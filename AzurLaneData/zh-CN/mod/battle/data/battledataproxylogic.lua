slot1 = ys.Battle.BattleEvent
slot2 = ys.Battle.BattleFormulas
slot3 = ys.Battle.BattleConst
slot4 = ys.Battle.BattleConfig
slot5 = ys.Battle.BattleDataFunction
slot6 = ys.Battle.BattleAttr
slot7 = ys.Battle.BattleVariable

ys.Battle.BattleDataProxy.SetupCalculateDamage = function (slot0, slot1)
	slot0._calculateDamage = slot1 or slot0.CreateContextCalculateDamage()
end

ys.Battle.BattleDataProxy.SetupDamageKamikazeAir = function (slot0, slot1)
	slot0._calculateDamageKamikazeAir = slot1 or slot0.CalculateDamageFromAircraftToMainShip
end

ys.Battle.BattleDataProxy.SetupDamageKamikazeShip = function (slot0, slot1)
	slot0._calculateDamageKamikazeShip = slot1 or slot0.CalculateDamageFromShipToMainShip
end

ys.Battle.BattleDataProxy.SetupDamageCrush = function (slot0, slot1)
	slot0._calculateDamageCrush = slot1 or slot0.CalculateCrashDamage
end

ys.Battle.BattleDataProxy.ClearFormulas = function (slot0)
	slot0._calculateDamage = nil
	slot0._calculateDamageKamikazeAir = nil
	slot0._calculateDamageKamikazeShip = nil
	slot0._calculateDamageCrush = nil
end

ys.Battle.BattleDataProxy.HandleBulletHit = function (slot0, slot1, slot2)
	if not slot2 then
		return false
	elseif not slot1 then
		return false
	end

	if slot0.IsSpirit(slot2) then
		return false
	end

	if slot1:IsCollided(slot2:GetUniqueID()) == true then
		return
	end

	slot1:Hit(slot2:GetUniqueID(), slot2:GetUnitType())
	slot1:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_COLLIDE, {
		_bullet = slot1,
		equipIndex = slot1:GetWeapon():GetEquipmentIndex()
	})

	if slot2:GetUnitType() == slot1.UnitType.PLAYER_UNIT and slot2:GetIFF() == slot2.FRIENDLY_CODE then
		ys.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[slot1.ShakeType.HIT])
	end

	return true
end

ys.Battle.BattleDataProxy.HandleDamage = function (slot0, slot1, slot2, slot3, slot4)
	if slot2:GetIFF() == slot0.FOE_CODE and slot2:IsShowHPBar() then
		slot0:DispatchEvent(ys.Event.New(slot1.HIT_ENEMY, slot2))
	end

	slot7 = slot1:GetWeaponHostAttr()

	slot2:TriggerBuff(slot2.BuffEffectType.ON_BULLET_HIT_BEFORE, {
		weaponType = slot1:GetWeapon().GetTemplateData(slot6).attack_attribute,
		bulletType = slot1:GetType()
	})

	if slot3.IsInvincible(slot2) then
		return
	end

	slot18.damage, slot11, slot19.font = slot0._calculateDamage(slot1, slot2, slot3, slot4)

	slot1:AppendDamageUnit(slot2:GetUniqueID())

	slot18 = {
		target = slot2,
		damage = slot10,
		weaponType = slot8.type,
		equipIndex = slot6:GetEquipmentIndex()
	}

	slot1:GetWeapon().WeaponStatistics(slot20, slot10, slot14, slot13)
	slot2:UpdateHP(slot10 * -1, slot19)
	slot0:DamageStatistics(slot7.id, slot2:GetAttrByName("id"), slot10)

	if not slot11.isMiss and slot1:GetWeaponTempData().type ~= slot2.EquipmentType.ANTI_AIR then
		slot1:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_HIT, slot18)
	end

	slot22 = true

	if slot2:GetUnitType() ~= slot2.UnitType.AIRCRAFT_UNIT and slot21 ~= slot2.UnitType.AIRFIGHTER_UNIT and slot21 ~= slot2.UnitType.FUNNEL_UNIT and slot21 ~= slot2.UnitType.UAV_UNIT then
		slot22 = false
	end

	if slot2:IsAlive() then
		if not slot22 then
			for slot26, slot27 in ipairs(slot1:GetAttachBuff()) do
				if slot27.hit_ignore or not slot13 then
					slot4.HandleBuffPlacer(slot27, slot1, slot2)
				end
			end
		end

		if not slot13 then
			slot2:TriggerBuff(slot2.BuffEffectType.ON_BE_HIT, slot9)
		end
	else
		slot1:BuffTrigger(ys.Battle.BattleConst.BuffEffectType.ON_BULLET_KILL, slot18)
		slot0:obituary(slot2, slot22, slot1)
		slot0:KillCountStatistics(slot7.id, slot2:GetAttrByName("id"))
	end

	return slot13, slot14
end

ys.Battle.BattleDataProxy.HandleMeteoDamage = function (slot0, slot1, slot2)
	slot3 = slot0.GetMeteoDamageRatio(#slot2)

	for slot7, slot8 in ipairs(slot2) do
		slot0:HandleDamage(slot1, slot8, nil, slot3[slot7])
	end
end

ys.Battle.BattleDataProxy.HandleDirectDamage = function (slot0, slot1, slot2, slot3, slot4)
	slot6 = slot1:GetAttrByName("id")

	slot1:UpdateHP(slot2 * -1, {
		isMiss = false,
		isCri = false,
		isHeal = false,
		damageReason = slot4
	})

	slot7 = slot1:IsAlive()

	if slot3 then
		slot0:DamageStatistics(slot3:GetAttrByName("id"), slot6, slot2)

		if not slot7 then
			slot0:KillCountStatistics(slot8, slot6)
		end
	end

	if not slot7 then
		slot9 = true

		if slot1:GetUnitType() ~= slot0.UnitType.AIRCRAFT_UNIT and slot8 ~= slot0.UnitType.AIRFIGHTER_UNIT and slot8 ~= slot0.UnitType.FUNNEL_UNIT and slot8 ~= slot0.UnitType.UAV_UNIT then
			slot9 = false
		end

		slot0:obituary(slot1, slot9, slot3)
	end
end

ys.Battle.BattleDataProxy.obituary = function (slot0, slot1, slot2, slot3)
	for slot7, slot8 in pairs(slot0._unitList) do
		if slot8 ~= slot1 then
			if slot8:GetIFF() == slot1:GetIFF() then
				if slot2 then
					slot8:TriggerBuff(slot0.BuffEffectType.ON_FRIENDLY_AIRCRAFT_DYING, {
						unit = slot1,
						killer = slot3
					})
				elseif not slot1:GetWorldDeathMark() then
					slot8:TriggerBuff(slot0.BuffEffectType.ON_FRIENDLY_SHIP_DYING, {
						unit = slot1,
						killer = slot3
					})
				end
			elseif slot2 then
				slot8:TriggerBuff(slot0.BuffEffectType.ON_FOE_AIRCRAFT_DYING, {
					unit = slot1,
					killer = slot3
				})
			else
				slot8:TriggerBuff(slot0.BuffEffectType.ON_FOE_DYING, {
					unit = slot1,
					killer = slot3
				})
			end
		end
	end
end

ys.Battle.BattleDataProxy.HandleAircraftMissDamage = function (slot0, slot1, slot2)
	if slot2 == nil then
		return
	end

	for slot7, slot8 in ipairs(slot3) do
		slot8:CloakExpose(slot0._airExpose)
	end

	if slot2:NearestUnitByType(slot1:GetPosition(), ShipType.CloakShipTypeList) then
		slot5:CloakExpose(slot0._airExposeEX)
	end

	if slot2:RandomMainVictim({
		"immuneDirectHit"
	}) then
		slot6:TriggerBuff(slot0.BuffEffectType.ON_BE_HIT, {})
		slot0:HandleDirectDamage(slot6, slot0._calculateDamageKamikazeAir(slot1, slot6), slot1)
	end
end

ys.Battle.BattleDataProxy.HandleShipMissDamage = function (slot0, slot1, slot2)
	if slot2 == nil then
		return
	end

	for slot7, slot8 in ipairs(slot3) do
		slot8:CloakExpose(slot0._shipExpose)
	end

	if slot2:NearestUnitByType(slot1:GetPosition(), ShipType.CloakShipTypeList) then
		slot5:CloakExpose(slot0._shipExposeEX)
	end

	if slot2:RandomMainVictim({
		"immuneDirectHit"
	}) then
		if table.contains(TeamType.SubShipType, slot1:GetTemplate().type) then
			slot6:TriggerBuff(slot1.BuffEffectType.ON_BE_HIT, {})
			slot0:HandleDirectDamage(slot6, slot0.CalculateDamageFromSubmarinToMainShip(slot1, slot6), slot1)

			if slot6:IsAlive() and slot0.RollSubmarineDualDice(slot1) then
				slot6:TriggerBuff(slot1.BuffEffectType.ON_BE_HIT, {})
				slot0:HandleDirectDamage(slot6, slot0.CalculateDamageFromSubmarinToMainShip(slot1, slot6), slot1)
			end
		else
			slot6:TriggerBuff(slot1.BuffEffectType.ON_BE_HIT, {})
			slot0:HandleDirectDamage(slot6, slot0._calculateDamageKamikazeShip(slot1, slot6), slot1)
		end
	end
end

ys.Battle.BattleDataProxy.HandleCrashDamage = function (slot0, slot1, slot2)
	slot8, slot8 = slot0._calculateDamageCrush(slot1, slot2)

	slot0:HandleDirectDamage(slot1, slot3, slot2, slot0.UnitDeathReason.CRUSH)
	slot0:HandleDirectDamage(slot2, slot4, slot1, slot0.UnitDeathReason.CRUSH)
end

ys.Battle.BattleDataProxy.HandleBuffPlacer = function (slot0, slot1, slot2)
	slot5 = false

	if slot0.GetBuffTemplate(slot0.buff_id).effect_list[1].type == "BattleBuffDOT" then
		if slot1.CaclulateDOTPlace(slot0.rant, slot4[1], slot1, slot2) then
			slot5 = true
		end
	elseif slot1.IsHappen(slot0.rant or 10000) then
		slot5 = true
	end

	if slot5 then
		slot6 = ys.Battle.BattleBuffUnit.New(slot0.buff_id, nil, slot1)

		slot6:SetOrb(slot1, slot0.level)
		slot2:AddBuff(slot6)
	end
end

ys.Battle.BattleDataProxy.HandleDOTPlace = function (slot0, slot1, slot2)
	slot5 = slot1:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].hit)

	if slot1.IsHappen((slot0.arg_list.ACC + slot1:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].hit)) - slot2:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].resist)) then
		return true
	end

	return false
end

ys.Battle.BattleDataProxy.HandleShipCrashDamageList = function (slot0, slot1, slot2)
	for slot7, slot8 in pairs(slot3) do
		if not table.contains(slot2, slot7) then
			slot1:RemoveHostileCld(slot7)
		end
	end

	for slot7, slot8 in ipairs(slot2) do
		if slot3[slot8] == nil then
			slot9 = nil

			slot1:AppendHostileCld(slot8, pg.TimeMgr.GetInstance().AddBattleTimer(slot10, "shipCld", nil, slot0.SHIP_CLD_INTERVAL, function ()
				slot0:HandleCrashDamage(slot0._unitList[slot1], )
			end, true))
			slot9()

			if not slot1:IsAlive() then
				return
			end
		end
	end
end

ys.Battle.BattleDataProxy.HandleShipCrashDecelerate = function (slot0, slot1, slot2)
	if slot2 == 0 and slot1:IsCrash() then
		slot1:SetCrash(false)
	elseif slot2 > 0 and not slot1:IsCrash() then
		slot1:SetCrash(true)
	end
end

ys.Battle.BattleDataProxy.HandleWallHitByBullet = function (slot0, slot1, slot2)
	return slot1:GetCldFunc()(slot2)
end

ys.Battle.BattleDataProxy.HandleWallHitByShip = function (slot0, slot1, slot2)
	slot1:GetCldFunc()(slot2)
end

ys.Battle.BattleDataProxy.HandleWallDamage = function (slot0, slot1, slot2)
	if slot2:GetIFF() == slot0.FOE_CODE and slot2:IsShowHPBar() then
		slot0:DispatchEvent(ys.Event.New(slot1.HIT_ENEMY, slot2))
	end

	slot4 = slot2.GetCurrent(slot1, "id")

	if slot2:IsInvincible() then
		return
	end

	slot5, slot6, slot11.font = slot0._calculateDamage(slot1, slot2)

	slot2:UpdateHP(slot5 * -1, slot11)
	slot0:DamageStatistics(slot4, slot2:GetAttrByName("id"), slot5)

	if slot2:IsAlive() then
		if not slot8 then
			slot2:TriggerBuff(slot3.BuffEffectType.ON_BE_HIT)
		end
	else
		slot0:obituary(slot2, false, slot1)
		slot0:KillCountStatistics(slot4, slot2:GetAttrByName("id"))
	end

	return slot8, slot9
end

return

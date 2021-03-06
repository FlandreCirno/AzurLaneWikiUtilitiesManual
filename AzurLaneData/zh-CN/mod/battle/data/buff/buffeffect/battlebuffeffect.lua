ys = ys or {}
ys.Battle.BattleBuffEffect = class("BattleBuffEffect")
ys.Battle.BattleBuffEffect.__name = "BattleBuffEffect"
slot1 = ys.Battle.BattleUnitEvent
ys.Battle.BattleBuffEffect.FX_TYPE_NOR = 0
ys.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR = 1
ys.Battle.BattleBuffEffect.FX_TYPE_CASTER = 2
ys.Battle.BattleBuffEffect.FX_TYPE_LINK = 3
ys.Battle.BattleBuffEffect.FX_TYPE_MOD_VELOCTIY = 4
ys.Battle.BattleBuffEffect.FX_TYPE_DOT = 5

ys.Battle.BattleBuffEffect.Ctor = function (slot0, slot1)
	slot0._tempData = Clone(slot1)
	slot0._type = slot0._tempData.type
	slot0._quota = slot0._tempData.arg_list.quota or -1
	slot0._indexRequire = slot2.index
	slot0._damageAttrRequire = slot2.damageAttr
	slot0._countType = slot2.countType
	slot0._behit = slot2.be_hit_condition
	slot0._ammoTypeRequire = slot2.ammoType
	slot0._ammoIndexRequire = slot2.ammoIndex
	slot0._buffStateIDRequire = slot2.buff_state_id

	slot0:ConfigHPTrigger()
	slot0:ConfigAttrTrigger()
	slot0:SetActive()
end

ys.Battle.BattleBuffEffect.GetEffectType = function (slot0)
	return slot0.FX_TYPE_NOR
end

ys.Battle.BattleBuffEffect.HaveQuota = function (slot0)
	if slot0._quota == 0 then
		return false
	else
		return true
	end
end

ys.Battle.BattleBuffEffect.GetEffectAttachData = function (slot0)
	return nil
end

ys.Battle.BattleBuffEffect.ConfigHPTrigger = function (slot0)
	slot0._hpUpperBound = slot0._tempData.arg_list.hpUpperBound
	slot0._hpLowerBound = slot0._tempData.arg_list.hpLowerBound

	if slot0._hpUpperBound and slot0._hpLowerBound == nil then
		slot0._hpLowerBound = 0
	end

	if slot0._hpLowerBound and slot0._hpUpperBound == nil then
		slot0._hpUpperBound = 1
	end

	slot0._hpSigned = slot1.hpSigned or -1
	slot0._hpOutInterval = slot1.hpOutInterval
end

ys.Battle.BattleBuffEffect.ConfigAttrTrigger = function (slot0)
	slot0._attrLowerBound = slot0._tempData.arg_list.attrLowerBound
	slot0._attrUpperBound = slot0._tempData.arg_list.attrUpperBound
	slot0._attrInterval = slot0._tempData.arg_list.attrInterval
end

ys.Battle.BattleBuffEffect.SetCaster = function (slot0, slot1)
	slot0._caster = slot1
end

ys.Battle.BattleBuffEffect.SetCommander = function (slot0, slot1)
	slot0._commander = slot1
end

ys.Battle.BattleBuffEffect.SetBullet = function (slot0, slot1)
	return
end

ys.Battle.BattleBuffEffect.SetArgs = function (slot0, slot1, slot2)
	return
end

ys.Battle.BattleBuffEffect.SetOrb = function (slot0)
	return
end

ys.Battle.BattleBuffEffect.Trigger = function (slot0, slot1, slot2, slot3, slot4)
	slot0[slot1](slot0, slot2, slot3, slot4)
end

ys.Battle.BattleBuffEffect.onAttach = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onRemove = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBuffAdded = function (slot0, slot1, slot2, slot3)
	if not slot0:buffStateRequire(slot3.buffID) then
		return
	end

	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBuffRemoved = function (slot0, slot1, slot2, slot3)
	if not slot0:buffStateRequire(slot3.buffID) then
		return
	end

	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onUpdate = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onStack = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBulletHit = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBeHit = function (slot0, slot1, slot2, slot3)
	if slot0._behit then
		if slot0._behit.damage_type == slot3.weaponType and slot0._behit.bullet_type == slot3.bulletType then
			slot0:onTrigger(slot1, slot2)
		end
	else
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.onFire = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onCombo = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot4 = slot3.matchUnitCount
	slot6 = slot0._tempData.arg_list.lowerBound

	if slot0._tempData.arg_list.upperBound and slot4 <= slot5 then
		slot0:onTrigger(slot1, slot2)
	elseif slot6 and slot6 <= slot4 then
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.equipIndexRequire = function (slot0, slot1)
	if not slot0._indexRequire then
		return true
	else
		for slot5, slot6 in ipairs(slot0._indexRequire) do
			if slot6 == slot1 then
				return true
			end
		end

		return false
	end
end

ys.Battle.BattleBuffEffect.ammoRequire = function (slot0, slot1)
	if not slot0._ammoTypeRequire then
		return true
	elseif not slot1:GetWeaponByIndex(slot0._ammoIndexRequire) or slot2:GetPrimalAmmoType() ~= slot0._ammoTypeRequire then
		return false
	else
		return true
	end
end

ys.Battle.BattleBuffEffect.buffStateRequire = function (slot0, slot1)
	if not slot0._buffStateIDRequire then
		return true
	else
		return slot1 == slot0._buffStateIDRequire
	end
end

ys.Battle.BattleBuffEffect.onWeaponSteday = function (slot0, slot1, slot2, slot3)
	slot0:onFire(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onChargeWeaponFire = function (slot0, slot1, slot2, slot3)
	slot0:onFire(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onTorpedoWeaponFire = function (slot0, slot1, slot2, slot3)
	slot0:onFire(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onAntiAirWeaponFire = function (slot0, slot1, slot2, slot3)
	slot0:onFire(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onAllInStrike = function (slot0, slot1, slot2, slot3)
	slot0:onFire(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onAllInStrikeSteady = function (slot0, slot1, slot2, slot3)
	slot0:onFire(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onChargeWeaponReady = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onManualTorpedoReady = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onAirAssistReady = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBeforeFatalDamage = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onFriendlyAircraftDying = function (slot0, slot1, slot2, slot3)
	if slot0._tempData.arg_list.templateID then
		if slot3.unit.GetTemplateID(slot4) == slot0._tempData.arg_list.templateID then
			slot0:onTrigger(slot1, slot2)
		end
	else
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.onFriendlyShipDying = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onFoeAircraftDying = function (slot0, slot1, slot2, slot3)
	if slot0._tempData.arg_list.inside then
		if not slot1:GetFleetVO():GetFleetAntiAirWeapon():IsOutOfRange(slot3.unit) then
			slot0:onTrigger(slot1, slot2)
		end
	elseif slot0._tempData.arg_list.killer then
		if slot0:killerRequire(slot0._tempData.arg_list.killer, slot3.killer, slot1) then
			slot0:onTrigger(slot1, slot2)
		end
	else
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.onFoeDying = function (slot0, slot1, slot2, slot3)
	if slot0._tempData.arg_list.killer then
		if slot0:killerRequire(slot0._tempData.arg_list.killer, slot3.killer, slot1) then
			slot0:onTrigger(slot1, slot2)
		end
	else
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.onSink = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.killerRequire = function (slot0, slot1, slot2, slot3)
	slot4, slot5 = nil
	slot4 = ((slot2.__name == slot0.Battle.BattlePlayerUnit.__name or slot6 == slot0.Battle.BattleNPCUnit.__name or slot6 == slot0.Battle.BattleEnemyUnit.__name or slot6 == slot0.Battle.BattleAircraftUnit.__name or slot6 == slot0.Battle.BattleAirFighterUnit.__name) and slot2) or slot2:GetHost()

	if slot4 then
		if slot4.__name == slot0.Battle.BattleAircraftUnit.__name then
			slot5 = slot4:GetMotherUnit()
		else
			slot5 = slot4
			slot4 = nil
		end
	else
		return false
	end

	if slot1 == "self" then
		if slot5 == slot3 and not slot4 then
			return true
		end
	elseif slot1 == "child" and slot5 == slot3 and slot4 then
		return true
	end

	return false
end

ys.Battle.BattleBuffEffect.onInitGame = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onStartGame = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onManual = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onAutoBot = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onFlagShip = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onUpperConsort = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onLowerConsort = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onLeader = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onCenter = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onRear = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onSubLeader = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onUpperSubConsort = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onLowerSubConsort = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBulletCollide = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBombBulletBang = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBulletHitBefore = function (slot0, slot1, slot2, slot3)
	if slot0._behit then
		if slot0._behit.damage_type == slot3.weaponType and slot0._behit.bullet_type == slot3.bulletType then
			slot0:onTrigger(slot1, slot2)
		end
	else
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.onBulletCreate = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onChargeWeaponBulletCreate = function (slot0, slot1, slot2, slot3)
	slot0:onBulletCreate(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onTorpedoWeaponBulletCreate = function (slot0, slot1, slot2, slot3)
	slot0:onBulletCreate(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onAntiAirWeaponBulletCreate = function (slot0, slot1, slot2, slot3)
	slot0:onBulletCreate(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onInternalBulletCreate = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onManualBulletCreate = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onTakeDamage = function (slot0, slot1, slot2, slot3)
	if slot0:damageAttrRequire(slot3.damageAttr) then
		slot0:onTrigger(slot1, slot2, slot3)
	end
end

ys.Battle.BattleBuffEffect.onTakeHealing = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.damageAttrRequire = function (slot0, slot1)
	if not slot0._damageAttrRequire or table.contains(slot0._damageAttrRequire, slot1) then
		return true
	else
		return false
	end
end

ys.Battle.BattleBuffEffect.hpIntervalRequire = function (slot0, slot1, slot2)
	if slot0._hpUpperBound == nil and slot0._hpLowerBound == nil then
		return true
	end

	if slot2 then
		if slot0._hpSigned == 0 then
		elseif slot2 * slot0._hpSigned < 0 then
			return false
		end
	end

	slot3 = nil

	if slot0._hpOutInterval then
		if slot0._hpUpperBound <= slot1 or slot1 <= slot0._hpLowerBound then
			slot3 = true
		end
	elseif slot1 <= slot0._hpUpperBound and slot0._hpLowerBound <= slot1 then
		slot3 = true
	end

	return slot3
end

ys.Battle.BattleBuffEffect.attrIntervalRequire = function (slot0, slot1)
	slot2 = true

	if slot0._attrUpperBound and slot0._attrUpperBound <= slot1 then
		slot2 = false
	end

	if slot0._attrLowerBound and slot1 <= slot0._attrLowerBound then
		slot2 = false
	end

	return slot2
end

ys.Battle.BattleBuffEffect.onHPRatioUpdate = function (slot0, slot1, slot2, slot3)
	if slot0:hpIntervalRequire(slot1:GetHPRate(), slot3.dHP) then
		slot0:doOnHPRatioUpdate(slot1, slot2, slot3)
	end
end

ys.Battle.BattleBuffEffect.onFriendlyHpRatioUpdate = function (slot0, slot1, slot2, slot3)
	if slot0:hpIntervalRequire(slot3.unit.GetHPRate(slot4), slot3.dHP) then
		slot0:doOnHPRatioUpdate(slot1, slot2, slot3)
	end
end

ys.Battle.BattleBuffEffect.onTeammateHpRatioUpdate = function (slot0, slot1, slot2, slot3)
	slot0:onFriendlyHpRatioUpdate(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onBulletKill = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffEffect.onBattleBuffCount = function (slot0, slot1, slot2, slot3)
	if slot3.buffFX.GetCountType(slot4) == slot0._countType and slot0:onTrigger(slot1, slot2) ~= "overheat" then
		slot4:ResetCount()
	end
end

ys.Battle.BattleBuffEffect.onShieldBroken = function (slot0, slot1, slot2, slot3)
	if slot3.shieldBuffID == slot0._tempData.arg_list.shieldBuffID then
		slot0:onTrigger(slot1, slot2)
	end
end

ys.Battle.BattleBuffEffect.onTrigger = function (slot0, slot1, slot2, slot3)
	if slot0._quota > 0 then
		slot0._quota = slot0._quota - 1
	end
end

ys.Battle.BattleBuffEffect.doOnHPRatioUpdate = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.doOnFriendlyHPRatioUpdate = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarineDive = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarineRaid = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarineFloat = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarineRetreat = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarineAid = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarinFreeDive = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarinFreeFloat = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubmarineFreeSpecial = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubDetected = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onSubUnDetected = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.onAntiSubHateChain = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, attach)
end

ys.Battle.BattleBuffEffect.onRetreat = function (slot0, slot1, slot2, slot3)
	slot0:onTrigger(slot1, slot2, slot3)
end

ys.Battle.BattleBuffEffect.Interrupt = function (slot0)
	return
end

ys.Battle.BattleBuffEffect.Clear = function (slot0)
	slot0._commander = nil
end

ys.Battle.BattleBuffEffect.getTargetList = function (slot0, slot1, slot2, slot3, slot4)
	if type(slot2) == "string" then
		slot2 = {
			slot2
		}
	end

	slot5 = slot3

	if table.contains(slot2, "TargetDamageSource") then
		Clone(slot3).damageSourceID = slot4.damageSrc
	end

	slot6 = nil

	for slot10, slot11 in ipairs(slot2) do
		slot6 = slot0.Battle.BattleTargetChoise[slot11](slot1, slot5, slot6)
	end

	return slot6
end

ys.Battle.BattleBuffEffect.commanderRequire = function (slot0, slot1)
	if slot0._tempData.arg_list.CMDBuff_id then
		slot2, slot3 = slot0.Battle.BattleDataProxy.GetInstance():GetCommanderBuff()
		slot4 = nil
		slot4 = (table.contains(TeamType.SubShipType, slot1:GetTemplate().type) and slot3) or slot2
		slot6 = {}
		slot7 = slot0._tempData.arg_list.CMDBuff_id

		for slot11, slot12 in ipairs(slot4) do
			if slot12.id == slot7 then
				table.insert(slot6, slot12)
			end
		end

		return #slot6 > 0
	else
		return true
	end
end

ys.Battle.BattleBuffEffect.IsActive = function (slot0)
	return slot0._isActive
end

ys.Battle.BattleBuffEffect.SetActive = function (slot0)
	slot0._isActive = true
end

ys.Battle.BattleBuffEffect.NotActive = function (slot0)
	slot0._isActive = false
end

ys.Battle.BattleBuffEffect.IsLock = function (slot0)
	return slot0._isLock
end

ys.Battle.BattleBuffEffect.SetLock = function (slot0)
	slot0._isLock = true
end

ys.Battle.BattleBuffEffect.NotLock = function (slot0)
	slot0._isLock = false
end

ys.Battle.BattleBuffEffect.Dispose = function (slot0)
	return
end

return

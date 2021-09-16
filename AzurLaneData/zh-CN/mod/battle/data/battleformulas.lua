ys.Battle.BattleFormulas = ys.Battle.BattleFormulas or {}
slot1 = ys.Battle.BattleConst
slot2 = pg.gameset
slot3 = ys.Battle.BattleAttr
slot5 = ys.Battle.BattleConfig.AnitAirRepeaterConfig
slot7 = pg.bfConsts.SECONDs / ys.Battle.BattleConfig.viewFPS * ys.Battle.BattleConfig.BulletSpeedConvertConst
slot8 = pg.bfConsts.SECONDs / ys.Battle.BattleConfig.calcFPS * ys.Battle.BattleConfig.ShipSpeedConvertConst
slot9 = pg.bfConsts.SECONDs / ys.Battle.BattleConfig.viewFPS * ys.Battle.BattleConfig.AircraftSpeedConvertConst
slot10 = ys.Battle.BattleConfig.AIR_ASSIST_RELOAD_RATIO * pg.bfConsts.PERCENT
slot11 = ys.Battle.BattleConfig.DAMAGE_ENHANCE_FROM_SHIP_TYPE
slot12 = ys.Battle.BattleConfig.AMMO_DAMAGE_ENHANCE
slot13 = ys.Battle.BattleConfig.AMMO_DAMAGE_REDUCE
slot14 = ys.Battle.BattleConfig.SHIP_TYPE_ACCURACY_ENHANCE

ys.Battle.BattleFormulas.GetFleetTotalHP = function (slot0)
	slot1 = slot0:GetFlagShip()
	slot3 = slot0.NUM0

	for slot7, slot8 in ipairs(slot2) do
		slot3 = (slot8 == slot1 and slot3 + slot1.GetCurrent(slot8, "maxHP") * slot0.HP_CONST) or slot3 + slot1.GetCurrent(slot8, "maxHP")
	end

	return slot3
end

ys.Battle.BattleFormulas.GetFleetVelocity = function (slot0)
	if slot0[1] and slot1.NUM0 < slot0.GetCurrent(slot1, "fleetVelocity") then
		return slot2 * slot1.PERCENT
	end

	slot2 = slot1.NUM0
	slot3 = #slot0

	for slot7, slot8 in ipairs(slot0) do
		slot2 = slot2 + slot8:GetAttrByName("velocity")
	end

	return slot2 / slot3 * (slot1.NUM1 - slot1.SPEED_CONST * (slot3 - slot1.NUM1))
end

ys.Battle.BattleFormulas.GetFleetReload = function (slot0)
	slot1 = slot0.NUM0

	for slot5, slot6 in ipairs(slot0) do
		slot1 = slot1 + slot6:GetReload()
	end

	return slot1
end

ys.Battle.BattleFormulas.GetFleetTorpedoPower = function (slot0)
	slot1 = slot0.NUM0

	for slot5, slot6 in ipairs(slot0) do
		slot1 = slot1 + slot6:GetTorpedoPower()
	end

	return slot1
end

ys.Battle.BattleFormulas.AttrFixer = function (slot0, slot1)
	if slot0 == SYSTEM_DUEL then
		slot4, slot5 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(slot0, slot2)
		slot1.durability = slot1.durability * slot4 + slot5
	end
end

ys.Battle.BattleFormulas.HealFixer = function (slot0, slot1)
	slot2 = 1

	if slot0 == SYSTEM_DUEL then
		slot2 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(slot0, slot1.level)
	end

	return slot2
end

ys.Battle.BattleFormulas.ConvertShipSpeed = function (slot0)
	return slot0 * slot0
end

ys.Battle.BattleFormulas.ConvertAircraftSpeed = function (slot0)
	if slot0 then
		return slot0 * slot0
	else
		return nil
	end
end

ys.Battle.BattleFormulas.ConvertBulletSpeed = function (slot0)
	return slot0 * slot0
end

ys.Battle.BattleFormulas.ConvertBulletDataSpeed = function (slot0)
	return slot0 / slot0
end

ys.Battle.BattleFormulas.CreateContextCalculateDamage = function (slot0)
	return function (slot0, slot1, slot2, slot3)
		slot6 = slot0.NUM10000
		slot7 = slot0.DRATE
		slot8 = slot0.ACCURACY
		slot12 = slot0:GetWeaponTempData().type
		slot13 = slot0.GetWeaponTempData().attack_attribute
		slot16 = slot0:GetTemplate().damage_type
		slot17 = slot0.GetTemplate().random_damage_rate
		slot19 = slot3 or slot0.NUM1
		slot2 = slot2 or slot0.NUM0
		slot20 = slot1._attr.armorType
		slot21 = slot0:GetWeaponHostAttr().formulaLevel - slot1._attr.formulaLevel
		slot22 = slot0.NUM1
		slot23 = false
		slot24 = false
		slot25 = slot0.NUM1
		slot26 = (slot0.NUM1 + slot0:GetWeaponAtkAttr() * slot0:GetWeapon().GetConvertedAtkAttr(slot10)) * slot0:GetCorrectedDMG()

		if slot13 == slot1.WeaponDamageAttr.CANNON then
			slot19 = slot4 + slot2.GetCurrent(slot1, "injureRatioByCannon") + slot2.GetCurrent(slot0, "damageRatioByCannon")
		elseif slot13 == slot1.WeaponDamageAttr.TORPEDO then
			slot19 = slot4 + slot2.GetCurrent(slot1, "injureRatioByBulletTorpedo") + slot2.GetCurrent(slot0, "damageRatioByBulletTorpedo")
		elseif slot13 == slot1.WeaponDamageAttr.AIR then
			slot19 = slot19 * math.min(slot7[7] / (slot18.antiAirPower + slot7[7]) + ((slot2.GetCurrent(slot0, "airResistPierceActive") == 1 and slot2.GetCurrent(slot0, "airResistPierce")) or 0), 1) * (slot4 + slot2.GetCurrent(slot1, "injureRatioByAir") + slot2.GetCurrent(slot0, "damageRatioByAir"))
		elseif slot13 == slot1.WeaponDamageAttr.ANTI_AIR then
		elseif slot13 == slot1.WeaponDamageAttr.ANIT_SUB then
		end

		slot23 = (slot2.GetCurrent(slot1, "perfectDodge") == 1 and true) or not slot4.IsHappen(math.max(slot7[5], math.min(slot4, (slot8[1] + slot9.attackRating / (slot9.attackRating + slot18.dodgeRate + slot8[2]) + (slot9.luck - slot18.luck + slot21) * slot0.PERCENT1 + slot2.GetCurrent(slot1, "accuracyRateExtra") + slot2.GetCurrent(slot0, slot3[slot1:GetTemplate().type])) - slot2.GetCurrent(slot1, "dodgeRateExtra"))) * slot6)

		if not slot23 then
			slot30 = nil
			slot25 = math.random(slot5.RANDOM_DAMAGE_MIN, slot5.RANDOM_DAMAGE_MAX) + slot26

			if slot4.IsHappen(((slot2.GetCurrent(slot0, "GCT") == 1 and 1) or slot0.DFT_CRIT_RATE + slot9.attackRating / (slot9.attackRating + slot18.dodgeRate + slot7[4]) + (slot28 + slot21) * slot7[3] + slot2.GetCurrent(slot0, "cri")) * slot6) then
				slot24 = true
				slot22 = math.max(1, (slot0.DFT_CRIT_EFFECT + slot2.GetCurrent(slot0, "criDamage")) - slot2.GetCurrent(slot1, "criDamageResist"))
			else
				slot24 = false
			end
		else
			return slot5, {
				isMiss = true,
				isDamagePrevent = false,
				isCri = slot24
			}
		end

		slot25 = math.max(slot0.NUM1, math.floor(slot25 * slot19 * (slot0.NUM1 - slot2) * ((slot10:GetFixAmmo() or slot16[slot20] or slot0.NUM1) + slot2.GetCurrent(slot0, slot5.AGAINST_ARMOR_ENHANCE[slot20])) * slot22 * (slot0.NUM1 + slot2.GetCurrent(slot0, "damageRatioBullet")) * slot2.GetTagAttr(slot0, slot1) * (slot0.NUM1 + slot2.GetCurrent(slot1, "injureRatio")) * ((slot0.NUM1 + slot2.GetCurrent(slot0, slot6[slot15.ammo_type])) - slot2.GetCurrent(slot1, slot7[slot15.ammo_type])) * (slot0.NUM1 + slot2.GetCurrent(slot1, slot37)) * (slot0.NUM1 + math.min(slot7[1], math.max(-slot7[1], slot21)) * slot7[2])))

		if slot1:GetCurrentOxyState() == slot1.OXY_STATE.DIVE then
			slot25 = math.floor(slot25 * slot15.antisub_enhancement)
		end

		slot39 = {
			isMiss = slot23,
			isCri = slot24,
			damageAttr = slot13
		}

		if slot0:GetDamageEnhance() ~= 1 then
			slot25 = math.floor(slot25 * slot40)
		end

		slot25 = slot25 * slot18.repressReduce

		if slot17 ~= 0 then
			slot25 = slot25 * (Mathf.RandomFloat(slot17) + 1)
		end

		slot25 = math.max(0, slot25 + slot2.GetCurrent(slot0, "damageEnhanceProjectile"))

		if slot8 then
			slot25 = slot25 * (slot0.NUM1 + slot2.GetCurrent(slot0, "worldBuffResistance"))
		end

		slot25 = math.floor(slot25)
		slot42 = slot15.DMG_font[slot20]

		if slot41 < 0 then
			slot42 = slot5.BULLET_DECREASE_DMG_FONT
		end

		return slot25, slot39, slot42
	end
end

ys.Battle.BattleFormulas.CalculateIgniteDamage = function (slot0, slot1, slot2)
	return slot0:GetWeapon().GetCorrectedDMG(slot4) * (1 + slot0._attr[slot1] * slot0.PERCENT) * slot2
end

ys.Battle.BattleFormulas.WeaponDamagePreCorrection = function (slot0, slot1)
	return (slot1 or slot0:GetTemplateData().damage) * slot0:GetPotential() * slot0.GetTemplateData().corrected * slot0.PERCENT
end

ys.Battle.BattleFormulas.WeaponAtkAttrPreRatio = function (slot0)
	return slot0:GetTemplateData().attack_attribute_ratio * slot0.PERCENT2
end

ys.Battle.BattleFormulas.GetMeteoDamageRatio = function (slot0)
	slot1 = {}
	slot3 = slot0.METEO_RATE[1]

	if slot0.METEO_RATE[2] <= slot0 then
		for slot7 = 1, slot0 + 1, 1 do
			slot1[slot7] = slot3
		end

		return slot1
	else
		slot4 = 1 - slot3 * slot0

		for slot8 = 1, slot0, 1 do
			slot1[slot8] = math.random() * slot4 * (slot2[3] + (slot2[4] * (slot8 - 1)) / slot0) + slot3
			slot4 = math.max(0, slot4 - math.random() * slot4 * (slot2[3] + (slot2[4] * (slot8 - 1)) / slot0))
		end

		slot1[slot0 + 1] = slot4

		return slot1
	end
end

ys.Battle.BattleFormulas.CalculateFleetAntiAirTotalDamage = function (slot0)
	slot2 = 0

	for slot6, slot7 in pairs(slot1) do
		slot8 = slot0.GetCurrent(slot6, "antiAirPower")

		for slot12, slot13 in ipairs(slot7) do
			slot2 = slot2 + math.max(1, (slot8 * slot13:GetConvertedAtkAttr() + 1) * slot13:GetCorrectedDMG())
		end
	end

	return slot2
end

ys.Battle.BattleFormulas.CalculateRepaterAnitiAirTotalDamage = function (slot0)
	return math.max(1, (slot0.GetCurrent(slot1, "antiAirPower") * slot0:GetConvertedAtkAttr() + 1) * slot0:GetCorrectedDMG())
end

ys.Battle.BattleFormulas.RollRepeaterHitDice = function (slot0, slot1)
	slot2 = slot0:GetHost()
	slot4 = slot0.GetCurrent(slot2, "attackRating")

	return slot2.IsHappen(math.min(slot6, (slot0.GetCurrent(slot1, "airPower") / slot1.const_A + slot1.const_B) / (slot0.GetCurrent(slot2, "antiAirPower") * slot0.GetCurrent(slot1, "dodge") + slot0.GetCurrent(slot1, "airPower") / slot1.const_A + slot1.const_B + slot1.const_C)) * slot3.NUM10000)
end

ys.Battle.BattleFormulas.AntiAirPowerWeight = function (slot0)
	return slot0 * slot0
end

ys.Battle.BattleFormulas.CalculateDamageFromAircraftToMainShip = function (slot0, slot1)
	return math.floor(math.max(slot1.PLANE_LEAK_RATE[1], math.floor((slot0:GetCurrent("crashDMG") * (slot1.PLANE_LEAK_RATE[2] + slot0:GetCurrent("airPower") * slot1.PLANE_LEAK_RATE[3]) + slot0:GetCurrent("formulaLevel") * slot1.PLANE_LEAK_RATE[4]) * (slot0:GetHPRate() * slot1.PLANE_LEAK_RATE[5] + slot1.PLANE_LEAK_RATE[6]) * (slot1.PLANE_LEAK_RATE[7] + (slot0.GetCurrent("formulaLevel") - slot0.GetCurrent(slot1, "formulaLevel")) * slot1.PLANE_LEAK_RATE[8]) * slot1.PLANE_LEAK_RATE[9] / (slot0.GetCurrent(slot1, "antiAirPower") + slot1.PLANE_LEAK_RATE[10]) * (slot1.PLANE_LEAK_RATE[11] + slot0.GetCurrent(slot1, "injureRatio")) * (slot1.PLANE_LEAK_RATE[12] + slot0.GetCurrent(slot1, "injureRatioByAir")))) * slot0.GetCurrent(slot1, "repressReduce"))
end

ys.Battle.BattleFormulas.CalculateDamageFromShipToMainShip = function (slot0, slot1)
	return math.floor(math.max(slot1.LEAK_RATE[1], math.floor(((slot0:GetCurrent("cannonPower") + slot0:GetCurrent("torpedoPower")) * slot1.LEAK_RATE[2] + slot0:GetCurrent("formulaLevel") * slot1.LEAK_RATE[7]) * (slot1.LEAK_RATE[5] + slot0.GetCurrent(slot1, "injureRatio")) * (slot0:GetHPRate() * slot1.LEAK_RATE[3] + slot1.LEAK_RATE[4]) * (slot1.LEAK_RATE[5] + (slot0.GetCurrent("formulaLevel") - slot0.GetCurrent(slot1, "formulaLevel")) * slot1.LEAK_RATE[6]))) * slot0.GetCurrent(slot1, "repressReduce"))
end

ys.Battle.BattleFormulas.CalculateDamageFromSubmarinToMainShip = function (slot0, slot1)
	return math.max(slot1.SUBMARINE_KAMIKAZE[1], math.floor((slot0:GetCurrent("torpedoPower") * slot1.SUBMARINE_KAMIKAZE[2] + slot0:GetCurrent("formulaLevel") * slot1.SUBMARINE_KAMIKAZE[3]) * (slot1.SUBMARINE_KAMIKAZE[4] + slot0.GetCurrent(slot1, "injureRatio")) * (slot0:GetHPRate() * slot1.SUBMARINE_KAMIKAZE[5] + slot1.SUBMARINE_KAMIKAZE[6]) * (slot1.SUBMARINE_KAMIKAZE[7] + (slot0.GetCurrent("formulaLevel") - slot0.GetCurrent(slot1, "formulaLevel")) * slot1.SUBMARINE_KAMIKAZE[8])))
end

ys.Battle.BattleFormulas.RollSubmarineDualDice = function (slot0)
	slot1 = slot0:GetCurrent("dodgeRate")

	return slot2.IsHappen(slot1 / (slot1 + slot1.MONSTER_SUB_KAMIKAZE_DUAL_K) * slot1.MONSTER_SUB_KAMIKAZE_DUAL_P * slot3.NUM10000)
end

ys.Battle.BattleFormulas.CalculateCrashDamage = function (slot0, slot1)
	return math.floor(math.floor(math.min(slot4, slot10) * (1 + slot0.GetCurrent(slot1, "hammerDamageRatio")) * (1 - slot0:GetCurrent("hammerDamagePrevent"))) * slot0:GetCurrent("repressReduce")), math.floor(math.floor(math.min(slot5, slot10) * (1 + slot0:GetCurrent("hammerDamageRatio")) * (1 - slot0.GetCurrent(slot1, "hammerDamagePrevent"))) * slot0.GetCurrent(slot1, "repressReduce"))
end

ys.Battle.BattleFormulas.CalculateFleetDamage = function (slot0)
	return slot0 * slot0.SCORE_RATE[1]
end

ys.Battle.BattleFormulas.CalculateFleetOverDamage = function (slot0, slot1)
	if slot1 == slot0:GetFlagShip() then
		return slot0.GetCurrent(slot1, "maxHP") * slot1.SCORE_RATE[2]
	else
		return slot0.GetCurrent(slot1, "maxHP") * slot1.SCORE_RATE[3]
	end
end

ys.Battle.BattleFormulas.ReloadTime = function (slot0, slot1)
	return slot0:CalculateReloadTime(slot1.loadSpeed)
end

ys.Battle.BattleFormulas.CalculateReloadTime = function (slot0, slot1)
	return slot0 / slot0.K1 / math.sqrt((slot1 + slot0.K2) * slot0.K3)
end

ys.Battle.BattleFormulas.CaclulateReloaded = function (slot0, slot1)
	return math.sqrt((slot1 + slot0.K2) * slot0.K3) * slot0 * slot0.K1
end

ys.Battle.BattleFormulas.CaclulateReloadAttr = function (slot0, slot1)
	return math.max((slot0 / slot0.K1 / slot1 * ) / slot0.K3 - slot0.K2, 0)
end

ys.Battle.BattleFormulas.CaclulateAirAssistReloadMax = function (slot0)
	slot1 = 0

	for slot5, slot6 in ipairs(slot0) do
		slot1 = slot1 + slot6:GetTemplateData().reload_max
	end

	return slot1 / #slot0 * slot0
end

ys.Battle.BattleFormulas.CaclulateDOTPlace = function (slot0, slot1, slot2, slot3)
	return slot2.IsHappen(slot0 * (slot1.NUM1 + ((slot2 and slot2:GetAttrByName(slot0.DOT_CONFIG[slot1.arg_list.dotType].hit)) or slot1.NUM0)) * (slot1.NUM1 - ((slot3 and slot3:GetAttrByName(slot0.DOT_CONFIG[slot1.arg_list.dotType].resist)) or slot1.NUM0)))
end

ys.Battle.BattleFormulas.CaclulateDOTDuration = function (slot0, slot1, slot2)
	return ((slot1 and slot1:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].prolong)) or slot1.NUM0) - ((slot2 and slot2:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].shorten)) or slot1.NUM0)
end

ys.Battle.BattleFormulas.CaclulateDOTDamageEnhanceRate = function (slot0, slot1, slot2)
	return (((slot1 and slot1:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].enhance)) or slot1.NUM0) - ((slot2 and slot2:GetAttrByName(slot0.DOT_CONFIG[slot0.arg_list.dotType].reduce)) or slot1.NUM0)) * slot1.PERCENT2
end

ys.Battle.BattleFormulas.WorldEnemyAttrEnhance = function (slot0, slot1)
	return 1 + slot0 / (1 + slot0.WORLD_ENEMY_ENHANCEMENT_CONST_C^(slot0.WORLD_ENEMY_ENHANCEMENT_CONST_B - slot1))
end

slot15 = setmetatable({}, {
	__index = function (slot0, slot1)
		return 0
	end
})

ys.Battle.BattleFormulas.WorldMapRewardAttrEnhance = function (slot0, slot1)
	slot2, slot3, slot4 = nil
	slot7 = nil

	return 1 - math.clamp((slot0 or slot0[1] ~= 0 or ({
		{
			slot1 or slot0 or slot0.attr_world_value_X1.key_value / 10000,
			slot1 or slot0 or slot0.attr_world_value_X2.key_value / 10000
		},
		{
			slot1 or slot0 or slot0.attr_world_value_Y1.key_value / 10000,
			slot1 or slot0 or slot0.attr_world_value_Y2.key_value / 10000
		},
		{
			slot1 or slot0 or slot0.attr_world_value_Z1.key_value / 10000,
			slot1 or slot0 or slot0.attr_world_value_Z2.key_value / 10000
		}
	})[1][2]) and slot1 or slot0 or slot0[1] / slot0 or slot0[1], ()[1][1], ()[1][2]), 1 - math.clamp((slot0 or slot0[2] ~= 0 or ()[2][2]) and slot1 or slot0 or slot0[2] / slot0 or slot0[2], ()[2][1], ()[2][2]), math.max(1 - math.clamp((slot0 or slot0[3] ~= 0 or ()[3][2]) and slot1 or slot0 or slot0[3] / slot0 or slot0[3], ()[3][1], ()[3][2]), -(slot1 or slot0 or slot0.attr_world_damage_fix.key_value / 10000))
end

ys.Battle.BattleFormulas.WorldMapRewardHealingRate = function (slot0, slot1)
	slot3 = nil

	return math.clamp((slot0 or slot1[3] ~= 0 or ({
		slot0.attr_world_value_H1.key_value / 10000,
		slot0.attr_world_value_H2.key_value / 10000
	})[2]) and slot1 or slot1[3] / slot0 or slot1[3], ()[1], ()[2])
end

ys.Battle.BattleFormulas.CalcDamageLock = function ()
	return 0, {
		false,
		true,
		false
	}
end

ys.Battle.BattleFormulas.CalcDamageLockA2M = function ()
	return 0
end

ys.Battle.BattleFormulas.CalcDamageLockS2M = function ()
	return 0
end

ys.Battle.BattleFormulas.CalcDamageLockCrush = function ()
	return 0, 0
end

ys.Battle.BattleFormulas.UnilateralCrush = function ()
	return 0, 100000
end

ys.Battle.BattleFormulas.FriendInvincibleDamage = function (slot0, slot1, ...)
	if slot1:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		return 1, {
			isMiss = false,
			isCri = false,
			isDamagePrevent = false
		}
	elseif slot2 == ys.Battle.BattleConfig.FOE_CODE then
		return slot0:CalculateDamage(slot1, ...)
	end
end

ys.Battle.BattleFormulas.FriendInvincibleCrashDamage = function (slot0, slot1)
	slot2, slot3 = slot0:CalculateCrashDamage(slot1)
	slot4 = 1

	if slot1:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		slot3 = 1
	end

	return slot4, slot3
end

ys.Battle.BattleFormulas.ChapterRepressReduce = function (slot0)
	return 1 - slot0 * 0.01
end

ys.Battle.BattleFormulas.IsHappen = function (slot0)
	if slot0 <= 0 then
		return false
	elseif slot0 >= 10000 then
		return true
	else
		return math.random(10000) <= slot0
	end
end

ys.Battle.BattleFormulas.WeightRandom = function (slot0)
	slot4, slot5 = slot0:GenerateWeightList()

	return slot0.WeightListRandom(slot1, slot2)
end

ys.Battle.BattleFormulas.WeightListRandom = function (slot0, slot1)
	slot2 = math.random(0, slot1)

	for slot6, slot7 in pairs(slot0) do
		slot9 = slot6.max

		if slot6.min <= slot2 and slot2 <= slot9 then
			return slot7
		end
	end
end

ys.Battle.BattleFormulas.GenerateWeightList = function (slot0)
	slot1 = {}
	slot2 = -1

	for slot6, slot7 in ipairs(slot0) do
		slot11 = nil
		slot12 = {
			min = slot2 + 1,
			max = slot2 + slot7.weight,
			[slot12] = slot7.rst
		}
	end

	return slot1, slot2
end

ys.Battle.BattleFormulas.IsListHappen = function (slot0)
	for slot4, slot5 in ipairs(slot0) do
		if slot0.IsHappen(slot5[1]) then
			return true, slot5[2]
		end
	end

	return false, nil
end

ys.Battle.BattleFormulas.BulletYAngle = function (slot0, slot1)
	return math.rad2Deg * math.atan2(slot1.z - slot0.z, slot1.x - slot0.x)
end

ys.Battle.BattleFormulas.RandomPosNull = function (slot0, slot1)
	slot1 = slot1 or 10
	slot2 = slot0.distance or 10
	slot2 = slot2 * slot2
	slot3 = ys.Battle.BattleTargetChoise.TargetAll()
	slot4, slot5 = nil

	for slot9 = 1, slot1, 1 do
		slot5 = true
		slot4 = slot0:RandomPos()

		for slot13, slot14 in pairs(slot3) do
			if Vector3.SqrDistance(slot4, slot14:GetPosition()) < slot2 then
				slot5 = false

				break
			end
		end

		if slot5 then
			return slot4
		end
	end

	return nil
end

ys.Battle.BattleFormulas.RandomPos = function (slot0)
	slot1 = slot0[1] or 0
	slot2 = slot0[2] or 0
	slot3 = slot0[3] or 0

	if slot0.rangeX or slot0.rangeY or slot0.rangeZ then
		return Vector3(slot1 + slot0.RandomDelta(slot0.rangeX), slot2 + slot0.RandomDelta(slot0.rangeY), slot3 + slot0.RandomDelta(slot0.rangeZ))
	else
		return Vector3(slot1 + slot0:RandomPosXYZ("X1", "X2"), slot2 + slot0:RandomPosXYZ("Y1", "Y2"), slot3 + slot0:RandomPosXYZ("Z1", "Z2"))
	end
end

ys.Battle.BattleFormulas.RandomPosXYZ = function (slot0, slot1, slot2)
	slot2 = slot0[slot2]

	if slot0[slot1] and slot2 then
		return math.random(slot1, slot2)
	else
		return 0
	end
end

ys.Battle.BattleFormulas.RandomPosCenterRange = function (slot0)
	return Vector3(slot0.RandomDelta(slot0.rangeX), slot0.RandomDelta(slot0.rangeY), slot0.RandomDelta(slot0.rangeZ))
end

ys.Battle.BattleFormulas.RandomDelta = function (slot0)
	if slot0 and slot0 > 0 then
		return math.random(slot0 + slot0) - slot0
	else
		return 0
	end
end

return

ys = ys or {}
ys.Battle.BattleAttr = {
	AttrListInheritance = {
		"level",
		"srcShipType",
		"formulaLevel",
		"repressReduce",
		"cannonPower",
		"torpedoPower",
		"antiAirPower",
		"airPower",
		"antiSubPower",
		"fleetGS",
		"loadSpeed",
		"attackRating",
		"dodgeRate",
		"velocity",
		"luck",
		"cri",
		"criDamage",
		"criDamageResist",
		"hiveExtraHP",
		"bulletSpeedRatio",
		"torpedoSpeedExtra",
		"damageRatioBullet",
		"damageEnhanceProjectile",
		"healingEnhancement",
		"injureRatio",
		"injureRatioByCannon",
		"injureRatioByBulletTorpedo",
		"injureRatioByAir",
		"damageRatioByCannon",
		"damageRatioByBulletTorpedo",
		"damageRatioByAir",
		"damagePreventRantTorpedo",
		"accuracyRateExtra",
		"dodgeRateExtra",
		"perfectDodge",
		"immuneDirectHit",
		"chargeBulletAccuracy",
		"dropBombAccuracy",
		"aircraftBooster",
		"manualEnhancement",
		"initialEnhancement",
		"worldBuffResistance",
		"airResistPierceActive",
		"airResistPierce"
	},
	InsertInheritedAttr = function (slot0)
		for slot4, slot5 in pairs(slot0) do
			slot0.AttrListInheritance[#slot0.AttrListInheritance + 1] = slot5
		end
	end,
	TAG_EHC_KEY = "DMG_TAG_EHC_",
	FROM_TAG_EHC_KEY = "DMG_FROM_TAG_",
	ATTACK_ATTR_TYPE = {
		[ys.Battle.BattleConst.WeaponDamageAttr.CANNON] = "cannonPower",
		[ys.Battle.BattleConst.WeaponDamageAttr.TORPEDO] = "torpedoPower",
		[ys.Battle.BattleConst.WeaponDamageAttr.ANTI_AIR] = "antiAirPower",
		[ys.Battle.BattleConst.WeaponDamageAttr.AIR] = "airPower",
		[ys.Battle.BattleConst.WeaponDamageAttr.ANIT_SUB] = "antiSubPower"
	},
	GetAtkAttrByType = function (slot0, slot1)
		return slot0[slot0.ATTACK_ATTR_TYPE[slot1]]
	end,
	SetAttr = function (slot0, slot1)
		slot0._attr = setmetatable({}, {
			__index = slot1
		})
	end,
	GetAttr = function (slot0)
		return slot0._attr
	end,
	SetBaseAttr = function (slot0)
		slot0._baseAttr = Clone(slot0._attr)
	end,
	IsInvincible = function (slot0)
		return slot0._attr.isInvincible and slot1 > 0
	end,
	Whosyourdaddy = function (slot0)
		slot0._attr.isInvincible = (slot0._attr.isInvincible or 0) + 1
	end,
	AddImmuneAreaLimit = function (slot0, slot1)
		slot0._attr.immuneAreaLimit = (slot0._attr.immuneAreaLimit or 0) + slot1

		slot0._move:ImmuneAreaLimit((slot0._attr.immuneAreaLimit or 0) + slot1 > 0)
	end,
	AddImmuneMaxAreaLimit = function (slot0, slot1)
		slot0._attr.immuneMaxAreaLimit = (slot0._attr.immuneMaxAreaLimit or 0) + slot1

		slot0._move:ImmuneMaxAreaLimit((slot0._attr.immuneMaxAreaLimit or 0) + slot1 > 0)
	end,
	IsImmuneAreaLimit = function (slot0)
		return slot0._attr.immuneAreaLimit and slot1 > 0
	end,
	IsImmuneMaxAreaLimit = function (slot0)
		return slot0._attr.immuneMaxAreaLimit and slot1 > 0
	end,
	IsVisitable = function (slot0)
		return not slot0._attr.isUnVisitable or slot1 <= 0
	end,
	UnVisitable = function (slot0)
		slot0._attr.isUnVisitable = (slot0._attr.isUnVisitable or 0) + 1
	end,
	Visitable = function (slot0)
		slot0._attr.isUnVisitable = (slot0._attr.isUnVisitable or 0) - 1
	end,
	IsSpirit = function (slot0)
		return slot0._attr.isSpirit and slot1 > 0
	end,
	Spirit = function (slot0)
		slot0._attr.isSpirit = (slot0._attr.isSpirit or 0) + 1
	end,
	Entity = function (slot0)
		slot0._attr.isSpirit = (slot0._attr.isSpirit or 0) - 1
	end,
	IsStun = function (slot0)
		return slot0._attr.isStun and slot1 > 0
	end,
	Stun = function (slot0)
		slot0._attr.isStun = (slot0._attr.isStun or 0) + 1
	end,
	CancelStun = function (slot0)
		slot0._attr.isStun = (slot0._attr.isStun or 0) - 1
	end,
	IsCloak = function (slot0)
		return (slot0._attr.isCloak or 0) == 1
	end,
	Cloak = function (slot0)
		slot0._attr.isCloak = 1
		slot0._attr.airResistPierceActive = 1
	end,
	Uncloak = function (slot0)
		slot0._attr.isCloak = 0
		slot0._attr.airResistPierceActive = 0
	end,
	SetPlayerAttrFromOutBattle = function (slot0, slot1, slot2)
		slot0._attr = slot0._attr or {}
		slot0._attr or .id = slot1.id
		slot0._attr or .battleUID = slot0:GetUniqueID()
		slot0._attr or .level = slot1.level
		slot0._attr or .formulaLevel = slot1.level
		slot0._attr or .maxHP = slot1.durability
		slot0._attr or .cannonPower = slot1.cannon
		slot0._attr or .torpedoPower = slot1.torpedo
		slot0._attr or .antiAirPower = slot1.antiaircraft
		slot0._attr or .antiSubPower = slot1.antisub
		slot0._attr or .baseAntiSubPower = (slot2 and slot2.antisub) or slot1.antisub
		slot0._attr or .airPower = slot1.air
		slot0._attr or .loadSpeed = slot1.reload
		slot0._attr or .armorType = slot1.armorType
		slot0._attr or .attackRating = slot1.hit
		slot0._attr or .dodgeRate = slot1.dodge
		slot0._attr or .velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(slot1.speed)
		slot0._attr or .luck = slot1.luck
		slot0._attr or .repressReduce = slot1.repressReduce or 1
		slot0._attr or .oxyMax = slot1.oxy_max
		slot0._attr or .oxyCost = slot1.oxy_cost
		slot0._attr or .oxyRecovery = slot1.oxy_recovery
		slot0._attr or .oxyRecoveryBench = slot1.oxy_recovery_bench
		slot0._attr or .oxyAtkDuration = slot1.attack_duration
		slot0._attr or .raidDist = slot1.raid_distance
		slot0._attr or .sonarRange = slot1.sonarRange or 0
		slot0._attr or .cloakExposeBase = (slot2 and slot2.dodge + ys.Battle.BattleConfig.CLOAK_EXPOSE_CONST) or 0
		slot0._attr or .cloakExposeExtra = 0
		slot0._attr or .cloakRestore = slot0._attr or .cloakExposeBase + slot0._attr or .cloakExposeExtra + ys.Battle.BattleConfig.CLOAK_BASE_RESTORE_DELTA
		slot0._attr or .cloakRecovery = ys.Battle.BattleConfig.CLOAK_RECOVERY
		slot0._attr or .cloakStrikeAdditive = ys.Battle.BattleConfig.CLOAK_STRIKE_ADDITIVE
		slot0._attr or .airResistPierce = ys.Battle.BattleConfig.BASE_ARP
		slot0._attr or .healingRate = 1
		slot0._attr or .DMG_TAG_EHC_N_99 = slot1[AttributeType.AntiSiren] or 0
		slot0._attr or .comboTag = "combo_" .. slot0._attr or .battleUID
		slot0._attr or .labelTag = {}
		slot0._attr or .barrageCounterMod = 1

		slot0:SetBaseAttr()
	end,
	AttrFixer = function (slot0, slot1)
		if slot0 == SYSTEM_SCENARIO then
			slot1.repressReduce = ys.Battle.BattleDataProxy.GetInstance():GetRepressReduce()
		elseif slot0 == SYSTEM_DUEL or slot0 == SYSTEM_SHAM then
			slot4, slot5 = ys.Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition(slot0, slot2)
			slot1.durability = slot1.durability * slot4 + slot5
		end
	end,
	InitDOTAttr = function (slot0, slot1)
		slot2 = ys.Battle.BattleConfig.DOT_CONFIG_DEFAULT

		for slot7, slot8 in ipairs(slot3) do
			for slot12, slot13 in pairs(slot8) do
				if slot12 == "hit" then
					slot0[slot13] = slot1[slot13] or slot2[slot12]
				else
					slot0[slot13] = slot2[slot12]
				end
			end
		end
	end,
	SetEnemyAttr = function (slot0, slot1)
		slot3 = slot0:GetLevel()
		slot0._attr = slot0._attr or {}
		slot0._attr or .battleUID = slot0:GetUniqueID()
		slot0._attr or .level = slot3
		slot0._attr or .formulaLevel = slot3
		slot0._attr or .maxHP = math.ceil(slot0._tmpData.durability + slot0._tmpData.durability_growth * (slot3 - 1) / 1000)
		slot0._attr or .cannonPower = slot0._tmpData.cannon + slot0._tmpData.cannon_growth * (slot3 - 1) / 1000
		slot0._attr or .torpedoPower = slot0._tmpData.torpedo + slot0._tmpData.torpedo_growth * (slot3 - 1) / 1000
		slot0._attr or .antiAirPower = slot0._tmpData.antiaircraft + slot0._tmpData.antiaircraft_growth * (slot3 - 1) / 1000
		slot0._attr or .airPower = slot0._tmpData.air + slot0._tmpData.air_growth * (slot3 - 1) / 1000
		slot0._attr or .antiSubPower = slot0._tmpData.antisub + slot0._tmpData.antisub_growth * (slot3 - 1) / 1000
		slot0._attr or .loadSpeed = slot0._tmpData.reload + slot0._tmpData.reload_growth * (slot3 - 1) / 1000
		slot0._attr or .armorType = slot0._tmpData.armor_type
		slot0._attr or .attackRating = slot0._tmpData.hit + slot0._tmpData.hit_growth * (slot3 - 1) / 1000
		slot0._attr or .dodgeRate = slot0._tmpData.dodge + slot0._tmpData.dodge_growth * (slot3 - 1) / 1000
		slot0._attr or .velocity = ys.Battle.BattleFormulas.ConvertShipSpeed(slot0._tmpData.speed + slot0._tmpData.speed_growth * (slot3 - 1) / 1000)
		slot0._attr or .luck = slot0._tmpData.luck + slot0._tmpData.luck_growth * (slot3 - 1) / 1000
		slot0._attr or .bulletSpeedRatio = 0
		slot0._attr or .id = "enemy_" .. tostring(slot0._tmpData.id)
		slot0._attr or .repressReduce = 1
		slot0._attr or .healingRate = 1
		slot0._attr or .comboTag = "combo_" .. slot0._attr or .battleUID
		slot0._attr or .labelTag = {}

		slot0:SetBaseAttr()
	end,
	SetEnemyWorldEnhance = function (slot0)
		slot0._attr.maxHP = slot0._attr.maxHP * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[1], slot3)
		slot0._attr.cannonPower = slot0._attr.cannonPower * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[2], slot3)
		slot0._attr.torpedoPower = slot0._attr.torpedoPower * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[3], slot3)
		slot0._attr.antiAirPower = slot0._attr.antiAirPower * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[4], slot3)
		slot0._attr.airPower = slot0._attr.airPower * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[5], slot3)
		slot0._attr.attackRating = slot0._attr.attackRating * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[6], slot3)
		slot0._attr.dodgeRate = slot0._attr.dodgeRate * ys.Battle.BattleFormulas.WorldEnemyAttrEnhance(slot0._tmpData.world_enhancement[7], slot3)
		slot8, slot9, slot0._attr.worldBuffResistance = ys.Battle.BattleFormulas.WorldMapRewardAttrEnhance(ys.Battle.BattleDataProxy.GetInstance().GetInitData(slot4).EnemyMapRewards, ys.Battle.BattleDataProxy.GetInstance().GetInitData(slot4).FleetMapRewards)
		slot0._attr.cannonPower = slot0._attr.cannonPower * (1 + slot8)
		slot0._attr.torpedoPower = slot0._attr.torpedoPower * (1 + slot8)
		slot0._attr.airPower = slot0._attr.airPower * (1 + slot8)
		slot0._attr.antiAirPower = slot0._attr.antiAirPower * (1 + slot8)
		slot0._attr.antiSubPower = slot0._attr.antiSubPower * (1 + slot8)
		slot0._attr.maxHP = math.ceil(slot0._attr.maxHP * (1 + slot9))

		slot0:SetBaseAttr()
	end,
	IsWorldMapRewardAttrWarning = function (slot0, slot1)
		for slot5 = 1, 3, 1 do
			if slot1[slot5] / ((slot0[slot5] ~= 0 and slot0[slot5]) or 1) < pg.gameset.world_mapbuff_tips.key_value / 10000 then
				return true
			end
		end

		return false
	end,
	MonsterAttrFixer = function (slot0, slot1)
		if slot0 == SYSTEM_SCENARIO then
			slot0.SetCurrent(slot1, "formulaLevel", math.max(1, slot0.GetCurrent(slot1, "level") - ((ys.Battle.BattleDataProxy.GetInstance():IsCompletelyRepress() and slot2:GetRepressLevel()) or 0)))
		elseif slot0 == SYSTEM_WORLD then
			slot0.SetEnemyWorldEnhance(slot1)
		end
	end,
	SetAircraftAttFromMother = function (slot0, slot1)
		slot0._attr = slot0._attr or {}
		slot0._attr or .battleUID = slot0:GetUniqueID()
		slot0._attr or .hostUID = slot1:GetUniqueID()

		if not type(slot1._attr.id) == "string" or string.find(slot1._attr.id, "enemy_") == nil then
			slot2.id = slot1._attr.id
		end

		slot3 = slot0.GetAttr(slot1)

		for slot7, slot8 in ipairs(slot0.AttrListInheritance) do
			slot2[slot8] = slot3[slot8]
		end

		for slot7, slot8 in pairs(slot3) do
			if string.find(slot7, slot0.TAG_EHC_KEY) then
				slot2[slot7] = slot8
			end
		end

		slot2.armorType = 0
		slot2.labelTag = setmetatable({}, {
			__index = slot1._attr.labelTag
		})
		slot2.comboTag = "combo_" .. slot2.hostUID
	end,
	SetAircraftAttFromTemp = function (slot0)
		slot0._attr = slot0._attr or {}
		slot0._attr.velocity = slot0._attr.velocity or ys.Battle.BattleFormulas.ConvertAircraftSpeed(slot0._tmpData.speed)
		slot0._attr.maxHP = slot0._attr.maxHP or slot0._tmpData.max_hp + slot0._tmpData.hp_growth / 1000 * ((slot0._attr.level or 1) - 1) + slot0:GetCurrent("hiveExtraHP")
		slot0._attr.crashDMG = slot0._tmpData.crash_DMG
		slot0._attr.dodge = slot0._tmpData.dodge
		slot0._attr.dodgeLimit = slot0._tmpData.dodge_limit
	end,
	SetAirFighterAttr = function (slot0, slot1)
		slot0._attr = slot0._attr or {}
		slot3 = ys.Battle.BattleDataProxy.GetInstance()
		slot0._attr or .battleUID = slot0:GetUniqueID()
		slot0._attr or .hostUID = 0
		slot0._attr or .id = 0
		slot0._attr or .level = slot3:GetDungeonLevel()
		slot0._attr or .formulaLevel = slot3.GetDungeonLevel()

		if slot3:IsCompletelyRepress() then
			slot2.formulaLevel = math.max(slot2.formulaLevel - 10, 1)
		end

		slot2.maxHP = math.floor(slot1.max_hp + slot1.hp_growth * (slot4 - 1) / 1000)
		slot2.attackRating = slot1.accuracy + slot1.ACC_growth * (slot4 - 1) / 1000
		slot2.dodge = slot1.dodge
		slot2.dodgeLimit = slot1.dodge_limit
		slot2.cannonPower = slot1.attack_power + slot1.AP_growth * (slot4 - 1) / 1000
		slot2.torpedoPower = slot1.attack_power + slot1.AP_growth * (slot4 - 1) / 1000
		slot2.antiAirPower = slot1.attack_power + slot1.AP_growth * (slot4 - 1) / 1000
		slot2.antiSubPower = slot1.attack_power + slot1.AP_growth * (slot4 - 1) / 1000
		slot2.airPower = slot1.attack_power + slot1.AP_growth * (slot4 - 1) / 1000
		slot2.loadSpeed = 0
		slot2.armorType = 1
		slot2.dodgeRate = 0
		slot2.luck = 50
		slot2.velocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(slot1.speed)
		slot2.repressReduce = 1
		slot2.crashDMG = slot1.crash_DMG
	end,
	FlashByBuff = function (slot0, slot1, slot2)
		slot0._attr[slot1] = slot2 + (slot0._baseAttr[slot1] or 0)

		if string.find(slot1, slot0.FROM_TAG_EHC_KEY) then
			slot3 = 0

			for slot7, slot8 in pairs(slot0._attr) do
				if string.find(slot7, slot0.FROM_TAG_EHC_KEY) and slot8 ~= 0 then
					slot3 = 1

					break
				end
			end

			slot0:SetCurrent(slot0.FROM_TAG_EHC_KEY, slot3)
		end
	end,
	FlashVelocity = function (slot0, slot1, slot2)
		slot0:SetCurrent("velocity", Mathf.Clamp(slot0._baseAttr.velocity * slot1 + slot2, slot4, slot3))
	end,
	HasSonar = function (slot0)
		return ys.Battle.BattleConfig.VAN_SONAR_PROPERTY[slot0:GetTemplate().type] ~= nil
	end,
	SetCurrent = function (slot0, slot1, slot2)
		slot0._attr[slot1] = slot2
	end,
	GetCurrent = function (slot0, slot1)
		return slot0._attr[slot1] or 0
	end,
	GetBase = function (slot0, slot1)
		return slot0._baseAttr[slot1] or 0
	end,
	GetCurrentTags = function (slot0)
		return slot0._attr.labelTag or {}
	end,
	Increase = function (slot0, slot1, slot2)
		if slot2 then
			slot0._attr[slot1] = (slot0._attr[slot1] or 0) + slot2
		end
	end,
	RatioIncrease = function (slot0, slot1, slot2)
		if slot2 then
			slot0._attr[slot1] = slot0._attr[slot1] + (slot0._baseAttr[slot1] * slot2) / 10000
		end
	end,
	GetTagAttr = function (slot0, slot1, slot2)
		slot4 = {}

		for slot8, slot9 in ipairs(slot3) do
			slot4[slot0.TAG_EHC_KEY .. slot9] = true
		end

		slot5 = 1

		for slot9, slot10 in pairs(slot4) do
			if slot0:GetCurrent(slot9) ~= 0 then
				if slot2 then
					slot11 = ys.Battle.BattleDataFunction.GetLimitAttributeRange(slot9, slot11)
				end

				slot5 = slot5 * (1 + slot11)
			end
		end

		if slot0.GetCurrent(slot1, slot0.FROM_TAG_EHC_KEY) > 0 then
			slot8 = slot0.FROM_TAG_EHC_KEY .. slot7 .. "_"

			for slot13, slot14 in pairs(slot9) do
				if slot14 > 0 and slot0.GetCurrent(slot1, slot8 .. slot13) ~= 0 then
					slot5 = slot5 * (1 + slot16)
				end
			end
		end

		return slot5
	end
}

()["InsertInheritedAttr"](ys.Battle.BattleConfig.AMMO_DAMAGE_ENHANCE)
()["InsertInheritedAttr"](ys.Battle.BattleConfig.AMMO_DAMAGE_REDUCE)
()["InsertInheritedAttr"](ys.Battle.BattleConfig.AGAINST_ARMOR_ENHANCE)
()["InsertInheritedAttr"](ys.Battle.BattleConfig.SHIP_TYPE_ACCURACY_ENHANCE)

return

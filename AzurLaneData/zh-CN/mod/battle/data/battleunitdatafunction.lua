ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleConfig
slot3 = ys.Battle.BattleAttr
slot4 = pg.ship_data_statistics
slot5 = pg.ship_data_template
slot6 = pg.ship_skin_template
slot7 = pg.enemy_data_statistics
slot8 = pg.weapon_property
slot9 = pg.formation_template
slot10 = pg.auto_pilot_template
slot11 = pg.aircraft_template
slot12 = pg.ship_skin_words
slot13 = pg.equip_data_statistics
slot14 = pg.equip_data_template
slot15 = pg.enemy_data_skill
slot16 = pg.ship_data_personality
slot17 = pg.enemy_data_by_type
slot18 = pg.ship_data_by_type
slot19 = pg.ship_level
slot20 = pg.skill_data_template
slot21 = pg.ship_data_trans
slot22 = pg.battle_environment_behaviour_template
slot23 = pg.equip_skin_template
slot24 = pg.activity_template
slot25 = pg.activity_event_worldboss
slot26 = pg.world_joint_boss_template
slot27 = pg.world_boss_level
slot28 = pg.guild_boss_event
slot29 = pg.ship_strengthen_meta
slot30 = pg.map_data
ys.Battle.BattleDataFunction = ys.Battle.BattleDataFunction or {}

ys or .Battle.BattleDataFunction.CreateBattleUnitData = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11)
	slot12, slot13 = nil

	if slot1 == slot0.UnitType.PLAYER_UNIT then
		slot1.Battle.BattlePlayerUnit.New(slot0, slot2).SetSkinId(slot12, slot4)
		slot1.Battle.BattlePlayerUnit.New(slot0, slot2):SetWeaponInfo(slot9, slot10)

		slot13 = Ship.WEAPON_COUNT
	elseif slot1 == slot0.UnitType.SUB_UNIT then
		slot1.Battle.BattleSubUnit.New(slot0, slot2).SetSkinId(slot12, slot4)
		slot1.Battle.BattleSubUnit.New(slot0, slot2):SetWeaponInfo(slot9, slot10)

		slot13 = Ship.WEAPON_COUNT
	elseif slot1 == slot0.UnitType.ENEMY_UNIT then
		slot1.Battle.BattleEnemyUnit.New(slot0, slot2):SetOverrideLevel(slot11)
	elseif slot1 == slot0.UnitType.BOSS_UNIT then
		slot1.Battle.BattleBossUnit.New(slot0, slot2):SetOverrideLevel(slot11)
	elseif slot1 == slot0.UnitType.NPC_UNIT then
		slot12 = slot1.Battle.BattleNPCUnit.New(slot0, slot2)
	elseif slot1 == slot0.UnitType.CONST_UNIT then
		slot1.Battle.BattleConstPlayerUnit.New(slot0, slot2).SetSkinId(slot12, slot4)
		slot1.Battle.BattleConstPlayerUnit.New(slot0, slot2):SetWeaponInfo(slot9, slot10)

		slot13 = Ship.WEAPON_COUNT
	end

	slot12:SetTemplate(slot3, slot6, slot7)

	slot14 = {}

	if slot1 == slot0.UnitType.ENEMY_UNIT or slot1 == slot0.UnitType.BOSS_UNIT then
		for slot18, slot19 in ipairs(slot5) do
			slot14[#slot14 + 1] = {
				equipment = {
					weapon_id = {
						slot19.id
					}
				}
			}
		end
	else
		for slot18, slot19 in ipairs(slot5) do
			if not slot19.id then
				slot14[#slot14 + 1] = {
					equipment = false,
					torpedoAmmo = 0,
					skin = slot19.skin
				}
			else
				slot20 = (slot19.equipmentInfo and slot19.equipmentInfo.config.torpedo_ammo) or 0

				if not slot13 or slot18 <= slot13 or #slot2.GetWeaponDataFromID(slot19.id).weapon_id then
					slot14[#slot14 + 1] = {
						equipment = slot2.GetWeaponDataFromID(slot19.id),
						skin = slot19.skin,
						torpedoAmmo = slot20
					}
				else
					slot14[#slot14 + 1] = {
						equipment = false,
						skin = slot19.skin,
						torpedoAmmo = slot20
					}
				end
			end
		end
	end

	slot12:SetProficiencyList(slot8)
	slot12:SetEquipment(slot14)

	return slot12
end

ys or .Battle.BattleDataFunction.InitUnitSkill = function (slot0, slot1, slot2)
	slot3 = slot0.skills or {}

	for slot7, slot8 in pairs(slot3) do
		slot1:AddBuff(slot0.Battle.BattleBuffUnit.New(slot8.id, slot8.level, slot1))
	end
end

ys or .Battle.BattleDataFunction.GetEquipSkill = function (slot0, slot1)
	slot2 = Ship.WEAPON_COUNT
	slot3 = {}

	for slot7, slot8 in ipairs(slot0) do
		if slot8.id then
			slot10 = nil

			if slot2 and slot2 < slot7 then
				if slot0.GetWeaponDataFromID(slot9) ~= nil then
					slot10 = slot11.skill_id
				end
			else
				slot10 = slot0.GetWeaponDataFromID(slot9).skill_id
			end

			for slot14, slot15 in ipairs(slot10) do
				if slot1 then
					table.insert(slot3, slot0.SkillTranform(slot1, slot15) or slot15)
				end
			end
		end
	end

	return slot3
end

ys or .Battle.BattleDataFunction.InitEquipSkill = function (slot0, slot1, slot2)
	for slot7, slot8 in ipairs(slot3) do
		slot1:AddBuff(slot1.Battle.BattleBuffUnit.New(slot8, 1, slot1))
	end
end

ys or .Battle.BattleDataFunction.InitCommanderSkill = function (slot0, slot1, slot2)
	slot3 = slot0 or {}.Battle.BattleState.GetInstance():GetBattleType()

	for slot7, slot8 in pairs(slot0) do
		slot10 = false

		if slot0.Battle.BattleDataFunction.GetBuffTemplate(slot8.id, slot8.level).limit then
			for slot14, slot15 in ipairs(slot9) do
				if slot3 == slot15 then
					slot10 = true

					break
				end
			end
		end

		if not slot10 then
			slot11 = slot0.Battle.BattleBuffUnit.New(slot8.id, slot8.level, slot1)

			slot11:SetCommander(slot8.commander)
			slot1:AddBuff(slot11)
		end
	end
end

ys or .Battle.BattleDataFunction.CreateWeaponUnit = function (slot0, slot1, slot2, slot3, slot4)
	slot3 = slot3 or -1
	slot5 = slot1:GetUnitType()
	slot6 = nil
	slot8 = slot4 or slot0:GetWeaponPropertyDataFromID().type

	if slot8 == slot1.EquipmentType.MAIN_CANNON then
		slot6 = slot2.Battle.BattleWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.SUB_CANNON then
		slot6 = slot2.Battle.BattleWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.TORPEDO then
		slot6 = slot2.Battle.BattleTorpedoUnit.New()
	elseif slot8 == slot1.EquipmentType.MANUAL_TORPEDO then
		slot6 = slot2.Battle.BattleManualTorpedoUnit.New()
	elseif slot8 == slot1.EquipmentType.ANTI_AIR then
		slot6 = slot2.Battle.BattleAntiAirUnit.New()
	elseif slot8 == slot1.EquipmentType.FLEET_ANTI_AIR then
		slot6 = slot2.Battle.BattleWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.SCOUT or slot8 == slot1.EquipmentType.PASSIVE_SCOUT then
		slot6 = slot2.Battle.BattleHiveUnit.New()
	elseif slot8 == slot1.EquipmentType.SPECIAL then
		slot6 = slot2.Battle.BattleSpecialWeapon.New()
	elseif slot8 == slot1.EquipmentType.ANTI_SEA then
		slot6 = slot2.Battle.BattleDirectHitWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.HAMMER_HEAD then
		slot6 = slot2.Battle.BattleHammerHeadWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.BOMBER_PRE_CAST_ALERT then
		slot6 = slot2.Battle.BattleBombWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.POINT_HIT_AND_LOCK then
		slot6 = slot2.Battle.BattlePointHitWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.BEAM then
		slot6 = slot2.Battle.BattleLaserUnit.New()
	elseif slot8 == slot1.EquipmentType.DEPTH_CHARGE then
		slot6 = slot2.Battle.BattleDepthChargeUnit.New()
	elseif slot8 == slot1.EquipmentType.REPEATER_ANTI_AIR then
		slot6 = slot2.Battle.BattleRepeaterAntiAirUnit.New()
	elseif slot8 == slot1.EquipmentType.DISPOSABLE_TORPEDO then
		slot6 = slot2.Battle.BattleDisposableTorpedoUnit.New()
	elseif slot8 == slot1.EquipmentType.SPACE_LASER then
		slot6 = slot2.Battle.BattleSpaceLaserWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.MISSILE then
		slot6 = slot2.Battle.BattleMissileWeaponUnit.New()
	elseif slot8 == slot1.EquipmentType.MANUAL_AAMISSILE then
		slot6 = slot2.Battle.BattleManualAAMissileUnit.New()
	end

	slot6:SetPotentialFactor(slot2)
	slot6:SetEquipmentIndex(slot3)
	slot6:SetTemplateData(slot7)
	slot6:SetHostData(slot1)

	if slot5 == slot1.UnitType.PLAYER_UNIT then
		if slot7.auto_aftercast > 0 then
			slot6:OverrideGCD(slot7.auto_aftercast)
		end
	elseif slot5 == slot1.UnitType.ENEMY_UNIT or slot1.UnitType.BOSS_UNIT then
		slot6:HostOnEnemy()
	end

	if slot7.type == slot1.EquipmentType.SCOUT or slot7.type == slot1.EquipmentType.PASSIVE_SCOUT then
		slot6:EnterCoolDown()
	end

	return slot6
end

ys or .Battle.BattleDataFunction.CreateAircraftUnit = function (slot0, slot1, slot2, slot3)
	slot4 = nil

	(type(slot0.GetAircraftTmpDataFromID(slot1).funnel_behavior) ~= "table" or ((not slot5.funnel_behavior.hover_range or slot1.Battle.BattelUAVUnit.New(slot0)) and (not slot5.funnel_behavior.AI or slot1.Battle.BattlePatternFunnelUnit.New(slot0)) and slot1.Battle.BattleFunnelUnit.New(slot0))) and slot1.Battle.BattleAircraftUnit.New(slot0):SetMotherUnit(slot2)
	(type(slot0.GetAircraftTmpDataFromID(slot1).funnel_behavior) ~= "table" or ((not slot5.funnel_behavior.hover_range or slot1.Battle.BattelUAVUnit.New(slot0)) and (not slot5.funnel_behavior.AI or slot1.Battle.BattlePatternFunnelUnit.New(slot0)) and slot1.Battle.BattleFunnelUnit.New(slot0))) and slot1.Battle.BattleAircraftUnit.New(slot0):SetWeanponPotential(slot3)
	(type(slot0.GetAircraftTmpDataFromID(slot1).funnel_behavior) ~= "table" or ((not slot5.funnel_behavior.hover_range or slot1.Battle.BattelUAVUnit.New(slot0)) and (not slot5.funnel_behavior.AI or slot1.Battle.BattlePatternFunnelUnit.New(slot0)) and slot1.Battle.BattleFunnelUnit.New(slot0))) and slot1.Battle.BattleAircraftUnit.New(slot0):SetTemplate(slot5)

	return (type(slot0.GetAircraftTmpDataFromID(slot1).funnel_behavior) ~= "table" or ((not slot5.funnel_behavior.hover_range or slot1.Battle.BattelUAVUnit.New(slot0)) and (not slot5.funnel_behavior.AI or slot1.Battle.BattlePatternFunnelUnit.New(slot0)) and slot1.Battle.BattleFunnelUnit.New(slot0))) and slot1.Battle.BattleAircraftUnit.New(slot0)
end

ys or .Battle.BattleDataFunction.CreateAllInStrike = function (slot0)
	slot3 = 0
	slot4 = {}

	for slot8, slot9 in ipairs(slot0.GetPlayerShipModelFromID(slot1).airassist_time) do
		slot10 = slot1.Battle.BattleAllInStrike.New(slot9)

		slot10:SetHost(slot0)

		slot4[slot8] = slot10
	end

	return slot4
end

ys or .Battle.BattleDataFunction.ExpandAllinStrike = function (slot0)
	if #slot0.GetPlayerShipModelFromID(slot1).airassist_time > 0 then
		slot5 = slot1.Battle.BattleAllInStrike.New(slot4)

		slot5:SetHost(slot0)
		slot0:GetFleetVO():GetAirAssistVO():AppendWeapon(slot5)
		slot5:OverHeat()
		slot0:GetAirAssistQueue():AppendWeapon(slot5)

		slot0:GetAirAssistList()[#slot0.GetAirAssistList() + 1] = slot5
	end
end

ys or .Battle.BattleDataFunction.CreateAirFighterUnit = function (slot0, slot1)
	slot1.Battle.BattleAirFighterUnit.New(slot0).SetWeaponTemplateID(nil, slot1.weaponID)
	slot1.Battle.BattleAirFighterUnit.New(slot0):SetTemplate(slot0.GetAircraftTmpDataFromID(slot1.templateID))

	return slot1.Battle.BattleAirFighterUnit.New(slot0)
end

ys or .Battle.BattleDataFunction.GetPlayerShipTmpDataFromID = function (slot0)
	return Clone(slot0[slot0])
end

ys or .Battle.BattleDataFunction.GetPlayerShipModelFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetPlayerShipSkinDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetShipTypeTmp = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetMonsterTmpDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetAircraftTmpDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetWeaponDataFromID = function (slot0)
	if slot0 ~= Equipment.EQUIPMENT_STATE_EMPTY and slot0 ~= Equipment.EQUIPMENT_STATE_LOCK then
	end

	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetEquipDataTemplate = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetWeaponPropertyDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetFormationTmpDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetAITmpDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetShipPersonality = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetEnemyTypeDataByType = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetArenaBuffByShipType = function (slot0)
	return slot0:GetShipTypeTmp().arena_buff
end

ys or .Battle.BattleDataFunction.GetPlayerUnitDurabilityExtraAddition = function (slot0, slot1)
	if slot0 == SYSTEM_DUEL then
		return slot0[slot1].arena_durability_ratio, slot0[slot1].arena_durability_add
	else
		return 1, 0
	end
end

ys or .Battle.BattleDataFunction.GetSkillDataTemplate = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetShipTransformDataTemplate = function (slot0)
	return slot1[slot0:GetPlayerShipModelFromID().group_type]
end

ys or .Battle.BattleDataFunction.GetShipMetaFromDataTemplate = function (slot0)
	return slot1[slot0:GetPlayerShipModelFromID().group_type]
end

ys or .Battle.BattleDataFunction.GetEquipSkinDataFromID = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.GetEquipSkin = function (slot0)
	return slot0[slot0].bullet_name, slot0[slot0].derivate_bullet, slot0[slot0].derivate_torpedo, slot0[slot0].derivate_boom
end

ys or .Battle.BattleDataFunction.GetSpecificGuildBossEnemyList = function (slot0, slot1)
	slot4 = {}

	if slot0[slot0].expedition_id[1] == slot1 then
		slot4 = slot3[2]
	end

	return slot4
end

ys or .Battle.BattleDataFunction.GetSpecificEnemyList = function (slot0, slot1)
	slot5 = nil

	for slot9, slot10 in ipairs(slot4) do
		if slot10[1] == slot1 then
			slot5 = slot10[2]

			break
		end
	end

	return slot5
end

ys or .Battle.BattleDataFunction.GetSpecificWorldJointEnemyList = function (slot0, slot1, slot2)
	return {
		pg.world_boss_level[slot0[slot1].boss_level_id + slot2 - 1].enemy_id
	}
end

ys or .Battle.BattleDataFunction.IncreaseAttributes = function (slot0, slot1, slot2)
	for slot6, slot7 in ipairs(slot2) do
		if slot7[slot1] ~= nil and type(slot7[slot1]) == "number" then
			slot0 = slot0 + slot7[slot1]
		end
	end
end

ys or .Battle.BattleDataFunction.CreateAirFighterWeaponUnit = function (slot0, slot1, slot2, slot3)
	slot4 = nil

	if slot0:GetWeaponPropertyDataFromID().type == slot1.EquipmentType.MAIN_CANNON then
		slot4 = slot2.Battle.BattleWeaponUnit.New()
	elseif slot5.type == slot1.EquipmentType.SUB_CANNON then
		slot4 = slot2.Battle.BattleWeaponUnit.New()
	elseif slot5.type == slot1.EquipmentType.TORPEDO then
		slot4 = slot2.Battle.BattleTorpedoUnit.New()
	elseif slot5.type == slot1.EquipmentType.ANTI_AIR then
		slot4 = slot2.Battle.BattleAntiAirUnit.New()
	elseif slot5.type == slot1.EquipmentType.ANTI_SEA then
		slot4 = slot2.Battle.BattleDirectHitWeaponUnit.New()
	elseif slot5.type == slot1.EquipmentType.HAMMER_HEAD then
		slot4 = slot2.Battle.BattleHammerHeadWeaponUnit.New()
	elseif slot5.type == slot1.EquipmentType.BOMBER_PRE_CAST_ALERT then
		slot4 = slot2.Battle.BattleBombWeaponUnit.New()
	elseif slot5.type == slot1.EquipmentType.DEPTH_CHARGE then
		slot4 = slot2.Battle.BattleDepthChargeUnit.New()
	end

	slot4:SetPotentialFactor(slot3)

	Clone(slot5).spawn_bound = "weapon"

	slot4:SetTemplateData(slot6)
	slot4:SetHostData(slot1, slot2)

	return slot4
end

ys or .Battle.BattleDataFunction.GetWords = function (slot0, slot1, slot2)
	slot3, slot4, slot5 = ShipWordHelper.GetWordAndCV(slot0, slot1, 1, true, slot2)

	return slot5
end

ys or .Battle.BattleDataFunction.SkillTranform = function (slot0, slot1)
	if slot0.GetSkillDataTemplate(slot1).system_transform[slot0] == nil then
		return slot1
	else
		return slot3[slot0]
	end
end

ys or .Battle.BattleDataFunction.GenerateHiddenBuff = function (slot0)
	slot2 = {}

	for slot6, slot7 in ipairs(slot1) do
		slot2[slot7] = {
			level = 1,
			id = slot7
		}
	end

	return slot2
end

ys or .Battle.BattleDataFunction.GetDivingFilter = function (slot0)
	return slot0[slot0].diving_filter
end

ys or .Battle.BattleDataFunction.GeneratePlayerSubmarinPhase = function (slot0, slot1, slot2, slot3, slot4)
	return {
		{
			index = 0,
			switchType = 3,
			switchTo = 1,
			switchParam = slot0 - slot2
		},
		{
			switchParam = 0,
			dive = "STATE_RAID",
			switchTo = 2,
			index = 1,
			switchType = 5
		},
		{
			index = 2,
			switchType = 1,
			switchTo = 3,
			dive = "STATE_FLOAT",
			switchParam = slot4
		},
		{
			index = 3,
			switchType = 4,
			switchTo = 4,
			dive = "STATE_RETREAT",
			switchParam = slot1
		},
		{
			index = 4,
			retreat = true
		}
	}
end

ys or .Battle.BattleDataFunction.GetEnvironmentBehaviour = function (slot0)
	return slot0[slot0]
end

ys or .Battle.BattleDataFunction.AttachUltimateBonus = function (slot0)
	if not Ship.IsMaxStarByTmpID(slot0:GetTemplateID()) then
		return
	end

	for slot7, slot8 in ipairs(slot3) do
		if slot8 == ShipType.SpecificTypeTable.gunner then
			slot1.SetCurrent(slot0, "barrageCounterMod", slot2.UltimateBonus.GunnerCountMod)
		elseif slot8 == ShipType.SpecificTypeTable.torpedo then
			slot0:AddBuff(slot3.Battle.BattleBuffUnit.New(slot2.UltimateBonus.TorpedoBarrageBuff))
		elseif slot8 == ShipType.SpecificTypeTable.auxiliary then
			slot0:AuxBoost()
		end
	end
end

ys or .Battle.BattleDataFunction.AuxBoost = function (slot0)
	for slot5, slot6 in ipairs(slot1) do
		if slot6 and slot6.equipment and table.contains(EquipType.DeviceEquipTypes, slot6.equipment.type) then
			slot7 = slot6.equipment

			for slot11 = 1, 3, 1 do
				if slot7["attribute_" .. slot11] then
					slot0:SetCurrent(AttributeType.ConvertBattleAttrName(slot7[slot12]), slot0:GetBase(slot14) + slot7["value_" .. slot11] * slot1.UltimateBonus.AuxBoostValue)
					slot0:SetBaseAttr()
				end
			end
		end
	end
end

return

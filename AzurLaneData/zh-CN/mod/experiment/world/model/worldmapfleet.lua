slot0 = class("WorldMapFleet", import(".WorldBaseFleet"))
slot0.Fields = {
	lossFlag = "number",
	ammo = "number",
	catSalvageList = "table",
	catSalvageStep = "number",
	index = "number",
	column = "number",
	catSalvageFrom = "number",
	buffs = "table",
	row = "number",
	damageLevel = "number",
	defeatEnemies = "number",
	skills = "table",
	carries = "table"
}
slot0.EventUpdateLocation = "WorldMapFleet.EventUpdateLocation"
slot0.EventUpdateShipOrder = "WorldMapFleet.EventUpdateShipOrder"
slot0.EventAddShip = "WorldMapFleet.EventAddShip"
slot0.EventRemoveShip = "WorldMapFleet.EventRemoveShip"
slot0.EventAddCarry = "WorldMapFleet.EventAddCarry"
slot0.EventRemoveCarry = "WorldMapFleet.EventRemoveCarry"
slot0.EventUpdateBuff = "WorldMapFleet.EventUpdateBuff"
slot0.EventUpdateDamageLevel = "WorldMapFleet.EventUpdateDamageLevel"
slot0.EventUpdateDefeat = "WorldMapFleet.EventUpdateDefeat"
slot0.EventUpdateCatSalvage = "WorldMapFleet.EventUpdateCatSalvage"

slot0.GetName = function (slot0)
	return "fleet_" .. slot0
end

slot0.DebugPrint = function (slot0)
	slot3 = string.format("[第%s舰队] [id: %s] [位置: %s, %s] [弹药: %s/%s] [携带物: %s] [战损: %s] [buff: %s]", slot0.index, slot0.id, slot0.row, slot0.column, slot0.GetAmmo(slot0), slot0:GetTotalAmmo(), table.concat(slot2, ", "), slot0.damageLevel, table.concat(_.map(slot0:GetBuffList(), function (slot0)
		return slot0.id .. "#" .. slot0:GetFloor()
	end), ", "))
	slot4 = {
		[TeamType.Main] = "主力",
		[TeamType.Vanguard] = "先锋",
		[TeamType.Submarine] = "潜艇"
	}
	slot5 = {}

	for slot9, slot10 in ipairs(slot0:GetShips(true)) do
		slot11 = WorldConst.FetchShipVO(slot10.id)

		table.insert(slot5, string.format("\t\t[%s] [id: %s] [config_id: %s] [%s] [hp: %s%%] [buff: %s]" .. " <material=underline c=#A9F548 event=ShipProperty args=%s><color=#A9F548>属性</color></material>", slot11.getName(slot11), slot11.id, slot11.configId, slot4[slot11:getTeamType()], slot10.hpRant / 100, table.concat(slot12, ", "), slot11.id))
	end

	return slot3 .. "\n" .. table.concat(slot5, "\n")
end

slot0.Build = function (slot0)
	slot0.super.Build(slot0)

	slot0.carries = {}
end

slot0.Setup = function (slot0, slot1)
	slot0.id = slot1.id

	slot0.UpdateShips(slot0, _.map(slot1.ship_list, function (slot0)
		slot1 = WPool:Get(WorldMapShip)

		slot1:Setup(slot0)

		return slot1
	end))

	slot0.commanderIds = {}
	slot3 = ipairs
	slot4 = slot1.commander_list or {}

	for slot6, slot7 in slot3(slot4) do
		slot0.commanderIds[slot7.pos] = slot7.id
	end

	slot0.skills = {}

	slot0:updateCommanderSkills()

	slot0.row = slot1.pos.row
	slot0.column = slot1.pos.column
	slot0.ammo = slot1.bullet
	slot0.damageLevel = math.clamp(slot1.damage_level, 0, #WorldConst.DamageBuffList)

	_.each(slot1.attach_list, function (slot0)
		slot1 = WPool:Get(WorldCarryItem)

		slot1:Setup(slot0)
		table.insert(slot0.carries, slot1)
	end)

	slot0.buffs = WorldConst.ParsingBuffs(slot1.buff_list)
	slot0.defeatEnemies = slot1.kill_count
	slot0.catSalvageStep = slot1.cmd_collection.progress
	slot0.catSalvageList = slot1.cmd_collection.progress_list
	slot0.catSalvageFrom = slot1.cmd_collection.random_id

	if slot0.GetFleetType(slot0) == FleetType.Submarine then
		slot0.row = -1
		slot0.column = -1
	end
end

slot0.GetCost = function (slot0)
	return {
		gold = 0,
		oil = 0
	}, {
		gold = 0,
		oil = 0
	}
end

slot0.GetFleetIndex = function (slot0)
	return slot0.index
end

slot0.GetDefaultName = function (slot0)
	return Fleet.DEFAULT_NAME[(#slot0[TeamType.Submarine] > 0 and slot0.index + 10) or slot0.index]
end

slot0.FormationEqual = function (slot0, slot1)
	for slot7 = 1, math.max(#_.map(slot0:GetShips(true), function (slot0)
		return slot0.id
	end), #_.map(slot1.GetShips(slot1, true), function (slot0)
		return slot0.id
	end)), 1 do
		if slot2[slot7] ~= slot3[slot7] then
			return false
		end
	end

	return true
end

slot0.GetPropertiesSum = function (slot0)
	slot1 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}

	for slot6, slot7 in ipairs(slot2) do
		slot8 = slot7:getProperties()
		slot1.cannon = slot1.cannon + math.floor(slot8.cannon)
		slot1.torpedo = slot1.torpedo + math.floor(slot8.torpedo)
		slot1.antiAir = slot1.antiAir + math.floor(slot8.antiaircraft)
		slot1.air = slot1.air + math.floor(slot8.air)
	end

	return slot1
end

slot0.GetGearScoreSum = function (slot0, slot1)
	slot2 = 0
	slot3 = (slot1 and slot0:GetTeamShipVOs(slot1)) or slot0:GetShipVOs()

	for slot7, slot8 in ipairs(slot3) do
		slot2 = slot2 + slot8:getShipCombatPower()
	end

	return slot2
end

slot0.GetLevelCount = function (slot0)
	underscore.each(slot0:GetShipVOs(), function (slot0)
		slot0 = slot0 + slot0.level
	end)

	return 0
end

slot0.AddShip = function (slot0, slot1, slot2)
	slot1.fleetId = slot0.id

	table.insert(slot0[WorldConst.FetchRawShipVO(slot1.id):getTeamType()], slot2 or #slot0[WorldConst.FetchRawShipVO(slot1.id).getTeamType()] + 1, slot1)
	slot0:DispatchEvent(slot0.EventAddShip, slot1)
end

slot0.RemoveShip = function (slot0, slot1)
	for slot7 = #slot0[WorldConst.FetchRawShipVO(slot1).getTeamType(slot2)], 1, -1 do
		if slot3[slot7].id == slot1 then
			slot8 = table.remove(slot3, slot7)
			slot8.fleetId = nil

			slot0:DispatchEvent(slot0.EventRemoveShip, slot8)

			return slot8, slot7
		end
	end
end

slot0.ReplaceShip = function (slot0, slot1, slot2)
	if slot0:GetShip(slot2.id) then
		slot0:SwitchShip(slot1, slot2.id)
	else
		slot3, slot8 = slot0:RemoveShip(slot1)

		slot0:AddShip(slot2, slot4)
	end
end

slot0.SwitchShip = function (slot0, slot1, slot2)
	slot6 = WorldConst.FetchRawShipVO(slot2).getTeamType(slot4)
	slot7, slot8 = nil

	for slot12, slot13 in ipairs(slot0[WorldConst.FetchRawShipVO(slot1).getTeamType(slot3)]) do
		if slot13.id == slot1 then
			slot7 = slot12
		end

		if slot13.id == slot2 then
			slot8 = slot12
		end
	end

	if slot7 ~= slot8 then
		slot0[slot6][slot8] = slot0[slot5][slot7]
		slot0[slot5][slot7] = slot0[slot6][slot8]

		slot0:DispatchEvent(slot0.EventUpdateShipOrder)
	end
end

slot0.CheckRemoveShip = function (slot0, slot1)
	if #slot0:GetTeamShips(slot1:getTeamType(), true) == 1 then
		return false, i18n("ship_formationUI_removeError_onlyShip", slot1:getConfig("name"), "", Fleet.C_TEAM_NAME[slot2])
	end

	return true
end

slot0.CheckChangeShip = function (slot0, slot1, slot2)
	if not (slot1 and WorldConst.FetchWorldShip(slot1.id).fleetId == WorldConst.FetchWorldShip(slot2.id).fleetId) and (not slot1 or not slot1:isSameKind(slot2)) and _.any(slot0:GetShips(true), function (slot0)
		return WorldConst.FetchRawShipVO(slot0.id):isSameKind(slot0)
	end) then
		return false, i18n("ship_formationMediator_changeNameError_sameShip")
	end

	return true
end

slot0.GetAmmo = function (slot0)
	return slot0.ammo
end

slot0.UseAmmo = function (slot0)
	slot0.ammo = slot0.ammo - 1
end

slot0.GetTotalAmmo = function (slot0)
	return _.reduce(slot0:GetShips(true), 0, function (slot0, slot1)
		return slot0 + slot1:GetImportWorldShipVO():getShipAmmo()
	end)
end

slot0.RepairSubmarine = function (slot0)
	_.each(slot0:GetTeamShips(TeamType.Submarine, true), function (slot0)
		slot0:Repair()
	end)

	slot0.ammo = slot0.GetTotalAmmo(slot0)
end

slot0.GetSpeed = function (slot0)
	slot1 = pg.gameset.world_move_initial_step.key_value

	if #slot0:GetBuffsByTrap(WorldBuff.TrapVortex) > 0 then
		slot1 = math.min(slot1, 1)
	end

	for slot5, slot6 in ipairs(slot0:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		slot1 = math.min(slot1, slot6:GetTrapParams()[2])
	end

	return slot1
end

slot0.GetStepDurationRate = function (slot0)
	slot1 = 1

	for slot5, slot6 in ipairs(slot0:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		slot1 = math.min(slot1, slot6:GetTrapParams()[3] / 100)
	end

	return 1 / slot1
end

slot0.GetFOVRange = function (slot0)
	slot1 = 1

	for slot5, slot6 in ipairs(slot0:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		slot1 = math.min(slot1, slot6:GetTrapParams()[1] / 100)
	end

	return math.floor(WorldConst.GetFOVRadius() * slot1)
end

slot0.GetCarries = function (slot0)
	return slot0.carries
end

slot0.ExistCarry = function (slot0, slot1)
	return _.any(slot0.carries, function (slot0)
		return slot0.id == slot0
	end)
end

slot0.AddCarry = function (slot0, slot1)
	table.insert(slot0.carries, slot1)
	slot0:DispatchEvent(WorldMapFleet.EventAddCarry, slot1)
end

slot0.RemoveCarry = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.carries) do
		if slot6.id == slot1 then
			for slot10 = #slot0.carries, slot5 + 1, -1 do
				slot0.carries[slot10]:UpdateOffset(slot0.carries[slot10 - 1].offsetRow, slot0.carries[slot10 - 1].offsetColumn)
			end

			table.remove(slot0.carries, slot5)
			slot0:DispatchEvent(WorldMapFleet.EventRemoveCarry, slot6)

			break
		end
	end
end

slot0.RemoveAllCarries = function (slot0)
	slot1 = nil

	for slot5 = #slot0.carries, 1, -1 do
		slot0:DispatchEvent(WorldMapFleet.EventRemoveCarry, table.remove(slot0.carries))
	end
end

slot0.BuildCarryPath = function (slot0, slot1, slot2, slot3)
	slot6 = _.map(slot3, function (slot0)
		return {
			row = slot0.row,
			column = slot0.column
		}
	end)

	table.insert(slot6, 1, {
		row = slot2.row,
		column = slot2.column
	})

	for slot10 = 1, table.indexof(slot4, slot1) - 1, 1 do
		table.insert(slot6, 1, {
			row = slot2.row + slot4[slot10].offsetRow,
			column = slot2.column + slot4[slot10].offsetColumn
		})
	end

	while #slot6 > #slot3 do
		table.remove(slot6, #slot6)
	end

	for slot10, slot11 in ipairs(slot6) do
		slot6[slot10].duration = slot3[slot10].duration
	end

	return slot6
end

slot0.HasDamageLevel = function (slot0)
	return slot0.damageLevel > 0
end

slot0.IncDamageLevel = function (slot0, slot1)
	if math.min(#WorldConst.DamageBuffList, slot0.damageLevel + (pg.world_expedition_data[slot1:GetBattleStageId()].failed_morale or 1)) ~= slot0.damageLevel then
		slot0.damageLevel = slot3

		slot0:DispatchEvent(slot0.EventUpdateDamageLevel)
	end
end

slot0.ClearDamageLevel = function (slot0)
	if 0 ~= slot0.damageLevel then
		slot0.damageLevel = slot1

		slot0:DispatchEvent(slot0.EventUpdateDamageLevel)
	end
end

slot0.GetDamageBuff = function (slot0)
	if slot0.damageLevel > 0 then
		slot1 = WorldBuff.New()

		slot1:Setup({
			floor = 1,
			id = WorldConst.DamageBuffList[slot0.damageLevel]
		})

		return slot1
	end
end

slot0.GetBuffList = function (slot0)
	return table.mergeArray(_.filter(_.values(slot0.buffs), function (slot0)
		return slot0:GetFloor() > 0
	end), nowWorld.GetActiveMap(slot2):GetBuffList(WorldMap.FactionSelf))
end

slot0.UpdateBuffs = function (slot0, slot1)
	if slot0.buffs ~= slot1 then
		if not nowWorld.isAutoFight then
			slot2 = nowWorld:GetActiveMap()

			for slot6, slot7 in pairs(WorldConst.CompareBuffs(slot0.buffs, slot1).add) do
				if #slot7.config.trap_lua > 0 then
					slot2:AddPhaseDisplay({
						story = slot7.config.trap_lua
					})
				end
			end
		end

		slot0.buffs = slot1

		slot0:DispatchEvent(slot0.EventUpdateBuff)
	end
end

slot0.GetBuff = function (slot0, slot1)
	return slot0.buffs[slot1]
end

slot0.GetBuffsByTrap = function (slot0, slot1)
	return underscore.filter(slot0:GetBuffList(), function (slot0)
		return slot0:GetTrapType() == slot0
	end)
end

slot0.HasTrapBuff = function (slot0)
	for slot4, slot5 in ipairs(slot0:GetBuffList()) do
		if slot5:GetTrapType() ~= 0 then
			return true
		end
	end

	return false
end

slot0.GetBuffFxList = function (slot0)
	_.each(slot0:GetBuffList(), function (slot0)
		if slot0.config.buff_fx and #slot0.config.buff_fx > 0 then
			table.insert(slot0, slot0.config.buff_fx)
		end
	end)

	return {}
end

slot0.GetWatchingBuff = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(pg.gameset.world_sairenbuff_fleeticon.description) do
		slot1[slot6] = true
	end

	for slot5, slot6 in ipairs(slot0:GetBuffList()) do
		if slot1[slot6.id] then
			return slot6
		end
	end

	return nil
end

slot0.AddDefeatEnemies = function (slot0, slot1)
	if slot1 then
		slot0.defeatEnemies = slot0.defeatEnemies + 1

		slot0:DispatchEvent(slot0.EventUpdateDefeat)
	end
end

slot0.ClearDefeatEnemies = function (slot0)
	slot0.defeatEnemies = 0

	slot0:DispatchEvent(slot0.EventUpdateDefeat)
end

slot0.getDefeatCount = function (slot0)
	return slot0.defeatEnemies
end

slot0.getMapAura = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0:GetShips(true)) do
		slot1 = table.mergeArray(slot1, slot6:GetImportWorldShipVO():getMapAuras())
	end

	return slot1
end

slot0.getMapAid = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0:GetShips(true)) do
		for slot11, slot12 in ipairs(slot7) do
			slot1[slot6] = slot1[slot6] or {}

			table.insert(slot1[slot6], slot12)
		end
	end

	return slot1
end

slot0.outputCommanders = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.commanderIds) do
		table.insert(slot1, {
			pos = slot5,
			id = slot6
		})
	end

	return slot1
end

slot0.getCommanders = function (slot0, slot1)
	slot2 = {}

	if slot1 and slot0:IsCatSalvage() then
	else
		for slot6, slot7 in pairs(slot0.commanderIds) do
			slot2[slot6] = getProxy(CommanderProxy):getCommanderById(slot7)
		end
	end

	return slot2
end

slot0.getCommanderByPos = function (slot0, slot1)
	return slot0:getCommanders()[slot1]
end

slot0.updateCommanderByPos = function (slot0, slot1, slot2)
	if slot2 then
		slot0.commanderIds[slot1] = slot2.id
	else
		slot0.commanderIds[slot1] = nil
	end

	slot0:updateCommanderSkills()
end

slot0.getCommandersAddition = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(CommanderConst.PROPERTIES) do
		slot7 = 0

		for slot11, slot12 in pairs(slot0:getCommanders()) do
			slot7 = slot7 + slot12:getAbilitysAddition()[slot6]
		end

		if slot7 > 0 then
			table.insert(slot1, {
				attrName = slot6,
				value = slot7
			})
		end
	end

	return slot1
end

slot0.getCommandersTalentDesc = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0:getCommanders()) do
		for slot11, slot12 in pairs(slot7) do
			if slot1[slot11] then
				slot1[slot11].value = slot1[slot11].value + slot12.value
			else
				slot1[slot11] = {
					name = slot11,
					value = slot12.value,
					type = slot12.type
				}
			end
		end
	end

	return slot1
end

slot0.findCommanderBySkillId = function (slot0, slot1)
	for slot6, slot7 in pairs(slot2) do
		if _.any(slot7:getSkills(), function (slot0)
			return _.any(slot0:GetTacticSkillForWorld(), function (slot0)
				return slot0 == slot0
			end)
		end) then
			return slot7
		end
	end
end

slot0.updateCommanderSkills = function (slot0)
	slot1 = #slot0.skills

	while slot1 > 0 do
		if not slot0:findCommanderBySkillId(slot0.skills[slot1].id) and slot2:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(slot0.skills, slot1)
		end

		slot1 = slot1 - 1
	end

	for slot6, slot7 in pairs(slot2) do
		for slot11, slot12 in ipairs(slot7:getSkills()) do
			for slot16, slot17 in ipairs(slot12:GetTacticSkillForWorld()) do
				table.insert(slot0.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, slot17))
			end
		end
	end
end

slot0.getSkills = function (slot0)
	return slot0.skills
end

slot0.getSkill = function (slot0, slot1)
	return _.detect(slot0:getSkills(), function (slot0)
		return slot0.id == slot0
	end)
end

slot0.findSkills = function (slot0, slot1)
	return _.filter(slot0:getSkills(), function (slot0)
		return slot0:GetType() == slot0
	end)
end

slot0.IsCatSalvage = function (slot0)
	return slot0.catSalvageFrom and slot0.catSalvageFrom > 0
end

slot0.UpdateCatSalvage = function (slot0, slot1, slot2, slot3)
	slot0.catSalvageStep = slot1
	slot0.catSalvageList = slot2
	slot0.catSalvageFrom = slot3

	if slot0:GetRarityState() == 2 and not nowWorld.isAutoFight then
		nowWorld:GetActiveMap():AddPhaseDisplay({
			story = pg.gameset.world_catsearch_raritytip.description[1]
		})
	end

	slot0:DispatchEvent(slot0.EventUpdateCatSalvage)
end

slot0.IsSalvageFinish = function (slot0)
	return slot0.catSalvageStep == #slot0.catSalvageList
end

function slot1(slot0)
	return pg.world_catsearch_node[slot0].special_drop == 1
end

slot0.GetRarityState = function (slot0)
	if slot0.catSalvageStep == 0 then
		return 0
	end

	if slot0(slot0.catSalvageList[slot0.catSalvageStep]) then
		return 2
	else
		for slot4 = 1, slot0.catSalvageStep - 1, 1 do
			if slot0(slot0.catSalvageList[slot4]) then
				return 1
			end
		end
	end

	return 0
end

slot0.GetSalvageScoreRarity = function (slot0)
	slot1 = 0

	for slot5, slot6 in ipairs(slot0.catSalvageList) do
		slot1 = slot1 + pg.world_catsearch_node[slot6].score
	end

	slot2 = nil

	for slot6, slot7 in ipairs(pg.gameset.world_catsearch_score.description) do
		if slot7 < slot1 then
			slot2 = slot6
		else
			break
		end
	end

	return slot2
end

slot0.GetDisplayCommander = function (slot0)
	slot1 = slot0:getCommanders()

	for slot5 = 1, 2, 1 do
		if slot0.commanderIds[slot5] then
			return getProxy(CommanderProxy):getCommanderById(slot0.commanderIds[slot5])
		end
	end
end

slot0.HasCommander = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.commanderIds) do
		if slot1 == slot6 then
			return true
		end
	end

	return false
end

return slot0

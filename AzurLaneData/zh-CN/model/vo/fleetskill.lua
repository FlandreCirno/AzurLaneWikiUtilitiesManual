slot0 = class("FleetSkill", import(".BaseVO"))
slot0.SystemCommanderNeko = 1
slot0.TypeMoveSpeed = "move_speed"
slot0.TypeHuntingLv = "hunt_lv"
slot0.TypeAmbushDodge = "ambush_dodge"
slot0.TypeAirStrikeDodge = "airfight_doge"
slot0.TypeStrategy = "strategy"
slot0.TypeBattleBuff = "battle_buff"
slot0.TypeAttack = "attack"
slot0.TypeTorpedoPowerUp = "torpedo_power_up"
slot0.TriggerDDCount = "dd_count"
slot0.TriggerDDHead = "dd_head"
slot0.TriggerAroundEnemy = "around_enemy"
slot0.TriggerVanCount = "vang_count"
slot0.TriggerNekoPos = "pos"
slot0.TriggerAroundLand = "around_land"
slot0.TriggerAroundCombatAlly = "around_combat_ally"
slot0.TriggerShipCount = "count"
slot0.TriggerInSubTeam = "insubteam"

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.system = slot1
	slot0.id = slot2
	slot0.configId = slot0.id
end

slot0.GetSystem = function (slot0)
	return slot0.system
end

slot0.bindConfigTable = function (slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return pg.commander_skill_effect_template
	end
end

slot0.GetType = function (slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return slot0:getConfig("effect_type")
	end
end

slot0.GetArgs = function (slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return slot0:getConfig("args")
	end
end

slot0.GetTriggers = function (slot0)
	if slot0:GetSystem() == slot0.SystemCommanderNeko then
		return slot0:getConfig("condition")
	end
end

slot0.triggerSkill = function (slot0, slot1)
	slot3 = _.reduce(slot2, nil, function (slot0, slot1)
		slot3 = slot1:GetArgs()

		if slot1:GetType() == FleetSkill.TypeBattleBuff then
			table.insert(slot0 or {}, slot3[1])

			return slot0 or 
		end
	end)

	return slot3, _.filter(slot0:findSkills(slot1), function (slot0)
		return _.any(slot1, function (slot0)
			return slot0[1] == FleetSkill.TriggerInSubTeam and slot0[2] == 1
		end) == slot0.getFleetType(slot3) == FleetType.Submarine and _.all(slot0:GetTriggers(), function (slot0)
			return slot0.NoneChapterFleetCheck(slot0.NoneChapterFleetCheck, , slot0)
		end)
	end)
end

slot0.NoneChapterFleetCheck = function (slot0, slot1, slot2)
	slot4 = getProxy(BayProxy)

	if slot2[1] == FleetSkill.TriggerDDCount then
		slot5 = slot4:getShipByTeam(slot0, TeamType.Vanguard)

		return slot2[2] <= #_.filter(fleetShips, function (slot0)
			return slot0:getShipType() == ShipType.QuZhu
		end) and slot6 <= slot2[3]
	elseif slot3 == FleetSkill.TriggerDDHead then
		return #slot4.getShipByTeam(slot4, slot0, TeamType.Vanguard) > 0 and slot5[1]:getShipType() == ShipType.QuZhu
	elseif slot3 == FleetSkill.TriggerVanCount then
		return slot2[2] <= #slot4:getShipByTeam(slot0, TeamType.Vanguard) and #slot5 <= slot2[3]
	elseif slot3 == FleetSkill.TriggerShipCount then
		return slot2[3] <= #_.filter(slot4:getShipsByFleet(slot0), function (slot0)
			return table.contains(slot0[2], slot0:getShipType())
		end) and #slot5 <= slot2[4]
	elseif slot3 == FleetSkill.TriggerNekoPos then
		slot5 = slot0.findCommanderBySkillId(slot0, slot1.id)

		for slot9, slot10 in pairs(slot0:getCommanders()) do
			if slot5.id == slot10.id and slot9 == slot2[2] then
				return true
			end
		end
	elseif slot3 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

slot0.triggerMirrorSkill = function (slot0, slot1)
	slot3 = _.reduce(slot2, nil, function (slot0, slot1)
		slot3 = slot1:GetArgs()

		if slot1:GetType() == FleetSkill.TypeBattleBuff then
			table.insert(slot0 or {}, slot3[1])

			return slot0 or 
		end
	end)

	return slot3, _.filter(slot0:findSkills(slot1), function (slot0)
		return _.any(slot1, function (slot0)
			return slot0[1] == FleetSkill.TriggerInSubTeam and slot0[2] == 1
		end) == slot0.getFleetType(slot3) == FleetType.Submarine and _.all(slot0:GetTriggers(), function (slot0)
			return slot0.MirrorFleetCheck(slot0.MirrorFleetCheck, , slot0)
		end)
	end)
end

slot0.MirrorFleetCheck = function (slot0, slot1, slot2)
	slot4 = getProxy(BayProxy)

	if slot2[1] == FleetSkill.TriggerDDCount then
		slot5 = slot0:getShipsByTeam(TeamType.Vanguard, false)

		return slot2[2] <= #_.filter(fleetShips, function (slot0)
			return slot0:getShipType() == ShipType.QuZhu
		end) and slot6 <= slot2[3]
	elseif slot3 == FleetSkill.TriggerDDHead then
		return #slot0.getShipsByTeam(slot0, TeamType.Vanguard, false) > 0 and slot5[1]:getShipType() == ShipType.QuZhu
	elseif slot3 == FleetSkill.TriggerVanCount then
		return slot2[2] <= #slot0:getShipsByTeam(TeamType.Vanguard, false) and #slot5 <= slot2[3]
	elseif slot3 == FleetSkill.TriggerShipCount then
		return slot2[3] <= #_.filter(slot0:getShips(false), function (slot0)
			return table.contains(slot0[2], slot0:getShipType())
		end) and #slot5 <= slot2[4]
	elseif slot3 == FleetSkill.TriggerNekoPos then
		slot5 = slot0.findCommanderBySkillId(slot0, slot1.id)

		for slot9, slot10 in pairs(slot0:getCommanders()) do
			if slot5.id == slot10.id and slot9 == slot2[2] then
				return true
			end
		end
	elseif slot3 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

slot0.GuildBossTriggerSkill = function (slot0, slot1)
	slot3 = _.reduce(slot2, nil, function (slot0, slot1)
		slot3 = slot1:GetArgs()

		if slot1:GetType() == FleetSkill.TypeBattleBuff then
			table.insert(slot0 or {}, slot3[1])

			return slot0 or 
		end
	end)

	return slot3, _.filter(slot0:findSkills(slot1), function (slot0)
		slot4 = slot0:GetShips()

		return _.any(slot1, function (slot0)
			return slot0[1] == FleetSkill.TriggerInSubTeam and slot0[2] == 1
		end) == slot0.getFleetType(slot3) == FleetType.Submarine and _.all(slot0:GetTriggers(), function (slot0)
			return slot0.GuildBossFleetCheck(slot0.GuildBossFleetCheck, , , slot0)
		end)
	end)
end

slot0.GuildBossFleetCheck = function (slot0, slot1, slot2, slot3)
	function slot5()
		for slot4, slot5 in ipairs(slot0) do
			if slot5.ship.getTeamType(slot6) == TeamType.Vanguard then
				table.insert(slot0, slot6)
			end
		end

		return slot0
	end

	if slot3[1] == FleetSkill.TriggerDDCount then
		return slot3[2] <= #_.filter(slot1, function (slot0)
			return slot0.ship.getShipType(slot1) == ShipType.QuZhu
		end) and slot6 <= slot3[3]
	elseif slot4 == FleetSkill.TriggerDDHead then
		return #slot5() > 0 and slot6[1]:getShipType() == ShipType.QuZhu
	elseif slot4 == FleetSkill.TriggerVanCount then
		return slot3[2] <= #slot5() and #slot6 <= slot3[3]
	elseif slot4 == FleetSkill.TriggerShipCount then
		return slot3[3] <= #_.filter(slot1, function (slot0)
			return table.contains(slot0[2], slot0.ship:getShipType())
		end) and #slot6 <= slot3[4]
	elseif slot4 == FleetSkill.TriggerNekoPos then
		slot6 = slot0.findCommanderBySkillId(slot0, slot2.id)

		for slot10, slot11 in pairs(slot0:getCommanders()) do
			if slot6.id == slot11.id and slot10 == slot3[2] then
				return true
			end
		end
	elseif slot4 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

return slot0

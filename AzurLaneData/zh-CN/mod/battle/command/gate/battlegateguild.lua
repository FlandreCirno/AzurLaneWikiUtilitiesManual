slot0 = class("BattleGateGuild")
ys.Battle.BattleGateGuild = slot0
slot0.__name = "BattleGateGuild"

slot0.Entrance = function (slot0, slot1)
	if getProxy(PlayerProxy):getRawData().oil < pg.guildset.use_oil.key_value then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	slot4 = slot0.GetGuildBossMission()
	slot5 = slot4:GetMyShipIds()
	slot7 = {}

	for slot11, slot12 in ipairs(slot6) do
		table.insert(slot7, {
			ship_id = slot12.shipID,
			user_id = slot12.userID
		})
	end

	BeginStageCommand.SendRequest(SYSTEM_GUILD, slot5, {
		slot4:GetStageID()
	}, function (slot0)
		slot2 = getProxy(GuildProxy)
		slot3 = slot2:getData()

		slot3:getMemberById(slot2.id).AddLiveness(slot5, slot4)
		slot2:updateGuild(slot3)
		slot3:sendNotification(GAME.BEGIN_STAGE_DONE, {
			prefabFleet = {},
			bossId = slot0.id,
			actId = slot0.id,
			stageId = slot1,
			system = SYSTEM_GUILD,
			token = slot0.key
		})
	end, function (slot0)
		slot0:RequestFailStandardProcess(slot0)
	end, slot7)
end

slot0.Exit = function (slot0, slot1)
	slot2 = getProxy(FleetProxy)
	slot3 = slot0.statistics._battleScore
	slot4 = pg.guildset.use_oil.key_value
	slot5 = {}
	slot8 = {}

	for slot12, slot13 in pairs(slot0.GetGuildBossMission().GetMainFleet(slot6).getCommanders(slot7)) do
		table.insert(slot8, slot13.id)
	end

	for slot13, slot14 in ipairs(slot9) do
		table.insert(slot5, slot14.ship)
	end

	if slot0.statistics.submarineAid then
		if slot6:GetSubFleet() then
			for slot15, slot16 in ipairs(slot11) do
				if slot0.statistics[slot16.ship.id] then
					table.insert(slot5, slot17)
				end
			end

			for slot15, slot16 in pairs(slot10:getCommanders()) do
				table.insert(slot8, slot16.id)
			end
		else
			print("finish stage error: can not find submarin fleet.")
		end
	end

	slot10 = 0
	slot11 = 0

	for slot15, slot16 in ipairs(slot5) do
		if slot10 < slot0.statistics[slot16.id].output then
			slot11 = slot16.id
			slot10 = slot17.output
		end
	end

	slot0:GeneralPackage(slot5).commander_id_list = slot8

	slot0.SendRequest(slot1, slot0.GeneralPackage(slot5), function (slot0)
		slot0.statistics.mvpShipID = slot0.statistics
		slot1, slot2 = slot0.statistics:GeneralLoot(slot0)

		slot0.GeneralPlayerCosume(SYSTEM_GUILD, ys.Battle.BattleConst.BattleScore.C < slot0, , slot0.player_exp, exFlag)
		slot5.UpdateGuildBossMission()
		slot2:sendNotification(GAME.FINISH_STAGE_DONE, {
			system = SYSTEM_GUILD,
			statistics = slot0.statistics,
			score = ys.Battle.BattleConst.BattleScore.C < slot0,
			drops = slot1,
			commanderExps = slot2.GenerateCommanderExp(slot0, slot2.GenerateCommanderExp),
			result = slot0.result,
			extraDrops = slot2
		})
	end)
end

slot0.SendRequest = function (slot0, slot1, slot2)
	pg.ConnectionMgr.GetInstance():Send(40003, slot1, 40004, function (slot0)
		if slot0.result == 0 or slot0.result == 1030 then
			slot0(slot0)
		elseif slot0.result == 20 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("guild_battle_result_boss_is_death"),
				onYes = function ()
					pg.m02:sendNotification(GAME.QUIT_BATTLE)
				end
			})
		elseif slot0.result == 4 then
			pg.m02.sendNotification(slot1, GAME.QUIT_BATTLE)
		else
			slot1:RequestFailStandardProcess(slot0)
		end
	end)
end

slot0.GetGuildBossMission = function ()
	return getProxy(GuildProxy):getData().GetActiveEvent(slot0):GetBossMission()
end

slot0.UpdateGuildBossMission = function ()
	slot0 = getProxy(GuildProxy)
	slot1 = slot0:getData()

	slot1:GetActiveEvent().GetBossMission(slot2).ReduceDailyCnt(slot3)
	slot0:ResetBossRankTime()
	slot0:ResetRefreshBossTime()
	slot0:updateGuild(slot1)
end

slot0.GeneralPlayerCosume = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = getProxy(PlayerProxy)
	slot6 = slot5:getData()

	slot6:addExp(slot3)
	slot6:consume({
		gold = 0,
		oil = slot2
	})
	slot5:updatePlayer(slot6)
end

slot0.GeneralPackage = function (slot0, slot1)
	slot2 = 0
	slot3 = {}
	slot4 = {}
	slot8 = slot0.system + slot0.stageId + slot0.statistics._battleScore
	slot9 = getProxy(PlayerProxy):getRawData().id

	for slot13, slot14 in ipairs(slot1) do
		if slot0.statistics[slot14.id] then
			table.insert((GuildAssaultFleet.GetUserId(slot15.id) ~= slot9 and slot4) or slot3, {
				ship_id = GuildAssaultFleet.GetRealId(slot15.id),
				hp_rest = math.floor(slot15.bp),
				damage_cause = math.floor(slot15.output),
				damage_caused = math.floor(slot15.damage),
				max_damage_once = math.floor(slot15.maxDamageOnce),
				ship_gear_score = math.floor(slot15.gearScore)
			})

			slot8 = slot8 + GuildAssaultFleet.GetRealId(slot15.id) + math.floor(slot15.bp) + math.floor(slot15.output) + math.floor(slot15.maxDamageOnce)
			slot2 = slot2 + slot14:getShipCombatPower()
		end
	end

	slot10, slot11 = GetBattleCheckResult(slot8, slot0.token, slot0.statistics._totalTime)
	slot12 = {}

	for slot16, slot17 in ipairs(slot0.statistics._enemyInfoList) do
		table.insert(slot12, {
			enemy_id = slot17.id,
			damage_taken = slot17.damage,
			total_hp = slot17.totalHp
		})
	end

	return {
		system = slot5,
		data = slot6,
		score = slot7,
		key = slot10,
		statistics = slot3,
		otherstatistics = slot4,
		kill_id_list = slot0.statistics.kill_id_list,
		total_time = slot0.statistics._totalTime,
		bot_percentage = slot0.statistics._botPercentage,
		extra_param = slot2,
		file_check = slot11,
		enemy_info = slot12,
		data2 = {}
	}
end

return slot0

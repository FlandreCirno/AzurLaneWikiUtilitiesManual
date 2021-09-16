slot0 = class("BattleGateWorldBoss")
ys.Battle.BattleGateWorldBoss = slot0
slot0.__name = "BattleGateWorldBoss"

slot0.Entrance = function (slot0, slot1)
	if BeginStageCommand.DockOverload() then
		return
	end

	slot2 = slot0.actID
	slot3 = getProxy(PlayerProxy)
	slot4 = getProxy(BayProxy)
	slot5 = pg.battle_cost_template[SYSTEM_WORLD_BOSS]
	slot6 = true
	slot7 = {}
	slot8 = 0
	slot9 = 0

	for slot17, slot18 in ipairs(slot13) do
		slot7[#slot7 + 1] = slot18
	end

	ships = slot4:getSortShipsByFleet(slot12)
	slot8 = 0
	slot9 = 0
	slot14 = slot3:getData()
	slot16 = nowWorld:GetBossProxy()
	slot17 = slot16:GetBossById(slot15)
	slot18 = slot17:GetStageID()

	if slot16:IsSelfBoss(slot17) and slot17:GetSelfFightCnt() > 0 then
		slot9 = slot17:GetOilConsume()
	end

	if slot6 and slot14.oil < slot9 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	slot1.ShipVertify()
	BeginStageCommand.SendRequest(SYSTEM_WORLD_BOSS, slot7, {
		slot15
	}, function (slot0)
		if slot0 then
			slot1:consume({
				gold = 0,
				oil = slot1
			})
		end

		if slot3.enter_energy_cost > 0 and not exFlag then
			slot1 = pg.gameset.battle_consume_energy.key_value

			for slot5, slot6 in ipairs(ships) do
				slot6:cosumeEnergy(slot1)
				slot4:updateShip(slot6)
			end
		end

		if slot5:IsSelfBoss(slot6) then
			slot6:IncreaseFightCnt()
		else
			slot5:reducePt()
			slot5:LockCacheBoss(slot7)
		end

		slot8:updatePlayer(slot8.updatePlayer)
		slot11:sendNotification(GAME.BEGIN_STAGE_DONE, {
			prefabFleet = {},
			bossId = slot7,
			actId = slot9,
			stageId = slot10,
			system = SYSTEM_WORLD_BOSS,
			token = slot0.key,
			bossLevel = slot6:GetLevel(),
			bossConfigId = slot6:GetConfigID()
		})
	end, function (slot0)
		function slot1()
			slot0:UnlockCacheBoss()
			slot0.UnlockCacheBoss:RemoveCacheBoss(slot1.id)
			pg.m02:sendNotification(GAME.WORLD_BOSS_START_BATTLE_FIALED)
		end

		if slot0.result == 1 then
			pg.TipsMgr.GetInstance().ShowTips(slot2, i18n("world_boss_none"))
			slot1()
		elseif slot0.result == 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			slot1()
		elseif slot0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_max_challenge_cnt"))
			slot1()
		elseif slot0.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
			slot1()
		elseif slot0.result == 9997 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_maintenance"))
			slot1()
		else
			slot2:RequestFailStandardProcess(slot0)
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

slot0.Exit = function (slot0, slot1)
	if slot1.CheaterVertify() then
		return
	end

	slot2 = pg.battle_cost_template[SYSTEM_WORLD_BOSS]
	slot3 = slot0.statistics._battleScore
	slot4 = 0
	slot5 = {}
	slot8 = nowWorld.GetBossProxy(slot6).GetFleet(slot7)
	gold = slot8:getEndCost().gold
	slot4 = slot8.getEndCost().oil
	stageId = slot0.bossId
	slot10 = slot1.GeneralPackage(slot0, slot5)
	slot11 = {}

	for slot15, slot16 in ipairs(slot0.statistics._enemyInfoList) do
		table.insert(slot11, {
			enemy_id = slot16.id,
			damage_taken = slot16.damage,
			total_hp = slot16.totalHp
		})
	end

	slot10.enemy_info = slot11

	slot1.SendRequest(slot1, slot10, function (slot0)
		slot3, slot2 = slot0:GeneralLoot(slot0)

		if slot1.end_sink_cost > 0 then
			slot0.DeadShipEnergyCosume(slot2, slot0.DeadShipEnergyCosume)
		end

		slot0.addShipsExp(slot0.ship_exp_list, slot2.statistics, accumulate)

		slot4 = nowWorld.GetBossProxy(slot3)
		slot5 = slot4:GetBossById(slot2.bossId)

		slot4:ClearRank(slot5.id)
		pg.m02:sendNotification(GAME.WORLD_BOSS_BATTLE_QUIT, {
			id = slot2.bossId
		})

		slot2.statistics.mvpShipID = slot0.mvp

		slot0:sendNotification(GAME.FINISH_STAGE_DONE, {
			system = SYSTEM_WORLD_BOSS,
			statistics = slot2.statistics,
			score = slot4,
			drops = slot1,
			commanderExps = {},
			result = slot0.result,
			extraDrops = slot2,
			bossId = slot2.bossId,
			name = slot5:GetName()
		})
		slot4:UnlockCacheBoss()
	end)
end

return slot0

slot0 = class("BattleGateWorld")
ys.Battle.BattleGateWorld = slot0
slot0.__name = "BattleGateWorld"

slot0.Entrance = function (slot0, slot1)
	if BeginStageCommand.DockOverload() then
		nowWorld:TriggerAutoFight(false)

		return
	end

	slot2 = getProxy(PlayerProxy)
	slot3 = getProxy(BayProxy)
	slot5 = pg.battle_cost_template[SYSTEM_WORLD].oil_cost > 0
	slot6 = {}
	slot7 = 0
	slot8 = 0
	slot9 = 0
	slot10 = 0

	for slot18, slot19 in ipairs(slot14) do
		slot6[#slot6 + 1] = slot19.id
	end

	slot15, slot16 = slot13:GetCost()
	slot7 = slot15.gold
	slot8 = slot15.oil
	slot9 = slot15.gold + slot16.gold
	slot10 = slot15.oil + slot16.oil
	slot17 = slot2:getData()

	if slot5 and slot17.oil < slot10 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))

		return
	end

	slot20 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(slot19).fleet_prefab

	slot1.ShipVertify()
	BeginStageCommand.SendRequest(SYSTEM_WORLD, slot6, {
		slot0.stageId
	}, function (slot0)
		if slot0 then
			slot1:consume({
				gold = 0,
				oil = slot1
			})
		end

		if slot3.enter_energy_cost > 0 and not exFlag then
			slot1 = pg.gameset.battle_consume_energy.key_value

			for slot5, slot6 in ipairs(slot4) do
				slot6:cosumeEnergy(slot1)
				slot5:updateShip(slot6)
			end
		end

		slot6:updatePlayer(slot6.updatePlayer)
		slot9:sendNotification(GAME.BEGIN_STAGE_DONE, {
			prefabFleet = slot7,
			stageId = slot8,
			system = SYSTEM_WORLD,
			token = slot0.key
		})
	end, function (slot0)
		slot0:RequestFailStandardProcess(slot0)
	end)
end

slot0.Exit = function (slot0, slot1)
	if slot1.CheaterVertify() then
		return
	end

	slot2 = pg.battle_cost_template[SYSTEM_WORLD]
	slot3 = slot0.statistics._battleScore
	slot4 = 0
	slot5 = {}
	slot8 = nowWorld.GetActiveMap(slot6).GetFleet(slot7)
	slot5 = slot8:GetShipVOs(true)
	slot9, slot10 = slot8:GetCost()
	slot4 = slot10.oil

	if slot0.statistics.submarineAid then
		for slot16, slot17 in ipairs(slot12) do
			if slot0.statistics[slot17.id] then
				table.insert(slot5, slot17)
			end
		end

		slot13, slot14 = slot11:GetCost()
		slot4 = slot4 + slot14.oil
	end

	slot1.SendRequest(slot1, slot1.GeneralPackage(slot0, slot5), function (slot0)
		if slot0.end_sink_cost > 0 then
			slot1.DeadShipEnergyCosume(slot2, slot3)
		end

		slot1.addShipsExp(slot0.ship_exp_list, slot2.statistics, true)

		slot0.statistics.mvpShipID = slot0.mvp
		slot2, slot3 = slot1:GeneralLoot(slot0)

		slot1.GeneralPlayerCosume(SYSTEM_WORLD, ys.Battle.BattleConst.BattleScore.C < slot5, , slot0.player_exp, exFlag)

		slot2.hpDropInfo = slot0.hp_drop_info

		slot1:sendNotification(GAME.FINISH_STAGE_DONE, slot5)
		slot1:WriteBack(ys.Battle.BattleConst.BattleScore.C < slot5, slot2)
	end)
end

return slot0

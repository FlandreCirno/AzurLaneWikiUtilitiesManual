slot0 = class("BattleGateScenario")
ys.Battle.BattleGateScenario = slot0
slot0.__name = "BattleGateScenario"

slot0.Entrance = function (slot0, slot1)
	if BeginStageCommand.DockOverload() then
		getProxy(ChapterProxy):StopAutoFight()

		return
	end

	slot2 = getProxy(PlayerProxy)
	slot3 = getProxy(BayProxy)
	slot5 = pg.battle_cost_template[SYSTEM_SCENARIO].oil_cost > 0
	slot6 = {}
	slot7 = 0
	slot8 = 0
	slot9 = 0
	slot10 = 0

	for slot18, slot19 in ipairs(slot14) do
		slot6[#slot6 + 1] = slot19.id
	end

	slot15 = slot12:GetExtraCostRate()
	slot16, slot17 = slot12:getFleetCost(slot13)
	slot7 = slot16.gold
	slot8 = slot16.oil
	slot9 = slot16.gold + slot17.gold
	slot10 = slot16.oil + slot17.oil
	slot18 = slot2:getData()

	if slot5 and slot18.oil < slot10 then
		getProxy(ChapterProxy):StopAutoFight()

		if not ItemTipPanel.ShowOilBuyTip(slot10) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("stage_beginStage_error_noResource"))
		end

		return
	end

	slot21 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(slot20).fleet_prefab

	slot1.ShipVertify()

	slot22 = nil

	if slot12:getPlayType() == ChapterConst.TypeExtra then
		slot22 = true
	end

	BeginStageCommand.SendRequest(SYSTEM_SCENARIO, slot6, {
		slot19
	}, function (slot0)
		if slot0 then
			slot1:consume({
				gold = 0,
				oil = slot1
			})
		end

		if slot3.enter_energy_cost > 0 and not slot4 then
			slot1 = pg.gameset.battle_consume_energy.key_value * slot5

			for slot5, slot6 in ipairs(slot6) do
				if slot7:getShipById(slot6) then
					slot7:cosumeEnergy(slot1)
					slot7:updateShip(slot7)
				end
			end
		end

		slot8:updatePlayer(slot8.updatePlayer)
		slot11:sendNotification(GAME.BEGIN_STAGE_DONE, {
			prefabFleet = slot9,
			stageId = slot10,
			system = SYSTEM_SCENARIO,
			token = slot0.key,
			exitCallback = slot0.exitCallback
		})
	end, function (slot0)
		slot0:RequestFailStandardProcess(slot0)
		getProxy(ChapterProxy):StopAutoFight()
	end)
end

slot0.Exit = function (slot0, slot1)
	if slot1.CheaterVertify() then
		return
	end

	slot2 = pg.battle_cost_template[SYSTEM_SCENARIO]
	slot3 = getProxy(FleetProxy)
	slot5 = slot0.statistics._battleScore
	slot6 = 0
	slot7 = 0
	slot8 = {}

	for slot15, slot16 in ipairs(slot11) do
		table.insert(slot8, slot16)
	end

	slot12, slot13 = slot9:getFleetCost(slot10)
	slot6 = slot13.gold
	slot7 = slot13.oil
	slot14 = slot9:GetExtraCostRate()

	if slot0.statistics.submarineAid then
		if _.detect(slot9.fleets, function (slot0)
			return slot0:getFleetType() == FleetType.Submarine and slot0:isValid()
		end) then
			for slot20, slot21 in ipairs(slot16) do
				if slot0.statistics[slot21.id] then
					table.insert(slot8, slot21)

					slot7 = slot7 + slot21:getEndBattleExpend() * slot14
				end
			end
		else
			print("finish stage error: can not find submarine fleet.")
		end
	end

	slot9:writeBack(ys.Battle.BattleConst.BattleScore.C < slot5, slot0)
	slot4:updateChapter(slot9)
	slot1.SendRequest(slot1, slot1.GeneralPackage(slot0, slot8), function (slot0)
		if slot0:getPlayType() == ChapterConst.TypeExtra.end_sink_cost > 0 and not slot1 then
			slot2.DeadShipEnergyCosume(slot3, slot4)
		end

		slot2.addShipsExp(slot0.ship_exp_list, slot3.statistics, true)

		slot2 = slot2.addShipsExp.GenerateCommanderExp(slot0, true:getActiveChapter().fleet)
		slot0.statistics.mvpShipID = slot0.mvp
		slot6, slot5.extraDrops = slot2:GeneralLoot(slot0)

		slot2.GeneralPlayerCosume(SYSTEM_SCENARIO, , , slot0.player_exp, slot1)
		slot2:sendNotification(GAME.FINISH_STAGE_DONE, slot5)
		slot5:updateActiveChapterShips()

		slot6 = slot5:getActiveChapter()

		slot6:writeDrops(slot3)

		slot7 = slot5:getLastUnlockMap().id

		slot5:updateChapter(slot6)

		slot8 = slot5:getLastUnlockMap().id

		if Map.lastMap and slot8 ~= slot7 and slot7 < slot8 then
			Map.autoNextPage = true
		end
	end)
end

return slot0

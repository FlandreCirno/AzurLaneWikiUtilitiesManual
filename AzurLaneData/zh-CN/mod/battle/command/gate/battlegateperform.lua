slot0 = class("BattleGatePerform")
ys.Battle.BattleGatePerform = slot0
slot0.__name = "BattleGatePerform"

slot0.Entrance = function (slot0, slot1)
	slot4 = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(pg.expedition_data_template[slot0.stageId].dungeon_id).fleet_prefab or {}
	slot5 = {}

	if slot0.mainFleetId then
		slot6 = getProxy(BayProxy)
		slot7 = getProxy(FleetProxy)

		if not slot1.LegalFleet(slot0.mainFleetId) then
			return
		end

		for slot13, slot14 in ipairs(slot9) do
			slot5[#slot5 + 1] = slot14.id
		end
	end

	slot6 = {
		stageId = slot2,
		system = SYSTEM_PERFORM,
		memory = slot0.memory,
		exitCallback = slot0.exitCallback,
		prefabFleet = slot4,
		mainFleetId = slot0.mainFleetId
	}

	if slot0.memory then
		slot1:sendNotification(GAME.BEGIN_STAGE_DONE, slot6)
	else
		BeginStageCommand.SendRequest(SYSTEM_PERFORM, slot5, {
			slot2
		}, function (slot0)
			slot1 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(slot0)

			slot1:sendNotification(GAME.STORY_UPDATE, {
				storyId = tostring(slot1)
			})

			slot1.sendNotification.token = slot0.key

			slot1:sendNotification(GAME.BEGIN_STAGE_DONE, slot1.sendNotification)
		end, function (slot0)
			slot0:RequestFailStandardProcess(slot0)
		end)
	end
end

slot0.Exit = function (slot0, slot1)
	if slot0.memory then
		slot1:sendNotification(GAME.FINISH_STAGE_DONE, {
			system = SYSTEM_PERFORM
		})
	else
		slot1.SendRequest(slot1, slot1.GeneralPackage(slot0, {}), function (slot0)
			slot0:sendNotification(GAME.FINISH_STAGE_DONE, {
				system = SYSTEM_PERFORM,
				exitCallback = slot1.exitCallback
			})
		end, function (slot0)
			slot0:RequestFailStandardProcess(slot0)
		end)
	end
end

return slot0
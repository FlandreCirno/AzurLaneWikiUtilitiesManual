slot0 = class("BattleGateRewardPerform")
ys.Battle.BattleGateRewardPerform = slot0
slot0.__name = "BattleGateRewardPerform"

slot0.Entrance = function (slot0, slot1)
	slot1:sendNotification(GAME.BEGIN_STAGE_DONE, {
		prefabFleet = ys.Battle.BattleDataFunction.GetDungeonTmpDataByID(slot3).fleet_prefab,
		stageId = slot0.stageId,
		system = SYSTEM_REWARD_PERFORM
	})
end

slot0.Exit = function (slot0, slot1)
	slot2 = slot0
	slot5 = nil

	for slot9 = 1, #getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_EXPEDITION).data1_list, 1 do
		if bit.rshift(slot4[slot9], 4) == slot2.stageId then
			slot5 = slot9

			break
		end
	end

	slot1:sendNotification(GAME.ACTIVITY_OPERATION, {
		cmd = 3,
		activity_id = slot3 and slot3.id,
		statistics = slot2.statistics,
		arg1 = slot2.statistics._battleScore,
		arg2 = slot5
	})
end

return slot0

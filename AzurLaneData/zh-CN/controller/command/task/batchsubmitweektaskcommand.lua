class("BatchSubmitWeekTaskCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot4 = slot2.callback
	slot5 = slot2.dontSendMsg
	slot7 = getProxy(TaskProxy).GetWeekTaskProgressInfo(slot6)

	if #slot2.ids <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20108, {
		id = slot3
	}, 20109, function (slot0)
		if slot0.result == 0 then
			table.insert(slot1, Item.New({
				type = slot0:GetSubTask(slot1[1]).GetAward(slot2)[1],
				id = slot0.GetSubTask(slot1[1]).GetAward(slot2)[2],
				count = slot0.pt
			}))
			slot0:RemoveSubTasks(slot1)
			slot0:AddProgress(slot0.pt)

			for slot7, slot8 in ipairs(slot0.next) do
				slot0:AddSubTask(WeekPtTask.New(slot8))
			end

			if not slot2 then
				slot3:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK_DONE, {
					awards = slot1,
					ids = slot1
				})
			end

			if slot4 then
				slot4(slot1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("BatchSubmitWeekTaskCommand", pm.SimpleCommand)

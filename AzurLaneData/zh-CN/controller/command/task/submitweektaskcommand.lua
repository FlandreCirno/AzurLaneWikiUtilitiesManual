class("SubmitWeekTaskCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not getProxy(TaskProxy).GetWeekTaskProgressInfo(slot4):GetSubTask(slot1:getBody().id) or not slot6:IsFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20106, {
		id = slot3
	}, 20107, function (slot0)
		if slot0.result == 0 then
			slot2 = slot0:GetAward()

			table.insert(slot1, Item.New({
				type = slot2[1],
				id = slot2[2],
				count = slot2[3]
			}))
			slot1:AddProgress(slot2[3])
			slot1:RemoveSubTask(slot2)

			if slot0.next and slot0.next.id ~= 0 then
				slot1:AddSubTask(WeekPtTask.New(slot0.next))
			end

			slot3:sendNotification(GAME.SUBMIT_WEEK_TASK_DONE, {
				awards = slot1,
				id = slot2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("SubmitWeekTaskCommand", pm.SimpleCommand)

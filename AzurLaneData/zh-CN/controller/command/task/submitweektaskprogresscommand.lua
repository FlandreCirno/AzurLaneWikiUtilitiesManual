class("SubmitWeekTaskProgressCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if not getProxy(TaskProxy).GetWeekTaskProgressInfo(slot3):CanUpgrade() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20110, {
		id = 0
	}, 20111, function (slot0)
		if slot0.result == 0 then
			slot1 = {}

			for slot5, slot6 in ipairs(slot0.award_list) do
				table.insert(slot1, slot7)
				slot0:sendNotification(GAME.ADD_ITEM, Item.New({
					type = slot6.type,
					id = slot6.id,
					count = slot6.number
				}))
			end

			slot1:Upgrade()
			slot0:sendNotification(GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE, {
				awards = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("SubmitWeekTaskProgressCommand", pm.SimpleCommand)

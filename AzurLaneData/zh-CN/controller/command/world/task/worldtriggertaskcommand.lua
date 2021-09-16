class("WorldTriggerTaskCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().portId
	slot6 = nowWorld.GetTaskProxy(slot5)
	slot7, slot8 = WorldTask.canTrigger(slot3)

	if not slot7 then
		pg.TipsMgr.GetInstance():ShowTips(slot8)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33205, {
		taskId = slot3
	}, 33206, function (slot0)
		if slot0.result == 0 then
			if slot0 then
				slot1 = nowWorld:GetActiveMap():GetPort()

				table.removebyvalue(slot2, slot1)
				slot1:UpdateTaskIds(underscore.rest(slot1.taskIds, 1))
			end

			slot1 = WorldTask.New(slot0.task)
			slot1.new = 1

			1:addTask(slot1)

			if #slot1.config.task_op > 0 then
				pg.NewStoryMgr.GetInstance():Play(slot1.config.task_op, nil, true)
			end

			slot3:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
				task = slot1
			})
		elseif slot0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_refuse1"))
		else
			pg.TipsMgr.GetInstance():ShowTips("trigger task fail" .. slot0.result)
		end
	end)
end

return class("WorldTriggerTaskCommand", pm.SimpleCommand)

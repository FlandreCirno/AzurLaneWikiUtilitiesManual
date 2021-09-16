class("TriggerTaskCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getType()

	pg.ConnectionMgr.GetInstance():Send(20007, {
		id = slot1:getBody()
	}, 20008, function (slot0)
		if slot0.result == 0 then
			getProxy(TaskProxy):addTask(Task.New({
				id = slot0
			}))
			getProxy(TaskProxy).addTask:sendNotification(GAME.TRIGGER_TASK_DONE)

			if getProxy(TaskProxy).addTask then
				slot2(true)
			end
		elseif slot2 then
			slot2(false)
		end
	end)
end

return class("TriggerTaskCommand", pm.SimpleCommand)

class("TaskOneStepSubmitOPCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if #slot1:getBody().resultList > 0 then
		slot4 = {}
		slot5 = {}

		for slot9, slot10 in ipairs(slot3) do
			if slot10.isWeekTask then
				table.insert(slot5, slot10.id)
			else
				table.insert(slot4, slot10)
			end
		end

		slot6 = {}

		seriesAsync({
			function (slot0)
				if #slot0 > 0 then
					pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
						resultList = pg.m02.sendNotification,
						callback = slot0
					})
				else
					slot0()
				end
			end,
			function (slot0)
				if #slot0 > 0 then
					slot1:emit(TaskMediator.ON_BATCH_SUBMIT_WEEK_TASK, slot0, slot0)
				else
					slot0()
				end
			end
		})
	end
end

return class("TaskOneStepSubmitOPCommand", pm.SimpleCommand)

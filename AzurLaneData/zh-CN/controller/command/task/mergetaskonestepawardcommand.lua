class("MergeTaskOneStepAwardCommand", pm.SimpleCommand).execute = function (slot0, slot1)
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

		function slot7(slot0)
			for slot4, slot5 in ipairs(slot0) do
				table.insert(slot0, slot5)
			end
		end

		seriesAsync({
			function (slot0)
				if #slot0 <= 0 then
					slot0()

					return
				end

				slot1:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
					dontSendMsg = true,
					resultList = slot0,
					callback = function (slot0)
						slot0(slot0)
						slot0()
					end
				})
			end,
			function (slot0)
				if #slot0 <= 0 then
					slot0()

					return
				end

				slot1:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK, {
					dontSendMsg = true,
					ids = slot0,
					callback = function (slot0)
						slot0(slot0)
						slot0()
					end
				})
			end
		}, function ()
			_.map.sendNotification(slot1, GAME.MERGE_TASK_ONE_STEP_AWARD_DONE, {
				awards = slot1,
				taskIds = _.map(_.map, function (slot0)
					return slot0.id
				end)
			})
		end)
	end
end

return class("MergeTaskOneStepAwardCommand", pm.SimpleCommand)

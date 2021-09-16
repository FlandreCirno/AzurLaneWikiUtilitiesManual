class("ActivityCollectionEventCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot3 = slot2.arg1
	slot4 = slot2.onConfirm
	slot5 = slot2.callBack
	slot6 = getProxy(EventProxy)

	if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT) or slot8:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = slot8.id,
		cmd = slot2.cmd,
		arg1 = slot2.arg1,
		arg2 = slot2.arg2,
		arg_list = slot2.arg_list
	}, 11203, function (slot0)
		if slot0.result == 0 then
			if slot0.cmd == ActivityConst.COLLETION_EVENT_OP_JOIN then
				EventStartCommand.OnStart(EventStartCommand.OnStart)

				if EventStartCommand.OnStart then
					slot2()
				end

				if slot3 then
					slot3()
				end
			elseif slot0.cmd == ActivityConst.COLLETION_EVENT_OP_SUBMIT then
				table.insert(slot4.data1_list, table.insert)
				slot5:updateActivity(slot4)

				if table.indexof(slot2, slot1) < slot2:getDayIndex() and slot4 <= #slot2 then
					table.insert(slot1, {
						finish_time = 0,
						over_time = 0,
						id = slot2[slot4],
						ship_id_list = {},
						activity_id = slot4.id
					})
				end

				EventFinishCommand.OnFinish(slot1, {
					exp = slot0.number[1],
					drop_list = slot0.award_list,
					new_collection = slot1,
					is_cri = slot0.number[2]
				}, slot3)

				if slot2 then
					slot2()
				end
			elseif slot0.cmd == ActivityConst.COLLETION_EVENT_OP_GIVE_UP then
				EventGiveUpCommand.OnCancel(EventGiveUpCommand.OnCancel)

				if table.indexof(slot2, slot1) < slot2:getDayIndex() and slot4 <= #slot2 then
					table.insert(slot1, {
						finish_time = 0,
						over_time = 0,
						id = slot2[slot4],
						ship_id_list = {},
						activity_id = slot4.id
					})
				end

				if #slot1 > 0 then
					slot5, slot8 = slot6:findInfoById(slot1)

					table.remove(slot6.eventList, slot6)

					for slot10, slot11 in ipairs(slot1) do
						table.insert(slot6.eventList, EventInfo.New(slot11))
					end
				end

				if slot2 then
					slot2()
				end

				if slot3 then
					slot3()
				end

				pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("ActivityCollectionEventCommand", pm.SimpleCommand)

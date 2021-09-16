class("ActivityNewPtOPCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback

	if not getProxy(ActivityProxy):getActivityById(slot1.getBody().activity_id) or slot5:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = slot2.activity_id,
		cmd = slot2.cmd or 0,
		arg1 = slot2.arg1 or 0,
		arg2 = slot2.arg2 or 0,
		arg_list = {}
	}, 11203, function (slot0)
		if slot0.result == 0 then
			slot1 = {}

			if slot0.cmd == 1 then
				table.insert(slot1.data1_list, slot0.arg1)

				if slot1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PIZZA_PT and slot0.arg2 and slot0.arg2 > 0 then
					table.insert(slot1.data2_list, slot0.arg2)
				end
			elseif slot0.cmd == 2 then
				slot1.data3 = slot0.number[1]
			elseif slot0.cmd == 3 then
				slot1 = PlayerConst.addTranDrop(slot0.award_list)

				if slot0.arg1 and slot0.arg1 > 0 then
					table.insert(slot1.data2_list, slot0.arg1)
				end

				slot2 = slot0.oldBuffId or 0

				for slot6, slot7 in ipairs(slot1.data3_list) do
					if slot7 == slot2 then
						slot1.data3_list[slot6] = slot0.arg2
					end
				end
			elseif slot0.cmd == 4 then
				for slot6, slot7 in ipairs(slot2) do
					if slot7 <= slot0.arg1 then
						if not table.contains(slot1.data1_list, slot7) then
							table.insert(slot1.data1_list, slot7)
						end
					else
						break
					end
				end
			elseif slot0.cmd == 5 then
				slot1.data1 = slot1.data1 + slot0.number[1]
				slot3 = getProxy(PlayerProxy)
				slot4 = slot3:getRawData()

				slot4:consume({
					[id2res(slot0.arg1)] = slot0.number[1]
				})
				slot3:updatePlayer(slot4)
			end

			slot2:updateActivity(slot1)
			slot2:sendNotification(GAME.ACT_NEW_PT_DONE, {
				awards = slot1,
				callback = GAME.ACT_NEW_PT_DONE
			})
		else
			print(errorTip("", slot0.result))
		end
	end)
end

return class("ActivityNewPtOPCommand", pm.SimpleCommand)

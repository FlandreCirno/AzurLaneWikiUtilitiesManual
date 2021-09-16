class("MonopolyOPCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not getProxy(ActivityProxy):getActivityById(slot1:getBody().activity_id) or slot4:isEnd() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = slot2.activity_id,
		cmd = slot2.cmd,
		arg1 = slot2.arg1,
		arg2 = slot2.arg2,
		arg_list = {}
	}, 11203, function (slot0)
		if slot0.result == 0 then
			slot1 = PlayerConst.addTranDrop(slot0.award_list)

			if slot0.cmd == ActivityConst.MONOPOLY_OP_AWARD then
				slot1.data2_list[2] = slot1.data2_list[2] + 1

				slot2:updateActivity(slot1)
				slot2.updateActivity:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
					awards = slot1
				})
			else
				if slot2 == ActivityConst.MONOPOLY_OP_LAST then
					slot1.data2_list[3] = 1

					if #slot1 > 0 then
						slot3:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = slot1,
							callback = function ()
								return
							end
						})
					end

					if slot0.callback then
						slot0.callback()
					end
				end

				slot3 = {}
				slot4 = ""

				for slot8, slot9 in ipairs(slot0.number) do
					if slot8 > 2 then
						table.insert(slot3, slot9)

						slot4 = slot4 .. "-" .. slot9
					end
				end

				slot5 = slot0.number[1]
				slot6 = slot0.number[2]
				slot7 = (#slot3 > 0 and slot3[#slot3]) or slot1.data2

				if table.contains(slot3, 1) then
					slot1.data1_list[3] = slot1.data1_list[3] + 1
				end

				if slot2 == ActivityConst.MONOPOLY_OP_THROW then
					slot1.data3 = slot5
					slot1.data1_list[2] = slot1.data1_list[2] + 1

					if slot1:getDataConfig("reward_time") > 0 then
						slot1.data2_list[1] = math.floor(slot1.data1_list[2] / slot8)
					else
						slot1.data2_list[1] = 0
					end

					slot2:updateActivity(slot1)

					if slot0.callback then
						slot0.callback(slot5)
					end
				elseif slot2 == ActivityConst.MONOPOLY_OP_MOVE then
					slot1.data3 = slot5
					slot1.data2 = slot7
					slot1.data4 = slot6

					slot2:updateActivity(slot1)

					if slot0.callback then
						slot0.callback(slot5, slot3, slot6)
					end
				elseif slot2 == ActivityConst.MONOPOLY_OP_TRIGGER then
					slot8 = slot0.callback or function ()
						return
					end
					slot1.data3 = slot5
					slot1.data2 = slot7
					slot1.data4 = 0

					slot2.updateActivity(slot9, slot1)

					if #slot1 > 0 then
						slot3:sendNotification(GAME.MONOPOLY_AWARD_DONE, {
							awards = slot1,
							callback = function ()
								slot0(slot1, slot2)
							end
						})
					else
						slot8(slot3, slot6)
					end
				end
			end
		else
			if slot0.callback then
				slot0.callback()
			end

			print("Monopoly Activity erro code" .. slot0.result .. " cmd:" .. slot0.cmd)
		end
	end)
end

return class("MonopolyOPCommand", pm.SimpleCommand)

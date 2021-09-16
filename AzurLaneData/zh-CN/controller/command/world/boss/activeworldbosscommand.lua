class("ActiveWorldBossCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) or slot4:isEnd() then
		return
	end

	print("active boss : ", slot2.arg1)
	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = slot2.activity_id,
		cmd = slot2.cmd,
		arg1 = slot2.arg1,
		arg2 = slot2.arg2
	}, 11203, function (slot0)
		if slot0.result == 0 then
			if slot0.cmd == 1 then
				slot1.data1 = 0

				if slot1.data3 > 0 then
					slot1.data3 = slot1.data3 - 1
				else
					slot1.data2 = slot1.data2 + 1
				end

				print(slot1, "activity  boss", slot1.data3, "data 2:", slot1.data2)
			end

			slot2:updateActivity(slot2.updateActivity)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("ActiveWorldBossCommand", pm.SimpleCommand)

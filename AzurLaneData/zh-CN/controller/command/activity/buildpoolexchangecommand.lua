class("BuildPoolExchangeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not getProxy(ActivityProxy):getActivityById(slot1:getBody().activity_id) or slot4:isEnd() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg1 = 0,
		arg2 = 0,
		cmd = 2,
		activity_id = slot3,
		arg_list = {}
	}, 11203, function (slot0)
		if slot0.result == 0 then
			slot0.data2 = slot0.data2 + 1

			getProxy(ActivityProxy):updateActivity(slot0)
			slot1:sendNotification(GAME.ACTIVITY_BUILD_POOL_EXCHANGE_DONE, {
				awards = PlayerConst.addTranDrop(slot0.award_list)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("BuildPoolExchangeCommand", pm.SimpleCommand)

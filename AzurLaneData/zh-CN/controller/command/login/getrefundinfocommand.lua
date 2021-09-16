class("GetRefundInfoCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(11023, {
		type = 1
	}, 11024, function (slot0)
		if slot0.result == 0 then
			getProxy(PlayerProxy).setRefundInfo(slot1, slot0.shop_info)
			pg.m02:sendNotification(GAME.REFUND_INFO_UPDATE)

			if slot0 and slot0:getBody() and slot0:getBody().callback then
				slot0:getBody().callback()
			end
		end
	end)
end

return class("GetRefundInfoCommand", pm.SimpleCommand)

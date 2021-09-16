class("CheaterMarkCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(10994, {
		type = slot1:getBody().reason
	}, 10995, function (slot0)
		if slot0 ~= CC_TYPE_99 then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 7
			})
		end
	end)
end

return class("CheaterMarkCommand", pm.SimpleCommand)

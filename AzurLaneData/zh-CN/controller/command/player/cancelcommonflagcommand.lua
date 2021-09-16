class("CancelCommonFlagCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(11021, {
		flag_id = slot1:getBody().flagID
	}, 11022, function (slot0)
		if getProxy(PlayerProxy) then
			slot2 = slot1:getData()

			slot2:CancelCommonFlag(slot0)
			slot1:updatePlayer(slot2)
		end
	end)
end

return class("CancelCommonFlagCommand", pm.SimpleCommand)

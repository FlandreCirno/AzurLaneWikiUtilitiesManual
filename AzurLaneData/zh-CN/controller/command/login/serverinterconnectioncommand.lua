slot0 = class("ServerInterconnectionCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot3 = slot1:getBody().user
	slot5 = getProxy(UserProxy)

	slot5:SetDefaultGateway()
	slot5:ActiveGatewaySwitcher()

	function slot6(slot0)
		NetConst.GATEWAY_HOST = slot0.host
		NetConst.GATEWAY_PORT = slot0.port
		NetConst.PROXY_GATEWAY_HOST = slot0.proxyHost
		NetConst.PROXY_GATEWAY_PORT = slot0.proxyPort

		print("switch to:", NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT)
		pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
			user = slot0
		})
	end

	slot8 = slot5
	slot7 = slot5.ShouldSwitchGateway
	slot9 = slot1.getBody().platform or PLATFORM

	if slot7(slot8, slot9, slot3.arg2) then
		if not slot5:GetGateWayByPlatform(slot4 or slot5:GetCacheGatewayFlag()) then
			slot0:GetGateWayByServer(slot7, function (slot0)
				slot0:SetGatewayForPlatform(slot0.SetGatewayForPlatform, slot0)
				slot0:SetCacheGatewayFlag(slot0.SetCacheGatewayFlag)
				slot0(slot0)
			end)
		else
			slot5.SetCacheGatewayFlag(slot5, slot7)
			slot6(slot8)
		end

		return
	end

	pg.m02:sendNotification(GAME.PLATFORM_LOGIN_DONE, {
		user = slot3
	})
end

slot0.GetGateWayByServer = function (slot0, slot1, slot2)
	pg.ConnectionMgr.GetInstance():Connect(NetConst.GATEWAY_HOST, NetConst.GATEWAY_PORT, function ()
		pg.ConnectionMgr.GetInstance():Send(10802, {
			platform = slot0,
			state = NetConst.GatewayState
		}, 10803, function (slot0)
			pg.ConnectionMgr.GetInstance():Disconnect()
			slot0(GatewayInfo.New(slot0.gateway_ip, slot0.gateway_port, (System.String.IsNullOrEmpty(slot0.proxy_ip) and slot0.gateway_ip) or slot0.proxy_ip, (slot3 and slot0.gateway_port) or slot0.proxy_port))
		end)
	end)
end

return slot0

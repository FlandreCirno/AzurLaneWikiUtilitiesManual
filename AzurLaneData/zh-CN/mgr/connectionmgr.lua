pg = pg or {}
pg.ConnectionMgr = singletonClass("ConnectionMgr")
slot2 = createLog("ConnectionMgr", LOG_CONNECTION)
slot3, slot4, slot5, slot6 = nil
slot7 = false
slot8 = {}
slot9, slot10, slot11, slot12 = nil
pg.ConnectionMgr.needStartSend = false
slot13, slot14, slot15, slot16 = nil

pg.ConnectionMgr.Connect = function (slot0, slot1, slot2, slot3, slot4)
	slot0.erroCode = slot4

	slot3.UIMgr.GetInstance():LoadingOn()
	slot2.onConnected:AddListener(function ()
		slot0.UIMgr.GetInstance():LoadingOff()
		slot0.UIMgr.GetInstance()("Network Connected.")
		print("connect success.")

		slot2 = slot3
		slot4 = slot5
		slot0 = slot6 or slot0.SendWindow.New(slot7, 0)

		slot8.onData:AddListener(slot6.onData)

		if PLATFORM_CODE == PLATFORM_CHT then
			slot9 = slot0.IPAddress.New()
		end

		slot10 = -1
		slot11 = true
		slot12 = false

		slot13()
		slot7:resetHBTimer()
	end)
	slot2.onData.AddListener(slot5, slot0.onData)
	slot2.onError:AddListener(slot0.onError)
	slot2.onDisconnected:AddListener(slot0.onDisconnected)

	slot11 = true

	slot2:Connect()
	print("connect to - " .. slot3 .. ":" .. Connection.New(slot1, slot2))
end

pg.ConnectionMgr.ConnectByProxy = function (slot0)
	VersionMgr.Inst:SetUseProxy(true)

	if slot0:GetLastHost() ~= nil and slot0:GetLastPort() ~= "" then
		print("switch proxy! reason: first connect error")
		slot0:Connect(slot0:GetLastHost(), slot0:GetLastPort(), slot0)
	else
		print("not proxy -> logout")
		print.m02.sendNotification(slot2, GAME.LOGOUT, {
			code = slot2.erroCode or 3
		})
	end
end

pg.ConnectionMgr.ConnectByDomain = function (slot0, slot1, slot2)
	slot0:Connect(LuaHelper.getHostByDomain(slot1), DEFAULT_PORT, slot2)
end

pg.ConnectionMgr.Reconnect = function (slot0, slot1)
	if not slot0 or not slot1 then
		warning("Network is not connected.")

		return
	end

	if slot2 then
		warning("connecting, please wait...")

		return
	end

	slot3 = slot1

	slot0:stopHBTimer()
	slot4:stopTimer()
	print("reconnect --> " .. slot0:GetLastHost() .. ":" .. slot0:GetLastPort())
	slot0:Connect(slot0:GetLastHost(), slot0:GetLastPort(), function ()
		slot0 = getProxy(UserProxy)
		slot1 = slot0:getData()

		if slot0.SdkMgr.GetInstance():GetChannelUID() == "" then
			slot2 = PLATFORM_LOCAL
		end

		if not slot1 or not slot1:isLogin() then
			if slot1.currentCS == 10020 and slot2 ~= DISCONNECT_TIME_OUT then
				slot3.needStartSend = false

				slot1:StartSend()
			else
				slot0.m02:sendNotification(GAME.LOGOUT, {
					code = 3
				})
			end

			return
		end

		slot1:Send(10022, {
			platform = slot2,
			account_id = slot1.uid,
			server_ticket = slot1.token,
			serverid = slot1.server,
			check_key = HashUtil.CalcMD5(slot1.token .. AABBUDUD),
			device_id = slot0.SdkMgr.GetInstance():GetDeviceId()
		}, 10023, function (slot0)
			if slot0.result == 0 then
				print("reconnect success: " .. slot0.user_id, " - ", slot0.server_ticket)

				slot0.token = slot0.server_ticket

				slot0:setLastLogin(slot0)
				slot2()

				if slot0 ~= DISCONNECT_TIME_OUT and slot4:getPacketIdx() > 0 then
					slot5.needStartSend = false

					slot4:Send(11001, {
						timestamp = 1
					}, 11002, function (slot0)
						slot0.TimeMgr.GetInstance():SetServerTime(slot0.timestamp, slot0.monday_0oclock_timestamp)
						slot0.m02:sendNotification(GAME.CHANGE_CHAT_ROOM, 0)
					end)
					slot6.m02.sendNotification(slot1, GAME.ON_RECONNECTION_GAME)
					WorldConst.ReqWorldForServer()
				elseif slot5.needStartSend then
					slot5.needStartSend = false

					slot4:StartSend()
				end

				slot3 = nil

				if getProxy(PlayerProxy) and slot1:getInited() then
					slot6.SecondaryPWDMgr.GetInstance():FetchData()
				end

				slot6.GuideMgr.GetInstance():onReconneceted()
			else
				print("reconnect failed: " .. slot0.result)
				slot6.m02:sendNotification(GAME.LOGOUT, {
					code = 199,
					tip = slot0.result
				})
			end
		end, false, false)
	end)
end

pg.ConnectionMgr.onDisconnected = function (slot0, slot1)
	slot0("Network onDisconnected: " .. tostring(slot0))

	slot1 = slot1

	if slot0 then
		if not slot0 then
			slot2.onDisconnected:RemoveAllListeners()
		end

		slot2:Dispose()

		slot2 = nil
	end

	if slot0 then
		slot3 = false
	end

	if slot4 then
		slot5.UIMgr.GetInstance():LoadingOff()
	end

	slot4 = false
end

pg.ConnectionMgr.onData = function (slot0)
	if slot0[slot0.cmd] then
		slot1 = slot1.Packer.GetInstance():Unpack(slot0.cmd, slot0:getLuaStringBuffer())

		for slot5, slot6 in ipairs(slot0[slot0.cmd]) do
			slot6(slot1)
		end
	end
end

pg.ConnectionMgr.onError = function (slot0)
	slot0.UIMgr.GetInstance():LoadingOff()
	tostring(slot0)("Network Error: " .. slot0)
	print("connect error: " .. tostring(slot0))

	if "connect error: " .. tostring(slot0) then
		slot2:Dispose()

		slot2 = nil
	end

	function slot1()
		slot0.m02.sendNotification(slot1, GAME.LOGOUT, {
			code = slot1.erroCode or 3
		})
	end

	function slot2()
		return
	end

	if slot4 then
		slot4 = false
		slot2 = slot5
	end

	slot0.ConnectionMgr.GetInstance().CheckProxyCounter(slot3)

	if slot6 and slot7 then
		slot0.ConnectionMgr.GetInstance():stopHBTimer()

		if table.contains({
			"NotSocket"
		}, slot0) then
			slot0.ConnectionMgr.GetInstance():Reconnect(slot2)
		else
			slot0.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				content = i18n("reconnect_tip", slot0),
				onYes = function ()
					slot0.ConnectionMgr.GetInstance():Reconnect(slot0.ConnectionMgr.GetInstance())
				end,
				onNo = slot1,
				weight = LayerWeightConst.TOP_LAYER
			})
			slot0.GuideMgr.GetInstance().onDisconnected(slot4)
		end
	else
		slot0.ConnectionMgr.GetInstance():ConnectByProxy()
	end
end

pg.ConnectionMgr.Send = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	if not slot0 then
		warning("Network is not connected. msgid " .. slot1)
		slot1.m02:sendNotification(GAME.LOGOUT, {
			code = 5
		})

		return
	end

	slot2.Queue(slot8, slot1, slot2, slot3, function (slot0)
		if slot0.result == 9998 then
			slot0.m02:sendNotification(GAME.EXTRA_PROTO_RESULT, {
				result = slot0.result
			})
		else
			slot1(slot0)
		end
	end, slot5, nil, slot6)
end

pg.ConnectionMgr.setPacketIdx = function (slot0, slot1)
	slot0:setPacketIdx(slot1)
end

pg.ConnectionMgr.On = function (slot0, slot1, slot2)
	if slot0[slot1] == nil then
		slot0[slot1] = {}
	end

	table.insert(slot0[slot1], slot2)
end

pg.ConnectionMgr.Off = function (slot0, slot1, slot2)
	if slot0[slot1] == nil then
		return
	end

	if slot2 == nil then
		slot0[slot1] = nil
	else
		for slot6, slot7 in ipairs(slot0[slot1]) do
			if slot7 == slot2 then
				table.remove(slot0[slot1], slot6)

				break
			end
		end
	end
end

pg.ConnectionMgr.Disconnect = function (slot0)
	slot0:stopHBTimer()

	slot0 = {}

	("Manually Disconnect !!!")

	if "Manually Disconnect !!!" then
		slot2:Dispose()

		slot2 = nil
	end

	slot3 = nil
	slot4 = nil
	lastProxyHost = nil
	lastProxyPort = nil
	slot5 = nil
	slot6 = false
end

pg.ConnectionMgr.getConnection = function (slot0)
	return slot0
end

pg.ConnectionMgr.isConnecting = function (slot0)
	return slot0
end

pg.ConnectionMgr.isConnected = function (slot0)
	return slot0
end

pg.ConnectionMgr.stopHBTimer = function (slot0)
	if slot0 then
		slot0:Stop()

		slot0 = nil
	end
end

pg.ConnectionMgr.resetHBTimer = function (slot0)
	slot0:stopHBTimer()
	slot0.Start(slot1)
end

pg.ConnectionMgr.GetPingDelay = function (slot0)
	return slot0
end

slot17 = 0
slot18 = 2
slot19, slot20 = nil

pg.ConnectionMgr.SetProxyHost = function (slot0, slot1, slot2)
	print("Proxy host --> " .. slot1 .. ":" .. slot2)
end

pg.ConnectionMgr.GetLastHost = function (slot0)
	if VersionMgr.Inst:OnProxyUsing() and slot0 ~= nil and slot0 ~= "" then
		return slot0
	end

	return slot1
end

pg.ConnectionMgr.GetLastPort = function (slot0)
	if VersionMgr.Inst:OnProxyUsing() and slot0 ~= nil and slot0 ~= 0 then
		return slot0
	end

	return slot1
end

pg.ConnectionMgr.CheckProxyCounter = function (slot0)
	print("proxyCounter: " .. slot0 + 1)

	if not VersionMgr.Inst:OnProxyUsing() then
		if slot0 ==  then
			print("switch proxy! reason: " .. print .. " error limit")
			VersionMgr.Inst:SetUseProxy(true)
		end
	else
		VersionMgr.Inst:SetUseProxy(false)

		slot0 = 0
	end
end

pg.ConnectionMgr.SwitchProxy = function (slot0)
	if slot0 and slot0:IsSpecialIP() then
		if not VersionMgr.Inst:OnProxyUsing() then
			print("switch proxy! reason: tw specialIP send timeout")
			VersionMgr.Inst:SetUseProxy(true)
		else
			VersionMgr.Inst:SetUseProxy(false)
		end

		slot1.onDisconnected(false, DISCONNECT_TIME_OUT)
	end
end

return

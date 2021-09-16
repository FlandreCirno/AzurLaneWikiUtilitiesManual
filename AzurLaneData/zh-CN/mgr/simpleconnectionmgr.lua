pg = pg or {}
pg.SimpleConnectionMgr = singletonClass("SimpleConnectionMgr")
slot2 = createLog("SimpleConnectionMgr", false)
slot3, slot4 = nil
slot5 = false
slot6 = {}
slot7 = nil

pg.SimpleConnectionMgr.Connect = function (slot0, slot1, slot2, slot3, slot4)
	slot0.stopTimer()
	slot2.UIMgr.GetInstance():LoadingOn()
	slot1.onConnected:AddListener(function ()
		slot0.UIMgr.GetInstance():LoadingOff()
		slot0.UIMgr.GetInstance()("Simple Network Connected.")
		slot4.onData:AddListener(slot2 or slot0.SendWindow.New(slot3, 0).onData)

		slot5 = true
		slot6 = false

		slot7()
	end)
	slot1.onData.AddListener(slot5, slot0.onData)
	slot1.onError:AddListener(slot0.onError)
	slot1.onDisconnected:AddListener(slot0.onDisconnected)

	slot6 = true

	slot1:Connect()

	slot4 = defaultValue(slot4, SEND_TIMEOUT)
	slot0.timer = Timer.New(function ()
		if not slot0 then
			warning("connect timeout error (custom): " .. )
			slot2.stopTimer()
			slot3.onDisconnected(false, DISCONNECT_TIME_OUT)

			if slot2.errorCB then
				slot2.errorCB()
			end
		end
	end, slot4, 1)

	slot0.timer:Start()
end

pg.SimpleConnectionMgr.stopTimer = function ()
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer.Stop.timer = nil
	end
end

pg.SimpleConnectionMgr.onDisconnected = function (slot0, slot1)
	slot0("Simple Network onDisconnected: " .. tostring(slot0))

	if slot1 then
		if not slot0 then
			slot1.onDisconnected:RemoveAllListeners()
		end

		slot1:Dispose()

		slot1 = nil
	end

	if slot0 then
		slot2 = false
	end

	if slot3 then
		slot4.UIMgr.GetInstance():LoadingOff()
	end

	slot3 = false
end

pg.SimpleConnectionMgr.onData = function (slot0)
	if slot0[slot0.cmd] then
		slot1 = slot1.Packer.GetInstance():Unpack(slot0.cmd, slot0:getLuaStringBuffer())

		for slot5, slot6 in ipairs(slot0[slot0.cmd]) do
			slot6(slot1)
		end
	end
end

pg.SimpleConnectionMgr.SetErrorCB = function (slot0, slot1)
	slot0.errorCB = slot1
end

pg.SimpleConnectionMgr.onError = function (slot0)
	slot0.UIMgr.GetInstance():LoadingOff()
	slot0.UIMgr.GetInstance().LoadingOff.stopTimer()
	slot0("Simple Network Error: " .. tostring(slot0))

	if tostring(slot0) then
		slot3:Dispose()

		slot3 = nil
	end

	if slot4 then
		slot4 = false
	end

	if slot1.errorCB then
		slot1.errorCB()
	end
end

pg.SimpleConnectionMgr.Send = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	if not slot0 then
		warning("Simple Network is not connected. msgid " .. slot1)

		return
	end

	slot1:Queue(slot1, slot2, slot3, slot4, slot5, nil, slot6)
end

pg.SimpleConnectionMgr.setPacketIdx = function (slot0, slot1)
	slot0:setPacketIdx(slot1)
end

pg.SimpleConnectionMgr.On = function (slot0, slot1, slot2)
	if slot0[slot1] == nil then
		slot0[slot1] = {}
	end

	table.insert(slot0[slot1], slot2)
end

pg.SimpleConnectionMgr.Off = function (slot0, slot1, slot2)
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

pg.SimpleConnectionMgr.Disconnect = function (slot0)
	slot0 = {}

	("Simple Network Disconnect !!!")

	if "Simple Network Disconnect !!!" then
		slot2:Dispose()

		slot2 = nil
	end

	slot3 = nil
	slot4 = false
end

pg.SimpleConnectionMgr.Reconnect = function (slot0, slot1)
	slot0:Disconnect()

	if slot0.errorCB then
		slot0.errorCB()
	end
end

pg.SimpleConnectionMgr.resetHBTimer = function (slot0)
	return
end

pg.SimpleConnectionMgr.getConnection = function (slot0)
	return slot0
end

pg.SimpleConnectionMgr.isConnecting = function (slot0)
	return slot0
end

pg.SimpleConnectionMgr.isConnected = function (slot0)
	return slot0
end

pg.SimpleConnectionMgr.SwitchProxy = function (slot0)
	return
end

return

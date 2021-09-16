slot0 = class("MiniGameRequestCommand", pm.SimpleCommand)
slot0.REQUEST_HUB_DATA = 1

slot0.execute = function (slot0, slot1)
	slot4 = slot1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(26101, {
		type = slot1.getBody().type
	}, 26102, function (slot0)
		slot1 = getProxy(MiniGameProxy)

		for slot5, slot6 in ipairs(slot0.hubs) do
			slot1:UpdataHubData(slot6)
		end

		if slot0 then
			slot0()
		end

		slot2 = getProxy(MiniGameProxy)

		for slot6, slot7 in ipairs(pg.mini_game.all) do
			slot2:RequestInitData(slot7, true)
		end
	end)
end

return slot0

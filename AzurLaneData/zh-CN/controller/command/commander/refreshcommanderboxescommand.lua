class("RefreshCommanderBoxesCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot3 = getProxy(CommanderProxy)

	pg.ConnectionMgr.GetInstance():Send(25034, {
		type = 0
	}, 25035, function (slot0)
		for slot4, slot5 in ipairs(slot0.box_list) do
			slot0:updateBox(CommanderBox.New(slot5))
		end

		slot1:sendNotification(GAME.REFRESH_COMMANDER_BOXES_DONE)
	end)
end

return class("RefreshCommanderBoxesCommand", pm.SimpleCommand)

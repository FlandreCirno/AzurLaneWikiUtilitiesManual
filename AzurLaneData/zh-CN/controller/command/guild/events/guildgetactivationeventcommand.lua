class("GuildGetActivationEventCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = slot1:getBody().force
	slot4 = slot1.getBody().callback

	if not getProxy(GuildProxy):ShouldFetchActivationEvent() and not slot3 then
		if slot4 then
			slot4()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61005, {
		type = 0
	}, 61006, function (slot0)
		if slot0.result == 0 then
			slot1 = slot0.operation.operation_id

			if slot0:getData():GetActiveEvent() then
				slot3:Deactivate()
			end

			slot2:GetEventById(slot1).Active(slot4, slot0.operation)
			slot0:AddFetchActivationEventCDTime()
			slot0:updateGuild(slot2)
			slot1:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildBossEvent")

			if slot2 then
				slot2()
			end
		else
			if slot0:getData():GetActiveEvent() then
				slot2:Deactivate()
			end

			slot0:updateGuild(slot1)
			slot1:sendNotification(GAME.ON_GUILD_EVENT_END)

			if slot2 then
				slot2()
			end
		end
	end)
end

return class("GuildGetActivationEventCommand", import(".GuildEventBaseCommand"))

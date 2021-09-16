class("GuildJoinMissionCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot4 = slot1:getBody().shipIds

	if not slot1.getBody().id or #slot4 == 0 then
		return
	end

	if not slot0:CanFormationMission(slot3) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61007, {
		event_tid = slot3,
		ship_ids = slot4
	}, 61008, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(GuildProxy)
			slot2 = slot1:getData()
			slot4 = slot2:GetActiveEvent().GetMissionById(slot3, slot0)

			slot4:UpdateFleet(slot5, slot1)
			slot4:UpdateFormationTime(pg.TimeMgr.GetInstance():GetServerTime())
			slot1:updateGuild(slot2)
			slot2:sendNotification(GAME.GUILD_JOIN_MISSION_DONE, {
				id = slot0
			})
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildJoinMissionCommand", import(".GuildEventBaseCommand"))

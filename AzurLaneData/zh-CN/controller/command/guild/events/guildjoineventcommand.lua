class("GuildJoinEventCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	pg.ConnectionMgr.GetInstance():Send(61031, {
		type = 0
	}, 61032, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(GuildProxy)
			slot2 = slot1:getData()

			slot2:GetActiveEvent().IncreaseJoinCnt(slot3)
			slot2:getMemberById(slot5).AddLiveness(slot6, slot4)
			slot1:updateGuild(slot2)
			slot0:sendNotification(GAME.ON_GUILD_JOIN_EVENT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildJoinEventCommand", pm.SimpleCommand)

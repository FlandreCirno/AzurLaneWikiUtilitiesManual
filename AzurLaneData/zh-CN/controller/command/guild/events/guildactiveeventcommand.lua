class("GuildActiveEventCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = getProxy(GuildProxy)

	if not slot0:ExistEvent(slot1:getBody().eventId) then
		return
	end

	if not slot0:NotExistActiveEvent() then
		return
	end

	if not slot0:IsAnim() then
		return
	end

	slot6 = slot3:getData().GetEventById(slot5, slot4)

	if not slot0:CheckCapital(slot6, slot6:GetConsume()) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61001, {
		chapter_id = slot4
	}, 61002, function (slot0)
		if slot0.result == 0 then
			slot0:consumeCapital(slot0.consumeCapital)
			slot0:updateGuild(slot0)
			slot3:sendNotification(GAME.GUILD_ACTIVE_EVENT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildActiveEventCommand", import(".GuildEventBaseCommand"))

class("GuildUpdateNodeAnimFlagCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot4 = slot1:getBody().position

	if not slot0:ExistMission(slot1.getBody().id) then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(61025, {
		perf = {
			{
				event_id = slot3,
				index = slot4
			}
		}
	}, 61026, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(GuildProxy)
			slot2 = slot1:getData()

			slot2:GetActiveEvent().GetMissionById(slot3, slot0).UpdateNodeAnimFlagIndex(slot4, slot1)
			slot1:updateGuild(slot2)
			slot2:sendNotification(GAME.GUILD_UPDATE_NODE_ANIM_FLAG_DONE, {
				id = slot0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildUpdateNodeAnimFlagCommand", import(".GuildEventBaseCommand"))

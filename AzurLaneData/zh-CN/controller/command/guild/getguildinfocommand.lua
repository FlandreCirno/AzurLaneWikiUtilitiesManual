class("GetGuildInfoCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if not getProxy(GuildProxy):getRawData() and not getProxy(GuildProxy).isFetchMainInfo then
		pg.ConnectionMgr.GetInstance():Send(60037, {
			type = 0
		}, 60000, function (slot0)
			getProxy(GuildProxy).isFetchMainInfo = true

			slot0:sendNotification(GAME.GET_GUILD_INFO_DONE)
		end)
	else
		slot0.sendNotification(slot0, GAME.GET_GUILD_INFO_DONE)
	end
end

return class("GetGuildInfoCommand", pm.SimpleCommand)

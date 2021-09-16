class("GuildGetUserInfoCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if not getProxy(GuildProxy):getData() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(60102, {
		type = 0
	}, 60103, function (slot0)
		slot1 = slot0:getData()

		slot1:updateUserInfo(slot0)
		slot0:updateGuild(slot1)
		slot1:sendNotification(GAME.GUILD_GET_USER_INFO_DONE)
	end)
end

return class("GuildGetUserInfoCommand", pm.SimpleCommand)

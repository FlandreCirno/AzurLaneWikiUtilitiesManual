slot0 = class("GetPublicGuildUserDataCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	seriesAsync({
		function (slot0)
			slot0:CreatePublicGuild(slot0)
		end,
		function (slot0)
			slot0:InitPublicGuild(slot0)
		end
	}, function ()
		slot0:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH)
		slot0.sendNotification:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA_DONE)
	end)
end

slot0.CreatePublicGuild = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(62100, {
		type = 0
	}, 62101, function (slot0)
		getProxy(GuildProxy):AddPublicGuild(PublicGuild.New(slot0))
		slot0()
	end)
end

slot0.InitPublicGuild = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(60102, {
		type = 0
	}, 60103, function (slot0)
		getProxy(GuildProxy):GetPublicGuild():InitUser(slot0.user_info)
		slot0()
	end)
end

return slot0

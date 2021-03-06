class("GetGuildBossRankCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(61029, {
		type = 0
	}, 61030, function (slot0)
		slot2 = getProxy(GuildProxy).getRawData(slot1)
		slot3 = {}

		for slot7, slot8 in ipairs(slot0.list) do
			if slot2:getMemberById(slot8.user_id) then
				table.insert(slot3, {
					name = slot9.name,
					damage = slot8.damage
				})
			end
		end

		slot1:UpdateBossRank(slot3)
		slot1:UpdateBossRankRefreshTime(pg.TimeMgr.GetInstance():GetServerTime())

		if slot0 then
			slot0()
		end

		slot1:sendNotification(GAME.GET_GUILD_BOSS_RANK_DONE)
	end)
end

return class("GetGuildBossRankCommand", import(".GuildEventBaseCommand"))

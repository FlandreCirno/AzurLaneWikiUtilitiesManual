class("GetGuildRankCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().id
	slot6 = {}

	if getProxy(GuildProxy).getRawData(slot4).memberCount < 1 then
		slot4:SetRank(slot3, slot6)
	else
		pg.ConnectionMgr.GetInstance():Send(62029, {
			type = slot3
		}, 62030, function (slot0)
			for slot4, slot5 in ipairs(slot0.list) do
				for slot9, slot10 in ipairs(slot5.rankuserinfo) do
					if slot0:getMemberById(slot10.user_id) then
						if not slot1[slot10.user_id] then
							GuildRank.New(slot10.user_id).SetName(slot12, slot11.name)

							slot1[GuildRank.New(slot10.user_id).id] = GuildRank.New(slot10.user_id)
						end

						slot12:SetScore(slot5.period, slot10.count)
					end
				end
			end

			slot2:SetRank(slot3, slot2.SetRank)
			slot4:sendNotification(GAME.GUILD_GET_RANK_DONE, {
				id = slot3,
				list = slot4.sendNotification
			})
		end)
	end
end

return class("GetGuildRankCommand", pm.SimpleCommand)

class("PublicGuildCommitDonateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not getProxy(GuildProxy).GetPublicGuild(slot4):GetDonateTaskById(slot1:getBody().id) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_donate_task"))

		return
	end

	if not slot6:canCommit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not slot5:HasDonateCnt() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_donate_times_not enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62002, {
		id = slot3
	}, 62003, function (slot0)
		if slot0.result == 0 then
			slot1 = {}

			for slot5, slot6 in ipairs(slot0.donate_tasks) do
				table.insert(slot1, GuildDonateTask.New({
					id = slot6
				}))
			end

			slot0:UpdateDonateTasks(slot1)
			slot0:IncDonateCount()

			slot2 = getProxy(PlayerProxy)
			slot3 = slot2:getData()

			slot3:addResources({
				guildCoin = slot1:getConfig("award_contribution")
			})
			slot2:updatePlayer(slot3)

			slot5 = slot1:getCommitItem()

			slot2:sendNotification(GAME.CONSUME_ITEM, Item.New({
				id = slot5[2],
				type = slot5[1],
				count = slot5[3]
			}))
			table.insert(slot6, slot7)
			slot2:sendNotification(GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE, {
				awards = {}
			})
		else
			pg.TipsMgr:GetInstance():ShowTips(errorTip("guild_dissolve_erro", slot0.result))
		end
	end)
end

return class("PublicGuildCommitDonateCommand", pm.SimpleCommand)

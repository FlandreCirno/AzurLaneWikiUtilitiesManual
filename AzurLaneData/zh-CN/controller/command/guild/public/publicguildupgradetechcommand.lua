class("PublicGuildUpgradeTechCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot7 = getProxy(PlayerProxy).getData(slot4)

	if not getProxy(GuildProxy).GetPublicGuild(slot5):GetTechnologyById(slot1:getBody().id) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_not_exist_tech"))

		return
	end

	if slot8:isMaxLevel() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_is_max_level"))

		return
	end

	slot9, slot10 = slot8:GetConsume()

	if slot7.gold < slot10 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_gold_no_enough"))

		return
	end

	if slot7.guildCoin < slot9 then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_tech_guildgold_no_enough"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(62015, {
		id = slot8.id
	}, 62016, function (slot0)
		if slot0.result == 0 then
			slot0:consume({
				gold = slot1,
				guildCoin = slot0
			})
			slot3:updatePlayer(slot0)
			slot4:levelUp()
			slot5:sendNotification(GAME.PULIC_GUILD_UPGRADE_TECH_DONE, {
				id = slot6
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tech_upgrade_done"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("PublicGuildUpgradeTechCommand", pm.SimpleCommand)

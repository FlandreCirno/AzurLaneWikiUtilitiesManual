class("GetGuildShopCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot2.callback
	slot5 = getProxy(PlayerProxy)
	slot6 = getProxy(ShopsProxy)

	if (slot1:getBody().type or 1) == GuildConst.MANUAL_REFRESH and slot5:getData().getResource(slot7, PlayerConst.ResGuildCoin) < slot6:getGuildShop():GetResetConsume() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60033, {
		type = slot3
	}, 60034, function (slot0)
		if slot0.result == 0 then
			slot1 = GuildShop.New(slot0.info)

			if slot0.guildShop then
				slot0:updateGuildShop(slot1, true)
			else
				slot0:setGuildShop(slot1)
			end

			if slot1 == GuildConst.MANUAL_REFRESH then
				slot2 = slot1:GetResetConsume()
				slot3 = slot2:getData()

				slot3:consume({
					guildCoin = slot2
				})
				slot2:updatePlayer(slot3)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_refresh_done"))
			end

			if slot3 then
				slot3(slot1)
			end

			slot4:sendNotification(GAME.GET_GUILD_SHOP_DONE)
		else
			if slot3 then
				slot3()
			end

			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GetGuildShopCommand", pm.SimpleCommand)

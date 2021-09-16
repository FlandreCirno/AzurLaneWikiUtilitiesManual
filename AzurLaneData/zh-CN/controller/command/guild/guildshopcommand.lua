class("GuildShopCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if getProxy(PlayerProxy).getData(slot6).getResource(slot7, 8) < getProxy(ShopsProxy).getGuildShop(slot9).getGoodsById(slot10, slot3).GetPrice(slot11) * #slot1:getBody().selectedId then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not slot11:CanPurchaseCnt(slot5) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_cnt_no_enough"))

		return
	end

	slot13 = {}

	for slot17, slot18 in ipairs(slot4) do
		if not slot13[slot18] then
			slot13[slot18] = {
				count = 1,
				id = slot18
			}
		else
			slot13[slot18].count = slot13[slot18].count + 1
		end
	end

	pg.ConnectionMgr.GetInstance():Send(60035, {
		goodsid = slot11.configId,
		index = slot11.index,
		selected = _.values(slot13)
	}, 60036, function (slot0)
		if slot0.result == 0 then
			slot2 = slot0:getGuildShop()

			slot2:UpdateGoodsCnt(slot1, slot2)
			slot0:updateGuildShop(slot2)
			slot0.updateGuildShop:consume({
				guildCoin = slot4 * slot2
			})
			slot5:updatePlayer(slot5.updatePlayer)
			slot6:sendNotification(GAME.ON_GUILD_SHOP_PURCHASE_DONE, {
				awards = PlayerConst.addTranDrop(slot0.drop_list)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildShopCommand", pm.SimpleCommand)

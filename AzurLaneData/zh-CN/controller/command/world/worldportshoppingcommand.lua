class("WorldPortShoppingCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if slot1:getBody().goods.count <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return
	end

	slot4 = getProxy(PlayerProxy)

	if slot3.moneyItem.type == DROP_TYPE_RESOURCE and slot4:getRawData()[id2res(slot5.id)] < slot5.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", pg.item_data_statistics[id2ItemId(slot5.id)].name))
	end

	if nowWorld.GetInventoryProxy(slot6).GetItemCount(slot7, slot5.id) < slot5.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(33403, {
		shop_id = slot3.id
	}, 33404, function (slot0)
		if slot0.result == 0 then
			slot0:UpdateCount(slot0.count - 1)

			slot2 = slot1:GetActiveMap()
			slot3 = slot2:GetFleet()
			slot4 = slot2:GetPort()
			slot5 = slot2.id

			if slot2.type == DROP_TYPE_RESOURCE then
				slot5 = id2ItemId(slot2.id)
				slot6 = slot3:getData()

				slot6:consume({
					[id2res(shopCfg.resource_type)] = slot2.count
				})
				slot3:updatePlayer(slot6)
			elseif slot2.type == DROP_TYPE_WORLD_ITEM then
				slot4:RemoveItem(slot2.id, slot2.count)
			end

			slot5:sendNotification(GAME.WORLD_PORT_SHOPPING_DONE, {
				drops = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_port_shopping_error_", slot0.result))
		end
	end)
end

return class("WorldPortShoppingCommand", pm.SimpleCommand)

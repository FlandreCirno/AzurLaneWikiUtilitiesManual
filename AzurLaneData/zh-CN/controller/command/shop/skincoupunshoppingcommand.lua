class("SkinCoupunShoppingCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().cnt

	if not getProxy(ActivityProxy):ExistSkinCouponActivityAndShopId(slot1.getBody().shopId) then
		return
	end

	if not _.detect(getProxy(ShipSkinProxy):GetAllSkins(), function (slot0)
		return slot0.id == slot0
	end) then
		pg.TipsMgr.GetInstance().ShowTips(slot7, i18n("common_shopId_noFound"))

		return
	end

	if not slot6:canPurchase() then
		return
	end

	if getProxy(PlayerProxy).getData(slot8)[id2res(slot6:getConfig("resource_type"))] < slot6:GetPrice() then
		GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON).id,
		arg1 = slot3,
		arg2 = slot4,
		arg_list = {}
	}, 11203, function (slot0)
		if slot0.result == 0 then
			slot3 = getProxy(ShipSkinProxy)

			slot3:addSkin(slot4)

			slot5 = slot1:getData()

			slot5:consume({
				[id2res(slot0:getConfig("resource_type"))] = slot2
			})
			slot1:updatePlayer(slot5)
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
			slot3:sendNotification(GAME.SKIN_COUPON_SHOPPING_DONE, {
				id = ShipSkin.New({
					id = slot0:getSkinId()
				}),
				awards = {}
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("SkinCoupunShoppingCommand", pm.SimpleCommand)

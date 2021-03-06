slot0 = class("ShopsProxy", import(".NetProxy"))
slot0.MERITOROUS_SHOP_UPDATED = "ShopsProxy:MERITOROUS_SHOP_UPDATED"
slot0.SHOPPINGSTREET_UPDATE = "ShopsProxy:SHOPPINGSTREET_UPDATE"
slot0.FIRST_CHARGE_IDS_UPDATED = "ShopsProxy:FIRST_CHARGE_IDS_UPDATED"
slot0.CHARGED_LIST_UPDATED = "ShopsProxy:CHARGED_LIST_UPDATED"
slot0.NORMAL_LIST_UPDATED = "ShopsProxy:NORMAL_LIST_UPDATED"
slot0.NORMAL_GROUP_LIST_UPDATED = "ShopsProxy:NORMAL_GROUP_LIST_UPDATED"
slot0.ACTIVITY_SHOP_UPDATED = "ShopsProxy:ACTIVITY_SHOP_UPDATED"
slot0.GUILD_SHOP_ADDED = "ShopsProxy:GUILD_SHOP_ADDED"
slot0.GUILD_SHOP_UPDATED = "ShopsProxy:GUILD_SHOP_UPDATED"
slot0.ACTIVITY_SHOPS_UPDATED = "ShopsProxy:ACTIVITY_SHOPS_UPDATED"
slot0.SHAM_SHOP_UPDATED = "ShopsProxy:SHAM_SHOP_UPDATED"
slot0.FRAGMENT_SHOP_UPDATED = "ShopsProxy:FRAGMENT_SHOP_UPDATED"
slot0.ACTIVITY_SHOP_GOODS_UPDATED = "ShopsProxy:ACTIVITY_SHOP_GOODS_UPDATED"

slot0.register = function (slot0)
	slot0.shopStreet = nil
	slot0.meritorousShop = nil
	slot0.guildShop = nil
	slot0.refreshChargeList = false

	slot0:on(22102, function (slot0)
		getProxy(ShopsProxy):setShopStreet(ShoppingStreet.New(slot0.street))
	end)

	slot0.shamShop = ShamBattleShop.New()
	slot0.fragmentShop = FragmentShop.New()

	slot0.on(slot0, 16200, function (slot0)
		slot0.shamShop:update(pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t").month, slot0.core_shop_list)
		slot0.fragmentShop:update(pg.TimeMgr.GetInstance().STimeDescS(pg.TimeMgr.GetInstance().GetServerTime(), "*t").month, slot0.blue_shop_list, slot0.normal_shop_list)
	end)

	slot0.timers = {}
	slot0.tradeNoPrev = ""
end

slot0.setShopStreet = function (slot0, slot1)
	slot0.shopStreet = slot1

	slot0:sendNotification(slot0.SHOPPINGSTREET_UPDATE, {
		shopStreet = Clone(slot0.shopStreet)
	})
end

slot0.UpdateShopStreet = function (slot0, slot1)
	slot0.shopStreet = slot1
end

slot0.getShopStreet = function (slot0)
	return Clone(slot0.shopStreet)
end

slot0.getMeritorousShop = function (slot0)
	return Clone(slot0.meritorousShop)
end

slot0.addMeritorousShop = function (slot0, slot1)
	slot0.meritorousShop = slot1

	slot0:sendNotification(slot0.MERITOROUS_SHOP_UPDATED, Clone(slot1))
end

slot0.updateMeritorousShop = function (slot0, slot1)
	slot0.meritorousShop = slot1
end

slot0.setNormalList = function (slot0, slot1)
	slot0.normalList = slot1 or {}
end

slot0.GetNormalList = function (slot0)
	return Clone(slot0.normalList)
end

slot0.GetNormalByID = function (slot0, slot1)
	if not slot0.normalList then
		slot0.normalList = {}
	end

	slot0.normalList[slot1] = slot0.normalList[slot1] or Goods.Create({
		buyCount = 0,
		id = slot1
	}, Goods.TYPE_GIFT_PACKAGE)

	return slot0.normalList[slot1]
end

slot0.updateNormalByID = function (slot0, slot1)
	slot0.normalList[slot1.id] = slot1
end

slot0.setNormalGroupList = function (slot0, slot1)
	slot0.normalGroupList = slot1
end

slot0.GetNormalGroupList = function (slot0)
	return slot0.normalGroupList
end

slot0.updateNormalGroupList = function (slot0, slot1, slot2)
	if slot1 <= 0 then
		return
	end

	for slot6, slot7 in ipairs(slot0.normalGroupList) do
		if slot7.shop_id == slot1 then
			slot0.normalGroupList[slot6].pay_count = (slot0.normalGroupList[slot6].pay_count or 0) + slot2

			return
		end
	end

	table.insert(slot0.normalGroupList, {
		shop_id = slot1,
		pay_count = slot2
	})
end

slot0.addActivityShops = function (slot0, slot1)
	slot0.activityShops = slot1

	slot0:sendNotification(slot0.ACTIVITY_SHOPS_UPDATED)
end

slot0.getActivityShopById = function (slot0, slot1)
	return slot0.activityShops[slot1]
end

slot0.updateActivityShop = function (slot0, slot1, slot2)
	slot0.activityShops[slot1] = slot2

	slot0:sendNotification(slot0.ACTIVITY_SHOP_UPDATED, {
		activityId = slot1,
		shop = slot2:clone()
	})
end

slot0.UpdateActivityGoods = function (slot0, slot1, slot2, slot3)
	slot4 = slot0:getActivityShopById(slot1)

	slot4:getGoodsById(slot2).addBuyCount(slot5, slot3)

	slot0.activityShops[slot1] = slot4

	slot0:sendNotification(slot0.ACTIVITY_SHOP_GOODS_UPDATED, {
		activityId = slot1,
		goodsId = slot2
	})
end

slot0.getActivityShops = function (slot0)
	return slot0.activityShops
end

slot0.setFirstChargeList = function (slot0, slot1)
	slot0.firstChargeList = slot1

	slot0:sendNotification(slot0.FIRST_CHARGE_IDS_UPDATED, Clone(slot1))
end

slot0.getFirstChargeList = function (slot0)
	return Clone(slot0.firstChargeList)
end

slot0.setChargedList = function (slot0, slot1)
	slot0.chargeList = slot1

	slot0:sendNotification(slot0.CHARGED_LIST_UPDATED, Clone(slot1))
end

slot0.getChargedList = function (slot0)
	return Clone(slot0.chargeList)
end

slot1 = 3
slot2 = 10

slot0.chargeFailed = function (slot0, slot1, slot2)
	if not slot0.timers[slot1] then
		pg.UIMgr.GetInstance():LoadingOn()

		slot0.timers[slot1] = Timer.New(function ()
			if slot0.timers[slot1].loop == 1 then
				pg.UIMgr.GetInstance():LoadingOff()
			end

			PaySuccess(slot1, slot2)
		end, slot0, slot1)

		slot0.timers[slot1].Start(slot3)
	end
end

slot0.removeChargeTimer = function (slot0, slot1)
	if slot0.timers[slot1] then
		pg.UIMgr.GetInstance():LoadingOff()
		slot0.timers[slot1]:Stop()

		slot0.timers[slot1] = nil
	end
end

slot0.addWaitTimer = function (slot0)
	pg.UIMgr.GetInstance():LoadingOn()

	slot0.waitBiliTimer = Timer.New(function ()
		slot0:removeWaitTimer()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("charge_time_out")
		})
	end, 25, 1)

	slot0.waitBiliTimer.Start(slot1)
end

slot0.removeWaitTimer = function (slot0)
	if slot0.waitBiliTimer then
		pg.UIMgr.GetInstance():LoadingOff()
		slot0.waitBiliTimer:Stop()

		slot0.waitBiliTimer = nil
	end
end

slot0.setGuildShop = function (slot0, slot1)
	slot0.guildShop = slot1

	slot0:sendNotification(slot0.GUILD_SHOP_ADDED, slot0.guildShop)
end

slot0.getGuildShop = function (slot0)
	return slot0.guildShop
end

slot0.updateGuildShop = function (slot0, slot1, slot2)
	slot0.guildShop = slot1

	slot0:sendNotification(slot0.GUILD_SHOP_UPDATED, {
		shop = slot0.guildShop,
		reset = slot2
	})
end

slot0.AddShamShop = function (slot0, slot1)
	slot0.shamShop = slot1

	slot0:sendNotification(slot0.SHAM_SHOP_UPDATED, slot1)
end

slot0.updateShamShop = function (slot0, slot1)
	slot0.shamShop = slot1
end

slot0.getShamShop = function (slot0)
	return slot0.shamShop
end

slot0.AddFragmentShop = function (slot0, slot1)
	slot0.fragmentShop = slot1

	slot0:sendNotification(slot0.FRAGMENT_SHOP_UPDATED, slot1)
end

slot0.updateFragmentShop = function (slot0, slot1)
	slot0.fragmentShop = slot1
end

slot0.getFragmentShop = function (slot0)
	return slot0.fragmentShop
end

slot0.remove = function (slot0)
	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Stop()
	end

	slot0.timers = nil

	slot0:removeWaitTimer()
end

slot0.ShouldRefreshChargeList = function (slot0)
	return not slot0:getFirstChargeList() or not slot0:getChargedList() or not slot0:GetNormalList() or not slot0:GetNormalGroupList() or slot0.refreshChargeList
end

return slot0

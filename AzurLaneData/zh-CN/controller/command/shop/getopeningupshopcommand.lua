slot0 = class("GetOpeningUpShopCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot3 = slot1:getBody() and slot2.callback
	slot0.shopsProxy = getProxy(ShopsProxy)
	slot0.shopList = {}

	parallelAsync({
		function (slot0)
			slot0:GetStressShop(slot0)
		end,
		function (slot0)
			slot0:GetMilitaryShop(slot0)
		end,
		function (slot0)
			slot0:GetShamShop(slot0)
		end,
		function (slot0)
			slot0:GetFragmentShop(slot0)
		end,
		function (slot0)
			slot0:GetActivityShops(slot0)
		end,
		function (slot0)
			slot0:GetGuildShop(slot0)
		end
	}, function ()
		if slot0 then
			slot0(slot1.shopList)
		end
	end)
end

slot0.GetMilitaryShop = function (slot0, slot1)
	slot0.shopList[NewShopsScene.TYPE_MILITARY_SHOP] = {}

	function slot2(slot0)
		table.insert(slot0.shopList[NewShopsScene.TYPE_MILITARY_SHOP], slot0)
		table.insert()
	end

	if not slot0.shopsProxy.getMeritorousShop(slot3) then
		slot0:sendNotification(GAME.GET_MILITARY_SHOP, {
			callback = slot2
		})
	else
		slot2(slot3)
	end
end

slot0.GetStressShop = function (slot0, slot1)
	slot0.shopList[NewShopsScene.TYPE_SHOP_STREET] = {}

	function slot2(slot0)
		table.insert(slot0.shopList[NewShopsScene.TYPE_SHOP_STREET], slot0)
		table.insert()
	end

	if not slot0.shopsProxy.getShopStreet(slot3) then
		slot0:sendNotification(GAME.GET_SHOPSTREET, {
			callback = slot2
		})
	else
		slot2(slot3)
	end
end

slot0.GetGuildShop = function (slot0, slot1)
	function slot2(slot0)
		if slot0 then
			table.insert(slot0.shopList[NewShopsScene.TYPE_GUILD], slot0)
		end

		slot1()
	end

	if not LOCK_GUILD_SHOP then
		slot0.shopList[NewShopsScene.TYPE_GUILD] = {}

		if not slot0.shopsProxy.getGuildShop(slot3) then
			slot0:sendNotification(GAME.GET_GUILD_SHOP, {
				type = GuildConst.GET_SHOP,
				callback = slot2
			})
		else
			slot2(slot3)
		end
	end
end

slot0.GetShamShop = function (slot0, slot1)
	slot2 = slot0.shopsProxy:getShamShop()
	slot3 = not LOCK_SHAM_CHAPTER and slot2 and slot2:isOpen()

	if slot3 then
		slot0.shopList[NewShopsScene.TYPE_SHAM_SHOP] = {}

		table.insert(slot0.shopList[NewShopsScene.TYPE_SHAM_SHOP], slot2)
	end

	slot1()
end

slot0.GetFragmentShop = function (slot0, slot1)
	slot2 = slot0.shopsProxy:getFragmentShop()
	slot3 = not LOCK_FRAGMENT_SHOP and slot2 and slot2:isOpen()

	if slot3 then
		slot0.shopList[NewShopsScene.TYPE_FRAGMENT] = {}

		table.insert(slot0.shopList[NewShopsScene.TYPE_FRAGMENT], slot2)
	end

	slot1()
end

slot0.GetActivityShops = function (slot0, slot1)
	function slot2(slot0)
		if slot0 and table.getCount(slot0) > 0 then
			slot0.shopList[NewShopsScene.TYPE_ACTIVITY] = {}

			for slot4, slot5 in pairs(slot0) do
				table.insert(slot0.shopList[NewShopsScene.TYPE_ACTIVITY], slot5)
			end

			slot1 = getProxy(ActivityProxy):getRawData()

			table.sort(slot0.shopList[NewShopsScene.TYPE_ACTIVITY], function (slot0, slot1)
				return slot0[slot1.activityId].getStartTime(slot3) < slot0[slot0.activityId]:getStartTime()
			end)
		end

		slot1()
	end

	if not slot0.shopsProxy.getActivityShops(slot3) or #slot3 == 0 then
		slot0:sendNotification(GAME.GET_ACTIVITY_SHOP, {
			callback = slot2
		})
	else
		slot2(slot3)
	end
end

return slot0

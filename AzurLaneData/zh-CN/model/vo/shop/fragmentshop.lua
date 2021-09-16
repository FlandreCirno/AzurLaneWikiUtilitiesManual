slot0 = class("FragmentShop", import(".MonthlyShop"))
slot0.GoodsType = Goods.TYPE_FRAGMENT
slot0.type = ShopArgs.ShopFragment

slot0.update = function (slot0, slot1, slot2, slot3)
	slot0.id = slot1
	slot0.configId = slot1
	slot4 = {}

	for slot8, slot9 in ipairs(slot2) do
		slot4[slot9.shop_id] = slot9.pay_count
	end

	for slot8, slot9 in ipairs(slot3) do
		slot4[slot9.shop_id] = slot9.pay_count
	end

	table.clear(slot0.goods)

	if slot0.id and slot0.id > 0 and slot0:getConfigTable() then
		function slot5(slot0, slot1)
			slot1.goods[slot0] = Goods.Create({
				shop_id = slot0,
				buy_count = slot0[slot0] or 0
			}, slot1)
		end

		for slot9, slot10 in ipairs(slot0.getConfig(slot0, "blueprint_shop_goods")) do
			slot5(slot10, Goods.TYPE_FRAGMENT)
		end

		for slot9, slot10 in ipairs(slot0:getConfig("blueprint_shop_limit_goods")) do
			slot5(slot10, Goods.TYPE_FRAGMENT_NORMAL)
		end
	end
end

slot0.Reset = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(slot0:getConfig("blueprint_shop_limit_goods")) do
		if slot0.goods[slot7] then
			table.insert(slot2, {
				shop_id = slot7,
				pay_count = slot8.buyCount
			})
		end
	end

	slot0:update(slot1, {}, slot2)
end

return slot0

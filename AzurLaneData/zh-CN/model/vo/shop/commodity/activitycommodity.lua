slot0 = class("ActivityCommodity", import(".BaseCommodity"))

slot0.bindConfigTable = function (slot0)
	return pg.activity_shop_template
end

slot0.canPurchase = function (slot0)
	if slot0:getConfig("num_limit") == 0 then
		return true
	end

	if slot0:getConfig("commodity_type") == DROP_TYPE_SKIN then
		slot3 = pg.ship_skin_template[slot0:getConfig("commodity_id")]

		if getProxy(ShipSkinProxy):hasSkin(slot0.getConfig("commodity_id")) then
			return false, i18n("common_already owned")
		end

		return slot0.buyCount < slot0:getConfig("num_limit")
	elseif slot1 == DROP_TYPE_FURNITURE then
		return getProxy(DormProxy):getFurnitrueCount(slot2) < pg.furniture_data_template[slot0:getConfig("commodity_id")].count and slot0.buyCount < slot0:getConfig("num_limit")
	else
		return slot0.buyCount < slot0:getConfig("num_limit")
	end
end

slot0.getSkinId = function (slot0)
	if slot0:getConfig("commodity_type") == DROP_TYPE_SKIN then
		return slot0:getConfig("commodity_id")
	end

	return nil
end

slot0.checkCommodityType = function (slot0, slot1)
	return slot0:getConfig("commodity_type") == slot1
end

slot0.GetPurchasableCnt = function (slot0)
	slot2 = slot0:getConfig("commodity_id")

	if slot0:getConfig("commodity_type") == DROP_TYPE_SKIN then
		return (not getProxy(ShipSkinProxy):hasSkin(slot2) or 0) and 1
	elseif slot1 == DROP_TYPE_FURNITURE then
		return math.min(pg.furniture_data_template[slot2].count - getProxy(DormProxy):getFurnitrueCount(slot2), slot0:getConfig("num_limit") - slot0.buyCount)
	else
		return slot0:getConfig("num_limit") - slot0.buyCount
	end
end

return slot0

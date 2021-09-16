slot0 = class("ChargeCommodity", import(".BaseCommodity"))

slot0.bindConfigTable = function (slot0)
	return pg.pay_data_display
end

slot0.isChargeType = function (slot0)
	return true
end

slot0.canPurchase = function (slot0)
	return slot0:getLimitCount() <= 0 or slot0.buyCount < slot1
end

slot0.firstPayDouble = function (slot0)
	return slot0:getConfig("first_pay_double") ~= 0
end

slot0.hasExtraGem = function (slot0)
	return slot0:getConfig("extra_gem") ~= 0
end

slot0.isGiftBox = function (slot0)
	return slot0:getConfig("extra_service") == Goods.GIFT_BOX
end

slot0.isMonthCard = function (slot0)
	return slot0:getConfig("extra_service") == Goods.MONTH_CARD
end

slot0.isGem = function (slot0)
	return slot0:getConfig("extra_service") == Goods.GEM
end

slot0.isItemBox = function (slot0)
	return slot0:getConfig("extra_service") == Goods.ITEM_BOX
end

slot0.getLimitCount = function (slot0)
	return slot0:getConfig("limit_arg")
end

return slot0

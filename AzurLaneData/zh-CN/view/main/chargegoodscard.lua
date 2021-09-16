class("ChargeGoodsCard", import(".GoodsCard")).update = function (slot0, slot1)
	slot0.goodsVO = slot1

	setActive(slot0.mask, not slot0.goodsVO:canPurchase())
	setActive(slot0.stars, false)
	updateDrop(slot0.itemTF, slot1:getDropInfo())
	setText(slot0.nameTxt, shortenString(slot1.getDropInfo().cfg.name or "", 6))

	slot0.discountTextTF = findTF(slot0.discountTF, "Text"):GetComponent(typeof(Text))

	setActive(slot0.discountTF, slot1:isDisCount())

	slot0.discountTextTF.text = slot6 .. "%OFF"
	slot0.countTF.text = math.ceil(slot5)

	GetImageSpriteFromAtlasAsync(pg.item_data_statistics[id2ItemId(slot1:getConfig("resource_type"))].icon, "", tf(slot0.resIconTF))
end

return class("ChargeGoodsCard", import(".GoodsCard"))

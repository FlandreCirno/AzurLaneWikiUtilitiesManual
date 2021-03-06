slot0 = class("ActivityGoodsCard")
slot0.Color = {}
slot0.DefaultColor = {
	0.8745098039215686,
	0.9294117647058824,
	1
}

slot0.Ctor = function (slot0, slot1)
	pg.DelegateInfo.New(slot0)

	slot0.go = slot1
	slot0.tr = tf(slot1)
	slot0.itemTF = findTF(slot0.tr, "item")
	slot0.nameTxt = findTF(slot0.tr, "item/name_mask/name")
	slot0.resIconTF = findTF(slot0.tr, "item/consume/contain/icon"):GetComponent(typeof(Image))
	slot0.mask = slot0.tr:Find("mask")
	slot0.selloutTag = slot0.tr:Find("mask/tag/sellout_tag")
	slot0.countTF = findTF(slot0.tr, "item/consume/contain/Text"):GetComponent(typeof(Text))
	slot0.discountTF = findTF(slot0.tr, "item/discount")

	setActive(slot0.discountTF, false)

	slot0.limitCountTF = findTF(slot0.tr, "item/count_contain/count"):GetComponent(typeof(Text))
	slot0.limitCountLabelTF = findTF(slot0.tr, "item/count_contain/label"):GetComponent(typeof(Text))
	slot0.limitCountLabelTF.text = i18n("activity_shop_exchange_count")
end

slot0.update = function (slot0, slot1, slot2, slot3, slot4)
	slot0.goodsVO = slot1

	setActive(slot0.mask, not slot0.goodsVO:canPurchase())
	setActive(slot0.selloutTag, not slot0.goodsVO.canPurchase())
	updateDrop(slot0.itemTF, {
		type = slot1:getConfig("commodity_type"),
		id = slot1:getConfig("commodity_id"),
		count = slot1:getConfig("num")
	})

	slot9 = ""

	if slot1.getConfig("commodity_type") == DROP_TYPE_SKIN then
		slot9 = pg.ship_skin_template[slot7].name or "??"
	end

	slot0.countTF.text = slot1:getConfig("resource_num")

	if string.match(slot8.cfg.name or "??", "(%d+)") then
		setText(slot0.nameTxt, shortenString(slot9, 5))
	else
		setText(slot0.nameTxt, shortenString(slot9, 6))
	end

	slot10 = nil

	if slot1:getConfig("resource_category") == DROP_TYPE_RESOURCE then
		slot10 = GetSpriteFromAtlas(pg.item_data_statistics[id2ItemId(slot1:getConfig("resource_type"))].icon, "")
	elseif slot11 == DROP_TYPE_ITEM then
		slot10 = GetSpriteFromAtlas(pg.item_data_statistics[slot1:getConfig("resource_type")].icon, "")
	end

	slot0.resIconTF.sprite = slot10

	if slot1:getConfig("num_limit") == 0 then
		slot0.limitCountTF.text = i18n("common_no_limit")
	else
		slot0.limitCountTF.text = math.max(slot13, 0) .. "/" .. slot12
	end

	slot0.limitCountTF.color = slot3 or Color.New(unpack(slot0.Color[slot2] or slot0.DefaultColor))
	slot0.limitCountLabelTF.color = slot3 or Color.New(unpack(slot0.Color[slot2] or slot0.DefaultColor))
	slot4 = slot4 or Color.New(0, 0, 0, 1)

	if GetComponent(slot0.limitCountTF, typeof(Outline)) then
		setOutlineColor(slot0.limitCountTF, slot4)
	end

	if GetComponent(slot0.limitCountLabelTF, typeof(Outline)) then
		setOutlineColor(slot0.limitCountLabelTF, slot4)
	end
end

slot0.setAsLastSibling = function (slot0)
	slot0.tr:SetAsLastSibling()
end

slot0.StaticUpdate = function (slot0, slot1, slot2, slot3)
	slot4 = tf(slot0)
	slot6 = findTF(slot4, "item/name_mask/name")
	slot7 = findTF(slot4, "item/consume/contain/icon"):GetComponent(typeof(Image))
	slot10 = findTF(slot4, "item/consume/contain/Text"):GetComponent(typeof(Text))

	setActive(slot11, false)

	slot12 = findTF(slot4, "item/count_contain/count"):GetComponent(typeof(Text))
	slot13 = findTF(slot4, "item/count_contain/label"):GetComponent(typeof(Text))
	slot14, slot15 = slot1:canPurchase()

	setActive(slot8, not slot14)
	setActive(slot9, not slot14)
	updateDrop(slot5, {
		type = slot1:getConfig("commodity_type"),
		id = slot1:getConfig("commodity_id"),
		count = slot1:getConfig("num")
	})

	slot19 = ""

	if slot1.getConfig("commodity_type") == DROP_TYPE_SKIN then
		slot19 = pg.ship_skin_template[slot17].name or "??"
	end

	slot10.text = slot1:getConfig("resource_num")

	if string.match(slot18.cfg.name or "??", "(%d+)") then
		setText(slot6, shortenString(slot19, 5))
	else
		setText(slot6, shortenString(slot19, 6))
	end

	slot20 = nil

	if slot1:getConfig("resource_category") == DROP_TYPE_RESOURCE then
		slot20 = GetSpriteFromAtlas(pg.item_data_statistics[id2ItemId(slot1:getConfig("resource_type"))].icon, "")
	elseif slot21 == DROP_TYPE_ITEM then
		slot20 = GetSpriteFromAtlas(pg.item_data_statistics[slot1:getConfig("resource_type")].icon, "")
	end

	slot7.sprite = slot20

	if slot1:getConfig("num_limit") == 0 then
		slot12.text = i18n("common_no_limit")
	else
		slot22 = slot1:getConfig("num_limit")

		if slot16 == DROP_TYPE_SKIN and not slot14 then
			slot12.text = "0/" .. slot22
		else
			slot12.text = slot22 - slot1.buyCount .. "/" .. slot22
		end
	end

	slot12.color = slot3 or Color.New(slot0.Color[slot2] or slot0.DefaultColor[1], slot0.Color[slot2] or slot0.DefaultColor[2], slot0.Color[slot2] or slot0.DefaultColor[3], 1)
	slot13.color = slot3 or Color.New(slot0.Color[slot2] or slot0.DefaultColor[1], slot0.Color[slot2] or slot0.DefaultColor[2], slot0.Color[slot2] or slot0.DefaultColor[3], 1)

	if slot1:getConfig("num_limit") >= 99 then
		slot13.text = i18n("shop_label_unlimt_cnt")
		slot12.text = ""
	end
end

slot0.dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
end

return slot0

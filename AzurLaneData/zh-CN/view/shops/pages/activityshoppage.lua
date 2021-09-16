slot0 = class("ActivityShopPage", import(".BaseShopPage"))

slot0.getUIName = function (slot0)
	return "ActivityShop"
end

slot0.GetPaintingName = function (slot0)
	if pg.activity_template[slot0.shop.activityId] and slot1.config_client and slot1.config_client.painting then
		return slot1.config_client.painting
	else
		return "aijiang_pt"
	end
end

slot0.GetBg = function (slot0, slot1)
	return slot1:getBgPath()
end

slot0.GetPaintingEnterVoice = function (slot0)
	slot4, slot3 = slot0.shop:GetEnterVoice()

	return slot2, slot1
end

slot0.GetPaintingCommodityUpdateVoice = function (slot0)
	slot4, slot3 = slot0.shop:GetPurchaseVoice()

	return slot2, slot1
end

slot0.GetPaintingTouchVoice = function (slot0)
	return
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("scrollView/view"), slot0:findTF("tpl"))
	slot0.resIcon = slot0:findTF("res_battery/icon"):GetComponent(typeof(Image))
	slot0.resCnt = slot0:findTF("res_battery/Text"):GetComponent(typeof(Text))
	slot0.resName = slot0:findTF("res_battery/label"):GetComponent(typeof(Text))
	slot0.time = slot0:findTF("Text"):GetComponent(typeof(Text))

	setText(slot0:findTF("tpl/mask/tag/sellout_tag"), i18n("word_sell_out"))
end

slot0.OnInit = function (slot0)
	return
end

slot0.OnUpdatePlayer = function (slot0)
	slot0.resCnt.text = slot0.player:getResource(slot0.shop:getResId())
end

slot0.OnSetUp = function (slot0)
	slot0:InitCommodities()
	slot0:SetResIcon()
end

slot0.OnUpdateAll = function (slot0)
	slot0:InitCommodities()
end

slot0.OnUpdateCommodity = function (slot0, slot1)
	slot3, slot10, slot11 = slot0.shop:getBgPath()

	slot0.cards[slot1.id]:update(slot1, nil, slot4, slot5)
end

slot0.SetResIcon = function (slot0)
	slot0.resIcon.sprite = GetSpriteFromAtlas(pg.item_data_statistics[id2ItemId(slot1)].icon, "")
	slot0.resName.text = pg.item_data_statistics[id2ItemId(slot1)].name
	slot0.time.text = i18n("activity_shop_lable", slot0.shop:getOpenTime())
end

slot0.InitCommodities = function (slot0)
	slot0.cards = {}
	slot2, slot3, slot4 = slot0.shop:getBgPath()

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = ActivityGoodsCard.New(slot2)

			slot4:update(slot3, nil, slot1, slot2)
			onButton(slot3, slot4.tr, function ()
				slot0:OnClickCommodity(slot1.goodsVO, function (slot0, slot1)
					slot0:OnPurchase(slot0, slot1)
				end)
			end, SFX_PANEL)

			slot3.cards[slot0[slot1 + 1].id] = slot4
		end
	end)
	slot0.uilist.align(slot5, #slot0.shop:GetCommodities())
end

slot0.OnPurchase = function (slot0, slot1, slot2)
	slot0:emit(NewShopsMediator.ON_ACT_SHOPPING, slot0.shop.activityId, 1, slot1.id, slot2)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

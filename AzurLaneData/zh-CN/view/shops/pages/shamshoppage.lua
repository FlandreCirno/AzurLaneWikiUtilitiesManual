slot0 = class("ShamShopPage", import(".BaseShopPage"))

slot0.getUIName = function (slot0)
	return "ShamShop"
end

slot0.GetPaintingCommodityUpdateVoice = function (slot0)
	return
end

slot0.CanOpen = function (slot0, slot1, slot2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(slot2.level, "ShamShop")
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("scrollView/view"), slot0:findTF("tpl"))
	slot0.dayTxt = slot0:findTF("time/day"):GetComponent(typeof(Text))
	slot0.nanoTxt = slot0:findTF("res_nano/Text"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	setText(slot0._tf:Find("time"), i18n("title_limit_time"))
	setText(slot0._tf:Find("time/text"), i18n("shops_rest_day"))
	setText(slot0._tf:Find("time/text_day"), i18n("word_date"))
	setText(slot0._tf:Find("tpl/mask/tag/sellout_tag"), i18n("word_sell_out"))
end

slot0.OnUpdateItems = function (slot0)
	if not slot0.items[ChapterConst.ShamMoneyItem] then
		slot0.nanoTxt.text = 0
	else
		slot0.nanoTxt.text = slot2.count
	end
end

slot0.OnSetUp = function (slot0)
	slot0:InitCommodities()

	slot0.dayTxt.text = string.format("%02d", slot0.shop:getRestDays())
end

slot0.OnUpdateAll = function (slot0)
	slot0:OnSetUp()
end

slot0.OnUpdateCommodity = function (slot0, slot1)
	slot0.cards[slot1.id]:update(slot1)
end

slot0.InitCommodities = function (slot0)
	slot0.cards = {}

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			onButton(slot1, slot1:AddCard(slot3, slot2).tr, function ()
				slot0:OnClickCommodity(slot1.goodsVO, function (slot0, slot1)
					slot0:OnPurchase(slot0, slot1)
				end)
			end, SFX_PANEL)

			slot1.cards[slot0[slot1 + 1].id] = slot1.AddCard(slot3, slot2)
		end
	end)
	slot0.uilist.align(slot2, #slot0.shop:GetCommodities())
end

slot0.AddCard = function (slot0, slot1, slot2)
	slot3 = ActivityGoodsCard.New(slot2)

	slot3:update(slot1)

	return slot3
end

slot0.OnPurchase = function (slot0, slot1, slot2)
	slot0:emit(NewShopsMediator.ON_SHAM_SHOPPING, slot1.id, slot2)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

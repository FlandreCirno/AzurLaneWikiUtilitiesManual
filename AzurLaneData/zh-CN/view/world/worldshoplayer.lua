slot0 = class("WorldShopLayer", import("view.base.BaseUI"))
slot0.Listeners = {
	onUpdateGoods = "updateGoods"
}
slot0.optionsPath = {
	"adapt/top/title/option"
}

slot0.getUIName = function (slot0)
	return "WorldShopUI"
end

slot0.init = function (slot0)
	for slot4, slot5 in pairs(slot0.Listeners) do
		slot0[slot4] = function (...)
			slot0[slot1](slot2, ...)
		end
	end

	slot0.btnBack = slot0.findTF(slot0, "adapt/top/title/back_button")
	slot0.rtRes = slot0:findTF("adapt/middle/content/res")
	slot0.rtResetTime = slot0:findTF("adapt/middle/content/resetTimer")
	slot0.rtResetTip = slot0:findTF("adapt/middle/content/resetTip")
	slot0.rtShop = slot0:findTF("adapt/middle/content/world_shop")
	slot0.goodsItemList = UIItemList.New(slot0.rtShop:Find("content"), slot0.rtShop:Find("content/item_tpl"))
	slot0.singleWindow = OriginShopSingleWindow.New(slot0._tf, slot0.event)
	slot0.multiWindow = OriginShopMultiWindow.New(slot0._tf, slot0.event)
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf, {
		groupName = slot0:getGroupNameFromData()
	})
	pg.CriMgr.GetInstance():PlayBGM("story-richang", "sub_layer")
	onButton(slot0, slot0.btnBack, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, slot0.rtRes, function ()
		slot0:emit(slot1.ON_DROP, {
			type = DROP_TYPE_RESOURCE,
			id = WorldConst.ResourceID
		})
	end, SFX_PANEL)
	slot0.goodsItemList.make(slot1, function (slot0, slot1, slot2)
		slot3 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			slot4 = Goods.Create(slot0.goodsList[slot3], Goods.TYPE_WORLD)

			GoodsCard.New(slot2).update(slot5, slot4)
			setText(slot2:Find("item/count_contain/count"), slot4:getLimitCount() - slot4.buyCount .. "/" .. slot6)
			setTextColor(slot2:Find("item/count_contain/count"), Color.New(unpack(ActivityGoodsCard.DefaultColor)))
			setTextColor(slot2:Find("item/count_contain/label"), Color.New(unpack(ActivityGoodsCard.DefaultColor)))
			onButton(slot0, slot2, function ()
				if not slot0:canPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				function slot0(slot0, slot1)
					slot0:emit(WorldShopMediator.BUY_ITEM, slot0.id, slot1)
				end

				if slot2 > 1 then
					slot1.multiWindow.ExecuteAction(slot1, "Open", slot0, slot0)
				else
					slot1.singleWindow:ExecuteAction("Open", slot0, slot0)
				end
			end, SFX_PANEL)
		end
	end)
	slot0.AddWorldListener(slot0)
	slot0:updateGoods(nil, nil, nowWorld:GetWorldShopGoodsDictionary())

	slot1 = nowWorld:IsReseted()

	setActive(slot0.rtResetTime, slot1)
	setActive(slot0.rtResetTip, not slot1)
	setText(slot0.rtResetTime:Find("number"), math.floor(nowWorld:GetResetWaitingTime() / 86400))
	setText(slot0.rtResetTip:Find("info"), i18n("world_shop_preview_tip"))

	if slot1 then
		WorldGuider.GetInstance():PlayGuide("WorldG180")
	end
end

slot0.onBackPressed = function (slot0)
	if slot0.singleWindow:isShowing() then
		slot0.singleWindow:Close()

		return
	end

	if slot0.multiWindow:isShowing() then
		slot0.multiWindow:Close()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(slot0.btnBack)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
	pg.CriMgr.GetInstance():ResumeLastNormalBGM()
	slot0:RemoveWorldListener()
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1

	GetImageSpriteFromAtlasAsync(pg.item_data_statistics[id2ItemId(WorldConst.ResourceID)].icon, "", slot0.rtRes:Find("icon"), true)
	setText(slot0.rtRes:Find("number"), slot0.player:getResource(WorldConst.ResourceID))
end

slot0.AddWorldListener = function (slot0)
	nowWorld:AddListener(World.EventUpdateShopGoods, slot0.onUpdateGoods)
end

slot0.RemoveWorldListener = function (slot0)
	nowWorld:RemoveListener(World.EventUpdateShopGoods, slot0.onUpdateGoods)
end

slot0.updateGoods = function (slot0, slot1, slot2, slot3)
	slot4 = {}

	for slot8, slot9 in pairs(slot3) do
		if slot8 ~= 100000 or nowWorld:IsReseted() then
			table.insert(slot4, {
				id = slot8,
				count = slot9
			})
		end
	end

	table.sort(slot4, function (slot0, slot1)
		return pg.shop_template[slot0.id].order < pg.shop_template[slot1.id].order
	end)

	slot0.goodsList = slot4

	slot0.goodsItemList.align(slot5, #slot0.goodsList)
end

return slot0

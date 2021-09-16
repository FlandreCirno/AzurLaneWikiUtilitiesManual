slot0 = class("ShopMultiWindow", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "ShopsUIMsgbox"
end

slot0.OnLoaded = function (slot0)
	slot0.topItem = slot0:findTF("item")
	slot0.bottomItem = slot0:findTF("got/panel_bg/list/item")
	slot0.maxBtn = slot0:findTF("count/max")
	slot0.leftBtn = slot0:findTF("count/number_panel/left")
	slot0.rightBtn = slot0:findTF("count/number_panel/right")
	slot0.nameTF = slot0:findTF("item/display_panel/name_container/name"):GetComponent(typeof(Text))
	slot0.descTF = slot0:findTF("item/display_panel/desc/Text"):GetComponent(typeof(Text))
	slot0.itemCountTF = slot0:findTF("icon_bg/count", slot0.bottomItem):GetComponent(typeof(Text))
	slot0.countTF = slot0:findTF("count/number_panel/value"):GetComponent(typeof(Text))
	slot0.ownerTF = slot0:findTF("icon_bg/own/Text", slot0.topItem)
	slot0.ownerLabelTF = slot0:findTF("icon_bg/own/label", slot0.topItem)
	slot0.cancelBtn = slot0:findTF("actions/cancel_button")
	slot0.confirmBtn = slot0:findTF("actions/confirm_button")

	setText(slot0:findTF("got/panel_bg/got_text"), i18n("shops_msgbox_output"))
	setText(slot0:findTF("count/image_text"), i18n("shops_msgbox_exchange_count"))
	setText(slot0:findTF("actions/cancel_button/label"), i18n("shop_word_cancel"))
	setText(slot0:findTF("actions/confirm_button/label"), i18n("shop_word_exchange"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Close()
	end, SFX_PANEL)
end

slot0.Open = function (slot0, slot1, slot2)
	slot0.opening = true

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:InitWindow(slot1, slot2)
	slot0:Show()
end

slot0.InitWindow = function (slot0, slot1, slot2)
	slot3 = {
		id = slot1:getConfig("commodity_id"),
		type = slot1:getConfig("commodity_type"),
		count = slot1:getConfig("num")
	}
	slot4, slot5 = getPlayerOwn(slot1:getConfig("resource_category"), slot1:getConfig("resource_type"))
	slot6 = math.max(math.floor(slot5 / slot1:getConfig("resource_num")), 1)

	if slot1:getConfig("num_limit") ~= 0 then
		slot6 = math.min(slot6, math.max(0, slot1:GetPurchasableCnt()))
	end

	function slot7(slot0)
		math.min(math.max(slot0, 1), ).countTF.text = math.min(math.max(slot0, 1), )
		math.min(math.max(slot0, 1), ).countTF.curCount = math.min(math.max(slot0, 1), )
		math.min(math.max(slot0, 1), ).countTF.itemCountTF.text = math.min(math.max(slot0, 1), ) * math.max(slot0, 1):getConfig("num")
	end

	slot7(1)
	updateDrop(slot0.topItem, slot3)
	updateDrop(slot0.bottomItem, slot3)

	slot12, slot12 = GetOwnedpropCount(slot3)

	setActive(slot0.ownerTF.parent, slot9)
	setText(slot0.ownerTF, slot8)
	setText(slot0.ownerLabelTF, i18n("word_own1"))

	slot0.nameTF.text = slot3.cfg.name
	slot0.descTF.text = slot3.desc

	onButton(slot0, slot0.confirmBtn, function ()
		if slot0 then
			slot0(slot1, slot2.curCount, slot3.cfg.name)
		end

		slot2:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0.leftBtn, function ()
		slot0(slot1.curCount - 1)
	end)
	onButton(slot0, slot0.rightBtn, function ()
		slot0(slot1.curCount + 1)
	end)
	onButton(slot0, slot0.maxBtn, function ()
		slot0(slot1)
	end)
end

slot0.Close = function (slot0)
	if slot0.opening then
		pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
		slot0:Hide()

		slot0.opening = false
	end
end

slot0.OnDestroy = function (slot0)
	if slot0.opening then
		slot0:Close()
	end
end

return slot0

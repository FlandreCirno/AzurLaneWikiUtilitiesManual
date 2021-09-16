slot0 = class("FoodMsgBox")
slot1 = pg.shop_template

slot0.Ctor = function (slot0, slot1, slot2)
	slot0._go = slot1
	slot0._tf = tf(slot1)
	slot0.parent = slot0._tf.parent
	slot0.overlay = slot2
	slot0.foodItem = slot0._tf:Find("frame")
	slot0.icon = slot0.foodItem:Find("icon_bg/icon")
	slot0.foodName = slot0._tf:Find("frame/name"):GetComponent(typeof(Text))
	slot0.foodDesc = slot0._tf:Find("frame/desc"):GetComponent(typeof(Text))
	slot0.calPanel = slot0._tf:Find("frame/cal_panel")
	slot0.cancelBtn = slot0._tf:Find("frame/cancel_btn")
	slot0.countValue = slot0.calPanel:Find("value/Text"):GetComponent(typeof(Text))
	slot0.total = slot0.calPanel:Find("total/Text"):GetComponent(typeof(Text))
	slot0.totalIcon = slot0.calPanel:Find("total/icon"):GetComponent(typeof(Image))
	slot0.minusBtn = slot0.calPanel:Find("minus_btn")
	slot0.addBtn = slot0.calPanel:Find("add_btn")
	slot0.tenBtn = slot0.calPanel:Find("ten_btn")
	slot0.confirmBtn = slot0._tf:Find("frame/ok_btn")
	slot0.cancelBtn = slot0._tf:Find("frame/cancel_btn")

	onButton(nil, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(nil, slot0.cancelBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.Show = function (slot0, slot1, slot2)
	setParent(slot0._tf, slot0.overlay)
	setActive(slot0._tf, true)
	slot0:UpdateFood(slot1)

	slot0.total.text = slot0[slot1:getConfig("shop_id")].resource_num * 1
	slot0.totalIcon.sprite = LoadSprite("props/" .. id2res(slot5))
	slot0.countValue.text = 1

	onButton(nil, slot0.minusBtn, function ()
		if slot0 <= 1 then
			return
		end

		slot0 = slot0 - 1
		slot1.countValue.text = slot1.countValue
		slot1.total.text = slot2 * slot1.total
	end, SFX_PANEL)
	onButton(nil, slot0.addBtn, function ()
		if slot0 == 999 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buyCountLimit", pg.TipsMgr.GetInstance().ShowTips))

			return
		end

		slot0 = (slot0 > 999 and 999) or slot0 + 1
		slot0 = slot0
		slot1.countValue.text = slot1.countValue
		slot1.total.text = slot2 * slot1.total
	end, SFX_PANEL)
	onButton(nil, slot0.tenBtn, function ()
		if slot0 == 999 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buyCountLimit", pg.TipsMgr.GetInstance().ShowTips))

			return
		end

		slot0 = (slot0 + 10 >= 999 and 999) or slot0 + 10
		slot0 = slot0
		slot1.countValue.text = slot1.countValue
		slot1.total.text = slot2 * slot1.total
	end, SFX_PANEL)
	onButton(nil, slot0.confirmBtn, function ()
		slot0({
			count = slot1,
			resourceType = slot1,
			resourceNum = slot3,
			shopId = slot4
		})
		slot5._tf:SetSiblingIndex(0)
	end, SFX_CONFIRM)
end

slot0.UpdateFood = function (slot0, slot1)
	slot3 = slot1:getConfig("display")

	updateItem(slot0.foodItem, slot1)

	slot0.foodName.text = slot1:getConfig("name")

	if PLATFORM_CODE == PLATFORM_US then
		setBestFitTextEN(slot0.foodDesc.gameObject, slot3, 28)
	else
		slot0.foodDesc.text = slot3
	end
end

slot0.Hide = function (slot0)
	setActive(slot0._tf, false)
	setParent(slot0._tf, slot0.parent)
end

slot0.Dispose = function (slot0)
	slot0:Hide()
	removeOnButton(slot0.minusBtn)
	removeOnButton(slot0.addBtn)
	removeOnButton(slot0.tenBtn)
	removeOnButton(slot0.confirmBtn)
end

return slot0

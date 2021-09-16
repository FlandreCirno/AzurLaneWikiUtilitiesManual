slot0 = class("ExtendPanel")
slot1 = pg.shop_template

slot0.Ctor = function (slot0, slot1, slot2)
	slot0._go = slot1
	slot0._tf = tf(slot1)
	slot0.parent = slot0._tf.parent
	slot0.overlay = slot2
	slot0.icon = slot0._tf:Find("frame/tip/icon"):GetComponent(typeof(Image))
	slot0.consume = slot0._tf:Find("frame/tip/Text"):GetComponent(typeof(Text))
	slot0.desc = slot0._tf:Find("frame/desc"):GetComponent(typeof(Text))
	slot0.addBtn = slot0._tf:Find("frame/ok_btn")
	slot0.cancelBtn = slot0._tf:Find("frame/cancel_btn")

	onButton(nil, slot0.cancelBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(nil, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.Show = function (slot0, slot1, slot2, slot3)
	setParent(slot0._tf, slot0.overlay)
	setActive(slot0._tf, true)

	slot0.icon.sprite = LoadSprite("props/" .. id2res(slot5))
	slot0.consume.text = slot0[slot1].resource_num
	slot0.desc.text = i18n("backyard_backyardGranaryLayer_foodMaxIncreaseNotice", slot2, slot2 + slot0[slot1].num)

	onButton(nil, slot0.addBtn, function ()
		slot0({
			resType = slot1,
			resCount = slot1,
			shopId = slot3
		})
	end, SFX_CONFIRM)
end

slot0.Hide = function (slot0)
	setActive(slot0._tf, false)
	setParent(slot0._tf, slot0.parent)
end

slot0.Dispose = function (slot0)
	slot0:Hide()
	removeOnButton(slot0.addBtn)
end

return slot0

slot0 = class("BackYardThemeCard")

slot0.Ctor = function (slot0, slot1)
	slot0._go = slot1
	slot0._tf = slot1.transform
	slot0.content = slot0._tf:Find("content")
	slot0.icon = slot0.content:Find("icon"):GetComponent(typeof(Image))
	slot0.discountTF = slot0.content:Find("discount")
	slot0.discountTxt = slot0.discountTF:Find("Text"):GetComponent(typeof(Text))
	slot0.mask = slot0.content:Find("mask")
	slot0.hotTF = slot0.content:Find("hot")
	slot0.newTF = slot0.content:Find("new")
	slot0.selected = slot0.content:Find("benti_s")
	slot0.label = slot0.content:Find("label")
	slot0.maskPurchased = slot0.content:Find("mask1")

	setActive(slot0.mask, false)
	setActive(slot0.maskPurchased, false)
end

slot0.Update = function (slot0, slot1, slot2)
	slot0.themeVO = slot1
	slot0.icon.sprite = GetSpriteFromAtlas("BackYardTheme/" .. slot1.id, "")

	slot0.icon:SetNativeSize()

	slot3 = slot1:GetDiscount()

	setActive(slot0.discountTF, slot1:HasDiscount())

	if slot1.HasDiscount() then
		slot0.discountTxt.text = slot3 .. "%"
	end

	slot5 = false
	slot6 = slot1:getConfig("new") > 0

	if not slot6 then
		setActive(slot0.hotTF, slot1:getConfig("hot") > 0 and not slot2)
		setActive(slot0.newTF, slot6 and not slot2)
		setActive(slot0.label, (not (slot1.getConfig("hot") > 0) and not slot6 and not slot4) or (slot2 and not slot4))
		setActive(slot0.maskPurchased, slot2)

		return
	end
end

slot0.UpdateSelected = function (slot0, slot1)
	slot3 = (not (slot1 and slot1.id == slot0.themeVO.id) or 0) and -170

	if not IsNil(slot0.content) then
		setActive(slot0.selected, slot2)
		setAnchoredPosition(slot0.content, {
			y = slot3
		})
	end

	slot4 = (not slot2 or 0) and 33

	if not IsNil(slot0.maskPurchased) then
		setAnchoredPosition(slot0.maskPurchased, {
			y = slot4
		})
	end
end

return slot0

slot0 = class("BackYardThemeTemplateCard", import("...Shop.cards.BackYardThemeCard"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
	setActive(slot0.discountTF, false)

	slot0.discountTxt.text = ""
	slot0.iconRaw = slot0.content:Find("icon_raw"):GetComponent(typeof(RawImage))

	setActive(slot0.icon.gameObject, false)
	setActive(slot0.hotTF, false)
	setActive(slot0.newTF, false)
	setActive(slot0.label, true)
	setAnchoredPosition(slot0.mask, {
		y = 33
	})

	slot0.pos = slot0.content:Find("pos")
	slot0.posTxt = slot0.pos:Find("Text"):GetComponent(typeof(Text))
end

slot0.FlushData = function (slot0, slot1)
	slot0.template = slot1
	slot0.themeVO = slot1
end

slot0.Update = function (slot0, slot1)
	if slot0.template and slot1.id == slot0.template.id then
		slot0:FlushData(slot1)

		return
	else
		slot0:FlushData(slot1)
		setActive(slot0.iconRaw.gameObject, false)
		BackYardThemeTempalteUtil.GetTexture(slot1:GetTextureIconName(), slot2, function (slot0)
			if not IsNil(slot0.iconRaw) and slot0 then
				setActive(slot0.iconRaw.gameObject, true)

				slot0.iconRaw.texture = slot0
			end
		end)
		setActive(slot0.mask, slot1:IsPushed() and slot1.IsSelfUsage(slot1))
		setActive(slot0.pos, slot1.IsSelfUsage(slot1))

		if slot3 then
			slot4 = slot1.pos

			if slot1.pos <= 9 then
				slot4 = "0" .. slot1.pos
			end

			slot0.posTxt.text = slot4
		end
	end
end

slot0.UpdateSelected = function (slot0, slot1)
	slot0.super.UpdateSelected(slot0, slot1)

	slot3 = (not (slot1 and slot1.id == slot0.themeVO.id) or 0) and 33

	if not IsNil(slot0.mask) then
		setAnchoredPosition(slot0.mask, {
			y = slot3
		})
	end
end

return slot0

slot0 = class("CustomDropdown", import("view.base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "IndexDropdownUI"
end

slot0.Ctor = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.super.Ctor(slot0, slot1, slot2, slot3)

	slot0.tag = slot4
	slot0.virtualBtn = slot5
	slot0.virtualBtnTitle = findTF(slot0.virtualBtn, "Image")
	slot0.virtualBtnDropdownSign = findTF(slot0.virtualBtn, "dropdown")
	slot0.setting = slot0.contextData.customPanels[slot0.tag]
	slot0.mode = slot0.setting.mode or CustomIndexLayer.Mode.OR
	slot0.options = slot0.setting.options
	slot0.names = slot0.setting.names

	slot0:UpdateVirtualBtn()
end

slot0.UpdateVirtualBtn = function (slot0)
	slot0.contextData.indexDatas[slot0.tag] = slot0.contextData.indexDatas[slot0.tag] or slot0.options[1]
	slot0.preIndex = table.indexof(slot0.options, slot0.contextData.indexDatas[slot0.tag])

	setText(slot0.virtualBtnTitle, i18n(slot0.names[slot0.preIndex]))
end

slot0.OnInit = function (slot0)
	slot0.btnTpl = slot0:findTF("resource/tpl")
	slot0.btnList = {}
	slot0.greySprite = slot0:findTF("resource/grey"):GetComponent(typeof(Image)).sprite
	slot0.yellowSprite = slot0:findTF("resource/yellow"):GetComponent(typeof(Image)).sprite
	slot0.mainBtn = tf(instantiate(slot0.btnTpl))
	slot0.mainTitle = slot0:findTF("Image", slot0.mainBtn)

	setImageSprite(slot0.mainBtn, slot0.yellowSprite)
	setParent(slot0.mainBtn, slot0._tf)
	setActive(slot0.mainBtn, true)

	slot0:findTF("dropdown", slot0.mainBtn).localEulerAngles = Vector3.New(0, 0, 0)

	onButton(slot0, slot0.mainBtn, function ()
		slot0:Hide()
	end)
	onButton(slot0, slot1, function ()
		slot0:Hide()
	end)

	slot0.attrs = slot0.findTF(slot0, "Attrs", slot0._tf)
	slot2 = GetComponent(slot0.attrs, typeof(GridLayoutGroup))

	if #slot0.options > 6 then
		slot2.constraintCount = 2
	else
		slot2.constraintCount = 1
	end

	for slot6 = 1, #slot0.options, 1 do
		slot7 = slot0.options[slot6]

		if slot6 == 1 then
		else
			slot8 = tf(instantiate(slot0.btnTpl))
			go(slot8).name = i18n(slot0.names[slot6])

			setActive(slot8, true)
			setActive(slot0:findTF("dropdown", slot8), false)
			setText(slot9, i18n(slot0.names[slot6]))
			setParent(slot8, slot0.attrs)
			onButton(slot0, slot8, function ()
				slot0:UpdateData(slot0)
				slot0.UpdateData:UpdateBtnState()
			end, SFX_UI_TAG)
			table.insert(slot0.btnList, slot8)
		end
	end

	slot0:SelectLast()
end

slot0.SelectLast = function (slot0)
	slot0:UpdateBtnState()
end

slot0.UpdateData = function (slot0, slot1)
	slot3 = bit.band(slot2, slot0.options[slot1]) > 0

	if slot0.mode == CustomIndexLayer.Mode.AND then
		if slot3 then
			slot0.contextData.indexDatas[slot0.tag] = slot2 - slot0.options[slot1]
		else
			slot0.contextData.indexDatas[slot0.tag] = bit.bxor(slot2, slot0.options[slot1])
		end
	elseif slot0.mode == CustomIndexLayer.Mode.OR then
		if slot2 ~= slot0.options[1] and slot3 then
			slot0.contextData.indexDatas[slot0.tag] = slot2 - slot0.options[slot1]
		else
			slot0.contextData.indexDatas[slot0.tag] = slot0.options[slot1]
		end

		if slot0.contextData.indexDatas[slot0.tag] == 0 then
			slot0.contextData.indexDatas[slot0.tag] = slot0.options[1]
		end
	end
end

slot0.UpdateBtnState = function (slot0)
	function slot1(slot0)
		setText(slot0.mainTitle, i18n(slot0.names[slot0]))
		setText(slot0.virtualBtnTitle, i18n(slot0.names[slot0]))
	end

	if slot0.mode == CustomIndexLayer.Mode.AND then
		if slot0.contextData.indexDatas[slot0.tag] == slot0.options[1] then
			for slot5, slot6 in ipairs(slot0.btnList) do
				setImageSprite(slot6, slot0.greySprite)
			end
		else
			for slot5, slot6 in ipairs(slot0.btnList) do
				setImageSprite(slot6, (bit.band(slot0.contextData.indexDatas[slot0.tag], slot0.options[slot5 + 1]) > 0 and slot0.yellowSprite) or slot0.greySprite)
			end
		end

		slot1(1)
	elseif slot0.mode == CustomIndexLayer.Mode.OR then
		slot2 = false

		for slot6, slot7 in ipairs(slot0.btnList) do
			setImageSprite(slot7, (slot0.options[slot6 + 1] == slot0.contextData.indexDatas[slot0.tag] and slot0.yellowSprite) or slot0.greySprite)

			if slot8 then
				slot2 = true

				slot1(slot6 + 1)
			end
		end

		if not slot2 then
			slot1(1)
		end
	end
end

slot0.Show = function (slot0, slot1)
	slot0.attrs.localPosition = slot1
	slot0.mainBtn.anchoredPosition = slot0.attrs.anchoredPosition
	slot0.attrs.anchoredPosition = slot0.attrs.anchoredPosition + Vector2.New(0, -45)

	setActive(slot0._tf, true)
	setActive(slot0.virtualBtnDropdownSign, false)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	setActive(slot0.virtualBtnDropdownSign, true)
end

slot0.OnDestroy = function (slot0)
	slot0.btnList = nil
end

return slot0

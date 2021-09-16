slot0 = class("CustomIndexLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "CustomIndexUI"
end

slot0.Mode = {
	OR = 2,
	AND = 1
}

slot0.init = function (slot0)
	slot0.panel = slot0:findTF("index_panel")
	slot0.layout = slot0:findTF("layout", slot0.panel)
	slot0.panelTemplate = slot0:findTF("Template", slot0.layout)

	setActive(slot0.panelTemplate, false)

	slot1 = slot0.layout:Find("bgpart")
	slot2 = slot0.layout:GetChild(slot0.layout.childCount - 1)

	for slot6 = 0, slot0.layout.childCount - 1, 1 do
		setActive(slot0.layout:GetChild(slot6), false)
	end

	setActive(slot1, true)
	setActive(slot2, true)

	slot0.displayList = {}
	slot0.typeList = {}
	slot0.btnConfirm = slot0:findTF("layout/btns/ok", slot0.panel)
	slot0.btnCancel = slot0:findTF("layout/btns/cancel", slot0.panel)

	setText(slot0:findTF("Image", slot0.btnConfirm), i18n("text_confirm"))
	setText(slot0:findTF("Image", slot0.btnCancel), i18n("text_cancel"))

	slot0.greySprite = slot0:findTF("resource/grey", slot0.panel):GetComponent(typeof(Image)).sprite
	slot0.blueSprite = slot0:findTF("resource/blue", slot0.panel):GetComponent(typeof(Image)).sprite
	slot0.yellowSprite = slot0:findTF("resource/yellow", slot0.panel):GetComponent(typeof(Image)).sprite
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.btnConfirm, function ()
		if slot0.contextData.callback then
			slot0.contextData.callback(slot0.contextData.indexDatas)

			slot0.contextData.callback.contextData.callback = nil
		end

		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(slot0, slot0.btnCancel, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("btn", slot0.panel), function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)

	slot0.panel.localScale = Vector3.zero

	LeanTween.scale(slot0.panel, Vector3(1, 1, 1), 0.2)
	slot0.InitGroup(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.InitGroup = function (slot0)
	slot0.onInit = true
	slot0.contextData.indexDatas = slot0.contextData.indexDatas or {}
	slot0.dropdownDic = {}
	slot0.updateList = {}

	for slot4, slot5 in ipairs(slot0.contextData.groupList) do
		if slot5.dropdown then
			slot0:InitDropdown(slot5)
		else
			slot0:InitCustoms(slot5)
		end
	end

	for slot4, slot5 in ipairs(slot0.updateList) do
		slot5()
	end

	if slot0.contextData.customPanels.minHeight then
		slot0.layout:GetComponent(typeof(LayoutElement)).preferredHeight = slot0.contextData.customPanels.minHeight
	end

	slot0.onInit = false
end

slot0.InitDropdown = function (slot0, slot1)
	slot3 = tf(Instantiate(slot0.panelTemplate))

	setParent(slot3, slot0.layout, false)
	setActive(slot3, true)

	slot4 = slot0.Clone2Full(slot3:Find("bg/panel"), #slot1.tags)
	go(slot3).name = slot1.titleTxt

	setText(slot3:Find("title/Image"), i18n(slot1.titleTxt))
	setText(slot3:Find("title/Image/Image_en"), i18n(slot1.titleENTxt))
	setActive(slot3:Find("bg"):GetComponent(typeof(ScrollRect)).verticalScrollbar, false)

	slot3.Find("bg").GetComponent(typeof(ScrollRect)).enabled = false

	for slot9, slot10 in ipairs(slot2) do
		setActive(slot0:findTF("dropdown", slot11), true)
		onButton(slot0, slot4[slot9], function ()
			slot0 = slot0.panel:InverseTransformPoint(slot1.position)

			if not slot1.position:GetLoaded() then
				slot2:Load()
			end

			slot2:ActionInvoke("Show", slot0)
		end)

		slot0.dropdownDic[slot10] = CustomDropdown.New(slot0.panel, slot0.event, slot0.contextData, slot10, slot4[slot9])
	end
end

slot0.InitCustoms = function (slot0, slot1)
	slot4 = tf(Instantiate(slot0.panelTemplate))

	setParent(slot4, slot0.layout, false)
	setActive(slot4, true)

	go(slot4).name = slot1.titleTxt

	setText(slot4:Find("title/Image"), i18n(slot1.titleTxt))
	setText(slot4:Find("title/Image/Image_en"), i18n(slot1.titleENTxt))
	setActive(slot4:Find("bg"):GetComponent(typeof(ScrollRect)).verticalScrollbar, false)

	slot4.Find("bg").GetComponent(typeof(ScrollRect)).enabled = false
	slot6 = slot0.contextData.customPanels[slot1.tags[1]].options
	slot7 = slot0.contextData.customPanels[slot1.tags[1]].mode or slot0.Mode.OR
	slot8 = 0

	for slot12, slot13 in ipairs(slot6) do
		slot8 = bit.bor(slot13, slot8)
	end

	slot0.contextData.indexDatas[slot2] = slot0.contextData.indexDatas[slot2] or slot6[1]
	slot9 = nil

	for slot14, slot15 in ipairs(slot10) do
		slot16 = slot6[slot14]

		setText(findTF(slot15, "Image"), i18n(slot3.names[slot14]))
		setImageSprite(slot15, slot0.greySprite)
		onButton(slot0, slot15, function ()
			if slot0 == slot1.Mode.AND then
				if slot2 == 1 or slot3.contextData.indexDatas[slot4] == slot5[1] then
					slot3.contextData.indexDatas[slot4] = slot6
				else
					slot3.contextData.indexDatas[slot4] = bit.bxor(slot3.contextData.indexDatas[slot4], slot6)
				end

				if slot3.contextData.indexDatas[slot4] == 0 or slot3.contextData.indexDatas[slot4] == slot7 then
					slot3.contextData.indexDatas[slot4] = slot5[1]
				end
			elseif slot0 == slot1.Mode.OR then
				slot3.contextData.indexDatas[slot4] = slot6
			end

			slot8()
		end, SFX_UI_TAG)
	end

	function slot9()
		if slot0 == slot1.Mode.AND then
			if slot2.contextData.indexDatas[slot3] == slot4[1] then
				for slot3, slot4 in ipairs(slot5) do
					slot6 = findTF(slot4, "Image")

					setImageSprite(slot4, (slot4[slot3] == slot4[1] and slot2.yellowSprite) or slot2.greySprite)
				end
			else
				for slot3, slot4 in ipairs(slot5) do
					slot6 = findTF(slot4, "Image")

					setImageSprite(slot4, (slot4[slot3] ~= slot4[1] and bit.band(slot2.contextData.indexDatas[slot3], slot4[slot3]) > 0 and slot2.yellowSprite) or slot2.greySprite)
				end
			end
		elseif slot0 == slot1.Mode.OR then
			for slot3, slot4 in ipairs(slot5) do
				slot6 = findTF(slot4, "Image")

				setImageSprite(slot4, (slot4[slot3] == slot2.contextData.indexDatas[slot3] and slot2.yellowSprite) or slot2.greySprite)
			end
		end

		slot2:OnDatasChange(slot3)
	end

	table.insert(slot0.updateList, slot9)
end

slot0.OnDatasChange = function (slot0, slot1)
	slot2 = slot0.contextData.dropdownLimit or {}

	for slot6, slot7 in pairs(slot0.dropdownDic) do
		if slot2[slot6] ~= nil then
			slot8 = slot2[slot6].include

			if slot2[slot6].exclude[slot1] ~= nil or slot8[slot1] ~= nil then
				slot10 = slot0.contextData.indexDatas[slot1]
				slot11 = false

				if slot9[slot1] ~= nil and slot10 == slot9[slot1] then
					slot11 = false
				elseif slot8[slot1] ~= nil then
					setActive(slot0.dropdownDic[slot6].virtualBtn, bit.band(slot10, slot8[slot1]) > 0)
				end

				if not slot0.onInit then
					slot0.contextData.indexDatas[slot6] = slot0.contextData.customPanels[slot6].options[1]
				end

				slot0.dropdownDic[slot6]:UpdateVirtualBtn()
				slot0.dropdownDic[slot6]:ActionInvoke("SelectLast")
			end
		end
	end
end

slot0.willExit = function (slot0)
	LeanTween.cancel(go(slot0.panel))

	for slot4, slot5 in pairs(slot0.dropdownDic) do
		slot5:Destroy()
	end

	slot0.updateList = nil

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

slot0.Clone2Full = function (slot0, slot1)
	slot2 = {}
	slot3 = slot0:GetChild(0)

	for slot8 = 0, slot0.childCount - 1, 1 do
		table.insert(slot2, slot0:GetChild(slot8))
	end

	for slot8 = slot4, slot1 - 1, 1 do
		cloneTplTo(slot3, slot0).name = slot8

		table.insert(slot2, tf(cloneTplTo(slot3, slot0)))
	end

	for slot8 = 0, slot0.childCount - 1, 1 do
		setActive(slot0:GetChild(slot8), slot8 < slot1)
	end

	for slot8 = slot4, slot1 + 1, -1 do
		table.remove(slot2)
	end

	return slot2
end

return slot0

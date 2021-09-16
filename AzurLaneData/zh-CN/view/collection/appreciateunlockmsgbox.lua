slot0 = class("AppreciateUnlockMsgBox", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "AppreciateUnlockMsgBox"
end

slot0.OnInit = function (slot0)
	slot0.customMsgbox = slot0._tf
	slot0.msgBoxItemPanel = slot0.customMsgbox:Find("frame/bg/item_panel")
	slot0.msgboxItemContains = slot0.customMsgbox:Find("frame/bg/item_panel/items")
	slot0.msgBoxItemTpl = slot0.msgboxItemContains:Find("equipmenttpl")
	slot0.msgBoxItemContent = slot0.customMsgbox:Find("frame/bg/item_panel/content")
	slot0.msgBoxItemContent1 = slot0.customMsgbox:Find("frame/bg/item_panel/content_num")
	slot0.msgBoxCancelBtn = slot0.customMsgbox:Find("frame/btns/cancel_btn")
	slot0.msgBoxConfirmBtn = slot0.customMsgbox:Find("frame/btns/confirm_btn")
	slot0.msgBoxContent = slot0.customMsgbox:Find("frame/bg/content")
	slot0.msgBtnBack = slot0.customMsgbox:Find("frame/top/btnBack")

	SetActive(slot0.customMsgbox, false)

	slot0.settings = {}

	onButton(slot0, slot0.msgBoxConfirmBtn, function ()
		if slot0.settings.onYes then
			slot0.settings.onYes()
		else
			slot0:hideCustomMsgBox()
		end
	end, SFX_PANEL)
	SetActive(slot0.msgBoxCancelBtn, not defaultValue(slot0.settings.hideNO, false))
	onButton(slot0, slot0.msgBoxCancelBtn, function ()
		if slot0.settings.onCancel then
			slot0.settings.onCancel()
		else
			slot0:hideCustomMsgBox()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.customMsgbox, function ()
		slot0:hideCustomMsgBox()
	end, SFX_PANEL)
	onButton(slot0, slot0.msgBtnBack, function ()
		slot0:hideCustomMsgBox()
	end, SFX_CANCEL)
end

slot0.showCustomMsgBox = function (slot0, slot1)
	slot0.isShowCustomMsgBox = true
	slot0.settings = slot1

	setActive(slot0.customMsgbox, true)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.customMsgbox, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})
	setActive(slot0.msgBoxItemPanel, slot1.items and #slot1.items > 0)
	setActive(slot0.msgBoxContent, not (slot1.items and #slot1.items > 0))

	slot3 = getProxy(PlayerProxy):getData()

	if slot1.items and #slot1.items > 0 then
		for slot9 = slot0.msgboxItemContains.childCount + 1, #slot1.items, 1 do
			cloneTplTo(slot0.msgBoxItemTpl, slot0.msgboxItemContains)
		end

		for slot9 = 1, slot0.msgboxItemContains.childCount, 1 do
			SetActive(slot0.msgboxItemContains:GetChild(slot9 - 1), slot9 <= #slot4)

			if slot9 <= #slot4 then
				updateDrop(slot10, slot11)

				slot12 = 0

				if slot4[slot9].type == DROP_TYPE_RESOURCE then
					slot12 = slot3:getResById(slot11.id)
				elseif slot11.type == DROP_TYPE_ITEM then
					slot12 = getProxy(BagProxy):getItemCountById(slot11.id)
				end

				setText(slot10:Find("icon_bg/count"), slot12 .. "/" .. ((slot12 < slot11.count and "<color=#D6341DFF>" .. slot11.count .. "</color>") or "<color=#A9F548FF>" .. slot11.count .. "</color>"))
			end
		end

		setText(slot0.msgBoxItemContent, slot1.content or "")
		setText(slot0.msgBoxItemContent1, slot1.content1 or "")
	else
		setText(slot0.msgBoxContent, slot1.content or "")
	end
end

slot0.hideCustomMsgBox = function (slot0)
	slot0.isShowCustomMsgBox = nil

	SetActive(slot0.customMsgbox, false)
	slot0:Destroy()
end

slot0.OnDestroy = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.customMsgbox, slot0._tf)
end

return slot0

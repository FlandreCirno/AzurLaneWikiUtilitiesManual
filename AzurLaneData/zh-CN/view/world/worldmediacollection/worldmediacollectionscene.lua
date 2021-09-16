slot0 = class("WorldMediaCollectionScene", require("view.base.BaseUI"))
slot0.PAGE_MEMORTY = 1
slot0.PAGE_FILE = 2
slot0.PAGE_RECORD = 3

slot0.getUIName = function (slot0)
	return "WorldMediaCollectionUI"
end

slot0.init = function (slot0)
	slot0.top = slot0._tf:Find("Top")
	slot0.viewContainer = slot0._tf:Find("Main")
	slot0.toggles = {}

	for slot5 = 0, slot0.top:Find("Adapt/Bar/ToggleGroup").childCount - 1, 1 do
		slot0.toggles[slot5 + 1] = slot1:GetChild(slot5)
	end

	slot0.subViews = {}
end

slot1 = {
	import(".WorldMediaCollectionMemoryLayer"),
	import(".WorldMediaCollectionRecordLayer"),
	import(".WorldMediaCollectionFileLayer")
}

slot0.GetCurrentPage = function (slot0)
	return slot0.contextData.page and slot0.subViews[slot0.contextData.page]
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.top, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})
	onButton(slot0, slot0.top:Find("blur_panel/adapt/top/option"), function ()
		slot0:quickExitFunc()
	end, SFX_PANEL)
	onButton(slot0, slot0.top:Find("blur_panel/adapt/top/back_btn"), function ()
		slot0:Backward()
	end, SFX_UI_CANCEL)

	for slot4 = 1, #slot0.toggles, 1 do
		onToggle(slot0, slot0.toggles[slot4], function (slot0)
			if not slot0 then
				return
			end

			if not slot0 == slot1.contextData.page.subViews[slot0] then
				if not slot2[slot0] then
					return
				end

				slot1.contextData[slot3] = slot1.contextData[slot3] or {}

				slot3.New(slot1, slot1.viewContainer, slot1.event, slot1.contextData):Load()
			end

			if slot1.contextData.page and slot1.subViews[slot1.contextData.page] and not slot1 then
				slot1.subViews[slot1.contextData.page].buffer:OnDeselected()
			end

			slot1.contextData.page = slot0
			slot1.subViews[slot0] = slot2

			if not slot1 then
				slot2.buffer:OnSelected()
			else
				slot2.buffer:OnReselected()
			end
		end, SFX_UI_TAG)
	end

	slot0.contextData.page = nil

	triggerToggle(slot0.toggles[slot0.contextData.page or slot1.PAGE_MEMORTY], true)
	slot0.UpdateView(slot0)
end

slot0.Backward = function (slot0)
	if slot0.subViews[slot0.contextData.page] and slot1:OnBackward() then
		return slot2
	end

	slot0:closeView()
end

slot0.onBackPressed = function (slot0)
	slot0:Backward()
end

slot0.Add2LayerContainer = function (slot0, slot1)
	setParent(slot1, slot0.viewContainer)
end

slot0.Add2TopContainer = function (slot0, slot1)
	setParent(slot1, slot0.top)
end

slot0.WorldRecordLock = function ()
	function slot0()
		return pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "WorldMediaCollectionRecordMediator")
	end

	return LOCK_WORLD_COLLECTION or not slot0()
end

slot0.UpdateView = function (slot0)
	setActive(slot1, not slot0.WorldRecordLock())

	if not slot0.subViews[slot0.contextData.page] then
		return
	end

	slot2.buffer:UpdateView()
end

slot0.willExit = function (slot0)
	if slot0:GetCurrentPage() then
		slot1.buffer:OnDeselected()
	end

	for slot5, slot6 in pairs(slot0.subViews) do
		slot6:Destroy()
	end

	table.clear(slot0.subViews)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.top, slot0._tf)
end

return slot0

slot0 = class("IdolMedalCollectionView2", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "IdolMedalCollectionUI2"
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
end

slot1 = {
	32.4,
	132.7
}

slot0.didEnter = function (slot0)
	slot0:checkAward()
	slot0:UpdateView()
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
end

slot0.initData = function (slot0)
	slot0.activityProxy = getProxy(ActivityProxy)
	slot0.activityData = slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA)
	slot0.allIDList = IdolMedalCollectionMediator.GetPicturePuzzleIds(slot0.activityData.id)
	slot0.activatableIDList = slot0.activityData.data1_list
	slot0.activeIDList = slot0.activityData.data2_list
end

slot2 = {}

slot0.findUI = function (slot0)
	slot0.bg = slot0:findTF("BG")
	slot1 = slot0:findTF("NotchAdapt")
	slot0.backBtn = slot0:findTF("BackBtn", slot1)
	slot0.progressText = slot0:findTF("ProgressText", slot1)
	slot0.helpBtn = slot0:findTF("HelpBtn", slot1)
	slot0.top = slot1
	slot2 = slot0:findTF("MedalContainer")
	slot0.medalContainer = slot2
	slot0.buttonNext = slot0:findTF("ButtonNext", slot2)
	slot0.buttonNextLocked = slot0:findTF("ButtonNextLocked", slot2)
	slot0.buttonPrev = slot0:findTF("ButtonPrev", slot2)
	slot0.buttonShare = slot0:findTF("ButtonShare", slot2)
	slot0.buttonReset = slot0:findTF("ButtonReset", slot2)
	slot0.pageCollection = slot2:Find("PageCollection")
	slot0.pageModified = slot2:Find("PageModified")
	slot0.OverlayPanel = slot2:Find("Overlay")
	slot0.pages = {
		slot0.pageCollection,
		slot0.pageModified
	}
	slot0.pageIndex = 1
	slot0.medalItemList = {}

	for slot6 = 1, #slot0.allIDList, 1 do
		table.insert(slot0.medalItemList, slot0:findTF("Images/Medal" .. slot6, slot0.pageCollection))
	end

	slot0.medalTextList = {}

	for slot6 = 1, #slot0.allIDList, 1 do
		table.insert(slot0.medalTextList, slot0:findTF("Texts/Medal" .. slot6, slot0.pageCollection))
	end

	slot0.selectPanel = slot2:Find("SelectPanel")
	slot0.selectPanelContainer = slot0.selectPanel:Find("Scroll/Container")
	slot0.allItems = {}
	slot0.selectedPositionsInPanels = {}
	slot0.listStayInPanel = {}
	slot0.listShowOnPanel = {}
	slot0.overlayingImage = nil

	for slot6 = 0, slot0.selectPanelContainer.childCount - 1, 1 do
		slot7 = slot0.selectPanelContainer:GetChild(slot6)
		slot0.selectedPositionsInPanels[slot7] = slot7.anchoredPosition

		table.insert(slot0.listStayInPanel, slot7)
		table.insert(slot0.allItems, slot7)
	end

	for slot6, slot7 in pairs(slot0) do
		setParent(slot8, slot0.pageModified)
		table.removebyvalue(slot0.listStayInPanel, slot8)
		table.insert(slot0.listShowOnPanel, slot8)
		setAnchoredPosition(slot0.allItems[slot6], slot7)
	end

	setText(slot0.pageModified:Find("TextTip"), i18n("collect_idol_tip"))
	slot0:AddLeanTween(function ()
		return LeanTween.alphaText(rtf(slot0.pageModified:Find("TextTip")), 1, 2):setFrom(0):setLoopPingPong()
	end)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_collection.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.bg, function ()
		slot0:SwitchSelectedImage(nil)
	end)
	onButton(slot0, slot0.selectPanelContainer, function ()
		slot0:SwitchSelectedImage(nil)
	end)
	onButton(slot0, slot0.buttonNext, function ()
		slot0:SwitchPage(1)
	end, SFX_PANEL)
	onButton(slot0, slot0.buttonNextLocked, function ()
		pg.TipsMgr.GetInstance():ShowTips(i18n("hand_account_tip"))
	end, SFX_PANEL)
	onButton(slot0, slot0.buttonPrev, function ()
		slot0:SwitchPage(-1)
	end, SFX_PANEL)
	onButton(slot0, slot0.buttonReset, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("hand_account_resetting_tip"),
			onYes = function ()
				slot0:ResetPanel()
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.buttonShare, function ()
		setAnchoredPosition(slot0.medalContainer, {
			x = slot1[1]
		})
		setActive(slot0.selectPanel, false)
		setActive(slot0.buttonNext, false)
		setActive(slot0.buttonNextLocked, false)
		setActive(slot0.buttonPrev, false)
		setActive(slot0.buttonShare, false)
		setActive(slot0.buttonReset, false)
		setActive(slot0.top, false)
		setActive(slot0.pageModified:Find("TextTip"), false)
		slot0:SwitchSelectedImage(nil)
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePoraisMedals)
		setActive(slot0.top, true)
		setActive(slot0.pageModified:Find("TextTip"), true)
		slot0:SwitchSelectedImage(setActive.lastSelectedImage)
		slot0:UpdateView()
	end, SFX_PANEL)

	slot1 = GameObject.Find("OverlayCamera").GetComponent(slot1, "Camera")

	for slot5, slot6 in ipairs(slot0.allItems) do
		slot7 = slot0.selectedPositionsInPanels[slot6]

		setActive(slot6:Find("Selected"), false)

		slot8 = GetOrAddComponent(slot6, "EventTriggerListener")

		function slot9()
			if not slot0.overlayingImage then
				return
			end

			slot0.overlayingImage = nil

			for slot4, slot5 in ipairs(slot0.listStayInPanel) do
				if slot5 == slot0 then
					setParent(slot0, slot0.selectPanelContainer)
					setAnchoredPosition(slot0, slot0.selectedPositionsInPanels[slot0])

					return
				end
			end

			for slot4, slot5 in ipairs(slot0.listShowOnPanel) do
				if slot5 == slot0 then
					setParent(slot0, slot0.pageModified)
					slot0:SetAsLastSibling()

					return
				end
			end
		end

		slot10 = nil

		slot8.AddPointClickFunc(slot8, function (slot0, slot1)
			if slot0 then
				return
			end

			if slot1.lastSelectedImage ==  then
				slot1:SwitchSelectedImage(nil)
			else
				slot1:SwitchSelectedImage(slot1.SwitchSelectedImage)
				slot1.SwitchSelectedImage:SetAsLastSibling()
			end
		end)
		slot8.AddBeginDragFunc(slot8, function (slot0, slot1)
			slot0 = slot1.position

			slot1()
			setParent(setParent, slot3.OverlayPanel)

			setParent.overlayingImage = setParent

			setParent:SwitchSelectedImage(setParent.SwitchSelectedImage)
		end)
		slot8.AddDragFunc(slot8, function (slot0, slot1)
			setAnchoredPosition(LuaHelper.ScreenToLocal(rtf(slot0.OverlayPanel), slot1.position, slot1), )
		end)
		slot8.AddDragEndFunc(slot8, function (slot0, slot1)
			slot3 = slot0 and slot0:Sub(slot1.position):SqrMagnitude() < 1
			slot0 = nil

			if slot3 then
				slot1()

				return
			end

			if not rtf(slot2.pageModified).rect:Contains(LuaHelper.ScreenToLocal(rtf(slot2.pageModified), slot1.position, slot3)) then
				setParent(slot4, slot2.selectPanelContainer)
				table.removebyvalue(slot2.listStayInPanel, slot4)
				table.removebyvalue(slot2.listShowOnPanel, slot4)
				table.insert(slot2.listStayInPanel, slot4)

				slot5[slot6] = nil

				setAnchoredPosition(slot4, setAnchoredPosition)
				slot4:SetAsLastSibling()
			else
				setParent(slot4, slot2.pageModified)
				table.removebyvalue(slot2.listStayInPanel, slot4)
				table.removebyvalue(slot2.listShowOnPanel, slot4)
				table.insert(slot2.listShowOnPanel, slot4)

				slot5[slot6] = slot4

				setAnchoredPosition(slot4, slot4)
				slot4:SetAsLastSibling()
			end

			slot2.overlayingImage = nil
		end)
	end
end

slot0.SwitchSelectedImage = function (slot0, slot1)
	if slot0.lastSelectedImage == slot1 then
		return
	end

	if slot0.lastSelectedImage then
		setActive(slot0.lastSelectedImage:Find("Selected"), false)
	end

	slot0.lastSelectedImage = slot1

	if slot1 then
		setActive(slot1:Find("Selected"), true)
	end
end

slot0.ResetPanel = function (slot0)
	for slot4, slot5 in ipairs(slot0.listShowOnPanel) do
		table.insert(slot0.listStayInPanel, slot5)
		setParent(slot5, slot0.selectPanelContainer)
		setAnchoredPosition(slot5, slot0.selectedPositionsInPanels[slot5] or Vector2.zero)
	end

	table.clean(slot0.listShowOnPanel)
	table.clear(slot0)
end

slot0.UpdateView = function (slot0)
	if slot0.pageIndex == 1 then
		slot0:updateMedalContainerView()
	end

	for slot4 = 1, #slot0.pages, 1 do
		setActive(slot0.pages[slot4], slot4 == slot0.pageIndex)
	end

	setAnchoredPosition(slot0.medalContainer, {
		x = slot0[slot0.pageIndex]
	})
	setActive(slot0.selectPanel, slot0.pageIndex == 2)
	setActive(slot0.buttonNext, #slot0.activeIDList == #slot0.allIDList and slot0.activityData.data1 == 1 and slot0.pageIndex == 1)
	setActive(slot0.buttonNextLocked, not (#slot0.activeIDList == #slot0.allIDList and slot0.activityData.data1 == 1) and slot0.pageIndex == 1)
	setActive(slot0.buttonPrev, slot0.pageIndex == 2)
	setActive(slot0.buttonShare, slot0.pageIndex == 2)
	setActive(slot0.buttonReset, slot0.pageIndex == 2)
	setText(slot0.progressText, setColorStr(tostring(#slot0.activeIDList), COLOR_RED) .. "/" .. #slot0.allIDList)
end

slot0.updateMedalContainerView = function (slot0)
	for slot4, slot5 in ipairs(slot0.allIDList) do
		slot0:updateMedalView(slot0.allIDList, slot5)
	end
end

slot0.updateMedalView = function (slot0, slot1, slot2)
	slot4 = table.contains(slot0.activeIDList, slot2)

	setImageAlpha(slot0.medalItemList[table.indexof(slot1, slot2, 1)], (slot4 and 1) or 0)
	setActive(slot0:findTF("Activable", slot8), table.contains(slot0.activatableIDList, slot2) and not slot4)
	setActive(slot0:findTF("DisActive", slot0.medalTextList[table.indexof(slot1, slot2, 1)]), not slot4 and not (table.contains(slot0.activatableIDList, slot2) and not slot4))
	onButton(slot0, slot7, function ()
		if not slot0 then
			return
		end

		pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
			id = slot1,
			actId = slot2.activityData.id
		})
	end, SFX_PANEL)
	setText(slot10, "")
end

slot0.updateAfterSubmit = function (slot0)
	return
end

slot0.UpdateActivity = function (slot0)
	slot0:initData()
	slot0:checkAward()
	slot0:UpdateView()
end

slot0.SwitchPage = function (slot0, slot1)
	slot0.pageIndex = math.clamp(slot0.pageIndex + slot1, 1, #slot0.pages)

	slot0:UpdateView()
end

slot0.checkAward = function (slot0)
	if #slot0.activeIDList == #slot0.allIDList and slot0.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = slot0.activityData.id
		})
	end
end

return slot0

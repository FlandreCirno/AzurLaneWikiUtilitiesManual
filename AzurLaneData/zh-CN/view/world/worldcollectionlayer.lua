slot0 = class("WorldCollectionLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "WorldCollectionUI"
end

slot0.setCollectionProxy = function (slot0, slot1)
	slot0.collectionProxy = slot1
end

slot0.init = function (slot0)
	slot0.top = slot0._tf:Find("top")
	slot0.backBtn = slot0.top:Find("back_btn")
	slot0.rtMain = slot0._tf:Find("main")
	slot0.entranceContainer = slot0.rtMain:Find("list_bg/map_list/content")
	slot0.entranceItemList = UIItemList.New(slot0.entranceContainer, slot0.entranceContainer:Find("item"))

	slot0.entranceItemList:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			slot0.entranceIndexDic[slot0.achEntranceList[slot1].id] = slot1

			setText(slot2:Find("icon/deco_id"), slot0.achEntranceList[slot1].config.serial_number)
			setText(slot2:Find("icon/name"), slot0.achEntranceList[slot1].GetBaseMap(slot3):GetName())
			setAnchoredPosition(slot4, {
				y = (1 - slot1 % 2 * 2) * slot2:Find("icon").anchoredPosition.y
			})
			onToggle(slot0, slot2, function (slot0)
				if slot0 then
					slot0:UpdateAchievement(slot0.UpdateAchievement)
				end
			end, SFX_PANEL)

			if nowWorld.AnyUnachievedAchievement(slot5, slot0.achEntranceList[slot1]) then
				setActive(slot2:Find("icon/tip"), true)
				table.insert(slot0.achAwardIndexList, slot1)
			else
				setActive(slot2:Find("icon/tip"), false)
			end
		end
	end)
	slot0.entranceContainer.GetComponent(slot1, typeof(ScrollRect)).onValueChanged:AddListener(function (slot0)
		slot0:UpdateJumpBtn()
	end)

	slot0.entrancePanel = slot0.rtMain.Find(slot1, "map")
	slot0.entranceTitle = slot0.entrancePanel:Find("target_rect/title")
	slot0.targetContainer = slot0.entrancePanel:Find("target_rect/target_list/content")
	slot0.targetItemList = UIItemList.New(slot0.targetContainer, slot0.targetContainer:Find("item"))

	slot0.targetItemList:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			slot5 = slot2:Find("bg")

			setActive(slot5:Find("normal"), not (slot1 > #slot0.achEntranceList[slot0.selectedIndex].config.normal_target))
			setActive(slot5:Find("hidden"), slot1 > #slot0.achEntranceList[slot0.selectedIndex].config.normal_target)
			setText(slot5:Find("desc"), ((not (slot1 > #slot0.achEntranceList[slot0.selectedIndex].config.normal_target) or slot0.targetList[slot1]:IsAchieved() or slot0.showHiddenDesc) and HXSet.hxLan(slot6.config.target_desc)) or "???")
			setText(slot5:Find("progress"), ((not (slot1 > #slot0.achEntranceList[slot0.selectedIndex].config.normal_target) or slot0.targetList[slot1].IsAchieved() or slot0.showHiddenDesc) and slot6:GetProgress() .. "/" .. slot6:GetMaxProgress()) or "")
			setActive(slot5:Find("finish_mark/Image"), slot0.targetList[slot1].IsAchieved())

			slot9 = slot2:Find("pop")
			slot11 = (not (slot1 > #slot0.achEntranceList[slot0.selectedIndex].config.normal_target) or slot0.targetList[slot1].IsAchieved() or slot0.showHiddenDesc) and #slot6:GetTriggers() > 1

			if slot11 then
				slot13 = slot9:Find("Text")

				function slot15(slot0, slot1)
					setText(slot1, slot0[slot0].GetDesc(slot2))
					setTextColor(slot1, (slot0[slot0]:IsAchieved() and Color.New(0.3686274509803922, 0.6078431372549019, 1)) or Color.New(0.4745098039215686, 0.4745098039215686, 0.4745098039215686))
					setActive(slot1, true)
				end

				for slot19 = #slot10, slot9.childCount - 1, 1 do
					setActive(slot12.GetChild(slot12, slot19), false)
				end

				for slot19 = slot14, #slot10 - 1, 1 do
					cloneTplTo(slot13, slot12)
				end

				for slot19 = 0, #slot10 - 1, 1 do
					slot15(slot19 + 1, slot12:GetChild(slot19))
				end
			end

			triggerToggle(slot2, false)
			setToggleEnabled(slot2, slot11)
			setActive(slot5:Find("arrow"), slot11)
		end
	end)

	slot0.achAwardRect = slot0.entrancePanel.Find(slot1, "award_rect")
	slot0.achAchieveBtn = slot0.achAwardRect:Find("btn_achieve")
	slot0.overviewBtn = slot0.entrancePanel:Find("btn_overview")
	slot0.subviewAchAward = WorldAchAwardSubview.New(slot0._tf, slot0.event)

	slot0:bind(WorldAchAwardSubview.ShowDrop, function (slot0, slot1)
		slot0:emit(slot1.ON_DROP, slot1)
	end)
end

slot0.onBackPressed = function (slot0)
	if pg.m02:retrieveMediator(WorldMediator.__cname).viewComponent:CheckMarkOverallClose() then
	elseif slot0.subviewAchAward:isShowing() then
		slot0.subviewAchAward:ActionInvoke("Hide")
	else
		slot0.super.onBackPressed(slot0)
	end
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
	onButton(slot0, slot0.backBtn, function ()
		if slot0.memories and slot0.toggles[2]:GetComponent(typeof(Toggle)).isOn then
			slot0:return2MemoryGroup()
		else
			slot0:closeView()
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0.rtMain:Find("list_bg/jump_icon_left"), function ()
		triggerToggle(slot0.entranceContainer:GetChild(slot0:GetAwardIndex(false) - 1), true)
		triggerToggle:ScrollToSelectEntrance()
	end, SFX_PANEL)
	onButton(slot0, slot0.rtMain:Find("list_bg/jump_icon_right"), function ()
		triggerToggle(slot0.entranceContainer:GetChild(slot0:GetAwardIndex(true) - 1), true)
		triggerToggle:ScrollToSelectEntrance()
	end, SFX_PANEL)
	onButton(slot0, slot0.achAchieveBtn, function ()
		slot0, slot1 = nowWorld:AnyUnachievedAchievement(slot0.entrance)

		if slot0 then
			slot0:emit(WorldCollectionMediator.ON_ACHIEVE_STAR, {
				{
					id = slot0.entrance.id,
					star_list = {
						slot1.star
					}
				}
			})
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.entrancePanel:Find("page_left"), function ()
		triggerToggle(slot0.entranceContainer:GetChild(slot0.selectedIndex - 1 - 1), true)
		triggerToggle:ScrollToSelectEntrance()
	end, SFX_PANEL)
	onButton(slot0, slot0.entrancePanel:Find("page_right"), function ()
		triggerToggle(slot0.entranceContainer:GetChild((slot0.selectedIndex + 1) - 1), true)
		triggerToggle:ScrollToSelectEntrance()
	end, SFX_PANEL)
	onButton(slot0, slot0.overviewBtn, function ()
		slot0:emit(WorldCollectionMediator.ON_ACHIEVE_OVERVIEW)
	end, SFX_PANEL)

	slot0.achEntranceList = nowWorld.GetAtlas(slot1):GetAchEntranceList()
	slot0.achAwardIndexList = {}
	slot0.entranceIndexDic = {}

	slot0.entranceItemList:align(#slot0.achEntranceList)

	slot0.contextData.entranceId = defaultValue(slot0.contextData.entranceId, 0)

	triggerToggle(slot0.entranceContainer:GetChild(defaultValue(slot0.entranceIndexDic[slot0.contextData.entranceId], 1) - 1), true)
	slot0:ScrollToSelectEntrance()
end

slot0.willExit = function (slot0)
	slot0.subviewAchAward:Destroy()
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
end

slot0.InitAchievement = function (slot0)
	return
end

slot0.FlushEntranceItem = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		if not nowWorld:AnyUnachievedAchievement(slot0.achEntranceList[slot0.entranceIndexDic[slot6.id]]) then
			setActive(slot0.entranceContainer:GetChild(slot7 - 1).Find(slot8, "icon/tip"), false)
			table.remove(slot0.achAwardIndexList, dichotomy(slot7, slot0.achAwardIndexList))
		end
	end
end

slot0.UpdateAchievement = function (slot0, slot1)
	if slot0.selectedIndex ~= slot1 then
		slot0.selectedIndex = slot1
		slot0.entrance = slot0.achEntranceList[slot0.selectedIndex]

		slot0:FlushAchievement()
	end
end

slot0.GetAwardIndex = function (slot0, slot1)
	slot3 = #slot0.achEntranceList - 1 - slot0.rtMain:Find("list_bg/map_list").rect.width / slot0.entranceContainer:Find("item"):GetComponent(typeof(LayoutElement)).preferredWidth

	if slot1 then
		if not dichotomy(math.ceil(slot0.entranceContainer:GetComponent(typeof(ScrollRect)).normalizedPosition.x * slot3 + 1 + slot2), slot0.achAwardIndexList) then
			return
		elseif slot0.achAwardIndexList[slot5] <= slot4 then
			return slot0.achAwardIndexList[slot5 + 1]
		else
			return slot0.achAwardIndexList[slot5]
		end
	elseif not dichotomy(math.floor(slot0.entranceContainer:GetComponent(typeof(ScrollRect)).normalizedPosition.x * slot3 + 1), slot0.achAwardIndexList) then
		return
	elseif slot4 <= slot0.achAwardIndexList[slot5] then
		return slot0.achAwardIndexList[slot5 - 1]
	else
		return slot0.achAwardIndexList[slot5]
	end
end

slot0.ScrollToSelectEntrance = function (slot0)
	if #slot0.achEntranceList - 1 - slot0.rtMain:Find("list_bg/map_list").rect.width / slot0.entranceContainer:Find("item"):GetComponent(typeof(LayoutElement)).preferredWidth > 0 then
		scrollTo(slot0.entranceContainer, math.clamp(slot0.selectedIndex - 1 - slot1 / 2, 0, slot2) / slot2, 0)
	end
end

slot0.UpdateJumpBtn = function (slot0)
	setActive(slot0.rtMain:Find("list_bg/jump_icon_left"), slot0:GetAwardIndex(false))
	setActive(slot0.rtMain:Find("list_bg/jump_icon_right"), slot0:GetAwardIndex(true))
end

slot0.FlushAchievement = function (slot0)
	slot0:UpdateJumpBtn()

	slot0.showHiddenDesc = nowWorld:IsNormalAchievementAchieved(slot0.entrance)
	slot0.targetList = nowWorld:GetAchievements(slot0.entrance)

	slot0.targetItemList:align(#slot0.targetList)

	slot1 = slot0.entrance:GetBaseMap()

	GetImageSpriteFromAtlasAsync("world/targeticon/" .. slot1.config.entrance_mapicon, "", slot0.entranceTitle)
	setText(slot0.entranceTitle:Find("name"), slot1:GetName())
	setText(slot0.entranceTitle:Find("deco_id"), slot0.entrance.config.serial_number)

	slot2, slot3, slot9 = nowWorld:CountAchievements(slot0.entrance)

	setText(slot0.entranceTitle:Find("progress_text"), slot2 + slot3 .. "/" .. slot4)

	slot5, slot6 = nowWorld:AnyUnachievedAchievement(slot0.entrance)
	slot7 = slot0.achAwardRect:Find("award")

	if slot6 then
		setActive(slot0.achAwardRect:Find("get_mask"), slot5)
		setActive(slot0.achAwardRect:Find("got_mask"), false)
	else
		slot6 = slot0.entrance:GetAchievementAwards()[#slot0.entrance.GetAchievementAwards()]

		setActive(slot0.achAwardRect:Find("get_mask"), false)
		setActive(slot0.achAwardRect:Find("got_mask"), true)
	end

	updateDrop(slot7, slot6.drop)
	onButton(slot0, slot7, function ()
		slot0:showAchAwardPanel(slot0.entrance)
	end, SFX_PANEL)
	setText(slot0.achAwardRect.Find(slot9, "star_count/Text"), slot2 + slot3 .. "/" .. slot6.star)
	setActive(slot0.achAchieveBtn, slot5)
	setActive(slot0.entrancePanel:Find("page_left"), slot0.selectedIndex > 1)
	setActive(slot0.entrancePanel:Find("page_right"), slot0.selectedIndex < #slot0.achEntranceList)
end

slot0.flushAchieveUpdate = function (slot0, slot1)
	slot0:FlushEntranceItem(slot1)
	slot0:FlushAchievement()
end

slot0.showAchAwardPanel = function (slot0, slot1)
	slot0.subviewAchAward:Load()
	slot0.subviewAchAward:ActionInvoke("Setup", slot1)
	slot0.subviewAchAward:ActionInvoke("Show")
end

return slot0

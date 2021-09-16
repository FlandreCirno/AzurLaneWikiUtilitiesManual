slot0 = class("WorldMediaCollectionMemoryGroupLayer", import(".WorldMediaCollectionSubLayer"))

slot0.getUIName = function (slot0)
	return "WorldMediaCollectionMemoryGroupUI"
end

slot0.PAGE_ACTIVITY = 2

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.memoryGroups = _.map(pg.memory_group.all, function (slot0)
		return pg.memory_group[slot0]
	end)
	slot0.memoryGroupList = slot0.findTF(slot0, "GroupRect"):GetComponent("LScrollRect")

	slot0.memoryGroupList.onInitItem = function (slot0)
		slot0:onInitMemoryGroup(slot0)
	end

	slot0.memoryGroupList.onUpdateItem = function (slot0, slot1)
		slot0:onUpdateMemoryGroup(slot0 + 1, slot1)
	end

	slot0.memoryGroupInfos = {}

	setActive(slot1, false)

	slot0.memoryGroupViewport = slot0:findTF("Viewport", slot0.memoryGroupList)
	slot0.memoryGroupsGrid = slot0:findTF("Viewport/Content", slot0.memoryGroupList):GetComponent(typeof(GridLayoutGroup))
	slot0.memoryTogGroup = slot0:findTF("Toggles", slot0._tf)

	setActive(slot0.memoryTogGroup, true)

	slot0.memoryToggles = {}

	for slot5 = 0, 3, 1 do
		slot0.memoryToggles[slot5 + 1] = slot0:findTF(slot5, slot0.memoryTogGroup)
	end

	slot0.memoryFilterIndex = {
		true,
		true,
		true
	}
	slot0.memoryActivityTogGroup = slot0:findTF("ActivityBar", slot0._tf)

	setActive(slot0.memoryActivityTogGroup, true)

	slot0.memoryActivityToggles = {}

	for slot5 = 0, 3, 1 do
		slot0.memoryActivityToggles[slot5 + 1] = slot0:findTF(slot5, slot0.memoryActivityTogGroup)
	end

	slot0.activityFilter = 0

	slot0:UpdateActivityBar()

	for slot5, slot6 in ipairs(slot0.memoryActivityToggles) do
		onButton(slot0, slot6, function ()
			if slot0 == slot1.activityFilter then
				slot1.activityFilter = 0
			elseif slot0 ~= slot1.activityFilter then
				slot1.activityFilter = slot1
			end

			slot1:UpdateActivityBar()
			slot1:MemoryFilter()
		end, SFX_UI_TAG)
	end

	setText(slot0.memoryActivityToggles[1].Find(slot3, "Image1/Text"), i18n("memory_actiivty_ex"))
	setText(slot0.memoryActivityToggles[1]:Find("Image2/Text"), i18n("memory_actiivty_ex"))
	setText(slot0.memoryActivityToggles[2]:Find("Image1/Text"), i18n("memory_activity_sp"))
	setText(slot0.memoryActivityToggles[2]:Find("Image2/Text"), i18n("memory_activity_sp"))
	setText(slot0.memoryActivityToggles[3]:Find("Image1/Text"), i18n("memory_activity_daily"))
	setText(slot0.memoryActivityToggles[3]:Find("Image2/Text"), i18n("memory_activity_daily"))
	setText(slot0.memoryActivityToggles[4]:Find("Image1/Text"), i18n("memory_activity_others"))
	setText(slot0.memoryActivityToggles[4]:Find("Image2/Text"), i18n("memory_activity_others"))

	slot0.contextData.toggle = slot0.contextData.toggle or 1

	triggerToggle(slot0.memoryToggles[slot0.contextData.toggle], true)
	slot0:SwitchMemoryFilter(slot0.contextData)

	for slot6, slot7 in ipairs(slot0.memoryToggles) do
		onToggle(slot0, slot7, function (slot0)
			if not slot0 then
				return
			end

			slot0:SwitchMemoryFilter(slot0.SwitchMemoryFilter)
			slot0:MemoryFilter()
		end, SFX_UI_TAG)
	end

	slot0.viewParent.Add2TopContainer(slot3, slot0.memoryTogGroup)

	slot0.loader = WorldMediaCollectionLoader.New()

	slot0:MemoryFilter()

	slot0.rectAnchorX = slot0:findTF("GroupRect").anchoredPosition.x

	slot0:UpdateView()
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	setActive(slot0.memoryTogGroup, true)
end

slot0.Hide = function (slot0)
	setActive(slot0.memoryTogGroup, false)
	slot0.super.Hide(slot0)
end

slot0.SwitchMemoryFilter = function (slot0, slot1)
	if slot1 == 1 then
		slot0.memoryFilterIndex = {
			true,
			true,
			true
		}
	else
		for slot5 in ipairs(slot0.memoryFilterIndex) do
			slot0.memoryFilterIndex[slot5] = slot1 - 1 == slot5
		end

		if slot1 - 1 == slot0.PAGE_ACTIVITY then
			slot0.activityFilter = 0

			slot0:UpdateActivityBar()
		end
	end
end

slot0.MemoryFilter = function (slot0)
	table.clear(slot0.memoryGroups)

	slot2 = not _.all(slot0.memoryFilterIndex, function (slot0)
		return slot0
	end) and slot0.memoryFilterIndex[slot0.PAGE_ACTIVITY]

	for slot6, slot7 in pairs(pg.memory_group) do
		if slot0.memoryFilterIndex[slot7.type] then
			if slot2 then
				if slot0.activityFilter == 0 or slot0.activityFilter == slot7.subtype then
					table.insert(slot0.memoryGroups, slot7)
				end
			else
				table.insert(slot0.memoryGroups, slot7)
			end
		end
	end

	table.sort(slot0.memoryGroups, function (slot0, slot1)
		return slot0.id < slot1.id
	end)
	slot0.memoryGroupList.SetTotalCount(slot3, #slot0.memoryGroups, 0)
	setActive(slot0.memoryActivityTogGroup, slot2)
end

slot0.onInitMemoryGroup = function (slot0, slot1)
	if slot0.exited then
		return
	end

	onButton(slot0, slot1, function ()
		if slot0.memoryGroupInfos[slot1] then
			slot0.viewParent:ShowSubMemories(slot0)
		end
	end, SOUND_BACK)
end

slot0.onUpdateMemoryGroup = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	slot0.memoryGroupInfos[slot2] = slot0.memoryGroups[slot1]

	setText(tf(slot2):Find("title"), HXSet.hxLan(slot0.memoryGroups[slot1].title))
	slot0.loader:GetSprite("memoryicon/" .. slot0.memoryGroups[slot1].icon, "", tf(slot2):Find("BG"))
	setText(tf(slot2):Find("count"), slot5 .. "/" .. #slot0.memoryGroups[slot1].memories)
end

slot0.Return2MemoryGroup = function (slot0)
	if not slot0.contextData.memoryGroup then
		return
	end

	slot2 = 0
	slot3 = 0

	for slot7, slot8 in ipairs(slot0.memoryGroups) do
		if slot8.id == slot1 then
			slot3 = slot7

			break
		end
	end

	if slot3 > 0 then
		slot2 = Mathf.Clamp01(((slot0.memoryGroupsGrid.cellSize.y + slot0.memoryGroupsGrid.spacing.y) * math.floor((slot3 - 1) / slot0.memoryGroupsGrid.constraintCount) + slot0.memoryGroupList.paddingFront) / ((slot0.memoryGroupsGrid.cellSize.y + slot0.memoryGroupsGrid.spacing.y) * math.ceil(#slot0.memoryGroups / slot0.memoryGroupsGrid.constraintCount) - slot0.memoryGroupViewport.rect.height))
	end

	slot0.memoryGroupList:SetTotalCount(#slot0.memoryGroups, slot2)
end

slot0.UpdateView = function (slot0)
	setAnchoredPosition(slot0:findTF("GroupRect"), {
		x = (not WorldMediaCollectionScene.WorldRecordLock() or 0) and slot0.rectAnchorX
	})

	for slot5, slot6 in ipairs(slot0.memoryActivityToggles) do
		setActive(slot6, _.any(pg.memory_group.all, function (slot0)
			return pg.memory_group[slot0].subtype == slot0
		end))
	end
end

slot0.UpdateActivityBar = function (slot0)
	for slot4, slot5 in ipairs(slot0.memoryActivityToggles) do
		setActive(slot5:Find("Image1"), not (slot0.activityFilter == slot4))
		setActive(slot5:Find("Image2"), slot0.activityFilter == slot4)
	end
end

return slot0

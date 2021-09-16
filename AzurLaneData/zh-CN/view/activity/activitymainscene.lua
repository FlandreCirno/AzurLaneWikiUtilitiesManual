slot0 = class("ActivityMainScene", import("..base.BaseUI"))
slot0.LOCK_ACT_MAIN = "ActivityMainScene:LOCK_ACT_MAIN"
slot0.UPDATE_ACTIVITY = "ActivityMainScene:UPDATE_ACTIVITY"

slot0.preload = function (slot0, slot1)
	slot1()
end

slot0.getUIName = function (slot0)
	return "ActivityMainUI"
end

slot0.onBackPressed = function (slot0)
	if slot0.locked then
		return
	end

	for slot4, slot5 in pairs(slot0.windowList) do
		if isActive(slot5._tf) then
			slot0:HideWindow(slot5.class)

			return
		end
	end

	slot0:emit(slot0.ON_BACK_PRESSED)
end

slot1 = nil

slot0.init = function (slot0)
	slot0.btnBack = slot0:findTF("blur_panel/adapt/top/back_btn")
	slot0.pageContainer = slot0:findTF("pages")
	slot0.permanentFinshMask = slot0:findTF("pages_finish")
	slot0.tabs = slot0:findTF("scroll/viewport/content")
	slot0.tab = slot0:findTF("tab", slot0.tabs)
	slot0.entranceList = UIItemList.New(slot0:findTF("enter/viewport/content"), slot0:findTF("enter/viewport/content/btn"))
	slot0.windowList = {}
	slot0.lockAll = slot0:findTF("blur_panel/lock_all")

	setActive(slot0.tab, false)
	setActive(slot0.lockAll, false)
	setActive(slot0.permanentFinshMask, false)
	setText(slot0.permanentFinshMask:Find("piece/Text"), i18n("activity_permanent_tips2"))
	onButton(slot0, slot0.permanentFinshMask:Find("piece/arrow/Image"), function ()
		slot0:emit(ActivityMediator.FINISH_ACTIVITY_PERMANENT)
	end, SFX_PANEL)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.btnBack, function ()
		slot0:emit(slot1.ON_BACK)
	end, SOUND_BACK)
	slot0.updateEntrances(slot0)
	slot0:emit(ActivityMediator.SHOW_NEXT_ACTIVITY)
	slot0:bind(slot0.LOCK_ACT_MAIN, function (slot0, slot1)
		slot0.locked = slot1

		setActive(slot0.lockAll, slot1)
	end)
	slot0.bind(slot0, slot0.UPDATE_ACTIVITY, function (slot0, slot1)
		slot0:updateActivity(slot1)
	end)
end

slot0.setPlayer = function (slot0, slot1)
	slot0.shareData:SetPlayer(slot1)
end

slot0.setFlagShip = function (slot0, slot1)
	slot0.shareData:SetFlagShip(slot1)
end

slot0.updateTaskLayers = function (slot0)
	if not slot0.activity then
		return
	end

	slot0:updateActivity(slot0.activity)
end

slot0.instanceActivityPage = function (slot0, slot1)
	if slot1:getConfig("page_info").class_name and not slot0.pageDic[slot1.id] and not slot1:isEnd() then
		if import("view.activity.subPages." .. slot2.class_name).New(slot0.pageContainer, slot0.event, slot0.contextData):UseSecondPage(slot1) then
			slot4:SetUIName(slot2.ui_name2)
		else
			slot4:SetUIName(slot2.ui_name)
		end

		slot4:SetShareData(slot0.shareData)

		slot0.pageDic[slot1.id] = slot4
	end
end

slot0.setActivities = function (slot0, slot1)
	slot0.activities = slot1 or {}
	slot0.shareData = slot0.shareData or ActivityShareData.New()
	slot0.pageDic = slot0.pageDic or {}

	for slot5, slot6 in ipairs(slot1) do
		slot0:instanceActivityPage(slot6)
	end

	slot0.activity = nil

	table.sort(slot0.activities, function (slot0, slot1)
		if slot0:getShowPriority() == slot1:getShowPriority() then
			return slot1.id < slot0.id
		end

		return slot3 < slot2
	end)
	slot0.flushTabs(slot0)
end

slot0.getActivityIndex = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.activities) do
		if slot6.id == slot1 then
			return slot5
		end
	end

	return nil
end

slot0.updateActivity = function (slot0, slot1)
	if ActivityConst.PageIdLink[slot1.id] then
		slot1 = getProxy(ActivityProxy):getActivityById(ActivityConst.PageIdLink[slot1.id])
	end

	if slot1:isShow() and not slot1:isEnd() then
		slot0.activities[slot0:getActivityIndex(slot1.id) or #slot0.activities + 1] = slot1

		table.sort(slot0.activities, function (slot0, slot1)
			if slot0:getShowPriority() == slot1:getShowPriority() then
				return slot1.id < slot0.id
			end

			return slot3 < slot2
		end)

		if not slot0.pageDic[slot1.id] then
			slot0.instanceActivityPage(slot0, slot1)
		end

		slot0:flushTabs()

		if slot0.activity and slot0.activity.id == slot1.id then
			slot0.activity = slot1

			slot0.pageDic[slot1.id].ActionInvoke(slot2, "Flush", slot1)
			setActive(slot0.permanentFinshMask, pg.activity_task_permanent[slot1.id] and slot1:canPermanentFinish())
		end
	end
end

slot0.removeActivity = function (slot0, slot1)
	if slot0:getActivityIndex(slot1) then
		table.remove(slot0.activities, slot2)
		slot0.pageDic[slot1]:Destroy()

		slot0.pageDic[slot1] = nil

		slot0:flushTabs()

		if slot0.activity and slot0.activity.id == slot1 then
			slot0.activity = nil

			slot0:verifyTabs()
		end
	end
end

slot0.GetOnShowEntranceData = function ()
	slot0 = slot0 or require("GameCfg.activity.EntranceData")
	slot0 = slot0 or {}
	slot0 = slot0

	return _.select(_.select, function (slot0)
		return slot0.isShow and slot0.isShow()
	end)
end

slot0.updateEntrances = function (slot0)
	slot0.entranceList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = "empty"

			removeOnButton(slot2)

			slot5 = false

			if slot0[slot1 + 1] and table.getCount(slot3) ~= 0 and slot3.isShow() then
				onButton(slot1, slot2, function ()
					slot0:emit(slot1.event, slot1.data[1], slot1.data[2])
				end, SFX_PANEL)

				slot4 = slot3.banner

				if slot3.isTip then
					slot6 = slot3.isTip()
					slot5 = slot6
				end
			end

			setActive(slot2:Find("tip"), slot5)
			LoadImageSpriteAsync("activitybanner/" .. slot4, slot2)
		end
	end)
	slot0.entranceList.align(slot3, math.max(#slot0.GetOnShowEntranceData(), 5))
end

slot0.flushTabs = function (slot0)
	if not slot0.tabsList then
		slot0.tabsList = UIItemList.New(slot0.tabs, slot0.tab)

		slot0.tabsList:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventUpdate then
				if slot0.pageDic[slot0.activities[slot1 + 1].id] ~= nil then
					if slot3:getConfig("title_res_tag") then
						setImageSprite(slot0:findTF("off/text", slot2), GetSpriteFromAtlas("ui/activityui_atlas", slot5 .. "_text") or GetSpriteFromAtlas("ui/activityui_atlas", "activity_text"), true)
						setImageSprite(slot0:findTF("on/text", slot2), GetSpriteFromAtlas("ui/activityui_atlas", slot5 .. "_text_selected") or GetSpriteFromAtlas("ui/activityui_atlas", "activity_text_selected"), true)
						setActive(slot0:findTF("red", slot2), slot3:readyToAchieve())
						onToggle(slot0, slot2, function (slot0)
							if slot0 then
								slot0:selectActivity(slot0.selectActivity)
							end
						end, SFX_PANEL)
					else
						onToggle(slot0, slot2, function (slot0)
							slot0:loadActivityPanel(slot0, slot0.loadActivityPanel)
						end, SFX_PANEL)
					end

					triggerToggle(slot2, false)
				end
			end
		end)
	end

	setActive(slot0.tabs, false)
	slot0.tabsList.align(slot1, #slot0.activities)
	setActive(slot0.tabs, true)

	if slot0.activity and slot0:getActivityIndex(slot0.activity.id) then
		triggerToggle(slot0.tabs:GetChild(slot1 - 1), true)
	end
end

slot0.selectActivity = function (slot0, slot1)
	if slot1 and (not slot0.activity or slot0.activity.id ~= slot1.id) then
		slot0.pageDic[slot1.id].Load(slot2)
		slot0.pageDic[slot1.id].ActionInvoke(slot2, "Flush", slot1)
		slot0.pageDic[slot1.id]:ActionInvoke("ShowOrHide", true)

		if slot0.activity and slot0.activity.id ~= slot1.id then
			slot0.pageDic[slot0.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		slot0.activity = slot1
		slot0.contextData.id = slot1.id

		setActive(slot0.permanentFinshMask, pg.activity_task_permanent[slot1.id] and slot1:canPermanentFinish())
	end
end

slot0.verifyTabs = function (slot0, slot1)
	triggerToggle(slot0.tabs:GetChild((slot0:getActivityIndex(slot1) or 1) - 1), true)
end

slot0.loadActivityPanel = function (slot0, slot1, slot2)
	slot3 = slot2:getConfig("type")

	if nil and slot1 then
		slot0:emit(ActivityMediator.OPEN_LAYER, slot4)
	elseif slot4 and not slot1 then
		slot0:emit(ActivityMediator.CLOSE_LAYER, slot4.mediator)
	else
		print("------活动id为" .. slot2.id .. "类型为" .. slot2:getConfig("type") .. "的页面不存在")
	end
end

slot0.getBonusWindow = function (slot0, slot1, slot2)
	if not slot0:findTF(slot1) then
		PoolMgr.GetInstance():GetUI("ActivitybonusWindow", true, function (slot0)
			SetParent(slot0, slot0._tf, false)

			slot0.name = SetParent

			slot0(slot0)
		end)
	else
		slot2(slot3)
	end
end

slot0.ShowWindow = function (slot0, slot1, slot2)
	if not slot0.windowList[slot1.__cname] then
		slot0:getBonusWindow(slot3, function (slot0)
			slot0.windowList[] = slot2.New(tf(slot0), slot0)

			slot0.windowList[]:Show(slot2.New(tf(slot0), slot0))
		end)
	else
		slot0.windowList[slot3].Show(slot4, slot2)
	end
end

slot0.HideWindow = function (slot0, slot1)
	if not slot0.windowList[slot1.__cname] then
		return
	end

	slot0.windowList[slot2]:Hide()
end

slot0.willExit = function (slot0)
	slot0.shareData = nil

	for slot4, slot5 in pairs(slot0.pageDic) do
		slot5:Destroy()
	end

	for slot4, slot5 in pairs(slot0.windowList) do
		slot5:Dispose()
	end
end

return slot0

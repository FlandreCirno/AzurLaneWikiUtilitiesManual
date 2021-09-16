slot0 = class("IdolMasterMedalCollectionView", import("view.base.BaseUI"))
slot0.FADE_OUT_TIME = 1
slot0.PAGE_NUM = 7
slot0.MEDAL_NUM_PER_PAGE = 2
slot0.MEDAL_STATUS_UNACTIVATED = 1
slot0.MEDAL_STATUS_ACTIVATED = 2
slot0.MEDAL_STATUS_ACTIVATABLE = 3
slot0.INDEX_CONVERT = {
	1,
	2,
	5,
	6,
	7,
	4,
	3
}

slot0.getUIName = function (slot0)
	return "IdolMasterMedalCollectionUI"
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
end

slot0.didEnter = function (slot0)
	slot0:checkAward()
	setText(slot0.progressText, setColorStr(tostring(#slot0.activeIDList), "#8CD5FFFF") .. "/" .. #slot0.allIDList)
	triggerToggle(slot0.switchBtnList[1], true)
end

slot0.willExit = function (slot0)
	if LeanTween.isTweening(go(slot0.photo)) then
		LeanTween.cancel(go(slot0.photo), false)
	end
end

slot0.initData = function (slot0)
	slot0.activityProxy = getProxy(ActivityProxy)
	slot0.activityData = slot0.activityProxy:getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID)
	slot0.allIDList = IdolMasterMedalCollectionMediator.GetPicturePuzzleIds(slot0.activityData.id)
	slot0.pageIDList = {}

	for slot4 = 1, slot0.PAGE_NUM, 1 do
		slot5 = slot0.INDEX_CONVERT[slot4]
		slot0.pageIDList[slot4] = {}

		for slot9 = 1, slot0.MEDAL_NUM_PER_PAGE, 1 do
			slot0.pageIDList[slot4][slot9] = slot0.allIDList[(slot5 - 1) * slot0.MEDAL_NUM_PER_PAGE + slot9]
		end
	end

	slot0.activatableIDList = slot0.activityData.data1_list
	slot0.activeIDList = slot0.activityData.data2_list
	slot0.curPage = nil
	slot0.newMedalID = nil
end

slot0.findUI = function (slot0)
	slot0.bg = slot0:findTF("BG")
	slot1 = slot0:findTF("NotchAdapt")
	slot0.backBtn = slot0:findTF("BackBtn", slot1)
	slot0.progressText = slot0:findTF("ProgressImg/ProgressText", slot1)
	slot0.helpBtn = slot0:findTF("HelpBtn", slot1)
	slot0.tplButtom = findTF(slot2, "tplButtom")
	slot0.imgGot = slot0:findTF("ProgressImg/got", slot1)
	slot0.switchBtnList = {}

	for slot6 = 1, slot0.PAGE_NUM, 1 do
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "icon" .. slot6, function (slot0)
			if slot0 then
				setImageSprite(findTF(slot0, "icon"), slot0, true)
			end
		end)
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "iconSelect" .. slot6, function (slot0)
			if slot0 then
				setImageSprite(findTF(slot0, "iconSelect"), slot0, true)
			end
		end)
		setParent(slot7, slot2)
		setActive(slot7, true)
		table.insert(slot0.switchBtnList, tf(instantiate(go(slot0.tplButtom))))
	end

	slot0.infoNode = slot0:findTF("book/info")
	slot0.photoNode = slot0:findTF("book/photo")
	slot0.photo = slot0:findTF("got", slot0.photoNode)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.idolmaster_collection.tip
		})
	end, SFX_PANEL)

	for slot4, slot5 in ipairs(slot0.switchBtnList) do
		onToggle(slot0, slot5, function (slot0)
			if slot0 == true then
				slot0.curPage = slot0.curPage ~= 

				slot0:updateSwitchBtnTF()
				slot0:updateMedalContainerView(slot0.curPage ~= , )
			end
		end, SFX_PANEL)
	end
end

slot0.UpdateActivity = function (slot0, slot1)
	slot0:checkAward()
end

slot0.updateMedalContainerView = function (slot0, slot1, slot2)
	slot0:updatePhotoNode(slot0.pageIDList[slot1][1], slot2)
	slot0:updateInfoNode(slot0.pageIDList[slot1][2])
end

slot0.getMedalStatus = function (slot0, slot1)
	slot4 = not table.contains(slot0.activeIDList, slot1) and not (table.contains(slot0.activatableIDList, slot1) and not table.contains(slot0.activeIDList, slot1))

	if slot2 then
		return slot0.MEDAL_STATUS_ACTIVATED
	elseif slot3 then
		return slot0.MEDAL_STATUS_ACTIVATABLE
	elseif slot4 then
		return slot0.MEDAL_STATUS_UNACTIVATED
	end
end

slot0.updatePhotoNode = function (slot0, slot1, slot2)
	slot3 = slot0:findTF("task", slot0.photoNode)
	slot4 = slot0:findTF("get", slot0.photoNode)
	slot5 = slot0:findTF("got", slot0.photoNode)
	slot7 = (slot0.curPage - 1) * slot0.MEDAL_NUM_PER_PAGE + 1

	if slot0:getMedalStatus(slot1) == slot0.MEDAL_STATUS_UNACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "task" .. slot7, function (slot0)
			setImageSprite(slot0, slot0, true)
			setActive(slot0, true)
		end)
	else
		setActive(slot3, false)
	end

	if slot6 == slot0.MEDAL_STATUS_ACTIVATED then
		if slot2 then
			setActive(slot0.photo, false)
			LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "photo" .. slot0.curPage, function (slot0)
				setImageSprite(slot0.photo, slot0, true)

				if LeanTween.isTweening(go(slot0.photo)) then
					LeanTween.cancel(go(slot0.photo), false)
				end

				GetComponent(slot0.photo, typeof(CanvasGroup)).alpha = 0

				LeanTween.value(go(slot0.photo), 0, 1, 0.3):setOnUpdate(System.Action_float(function (slot0)
					GetComponent(slot0.photo, typeof(CanvasGroup)).alpha = slot0
				end))
				setActive(slot0.photo, true)
			end)
		else
			LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "photo" .. slot0.curPage, function (slot0)
				setImageSprite(slot0.photo, slot0, true)
				setActive(slot0.photo, true)
			end)
		end
	else
		setActive(slot0.photo, false)
	end

	setActive(slot4, slot6 == slot0.MEDAL_STATUS_ACTIVATABLE)

	if slot6 == slot0.MEDAL_STATUS_ACTIVATABLE then
		onButton(slot0, slot0.photoNode, function ()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = slot0,
				actId = slot1.activityData.id
			})
		end, SFX_PANEL)
	end
end

slot0.updateInfoNode = function (slot0, slot1)
	slot2 = slot0:findTF("task", slot0.infoNode)
	slot3 = slot0:findTF("get", slot0.infoNode)
	slot4 = slot0:findTF("got", slot0.infoNode)
	slot6 = (slot0.curPage - 1) * slot0.MEDAL_NUM_PER_PAGE + 2

	if slot0:getMedalStatus(slot1) == slot0.MEDAL_STATUS_UNACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "task" .. slot6, function (slot0)
			setImageSprite(slot0, slot0, true)
			setActive(slot0, true)
		end)
	else
		setActive(slot2, false)
	end

	if slot5 == slot0.MEDAL_STATUS_ACTIVATED then
		LoadSpriteAtlasAsync("ui/idolmastermedalcollectionui_atlas", "info" .. slot0.curPage, function (slot0)
			setImageSprite(slot0, slot0, true)
			setActive(slot0, true)
		end)
	else
		setActive(slot4, false)
	end

	setActive(slot3, slot5 == slot0.MEDAL_STATUS_ACTIVATABLE)

	if slot5 == slot0.MEDAL_STATUS_ACTIVATABLE then
		onButton(slot0, slot0.infoNode, function ()
			pg.m02:sendNotification(GAME.MEMORYBOOK_UNLOCK, {
				id = slot0,
				actId = slot1.activityData.id
			})
		end, SFX_PANEL)
	end
end

slot0.updateSwitchBtnTF = function (slot0)
	for slot4, slot5 in ipairs(slot0.switchBtnList) do
		slot6 = slot0:findTF("tip", slot5)

		if slot0:caculateActivatable(slot4) == 0 or slot4 == slot0.curPage then
			setActive(slot6, false)
		end

		if slot7 > 0 and slot4 ~= slot0.curPage then
			setActive(slot6, true)
		end

		setActive(slot0:findTF("icon", slot5), not (slot4 == slot0.curPage))
		setActive(slot0:findTF("iconSelect", slot5), slot4 == slot0.curPage)
	end
end

slot0.updateAfterSubmit = function (slot0, slot1)
	slot0.activityProxy = getProxy(ActivityProxy)
	slot0.activityData = slot0.activityProxy:getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID)
	slot0.activatableIDList = slot0.activityData.data1_list
	slot0.activeIDList = slot0.activityData.data2_list
	slot0.newMedalID = slot1

	triggerToggle(slot0.switchBtnList[slot0.curPage], true)
	setText(slot0.progressText, setColorStr(tostring(#slot0.activeIDList), COLOR_WHITE) .. "/" .. #slot0.allIDList)
	slot0:checkAward()
end

slot0.isHaveActivableMedal = function ()
	if not getProxy(ActivityProxy):getActivityById(ActivityConst.IDOL_MASTER_MEDAL_ID) or slot0:isEnd() then
		return
	end

	slot1 = slot0.data1_list
	slot2 = slot0.data2_list

	for slot7, slot8 in ipairs(slot3) do
		slot10 = table.contains(slot1, slot8)

		if not table.contains(slot2, slot8) and slot10 then
			return true
		end
	end

	return false
end

slot0.caculateActivatable = function (slot0, slot1)
	slot3 = 0

	for slot7, slot8 in ipairs(slot2) do
		slot10 = table.contains(slot0.activatableIDList, slot8)

		if not table.contains(slot0.activeIDList, slot8) and slot10 then
			slot3 = slot3 + 1
		end
	end

	return slot3
end

slot0.checkAward = function (slot0)
	setActive(slot0.imgGot, #slot0.activeIDList == #slot0.allIDList and slot0.activityData.data1 == 1)

	if #slot0.activeIDList == #slot0.allIDList and slot0.activityData.data1 ~= 1 then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = ActivityConst.IDOL_MASTER_MEDAL_ID
		})
		setActive(slot0.imgGot, true)
	end
end

return slot0

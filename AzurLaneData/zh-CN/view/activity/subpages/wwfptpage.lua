slot0 = class("WWFPtPage", import(".TemplatePage.PtTemplatePage"))
slot1 = 6000

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.helpBtn = slot0:findTF("help_btn", slot0.bg)
	slot0.collectBtn = slot0:findTF("collect_btn", slot0.bg)
	slot0.taskRedDot = slot0:findTF("red_dot", slot0.collectBtn)
	slot0.resNumTF = slot0:findTF("res_num", slot0.collectBtn)
	slot0.title = slot0:findTF("title", slot0.bg)
	slot0.tags = slot0:findTF("tags", slot0.bg)
	slot0.convertBtn = slot0:findTF("convert_btn", slot0.bg)
	slot0.switchBtn = slot0:findTF("switch_btn", slot0.bg)
	slot0.switchRedDot = slot0:findTF("red_dot", slot0.switchBtn)
	slot0.paintings = {
		slot0:findTF("paintings/ninghai", slot0.bg),
		slot0:findTF("paintings/pinghai", slot0.bg)
	}
	slot0.anim = slot0:findTF("anim", slot0.bg)
	slot0.ninghaiTF = slot0:findTF("anim/panda_anim/ninghai", slot0.bg)
	slot0.pinghaiTF = slot0:findTF("anim/panda_anim/pinghai", slot0.bg)
	slot0.heartImages = slot0:findTF("hearts", slot0.bg)
	slot0.step2 = slot0:findTF("step2", slot0.bg)
	slot0.taskWindow = slot0:findTF("TaskWindow")
	slot0.closeBtn = slot0:findTF("panel/close_btn", slot0.taskWindow)
	slot0.maskBtn = slot0:findTF("mask", slot0.taskWindow)
	slot0.item = slot0:findTF("panel/scrollview/item", slot0.taskWindow)
	slot0.items = slot0:findTF("panel/scrollview/items", slot0.taskWindow)
	slot0.uilist = UIItemList.New(slot0.items, slot0.item)
	slot0.typeImages = slot0:findTF("panel/tags", slot0.taskWindow)
	slot0.barImages = slot0:findTF("panel/bars", slot0.taskWindow)
	slot0.guide = slot0:findTF("Guide")
	slot0.guideTarget = slot0:findTF("target", slot0.guide)
	slot0.guideContent = slot0:findTF("dialogBox/content", slot0.guide)
end

slot0.OnDataSetting = function (slot0)
	slot0.titleTxts = {
		i18n("wwf_bamboo_tip1"),
		i18n("wwf_bamboo_tip2")
	}
	slot0.resID = slot0.activity:getConfig("config_client").convertRes
	slot0.subActivities = slot0.activity:getConfig("config_client").ptActID
	slot0.taskList = slot0.activity:getConfig("config_data")

	slot0:initPtData()
	slot0:initTaskData()
	slot0:initLocalData()
end

slot0.initPtData = function (slot0)
	slot0.subPtDate = {}

	for slot4, slot5 in ipairs(slot0.subActivities) do
		slot6 = getProxy(ActivityProxy):getActivityById(slot5)

		if slot0.subPtDate[slot5] then
			slot0.subPtDate[slot5]:Update(slot6)
		else
			slot0.subPtDate[slot5] = ActivityPtData.New(slot6)
		end
	end

	slot0.resNum = getProxy(PlayerProxy):getRawData():getResource(slot0.resID)
end

slot0.setPtActIndex = function (slot0)
	slot0.curActIndex = slot0.lastSelectIndex
	slot0.curSubActID = slot0.subActivities[slot0.curActIndex]
	slot3 = slot0.subPtDate[slot0.subActivities[(slot0.curActIndex == 1 and 2) or 1]]:CanGetAward()

	if not slot0.subPtDate[slot0.curSubActID]:CanGetMorePt() or slot3 then
		slot0.curActIndex = slot1
		slot0.curSubActID = slot0.subActivities[slot0.curActIndex]

		PlayerPrefs.SetInt("wwf_select_index_" .. slot0.playerId, slot0.lastSelectIndex)
		PlayerPrefs.Save()
	end
end

slot0.setStep2Progress = function (slot0)
	setImageSprite(slot0.step2, slot0.heartImages:Find(tostring(slot0.curActIndex)):GetComponent(typeof(Image)).sprite)

	slot0.step2:GetComponent(typeof(Image)).fillAmount = slot0.subPtDate[slot0.curSubActID].count / slot0
end

slot0.initTaskData = function (slot0)
	slot0.taskProxy = getProxy(TaskProxy)
	slot0.curTask = {}
	slot0.todoTaskNum = 0

	for slot4, slot5 in ipairs(slot0.taskList) do
		if slot0.taskProxy:getTaskById(slot5) or slot0.taskProxy:getFinishTaskById(slot5) then
			table.insert(slot0.curTask, slot6.id)

			if slot6:getTaskStatus() == 0 then
				slot0.todoTaskNum = slot0.todoTaskNum + 1
			end
		end
	end
end

slot0.initLocalData = function (slot0)
	slot0.playerId = getProxy(PlayerProxy):getData().id
	slot0.isFirst = PlayerPrefs.GetInt("wwf_first_" .. slot0.playerId)

	if PlayerPrefs.GetInt("wwf_select_index_" .. slot0.playerId) == 0 then
		slot0.lastSelectIndex = 1
	else
		slot0.lastSelectIndex = PlayerPrefs.GetInt("wwf_select_index_" .. slot0.playerId)
	end

	slot0.showTaskRedDot = false

	if ((PlayerPrefs.GetInt("wwf_todo_task_num_" .. slot0.playerId) == 0 and not slot0.todoTaskNum == 0) or slot1 < slot0.todoTaskNum) and not slot0:isFinishAllAct() then
		slot0.showTaskRedDot = true
	end

	slot0.hasClickTask = false

	PlayerPrefs.SetInt("wwf_todo_task_num_" .. slot0.playerId, slot0.todoTaskNum)
	PlayerPrefs.Save()
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.awardTF, function ()
		slot0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = slot0.subPtDate[slot0.curSubActID].type,
			dropList = slot0.subPtDate[slot0.curSubActID].dropList,
			targets = slot0.subPtDate[slot0.curSubActID].targets,
			level = slot0.subPtDate[slot0.curSubActID].level,
			count = slot0.subPtDate[slot0.curSubActID].count,
			resId = slot0.subPtDate[slot0.curSubActID].resId
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.getBtn, function ()
		slot3 = getProxy(PlayerProxy).getData(slot2)

		if slot0.subPtDate[slot0.curSubActID]:GetAward().type == DROP_TYPE_RESOURCE and slot1.id == PlayerConst.ResGold and slot3:GoldMax(slot1.count) then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = slot0
				})
			end)
		end

		function slot4()
			if not slot0.subPtDate[slot0.curSubActID]:CanGetNextAward() then
				triggerButton(slot0.switchBtn)
			end
		end

		seriesAsync(slot0, function ()
			slot2, slot5.arg1 = slot0.subPtDate[slot0.curSubActID]:GetResProgress()

			slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = slot0.subPtDate[slot0.curSubActID]:GetId(),
				arg1 = slot1,
				callback = slot1
			})
		end)
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("wwf_bamboo_help")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.convertBtn, function ()
		if slot0.resNum <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("wwf_bamboo_tip3"))
			pg.TipsMgr.GetInstance().ShowTips:openTask()
		else
			slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 5,
				activity_id = slot0.curSubActID,
				arg1 = slot0.resID
			})
			slot0.emit:playSpineAni()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.switchBtn, function ()
		if slot0.isSwitching then
			return
		end

		slot0.curActIndex = (slot0.curActIndex == 1 and 2) or 1
		slot0.lastSelectIndex = slot0.curActIndex

		PlayerPrefs.SetInt("wwf_select_index_" .. slot0.playerId, slot0.lastSelectIndex)
		PlayerPrefs.Save()

		PlayerPrefs.Save.curSubActID = slot0.subActivities[slot0.curActIndex]

		PlayerPrefs.Save:OnUpdatePtAct()
		PlayerPrefs.Save.OnUpdatePtAct:playPaintingAni()
		PlayerPrefs.Save.OnUpdatePtAct.playPaintingAni:setStep2Progress()
	end, SFX_PANEL)
	onButton(slot0, slot0.collectBtn, function ()
		slot0:openTask()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:closeTask()
	end, SFX_PANEL)
	onButton(slot0, slot0.maskBtn, function ()
		slot0:closeTask()
	end, SFX_PANEL)
	onButton(slot0, slot0.guideTarget, function ()
		setActive(slot0.guide, false)
		setActive:openTask()
		PlayerPrefs.SetInt("wwf_first_" .. slot0.playerId, 1)
		PlayerPrefs.Save()

		if #PlayerPrefs.Save.finishItemList > 0 then
			slot0:autoFinishTask()
		end
	end, SFX_PANEL)

	slot1 = "ninghai_7"
	slot2 = "pinghai_7"

	if not slot0.model1 then
		pg.UIMgr.GetInstance().LoadingOn(slot3)
		PoolMgr.GetInstance():GetSpineChar(slot1, true, function (slot0)
			pg.UIMgr.GetInstance():LoadingOff()

			slot0.prefab1 = slot0
			slot0.model1 = slot0
			tf(slot0).localScale = Vector3(1, 1, 1)

			setParent(slot0, slot0.ninghaiTF)
			setActive(slot0, false)
		end)
	end

	if not slot0.model2 then
		pg.UIMgr.GetInstance().LoadingOn(slot3)
		PoolMgr.GetInstance():GetSpineChar(slot2, true, function (slot0)
			pg.UIMgr.GetInstance():LoadingOff()

			slot0.prefab2 = slot0
			slot0.model2 = slot0
			tf(slot0).localScale = Vector3(1, 1, 1)

			setParent(slot0, slot0.pinghaiTF)
			setActive(slot0, false)
		end)
	end

	slot0.setPtActIndex(slot0)
	slot0:setStep2Progress()
	slot0:initTaskWindow()

	if slot0.isFirst == 0 then
		setActive(slot0.guide, true)
		setText(slot0.guideContent, i18n("wwf_guide_tip"))
	elseif #slot0.finishItemList > 0 then
		slot0:openTask()
		slot0:autoFinishTask()
	end
end

slot0.OnUpdateFlush = function (slot0)
	for slot4, slot5 in ipairs(slot0.subActivities) do
		slot6 = getProxy(ActivityProxy):getActivityById(slot5)

		if slot0.subPtDate[slot5] then
			slot0.subPtDate[slot5]:Update(slot6)
		else
			slot0.subPtDate[slot5] = ActivityPtData.New(slot6)
		end
	end

	slot0.resNum = getProxy(PlayerProxy):getRawData().getResource(slot1, slot0.resID)

	setText(slot0.resNumTF, slot0.resNum)
	slot0:OnUpdatePtAct()

	GetOrAddComponent(slot0.paintings[slot0.curActIndex], typeof(CanvasGroup)).alpha = 1
	GetOrAddComponent(slot0.paintings[(slot0.curActIndex == 1 and 2) or 1], typeof(CanvasGroup)).alpha = 0
end

slot0.OnUpdatePtAct = function (slot0)
	setText(slot0.title, slot0.titleTxts[slot0.curActIndex])
	eachChild(slot0.tags, function (slot0)
		setActive(slot0, tonumber(slot0.name) == slot0.curActIndex)
	end)

	slot1, slot2, slot3 = slot0.subPtDate[slot0.curSubActID].GetLevelProgress(slot1)
	slot4, slot5, slot6 = slot0.subPtDate[slot0.curSubActID]:GetResProgress()

	eachChild(slot0.step, function (slot0)
		setActive(slot0, (tonumber(slot0.name) < slot0 and true) or false)
	end)
	setText(slot0.progress, ((slot6 >= 1 and setColorStr(slot4, "#94D979")) or slot4) .. "/" .. slot5)
	updateDrop(slot0.awardTF, setText)

	slot9 = slot0.subPtDate[slot0.curSubActID]:CanGetNextAward()
	slot10 = slot0.subPtDate[slot0.curSubActID]:CanGetMorePt()

	setActive(slot0.convertBtn, not slot0.subPtDate[slot0.curSubActID]:CanGetAward())
	setActive(slot0.getBtn, slot0.progress)
	setActive(slot0.gotBtn, not slot9)
	setActive(slot0:findTF("10", slot0.step), not slot9)
	setActive(slot0.switchRedDot, not slot9 and not slot0:isFinishAllAct())
	setActive(slot0.taskRedDot, slot0.showTaskRedDot and not slot0.hasClickTask)
end

slot0.playPaintingAni = function (slot0)
	slot0.isSwitching = true
	slot1 = slot0.curActIndex
	slot2 = (slot0.curActIndex == 1 and 2) or 1
	slot5 = GetOrAddComponent(slot3, typeof(CanvasGroup))
	slot6 = GetOrAddComponent(slot4, typeof(CanvasGroup))

	LeanTween.value(go(slot4), 1, 0, 0.4):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end)).setOnComplete(slot7, System.Action(function ()
		LeanTween.value(go(slot0), 0, 1, 0.4):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
		end)).setOnComplete(slot0, System.Action(function ()
			slot0.isSwitching = false
		end))
	end))
end

slot0.playSpineAni = function (slot0)
	setActive(slot0.anim, true)

	slot2 = slot0:findTF("panda_anim", slot0.anim)
	slot3 = slot0:findTF("heart_anim", slot0.anim)

	setActive(slot2, true)

	GetOrAddComponent(slot2, typeof(CanvasGroup)).alpha = 1

	LeanTween.value(go(slot2), 0, 1, 0.4):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))

	function slot5()
		LeanTween.value(go(slot0), 1, 0, ):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
		end))
		LeanTween.scale(LeanTween.scale, Vector3(1, 0, 1), ).setFrom(slot0, Vector3(1, 1, 1)):setOnComplete(System.Action(function ()
			setActive(setActive, false)
		end))
		setActive(slot3, true)
		LeanTween.delayedCall(2, System.Action(function ()
			setActive(setActive, false)
			LeanTween.value(go(slot1.step2), slot0, slot1.step2.subPtDate[slot1.curSubActID].count / slot2, 1):setOnUpdate(System.Action_float(function (slot0)
				slot0.step2:GetComponent(typeof(Image)).fillAmount = slot0
			end)).setOnComplete(slot2, System.Action(function ()
				setActive(slot0.anim, false)

				setActive.heartAni = false
			end))
		end))
	end

	slot6 = (slot0.curActIndex == 1 and slot0.model1) or slot0.model2

	LeanTween.scale(slot2, Vector3(1, 1, 1), slot1):setFrom(Vector3(1, 0, 1)):setOnComplete(System.Action(function ()
		setActive(setActive, true)
		setActive:GetComponent("SpineAnimUI"):SetActionCallBack(function (slot0)
			if slot0 == "finish" then
				slot0:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
				setActive(slot0, false)
				setActive()
			end
		end)
		setActive.GetComponent("SpineAnimUI").SetActionCallBack.GetComponent(slot0, "SpineAnimUI"):SetAction("event", 0)
	end))

	slot0.heartAni = false

	onButton(slot0, slot0.anim, function ()
		if slot0.heartAni then
			return
		end

		slot1:GetComponent("SpineAnimUI"):SetActionCallBack(nil)
		setActive(slot1.GetComponent("SpineAnimUI"), false)

		setActive.heartAni = true

		false()
	end, SFX_PANEL)
end

slot0.initTaskWindow = function (slot0)
	slot0.finishItemList = {}
	slot0.finishTaskVOList = {}

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot0:findTF("item", slot2), slot8)
			onButton(slot0, slot0.findTF("item", slot2), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setText(slot0:findTF("description", slot2), slot0.taskProxy:getTaskById(slot0.curTask[slot1 + 1]) or slot0.taskProxy:getFinishTaskById(slot5):getConfig("desc"))
			setText(slot0:findTF("progressText", slot2), slot9 .. "/" .. slot10)
			setSlider(slot0:findTF("progress", slot2), 0, slot10, slot0.taskProxy.getTaskById(slot0.curTask[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5).getProgress(slot6))

			slot11 = slot0:findTF("go_btn", slot2)

			if slot6:getTaskStatus() == 1 then
				table.insert(slot0.finishItemList, slot2)
				table.insert(slot0.finishTaskVOList, slot6)
			end

			setActive(slot0:findTF("finnal", slot2), slot12 == 2)
			onButton(slot0, slot11, function ()
				slot0:emit(ActivityMediator.ON_TASK_GO, slot0)
			end, SFX_PANEL)
			setImageSprite(slot0:findTF("type", slot2), slot0.typeImages:Find(tostring(setActive)):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(slot0:findTF("progress/slider", slot2), slot0.barImages:Find(tostring(setActive)):GetComponent(typeof(Image)).sprite)
		end
	end)
	slot0.uilist.align(slot1, #slot0.curTask)
	setActive(slot0.taskWindow, false)
end

slot0.closeTask = function (slot0)
	setActive(slot0.taskWindow, false)
end

slot0.openTask = function (slot0)
	if not slot0.curSubActID then
		slot0:setPtActIndex()
		slot0:setStep2Progress()
	end

	setActive(slot0.taskWindow, true)

	if slot0.showTaskRedDot then
		setActive(slot0.taskRedDot, false)
		getProxy(ActivityProxy):updateActivity(slot0.activity)
	end

	slot0.hasClickTask = true

	eachChild(slot0.items, function (slot0)
		if isActive(slot0:findTF("finnal", slot0)) then
			slot0:SetAsLastSibling()
		end
	end)
end

slot0.autoFinishTask = function (slot0)
	slot1 = 0.01
	slot2 = 0.5

	for slot6, slot7 in ipairs(slot0.finishItemList) do
		slot8 = GetOrAddComponent(slot7, typeof(CanvasGroup))

		slot0:managedTween(LeanTween.delayedCall, function ()
			slot0:SetAsFirstSibling()
			LeanTween.value(go(slot0), 1, 0, ):setOnUpdate(System.Action_float(function (slot0)
				slot0.alpha = slot0
			end)).setOnComplete(slot0, System.Action(function ()
				slot0.alpha = 1

				setActive(1:findTF("finnal", 1), true)
				slot2:SetAsLastSibling()
			end))
		end, slot1, nil)

		slot1 = slot1 + slot2 + 0.1
	end

	slot0:managedTween(LeanTween.delayedCall, function ()
		pg.m02:sendNotification(GAME.SUBMIT_TASK_ONESTEP, {
			resultList = slot0.finishTaskVOList
		})
	end, slot1, nil)
end

slot0.canFinishTask = function (slot0)
	slot1 = false

	for slot5, slot6 in pairs(slot0.curTask) do
		if slot0.taskProxy:getTaskById(slot6) or slot0.taskProxy:getFinishTaskById(slot6):getTaskStatus() == 1 then
			slot1 = true

			break
		end
	end

	return slot1
end

slot0.canAddProgress = function (slot0)
	slot1 = false

	for slot5, slot6 in pairs(slot0.subPtDate) do
		slot7, slot8, slot9 = slot6:GetResProgress()

		if slot0.resNum >= slot8 - slot7 and slot6:CanGetNextAward() then
			slot1 = true

			break
		end
	end

	return slot1
end

slot0.canGetPtAward = function (slot0)
	slot1 = false

	for slot5, slot6 in pairs(slot0.subPtDate) do
		if slot6:CanGetAward() then
			slot1 = true

			break
		end
	end

	return slot1
end

slot0.isFinishAllAct = function (slot0)
	slot1 = true

	for slot5, slot6 in pairs(slot0.subPtDate) do
		if slot6:CanGetNextAward() then
			slot1 = false

			break
		end
	end

	return slot1
end

slot0.isNewTask = function (slot0)
	slot0.playerId = getProxy(PlayerProxy):getData().id

	if (PlayerPrefs.GetInt("wwf_todo_task_num_" .. slot0.playerId) == 0 and not slot0.todoTaskNum == 0) or slot1 < slot0.todoTaskNum then
		return true
	else
		return false
	end
end

slot0.IsShowRed = function (slot0)
	slot0.resID = pg.activity_template[ActivityConst.WWF_TASK_ID].config_client.convertRes
	slot0.subActivities = pg.activity_template[ActivityConst.WWF_TASK_ID].config_client.ptActID
	slot0.taskList = pg.activity_template[ActivityConst.WWF_TASK_ID].config_data

	slot0:initPtData()
	slot0:initTaskData()

	if slot0:isFinishAllAct() then
		return false
	else
		return slot0:canFinishTask() or slot0:canGetPtAward() or slot0:canAddProgress() or slot0:isNewTask()
	end

	return false
end

slot0.OnDestroy = function (slot0)
	if slot0.prefab1 and slot0.model1 then
		PoolMgr.GetInstance():ReturnSpineChar(slot0.prefab1, slot0.model1)

		slot0.prefab1 = nil
		slot0.model1 = nil
	end

	if slot0.prefab2 and slot0.model2 then
		PoolMgr.GetInstance():ReturnSpineChar(slot0.prefab2, slot0.model2)

		slot0.prefab2 = nil
		slot0.model2 = nil
	end

	slot0:cleanManagedTween()
end

return slot0

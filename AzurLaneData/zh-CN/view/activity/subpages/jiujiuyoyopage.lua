slot0 = class("JiujiuYoyoPage", import("...base.BaseActivityPage"))
slot1 = PLATFORM_CODE == PLATFORM_JP

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.helpBtn = slot0:findTF("help_btn", slot0.bg)
	slot0.taskBtn = slot0:findTF("task_btn", slot0.bg)
	slot0.taskRedDot = slot0:findTF("red_dot", slot0.taskBtn)
	slot0.ticketNumTF = slot0:findTF("ticket_num", slot0.bg)
	slot0.rollingCountTF = slot0:findTF("rolling_count", slot0.bg)
	slot0.rollingBlink = slot0:findTF("blink", slot0.bg)

	if slot0 then
		slot0.awardTpl = slot0:findTF("item_jp", slot0.bg)
		slot0.awardContainter = slot0:findTF("award_list_jp", slot0.bg)
	else
		slot0.awardTpl = slot0:findTF("item", slot0.bg)
		slot0.awardContainter = slot0:findTF("award_list", slot0.bg)
	end

	slot0.awardUIList = UIItemList.New(slot0.awardContainter, slot0.awardTpl)
	slot0.finalGot = slot0:findTF("final_got_jp", slot0.bg)
	slot0.rollingAni = slot0:findTF("rolling_mask", slot0.bg)
	slot0.rollingSpine = slot0:findTF("rolling", slot0.rollingAni):GetComponent("SpineAnimUI")
	slot0.rollingGraphic = slot0:findTF("rolling", slot0.rollingAni):GetComponent("SkeletonGraphic")
	slot0.forbidMask = slot0:findTF("forbid_mask", slot0.bg)
	slot0.taskWindow = slot0:findTF("TaskWindow")
	slot0.closeBtn = slot0:findTF("panel/close_btn", slot0.taskWindow)
	slot0.taskTpl = slot0:findTF("panel/scrollview/item", slot0.taskWindow)
	slot0.taskContainter = slot0:findTF("panel/scrollview/items", slot0.taskWindow)
	slot0.taskUIList = UIItemList.New(slot0.taskContainter, slot0.taskTpl)

	slot0:register()
end

slot0.register = function (slot0)
	slot0:bind(ActivityMediator.ON_SHAKE_BEADS_RESULT, function (slot0, slot1)
		slot0:displayResult(slot1.awards, slot1.number, function ()
			slot0.callback()
		end)
	end)
end

slot0.OnDataSetting = function (slot0)
	slot0.taskProxy = getProxy(TaskProxy)
	slot0.taskList = pg.activity_template[slot0.activity:getConfig("config_client").taskActID].config_data
	slot0.startTime = pg.TimeMgr.GetInstance():parseTimeFromConfig(slot0.activity:getConfig("time")[2])
	slot0.totalNumList = {}
	slot0.remainNumList = {}
	slot0.remainTotalNum = 0
	slot0.awardList = {}
	slot0.finalAward = slot0.activity:getConfig("config_client").finalAward
	slot0.awardConifg = slot0.activity:getConfig("config_client").award
	slot0.beadsConfig = slot0.activity:getConfig("config_data")[1]

	for slot5, slot6 in ipairs(slot0.beadsConfig) do
		slot0.awardList[slot6[1]] = slot0.awardConifg[slot6[1]]
		slot0.totalNumList[slot6[1]] = slot6[2]
	end
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("tips_shakebeads")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.taskBtn, function ()
		slot0:openTask()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:closeTask()
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("mask", slot0.taskWindow), function ()
		slot0:closeTask()
	end, SFX_PANEL)
	onButton(slot0, slot0.rollingBlink, function ()
		if slot0.ticketNum <= 0 then
			return
		end

		slot0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 1,
			activity_id = slot0.activity.id
		})
	end, SFX_PANEL)
	setActive(slot0.taskRedDot, false)

	if LeanTween.isTweening(slot0.rollingBlink) then
		LeanTween.cancel(slot0.rollingBlink)
	end

	setImageAlpha(slot0.rollingBlink, 1)
	blinkAni(slot0.rollingBlink, 0.5)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.curDay = pg.TimeMgr.GetInstance():DiffDay(slot0.startTime, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	slot0.ticketNum = slot0.activity.data1
	slot0.hasNumList = slot0.activity.data1KeyValueList[1]
	slot0.remainTotalNum = 0

	for slot4, slot5 in ipairs(slot0.beadsConfig) do
		if not slot0.hasNumList[slot5[1]] then
			slot0.hasNumList[slot6] = 0
		end

		slot0.remainNumList[slot6] = slot0.totalNumList[slot6] - slot0.hasNumList[slot6]
		slot0.remainTotalNum = slot0.remainTotalNum + slot0.remainNumList[slot6]
	end

	setText(slot0.ticketNumTF, slot0.ticketNum)
	setText(slot0.rollingCountTF, slot0.remainTotalNum)
	setActive(slot0.rollingBlink, slot0.ticketNum > 0)
	slot0:initAwardList()
	slot0:initTaskWindow()

	slot0.isFirst = PlayerPrefs.GetInt("jiujiuyoyo_first_" .. getProxy(PlayerProxy):getData().id)

	if slot0.isFirst == 0 then
		setActive(slot0.taskRedDot, true)
	end

	if #slot0.finishItemList > 0 then
		slot0:openTask()
	end

	setActive(slot0.finalGot, slot0 and slot0.activity.data2 == 1)
	slot0:CheckFinalAward()
end

slot0.initAwardList = function (slot0)
	slot0.awardUIList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = slot0.totalNumList[slot1 + 1]

			if slot0.remainNumList[slot1 + 1] == 0 then
				setTextColor(slot0:findTF("num", slot2), Color.New(0.55, 0.55, 0.55, 1))
				setOutlineColor(slot0:findTF("num", slot2), Color.New(0.26, 0.26, 0.26, 1))
			end

			setText(slot0:findTF("num", slot2), slot5 .. "/" .. slot4)
			setActive(slot0:findTF("got", slot2), slot5 == 0)
			updateDrop(setActive, slot5 == 0)
			onButton(slot0, slot0:findTF("award_mask/award", slot2), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
		end
	end)
	slot0.awardUIList.align(slot1, #slot0.awardList)
end

slot0.initTaskWindow = function (slot0)
	slot0.finishItemList = {}
	slot0.finishTaskVOList = {}

	slot0.taskUIList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot9 = slot0.taskProxy:getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy:getFinishTaskById(slot5):getTaskStatus()
			slot11 = slot0.taskProxy.getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5):getConfig("award_display")[1]

			setText(slot0:findTF("description", slot2), slot0.taskProxy.getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5):getConfig("desc"))
			setText(slot0:findTF("progress/progressText", slot2), slot0.taskProxy.getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5):getProgress() .. "/" .. slot0.taskProxy.getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5):getConfig("target_num"))
			setSlider(slot0:findTF("progress", slot2), 0, slot0.taskProxy.getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5).getConfig("target_num"), slot0.taskProxy.getTaskById(slot0.taskList[slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5).getProgress())
			updateDrop(slot0:findTF("award/award", slot2), slot13)
			onButton(slot0, slot0:findTF("award/Image", slot2), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setActive(slot0.findTF(slot14, "go_btn", slot2), slot9 == 0)
			setActive(slot0:findTF("get_btn", slot2), slot9 == 1)
			onButton(slot0, slot14, function ()
				slot0:emit(ActivityMediator.ON_TASK_GO, slot0)
			end, SFX_PANEL)
			onButton(slot0, slot15, function ()
				slot0:emit(ActivityMediator.ON_TASK_SUBMIT, slot0)
			end, SFX_PANEL)
			setActive(slot0.findTF(slot17, "finnal", slot2), slot9 == 2 and not (slot0.curDay < slot3))
			setText(slot0:findTF("lock/tip", slot2), i18n("unlock_tips", slot3))
			setActive(slot0:findTF("lock", slot2), slot0.curDay < slot3)

			if slot9 == 1 and not slot12 then
				table.insert(slot0.finishItemList, slot2)
				table.insert(slot0.finishTaskVOList, slot6)
			end
		end
	end)
	slot0.taskUIList.align(slot1, #slot0.taskList)
end

slot0.closeTask = function (slot0)
	setActive(slot0.taskWindow, false)
end

slot0.openTask = function (slot0)
	setActive(slot0.taskWindow, true)

	if slot0.isFirst == 0 then
		PlayerPrefs.SetInt("jiujiuyoyo_first_" .. getProxy(PlayerProxy):getData().id, 1)
		setActive(slot0.taskRedDot, false)
	end

	slot0.hasClickTask = true

	eachChild(slot0.taskContainter, function (slot0)
		if isActive(slot0:findTF("finnal", slot0)) then
			slot0:SetAsLastSibling()
		end
	end)

	if #slot0.finishItemList > 0 then
		slot0.autoFinishTask(slot0)
	end
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

slot0.CheckFinalAward = function (slot0)
	if slot0 and slot0.activity.data2 == 0 and slot0.remainTotalNum == 0 then
		slot0:emit(ActivityMediator.EVENT_OPERATION, {
			cmd = 2,
			activity_id = slot0.activity.id
		})
	end
end

slot0.displayResult = function (slot0, slot1, slot2, slot3)
	slot0:setForbidMaskStatus(true)
	setActive(slot0.rollingAni, true)

	slot0.aniCallback = function ()
		slot0()
	end

	slot0.rollingSpine.SetActionCallBack(slot4, function (slot0)
		if slot0 == "finish" then
			setActive(slot0.rollingAni, false)
			setActive()

			slot0.aniCallback = nil

			slot0:setForbidMaskStatus(false)
		end
	end)
	slot0.rollingSpine.SetAction(slot4, tostring(slot2), 0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/zhuanzhu")
	slot0:managedTween(LeanTween.delayedCall, function ()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/zhengque")
	end, 4, nil)
end

slot0.setForbidMaskStatus = function (slot0, slot1)
	if slot1 then
		setActive(slot0.forbidMask, true)
		pg.UIMgr.GetInstance():OverlayPanel(slot0.forbidMask)
	else
		setActive(slot0.forbidMask, false)
		pg.UIMgr.GetInstance():UnOverlayPanel(slot0.forbidMask, slot0.bg)
	end
end

slot0.canFinishTask = function (slot0)
	slot5 = pg.TimeMgr.GetInstance():DiffDay(slot4, pg.TimeMgr.GetInstance():GetServerTime()) + 1
	slot6 = false
	slot7 = getProxy(TaskProxy)

	for slot11, slot12 in pairs(slot3) do
		slot13 = slot5 < slot11

		if slot7:getTaskById(slot12) or slot7:getFinishTaskById(slot12):getTaskStatus() == 1 and not slot13 then
			slot6 = true

			break
		end
	end

	return slot6
end

slot0.IsShowRed = function (slot0)
	return getProxy(ActivityProxy):getActivityById(ActivityConst.JIUJIU_YOYO_ID).data1 > 0 or slot0:canFinishTask()
end

return slot0

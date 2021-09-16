slot0 = class("TrainingCampScene", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "TrainingCampUI"
end

slot0.init = function (slot0)
	slot0:findUI()
	slot0:initData()
	slot0:addListener()

	if slot0.isNormalActOn() then
		slot0:initNormalPanel()
	end

	if slot0.isTecActOn() then
		slot0:initTecPanel()
	end

	slot0:closeMsgBox()
end

slot0.findUI = function (slot0)
	slot0.adaptPanel = slot0:findTF("blur_panel/adapt")
	slot0.panelContainer = slot0:findTF("PanelContainer")
	slot0.normalPanel = slot0:findTF("NormalPanel", slot0.panelContainer)
	slot0.tecPanel = slot0:findTF("TecPanel", slot0.panelContainer)
	slot0.switchToNormalBtn = slot0:findTF("SwitchToNormal")
	slot0.switchToTecBtn = slot0:findTF("SwitchToTec")
	slot0.switchToNormalLight = GetOrAddComponent(slot0:findTF("Light", slot0.switchToNormalBtn), "Animator")
	slot0.switchToTecLight = GetOrAddComponent(slot0:findTF("Light", slot0.switchToTecBtn), "Animator")
	slot0.awardMsg = slot0:findTF("ChooseAwardPanel")
	slot0.helpBtn = slot0:findTF("HelpBtn")
end

slot0.initData = function (slot0)
	slot0.taskProxy = getProxy(TaskProxy)
	slot0.activityProxy = getProxy(ActivityProxy)
	slot0.normalTaskactivity = slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS)
	slot0.tecTaskActivity = slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP)
	slot0.phaseId = nil
	slot0.cachePageID = nil
	slot0.activity = nil
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0:findTF("top/back_button", slot0.adaptPanel), function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_PANEL)
	onButton(slot0, slot0.switchToNormalBtn, function ()
		if not slot0.isOnSwitchAni and slot1.isNormalActOn() then
			slot0:switchPanel(slot0.normalTaskactivity, true)
			setActive(slot0.switchToNormalBtn, false)
			setActive(slot0.switchToTecBtn, true)
			slot0:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.switchToTecBtn, function ()
		if not slot0.isOnSwitchAni and slot1.isTecActOn() then
			slot0:switchPanel(slot0.tecTaskActivity, true)
			setActive(slot0.switchToNormalBtn, true)
			setActive(slot0.switchToTecBtn, false)
			slot0:resetSwitchBtnsLight()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("newplayer_help_tip")
		})
	end, SFX_PANEL)
end

slot0.didEnter = function (slot0)
	slot0:updateSwitchBtns()
	slot0:updateSwitchBtnsTag()
	slot0:autoSelectPanel()
end

slot0.willExit = function (slot0)
	LeanTween.cancel(go(slot0.normalPanel))
	LeanTween.cancel(go(slot0.tecPanel))
end

slot0.updateSwitchBtns = function (slot0)
	slot1, slot2 = TrainingCampScene.isNormalActOn()
	slot3, slot4 = TrainingCampScene.isTecActOn()

	if not slot1 or not slot3 then
		setActive(slot0.switchToNormalBtn, false)
		setActive(slot0.switchToTecBtn, false)
	elseif slot1 and slot3 then
		setActive(slot0.switchToNormalBtn, true)
		setActive(slot0.switchToTecBtn, true)
	end

	setActive(slot5, slot2)
	setActive(slot0:findTF("Tag", slot0.switchToTecBtn), slot4)
end

slot0.updateSwitchBtnsTag = function (slot0)
	slot1, slot9 = TrainingCampScene.isNormalActOn()
	slot3, slot9 = TrainingCampScene.isTecActOn()

	setActive(slot5, slot2)
	setActive(slot6, slot4)

	slot0.switchToNormalLight.enabled = PlayerPrefs.GetInt("TrainCamp_Tec_Catchup_First_Tag", 0) == 0
	slot0.switchToTecLight.enabled = slot7 == 0

	if slot7 == 0 then
		PlayerPrefs.SetInt("TrainCamp_Tec_Catchup_First_Tag", 1)
	end
end

slot0.resetSwitchBtnsLight = function (slot0)
	slot0.switchToNormalLight.enabled = false
	slot0.switchToTecLight.enabled = false
end

slot0.autoSelectPanel = function (slot0)
	slot1, slot2 = TrainingCampScene.isNormalActOn()
	slot3, slot4 = TrainingCampScene.isTecActOn()

	if slot1 and slot3 then
		slot0:switchPanel(slot0.normalTaskactivity)
		setActive(slot0.switchToNormalBtn, false)
		setActive(slot0.switchToTecBtn, true)
	elseif slot1 then
		slot0:switchPanel(slot0.normalTaskactivity)
	elseif slot3 then
		slot0:switchPanel(slot0.tecTaskActivity)
	end
end

slot0.initNormalPanel = function (slot0)
	slot1 = slot0:findTF("ToggleList", slot0.normalPanel)
	slot0.normalToggles = {
		slot0:findTF("Phase1", slot1),
		slot0:findTF("Phase2", slot1),
		slot0:findTF("Phase3", slot1)
	}
	slot0.normalTaskUIItemList = UIItemList.New(slot0:findTF("ScrollRect/Content", slot0.normalPanel), slot0:findTF("ScrollRect/TaskTpl", slot0.normalPanel))
	slot0.normalProgressPanel = slot0:findTF("ProgressPanel", slot0.normalPanel)

	for slot5, slot6 in pairs(slot0.normalToggles) do
		onToggle(slot0, slot6, function (slot0)
			if slot0 then
				if slot0.phaseId <  then
					pg.TipsMgr.GetInstance():ShowTips(i18n("newplayer_notice_7"))
					triggerToggle(slot0.normalToggles[slot0.cachePageID], true)
				else
					slot0:updateNormalPanel(slot0.updateNormalPanel)
				end
			end
		end, SFX_PANEL)
	end
end

slot0.updateNormalPanel = function (slot0, slot1)
	slot0.cachePageID = slot1

	slot0:sortTaskIDList(slot4)
	slot0:updateTaskUIItemList(slot0.normalTaskUIItemList, slot4, slot1)
	slot0:updateNormalProgressPanel(slot1, slot0.normalTaskactivity.getConfig(slot2, "config_data")[3][slot1][2], slot0.normalTaskactivity.getConfig(slot2, "config_data")[3][slot1][1])
end

slot0.updateNormalProgressPanel = function (slot0, slot1, slot2, slot3)
	slot4 = slot0:getTask(slot1, slot2)

	if slot1 == slot0.phaseId and slot0:isMissTask(slot3) then
		slot0:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 1,
			activity_id = slot0.activity.id
		})
	end

	if slot4 and slot4:isClientTrigger() and not slot4:isFinish() then
		slot0:emit(TrainingCampMediator.ON_UPDATE, slot4)
	end

	setActive(slot0.normalProgressPanel:Find("Get"), slot4 and slot4:isFinish() and not slot4:isReceive())
	setActive(slot0.normalProgressPanel:Find("Lock"), not slot4)
	setActive(slot0.normalProgressPanel:Find("Go"), slot4 and not slot4:isFinish())
	setActive(slot0.normalProgressPanel:Find("Pass"), slot4 and slot4:isReceive())

	slot9 = slot0.normalProgressPanel:Find("Slider/LabelText")
	slot10 = slot0.normalProgressPanel:Find("Slider/ProgressText")

	if not slot4 then
		slot4 = Task.New({
			id = slot2
		})

		if slot0:isFinishedAll(slot3) then
			slot0:emit(TrainingCampMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = slot0.activity.id
			})
		end

		setText(slot9, i18n("newplayer_notice_" .. slot1))
		_.each(slot3, function (slot0)
			if slot0.taskProxy:getFinishTaskById(slot0) ~= nil then
				slot1 = slot1 + 1
			end
		end)
		setText(slot10, slot11 .. "/" .. #slot3)
	else
		setText(slot9, slot4:getConfig("desc"))
		setText(slot10, math.min(slot4.progress, slot4:getConfig("target_num")) .. "/" .. slot4:getConfig("target_num"))
	end

	slot0.normalProgressPanel:Find("Slider"):GetComponent(typeof(Slider)).value = slot4.progress / slot4:getConfig("target_num")
	slot0.normalProgressPanel:Find("Icon"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/trainingcampui_atlas", "panel_phase_award_" .. slot1)

	setText(slot0.normalProgressPanel:Find("TipText"), i18n("newplayer_notice_" .. 3 + slot1))
	onButton(slot0, slot5, function ()
		if slot0:isSelectable() then
			slot1:openMsgbox(function (slot0)
				slot0:emit(TrainingCampMediator.ON_SELECTABLE_GET, slot0.emit, slot0)
			end)
		else
			slot1.emit(slot0, TrainingCampMediator.ON_GET, slot1.emit)
		end
	end, SFX_PANEL)
	onButton(slot0, slot7, function ()
		slot0:emit(TrainingCampMediator.ON_GO, slot0)
	end, SFX_PANEL)
end

slot0.initTecPanel = function (slot0)
	slot1 = slot0:findTF("ToggleList", slot0.tecPanel)
	slot0.tecToggles = {
		slot0:findTF("Phase1", slot1),
		slot0:findTF("Phase2", slot1),
		slot0:findTF("Phase3", slot1)
	}

	for slot7 = #slot0.tecTaskActivity:getConfig("config_data")[3] + 1, #slot0.tecToggles, 1 do
		setActive(slot0.tecToggles[slot7], false)
	end

	slot0.tecTaskUIItemList = UIItemList.New(slot0:findTF("ScrollRect/Content", slot0.tecPanel), slot0:findTF("ScrollRect/TaskTpl", slot0.tecPanel))
	slot0.tecProgressPanel = slot0:findTF("ProgressPanel", slot0.tecPanel)

	for slot7, slot8 in pairs(slot0.tecToggles) do
		onToggle(slot0, slot8, function (slot0)
			if slot0 then
				if slot0.phaseId <  then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tec_notice_not_open_tip"))
					triggerToggle(slot0.tecToggles[slot0.cachePageID], true)
				else
					slot0:updateTecPanel(slot0.updateTecPanel)
				end
			end
		end, SFX_PANEL)
	end
end

slot0.updateTecPanel = function (slot0, slot1)
	slot0.cachePageID = slot1

	slot0:sortTaskIDList(slot4)
	slot0:updateTaskUIItemList(slot0.tecTaskUIItemList, slot4, slot1)
	slot0:updateTecProgressPanel(slot1, slot0.tecTaskActivity.getConfig(slot2, "config_data")[3][slot1][2], slot0.tecTaskActivity.getConfig(slot2, "config_data")[3][slot1][1])
end

slot0.updateTecProgressPanel = function (slot0, slot1, slot2, slot3)
	slot5 = nil

	if not slot0:isFinishedAll(slot3) then
		slot5 = true
	end

	slot6 = slot0:getTask(slot1, slot2, slot5)

	if slot1 == slot0.phaseId and slot0:isMissTask(slot3) then
		slot0:emit(TrainingCampMediator.ON_TRIGGER, {
			cmd = 1,
			activity_id = slot0.activity.id
		})
	end

	if slot6 and slot6:isClientTrigger() and not slot6:isFinish() then
		slot0:emit(TrainingCampMediator.ON_UPDATE, slot6)
	end

	setActive(slot0.tecProgressPanel:Find("Get"), slot6 and slot6:isFinish() and not slot6:isReceive())
	setActive(slot0.tecProgressPanel:Find("Lock"), not slot6)
	setActive(slot0.tecProgressPanel:Find("Go"), slot6 and not slot6:isFinish())
	setActive(slot0.tecProgressPanel:Find("Pass"), slot6 and slot6:isReceive())

	slot11 = slot0.tecProgressPanel:Find("Slider/LabelText")
	slot12 = slot0.tecProgressPanel:Find("Slider/ProgressText")

	if not slot6 then
		slot6 = Task.New({
			id = slot2
		})

		if slot0:isFinishedAll(slot3) then
			slot0:emit(TrainingCampMediator.ON_TRIGGER, {
				cmd = 2,
				activity_id = slot0.activity.id
			})
		end

		setText(slot11, i18n("tec_notice_" .. slot1))
		_.each(slot3, function (slot0)
			if slot0.taskProxy:getTaskVO(slot0) and slot1:isReceive() then
				slot1 = slot1 + 1
			end
		end)
		setText(slot12, slot13 .. "/" .. #slot3)
	else
		setText(slot11, slot6:getConfig("desc"))
		setText(slot12, math.min(slot6.progress, slot6:getConfig("target_num")) .. "/" .. slot6:getConfig("target_num"))
	end

	slot0.tecProgressPanel:Find("Slider"):GetComponent(typeof(Slider)).value = slot6.progress / slot6:getConfig("target_num")

	updateDrop(slot13, slot15)
	onButton(slot0, slot13, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	setActive(slot0.tecProgressPanel.Find(slot17, "TipText"), false)
	onButton(slot0, slot7, function ()
		if slot0:isSelectable() then
			slot1:openMsgbox(function (slot0)
				slot0:emit(TrainingCampMediator.ON_SELECTABLE_GET, slot0.emit, slot0)
			end)
		else
			slot1.emit(slot0, TrainingCampMediator.ON_GET, slot1.emit)

			if slot1.phaseId == 1 then
				slot1.isSubmitTecFirstTaskTag = true

				true:emit(TrainingCampMediator.ON_TRIGGER, {
					cmd = 1,
					activity_id = slot1.activity.id
				})
			end
		end
	end, SFX_PANEL)
	onButton(slot0, slot9, function ()
		slot0:emit(TrainingCampMediator.ON_GO, slot0)
	end, SFX_PANEL)
end

slot0.updateToggleDisable = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		setActive(slot6:Find("Disable"), slot0.phaseId < slot5)
	end
end

slot0.updateTaskUIItemList = function (slot0, slot1, slot2, slot3)
	slot1:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:updateTask(slot1[slot1 + 1], slot2, slot2)
		end
	end)
	slot1.align(slot1, #slot2)
end

slot0.updateTask = function (slot0, slot1, slot2, slot3)
	setActive(slot2:Find("Get"), slot0:getTask(slot3, slot1) and slot7:isFinish() and not slot7:isReceive())
	setActive(slot2:Find("Got"), slot7 and slot7:isReceive())
	setActive(slot2:Find("Go"), not slot7 or (slot7 and not slot7:isFinish()))

	if slot7 and slot7:isClientTrigger() and not slot7:isFinish() then
		slot0:emit(TrainingCampMediator.ON_UPDATE, slot7)
	end

	setText(slot2:Find("TitleText"), slot7 or Task.New({
		id = slot1
	}):getConfig("desc"))
	updateDrop(slot9, slot10)
	onButton(slot0, slot9, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	setText(slot2.Find(slot2, "ProgressText"), math.min(slot7 or Task.New().progress, slot7 or Task.New():getConfig("target_num")) .. "/" .. slot7 or Task.New():getConfig("target_num"))
	onButton(slot0, slot4, function ()
		slot0:emit(TrainingCampMediator.ON_GET, slot0)
	end, SFX_PANEL)
	onButton(slot0, slot6, function ()
		slot0:emit(TrainingCampMediator.ON_GO, slot0)
	end, SFX_PANEL)
end

slot0.getTask = function (slot0, slot1, slot2, slot3)
	slot4 = nil

	if slot0.phaseId <= slot1 then
		if slot3 == true then
			return nil
		end

		slot4 = slot0.taskProxy:getTaskById(slot2) or slot0.taskProxy:getFinishTaskById(slot2)
	else
		Task.New({
			id = slot2
		}).progress = Task.New():getConfig("target_num")
		Task.New().submitTime = 1
	end

	return slot4
end

slot0.getTaskState = function (slot0, slot1)
	if slot1:isReceive() then
		return 0
	elseif slot1:isFinish() then
		return 2
	elseif not slot1:isFinish() then
		return 1
	end

	return -1
end

slot0.sortTaskIDList = function (slot0, slot1)
	table.sort(slot1, function (slot0, slot1)
		if slot0:getTaskState(slot0.taskProxy:getTaskVO(slot0) or Task.New({
			id = slot0
		})) == slot0:getTaskState(slot0.taskProxy:getTaskVO(slot1) or Task.New({
			id = slot1
		})) then
			return slot2.id < slot3.id
		else
			return slot5 < slot4
		end
	end)

	return slot1
end

slot0.isFinishedAll = function (slot0, slot1)
	return _.all(slot1, function (slot0)
		return (slot0.taskProxy:getTaskVO(slot0) and slot1:isReceive()) or false
	end)
end

slot0.isMissTask = function (slot0, slot1)
	return _.any(slot1, function (slot0)
		return slot0.taskProxy:getTaskVO(slot0) == nil
	end)
end

slot0.setPhrase = function (slot0)
	if slot0.lockFirst == true then
		slot0.phaseId = 1

		return
	end

	slot1 = 1
	slot3 = #slot0.activity:getConfig("config_data")[3]

	function slot4(slot0)
		if slot0 > 1 then
			return slot1.taskProxy:getFinishTaskById(slot0[slot0 - 1][2]) ~= nil
		end
	end

	for slot8 = slot3, 1, -1 do
		if _.all(slot2[slot8][1], function (slot0)
			return slot0.taskProxy:getTaskVO(slot0) ~= nil
		end) or slot4(slot8) then
			slot1 = slot8

			break
		end
	end

	slot0.phaseId = slot1
end

slot0.isNormalActOn = function ()
	slot2 = false
	slot3 = false

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS) and not slot0:isEnd() then
		slot2 = getProxy(ChapterProxy):getChapterById(slot0:getConfig("config_data")[1]) and slot5:isClear()
		slot7 = getProxy(TaskProxy)
		slot8 = _.any(_.flatten(slot0:getConfig("config_data")[3]), function (slot0)
			return slot0:getTaskById(slot0) and slot1:isFinish() and not slot1:isReceive()
		end)
		slot3 = slot8
	end

	return slot1 and slot2, slot3
end

slot0.isTecActOn = function ()
	slot4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy).getData(slot2).level, "ShipBluePrintMediator")
	slot5 = false

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP) and not slot0:isEnd() then
		slot7 = getProxy(TaskProxy)
		slot8 = _.any(_.flatten(slot0:getConfig("config_data")[3]), function (slot0)
			return slot0:getTaskById(slot0) and slot1:isFinish() and not slot1:isReceive()
		end)
		slot5 = slot8
	end

	return slot1 and slot4, slot5
end

slot0.switchPanel = function (slot0, slot1, slot2)
	slot0.activity = slot1

	if slot1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		if slot2 then
			slot0:aniOnSwitch(slot0.normalPanel, slot0.tecPanel)
		else
			setActive(slot0.normalPanel, true)
			setActive(slot0.tecPanel, false)
		end

		slot0:setPhrase()
		slot0:updateToggleDisable(slot0.normalToggles)
		triggerToggle(slot0.normalToggles[slot0.phaseId], true)
	elseif slot1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		if slot2 then
			slot0:aniOnSwitch(slot0.tecPanel, slot0.normalPanel)
		else
			setActive(slot0.normalPanel, false)
			setActive(slot0.tecPanel, true)
		end

		slot0:setPhrase()
		slot0:updateToggleDisable(slot0.tecToggles)
		triggerToggle(slot0.tecToggles[slot0.phaseId], true)
	end
end

slot0.switchPageByMediator = function (slot0)
	if slot0.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_GUIDE_TASKS then
		slot0:switchPanel(slot0.normalTaskactivity)
	elseif slot0.activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
		slot0:switchPanel(slot0.tecTaskActivity)
	end
end

slot0.aniOnSwitch = function (slot0, slot1, slot2)
	slot0.isOnSwitchAni = true

	slot1:SetAsLastSibling()
	setActive(slot1, true)
	GetOrAddComponent(slot1, "DftAniEvent"):SetEndEvent(function ()
		slot0.isOnSwitchAni = false

		setActive(false, false)
	end)
end

slot0.openMsgbox = function (slot0, slot1)
	setActive(slot0.switchToNormalBtn, false)
	setActive(slot0.switchToTecBtn, false)
	setActive(slot0.awardMsg, true)
	setActive(slot0.normalPanel, false)

	slot2 = nil

	for slot7 = 1, slot0.awardMsg:Find("photos").childCount, 1 do
		onToggle(slot0, slot3:GetChild(slot7 - 1), function (slot0)
			slot0 = slot0 and slot1
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.awardMsg:Find("confirm_btn"), function ()
		if slot0 then
			if slot1 then
				slot1(slot1)
			end

			slot2:closeMsgBox()
		end
	end, SFX_PANEL)
end

slot0.closeMsgBox = function (slot0)
	setActive(slot0.awardMsg, false)
	setActive(slot0.normalPanel, true)
	slot0:updateSwitchBtns()
end

slot0.tryShowTecFixTip = function (slot0)
	if slot0.isSubmitTecFirstTaskTag == true then
		slot0.isSubmitTecFirstTaskTag = false

		if _.all(slot0.tecTaskActivity:getConfig("config_data")[3][1][1], function (slot0)
			return slot0.taskProxy:getTaskById(slot0) ~= nil
		end) then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
				modal = true,
				hideNo = true,
				hideClose = true,
				content = i18n("tec_catchup_errorfix"),
				weight = LayerWeightConst.TOP_LAYER,
				onClose = function ()
					slot0.lockFirst = true

					slot0:switchPanel(slot0.tecTaskActivity)
				end,
				onYes = function ()
					slot0.lockFirst = true

					slot0:switchPanel(slot0.tecTaskActivity)
				end
			})
		end
	end
end

return slot0

slot0 = class("TaskScene", import("..base.BaseUI"))
slot0.PAGE_TYPE_SCENARIO = "scenario"
slot0.PAGE_TYPE_BRANCH = "branch"
slot0.PAGE_TYPE_ROUTINE = "routine"
slot0.PAGE_TYPE_WEEKLY = "weekly"
slot0.PAGE_TYPE_ALL = "all"
slot0.PAGE_TYPE_ACT = "activity"
slot1 = {
	[slot0.PAGE_TYPE_SCENARIO] = {
		[1.0] = true
	},
	[slot0.PAGE_TYPE_BRANCH] = {
		nil,
		true,
		nil,
		nil,
		true,
		true
	},
	[slot0.PAGE_TYPE_ROUTINE] = {
		[3.0] = true,
		[36.0] = true
	},
	[slot0.PAGE_TYPE_WEEKLY] = {
		[4.0] = true,
		[13.0] = true
	},
	[slot0.PAGE_TYPE_ALL] = {
		true,
		true,
		true,
		true,
		true,
		true,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		true,
		[36.0] = true,
		[26.0] = true
	},
	[slot0.PAGE_TYPE_ACT] = {
		[36.0] = true,
		[6.0] = true,
		[26.0] = true
	}
}

slot0.getUIName = function (slot0)
	return "TaskScene"
end

slot0.preload = function (slot0, slot1)
	PoolMgr.GetInstance():PreloadUI("TaskListPage", slot1)
end

slot0.setTaskVOs = function (slot0, slot1)
	slot0.contextData.taskVOsById = slot1
end

slot0.SetWeekTaskProgressInfo = function (slot0, slot1)
	slot0.contextData.weekTaskProgressInfo = slot1
end

slot0.init = function (slot0)
	slot0._topPanel = slot0:findTF("blur_panel/adapt/top")
	slot0._backBtn = slot0._topPanel:Find("back_btn")
	slot0._leftLength = slot0:findTF("blur_panel/adapt/left_length")
	slot0._tagRoot = slot0:findTF("blur_panel/adapt/left_length/frame/tagRoot")
	slot0.taskIconTpl = slot0:findTF("taskTagOb/task_icon_default")
	slot0.weekTip = slot0:findTF("weekly/tip", slot0._tagRoot)
	slot0.oneStepBtn = slot0:findTF("blur_panel/adapt/top/GetAllButton")
	slot0.listEmptyTF = slot0:findTF("empty")

	setActive(slot0.listEmptyTF, false)

	slot0.listEmptyTxt = slot0:findTF("Text", slot0.listEmptyTF)

	setText(slot0.listEmptyTxt, i18n("list_empty_tip_taskscene"))

	slot0.contextData.viewComponent = slot0
	slot0.pageTF = slot0:findTF("pages")
end

slot0.IsNewStyleTime = function ()
	return pg.TimeMgr.GetInstance():parseTimeFromConfig({
		{
			2021,
			6,
			14
		},
		{
			0,
			0,
			0
		}
	}) <= pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.IsPassScenario = function ()
	slot0 = pg.gameset.task_first_daily_pre_id.key_value

	if #_.select(_.values(slot1), function (slot0)
		return slot0:getConfig("type") == 1
	end) > 0 then
		table.sort(slot2, function (slot0, slot1)
			return slot0.id < slot1.id
		end)

		return slot0 < slot2[1].id
	else
		return true
	end
end

slot0.didEnter = function (slot0)
	slot1 = TaskCommonPage.New(slot0.pageTF, slot0.event, slot0.contextData)
	slot0.pages = {
		[slot0.PAGE_TYPE_SCENARIO] = slot1,
		[slot0.PAGE_TYPE_BRANCH] = slot1,
		[slot0.PAGE_TYPE_ROUTINE] = slot1,
		[slot0.PAGE_TYPE_WEEKLY] = (slot0.IsNewStyleTime() and not slot0.contextData.weekTaskProgressInfo:IsMaximum() and TaskWeekPage.New(slot0.pageTF, slot0.event, slot0.contextData)) or slot1,
		[slot0.PAGE_TYPE_ALL] = slot1,
		[slot0.PAGE_TYPE_ACT] = slot1
	}
	slot0.contextData.ptAwardWindow = TaskPtAwardPage.New(slot0._tf, slot0.event, slot0.contextData)

	onButton(slot0, slot0._backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_CANCEL)
	setActive(slot0.findTF(slot0, "stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(slot0:findTF("stamp"), false)
	end

	onButton(slot0, slot0:findTF("stamp"), function ()
		getProxy(TaskProxy):dealMingshiTouchFlag(5)
	end, SFX_CONFIRM)

	slot0.toggles = {}

	for slot6, slot7 in pairs(slot1) do
		onToggle(slot0, slot0.findTF(slot0, slot6, slot0._tagRoot), function (slot0)
			if slot0 then
				slot0:UpdatePage(slot0.UpdatePage)
			end
		end, SFX_PANEL)

		slot0.toggles[slot6] = slot0.findTF(slot0, slot6, slot0._tagRoot)
	end

	slot3 = slot0.toggles[slot0.contextData.page or slot0.PAGE_TYPE_ALL]

	if slot0.toggles and slot3 then
		triggerToggle(slot3, true)
	end

	slot0:UpdateWeekTip()
end

slot0.UpdatePage = function (slot0, slot1)
	slot2 = slot0[slot1]

	function slot3(slot0, slot1)
		setActive(slot0.listEmptyTF, #slot1 <= 0)
		slot0:updateOneStepBtn(slot0)
	end

	if slot0._currentToggleType and slot0._currentToggleType ~= slot1 then
		slot0.pages[slot0._currentToggleType].ExecuteAction(slot4, "Hide")
	end

	slot0.pages[slot1]:ExecuteAction("Update", slot1, slot2, function (slot0)
		slot0(slot0, slot0)
	end)

	slot0._currentToggleType = slot1
	slot0.contextData.page = slot1
end

slot0.addTask = function (slot0, slot1)
	print("add task " .. slot1.id)

	slot0.contextData.taskVOsById[slot1.id] = slot1

	slot0:UpdatePage(slot0._currentToggleType)
end

slot0.removeTask = function (slot0, slot1)
	print("revemo task " .. slot1.id)

	slot0.contextData.taskVOsById[slot1.id] = nil

	slot0:UpdatePage(slot0._currentToggleType)
end

slot0.updateTask = function (slot0, slot1)
	slot0:addTask(slot1)
end

slot0.ResetWeekTaskPage = function (slot0)
	slot1 = slot0.pages[slot0.PAGE_TYPE_WEEKLY]

	if slot0.IsNewStyleTime() and isa(slot1, TaskCommonPage) then
		if slot1:GetLoaded() and slot1:isShowing() then
			slot1:Hide()
		end

		slot0.pages[slot0.PAGE_TYPE_WEEKLY] = TaskWeekPage.New(slot0.pageTF, slot0.event, slot0.contextData)
	end

	slot0:RefreshWeekTaskPage()

	if slot0._currentToggleType ~= slot0.PAGE_TYPE_WEEKLY then
		slot0:UpdatePage(slot0._currentToggleType)
	end
end

slot0.RefreshWeekTaskPage = function (slot0)
	if slot0._currentToggleType == slot0.PAGE_TYPE_WEEKLY then
		slot0:UpdatePage(slot0._currentToggleType)
		slot0:UpdateWeekTip()
	end
end

slot0.RefreshWeekTaskPageBefore = function (slot0, slot1)
	if slot0._currentToggleType == slot0.PAGE_TYPE_WEEKLY then
		slot0.pages[slot0._currentToggleType]:RefreshWeekTaskPageBefore(slot1)
	end
end

slot0.RefreshWeekTaskProgress = function (slot0)
	if isa(slot0.pages[slot0._currentToggleType], TaskWeekPage) and slot0.contextData.weekTaskProgressInfo:IsMaximum() then
		slot1:Destroy()

		slot0.pages[slot0.PAGE_TYPE_WEEKLY] = slot0.pages[slot0.PAGE_TYPE_SCENARIO]

		slot0:UpdatePage(slot0.PAGE_TYPE_WEEKLY)
	elseif slot0._currentToggleType == slot0.PAGE_TYPE_WEEKLY and isa(slot1, TaskWeekPage) then
		slot1:ExecuteAction("RefreshWeekProgress")
		slot0:UpdateWeekTip()
	end
end

slot0.UpdateWeekTip = function (slot0)
	slot1 = false

	if slot0.IsPassScenario() and slot0.IsNewStyleTime() then
		for slot5, slot6 in pairs(slot0.contextData.taskVOsById) do
			if (slot6:getConfig("type") == 4 or slot6:getConfig("type") == 13) and slot6:isFinish() and not slot6:isReceive() and slot6:getConfig("visibility") == 1 then
				slot1 = true

				break
			end
		end

		if not slot1 and (slot0.contextData.weekTaskProgressInfo:CanUpgrade() or slot2:AnySubTaskCanSubmit()) then
			slot1 = true
		end
	end

	setActive(slot0.weekTip, slot1)
end

slot0.GoToFilter = function (slot0, slot1)
	triggerToggle(slot0:findTF(slot1, slot0._tagRoot), true)
end

slot0.onSubmit = function (slot0, slot1)
	if slot0.onShowAwards then
		return
	end

	slot0:emit(TaskMediator.ON_TASK_SUBMIT, slot1)
end

slot0.onSubmitForWeek = function (slot0, slot1)
	if slot0.onShowAwards then
		return
	end

	slot0:emit(TaskMediator.ON_SUBMIT_WEEK_TASK, slot1)
end

slot0.onGo = function (slot0, slot1)
	if slot0.onShowAwards then
		return
	end

	slot0:emit(TaskMediator.ON_TASK_GO, slot1)
end

slot0.willExit = function (slot0)
	for slot4, slot5 in pairs(slot0.pages) do
		slot5:Destroy()
	end

	slot0.pages = nil

	slot0.contextData.ptAwardWindow:Destroy()

	slot0.contextData.ptAwardWindow = nil
	slot0.contextData.taskVOsById = nil
	slot0.contextData.weekTaskProgressInfo = nil
	slot0.contextData.viewComponent = nil
end

slot0.updateOneStepBtn = function (slot0, slot1)
	if #slot1 or slot0.pages[slot0._currentToggleType]:GetWaitToCheckList() >= 2 then
		onButton(slot0, slot0.oneStepBtn, function ()
			slot0:ExecuteOneStepSubmit()
		end, SFX_PANEL)
	else
		removeOnButton(slot0.oneStepBtn)
	end

	setActive(slot0.oneStepBtn, slot3)
end

return slot0

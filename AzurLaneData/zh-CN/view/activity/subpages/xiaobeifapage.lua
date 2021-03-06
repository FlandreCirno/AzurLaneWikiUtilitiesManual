slot0 = class("XiaobeiFaPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.layer = slot0:findTF("layer")
	slot0.btn = slot0:findTF("btn", slot0.layer)
	slot0.bonusList = slot0:findTF("bonus_list", slot0.layer)
	slot0.progress = slot0:findTF("progress", slot0.layer)
	slot0.progressTxt = slot0:findTF("progressText", slot0.layer)
	slot0.phaseTxt = slot0:findTF("phase/Text", slot0.layer)
	slot0.award = slot0:findTF("award", slot0.layer)
end

slot0.OnFirstFlush = function (slot0)
	slot1 = slot0.activity

	onButton(slot0, slot0.bonusList, function ()
		slot0 = slot0:getConfig("config_data")

		print(slot0)
		slot1:emit(ActivityMediator.SHOW_AWARD_WINDOW, TaskAwardWindow, {
			tasklist = slot0,
			ptId = slot0:getConfig("config_client").pt_id,
			totalPt = getProxy(ActivityProxy):getActivityById(slot0:getConfig("config_client").rank_act_id).data1
		})
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0:flush_task_list_pt_xiaobeifa()
end

slot0.flush_task_list_pt_xiaobeifa = function (slot0)
	slot0:flush_task_list_pt()

	slot2, slot3, slot4 = slot0:getDoingTask(slot1)

	if slot0.activity:getConfig("config_client").main_task then
		slot0:setImportantProgress(slot1, slot0:findTF("progress_important"), (slot4 and slot2) or slot2 - 1, slot1:getConfig("config_client").main_task, slot1:getConfig("config_data"))
	end
end

slot0.getDoingTask = function (slot0, slot1, slot2)
	slot3 = getProxy(TaskProxy)
	slot4 = _.flatten(slot1:getConfig("config_data"))
	slot5, slot6 = nil

	if slot1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASKS then
		for slot10 = #slot4, 1, -1 do
			if slot3:getFinishTaskById(slot4[slot10]) then
				if not slot6 then
					slot5 = slot4[slot10]
					slot6 = slot11
				end

				break
			end

			slot5 = slot4[slot10]
			slot6 = slot3:getTaskById(slot4[slot10])
		end
	else
		slot5, slot6 = getActivityTask(slot1)
	end

	if not slot2 then
		assert(slot6, "without taskVO " .. slot5 .. " from server")
	end

	return table.indexof(slot4, slot5), slot5, slot6
end

slot0.flush_task_list_pt = function (slot0)
	slot10, slot4, slot5 = slot0:getDoingTask(slot1)
	slot7 = getProxy(ActivityProxy):getActivityById(slot0.activity.getConfig(slot1, "config_client").rank_act_id).data1

	setText(slot0.phaseTxt, slot3 .. "/" .. #_.flatten(slot0.activity.getConfig(slot1, "config_data")))

	if slot5 then
		slot10 = math.min(slot7, slot5:getConfig("target_num"))

		setText(slot0.progressTxt, setColorStr)
		setSlider(slot0.progress, 0, slot8, math.min(slot7, slot8))
		updateDrop(slot0.award, (slot7 < slot5.getConfig("target_num") and COLOR_RED) or COLOR_GREEN)
		onButton(slot0, slot0.award, function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)

		slot0.btn.GetComponent(slot12, typeof(Image)).enabled = not slot5:isFinish()

		setActive(slot0.btn:Find("get"), slot5:isFinish() and not slot5:isReceive())
		setActive(slot0.btn:Find("achieved"), slot5:isReceive())
		onButton(slot0, slot0.btn, function ()
			if not slot0:isFinish() then
				slot1:emit(ActivityMediator.ON_TASK_GO, slot1.emit)
			else
				if not slot1:TaskSubmitCheck(slot1.TaskSubmitCheck) then
					return
				end

				slot1:emit(ActivityMediator.ON_TASK_SUBMIT, slot1.emit)
			end
		end, SFX_PANEL)
		setButtonEnabled(slot0.btn, not slot5.isReceive(slot5))
	end
end

slot0.TaskSubmitCheck = function (slot0, slot1)
	if slot0.checkList[slot1.id] then
		for slot6, slot7 in ipairs(slot2) do
			if slot7:getGroupId() == slot0.checkList[slot1.id] and slot7:isActivityNpc() then
				return true
			end
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_client"))

		return false
	end

	return true
end

slot0.setImportantProgress = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = slot2:Find("award_display")
	slot8 = getProxy(TaskProxy)

	setSlider(slot2, 0, slot9, slot11)

	slot12 = nil
	slot13 = slot6:GetComponent(typeof(RectTransform)).rect.width
	slot14 = nil

	removeAllChildren(slot6)
	setActive(slot7, false)

	for slot18, slot19 in ipairs(slot4) do
		for slot23, slot24 in ipairs(slot5) do
			if slot19 == slot24 then
				SetParent(slot14, slot6)
				setActive(slot14, true)
				setAnchoredPosition(slot14, {
					x = pg.task_data_template[slot5[slot23]].target_num / slot9 * slot13
				})

				slot27 = slot0:findTF("award", slot14)

				updateDrop(slot27, slot28)
				onButton(slot0, slot27, function ()
					slot0:emit(BaseUI.ON_DROP, slot0)
				end, SFX_PANEL)
				setText(slot0.findTF(slot0, "Text", Instantiate(slot7)), pg.task_data_template[slot19].target_num)
				setActive(slot0:findTF("mask", slot27), slot23 <= slot3)

				break
			end
		end
	end
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

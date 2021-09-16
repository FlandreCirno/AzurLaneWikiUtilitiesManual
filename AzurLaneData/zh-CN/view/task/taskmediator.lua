slot0 = class("TaskMediator", import("..base.ContextMediator"))
slot0.ON_TASK_SUBMIT = "TaskMediator:ON_TASK_SUBMIT"
slot0.ON_TASK_GO = "TaskMediator:ON_TASK_GO"
slot0.TASK_FILTER = "TaskMediator:TASK_FILTER"
slot0.ON_SUBMIT_WEEK_PROGREE = "TaskMediator:ON_SUBMIT_WEEK_PROGREE"
slot0.ON_BATCH_SUBMIT_WEEK_TASK = "TaskMediator:ON_BATCH_SUBMIT_WEEK_TASK"
slot0.ON_SUBMIT_WEEK_TASK = "TaskMediator:ON_SUBMIT_WEEK_TASK"
slot0.CLICK_GET_ALL = "TaskMediator:CLICK_GET_ALL"
slot0.ON_DROP = "TaskMediator:ON_DROP"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_SUBMIT_WEEK_TASK, function (slot0, slot1)
		slot0:sendNotification(GAME.SUBMIT_WEEK_TASK, {
			id = slot1.id
		})
	end)
	slot0.bind(slot0, slot0.ON_SUBMIT_WEEK_PROGREE, function (slot0)
		slot0:sendNotification(GAME.SUBMIT_WEEK_TASK_PROGRESS)
	end)
	slot0.bind(slot0, slot0.ON_BATCH_SUBMIT_WEEK_TASK, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK, {
			ids = slot1,
			callback = slot2
		})
	end)
	slot0.bind(slot0, slot0.ON_DROP, function (slot0, slot1, slot2)
		if slot1.type == DROP_TYPE_EQUIP then
			slot0:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = {
					equipmentId = slot1.cfg.id,
					type = EquipmentInfoMediator.TYPE_DISPLAY,
					onRemoved = slot2,
					LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
				}
			}))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = slot1,
				onNo = slot2,
				onYes = slot2,
				weight = LayerWeightConst.THIRD_LAYER
			})
		end
	end)
	slot0.bind(slot0, slot0.ON_TASK_SUBMIT, function (slot0, slot1)
		if getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID) and slot1.id == _.flatten(slot4)[#_.flatten(slot4)] then
			pg.NewStoryMgr.GetInstance():Play("YIXIAN8", function ()
				slot0:sendNotification(GAME.SUBMIT_TASK, slot1.id)
			end)

			return
		end

		if slot1.index then
			slot0.sendNotification(slot4, GAME.SUBMIT_TASK, {
				taskId = slot1.id,
				index = slot1.index
			})
		else
			slot0:sendNotification(GAME.SUBMIT_TASK, slot1.id)
		end
	end)
	slot0.bind(slot0, slot0.ON_TASK_GO, function (slot0, slot1)
		slot0:sendNotification(GAME.TASK_GO, {
			taskVO = slot1
		})
	end)
	slot0.SetTaskVOs(slot0)
	slot0.viewComponent:SetWeekTaskProgressInfo(getProxy(TaskProxy):GetWeekTaskProgressInfo())
end

slot0.SetTaskVOs = function (slot0)
	slot3 = getProxy(BagProxy)

	for slot7, slot8 in pairs(slot2) do
		if slot8:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			slot8.progress = slot3:getItemCountById(tonumber(slot8:getConfig("target_id_for_client")))
		elseif slot8:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			slot8.progress = getProxy(ActivityProxy):getVirtualItemNumber(slot8:getConfig("target_id_for_client"))
		end
	end

	slot0.viewComponent:setTaskVOs(slot2)
end

slot0.enterLevel = function (slot0, slot1)
	if getProxy(ChapterProxy):getChapterById(slot1) then
		slot4 = {
			mapIdx = slot3:getConfig("map")
		}

		if slot3.active then
			slot4.chapterId = slot3.id
		else
			slot4.openChapterId = slot1
		end

		slot0:sendNotification(GAME.GO_SCENE, SCENE.LEVEL, slot4)
	end
end

slot0.remove = function (slot0)
	return
end

slot0.listNotificationInterests = function (slot0)
	return {
		TaskProxy.TASK_ADDED,
		TaskProxy.TASK_UPDATED,
		TaskProxy.TASK_REMOVED,
		GAME.SUBMIT_TASK_DONE,
		slot0.TASK_FILTER,
		GAME.BEGIN_STAGE_DONE,
		GAME.CHAPTER_OP_DONE,
		TaskProxy.WEEK_TASK_UPDATED,
		TaskProxy.WEEK_TASKS_ADDED,
		TaskProxy.WEEK_TASKS_DELETED,
		GAME.SUBMIT_WEEK_TASK_DONE,
		GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE,
		TaskProxy.WEEK_TASK_RESET,
		GAME.MERGE_TASK_ONE_STEP_AWARD_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == TaskProxy.TASK_ADDED then
		if slot3:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			slot3.progress = getProxy(BagProxy):getItemCountById(tonumber(slot3:getConfig("target_id_for_client")))
		elseif slot3:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			slot3.progress = getProxy(ActivityProxy):getVirtualItemNumber(slot3:getConfig("target_id_for_client"))
		end

		slot0.viewComponent:addTask(slot3)
	elseif slot2 == GAME.CHAPTER_OP_DONE then
		if slot0.chapterId then
			slot0:enterLevel(slot0.chapterId)

			slot0.chapterId = nil
		end
	elseif slot2 == TaskProxy.TASK_UPDATED then
		if slot3:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
			slot3.progress = getProxy(BagProxy):getItemCountById(tonumber(slot3:getConfig("target_id_for_client")))
		elseif slot3:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
			slot3.progress = getProxy(ActivityProxy):getVirtualItemNumber(slot3:getConfig("target_id_for_client"))
		end

		slot0.viewComponent:updateTask(slot3)
	elseif slot2 == TaskProxy.TASK_REMOVED then
		slot0.viewComponent:removeTask(slot3)
	elseif slot2 == slot0.TASK_FILTER then
		slot0.viewComponent:GoToFilter(slot3)
	else
		if slot2 == GAME.SUBMIT_TASK_DONE then
			slot4 = slot1:getType()
			slot5 = getProxy(TaskProxy)
			slot0.viewComponent.onShowAwards = true

			slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3, function ()
				slot0.viewComponent.onShowAwards = nil

				slot0.viewComponent:accepetActivityTask()
				slot0.viewComponent.accepetActivityTask.viewComponent:updateOneStepBtn()

				slot0 = {}

				for slot4, slot5 in ipairs(ipairs) do
					table.insert(slot0, function (slot0)
						slot0:PlayStoryForTaskAct(slot0.PlayStoryForTaskAct, slot0)
					end)
				end

				if slot0.refreshWeekTaskPageFlag then
					slot0.viewComponent.RefreshWeekTaskPage(slot1)

					slot0.refreshWeekTaskPageFlag = nil
				end

				if #slot0 > 0 then
					seriesAsync(slot0)
				end
			end)

			return
		end

		if slot2 == GAME.BEGIN_STAGE_DONE then
			slot0.sendNotification(slot0, GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
		elseif slot2 == TaskProxy.WEEK_TASKS_ADDED or slot2 == TaskProxy.WEEK_TASKS_DELETED or slot2 == TaskProxy.WEEK_TASK_UPDATED then
			slot0.viewComponent:RefreshWeekTaskPage()
		elseif slot2 == GAME.SUBMIT_WEEK_TASK_DONE then
			slot0.viewComponent:RefreshWeekTaskPageBefore(slot3.id)

			function slot4()
				slot0.viewComponent:RefreshWeekTaskPage()
			end

			if #slot3.awards > 0 then
				slot0.viewComponent.emit(slot5, BaseUI.ON_ACHIEVE, slot3.awards, slot4)
			else
				slot4()
			end
		elseif slot2 == GAME.SUBMIT_WEEK_TASK_PROGRESS_DONE then
			function slot4()
				slot0.viewComponent:RefreshWeekTaskProgress()
			end

			if #slot3.awards > 0 then
				slot0.viewComponent.emit(slot5, BaseUI.ON_ACHIEVE, slot3.awards, slot4)
			else
				slot4()
			end
		elseif slot2 == TaskProxy.WEEK_TASK_RESET then
			slot0:SetTaskVOs()
			slot0.viewComponent:ResetWeekTaskPage()
		elseif slot2 == GAME.MERGE_TASK_ONE_STEP_AWARD_DONE then
			slot0.refreshWeekTaskPageFlag = true

			slot0:sendNotification(GAME.SUBMIT_TASK_DONE, slot3.awards, slot3.taskIds)
		end
	end
end

slot0.accepetActivityTask = function (slot0)
	slot0:sendNotification(GAME.ACCEPT_ACTIVITY_TASK)
end

slot0.PlayStoryForTaskAct = function (slot0, slot1, slot2)
	slot4 = nil

	for slot8, slot9 in ipairs(slot3) do
		if slot9 and not slot9:isEnd() then
			slot11 = 0
			slot12 = 0

			for slot16, slot17 in ipairs(slot10) do
				for slot21, slot22 in ipairs(slot17) do
					if slot22 == slot1 then
						slot11 = slot16
						slot12 = slot21
					end
				end
			end

			if slot9:getConfig("config_client").story or {}[slot11] and slot13[slot11][slot12] and not pg.NewStoryMgr.GetInstance():IsPlayed(slot14) then
				slot4 = slot14
			end
		end
	end

	if slot4 then
		pg.NewStoryMgr.GetInstance():Play(slot4, slot2)
	else
		slot2()
	end
end

return slot0

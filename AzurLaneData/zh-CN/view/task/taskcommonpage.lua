slot0 = class("TaskCommonPage", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "TaskListPage"
end

slot0.OnLoaded = function (slot0)
	slot0._scrllPanel = slot0:findTF("right_panel")
	slot0._scrollView = slot0._scrllPanel:GetComponent("LScrollRect")
end

slot0.OnInit = function (slot0)
	slot0.taskCards = {}

	slot0._scrollView.onInitItem = function (slot0)
		slot0:onInitTask(slot0)
	end

	slot0._scrollView.onUpdateItem = function (slot0, slot1)
		slot0:onUpdateTask(slot0, slot1)
	end
end

slot0.onInitTask = function (slot0, slot1)
	slot0.taskCards[slot1] = TaskCard.New(slot1, slot0.contextData.viewComponent)
end

slot0.onUpdateTask = function (slot0, slot1, slot2)
	if not slot0.taskCards[slot2] then
		slot0:onInitTask(slot2)

		slot3 = slot0.taskCards[slot2]
	end

	slot3:update(slot0.taskVOs[slot1 + 1])
end

slot0.Update = function (slot0, slot1, slot2, slot3)
	slot0:Show()

	slot0.taskVOs = {}

	for slot8, slot9 in pairs(slot4) do
		if slot9:getConfig("visibility") == 1 and slot2[slot9:GetRealType()] then
			table.insert(slot0.taskVOs, slot9)
		end
	end

	if (slot1 == TaskScene.PAGE_TYPE_ALL or slot1 == TaskScene.PAGE_TYPE_ROUTINE) and TaskScene.IsPassScenario() and TaskScene.IsNewStyleTime() then
		slot6 = getProxy(TaskProxy)

		for slot10, slot11 in ipairs(slot5) do
			if not (slot6:getTaskById(slot11) or slot6:getFinishTaskById(slot11)) then
				table.insert(slot0.taskVOs, Task.New({
					progress = 0,
					id = slot11
				}))
			end
		end
	end

	slot0:Sort()
	slot0._scrollView:SetTotalCount(#slot0.taskVOs, -1)

	if slot0:GetSliderValue() > 0 then
		slot0._scrollView:ScrollTo(slot5)
	end

	if slot3 then
		slot3(slot0.taskVOs)
	end
end

slot0.GetSliderValue = function (slot0)
	slot1 = -1

	if slot0.contextData.targetId then
		slot2 = nil

		for slot6, slot7 in ipairs(slot0.taskVOs) do
			if slot7.id == slot0.contextData.targetId then
				slot2 = slot6 - 1

				break
			end
		end

		if slot2 then
			slot1 = slot0._scrollView:HeadIndexToValue(slot2)
		end
	end

	return slot1
end

slot0.Sort = function (slot0)
	function slot1(slot0, slot1, slot2)
		return slot3(slot0) < slot3(slot1)
	end

	function slot2(slot0)
		return (slot0:IsUrTask() and 1) or 0
	end

	function slot3(slot0, slot1)
		if slot0:GetRealType() == slot1:GetRealType() then
			return slot0.id < slot1.id
		elseif slot0:getTaskStatus() == 0 then
			return slot0(slot0:GetRealType(), slot1:GetRealType(), {
				26,
				36,
				6,
				3,
				4,
				13,
				5,
				2,
				1
			})
		elseif slot0:getTaskStatus() == 1 then
			return slot0(slot0:GetRealType(), slot1:GetRealType(), {
				26,
				36,
				6,
				1,
				4,
				13,
				2,
				5,
				3
			})
		end
	end

	table.sort(slot0.taskVOs, function (slot0, slot1)
		if slot0:getTaskStatus() == slot1:getTaskStatus() then
			if ((slot0.id == 10302 and 1) or 0) == ((slot1.id == 10302 and 1) or 0) then
				if slot0(slot0) == slot0(slot1) then
					return slot1(slot0, slot1)
				else
					return slot5 < slot4
				end
			else
				return slot3 < slot2
			end
		else
			return slot2(slot0:getTaskStatus(), slot1:getTaskStatus(), {
				1,
				0,
				2,
				-1
			})
		end
	end)
end

slot0.OnDestroy = function (slot0)
	for slot4, slot5 in pairs(slot0.taskCards) do
		slot5:dispose()
	end
end

slot0.GetWaitToCheckList = function (slot0)
	slot1 = slot0.taskVOs or {}
	slot2 = {}

	for slot6, slot7 in pairs(slot1) do
		if slot7:getTaskStatus() == 1 and slot7:getConfig("visibility") == 1 then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.ExecuteOneStepSubmit = function (slot0)
	slot1 = slot0:GetWaitToCheckList()
	slot2 = nil
	slot4 = nil

	function slot5()
		slot0, slot1 = slot2:filterOverflowTaskVOList(slot3)
		slot0 = slot2:filterSubmitTaskVOList(slot2.filterSubmitTaskVOList, slot4)
		slot0 = slot2:filterChoiceTaskVOList(slot2.filterChoiceTaskVOList, slot4)

		pg.m02:sendNotification(GAME.MERGE_TASK_ONE_STEP_AWARD, {
			resultList = pg.m02.sendNotification
		})
	end

	coroutine.wrap(slot5)()

	if false then
		pg.TipsMgr.GetInstance():ShowTips(i18n("award_overflow_tip"))

		slot3 = false
	end
end

slot0.filterOverflowTaskVOList = function (slot0, slot1)
	slot2 = {}
	slot5 = getProxy(PlayerProxy):getData().gold
	slot6 = getProxy(PlayerProxy).getData().oil
	slot7 = (not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(pg.gameset.urpt_chapter_max.description[1])) or 0
	slot8 = pg.gameset.max_gold.key_value
	slot9 = pg.gameset.max_oil.key_value
	slot10 = (not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2]) or 0
	slot11 = false

	for slot15, slot16 in pairs(slot1) do
		if not slot16:judgeOverflow(slot5, slot6, slot7) then
			table.insert(slot2, slot16)
		end

		if slot17 then
			slot11 = true
		end
	end

	return slot2, slot11
end

slot0.filterSubmitTaskVOList = function (slot0, slot1, slot2)
	slot3 = {}

	for slot8, slot9 in ipairs(slot4) do
		if slot9:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM or slot9:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM or slot9:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
			slot10 = DROP_TYPE_ITEM

			if slot9:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
				slot10 = DROP_TYPE_RESOURCE
			end

			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot15, {
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("sub_item_warning"),
				items = {
					{
						type = slot10,
						id = slot9:getConfig("target_id_for_client"),
						count = slot9:getConfig("target_num")
					}
				},
				onYes = function ()
					table.insert(table.insert, )
					table.insert()
				end,
				onNo = function ()
					slot0()
				end
			})
			coroutine.yield()
		else
			table.insert(slot3, slot9)
		end
	end

	return slot3
end

slot0.filterChoiceTaskVOList = function (slot0, slot1)
	slot2 = {}

	for slot7, slot8 in ipairs(slot3) do
		if slot8:isSelectable() then
			slot10 = {}

			for slot14, slot15 in ipairs(slot9) do
				slot10[#slot10 + 1] = {
					type = slot15[1],
					id = slot15[2],
					count = slot15[3],
					index = slot14
				}
			end

			slot11 = nil

			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot16, {
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("select_award_warning"),
				items = slot10,
				itemFunc = function (slot0)
					slot0 = slot0.index
				end,
				onYes = function ()
					if not slot0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("no_item_selected_tip"))
					else
						for slot5, slot6 in ipairs(slot1) do
							table.insert(slot0, {
								type = slot6[1],
								id = slot6[2],
								number = slot6[3]
							})
						end

						slot2.choiceItemList = slot0

						table.insert(slot3, table.insert)
						process()
					end
				end,
				onNo = function ()
					process()
				end
			})
			coroutine.yield()
		else
			table.insert(slot2, slot8)
		end
	end

	return slot2
end

return slot0

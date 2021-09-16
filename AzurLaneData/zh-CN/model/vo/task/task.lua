slot0 = class("Task", import("..BaseVO"))
slot0.TYPE_SCENARIO = 1
slot0.TYPE_BRANCH = 2
slot0.TYPE_ROUTINE = 3
slot0.TYPE_WEEKLY = 4
slot0.TYPE_HIDDEN = 5
slot0.TYPE_ACTIVITY = 6
slot0.TYPE_ACTIVITY_ROUTINE = 36
slot0.TYPE_ACTIVITY_BRANCH = 26
slot0.TYPE_GUILD_WEEKLY = 12
slot0.TYPE_NEW_WEEKLY = 13
slot0.TYPE_ACTIVITY_WEEKLY = 46
slot1 = {
	"scenario",
	"branch",
	"routine",
	"weekly"
}
slot0.TASK_PROGRESS_UPDATE = 0
slot0.TASK_PROGRESS_APPEND = 1

slot0.Ctor = function (slot0, slot1)
	slot0.id = slot1.id
	slot0.configId = slot1.id
	slot0.progress = slot1.progress or 0
	slot0.acceptTime = slot1.accept_time
	slot0.submitTime = slot1.submit_time or 0
end

slot0.isClientTrigger = function (slot0)
	return slot0:getConfig("sub_type") > 2000 and slot0:getConfig("sub_type") < 3000
end

slot0.bindConfigTable = function (slot0)
	return pg.task_data_template
end

slot0.isGuildTask = function (slot0)
	return slot0:getConfig("type") == slot0.TYPE_GUILD_WEEKLY
end

slot0.IsRoutineType = function (slot0)
	return slot0:getConfig("type") == slot0.TYPE_ROUTINE
end

slot0.IsWeeklyType = function (slot0)
	return slot0:getConfig("type") == slot0.TYPE_WEEKLY or slot0:getConfig("type") == slot0.TYPE_NEW_WEEKLY
end

slot0.IsBackYardInterActionType = function (slot0)
	return slot0:getConfig("sub_type") == 2010
end

slot0.IsFlagShipInterActionType = function (slot0)
	return slot0:getConfig("sub_type") == 2011
end

slot0.IsGuildAddLivnessType = function (slot0)
	return slot0:getConfig("type") == slot0.TYPE_ROUTINE or slot1 == slot0.TYPE_WEEKLY or slot1 == slot0.TYPE_GUILD_WEEKLY or slot1 == slot0.TYPE_NEW_WEEKLY
end

slot0.isLock = function (slot0)
	return getProxy(PlayerProxy):getRawData().level < slot0:getConfig("level")
end

slot0.isFinish = function (slot0)
	return slot0:getConfig("target_num") <= slot0:getProgress()
end

slot0.getProgress = function (slot0)
	slot1 = slot0.progress

	if slot0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
		slot1 = getProxy(BagProxy):getItemCountById(tonumber(slot0:getConfig("target_id_for_client")))
	elseif slot0:getConfig("sub_type") == TASK_SUB_TYPE_PT then
		slot1 = (getProxy(ActivityProxy):getActivityById(tonumber(slot0:getConfig("target_id_2"))) and slot2.data1) or 0
	elseif slot0:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
		slot1 = getProxy(PlayerProxy):getData():getResById(slot0:getConfig("target_id_for_client"))
	elseif slot0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
		slot1 = getProxy(ActivityProxy):getVirtualItemNumber(slot0:getConfig("target_id_for_client"))
	elseif slot0:getConfig("sub_type") == TASK_SUB_TYPE_BOSS_PT then
		slot1 = getProxy(PlayerProxy):getData():getResById(tonumber(slot0:getConfig("target_id")))
	elseif slot0:getConfig("sub_type") == TASK_SUB_STROY then
		slot3 = 0

		_.each(slot0:getConfig("target_id"), function (slot0)
			if pg.NewStoryMgr.GetInstance():GetPlayedFlag(slot0) then
				slot0 = slot0 + 1
			end
		end)

		slot1 = slot3
	elseif slot0:getConfig("sub_type") == TASK_SUB_TYPE_TECHNOLOGY_POINT then
		slot1 = math.min(getProxy(TechnologyNationProxy):getNationPoint(tonumber(slot0:getConfig("target_id"))), slot0:getConfig("target_num"))
	end

	return slot1 or 0
end

slot0.isReceive = function (slot0)
	return slot0.submitTime > 0
end

slot0.getTaskStatus = function (slot0)
	if slot0:isLock() then
		return -1
	end

	if slot0:isReceive() then
		return 2
	end

	if slot0:isFinish() then
		return 1
	end

	return 0
end

slot0.onAdded = function (slot0)
	function slot1()
		if slot0:getConfig("sub_type") == 29 then
			if _.any(getProxy(SkirmishProxy):getRawData(), function (slot0)
				return slot0:getConfig("task_id") == slot0.id
			end) then
				return
			end

			pg.m02.sendNotification(slot1, GAME.TASK_GO, {
				taskVO = slot0
			})
		elseif slot0:getConfig("added_tip") > 0 then
			slot0 = nil

			if getProxy(ContextProxy).getCurrentContext(slot1).mediator.__cname ~= TaskMediator.__cname then
				function slot0()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK, {
						page = slot0[slot1:GetRealType()]
					})
				end
			end

			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
				noText = "text_iknow",
				yesText = "text_forward",
				content = i18n("tip_add_task", HXSet.hxLan(slot0:getConfig("name"))),
				onYes = slot0,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end

	function slot2()
		if not table.contains({
			"LevelScene",
			"BattleScene",
			"EventListScene",
			"MilitaryExerciseScene",
			"DailyLevelScene"
		}, getProxy(ContextProxy):getCurrentContext().viewComponent.__cname) then
			return true
		end

		return false
	end

	if slot0.getConfig(slot0, "story_id") and slot3 ~= "" and slot2() then
		pg.NewStoryMgr.GetInstance():Play(slot3, slot1, true, true)
	else
		slot1()
	end
end

slot0.updateProgress = function (slot0, slot1)
	slot0.progress = slot1
end

slot0.isSelectable = function (slot0)
	return slot0:getConfig("award_choice") ~= nil and type(slot1) == "table" and #slot1 > 0
end

slot0.judgeOverflow = function (slot0, slot1, slot2, slot3)
	return slot0.StaticJudgeOverflow(slot1, slot2, slot3, slot0:getTaskStatus() == 1, slot0:getConfig("visibility") == 1, slot0:getConfig("award_display"))
end

slot0.StaticJudgeOverflow = function (slot0, slot1, slot2, slot3, slot4, slot5)
	if slot3 and slot4 then
		slot8 = slot0 or getProxy(PlayerProxy):getData().gold
		slot9 = slot1 or getProxy(PlayerProxy).getData().oil
		slot10 = slot2 or (not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(pg.gameset.urpt_chapter_max.description[1])) or 0
		slot11 = pg.gameset.max_gold.key_value
		slot12 = pg.gameset.max_oil.key_value
		slot13 = (not LOCK_UR_SHIP and pg.gameset.urpt_chapter_max.description[2]) or 0
		slot14 = false
		slot15 = false
		slot16 = false
		slot17 = false
		slot18 = {}

		for slot23, slot24 in ipairs(slot19) do
			slot26 = slot24[2]
			slot27 = slot24[3]

			if slot24[1] == DROP_TYPE_RESOURCE then
				if slot26 == PlayerConst.ResGold then
					if (slot8 + slot27) - slot11 > 0 then
						slot14 = true

						table.insert(slot18, {
							type = DROP_TYPE_RESOURCE,
							id = PlayerConst.ResGold,
							count = setColorStr(slot28, COLOR_RED)
						})
					end
				elseif slot26 == PlayerConst.ResOil and (slot9 + slot27) - slot12 > 0 then
					slot15 = true

					table.insert(slot18, {
						type = DROP_TYPE_RESOURCE,
						id = PlayerConst.ResOil,
						count = setColorStr(slot28, COLOR_RED)
					})
				end
			elseif not LOCK_UR_SHIP and slot25 == DROP_TYPE_VITEM and pg.item_data_statistics[slot26].virtual_type == 20 and (slot10 + slot27) - slot13 > 0 then
				slot16 = true

				table.insert(slot18, {
					type = DROP_TYPE_VITEM,
					id = slot7,
					count = setColorStr(slot29, COLOR_RED)
				})
			end
		end

		return slot14 or slot15 or slot16, slot18
	end
end

slot0.IsUrTask = function (slot0)
	if not LOCK_UR_SHIP then
		slot2 = pg.gameset.urpt_chapter_max.description[1]

		return _.any(slot0:getConfig("award_display"), function (slot0)
			return slot0[1] == DROP_TYPE_ITEM and slot0[2] == slot0
		end)
		return
	end

	return false
end

slot0.GetRealType = function (slot0)
	if slot0:getConfig("priority_type") == 0 then
		slot1 = slot0:getConfig("type")
	end

	return slot1
end

return slot0

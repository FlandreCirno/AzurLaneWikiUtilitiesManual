slot0 = class("LevelMediator2", import("..base.ContextMediator"))
slot0.ON_TRACKING = "LevelMediator2:ON_TRACKING"
slot0.ON_ELITE_TRACKING = "LevelMediator2:ON_ELITE_TRACKING"
slot0.ON_UPDATE_CUSTOM_FLEET = "LevelMediator2:ON_UPDATE_CUSTOM_FLEET"
slot0.ON_OP = "LevelMediator2:ON_OP"
slot0.ON_STAGE = "LevelMediator2:ON_STAGE"
slot0.ON_GO_TO_TASK_SCENE = "LevelMediator2:ON_GO_TO_TASK_SCENE"
slot0.ON_OPEN_EVENT_SCENE = "LevelMediator2:ON_OPEN_EVENT_SCENE"
slot0.ON_DAILY_LEVEL = "LevelMediator2:ON_DAILY_LEVEL"
slot0.ON_OPEN_MILITARYEXERCISE = "LevelMediator2:ON_OPEN_MILLITARYEXERCISE"
slot0.ON_OVERRIDE_CHAPTER = "LevelMediator2:ON_OVERRIDE_CHAPTER"
slot0.ON_TIME_UP = "LevelMediator2:ON_TIME_UP"
slot0.ON_EVENT_LIST_UPDATE = "LevelMediator2:ON_EVENT_LIST_UPDATE"
slot0.ON_START = "ON_START"
slot0.ON_ENTER_MAINLEVEL = "LevelMediator2:ON_ENTER_MAINLEVEL"
slot0.ON_PERFORM_COMBAT = "LevelMediator2.ON_PERFORM_COMBAT"
slot0.ON_ELITE_OEPN_DECK = "LevelMediator2:ON_ELITE_OEPN_DECK"
slot0.ON_ELITE_CLEAR = "LevelMediator2:ON_ELITE_CLEAR"
slot0.ON_ELITE_RECOMMEND = "LevelMediator2:ON_ELITE_RECOMMEND"
slot0.ON_ELITE_ADJUSTMENT = "LevelMediator2:ON_ELITE_ADJUSTMENT"
slot0.ON_ACTIVITY_MAP = "LevelMediator2:ON_ACTIVITY_MAP"
slot0.GO_ACT_SHOP = "LevelMediator2:GO_ACT_SHOP"
slot0.ON_SWITCH_NORMAL_MAP = "LevelMediator2:ON_SWITCH_NORMAL_MAP"
slot0.NOTICE_AUTOBOT_ENABLED = "LevelMediator2:NOTICE_AUTOBOT_ENABLED"
slot0.ON_EXTRA_RANK = "LevelMediator2:ON_EXTRA_RANK"
slot0.ON_FETCH_SUB_CHAPTER = "LevelMediator2:ON_FETCH_SUB_CHAPTER"
slot0.ON_REFRESH_SUB_CHAPTER = "LevelMediator2:ON_REFRESH_SUB_CHAPTER"
slot0.ON_STRATEGYING_CHAPTER = "LevelMediator2:ON_STRATEGYING_CHAPTER"
slot0.ON_SELECT_COMMANDER = "LevelMediator2:ON_SELECT_COMMANDER"
slot0.ON_SELECT_ELITE_COMMANDER = "LevelMediator2:ON_SELECT_ELITE_COMMANDER"
slot0.ON_COMMANDER_SKILL = "LevelMediator2:ON_COMMANDER_SKILL"
slot0.ON_SHIP_DETAIL = "LevelMediator2:ON_SHIP_DETAIL"
slot0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN = "LevelMediator2:ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN"
slot0.GET_REMASTER_TICKETS_DONE = "LevelMediator2:GET_REMASTER_TICKETS_DONE"
slot0.ON_FLEET_SHIPINFO = "LevelMediator2:ON_FLEET_SHIPINFO"
slot0.ON_STAGE_SHIPINFO = "LevelMediator2:ON_STAGE_SHIPINFO"
slot0.ON_COMMANDER_OP = "LevelMediator2:ON_COMMANDER_OP"
slot0.CLICK_CHALLENGE_BTN = "LevelMediator2:CLICK_CHALLENGE_BTN"
slot0.ON_SUBMIT_TASK = "LevelMediator2:ON_SUBMIT_TASK"
slot0.ON_VOTE_BOOK = "LevelMediator2:ON_VOTE_BOOK"
slot0.GET_CHAPTER_DROP_SHIP_LIST = "LevelMediator2:GET_CHAPTER_DROP_SHIP_LIST"
slot0.ENTER_WORLD = "LevelMediator2:ENTER_WORLD"

slot0.register = function (slot0)
	slot1 = getProxy(PlayerProxy)

	slot0:bind(slot0.GET_CHAPTER_DROP_SHIP_LIST, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = slot1,
			callback = slot2
		})
	end)
	slot0.bind(slot0, slot0.ON_VOTE_BOOK, function (slot0)
		slot0:addSubLayers(Context.New({
			mediator = VoteOrderBookMediator,
			viewComponent = VoteOrderBookLayer
		}))
	end)
	slot0.bind(slot0, slot0.ON_COMMANDER_OP, function (slot0, slot1, slot2)
		slot0.contextData.commanderOPChapter = slot2

		slot0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = slot1
		})
	end)
	slot0.bind(slot0, slot0.ON_SELECT_COMMANDER, function (slot0, slot1, slot2, slot3)
		FormationMediator.onSelectCommander(slot1, slot2)

		slot0.contextData.selectedChapterVO = slot3
	end)
	slot0.bind(slot0, slot0.ON_SELECT_ELITE_COMMANDER, function (slot0, slot1, slot2, slot3)
		slot4 = getProxy(ChapterProxy)
		slot5 = slot3.id
		slot0.contextData.editEliteChapter = slot3
		slot6 = slot3:getEliteFleetCommanders()[slot1] or {}
		slot7 = nil

		if slot6[slot2] then
			slot7 = getProxy(CommanderProxy):getCommanderById(slot6[slot2])
		end

		function slot8()
			if slot0.contextData.editEliteChapter then
				slot1.eliteCommanderList = slot1:getChapterById(slot0).eliteCommanderList
				slot0.contextData.editEliteChapter = slot0.contextData
			end
		end

		slot0.sendNotification(slot9, GAME.GO_SCENE, SCENE.COMMANDROOM, {
			maxCount = 1,
			mode = CommandRoomScene.MODE_SELECT,
			activeCommander = slot7,
			ignoredIds = {},
			fleetType = CommandRoomScene.FLEET_TYPE_HARD_CHAPTER,
			chapterId = slot5,
			onCommander = function (slot0)
				return true
			end,
			onSelected = function (slot0, slot1)
				slot0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = slot1,
					index = slot2,
					pos = slot3,
					commanderId = slot0[1],
					callback = function ()
						slot0()
						slot1()
					end
				})
			end,
			onQuit = function (slot0)
				slot0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = slot1,
					index = slot2,
					pos = slot3,
					callback = function ()
						slot0()
						slot1()
					end
				})
			end
		})
	end)
	slot0.RegisterTrackEvent(slot0)
	slot0:bind(slot0.ON_UPDATE_CUSTOM_FLEET, function (slot0, slot1)
		slot0:sendNotification(GAME.UPDATE_CUSTOM_FLEET, {
			chapterId = slot1.id
		})
	end)
	slot0.bind(slot0, slot0.ON_OP, function (slot0, slot1)
		slot0:sendNotification(GAME.CHAPTER_OP, slot1)
	end)
	slot0.bind(slot0, slot0.ON_SWITCH_NORMAL_MAP, function (slot0)
		slot2 = nil
		slot3 = Map.lastMap and getProxy(ChapterProxy):getMapById(Map.lastMap)

		if (not slot3 or not slot3:isUnlock() or slot3:getMapType() ~= Map.SCENARIO or Map.lastMap) and slot1:getLastUnlockMap().id then
			slot0.viewComponent:setMap(slot2)
		end
	end)
	slot0.bind(slot0, slot0.ON_STAGE, function (slot0)
		slot0:addSubLayers(Context.New({
			mediator = ChapterPreCombatMediator,
			viewComponent = ChapterPreCombatLayer,
			onRemoved = function ()
				slot0.viewComponent:onSubLayerClose()
			end
		}), false, function ()
			slot0.viewComponent:onSubLayerOpen()
		end)
	end)
	slot0.bind(slot0, slot0.ON_OPEN_MILITARYEXERCISE, function ()
		if getProxy(ActivityProxy):getMilitaryExerciseActivity() then
			slot0:sendNotification(GAME.GO_SCENE, SCENE.MILITARYEXERCISE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_notStartOrEnd"))
		end
	end)
	slot0.bind(slot0, slot0.CLICK_CHALLENGE_BTN, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.CHALLENGE_MAIN_SCENE)
	end)
	slot0.bind(slot0, slot0.ON_DAILY_LEVEL, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.DAILYLEVEL)
	end)
	slot0.bind(slot0, slot0.ON_GO_TO_TASK_SCENE, function ()
		slot0:sendNotification(GAME.GO_SCENE, SCENE.TASK)
	end)
	slot0.bind(slot0, slot0.ON_OPEN_EVENT_SCENE, function ()
		slot0:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	slot0.bind(slot0, slot0.ON_OVERRIDE_CHAPTER, function ()
		getProxy(ChapterProxy):updateChapter(slot0.contextData.chapterVO)
	end)
	slot0.bind(slot0, slot0.ON_TIME_UP, function ()
		slot0:onTimeUp()
	end)
	slot0.bind(slot0, slot0.ON_EVENT_LIST_UPDATE, function ()
		slot0.viewComponent:addbubbleMsgBox(function (slot0)
			slot0:OnEventUpdate(slot0)
		end)

		if getProxy(ChapterProxy).getActiveChapter(slot1, true) and slot1:IsAutoFight() then
			if pg.GuildMsgBoxMgr.GetInstance():GetShouldShowBattleTip() then
				if getProxy(GuildProxy):getRawData() and slot3:getWeeklyTask() and slot4.id ~= 0 then
					getProxy(ChapterProxy):AddExtendChapterDataTable(slot1.id, "ListGuildEventNotify", slot4:GetPresonTaskId(), slot4:GetPrivateTaskName())
					pg.GuildMsgBoxMgr.GetInstance():CancelShouldShowBattleTip()
				end

				slot2:SubmitTask(function (slot0, slot1, slot2)
					if slot0 then
						getProxy(ChapterProxy):AddExtendChapterDataTable(slot0.id, "ListGuildEventAutoReceiveNotify", slot2, pg.task_data_template[slot2].desc)
					end
				end)
			end
		else
			slot0.viewComponent.addbubbleMsgBox(slot2, function (slot0)
				pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle(slot0)
			end)
		end
	end)
	slot0.bind(slot0, slot0.ON_ELITE_CLEAR, function (slot0, slot1)
		slot1.chapterVO.clearEliterFleetByIndex(slot3, slot2)

		slot4 = getProxy(ChapterProxy)

		slot4:updateChapter(slot3)
		slot4:duplicateEliteFleet(slot3)
		slot0.viewComponent.levelFleetView:setOnHard(slot1.chapterVO)
	end)
	slot0.bind(slot0, slot0.NOTICE_AUTOBOT_ENABLED, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMON_FLAG, {
			flagID = BATTLE_AUTO_ENABLED
		})
	end)
	slot0.bind(slot0, slot0.ON_ELITE_RECOMMEND, function (slot0, slot1)
		slot4 = getProxy(ChapterProxy)

		slot4:eliteFleetRecommend(slot3, slot1.index)
		slot4:updateChapter(slot3)
		slot4:duplicateEliteFleet(slot3)
		slot0.viewComponent.levelFleetView:setOnHard(slot1.chapterVO)
	end)
	slot0.bind(slot0, slot0.ON_ELITE_ADJUSTMENT, function (slot0, slot1)
		slot2 = getProxy(ChapterProxy)

		slot2:updateChapter(slot1)
		slot2:duplicateEliteFleet(slot1)
	end)
	slot0.bind(slot0, slot0.ON_ELITE_OEPN_DECK, function (slot0, slot1)
		slot2 = slot1.shipType
		slot3 = slot1.fleetIndex
		slot4 = slot1.shipVO
		slot5 = slot1.fleet
		slot6 = slot1.chapter
		slot7 = slot1.teamType
		slot10 = {}

		for slot14, slot15 in pairs(slot9) do
			if type(slot2) == "number" then
				if slot2 ~= 0 and slot2 ~= slot15:getShipType() then
					table.insert(slot10, slot14)
				end
			elseif type(slot2) == "string" and not table.contains(ShipType.BundleList[slot2], slot15:getShipType()) then
				table.insert(slot10, slot14)
			end
		end

		slot0.contextData.editEliteChapter = slot6
		slot11 = {}

		for slot15, slot16 in pairs(slot5) do
			table.insert(slot11, slot15.id)
		end

		slot19.onShip, slot19.confirmSelect, slot19.onSelected = slot0:getDockCallbackFuncs(slot5, slot4, slot6, slot3)

		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			useBlackBlock = true,
			selectedMin = 0,
			skipSelect = true,
			selectedMax = 1,
			energyDisplay = true,
			ignoredIds = slot10,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = slot4 ~= nil,
			teamFilter = slot7,
			leftTopInfo = i18n("word_formation"),
			onShip = slot12,
			confirmSelect = slot13,
			onSelected = slot14,
			hideTagFlags = setmetatable({
				inElite = slot6:getConfig("formation")
			}, {
				__index = ShipStatus.TAG_HIDE_LEVEL
			}),
			otherSelectedIds = slot11
		})
	end)
	slot0.bind(slot0, slot0.ON_ACTIVITY_MAP, function ()
		slot1, slot2 = getProxy(ChapterProxy).getLastMapForActivity(slot0)

		if not slot1 or not slot0:getMapById(slot1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end

		slot0.viewComponent:ShowSelectedMap(slot1, function ()
			if slot0 then
				slot2.viewComponent:switchToChapter(slot1:getChapterById(slot1.getChapterById))
			end
		end)
	end)
	slot0.bind(slot0, slot0.GO_ACT_SHOP, function ()
		slot0, slot1 = nil
		slot2 = {}
		slot3 = pg.gameset.activity_res_id.key_value

		if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY) and slot4:getConfig("config_client").resId == slot3 and not slot4:isEnd() then
			slot0:addSubLayers(Context.New({
				mediator = LotteryMediator,
				viewComponent = LotteryLayer,
				data = {
					activityId = slot4.id
				},
				onRemoved = function ()
					slot0.viewComponent:onSubLayerClose()
				end
			}), false, function ()
				slot0.viewComponent:onSubLayerOpen()
			end)
		else
			slot0.sendNotification(slot7, GAME.GO_SCENE, SCENE.SHOP, {
				warp = NewShopsScene.TYPE_ACTIVITY,
				actId = _.detect(getProxy(ActivityProxy).getActivitiesByType(slot6, ActivityConst.ACTIVITY_TYPE_SHOP), function (slot0)
					return slot0:getConfig("config_client").pt_id == slot0
				end) and slot5.id
			})
		end
	end)
	slot0.bind(slot0, slot0.ON_SHIP_DETAIL, function (slot0, slot1)
		slot0.contextData.selectedChapterVO = slot1.chapter

		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1.id
		})
	end)
	slot0.bind(slot0, slot0.ON_FLEET_SHIPINFO, function (slot0, slot1)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1.shipId,
			shipVOs = slot1.shipVOs
		})

		slot0.contextData.editEliteChapter = slot1.chapter
	end)
	slot0.bind(slot0, slot0.ON_STAGE_SHIPINFO, function (slot0, slot1)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1.shipId,
			shipVOs = slot1.shipVOs
		})
	end)
	slot0.bind(slot0, slot0.ON_EXTRA_RANK, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_EXTRA_CHAPTER
		})
	end)
	slot0.bind(slot0, slot0.ON_REFRESH_SUB_CHAPTER, function (slot0, slot1)
		slot0:sendNotification(GAME.SUB_CHAPTER_REFRESH, slot1)
	end)
	slot0.bind(slot0, slot0.ON_FETCH_SUB_CHAPTER, function (slot0)
		if not LOCK_SUBMARINE then
			slot0:sendNotification(GAME.SUB_CHAPTER_FETCH)
		end
	end)
	slot0.bind(slot0, slot0.ON_STRATEGYING_CHAPTER, function (slot0)
		slot1 = getProxy(ChapterProxy)
		slot2 = slot1:getActiveChapter()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_forward",
			content = i18n("levelScene_chapter_is_activation", string.split(slot1:getMapById(slot2:getConfig("map")).getConfig(slot3, "name"), "|")[1] .. ":" .. slot2:getConfig("chapter_name")),
			onYes = function ()
				slot0.viewComponent:switchToChapter(slot0.viewComponent)
			end,
			onNo = function ()
				slot0.contextData.chapterVO = slot1

				slot0.contextData.viewComponent:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpRetreat,
					exittype = ChapterConst.ExitFromMap
				})
			end,
			onClose = function ()
				return
			end,
			noBtnType = pg.MsgboxMgr.BUTTON_RETREAT
		})
	end)
	slot0.bind(slot0, slot0.ON_COMMANDER_SKILL, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = slot1
			}
		}))
	end)
	slot0.bind(slot0, slot0.ON_PERFORM_COMBAT, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_PERFORM,
			stageId = slot1,
			exitCallback = slot2
		})
	end)
	slot0.bind(slot0, slot0.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN, function (slot0)
		slot0:sendNotification(GAME.GET_REMASTER_TICKETS)
	end)
	slot0.bind(slot0, slot0.ON_SUBMIT_TASK, function (slot0, slot1)
		slot0:sendNotification(GAME.SUBMIT_TASK, slot1)
	end)
	slot0.bind(slot0, slot0.ON_START, function (slot0)
		slot1 = getProxy(ChapterProxy):getActiveChapter()
		slot3 = slot1:getStageId(slot1.fleet.line.row, slot1.fleet.line.column)

		seriesAsync({
			function (slot0)
				slot1 = {}

				for slot5, slot6 in pairs(slot0.ships) do
					table.insert(slot1, slot6)
				end

				Fleet.EnergyCheck(slot1, slot0.name, function (slot0)
					if slot0 then
						slot0()
					end
				end, function (slot0)
					if not slot0 then
						getProxy(ChapterProxy):StopAutoFight()
					end
				end)
			end,
			function (slot0)
				if getProxy(PlayerProxy):getRawData():GoldMax(1) then
					getProxy(ChapterProxy):StopAutoFight()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("gold_max_tip_title") .. i18n("resource_max_tip_battle"),
						onYes = slot0,
						weight = LayerWeightConst.SECOND_LAYER
					})
				else
					slot0()
				end
			end,
			function (slot0)
				slot0:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_SCENARIO,
					stageId = slot0.sendNotification
				})
			end
		})
	end)
	slot0.bind(slot0, slot0.ON_ENTER_MAINLEVEL, function (slot0, slot1)
		slot0:DidEnterLevelMainUI(slot1)
	end)
	slot0.bind(slot0, slot0.ENTER_WORLD, function (slot0)
		slot0:sendNotification(GAME.ENTER_WORLD)
	end)

	slot0.player = slot1.getData(slot1)

	slot0.viewComponent:updateRes(slot0.player)
	slot0.viewComponent:updateLastFleet(slot1:getFlag("lastFleetIndex"))
	slot0.viewComponent:updateEvent(slot2)
	slot0.viewComponent:updateFleet(slot4)
	slot0.viewComponent:setShips(getProxy(BayProxy).getRawData(slot5))
	slot0.viewComponent:updateVoteBookBtn(getProxy(VoteProxy):GetOrderBook())
	slot0.viewComponent:setCommanderPrefabs(slot7)

	for slot12, slot13 in ipairs(slot8) do
		if slot13:getConfig("config_id") == pg.gameset.activity_res_id.key_value then
			slot0.viewComponent:updatePtActivity(slot13)

			break
		end
	end

	slot0.viewComponent:setEliteQuota(getProxy(DailyLevelProxy).eliteCount, pg.gameset.elite_quota.key_value)
	slot0.viewComponent:updateSubInfo(getProxy(ChapterProxy).subRefreshCount, getProxy(ChapterProxy).subProgress)
	slot0.viewComponent:setSpecialOperationTickets(slot12)
	slot0.viewComponent:ShowEntranceUI(slot0.contextData.entranceStatus)

	if not slot0.contextData.entranceStatus and slot0.contextData.InitializeMap then
		slot0:DidEnterLevelMainUI(slot0.contextData.InitializeMap)

		slot0.contextData.InitializeMap = nil
	end

	slot10:updateActiveChapterShips()
end

slot0.DidEnterLevelMainUI = function (slot0, slot1)
	slot0.viewComponent:setMap(slot1)

	if slot0.contextData.chapterVO and slot2.active then
		slot0.contextData.isSwitchToChapter = true

		slot0.viewComponent:switchToChapter(slot2, function ()
			slot0:OnSwitchChapterDone()
		end)
	elseif slot0.contextData.map.isSkirmish(slot3) then
		slot0.viewComponent:ShowCurtains(true)
		slot0.viewComponent:doPlayAnim("TV01", function (slot0)
			go(slot0):SetActive(false)
			slot0.viewComponent:ShowCurtains(false)
		end)
	end

	if slot0.contextData.preparedTaskList and #slot0.contextData.preparedTaskList > 0 then
		for slot6, slot7 in ipairs(slot0.contextData.preparedTaskList) do
			slot0.sendNotification(slot0, GAME.SUBMIT_TASK, slot7)
		end

		table.clean(slot0.contextData.preparedTaskList)
	end

	if slot0.contextData.StopAutoFightFlag then
		if getProxy(ChapterProxy):getActiveChapter() then
			slot3:SetChapterAutoFlag(slot4.id, false)
			slot0.viewComponent:updateChapterVO(slot4, bit.bor(ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy))
		end

		slot0.contextData.StopAutoFightFlag = nil
	end
end

slot0.RegisterTrackEvent = function (slot0)
	slot0:bind(slot0.ON_TRACKING, function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		getProxy(PlayerProxy):setFlag("lastFleetIndex", slot2)
		slot0:sendNotification(GAME.TRACKING, {
			chapterId = slot1,
			fleetIds = slot2,
			operationItem = slot4,
			loopFlag = slot3,
			duties = slot5,
			autoFightFlag = slot6
		})
		slot0.viewComponent:updateLastFleet(getProxy(PlayerProxy):getFlag("lastFleetIndex"))
		Chapter.SaveChapterLastFleetCache(slot1, slot2)
	end)
	slot0.bind(slot0, slot0.ON_ELITE_TRACKING, function (slot0, slot1, slot2, slot3, slot4, slot5)
		slot0:sendNotification(GAME.TRACKING, {
			chapterId = slot1,
			loopFlag = slot2,
			operationItem = slot3,
			duties = slot4,
			autoFightFlag = slot5
		})
	end)
end

slot0.NoticeVoteBook = function (slot0, slot1)
	if getProxy(VoteProxy):IsNewOrderBook() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			noText = "text_iknow",
			yesText = "text_forward",
			content = i18n("vote_get_book"),
			onYes = function ()
				if getProxy(VoteProxy):GetOrderBook() and not slot0:IsExpired() then
					slot0.viewComponent:emit(slot1.ON_VOTE_BOOK)
				end

				slot2()
			end
		})
	else
		slot1()
	end
end

slot0.OnSwitchChapterDone = function (slot0)
	slot0.viewComponent:tryPlaySubGuide()
end

slot0.listNotificationInterests = function (slot0)
	return {
		ChapterProxy.CHAPTER_UPDATED,
		ChapterProxy.CHAPTER_TIMESUP,
		ChapterProxy.CHAPTER_EXTAR_FLAG_UPDATED,
		PlayerProxy.UPDATED,
		DailyLevelProxy.ELITE_QUOTA_UPDATE,
		GAME.TRACKING_DONE,
		GAME.CHAPTER_OP_DONE,
		GAME.EVENT_LIST_UPDATE,
		GAME.BEGIN_STAGE_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUB_CHAPTER_REFRESH_DONE,
		GAME.SUB_CHAPTER_FETCH_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COOMMANDER_EQUIP_TO_FLEET_DONE,
		GAME.COMMANDER_ELIT_FORMATION_OP_DONE,
		GAME.SUBMIT_TASK_DONE,
		GAME.GET_REMASTER_TICKETS_DONE,
		VoteProxy.VOTE_ORDER_BOOK_DELETE,
		VoteProxy.VOTE_ORDER_BOOK_UPDATE,
		GAME.VOTE_BOOK_BE_UPDATED_DONE,
		BagProxy.ITEM_UPDATED,
		ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED,
		ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.BEGIN_STAGE_DONE then
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
	elseif slot2 == VoteProxy.VOTE_ORDER_BOOK_DELETE or VoteProxy.VOTE_ORDER_BOOK_UPDATE == slot2 then
		slot0.viewComponent:updateVoteBookBtn(slot3)
	elseif slot2 == PlayerProxy.UPDATED then
		slot0.viewComponent:updateRes(slot3)
	elseif slot2 == GAME.TRACKING_DONE then
		slot0.viewComponent:resetLevelGrid()

		slot0.viewComponent.FirstEnterChapter = slot3.id

		slot0.viewComponent:switchToChapter(slot3, function ()
			slot0:loadSubState(slot1.subAutoAttack)
		end)
	elseif slot2 == ChapterProxy.CHAPTER_UPDATED then
		slot0.viewComponent.updateChapterVO(slot4, slot3.chapter, slot3.dirty)
	elseif slot2 == GAME.COMMANDER_ELIT_FORMATION_OP_DONE then
		if slot0.contextData.commanderOPChapter then
			slot0.contextData.commanderOPChapter.eliteCommanderList = getProxy(ChapterProxy):getChapterById(slot3.chapterId).eliteCommanderList

			slot0.viewComponent:updateFleetEdit(slot0.contextData.commanderOPChapter, slot3.index)
		end
	elseif slot2 == ChapterProxy.CHAPTER_EXTAR_FLAG_UPDATED then
		if slot0.viewComponent.levelStageView then
			slot0.viewComponent.levelStageView:ActionInvoke("PopBar", slot3)
		end
	else
		if slot2 == GAME.CHAPTER_OP_DONE then
			slot4 = nil
			slot5 = false
			slot7 = coroutine.wrap(function ()
				slot2 = slot1.contextData.chapterVO or slot0.chapterVO

				if slot0 == ChapterConst.OpRetreat and slot0.exittype and slot0.exittype == ChapterConst.ExitFromMap then
					slot1.viewComponent:setChapter(nil)
					slot1.viewComponent:updateChapterTF(slot2.id)
					slot1:OnExitChapter(slot2)

					return
				end

				if slot0 == ChapterConst.OpRetreat and slot2:existOni() and slot2:checkOniState() then
					slot1.viewComponent:displaySpResult(slot3, slot2)
					coroutine.yield()
				end

				if slot0 == ChapterConst.OpRetreat and slot2:isPlayingWithBombEnemy() then
					slot1.viewComponent:displayBombResult(slot2)
					coroutine.yield()
				end

				if slot0.items and #slot3 > 0 then
					if slot0 == ChapterConst.OpRetreat and slot1.contextData.map:isEscort() then
						slot1.viewComponent:emit(BaseUI.ON_AWARD, {
							items = slot3,
							title = AwardInfoLayer.TITLE.ESCORT,
							removeFunc = slot2
						})
					else
						seriesAsync({
							function (slot0)
								slot0.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
									items = slot1,
									closeOnCompleted = slot2:IsAutoFight(),
									removeFunc = slot0
								})
							end,
							function (slot0)
								if _.any(slot0, function (slot0)
									return slot0.type == DROP_TYPE_STRATEGY
								end) then
									slot1.viewComponent.levelStageView.popStageStrategy(slot1)
								end

								slot2()
							end
						})
					end

					coroutine.yield()
				end

				if slot0 == ChapterConst.OpSkipBattle then
					slot1.viewComponent.levelStageView.tryAutoAction(slot4, function ()
						if not slot0.viewComponent.levelStageView then
							return
						end

						slot0.viewComponent.levelStageView:tryAutoTrigger()
					end)
				elseif slot0 == ChapterConst.OpRetreat then
					if getProxy(ContextProxy).getContextByMediator(slot4, LevelMediator2) then
						slot5 = {}

						if slot4:getContextByMediator(ChapterPreCombatMediator) then
							table.insert(slot5, slot6)
						end

						if slot4:getContextByMediator(RivalInfoMediator) then
							table.insert(slot5, slot7)
						end

						_.each(slot5, function (slot0)
							slot0:sendNotification(GAME.REMOVE_LAYERS, {
								context = slot0
							})
						end)
					end

					if slot0.id then
						getProxy(ChapterProxy).StopAutoFight(slot5)

						return
					end

					if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN) and not slot6.autoActionForbidden and not slot6.achieved and slot6.data1 == 7 and slot2.id == 204 and slot2:isClear() then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							modal = true,
							hideNo = true,
							content = "有新的签到奖励可以领取，点击确定前往",
							onYes = function ()
								slot0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
							end,
							onNo = function ()
								slot0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY)
							end
						})

						return
					end

					slot1.OnExitChapter(slot7, slot2, slot1)
				elseif slot0 == ChapterConst.OpMove then
					seriesAsync({
						function (slot0)
							slot0.viewComponent.grid:moveFleet(slot1.path, slot1.fullpath, slot1.oldLine, slot0)
						end,
						function (slot0)
							if not slot0.teleportPaths then
								slot0()

								return
							end

							slot2 = slot0.teleportPaths[2]

							if not slot0.teleportPaths[1] or not slot2 then
								slot0()

								return
							end

							if not slot1:getFleet(FleetType.Normal, slot1.row, slot1.column) then
								slot0()

								return
							end

							slot3.line = Clone(slot0.teleportPaths[2])

							getProxy(ChapterProxy):updateChapter(slot1)
							slot2:getViewComponent().grid:TeleportCellByPortalWithCameraMove(slot3, slot2:getViewComponent().grid:GetCellFleet(slot3.id), slot0.teleportPaths, slot0)
						end,
						function (slot0)
							if slot0.aiActs then
								slot1:playAIActions(slot0.aiActs, slot0.extraFlag, slot0)
							else
								slot0()
							end
						end
					}, function ()
						if _.any(slot1.contextData.chapterVO:getFleetStgs(slot0.fleet), function (slot0)
							return slot0.id == ChapterConst.StrategyExchange and slot0.count > 0
						end) then
							slot1.viewComponent.levelStageView.popStageStrategy(slot1)
						end

						slot1.viewComponent.grid:updateFleets()
						slot1.viewComponent.grid.updateFleets.viewComponent.levelStageView:updateBombPanel()
						slot1.viewComponent.grid.updateFleets.viewComponent.levelStageView.updateBombPanel.viewComponent.levelStageView:tryAutoTrigger()
					end)
				elseif slot0 == ChapterConst.OpAmbush then
					slot1.viewComponent.levelStageView.tryAutoTrigger(slot4)
				elseif slot0 == ChapterConst.OpBox then
					if pg.box_data_template[slot2:getChapterCell(slot2.fleet.line.row, slot2.fleet.line.column).attachmentId].type == ChapterConst.BoxAirStrike then
						slot1.viewComponent:doPlayAirStrike(ChapterConst.SubjectChampion, false, slot2)
						coroutine.yield()

						if slot0.aiActs and #slot0.aiActs > 0 then
							slot1.viewComponent:doPlayCommander(slot8, slot2)
							coroutine.yield()
							slot1.viewComponent:easeAvoid(slot1.viewComponent.grid.cellFleets[slot2.fleets[slot2.findex].id].tf.position, slot2)
							coroutine.yield()
						end
					elseif slot6.type == ChapterConst.BoxTorpedo then
						if slot2.fleet:canClearTorpedo() then
							pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_destroy_torpedo"))
						else
							slot1.viewComponent:doPlayTorpedo(slot2)
							coroutine.yield()
						end
					elseif slot6.type == ChapterConst.BoxBanaiDamage then
						slot1.viewComponent:doPlayAirStrike(ChapterConst.SubjectChampion, false, slot2)
						coroutine.yield()
					elseif slot6.type == ChapterConst.BoxLavaDamage then
						slot1.viewComponent:doPlayAnim("AirStrikeLava", function (slot0)
							setActive(slot0, false)
							slot0()
						end)
						pg.CriMgr.GetInstance().PlaySE_V3(slot7, "ui-magma")
						coroutine.yield()
					end

					slot1.viewComponent.levelStageView:tryAutoTrigger()
				elseif slot0 == ChapterConst.OpStory then
					slot1.viewComponent.levelStageView:tryAutoTrigger()
				elseif slot0 == ChapterConst.OpSwitch then
					slot1.viewComponent.grid:adjustCameraFocus()
				elseif slot0 == ChapterConst.OpEnemyRound then
					slot1:playAIActions(slot0.aiActs, slot0.extraFlag, function ()
						slot0.viewComponent.levelStageView:updateBombPanel(true)

						if _.any(slot0.viewComponent.levelStageView:getFleetStgs(slot1.fleet), function (slot0)
							return slot0.id == ChapterConst.StrategyExchange and slot0.count > 0
						end) then
							slot0.viewComponent.levelStageView.updateStageStrategy(slot1)
							slot0.viewComponent.levelStageView:popStageStrategy()
						end

						slot0.viewComponent.levelStageView:tryAutoTrigger()
						slot0.viewComponent:updatePoisonAreaTip()
					end)
				elseif slot0 == ChapterConst.OpSubState then
					slot1.saveSubState(slot4, slot2.subAutoAttack)
					slot1.viewComponent.grid:OnChangeSubAutoAttack()
				elseif slot0 == ChapterConst.OpStrategy then
					if slot0.arg1 == ChapterConst.StrategyExchange then
						for slot9, slot10 in ipairs(slot5) do
							if slot10:GetType() == FleetSkill.TypeStrategy and slot10:GetArgs()[1] == ChapterConst.StrategyExchange then
								slot1.viewComponent:doPlayCommander(slot2.fleet:findCommanderBySkillId(slot10.id))

								break
							end
						end
					end
				elseif slot0 == ChapterConst.OpSupply then
					slot1.viewComponent.levelStageView:tryAutoTrigger()
				elseif slot0 == ChapterConst.OpBarrier then
					slot1.viewComponent.levelStageView:tryAutoTrigger()
				elseif slot0 == ChapterConst.OpSubTeleport then
					seriesAsync({
						function (slot0)
							slot1 = _.detect(slot0.fleets, function (slot0)
								return slot0.id == slot0.id
							end)
							slot1.line = {
								row = slot1.arg1,
								column = slot1.arg2
							}
							slot1.startPos = {
								row = slot1.arg1,
								column = slot1.arg2
							}
							slot5, slot6 = slot0.findPath(slot5, nil, slot3, slot4)
							slot9 = getProxy(PlayerProxy)
							slot10 = slot9:getData()

							slot10:consume({
								oil = math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #slot1:getShips(false) * slot5 - 1e-05)
							})
							slot2.viewComponent:updateRes(slot10)
							slot9:updatePlayer(slot10)

							slot2.viewComponent.grid.subTeleportMode = false

							slot2.viewComponent.grid:moveSub(table.indexof(slot0.fleets, slot1), slot1.fullpath, nil, function ()
								getProxy(ChapterProxy):updateChapter(bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition), )

								slot0 = getProxy(ChapterProxy).updateChapter.contextData.chapterVO

								getProxy(ChapterProxy)()
							end)
						end,
						function (slot0)
							if not slot0.teleportPaths then
								slot0()

								return
							end

							slot2 = slot0.teleportPaths[2]

							if not slot0.teleportPaths[1] or not slot2 then
								slot0()

								return
							end

							slot3 = _.detect(slot1.fleets, function (slot0)
								return slot0.id == slot0.id
							end)
							slot3.startPos = Clone(slot0.teleportPaths[2])
							slot3.line = Clone(slot0.teleportPaths[2])

							slot2:getViewComponent().grid:TeleportFleetByPortal(slot2.getViewComponent(slot4).grid:GetCellFleet(slot3.id), slot0.teleportPaths, function ()
								getProxy(ChapterProxy):updateChapter(bit.bor(ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampionPosition), )

								slot0 = getProxy(ChapterProxy).updateChapter.contextData.chapterVO

								getProxy(ChapterProxy)()
							end)
						end,
						function (slot0)
							slot0.viewComponent.grid:TurnOffSubTeleport()
							slot0.viewComponent.levelStageView:SwitchBottomStage(false)
							slot0.viewComponent.grid:updateQuadCells(ChapterConst.QuadStateNormal)
						end
					})
				end
			end)
			slot4 = slot7

			function ()
				if not slot0 then
					TryCall(slot1, function ()
						slot0 = true
					end)
				end
			end()

			return
		end

		if slot2 == ChapterProxy.CHAPTER_TIMESUP then
			slot0:onTimeUp()
		elseif slot2 == GAME.EVENT_LIST_UPDATE then
			slot0.viewComponent:addbubbleMsgBox(function (slot0)
				slot0:OnEventUpdate(slot0)
			end)
		elseif slot2 == GAME.VOTE_BOOK_BE_UPDATED_DONE then
			slot0.viewComponent.addbubbleMsgBox(slot4, function (slot0)
				slot0:NoticeVoteBook(slot0)
			end)
		elseif slot2 == DailyLevelProxy.ELITE_QUOTA_UPDATE then
			slot0.viewComponent.setEliteQuota(slot5, getProxy(DailyLevelProxy).eliteCount, pg.gameset.elite_quota.key_value)
		elseif slot2 == ActivityProxy.ACTIVITY_OPERATION_DONE then
			slot0.viewComponent:updateMapItems()
		elseif slot2 == ActivityProxy.ACTIVITY_UPDATED then
			if slot3 and slot3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_RANK then
				slot0.viewComponent:updatePtActivity(slot3)
			end
		elseif slot2 == GAME.SUB_CHAPTER_REFRESH_DONE then
			slot4 = slot3
			slot5 = nil
			slot6 = false
			slot8 = coroutine.wrap(function ()
				slot0 = getProxy(ChapterProxy)

				slot0.viewComponent:updateSubInfo(slot0.subRefreshCount, slot0.subProgress)
				slot0.viewComponent:PlaySubRefreshAnimation(slot1:getConfig("map"))
			end)
			slot5 = slot8

			function ()
				if not slot0 then
					TryCall(slot1, function ()
						slot0 = true
					end)
				end
			end()
		elseif slot2 == GAME.SUB_CHAPTER_FETCH_DONE then
			if slot0.contextData.chapterVO then
				slot0.viewComponent:switchToMap()
			else
				slot0.viewComponent:updateMap()
			end
		elseif slot2 == GAME.GET_REMASTER_TICKETS_DONE then
			slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3, function ()
				if getProxy(ChapterProxy).remasterDailyCount > 0 then
					SetActive(slot0.viewComponent.levelRemasterView.getRemasterTF, false)
					SetActive(slot0.viewComponent.levelRemasterView.gotRemasterTF, true)
					removeOnButton(slot0.viewComponent.levelRemasterView.getRemasterTF)
					setText(slot0.viewComponent.levelRemasterView.numsTxt, slot0.remasterTickets .. "/" .. pg.gameset.reactivity_ticket_max.key_value)
				end

				slot0.viewComponent:updateRemasterTicket()
			end)
		elseif slot2 == CommanderProxy.PREFAB_FLEET_UPDATE then
			slot0.viewComponent:setCommanderPrefabs(getProxy(CommanderProxy).getPrefabFleet(slot4))
			slot0.viewComponent:updateCommanderPrefab()
		elseif slot2 == GAME.COOMMANDER_EQUIP_TO_FLEET_DONE then
			slot0.viewComponent:updateFleet(getProxy(FleetProxy).getData(slot4))
			slot0.viewComponent:updateFleetSelect()
		elseif slot2 == GAME.SUBMIT_TASK_DONE then
			if slot0.contextData.map:isSkirmish() then
				slot0.viewComponent:updateMapItems()
			end

			slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3, function ()
				if slot0.contextData.map:isSkirmish() and slot0.contextData.TaskToSubmit then
					slot0.contextData.TaskToSubmit = nil

					slot0:sendNotification(GAME.SUBMIT_TASK, slot0.contextData.TaskToSubmit)
				end
			end)
		elseif slot2 == BagProxy.ITEM_UPDATED then
			slot0.viewComponent:setSpecialOperationTickets(getProxy(BagProxy).getItemsByType(slot4, Item.SPECIAL_OPERATION_TICKET))
		elseif slot2 == ChapterProxy.CHAPTER_AUTO_FIGHT_FLAG_UPDATED then
			if not slot0:getViewComponent().levelStageView then
				return
			end

			slot0:getViewComponent().levelStageView:ActionInvoke("UpdateAutoFightMark")
		elseif slot2 == ChapterProxy.CHAPTER_SKIP_PRECOMBAT_UPDATED then
			if not slot0:getViewComponent().levelStageView then
				return
			end

			slot0:getViewComponent().levelStageView:ActionInvoke("UpdateSkipPreCombatMark")
		end
	end
end

slot0.OnExitChapter = function (slot0, slot1, slot2)
	seriesAsync({
		function (slot0)
			if not slot0 then
				return slot0()
			end

			if slot1.id == 103 and not slot1:GetCommonFlag(BATTLE_AUTO_ENABLED) then
				slot2.viewComponent:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("battle_autobot_unlock"),
					onYes = slot0,
					onNo = slot0
				})
				slot2.viewComponent.HandleShowMsgBox.viewComponent:emit(LevelMediator2.NOTICE_AUTOBOT_ENABLED, {})

				return
			end

			slot0()
		end,
		function (slot0)
			if not slot0 then
				return slot0()
			end

			if getProxy(ChapterProxy):getMapById(slot1:getConfig("map")):isSkirmish() then
				slot2 = slot1.id

				if not _.detect(getProxy(SkirmishProxy).getRawData(slot3), function (slot0)
					return tonumber(slot0:getConfig("event")) == slot0
				end) then
					slot0()

					return
				end

				if getProxy(TaskProxy):getTaskVO(slot5:getConfig("task_id")) and slot8:getTaskStatus() == 1 then
					slot2:sendNotification(GAME.SUBMIT_TASK, slot7)

					if slot5 == slot4[#slot4] and slot6:getTaskVO(getProxy(ActivityProxy).getActivityById(slot9, slot10).getConfig(slot11, "config_data")[#getProxy(ActivityProxy).getActivityById(slot9, slot10).getConfig(slot11, "config_data")][2]) and slot14:getTaskStatus() < 2 then
						slot2.contextData.TaskToSubmit = slot13
					end
				end
			end

			slot0()
		end,
		function (slot0)
			if not slot0.contextData.chapterVO then
				return slot0()
			end

			slot0.viewComponent:switchToMap(slot0)
		end,
		function (slot0)
			slot3 = getProxy(ChapterProxy):GetExtendChapter(slot0.id) and slot2.AutoFightFlag

			slot1:RecordLastDefeatedEnemy(slot0.id, nil)
			slot1:SetChapterAutoFlag(slot0.id, false)
			slot1:RemoveExtendChapter(slot0.id)
			slot1.viewComponent:UpdateSwitchMapButton()

			if slot1.contextData.map and not slot1.contextData.map:isUnlock() then
				slot1.viewComponent:emit(slot2.ON_SWITCH_NORMAL_MAP)

				return
			end

			if slot3 == nil then
				return slot0()
			end

			slot4 = {}

			if slot2.TotalDrops then
				for slot8, slot9 in ipairs(slot2.TotalDrops) do
					slot4 = table.mergeArray(slot4, slot9)
				end
			end

			DropResultIntegration(slot4)
			slot1:addSubLayers(Context.New({
				viewComponent = LevelStageTotalRewardPanel,
				mediator = LevelStageTotalRewardPanelMediator,
				data = {
					chapter = slot0,
					onClose = slot0,
					rewards = slot4,
					events = slot2.ListEventNotify,
					guildTasks = slot2.ListGuildEventNotify,
					guildAutoReceives = slot2.ListGuildEventAutoReceiveNotify,
					fleets = Chapter.GetChapterLastFleetCache(slot0.id),
					isAutoFight = slot3
				}
			}), true)
		end,
		function (slot0)
			if Map.autoNextPage then
				Map.autoNextPage = nil

				triggerButton(slot0.viewComponent.btnNext)
			end
		end
	})
end

slot0.OnEventUpdate = function (slot0, slot1)
	slot0.viewComponent:updateEvent(slot2)

	slot3, slot4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "EventMediator")

	if slot3 and slot2.eventForMsg then
		slot5 = slot2.eventForMsg.id or 0

		if getProxy(ChapterProxy):getActiveChapter(true) and slot6:IsAutoFight() then
			getProxy(ChapterProxy):AddExtendChapterDataArray(slot6.id, "ListEventNotify", slot5)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = false,
				hideNo = true,
				content = i18n("event_special_update", (pg.collection_template[slot5] and pg.collection_template[slot5].title) or ""),
				weight = LayerWeightConst.SECOND_LAYER,
				onYes = function ()
					if slot0 then
						slot0()
					end
				end
			})
		end

		slot2.eventForMsg = nil
	elseif slot1 then
		slot1()
	end
end

slot0.onTimeUp = function (slot0)
	if getProxy(ChapterProxy):getActiveChapter() and not slot2:inWartime() then
		function slot3()
			slot0:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
		end

		if slot0.contextData.chapterVO then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot4, {
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = slot3,
				onNo = slot3
			})
		else
			slot3()
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_timeout"))
		end
	end
end

slot0.getDockCallbackFuncs = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = getProxy(BayProxy)
	slot6 = getProxy(ChapterProxy)

	function slot7(slot0, slot1)
		slot2, slot3 = ShipStatus.ShipStatusCheck("inElite", slot0, slot1, {
			inElite = slot0:getConfig("formation")
		})

		if not slot2 then
			return slot2, slot3
		end

		for slot7, slot8 in pairs(slot1) do
			if slot0:isSameKind(slot7) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	return slot7, function (slot0, slot1, slot2)
		slot1()
	end, function (slot0)
		slot1 = slot0:getEliteFleetList()[]

		if slot0.getEliteFleetList() then
			slot2 = table.indexof(slot1, slot2.id)

			if slot0[1] then
				slot1[slot2] = slot0[1]
			else
				table.remove(slot1, slot2)
			end
		else
			table.insert(slot1, slot0[1])
		end

		slot3:updateChapter(slot0)
		slot3:duplicateEliteFleet(slot0)
	end
end

slot0.playAIActions = function (slot0, slot1, slot2, slot3)
	if not slot0.viewComponent.grid then
		slot3()

		return
	end

	slot4 = getProxy(ChapterProxy)
	slot5 = nil
	slot6 = false
	slot8 = coroutine.wrap(function ()
		({})["viewComponent"]:frozen()

		slot1 = ()["viewComponent"] or 0

		for slot5, slot6 in ipairs(ipairs) do
			slot8, slot9 = slot6:applyTo(slot7, true)

			slot6:PlayAIAction(slot0.contextData.chapterVO, slot0, function ()
				slot0, slot1, slot2 = slot0:applyTo(slot0, false)

				if slot0 then
					slot2:updateChapter(slot1, slot1)

					slot3 = slot3(bit.bor, slot2 or 0)
				end

				onNextTick(slot4)
			end)
			coroutine.yield()

			if isa(slot6, FleetAIAction) and slot6.actType == ChapterConst.ActType_Poison and slot7:existFleet(FleetType.Normal, slot6.line.row, slot6.line.column) then
				table.insert(slot0, slot7:getFleetIndex(FleetType.Normal, slot6.line.row, slot6.line.column))
			end
		end

		slot2 = bit.band(slot1, ChapterConst.DirtyAutoAction)

		if bit.band(slot1, bit.bnot(ChapterConst.DirtyAutoAction)) ~= 0 then
			slot3:updateChapter(slot0.contextData.chapterVO, slot1)
		end

		seriesAsync({
			function (slot0)
				if slot0 ~= 0 then
					slot1.viewComponent.levelStageView:tryAutoAction(slot0)
				else
					slot0()
				end
			end,
			function (slot0)
				if #slot0 > 0 then
					slot1 = 0

					for slot5 = 1, #slot0, 1 do
						slot1.viewComponent.grid:showFleetPoisonDamage(slot0[slot5], function ()
							if slot0 + 1 >= #slot1 then
								slot2()
							end
						end)
					end

					return
				end

				slot0()
			end,
			function (slot0)
				slot0()
				slot0.viewComponent:unfrozen()
			end
		})
	end)
	slot5 = slot8

	function ()
		if not slot0 then
			TryCall(slot1, function ()
				slot0 = true

				slot1.viewComponent:unfrozen(-1)
				slot1.viewComponent:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest
				})
			end)
		end
	end()
end

slot0.saveSubState = function (slot0, slot1)
	PlayerPrefs.SetInt("chapter_submarine_ai_type_" .. slot2, slot1 + 1)
	PlayerPrefs.Save()
end

slot0.loadSubState = function (slot0, slot1)
	if PlayerPrefs.GetInt("chapter_submarine_ai_type_" .. getProxy(PlayerProxy):getRawData().id) - 1 >= 0 and slot3 ~= slot1 then
		slot0.viewComponent:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSubState,
			arg1 = slot3
		})
	end
end

slot0.PrepareSkipTimer = function (slot0, slot1, slot2)
	slot0:StopSkipTimer()

	slot0.skipTimer = Timer.New(slot1, slot2)

	slot0.skipTimer:Start()
end

slot0.StopSkipTimer = function (slot0)
	if not slot0.skipTimer then
		return
	end

	slot0.skipTimer:Stop()

	slot0.skipTimer = nil
end

slot0.onRemove = function (slot0)
	slot0:StopSkipTimer()
	slot0.super.onRemove(slot0)
end

return slot0

slot0 = class("LevelScene", import("..base.BaseUI"))
slot1 = require("Mgr/Pool/PoolUtil")
slot2 = import("view.level.MapBuilder.MapBuilder")
slot0.correspondingClass = {
	[slot2.TYPENORMAL] = "MapBuilderNormal",
	[slot2.TYPEESCORT] = "MapBuilderEscort",
	[slot2.TYPESHINANO] = "MapBuilderShinano",
	[slot2.TYPESKIRMISH] = "MapBuilderSkirmish"
}
slot3 = 0.5

slot0.getUIName = function (slot0)
	return "LevelMainScene"
end

slot0.getBGM = function (slot0)
	table.insert({}, checkExist(slot0.contextData.chapterVO, {
		"getConfig",
		{
			"bgm"
		}
	}) or "")
	table.insert(slot1, checkExist(slot0.contextData.map, {
		"getConfig",
		{
			"bgm"
		}
	}) or "")

	for slot5, slot6 in ipairs(slot1) do
		if slot6 ~= "" then
			return slot6
		end
	end

	return slot0.super.getBGM(slot0)
end

slot0.optionsPath = {
	"top/top_chapter/option"
}

slot0.preload = function (slot0, slot1)
	slot2 = getProxy(ChapterProxy)

	if slot0.contextData.mapIdx and slot0.contextData.chapterId then
		slot3 = slot2:getMapById(slot0.contextData.mapIdx)

		if slot2:getChapterById(slot0.contextData.chapterId).getConfig(slot4, "map") == slot0.contextData.mapIdx then
			slot0.contextData.chapterVO = slot4
		end
	end

	slot3, slot4 = slot0:GetInitializeMap()

	if slot0.contextData.entranceStatus == nil then
		slot0.contextData.entranceStatus = not slot4
	end

	if not slot0.contextData.entranceStatus then
		slot0.contextData.InitializeMap = slot3

		slot0:PreloadLevelMainUI(slot3, slot1)
	else
		slot1()
	end
end

slot0.GetInitializeMap = function (slot0)
	function slot1()
		if slot0.contextData.chapterVO and slot0.active then
			return slot0:getConfig("map")
		end

		if slot0.contextData.mapIdx then
			return slot0.contextData.mapIdx
		end

		slot1 = nil

		if slot0.contextData.targetChapter and slot0.contextData.targetMap then
			slot0.contextData.openChapterId = slot0.contextData.targetChapter
			slot1 = slot0.contextData.targetMap.id
			slot0.contextData.targetChapter = nil
			slot0.contextData.targetMap = nil
		elseif slot0.contextData.eliteDefault then
			slot1 = (getProxy(ChapterProxy):getUseableMaxEliteMap() and slot2.id) or nil
			slot0.contextData.eliteDefault = nil
		end

		return slot1
	end

	return slot1() or slot0:selectMap(), tobool(slot2)
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:initUI()
	slot0:initEvents()
	slot0:updateClouds()
end

slot0.initData = function (slot0)
	slot0.tweens = {}
	slot0.mapWidth = 1920
	slot0.mapHeight = 1440
	slot0.levelCamIndices = 1
	slot0.frozenCount = 0
	slot0.currentBG = nil
	slot0.mbDict = {}
	slot0.mapGroup = {}

	if not slot0.contextData.huntingRangeVisibility then
		slot0.contextData.huntingRangeVisibility = 2
	end
end

slot0.initUI = function (slot0)
	slot0.topPanel = slot0:findTF("top")
	slot0.canvasGroup = slot0.topPanel:GetComponent("CanvasGroup")
	slot0.canvasGroup.blocksRaycasts = not slot0.canvasGroup.blocksRaycasts
	slot0.canvasGroup.blocksRaycasts = not slot0.canvasGroup.blocksRaycasts
	slot0.entranceLayer = slot0:findTF("entrance")
	slot0.entranceBg = slot0:findTF("entrance_bg")
	slot0.topChapter = slot0:findTF("top_chapter", slot0.topPanel)

	setActive(slot0.topChapter:Find("title_chapter"), false)
	setActive(slot0.topChapter:Find("type_chapter"), false)
	setActive(slot0.topChapter:Find("type_escort"), false)
	setActive(slot0.topChapter:Find("type_skirmish"), false)

	slot0.chapterName = slot0:findTF("title_chapter/name", slot0.topChapter)
	slot0.chapterNoTitle = slot0:findTF("title_chapter/chapter", slot0.topChapter)
	slot0.resChapter = slot0:findTF("resources", slot0.topChapter)
	slot0.resPanel = PlayerResource.New()

	slot0.resPanel:setParent(slot0.resChapter, false)
	setActive(slot0.topChapter, true)

	slot0._voteBookBtn = slot0.topChapter:Find("vote_book")
	slot0.leftChapter = slot0:findTF("main/left_chapter")

	setActive(slot0.leftChapter, true)

	slot0.leftCanvasGroup = slot0.leftChapter:GetComponent(typeof(CanvasGroup))
	slot0.btnPrev = slot0:findTF("btn_prev", slot0.leftChapter)
	slot0.btnPrevCol = slot0:findTF("btn_prev/prev_image", slot0.leftChapter)
	slot0.eliteBtn = slot0:findTF("buttons/btn_elite", slot0.leftChapter)
	slot0.normalBtn = slot0:findTF("buttons/btn_normal", slot0.leftChapter)
	slot0.actNormalBtn = slot0:findTF("buttons/btn_act_normal", slot0.leftChapter)

	setActive(slot0.actNormalBtn, false)

	slot0.actEliteBtn = slot0:findTF("buttons/btn_act_elite", slot0.leftChapter)

	setActive(slot0.actEliteBtn, false)

	slot0.actExtraBtn = slot0:findTF("buttons/btn_act_extra", slot0.leftChapter)
	slot0.actExtraBtnAnim = slot0:findTF("usm", slot0.actExtraBtn)
	slot0.remasterBtn = slot0:findTF("buttons/btn_remaster", slot0.leftChapter)
	slot0.escortBar = slot0:findTF("escort_bar", slot0.leftChapter)

	setActive(slot0.escortBar, false)

	slot0.eliteQuota = slot0:findTF("elite_quota", slot0.leftChapter)

	setActive(slot0.eliteQuota, false)

	slot0.skirmishBar = slot0:findTF("left_times", slot0.leftChapter)
	slot0.mainLayer = slot0:findTF("main")

	setActive(slot0.mainLayer:Find("title_chapter_lines"), false)

	slot0.rightChapter = slot0:findTF("main/right_chapter")
	slot0.rightCanvasGroup = slot0.rightChapter:GetComponent(typeof(CanvasGroup))
	slot0.eventContainer = slot0:findTF("event_btns/event_container", slot0.rightChapter)
	slot0.btnSpecial = slot0:findTF("btn_task", slot0.eventContainer)
	slot0.challengeBtn = slot0:findTF("btn_challenge", slot0.eventContainer)
	slot0.dailyBtn = slot0:findTF("btn_daily", slot0.eventContainer)
	slot0.militaryExerciseBtn = slot0:findTF("btn_pvp", slot0.eventContainer)
	slot0.activityBtn = slot0:findTF("event_btns/activity_btn", slot0.rightChapter)
	slot0.ptTotal = slot0:findTF("event_btns/pt_text", slot0.rightChapter)
	slot0.ticketTxt = slot0:findTF("event_btns/tickets/Text", slot0.rightChapter)
	slot0.actExchangeShopBtn = slot0:findTF("event_btns/btn_exchange", slot0.rightChapter)
	slot0.signalBtn = slot0:findTF("btn_signal", slot0.rightChapter)

	setActive(slot0.signalBtn, false)

	slot0.btnNext = slot0:findTF("btn_next", slot0.rightChapter)
	slot0.btnNextCol = slot0:findTF("btn_next/next_image", slot0.rightChapter)
	slot0.countDown = slot0:findTF("event_btns/count_down", slot0.rightChapter)
	slot0.actExtraRank = slot0:findTF("event_btns/act_extra_rank", slot0.rightChapter)

	setActive(slot0.rightChapter, true)

	slot0.damageText = slot0:findTF("damage", slot0.topPanel)

	setActive(slot0.damageText, false)

	slot0.mapHelpBtn = slot0:findTF("help_button", slot0.topPanel)

	setActive(slot0.mapHelpBtn, false)

	slot0.avoidText = slot0:findTF("text_avoid", slot0.topPanel)
	slot0.commanderTinkle = slot0:findTF("neko_tinkle", slot0.topPanel)

	setActive(slot0.commanderTinkle, false)

	slot0.spResult = slot0:findTF("sp_result", slot0.topPanel)

	setActive(slot0.spResult, false)

	slot0.helpPage = slot0:findTF("help_page", slot0.topPanel)
	slot0.helpImage = slot0:findTF("icon", slot0.helpPage)
	slot0.helpBtn = slot0:findTF("help_button", slot0.bottomStage)

	setActive(slot0.helpPage, false)

	slot0.curtain = slot0:findTF("curtain", slot0.topPanel)

	setActive(slot0.curtain, false)

	slot0.map = slot0:findTF("maps")
	slot0.mapTFs = {
		slot0:findTF("maps/map1"),
		slot0:findTF("maps/map2")
	}

	for slot4, slot5 in ipairs(slot0.mapTFs) do
		slot5:GetComponent(typeof(Image)).enabled = false
	end

	slot1 = slot0.map:GetComponent(typeof(AspectRatioFitter))
	slot1.aspectRatio = 1
	slot1.aspectRatio = slot1.aspectRatio
	slot0.UIFXList = slot0:findTF("maps/UI_FX_list")

	for slot7 = 0, slot0.UIFXList:GetComponentsInChildren(typeof(Renderer)).Length - 1, 1 do
		slot3[slot7].sortingOrder = -1
	end

	slot0.levelCam = GameObject.Find("LevelCamera").transform.GetComponent(slot4, typeof(Camera))
	slot0.uiMain = GameObject.Find("LevelCamera").transform.Find(slot4, "Canvas/UIMain")

	setActive(slot0.uiMain, false)

	GetOrAddComponent(slot0.uiMain, typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	slot0.uiCam = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	slot0.levelGrid = slot0.uiMain:Find("LevelGrid")

	setActive(slot0.levelGrid, true)

	slot0.dragLayer = slot0.levelGrid:Find("DragLayer")

	setImageAlpha(slot0.dragLayer, 0.27450980392156865)

	slot0.float = slot0:findTF("float")
	slot0.clouds = slot0:findTF("clouds", slot0.float)

	setActive(slot0.clouds, true)
	setActive(slot0.float:Find("levels"), false)

	slot0.resources = slot0:findTF("resources"):GetComponent("ItemList")
	slot0.arrowTarget = slot0.resources.prefabItem[0]
	slot0.championTpl = slot0.resources.prefabItem[3]
	slot0.deadTpl = slot0.resources.prefabItem[4]
	slot0.enemyTpl = slot0.resources.prefabItem[5]
	slot0.oniTpl = slot0.resources.prefabItem[6]
	slot0.shipTpl = slot0.resources.prefabItem[8]
	slot0.subTpl = slot0.resources.prefabItem[9]
	slot0.transportTpl = slot0.resources.prefabItem[11]

	setText(slot0:findTF("fighting/Text", slot0.enemyTpl), i18n("ui_word_levelui2_inevent"))
	setAnchoredPosition(slot0.topChapter, {
		y = 0
	})
	setAnchoredPosition(slot0.leftChapter, {
		x = 0
	})
	setAnchoredPosition(slot0.rightChapter, {
		x = 0
	})

	slot0.bubbleMsgBoxes = {}
	slot0.loader = AutoLoader.New()
	slot0.levelFleetView = LevelFleetView.New(slot0.topPanel, slot0.event, slot0.contextData)
	slot0.levelInfoView = LevelInfoView.New(slot0.topPanel, slot0.event, slot0.contextData)

	slot0:buildCommanderPanel()
end

slot0.initEvents = function (slot0)
	slot0:bind(LevelUIConst.OPEN_COMMANDER_PANEL, function (slot0, slot1, slot2, slot3)
		slot0:openCommanderPanel(slot1, slot2, slot3)
	end)
	slot0.bind(slot0, LevelUIConst.TRACK_CHAPTER, function (slot0, slot1, slot2)
		slot0:trackChapter(slot1, slot2)
	end)
	slot0.bind(slot0, LevelUIConst.HANDLE_SHOW_MSG_BOX, function (slot0, slot1)
		slot0:HandleShowMsgBox(slot1)
	end)
	slot0.bind(slot0, LevelUIConst.DO_AMBUSH_WARNING, function (slot0, slot1)
		slot0:doAmbushWarning(slot1)
	end)
	slot0.bind(slot0, LevelUIConst.DISPLAY_AMBUSH_INFO, function (slot0, slot1)
		slot0:displayAmbushInfo(slot1)
	end)
	slot0.bind(slot0, LevelUIConst.DISPLAY_STRATEGY_INFO, function (slot0, slot1)
		slot0:displayStrategyInfo(slot1)
	end)
	slot0.bind(slot0, LevelUIConst.FROZEN, function (slot0)
		slot0:frozen()
	end)
	slot0.bind(slot0, LevelUIConst.UN_FROZEN, function (slot0)
		slot0:unfrozen()
	end)
	slot0.bind(slot0, LevelUIConst.DO_TRACKING, function (slot0, slot1)
		slot0:doTracking(slot1)
	end)
	slot0.bind(slot0, LevelUIConst.SWITCH_TO_MAP, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:switchToMap()
	end)
	slot0.bind(slot0, LevelUIConst.DISPLAY_REPAIR_WINDOW, function (slot0, slot1)
		slot0:displayRepairWindow(slot1)
	end)
	slot0.bind(slot0, LevelUIConst.DO_PLAY_ANIM, function (slot0, slot1)
		slot0:doPlayAnim(slot1.name, slot1.callback, slot1.onStart)
	end)
	slot0.bind(slot0, LevelUIConst.HIDE_FLEET_SELECT, function ()
		slot0:hideFleetSelect()
	end)
	slot0.bind(slot0, LevelUIConst.HIDE_FLEET_EDIT, function (slot0)
		slot0:hideFleetEdit()
	end)
end

slot0.addbubbleMsgBox = function (slot0, slot1, slot2)
	if #slot0.bubbleMsgBoxes > 0 then
		table.insert(slot0.bubbleMsgBoxes, slot1)
	else
		slot3 = nil

		table.insert(slot0.bubbleMsgBoxes, slot1)
		function ()
			if slot0.bubbleMsgBoxes[1] then
				slot0(function ()
					table.remove(slot0.bubbleMsgBoxes, 1)
					slot0.bubbleMsgBoxes()
				end)
			elseif slot2 then
				slot2()
			end
		end()
	end
end

slot0.updatePtActivity = function (slot0, slot1)
	slot0.ptActivity = slot1

	slot0:updateActivityRes()
end

slot0.updateActivityRes = function (slot0)
	slot2 = findTF(slot0.ptTotal, "icon/Image")

	if findTF(slot0.ptTotal, "Text") and slot2 and slot0.ptActivity then
		setText(slot1, "x" .. slot0.ptActivity.data1)
		GetImageSpriteFromAtlasAsync(pg.item_data_statistics[id2ItemId(tonumber(slot0.ptActivity:getConfig("config_id")))].icon, "", slot2, true)
	end
end

slot0.setCommanderPrefabs = function (slot0, slot1)
	slot0.commanderPrefabs = slot1
end

slot0.didEnter = function (slot0)
	slot0.openedCommanerSystem = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "CommandRoomMediator")

	onButton(slot0, slot0:findTF("back_button", slot0.topChapter), function ()
		if slot0:isfrozen() then
			return
		end

		if slot0.contextData.map and (slot0:isActivity() or slot0:isEscort()) then
			slot0:emit(LevelMediator2.ON_SWITCH_NORMAL_MAP)

			return
		elseif slot0 and slot0:isSkirmish() then
			slot0:emit(slot1.ON_BACK)
		elseif not slot0.contextData.entranceStatus then
			slot0:ShowEntranceUI(true)
		else
			slot0:emit(slot1.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0.btnSpecial, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	onButton(slot0, slot0.dailyBtn, function ()
		if slot0:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		DailyLevelProxy:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(slot0, slot0.challengeBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0, slot1 = slot0:checkChallengeOpen()

		if slot0 == false then
			pg.TipsMgr.GetInstance():ShowTips(slot1)
		else
			slot0:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.militaryExerciseBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(slot0, slot0.normalBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:setMap(slot0.contextData.map:getBindMapId())
	end, SFX_PANEL)
	onButton(slot0, slot0.eliteBtn, function ()
		if slot0:isfrozen() then
			return
		end

		if slot0.contextData.map:getBindMapId() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))

			if getProxy(ChapterProxy):getUseableMaxEliteMap() then
				slot0:setMap(slot1.configId)
				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_warp_to_latest_map"))
			end
		elseif slot0.contextData.map:isEliteEnabled() then
			slot0:setMap(slot0.contextData.map:getBindMapId())
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unsatisfied"))
		end
	end, SFX_UI_WEIGHANCHOR_HARD)
	onButton(slot0, slot0.remasterBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		SetActive(slot0.remasterBtn:Find("tip"), false)
		SetActive(slot0.entranceLayer:Find("btns/btn_remaster/tip"), false)
	end, SFX_PANEL)
	onButton(slot0, slot0.signalBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:displaySignalPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.entranceLayer:Find("enters/enter_main"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0:ShowSelectedMap(slot0:GetInitializeMap())
	end, SFX_PANEL)
	setText(slot0.entranceLayer.Find(slot2, "enters/enter_main/Text"), getProxy(ChapterProxy):getLastUnlockMap():getLastUnlockChapterName())
	onButton(slot0, slot0.entranceLayer:Find("enters/enter_world/enter"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0, slot1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "WorldMediator")

		if slot0 then
			slot0:emit(LevelMediator2.ENTER_WORLD)
		else
			pg.TipsMgr.GetInstance():ShowTips(slot1)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.entranceLayer:Find("enters/enter_ready/activity"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_PANEL)
	onButton(slot0, slot0.entranceLayer:Find("enters/right_panel/btn_signal"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0:displaySignalPanel()
	end, SFX_PANEL)
	setActive(slot0.entranceLayer.Find(slot2, "enters/right_panel/btn_signal"), checkExist(getProxy(ChapterProxy):getChapterById(304), {
		"isClear"
	}))
	onButton(slot0, slot0.entranceLayer:Find("btns/btn_remaster"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0:displayRemasterPanel()
		getProxy(ChapterProxy):setRemasterTip(false)
		SetActive(slot0.remasterBtn:Find("tip"), false)
		SetActive(slot0.entranceLayer:Find("btns/btn_remaster/tip"), false)
	end, SFX_PANEL)
	setActive(slot0.entranceLayer.Find(slot2, "btns/btn_remaster"), OPEN_REMASTER)
	onButton(slot0, slot0.entranceLayer:Find("btns/btn_challenge"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0, slot1 = slot0:checkChallengeOpen()

		if slot0 == false then
			pg.TipsMgr.GetInstance():ShowTips(slot1)
		else
			slot0:emit(LevelMediator2.CLICK_CHALLENGE_BTN)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.entranceLayer:Find("btns/btn_pvp"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_OPEN_MILITARYEXERCISE)
	end, SFX_PANEL)
	onButton(slot0, slot0.entranceLayer:Find("btns/btn_daily"), function ()
		if slot0:isfrozen() then
			return
		end

		DailyLevelProxy.dailyLevelId = nil

		DailyLevelProxy:emit(LevelMediator2.ON_DAILY_LEVEL)
	end, SFX_PANEL)
	onButton(slot0, slot0.entranceLayer:Find("btns/btn_task"), function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
	end, SFX_PANEL)
	setActive(slot0.entranceLayer.Find(slot2, "enters/enter_world/enter"), not WORLD_ENTER_LOCK)
	setActive(slot0.entranceLayer:Find("enters/enter_world/nothing"), WORLD_ENTER_LOCK)
	setActive(slot0.entranceLayer.Find(slot3, "enters/enter_ready/nothing"), #underscore.filter(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT), function (slot0)
		return not slot0:isEnd()
	end) == 0)
	setActive(slot0.entranceLayer:Find("enters/enter_ready/activity"), #(not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance().isOpenSystem(slot0.player.level, "CommandRoomMediator")) > 0)

	if #slot1 > 0 then
		table.sort(slot1, function (slot0, slot1)
			return slot1.id < slot0.id
		end)

		if slot1[1].getConfig(slot2, "config_client").entrance_bg then
			GetImageSpriteFromAtlasAsync(slot2, "", slot0.entranceLayer:Find("enters/enter_ready/activity"), true)
		end
	end

	setActive(slot0.btnSpecial:Find("lock"), not pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "EventMediator"))
	setActive(slot0.entranceLayer:Find("btns/btn_task/lock"), not pg.SystemOpenMgr.GetInstance().isOpenSystem(slot0.player.level, "EventMediator"))
	setActive(slot0.dailyBtn:Find("lock"), not pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "DailyLevelMediator"))
	setActive(slot0.entranceLayer:Find("btns/btn_daily/lock"), not pg.SystemOpenMgr.GetInstance().isOpenSystem(slot0.player.level, "DailyLevelMediator"))
	setActive(slot0.militaryExerciseBtn:Find("lock"), not pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "MilitaryExerciseMediator"))
	setActive(slot0.entranceLayer:Find("btns/btn_pvp/lock"), not pg.SystemOpenMgr.GetInstance().isOpenSystem(slot0.player.level, "MilitaryExerciseMediator"))
	setActive(slot0.challengeBtn:Find("lock"), not slot0:checkChallengeOpen())
	setActive(slot0.entranceLayer:Find("btns/btn_challenge/lock"), not slot0.checkChallengeOpen())
	setActive(slot0.challengeBtn, checkExist(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE), {
		"isEnd"
	}) == false)
	setActive(slot0.entranceLayer:Find("btns/btn_challenge"), checkExist(getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE), ) == false)
	slot0:initMapBtn(slot0.btnPrev, -1)
	slot0:initMapBtn(slot0.btnNext, 1)

	for slot12, slot13 in ipairs(getProxy(ContextProxy).getContextByMediator(slot7, LevelMediator2).children) do
		slot0.levelCamIndices = slot0.levelCamIndices + 1

		slot13.onRemoved = function ()
			slot0:onSubLayerClose()
		end
	end

	slot0.emit(slot0, LevelMediator2.ON_EVENT_LIST_UPDATE)

	if slot0.contextData.editEliteChapter then
		slot0:displayFleetEdit(slot0.contextData.editEliteChapter)

		slot0.contextData.editEliteChapter = nil
	elseif slot0.contextData.selectedChapterVO then
		slot0:displayFleetSelect(slot0.contextData.selectedChapterVO)

		slot0.contextData.selectedChapterVO = nil
	end

	if not slot0.contextData.isSwitchToChapter then
		slot0:tryPlaySubGuide()
	end

	if getProxy(ChapterProxy):ifShowRemasterTip() then
		SetActive(slot0.remasterBtn:Find("tip"), true)
		SetActive(slot0.entranceLayer:Find("btns/btn_remaster/tip"), true)
	else
		SetActive(slot0.remasterBtn:Find("tip"), false)
		SetActive(slot0.entranceLayer:Find("btns/btn_remaster/tip"), false)
	end

	if slot0.contextData.open_remaster then
		slot0:displayRemasterPanel(slot0.contextData.isSP)

		slot0.contextData.open_remaster = nil
	end
end

slot0.checkChallengeOpen = function (slot0)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "ChallengeMainMediator")
end

slot0.tryPlaySubGuide = function (slot0)
	if slot0.contextData.map and slot0.contextData.map:isSkirmish() then
		return
	end

	pg.SystemGuideMgr.GetInstance():Play(slot0)
end

slot0.onBackPressed = function (slot0)
	if slot0:isfrozen() then
		return
	end

	if slot0.levelAmbushView then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if slot0.levelInfoView:isShowing() then
		slot0:hideChapterPanel()

		return
	end

	if slot0.levelFleetView:isShowing() then
		slot0:hideFleetEdit()

		return
	end

	if slot0.levelSignalView then
		slot0:hideSignalPanel()

		return
	end

	if slot0.levelStrategyView then
		slot0:hideStrategyInfo()

		return
	end

	if slot0.levelRepairView then
		slot0:hideRepairWindow()

		return
	end

	if slot0.levelRemasterView then
		slot0:hideRemasterPanel()

		return
	end

	if isActive(slot0.helpPage) then
		setActive(slot0.helpPage, false)

		return
	end

	slot2 = getProxy(ChapterProxy):getActiveChapter()

	if slot0.contextData.chapterVO and slot2 then
		slot0:switchToMap()

		return
	end

	triggerButton(slot0:findTF("back_button", slot0.topChapter))
end

slot0.ShowEntranceUI = function (slot0, slot1)
	setActive(slot0.entranceLayer, slot1)
	setActive(slot0.entranceBg, slot1)
	setActive(slot0.map, not slot1)
	setActive(slot0.float, not slot1)
	setActive(slot0.mainLayer, not slot1)
	setActive(slot0.topChapter:Find("type_entrance"), slot1)

	slot0.contextData.entranceStatus = tobool(slot1)

	if slot1 then
		setActive(slot0.topChapter:Find("title_chapter"), false)
		setActive(slot0.topChapter:Find("type_chapter"), false)
		setActive(slot0.topChapter:Find("type_escort"), false)
		setActive(slot0.topChapter:Find("type_skirmish"), false)

		if slot0.newChapterCDTimer then
			slot0.newChapterCDTimer:Stop()

			slot0.newChapterCDTimer = nil
		end

		slot0:RecordLastMapOnExit()

		slot0.contextData.mapIdx = nil
		slot0.contextData.map = nil
	end

	slot0:PlayBGM()
end

slot0.PreloadLevelMainUI = function (slot0, slot1, slot2)
	if slot0.preloadLevelDone then
		if slot2 then
			slot2()
		end

		return
	end

	slot3 = 0
	slot5 = nil

	function slot5()
		if slot0 + 1 == slot1 and not slot2.exited then
			slot2.preloadLevelDone = true

			if slot3 then
				slot3()
			end
		end
	end

	GetSpriteFromAtlasAsync("chapter/pic/cellgrid", "cell_grid", slot5)

	slot6 = PoolMgr.GetInstance()

	slot6:GetPrefab("chapter/cell_quad", "", true, function (slot0)
		slot0:ReturnPrefab("chapter/cell_quad", "", slot0)
		slot0.ReturnPrefab()
	end)
	slot6.GetPrefab(slot6, "chapter/cell_quad_mark", "", true, function (slot0)
		slot0:ReturnPrefab("chapter/cell_quad_mark", "", slot0)
		slot0.ReturnPrefab()
	end)
	slot6.GetPrefab(slot6, "chapter/cell", "", true, function (slot0)
		slot0:ReturnPrefab("chapter/cell", "", slot0)
		slot0.ReturnPrefab()
	end)
	slot6.GetPrefab(slot6, "chapter/plane", "", true, function (slot0)
		slot0:ReturnPrefab("chapter/plane", "", slot0)
		slot0.ReturnPrefab()
	end)

	slot0.loadedTpls = {}
	slot4 = 0 + 5 + #{
		{
			"Tpl_Destination_Mark",
			"leveluiview",
			"destinationMarkTpl"
		}
	}

	for slot11, slot12 in pairs(slot7) do
		LoadAndInstantiateAsync(slot12[2], slot12[1], function (slot0)
			slot0:SetActive(false)

			slot0.name = slot0[3]
			slot0[3][slot0[3]] = slot0

			table.insert(slot1.loadedTpls, slot0)
			slot1.loadedTpls()
		end, true)
	end

	slot4 = slot4 + 1

	table.eachParallel(slot0:GetMapBG(slot8), function (slot0, slot1, slot2)
		GetSpriteFromAtlasAsync("levelmap/" .. slot1.BG, "", slot2)
	end, slot5)
end

slot0.selectMap = function (slot0)
	return slot0.contextData.mapIdx or ((not slot3 or not slot3:isUnlock() or Map.lastMap) and slot2:getLastUnlockMap().id)
end

slot0.setShips = function (slot0, slot1)
	slot0.shipVOs = slot1
end

slot0.updateRes = function (slot0, slot1)
	slot0.resPanel:setResources(slot1)

	if slot0.levelStageView then
		slot0.levelStageView:ActionInvoke("SetPlayer", slot1)
	end

	slot0.player = slot1
end

slot0.setEliteQuota = function (slot0, slot1, slot2)
	slot3 = slot2 - slot1
	slot5 = slot0:findTF("bg/Text", slot0.eliteQuota):GetComponent(typeof(Text))

	if slot1 == slot2 then
		slot5.color = Color.red
	else
		slot5.color = Color.New(0.47, 0.89, 0.27)
	end

	slot5.text = slot3 .. "/" .. slot2
end

slot0.updateSubInfo = function (slot0, slot1, slot2)
	slot0.subRefreshCount = slot1
	slot0.subProgress = slot2

	setText(slot0.signalBtn:Find("nums"), slot0.subRefreshCount)
	setText(slot0.entranceLayer:Find("enters/right_panel/btn_signal/nums"), slot0.subRefreshCount)

	if slot0.levelSignalView then
		slot0.levelSignalView:ActionInvoke("set", slot0.subRefreshCount, slot0.subProgress)
	end
end

slot0.updateLastFleet = function (slot0, slot1)
	slot0.lastFleetIndex = slot1
end

slot0.updateEvent = function (slot0, slot1)
	setActive(slot0.btnSpecial:Find("tip"), slot2)
	setActive(slot0.entranceLayer:Find("btns/btn_task/tip"), slot1:hasFinishState())
end

slot0.updateFleet = function (slot0, slot1)
	slot0.fleets = slot1
end

slot0.updateChapterVO = function (slot0, slot1, slot2)
	slot3 = slot1:getConfig("map")

	if not slot0.contextData.chapterVO then
		if slot0.contextData.mapIdx == slot3 and bit.band(slot2, ChapterConst.DirtyMapItems) > 0 then
			slot0:updateMapItems()
		end

		if slot0.levelSignalView then
			slot0.levelSignalView:ActionInvoke("flush")
		end
	end

	if slot0.contextData.chapterVO and slot0.contextData.chapterVO.id == slot1.id and slot1.active then
		slot0:setChapter(slot1)
	end

	if slot0.contextData.chapterVO and slot0.contextData.chapterVO.id == slot1.id and slot1.active and slot0.levelStageView and slot0.grid then
		slot4 = false
		slot5 = false
		slot6 = false

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyFleet) > 0 then
			slot0.levelStageView:updateStageFleet()
			slot0.levelStageView:updateAmbushRate(slot1.fleet.line, true)

			slot6 = true

			if slot0.grid then
				slot0.grid:RefreshFleetCells()

				slot4 = true
			end
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyChampion) > 0 then
			slot6 = true

			if slot0.grid then
				slot0.grid:updateFleets()
				slot0.grid:clearChampions()
				slot0.grid:initChampions()

				slot5 = true
			end
		elseif bit.band(slot2, ChapterConst.DirtyChampionPosition) > 0 then
			slot6 = true

			if slot0.grid then
				slot0.grid:updateFleets()
				slot0.grid:updateChampions()

				slot5 = true
			end
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyAchieve) > 0 then
			slot0.levelStageView:updateStageAchieve()
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyAttachment) > 0 then
			slot0.levelStageView:updateAmbushRate(slot1.fleet.line, true)

			if slot0.grid then
				if slot2 >= 0 and bit.band(slot2, ChapterConst.DirtyFleet) <= 0 then
					slot0.grid:updateFleet(slot1.fleets[slot1.findex].id)
				end

				slot0.grid:updateAttachments()

				if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyAutoAction) > 0 then
					slot0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
				else
					slot4 = true
				end
			end
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyStrategy) > 0 then
			slot0.levelStageView:updateStageStrategy()

			slot6 = true

			slot0.levelStageView:updateStageBarrier()
			slot0.levelStageView:UpdateAutoFightPanel()
		end

		if slot2 >= 0 then
			if bit.band(slot2, ChapterConst.DirtyAutoAction) > 0 then
			elseif slot4 then
				slot0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
			elseif slot5 then
				slot0.grid:updateQuadCells(ChapterConst.QuadStateFrozen)
			end
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyCellFlag) > 0 then
			slot0.grid:UpdateFloor()
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyBase) > 0 then
			slot0.levelStageView:UpdateDefenseStatus()
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyFloatItems) > 0 then
			slot0.grid:UpdateItemCells()
		end

		if slot2 < 0 or bit.band(slot2, ChapterConst.DirtyStrategyComboPanel) > 0 then
			slot0.levelStageView:UpdateDOALinkFeverPanel()
		end

		if slot6 then
			slot0.levelStageView:updateFleetBuff()
		end
	end
end

slot0.updateClouds = function (slot0)
	slot0.cloudRTFs = {}
	slot0.cloudRects = {}
	slot0.cloudTimer = {}

	for slot4 = 1, 6, 1 do
		table.insert(slot0.cloudRTFs, slot6)
		table.insert(slot0.cloudRects, rtf(slot5).rect.width)
	end

	slot0:initCloudsPos()

	for slot4, slot5 in ipairs(slot0.cloudRTFs) do
		slot10 = nil
		slot11 = LeanTween.moveX(slot5, slot0.mapWidth, slot9):setRepeat(-1):setOnCompleteOnRepeat(true):setOnComplete(System.Action(function ()
			slot3.anchoredPosition = Vector2(-slot1.cloudRects[slot2], slot4.y)

			slot5:setFrom(-slot1.cloudRects[slot2]):setTime((slot1.mapWidth + slot1.cloudRects[slot2]) / slot6)
		end))
		slot11.passed = math.random() * (slot0.mapWidth + slot0.cloudRects[slot4]) / (30 - slot0.initPositions[slot4] or Vector2(0, 0).y / 20)
		slot0.cloudTimer[slot4] = slot11.uniqueId
	end
end

slot0.updateCouldAnimator = function (slot0, slot1, slot2)
	if slot1 then
		slot3 = nil
		slot4 = slot0.mapTFs[slot2]

		function slot5()
			if slot0.transform.rect.width > 0 and slot0.transform.rect.height > 0 then
				slot0.x = slot0.transform.parent.rect.width / slot0.transform.rect.width
				slot0.y = slot0.transform.parent.rect.height / slot0.transform.rect.height
			end

			slot0.transform.localScale = slot0
		end

		slot6 = slot0.loader.GetPrefab(slot6, "ui/" .. slot1, slot1, function (slot0)
			slot0:SetActive(true)
			setParent(slot0, setParent)
			pg.ViewUtils.SetSortingOrder(slot0, (ChapterConst.LayerWeightMap + slot2 * 2) - 1)
			(ChapterConst.LayerWeightMap + slot2 * 2) - 1()
		end)

		table.insert(slot0.mapGroup, slot6)
	end
end

slot0.updateMapItems = function (slot0)
	if slot0.contextData.map:getConfig("cloud_suffix") == "" then
		setActive(slot0.clouds, false)
	else
		setActive(slot0.clouds, true)

		for slot6, slot7 in ipairs(slot1:getConfig("clouds_pos")) do
			slot0.cloudRTFs[slot6].GetComponent(slot8, typeof(Image)).enabled = false

			GetSpriteFromAtlasAsync("clouds/cloud_" .. slot6 .. "_" .. slot2, "", function (slot0)
				if not slot0.exited and not IsNil(IsNil) and slot2 == slot0.contextData.map then
					slot1.enabled = true
					slot1.sprite = slot0

					slot1:SetNativeSize()

					slot0.cloudRects[slot3] = slot4.rect.width
				end
			end)
		end
	end

	slot0.mapBuilder.buffer.UpdateMapItems(slot3, slot1)
end

slot0.updateDifficultyBtns = function (slot0)
	setActive(slot0.normalBtn, slot0.contextData.map.getConfig(slot1, "type") == Map.ELITE)
	setActive(slot0.eliteQuota, slot2 == Map.ELITE)
	setActive(slot0.eliteBtn, slot2 == Map.SCENARIO)
	setActive(slot0.eliteBtn:Find("pic_activity"), getProxy(ActivityProxy).getActivityById(setActive, ActivityConst.ELITE_AWARD_ACTIVITY_ID) and not slot0.eliteBtn:isEnd())
end

slot0.updateActivityBtns = function (slot0)
	slot1, slot2 = slot0.contextData.map:isActivity()
	slot3 = slot0.contextData.map:isRemaster()
	slot4 = slot0.contextData.map:isSkirmish()
	slot5 = slot0.contextData.map:isEscort()
	slot6 = slot0.contextData.map:getConfig("type")
	slot9 = getProxy(ActivityProxy):GetEarliestActByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT) and not slot8:isEnd()

	if slot9 and not slot1 and not slot4 and not slot5 then
		setImageSprite(slot0.activityBtn, (slot9 and LoadSprite("ui/mainui_atlas", "event_map_" .. slot8.id)) or LoadSprite("ui/mainui_atlas", "event_map"), true)
	end

	setActive(slot0.activityBtn, slot10)
	setActive(slot0.signalBtn, getProxy(ChapterProxy).getChapterById(slot11, 304):isClear() and (slot6 == Map.SCENARIO or slot6 == Map.ELITE))

	if slot1 and slot2 then
		setActive(slot0.actExtraBtn, underscore.any(slot13, function (slot0)
			return slot0:isActExtra()
		end) and not slot3 and slot6 ~= Map.ACT_EXTRA)

		if isActive(slot0.actExtraBtn) then
			if underscore.all(underscore.filter(slot13, function (slot0)
				return slot0:getMapType() == Map.ACTIVITY_EASY or slot1 == Map.ACTIVITY_HARD
			end), function (slot0)
				return slot0:isClear()
			end) then
				setActive(slot0.actExtraBtnAnim, true)
			else
				setActive(slot0.actExtraBtnAnim, false)
			end
		end

		setActive(slot0.actEliteBtn, checkExist(slot0.contextData.map.getBindMap(slot16), {
			"isHardMap"
		}) and slot6 ~= Map.ACTIVITY_HARD)
		setActive(slot0.actNormalBtn, slot6 ~= Map.ACTIVITY_EASY)
		setActive(slot0.actExtraRank, slot6 == Map.ACT_EXTRA)
		setActive(slot0.actExchangeShopBtn, not slot3 and slot2 and not ActivityConst.HIDE_PT_PANELS)
		setActive(slot0.ptTotal, not slot3 and slot2 and not ActivityConst.HIDE_PT_PANELS and slot0.ptActivity and not slot0.ptActivity:isEnd())
		slot0:updateActivityRes()
	else
		setActive(slot0.actExtraBtn, false)
		setActive(slot0.actEliteBtn, false)
		setActive(slot0.actNormalBtn, false)
		setActive(slot0.actExtraRank, false)
		setActive(slot0.actExchangeShopBtn, false)
		setActive(slot0.ptTotal, false)
	end

	setActive(slot0.eventContainer, (not slot1 or not slot2) and not slot5)
	setActive(slot0.remasterBtn, OPEN_REMASTER and (slot3 or (not slot1 and not slot5 and not slot4)))
	setActive(slot0.ticketTxt.parent, slot3)
	slot0:updateRemasterTicket()
	slot0:updateCountDown()
	slot0:registerActBtn()

	if slot1 and slot6 ~= Map.ACT_EXTRA then
		Map.lastMapForActivity = slot0.contextData.mapIdx
	end
end

slot0.updateRemasterTicket = function (slot0)
	setText(slot0.ticketTxt, getProxy(ChapterProxy).remasterTickets .. " / " .. pg.gameset.reactivity_ticket_max.key_value)
end

slot0.updateCountDown = function (slot0)
	slot1 = getProxy(ChapterProxy)

	if slot0.newChapterCDTimer then
		slot0.newChapterCDTimer:Stop()

		slot0.newChapterCDTimer = nil
	end

	slot2 = 0

	if slot0.contextData.map:isActivity() and not slot0.contextData.map:isRemaster() then
		_.each(slot3, function (slot0)
			slot0 = (slot0 == 0 and slot0:getChapterTimeLimit()) or math.min(slot0, slot0.getChapterTimeLimit())
		end)
		setActive(slot0.countDown, slot2 > 0)
		setText(slot0.countDown.Find(slot5, "title"), i18n("levelScene_new_chapter_coming"))
	else
		setActive(slot0.countDown, false)
	end

	if slot2 > 0 then
		setText(slot0.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(slot2))

		slot0.newChapterCDTimer = Timer.New(function ()
			if slot0 - 1 <= 0 then
				slot1:updateCountDown()

				if not slot1.contextData.chapterVO then
					slot1:setMap(slot1.contextData.mapIdx)
				end
			else
				setText(slot1.countDown:Find("time"), pg.TimeMgr.GetInstance():DescCDTime(setText))
			end
		end, 1, -1)

		slot0.newChapterCDTimer.Start(slot3)
	else
		setText(slot0.countDown:Find("time"), "")
	end
end

slot0.registerActBtn = function (slot0)
	if slot0.isRegisterBtn then
		return
	end

	slot0.isRegisterBtn = true

	onButton(slot0, slot0.actExtraRank, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_EXTRA_RANK)
	end, SFX_PANEL)
	onButton(slot0, slot0.activityBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.ON_ACTIVITY_MAP)
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.actExchangeShopBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot0:emit(LevelMediator2.GO_ACT_SHOP)
	end, SFX_UI_CLICK)

	slot1 = getProxy(ChapterProxy)

	function slot2(slot0, slot1, slot2)
		slot3 = nil
		slot4 = _.select((not slot0:isRemaster() or slot0:getRemasterMaps(slot0.remasterId)) and slot0:getMapsByActivities(), function (slot0)
			return slot0:getMapType() == slot0
		end)

		table.sort((not slot0.isRemaster() or slot0.getRemasterMaps(slot0.remasterId)) and slot0.getMapsByActivities(), function (slot0, slot1)
			return slot0.id < slot1.id
		end)

		slot4 = table.indexof(underscore.map(slot3, function (slot0)
			return slot0.id
		end), slot2) or #((not slot0.isRemaster() or slot0.getRemasterMaps(slot0.remasterId)) and slot0.getMapsByActivities())

		while not slot3[slot4]:isUnlock() do
			if slot4 > 1 then
				slot4 = slot4 - 1
			else
				break
			end
		end

		return slot3[slot4]
	end

	onButton(slot0, slot0.actEliteBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot2, slot3 = slot0.contextData.map(slot0.contextData.map, Map.ACTIVITY_HARD, slot0.contextData.map:getBindMapId()).isUnlock(slot1)

		if slot2 then
			slot0:setMap(slot1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(slot3)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.actNormalBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot2, slot3 = slot0.contextData.map(slot0.contextData.map, Map.ACTIVITY_EASY, slot0.contextData.map:getBindMapId()).isUnlock(slot1)

		if slot2 then
			slot0:setMap(slot1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(slot3)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.actExtraBtn, function ()
		if slot0:isfrozen() then
			return
		end

		slot2, slot3 = slot1((PlayerPrefs.HasKey("ex_mapId") and PlayerPrefs.GetInt("ex_mapId")) or 0.contextData.map, Map.ACT_EXTRA, (PlayerPrefs.HasKey("ex_mapId") and PlayerPrefs.GetInt("ex_mapId")) or 0).isUnlock(slot1)

		if slot2 then
			slot0:setMap(slot1.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(slot3)
		end
	end, SFX_PANEL)
end

slot0.initCloudsPos = function (slot0, slot1)
	slot0.initPositions = {}
	slot3 = pg.expedition_data_by_map[slot1 or 1].clouds_pos

	for slot7, slot8 in ipairs(slot0.cloudRTFs) do
		if slot3[slot7] then
			slot8.anchoredPosition = Vector2(slot9[1], slot9[2])

			table.insert(slot0.initPositions, slot8.anchoredPosition)
		else
			setActive(slot8, false)
		end
	end
end

slot0.initMapBtn = function (slot0, slot1, slot2)
	onButton(slot0, slot1, function ()
		if slot0:isfrozen() then
			return
		end

		if getProxy(ChapterProxy):getMapById(slot0.contextData.mapIdx + slot1) then
			if slot1:getMapType() == Map.ELITE and not slot1:isEliteEnabled() then
				slot0 = slot1:getBindMap().id

				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
			end

			slot3, slot4 = slot1:isUnlock()

			if not slot3 then
				pg.TipsMgr.GetInstance():ShowTips(slot4)

				return
			end

			slot0:setMap(slot0)
		end
	end, SFX_PANEL)
end

slot0.ShowSelectedMap = function (slot0, slot1, slot2)
	seriesAsync({
		function (slot0)
			if slot0.contextData.entranceStatus then
				slot0:frozen()

				slot0.nextPreloadMap = slot0

				slot0:PreloadLevelMainUI(slot0.PreloadLevelMainUI, function ()
					slot0:unfrozen()

					if slot0.unfrozen.nextPreloadMap ~= slot0 then
						return
					end

					slot0:emit(LevelMediator2.ON_ENTER_MAINLEVEL, slot0)
					slot0.emit:ShowEntranceUI(false)
					false()
				end)
			else
				slot0.setMap(slot1, slot0.setMap)
				slot0()
			end
		end,
		function (slot0)
			if slot0 then
				slot0()
			end
		end
	})
end

slot0.setMap = function (slot0, slot1)
	slot0.lastMapIdx = slot0.contextData.mapIdx
	slot0.contextData.mapIdx = slot1
	slot0.contextData.map = getProxy(ChapterProxy):getMapById(slot1)

	if slot0.contextData.map:getMapType() == Map.ACT_EXTRA then
		PlayerPrefs.SetInt("ex_mapId", slot0.contextData.map.id)
		PlayerPrefs.Save()
	elseif slot0.contextData.map:isRemaster() then
		PlayerPrefs.SetInt("remaster_lastmap_" .. slot0.contextData.map.remasterId, slot1)
		PlayerPrefs.Save()
	end

	slot0:updateMap()
	slot0:tryPlayMapStory()
end

slot0.SwitchMapBuilder = function (slot0, slot1, slot2)
	slot3 = slot0:GetMapBuilderInBuffer(slot1)

	if not slot0.mapBuilder then
		slot0.mapBuilder = slot0.mbDict[slot1]
	end

	slot3.buffer:DoFunction(function ()
		if slot0.mapBuilder and slot0.mapBuilder:GetType() ~= slot0.mapBuilder then
			slot0.mapBuilder.buffer:Hide()
		end

		slot0.mapBuilder = slot0.mbDict[]

		slot2:Show()
		slot3(slot0.mbDict)
	end)
end

slot0.GetMapBuilderInBuffer = function (slot0, slot1)
	if not slot0.mbDict[slot1] then
		slot0.mbDict[slot1] = import("view.level.MapBuilder." .. slot0.correspondingClass[slot1]).New(slot0._tf, slot0)

		slot0.mbDict[slot1]:Load()
	end

	return slot0.mbDict[slot1]
end

slot0.JudgeMapBuilderType = function (slot0)
	slot2 = nil

	if slot0.contextData.map.getConfig(slot1, "ui_type") == slot0.TYPESHINANO then
		slot2 = slot0.TYPESHINANO
	elseif slot1:isNormalMap() then
		slot2 = slot0.TYPENORMAL
	elseif slot1:isSkirmish() then
		slot2 = slot0.TYPESKIRMISH
	elseif slot1:isEscort() then
		slot2 = slot0.TYPEESCORT
	end

	return slot2
end

slot0.updateMap = function (slot0)
	slot1 = slot0.contextData.map
	slot2 = slot0.contextData.chapterVO

	seriesAsync({
		function (slot0)
			slot0:SwitchMapBG(slot0.SwitchMapBG, slot0.lastMapIdx)

			slot0.lastMapIdx = nil
			slot1 = slot0:getConfig("uifx")

			for slot5 = 1, slot0.UIFXList.childCount, 1 do
				setActive(slot0.UIFXList:GetChild(slot5 - 1), slot0.UIFXList:GetChild(slot5 - 1).name == slot1)
			end

			slot0:PlayBGM()
			slot0:SwitchMapBuilder(slot0:JudgeMapBuilderType(), slot0)
		end,
		function (slot0)
			slot0.mapBuilder:Update(slot1)
			slot0:UpdateSwitchMapButton()
			slot0:updateMapItems()
			slot0.mapBuilder:UpdateButtons()
			slot0.mapBuilder:PostUpdateMap(getProxy(ChapterProxy))

			if slot0.contextData.openChapterId then
				slot0.mapBuilder.buffer:TryOpenChapter(slot0.contextData.openChapterId)

				slot0.contextData.openChapterId = nil
			end

			slot0()
		end
	})
end

slot0.UpdateSwitchMapButton = function (slot0)
	setActive(slot0.btnPrev, slot3)
	setActive(slot0.btnNext, slot4)
	setImageColor(slot0.btnPrevCol, (getProxy(ChapterProxy):getMapById(slot0.contextData.map.id - 1) and slot3:isUnlock() and Color.white) or Color.New(0.5, 0.5, 0.5, 1))
	setImageColor(slot0.btnNextCol, (slot4 and slot4:isUnlock() and Color.white) or Color.New(0.5, 0.5, 0.5, 1))
end

slot0.TrySwitchChapter = function (slot0, slot1)
	if getProxy(ChapterProxy):getActiveChapter() then
		if slot3.id == slot1.id then
			slot0:switchToChapter(slot3)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_strategying", slot3:getConfig("chapter_name")))
		end
	else
		slot0:displayChapterPanel(slot1)
	end
end

slot0.updateChapterTF = function (slot0, slot1)
	if not slot0.mapBuilder.UpdateChapterTF then
		return
	end

	slot0.mapBuilder:UpdateChapterTF(slot1)
end

slot0.tryPlayMapStory = function (slot0)
	if Application.isEditor and not ENABLE_GUIDE then
		return
	end

	seriesAsync({
		function (slot0)
			if slot0.contextData.map:getConfig("enter_story") and slot1 ~= "" and not pg.SystemOpenMgr.GetInstance().active then
				pg.NewStoryMgr.GetInstance():Play(slot1, function (slot0)
					slot0(not slot0)
				end)

				return
			end

			slot0()
		end,
		function (slot0, slot1)
			if not slot1 then
				return slot0()
			end

			if slot0.contextData.map:getConfig("guide_id") and slot2 ~= "" then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(slot2, nil, slot0)

				return
			end

			slot0()
		end,
		function (slot0)
			if slot0.exited then
				return
			end

			pg.SystemOpenMgr.GetInstance():notification(slot0.player.level)

			if pg.SystemOpenMgr.GetInstance().active then
				getProxy(ChapterProxy):StopAutoFight()
			end
		end
	})
end

slot0.displaySignalPanel = function (slot0)
	slot0.levelSignalView = LevelSignalView.New(slot0.topPanel, slot0.event, slot0.contextData)

	slot0.levelSignalView:Load()
	slot0.levelSignalView:ActionInvoke("set", slot0.subRefreshCount, slot0.subProgress)
	slot0.levelSignalView.ActionInvoke(slot4, "setCBFunc", function (slot0)
		slot0:emit(LevelMediator2.ON_REFRESH_SUB_CHAPTER, slot0)
	end, function (slot0)
		slot0:hideSignalPanel()

		if slot0.active then
			if slot0.contextData.entranceStatus then
				slot0:ShowSelectedMap(slot0:getConfig("map"), function ()
					slot0:switchToChapter(slot0)
				end)
			else
				slot0.switchToChapter(slot1, slot0)
			end
		elseif slot0.contextData.mapIdx ~= slot0:getConfig("map") then
			slot0:ShowSelectedMap(slot0:getConfig("map"))
		end
	end, function ()
		slot0:hideSignalPanel()
	end)
end

slot0.hideSignalPanel = function (slot0)
	if slot0.levelSignalView then
		slot0.levelSignalView:Destroy()

		slot0.levelSignalView = nil
	end
end

slot0.DisplaySPAnim = function (slot0, slot1, slot2, slot3)
	slot0.uiAnims = slot0.uiAnims or {}

	function slot5()
		slot0.playing = true

		slot0:frozen()
		slot0:SetActive(true)
		pg.UIMgr.GetInstance():OverlayPanel(tf(slot0), false, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if pg.UIMgr.GetInstance() then
			slot2(slot2)
		end

		slot0:GetComponent("DftAniEvent").SetEndEvent(slot1, function (slot0)
			slot0.playing = false

			if slot0 then
				slot1(slot2)
			end

			slot0:unfrozen()
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WARNING)
	end

	if not slot0.uiAnims[slot1] then
		PoolMgr.GetInstance().GetUI(slot6, slot1, true, function (slot0)
			slot0:SetActive(true)

			slot0.uiAnims[] = slot0
			slot2 = slot0.uiAnims[]

			true()
		end)
	else
		slot5()
	end
end

slot0.displaySpResult = function (slot0, slot1, slot2)
	setActive(slot0.spResult, true)
	slot0:DisplaySPAnim((slot1 == 1 and "SpUnitWin") or "SpUnitLose", function (slot0)
		onButton(slot0, slot0, function ()
			removeOnButton(removeOnButton)
			setActive(setActive, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(pg.UIMgr.GetInstance().UnOverlayPanel, slot1._tf)
			pg.UIMgr.GetInstance():hideSpResult()
			pg.UIMgr.GetInstance().UnOverlayPanel()
		end, SFX_PANEL)
	end)
end

slot0.hideSpResult = function (slot0)
	setActive(slot0.spResult, false)
end

slot0.displayBombResult = function (slot0, slot1)
	setActive(slot0.spResult, true)
	slot0:DisplaySPAnim("SpBombRet", function (slot0)
		onButton(slot0, slot0, function ()
			removeOnButton(removeOnButton)
			setActive(setActive, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(pg.UIMgr.GetInstance().UnOverlayPanel, slot1._tf)
			pg.UIMgr.GetInstance():hideSpResult()
			pg.UIMgr.GetInstance().UnOverlayPanel()
		end, SFX_PANEL)
	end, function (slot0)
		setText(slot0.transform:Find("right/name_bg/en"), slot0.contextData.chapterVO.modelCount)
	end)
end

slot0.displayChapterPanel = function (slot0, slot1, slot2)
	function slot3(slot0)
		if slot0.player:getMaxShipBag() <= getProxy(BayProxy).getShipCount(slot1) then
			NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)

			return
		end

		slot0:hideChapterPanel()

		slot3 = slot1:clone()
		slot3.loopFlag = slot0

		if slot3:getConfig("type") == Chapter.CustomFleet then
			slot0:displayFleetEdit(slot3)
		elseif #slot3:getNpcShipByType(1) > 0 then
			if slot1:isValid() then
				slot0:trackChapter(slot1, function ()
					slot0:emit(LevelMediator2.ON_TRACKING, slot1.id, {}, slot1.loopFlag)
				end)
			end

			return
		else
			slot0.displayFleetSelect(slot6, slot3)
		end
	end

	function slot4()
		slot0:hideChapterPanel()
	end

	if getProxy(ChapterProxy).getMapById(slot5, slot1:getConfig("map")):isSkirmish() and #slot1:getNpcShipByType(1) > 0 then
		slot3(false)

		return
	end

	slot0.levelInfoView:Load()
	slot0.levelInfoView:ActionInvoke("set", slot1, slot2)
	slot0.levelInfoView:ActionInvoke("setCBFunc", slot3, slot4)
	slot0.levelInfoView:ActionInvoke("Show")
end

slot0.hideChapterPanel = function (slot0)
	if slot0.levelInfoView:isShowing() then
		slot0.levelInfoView:ActionInvoke("Hide")
	end
end

slot0.destroyChapterPanel = function (slot0)
	slot0.levelInfoView:Destroy()

	slot0.levelInfoView = nil
end

slot0.displayFleetSelect = function (slot0, slot1)
	slot0.levelFleetView:updateSpecialOperationTickets(slot0.spTickets)
	slot0.levelFleetView:Load()
	slot0.levelFleetView:ActionInvoke("setOpenCommanderTag", slot0.openedCommanerSystem)
	slot0.levelFleetView:ActionInvoke("set", slot1, slot0.fleets, slot0.contextData.selectedFleetIDs or slot1:selectFleets(slot0.lastFleetIndex, slot0.fleets))
	slot0.levelFleetView:ActionInvoke("Show")
end

slot0.updateFleetSelect = function (slot0)
	if slot0.levelFleetView:isShowing() then
		slot0.levelFleetView:ActionInvoke("set", slot0.levelFleetView.chapter, slot0.fleets, slot0.levelFleetView:getSelectIds())

		if slot0.levelCMDFormationView:isShowing() and slot0.fleets[slot0.levelCMDFormationView.fleet.id] then
			slot0.levelCMDFormationView:ActionInvoke("updateFleet", slot2)
		end
	end
end

slot0.hideFleetSelect = function (slot0)
	if slot0.levelCMDFormationView:isShowing() then
		slot0.levelCMDFormationView:Hide()
	end

	if slot0.levelFleetView then
		slot0.levelFleetView:Hide()
	end
end

slot0.buildCommanderPanel = function (slot0)
	slot0.levelCMDFormationView = LevelCMDFormationView.New(slot0.topPanel, slot0.event, slot0.contextData)
end

slot0.destroyFleetSelect = function (slot0)
	if not slot0.levelFleetView then
		return
	end

	slot0.levelFleetView:Destroy()

	slot0.levelFleetView = nil
end

slot0.displayFleetEdit = function (slot0, slot1)
	slot0.levelFleetView:updateSpecialOperationTickets(slot0.spTickets)
	slot0.levelFleetView:Load()
	slot0.levelFleetView:ActionInvoke("setOpenCommanderTag", slot0.openedCommanerSystem)
	slot0.levelFleetView:ActionInvoke("setHardShipVOs", slot0.shipVOs)
	slot0.levelFleetView:ActionInvoke("setOnHard", slot1)
	slot0.levelFleetView:ActionInvoke("Show")
end

slot0.updateFleetEdit = function (slot0, slot1, slot2)
	if slot0.levelFleetView then
		slot3 = slot0.contextData.map

		if slot1 and slot0.levelFleetView.chapter.id == slot1.id then
			slot0.levelFleetView:ActionInvoke("setOnHard", slot1)
		end

		if slot1 and slot0.levelCMDFormationView:isShowing() then
			slot0.levelCMDFormationView:ActionInvoke("updateFleet", slot1:wrapEliteFleet(slot2))
		end
	end
end

slot0.hideFleetEdit = function (slot0)
	slot0:hideFleetSelect()
end

slot0.destroyFleetEdit = function (slot0)
	slot0:destroyFleetSelect()
end

slot0.isCrossStoryLimit = function (slot0, slot1)
	slot2 = true

	if slot1 ~= "" and #slot1 > 0 then
		slot3 = _.all(slot1, function (slot0)
			if slot0[1] == 1 then
				return getProxy(TaskProxy):getTaskById(slot0[2]) and not slot2:isFinish()
			end

			return false
		end)
		slot2 = slot3
	end

	return slot2
end

slot0.trackChapter = function (slot0, slot1, slot2)
	slot3 = nil
	slot4 = coroutine.wrap(function ()
		slot1 = getProxy(ChapterProxy)

		if slot0.contextData.map:isRemaster() then
			if PlayerPrefs.GetString("remaster_tip") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d") then
				slot0:HandleShowMsgBox({
					showStopRemind = true,
					content = i18n("levelScene_activate_remaster"),
					onYes = function ()
						if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
							PlayerPrefs.SetString("remaster_tip", pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d"))
						end

						onNextTick(onNextTick)
					end
				})
				coroutine.yield()
			end

			if slot1.remasterTickets <= 0 then
				pg.TipsMgr.GetInstance().ShowTips(slot2, i18n("levelScene_remaster_tickets_not_enough"))

				return
			end
		end

		if slot0:isActivity() and not slot0:isRemaster() and not slot2:inActTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_lock_1"))

			return
		end

		slot3 = slot2:getConfig("enter_story_limit")

		if slot2:getConfig("enter_story") and slot2 ~= "" and slot0:isCrossStoryLimit(slot3) then
			ChapterOpCommand.PlayChapterStory(slot2, function ()
				onNextTick(onNextTick)
			end, slot2.isLoop(slot7) and PlayerPrefs.GetInt("chapter_autofight_flag_" .. slot2.id, 1) == 1)
			coroutine.yield()
		end

		if slot3 then
			slot3()
		end
	end)

	slot4()
end

slot0.setChapter = function (slot0, slot1)
	slot2 = nil

	if slot1 then
		slot2 = slot1.id
	end

	slot0.contextData.chapterId = slot2
	slot0.contextData.chapterVO = slot1
end

slot0.switchToChapter = function (slot0, slot1, slot2)
	if slot0.contextData.mapIdx ~= slot1:getConfig("map") then
		slot0:setMap(slot1:getConfig("map"))
	end

	slot0:setChapter(slot1)
	setActive(slot0.clouds, false)
	slot0.mapBuilder.buffer:Hide()

	slot0.leftCanvasGroup.blocksRaycasts = false
	slot0.rightCanvasGroup.blocksRaycasts = false

	slot0:DestroyLevelStageView()

	if not slot0.levelStageView then
		slot0.levelStageView = LevelStageView.New(slot0.topPanel, slot0.event, slot0.contextData)

		slot0.levelStageView:Load()

		slot0.levelStageView.isFrozen = slot0:isfrozen()
	end

	slot0:frozen()
	slot0.levelStageView.ActionInvoke(slot4, "SetSeriesOperation", slot3)
	slot0.levelStageView:ActionInvoke("SetPlayer", slot0.player)
	slot0.levelStageView:ActionInvoke("SwitchToChapter", slot1)
end

slot0.switchToMap = function (slot0, slot1)
	slot4 = slot0.contextData.chapterVO and getProxy(ChapterProxy):getMapById(slot2:getConfig("map"))

	if slot3.subNextReqTime < pg.TimeMgr.GetInstance():GetServerTime() then
		slot0:emit(LevelMediator2.ON_FETCH_SUB_CHAPTER)

		return
	end

	slot0:frozen()
	slot0:destroyGrid()
	slot0:RecordTween("mapScale", LeanTween.value(go(slot0.map), slot0.map.localScale, Vector3.one, slot0):setOnUpdateVector3(function (slot0)
		slot0.map.localScale = slot0
		slot0.float.localScale = slot0
	end).setOnComplete(slot5, System.Action(function ()
		slot0.mapBuilder.buffer:Show()
		slot0.mapBuilder.buffer.Show:updateMapItems()
		slot0.mapBuilder.buffer.Show.updateMapItems:unfrozen()

		if slot0.mapBuilder.buffer.Show.updateMapItems then
			slot1()
		end
	end)).setEase(slot5, LeanTweenType.easeOutSine).uniqueId)

	slot7 = LeanTween.value(go(slot0.map), slot0.map.pivot, slot0.lastRecordPivot or Vector2.zero, slot0)

	slot7:setOnUpdateVector2(function (slot0)
		slot0.map.pivot = slot0
		slot0.float.pivot = slot0
	end).setEase(slot8, LeanTweenType.easeOutSine)
	slot0:RecordTween("mapPivot", slot7.uniqueId)
	setActive(slot0.topChapter, true)
	setActive(slot0.leftChapter, true)
	setActive(slot0.rightChapter, true)
	shiftPanel(slot0.leftChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(slot0.rightChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(slot0.topChapter, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)

	if slot0.levelStageView then
		slot0.levelStageView:ActionInvoke("ShiftStagePanelOut", function ()
			slot0:DestroyLevelStageView()
		end)
		slot0.levelStageView.ActionInvoke(slot8, "SwitchToMap")
	end

	slot0:SwitchMapBG(slot0.contextData.map)
	slot0:setChapter(nil)
	slot0:PlayBGM()
	pg.UIMgr.GetInstance():UnblurPanel(slot0.topPanel, slot0._tf)

	slot0.canvasGroup.blocksRaycasts = slot0.frozenCount == 0

	if slot0.ambushWarning and slot0.ambushWarning.activeSelf then
		slot0.ambushWarning:SetActive(false)
		slot0:unfrozen()
	end

	slot0.mapBuilder:UpdateButtons()
end

slot0.SwitchBG = function (slot0, slot1, slot2)
	if not slot1 or #slot1 <= 0 then
		if slot2 then
			slot2()
		end
	elseif table.equal(slot0.currentBG, slot1) then
		return
	end

	slot0.currentBG = slot1
	slot3 = {}

	table.eachParallel(slot1, function (slot0, slot1, slot2)
		slot3 = slot0.mapTFs[slot0]

		table.insert(slot0.mapGroup, slot4)
		slot0:updateCouldAnimator(slot1.Animator, slot0)
	end, function ()
		for slot3, slot4 in ipairs(slot0.mapTFs) do
			setImageSprite(slot4, slot1[slot3])
			setActive(slot4, slot2[slot3])
			SetCompomentEnabled(slot4, typeof(Image), true)
		end

		existCall(slot3)
	end)
end

slot4 = {
	1520001,
	1520002,
	1520011,
	1520012
}
slot5 = {
	{
		1420008,
		"map_1420008",
		1420021,
		"map_1420001"
	},
	{
		1420018,
		"map_1420018",
		1420031,
		"map_1420011"
	}
}
slot6 = {
	1420001,
	1420011
}

slot0.ClearMapTransitions = function (slot0)
	if not slot0.mapTransitions then
		return
	end

	for slot4, slot5 in pairs(slot0.mapTransitions) do
		if slot5 then
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. slot4, slot4, slot5, true)
		else
			PoolMgr.GetInstance():DestroyPrefab("ui/" .. slot4, slot4)
		end
	end

	slot0.mapTransitions = nil
end

slot0.SwitchMapBG = function (slot0, slot1, slot2)
	slot3, slot4, slot5 = slot0:GetMapBG(slot1, slot2)

	if not slot3 or #slot3 <= 0 or table.equal(slot0.currentBG, slot3) then
		return
	end

	for slot9, slot10 in ipairs(slot0.mapGroup) do
		slot0.loader:ClearRequest(slot10)
	end

	table.clear(slot0.mapGroup)

	if not slot4 then
		slot0:SwitchBG(slot3)

		return
	end

	slot0:PlayMapTransition("LevelMapTransition_" .. slot4, slot5, function ()
		slot0:SwitchBG(slot0)
	end)
end

slot0.GetMapBG = function (slot0, slot1, slot2)
	if not table.contains(slot0, slot1.id) then
		return {
			slot0:GetMapElement(slot1)
		}
	end

	slot7 = _.map({
		slot0[bit.lshift(bit.rshift(slot4, 1), 1) + 1],
		slot0[bit.lshift(bit.rshift(slot4, 1), 1) + 1 + 1]
	}, function (slot0)
		return getProxy(ChapterProxy):getMapById(slot0)
	end)

	if _.all(slot7, function (slot0)
		return slot0:isAllChaptersClear()
	end) then
		slot7 = {
			slot0.GetMapElement(slot0, slot1)
		}

		if not slot2 or math.abs(slot3 - slot2) ~= 1 then
			return slot7
		end

		return slot7, slot1[bit.rshift(slot5 - 1, 1) + 1], bit.band(slot4, 1) == 1
	else
		function slot8()
			for slot4, slot5 in ipairs(slot0) do
				if not slot5:isClear() then
					return
				end

				slot1 = slot1 + 1
			end

			if not slot0[2]:isAnyChapterUnlocked(true) then
				return
			end

			slot1 = slot1 + 1

			for slot5, slot6 in ipairs(slot1) do
				if not slot6:isClear() then
					return
				end

				slot1 = slot1 + 1
			end
		end

		slot8()

		slot9 = nil

		return (0 <= 0 or {
			{
				BG = "map_" .. slot2[bit.rshift(slot5 - 1, 1) + 1][1],
				Animator = slot2[bit.rshift(slot5 - 1, 1) + 1][2]
			},
			{
				BG = "map_" .. slot2[bit.rshift(slot5 - 1, 1) + 1][3] + slot7,
				Animator = slot2[bit.rshift(slot5 - 1, 1) + 1][4]
			}
		}) and {
			slot0:GetMapElement(slot1)
		}
	end
end

slot0.GetMapElement = function (slot0, slot1)
	return {
		BG = slot1:getConfig("bg"),
		Animator = slot0:GetMapAnimator(slot1)
	}
end

slot0.GetMapAnimator = function (slot0, slot1)
	slot2 = slot1:getConfig("ani_name")

	if slot1:getConfig("animtor") == 1 and slot2 and #slot2 > 0 then
		return slot2
	end
end

slot0.PlayMapTransition = function (slot0, slot1, slot2, slot3, slot4)
	slot0.mapTransitions = slot0.mapTransitions or {}
	slot5 = nil

	function slot6()
		slot0:frozen()
		existCall(slot0, slot2)
		slot2:SetActive(true)
		pg.UIMgr.GetInstance():OverlayPanel(slot0, false, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})
		pg.UIMgr.GetInstance():GetComponent(typeof(Animator)).Play(slot3, (pg.UIMgr.GetInstance().GetComponent(typeof(Animator)) and "Sequence") or "Inverted", -1, 0)
		slot0:GetComponent("DftAniEvent"):SetEndEvent(function (slot0)
			pg.UIMgr.GetInstance():UnOverlayPanel(slot0, slot1._tf)
			existCall(pg.UIMgr.GetInstance(), slot0)
			PoolMgr.GetInstance():ReturnPrefab("ui/" .. slot1._tf, slot1._tf, )

			PoolMgr.GetInstance().ReturnPrefab.mapTransitions[slot4] = false

			PoolMgr.GetInstance().ReturnPrefab.mapTransitions:unfrozen()
		end)
	end

	PoolMgr.GetInstance().GetPrefab(slot7, "ui/" .. slot1, slot1, true, function (slot0)
		slot1.mapTransitions[slot2] = slot0

		slot3()
	end)
end

slot0.DestroyLevelStageView = function (slot0)
	if slot0.levelStageView then
		slot0.levelStageView:Destroy()

		slot0.levelStageView = nil
	end
end

slot0.displayAmbushInfo = function (slot0, slot1)
	slot0.levelAmbushView = LevelAmbushView.New(slot0.topPanel, slot0.event, slot0.contextData)

	slot0.levelAmbushView:Load()
	slot0.levelAmbushView:ActionInvoke("SetFuncOnComplete", slot1)
end

slot0.hideAmbushInfo = function (slot0)
	if slot0.levelAmbushView then
		slot0.levelAmbushView:Destroy()

		slot0.levelAmbushView = nil
	end
end

slot0.doAmbushWarning = function (slot0, slot1)
	slot0:frozen()

	function slot2()
		slot0.ambushWarning:SetActive(true)

		slot0 = tf(slot0.ambushWarning)

		slot0:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		slot0:SetSiblingIndex(1)

		slot1 = slot0:GetComponent("DftAniEvent")

		slot1:SetTriggerEvent(function (slot0)
			slot0()
		end)
		slot1.SetEndEvent(slot1, function (slot0)
			slot0.ambushWarning:SetActive(false)
			slot0:unfrozen()
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WARNING)
		Timer.New(function ()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
		end, 1, 1).Start(slot2)
	end

	if not slot0.ambushWarning then
		PoolMgr.GetInstance().GetUI(slot3, "ambushwarnui", true, function (slot0)
			slot0:SetActive(true)

			slot0.ambushWarning = slot0

			slot0()
		end)
	else
		slot2()
	end
end

slot0.destroyAmbushWarn = function (slot0)
	if slot0.ambushWarning then
		PoolMgr.GetInstance():ReturnUI("ambushwarnui", slot0.ambushWarning)

		slot0.ambushWarning = nil
	end
end

slot0.displayStrategyInfo = function (slot0, slot1)
	slot0.levelStrategyView = LevelStrategyView.New(slot0.topPanel, slot0.event, slot0.contextData)

	slot0.levelStrategyView:Load()
	slot0.levelStrategyView:ActionInvoke("set", slot1)
	slot0.levelStrategyView.ActionInvoke(slot4, "setCBFunc", function ()
		slot2 = pg.strategy_data_template[slot1.id]

		if not slot0.contextData.chapterVO.fleet:canUseStrategy(slot0.contextData.chapterVO.fleet) then
			return
		end

		slot3 = slot1:getNextStgUser(slot1.id)

		if slot2.type == ChapterConst.StgTypeForm then
			slot0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = slot3,
				arg1 = slot1.id
			})
		elseif slot2.type == ChapterConst.StgTypeConsume then
			slot0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = slot3,
				arg1 = slot1.id
			})
		end

		slot0:hideStrategyInfo()
	end, function ()
		slot0:hideStrategyInfo()
	end)
end

slot0.selectStrategyTarget = function (slot0, slot1, slot2)
	slot5 = slot0.contextData.chapterVO.fleet.line
	slot6 = {}

	if slot1.id == ChapterConst.StrategyAirStrike then
		slot6 = slot3:calcAreaCells(slot5.row, slot5.column, slot1.arg[2], slot1.arg[3])
	elseif slot1.id == ChapterConst.StrategyCannon then
		slot6 = slot3:calcAreaCells(slot5.row, slot5.column, 0, slot1.arg[2])
	end

	slot7 = _.filter(slot6, function (slot0)
		return not slot0:existFleet(nil, slot0.row, slot0.column)
	end)

	_.each(slot6, function (slot0)
		slot0.grid:shiningTarget(slot0.row, slot0.column, true)
	end)
	slot0.grid.updateQuadCells(slot7, ChapterConst.QuadStateStrategy, slot7, function (slot0)
		_.each(slot0, function (slot0)
			slot0.grid:shiningTarget(slot0.row, slot0.column, false)
		end)

		if slot0 and _.any(slot0, function (slot0)
			return slot0.row == slot0.row and slot0.column == slot0.column
		end) and slot2.existEnemy(slot1, ChapterConst.SubjectPlayer, slot0.row, slot0.column) then
			slot3(slot0.row, slot0.column)
		else
			slot1.grid:updateQuadCells(ChapterConst.QuadStateNormal)
		end
	end)
end

slot0.hideStrategyInfo = function (slot0)
	if slot0.levelStrategyView then
		slot0.levelStrategyView:Destroy()

		slot0.levelStrategyView = nil
	end
end

slot0.displayRepairWindow = function (slot0, slot1)
	slot2 = slot0.contextData.chapterVO
	slot4, slot5, slot6, slot7 = nil
	slot5, slot6, slot7 = ChapterConst.GetRepairParams()
	slot0.levelRepairView = LevelRepairView.New(slot0.topPanel, slot0.event, slot0.contextData)

	slot0.levelRepairView:Load()
	slot0.levelRepairView:ActionInvoke("set", slot4, slot5, slot6, slot7)
	slot0.levelRepairView.ActionInvoke(slot10, "setCBFunc", function ()
		if slot0 - math.min(math.min, slot0) == 0 and slot2.player:getTotalGem() < slot3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_rmb"))

			return
		end

		slot2:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpRepair,
			id = slot4.fleet.id,
			arg1 = slot4.fleet.id.id
		})
		slot2:hideRepairWindow()
	end, function ()
		slot0:hideRepairWindow()
	end)
end

slot0.hideRepairWindow = function (slot0)
	if slot0.levelRepairView then
		slot0.levelRepairView:Destroy()

		slot0.levelRepairView = nil
	end
end

slot0.displayRemasterPanel = function (slot0, slot1)
	slot2 = getProxy(ChapterProxy)
	slot3 = {}
	slot4 = pg.TimeMgr.GetInstance()

	for slot8, slot9 in ipairs(pg.re_map_template.all) do
		table.insert(slot3, pg.re_map_template[slot9])
	end

	table.sort(slot3, function (slot0, slot1)
		return slot0.order < slot1.order
	end)

	slot0.levelRemasterView = LevelRemasterView.New(slot0.topPanel, slot0.event, slot0.contextData)

	slot0.levelRemasterView.Load(slot5)
	slot0.levelRemasterView:ActionInvoke("set", slot3, slot2.remasterTickets, slot1)
	slot0.levelRemasterView.ActionInvoke(slot7, "setCBFunc", function (slot0)
		if not ((PlayerPrefs.HasKey("remaster_lastmap_" .. slot0.id) and PlayerPrefs.GetInt("remaster_lastmap_" .. slot0.id)) or pg.chapter_template[slot0.config_data[1]].map) then
			return
		end

		slot0:ShowSelectedMap(slot1, function ()
			slot0:hideRemasterPanel()
		end)
	end, function ()
		slot0:hideRemasterPanel()
	end)
end

slot0.hideRemasterPanel = function (slot0)
	if slot0.levelRemasterView then
		slot0.levelRemasterView:Destroy()

		slot0.levelRemasterView = nil
	end
end

slot0.initGrid = function (slot0, slot1)
	if not slot0.contextData.chapterVO then
		return
	end

	slot0:enableLevelCamera()
	setActive(slot0.uiMain, true)

	slot0.levelGrid.localEulerAngles = Vector3(slot2.theme.angle, 0, 0)
	slot0.grid = LevelGrid.New(slot0.dragLayer)

	slot0.grid:attach(slot0)
	slot0.grid:ExtendItem("shipTpl", slot0.shipTpl)
	slot0.grid:ExtendItem("subTpl", slot0.subTpl)
	slot0.grid:ExtendItem("transportTpl", slot0.transportTpl)
	slot0.grid:ExtendItem("enemyTpl", slot0.enemyTpl)
	slot0.grid:ExtendItem("deadTpl", slot0.deadTpl)
	slot0.grid:ExtendItem("championTpl", slot0.championTpl)
	slot0.grid:ExtendItem("oniTpl", slot0.oniTpl)
	slot0.grid:ExtendItem("arrowTpl", slot0.arrowTarget)
	slot0.grid:ExtendItem("destinationMarkTpl", slot0.destinationMarkTpl)

	slot0.grid.onCellClick = function (slot0)
		slot0:clickGridCell(slot0)
	end

	slot0.grid.onShipStepChange = function (slot0)
		slot0.levelStageView:updateAmbushRate(slot0)
	end

	slot0.grid.onShipArrived = function ()
		slot0:overrideChapter()
		slot0.levelStageView:updateAmbushRate(slot0.overrideChapter.contextData.chapterVO.fleet.line, true)
		slot0.levelStageView:updateStageStrategy()
	end

	slot0.grid.initAll(slot3, function ()
		slot0()
	end)
end

slot0.destroyGrid = function (slot0)
	if slot0.grid then
		slot0.grid:detach()

		slot0.grid = nil

		slot0:disableLevelCamera()
		setActive(slot0.dragLayer, true)
		setActive(slot0.uiMain, false)
	end
end

slot0.clickGridCell = function (slot0, slot1)
	if not slot0:isfrozen() then
		slot0.levelStageView:clickGridCell(slot1)
	end
end

slot0.doTracking = function (slot0, slot1)
	slot0:frozen()

	function slot2()
		slot0.radar:SetActive(true)

		slot0 = tf(slot0.radar)

		slot0:SetParent(slot0.topPanel, false)
		slot0:SetSiblingIndex(1)
		slot0:GetComponent("DftAniEvent").SetEndEvent(slot1, function (slot0)
			slot0.radar:SetActive(false)
			slot0:unfrozen()
			slot0.unfrozen()
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WEIGHANCHOR_SEARCH)
	end

	if not slot0.radar then
		PoolMgr.GetInstance().GetUI(slot3, "RadarEffectUI", true, function (slot0)
			slot0:SetActive(true)

			slot0.radar = slot0

			slot0()
		end)
	else
		slot2()
	end
end

slot0.destroyTracking = function (slot0)
	if slot0.radar then
		PoolMgr.GetInstance():ReturnUI("RadarEffectUI", slot0.radar)

		slot0.radar = nil
	end
end

slot0.doPlayAirStrike = function (slot0, slot1, slot2, slot3)
	function slot4()
		slot0.playing = true

		slot0:frozen()
		slot0.frozen.airStrike:SetActive(true)

		slot0 = tf(slot0.airStrike)

		slot0:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		slot0:SetAsLastSibling()
		slot1(slot0:Find("words/be_striked"), setActive == ChapterConst.SubjectChampion)
		slot1(slot0:Find("words/strike_enemy"), setActive == ChapterConst.SubjectPlayer)
		slot0.GetComponent(slot0, "DftAniEvent"):SetEndEvent(function ()
			slot0.playing = false

			SetActive(slot0.airStrike, false)

			if slot0.airStrike then
				slot1()
			end

			slot0:unfrozen()
		end)

		if slot0.GetComponent(slot0, "DftAniEvent").SetEndEvent then
			onButton(slot0, slot0, slot1, SFX_PANEL)
		else
			removeOnButton(slot0)
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WARNING)
	end

	if not slot0.airStrike then
		PoolMgr.GetInstance().GetUI(slot5, "AirStrike", true, function (slot0)
			slot0:SetActive(true)

			slot0.airStrike = slot0

			slot0()
		end)
	else
		slot4()
	end
end

slot0.destroyAirStrike = function (slot0)
	if slot0.airStrike then
		slot0.airStrike:GetComponent("DftAniEvent").SetEndEvent(slot1, nil)
		PoolMgr.GetInstance():ReturnUI("AirStrike", slot0.airStrike)

		slot0.airStrike = nil
	end
end

slot0.doPlayAnim = function (slot0, slot1, slot2, slot3)
	slot0.uiAnims = slot0.uiAnims or {}

	function slot5()
		slot0.playing = true

		slot0:frozen()
		slot0:SetActive(true)
		pg.UIMgr.GetInstance():OverlayPanel(tf(slot0), false, {
			groupName = LayerWeightConst.GROUP_LEVELUI
		})

		if pg.UIMgr.GetInstance() then
			slot2(slot2)
		end

		slot0:GetComponent("DftAniEvent").SetEndEvent(slot1, function (slot0)
			slot0.playing = false

			pg.UIMgr.GetInstance():UnOverlayPanel(pg.UIMgr.GetInstance().UnOverlayPanel, slot0._tf)

			if pg.UIMgr.GetInstance() then
				slot2(slot3)
			end

			slot0:unfrozen()
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WARNING)
	end

	if not slot0.uiAnims[slot1] then
		PoolMgr.GetInstance().GetUI(slot6, slot1, true, function (slot0)
			slot0:SetActive(true)

			slot0.uiAnims[] = slot0
			slot2 = slot0.uiAnims[]

			true()
		end)
	else
		slot5()
	end
end

slot0.destroyUIAnims = function (slot0)
	if slot0.uiAnims then
		for slot4, slot5 in pairs(slot0.uiAnims) do
			pg.UIMgr.GetInstance():UnOverlayPanel(tf(slot5), slot0._tf)
			slot5:GetComponent("DftAniEvent").SetEndEvent(slot6, nil)
			PoolMgr.GetInstance():ReturnUI(slot4, slot5)
		end

		slot0.uiAnims = nil
	end
end

slot0.doPlayTorpedo = function (slot0, slot1)
	function slot2()
		slot0.playing = true

		slot0:frozen()
		slot0.frozen.torpetoAni:SetActive(true)

		slot0 = tf(slot0.torpetoAni)

		slot0:SetParent(slot0.topPanel, false)
		slot0:SetAsLastSibling()
		slot0:GetComponent("DftAniEvent").SetEndEvent(slot1, function (slot0)
			slot0.playing = false

			SetActive(slot0.torpetoAni, false)

			if SetActive then
				slot1()
			end

			slot0:unfrozen()
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WARNING)
	end

	if not slot0.torpetoAni then
		PoolMgr.GetInstance().GetUI(slot3, "Torpeto", true, function (slot0)
			slot0:SetActive(true)

			slot0.torpetoAni = slot0

			slot0()
		end)
	else
		slot2()
	end
end

slot0.destroyTorpedo = function (slot0)
	if slot0.torpetoAni then
		slot0.torpetoAni:GetComponent("DftAniEvent").SetEndEvent(slot1, nil)
		PoolMgr.GetInstance():ReturnUI("Torpeto", slot0.torpetoAni)

		slot0.torpetoAni = nil
	end
end

slot0.doPlayStrikeAnim = function (slot0, slot1, slot2, slot3)
	slot0.strikeAnims = slot0.strikeAnims or {}
	slot4, slot5, slot6 = nil

	function slot7()
		if coroutine.status(coroutine.status) == "suspended" then
			slot0, slot1 = coroutine.resume(coroutine.resume)
		end
	end

	slot8 = coroutine.create(function ()
		slot0.playing = true

		slot0:frozen()
		setActive(slot0, true)

		slot1 = tf(slot0)
		slot3 = findTF(slot1, "mask/painting")
		slot4 = findTF(slot1, "ship")

		setParent(slot2, slot3:Find("fitter"), false)
		setParent(slot3, slot4, false)
		setActive(slot4, false)
		setActive(slot2, false)
		slot1:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		slot1:SetAsLastSibling()

		slot5 = slot1:GetComponent("DftAniEvent")
		slot6 = slot3:GetComponent("SpineAnimUI")

		slot5:SetStartEvent(function (slot0)
			slot0:SetAction("attack", 0)

			slot0.SetAction.freeze = true
		end)
		slot5.SetTriggerEvent(slot5, function (slot0)
			slot0.freeze = false

			slot0:SetActionCallBack(function (slot0)
				if slot0 == "action" then
				elseif slot0 == "finish" then
					slot0.freeze = true
				end
			end)
		end)
		slot5.SetEndEvent(slot5, function (slot0)
			slot0.freeze = false

			slot0()
		end)
		onButton(slot0, slot1, slot4, SFX_CANCEL)
		coroutine.yield()
		retPaintingPrefab(slot3, slot5:getPainting())
		slot6:SetActionCallBack(nil)

		slot6:GetComponent("SkeletonGraphic").freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(slot5:getPrefab(), slot3)
		setActive(slot0, false)

		slot0.playing = false

		slot0:unfrozen()

		if slot6 then
			slot6()
		end
	end)
	slot6 = slot8

	function slot8()
		if slot0.strikeAnims[slot1] and slot2 and slot3 then
			slot4()
		end
	end

	PoolMgr.GetInstance().GetPainting(slot9, slot1:getPainting(), true, function (slot0)
		ShipExpressionHelper.SetExpression(slot0, slot1:getPainting())
		slot0()
	end)
	PoolMgr.GetInstance().GetSpineChar(slot9, slot1:getPrefab(), true, function (slot0)
		slot0.transform.localScale = Vector3.one

		slot0.transform()
	end)

	if not slot0.strikeAnims[slot2] then
		PoolMgr.GetInstance().GetUI(slot9, slot2, true, function (slot0)
			slot0.strikeAnims[] = slot0

			slot0.strikeAnims()
		end)
	end
end

slot0.destroyStrikeAnim = function (slot0)
	if slot0.strikeAnims then
		for slot4, slot5 in pairs(slot0.strikeAnims) do
			slot5:GetComponent("DftAniEvent").SetEndEvent(slot6, nil)
			PoolMgr.GetInstance():ReturnUI(slot4, slot5)
		end

		slot0.strikeAnims = nil
	end
end

slot0.doPlayEnemyAnim = function (slot0, slot1, slot2, slot3)
	slot0.strikeAnims = slot0.strikeAnims or {}
	slot4, slot5 = nil

	function slot6()
		if coroutine.status(coroutine.status) == "suspended" then
			slot0, slot1 = coroutine.resume(coroutine.resume)
		end
	end

	slot7 = coroutine.create(function ()
		slot0.playing = true

		slot0:frozen()
		setActive(slot0, true)

		slot1 = tf(slot0)
		slot2 = findTF(slot1, "torpedo")
		slot3 = findTF(slot1, "ship")

		setParent(slot2, slot3, false)
		setActive(slot3, false)
		setActive(slot2, false)
		slot1:SetParent(pg.UIMgr.GetInstance().OverlayMain.transform, false)
		slot1:SetAsLastSibling()

		slot4 = slot1:GetComponent("DftAniEvent")
		slot5 = slot2:GetComponent("SpineAnimUI")

		slot4:SetStartEvent(function (slot0)
			slot0:SetAction("attack", 0)

			slot0.SetAction.freeze = true
		end)
		slot4.SetTriggerEvent(slot4, function (slot0)
			slot0.freeze = false

			slot0:SetActionCallBack(function (slot0)
				if slot0 == "action" then
				elseif slot0 == "finish" then
					slot0.freeze = true
				end
			end)
		end)
		slot4.SetEndEvent(slot4, function (slot0)
			slot0.freeze = false

			slot0()
		end)
		onButton(slot0, slot1, slot3, SFX_CANCEL)
		coroutine.yield()
		slot5:SetActionCallBack(nil)

		slot5:GetComponent("SkeletonGraphic").freeze = false

		PoolMgr.GetInstance():ReturnSpineChar(slot4:getPrefab(), slot2)
		setActive(slot0, false)

		slot0.playing = false

		slot0:unfrozen()

		if slot5 then
			slot5()
		end
	end)
	slot5 = slot7

	function slot7()
		if slot0.strikeAnims[slot1] and slot2 then
			slot3()
		end
	end

	PoolMgr.GetInstance().GetSpineChar(slot8, slot1:getPrefab(), true, function (slot0)
		slot0.transform.localScale = Vector3.one

		slot0.transform()
	end)

	if not slot0.strikeAnims[slot2] then
		PoolMgr.GetInstance().GetUI(slot8, slot2, true, function (slot0)
			slot0.strikeAnims[] = slot0

			slot0.strikeAnims()
		end)
	end
end

slot0.doSignalSearch = function (slot0, slot1)
	slot0:frozen()

	function slot2()
		slot0.playing = true

		slot0.signalAni:SetActive(true)

		slot0 = tf(slot0.signalAni)

		slot0:SetParent(slot0.topPanel, false)
		slot0:SetAsLastSibling()
		slot0:GetComponent("DftAniEvent").SetEndEvent(slot1, function (slot0)
			slot0.playing = false

			SetActive(slot0.signalAni, false)

			if SetActive then
				slot1()
			end

			slot0:unfrozen()
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WARNING)
	end

	if not slot0.signalAni then
		PoolMgr.GetInstance().GetUI(slot3, "SignalUI", true, function (slot0)
			slot0:SetActive(true)

			slot0.signalAni = slot0

			slot0()
		end)
	else
		slot2()
	end
end

slot0.destroySignalSearch = function (slot0)
	if slot0.signalAni then
		slot0.signalAni:GetComponent("DftAniEvent").SetEndEvent(slot1, nil)
		PoolMgr.GetInstance():ReturnUI("SignalUI", slot0.signalAni)

		slot0.signalAni = nil
	end
end

slot0.PlaySubRefreshAnimation = function (slot0, slot1, slot2)
	if not slot0.levelSignalView then
		existCall(slot2)

		return
	end

	slot0.levelSignalView:ActionInvoke("PlaySubRefreshAnimation", slot1, slot2)
end

slot0.doPlayCommander = function (slot0, slot1, slot2)
	slot0:frozen()
	setActive(slot0.commanderTinkle, true)
	setText(slot0.commanderTinkle:Find("name"), (#slot1:getSkills() > 0 and slot3[1]:getConfig("name")) or "")
	setImageSprite(slot0.commanderTinkle:Find("icon"), GetSpriteFromAtlas("commanderhrz/" .. slot1:getConfig("painting"), ""))

	slot0.commanderTinkle:GetComponent(typeof(CanvasGroup)).alpha = 0
	slot5 = Vector2(248, 237)

	LeanTween.value(go(slot0.commanderTinkle), 0, 1, 0.5):setOnUpdate(System.Action_float(function (slot0)
		slot0.commanderTinkle.localPosition.x = slot1.x + -100 * (1 - slot0)
		slot0.commanderTinkle.localPosition = slot0.commanderTinkle.localPosition
		slot0.commanderTinkle.alpha = slot0
	end)).setEase(slot6, LeanTweenType.easeOutSine)
	LeanTween.value(go(slot0.commanderTinkle), 0, 1, 0.3):setDelay(0.7):setOnUpdate(System.Action_float(function (slot0)
		slot0.commanderTinkle.localPosition.x = slot1.x + 100 * slot0
		slot0.commanderTinkle.localPosition = slot0.commanderTinkle.localPosition
		slot0.commanderTinkle.alpha = 1 - slot0
	end)).setOnComplete(slot6, System.Action(function ()
		if slot0 then
			slot0()
		end

		slot1:unfrozen()
	end))
end

slot0.strikeEnemy = function (slot0, slot1, slot2, slot3)
	if not slot0.grid:shakeCell(slot1) then
		slot3()

		return
	end

	slot0:frozen()

	slot0.damageText.position = slot0.uiCam:ScreenToWorldPoint(slot5)
	slot0.damageText.localPosition.y = slot0.damageText.localPosition.y + 40
	slot0.damageText.localPosition.z = 0

	slot0:easeDamage(slot0.damageText.localPosition, slot2, function ()
		slot0:unfrozen()
		slot0()
	end)
end

slot0.easeDamage = function (slot0, slot1, slot2, slot3)
	slot0:frozen()
	setText(slot0.damageText, slot2)
	setActive(slot0.damageText, true)

	slot0.damageText.localPosition = slot1

	LeanTween.value(go(slot0.damageText), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
		slot0.damageText.localPosition.y = slot1.y + 60 * slot0
		slot0.damageText.localPosition = slot0.damageText.localPosition

		setTextAlpha(slot0.damageText, 1 - slot0)
	end)).setOnComplete(slot4, System.Action(function ()
		setActive(slot0.damageText, false)
		setActive:unfrozen()

		if setActive then
			slot1()
		end
	end))
end

slot0.easeAvoid = function (slot0, slot1, slot2)
	slot0:frozen()

	slot0.avoidText.position = slot0.uiCam:ScreenToWorldPoint(slot3)
	slot0.avoidText.localPosition.z = 0
	slot0.avoidText.localPosition = slot0.avoidText.localPosition

	setActive(slot0.avoidText, true)

	slot5 = slot0.avoidText:Find("avoid")

	LeanTween.value(go(slot0.avoidText), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
		slot0.avoidText.localPosition.y = slot1.y + 100 * slot0
		slot0.avoidText.localPosition = slot0.avoidText.localPosition

		setImageAlpha(slot0.avoidText, 1 - slot0)
		setImageAlpha(setImageAlpha, 1 - slot0)
	end)).setOnComplete(slot6, System.Action(function ()
		setActive(slot0.avoidText, false)
		setActive:unfrozen()

		if setActive then
			slot1()
		end
	end))
end

slot0.overrideChapter = function (slot0)
	slot0:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
end

slot0.onSubLayerOpen = function (slot0)
	setActive(slot0.topPanel, false)
	slot0:disableLevelCamera()

	slot0.visibilityForPreCombat = {
		leftChapter = isActive(slot0.leftChapter),
		rightChapter = isActive(slot0.rightChapter),
		clouds = isActive(slot0.clouds)
	}

	for slot4, slot5 in pairs(slot0.visibilityForPreCombat) do
		setActive(slot0[slot4], false)
	end

	slot0.isSubLayerOpen = true
end

slot0.onSubLayerClose = function (slot0)
	if not slot0.exited then
		slot0:enableLevelCamera()

		if #getProxy(ContextProxy).getContextByMediator(slot1, LevelMediator2).children == 0 then
			setActive(slot0.topPanel, true)

			if slot0.visibilityForPreCombat then
				for slot6, slot7 in pairs(slot0.visibilityForPreCombat) do
					setActive(slot0[slot6], slot7)
				end

				slot0.visibilityForPreCombat = nil
			end
		end
	end

	slot0.isSubLayerOpen = nil
end

slot0.resetLevelGrid = function (slot0)
	slot0.dragLayer.localPosition = Vector3.zero
end

slot0.ShowCurtains = function (slot0, slot1)
	setActive(slot0.curtain, slot1)
end

slot0.ClearLoadedTemplates = function (slot0)
	if not slot0.loadedTpls then
		return
	end

	for slot4, slot5 in pairs(slot0.loadedTpls) do
		if not IsNil(slot5) then
			slot0.Destroy(slot5, true)
		end
	end

	slot0.loadedTpls = nil
end

slot0.frozen = function (slot0)
	slot1 = slot0.frozenCount
	slot0.frozenCount = slot0.frozenCount + 1
	slot0.canvasGroup.blocksRaycasts = slot0.frozenCount == 0

	if slot1 == 0 and slot0.frozenCount ~= 0 then
		slot0:emit(LevelUIConst.ON_FROZEN)
	end
end

slot0.unfrozen = function (slot0, slot1)
	if slot0.exited then
		return
	end

	slot2 = slot0.frozenCount
	slot0.frozenCount = slot0.frozenCount - ((slot1 == -1 and slot0.frozenCount) or slot1 or 1)
	slot0.canvasGroup.blocksRaycasts = slot0.frozenCount == 0

	if slot2 ~= 0 and slot0.frozenCount == 0 then
		slot0:emit(LevelUIConst.ON_UNFROZEN)
	end
end

slot0.isfrozen = function (slot0)
	return slot0.frozenCount > 0
end

slot0.enableLevelCamera = function (slot0)
	slot0.levelCamIndices = math.max(slot0.levelCamIndices - 1, 0)

	if slot0.levelCamIndices == 0 then
		slot0.levelCam.enabled = true

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

slot0.disableLevelCamera = function (slot0)
	slot0.levelCamIndices = slot0.levelCamIndices + 1

	if slot0.levelCamIndices > 0 then
		slot0.levelCam.enabled = false

		pg.LayerWeightMgr.GetInstance():switchOriginParent()
	end
end

slot0.RecordTween = function (slot0, slot1, slot2)
	slot0.tweens[slot1] = slot2
end

slot0.DeleteTween = function (slot0, slot1)
	if slot0.tweens[slot1] then
		LeanTween.cancel(slot2)

		slot0.tweens[slot1] = nil
	end
end

slot0.openCommanderPanel = function (slot0, slot1, slot2, slot3)
	slot4 = slot2.id

	slot0.levelCMDFormationView:setCallback(function (slot0)
		if not slot0 then
			if slot0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
				slot1:emit(LevelMediator2.ON_COMMANDER_SKILL, slot0.skill)
			elseif slot0.type == LevelUIConst.COMMANDER_OP_ADD then
				slot1.contextData.commanderSelected = {
					chapterId = slot2,
					fleetId = slot2.id
				}

				slot1.contextData:emit(LevelMediator2.ON_SELECT_COMMANDER, slot0.pos, slot3.id, )
				slot1.contextData.emit:closeCommanderPanel()
			else
				slot1:emit(LevelMediator2.ON_COMMANDER_OP, {
					FleetType = LevelUIConst.FLEET_TYPE_SELECT,
					data = slot0,
					fleetId = slot3.id,
					chapterId = slot2
				}, )
			end
		elseif slot0.type == LevelUIConst.COMMANDER_OP_SHOW_SKILL then
			slot1:emit(LevelMediator2.ON_COMMANDER_SKILL, slot0.skill)
		elseif slot0.type == LevelUIConst.COMMANDER_OP_ADD then
			slot1.contextData.eliteCommanderSelected = {
				index = slot0,
				pos = slot0.pos,
				chapterId = 
			}

			slot1.contextData:emit(LevelMediator2.ON_SELECT_ELITE_COMMANDER, slot0, slot0.pos, )
			slot1.contextData.emit:closeCommanderPanel()
		else
			slot1:emit(LevelMediator2.ON_COMMANDER_OP, {
				FleetType = LevelUIConst.FLEET_TYPE_EDIT,
				data = slot0,
				index = slot0,
				chapterId = slot2
			}, )
		end
	end)
	slot0.levelCMDFormationView.Load(slot5)
	slot0.levelCMDFormationView:ActionInvoke("update", slot1, slot0.commanderPrefabs)
	slot0.levelCMDFormationView:ActionInvoke("Show")
end

slot0.updateCommanderPrefab = function (slot0)
	if slot0.levelCMDFormationView:isShowing() then
		slot0.levelCMDFormationView:ActionInvoke("updatePrefabs", slot0.commanderPrefabs)
	end
end

slot0.closeCommanderPanel = function (slot0)
	slot0.levelCMDFormationView:ActionInvoke("Hide")
end

slot0.destroyCommanderPanel = function (slot0)
	slot0.levelCMDFormationView:Destroy()

	slot0.levelCMDFormationView = nil
end

slot0.setSpecialOperationTickets = function (slot0, slot1)
	slot0.spTickets = slot1
end

slot0.HandleShowMsgBox = function (slot0, slot1)
	slot1.blurLevelCamera = true

	pg.MsgboxMgr.GetInstance():ShowMsgBox(slot1)
end

slot0.updatePoisonAreaTip = function (slot0)
	slot1 = slot0.contextData.chapterVO

	function slot2(slot0)
		slot1 = {}
		slot2 = pg.map_event_list[slot0.id] or {}
		slot3 = nil

		if slot0:isLoop() then
			slot3 = slot2.event_list_loop or {}
		else
			slot3 = slot2.event_list or {}
		end

		for slot7, slot8 in ipairs(slot3) do
			if pg.map_event_template[slot8].c_type == slot0 then
				table.insert(slot1, slot9)
			end
		end

		return slot1
	end

	if slot2(ChapterConst.EvtType_Poison) then
		for slot7, slot8 in ipairs(slot3) do
			if slot8.round_gametip ~= nil and slot9 ~= "" and slot1:getRoundNum() == slot9[1] then
				pg.TipsMgr.GetInstance():ShowTips(i18n(slot9[2]))
			end
		end
	end
end

slot0.updateVoteBookBtn = function (slot0, slot1)
	setActive(slot0._voteBookBtn, slot1 and not slot1:IsExpired())
	slot0:RemoveVoteBookTimer()

	if slot1 and not slot1.IsExpired() then
		onButton(slot0, slot0._voteBookBtn, function ()
			slot0:emit(LevelMediator2.ON_VOTE_BOOK)
		end, SFX_PANEL)

		slot3 = slot0._voteBookBtn.Find(slot3, "tip/Text"):GetComponent(typeof(Text))
		slot0.voteBookTimer = Timer.New(function ()
			slot0.text = slot1:GetCDTime()
		end, 1, -1)

		slot0.voteBookTimer.Start(slot4)
		slot0.voteBookTimer.func()
	end
end

slot0.RemoveVoteBookTimer = function (slot0)
	if slot0.voteBookTimer then
		slot0.voteBookTimer:Stop()

		slot0.voteBookTimer = nil
	end
end

slot0.RecordLastMapOnExit = function (slot0)
	if getProxy(ChapterProxy) and not slot0.contextData.noRecord then
		if not slot0.contextData.map then
			return
		end

		if slot2 and slot2:NeedRecordMap() then
			slot1:recordLastMap(ChapterProxy.LAST_MAP, slot2.id)
		end

		if Map.lastMapForActivity then
			slot1:recordLastMap(ChapterProxy.LAST_MAP_FOR_ACTIVITY, Map.lastMapForActivity)
		end
	end
end

slot0.willExit = function (slot0)
	slot0:ClearMapTransitions()
	slot0.loader:Clear()
	slot0:RemoveVoteBookTimer()

	if slot0.contextData.chapterVO then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.topPanel, slot0._tf)
	end

	slot0:ClearLoadedTemplates()

	if slot0.levelFleetView and slot0.levelFleetView.selectIds then
		slot0.contextData.selectedFleetIDs = {}

		for slot4, slot5 in pairs(slot0.levelFleetView.selectIds) do
			for slot9, slot10 in pairs(slot5) do
				slot0.contextData.selectedFleetIDs[#slot0.contextData.selectedFleetIDs + 1] = slot10
			end
		end
	end

	slot0:destroyChapterPanel()
	slot0:destroyFleetEdit()
	slot0:destroyCommanderPanel()
	slot0:DestroyLevelStageView()
	slot0:hideSignalPanel()
	slot0:hideRepairWindow()
	slot0:hideStrategyInfo()
	slot0:hideRemasterPanel()
	slot0:hideSpResult()
	slot0:destroyGrid()
	slot0:destroyAmbushWarn()
	slot0:destroyAirStrike()
	slot0:destroyTorpedo()
	slot0:destroyStrikeAnim()
	slot0:destroyTracking()
	slot0:destroyUIAnims()
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad_mark", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell_quad", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/cell", "")
	PoolMgr.GetInstance():DestroyPrefab("chapter/plane", "")

	for slot4, slot5 in pairs(slot0.mbDict) do
		slot5:Destroy()
	end

	slot0.mbDict = nil

	for slot4, slot5 in pairs(slot0.tweens) do
		LeanTween.cancel(slot5)
	end

	slot0.tweens = nil

	if slot0.cloudTimer then
		_.each(slot0.cloudTimer, function (slot0)
			LeanTween.cancel(slot0)
		end)

		slot0.cloudTimer = nil
	end

	if slot0.newChapterCDTimer then
		slot0.newChapterCDTimer.Stop(slot1)

		slot0.newChapterCDTimer = nil
	end

	if slot0.resPanel then
		slot0.resPanel:exit()

		slot0.resPanel = nil
	end

	LeanTween.cancel(go(slot0.damageText))
	LeanTween.cancel(go(slot0.avoidText))

	slot0.map.localScale = Vector3.one
	slot0.map.pivot = Vector2(0.5, 0.5)
	slot0.float.localScale = Vector3.one
	slot0.float.pivot = Vector2(0.5, 0.5)

	for slot4, slot5 in ipairs(slot0.mapTFs) do
		clearImageSprite(slot5)
	end

	_.each(slot0.cloudRTFs, function (slot0)
		clearImageSprite(slot0)
	end)
	PoolMgr.GetInstance().DestroyAllSprite(slot1)
	slot0:RecordLastMapOnExit()
end

return slot0

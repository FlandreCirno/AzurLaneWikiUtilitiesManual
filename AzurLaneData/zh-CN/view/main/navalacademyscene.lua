slot0 = class("NavalAcademyScene", import("..base.BaseUI"))
slot0.STATE_ACADEMY = "STATE_ACADEMY"
slot0.STATE_COURSE = "STATE_COURSE"
slot0.STATE_RESOURCE = "STATE_RESOURCE"
slot0.STATE_MERCHANT = "STATE_MERCHANT"
slot0.COURSE_COUNT = 5
slot0.ICON_COUNT = 3
slot0.MAX_SLOT = 3
slot1 = 5
slot0.WARP_TO_TACTIC = "WARP_TO_TACTIC"

slot0.getUIName = function (slot0)
	return "NavalAcademyUI"
end

slot0.init = function (slot0)
	slot0.sakura = slot0:findTF("effect")
	slot0._map = slot0:findTF("academyMap/map")
	slot0.wave = slot0._map:Find("effect_wave")
	slot0._classBtn = slot0._map:Find("classRoom")

	setActive(slot0._classBtn, not LOCK_CLASSROOM)

	slot0._fountain = slot0._map:Find("fountain")
	slot0._commanderBtn = slot0._map:Find("commander")
	slot0._merchant = slot0._map:Find("merchant")
	slot0._tacticRoom = slot0._map:Find("tacticRoom")
	slot0._shipTpl = slot0._map:Find("ship")
	slot0._blurLayer = slot0:findTF("blur_container")
	slot0._topPanel = slot0._blurLayer:Find("adapt/top")
	slot0._backBtn = slot0._topPanel:Find("title/back")
	slot0._shop = slot0._map:Find("shop")
	slot0._getGold = slot0._shop:Find("popup_contain/popup")
	slot0._canteen = slot0._map:Find("canteen")
	slot0._getOil = slot0._canteen:Find("popup_contain/popup")
	slot0._resourceLayer = slot0:findTF("blur_container/resource_panel")
	slot0._merchantTip = slot0:findTF("merchant/tip", slot0._map)
	slot0._tacticTips = slot0:findTF("tip", slot0._tacticRoom)
	slot0._fountainReminder = slot0:findTF("tip", slot0._fountain)
	slot0._currentCourseID = slot0.contextData.number
	slot0._startCourseFlag = slot0.contextData.startCourseFlag
	slot0.contextData.number = nil
	slot0.contextData.selectedShips = nil
	slot0.contextData.startCourseFlag = nil
	slot0.warp = slot0.contextData.warp
	slot0.contextData.warp = nil
	slot0._panelTimer = {}
	slot0._buildingTimers = {}
	slot0._mapTimers = {}
	slot0.academyStudents = {}
	slot0.academyGraphPath = GraphPath.New(AcademyGraph)
	slot0._playerResOb = slot0:findTF("blur_container/adapt/top/playerRes")
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)
	slot0:uiStartAnimating()
end

slot0.uiStartAnimating = function (slot0)
	setAnchoredPosition(slot0._topPanel, {
		y = 84
	})
	shiftPanel(slot0._topPanel, nil, 0, 0.3, 0, true, true)
end

slot0.uiExitAnimating = function (slot0)
	shiftPanel(slot0._topPanel, nil, slot0._topPanel.rect.height, 0.3, 0, true, true)
end

slot0.didEnter = function (slot0)
	setText(slot0._resourceLayer:Find("describe/canteen"), i18n("naval_academy_res_desc_cateen"))
	setText(slot0._resourceLayer:Find("describe/shop"), i18n("naval_academy_res_desc_shop"))

	slot0._currentState = slot0.STATE_ACADEMY

	onButton(slot0, slot0._backBtn, function ()
		if slot0._currentState == slot1.STATE_ACADEMY then
			slot0:uiExitAnimating()
			slot0.uiExitAnimating:emit(slot1.ON_BACK, nil, 0.3)
		elseif slot0._currentState == slot1.STATE_COURSE then
			slot0:CloseCoursePanel()
		elseif slot0._currentState == slot1.STATE_RESOURCE then
			slot0:CloseResourcePanel()
		end
	end, SFX_CANCEL)
	setText(slot0._classBtn.Find(slot2, "title/name/Text"), i18n("school_title_dajiangtang"))
	setText(slot0._commanderBtn:Find("title/name/Text"), i18n("school_title_zhihuimiao"))
	setText(slot0._tacticRoom:Find("title/name/Text"), i18n("school_title_xueyuan"))
	setText(slot0._merchant:Find("title/name/Text"), i18n("school_title_shangdian"))
	setText(slot0._fountain:Find("title/name/Text"), i18n("school_title_shoucang"))
	setText(slot0._shop:Find("title/name/Text"), i18n("school_title_xiaomaibu"))
	setText(slot0._canteen:Find("title/name/Text"), i18n("school_title_shitang"))
	onButton(slot0, slot0._classBtn, function ()
		slot0, slot1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0._player.level, "ClassMediator")

		if not slot0 then
			pg.TipsMgr.GetInstance():ShowTips(slot1)

			return
		end

		slot0:emit(NavalAcademyMediator.OPEN_CLASS)
	end, SFX_PANEL)
	onButton(slot0, slot0._canteen, function ()
		slot0:OpenResourcePanel(slot0._oilVO)
	end, SFX_PANEL)
	onButton(slot0, slot0._shop, function ()
		slot0:OpenResourcePanel(slot0._goldVO)
	end, SFX_PANEL)
	onButton(slot0, slot0._getGold, function ()
		if slot0._player.goldField <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_0Gold"))
		else
			slot0:emit(NavalAcademyMediator.GET_RES, ResourceField.TYPE_GOLD)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._getOil, function ()
		if slot0._player.oilField <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_0Oil"))
		else
			slot0:emit(NavalAcademyMediator.GET_RES, ResourceField.TYPE_OIL)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._merchant, function ()
		setActive(slot0._merchantTip, false)
		setActive:emit(NavalAcademyMediator.GO_SHOP)
	end, SFX_PANEL)
	onButton(slot0, slot0._tacticRoom, function ()
		setActive(slot0._tacticTips, false)
		setActive:activeSakura(false)
		setActive.activeSakura:emit(NavalAcademyMediator.OPEN_TACTIC, function ()
			slot0:activeSakura(true)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot0._commanderBtn, function ()
		slot0:emit(NavalAcademyMediator.OPEN_COMMANDER)
	end)
	onButton(slot0, slot0._fountain, function ()
		slot0:activeSakura(false)
		slot0.activeSakura:emit(NavalAcademyMediator.OPEN_TROPHY_GALLERY, function ()
			slot0:activeSakura(true)
		end, SFX_PANEL)
	end)

	if slot0._currentCourseID ~= nil then
		if slot0._startCourseFlag then
			pg.TipsMgr.GetInstance().ShowTips(slot1, i18n("main_navalAcademyScene_quest_startClass"))
		end

		triggerToggle(slot0._toggleList[slot0._currentCourseID], true)

		slot0.currentCourseID = nil
	end

	if slot0.warp == slot0.WARP_TO_TACTIC then
		slot0:activeSakura(false)
		slot0:emit(NavalAcademyMediator.OPEN_TACTIC, function ()
			slot0:activeSakura(true)
		end)
	end

	blinkAni(go(slot0.findTF(slot0, "blur_container/resource_panel/produce/pre_value")), 0.8)
	blinkAni(go(slot0:findTF("blur_container/resource_panel/store/pre_value")), 0.8)
	slot0:updateStudents()
	slot0:updateTrophyReminder()

	slot0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(slot0, 60037)
end

slot0.SetPlayerInfo = function (slot0, slot1, slot2, slot3, slot4)
	slot0._player = slot1
	slot0._oilVO = slot2
	slot0._goldVO = slot3
	slot0._classVO = slot4

	slot0:updateMap()
	slot0._resPanel:setResources(slot1)
end

slot0.SetMerchantInfo = function (slot0, slot1)
	if slot1:isUpdateGoods() then
		setActive(slot0._merchantTip, true)
	end
end

slot0.SetTacticInfo = function (slot0, slot1)
	slot0.students = slot1
	slot2 = pg.TimeMgr.GetInstance():GetServerTime()

	for slot6, slot7 in pairs(slot1) do
		if slot7:getFinishTime() <= slot2 then
			setActive(slot0._tacticTips, true)

			break
		end
	end
end

slot0.SetCourseInfo = function (slot0, slot1)
	slot0._courseVO = slot1
end

slot0.SetUnclaimTrophyCount = function (slot0, slot1)
	slot0._unclaimTrophyCount = slot1
end

slot0.updateMap = function (slot0)
	slot0:updateResourceBuilding(slot0._canteen, slot0._player.oilField, slot0._oilVO)
	slot0:updateResourceBuilding(slot0._shop, slot0._player.goldField, slot0._goldVO)
	slot0:updateResourceBuilding(slot0._classBtn, nil, slot0._classVO)
end

slot0.updateResourceBuilding = function (slot0, slot1, slot2, slot3)
	pg.TimeMgr.GetInstance():RemoveTimer(slot0._buildingTimers[slot3])

	if slot2 then
		SetActive(slot1:Find("popup_contain/popup"), slot2 > 0)
	end

	SetActive(slot1:Find("tip"), false)

	if slot3._type == ResourceField.TYPE_CLASS and slot0._courseVO:inClass() and AcademyCourse.MaxStudyTime <= pg.TimeMgr.GetInstance():GetServerTime() - slot0._courseVO.timestamp then
		SetActive(slot1:Find("tip"), true)
	end

	slot4 = slot1:Find("title/name")
	slot5 = slot1:Find("title/count")

	if slot3:GetUpgradeTimeStamp() == 0 then
		SetActive(slot4, true)
		SetActive(slot5, false)

		slot4:Find("level"):GetComponent(typeof(Text)).text = "Lv." .. slot3:GetLevel()

		if slot3:CanUpgrade(slot0._player.level, slot0._player.gold) then
			SetActive(slot1:Find("tip"), true)
		end
	else
		SetActive(slot4, false)
		SetActive(slot5, true)

		slot6 = slot5:Find("Text"):GetComponent(typeof(Text))
		slot0._buildingTimers[slot3] = pg.TimeMgr.GetInstance():AddTimer("timer", 0, 1, function ()
			if slot0:GetDuration() and slot0 > 0 then
				slot1.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
			else
				pg.TimeMgr.GetInstance():RemoveTimer(slot2._buildingTimers[slot0])
				pg.TimeMgr.GetInstance():emit(NavalAcademyMediator.UPGRADE_TIMES_UP)
			end
		end)
	end
end

slot0.OpenResourcePanel = function (slot0, slot1)
	setActive(slot0._topPanel, false)
	slot0:openSecondPanel()

	slot0._currentState = slot0.STATE_RESOURCE

	SetActive(slot0._resourceLayer, true)
	onButton(slot0, slot0:findTF("mengban", slot0._resourceLayer), function ()
		slot0:CloseResourcePanel()
	end)

	slot2 = slot1.bindConfigTable(slot1)
	slot4 = slot0._resourceLayer:Find("upgrading_block")
	slot5 = slot0._resourceLayer:Find("upgrade_btn").Find(slot3, "cost"):GetComponent("Text")
	slot6 = slot0._resourceLayer:Find("upgrade_duration/Text"):GetComponent(typeof(Text))
	slot7 = slot0._resourceLayer:Find("produce")
	slot8 = slot0._resourceLayer:Find("store")
	slot9 = slot0._resourceLayer:Find("bg/bg/title/lv/current")
	slot10 = slot0._resourceLayer:Find("bg/bg/title/lv/next")

	SetActive(slot0._resourceLayer:Find("icon/" .. slot1:GetKeyWord()), true)
	setText(slot0._resourceLayer:Find("icon/" .. slot1:GetKeyWord() .. "/current"), "Lv." .. slot1:GetLevel())
	eachChild(slot0._resourceLayer:Find("describe"), function (slot0)
		setActive(slot0, false)
	end)
	SetActive(slot0._resourceLayer.Find(slot12, "describe/" .. slot1:GetKeyWord()), true)
	SetActive(slot0._resourceLayer:Find("produce/label/" .. slot1:GetKeyWord()), true)

	slot13 = slot2[slot1:GetLevel()]
	slot14 = slot2[slot2.all[#slot2.all]]

	if slot1.GetLevel() == slot2.all[#slot2.all] then
		SetActive(slot4, false)

		slot3:GetComponent("Button").interactable = false
		slot5.text = "-"
		slot6.text = "-"
		slot9:GetComponent(typeof(Text)).text = "Lv.Max"

		setActive(slot10, false)
		slot0:setBar(slot7, slot13.production, 0, slot14.production, slot13.hour_time)
		slot0:setBar(slot8, slot13.store, 0, slot14.store)
	else
		slot0:setBar(slot7, slot13.production, slot17, slot14.production, slot13.hour_time)
		slot0:setBar(slot8, slot13.store, slot2[slot11 + 1].store - slot13.store, slot14.store)

		slot5.text = (slot13.use[2] <= slot0._player.gold and slot13.use[2]) or "<color=#FB4A2C>" .. slot13.use[2] .. "</color>"
		slot9:GetComponent(typeof(Text)).text = "Lv." .. slot11
		slot10:GetComponent(typeof(Text)).text = "> Lv." .. slot11 + 1

		if slot1:GetUpgradeTimeStamp() == 0 then
			SetActive(slot4, false)
			SetActive(slot3, true)

			slot6.text = pg.TimeMgr.GetInstance():DescCDTime(slot13.time)
			slot3:GetComponent("Button").interactable = true

			onButton(slot0, slot3, function ()
				slot0:emit(NavalAcademyMediator.UPGRADE_FIELD, slot0)
			end, SFX_UI_ACADEMY_LVLUP)
		else
			SetActive(slot4, true)
			SetActive(slot3, false)

			slot3:GetComponent("Button").interactable = false
			slot0._panelTimer[#slot0._panelTimer + 1] = pg.TimeMgr.GetInstance():AddTimer("timer", 0, 1, function ()
				if slot0:GetDuration() and slot0 > 0 then
					slot1.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
				else
					slot2:emit(NavalAcademyMediator.UPGRADE_TIMES_UP, slot0)
				end
			end)
		end
	end

	onButton(slot0, findTF(slot0._resourceLayer, "top/btnBack"), function ()
		slot0:CloseResourcePanel()
	end, SFX_CANCEL)
end

slot0.setSliderValue = function (slot0, slot1, slot2)
	slot1.value = (slot2 == 0 and slot2) or math.max(slot2, 0.08)
end

slot0.setBar = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot1:Find("pre_value"):GetComponent(typeof(Image)).fillAmount = (slot2 + slot3) / slot4
	slot1:Find("value"):GetComponent(typeof(Image)).fillAmount = slot2 / slot4

	if slot5 then
		slot1:Find("current"):GetComponent(typeof(Text)).text = slot2 * slot5 .. "/H"
	else
		slot5 = 1
		slot1:Find("current"):GetComponent(typeof(Text)).text = slot2 .. "/" .. slot4
	end

	slot8 = slot1:Find("advance")

	if slot3 <= 0 then
		SetActive(slot8, false)
	else
		SetActive(slot8, true)

		slot8:GetComponent(typeof(Text)).text = "[+" .. slot3 * slot5 .. "]"
	end
end

slot0.CloseResourcePanel = function (slot0)
	setActive(slot0._topPanel, true)
	SetActive(slot0._resourceLayer, false)
	SetActive(slot0._resourceLayer:Find("icon/canteen"), false)
	SetActive(slot0._resourceLayer:Find("icon/shop"), false)
	SetActive(slot0._resourceLayer:Find("describe/canteen"), false)
	SetActive(slot0._resourceLayer:Find("describe/shop"), false)
	SetActive(slot0._resourceLayer:Find("produce/label/canteen"), false)
	SetActive(slot0._resourceLayer:Find("produce/label/shop"), false)
	slot0:closeSecondPanel()
end

slot0.GetResourceDone = function (slot0, slot1, slot2)
	slot3 = nil

	if slot1 == ResourceField.TYPE_GOLD then
		slot3 = slot0._shop
	elseif slot1 == ResourceField.TYPE_OIL then
		slot3 = slot0._canteen
	end

	SetActive(slot3:Find("popup_contain/popup"), false)

	slot4 = slot3:Find("float")
	slot6 = slot4:GetComponent(typeof(Image))

	SetActive(slot4, true)

	slot4:Find("Text"):GetComponent(typeof(Text)).text = "+" .. slot2
	rtf(slot4).anchoredPosition = Vector2(slot4.localPosition.x, y)

	LeanTween.moveY(rtf(slot4), 100, 4):setOnUpdate(System.Action_float(function (slot0)
		slot1 = Color(1, 1, 1, 1.5 - slot0 * 0.05)
		slot0.color = slot1
		slot1.color = slot1
	end)).setOnComplete(slot8, System.Action(function ()
		SetActive(SetActive, false)

		SetActive.localPosition = SetActive
	end))
end

slot0.openSecondPanel = function (slot0)
	slot0.isOpenSecondPanel = true

	for slot4, slot5 in ipairs(slot0._panelTimer) do
		pg.TimeMgr.GetInstance():RemoveTimer(slot5)
	end

	slot0._panelTimer = {}

	pg.UIMgr.GetInstance():BlurPanel(slot0._blurLayer, false)
end

slot0.closeSecondPanel = function (slot0)
	slot0.isOpenSecondPanel = nil

	pg.UIMgr.GetInstance():UnblurPanel(slot0._blurLayer, slot0._tf)

	for slot4, slot5 in ipairs(slot0._panelTimer) do
		pg.TimeMgr.GetInstance():RemoveTimer(slot5)
	end

	slot0._panelTimer = {}
	slot0._currentState = slot0.STATE_ACADEMY
end

slot0.loadCharacter = function (slot0, slot1, slot2, slot3)
	function slot4(slot0)
		if slot0 == nil then
			PoolMgr.GetInstance():ReturnSpineChar(PoolMgr.GetInstance().ReturnSpineChar, slot0)

			return
		end

		tf(slot0):SetParent(slot0, false)

		tf(slot0).localScale = Vector3(0.5, 0.5, 1)

		pg.ViewUtils.SetLayer(tf(slot0), Layer.UI)
		slot0:GetComponent("SpineAnimUI").SetAction(slot2, slot0.GetComponent("SpineAnimUI") or "stand", 0)

		slot0.GetComponent("SpineAnimUI") or "stand".prefabs = slot0.GetComponent("SpineAnimUI") or "stand".prefabs or {}

		table.insert(slot0.GetComponent("SpineAnimUI") or "stand".prefabs, table.insert)

		table.insert.models = slot0.GetComponent("SpineAnimUI") or "stand".models or {}

		table.insert(slot0.GetComponent("SpineAnimUI") or "stand".models, slot0)
	end

	return function (slot0)
		PoolMgr.GetInstance():GetSpineChar(slot0, true, function (slot0)
			slot0(slot0)
			slot0()
		end)
	end
end

slot0.SetPainting = function (slot0, slot1)
	setPaintingPrefabAsync(slot0._painting, Ship.getPaintingName(slot1), "info")
	onButton(slot0, slot0._painting, function ()
		setButtonEnabled(slot0._painting, false)
		slot0:displayShipWord(slot0.displayShipWord, ({
			"touch",
			"touch2"
		})[math.random(#)])
	end)
end

slot0.RetPainting = function (slot0, slot1)
	retPaintingPrefab(slot0._painting, Ship.getPaintingName(slot1))
end

slot0.displayShipWord = function (slot0, slot1, slot2)
	if not slot0._chatFlag then
		slot0._chatFlag = true

		if slot0._chatTimer then
			slot0._chatTimer:Stop()

			slot0._chatTimer = nil
		end

		slot3, slot4, slot8 = ShipWordHelper.GetWordAndCV(slot1.skinId, slot2)

		setText(slot0._chatText, slot5)

		if CHAT_POP_STR_LEN_SHORT < #slot0._chatText:GetComponent(typeof(Text)).text then
			slot6.alignment = TextAnchor.MiddleLeft
		else
			slot6.alignment = TextAnchor.MiddleCenter
		end

		LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(1, 1, 1), 0.45):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function ()
			LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(0, 0, 1), 0.45):setEase(LeanTweenType.easeInBack):setDelay(2.3):setOnComplete(System.Action(function ()
				slot0._chatFlag = nil

				slot0:startChatTimer(slot0)
				setButtonEnabled(slot0._painting, true)
			end))
		end))
	end
end

slot0.startChatTimer = function (slot0, slot1)
	if slot0._chatFlag then
		return
	end

	if slot0._chatTimer then
		slot0._chatTimer:Stop()

		slot0._chatTimer = nil
	end

	slot0._chatTimer = Timer.New(function ()
		slot0:displayShipWord(slot0, "main")

		slot0.displayShipWord._chatTimer = nil
	end, 10, 1)

	slot0._chatTimer.Start(slot2)
end

slot0.recycleSpineChar = function (slot0)
	if slot0.prefabs and slot0.models then
		for slot4, slot5 in ipairs(slot0.prefabs) do
			slot7 = slot0.models[slot4]

			if slot0.prefabs[slot4] and slot7 then
				PoolMgr.GetInstance():ReturnSpineChar(slot6, slot7)
			end
		end
	end

	slot0.prefabs = nil
	slot0.models = nil
end

slot0.getStudents = function (slot0)
	slot3 = getProxy(TaskProxy)

	_.each(slot5, function (slot0)
		if not slot0:isEnd() then
			slot3 = _.flatten(slot2)
			slot4, slot5 = nil

			if type(slot0:getConfig("config_client")) == "table" then
				for slot9, slot10 in ipairs(slot1) do
					slot0[slot10.id] = Ship.New(slot10)

					if slot9 == 1 then
						slot0[slot10.id].withShipFace = true
						slot11 = {}

						if slot10.type then
							slot11.type = slot10.type
							slot11.param = slot10.param
						end

						slot12, slot13 = getActivityTask(slot0, true)
						slot11.showTips = (slot12 and not slot13) or (slot13 and slot13:isFinish() and not slot13:isReceive())
						slot11.acceptTaskId = slot12
						slot11.currentTask = slot13
						slot1[slot10.id] = slot11
						slot4 = slot11.acceptTaskId
						slot5 = slot11.currentTask
					end

					if slot10.tasks then
						slot0[slot10.id].hide = true
						slot12 = (slot5 and table.indexof(slot3, slot5.id)) or table.indexof(slot3, slot4)

						for slot16, slot17 in ipairs(slot11) do
							if slot17 == slot12 then
								slot0[slot10.id].hide = false

								break
							end
						end
					end
				end
			end
		end
	end)

	return getProxy(NavalAcademyProxy).fillStudens(slot6, {}), {}
end

slot0.updateStudents = function (slot0)
	slot1, slot2 = slot0:getStudents()

	_.each(_.keys(slot0.academyStudents), function (slot0)
		slot3 = slot2.academyStudents[slot0]

		if slot0[slot0] then
			slot3:updateStudent(slot1, slot2)
		else
			slot3:detach()
		end
	end)

	for slot6, slot7 in pairs(slot1) do
		if not slot0.academyStudents[slot6] then
			slot10 = NavalAcademyStudent.New(cloneTplTo(slot0._shipTpl, slot0._map).gameObject)

			slot10:attach()
			slot10:setPathFinder(slot0.academyGraphPath)
			slot10:setCallBack(function (slot0)
				slot0:onStateChange(slot0.onStateChange, slot0)
			end, function (slot0, slot1)
				slot0:onTask(slot1, slot0.onTask)
			end)
			slot10.updateStudent(slot10, slot7, slot2[slot6])

			slot0.academyStudents[slot6] = slot10
		end
	end

	slot0:sortStudents()
end

slot0.updateTrophyReminder = function (slot0)
	setActive(slot0._fountainReminder, slot0._unclaimTrophyCount > 0)
end

slot0.onStateChange = function (slot0, slot1, slot2)
	if slot0.sortTimer then
		slot0.sortTimer:Stop()

		slot0.sortTimer = nil
	end

	if slot2 == NavalAcademyStudent.ShipState.Walk then
		slot0.sortTimer = Timer.New(function ()
			slot0:sortStudents()
		end, 0.2, -1)

		slot0.sortTimer.Start(slot3)
	end
end

slot0.sortStudents = function (slot0)
	slot1 = {
		slot0._fountain
	}

	for slot5, slot6 in pairs(slot0.academyStudents) do
		table.insert(slot1, slot6._tf)
	end

	table.sort(slot1, function (slot0, slot1)
		return slot1.anchoredPosition.y < slot0.anchoredPosition.y
	end)

	slot2 = 6

	for slot6, slot7 in ipairs(slot1) do
		slot7:SetSiblingIndex(slot2)

		slot2 = slot2 + 1
	end
end

slot0.onTask = function (slot0, slot1, slot2)
	slot3 = getProxy(TaskProxy)

	if _.detect(getProxy(ActivityProxy).getActivitiesByType(slot4, ActivityConst.ACTIVITY_TYPE_TASK_LIST), function (slot0)
		return slot0:getTaskShip() and slot1.groupId == slot0.groupId
	end) and not slot6.isEnd(slot6) then
		if slot6.id == ActivityConst.JYHZ_ACTIVITY_ID and slot2.acceptTaskId then
			slot7 = slot3:getAcademyTask(slot1.groupId)

			if slot4:getActivityByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT) and _.detect(slot8:getConfig("config_data"), function (slot0)
				return _.any(pg.chapter_template[slot0].npc_data, function (slot0)
					return pg.npc_squad_template[slot0].task_id == slot0
				end)
			end) and getProxy(ChapterProxy).getChapterById(slot11, slot10).active then
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_target_chapter_in_progress"))

				return
			end
		end

		if slot2.type then
			if slot2.type == 1 then
				Application.OpenURL(slot2.param)
			elseif slot2.type == 2 then
				slot0:emit(NavalAcademyMediator.GO_SCENE, slot2.param)
			elseif slot2.type == 3 then
				slot0:emit(NavalAcademyMediator.OPEN_ACTIVITY_PANEL, tonumber(slot2.param))
			elseif slot2.type == 4 then
				slot0:emit(NavalAcademyMediator.OPEN_ACTIVITY_SHOP)
			elseif slot2.type == 5 then
				slot0:emit(NavalAcademyMediator.OPEN_SCROLL, tonumber(slot2.param))
			end
		elseif not slot2.currentTask and slot2.acceptTaskId then
			if getProxy(PlayerProxy).getRawData(slot7).level < pg.task_data_template[slot2.acceptTaskId].level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("task_level_notenough", slot9.level))

				return
			end

			slot0:emit(NavalAcademyMediator.ACTIVITY_OP, {
				cmd = 1,
				activity_id = slot6.id,
				arg1 = slot2.acceptTaskId
			})
		elseif slot2.currentTask then
			if not slot2.currentTask:isFinish() and slot2.currentTask:getConfig("sub_type") == 29 then
				slot0:emit(NavalAcademyMediator.TASK_GO, {
					taskVO = slot2.currentTask
				})
			elseif not slot2.currentTask:isReceive() then
				slot0:emit(NavalAcademyMediator.GO_TASK_SCENE, {
					page = "activity"
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_work_done"))
		end
	end
end

slot0.clearStudents = function (slot0)
	if slot0.sortTimer then
		slot0.sortTimer:Stop()

		slot0.sortTimer = nil
	end

	for slot4, slot5 in pairs(slot0.academyStudents) do
		slot5:detach()
		Destroy(slot5._go)
	end

	slot0.academyStudents = {}
end

slot0.onBackPressed = function (slot0)
	triggerButton(slot0._backBtn)
end

slot0.willExit = function (slot0)
	if slot0.bulinTip then
		slot0.bulinTip:Destroy()

		slot0.bulinTip = nil
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._blurLayer, slot0._tf)

	for slot4, slot5 in ipairs(slot0._panelTimer) do
		pg.TimeMgr.GetInstance():RemoveTimer(slot5)
	end

	for slot4, slot5 in pairs(slot0._buildingTimers) do
		pg.TimeMgr.GetInstance():RemoveTimer(slot5)
	end

	if slot0._chatTimer then
		slot0._chatTimer:Stop()

		slot0._chatTimer = nil
	end

	if not IsNil(slot0._resourceLayer) then
		setActive(slot0._resourceLayer, false)
	end

	if slot0._resPanel then
		slot0._resPanel:exit()

		slot0._resPanel = nil
	end

	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	slot0:clearStudents()
end

slot0.activeSakura = function (slot0, slot1)
	if slot0.sakura then
		setActive(slot0.sakura, slot1)
	end

	if slot0.wave then
		setActive(slot0.wave, slot1)
	end
end

return slot0

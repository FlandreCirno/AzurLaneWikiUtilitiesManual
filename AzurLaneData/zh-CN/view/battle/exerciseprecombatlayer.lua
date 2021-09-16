slot0 = class("ExercisePreCombatLayer", import("..base.BaseUI"))
slot1 = import("..ship.FormationUI")
slot2 = {
	[99.0] = true
}
slot0.FORM_EDIT = "EDIT"
slot0.FORM_PREVIEW = "PREVIEW"
slot0.ObjectiveList = {
	"battle_preCombatLayer_victory",
	"battle_preCombatLayer_undefeated",
	"battle_preCombatLayer_sink_limit",
	"battle_preCombatLayer_time_hold",
	"battle_preCombatLayer_time_limit",
	"battle_preCombatLayer_boss_destruct",
	"battle_preCombatLayer_damage_before_end",
	"battle_result_defeat_all_enemys",
	"battle_preCombatLayer_destory_transport_ship"
}

slot0.getUIName = function (slot0)
	return "PreCombatUI"
end

slot0.init = function (slot0)
	slot0.eventTriggers = {}
	slot0._startBtn = slot0:findTF("right/start")
	slot0._costContainer = slot0:findTF("right/start/cost_container")
	slot0._popup = slot0._costContainer:Find("popup")
	slot0._ticket = slot0._costContainer:Find("ticket")
	slot0._costText = slot0._popup:Find("Text")
	slot0._moveLayer = slot0:findTF("moveLayer")
	slot1 = slot0:findTF("middle")
	slot0._autoToggle = slot0:findTF("auto_toggle")
	slot0._autoSubToggle = slot0:findTF("sub_toggle_container/sub_toggle")
	slot0._fleetInfo = slot1:Find("fleet_info")
	slot0._fleetNameText = slot1:Find("fleet_info/fleet_name/Text")
	slot0._fleetNumText = slot1:Find("fleet_info/fleet_number")

	setActive(slot0._fleetInfo, slot0.contextData.system ~= SYSTEM_DUEL)

	slot0._mainGS = slot1:Find("gear_score/main/Text")
	slot0._vanguardGS = slot1:Find("gear_score/vanguard/Text")
	slot0._subGS = slot1:Find("gear_score/submarine/Text")
	slot0._gridTFs = {
		vanguard = {},
		main = {}
	}
	slot0._gridFrame = slot1:Find("mask/GridFrame")

	for slot5 = 1, 3, 1 do
		slot0._gridTFs[TeamType.Vanguard][slot5] = slot0._gridFrame:Find("vanguard_" .. slot5)
		slot0._gridTFs[TeamType.Main][slot5] = slot0._gridFrame:Find("main_" .. slot5)
	end

	slot0._nextPage = slot0:findTF("middle/nextPage")
	slot0._prevPage = slot0:findTF("middle/prevPage")
	slot0._heroContainer = slot1:Find("HeroContainer")
	slot0._checkBtn = slot1:Find("checkBtn")
	slot0._blurPanel = slot0:findTF("blur_panel")
	slot0.topPanel = slot0:findTF("top", slot0._blurPanel)
	slot0.topPanelBg = slot0:findTF("top_bg", slot0._blurPanel)
	slot0._backBtn = slot0:findTF("back_btn", slot0.topPanel)
	slot0._playerResOb = slot0:findTF("playerRes", slot0.topPanel)
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)

	slot0._spoilsContainer = slot0:findTF("right/infomation/atlasloot/spoils/items/items_container")
	slot0._item = slot0:getTpl("right/infomation/atlasloot/spoils/items/item_tpl")
	slot0._goals = slot0:findTF("right/infomation/target/goal")
	slot0._heroInfo = slot0:getTpl("heroInfo")
	slot0._starTpl = slot0:getTpl("star_tpl")
	slot0._middle = slot0:findTF("middle")
	slot0._right = slot0:findTF("right")

	setAnchoredPosition(slot0._middle, {
		x = -840
	})
	setAnchoredPosition(slot0._right, {
		x = 470
	})

	slot0.guideDesc = slot0:findTF("guideDesc", slot0._middle)

	if slot0.contextData.stageId then
		slot0:SetStageID(slot0.contextData.stageId)
	end

	slot0._attachmentList = {}
end

slot0.SetPlayerInfo = function (slot0, slot1)
	slot0._resPanel:setResources(slot1)
end

slot0.SetSubFlag = function (slot0, slot1)
	slot0._subUseable = slot1 or false
end

slot0.SetShips = function (slot0, slot1)
	slot0._shipVOs = slot1
end

slot0.SetStageID = function (slot0, slot1)
	removeAllChildren(slot0._spoilsContainer)

	slot0._stageID = slot1
	slot3 = Clone(pg.expedition_data_template[slot1].award_display)

	if checkExist(pg.expedition_activity_template[slot1], {
		"pt_drop_display"
	}) and type(slot4) == "table" then
		slot5 = getProxy(ActivityProxy)

		for slot9 = #slot4, 1, -1 do
			if slot5:getActivityById(slot4[slot9][1]) and not slot10:isEnd() then
				table.insert(slot3, 1, {
					2,
					id2ItemId(slot4[slot9][2])
				})
			end
		end
	end

	if slot0.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
		for slot8, slot9 in ipairs(slot3) do
			updateDrop(slot10, slot11)
			onButton(slot0, cloneTplTo(slot0._item, slot0._spoilsContainer), function ()
				if pg.item_data_statistics[slot0[2]] and slot1[slot0.type] then
					slot2 = {}

					for slot6, slot7 in ipairs(slot1) do
						slot2[#slot2 + 1] = {
							hideName = true,
							type = slot7[1],
							id = slot7[2]
						}
					end

					slot2:emit(slot3.ON_DROP_LIST, {
						item2Row = true,
						itemList = slot2,
						content = slot0.display
					})
				else
					slot2:emit(slot3.ON_DROP, slot4)
				end
			end, SFX_PANEL)
		end
	end

	function slot5(slot0, slot1)
		if type(slot0) == "table" then
			setActive(slot1, true)
			setWidgetText(slot1, i18n(slot0.ObjectiveList[slot0[1]], slot0[2]))
		else
			setActive(slot1, false)
		end
	end

	slot6 = {
		findTF(slot0._goals, "goal_tpl"),
		findTF(slot0._goals, "goal_sink"),
		findTF(slot0._goals, "goal_time")
	}
	slot7 = {
		slot2.objective_1,
		slot2.objective_2,
		slot2.objective_3
	}
	slot8 = 1

	for slot12, slot13 in ipairs(slot7) do
		if type(slot13) ~= "string" then
			slot5(slot13, slot6[slot8])

			slot8 = slot8 + 1
		end
	end

	for slot12 = slot8, #slot6, 1 do
		slot5("", slot6[slot12])
	end

	setActive(slot0.guideDesc, slot2.guide_desc and #slot2.guide_desc > 0)

	if slot2.guide_desc and #slot2.guide_desc > 0 then
		setText(slot0.guideDesc, slot2.guide_desc)
	end
end

slot0.SetFleets = function (slot0, slot1)
	slot2 = _.filter(_.values(slot1), function (slot0)
		return slot0:getFleetType() == FleetType.Normal
	end)
	slot0._fleetVOs = {}

	_.each(slot2, function (slot0)
		slot0._fleetVOs[slot0.id] = slot0
	end)
	slot0.CheckLegalFleet(slot0)
end

slot0.SetCurrentFleet = function (slot0, slot1)
	slot0._currentFleetVO = slot0._fleetVOs[slot1]

	slot0:CheckLegalFleet()

	for slot5, slot6 in ipairs(slot0._legalFleetIdList) do
		if slot0._currentFleetVO.id == slot6 then
			slot0._curFleetIndex = slot5

			break
		end
	end
end

slot0.SetTicketItemID = function (slot0, slot1)
	slot0._ticketItemID = slot1
end

slot0.CheckLegalFleet = function (slot0)
	slot0._legalFleetIdList = {}

	for slot4, slot5 in pairs(slot0._fleetVOs) do
		if #slot5.ships > 0 and slot5.id ~= FleetProxy.PVP_FLEET_ID then
			table.insert(slot0._legalFleetIdList, slot5.id)
		end
	end

	table.sort(slot0._legalFleetIdList)
end

slot0.UpdateFleetView = function (slot0, slot1)
	slot0:displayFleetInfo()
	slot0:resetGrid(TeamType.Vanguard)
	slot0:resetGrid(TeamType.Main)
	SetActive(slot0._gridTFs[TeamType.Main][1]:Find("flag"), true)

	if slot1 then
		slot0:loadAllCharacter()
	else
		slot0:setAllCharacterPos(true)
	end
end

slot0.uiStartAnimating = function (slot0)
	shiftPanel(slot0._middle, 0, nil, slot2, slot1, true, true)
	shiftPanel(slot0._right, 0, nil, 0.3, 0, true, true)
end

slot0.uiExitAnimating = function (slot0)
	shiftPanel(slot0._middle, -840, nil, nil, nil, true, true)
	shiftPanel(slot0._right, 470, nil, nil, nil, true, true)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._backBtn, function ()
		if slot0._currentForm == slot1.FORM_EDIT then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function ()
						slot0:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function ()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							pg.TipsMgr.GetInstance().ShowTips()
						end)
					end,
					onNo = slot0
				})
			end)
		end

		seriesAsync(slot0, function ()
			GetOrAddComponent(slot0._tf, typeof(CanvasGroup)).interactable = false

			slot0:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function ()
				slot0:emit(slot1.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(slot0, slot0._startBtn, function ()
		if slot0._currentForm == slot1.FORM_EDIT then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function ()
						slot0:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function ()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							pg.TipsMgr.GetInstance().ShowTips()
						end)
					end
				})
			end)
		end

		seriesAsync(slot0, function ()
			slot0:emit(ExercisePreCombatMediator.ON_START, slot0._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(slot0, slot0._nextPage, function ()
		slot0:emit(ExercisePreCombatMediator.ON_CHANGE_FLEET, slot0._legalFleetIdList[slot0._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(slot0, slot0._prevPage, function ()
		slot0:emit(ExercisePreCombatMediator.ON_CHANGE_FLEET, slot0._legalFleetIdList[slot0._curFleetIndex - 1])
	end, SFX_PANEL)
	onButton(slot0, slot0._checkBtn, function ()
		if slot0._currentForm == slot1.FORM_EDIT then
			slot0:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function ()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				pg.TipsMgr.GetInstance().ShowTips:swtichToPreviewMode()
			end)
		elseif slot0._currentForm == slot1.FORM_PREVIEW then
			slot0.switchToEditMode(slot0)
		end
	end, SFX_PANEL)

	slot0._currentForm = slot0.contextData.form
	slot0.contextData.form = nil

	slot0.UpdateFleetView(slot0, true)

	if slot0._currentForm == slot0.FORM_EDIT then
		slot0:switchToEditMode()
	else
		slot0:swtichToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)

	if slot0.contextData.system == SYSTEM_DUEL then
		setActive(slot0._autoToggle, false)
		setActive(slot0._autoSubToggle, false)
	else
		setActive(slot0._autoToggle, true)
		onToggle(slot0, slot0._autoToggle, function (slot0)
			slot0:emit(ExercisePreCombatMediator.ON_AUTO, {
				isOn = not slot0,
				toggle = slot0._autoToggle
			})

			if slot0 and slot0._subUseable == true then
				setActive(slot0._autoSubToggle, true)
				onToggle(slot0, slot0._autoSubToggle, function (slot0)
					slot0:emit(ExercisePreCombatMediator.ON_SUB_AUTO, {
						isOn = not slot0,
						toggle = slot0._autoSubToggle
					})
				end, SFX_PANEL, SFX_PANEL)
				triggerToggle(slot0._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
			else
				setActive(slot0._autoSubToggle, false)
			end
		end, SFX_PANEL, SFX_PANEL)
		triggerToggle(slot0._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	end

	onNextTick(function ()
		slot0:uiStartAnimating()
	end)

	if slot0._currentForm == slot0.FORM_PREVIEW and slot0.contextData.system == SYSTEM_DUEL and #slot0._currentFleetVO.mainShips <= 0 then
		triggerButton(slot0._checkBtn)
	end
end

slot0.onBackPressed = function (slot0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(slot0._backBtn)
end

slot0.swtichToPreviewMode = function (slot0)
	slot0._currentForm = slot0.FORM_PREVIEW
	slot0._checkBtn:GetComponent("Button").interactable = true

	setActive(slot0._checkBtn:Find("save"), false)
	setActive(slot0._checkBtn:Find("edit"), true)
	slot0:resetGrid(TeamType.Vanguard)
	slot0:resetGrid(TeamType.Main)
	slot0:setAllCharacterPos(false)
	slot0:disableAllStepper()
	slot0:SetFleetStepper()
	slot0:enabledTeamCharacter(TeamType.Vanguard, false)
	slot0:enabledTeamCharacter(TeamType.Main, false)
end

slot0.switchToEditMode = function (slot0)
	slot0._currentForm = slot0.FORM_EDIT
	slot0._checkBtn:GetComponent("Button").interactable = true

	setActive(slot0._checkBtn:Find("save"), true)
	setActive(slot0._checkBtn:Find("edit"), false)

	if slot0.contextData.system ~= SYSTEM_HP_SHARE_ACT_BOSS and slot0.contextData.system ~= SYSTEM_ACT_BOSS and slot0.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
		slot0:EnableAddGrid(TeamType.Main)
		slot0:EnableAddGrid(TeamType.Vanguard)
	end

	slot1(slot0._characterList.vanguard)
	slot1(slot0._characterList.main)

	slot0._shiftIndex = nil

	slot0:setAllCharacterPos(false)
	slot0:disableAllStepper()
	slot0:enabledTeamCharacter(TeamType.Vanguard, true)
	slot0:enabledTeamCharacter(TeamType.Main, true)
end

slot0.switchToShiftMode = function (slot0, slot1, slot2)
	slot0:disableAllStepper()

	slot0._checkBtn:GetComponent("Button").interactable = false

	for slot6 = 1, 3, 1 do
		setActive(slot0._gridTFs[TeamType.Vanguard][slot6].Find(slot7, "tip"), false)
		setActive(slot0._gridTFs[TeamType.Main][slot6].Find(slot8, "tip"), false)
		setActive(slot0._gridTFs[slot2][slot6]:Find("shadow"), false)
	end

	for slot7, slot8 in ipairs(slot3) do
		if slot8 ~= slot1 then
			LeanTween.moveLocalY(go(slot8), slot0._gridTFs[slot2][slot7].localPosition.y - 80, 0.5)

			slot10 = tf(slot8):Find("mouseChild"):GetComponent("EventTriggerListener")
			slot0.eventTriggers[slot10] = true

			slot10:AddPointEnterFunc(function ()
				for slot3, slot4 in ipairs(ipairs) do
					if slot4 == slot1 then
						slot2:shift(slot2._shiftIndex, slot3, slot3)

						break
					end
				end
			end)
		else
			slot0._shiftIndex = slot7
			tf(slot8):Find("mouseChild"):GetComponent(typeof(Image)).enabled = false
		end

		slot8:GetComponent("SpineAnimUI"):SetAction("normal", 0)
	end
end

slot0.loadAllCharacter = function (slot0)
	removeAllChildren(slot0._heroContainer)

	slot0._characterList = {
		vanguard = {},
		main = {}
	}
	slot0._infoList = {
		vanguard = {},
		main = {}
	}

	function slot1(slot0, slot1, slot2, slot3)
		slot5 = slot0._shipVOs[slot1].getConfigTable(slot4)

		if slot0.exited then
			PoolMgr.GetInstance():ReturnSpineChar(slot4:getPrefab(), slot0)

			return
		end

		for slot10, slot11 in pairs(slot6) do
			if slot11.attachment_combat_ui[1] ~= "" then
				ResourceMgr.Inst:getAssetAsync("Effect/" .. slot12, slot12, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
					if slot0.exited then
					else
						slot1 = Object.Instantiate(slot0)
						slot0._attachmentList[#slot0._attachmentList + 1] = slot1

						tf(slot1):SetParent(tf(slot1))

						tf(slot1).localPosition = BuildVector3(slot2.attachment_combat_ui[2])
					end
				end), true, true)
			end
		end

		slot0._characterList[slot2][slot3] = slot0

		tf(slot0):SetParent(slot0._heroContainer, false)

		tf(slot0).localScale = Vector3(0.65, 0.65, 1)

		pg.ViewUtils.SetLayer(tf(slot0), Layer.UI)

		slot0:GetComponent("SkeletonGraphic").raycastTarget = false

		slot0:enabledCharacter(slot0, slot0._currentForm == slot1.FORM_EDIT, slot0._shipVOs[slot1], slot2)
		slot0:setCharacterPos(slot2, slot3, slot0)
		slot0:sortSiblingIndex()

		slot8 = cloneTplTo(slot0._heroInfo, slot0)

		setAnchoredPosition(slot8, {
			x = 0,
			y = 0
		})

		slot8.localScale = Vector3(2, 2, 1)

		SetActive(slot8, true)

		slot8.name = "info"
		slot10 = findTF(slot0, "stars")
		slot11 = slot0._shipVOs[slot1].energy <= Ship.ENERGY_MID
		slot12 = findTF(slot0, "energy")

		if slot11 then
			slot17, slot14 = slot7:getEnergyPrint()

			if not GetSpriteFromAtlas("energy", slot13) then
				warning("找不到疲劳")
			end

			setImageSprite(slot12, slot15)
		end

		setActive(slot12, slot11 and slot0.contextData.system ~= SYSTEM_DUEL)

		for slot17 = 1, slot7:getStar(), 1 do
			cloneTplTo(slot0._starTpl, slot10)
		end

		if not GetSpriteFromAtlas("shiptype", shipType2print(slot7:getShipType())) then
			warning("找不到船形, shipConfigId: " .. slot7.configId)
		end

		setImageSprite(findTF(slot9, "type"), slot14, true)
		setText(findTF(slot9, "frame/lv_contain/lv"), slot7.level)

		if slot0.contextData.system == SYSTEM_SCENARIO or slot15 == SYSTEM_ROUTINE or slot15 == SYSTEM_ACT_BOSS or slot15 == SYSTEM_SUB_ROUTINE then
			setActive(slot9:Find("expbuff"), getProxy(ActivityProxy).getBuffShipList(slot16)[slot7:getGroupId()] ~= nil)

			if slot18 then
				slot22 = tostring(slot20)

				if slot18 % 100 > 0 then
					slot22 = slot22 .. "." .. tostring(slot21)
				end

				setText(slot19:Find("text"), string.format("EXP +%s%%", slot22))
			end
		else
			setActive(slot9:Find("expbuff"), false)
		end
	end

	slot3(slot0._currentFleetVO.vanguardShips, TeamType.Vanguard)
	slot3(slot0._currentFleetVO.mainShips, TeamType.Main)
	pg.UIMgr.GetInstance():LoadingOn()
	parallelAsync({}, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

slot0.setAllCharacterPos = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._characterList.vanguard) do
		slot0:setCharacterPos(TeamType.Vanguard, slot5, slot6, slot1)
	end

	for slot5, slot6 in ipairs(slot0._characterList.main) do
		slot0:setCharacterPos(TeamType.Main, slot5, slot6, slot1)
	end

	slot0:sortSiblingIndex()
end

slot0.setCharacterPos = function (slot0, slot1, slot2, slot3, slot4)
	SetActive(slot3, true)

	slot6 = slot0._gridTFs[slot1][slot2].localPosition

	LeanTween.cancel(go(slot3))

	if slot4 then
		tf(slot3).localPosition = Vector3(slot6.x + 2, slot6.y - 80, slot6.z)

		LeanTween.moveLocalY(go(slot3), slot6.y - 110, 0.5):setDelay(0.5)
	else
		tf(slot3).localPosition = Vector3(slot6.x + 2, slot6.y - 110, slot6.z)
	end

	SetActive(slot5:Find("shadow"), true)
	slot3:GetComponent("SpineAnimUI"):SetAction("stand", 0)
end

slot0.resetGrid = function (slot0, slot1)
	slot2 = slot0._currentFleetVO:getTeamByName(slot1)

	for slot7, slot8 in ipairs(slot3) do
		SetActive(slot8:Find("shadow"), false)
		SetActive(slot8:Find("tip"), false)
	end
end

slot0.EnableAddGrid = function (slot0, slot1)
	slot3 = slot0._gridTFs[slot1]

	if #slot0._currentFleetVO:getTeamByName(slot1) < 3 then
		slot6 = slot3[slot4 + 1].Find(slot5, "tip")
		slot6:GetComponent("Button").enabled = true

		onButton(slot0, slot6, function ()
			slot0:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIP, nil, slot0._currentFleetVO, slot0)
		end, SFX_UI_FORMATION_ADD)

		slot6.localScale = Vector3(0, 0, 1)

		SetActive(slot6, true)
		LeanTween.value(go(slot6), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
			slot0.localScale = Vector3(slot0, slot0, 1)
		end)).setEase(slot7, LeanTweenType.easeOutBack)
	end
end

slot0.shift = function (slot0, slot1, slot2, slot3)
	slot6 = slot0._currentFleetVO:getTeamByName(slot3)
	tf(slot7).localPosition = Vector3(slot0._gridTFs[slot3][slot1].localPosition.x + 2, slot0._gridTFs[slot3][slot1].localPosition.y - 80, slot0._gridTFs[slot3][slot1].localPosition.z)

	LeanTween.cancel(go(slot0._characterList[slot3][slot2]))

	slot0._characterList[slot3][slot2] = slot0._characterList[slot3][slot1]
	slot0._characterList[slot3][slot1] = slot0._characterList[slot3][slot2]
	slot6[slot2] = slot6[slot1]
	slot6[slot1] = slot6[slot2]
	slot0._shiftIndex = slot2

	slot0:sortSiblingIndex()
end

slot0.sortSiblingIndex = function (slot0)
	slot1 = 3
	slot2 = 0

	while slot1 > 0 do
		slot4 = slot0._characterList[TeamType.Vanguard][slot1]

		if slot0._characterList[TeamType.Main][slot1] then
			tf(slot3):SetSiblingIndex(slot2)

			slot2 = slot2 + 1
		end

		if slot4 then
			tf(slot4):SetSiblingIndex(slot2)

			slot2 = slot2 + 1
		end

		slot1 = slot1 - 1
	end
end

slot0.enabledTeamCharacter = function (slot0, slot1, slot2)
	slot4 = slot0._currentFleetVO:getTeamByName(slot1)

	for slot8, slot9 in ipairs(slot3) do
		slot0:enabledCharacter(slot9, slot2, slot0._shipVOs[slot4[slot8]], slot1)
	end
end

slot0.enabledCharacter = function (slot0, slot1, slot2, slot3, slot4)
	if slot2 then
		slot5, slot6, slot7, slot8 = tf(slot1):Find("mouseChild")

		if slot5 then
			SetActive(slot5, true)
		else
			tf(slot5):SetParent(tf(slot1))

			tf(slot5).localPosition = Vector3.zero
			slot0.eventTriggers[GetOrAddComponent(slot5, "EventTriggerListener")] = true

			GetOrAddComponent(slot5, "ModelDrag").Init(slot6)

			slot9 = GameObject("mouseChild").GetComponent(slot5, typeof(RectTransform))
			slot9.sizeDelta = Vector2(2.5, 2.5)
			slot9.pivot = Vector2(0.5, 0)
			slot9.anchoredPosition = Vector2(0, 0)
			GetOrAddComponent(slot5, "UILongPressTrigger").longPressThreshold = 1

			pg.DelegateInfo.Add(slot0, GetOrAddComponent(slot5, "UILongPressTrigger").onLongPressed)
			GetOrAddComponent(slot5, "UILongPressTrigger").onLongPressed:AddListener(function ()
				slot0:emit(ExercisePreCombatMediator.OPEN_SHIP_INFO, slot1.id, slot0._currentFleetVO)
			end)
			pg.DelegateInfo.Add(slot0, GetOrAddComponent(slot5, "ModelDrag").onModelClick)
			GetOrAddComponent(slot5, "ModelDrag").onModelClick:AddListener(function ()
				if slot0.contextData.system ~= SYSTEM_HP_SHARE_ACT_BOSS and slot0.contextData.system ~= SYSTEM_ACT_BOSS and slot0.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
					pg.CriMgr.GetInstance().PlaySoundEffect_V3:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIP, pg.CriMgr.GetInstance().PlaySoundEffect_V3, slot0._currentFleetVO, )
				end
			end)
			GetOrAddComponent(slot5, "EventTriggerListener").AddBeginDragFunc(slot8, function ()
				screenWidth = UnityEngine.Screen.width
				screenHeight = UnityEngine.Screen.height
				widthRate = rtf(slot0._tf).rect.width / screenWidth
				heightRate = rtf(slot0._tf).rect.height / screenHeight

				LeanTween.cancel(go(go))
				LeanTween.cancel:switchToShiftMode(LeanTween.cancel, )
				LeanTween.cancel:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(LeanTween.cancel.GetComponent("SpineAnimUI")):SetParent(slot0._moveLayer, false)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
			end)
			GetOrAddComponent(slot5, "EventTriggerListener").AddDragFunc(slot8, function (slot0, slot1)
				rtf(slot0).anchoredPosition = Vector2((slot1.position.x - screenWidth / 2) * widthRate + 20, (slot1.position.y - screenHeight / 2) * heightRate - 20)
			end)
			GetOrAddComponent(slot5, "EventTriggerListener").AddDragEndFunc(slot8, function (slot0, slot1)
				slot0:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)

				function slot2()
					tf(tf):SetParent(slot1._heroContainer, false)
					tf(tf):emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, slot1._currentFleetVO)
					tf(tf):switchToEditMode()
					tf(tf):sortSiblingIndex()
				end

				if (slot1.position.x > UnityEngine.Screen.width * 0.65 or slot1.position.y < UnityEngine.Screen.height * 0.25) and slot1.contextData.system ~= SYSTEM_HP_SHARE_ACT_BOSS and slot1.contextData.system ~= SYSTEM_ACT_BOSS and slot1.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
					if not slot1._currentFleetVO.canRemove(slot3, slot2) then
						slot3, slot4 = slot1._currentFleetVO:getShipPos(slot2)

						pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", slot2:getConfigTable().name, slot1._currentFleetVO.name, Fleet.C_TEAM_NAME[slot4]))
						slot2()
					else
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							zIndex = -100,
							hideNo = false,
							content = i18n("battle_preCombatLayer_quest_leaveFleet", slot2:getConfigTable().name),
							onYes = function ()
								for slot4, slot5 in ipairs(slot0) do
									if slot5 == slot2 then
										PoolMgr.GetInstance():ReturnSpineChar(slot3:getPrefab(), slot2)
										table.remove(slot0, slot4)

										break
									end
								end

								slot0:emit(ExercisePreCombatMediator.REMOVE_SHIP, , slot0._currentFleetVO)
								slot0:switchToEditMode()
								slot0:sortSiblingIndex()
							end,
							onNo = slot2
						})
					end
				else
					slot2()
				end

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
			end)
		end
	elseif not IsNil(tf(slot1):Find("mouseChild")) then
		setActive(slot5, false)
	end
end

slot0.displayFleetInfo = function (slot0)
	slot1 = slot0._currentFleetVO:GetPropertiesSum()

	setActive(slot0._costContainer, slot5 ~= SYSTEM_DUEL)
	slot0.tweenNumText(slot0._costText, (pg.battle_cost_template[slot0.contextData.system].oil_cost ~= 0 or 0) and slot0._currentFleetVO:GetCostSum().oil)
	slot0.tweenNumText(slot0._vanguardGS, slot0._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	slot0.tweenNumText(slot0._mainGS, slot0._currentFleetVO:GetGearScoreSum(TeamType.Main))

	slot8 = nil

	if slot0._ticketItemID then
		setImageSprite(slot0._ticket:Find("icon"), GetSpriteFromAtlas(slot8, ""))
	end

	if slot5 == SYSTEM_BOSS_EXPERIMENT then
		setActive(slot0._ticket, true)
		setText(slot0._ticket:Find("Text"), 0)
	elseif slot5 == SYSTEM_HP_SHARE_ACT_BOSS then
		setActive(slot0._ticket, true)
		setText(slot0._ticket:Find("Text"), 1)
	end

	if slot5 == SYSTEM_ACT_BOSS or slot5 == SYSTEM_HP_SHARE_ACT_BOSS or slot5 == SYSTEM_BOSS_EXPERIMENT then
		setText(slot0._fleetNameText, Fleet.DEFAULT_NAME_BOSS_ACT[slot0._currentFleetVO.id])
	else
		setText(slot0._fleetNameText, slot0.defaultFleetName(slot0._currentFleetVO))
	end

	setText(slot0._fleetNumText, slot0._currentFleetVO.id)
end

slot0.SetFleetStepper = function (slot0)
	if slot0.contextData.system ~= SYSTEM_DUEL and slot1 ~= SYSTEM_ACT_BOSS and slot1 ~= SYSTEM_HP_SHARE_ACT_BOSS and slot1 ~= SYSTEM_BOSS_EXPERIMENT then
		SetActive(slot0._nextPage, slot0._curFleetIndex < #slot0._legalFleetIdList)
		SetActive(slot0._prevPage, slot0._curFleetIndex > 1)
	else
		SetActive(slot0._nextPage, false)
		SetActive(slot0._prevPage, false)
	end
end

slot0.disableAllStepper = function (slot0)
	SetActive(slot0._nextPage, false)
	SetActive(slot0._prevPage, false)
end

slot0.recycleCharacterList = function (slot0, slot1, slot2)
	for slot6, slot7 in ipairs(slot1) do
		if slot2[slot6] then
			PoolMgr.GetInstance():ReturnSpineChar(slot0._shipVOs[slot7]:getPrefab(), slot2[slot6])

			slot2[slot6] = nil
		end
	end
end

slot0.willExit = function (slot0)
	if slot0._currentForm == slot0.FORM_EDIT then
		slot1 = getProxy(FleetProxy)
		slot0.contextData.EdittingFleet = slot1.EdittingFleet

		slot1:abortEditting()
	end

	if slot0.eventTriggers then
		for slot4, slot5 in pairs(slot0.eventTriggers) do
			ClearEventTrigger(slot4)
		end

		slot0.eventTriggers = nil
	end

	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
	slot0:recycleCharacterList(slot0._currentFleetVO.mainShips, slot0._characterList[TeamType.Main])
	slot0:recycleCharacterList(slot0._currentFleetVO.vanguardShips, slot0._characterList[TeamType.Vanguard])

	if slot0._resPanel then
		slot0._resPanel:exit()

		slot0._resPanel = nil
	end

	for slot4, slot5 in ipairs(slot0._attachmentList) do
		Object.Destroy(slot5)
	end

	slot0._attachmentList = nil
end

return slot0

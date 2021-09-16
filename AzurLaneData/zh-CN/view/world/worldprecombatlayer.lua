slot0 = class("WorldPreCombatLayer", import("..base.BaseUI"))
slot1 = import("..ship.FormationUI")
slot2 = {
	[99.0] = true
}

slot0.getUIName = function (slot0)
	return "WorldPreCombatUI"
end

slot0.init = function (slot0)
	slot0.eventTriggers = {}
	slot0.middle = slot0:findTF("middle")
	slot0.right = slot0:findTF("right")
	slot0.top = slot0:findTF("top")
	slot0.moveLayer = slot0:findTF("moveLayer")
	slot0.backBtn = slot0.top:Find("back_btn")
	slot0.playerResOb = slot0.top:Find("playerRes")
	slot0.resPanel = WorldResource.New()

	tf(slot0.resPanel._go):SetParent(tf(slot0.playerResOb), false)

	slot0.strategyInfo = slot0:findTF("strategy_info", slot0.top)

	setActive(slot0.strategyInfo, false)

	slot0.mainGS = slot0.middle:Find("gear_score/main/Text")
	slot0.vanguardGS = slot0.middle:Find("gear_score/vanguard/Text")

	setText(slot0.mainGS, 0)
	setText(slot0.vanguardGS, 0)

	slot0.gridTFs = {
		vanguard = {},
		main = {}
	}
	slot0.gridFrame = slot0.middle:Find("mask/GridFrame")

	for slot4 = 1, 3, 1 do
		slot0.gridTFs[TeamType.Vanguard][slot4] = slot0.gridFrame:Find("vanguard_" .. slot4)
		slot0.gridTFs[TeamType.Main][slot4] = slot0.gridFrame:Find("main_" .. slot4)
	end

	slot0.heroContainer = slot0.middle:Find("HeroContainer")
	slot0.strategy = slot0.middle:Find("strategy")

	setActive(slot0.strategy, false)

	slot0.fleet = slot0:findTF("middle/fleet")
	slot0.ship_tpl = findTF(slot0.fleet, "shiptpl")
	slot0.empty_tpl = findTF(slot0.fleet, "emptytpl")

	setActive(slot0.ship_tpl, false)
	setActive(slot0.empty_tpl, false)

	slot0.autoToggle = slot0.right:Find("auto_toggle")
	slot0.autoSubToggle = slot0.right:Find("sub_toggle_container/sub_toggle")
	slot0.startBtn = slot0.right:Find("start")
	slot0.infoBtn = slot0.right:Find("information")
	slot0.heroInfo = slot0:getTpl("heroInfo")
	slot0.starTpl = slot0:getTpl("star_tpl")
	slot0.energyDescTF = slot0:findTF("energy_desc")
	slot0.energyDescTextTF = slot0:findTF("energy_desc/Text")
	slot0.normaltab = slot0.right:Find("normal")
	slot0.informationtab = slot0.right:Find("infomation")
	slot0.buffInfo = slot0.normaltab:Find("buff")
	slot0.bossInfo = slot0.normaltab:Find("boss")
	slot0.spoilsContainer = slot0.normaltab:Find("spoils/items/items_container")
	slot0.spoilsItem = slot0.normaltab:Find("spoils/items/item_tpl")
	slot0.digits = slot0.Clone2Full(slot0.informationtab:Find("target/simple/digits"), 3)
	slot0.digitExtras = slot0.Clone2Full(slot0.informationtab:Find("target/detail"), 3)
	slot0.dropright = slot0.informationtab:Find("spoils/right")
	slot0.dropleft = slot0.informationtab:Find("spoils/left")
	slot0.dropitems = slot0.Clone2Full(slot0.informationtab:Find("spoils/items_container"), 3)

	setActive(slot0.informationtab:Find("target/simple"), true)
	setActive(slot0.informationtab:Find("target/detail"), false)

	for slot4 = 1, #slot0.digitExtras, 1 do
		setText(slot0.digitExtras[slot4].Find(slot5, "desc"), i18n("world_mapbuff_compare_txt") .. "：")
	end
end

slot0.uiStartAnimating = function (slot0)
	setAnchoredPosition(slot0.middle, {
		x = -840
	})
	setAnchoredPosition(slot0.right, {
		x = 470
	})
	setAnchoredPosition(slot0.top, {
		y = slot0.top.rect.height
	})
	shiftPanel(slot0.middle, 0, nil, slot2, slot1, true, true)
	shiftPanel(slot0.right, 0, nil, slot2, slot1, true, true, nil)
	shiftPanel(slot0.top, nil, 0, 0.3, 0, true, true, nil, nil)
end

slot0.uiExitAnimating = function (slot0)
	shiftPanel(slot0.middle, -840, nil, slot2, slot1, true, true)
	shiftPanel(slot0.right, 470, nil, slot2, slot1, true, true)
	shiftPanel(slot0.top, nil, slot0.top.rect.height, 0.3, 0, true, true, nil, nil)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		GetOrAddComponent(slot0._tf, typeof(CanvasGroup)).interactable = false

		slot0:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function ()
			slot0:emit(slot1.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onToggle(slot0, slot0.autoToggle, function (slot0)
		slot0:emit(WorldPreCombatMediator.OnAuto, {
			isOn = not slot0,
			toggle = slot0.autoToggle
		})

		if slot0 and nowWorld:GetSubAidFlag() then
			setActive(slot0.autoSubToggle, true)
			onToggle(slot0, slot0.autoSubToggle, function (slot0)
				slot0:emit(WorldPreCombatMediator.OnSubAuto, {
					isOn = not slot0,
					toggle = slot0.autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(slot0.autoSubToggle, ys.Battle.BattleState.IsAutoSubActive(SYSTEM_WORLD))
		else
			setActive(slot0.autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance().OverlayPanel(slot1, slot0._tf)
	slot0:updateCharacters()
	slot0:updateStageView()
	triggerToggle(slot0.autoToggle, ys.Battle.BattleState.IsAutoBotActive(SYSTEM_WORLD))

	slot3 = pg.expedition_data_template[slot0:GetCurrentAttachment().GetBattleStageId(slot1)]
	slot5 = pg.world_expedition_data[slot0.GetCurrentAttachment().GetBattleStageId(slot1)] and slot4.battle_type and slot4.battle_type ~= 0

	onNextTick(function ()
		slot0:uiStartAnimating()
	end)

	slot0.contextData.entetagain = true

	setActive(slot0.infoBtn, slot5)
	onButton(slot0, slot0.infoBtn, function ()
		slot0:emit(WorldPreCombatMediator.OnOpenSublayer, Context.New({
			mediator = WorldBossInformationMediator,
			viewComponent = WorldBossInformationLayer
		}), true, function ()
			slot0:closeView()
		end)
	end)
	onButton(slot0, slot0.startBtn, function ()
		slot0:emit(WorldPreCombatMediator.OnStartBattle, slot1:GetBattleStageId(), slot0:getCurrentFleet(), slot0)
	end, SFX_UI_WEIGHANCHOR)
end

slot0.onBackPressed = function (slot0)
	if slot0.strategyPanel and slot0.strategyPanel._go and isActive(slot0.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		slot0:hideStrategyInfo()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(slot0.backBtn)
	end
end

slot0.setPlayerInfo = function (slot0, slot1)
	slot0.resPanel:setPlayer(slot1)
	setActive(slot0.resPanel._tf, nowWorld:IsSystemOpen(WorldConst.SystemResource))
end

slot0.getCurrentFleet = function (slot0)
	return nowWorld:GetFleet()
end

slot0.GetCurrentAttachment = function (slot0)
	slot1 = nowWorld:GetActiveMap()

	return slot1:GetCell(slot1:GetFleet().row, slot1.GetFleet().column).GetAliveAttachment(slot3), slot1.config.difficulty
end

slot0.updateStageView = function (slot0)
	slot3 = pg.expedition_data_template[slot0:GetCurrentAttachment().GetBattleStageId(slot1)]
	slot5 = pg.world_expedition_data[slot0.GetCurrentAttachment().GetBattleStageId(slot1)] and slot4.battle_type and slot4.battle_type ~= 0

	setActive(slot0.normaltab, false)
	setActive(slot0.informationtab, true)
	slot0:UpdateInformationtab()
end

slot0.UpdateNormaltab = function (slot0)
	slot4, slot2 = slot0:GetCurrentAttachment()
	slot4 = pg.expedition_data_template[slot1:GetBattleStageId()]
	slot6 = {}

	for slot10, slot11 in ipairs(pg.world_expedition_data[slot1.GetBattleStageId()].award_display_world) do
		if slot2 == slot11[1] then
			slot6 = slot11[2]
		end
	end

	slot7 = UIItemList.New(slot0.spoilsContainer, slot0.spoilsItem)

	slot7:make(function (slot0, slot1, slot2)
		updateDrop(slot3, slot5)
		onButton(slot1, slot2, function ()
			slot0:emit(slot1.ON_DROP, )
		end, SFX_PANEL)
	end)
	slot7.align(slot7, #slot6)
end

slot3 = "fe2222"
slot4 = "92fc63"

slot0.UpdateInformationtab = function (slot0)
	slot4, slot2 = slot0:GetCurrentAttachment()
	slot4 = pg.expedition_data_template[slot1:GetBattleStageId()]
	slot5 = pg.world_expedition_data[slot1.GetBattleStageId()]

	for slot9 = 1, #slot0.digits, 1 do
		slot10 = slot0.digits[slot9]
	end

	slot6 = {}

	for slot10, slot11 in ipairs(slot5.award_display_world) do
		if slot2 == slot11[1] then
			slot6 = slot11[2]
		end
	end

	slot7 = 0

	function slot8()
		for slot3 = 1, #slot0.dropitems, 1 do
			setActive(slot0.dropitems[slot3]:Find("item_tpl"), slot1[slot3 + slot2] ~= nil)

			if slot5 then
				updateDrop(slot4, slot6)
				onButton(slot0, slot4, function ()
					slot0:emit(slot1.ON_DROP, )
				end, SFX_PANEL)
			end
		end

		slot0(slot0.dropleft, slot2 > 0)
		slot0(slot0.dropleft, #slot0.dropleft -  > #slot0.dropitems)
	end

	onButton(slot0, slot0.dropright, function ()
		slot0 = slot0 + 1

		slot1()
	end)
	onButton(slot0, slot0.dropleft, function ()
		slot0 = slot0 - 1

		slot1()
	end)
	slot8()

	slot10 = nowWorld:GetWorldMapDifficultyBuffLevel()
	slot17[1], slot17[2], slot15 = ys.Battle.BattleFormulas.WorldMapRewardAttrEnhance(slot11, slot12)
	slot17 = {
		slot13,
		slot14,
		1 - ys.Battle.BattleFormulas.WorldMapRewardHealingRate(slot11, slot12)
	}

	for slot21 = 1, #slot0.digits, 1 do
		setText(slot0.digits[slot21].Find(slot22, "digit"), string.format("%d", slot11[slot21]))
		setText(slot22:Find("desc"), i18n("world_mapbuff_attrtxt_" .. slot21) .. string.format("%3d%%", ((slot21 == 3 and 1 - slot17[slot21]) or slot17[slot21] + 1) * 100))
	end

	for slot21 = 1, #slot0.digitExtras, 1 do
		setText(slot0.digitExtras[slot21].Find(slot22, "enemy"), string.format("%d", slot11[slot21]))
		setText(slot0.digitExtras[slot21].Find(slot22, "ally"), string.format("%d", slot12[slot21]))
		setText(slot0.digitExtras[slot21].Find(slot22, "result"), string.format("%d%%", slot17[slot21] * 100))
		setTextColor(slot0.digitExtras[slot21].Find(slot22, "result"), (slot17[slot21] > 0 and slot0.TransformColor(slot1)) or slot0.TransformColor(slot2))
		setText(slot22:Find("result/arrow"), (slot17[slot21] == 0 and "") or (slot17[slot21] > 0 and "↑") or "↓")

		if slot17[slot21] ~= 0 then
			setTextColor(slot22:Find("result/arrow"), (slot17[slot21] > 0 and slot0.TransformColor(slot1)) or slot0.TransformColor(slot2))
		end
	end

	onButton(slot0, slot0.informationtab:Find("target/bg"), function ()
		slot0 = slot0.informationtab:Find("target/simple")

		setActive(slot0, not go(slot0).activeSelf)
		setActive(slot0.informationtab:Find("target/detail"), go(slot0).activeSelf)
	end, SFX_PANEL)
end

slot0.updateCharacters = function (slot0)
	pg.UIMgr.GetInstance():LoadingOn()
	slot0:resetGrid(TeamType.Vanguard)
	slot0:resetGrid(TeamType.Main)
	slot0:loadAllCharacter(function ()
		slot0:updateFleetView()
		slot0.updateFleetView:displayFleetInfo()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

slot0.flushCharacters = function (slot0)
	slot0:resetGrid(TeamType.Vanguard)
	slot0:resetGrid(TeamType.Main)
	slot0:setAllCharacterPos(true)
	slot0:updateFleetView()
end

slot0.updateFleetView = function (slot0)
	slot2 = slot0.getCurrentFleet(slot0)

	slot1(slot0.fleet:Find("main"), slot2:GetTeamShipVOs(TeamType.Main, true))
	function (slot0, slot1)
		removeAllChildren(slot0)

		for slot5 = 1, 3, 1 do
			if slot1[slot5] then
				slot6 = cloneTplTo(slot0.ship_tpl, slot0)

				updateShip(slot6, slot1[slot5])

				slot7 = WorldConst.FetchWorldShip(slot1[slot5].id)
				slot8 = slot7:IsHpSafe()
				slot10 = findTF(slot6, "blood")

				setActive(slot11, slot8)
				setActive(findTF(slot6, "blood/fillarea/red"), not slot8)

				(slot8 and slot11) or slot12:GetComponent("Image").fillAmount = slot7.hpRant * 0.0001

				setActive(slot6:Find("broken"), slot7:IsBroken())
				setActive(slot6:Find("mask"), not slot7:IsAlive())
			end
		end
	end(slot0.fleet:Find("vanguard"), slot2:GetTeamShipVOs(TeamType.Vanguard, true))
end

slot0.loadAllCharacter = function (slot0, slot1)
	removeAllChildren(slot0.heroContainer)

	slot0.characterList = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {}
	}

	function slot2(slot0, slot1, slot2, slot3)
		if slot0.exited then
			PoolMgr.GetInstance():ReturnSpineChar(slot1:getPrefab(), slot0)

			return
		end

		slot4 = WorldConst.FetchWorldShip(slot1.id)
		slot0.characterList[slot2][slot3] = slot0

		tf(slot0):SetParent(slot0.heroContainer, false)

		tf(slot0).localScale = Vector3(0.65, 0.65, 1)

		pg.ViewUtils.SetLayer(tf(slot0), Layer.UI)
		slot0:enabledCharacter(slot0, true, slot2)
		slot0:setCharacterPos(slot2, slot3, slot0)
		slot0:sortSiblingIndex()

		slot5 = cloneTplTo(slot0.heroInfo, slot0)

		setAnchoredPosition(slot5, {
			x = 0,
			y = 0
		})

		slot5.localScale = Vector3(2, 2, 1)

		SetActive(slot5, true)

		slot5.name = "info"
		slot7 = findTF(slot6, "stars")
		slot8 = slot1:getEnergy() <= Ship.ENERGY_MID
		slot9 = findTF(slot6, "energy")

		if slot8 then
			slot14, slot11 = slot1:getEnergyPrint()

			if not GetSpriteFromAtlas("energy", slot10) then
				warning("找不到疲劳")
			end

			setImageSprite(slot9, slot12)
		end

		setActive(slot9, slot8)

		for slot14 = 1, slot1:getStar(), 1 do
			cloneTplTo(slot0.starTpl, slot7)
		end

		if not GetSpriteFromAtlas("shiptype", shipType2print(slot1:getShipType())) then
			warning("找不到船形, shipConfigId: " .. slot1.configId)
		end

		setImageSprite(findTF(slot6, "type"), slot11, true)
		setText(findTF(slot6, "frame/lv_contain/lv"), slot1.level)

		slot12 = slot4:IsHpSafe()
		slot13 = findTF(slot6, "blood")

		setActive(slot14, slot12)
		setActive(slot15, not slot12)

		slot13:GetComponent(typeof(Slider)).fillRect = (slot12 and slot14) or slot15

		setSlider(slot13, 0, 10000, slot4.hpRant)
		setActive(slot13:Find("broken"), slot4:IsBroken())
		setActive(slot6:Find("expbuff"), getProxy(ActivityProxy):getBuffShipList()[slot1:getGroupId()] ~= nil)

		if slot17 then
			slot21 = tostring(slot19)

			if slot17 % 100 > 0 then
				slot21 = slot21 .. "." .. tostring(slot20)
			end

			setText(slot18:Find("text"), string.format("EXP +%s%%", slot21))
		end
	end

	slot4(TeamType.Vanguard)
	slot4(TeamType.Main)
	seriesAsync({}, function (slot0)
		if slot0.exited then
			return
		end

		if slot1 then
			slot1()
		end
	end)
end

slot0.showEnergyDesc = function (slot0, slot1, slot2)
	if LeanTween.isTweening(go(slot0.energyDescTF)) then
		LeanTween.cancel(go(slot0.energyDescTF))

		slot0.energyDescTF.localScale = Vector3.one
	end

	setText(slot0.energyDescTextTF, slot2)

	slot0.energyDescTF.position = slot1

	setActive(slot0.energyDescTF, true)
	LeanTween.scale(slot0.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function ()
		slot0.energyDescTF.localScale = Vector3.one

		setActive(slot0.energyDescTF, false)
	end))
end

slot0.setAllCharacterPos = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.characterList[TeamType.Vanguard]) do
		slot0:setCharacterPos(TeamType.Vanguard, slot5, slot6, slot1)
	end

	for slot5, slot6 in ipairs(slot0.characterList[TeamType.Main]) do
		slot0:setCharacterPos(TeamType.Main, slot5, slot6, slot1)
	end

	slot0:sortSiblingIndex()
end

slot0.setCharacterPos = function (slot0, slot1, slot2, slot3, slot4)
	SetActive(slot3, true)

	slot6 = slot0.gridTFs[slot1][slot2].localPosition

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
	for slot6, slot7 in ipairs(slot2) do
		SetActive(slot7:Find("shadow"), false)
	end
end

slot0.switchToEditMode = function (slot0)
	slot1(slot0.characterList[TeamType.Vanguard])
	slot1(slot0.characterList[TeamType.Main])

	slot0._shiftIndex = nil

	slot0:flushCharacters()
end

slot0.switchToShiftMode = function (slot0, slot1, slot2)
	for slot6 = 1, 3, 1 do
		setActive(slot0.gridTFs[TeamType.Vanguard][slot6].Find(slot7, "tip"), false)
		setActive(slot0.gridTFs[TeamType.Main][slot6].Find(slot8, "tip"), false)
		setActive(slot0.gridTFs[slot2][slot6]:Find("shadow"), false)
	end

	for slot7, slot8 in ipairs(slot3) do
		if slot8 ~= slot1 then
			LeanTween.moveLocalY(go(slot8), slot0.gridTFs[slot2][slot7].localPosition.y - 80, 0.5)

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

slot0.shift = function (slot0, slot1, slot2, slot3)
	tf(slot6).localPosition = Vector3(slot0.gridTFs[slot3][slot1].localPosition.x + 2, slot0.gridTFs[slot3][slot1].localPosition.y - 80, slot0.gridTFs[slot3][slot1].localPosition.z)

	LeanTween.cancel(go(slot6))

	slot0.characterList[slot3][slot2] = slot0.characterList[slot3][slot1]
	slot0.characterList[slot3][slot1] = slot0.characterList[slot3][slot2]
	slot9 = slot0:getCurrentFleet()

	slot9:SwitchShip(slot9:GetTeamShips(slot3, false)[slot1].id, slot9.GetTeamShips(slot3, false)[slot2].id)

	slot0._shiftIndex = slot2

	slot0:sortSiblingIndex()
end

slot0.sortSiblingIndex = function (slot0)
	slot1 = 3
	slot2 = 0

	while slot1 > 0 do
		slot4 = slot0.characterList[TeamType.Vanguard][slot1]

		if slot0.characterList[TeamType.Main][slot1] then
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
	for slot7, slot8 in ipairs(slot3) do
		slot0:enabledCharacter(slot8, slot2, slot1)
	end
end

slot0.enabledCharacter = function (slot0, slot1, slot2, slot3)
	if slot2 then
		slot4, slot5, slot6 = tf(slot1):Find("mouseChild")

		if slot4 then
			SetActive(slot4, true)
		else
			tf(slot4):SetParent(tf(slot1))

			tf(slot4).localPosition = Vector3.zero
			slot0.eventTriggers[GetOrAddComponent(slot4, "EventTriggerListener")] = true

			GetOrAddComponent(slot4, "ModelDrag").Init(slot5)

			slot7 = GameObject("mouseChild").GetComponent(slot4, typeof(RectTransform))
			slot7.sizeDelta = Vector2(2.5, 2.5)
			slot7.pivot = Vector2(0.5, 0)
			slot7.anchoredPosition = Vector2(0, 0)
			slot8, slot9, slot10, slot11 = nil

			GetOrAddComponent(slot4, "EventTriggerListener").AddBeginDragFunc(slot6, function ()
				slot0 = UnityEngine.Screen.width
				slot1 = UnityEngine.Screen.height
				slot2 = rtf(slot3._tf).rect.width / 
				slot4 = rtf(slot3._tf).rect.height / slot3._tf

				LeanTween.cancel(go(slot5))
				slot3:switchToShiftMode(slot5, slot6)
				slot5:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(slot5):SetParent(slot3.moveLayer, false)
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_DRAG)
			end)
			GetOrAddComponent(slot4, "EventTriggerListener").AddDragFunc(slot6, function (slot0, slot1)
				rtf(slot0).anchoredPosition = Vector2((slot1.position.x - slot1 / 2) * slot2 + 20, (slot1.position.y - slot3 / 2) * ((slot1.position.x - slot1 / 2) * slot2 + 20) - 20)
			end)
			GetOrAddComponent(slot4, "EventTriggerListener").AddDragEndFunc(slot6, function (slot0, slot1)
				slot0:GetComponent("SpineAnimUI"):SetAction("tuozhuai", 0)
				tf(slot0):SetParent(slot1.heroContainer, false)
				slot1:switchToEditMode()
				slot1:sortSiblingIndex()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_HOME_PUT)
			end)
		end
	else
		SetActive(tf(slot1):Find("mouseChild"), false)
	end
end

slot0.displayFleetInfo = function (slot0)
	slot1 = slot0:getCurrentFleet()
	slot2 = _.reduce(slot1:GetTeamShipVOs(TeamType.Vanguard, false), 0, function (slot0, slot1)
		return slot0 + slot1:getShipCombatPower()
	end)

	slot0.tweenNumText(slot0.vanguardGS, slot2)
	slot0.tweenNumText(slot0.mainGS, _.reduce(slot1.GetTeamShipVOs(slot1, TeamType.Main, false), 0, function (slot0, slot1)
		return slot0 + slot1:getShipCombatPower()
	end))
end

slot0.hideStrategyInfo = function (slot0)
	if slot0.strategyPanel then
		slot0.strategyPanel:detach()
	end
end

slot0.recycleCharacterList = function (slot0, slot1, slot2)
	for slot6, slot7 in ipairs(slot1) do
		if slot2[slot6] then
			PoolMgr.GetInstance():ReturnSpineChar(slot7:getPrefab(), slot2[slot6])

			slot2[slot6] = nil
		end
	end
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)

	if slot0.resPanel then
		slot0.resPanel:exit()

		slot0.resPanel = nil
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

	slot1 = slot0:getCurrentFleet()

	slot0:recycleCharacterList(slot1:GetTeamShipVOs(TeamType.Main, false), slot0.characterList[TeamType.Main])
	slot0:recycleCharacterList(slot1:GetTeamShipVOs(TeamType.Vanguard, false), slot0.characterList[TeamType.Vanguard])
end

slot0.Clone2Full = function (slot0, slot1)
	slot2 = {}
	slot3 = slot0:GetChild(0)

	for slot8 = 0, slot0.childCount - 1, 1 do
		table.insert(slot2, slot0:GetChild(slot8))
	end

	for slot8 = slot4, slot1 - 1, 1 do
		table.insert(slot2, tf(cloneTplTo(slot3, slot0)))
	end

	return slot2
end

slot0.TransformColor = function (slot0)
	return Color.New(tonumber(string.sub(slot0, 1, 2), 16) / 255, tonumber(string.sub(slot0, 3, 4), 16) / 255, tonumber(string.sub(slot0, 5, 6), 16) / 255)
end

return slot0

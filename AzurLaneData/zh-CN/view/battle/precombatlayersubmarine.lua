slot0 = class("PreCombatLayerSubmarine", import(".PreCombatLayer"))
slot1 = import("..ship.FormationUI")
slot0.FORM_EDIT = "EDIT"
slot0.FORM_PREVIEW = "PREVIEW"

slot0.getUIName = function (slot0)
	return "PreCombatUI"
end

slot0.init = function (slot0)
	slot0.super.init(slot0)

	slot1 = slot0:findTF("middle")

	SetActive(slot2, false)
	SetActive(slot0._gridFrame, false)
	SetActive(slot1:Find("gear_score/main"), false)
	SetActive(slot1:Find("gear_score/vanguard"), false)
	SetActive(slot1:Find("gear_score/submarine"), true)

	slot0._subFrame = slot1:Find("mask/bg_sub")

	SetActive(slot0._subFrame, true)

	slot0._gridTFs = {
		[TeamType.Submarine] = {}
	}

	for slot6 = 1, 3, 1 do
		slot0._gridTFs[TeamType.Submarine][slot6] = slot0._subFrame:Find("submarine_" .. slot6)
	end
end

slot0.SetFleets = function (slot0, slot1)
	slot2 = _.filter(_.values(slot1), function (slot0)
		return slot0:getFleetType() == FleetType.Submarine
	end)
	slot0._fleetVOs = {}
	slot0._fleetIDList = {}

	_.each(slot2, function (slot0)
		if #slot0.ships > 0 then
			slot0._fleetVOs[slot0.id] = slot0

			table.insert(slot0._fleetIDList, slot0.id)

			slot1 = table.insert + 1
		end
	end)

	if 0 == 0 then
		slot0._fleetVOs[11] = slot2[1]

		table.insert(slot0._fleetIDList, 11)
	else
		table.sort(slot0._fleetIDList, function (slot0, slot1)
			return slot0 < slot1
		end)
	end
end

slot0.SetCurrentFleet = function (slot0, slot1)
	slot0._currentFleetVO = slot0._fleetVOs[slot1 or slot0._fleetIDList[1]]
end

slot0.UpdateFleetView = function (slot0, slot1)
	slot0:displayFleetInfo()
	slot0:resetGrid(TeamType.Submarine)

	if slot1 then
		slot0:loadAllCharacter()
	else
		slot0:setAllCharacterPos(true)
	end
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._backBtn, function ()
		if slot0._currentForm == slot1.FORM_EDIT and slot0._editedFlag then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function ()
						slot0:emit(PreCombatMediator.ON_COMMIT_EDIT, function ()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							pg.TipsMgr.GetInstance().ShowTips()
						end)
					end,
					onNo = function ()
						slot0:emit(PreCombatMediator.ON_ABORT_EDIT)
						slot0()
					end
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
		if slot0._currentForm == slot1.FORM_EDIT and slot0._editedFlag then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function ()
						slot0:emit(PreCombatMediator.ON_COMMIT_EDIT, function ()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							pg.TipsMgr.GetInstance().ShowTips()
						end)
					end
				})
			end)
		end

		seriesAsync(slot0, function ()
			slot0:emit(PreCombatMediator.ON_START, slot0._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(slot0, slot0._nextPage, function ()
		if slot0:getNextFleetID() then
			slot0:emit(PreCombatMediator.ON_CHANGE_FLEET, slot0, true)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._prevPage, function ()
		if slot0:getPrevFleetID() then
			slot0:emit(PreCombatMediator.ON_CHANGE_FLEET, slot0, true)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._checkBtn, function ()
		if slot0._currentForm == slot1.FORM_EDIT then
			slot0:emit(PreCombatMediator.ON_COMMIT_EDIT, function ()
				if slot0._editedFlag then
					pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				end

				slot0:swtichToPreviewMode()
			end)
		elseif slot0._currentForm == slot1.FORM_PREVIEW then
			slot0.switchToEditMode(slot0)
		end
	end, SFX_PANEL)

	slot0._editedFlag = slot0.contextData.form == slot0.FORM_EDIT

	slot0.UpdateFleetView(slot0, true)

	if slot0.contextData.form == slot0.FORM_EDIT then
		slot0:switchToEditMode()
	else
		slot0:swtichToPreviewMode()
	end

	slot0.contextData.form = nil

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._autoToggle, false)
	setActive(slot0._autoSubToggle, false)
	onNextTick(function ()
		slot0:uiStartAnimating()
	end)

	if slot0._currentForm == slot0.FORM_PREVIEW and slot0.contextData.system == SYSTEM_DUEL and #slot0._currentFleetVO.mainShips <= 0 then
		triggerButton(slot0._checkBtn)
	end
end

slot0.getNextFleetID = function (slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0._fleetIDList) do
		if slot6 == slot0._currentFleetVO.id then
			slot1 = slot5

			break
		end
	end

	return slot0._fleetIDList[slot1 + 1]
end

slot0.getPrevFleetID = function (slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0._fleetIDList) do
		if slot6 == slot0._currentFleetVO.id then
			slot1 = slot5

			break
		end
	end

	return slot0._fleetIDList[slot1 - 1]
end

slot0.swtichToPreviewMode = function (slot0)
	slot0._editedFlag = nil
	slot0._currentForm = slot0.FORM_PREVIEW
	slot0._checkBtn:GetComponent("Button").interactable = true

	setActive(slot0._checkBtn:Find("save"), false)
	setActive(slot0._checkBtn:Find("edit"), true)
	slot0:resetGrid(TeamType.Submarine)
	slot0:setAllCharacterPos(false)
	slot0:disableAllStepper()
	slot0:SetFleetStepper()
	slot0:enabledTeamCharacter(TeamType.Submarine, false)
end

slot0.switchToEditMode = function (slot0)
	slot0._currentForm = slot0.FORM_EDIT
	slot0._checkBtn:GetComponent("Button").interactable = true

	setActive(slot0._checkBtn:Find("save"), true)
	setActive(slot0._checkBtn:Find("edit"), false)
	slot0:EnableAddGrid(TeamType.Submarine)

	function slot1(slot0)
		for slot4, slot5 in ipairs(slot0) do
			if tf(slot5):Find("mouseChild") then
				if slot6:GetComponent("EventTriggerListener") then
					slot0.eventTriggers[slot7] = true

					slot7:RemovePointEnterFunc()
				end

				if slot4 == slot0._shiftIndex then
					slot6:GetComponent(typeof(Image)).enabled = true
				end
			end
		end
	end

	slot1(slot0._characterList[TeamType.Submarine])

	slot0._shiftIndex = nil

	slot0:setAllCharacterPos(false)
	slot0:disableAllStepper()
	slot0:enabledTeamCharacter(TeamType.Submarine, true)
end

slot0.switchToShiftMode = function (slot0, slot1, slot2)
	slot0:disableAllStepper()

	slot0._checkBtn:GetComponent("Button").interactable = false

	for slot6 = 1, 3, 1 do
		setActive(slot0._gridTFs[TeamType.Submarine][slot6].Find(slot7, "tip"), false)
		setActive(slot0._gridTFs[slot2][slot6]:Find("shadow"), false)
	end

	for slot7, slot8 in ipairs(slot3) do
		if slot8 ~= slot1 then
			LeanTween.moveLocalY(go(slot8), slot0._gridTFs[slot2][slot7].localPosition.y + 80, 0.5)

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
		[TeamType.Submarine] = {}
	}
	slot0._infoList = {
		[TeamType.Submarine] = {}
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

		slot0:enabledCharacter(slot0, tobool(slot0._editedFlag), slot7, slot2)
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
		slot10 = findTF(slot9, "stars")
		slot11 = slot0._shipVOs[slot1].energy <= Ship.ENERGY_MID
		slot12 = findTF(slot9, "energy")

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
		setActive(slot9:Find("expbuff"), getProxy(ActivityProxy).getBuffShipList(slot15)[slot7:getGroupId()] ~= nil)

		if slot17 then
			slot21 = tostring(slot19)

			if slot17 % 100 > 0 then
				slot21 = slot21 .. "." .. tostring(slot20)
			end

			setText(slot18:Find("text"), string.format("EXP +%s%%", slot21))
		end
	end

	function slot3(slot0, slot1)
		for slot5, slot6 in ipairs(slot0) do
			slot7 = slot0._shipVOs[slot6]:getPrefab()

			table.insert(slot1, function (slot0)
				PoolMgr.GetInstance():GetSpineChar(slot0, true, function (slot0)
					slot0(slot0, slot0, , )
					slot0()
				end)
			end)
		end
	end

	slot3(slot0._currentFleetVO.subShips, TeamType.Submarine)
	pg.UIMgr.GetInstance():LoadingOn()
	parallelAsync({}, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

slot0.setAllCharacterPos = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._characterList[TeamType.Submarine]) do
		slot0:setCharacterPos(TeamType.Submarine, slot5, slot6, slot1)
	end

	slot0:sortSiblingIndex()
end

slot0.setCharacterPos = function (slot0, slot1, slot2, slot3, slot4)
	SetActive(slot3, true)

	slot6 = slot0._gridTFs[slot1][slot2].position

	LeanTween.cancel(go(slot3))

	if slot4 then
		tf(slot3).position = Vector3(slot6.x, slot6.y + 0.9, slot6.z)

		LeanTween.moveY(go(slot3), slot6.y, 0.5):setDelay(0.5)
	else
		tf(slot3).position = Vector3(slot6.x, slot6.y, slot6.z)
	end

	SetActive(slot5:Find("shadow"), true)
	slot3:GetComponent("SpineAnimUI"):SetAction("stand", 0)
end

slot0.shift = function (slot0, slot1, slot2, slot3)
	slot6 = slot0._currentFleetVO:getTeamByName(slot3)
	tf(slot7).position = Vector3(slot0._gridTFs[slot3][slot1].position.x, slot0._gridTFs[slot3][slot1].position.y + 0.9, slot0._gridTFs[slot3][slot1].position.z)

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
		if slot0._characterList[TeamType.Submarine][slot1] then
			tf(slot3):SetSiblingIndex(slot2)

			slot2 = slot2 + 1
		end

		slot1 = slot1 - 1
	end
end

slot0.displayFleetInfo = function (slot0)
	slot1 = slot0._currentFleetVO:GetPropertiesSum()

	setActive(slot0._popup, true)
	slot0.tweenNumText(slot0._costText, slot0._currentFleetVO:GetCostSum().oil)
	slot0.tweenNumText(slot0._subGS, slot2)
	setText(slot0._fleetNameText, slot0.defaultFleetName(slot0._currentFleetVO))
	setText(slot0._fleetNumText, slot0._currentFleetVO.id - 10)
end

slot0.SetFleetStepper = function (slot0)
	setActive(slot0._nextPage, slot0:getNextFleetID() ~= nil)
	setActive(slot0._prevPage, slot0:getPrevFleetID() ~= nil)
end

slot0.willExit = function (slot0)
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
	slot0:recycleCharacterList(slot0._currentFleetVO.subShips, slot0._characterList[TeamType.Submarine])

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

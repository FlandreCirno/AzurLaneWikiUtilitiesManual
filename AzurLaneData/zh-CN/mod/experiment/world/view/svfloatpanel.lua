slot0 = class("SVFloatPanel", import("view.base.BaseSubView"))
slot0.ShowView = "SVFloatPanel.ShowView"
slot0.HideView = "SVFloatPanel.HideView"
slot0.ReturnCall = "SVFloatPanel.ReturnCall"

slot0.getUIName = function (slot0)
	return "SVFloatPanel"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.rtBasePoint = slot0._tf:Find("point")
	slot0.rtInfoPanel = slot0.rtBasePoint:Find("line/bg")
	slot0.rtMarking = slot0.rtInfoPanel:Find("icon/marking")
	slot0.rtRes = slot0._tf:Find("res")
	slot0.awardItemList = UIItemList.New(slot0.rtInfoPanel:Find("pressing_award"), slot0.rtInfoPanel:Find("pressing_award/award_tpl"))

	slot0.awardItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2:Find("IconTpl"), slot4)
			onButton(slot0, slot2:Find("IconTpl"), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setActive(slot2.Find(slot2, "is_pressing"), slot0.mapList[slot0.destIndex].isPressing)
			setActive(slot2:Find("IconTpl"), not slot0.mapList[slot0.destIndex].isPressing)
		end
	end)

	slot0.btnBack = slot0.rtInfoPanel.Find(slot1, "back")

	onButton(slot0, slot0.btnBack, function ()
		slot0:emit(WorldScene.SceneOp, "OpSetInMap", true)
	end, SFX_CONFIRM)

	slot0.btnEnter = slot0.rtInfoPanel.Find(slot1, "enter")

	onButton(slot0, slot0.btnEnter, function ()
		if WorldConst.HasDangerConfirm(slot0.mapList[slot0.destIndex].config.entrance_ui) then
			table.insert(slot0, function (slot0)
				slot0:emit(WorldScene.SceneOp, "OpCall", function (slot0)
					slot0()
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_map_dangerous_confirm"),
						onYes = slot0
					})
				end)
			end)
		end

		seriesAsync(slot0, function ()
			if not slot0.isCost and nowWorld.staminaMgr:GetTotalStamina() < slot0.config.enter_cost then
				nowWorld.staminaMgr:Show()
			else
				slot1:emit(WorldScene.SceneOp, "OpTransport", slot1.entrance, slot1.emit)
			end
		end)
	end, SFX_CONFIRM)

	slot0.btnLock = slot0.rtInfoPanel.Find(slot1, "lock")
	slot0.btnReturn = slot0.rtInfoPanel:Find("return")

	onButton(slot0, slot0.btnReturn, function ()
		slot0:emit(slot1.ReturnCall, slot0.entrance)
	end, SFX_CONFIRM)

	slot0.btnSwitch = slot0.rtInfoPanel.Find(slot1, "switch")

	onButton(slot0, slot0.btnSwitch, function ()
		if slot0.isTweening then
			return
		end

		slot0:ShowToggleMask()
	end, SFX_PANEL)

	slot0.rtSelectMask = slot0._tf.Find(slot1, "select_mask")

	onButton(slot0, slot0.rtSelectMask:Find("bg"), function ()
		if slot0.isTweening then
			return
		end

		slot0:HideToggleMask()
	end, SFX_PANEL)

	slot0.rtMaskMarking = slot0.rtSelectMask.Find(slot1, "marking")
	slot0.rtToggles = slot0.rtMaskMarking:Find("toggles")
	slot0.toggleItemList = UIItemList.New(slot0.rtToggles, slot0.rtToggles:Find("toggle"))

	slot0.toggleItemList:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			slot4, slot8 = World.ReplacementMapType(slot0.entrance, slot3)

			setText(slot2:Find("Text"), slot5)
			onToggle(slot0, slot2, function (slot0)
				if slot0 then
					slot0:HideToggleMask()

					slot0.destIndex = slot0

					slot0:UpdatePanel()
				end
			end, SFX_PANEL)
			triggerToggle(slot2, false)
		end
	end)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	setActive(slot0._tf, false)
end

slot0.Setup = function (slot0, slot1, slot2, slot3, slot4)
	slot0.entrance = slot1

	setAnchoredPosition(slot0.rtBasePoint, slot0._tf:InverseTransformPoint(GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)):ScreenToWorldPoint(slot4:GetMapScreenPos(Vector2(slot1.config.area_pos[1], slot1.config.area_pos[2])))))

	slot0.mapList = nowWorld:EntranceToReplacementMapList(slot1)

	slot0.toggleItemList.align(slot7, #slot0.mapList)
	triggerToggle(slot0.rtToggles:GetChild(slot6() - 1), true)
end

slot0.setColorfulImage = function (slot0, slot1, slot2, slot3)
	setImageSprite(slot1, getImageSprite(slot0.rtRes:Find(slot1.name .. "/" .. slot2)), defaultValue(slot3, true))
end

slot0.UpdatePanel = function (slot0)
	slot4, slot5 = World.ReplacementMapType(slot0.entrance, slot0.mapList[slot0.destIndex])

	slot0:setColorfulImage(slot0.rtBasePoint, (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	slot0:setColorfulImage(slot0.rtInfoPanel, (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui), false)
	setImageSprite(slot0.rtInfoPanel:Find("icon"), slot8)
	slot0:setColorfulImage(slot0.btnBack, (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	slot0:setColorfulImage(slot0.btnEnter, (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	slot0:setColorfulImage(slot0.rtMarking, (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	slot0:setColorfulImage(slot0.rtMarking:Find("mark_bg"), (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	slot0:setColorfulImage(slot0.rtMaskMarking, (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	slot0:setColorfulImage(slot0.rtMaskMarking:Find("mark_bg"), (slot4 == "complete_chapter" and "safe") or WorldConst.GetMapIconState(slot3.config.entrance_ui))
	setText(slot0.rtMarking:Find("Text"), slot5)
	setText(slot0.rtMaskMarking:Find("Text"), slot5)
	setActive(slot0.rtInfoPanel:Find("sairen"), slot4 == "sairen_chapter")
	setText(slot0.rtInfoPanel:Find("sairen/Text"), i18n("area_yaosai_2"))
	setText(slot0.rtInfoPanel:Find("danger_text"), (slot3:IsMapOpen() and slot3:GetDanger()) or "?")
	changeToScrollText(slot0.rtInfoPanel:Find("title/name"), slot3:GetName(slot0.entrance:GetBaseMap()))

	slot9, slot10, slot16 = nowWorld:CountAchievements(slot0.entrance)

	setText(slot0.rtInfoPanel:Find("title/achievement/number"), slot9 + slot10 .. "/" .. ((slot3.IsMapOpen() and slot3.GetDanger()) or "?"))
	setActive(slot0.rtInfoPanel:Find("pressing_award"), nowWorld:GetPressingAward(slot3.id) and slot12.flag)

	if slot12 and slot12.flag then
		slot0.awardConfig = pg.world_event_complete[slot12.id].tips_icon

		slot0.awardItemList:align(#slot0.awardConfig)
	end

	slot0:UpdateCost()

	slot15, slot16 = nowWorld:GetAtlas().GetActiveMap(slot13).CkeckTransport(slot14)

	setActive(slot0.btnBack, not false and slot13:GetActiveEntrance() == slot0.entrance and slot14 == slot3)
	setActive(slot0.btnEnter, not (slot17 or isActive(slot0.btnBack)) and slot15 and slot7 and slot13.transportDic[slot0.entrance.id])
	setText(slot0.btnLock:Find("Text"), (slot7 and i18n("world_map_locked_border")) or i18n("world_map_locked_stage"))
	setActive(slot0.btnLock, not (slot17 or isActive(slot0.btnBack) or isActive(slot0.btnEnter)) and slot15)
	setActive(slot0.btnReturn, not (slot17 or isActive(slot0.btnBack) or isActive(slot0.btnEnter) or isActive(slot0.btnLock)))

	slot17 = slot17 or isActive(slot0.btnReturn)
end

slot0.UpdateCost = function (slot0)
	slot2 = slot0.btnEnter:Find("cost")

	setActive(slot2, not slot0.mapList[slot0.destIndex].isCost)
	setText(slot2:Find("Text"), setColorStr(nowWorld.staminaMgr:GetTotalStamina(), (nowWorld.staminaMgr.GetTotalStamina() < slot0.mapList[slot0.destIndex].config.enter_cost and COLOR_RED) or COLOR_GREEN) .. "/" .. slot4)
end

slot0.ShowToggleMask = function (slot0)
	slot0.isTweening = true

	setActive(slot0.rtMarking, false)
	setActive(slot0.rtSelectMask, true)
	setActive(slot0.rtToggles, false)

	slot0.rtMaskMarking.position = slot0.rtMarking.position

	LeanTween.moveY(slot0.rtMaskMarking, slot0.rtMaskMarking.anchoredPosition.y + 150, 0.2):setOnComplete(System.Action(function ()
		setActive(slot0.rtToggles, true)

		setActive.isTweening = false
	end))
	setActive(slot0.btnSwitch, false)
end

slot0.HideToggleMask = function (slot0)
	slot0.isTweening = true

	setActive(slot0.rtToggles, false)

	slot0.rtMaskMarking.position = slot0.rtMarking.position

	setAnchoredPosition(slot0.rtMaskMarking, {
		y = slot0.rtMaskMarking.anchoredPosition.y + 150
	})
	LeanTween.moveY(slot0.rtMaskMarking, slot0.rtMaskMarking.anchoredPosition.y - 150, 0.2):setOnComplete(System.Action(function ()
		setActive(slot0.rtSelectMask, false)
		setActive(slot0.rtMarking, true)

		setActive.isTweening = false

		slot0(slot0.btnSwitch, #slot0.mapList > 1)
	end))
end

return slot0

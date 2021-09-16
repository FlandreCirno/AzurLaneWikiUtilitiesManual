slot0 = class("ShipModLayer", import("..base.BaseUI"))
slot1 = 12
slot0.IGNORE_ID = 4

slot0.getUIName = function (slot0)
	return "ShipModUI"
end

slot0.setShipVOs = function (slot0, slot1)
	slot0.shipVOs = slot1
end

slot0.init = function (slot0)
	slot0.blurPanelTF = slot0:findTF("blur_panel")
	slot0.mainPanel = slot0:findTF("blur_panel/main")
	slot0.shipContainer = slot0:findTF("bg/add_ship_panel/ships", slot0.mainPanel)
	slot0.attrsPanel = slot0:findTF("bg/property_panel/attrs", slot0.mainPanel)

	setText(slot0:findTF("bg/add_ship_panel/title/tip", slot0.mainPanel), i18n("ship_mod_exp_to_attr_tip"))

	slot0.destoryConfirmWindow = ShipDestoryConfirmWindow.New(slot0._tf, slot0.event)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0:findTF("ok_btn", slot0.mainPanel), function ()
		if slot0.shipVO.isActivityNpc(slot1) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("npc_strength_tip"),
				onYes = slot0
			})
		else
			slot0()
		end
	end, SFX_CONFIRM)
	onButton(slot0, slot0:findTF("cancel_btn", slot0.mainPanel), function ()
		if not slot0.contextData.materialShipIds or table.getCount(slot0) == 0 then
			return
		end

		slot0:clearAllShip()
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("select_btn", slot0.mainPanel), function ()
		slot0:emit(ShipModMediator.ON_AUTO_SELECT_SHIP)
	end, SFX_CANCEL)
	slot0.initAttrs(slot0)

	slot0.inited = true

	slot0:emit(ShipModMediator.LOADEND, slot0.mainPanel)
	slot0:blurPanel(true)
end

slot0.blurPanel = function (slot0, slot1)
	slot2 = pg.UIMgr.GetInstance()

	if slot1 then
		slot2:OverlayPanelPB(slot0.blurPanelTF, {
			pbList = {
				slot0.mainPanel:Find("bg")
			},
			groupName = slot0:getGroupNameFromData(),
			overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
		})
	else
		slot2:UnOverlayPanel(slot0.blurPanelTF, slot0._tf)
	end
end

slot0.startModShip = function (slot0)
	if not slot0.hasAddition then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_mod_no_addition_tip"),
			onYes = function ()
				slot0:emit(ShipModMediator.MOD_SHIP, slot0.shipVO.id)
			end
		})
	else
		slot0.emit(slot0, ShipModMediator.MOD_SHIP, slot0.shipVO.id)
	end
end

slot0.setShip = function (slot0, slot1)
	if slot0.shipVO and slot0.shipVO.id ~= slot1.id then
		slot0:switchToPage()
	end

	slot0.shipVO = slot1

	slot0:initSelectedShips()

	if slot0.inited then
		slot0:initAttrs()
	end
end

slot0.clearAllShip = function (slot0)
	for slot4 = 1, slot0, 1 do
		slot5 = slot0.shipContainer:GetChild(slot4 - 1)

		setActive(slot5:Find("IconTpl"), false)
		onButton(slot0, slot5:Find("add"), function ()
			slot0:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
		end, SFX_PANEL)
	end

	slot0.contextData.materialShipIds = nil

	slot0.updateAttrs(slot0)
end

slot0.initSelectedShips = function (slot0)
	slot2 = table.getCount(slot0.contextData.materialShipIds or {})

	for slot6 = 1, slot0, 1 do
		slot7 = slot0.shipContainer:GetChild(slot6 - 1)

		if slot6 <= slot2 then
			slot0:updateShip(slot7, slot1[slot6])
		else
			onButton(slot0, slot7:Find("add"), function ()
				slot0:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
			end, SFX_PANEL)
		end

		setActive(slot7.Find(slot7, "IconTpl"), slot6 <= slot2)
	end
end

slot0.updateShip = function (slot0, slot1, slot2)
	onButton(slot0, slot1, function ()
		for slot3, slot4 in ipairs(slot0.contextData.materialShipIds) do
			if slot1 == slot4 then
				setActive(slot2:Find("IconTpl"), false)
				onButton(slot0, slot5, function ()
					slot0:emit(ShipModMediator.ON_SELECT_MATERIAL_SHIPS)
				end, SFX_PANEL)
				table.remove(slot0.contextData.materialShipIds, slot3)
				slot0:updateAttrs()

				break
			end
		end
	end, SFX_PANEL)
	updateShip(slot0.findTF(slot0, "IconTpl", slot1), slot3, {
		initStar = true
	})
	setText(slot1:Find("IconTpl/icon_bg/lv/Text"), slot0.shipVOs[slot2].level)
end

slot0.initAttrs = function (slot0)
	slot0.attrTFs = {}

	for slot4, slot5 in pairs(ShipModAttr.ID_TO_ATTR) do
		if slot0.IGNORE_ID ~= slot4 then
			slot0.attrTFs[slot4] = slot0.attrsPanel:Find("attr_" .. slot4)
		end
	end

	slot0:updateAttrs()
end

slot0.updateAttrs = function (slot0)
	slot0.hasAddition = nil

	for slot4, slot5 in pairs(slot0.attrTFs) do
		slot0:updateAttr(slot4)
	end
end

slot0.updateAttr = function (slot0, slot1)
	slot3 = slot0:findTF("info", slot2)
	slot4 = slot0.attrTFs[slot1].GetComponent(slot2, typeof(CanvasGroup))
	slot6 = slot0.shipVO:getModAttrTopLimit(slot5)
	slot7 = intProperties(slot0.shipVO:getShipProperties())
	slot10 = slot0.shipVO:getModExpRatio(slot5)
	slot11 = math.max(slot0.shipVO:getModExpRatio(ShipModAttr.ID_TO_ATTR[slot1]), 1)

	if slot0.getExpAddition(slot0.shipVO, slot8, slot5) ~= 0 then
		slot0.hasAddition = true
	end

	setText(slot0:findTF("info_container/addition", slot3), "+" .. slot14)
	setText(slot0:findTF("info_container/name", slot3), AttributeType.Type2Name(slot5))
	setText(slot0:findTF("max_container/Text", slot3), slot12)
	setText(slot0:findTF("info_container/value", slot3), slot7[slot5])

	slot4.alpha = (slot7[slot5] == 0 and 0.3) or 1

	slot0:setSliderValue((slot7[slot5] == 0 and 0.3) or 1, (slot9 + slot13) / slot11)

	slot16 = slot13 / slot11
	slot17 = slot13 + slot9 .. "/" .. slot10

	if slot12 == slot7[slot5] and slot7[slot5] ~= 0 then
		slot16 = 1
		slot17 = "MAX"
	end

	slot0:setSliderValue(slot18, slot16)
	setText(slot0:findTF("exp_container/Text", slot2), slot17)
end

slot0.modAttrAnim = function (slot0, slot1, slot2, slot3)
	slot4 = slot3 or 0.3
	slot5 = intProperties(slot1:getShipProperties())
	slot6 = intProperties(slot2:getShipProperties())
	slot0.tweens = {}

	for slot10, slot11 in pairs(slot0.attrTFs) do
		slot14 = slot0.shipVO:getModAttrBaseMax(ShipModAttr.ID_TO_ATTR[slot10])

		if slot1:getModAttrTopLimit(slot12) == 0 then
			slot0:updateAttr(slot10)
		else
			slot16 = slot0:findTF("info", slot15)
			slot17 = slot0:findTF("info_container/value", slot16)
			slot22 = slot0:findTF("cur_slider", slot16).GetComponent(slot20, typeof(Slider))
			slot25 = slot0:findTF("info_container/addition", slot16)
			slot26 = slot0:findTF("exp_container/Text", slot15)

			slot0:setSliderValue(slot23, 0)
			setText(slot0:findTF("exp_container/Text", slot15), slot24 .. "/" .. math.max(slot1:getModExpRatio(slot12), 1))

			function slot27(slot0, slot1)
				setText(slot0, slot0)
				setText(slot1, "+" .. slot1)
			end

			if slot5[slot12] - slot6[slot12] >= 1 then
				slot28 = slot6[slot12]

				slot0.tweenValue(slot0, slot22, slot22.value, 1, slot4, nil, function (slot0)
					slot0:setSliderValue(slot0.setSliderValue, slot0)
				end, function ()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

					slot0 = pg.CriMgr.GetInstance().PlaySoundEffect_V3 + 1

					pg.CriMgr.GetInstance()(pg.CriMgr.GetInstance(), SFX_BREAK_OUT_FULL[slot3] - pg.CriMgr.GetInstance())

					if slot2[slot3] -  > 0 then
						slot4:tweenValue(slot5, 0, 1, slot6, nil, function (slot0)
							slot0:setSliderValue(slot0.setSliderValue, slot0)
						end, function ()
							pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BREAK_OUT_FULL)

							slot0 = pg.CriMgr.GetInstance().PlaySoundEffect_V3 + 1

							pg.CriMgr.GetInstance()(pg.CriMgr.GetInstance(), SFX_BREAK_OUT_FULL[slot3] - pg.CriMgr.GetInstance())

							if pg.CriMgr.GetInstance() == SFX_BREAK_OUT_FULL[slot3] - pg.CriMgr.GetInstance()[pg.CriMgr.GetInstance()] then
								slot4:tweenValue(slot5, 0, slot6 / slot7, slot8, nil, function (slot0)
									slot0:setSliderValue(slot0.setSliderValue, slot0)
								end, function ()
									if slot0 == slot1[slot2] then
										slot3:setSliderValue(slot4, 1)
										setText(slot5, "MAX")
									end
								end)
							end
						end, slot0)
					else
						slot4:tweenValue(slot5, 0, slot7 / slot8, slot8, nil, function (slot0)
							slot0:setSliderValue(slot0.setSliderValue, slot0)
						end, function ()
							if slot0 == slot1[slot2] then
								slot3:setSliderValue(slot4, 1)
								setText(slot5, "MAX")
							end
						end)
					end
				end)
			else
				slot0.tweenValue(slot0, slot22, slot22.value, slot24 / slot19, slot4, nil, function (slot0)
					slot0:setSliderValue(slot0.setSliderValue, slot0)
				end, function ()
					if slot0 == slot1[slot2] then
						slot3:setSliderValue(slot4, 1)
						setText(slot5, "MAX")
					end
				end)
			end
		end
	end
end

slot0.tweenValue = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8)
	slot0.tweens[slot1] = slot1
	slot9 = LeanTween.value(go(slot1), slot2, slot3, slot4):setOnUpdate(System.Action_float(function (slot0)
		if slot0 then
			slot0(slot0)
		end
	end)).setDelay(slot9, slot5 or 0):setOnComplete(System.Action(function ()
		if slot0 then
			slot0()
		end
	end))

	if slot8 and slot8 > 0 then
		slot9.setRepeat(slot9, slot8)
	end
end

slot0.getModExpAdditions = function (slot0, slot1)
	slot3 = pg.ship_data_template[slot0.configId].group_type
	slot4 = pg.ship_data_strengthen
	slot5 = {}

	for slot9, slot10 in pairs(ShipModAttr.ID_TO_ATTR) do
		slot11 = 0

		if slot9 ~= ShipModLayer.IGNORE_ID then
			for slot15, slot16 in pairs(slot1) do
				slot19 = slot4[slot2[slot16.configId].strengthen_id].attr_exp[slot9 - 1]

				if slot2[slot16.configId].group_type == slot3 then
					slot19 = slot19 * 2
				end

				slot11 = slot11 + slot19
			end
		end

		slot5[slot10] = slot11
	end

	return slot5
end

slot0.getMaterialShips = function (slot0, slot1)
	slot2 = {}
	slot3 = ipairs
	slot4 = slot1 or {}

	for slot6, slot7 in slot3(slot4) do
		table.insert(slot2, slot0.shipVOs[slot7])
	end

	return slot2
end

slot0.getExpAddition = function (slot0, slot1, slot2)
	slot3 = slot0:getModExpAdditions(slot1)

	if slot0:getModAttrTopLimit(slot2) == 0 then
		return 0, 0
	else
		slot4 = Clone(slot0)

		slot4:addModAttrExp(slot2, slot3[slot2])

		return slot4:getModProperties(slot2) - slot0:getModProperties(slot2)
	end
end

slot0.getRemainExp = function (slot0, slot1)
	return slot0:getModProperties(slot1) % math.max(slot0:getModExpRatio(slot1), 1)
end

slot0.setSliderValue = function (slot0, slot1, slot2)
	slot1.value = (slot2 == 0 and slot2) or math.max(slot2, 0.08)
end

slot0.willExit = function (slot0)
	slot0:blurPanel(false)

	slot1 = pairs
	slot2 = slot0.tweens or {}

	for slot4, slot5 in slot1(slot2) do
		if LeanTween.isTweening(go(slot5)) then
			LeanTween.cancel(go(slot5))
		end
	end

	slot0.tweens = nil

	if slot0.destoryConfirmWindow then
		slot0.destoryConfirmWindow:Destroy()

		slot0.destoryConfirmWindow = nil
	end
end

slot0.onBackPressed = function (slot0)
	if slot0.destoryConfirmWindow and slot0.destoryConfirmWindow:GetLoaded() and slot0.destoryConfirmWindow:isShowing() then
		slot0.destoryConfirmWindow:Hide()

		return
	end

	slot0:emit(BaseUI.ON_BACK_PRESSED, true)
end

return slot0

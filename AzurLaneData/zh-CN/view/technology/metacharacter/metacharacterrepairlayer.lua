slot0 = class("MetaCharacterRepairLayer", import("...base.BaseUI"))

slot0.getUIName = function (slot0)
	return "MetaCharacterRepairUI"
end

slot0.init = function (slot0)
	slot0:initTipText()
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
end

slot0.didEnter = function (slot0)
	slot0:doRepairProgressPanelAni()
	slot0:updateAttrListPanel()
	slot0:updateRepairBtn(true)
	slot0:updateDetailPanel()

	for slot4, slot5 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		if not slot0.curMetaCharacterVO:getAttrVO(slot5):isLock() then
			triggerToggle(slot0.attrTFList[slot5], true)

			break
		end
	end

	slot0:TryPlayGuide()
end

slot0.willExit = function (slot0)
	return
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.repairEffectBoxPanel) then
		slot0:closeRepairEffectBoxPanel()

		return
	elseif isActive(slot0.detailPanel) then
		slot0:closeDetailPanel()

		return
	else
		slot0:emit(slot0.ON_BACK_PRESSED)
	end
end

slot0.initTipText = function (slot0)
	setText(slot1, i18n("meta_repair"))
	setText(slot2, i18n("meta_repair"))
	setText(slot3, i18n("meta_repair"))
	setText(slot0:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemReload/SelectedPanel/AttrRepairTipText"), i18n("meta_repair"))
end

slot0.initData = function (slot0)
	slot0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	slot0.bayProxy = getProxy(BayProxy)
	slot0.attrTFList = {}
	slot0.curAttrName = nil
	slot0.curMetaShipID = slot0.contextData.shipID
	slot0.curShipVO = nil
	slot0.curMetaCharacterVO = nil

	slot0:updateData()
end

slot0.findUI = function (slot0)
	slot0.repairPanel = slot0:findTF("Repair")
	slot0.attrListPanel = slot0:findTF("AttrListPanel", slot0.repairPanel)
	slot0.attrItemContainer = slot0:findTF("AttrItemContainer", slot0.attrListPanel)
	slot0.attrCannonTF = slot0:findTF("AttrItemCannon", slot0.attrItemContainer)
	slot0.attrTorpedoTF = slot0:findTF("AttrItemTorpedo", slot0.attrItemContainer)
	slot0.attrAirTF = slot0:findTF("AttrItemAir", slot0.attrItemContainer)
	slot0.attrReloadTF = slot0:findTF("AttrItemReload", slot0.attrItemContainer)
	slot0.attrTFList.cannon = slot0.attrCannonTF
	slot0.attrTFList.torpedo = slot0.attrTorpedoTF
	slot0.attrTFList.air = slot0.attrAirTF
	slot0.attrTFList.reload = slot0.attrReloadTF
	slot0.repairPercentText = slot0:findTF("SynProgressPanel/SynRate/NumTextText", slot0.repairPanel)
	slot0.repairSliderTF = slot0:findTF("SynProgressPanel/Slider", slot0.repairPanel)
	slot0.repairBtn = slot0:findTF("RepairBtn", slot0.repairPanel)
	slot0.repairBtnDisable = slot0:findTF("RepairBtnDisable", slot0.repairPanel)
	slot0.showDetailLine = slot0:findTF("ShowDetailLine")
	slot0.showDetailBtn = slot0:findTF("ShowDetailBtn", slot0.showDetailLine)
	slot0.detailPanel = slot0:findTF("Detail")
	slot0.detailBG = slot0:findTF("BG", slot0.detailPanel)
	slot0.detailTF = slot0:findTF("Panel", slot0.detailPanel)
	slot0.detailCloseBtn = slot0:findTF("CloseBtn", slot0.detailTF)
	slot0.detailLineTpl = slot0:findTF("DetailLineTpl", slot0.detailTF)
	slot0.detailItemTpl = slot0:findTF("DetailItemTpl", slot0.detailTF)
	slot0.detailItemContainer = slot0:findTF("ScrollView/Viewport/Content", slot0.detailTF)
	slot0.repairEffectBoxPanel = slot0:findTF("RepairEffectBox")
end

slot0.addListener = function (slot0)
	for slot4, slot5 in pairs(slot0.attrTFList) do
		onToggle(slot0, slot5, function (slot0)
			if slot0 == true then
				slot0.curAttrName = slot0

				slot0:updateRepairBtn()
			else
				slot0.curAttrName = nil

				slot0:updateRepairBtn(true)
			end
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.repairBtn, function ()
		pg.m02:sendNotification(GAME.REPAIR_META_CHARACTER, {
			shipID = slot0.curMetaShipID,
			attr = slot0.curAttrName
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.showDetailBtn, function ()
		if not isActive(slot0.detailPanel) then
			slot0:openDetailPanel()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.showDetailLine, function ()
		if not isActive(slot0.detailPanel) then
			slot0:openDetailPanel()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.detailCloseBtn, function ()
		slot0:closeDetailPanel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.detailBG, function ()
		slot0:closeDetailPanel()
	end, SFX_CANCEL)
end

slot0.TryPlayGuide = function (slot0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0027")
end

slot0.doRepairProgressPanelAni = function (slot0)
	slot2 = GetComponent(slot0.repairSliderTF, typeof(Slider))
	slot2.minValue = 0
	slot2.maxValue = 1
	slot3 = slot2.value

	if slot0.curMetaCharacterVO:getRepairRate() > 0 then
		slot0:managedTween(LeanTween.value, nil, go(slot0.repairSliderTF), slot3, slot1, 0.5):setOnUpdate(System.Action_float(function (slot0)
			slot0:updateRepairProgressPanel(slot0)
		end)).setOnComplete(slot5, System.Action(function ()
			slot0:updateRepairProgressPanel(slot0)
		end))
	else
		slot0.updateRepairProgressPanel(slot0, slot1)
	end
end

slot0.updateRepairProgressPanel = function (slot0, slot1)
	setSlider(slot0.repairSliderTF, 0, 1, slot1 or slot0.curMetaCharacterVO:getRepairRate())
	setText(slot0.repairPercentText, string.format("%d", (slot1 or slot0.curMetaCharacterVO.getRepairRate()) * 100))
end

slot0.updateAttrListPanel = function (slot0)
	for slot4, slot5 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		slot0:updateAttrItem(slot0.attrTFList[slot5], slot5)
	end
end

slot0.updateAttrItem = function (slot0, slot1, slot2)
	slot3 = slot0:findTF("LockPanel", slot1)
	slot4 = slot0:findTF("UnSelectPanel", slot1)
	slot5 = slot0:findTF("SelectedPanel", slot1)

	if slot0.curMetaCharacterVO:getAttrVO(slot2):isLock() then
		setActive(slot4, false)
		setActive(slot5, false)
		setActive(slot3, true)

		slot1:GetComponent("Toggle").interactable = false
	else
		slot8 = slot1:GetComponent("Toggle")

		setActive(slot4, not slot8.isOn)
		setActive(slot5, slot8.isOn)
		setActive(slot3, false)

		slot8.interactable = true
		slot12 = slot0:findTF("AttrRepairValue/Image", slot5)
		slot13 = slot0:findTF("AttrRepairValue/NextValueText", slot5)
		slot14 = slot0:findTF("IconTpl", slot5)
		slot16 = slot0:findTF("NumText", slot15)
		slot17 = slot6:getAddition()

		setText(slot9, "+" .. slot17)
		setText(slot10, "+" .. slot17)
		setText(slot11, "+" .. slot17)

		slot20 = nil
		slot20 = (slot6:isMaxLevel() or slot6:getItem()) and slot6:getItemByLevel(slot6:getLevel() - 1)

		if getProxy(BagProxy):getItemCountById(slot20:getItemId()) < slot20:getTotalCnt() then
			slot23 = setColorStr(slot23, COLOR_RED)
		end

		setText(slot16, slot23 .. "/" .. slot22)
		updateDrop(slot14, slot24, {
			hideName = true
		})
		onButton(slot0, slot14, function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
		setActive(slot12, not slot19)
		setActive(slot13, not slot19)

		if slot19 then
			setText(slot13, slot17)
		else
			setText(slot13, "+" .. slot17 + slot20:getAdditionValue())
		end

		if slot19 then
			setActive(slot14, false)
			setActive(slot15, false)
		else
			setActive(slot14, true)
			setActive(slot15, true)
		end
	end
end

slot0.updateRepairBtn = function (slot0, slot1)
	if slot1 == true then
		setActive(slot0.repairBtn, false)
		setActive(slot0.repairBtnDisable, false)

		return
	end

	slot2 = slot0.curMetaCharacterVO:getAttrVO(slot0.curAttrName)
	slot5 = nil
	slot9 = (slot2:isMaxLevel() or slot2:getItem()) and slot2:getItemByLevel(slot2:getLevel() - 1):getTotalCnt() <= getProxy(BagProxy):getItemCountById((slot2.isMaxLevel() or slot2.getItem()) and slot2.getItemByLevel(slot2.getLevel() - 1):getItemId())

	if slot4 then
		setActive(slot0.repairBtn, false)
		setActive(slot0.repairBtnDisable, false)
	elseif not slot9 then
		setActive(slot0.repairBtn, false)
		setActive(slot0.repairBtnDisable, true)
	else
		setActive(slot0.repairBtn, true)
		setActive(slot0.repairBtnDisable, false)
	end
end

slot0.updateDetailItem = function (slot0, slot1, slot2)
	setText(slot5, i18n("meta_repair_effect_unlock", slot2.progress))
	setActive(slot0:findTF("LockPanel", slot1), slot2.progress > slot0.curMetaCharacterVO:getRepairRate() * 100)

	slot13 = UIItemList.New(slot0:findTF("LineContainer", slot1), slot0.detailLineTpl)

	slot13:make(function (slot0, slot1, slot2)
		slot3 = slot0:findTF("AttrLine", slot2)
		slot4 = slot0:findTF("UnlockTipLine", slot2)
		slot5 = slot0:findTF("Text", slot2)

		if slot0 == UIItemList.EventUpdate then
			if slot1 + 1 == 1 then
				setActive(slot3, false)
				setActive(slot4, false)
				setActive(slot5, true)
				setText(slot5, i18n("meta_repair_effect_unlock", slot1))

				return
			end

			if slot1 <= slot2 + 1 then
				setActive(slot3, true)
				setActive(slot4, false)
				setImageSprite(slot6, LoadSprite("attricon", slot3[slot1 - 1][1]))
				setText(slot7, AttributeType.Type2Name(slot10))
				setText(slot0:findTF("NumText", slot3), "+" .. slot3[slot1 - 1][2])
			else
				setActive(slot3, false)
				setActive(slot4, true)
				setScrollText(slot0:findTF("Text", slot4), slot4[slot1 - 1 - slot2])
			end
		end
	end)
	slot13.align(slot13, #slot2:getAttrAdditionList() + #slot2:getDescs() + 1)
end

slot0.updateDetailPanel = function (slot0)
	setActive(slot0.detailPanel, false)

	slot0.detailList = UIItemList.New(slot0.detailItemContainer, slot0.detailItemTpl)

	slot0.detailList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1:updateDetailItem(slot2, slot0[slot1 + 1])
		end
	end)
	slot0.detailList.align(slot2, #slot0.curMetaCharacterVO:getEffects())
end

slot0.updateData = function (slot0)
	slot0.curShipVO = slot0.bayProxy:getShipById(slot0.curMetaShipID)
	slot0.curMetaCharacterVO = slot0.curShipVO:getMetaCharacter()
end

slot0.checkSpecialEffect = function (slot0)
	slot2 = slot0.bayProxy:getShipById(slot0.curMetaShipID).getMetaCharacter(slot1)
	slot3 = slot2:getRepairRate() * 100
	slot4 = slot0.curMetaCharacterVO:getRepairRate() * 100

	for slot9, slot10 in ipairs(slot5) do
		if slot4 < slot10.progress and slot11 <= slot3 then
			slot0:openRepairEffectBoxPanel(slot10)

			break
		end
	end
end

slot0.openRepairEffectBoxPanel = function (slot0, slot1)
	slot7 = slot1.progress
	slot8 = slot0:findTF("BG", slot0.repairEffectBoxPanel)

	onButton(slot0, slot9, function ()
		slot0:closeRepairEffectBoxPanel()
	end, SFX_CANCEL)

	slot12 = UIItemList.New(slot10, slot11)

	slot12:make(function (slot0, slot1, slot2)
		slot3 = slot0:findTF("AttrLine", slot2)
		slot4 = slot0:findTF("UnlockTipLine", slot2)

		if slot0 == UIItemList.EventUpdate then
			if slot1 + 1 == 1 then
				setActive(slot3, false)
				setActive(slot4, true)
				setScrollText(slot0:findTF("Text", slot4), i18n("meta_repair_effect_special", slot1))
			elseif slot1 > 1 and slot1 <= 1 + slot2 then
				setActive(slot3, true)
				setActive(slot4, false)
				setImageSprite(slot5, LoadSprite("attricon", slot3[slot1 - 1][1]))
				setText(slot6, AttributeType.Type2Name(slot9))
				setText(slot0:findTF("NumText", slot3), "+" .. slot3[slot1 - 1][2])
			elseif slot1 > 1 + slot2 and slot1 <= slot4 then
				setActive(slot3, false)
				setActive(slot4, true)
				setScrollText(slot0:findTF("Text", slot4), slot5[slot1 - (1 + slot2)])
			end
		end
	end)
	slot12.align(slot12, slot6)
	setActive(slot0.repairEffectBoxPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.repairEffectBoxPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

slot0.closeRepairEffectBoxPanel = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.repairEffectBoxPanel)
	setActive(slot0.repairEffectBoxPanel, false)
end

slot0.openDetailPanel = function (slot0)
	setActive(slot0.detailPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.detailPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	slot0.isOpening = true

	slot0:managedTween(LeanTween.value, nil, go(slot0.detailTF), slot0.detailTF.rect.width, 0, 0.3):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0.detailTF, {
			x = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		slot0.isOpening = nil
	end))
end

slot0.closeDetailPanel = function (slot0)
	if slot0.isClosing or slot0.isOpening then
		return
	end

	slot0.isClosing = true

	slot0:managedTween(LeanTween.value, nil, go(slot0.detailTF), 0, slot0.detailTF.rect.width, 0.3):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0.detailTF, {
			x = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		slot0.isClosing = nil

		setActive(slot0.detailPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(slot0.detailPanel)
	end))
end

return slot0

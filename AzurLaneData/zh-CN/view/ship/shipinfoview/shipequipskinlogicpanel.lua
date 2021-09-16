slot0 = class("ShipEquipSkinLogicPanel", import("...base.BasePanel"))
slot1 = 0.2

slot0.init = function (slot0)
	slot0.equipmentTFs = {
		slot0:findTF("equipment_r/skin/equipment_r1"),
		slot0:findTF("equipment_r/skin/equipment_r2"),
		slot0:findTF("equipment_r/skin/equipment_r3"),
		slot0:findTF("equipment_l/skin/equipment_l1"),
		slot0:findTF("equipment_l/skin/equipment_l2")
	}
	slot0.equipmentNormalTFs = {
		slot0:findTF("equipment_r/equipment/equipment_r1"),
		slot0:findTF("equipment_r/equipment/equipment_r2"),
		slot0:findTF("equipment_r/equipment/equipment_r3"),
		slot0:findTF("equipment_l/equipment/equipment_l1"),
		slot0:findTF("equipment_l/equipment/equipment_l2")
	}
	slot0.equipmentR = slot0:findTF("equipment_r/equipment")
	slot0.equipmentL = slot0:findTF("equipment_l/equipment")
	slot0.skinR = slot0:findTF("equipment_r/skin")
	slot0.skinL = slot0:findTF("equipment_l/skin")
	slot0.infoPanel = slot0:findTF("info", slot0.equipmentTFs[1])
	slot0.inSkinPage = true

	for slot4 = 1, 3, 1 do
		setText(slot5, i18n("equipskin_typewrong"))
		setText(slot6, i18n("equipskin_typewrong_en"))
		setText(slot7, i18n("equipskin_add"))
		setText(findTF(slot0.skinR, "equipment_r" .. slot4 .. "/info/forbid"), i18n("equipskin_none"))
	end

	for slot4 = 1, 2, 1 do
		setText(findTF(slot0.skinL, "equipment_l" .. slot4 .. "/forbid"), i18n("equipskin_none"))
	end

	for slot4 = 1, #slot0.equipmentNormalTFs, 1 do
		setText(findTF(slot0.equipmentNormalTFs[slot4], "empty/tip"), i18n("equip_add"))
	end
end

slot0.setLabelResource = function (slot0, slot1)
	slot0.resource = slot1
end

slot0.doSwitchAnim = function (slot0, slot1)
	if slot0:isTweening() then
		return
	end

	slot0.inSkinPage = slot1

	slot0:doAnim(slot0.equipmentR, slot0.skinR)
	slot0:doAnim(slot0.equipmentL, slot0.skinL)
end

slot0.isTweening = function (slot0)
	if LeanTween.isTweening(go(slot0.equipmentR)) or LeanTween.isTweening(go(slot0.skinR)) or LeanTween.isTweening(go(slot0.equipmentL)) or LeanTween.isTweening(go(slot0.skinL)) then
		return true
	end

	return false
end

slot0.doAnim = function (slot0, slot1, slot2)
	slot5 = slot1:GetComponent(typeof(CanvasGroup))
	slot6 = slot2:GetComponent(typeof(CanvasGroup))

	LeanTween.moveLocal(go(slot1), slot3, slot0)
	LeanTween.moveLocal(go(slot2), slot4, slot0)

	slot7 = 0.8
	slot8 = 1

	if not slot0.inSkinPage then
		slot8 = 0.8
		slot7 = 1
	end

	LeanTween.value(go(slot1), slot7, slot8, slot0):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))
	LeanTween.value(go(slot2), slot8, slot7, slot0):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))

	slot6.blocksRaycasts = not slot0.inSkinPage
	slot5.blocksRaycasts = slot0.inSkinPage

	(not slot0.inSkinPage and slot2) or slot1:SetAsLastSibling()
end

slot0.updateAll = function (slot0, slot1)
	if slot1 then
		for slot5, slot6 in ipairs(slot0.equipmentTFs) do
			if not not table.contains(ShipEquipView.UNLOCK_EQUIPMENT_SKIN_POS, slot5) then
				slot0:updateEquipmentTF(slot1, slot5)
			end

			if slot0:findTF("shadow", slot6) then
				setActive(slot8, slot0.inSkinPage)
			end
		end

		for slot5, slot6 in ipairs(slot0.equipmentNormalTFs) do
			if slot0:findTF("shadow", slot6) then
				setActive(slot7, not slot0.inSkinPage)
			end
		end
	end
end

slot0.updateEquipmentTF = function (slot0, slot1, slot2)
	slot0.shipVO = slot1

	if slot1 then
		removeOnButton(slot3)

		slot4 = slot1:getEquip(slot2)
		slot5 = slot1:getEquipSkin(slot2)

		if IsNil(slot0.equipmentTFs[slot2].Find(slot3, "info")) then
			slot6 = cloneTplTo(slot0.infoPanel, slot3, "info")
		end

		slot0:findTF("panel_title/type", slot3).GetComponent(slot7, typeof(Text)).text = EquipType.LabelToName(slot8)

		setActive(slot3:Find("unequip"), false)

		slot10 = slot1:getCanEquipSkin(slot2)

		setActive(slot6:Find("forbid"), not slot10)
		setActive(slot6:Find("equip"), slot10)

		if slot10 then
			slot0:updateEquipmentPanel(slot11, slot2)
		end
	end
end

slot0.updateEquipmentPanel = function (slot0, slot1, slot2)
	if not slot0.shipVO:getCanEquipSkin(slot2) then
		return
	end

	slot4 = slot0.shipVO:getEquipSkin(slot2) ~= 0
	slot5 = slot0.shipVO:getEquip(slot2)
	slot7 = false

	if slot0.shipVO:getEquipSkin(slot2) ~= 0 then
		if slot5 then
			if not table.contains(pg.equip_skin_template[slot6].equip_type, slot5:getType()) then
				slot7 = true
			end
		else
			slot7 = true
		end
	end

	slot9 = slot1:Find("info")

	setActive(slot9, slot4)
	setActive(slot8, not slot4)
	setActive(slot10, slot7)
	setActive(slot9:Find("desc"), not slot7)

	if slot4 then
		slot0:updateSkinInfo(slot9, slot6)
		onButton(slot0, slot0.equipmentTFs[slot2], function ()
			slot0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, slot0)
		end, SFX_PANEL)
	else
		onButton(slot0, slot8:Find("icon"), function ()
			slot0:emit(ShipMainMediator.ON_SELECT_EQUIPMENT_SKIN, slot0)
		end, SFX_PANEL)
	end
end

slot0.updateSkinInfo = function (slot0, slot1, slot2)
	setText(slot1:Find("desc"), pg.equip_skin_template[slot2].desc)
	setText(slot1:Find("cont/name_mask/name"), shortenString(pg.equip_skin_template[slot2].name, 10))
	updateDrop(slot1:Find("IconTpl"), {
		type = DROP_TYPE_EQUIPMENT_SKIN,
		id = slot2
	})
end

return slot0

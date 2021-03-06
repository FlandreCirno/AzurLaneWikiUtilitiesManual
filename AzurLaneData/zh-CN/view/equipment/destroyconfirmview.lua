slot0 = class("DestroyConfirmView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "StoreHouseDestroyConfirmView"
end

slot0.OnInit = function (slot0)
	slot0:InitUI()
	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.InitUI = function (slot0)
	slot0.destroyBonusList = slot0._tf:Find("frame/bg/scrollview/list")
	slot0.destroyBonusItem = slot0.destroyBonusList:Find("equipment_tpl")
	slot0.destroyNoGotTip = slot0._tf:Find("frame/bg/tip")

	setText(slot0:findTF("frame/title_text/Text"), i18n("equipment_select_device_destroy_bonus_tip"))
	setText(slot0.destroyNoGotTip, i18n("equipment_select_device_destroy_nobonus_tip"))
	onButton(slot0, slot0:findTF("frame/actions/cancel_btn"), function ()
		slot0:Destroy()
	end, SFX_CANCEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Destroy()
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("frame/top/btnBack"), function ()
		slot0:Destroy()
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("frame/actions/confirm_btn"), function ()
		slot0:emit(EquipmentMediator.ON_DESTROY, slot0.selectedIds)
		slot0.emit.confirmBtnCB()
		slot0.emit.confirmBtnCB:Destroy()
	end, SFX_UI_EQUIPMENT_RESOLVE)
end

slot0.OnDestroy = function (slot0)
	slot0.confirmBtnCB = nil
	slot0.selectedIds = nil

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTF)
end

slot0.SetConfirmBtnCB = function (slot0, slot1)
	slot0.confirmBtnCB = slot1
end

slot0.DisplayDestroyBonus = function (slot0, slot1)
	slot0.selectedIds = slot1
	slot2 = {}
	slot3 = 0

	for slot7, slot8 in ipairs(slot0.selectedIds) do
		if pg.equip_data_template[slot8[1]] then
			slot10 = slot9.destory_item or {}
			slot3 = slot3 + (slot9.destory_gold or 0) * slot8[2]

			for slot15, slot16 in ipairs(slot10) do
				slot17 = false

				for slot21, slot22 in ipairs(slot2) do
					if slot16[1] == slot2[slot21].id then
						slot2[slot21].count = slot2[slot21].count + slot16[2] * slot8[2]
						slot17 = true

						break
					end
				end

				if not slot17 then
					table.insert(slot2, {
						type = DROP_TYPE_ITEM,
						id = slot16[1],
						count = slot16[2] * slot8[2]
					})
				end
			end
		end
	end

	if slot3 > 0 then
		table.insert(slot2, {
			id = 1,
			type = DROP_TYPE_RESOURCE,
			count = slot3
		})
	end

	setActive(slot0.destroyNoGotTip, #slot2 <= 0)

	if not slot0.destroyList then
		slot0.destroyList = UIItemList.New(slot0.destroyBonusList, slot0.destroyBonusItem)
	end

	slot0.destroyList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			if slot0[slot1 + 1].type == DROP_TYPE_SHIP then
				slot1.hasShip = true
			end

			updateDrop(slot2:Find("bg"), slot3)

			slot4, slot5 = contentWrap(slot3.cfg.name, 10, 2)

			if slot4 then
				slot5 = slot5 .. "..."
			end

			setText(slot2:Find("bg/name"), slot5)
			onButton(slot1, slot2, function ()
				if slot0.type == DROP_TYPE_RESOURCE or slot0.type == DROP_TYPE_ITEM then
					slot1:emit(BaseUI.ON_ITEM, slot0.cfg.id)
				elseif slot0.type == DROP_TYPE_EQUIP then
					slot1:emit(BaseUI.ON_EQUIPMENT, {
						equipmentId = slot0.cfg.id,
						type = EquipmentInfoMediator.TYPE_DISPLAY
					})
				end
			end, SFX_PANEL)
		end
	end)
	slot0.destroyList.align(slot4, #slot2)
end

return slot0

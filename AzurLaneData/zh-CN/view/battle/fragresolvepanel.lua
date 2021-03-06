slot0 = class("FragResolvePanel", BaseSubPanel)

slot0.GetUIName = function (slot0)
	return "FragResolveUI"
end

slot1 = {
	"control",
	"resolve"
}

slot0.OnInit = function (slot0)
	slot0.bagProxy = getProxy(BagProxy)
	slot0.technologyProxy = getProxy(TechnologyProxy)
	slot0.toggles = {}

	for slot4, slot5 in ipairs(slot0) do
		slot0[slot5 .. "Panel"] = slot0._tf:Find(slot5)
		slot0.toggles[slot5] = slot0._tf:Find("toggle_controll/" .. slot5)

		onToggle(slot0, slot0._tf.Find("toggle_controll/" .. slot5), function (slot0)
			slot0["Reset" .. slot0](slot0)
		end, SFX_PANEL)
	end

	onButton(slot0, slot0._tf:Find("bg"), function ()
		slot0:Back()
	end, SFX_PANEL)

	slot1 = slot0.controlPanel.Find(slot1, "got/empty/Text")

	setText(slot0.controlPanel:Find("allMax/txt"), i18n("onebutton_max_tip"))

	slot2 = slot0._tf:Find("control/condition/text")
	slot3 = slot0.resolvePanel:Find("cancel_button/label")

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(slot2, i18n("fenjie_lantu_tip"))
		setTextEN(slot1, i18n("fragresolve_empty_tip"))
	else
		setText(slot2, i18n("fenjie_lantu_tip"))
		setText(slot1, i18n("fragresolve_empty_tip"))
	end

	setText(slot3, i18n("msgbox_text_cancel"))

	slot1.keepFateTog = slot0._tf:Find("control/condition/keep_tog")

	setText(slot0:findTF("label", slot0.keepFateTog), i18n("keep_fate_tip"))

	slot1.keepFateState = not getProxy(PlayerProxy):getData().GetCommonFlag(slot4, SHOW_DONT_KEEP_FATE_ITEM)
	GetComponent(slot0.keepFateTog, typeof(Toggle)).isOn = slot1.keepFateState

	onToggle(slot0, slot0.keepFateTog, function (slot0)
		slot0.keepFateState = slot0

		slot0:emit(NewShopsMediator.SET_PLAYER_FLAG, SHOW_DONT_KEEP_FATE_ITEM, not slot0)
		slot0.emit:Trigger("control")
	end)
	slot0.Trigger(slot0, "control")
end

slot0.OnShow = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.OnHide = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

slot0.Reset = function (slot0)
	if slot0.resolveItems then
		table.clear(slot0.resolveItems)
	end
end

slot0.Resetcontrol = function (slot0)
	slot0.blueprintItems = slot0.GetAllBluePrintStrengthenItems()

	setActive(slot0.controlPanel.Find(slot2, "got/empty"), #slot0.blueprintItems <= 0)
	setActive(slot0.controlPanel.Find(slot2, "got/list"), #slot1 > 0)

	if #slot1 <= 0 then
		slot0:Updatecontrol()

		return
	end

	slot5 = {}
	slot6 = ipairs
	slot7 = slot0.resolveItems or {}

	for slot9, slot10 in slot6(slot7) do
		slot5[slot10.id] = slot10
	end

	UIItemList.StaticAlign(slot4, slot4:Find("item"), #slot1, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2:Find("icon"), slot3)

			slot3.curCount = math.clamp((slot1[slot0[slot1 + 1].id] and slot1[slot3.id].curCount) or 0, 0, slot3.maxCount)

			onButton(slot2, slot2:Find("icon/icon_bg"), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)

			slot4 = slot2.Find(slot2, "count")

			onButton(slot2, slot4:Find("max"), function ()
				if slot0.curCount ~= slot0.maxCount then
					slot0.curCount = slot0.maxCount

					slot0.maxCount:Updatecontrol()
				end
			end)
			pressPersistTrigger(slot4.Find(slot4, "number_panel/left"), 0.5, function (slot0)
				if slot0.curCount <= 0 then
					slot0()

					return
				end

				slot0.curCount = slot0.curCount - 1

				slot0:Updatecontrol()
			end, nil, true, true, 0.1, SFX_PANEL)
			pressPersistTrigger(slot4.Find(slot4, "number_panel/right"), 0.5, function (slot0)
				if slot0.maxCount <= slot0.curCount then
					slot0()

					return
				end

				slot0.curCount = slot0.curCount + 1

				slot0:Updatecontrol()
			end, nil, true, true, 0.1, SFX_PANEL)
		end
	end)
	onButton(slot0, slot2:Find("button_1"), function ()
		for slot4, slot5 in ipairs(slot0.blueprintItems) do
			if slot5.curCount > 0 then
				Clone(slot5).count = slot5.curCount

				table.insert(slot0, Clone(slot5))
			end
		end

		if #slot0 > 0 then
			slot0.resolveItems = slot0

			triggerToggle(slot0.toggles.resolve, true)
		end
	end, SFX_PANEL)
	onButton(slot0, slot2:Find("allMax"), function ()
		for slot3 = 1, #slot0, 1 do
			if slot0[slot3].curCount ~= slot0[slot3].maxCount then
				slot4.curCount = slot4.maxCount
			end

			slot1:Updatecontrol()
		end
	end, SFX_PANEL)
	slot0.Updatecontrol(slot0)
end

slot0.Updatecontrol = function (slot0)
	slot2 = slot0.controlPanel.Find(slot1, "got/list")

	UIItemList.StaticAlign(slot2, slot2:Find("item"), #slot0.blueprintItems, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("count").Find(slot4, "number_panel/value"), slot0[slot1 + 1].curCount)

			slot1 = slot1 + slot0[slot1 + 1].curCount
		end
	end)
	setButtonEnabled(slot0.controlPanel.Find(slot1, "button_1"), 0 > 0)
	setGray(slot5, slot4 <= 0)
	setGray(slot1:Find("allMax"), not slot3 or #slot3 == 0)
	setButtonEnabled(setGray, slot3 and #slot3 > 0)
end

slot0.Resetresolve = function (slot0)
	slot2 = slot0.resolvePanel.Find(slot1, "preview/got/list")
	slot3 = slot0.resolvePanel.Find(slot1, "result/got/list")

	UIItemList.StaticAlign(slot2, slot2:Find("item"), #slot0.resolveItems, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2:Find("icon"), slot3)
			onButton(slot1, slot2:Find("icon/icon_bg"), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setText(slot2.Find(slot2, "name_panel/name"), HXSet.hxLan(slot0[slot1 + 1].cfg.name))
			setText(slot2:Find("name_panel/number"), "x " .. slot0[slot1 + 1].curCount)
		end
	end)

	slot5 = {}
	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		slot5[slot13.price[1]] = (slot5[pg.item_data_statistics[slot11.id].price[1]] or 0) + slot13.price[2] * slot12.count
	end

	for slot10, slot11 in pairs(slot5) do
		table.insert(slot6, {
			type = DROP_TYPE_RESOURCE,
			id = slot10,
			count = slot11
		})
	end

	UIItemList.StaticAlign(slot3, slot3:Find("item"), #slot6, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2:Find("icon"), slot3)
			onButton(slot1, slot2:Find("icon/icon_bg"), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setText(slot2.Find(slot2, "name_panel/name"), slot0[slot1 + 1].cfg.name)
			setText(slot2:Find("name_panel/number"), "x " .. slot0[slot1 + 1].count)
		end
	end)
	onButton(slot0, slot1:Find("cancel_button"), function ()
		slot0:Back()
	end)
	onButton(slot0, slot1:Find("destroy_button"), function ()
		slot0:emit(NewShopsMediator.SELL_BLUEPRINT, slot0.resolveItems)
	end)
end

slot0.GetAllBluePrintStrengthenItems = function ()
	slot0 = {}
	slot1 = getProxy(TechnologyProxy)
	slot2 = getProxy(BagProxy)

	for slot7, slot8 in ipairs(pg.ship_data_blueprint.all) do
		slot9 = slot3[slot8]

		if slot1:getBluePrintById(slot8):isMaxLevel() and slot2:getItemById(slot9.strengthen_item) then
			slot13 = slot1:getBluePrintById(slot1:GetBlueprint4Item(slot11))
			slot14 = slot12.count

			if slot12 and slot12.count > 0 and slot0.keepFateState and slot12.count - slot13:getFateMaxLeftOver() < 0 then
				slot14 = 0
			end

			table.insert(slot0, {
				id = slot12.id,
				type = DROP_TYPE_ITEM,
				count = slot12.count,
				maxCount = slot14
			})
		end
	end

	return slot0
end

slot0.Trigger = function (slot0, slot1)
	if slot0.toggles[slot1] then
		slot0.buffer:Show()
		triggerToggle(slot2, true)
	end
end

slot0.Back = function (slot0)
	if getToggleState(slot0.toggles.resolve) then
		triggerToggle(slot0.toggles.control, true)
	elseif getToggleState(slot0.toggles.control) then
		slot0:Hide()
	end
end

return slot0

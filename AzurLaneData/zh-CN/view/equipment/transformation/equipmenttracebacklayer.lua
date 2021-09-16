slot0 = class("EquipmentTraceBackLayer", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "EquipmentTraceBackUI"
end

slot0.init = function (slot0)
	slot1 = slot0._tf:Find("Adapt/Left/Operation")
	slot0.sortOrderBtn = slot1:Find("Bar1")
	slot0.orderText = slot1:Find("OrderText")
	slot0.sortBarBtn = slot1:Find("Bar2")
	slot0.sortImg = slot1:Find("SortImg")
	slot0.sortBar = slot0._tf:Find("Adapt/Left/SortBar")

	setActive(slot0.sortBar, false)

	slot0.equipLayout = slot0._tf:Find("Adapt/Left/Scroll View")
	slot0.equipLayoutContent = slot0.equipLayout:Find("Viewport/Content")
	slot0.equipLayoutContent:GetComponent(typeof(GridLayoutGroup)).constraintCount = 6
	slot3 = slot0._tf:Find("Adapt/Right")
	slot0.sourceEquip = slot3:Find("Source")
	slot0.sourceEquipStatus = slot3:Find("Status")
	slot0.formulaWire = slot3:Find("Wire")
	slot0.targetEquip = slot3:Find("Target")
	slot0.confirmBtn = slot3:Find("ConfirmBtn")
	slot0.cancelBtn = slot3:Find("CancelBtn")
	slot0.materialLayout = slot3:Find("Scroll View")
	slot0.materialLayoutContent = slot0.materialLayout:Find("Viewport/Content")
	slot0.goldText = slot3:Find("GoldText")

	setText(slot1:Find("Field/Text"), i18n("equipment_upgrade_quick_interface_source_chosen"))
	setText(slot3:Find("Text"), i18n("equipment_upgrade_quick_interface_materials_consume"))

	slot0.loader = AutoLoader.New()
end

slot0.SortType = {
	Rarity = "rarity",
	Strengthen = "level",
	Type = "type"
}
slot1 = {
	slot0.SortType.Rarity,
	slot0.SortType.Type,
	slot0.SortType.Strengthen
}
slot2 = {
	[slot0.SortType.Rarity] = "rarity",
	[slot0.SortType.Type] = "type",
	[slot0.SortType.Strengthen] = "strengthen"
}
slot0.SortOrder = {
	Descend = 0,
	Ascend = 1
}
slot3 = {
	[slot0.SortOrder.Descend] = "word_desc",
	[slot0.SortOrder.Ascend] = "word_asc"
}

slot0.SetEnv = function (slot0, slot1)
	slot0.env = slot1
end

slot0.GetAllPaths = function (slot0, slot1)
	slot2 = {}
	slot3 = {
		{
			slot1
		}
	}

	while #slot3 > 0 do
		for slot9, slot10 in ipairs(slot5) do
			table.insert((slot4[2] and Clone(slot4[2])) or {}, 1, slot10)
			table.insert(slot3, {
				pg.equip_upgrade_data[slot10].upgrade_from,
				(slot4[2] and Clone(slot4[2])) or 
			})

			if #slot0.env.tracebackHelper:GetEquipmentTransformCandicates(slot11) > 0 then
				table.insertto(slot2, _.map(slot13, function (slot0)
					return {
						source = slot0,
						formulas = slot0
					}
				end))
			end
		end
	end

	return slot2
end

slot0.UpdateSourceEquipmentPaths = function (slot0)
	slot0.totalPaths = slot0:GetAllPaths(slot0.contextData.TargetEquipmentId)

	if slot0.contextData.sourceEquipmentInstance then
		slot0.contextData.sourceEquipmentInstance = (_.detect(slot0.totalPaths, function (slot0)
			return EquipmentTransformUtil.SameDrop(slot0.source, slot0.contextData.sourceEquipmentInstance)
		end) and slot1.source) or nil
	end
end

slot0.UpdateSort = function (slot0)
	for slot4, slot5 in ipairs(slot0.totalPaths) do
		slot5.isSourceEnough = slot5.source.type ~= DROP_TYPE_ITEM or slot5.source.composeCfg.material_num <= slot5.source.template.count
		slot5.isMaterialEnough = slot5.isSourceEnough and EquipmentTransformUtil.CheckTransformFormulasSucceed(slot5.formulas, slot5.source)
	end

	table.sort(slot0.totalPaths, function (slot0, slot1)
		if slot0.isSourceEnough ~= slot1.isSourceEnough then
			return slot0.isSourceEnough
		end

		if slot0.isMaterialEnough ~= slot1.isMaterialEnough then
			return slot0.isMaterialEnough
		end

		if slot0.source.type ~= slot1.source.type then
			return slot0.source.type < slot1.source.type
		end

		slot2 = slot0.contextData.sortType
		slot3 = (slot0.contextData.sortOrder == slot1.SortOrder.Descend and 1) or -1

		if slot0.source.type == DROP_TYPE_ITEM then
			return (slot0.source.template.id - slot1.source.template.id) * slot3 > 0
		end

		if (slot0.source.template.shipId or -1) ~= (slot1.source.template.shipId or -1) then
			return slot4 < slot5
		end

		return ((slot0.source.template.config[slot2] - slot1.source.template.config[slot2] ~= 0 and slot8) or slot0.source.template.id - slot1.source.template.id) * slot3 > 0
	end)
	setText(slot0.orderText, i18n(slot1[slot0.contextData.sortOrder]))
	slot0.loader.GetSprite(slot1, "ui/equipmenttracebackui_atlas", slot2[slot0.contextData.sortType], slot0.sortImg)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.sortBarBtn, function ()
		setActive(slot0.sortBar, not isActive(slot0.sortBar))
	end, SFX_PANEL)

	for slot4 = 1, slot0.sortBar.childCount, 1 do
		onButton(slot0, slot0.sortBar.GetChild(slot5, slot4 - 1), function ()
			slot0.contextData.sortType = slot1[slot2]

			slot0.contextData:UpdateSort()
			slot0.contextData.UpdateSort:UpdateSourceList()
			setActive(slot0.sortBar, false)
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.sortOrderBtn, function ()
		slot0.contextData.sortOrder = slot1.SortOrder.Ascend - slot0.contextData.sortOrder

		slot0.contextData:UpdateSort()
		slot0.contextData.UpdateSort:UpdateSourceList()
	end, SFX_PANEL)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, slot0.confirmBtn, function ()
		if not slot0.contextData.sourceEquipmentInstance then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_quick_interface_feedback_source_chosen"))

			return
		end

		if not EquipmentTransformUtil.CheckTransformFormulasSucceed(slot0.contextData.sourceEquipmentFormulaList, slot0) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_materials"))

			return
		end

		slot0:emit(EquipmentTraceBackMediator.TRANSFORM_EQUIP, slot0, slot0.contextData.sourceEquipmentFormulaList)
	end, SFX_PANEL)

	slot0.contextData.sortOrder = slot0.contextData.sortOrder or slot0.contextData.SortOrder.Descend
	slot0.contextData.sortType = slot0.contextData.sortType or slot0.contextData.SortType.Rarity

	slot0.UpdateSourceEquipmentPaths(slot0)
	slot0:UpdateSort()
	slot0:UpdateSourceList()
	slot0:UpdateFormula()
	updateDrop(slot0.targetEquip, {
		type = DROP_TYPE_EQUIP,
		id = slot0.contextData.TargetEquipmentId
	})
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, true)
end

slot0.UpdateSourceList = function (slot0)
	slot0.lastSourceItem = nil

	UIItemList.StaticAlign(slot0.equipLayoutContent, slot0.equipLayoutContent:GetChild(0), #slot0.totalPaths, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:UpdateSourceListItem(slot1, slot2)
		end
	end)
	Canvas.ForceUpdateCanvases()

	slot0.equipLayout.GetComponent(slot2, typeof(ScrollRect)).enabled = not (slot0.equipLayoutContent.rect.height < slot0.equipLayout.rect.height)

	setActive(slot0.equipLayout:Find("Scrollbar"), not (slot0.equipLayoutContent.rect.height < slot0.equipLayout.rect.height))

	if slot0.equipLayoutContent.rect.height < slot0.equipLayout.rect.height then
		slot0.equipLayoutContent.anchoredPosition = Vector2.zero
	end
end

slot0.UpdateSourceListItem = function (slot0, slot1, slot2)
	updateDrop(slot2:Find("Item"), slot3)
	setText(slot2:Find("Item/icon_bg/count"), slot0.totalPaths[slot1 + 1].source.template.count)
	setActive(slot2:Find("EquipShip"), slot0.totalPaths[slot1 + 1].source.template.shipId)
	setActive(slot2:Find("Selected"), false)

	if slot0.totalPaths[slot1 + 1].source == slot0.contextData.sourceEquipmentInstance then
		slot0.lastSourceItem = slot2

		setActive(slot2:Find("Selected"), true)
	end

	setActive(slot2:Find("Item/mask"), false)

	if slot3.type == DROP_TYPE_ITEM then
		slot10 = slot6 .. "/" .. slot7
		slot11 = (slot3.composeCfg.material_num <= slot4.count and COLOR_WHITE) or COLOR_RED

		setText(slot2:Find("Item/icon_bg/count"), setColorStr)
		setActive(slot2:Find("Item/mask"), not (slot3.composeCfg.material_num <= slot4.count))
	end

	if slot4.shipId then
		slot0.loader:GetSprite("qicon/" .. getProxy(BayProxy):getShipById(slot4.shipId).getPainting(slot5), "", slot2:Find("EquipShip/Image"))
	end

	slot2:Find("Mask/NameText"):GetComponent(typeof(ScrollText)):SetText(slot4:getConfig("name"))
	onButton(slot0, slot2:Find("Item"), function ()
		if slot0.type == DROP_TYPE_ITEM and not (slot0.composeCfg.material_num <= slot0.template.count) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_fragment", slot0.template:getConfig("name")))

			return
		end

		if slot1.lastSourceItem then
			setActive(slot1.lastSourceItem:Find("Selected"), false)
		end

		slot1.lastSourceItem = slot2

		setActive(slot2:Find("Selected"), true)

		slot1.contextData.sourceEquipmentInstance = slot1.contextData
		slot1.contextData.sourceEquipmentFormulaList = slot1.contextData.totalPaths[slot3 + 1].formulas

		slot1.contextData.totalPaths[slot3 + 1].formulas:UpdateFormula()
	end, SFX_PANEL)
end

slot0.UpdatePlayer = function (slot0, slot1)
	slot0.player = slot1

	slot0:UpdateConsumeComparer()
end

slot0.UpdateConsumeComparer = function (slot0)
	slot1 = 0
	slot2 = 0
	slot3 = true

	if slot0.contextData.sourceEquipmentInstance then
		slot3, slot1, slot2 = EquipmentTransformUtil.CheckTransformEnoughGold(slot0.contextData.sourceEquipmentFormulaList, slot0.contextData.sourceEquipmentInstance)
	end

	slot4 = setColorStr(slot1, (slot3 and COLOR_WHITE) or COLOR_RED)

	if slot2 > 0 then
		slot4 = slot4 .. setColorStr(" + " .. slot2, (slot3 and COLOR_GREEN) or COLOR_RED)
	end

	slot0.goldText:GetComponent(typeof(Text)).text = slot4
end

slot0.UpdateFormula = function (slot0)
	setActive(slot0.sourceEquipStatus, not slot0.contextData.sourceEquipmentInstance)
	setActive(slot0.sourceEquip, slot1)
	setActive(slot0.materialLayout, slot0.contextData.sourceEquipmentInstance)

	if slot0.contextData.sourceEquipmentInstance then
		updateDrop(slot0.sourceEquip, slot1)

		slot2 = slot0.sourceEquip:Find("icon_bg/count")
		slot3 = ""

		if slot1 and slot1.type == DROP_TYPE_ITEM then
			slot3 = slot1.composeCfg.material_num
		end

		setText(slot2, slot3)
		slot0.loader:GetSprite("ui/equipmenttracebackui_atlas", ((not slot0.contextData.sourceEquipmentFormulaList or #slot4 <= 1) and "wire") or "wire2", slot0.formulaWire)
		slot0:UpdateFormulaMaterials()
	else
		slot0:UpdateConsumeComparer()
	end
end

slot0.UpdateFormulaMaterials = function (slot0)
	if not slot0.contextData.sourceEquipmentFormulaList then
		return
	end

	slot1 = {}
	slot2 = 0

	for slot6, slot7 in ipairs(slot0.contextData.sourceEquipmentFormulaList) do
		for slot12, slot13 in ipairs(pg.equip_upgrade_data[slot7].material_consume) do
			slot1[slot13[1]] = (slot1[slot13[1]] or 0) + slot13[2]
		end

		slot2 = slot2 + slot8.coin_consume
	end

	slot3 = {}

	for slot7, slot8 in pairs(slot1) do
		table.insert(slot3, {
			id = slot7,
			count = slot8
		})
	end

	table.sort(slot3, function (slot0, slot1)
		return slot1.id < slot0.id
	end)

	slot0.consumeMaterials = slot3

	UIItemList.StaticAlign(slot0.materialLayoutContent, slot0.materialLayoutContent.GetChild(slot6, 0), #slot0.consumeMaterials, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:UpdateFormulaMaterialItem(slot1, slot2)
		end
	end)
	Canvas.ForceUpdateCanvases()

	slot0.materialLayout.GetComponent(slot5, typeof(ScrollRect)).enabled = not (slot0.materialLayoutContent.rect.height < slot0.materialLayout.rect.height)

	setActive(slot0.materialLayout:Find("Scrollbar"), not (slot0.materialLayoutContent.rect.height < slot0.materialLayout.rect.height))

	if slot0.materialLayoutContent.rect.height < slot0.materialLayout.rect.height then
		slot0.materialLayoutContent.anchoredPosition = Vector2.zero
	end

	slot0:UpdateConsumeComparer()
end

slot0.UpdateFormulaMaterialItem = function (slot0, slot1, slot2)
	updateDrop(slot2:Find("Item"), slot4)
	setText(slot2:Find("Count"), setColorStr(slot0.consumeMaterials[slot1 + 1].count, (slot0.consumeMaterials[slot1 + 1].count <= getProxy(BagProxy):getItemCountById(slot0.consumeMaterials[slot1 + 1].id) and COLOR_GREEN) or COLOR_RED) .. "/" .. slot5)
	onButton(slot0, slot2:Find("Item"), function ()
		slot0:emit(slot1.ON_DROP, )
	end)
end

slot0.willExit = function (slot0)
	slot0.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

return slot0

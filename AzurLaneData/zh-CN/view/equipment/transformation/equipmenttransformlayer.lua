slot0 = class("EquipmentTransformLayer", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "EquipmentTransformUI"
end

slot0.init = function (slot0)
	slot0.layer = slot0:findTF("Adapt")
	slot0.formulaItems = {
		slot0.layer:Find("MaterialModule1"),
		slot0.layer:Find("MaterialModule2"),
		slot0.layer:Find("MaterialModule3")
	}
	slot0.sourceEquipItem = slot0.layer:Find("SourceEquip")
	slot0.targetEquipItem = slot0.layer:Find("TargetEquip")
	slot0.consumePanel = slot0.layer:Find("ComposePanel")

	setText(slot0._tf:Find("Adapt/TitleText"), i18n("equipment_upgrade_title"))
	setText(slot0.consumePanel:Find("Consume"), i18n("equipment_upgrade_coin_consume"))
	setText(slot0._tf:Find("Adapt/InfoPanel/StoreCount/OnShip/NameText"), i18n("equipment_upgrade_equipped_tag"))
	setText(slot0._tf:Find("Adapt/InfoPanel/StoreCount/Free/NameText"), i18n("equipment_upgrade_spare_tag"))

	slot1 = slot0._tf:Find("Adapt/InfoPanel/Viewport/Content")
	slot2 = slot1:Find("attr_tpl")

	setActive(slot2, false)
	setActive(slot2:Find("subs"), false)

	Instantiate(slot2).transform.name = "attr"

	setParent(slot3, slot1:Find("skill"))
	Instantiate(slot2).transform.SetAsFirstSibling(slot3)

	Instantiate(slot2).transform.name = "attr"

	setParent(slot4, slot1:Find("part"))
	Instantiate(slot2).transform:SetAsFirstSibling()

	slot0.loader = AutoLoader.New()
end

slot0.SetEnv = function (slot0, slot1)
	slot0.env = slot1
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
		slot3, slot1, slot2 = EquipmentTransformUtil.CheckTransformEnoughGold({
			slot0.contextData.formulaId
		}, slot0.contextData.sourceEquipmentInstance)
	end

	slot4 = setColorStr(slot1, (slot3 and COLOR_WHITE) or COLOR_RED)

	if slot2 > 0 then
		slot4 = slot4 .. setColorStr(" + " .. slot2, (slot3 and COLOR_GREEN) or COLOR_RED)
	end

	slot0.consumePanel:Find("GoldText"):GetComponent(typeof(Text)).text = slot4
end

slot0.UpdateFormula = function (slot0, slot1)
	if slot1 == slot0.contextData.formulaId then
		return
	end

	slot0.contextData.formulaId = slot1
	slot0.contextData.formula = pg.equip_upgrade_data[slot1]
	slot0.equipmentSourceId = pg.equip_upgrade_data[slot1].upgrade_from
	slot0.equipmentTarget = pg.equip_upgrade_data[slot1].target_id
	slot0.transformMaterials = pg.equip_upgrade_data[slot1].material_consume

	slot0:UpdateConsumeComparer()

	slot3 = slot0.env.tracebackHelper:GetEquipmentTransformCandicates(slot0.equipmentSourceId)
	slot4 = nil

	if slot0.contextData.sourceEquipmentInstance then
		slot5 = _.detect(slot3, function (slot0)
			return EquipmentTransformUtil.SameDrop(slot0, slot0.contextData.sourceEquipmentInstance)
		end)
		slot4 = slot5
	end

	slot0.contextData.sourceEquipmentInstance = slot4

	PlayerPrefs.SetInt("ShowTransformTip_" .. slot0.equipmentTarget, 1)
	PlayerPrefs.Save()
	slot0:emit(EquipmentTransformMediator.UPDATE_NEW_FLAG, slot0.equipmentTarget)
	setActive(slot0.layer:Find("SwitchButton"), #EquipmentProxy.GetTransformSources(slot0.equipmentTarget) > 1)
	slot0:UpdatePage()
end

slot0.UpdatePage = function (slot0)
	slot0:UpdateSourceEquipmentPaths()
	slot0:UpdateFormulaItems()
	slot0:UpdateTargetInfo()
	slot0:UpdateSourceInfo()
end

slot0.UpdateSourceEquipmentPaths = function (slot0)
	slot0.hasRoot = _.any(slot1, function (slot0)
		return slot0.candicates and #slot1 > 0 and EquipmentTransformUtil.CheckTransformFormulasSucceed(slot0.formulas, slot1[#slot1])
	end)
	slot0.childsCanUse = _.any(slot0.env.tracebackHelper.GetEquipmentTransformCandicates(slot2, slot0.equipmentSourceId), function (slot0)
		if slot0.type == DROP_TYPE_ITEM then
			return slot0.composeCfg.material_num <= slot0.template.count
		elseif slot0.type == DROP_TYPE_EQUIP then
			return slot0.template.count > 0
		end
	end)
end

slot0.CheckEnoughMaterials = function (slot0)
	if not slot0.contextData.formula then
		return
	end

	if not slot0.contextData.sourceEquipmentInstance then
		return
	end

	slot2, slot3 = EquipmentTransformUtil.CheckTransformFormulasSucceed({
		slot0.contextData.formulaId
	}, slot0.contextData.sourceEquipmentInstance)

	if not slot2 then
		return false, slot3
	end

	return true
end

slot0.UpdateFormulaItems = function (slot0)
	for slot4, slot5 in ipairs(slot0.formulaItems) do
		slot6 = slot5:Find("Item")

		setActive(slot5, slot0.transformMaterials[slot4])

		if slot0.transformMaterials[slot4] then
			updateDrop(slot6, slot8)
			onButton(slot0, slot6, function ()
				slot0:emit(slot1.ON_DROP, )
			end, SFX_PANEL)
			setText(slot5:Find("NumText"), setColorStr(getProxy(BagProxy).getItemCountById(slot9, slot7[1]) or 0, ((getProxy(BagProxy).getItemCountById(slot9, slot7[1]) or 0) < slot7[2] and COLOR_RED) or "#000F") .. "/" .. slot7[2])
			setActive(slot5:Find("Line"), not (slot0.equipmentSourceId == 0))
			setActive(slot5:Find("Line2"), slot0.equipmentSourceId == 0)
		end
	end
end

slot0.UpdateTargetInfo = function (slot0)
	updateDrop(slot0.targetEquipItem:Find("Item"), {
		id = slot0.equipmentTarget,
		type = DROP_TYPE_EQUIP
	})
	slot0.targetEquipItem:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(pg.equip_data_statistics[slot0.equipmentTarget].name)

	slot2 = slot0.layer:Find("InfoPanel")
	slot4 = 0
	slot5 = 0

	for slot9, slot10 in ipairs(slot3) do
		if slot10.type == DROP_TYPE_EQUIP then
			if slot10.template.shipId then
				slot4 = slot4 + slot10.template.count
			else
				slot5 = slot5 + slot10.template.count
			end
		end
	end

	setText(slot2:Find("StoreCount/OnShip/ValueText"), slot4)
	setText(slot2:Find("StoreCount/Free/ValueText"), slot5)

	slot6 = Equipment.New({
		id = slot0.equipmentTarget
	})
	slot7 = slot2:Find("Viewport/Content")

	updateEquipInfo(slot7, slot6:GetPropertiesInfo(), slot6:GetSkill())
	Canvas.ForceUpdateCanvases()
	slot0.FitTextBGSize(slot7:Find("attrs"))
	slot0.FitTextBGSize(slot7:Find("weapon"))
	slot0.FitTextBGSize(slot7:Find("equip_info"))
end

slot0.FitTextBGSize = function (slot0)
	for slot4 = 0, slot0.childCount - 1, 1 do
		slot5 = slot0:GetChild(slot4)
		slot5:Find("base/NameBG").sizeDelta.x = slot5:Find("base/name").rect.width + 18
		slot5:Find("base/NameBG").sizeDelta = slot5.Find("base/NameBG").sizeDelta

		slot0.FitTextBGSize(slot5:Find("subs"))
	end
end

slot0.UpdateSourceInfo = function (slot0)
	slot2 = slot0.contextData.sourceEquipmentInstance or {
		id = slot0.equipmentSourceId,
		type = DROP_TYPE_EQUIP
	}

	setActive(slot0.sourceEquipItem, not (slot0.equipmentSourceId == 0))

	if slot0.equipmentSourceId == 0 then
		return
	end

	updateDrop(slot0.sourceEquipItem:Find("Item"), slot2)

	slot4 = slot0.sourceEquipItem:Find("Item/icon_bg/count")
	slot5 = ""

	if slot1 and slot1.type == DROP_TYPE_ITEM then
		slot5 = setColorStr(math.min(slot1.template.count, slot1.composeCfg.material_num), (slot1.composeCfg.material_num <= slot1.template.count and COLOR_WHITE) or COLOR_RED)
	end

	setText(slot4, slot5)
	slot0.sourceEquipItem:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(pg.equip_data_statistics[slot0.equipmentSourceId].name)
	setActive(slot0.sourceEquipItem:Find("craftable"), slot0.hasRoot)
	onButton(slot0, slot0.sourceEquipItem:Find("craftable"), function ()
		slot0:emit(EquipmentTransformMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = slot0.equipmentSourceId
			}
		}))
	end, SFX_PANEL)
	onButton(slot0, slot0.sourceEquipItem:Find("Item"), function ()
		if slot0.childsCanUse then
			slot0:emit(EquipmentTransformMediator.SELECT_TRANSFORM_FROM_STOREHOUSE, slot0.equipmentSourceId)
		end
	end, SFX_PANEL)

	slot7 = slot0.sourceEquipItem.Find(slot7, "Status")

	if not slot0.childsCanUse then
		setImageSprite(slot7, LoadSprite("ui/equipmenttransformui_atlas", "noown"))
		setActive(slot7, true)
	elseif not slot1 then
		setImageSprite(slot7, LoadSprite("ui/equipmenttransformui_atlas", "unselect"))
		setActive(slot7, true)
	else
		setActive(slot7, false)
	end

	setActive(slot0.sourceEquipItem:Find("EquipShip"), slot1 and slot1.template.shipId)

	if slot1 and slot1.template.shipId then
		slot0.loader:GetSprite("qicon/" .. getProxy(BayProxy):getShipById(slot8).getPainting(slot9), "", slot0.sourceEquipItem:Find("EquipShip/Image"))
	end
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._tf:Find("BG"), function ()
		slot0:closeView()
	end)
	onButton(slot0, slot0.consumePanel:Find("ComposeBtn"), function ()
		if slot0.equipmentSourceId ~= 0 and not slot0 then
			if slot0.childsCanUse then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_quick_interface_feedback_source_chosen"))

				return
			elseif slot0.hasRoot then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_equipment_can_be_produced"))

				return
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_equipment"))

				return
			end
		end

		if not slot0:CheckEnoughMaterials() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_materials"))

			return
		end

		slot0:emit(EquipmentTransformMediator.TRANSFORM_EQUIP, slot0, slot0.contextData.formulaId)
	end, SFX_PANEL)
	onButton(slot0, slot0.layer:Find("OverviewBtn"), function ()
		slot0:emit(EquipmentTransformMediator.OPEN_TRANSFORM_TREE, slot0.equipmentTarget)
	end, SFX_CANCEL)
	onButton(slot0, slot0.layer:Find("SwitchButton"), function ()
		slot0:UpdateFormula(slot0[(table.indexof(EquipmentProxy.GetTransformSources(slot0.equipmentTarget), slot0.contextData.formulaId) and slot1 % #slot0 + 1) or 1])
	end, SFX_PANEL)
	onButton(slot0, slot0.layer:Find("HelpBtn"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.equipment_upgrade_help.tip
		})
	end, SFX_PANEL)

	slot0.contextData.formulaId = nil

	slot0.UpdateFormula(slot0, slot1)

	slot2, slot3 = getProxy(ContextProxy):getContextByMediator(EquipmentTransformMediator)

	setActive(slot0.layer:Find("OverviewBtn"), slot3 and pg.m02:retrieveMediator(slot3.mediator.__cname).class ~= EquipmentTransformTreeMediator)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.willExit = function (slot0)
	slot0.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
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

	for slot8 = 0, slot0.childCount - 1, 1 do
		setActive(slot0:GetChild(slot8), slot8 < slot1)
	end

	for slot8 = slot4, slot1 + 1, -1 do
		table.remove(slot2)
	end

	return slot2
end

return slot0

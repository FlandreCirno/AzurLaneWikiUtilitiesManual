slot0 = class("EquipmentDesignLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "EquipmentDesignUI"
end

slot0.setItems = function (slot0, slot1)
	slot0.itemVOs = slot1
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1
end

slot0.setCapacity = function (slot0, slot1)
	slot0.capacity = slot1
end

slot0.init = function (slot0)
	slot0.parentTF = GameObject.Find("/UICamera/Canvas/UIMain/StoreHouseUI(Clone)")
	slot0.equipmentView = slot0:findTF("equipment_scrollview", slot0.parentTF)
	slot0.designScrollView = slot0:findTF("equipment_scrollview")
	slot0.equipmentTpl = slot0:findTF("equipment_tpl")
	slot0.equipmentContainer = slot0:findTF("equipment_grid", slot0.designScrollView)
	slot0.msgBoxTF = slot0:findTF("msg_panel")

	setActive(slot0.msgBoxTF, false)

	slot0.top = slot0:findTF("top")
	slot0.sortBtn = slot0:findTF("sort_button", slot0.top)
	slot0.indexBtn = slot0:findTF("index_button", slot0.top)
	slot0.decBtn = slot0:findTF("dec_btn", slot0.sortBtn)
	slot0.sortImgAsc = slot0:findTF("asc", slot0.decBtn)
	slot0.sortImgDec = slot0:findTF("desc", slot0.decBtn)
	slot0.indexPanel = slot0:findTF("index")
	slot0.tagContainer = slot0:findTF("adapt/mask/panel", slot0.indexPanel)
	slot0.tagTpl = slot0:findTF("tpl", slot0.tagContainer)
	slot0.UIMgr = pg.UIMgr.GetInstance()

	setActive(slot0.equipmentView, false)
	setParent(slot0._tf, slot0.parentTF)
	slot0._tf:SetSiblingIndex(slot1)

	slot0.listEmptyTF = slot0:findTF("empty")

	setActive(slot0.listEmptyTF, false)

	slot0.listEmptyTxt = slot0:findTF("Text", slot0.listEmptyTF)

	setText(slot0.listEmptyTxt, i18n("list_empty_tip_equipmentdesignui"))
	pg.UIMgr.GetInstance():OverlayPanel(slot0.indexPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
end

slot1 = {
	"sort_default",
	"sort_rarity",
	"sort_count"
}

slot0.didEnter = function (slot0)
	slot0.contextData.indexDatas = slot0.contextData.indexDatas or {}
	slot0.topPanel = GameObject.Find("/OverlayCamera/Overlay/UIMain/blur_panel/adapt/top")

	setParent(slot0.top, slot0.topPanel)
	slot0:initDesigns()
	onToggle(slot0, slot0.sortBtn, function (slot0)
		if slot0 then
			setActive(slot0.indexPanel, true)
		else
			setActive(slot0.indexPanel, false)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.indexPanel, function ()
		triggerToggle(slot0.sortBtn, false)
	end, SFX_PANEL)
	onButton(slot0, slot0.indexBtn, function ()
		slot0.emit(slot1, EquipmentDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, {
			indexDatas = Clone(slot0.contextData.indexDatas),
			customPanels = {
				minHeight = 650,
				typeIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipmentTypeIndexs,
					names = IndexConst.EquipmentTypeNames
				},
				equipPropertyIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipPropertyIndexs,
					names = IndexConst.EquipPropertyNames
				},
				equipPropertyIndex2 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipPropertyIndexs,
					names = IndexConst.EquipPropertyNames
				},
				equipAmmoIndex1 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipAmmoIndexs_1,
					names = IndexConst.EquipAmmoIndexs_1_Names
				},
				equipAmmoIndex2 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipAmmoIndexs_2,
					names = IndexConst.EquipAmmoIndexs_2_Names
				},
				equipCampIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.EquipCampIndexs,
					names = IndexConst.EquipCampNames
				},
				rarityIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.EquipmentRarityIndexs,
					names = IndexConst.RarityNames
				}
			},
			groupList = {
				{
					dropdown = false,
					titleTxt = "indexsort_type",
					titleENTxt = "indexsort_typeeng",
					tags = {
						"typeIndex"
					}
				},
				{
					dropdown = true,
					titleTxt = "indexsort_index",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"equipPropertyIndex",
						"equipPropertyIndex2",
						"equipAmmoIndex1",
						"equipAmmoIndex2"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_camp",
					titleENTxt = "indexsort_campeng",
					tags = {
						"equipCampIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_rarity",
					titleENTxt = "indexsort_rarityeng",
					tags = {
						"rarityIndex"
					}
				}
			},
			dropdownLimit = {
				equipPropertyIndex = {
					include = {
						typeIndex = IndexConst.EquipmentTypeAll
					},
					exclude = {}
				},
				equipPropertyIndex2 = {
					include = {
						typeIndex = IndexConst.EquipmentTypeEquip
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				},
				equipAmmoIndex1 = {
					include = {
						typeIndex = IndexConst.BitAll({
							IndexConst.EquipmentTypeSmallCannon,
							IndexConst.EquipmentTypeMediumCannon,
							IndexConst.EquipmentTypeBigCannon
						})
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				},
				equipAmmoIndex2 = {
					include = {
						typeIndex = IndexConst.BitAll({
							IndexConst.EquipmentTypeWarshipTorpedo,
							IndexConst.EquipmentTypeSubmaraineTorpedo
						})
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				}
			},
			callback = function (slot0)
				if not isActive(slot0._tf) then
					return
				end

				slot0.contextData.indexDatas.typeIndex = slot0.typeIndex
				slot0.contextData.indexDatas.equipPropertyIndex = slot0.equipPropertyIndex
				slot0.contextData.indexDatas.equipPropertyIndex2 = slot0.equipPropertyIndex2
				slot0.contextData.indexDatas.equipAmmoIndex1 = slot0.equipAmmoIndex1
				slot0.contextData.indexDatas.equipAmmoIndex2 = slot0.equipAmmoIndex2
				slot0.contextData.indexDatas.equipCampIndex = slot0.equipCampIndex
				slot0.contextData.indexDatas.rarityIndex = slot0.rarityIndex

				slot0:filter(slot0.contextData.index or 1)
			end
		})
	end, SFX_PANEL)
	slot0.initTags(slot0)
end

slot0.isDefaultStatus = function (slot0)
	return (not slot0.contextData.indexDatas.typeIndex or slot0.contextData.indexDatas.typeIndex == IndexConst.EquipmentTypeAll) and (not slot0.contextData.indexDatas.equipPropertyIndex or slot0.contextData.indexDatas.equipPropertyIndex == IndexConst.EquipPropertyAll) and (not slot0.contextData.indexDatas.equipPropertyIndex2 or slot0.contextData.indexDatas.equipPropertyIndex2 == IndexConst.EquipPropertyAll) and (not slot0.contextData.indexDatas.equipAmmoIndex1 or slot0.contextData.indexDatas.equipAmmoIndex1 == IndexConst.EquipAmmoAll_1) and (not slot0.contextData.indexDatas.equipAmmoIndex2 or slot0.contextData.indexDatas.equipAmmoIndex2 == IndexConst.EquipAmmoAll_2) and (not slot0.contextData.indexDatas.equipCampIndex or slot0.contextData.indexDatas.equipCampIndex == IndexConst.EquipCampAll) and (not slot0.contextData.indexDatas.rarityIndex or slot0.contextData.indexDatas.rarityIndex == IndexConst.EquipmentRarityAll)
end

slot0.initTags = function (slot0)
	onButton(slot0, slot0.decBtn, function ()
		slot0.asc = not slot0.asc
		slot0.contextData.asc = slot0.asc

		slot0(slot0.contextData, slot0.contextData.index or 1)
	end)

	slot0.tagTFs = {}

	eachChild(slot0.tagContainer, function (slot0)
		setActive(slot0, false)
	end)

	for slot4, slot5 in ipairs(slot0) do
		setActive((slot4 <= slot0.tagContainer.childCount and slot0.tagContainer.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.tagTpl, slot0.tagContainer), true)
		setImageSprite(findTF((slot4 <= slot0.tagContainer.childCount and slot0.tagContainer.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.tagTpl, slot0.tagContainer), "Image"), GetSpriteFromAtlas("ui/equipmentdesignui_atlas", slot5))
		onToggle(slot0, (slot4 <= slot0.tagContainer.childCount and slot0.tagContainer.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.tagTpl, slot0.tagContainer), function (slot0)
			if slot0 then
				slot0:filter(slot0.filter)
				triggerButton(slot0.indexPanel)

				slot0.contextData.index = slot0.contextData
			else
				triggerButton(slot0.indexPanel)
			end
		end, SFX_PANEL)
		table.insert(slot0.tagTFs, slot6)

		if not slot0.contextData.index then
			slot0.contextData.index = slot4
		end
	end

	triggerToggle(slot0.tagTFs[slot0.contextData.index], true)
end

slot0.initDesigns = function (slot0)
	slot0.scollRect = slot0.designScrollView:GetComponent("LScrollRect")
	slot0.scollRect.decelerationRate = 0.07

	slot0.scollRect.onInitItem = function (slot0)
		slot0:initDesign(slot0)
	end

	slot0.scollRect.onUpdateItem = function (slot0, slot1)
		slot0:updateDesign(slot0, slot1)
	end

	slot0.scollRect.onReturnItem = function (slot0, slot1)
		slot0:returnDesign(slot0, slot1)
	end

	slot0.desgins = {}
end

function slot2(slot0, slot1)
	setImageSprite(findTF(slot0, "name_bg/tag"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(slot1.config.type)))
	eachChild(slot2, function (slot0)
		setActive(slot0, false)
	end)

	slot5 = underscore.filter(slot1.GetPropertiesInfo(slot1).attrs, function (slot0)
		return not slot0.type or slot0.type ~= AttributeType.AntiSiren
	end)
	slot4 = slot5
	slot6 = (slot1.config.skill_id[1] and slot1:isDevice() and {
		1,
		2,
		5
	}) or {
		1,
		4,
		2,
		3
	}

	for slot10, slot11 in ipairs(slot6) do
		setActive(slot2:Find("attr_" .. slot11), true)

		if slot11 == 5 then
			setText(slot12:Find("value"), getSkillName(slot5))
		else
			slot13 = ""
			slot14 = ""

			if #slot4 > 0 then
				slot13, slot14 = Equipment.GetInfoTrans(slot15)
			end

			setText(slot12:Find("tag"), slot13)
			setText(slot12:Find("value"), slot14)
		end
	end
end

slot0.createDesign = function (slot0, slot1)
	slot2 = findTF(slot1, "info/count")
	slot3 = findTF(slot1, "mask")

	ClearTweenItemAlphaAndWhite(({
		go = slot1,
		nameTxt = slot0:findTF("name_bg/mask/name", slot1),
		getItemById = function (slot0, slot1)
			return slot0.itemVOs[slot1] or Item.New({
				count = 0,
				id = slot1
			})
		end,
		update = function (slot0, slot1, slot2)
			slot0.designId = slot1
			slot0.itemVOs = slot2

			TweenItemAlphaAndWhite(slot0.go)
			setText(slot0.nameTxt, shortenString(pg.equip_data_statistics[pg.compose_data_template[slot1].equip_id].name, 6))
			updateEquipment(slot7, slot6)
			slot3(slot0, slot6)
			function ()
				setText(setText, (slot1.material_num <= slot0.itemVOs[slot1.material_id] or Item.New({
					count = 0,
					id = slot1.material_id
				}).count and setColorStr(slot1, COLOR_WHITE)) or setColorStr(slot1, COLOR_RED))
				setActive(setText, slot0.itemVOs[slot1.material_id] or Item.New().count < (slot1.material_num <= slot0.itemVOs[slot1.material_id] or Item.New().count and setColorStr(slot1, COLOR_WHITE)) or setColorStr(slot1, COLOR_RED).material_num)
			end()
		end,
		clear = function (slot0)
			ClearTweenItemAlphaAndWhite(slot0.go)
		end
	})["go"])

	return 
end

slot0.initDesign = function (slot0, slot1)
	onButton(slot0, tf(slot0:createDesign(slot1).go):Find("info/make_btn"), function ()
		slot0:showDesignDesc(slot1.designId)
	end)

	slot0.desgins[slot1] = slot0.createDesign(slot1)
end

slot0.updateDesign = function (slot0, slot1, slot2)
	if not slot0.desgins[slot2] then
		slot0:initDesign(slot2)

		slot3 = slot0.desgins[slot2]
	end

	slot3:update(slot0.desginIds[slot1 + 1], slot0.itemVOs)
end

slot0.returnDesign = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	if slot0.desgins[slot2] then
		slot3:clear()
	end
end

slot0.getDesignVO = function (slot0, slot1)
	slot7 = pg.equip_data_statistics[pg.compose_data_template[slot1].equip_id]
	slot8 = pg.equip_data_template[pg.compose_data_template[slot1].equip_id]

	if setmetatable({}, {
		__index = function (slot0, slot1)
			return slot0[slot1] or slot1[slot1]
		end
	}).weapon_id and #slot10 > 0 and pg.weapon_property[slot10[1]] then
		slot9[AttributeType.CD] = slot11.reload_max
	end

	slot2.config = slot9

	slot2.getNation = function (slot0)
		return slot0.nationality
	end

	slot2.getConfig = function (slot0, slot1)
		return slot0[slot1]
	end

	return slot2
end

slot0.filter = function (slot0, slot1)
	GetSpriteFromAtlasAsync("ui/commonui_atlas", (slot0:isDefaultStatus() and "shaixuan_off") or "shaixuan_on", function (slot0)
		setImageSprite(slot0.indexBtn, slot0, true)
	end)

	slot4 = {}
	slot5 = slot0.asc

	for slot9, slot10 in ipairs(pg.compose_data_template.all) do
		if slot0.getItemById(slot0, pg.compose_data_template[slot10].material_id).count > 0 then
			table.insert(slot4, slot10)
		end
	end

	slot6 = {}
	slot7 = table.mergeArray({}, {
		slot0.contextData.indexDatas.equipPropertyIndex,
		slot0.contextData.indexDatas.equipPropertyIndex2
	}, true)

	for slot11, slot12 in pairs(slot4) do
		if IndexConst.filterEquipByType(slot0:getDesignVO(slot12), slot0.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(slot13, slot7) and IndexConst.filterEquipAmmo1(slot13, slot0.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(slot13, slot0.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(slot13, slot0.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(slot13, slot0.contextData.indexDatas.rarityIndex) then
			table.insert(slot6, slot12)
		end
	end

	if slot1 == 1 then
		if slot5 then
			table.sort(slot6, function (slot0, slot1)
				if slot0:getDesignVO(slot0).canMake == slot0:getDesignVO(slot1).canMake then
					if slot2.equipmentCfg.rarity == slot3.equipmentCfg.rarity then
						return slot2.equipmentCfg.id < slot3.equipmentCfg.id
					else
						return slot3.equipmentCfg.rarity < slot2.equipmentCfg.rarity
					end
				else
					return slot2.canMake < slot3.canMake
				end
			end)
		else
			table.sort(slot6, function (slot0, slot1)
				if slot0:getDesignVO(slot0).canMake == slot0:getDesignVO(slot1).canMake then
					if slot2.equipmentCfg.rarity == slot3.equipmentCfg.rarity then
						return slot2.equipmentCfg.id < slot3.equipmentCfg.id
					else
						return slot3.equipmentCfg.rarity < slot2.equipmentCfg.rarity
					end
				else
					return slot3.canMake < slot2.canMake
				end
			end)
		end
	elseif slot1 == 2 then
		if slot0.asc then
			table.sort(slot6, function (slot0, slot1)
				if slot0:getDesignVO(slot0).equipmentCfg.rarity == slot0:getDesignVO(slot1).equipmentCfg.rarity then
					return slot2.equipmentCfg.id < slot2.equipmentCfg.id
				end

				return slot2.equipmentCfg.rarity < slot3.equipmentCfg.rarity
			end)
		else
			table.sort(slot6, function (slot0, slot1)
				if slot0:getDesignVO(slot0).equipmentCfg.rarity == slot0:getDesignVO(slot1).equipmentCfg.rarity then
					return slot2.equipmentCfg.id < slot2.equipmentCfg.id
				end

				return slot3.equipmentCfg.rarity < slot2.equipmentCfg.rarity
			end)
		end
	elseif slot1 == 3 then
		if slot0.asc then
			table.sort(slot6, function (slot0, slot1)
				if slot0:getDesignVO(slot0).itemCount == slot0:getDesignVO(slot1).itemCount then
					return slot2.equipmentCfg.id < slot3.equipmentCfg.id
				end

				return slot2.itemCount < slot3.itemCount
			end)
		else
			table.sort(slot6, function (slot0, slot1)
				if slot0:getDesignVO(slot0).itemCount == slot0:getDesignVO(slot1).itemCount then
					return slot2.equipmentCfg.id < slot3.equipmentCfg.id
				end

				return slot3.itemCount < slot2.itemCount
			end)
		end
	end

	slot0.desginIds = slot6

	slot0.scollRect.SetTotalCount(slot8, #slot6, 0)
	setActive(slot0.listEmptyTF, #slot6 <= 0)
	Canvas.ForceUpdateCanvases()
	setImageSprite(slot0:findTF("Image", slot0.sortBtn), setActive)
	setActive(slot0.sortImgAsc, slot0.asc)
	setActive(slot0.sortImgDec, not slot0.asc)
end

slot0.getItemById = function (slot0, slot1)
	return slot0.itemVOs[slot1] or Item.New({
		count = 0,
		id = slot1
	})
end

slot0.showDesignDesc = function (slot0, slot1)
	slot0.isShowDesc = true

	if IsNil(slot0.msgBoxTF) then
		return
	end

	slot0.UIMgr:BlurPanel(slot0.msgBoxTF)
	setActive(slot0.msgBoxTF, true)

	slot5 = Equipment.New({
		id = pg.compose_data_template[slot1].equip_id
	})

	updateEquipInfo(slot0.msgBoxTF.Find(slot2, "bg/attrs/content"), slot5:GetPropertiesInfo(), slot5:GetSkill())
	GetImageSpriteFromAtlasAsync("equips/" .. slot5.config.icon, "", slot6)
	setText(slot0.msgBoxTF.Find(slot2, "bg/name"), slot5.config.name)
	UIItemList.New(slot0.msgBoxTF.Find(slot2, "bg/frame/stars"), slot0.msgBoxTF.Find(slot2, "bg/frame/stars/sarttpl")).align(slot7, slot5.config.rarity)
	setImageSprite(findTF(slot2, "bg/frame/type"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(slot5.config.type)))
	setText(slot0.msgBoxTF.Find(slot2, "bg/frame/speciality/Text"), (slot5.config.speciality ~= "无" and slot5.config.speciality) or i18n1("—"))

	slot2:Find("bg/frame"):GetComponent(typeof(Image)).sprite = LoadSprite("bg/equipment_bg_" .. slot5.config.rarity)
	slot9 = findTF(slot2, "bg/frame/numbers")
	slot10 = slot5.config.tech or 1

	for slot14 = 0, slot9.childCount - 1, 1 do
		setActive(slot9:GetChild(slot14), slot14 == slot10)
	end

	slot12 = math.floor(slot0:getItemById(slot3.material_id).count / slot3.material_num)
	slot14 = slot0:findTF("bg/calc/values/Text", slot2)
	slot15 = slot3.gold_num
	slot16 = slot0:findTF("bg/calc/gold/Text", slot2)

	function slot17(slot0)
		setText(slot0, slot0)
		setText(setText, slot0 * slot2)
	end

	slot17(slot13)
	onButton(slot0, findTF(slot2, "bg/calc/minus"), function ()
		if slot0 <= 1 then
			return
		end

		slot0 = slot0 - 1

		slot1(slot1)
	end, SFX_PANEL)
	onButton(slot0, findTF(slot2, "bg/calc/add"), function ()
		if slot0 == slot1 then
			return
		end

		slot0 = slot0 + 1

		slot2(slot2)
	end, SFX_PANEL)
	onButton(slot0, findTF(slot2, "bg/calc/max"), function ()
		if slot0 == slot1 then
			return
		end

		1(math.max(math.min(slot1, slot2.player:getMaxEquipmentBag() - slot2.capacity), 1))
	end, SFX_PANEL)
	onButton(slot0, findTF(slot2, "bg/cancel_btn"), function ()
		slot0:hideMsgBox()
	end, SFX_CANCEL)
	onButton(slot0, findTF(slot2, "bg/confirm_btn"), function ()
		slot0:emit(EquipmentDesignMediator.MAKE_EQUIPMENT, slot0, )
		slot0.emit:hideMsgBox()
	end, SFX_CONFIRM)
	onButton(slot0, slot2, function ()
		slot0:hideMsgBox()
	end, SFX_CANCEL)
end

slot0.hideMsgBox = function (slot0)
	if not IsNil(slot0.msgBoxTF) then
		slot0.isShowDesc = nil

		slot0.UIMgr:UnblurPanel(slot0.msgBoxTF, slot0._tf)
		setActive(slot0.msgBoxTF, false)
	end
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.indexPanel) then
		triggerButton(slot0.indexPanel)

		return
	end

	if slot0.isShowDesc then
		slot0:hideMsgBox()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		slot0:emit(slot0.ON_BACK)
	end
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.indexPanel, slot0._tf)

	if slot0.leftEventTrigger then
		ClearEventTrigger(slot0.leftEventTrigger)
	end

	if slot0.rightEventTrigger then
		ClearEventTrigger(slot0.rightEventTrigger)
	end

	setParent(slot0.sortBtn.parent, slot0._tf)
end

return slot0

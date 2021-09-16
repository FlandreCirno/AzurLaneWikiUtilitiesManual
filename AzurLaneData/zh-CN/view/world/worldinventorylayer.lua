slot0 = class("WorldInventoryLayer", import("..base.BaseUI"))
slot1 = require("view.equipment.EquipmentSortCfg")
slot0.PAGE = {
	Equipment = 2,
	Property = 1,
	Material = 3
}

slot0.getUIName = function (slot0)
	return "WorldInventoryUI"
end

slot0.init = function (slot0)
	slot0.itemUpdateListenerFunc = function (...)
		slot0:setItemList(slot0.inventoryProxy:GetItemList())
	end

	slot0.blurPanel = slot0.findTF(slot0, "blur_panel")
	slot0.backBtn = slot0:findTF("adapt/top/back_btn", slot0.blurPanel)
	slot0.topItems = slot0:findTF("topItems")
	slot0.itemView = slot0:findTF("item_scrollview")
	slot0.equipmentView = slot0:findTF("equipment_scrollview")
	slot0.materialtView = slot0:findTF("material_scrollview")
	slot1 = nil
	slot2 = getProxy(SettingsProxy)

	if NotchAdapt.CheckNotchRatio == 2 or not slot2:CheckLargeScreen() then
		slot1 = slot0.itemView.rect.width > 2000
	else
		slot0.itemView:Find("Viewport/item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = (NotchAdapt.CheckNotchRatio >= 2 and 8) or 7
		slot0.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = (NotchAdapt.CheckNotchRatio >= 2 and 8) or 7
		slot0.materialtView:Find("Viewport/item_grid"):GetComponent(typeof(GridLayoutGroup)).constraintCount = (NotchAdapt.CheckNotchRatio >= 2 and 8) or 7
		slot0.itemUsagePanel = ItemUsagePanel.New(slot0:findTF("item_usage_panel"), slot0._tf)
		slot0.itemResetPanel = ItemResetPanel.New(slot0:findTF("reset_info_panel"), slot0._tf)
		slot0.assignedItemView = WorldAssignedItemView.New(slot0._tf, slot0.event)
		slot0.itemCards = {}
		slot0.equipmetItems = {}
		slot0.materialCards = {}
		slot0._itemToggle = slot0:findTF("topItems/bottom_back/types/properties")
		slot0._weaponToggle = slot0:findTF("topItems/bottom_back/types/siren_weapon")
		slot0._materialToggle = slot0:findTF("topItems/bottom_back/types/material")
		slot0.exchangeTips = slot0:findTF("topItems/bottom_back/reset_exchange")
		slot0.filterBusyToggle = slot0:findTF("adapt/left_length/frame/toggle_equip", slot0.blurPanel)
		slot0.sortBtn = slot0:findTF("adapt/top/buttons/sort_button", slot0.blurPanel)
		slot0.indexBtn = slot0:findTF("adapt/top/buttons/index_button", slot0.blurPanel)
		slot0.decBtn = slot0:findTF("adapt/top/buttons/dec_btn", slot0.blurPanel)
		slot0.upOrderTF = slot0:findTF("asc", slot0.decBtn)
		slot0.downOrderTF = slot0:findTF("desc", slot0.decBtn)
		slot0.sortPanel = slot0:findTF("sort", slot0.topItems)
		slot0.sortContain = slot0:findTF("adapt/mask/panel", slot0.sortPanel)
		slot0.sortTpl = slot0:findTF("tpl", slot0.sortContain)

		setActive(slot0.sortTpl, false)
		slot0:initData()
		slot0:addListener()

		return
	end
end

slot0.didEnter = function (slot0)
	slot0:initItems()
	slot0:initEquipments()
	slot0:InitMaterials()
	setActive(slot0._weaponToggle, true)
	setActive(slot0._itemToggle, true)

	slot0.contextData.pageNum = nil

	if slot0.contextData.pageNum == slot0.PAGE.Property then
		triggerToggle(slot0._itemToggle, true)
	elseif slot1 == slot0.PAGE.Equipment then
		triggerToggle(slot0._weaponToggle, true)
	elseif slot1 == slot0.PAGE.Material then
		triggerToggle(slot0._materialToggle, true)
	end

	if slot0.contextData.equipScrollPos then
		slot0:ScrollEquipPos(slot0.contextData.equipScrollPos.y)
	end

	onButton(slot0, slot0.exchangeTips:Find("capcity"), function ()
		slot0:emit(slot1.ON_DROP, {
			type = DROP_TYPE_RESOURCE,
			id = WorldConst.ResourceID
		})
	end, SFX_PANEL)
	pg.UIMgr.GetInstance().OverlayPanel(slot2, slot0._tf, {
		groupName = slot0:getGroupNameFromData()
	})
end

slot0.OverlayPanel = function (slot0, slot1)
	slot0.overlayIndex = slot0.overlayIndex or 0
	slot0.overlayIndex = slot0.overlayIndex + 1

	setParent(tf(slot1), slot0._tf.parent, false)
	tf(slot1):SetSiblingIndex(slot0._tf:GetSiblingIndex() + slot0.overlayIndex)
end

slot0.UnOverlayPanel = function (slot0, slot1, slot2)
	setParent(tf(slot1), slot2, false)

	slot0.overlayIndex = slot0.overlayIndex or 0
	slot0.overlayIndex = slot0.overlayIndex - 1
	slot0.overlayIndex = math.max(slot0.overlayIndex, 0)
end

slot0.onBackPressed = function (slot0)
	if pg.m02:retrieveMediator(WorldMediator.__cname).viewComponent:CheckMarkOverallClose() then
	elseif isActive(slot0.itemResetPanel._go) then
		slot0.itemResetPanel:Close()
	elseif isActive(slot0.itemUsagePanel._go) then
		slot0.itemUsagePanel:Close()
	elseif slot0.assignedItemView:isShowing() then
		slot0.assignedItemView:Hide()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(slot0.backBtn)
	end
end

slot0.willExit = function (slot0)
	slot0.assignedItemView:Destroy()
	slot0.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, slot0.itemUpdateListenerFunc)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
end

slot0.initData = function (slot0)
	slot0.contextData.pageNum = slot0.contextData.pageNum or slot0.PAGE.Property
	slot0.contextData.asc = slot0.contextData.asc or false

	if not slot0.contextData.sortData then
		slot0.contextData.sortData = slot1.sort[1]
	end

	slot0.contextData.indexDatas = slot0.contextData.indexDatas or {}
	slot0.isEquipingOn = false
end

slot0.GetShowBusyFlag = function (slot0)
	return slot0.isEquipingOn
end

slot0.SetShowBusyFlag = function (slot0, slot1)
	slot0.isEquipingOn = slot1
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, slot0.decBtn, function ()
		slot0.contextData.asc = not slot0.contextData.asc

		if slot0.contextData.contextData.pageNum == not slot0.contextData.asc.PAGE.Equipment then
			slot0:filterEquipment()
		end
	end, SFX_PANEL)

	slot0.sortButtons = {}

	eachChild(slot0.sortContain, function (slot0)
		setActive(slot0, false)
	end)

	for slot4, slot5 in ipairs(slot1.sort) do
		setActive((slot4 <= slot0.sortContain.childCount and slot0.sortContain.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.sortTpl, slot0.sortContain), true)
		setImageSprite(findTF((slot4 <= slot0.sortContain.childCount and slot0.sortContain.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.sortTpl, slot0.sortContain), "Image"), GetSpriteFromAtlas("ui/equipmentui_atlas", slot5.spr), true)
		onToggle(slot0, (slot4 <= slot0.sortContain.childCount and slot0.sortContain.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.sortTpl, slot0.sortContain), function (slot0)
			if slot0 then
				slot0.contextData.sortData = slot0.contextData

				slot0:filterEquipment()
				triggerToggle(slot0.sortBtn, false)
			end
		end, SFX_PANEL)

		slot0.sortButtons[slot4] = (slot4 <= slot0.sortContain.childCount and slot0.sortContain.GetChild(slot6, slot4 - 1)) or cloneTplTo(slot0.sortTpl, slot0.sortContain)
	end

	onToggle(slot0, slot0.sortBtn, function (slot0)
		if slot0 then
			slot0:OverlayPanel(slot0.sortPanel)
			setActive(slot0.sortPanel, true)
		else
			slot0:UnOverlayPanel(slot0.sortPanel, slot0.topItems)
			setActive(slot0.sortPanel, false)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.sortPanel, function ()
		triggerToggle(slot0.sortBtn, false)
	end, SFX_PANEL)
	onToggle(slot0, slot0.filterBusyToggle, function (slot0)
		slot0:SetShowBusyFlag(slot0)

		if slot0.contextData.pageNum == slot1.PAGE.Equipment then
			slot0:filterEquipment()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.indexBtn, function ()
		slot0.emit(slot1, WorldInventoryMediator.OPEN_EQUIPMENT_INDEX, {
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
				},
				extraIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipmentExtraIndexs,
					names = IndexConst.EquipmentExtraNames
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
				},
				{
					dropdown = false,
					titleTxt = "indexsort_extraindex",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"extraIndex"
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
				slot0.contextData.indexDatas.typeIndex = slot0.typeIndex
				slot0.contextData.indexDatas.equipPropertyIndex = slot0.equipPropertyIndex
				slot0.contextData.indexDatas.equipPropertyIndex2 = slot0.equipPropertyIndex2
				slot0.contextData.indexDatas.equipAmmoIndex1 = slot0.equipAmmoIndex1
				slot0.contextData.indexDatas.equipAmmoIndex2 = slot0.equipAmmoIndex2
				slot0.contextData.indexDatas.equipCampIndex = slot0.equipCampIndex
				slot0.contextData.indexDatas.rarityIndex = slot0.rarityIndex
				slot0.contextData.indexDatas.extraIndex = slot0.extraIndex

				if slot0.filterBusyToggle:GetComponent(typeof(Toggle)) then
					if bit.band(slot0.extraIndex, IndexConst.EquipmentExtraEquiping) > 0 then
						slot0:SetShowBusyFlag(true)
					end

					triggerToggle(slot0.filterBusyToggle, slot0:GetShowBusyFlag())
				else
					slot0:filterEquipment()
				end
			end
		})
	end, SFX_PANEL)
	onToggle(slot0, slot0._itemToggle, function (slot0)
		if slot0 and slot0.contextData.pageNum ~= slot1.PAGE.Property then
			slot0.contextData.pageNum = slot1.PAGE.Property

			slot1(slot0, slot0.contextData.pageNum == slot1.PAGE.Property)
			slot0:sortItems()
		end
	end, SFX_PANEL)
	onToggle(slot0, slot0._weaponToggle, function (slot0)
		if slot0 and slot0.contextData.pageNum ~= slot1.PAGE.Equipment then
			slot0.contextData.pageNum = slot1.PAGE.Equipment

			slot1(slot0, slot0.contextData.pageNum == slot1.PAGE.Property)
			slot0:filterEquipment()
		end
	end, SFX_PANEL)
	onToggle(slot0, slot0._materialToggle, function (slot0)
		if slot0 and slot0.contextData.pageNum ~= slot1.PAGE.Material then
			slot0.contextData.pageNum = slot1.PAGE.Material

			slot1(slot0, slot0.contextData.pageNum == slot1.PAGE.Property)
			slot0:SortMaterials()
		end
	end, SFX_PANEL)
end

slot0.setWorldFleet = function (slot0, slot1)
	slot0.worldFleetList = slot1
end

slot0.setInventoryProxy = function (slot0, slot1)
	slot0.inventoryProxy = slot1

	slot0.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, slot0.itemUpdateListenerFunc)
	slot0:setItemList(slot0.inventoryProxy:GetItemList())
end

slot0.setItemList = function (slot0, slot1)
	slot0.itemList = slot1

	if slot0.isInitItems then
		slot0:sortItems()
	end
end

slot0.initItems = function (slot0)
	slot0.isInitItems = true
	slot0.itemRect = slot0.itemView:GetComponent("LScrollRect")

	slot0.itemRect.onInitItem = function (slot0)
		slot0:initItem(slot0)
	end

	slot0.itemRect.onUpdateItem = function (slot0, slot1)
		slot0:updateItem(slot0, slot1)
	end

	slot0.itemRect.onReturnItem = function (slot0, slot1)
		slot0:returnItem(slot0, slot1)
	end
end

slot0.initItem = function (slot0, slot1)
	onButton(slot0, WSInventoryItem.New(slot1).go, function ()
		if slot0.itemVO:getWorldItemType() == WorldItem.UsageBuff or slot0 == WorldItem.UsageHPRegenerate or slot0 == WorldItem.UsageHPRegenerateValue then
			slot1:emit(WorldInventoryMediator.OnOpenAllocateLayer, {
				itemVO = slot0.itemVO,
				fleetList = slot1.worldFleetList,
				fleetIndex = slot1.contextData.currentFleetIndex,
				confirmCallback = function (slot0, slot1)
					slot0:emit(WorldInventoryMediator.OnUseItem, slot0, 1, slot1)
				end,
				onResetInfo = function (slot0)
					slot0.itemResetPanel:Open(slot0)
				end
			})
		elseif slot0 == WorldItem.UsageWorldMap then
			slot1.itemUsagePanel.Open(slot1, {
				item = slot0.itemVO,
				mode = ItemUsagePanel.SEE,
				onUse = function ()
					slot0:PlayOpenBox(slot1.itemVO:getWorldItemOpenDisplay(), function ()
						slot0:emit(WorldInventoryMediator.OnMap, slot1.itemVO.id)
						slot0.emit:closeView()
					end)
				end,
				onResetInfo = function (slot0)
					slot0.itemResetPanel:Open(slot0)
				end
			})
		elseif slot0 == WorldItem.UsageDrop or slot0 == WorldItem.UsageRecoverAp or slot0 == WorldItem.UsageWorldItem or slot0 == WorldItem.UsageWorldBuff then
			slot1.itemUsagePanel.Open(slot1, {
				item = slot0.itemVO,
				mode = ItemUsagePanel.BATCH,
				onUseBatch = function (slot0)
					slot0:emit(WorldInventoryMediator.OnUseItem, slot1.itemVO.id, slot0, {})
				end,
				onUseOne = function ()
					slot0:emit(WorldInventoryMediator.OnUseItem, slot1.itemVO.id, 1, {})
				end,
				onResetInfo = function (slot0)
					slot0.itemResetPanel:Open(slot0)
				end
			})
		elseif slot0 == WorldItem.UsageLoot then
			slot1.itemUsagePanel.Open(slot1, {
				item = slot0.itemVO,
				mode = ItemUsagePanel.INFO,
				onResetInfo = function (slot0)
					slot0.itemResetPanel:Open(slot0)
				end
			})
		elseif slot0 == WorldItem.UsageWorldClean then
			slot1.itemUsagePanel.Open(slot1, {
				item = slot0.itemVO,
				onUse = function ()
					slot0:emit(WorldInventoryMediator.OnUseItem, slot1.itemVO.id, 1, {})
				end,
				onResetInfo = function (slot0)
					slot0.itemResetPanel:Open(slot0)
				end
			})
		elseif slot0 == WorldItem.UsageDropAppointed then
			slot1.assignedItemView.Load(slot1)
			slot1.assignedItemView.Load.assignedItemView:ActionInvoke("update", slot0.itemVO)
			slot1.assignedItemView.Load.assignedItemView.ActionInvoke.assignedItemView:ActionInvoke("Show")
		end
	end, SFX_PANEL)

	slot0.itemCards[slot1] = WSInventoryItem.New(slot1)
end

slot0.updateItem = function (slot0, slot1, slot2)
	if not slot0.itemCards[slot2] then
		slot0:initItem(slot2)

		slot3 = slot0.itemCards[slot2]
	end

	slot3:update(slot0.itemList[slot1 + 1])
end

slot0.returnItem = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	if slot0.itemCards[slot2] then
		slot3:clear()
	end
end

slot0.sortItems = function (slot0)
	table.sort(slot0.itemList, function (slot0, slot1)
		if slot0:getConfig("sort_priority") ~= slot1:getConfig("sort_priority") then
			return slot3 < slot2
		else
			return slot0:getConfig("id") < slot1:getConfig("id")
		end
	end)
	slot0.itemRect.SetTotalCount(slot1, #slot0.itemList, -1)
	slot0:updateResetExchange()
end

slot0.updateResetExchange = function (slot0)
	setText(slot0.exchangeTips:Find("capcity/Text"), defaultValue(checkExist(slot1, {
		DROP_TYPE_RESOURCE
	}, {
		WorldConst.ResourceID
	}), 0))
end

slot0.activeResetExchange = function (slot0, slot1)
	setActive(slot0.exchangeTips, nowWorld:IsSystemOpen(WorldConst.SystemResetExchange) and slot1)
end

slot0.PlayOpenBox = function (slot0, slot1, slot2)
	if not slot1 or slot1 == "" then
		slot2()

		return
	end

	function slot3()
		if slot0.playing or not slot0[slot1] then
			return
		end

		slot0.playing = true

		slot0[true]:SetActive(true)

		slot0 = tf(slot0[])

		slot0:SetParent(slot0._tf, false)
		slot0:SetAsLastSibling()

		slot1 = slot0:GetComponent("DftAniEvent")

		slot1:SetTriggerEvent(function (slot0)
			slot0()
		end)
		slot1.SetEndEvent(slot1, function (slot0)
			if slot0[] then
				SetActive(slot0[slot1], false)

				slot0.playing = false
			end
		end)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_EQUIPMENT_OPEN)
	end

	if slot0.findTF(slot0, slot1 .. "(Clone)") then
		slot0[slot1] = go(slot4)
	end

	if not slot0[slot1] then
		PoolMgr.GetInstance():GetPrefab("ui/" .. string.lower(slot1), "", true, function (slot0)
			slot0:SetActive(true)

			slot0[] = slot0

			slot0()
		end)
	else
		slot3()
	end
end

slot0.setEquipments = function (slot0, slot1)
	slot0.equipmentVOs = slot1
end

slot0.setEquipment = function (slot0, slot1)
	slot2 = true

	for slot6, slot7 in pairs(slot0.equipmentVOs) do
		if slot7.id == slot1.id and not slot7.shipId then
			slot0.equipmentVOs[slot6] = slot1
			slot2 = false
		end
	end

	if slot2 then
		table.insert(slot0.equipmentVOs, slot1)
	end

	if slot0.contextData.pageNum == slot0.PAGE.Equipment then
		slot0:filterEquipment()
	end
end

slot0.removeEquipment = function (slot0, slot1)
	for slot5 = #slot0.equipmentVOs, 1, -1 do
		if slot0.equipmentVOs[slot5].id == slot1 then
			table.remove(slot0.equipmentVOs, slot5)
		end
	end

	if slot0.contextData.pageNum == slot0.PAGE.Equipment then
		slot0:filterEquipment()
	end
end

slot0.initEquipments = function (slot0)
	slot0.isInitWeapons = true
	slot0.equipmentRect = slot0.equipmentView:GetComponent("LScrollRect")

	slot0.equipmentRect.onInitItem = function (slot0)
		slot0:initEquipment(slot0)
	end

	slot0.equipmentRect.onUpdateItem = function (slot0, slot1)
		slot0:updateEquipment(slot0, slot1)
	end

	slot0.equipmentRect.onReturnItem = function (slot0, slot1)
		slot0:returnEquipment(slot0, slot1)
	end

	slot0.equipmentRect.decelerationRate = 0.07
end

slot0.initEquipment = function (slot0, slot1)
	onButton(slot0, EquipmentItem.New(slot1).go, function ()
		if slot0.equipmentRect.GetContentAnchoredPositionOriginal then
			slot0.contextData.equipScrollPos = slot0.equipmentRect:GetContentAnchoredPositionOriginal()
		end

		if slot1.equipmentVO == nil or slot1.equipmentVO.mask then
			return
		end

		(slot0.shipVO and {
			type = EquipmentInfoMediator.TYPE_REPLACE,
			equipmentId = EquipmentInfoMediator.TYPE_REPLACE.equipmentVO.id,
			shipId = slot0.contextData.shipId,
			pos = slot0.contextData.pos,
			oldShipId = slot0.contextData.pos.equipmentVO.shipId,
			oldPos = slot0.contextData.pos.equipmentVO.shipId.equipmentVO.shipPos
		}) or (slot1.equipmentVO.shipId and {
			type = EquipmentInfoMediator.TYPE_DISPLAY,
			equipmentId = EquipmentInfoMediator.TYPE_DISPLAY.equipmentVO.id,
			shipId = EquipmentInfoMediator.TYPE_DISPLAY.equipmentVO.id.equipmentVO.shipId,
			pos = EquipmentInfoMediator.TYPE_DISPLAY.equipmentVO.id.equipmentVO.shipId.equipmentVO.shipPos
		}) or {
			destroy = true,
			type = EquipmentInfoMediator.TYPE_DEFAULT,
			equipmentId = EquipmentInfoMediator.TYPE_DEFAULT.equipmentVO.id
		}:emit(slot2.ON_EQUIPMENT, (slot0.shipVO and ) or (slot1.equipmentVO.shipId and ) or )
	end, SFX_PANEL)

	slot0.equipmetItems[slot1] = EquipmentItem.New(slot1)
end

slot0.updateEquipment = function (slot0, slot1, slot2)
	if not slot0.equipmetItems[slot2] then
		slot0:initEquipment(slot2)

		slot3 = slot0.equipmetItems[slot2]
	end

	slot3:update(slot0.loadEquipmentVOs[slot1 + 1])
end

slot0.returnEquipment = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	if slot0.equipmetItems[slot2] then
		slot3:clear()
	end
end

slot0.filterEquipment = function (slot0)
	slot1 = slot0.contextData.sortData
	slot0.loadEquipmentVOs = slot0.loadEquipmentVOs or {}

	table.clean(slot0.loadEquipmentVOs)

	slot2 = slot0.loadEquipmentVOs
	slot3 = table.mergeArray({}, {
		slot0.contextData.indexDatas.equipPropertyIndex,
		slot0.contextData.indexDatas.equipPropertyIndex2
	}, true)

	for slot7, slot8 in pairs(slot0.equipmentVOs) do
		if (slot8.count > 0 or slot8.shipId) and not slot8.isSkin and IndexConst.filterEquipByType(slot8, slot0.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(slot8, slot3) and IndexConst.filterEquipAmmo1(slot8, slot0.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(slot8, slot0.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(slot8, slot0.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(slot8, slot0.contextData.indexDatas.rarityIndex) and IndexConst.filterEquipByExtra(slot8, slot0.contextData.indexDatas.extraIndex, slot0:GetShowBusyFlag()) then
			table.insert(slot0.loadEquipmentVOs, slot8)
		end
	end

	if slot1 then
		slot4 = slot0.contextData.asc

		table.sort(slot2, function (slot0, slot1)
			return slot0:sortFunc(slot1, slot1, slot0.sortFunc)
		end)
	end

	slot0.updateEquipmentCount(slot0)
	setImageSprite(slot0:findTF("Image", slot0.sortBtn), GetSpriteFromAtlas("ui/equipmentui_atlas", slot1.spr), true)
	setActive(slot0.downOrderTF, not slot0.contextData.asc)
	setActive(slot0.upOrderTF, slot0.contextData.asc)
end

slot0.updateEquipmentCount = function (slot0, slot1)
	slot0.equipmentRect:SetTotalCount(slot1 or #slot0.loadEquipmentVOs, -1)
	Canvas.ForceUpdateCanvases()
end

slot0.Scroll2Equip = function (slot0, slot1)
	if slot0.contextData.pageNum ~= slot0.PAGE.Equipment then
		return
	end

	for slot5, slot6 in ipairs(slot0.loadEquipmentVOs) do
		if EquipmentProxy.SameEquip(slot6, slot1) then
			slot7 = slot0.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))

			slot0:ScrollEquipPos(((slot7.cellSize.y + slot7.spacing.y) * math.floor((slot5 - 1) / slot7.constraintCount) + slot0.equipmentRect.paddingFront + slot0.equipmentView.rect.height * 0.5) - slot0.equipmentRect.paddingFront)

			break
		end
	end
end

slot0.ScrollEquipPos = function (slot0, slot1)
	slot2 = slot0.equipmentView:Find("Viewport/moudle_grid"):GetComponent(typeof(GridLayoutGroup))

	slot0.equipmentRect:ScrollTo((slot1 - slot0.equipmentView.rect.height * 0.5) / ((((slot2.cellSize.y + slot2.spacing.y) * math.ceil(#slot0.loadEquipmentVOs / slot2.constraintCount) - slot2.spacing.y + slot0.equipmentRect.paddingFront + slot0.equipmentRect.paddingEnd) - slot0.equipmentView.rect.height > 0 and slot5) or slot4))
end

slot0.SetMaterials = function (slot0, slot1)
	slot0.materials = slot1

	if slot0.isInitMaterials and slot0.contextData.pageNum == slot0.PAGE.Material then
		slot0:SortMaterials()
	end
end

slot0.InitMaterials = function (slot0)
	slot0.isInitMaterials = true
	slot0.materialRect = slot0.materialtView:GetComponent("LScrollRect")

	slot0.materialRect.onInitItem = function (slot0)
		slot0:InitMaterial(slot0)
	end

	slot0.materialRect.onUpdateItem = function (slot0, slot1)
		slot0:UpdateMaterial(slot0, slot1)
	end

	slot0.materialRect.onReturnItem = function (slot0, slot1)
		slot0:ReturnMaterial(slot0, slot1)
	end

	slot0.materialRect.decelerationRate = 0.07
end

slot0.SortMaterials = function (slot0)
	table.sort(slot0.materials, function (slot0, slot1)
		if slot0:getConfig("rarity") == slot1:getConfig("rarity") then
			return slot0.id < slot1.id
		else
			return slot3 < slot2
		end
	end)
	slot0.materialRect.SetTotalCount(slot1, #slot0.materials, -1)
	Canvas.ForceUpdateCanvases()
end

slot0.InitMaterial = function (slot0, slot1)
	onButton(slot0, ItemCard.New(slot1).go, function ()
		if slot0.itemVO == nil then
			return
		end

		if slot0.itemVO:getConfig("type") == Item.INVITATION_TYPE then
			slot1:emit(EquipmentMediator.ITEM_GO_SCENE, SCENE.INVITATION, {
				itemVO = slot0.itemVO
			})
		else
			slot1:emit(slot2.ON_ITEM, slot0.itemVO.id)
		end
	end, SFX_PANEL)

	slot0.materialCards[slot1] = ItemCard.New(slot1)
end

slot0.UpdateMaterial = function (slot0, slot1, slot2)
	if not slot0.materialCards[slot2] then
		slot0:initItem(slot2)

		slot3 = slot0.materialCards[slot2]
	end

	slot3:update(slot0.materials[slot1 + 1])
end

slot0.ReturnMaterial = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	if slot0.materialCards[slot2] then
		slot3:clear()
	end
end

return slot0

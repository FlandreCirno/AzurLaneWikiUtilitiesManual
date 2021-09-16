slot0 = class("TechnologyTreeScene", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "TechnologyTreeUI"
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:findUI()
end

slot0.didEnter = function (slot0)
	slot0:updateNationItemList()
	slot0:updateTypeItemList()
	slot0:updateTecItemList()
	slot0:addBtnListener()
	setText(slot0.pointNumText, slot0.point)
	slot0:refreshRedPoint(getProxy(TechnologyNationProxy):getShowRedPointTag())

	if not PlayerPrefs.HasKey("first_comein_technologytree") then
		triggerButton(slot0.helpBtn)
		PlayerPrefs.SetInt("first_comein_technologytree", 1)
		PlayerPrefs.Save()
	end
end

slot0.refreshRedPoint = function (slot0, slot1)
	setActive(slot0.redPointImg, slot1)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.blurPanel, slot0._tf)

	slot0.rightLSC.onReturnItem = nil
end

slot0.initData = function (slot0)
	slot0.nationToggleList = {}
	slot0.typeToggleList = {}
	slot0.nationSelectedList = {}
	slot0.typeSelectedList = {}
	slot0.nationSelectedCount = 0
	slot0.typeSelectedCount = 0
	slot0.countInEveryRow = 5
	slot0.collectionProxy = getProxy(CollectionProxy)
	slot0.groupIDGotList = {}

	for slot5, slot6 in pairs(slot1) do
		slot0.groupIDGotList[#slot0.groupIDGotList + 1] = slot6.id
	end

	slot0.point = getProxy(TechnologyNationProxy):getPoint()
	slot0.expanded = {}
end

slot0.findUI = function (slot0)
	slot0.blurPanel = slot0:findTF("blur_panel")
	slot0.adapt = slot0:findTF("adapt", slot0.blurPanel)
	slot0.backBtn = slot0:findTF("top/back", slot0.adapt)
	slot0.homeBtn = slot0:findTF("top/option", slot0.adapt)
	slot0.additionDetailBtn = slot0:findTF("AdditionDetailBtn", slot0.adapt)
	slot0.switchBtn = slot0:findTF("SwitchToggle", slot0.adapt)
	slot0.pointTF = slot0:findTF("PointCount", slot0.adapt)
	slot0.pointNumText = slot0:findTF("PointCount/PointNumText", slot0.adapt)
	slot0.redPointImg = slot0:findTF("RedPoint", slot0.switchBtn)
	slot0.helpBtn = slot0:findTF("help_btn", slot0.adapt)
	slot0.leftContainer = slot0:findTF("Adapt/Left/Scroll View/Viewport/Content")
	slot0.selectNationItem = slot0:findTF("SelectCampItem")
	slot0.bottomContainer = slot0:findTF("Adapt/Bottom/Scroll View/Viewport/Content")
	slot0.selectTypeItem = slot0:findTF("SelectTypeItem")
	slot0.rightLSC = slot0:findTF("Adapt/Right"):GetComponent("LScrollRect")
	slot0.rightContainer = slot0:findTF("Adapt/Right/ViewPort/Container")
	slot0.headItem = slot0:findTF("HeadItem")
	slot0.rowHeight = slot0.headItem.rect.height
	slot0.maxRowHeight = 853.5
end

slot0.onBackPressed = function (slot0)
	triggerButton(slot0.backBtn)
end

slot0.addBtnListener = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_CANCEL)
	onButton(slot0, slot0.additionDetailBtn, function ()
		slot0:emit(TechnologyConst.OPEN_ALL_BUFF_DETAIL)
	end)
	onToggle(slot0, slot0.switchBtn, function (slot0)
		if slot0 then
			setActive(slot0.pointTF, false)
			pg.UIMgr.GetInstance():OverlayPanel(slot0.blurPanel, {
				weight = LayerWeightConst.SECOND_LAYER
			})
			slot0:emit(TechnologyConst.OPEN_TECHNOLOGY_NATION_LAYER)
		else
			setActive(slot0.pointTF, true)
			pg.UIMgr.GetInstance():UnOverlayPanel(slot0.blurPanel, slot0._tf)
			slot0:emit(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER)
		end
	end, SFX_PANEL)
	onToggle(slot0, slot0.nationAllToggle, function (slot0)
		if slot0 == true then
			slot0.nationSelectedCount = 0
			slot0.nationSelectedList = {}
			slot0.nationAllToggleCom.interactable = false

			for slot4, slot5 in ipairs(slot0.nationToggleList) do
				triggerToggle(slot5, false)
			end

			slot0:updateTecItemList()
		else
			slot0.nationAllToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(slot0, slot0.typeAllToggle, function (slot0)
		if slot0 == true then
			slot0.typeSelectedCount = 0
			slot0.typeSelectedList = {}
			slot0.typeAllToggleCom.interactable = false

			for slot4, slot5 in ipairs(slot0.typeToggleList) do
				triggerToggle(slot5, false)
			end

			slot0:updateTecItemList()
		else
			slot0.typeAllToggleCom.interactable = true
		end
	end)

	for slot4, slot5 in ipairs(slot0.nationToggleList) do
		onToggle(slot0, slot5, function (slot0)
			if slot0 == true then
				slot0.nationSelectedCount = slot0.nationSelectedCount + 1

				if slot0.nationSelectedCount == #slot0.nationToggleList then
					triggerToggle(slot0.nationAllToggle, true)
					onNextTick(function ()
						setActive(slot0:findTF("UnSelectedImg", slot0.findTF), true)
					end)

					return
				end

				table.insert(slot0.nationSelectedList, TechnologyConst.NationOrder[slot0.nationSelectedList])

				if slot0.nationAllToggleCom.isOn == true then
					triggerToggle(slot0.nationAllToggle, false)
				end

				slot0.updateTecItemList(slot1)
			elseif slot0.nationAllToggleCom.isOn == false then
				slot0.nationSelectedCount = slot0.nationSelectedCount - 1

				if slot0.nationSelectedCount == 0 then
					triggerToggle(slot0.nationAllToggle, true)

					return
				end

				if table.indexof(slot0.nationSelectedList, TechnologyConst.NationOrder[slot2], 1) then
					table.remove(slot0.nationSelectedList, slot1)
				end

				slot0:updateTecItemList()
			end
		end, SFX_PANEL)
	end

	for slot4, slot5 in ipairs(slot0.typeToggleList) do
		onToggle(slot0, slot5, function (slot0)
			if slot0 == true then
				slot0.typeSelectedCount = slot0.typeSelectedCount + 1

				if slot0.typeSelectedCount == #slot0.typeToggleList then
					triggerToggle(slot0.typeAllToggle, true)
					onNextTick(function ()
						setActive(slot0:findTF("UnSelectedImg", slot0.findTF), true)
					end)

					return
				end

				for slot4, slot5 in ipairs(TechnologyConst.TypeOrder[]) do
					table.insert(slot0.typeSelectedList, slot5)
				end

				if slot0.typeAllToggleCom.isOn == true then
					triggerToggle(slot0.typeAllToggle, false)
				end

				slot0:updateTecItemList()
			elseif slot0.typeAllToggleCom.isOn == false then
				slot0.typeSelectedCount = slot0.typeSelectedCount - 1

				if slot0.typeSelectedCount == 0 then
					triggerToggle(slot0.typeAllToggle, true)

					return
				end

				for slot4, slot5 in ipairs(TechnologyConst.TypeOrder[]) do
					if table.indexof(slot0.typeSelectedList, slot5, 1) then
						table.remove(slot0.typeSelectedList, slot6)
					end
				end

				slot0:updateTecItemList()
			end
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.helpBtn, function ()
		if pg.gametip.help_technologytree then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.help_technologytree.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
end

slot0.updateNationItemList = function (slot0)
	slot1 = UIItemList.New(slot0.leftContainer, slot0.selectNationItem)

	slot1:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:findTF("UnSelectedImg", slot2):GetComponent("Image").sprite, slot0:findTF("SelectedImg", slot2):GetComponent("Image").sprite = TechnologyConst.GetNationSpriteByIndex(slot1 + 1)

			if slot1 == 0 then
				slot0.nationAllToggle = slot2

				triggerToggle(slot2, true)

				slot0.nationAllToggleCom = GetComponent(slot2, "Toggle")
				slot0.nationAllToggleCom.interactable = false
			else
				triggerToggle(slot2, false)

				slot0.nationToggleList[slot1] = slot2
			end

			setActive(slot2, true)
		end
	end)
	slot1.align(slot1, #TechnologyConst.NationResName)
end

slot0.updateTypeItemList = function (slot0)
	slot1 = UIItemList.New(slot0.bottomContainer, slot0.selectTypeItem)

	slot1:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:findTF("UnSelectedImg", slot2):GetComponent("Image").sprite, slot0:findTF("SelectedImg", slot2):GetComponent("Image").sprite = TechnologyConst.GetTypeSpriteByIndex(slot1 + 1)

			if slot1 + 1 == #TechnologyConst.TypeResName then
				slot0.typeAllToggle = slot2

				triggerToggle(slot2, true)

				slot0.typeAllToggleCom = GetComponent(slot2, "Toggle")
				slot0.typeAllToggleCom.interactable = false
			else
				triggerToggle(slot2, false)

				slot0.typeToggleList[slot1 + 1] = slot2
			end

			setActive(slot2, true)
		end
	end)
	slot1.align(slot1, #TechnologyConst.TypeResName)
end

slot0.updateTecItemList = function (slot0)
	slot0.expanded = {}
	slot1 = nil

	if #slot0.nationSelectedList == 0 and #slot0.typeSelectedList == 0 then
		slot1 = TechnologyConst.GetOrderClassList()
	else
		slot2 = _.select(TechnologyConst.GetOrderClassList(), function (slot0)
			if table.indexof((#slot0.nationSelectedList == 0 and TechnologyConst.NationOrder) or slot0.nationSelectedList, pg.fleet_tech_ship_class[slot0].nation, 1) then
				if #slot0.typeSelectedList == 0 then
					return true
				else
					return table.indexof(slot0.typeSelectedList, pg.fleet_tech_ship_class[slot0].shiptype, 1)
				end
			else
				return false
			end
		end)
		slot1 = slot2
	end

	slot0.rightLSC.onUpdateItem = function (slot0, slot1)
		slot7 = slot0:findTF("ArrowBtn", slot6)

		setText(slot2, slot9)
		setImageSprite(slot3, GetSpriteFromAtlas("TecNation", "bg_nation_" .. slot10, true))
		setImageSprite(slot5, GetSpriteFromAtlas("ShipType", "ch_title_" .. slot11, true), true)
		setImageSprite(slot4, GetSpriteFromAtlas("TecClassLevelIcon", "T" .. slot12, true), true)
		setLocalRotation(slot13, {
			z = 180
		})

		GetComponent(slot1, "LayoutElement").preferredHeight = slot0.rowHeight

		slot0:updateShipItemList(slot8, slot14)
		setActive(slot0:findTF("ClickBtn", slot1), #pg.fleet_tech_ship_class[slot1[slot0 + 1]].ships > 5)
		onButton(slot0, slot6, function ()
			if slot0.rowHeight < slot0.expanded[slot1] then
				slot0.expanded[slot1] = slot0.rowHeight
			else
				slot0.expanded[slot1] = slot2.rect.height
			end

			slot0.rightLSC:ScrollTo(slot0.rightLSC:HeadIndexToValue(slot0.rightLSC) - 0.0001)
		end, SFX_PANEL)

		slot0.expanded[slot0] = defaultValue(slot0.expanded[slot0], slot0.rowHeight)
		GetComponent(slot1, "LayoutElement").preferredHeight = slot0.expanded[slot0]
		slot15 = slot0:findTF("ClickBtn/ArrowBtn", slot1)

		if slot0.rowHeight < slot0.expanded[slot0] then
			setLocalRotation(slot15, {
				z = 0
			})

			GetComponent(slot0.rightContainer, "VerticalLayoutGroup").padding.bottom = GetComponent(slot0.rightContainer, "VerticalLayoutGroup").padding.bottom + slot0.expanded[slot0] - slot0.rowHeight
		else
			setLocalRotation(slot15, {
				z = 180
			})
		end
	end

	slot0.rightLSC.onReturnItem = function (slot0, slot1)
		slot0.expanded[slot0] = defaultValue(slot0.expanded[slot0], slot0.rowHeight)

		if slot0.rowHeight < slot0.expanded[slot0] then
			GetComponent(slot0.rightContainer, "VerticalLayoutGroup").padding.bottom = GetComponent(slot0.rightContainer, "VerticalLayoutGroup").padding.bottom - (slot0.expanded[slot0] - slot0.rowHeight)
		end
	end

	if slot0.rightLSC.totalCount ~= 0 then
		slot0.rightLSC.SetTotalCount(slot2, 0)
	end

	slot0.rightLSC:SetTotalCount(#slot1)
	slot0.rightLSC:BeginLayout()
	slot0.rightLSC:EndLayout()
end

slot0.updateShipItemList = function (slot0, slot1, slot2)
	slot4 = UIItemList.New(slot2, slot0.headItem)

	slot4:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = slot0:findTF("BaseImg/CharImg", slot2)
			slot7 = slot0:findTF("BG", slot2)
			slot8 = slot0:findTF("Star", slot2)
			slot9 = slot0:findTF("Star/StarImg", slot2)
			slot10 = slot0:findTF("Info", slot2)
			slot11 = slot0:findTF("PointText", slot10)
			slot14 = slot0:findTF("AttrIcon", slot13)
			slot15 = slot0:findTF("NumText", slot13)
			slot16 = slot0:findTF("Lock", slot10)
			slot19 = slot0:findTF("AttrIcon", slot18)
			slot20 = slot0:findTF("NumText", slot18)
			slot21 = slot0:findTF("BottomBG", slot2)
			slot22 = slot0:findTF("BottomBG/StatusUnknow", slot2)
			slot23 = slot0:findTF("BottomBG/StatusResearching", slot2)
			slot24 = slot0:findTF("ViewIcon", slot2)
			slot25 = slot0:findTF("keyansaohguang", slot2)

			setText(slot6, shortenString(ShipGroup.getDefaultShipNameByGroupID(slot26), 6))
			setImageSprite(slot3, GetSpriteFromAtlas("shipraritybaseicon", "base_" .. pg.ship_data_statistics[slot1[slot1 + 1] * 10 + 1].rarity))
			LoadSpriteAsync("shipmodels/" .. Ship.getPaintingName(slot27), function (slot0)
				if slot0 then
					setImageSprite(slot0, slot0, true)

					rtf(slot0).pivot = getSpritePivot(slot0)
				end
			end)

			if table.indexof(slot0.groupIDGotList, slot26, 1) then
				setImageSprite(slot13, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. slot28, true))
				setImageSprite(slot14, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[pg.fleet_tech_ship_template[slot26].add_get_attr].name, true))
				setText(slot15, "+" .. pg.fleet_tech_ship_template[slot26].add_get_value)
				setActive(slot12, true)

				if slot0.collectionProxy:getShipGroup(slot26).maxLV < 120 then
					setActive(slot23, true)
					setActive(slot22, false)
					setActive(slot17, false)
					setImageSprite(slot7, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
					setActive(slot21, true)
					setActive(slot24, true)
					setActive(slot16, true)
					setActive(slot25, false)

					if slot31.star == pg.fleet_tech_ship_template[slot26].max_star then
						setText(slot11, "+" .. pg.fleet_tech_ship_template[slot26].pt_get + pg.fleet_tech_ship_template[slot26].pt_upgrage)
					else
						setText(slot11, "+" .. pg.fleet_tech_ship_template[slot26].pt_get)
					end
				else
					setImageSprite(slot18, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. slot32, true))
					setImageSprite(slot19, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[pg.fleet_tech_ship_template[slot26].add_level_attr].name, true))
					setText(slot20, "+" .. pg.fleet_tech_ship_template[slot26].add_level_value)
					setActive(slot17, true)

					if slot31.star == pg.fleet_tech_ship_template[slot26].max_star then
						setText(slot11, "+" .. pg.fleet_tech_ship_template[slot26].pt_get + pg.fleet_tech_ship_template[slot26].pt_level + pg.fleet_tech_ship_template[slot26].pt_upgrage)
						setImageSprite(slot7, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_finished"))
						setActive(slot21, false)
						setActive(slot24, false)
						setActive(slot23, false)
						setActive(slot22, false)
						setActive(slot25, true)
					else
						setText(slot11, "+" .. pg.fleet_tech_ship_template[slot26].pt_get + pg.fleet_tech_ship_template[slot26].pt_level)
						setImageSprite(slot7, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
						setActive(slot21, true)
						setActive(slot24, true)
						setActive(slot23, true)
						setActive(slot22, false)
						setActive(slot25, false)
					end

					setActive(slot16, false)
				end

				setImageColor(slot4, Color.New(1, 1, 1, 1))
				setActive(slot5, true)
				setActive(slot10, true)
				setActive(slot8, true)

				if slot31.star == pg.fleet_tech_ship_template[slot26].max_star then
					setActive(slot9, true)
				else
					setActive(slot9, false)
				end

				onButton(slot0, slot2, function ()
					slot0:emit(TechnologyConst.OPEN_SHIP_BUFF_DETAIL, slot0, slot2.maxLV, slot2.star)
				end)
			else
				setImageSprite(slot7, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
				setImageColor(slot4, Color.New(0, 0, 0, 0.4))
				setActive(slot24, false)
				setActive(slot5, false)
				setActive(slot10, false)
				setActive(slot23, false)
				setActive(slot22, true)
				setActive(slot8, false)
				setActive(slot16, false)
				setActive(slot25, false)
				removeOnButton(slot2)
			end

			setActive(slot2, true)
		end
	end)
	slot4.align(slot4, #pg.fleet_tech_ship_class[slot1].ships)
end

return slot0

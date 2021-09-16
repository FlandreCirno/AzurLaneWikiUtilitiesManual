slot0 = class("ColoringScene", import("view.base.BaseUI"))
slot1 = 387
slot2 = 467
slot3 = 812.5
slot4 = 1200
slot5 = Vector2(49, -436.12)

slot0.getUIName = function (slot0)
	return "ColoringUI"
end

slot0.setActivity = function (slot0, slot1)
	slot0.activity = slot1
end

slot0.setColorItems = function (slot0, slot1)
	slot0.colorItems = slot1
end

slot0.setColorGroups = function (slot0, slot1)
	slot0.colorGroups = slot1
end

slot0.init = function (slot0)
	slot0.topPanel = slot0:findTF("top")
	slot0.btnBack = slot0:findTF("top/btnBack")
	slot0.title = slot0:findTF("center/title_bar/text")
	slot0.bg = slot0:findTF("center/board/container/bg")
	slot0.painting = slot0:findTF("center/painting")
	slot0.zoom = slot0.bg:GetComponent("Zoom")
	slot0.zoom.maxZoom = 3
	slot0.cells = slot0:findTF("cells", slot0.bg)
	slot0.cell = slot0:findTF("cell", slot0.bg)
	slot0.lines = slot0:findTF("lines", slot0.bg)
	slot0.line = slot0:findTF("line", slot0.bg)
	slot0.btnHelp = slot0:findTF("top/btnHelp")
	slot0.btnShare = slot0:findTF("top/btnShare")
	slot0.colorgroupfront = slot0:findTF("center/colorgroupfront")
	slot0.scrollColor = slot0:findTF("color_bar/scroll")
	slot0.barExtra = slot0:findTF("color_bar/extra")
	slot0.toggleEraser = slot0:findTF("eraser", slot0.barExtra)
	slot0.btnEraserAll = slot0:findTF("eraser_all", slot0.barExtra)
	slot0.arrowDown = slot0:findTF("arrow", slot0.barExtra)

	setActive(slot0.cell, false)
	setActive(slot0.line, false)
	setActive(slot0.barExtra, false)

	slot0.loader = AutoLoader.New()
end

slot0.DidMediatorRegisterDone = function (slot0)
	slot0.colorPlates = slot0:Clone2Full(slot0:findTF("content", slot0.scrollColor), #slot0.colorGroups[1]:getConfig("color_id_list"))

	for slot5, slot6 in ipairs(slot0.colorPlates) do
		slot0.loader:GetSprite("ui/coloring_atlas", string.char((string.byte("A") + slot5) - 1), slot6:Find("icon"))
	end

	slot0.coloringUIGroupName = "ColoringUIGroupSize" .. slot2

	PoolMgr.GetInstance():GetUI(slot0.coloringUIGroupName, false, function (slot0)
		setParent(slot0, slot0:findTF("center"))
		setAnchoredPosition(slot0, setAnchoredPosition)
		tf(slot0):SetSiblingIndex(1)
		setActive(slot0, true)

		slot0.colorgroupbehind = tf(slot0)
		slot0.paintsgroup = {}

		for slot4 = slot0.colorgroupbehind.childCount - 1, 0, -1 do
			table.insert(slot0.paintsgroup, slot0.colorgroupbehind:GetChild(slot4))
		end
	end)

	slot3 = not COLORING_ACTIVITY_CUSTOMIZED_BANNED and _.any(slot0.colorGroups, function (slot0)
		return slot0:canBeCustomised()
	end)

	setActive(slot0.btnShare, slot3)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.btnBack, function ()
		if slot0.exited then
			return
		end

		slot0:uiExitAnimating()
		slot0.uiExitAnimating:emit(slot1.ON_BACK, nil, 0.3)
	end, SOUND_BACK)
	onButton(slot0, slot0.btnHelp, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("coloring_help_tip")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.btnShare, function ()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeColoring)
	end, SFX_PANEL)
	onNextTick(function ()
		if slot0.exited then
			return
		end

		slot0:uiStartAnimating()
	end)
	slot0.initColoring(slot0)
	slot0:updatePage()
end

slot0.uiStartAnimating = function (slot0)
	slot0.topPanel.anchoredPosition = Vector2(0, slot0.topPanel.rect.height)

	shiftPanel(slot0.topPanel, nil, 0, 0.3, 0, true, true, nil)
end

slot0.uiExitAnimating = function (slot0)
	shiftPanel(slot0.topPanel, nil, slot0.topPanel.rect.height, 0.3, 0, true, true, nil)
end

slot0.initColoring = function (slot0)
	onButton(slot0, slot0.btnEraserAll, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("coloring_erase_all_warning"),
			onYes = function ()
				if slot0.colorGroups[slot0.selectedIndex]:canBeCustomised() then
					slot0:emit(ColoringMediator.EVENT_COLORING_CLEAR, {
						activityId = slot0.activity.id,
						id = slot0.id
					})
				end
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.arrowDown, function ()
		slot0.scrollColor:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 0
	end, SFX_PANEL)

	slot1 = 1

	for slot5 = 1, #slot0.colorGroups, 1 do
		if slot0.colorGroups[slot5].getState(slot6) == ColorGroup.StateColoring then
			slot1 = slot5

			break
		end
	end

	slot0:initInteractive()

	slot0.selectedIndex = 0
	slot0.selectedColorIndex = 0

	triggerButton(slot0.paintsgroup[Mathf.Min(slot1, #slot0.paintsgroup)], true)
end

slot0.initInteractive = function (slot0)
	for slot4, slot5 in pairs(slot0.paintsgroup) do
		slot7 = slot0.colorGroups[slot4]

		onButton(slot0, slot5, function ()
			slot0 = slot0:getState()

			if slot0.selectedIndex ~= slot2 and slot0 ~= ColorGroup.StateLock then
				if slot1.paintsgroup[slot1.selectedIndex] then
					slot1:SetParent(slot1.colorgroupbehind)
				end

				slot1.selectedIndex = slot1

				slot1:SetParent(slot1.colorgroupfront)
				slot1:SelectColoBar(0)
				slot1:updateSelectedColoring()
			elseif slot0 == ColorGroup.StateLock then
				pg.TipsMgr.GetInstance():ShowTips(i18n("coloring_lock"))
			end

			slot1:updatePage()
		end, SFX_PANEL)
	end

	for slot4 = 0, #slot0.colorPlates - 1, 1 do
		onButton(slot0, slot0.colorPlates[slot4 + 1], function ()
			slot0:SelectColoBar(slot1 + 1)

			if slot0.SelectColoBar.colorGroups[slot0.selectedIndex].getState(slot0) == ColorGroup.StateColoring and not slot0:canBeCustomised() then
				if (slot0.colorItems[slot0:getConfig("color_id_list")[slot0.selectedColorIndex]] or 0) ~= 0 then
					if slot0:SearchValidDiagonalColoringCells(slot0, slot0.selectedColorIndex, slot2) and #slot3 > 0 then
						slot0:emit(ColoringMediator.EVENT_COLORING_CELL, {
							activityId = slot0.activity.id,
							id = slot0.id,
							cells = slot3
						})
					end
				elseif not slot0:isAllFill(slot0.selectedColorIndex) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("coloring_color_not_enough"))
				end
			end
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.toggleEraser, function ()
		slot0:SelectColoBar(0)
	end, SFX_PANEL)
end

slot0.SelectColoBar = function (slot0, slot1)
	if slot0.selectedColorIndex ~= 0 and slot0.selectedColorIndex ~= slot1 then
		slot0:findTF("icon", slot0.colorPlates[slot0.selectedColorIndex]).sizeDelta.x = slot0
		slot0.findTF("icon", slot0.colorPlates[slot0.selectedColorIndex]).sizeDelta = slot0.findTF("icon", slot0.colorPlates[slot0.selectedColorIndex]).sizeDelta
	end

	slot0.selectedColorIndex = slot1

	if slot0.selectedColorIndex ~= 0 then
		slot0:findTF("icon", slot0.colorPlates[slot0.selectedColorIndex]).sizeDelta.x = slot1
		slot0.findTF("icon", slot0.colorPlates[slot0.selectedColorIndex]).sizeDelta = slot0.findTF("icon", slot0.colorPlates[slot0.selectedColorIndex]).sizeDelta
	end
end

slot0.updatePage = function (slot0)
	for slot4, slot5 in ipairs(slot0.paintsgroup) do
		setActive(slot5:Find("lock"), slot0.colorGroups[slot4].getState(slot6) == ColorGroup.StateLock)
		setActive(slot5:Find("get"), slot7 == ColorGroup.StateAchieved)
	end

	slot2 = 0

	for slot6 = #slot0.paintsgroup, 1, -1 do
		if slot6 ~= slot0.selectedIndex then
			slot0.paintsgroup[slot6]:SetSiblingIndex(slot2)

			slot2 = slot2 + 1
		end
	end

	slot0:TryPlayStory()
end

slot0.updateSelectedColoring = function (slot0)
	slot2 = slot0.colorGroups[slot0.selectedIndex].getConfig(slot1, "color_id_list")
	slot3 = slot0.colorGroups[slot0.selectedIndex].colors

	for slot7 = 1, #slot0.colorPlates, 1 do
		setText(slot0.colorPlates[slot7].Find(slot8, "icon/x/nums"), slot0.colorItems[slot2[slot7]] or 0)
	end

	setText(slot0.title, slot1:getConfig("name"))
	setActive(slot0.title.parent, slot1:getConfig("name") ~= nil)
	setActive(slot0.barExtra, slot1:canBeCustomised())

	slot0.scrollColor.sizeDelta.y = (slot1:canBeCustomised() and slot0) or slot1
	slot0.scrollColor.sizeDelta = slot0.scrollColor.sizeDelta
	slot0.scrollColor:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 1

	setActive(slot0.scrollColor, false)
	setActive(slot0.scrollColor, true)

	slot0.cellSize = slot0:calcCellSize()

	slot0:updateCells()
	slot0:updateLines()
end

slot0.updateCells = function (slot0)
	slot5, slot3 = unpack(slot0.colorGroups[slot0.selectedIndex].getConfig(slot1, "theme"))

	for slot7 = 0, slot2, 1 do
		for slot11 = 0, slot3, 1 do
			slot0:updateCell(slot7, slot11)
		end
	end

	slot4 = slot0.bg:GetComponent("EventTriggerListener")

	slot4:RemovePointClickFunc()
	slot4:RemoveBeginDragFunc()
	slot4:RemoveDragFunc()
	slot4:RemoveDragEndFunc()

	slot5 = false

	slot4:AddPointClickFunc(function (slot0, slot1)
		if slot0 then
			return
		end

		slot2 = LuaHelper.ScreenToLocal(slot1.bg, slot1.position, GameObject.Find("UICamera"):GetComponent(typeof(Camera)))
		slot5 = slot2:getCell(slot3, math.floor(slot2.x / slot1.cellSize.x))

		if slot2:getState() == ColorGroup.StateColoring then
			function slot6()
				slot0:emit(ColoringMediator.EVENT_COLORING_CELL, {
					activityId = slot0.activity.id,
					id = slot1.id,
					cells = slot0:searchColoringCells(slot0, ColoringMediator.EVENT_COLORING_CELL, , slot0.selectedColorIndex)
				})
			end

			if not slot2.canBeCustomised(slot7) then
				return
			elseif slot1.selectedColorIndex == 0 and not slot2:hasFill(slot3, slot4) then
				return
			end

			slot6()
		end
	end)
	slot4.AddBeginDragFunc(slot4, function ()
		slot0 = false
	end)

	slot6 = Vector2.New(slot0.bg.rect.width / UnityEngine.Screen.width, slot0.bg.rect.height / UnityEngine.Screen.height)

	slot4.AddDragFunc(slot4, function (slot0, slot1)
		slot0 = true

		if not Application.isEditor then
			slot1.zoom.enabled = Input.touchCount == 2
		end

		if Application.isEditor or not slot1.zoom.enabled then
			slot1.bg.anchoredPosition.x = slot1.bg.anchoredPosition.x + slot1.delta.x * slot2.x
			slot1.bg.anchoredPosition.x = math.clamp(slot1.bg.anchoredPosition.x, -slot1.bg.rect.width * (slot1.bg.localScale.x - 1), 0)
			slot1.bg.anchoredPosition.y = slot1.bg.anchoredPosition.y + slot1.delta.y * slot2.y
			slot1.bg.anchoredPosition.y = math.clamp(slot1.bg.anchoredPosition.y, 0, slot1.bg.rect.height * (slot1.bg.localScale.y - 1))
			slot1.bg.anchoredPosition = slot1.bg.anchoredPosition
		end
	end)
	slot4.AddDragEndFunc(slot4, function ()
		slot0 = false
	end)
end

slot0.updateCell = function (slot0, slot1, slot2)
	slot4 = slot0.colorGroups[slot0.selectedIndex].getCell(slot3, slot1, slot2)
	slot5 = slot0.colorGroups[slot0.selectedIndex].getFill(slot3, slot1, slot2)

	if slot0.colorGroups[slot0.selectedIndex].getState(slot3) == ColorGroup.StateFinish or slot6 == ColorGroup.StateAchieved then
		slot5 = slot4
	end

	slot8 = slot0.cells:Find(slot1 .. "_" .. slot2)

	if slot4 or slot5 then
		slot8 or cloneTplTo(slot0.cell, slot0.cells, slot7).sizeDelta = slot0.cellSize
		slot8 or cloneTplTo(slot0.cell, slot0.cells, slot7).anchoredPosition = Vector2(slot5 or slot4.column * slot0.cellSize.x, -(slot5 or slot4.row * slot0.cellSize.y))
		slot9 = slot8 or cloneTplTo(slot0.cell, slot0.cells, slot7):Find("image")
		slot10 = slot8:Find("text")

		if slot5 then
			setImageColor(slot9, slot3.colors[slot5.type])
		else
			setText(slot10, string.char((string.byte("A") + slot4.type) - 1))
		end

		setActive(slot9, slot5)
		setActive(slot10, not slot5)
		setActive(slot8, true)
	elseif slot8 then
		setActive(slot8, false)
	end
end

slot0.calcCellSize = function (slot0)
	slot2, slot3 = unpack(slot0.colorGroups[slot0.selectedIndex].getConfig(slot1, "theme"))

	return Vector2.New(slot0.bg.rect.width / slot3, slot0.bg.rect.height / slot2)
end

slot0.updateLines = function (slot0)
	slot2, slot3 = unpack(slot0.colorGroups[slot0.selectedIndex].getConfig(slot1, "theme"))

	for slot7 = 1, slot3 - 1, 1 do
		slot0.lines:Find("column_" .. slot7) or cloneTplTo(slot0.line, slot0.lines, slot8).sizeDelta = Vector2.New(1, slot0.lines.rect.height)
		slot0.lines.Find("column_" .. slot7) or cloneTplTo(slot0.line, slot0.lines, slot8).anchoredPosition = Vector2.New(slot7 * slot0.cellSize.x - 0.5, 0)
	end

	for slot7 = 1, slot2 - 1, 1 do
		slot0.lines:Find("row_" .. slot7) or cloneTplTo(slot0.line, slot0.lines, slot8).sizeDelta = Vector2.New(slot0.lines.rect.width, 1)
		slot0.lines.Find("row_" .. slot7) or cloneTplTo(slot0.line, slot0.lines, slot8).anchoredPosition = Vector2.New(0, -(slot7 * slot0.cellSize.y - 0.5))
	end
end

slot0.searchColoringCells = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = {
		row = slot2,
		column = slot3,
		color = slot4
	}

	if slot1:canBeCustomised() then
		return {
			slot5
		}
	else
		slot7 = slot0.colorItems[slot1:getConfig("color_id_list")[slot4]]
		slot8 = {}
		slot9 = {}
		slot10 = {
			slot5
		}
		slot11 = {
			{
				row = -1,
				column = 0
			},
			{
				row = 1,
				column = 0
			},
			{
				row = 0,
				column = -1
			},
			{
				row = 0,
				column = 1
			},
			{
				row = -1,
				column = -1
			},
			{
				row = -1,
				column = 1
			},
			{
				row = 1,
				column = -1
			},
			{
				row = 1,
				column = 1
			}
		}

		while #slot10 > 0 and slot7 > 0 do
			if not slot1:hasFill(table.remove(slot10, 1).row, table.remove(slot10, 1).column) and slot12.color == slot4 then
				table.insert(slot8, slot12)

				slot7 = slot7 - 1

				_.each(slot11, function (slot0)
					if slot0:getCell(slot0.row + slot1.row, slot0.column + slot1.column) and not (_.any(_.any, function (slot0)
						return slot0.row == slot0.row and slot0.column == slot0.column
					end) or _.any(slot3, function (slot0)
						return slot0.row == slot0.row and slot0.column == slot0.column
					end)) then
						table.insert(slot2, {
							row = slot1.row,
							column = slot1.column,
							color = slot1.type
						})
					end
				end)
			end

			table.insert(slot9, slot12)
		end

		return slot8
	end
end

slot0.SearchValidDiagonalColoringCells = function (slot0, slot1, slot2, slot3)
	slot4 = {}

	if slot1:getState() ~= ColorGroup.StateColoring or slot1:canBeCustomised() or slot3 == 0 then
		return slot4
	else
		slot5, slot6 = slot1:GetAABB()
		slot7 = slot6.x - slot5.x
		slot8 = slot6.y - slot5.y

		function slot9()
			for slot4 = 0, slot0 + slot1, 1 do
				for slot8 = 0, slot4, 1 do
					slot10 = slot8

					if slot4 - slot8 <= slot0 and slot10 <= slot1 and slot3:getCell(slot10 + slot2.y, slot9 + slot2.x) and slot13.type == slot4 and not slot3:getFill(slot11, slot12) then
						table.insert(slot5, {
							row = slot11,
							column = slot12,
							color = slot4
						})

						if slot6 <= #slot5 then
							return
						end
					end
				end
			end
		end

		slot9()

		return slot4
	end
end

slot0.TryPlayStory = function (slot0)
	slot2 = slot0.selectedIndex

	table.eachAsync({}, function (slot0, slot1, slot2)
		if slot0 <= slot0 and slot1 then
			pg.NewStoryMgr.GetInstance():Play(slot1, slot2)
		else
			slot2()
		end
	end)
end

slot0.onBackPressed = function (slot0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(slot0.btnBack)
end

slot0.willExit = function (slot0)
	slot0.loader:Clear()
	PoolMgr.GetInstance():ReturnUI(slot0.coloringUIGroupName, slot0.colorgroupbehind)
end

slot0.Clone2Full = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = slot1:GetChild(0)

	for slot9 = 0, slot1.childCount - 1, 1 do
		table.insert(slot3, slot1:GetChild(slot9))
	end

	for slot9 = slot5, slot2 - 1, 1 do
		table.insert(slot3, tf(cloneTplTo(slot4, slot1)))
	end

	return slot3
end

return slot0

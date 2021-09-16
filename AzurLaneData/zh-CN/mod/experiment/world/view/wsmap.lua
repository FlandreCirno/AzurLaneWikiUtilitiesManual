slot0 = class("WSMap", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	rtQuads = "userdata",
	wsMapQuads = "table",
	wsMapArtifactsFA = "table",
	wsMapPath = "table",
	wsMapCells = "table",
	wsMapAttachments = "table",
	world = "table",
	rtTop = "userdata",
	rtTargetArrow = "userdata",
	rtItems = "userdata",
	rtEffectA = "userdata",
	wsTerrainEffects = "table",
	rtEffectB = "userdata",
	taskQueue = "table",
	twTimerId = "number",
	wsMapArtifacts = "table",
	rangeVisible = "boolean",
	wsMapFleets = "table",
	transform = "userdata",
	wsPool = "table",
	twTimer = "userdata",
	rtCells = "userdata",
	displayRangeLines = "table",
	wsTimer = "table",
	wsMapItems = "table",
	transportDisplay = "number",
	wsCarryItems = "table",
	wsMapResource = "table",
	wsMapTransports = "table",
	displayRangeTimer = "table",
	rtEffectC = "userdata"
}
slot0.Listeners = {
	onRemoveCarry = "OnRemoveCarry",
	onUpdateAttachment = "OnUpdateAttachment",
	onUpdateTerrain = "OnUpdateTerrain",
	onUpdateFleetFOV = "OnUpdateFleetFOV",
	onAddAttachment = "OnAddAttachment",
	onRemoveAttachment = "OnRemoveAttachment",
	onAddCarry = "OnAddCarry"
}
slot0.EventUpdateEventTips = "WSMap.EventUpdateEventTips"

slot0.Setup = function (slot0, slot1)
	slot0.map = slot1
	slot0.wsMapQuads = {}
	slot0.wsMapItems = {}
	slot0.wsMapCells = {}
	slot0.wsMapFleets = {}
	slot0.wsMapArtifacts = {}
	slot0.wsMapArtifactsFA = {}
	slot0.wsMapTransports = {}
	slot0.wsMapAttachments = {}
	slot0.wsTerrainEffects = {}
	slot0.wsCarryItems = {}
	slot0.wsMapPath = WSMapPath.New()

	slot0.wsMapPath:Setup(slot0.map.theme)

	slot0.wsMapResource = WSMapResource.New()

	slot0.wsMapResource:Setup(slot0.map)

	slot0.taskQueue = TSTaskQueue.New(0.025)
	slot0.transportDisplay = WorldConst.TransportDisplayNormal

	pg.DelegateInfo.New(slot0)
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
	slot0.taskQueue:Clear()
	slot0.wsMapPath:Dispose()
	slot0:ClearTargetArrow()
	slot0:Unload()
	slot0:Clear()
end

slot0.Load = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		slot0:InitPlane()
		slot0.wsMapResource:Load(slot0)
	end)
	table.insert(slot2, function (slot0)
		slot0:InitClutter()
		slot0:InitMap()
		slot0.taskQueue:Enqueue(slot0)
	end)
	seriesAsync(slot2, slot1)
end

slot0.Unload = function (slot0)
	slot0:DisposeMap()
	slot0.wsMapResource:Unload()

	if slot0.transform then
		PoolMgr.GetInstance():ReturnPrefab("world/object/world_plane", "world_plane", slot0.transform.gameObject, true)

		slot0.transform = nil
	end
end

slot0.InitPlane = function (slot0)
	PoolMgr.GetInstance().GetPrefab(slot1, "world/object/world_plane", "world_plane", false, function (slot0)
		slot0.transform = slot0.transform

		setActive(slot0.transform, false)
	end)

	slot0.rtQuads = slot0.transform.Find(slot2, "quads")
	slot0.rtItems = slot0.transform:Find("items")
	slot0.rtCells = slot0.transform:Find("cells")
	slot0.rtTop = slot0.transform:Find("top")
	slot0.rtEffectA = slot0.transform:Find("effect-a-1-999")
	slot0.rtEffectB = slot0.transform:Find("effect-b-1001-1999")
	slot0.rtEffectC = slot0.transform:Find("effect-c-2001-2999")
	slot0.transform.name = "plane"
	slot0.transform.anchoredPosition3D = Vector3(slot0.map.theme.offsetx, slot0.map.theme.offsety, slot0.map.theme.offsetz) + WorldConst.DefaultMapOffset

	setImageAlpha(slot6, 0)
	GetSpriteFromAtlasAsync("chapter/pic/" .. slot0.map.theme.assetSea, slot0.map.theme.assetSea, function (slot0)
		if slot0 then
			setImageSprite(slot0, slot0, false)
			setImageAlpha(slot0, 1)
		end
	end)

	slot7 = Vector2(10000, 10000)
	slot8 = Vector2.zero
	slot9 = Vector2(WorldConst.MaxColumn, WorldConst.MaxRow)
	slot10 = Vector2(-WorldConst.MaxColumn, -WorldConst.MaxRow)

	for slot14 = 0, WorldConst.MaxRow - 1, 1 do
		for slot18 = 0, WorldConst.MaxColumn - 1, 1 do
			if slot2.GetCell(slot2, slot14, slot18) then
				slot7.x = math.min(slot7.x, slot18)
				slot7.y = math.min(slot7.y, WorldConst.MaxRow * 0.5 - slot14 - 1)
				slot9.x = math.min(slot9.x, slot18)
				slot9.y = math.min(slot9.y, slot14)
				slot10.x = math.max(slot10.x, slot18)
				slot10.y = math.max(slot10.y, slot14)
			end
		end
	end

	slot7.x = slot7.x * slot3.cellSize + slot3.cellSpace.x
	slot7.y = slot7.y * slot3.cellSize + slot3.cellSpace.y
	slot8.x = (slot10.x - slot9.x + 1) * slot3.cellSize + slot3.cellSpace.x
	slot8.y = (slot10.y - slot9.y + 1) * slot3.cellSize + slot3.cellSpace.y
	slot5.anchoredPosition = slot7 + slot8 * 0.5
	slot5.sizeDelta = slot8
	slot13 = slot5:Find("linev")
	slot14 = slot13:GetChild(0)
	slot15 = slot13:GetComponent(typeof(GridLayoutGroup))
	slot15.cellSize = Vector2(WorldConst.LineCross, slot5.sizeDelta.y)
	slot15.spacing = Vector2(slot3.cellSize + slot3.cellSpace.x - WorldConst.LineCross, 0)
	slot15.padding.left = math.floor(slot15.spacing.x)

	for slot19 = slot13.childCount - 1, math.max(Vector2(math.floor(slot5.sizeDelta.x / slot3.cellSize + slot3.cellSpace.x), math.floor(slot5.sizeDelta.y / slot3.cellSize + slot3.cellSpace.y)).x - 1, 0), -1 do
		if slot19 > 0 then
			Destroy(slot13:GetChild(slot19))
		end
	end

	for slot19 = slot13.childCount, slot12.x - 2, 1 do
		Instantiate(slot14).transform:SetParent(slot13, false)
	end

	slot16 = slot5:Find("lineh")
	slot17 = slot16:GetChild(0)
	slot18 = slot16:GetComponent(typeof(GridLayoutGroup))
	slot18.cellSize = Vector2(slot5.sizeDelta.x, WorldConst.LineCross)
	slot18.spacing = Vector2(0, slot11.y - WorldConst.LineCross)
	slot18.padding.top = math.floor(slot18.spacing.y)

	for slot22 = slot16.childCount - 1, math.max(slot12.y - 1, 0), -1 do
		if slot22 > 0 then
			Destroy(slot16:GetChild(slot22))
		end
	end

	for slot22 = slot16.childCount, slot12.y - 2, 1 do
		Instantiate(slot17).transform:SetParent(slot16, false)
	end
end

slot0.InitClutter = function (slot0)
	slot0.twTimer = LeanTween.value(slot0.transform.gameObject, 1, 0, WorldConst.QuadBlinkDuration):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	slot0.wsTimer:AddInMapTween(slot0.twTimer.uniqueId)
	slot0:NewTargetArrow()
end

slot0.InitMap = function (slot0)
	slot2 = slot0.map.theme
	slot3 = slot0.taskQueue

	table.sort(slot4, function (slot0, slot1)
		return slot0.row < slot1.row or (slot0.row == slot1.row and slot0.column < slot1.column)
	end)

	for slot8, slot9 in ipairs(slot4) do
		slot3:Enqueue(function ()
			slot0.wsMapQuads[WSMapQuad.GetName(slot1.row, slot1.column)] = slot0:NewQuad(slot0)
		end)
		slot3.Enqueue(slot3, function ()
			slot0.wsMapCells[WSMapCell.GetName(slot1.row, slot1.column)] = slot0:NewCell(slot0)
		end)
	end

	for slot8, slot9 in ipairs(slot1.config.float_items) do
		slot3.Enqueue(slot3, function ()
			if slot1:GetCell(slot0[1], slot0[2]) then
				if not slot2:GetItem(slot0, slot1) then
					slot2.wsMapItems[WSMapItem.GetName(slot2.row, slot2.column)] = slot2:NewItem(slot2)
				end

				table.insert(slot2.wsMapArtifacts, slot2:NewArtifact(slot3, slot0))
			end
		end)
	end

	for slot8, slot9 in ipairs(slot4) do
		for slot13, slot14 in ipairs(slot9.attachments) do
			slot3:Enqueue(function ()
				slot0 = slot0:GetCell(slot1.row, slot1.column)

				if slot0.type == WorldMapAttachment.TypeArtifact then
					if not slot0:GetItem(slot2.row, slot2.column) then
						slot0.wsMapItems[WSMapItem.GetName(slot2.row, slot2.column)] = slot0:NewItem(slot0.NewItem)
					end

					table.insert(slot0.wsMapArtifactsFA, slot0:NewArtifact(slot1, slot1:GetArtifaceInfo(), slot1))
				else
					table.insert(slot0.wsMapAttachments, slot0:NewAttachment(slot0, slot0.NewAttachment))
				end
			end)
		end
	end

	for slot8, slot9 in ipairs(slot1.GetNormalFleets(slot1)) do
		slot3:Enqueue(function ()
			table.insert(slot0.wsMapFleets, slot0:NewFleet(slot0))
		end)

		for slot13, slot14 in ipairs(slot9.GetCarries(slot9)) do
			slot3:Enqueue(function ()
				table.insert(slot0.wsCarryItems, slot0:NewCarryItem(slot0, ))
			end)
		end
	end

	slot3.Enqueue(slot3, function ()
		slot0:FlushFleets()
	end)
	slot1.AddListener(slot1, WorldMap.EventUpdateFleetFOV, slot0.onUpdateFleetFOV)
end

slot0.DisposeMap = function (slot0)
	slot0.map:RemoveListener(WorldMap.EventUpdateFleetFOV, slot0.onUpdateFleetFOV)
	_.each(slot0.wsCarryItems, function (slot0)
		slot0:DisposeCarryItem(slot0)
	end)

	slot0.wsCarryItems = {}

	_.each(slot0.wsMapFleets, function (slot0)
		slot0:DisposeFleet(slot0)
	end)

	slot0.wsMapFleets = {}

	_.each(slot0.wsMapAttachments, function (slot0)
		slot0:DisposeAttachment(slot0)
	end)

	slot0.wsMapAttachments = {}

	_.each(slot0.wsMapArtifacts, function (slot0)
		slot0:DisposeArtifact(slot0)
	end)

	slot0.wsMapArtifacts = {}

	for slot4, slot5 in pairs(slot0.wsMapTransports) do
		slot0.DisposeTransport(slot0, slot5)
	end

	slot0.wsMapTransports = {}

	_.each(slot0.wsMapArtifactsFA, function (slot0)
		slot0:DisposeArtifact(slot0)
	end)

	slot0.wsMapArtifactsFA = {}

	for slot4, slot5 in pairs(slot0.wsMapCells) do
		slot0.DisposeCell(slot0, slot5)
	end

	slot0.wsMapCells = {}

	for slot4, slot5 in pairs(slot0.wsMapItems) do
		slot0:DisposeItem(slot5)
	end

	slot0.wsMapItems = {}

	for slot4, slot5 in pairs(slot0.wsMapQuads) do
		slot0:DisposeQuad(slot5)
	end

	slot0.wsMapQuads = {}

	for slot4, slot5 in ipairs(slot0.wsTerrainEffects) do
		slot0:DisposeTerrainEffect(slot5)
	end

	slot0.wsTerrainEffects = {}
end

slot0.OnAddAttachment = function (slot0, slot1, slot2, slot3)
	slot4 = slot0:GetCell(slot2.row, slot2.column)

	if slot3.type == WorldMapAttachment.TypeArtifact then
		if not slot0:GetItem(slot2.row, slot2.column) then
			slot0.wsMapItems[WSMapItem.GetName(slot2.row, slot2.column)] = slot0:NewItem(slot2)
		end

		table.insert(slot0.wsMapArtifactsFA, slot0:NewArtifact(slot5, slot3:GetArtifaceInfo(), slot3))
	else
		table.insert(slot0.wsMapAttachments, slot5)
		slot0:OnUpdateAttachment(nil, slot3)
	end
end

slot0.OnRemoveAttachment = function (slot0, slot1, slot2, slot3)
	if slot3.type == WorldMapAttachment.TypeArtifact then
		for slot7 = #slot0.wsMapArtifactsFA, 1, -1 do
			if slot0.wsMapArtifactsFA[slot7].attachment == slot3 then
				slot0:DisposeArtifact(slot8)
				table.remove(slot0.wsMapArtifactsFA, slot7)

				break
			end
		end
	else
		for slot7 = #slot0.wsMapAttachments, 1, -1 do
			if slot0.wsMapAttachments[slot7].attachment == slot3 then
				slot0:DisposeAttachment(slot8)
				table.remove(slot0.wsMapAttachments, slot7)
				slot0:OnUpdateAttachment(nil, slot3)

				break
			end
		end
	end
end

slot0.OnUpdateAttachment = function (slot0, slot1, slot2)
	_.each(slot3, function (slot0)
		slot0:Update(slot0)
	end)

	if slot0.FindFleet(slot0, slot2.row, slot2.column) then
		slot0:FlushFleets()
	end

	slot0:DispatchEvent(slot0.EventUpdateEventTips)
end

slot0.OnUpdateTerrain = function (slot0, slot1, slot2)
	slot3, slot4 = slot0:GetTerrainEffect(slot2.row, slot2.column)

	if slot3 then
		slot0:DisposeTerrainEffect(slot3)
		table.remove(slot0.wsTerrainEffects, slot4)
	end

	if slot2:GetTerrain() == WorldMapCell.TerrainStream or slot5 == WorldMapCell.TerrainWind or slot5 == WorldMapCell.TerrainIce or slot5 == WorldMapCell.TerrainPoison then
		table.insert(slot0.wsTerrainEffects, slot0:NewTerrainEffect(slot2))
	end
end

slot0.OnAddCarry = function (slot0, slot1, slot2, slot3)
	table.insert(slot0.wsCarryItems, slot0:NewCarryItem(slot2, slot3))
end

slot0.OnRemoveCarry = function (slot0, slot1, slot2, slot3)
	for slot7 = #slot0.wsCarryItems, 1, -1 do
		if slot0.wsCarryItems[slot7].carryItem == slot3 then
			slot0:DisposeCarryItem(slot8)
			table.remove(slot0.wsCarryItems, slot7)

			break
		end
	end
end

slot0.OnUpdateFleetFOV = function (slot0)
	slot0:FlushFleets()
end

slot0.NewQuad = function (slot0, slot1)
	slot2 = WPool:Get(WSMapQuad)
	slot2.twTimer = slot0.twTimer

	slot2:Setup(slot1, slot0.map.theme)
	slot2:Load()
	slot2.transform:SetParent(slot0.rtQuads, false)

	return slot2
end

slot0.DisposeQuad = function (slot0, slot1)
	WPool:Return(slot1)
end

slot0.NewItem = function (slot0, slot1)
	slot2 = WPool:Get(WSMapItem)

	slot2:Setup(slot1, slot0.map.theme)
	slot2:Load()
	slot2.transform:SetParent(slot0.rtItems, false)

	return slot2
end

slot0.DisposeItem = function (slot0, slot1)
	WPool:Return(slot1)
end

slot0.NewCell = function (slot0, slot1)
	slot2 = WPool:Get(WSMapCell)
	slot2.wsMapResource = slot0.wsMapResource
	slot2.wsTimer = slot0.wsTimer

	slot2:Setup(slot0.map, slot1)
	slot2:Load()
	slot2.transform:SetParent(slot0.rtCells, false)
	slot2.rtFog:SetParent(slot0.rtCells:Find("fogs"), true)
	slot1:AddListener(WorldMapCell.EventAddAttachment, slot0.onAddAttachment)
	slot1:AddListener(WorldMapCell.EventRemoveAttachment, slot0.onRemoveAttachment)
	slot1:AddListener(WorldMapCell.EventUpdateTerrain, slot0.onUpdateTerrain)
	slot0:OnUpdateTerrain(nil, slot1)

	return slot2
end

slot0.DisposeCell = function (slot0, slot1)
	slot1.rtFog:SetParent(slot1.transform, true)
	slot1.cell.RemoveListener(slot2, WorldMapCell.EventAddAttachment, slot0.onAddAttachment)
	slot1.cell.RemoveListener(slot2, WorldMapCell.EventRemoveAttachment, slot0.onRemoveAttachment)
	slot1.cell.RemoveListener(slot2, WorldMapCell.EventUpdateTerrain, slot0.onUpdateTerrain)
	WPool:Return(slot1)
end

slot0.NewTransport = function (slot0, slot1, slot2, slot3)
	slot4 = WPool:Get(WSMapTransport)
	slot4.wsMapPath = slot0.wsMapPath

	slot4:Setup(slot1, slot2, slot3, slot0.map)
	slot4:Load()
	slot4.transform:SetParent(slot0.rtQuads, false)

	return slot4
end

slot0.DisposeTransport = function (slot0, slot1)
	WPool:Return(slot1)
end

slot0.NewAttachment = function (slot0, slot1, slot2)
	slot3 = WPool:Get(WSMapAttachment)
	slot3.transform = slot0.wsPool:Get(slot4).transform

	slot3.transform:SetParent(slot1.rtAttachments, false)

	slot3.twTimer = slot0.twTimer

	slot3:Setup(slot0.map, slot1.cell, slot2)
	slot2:AddListener(WorldMapAttachment.EventUpdateFlag, slot0.onUpdateAttachment)
	slot2:AddListener(WorldMapAttachment.EventUpdateData, slot0.onUpdateAttachment)
	slot2:AddListener(WorldMapAttachment.EventUpdateLurk, slot0.onUpdateAttachment)

	return slot3
end

slot0.DisposeAttachment = function (slot0, slot1)
	slot1.attachment.RemoveListener(slot2, WorldMapAttachment.EventUpdateFlag, slot0.onUpdateAttachment)
	slot1.attachment.RemoveListener(slot2, WorldMapAttachment.EventUpdateData, slot0.onUpdateAttachment)
	slot1.attachment.RemoveListener(slot2, WorldMapAttachment.EventUpdateLurk, slot0.onUpdateAttachment)
	slot0.wsPool:Return(slot3, slot1.transform.gameObject)
	WPool:Return(slot1)
end

slot0.NewArtifact = function (slot0, slot1, slot2, slot3)
	slot4 = WPool:Get(WSMapArtifact)

	slot4.transform:SetParent(slot1.rtArtifacts, false)
	slot4:Setup(slot2, slot0.map.theme, slot3)

	return slot4
end

slot0.DisposeArtifact = function (slot0, slot1)
	WPool:Return(slot1)
end

slot0.GetTerrainEffectParent = function (slot0, slot1)
	if slot1 == WorldMapCell.TerrainStream then
		return slot0.rtEffectB
	elseif slot1 == WorldMapCell.TerrainWind then
		return slot0.rtEffectC
	elseif slot1 == WorldMapCell.TerrainIce then
		return slot0.rtEffectA
	elseif slot1 == WorldMapCell.TerrainPoison then
		return slot0.rtEffectA
	end
end

slot0.NewTerrainEffect = function (slot0, slot1)
	slot2 = WPool:Get(WSMapCellEffect)
	slot2.transform = createNewGameObject("mapCellEffect")

	slot2.transform:SetParent(slot0:GetTerrainEffectParent(slot1:GetTerrain()), false)
	slot2:Setup(slot1, slot0.map.theme)

	return slot2
end

slot0.DisposeTerrainEffect = function (slot0, slot1)
	WPool:Return(slot1)
	Destroy(slot1.transform)
end

slot0.GetTerrainEffect = function (slot0, slot1, slot2)
	for slot6, slot7 in ipairs(slot0.wsTerrainEffects) do
		if slot7.cell.row == slot1 and slot7.cell.column == slot2 then
			return slot7, slot6
		end
	end
end

slot0.NewFleet = function (slot0, slot1)
	slot2 = WPool:Get(WSMapFleet)
	slot2.transform = slot0.wsPool:Get(slot3).transform

	slot2.transform:SetParent(slot0.rtCells, false)
	slot2:Setup(slot1, slot0.map.theme)
	slot2.rtRetreat:SetParent(slot0.rtTop, false)
	slot1:AddListener(WorldMapFleet.EventAddCarry, slot0.onAddCarry)
	slot1:AddListener(WorldMapFleet.EventRemoveCarry, slot0.onRemoveCarry)

	return slot2
end

slot0.DisposeFleet = function (slot0, slot1)
	slot1.fleet:RemoveListener(WorldMapFleet.EventAddCarry, slot0.onAddCarry)
	slot1.fleet:RemoveListener(WorldMapFleet.EventRemoveCarry, slot0.onRemoveCarry)
	slot1.rtRetreat:SetParent(slot1.transform, false)
	slot0.wsPool:Return(WSMapFleet.GetResName(), slot1.transform.gameObject)
	WPool:Return(slot1)
end

slot0.NewCarryItem = function (slot0, slot1, slot2)
	slot3 = WPool:Get(WSCarryItem)
	slot3.transform = slot0.wsPool:Get(slot4).transform

	slot3.transform:SetParent(slot0.rtCells, false)
	slot3:Setup(slot1, slot2, slot0.map.theme)

	return slot3
end

slot0.DisposeCarryItem = function (slot0, slot1)
	slot0.wsPool:Return(WSCarryItem.GetResName(), slot1.transform.gameObject)
	WPool:Return(slot1)
end

slot0.GetCarryItem = function (slot0, slot1)
	return _.detect(slot0.wsCarryItems, function (slot0)
		return slot0.carryItem == slot0
	end)
end

slot0.FindCarryItems = function (slot0, slot1)
	return _.filter(slot0.wsCarryItems, function (slot0)
		return slot0.fleet == slot0
	end)
end

slot0.GetFleet = function (slot0, slot1)
	slot1 = slot1 or slot0.map:GetFleet()

	return _.detect(slot0.wsMapFleets, function (slot0)
		return slot0.fleet == slot0
	end)
end

slot0.FindFleet = function (slot0, slot1, slot2)
	return _.detect(slot0.wsMapFleets, function (slot0)
		return slot0.fleet.row == slot0 and slot0.fleet.column == 
	end)
end

slot0.GetCell = function (slot0, slot1, slot2)
	return slot0.wsMapCells[WSMapCell.GetName(slot1, slot2)]
end

slot0.GetAttachment = function (slot0, slot1, slot2, slot3)
	return _.detect(slot0.wsMapAttachments, function (slot0)
		return slot0.attachment.row == slot0 and slot0.attachment.column ==  and slot0.attachment.type == slot2
	end)
end

slot0.FindAttachments = function (slot0, slot1, slot2)
	return _.filter(slot0.wsMapAttachments, function (slot0)
		return slot0.attachment.row == slot0 and slot0.attachment.column == 
	end)
end

slot0.GetQuad = function (slot0, slot1, slot2)
	return slot0.wsMapQuads[WSMapQuad.GetName(slot1, slot2)]
end

slot0.GetItem = function (slot0, slot1, slot2)
	return slot0.wsMapItems[WSMapItem.GetName(slot1, slot2)]
end

slot0.GetTransport = function (slot0, slot1, slot2, slot3)
	return slot0.wsMapTransports[WSMapTransport.GetName(slot1, slot2, slot3)]
end

slot0.UpdateRangeVisible = function (slot0, slot1)
	if slot0.rangeVisible ~= slot1 then
		slot0.rangeVisible = slot1

		if slot1 then
			slot0:DisplayMoveRange()
		else
			slot0:HideMoveRange()
		end
	end
end

slot0.DisplayMoveRange = function (slot0)
	slot0.displayRangeLines = {}
	slot3 = 0

	for slot7, slot8 in ipairs(slot2) do
		setImageAlpha(slot0:GetQuad(slot8.row, slot8.column).rtWalkQuad, math.pow(0.75, (slot8.stay and slot8.stay - 1) or 0))
		setLocalScale(slot9.rtWalkQuad, Vector3.zero)

		slot3 = math.max(slot3, setImageAlpha)
		slot11 = {
			line = slot8,
			func = function ()
				slot0.uid = LeanTween.scale(slot1.rtWalkQuad, Vector3.one, 0.2):setEase(LeanTweenType.easeInOutSine).uniqueId

				slot2.wsTimer:AddInMapTween(slot0.uid)
			end
		}
		slot0.displayRangeLines[setImageAlpha] = slot0.displayRangeLines[ManhattonDist(slot1, slot8)] or {}

		table.insert(slot0.displayRangeLines[setImageAlpha], slot11)
	end

	if slot3 > 0 then
		slot4 = 0
		slot0.displayRangeTimer = slot0.wsTimer:AddInMapTimer(function ()
			slot0 = slot0 + 1

			if slot1.displayRangeLines[] then
				for slot3, slot4 in ipairs(slot1.displayRangeLines[ipairs]) do
					slot4.func()
				end
			end
		end, 0.1, slot3)

		slot0.displayRangeTimer:Start()
	end
end

slot0.HideMoveRange = function (slot0)
	if slot0.displayRangeTimer then
		slot0.wsTimer:RemoveInMapTimer(slot0.displayRangeTimer)

		slot0.displayRangeTimer = nil
	end

	if slot0.displayRangeLines then
		for slot4, slot5 in pairs(slot0.displayRangeLines) do
			for slot9, slot10 in ipairs(slot5) do
				if slot10.uid then
					slot0.wsTimer:RemoveInMapTween(slot10.uid)
				end

				setImageAlpha(slot0:GetQuad(slot10.line.row, slot10.line.column).rtWalkQuad, 0)
				setLocalScale(slot0.GetQuad(slot10.line.row, slot10.line.column).rtWalkQuad, Vector3.one)
			end
		end

		slot0.displayRangeLines = nil
	end
end

slot0.MovePath = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = slot0.map
	slot7 = _.map(slot2, function (slot0)
		return slot0:GetQuad(slot0.row, slot0.column)
	end)
	slot8 = nil

	if slot5 then
		WPool.Get(slot9, WSMapEffect).transform = createNewGameObject("mapEffect")

		WPool.Get(slot9, WSMapEffect).transform:SetParent(slot1.transform, false)

		WPool.Get(slot9, WSMapEffect).transform.anchoredPosition3D = Vector3.zero
		WPool.Get(slot9, WSMapEffect).transform.localEulerAngles = Vector3(slot0.map.theme.angle, 0, 0)
		WPool.Get(slot9, WSMapEffect).modelOrder = slot1.modelOrder

		WPool.Get(slot9, WSMapEffect).Setup(slot8, WorldConst.GetWindEffect())
		WPool.Get(slot9, WSMapEffect):Load()
	end

	slot9 = 0

	for slot13, slot14 in ipairs(slot7) do
		LeanTween.cancel(slot14.rtWalkQuad)
		setLocalScale(slot14.rtWalkQuad, Vector3.one)
		setImageAlpha(slot14.rtWalkQuad, 0)
		LeanTween.alpha(slot14.rtWalkQuad, 1, slot2[slot13].duration / 2):setDelay(slot9)

		slot9 = slot9 + slot2[slot13].duration / 2
	end

	slot10 = 0
	slot12 = nil

	slot0.wsMapPath.AddListener(slot13, WSMapPath.EventArrivedStep, nil)
	slot0.wsMapPath:AddListener(WSMapPath.EventArrived, function ()
		slot0.wsMapPath:RemoveListener(WSMapPath.EventArrivedStep, slot0.wsMapPath)
		slot0.wsMapPath.RemoveListener.wsMapPath:RemoveListener(WSMapPath.EventArrived, )
		_.each(WSMapPath.EventArrived, function (slot0)
			LeanTween.cancel(slot0.rtWalkQuad)
			setImageAlpha(slot0.rtWalkQuad, 0)
		end)

		if slot4 then
			WPool.Return(slot1, slot5)
			Destroy(slot5.transform)
		end
	end)
	slot0.wsMapPath:UpdateObject(slot1)
	slot0.wsMapPath:UpdateAction((slot5 and WorldConst.ActionDrag) or WorldConst.ActionMove)
	slot0.wsMapPath:UpdateDirType(slot4)
	slot0.wsMapPath:StartMove(slot3, slot2, (slot5 and 100) or 0)

	return slot0.wsMapPath
end

slot0.FlushFleets = function (slot0)
	slot0:FlushFleetVisibility()
	slot0:FlushFleetRetreatBtn()
	slot0:FlushEnemyFightingMark()
	slot0:FlushTransportDisplay()

	slot1 = slot0.map:GetFleet()

	_.each(slot0.wsMapFleets, function (slot0)
		slot0:UpdateSelected(slot0.fleet == slot0)
	end)
end

slot0.FlushFleetRetreatBtn = function (slot0)
	slot1 = slot0.map:GetFleet()

	_.each(slot0.wsMapFleets, function (slot0)
		setActive(slot0.rtRetreat, slot0.map:GetCell(slot0.fleet.row, slot0.fleet.column):ExistEnemy() and slot1 == slot1 and not WorldConst.IsWorldGuideEnemyId(slot2:GetStageEnemy().id))

		if slot0.map.GetCell(slot0.fleet.row, slot0.fleet.column).ExistEnemy() and slot1 == slot1 and not WorldConst.IsWorldGuideEnemyId(slot2.GetStageEnemy().id) then
			slot0.rtRetreat.localPosition = slot0.rtTop:InverseTransformPoint(slot0.transform.position) + Vector3(89, 0, 0)
			slot0.rtRetreat.localEulerAngles = Vector3(-slot0.map.theme.angle, 0, 0)

			slot0.rtRetreat:SetAsLastSibling()
		end
	end)
end

slot0.FlushEnemyFightingMark = function (slot0)
	_.each(slot0.wsMapAttachments, function (slot0)
		if WorldMapAttachment.IsEnemyType(slot0.attachment.type) then
			slot0:UpdateIsFighting(slot0.map:ExistFleet(slot1.row, slot1.column))
		end
	end)
end

slot0.FlushTransportVisibleByFleet = function (slot0)
	for slot4, slot5 in pairs(slot0.wsMapTransports) do
		if not _.any(slot0.wsMapFleets, function (slot0)
			return ManhattonDist({
				row = slot0.fleet.row,
				column = slot0.fleet.column
			}, {
				row = slot0.row,
				column = slot0.column
			}) <= 1
		end) then
			slot0.DisposeTransport(slot0, slot5)

			slot0.wsMapTransports[slot4] = nil
		end
	end

	_.each(slot0.wsMapFleets, function (slot0)
		for slot4 = WorldConst.DirNone, WorldConst.DirLeft, 1 do
			if slot0.map:GetCell(slot0.fleet.row + WorldConst.DirToLine(slot4).row, slot0.fleet.column + WorldConst.DirToLine(slot4).column) then
				for slot10 = WorldConst.DirUp, WorldConst.DirLeft, 1 do
					if bit.band(slot6.dir, bit.lshift(1, slot10)) > 0 then
						if not slot0.wsMapTransports[WSMapTransport.GetName(slot6.row, slot6.column, slot10)] then
							slot0.wsMapTransports[slot11] = slot0:NewTransport(slot6.row, slot6.column, slot10)

							setActive(slot0.NewTransport(slot6.row, slot6.column, slot10).rtClick, false)
						end

						slot12.UpdateAlpha(slot12, (_.any(slot0.wsMapFleets, function (slot0)
							return slot0.fleet.row == slot0.row and slot0.fleet.column == slot0.column
						end) and 1) or 0)
						setActive(slot12.rtForbid, slot0.map.config.is_transfer == 0)
					end
				end
			end
		end
	end)
end

slot0.FlushFleetVisibility = function (slot0)
	underscore.each(slot0.wsMapFleets, function (slot0)
		slot0:UpdateActive(not slot0.map:GetCell(slot0.fleet.row, slot0.fleet.column):ExistEnemy() and not slot2:InFog())
		_.each(slot0:FindCarryItems(slot1), function (slot0)
			slot0:UpdateActive(slot0)
		end)
	end)
end

slot0.UpdateSubmarineSupport = function (slot0)
	_.each(slot0.wsMapFleets, function (slot0)
		slot0:UpdateSubmarineSupport()
	end)
end

slot0.FlushMovingAttachment = function (slot0, slot1)
	if slot1.transform.parent ~= slot0.rtCells then
		slot1.transform:SetParent(slot0.rtCells, true)
	end

	slot2 = {
		row = slot1.attachment.row,
		column = slot1.attachment.column
	}

	if WorldMapAttachment.IsEnemyType(slot1.attachment.type) and slot0:FindFleet(slot2.row, slot2.column) then
		slot3:UpdateActive(true)
		setActive(slot3.rtRetreat, false)
		slot1:UpdateIsFighting(false)
	end

	slot0:FlushMovingAttachmentOrder(slot1, slot2)
end

slot0.FlushMovingAttachmentOrder = function (slot0, slot1, slot2)
	setActive(slot1.transform, slot0:GetCell(slot2.row, slot2.column).cell:GetInFOV() and not slot4:InFog())
	slot1:SetModelOrder(slot1.attachment:GetModelOrder(), slot2.row)
end

slot0.UpdateTransportDisplay = function (slot0, slot1)
	if slot0.transportDisplay ~= slot1 then
		slot0.transportDisplay = slot1

		slot0:FlushTransportDisplay()
	end
end

slot0.FlushTransportDisplay = function (slot0)
	if slot0.transportDisplay == WorldConst.TransportDisplayNormal then
		slot0:FlushTransportVisibleByFleet()
	else
		slot0:FlushTransportVisibleByState()
	end
end

slot0.FlushTransportVisibleByState = function (slot0)
	slot1 = slot0.map:GetCellsInFOV()

	for slot5, slot6 in pairs(slot0.wsMapTransports) do
		if not _.any(slot1, function (slot0)
			return slot0.row == slot0.row and slot0.column == slot0.column
		end) then
			slot0.DisposeTransport(slot0, slot6)

			slot0.wsMapTransports[slot5] = nil
		end
	end

	slot2 = WorldConst.DirUp

	_.each(slot1, function (slot0)
		for slot4 = slot0, WorldConst.DirLeft, 1 do
			if bit.band(slot0.dir, bit.lshift(1, slot4)) > 0 then
				if not slot1.wsMapTransports[WSMapTransport.GetName(slot0.row, slot0.column, slot4)] then
					slot1.wsMapTransports[slot5] = slot1:NewTransport(slot0.row, slot0.column, slot4)
				end

				setActive(slot6.rtForbid, slot1.transportDisplay == WorldConst.TransportDisplayGuideForbid)
				setActive(slot6.rtDanger, slot1.transportDisplay == WorldConst.TransportDisplayGuideDanger)
				slot6:UpdateAlpha(1)
			end
		end
	end)
end

slot0.NewTargetArrow = function (slot0)
	slot0.rtTargetArrow = slot0.wsPool:Get("arrow_tpl").transform

	setActive(slot0.rtTargetArrow, false)
end

slot0.DisplayTargetArrow = function (slot0, slot1, slot2)
	slot0.rtTargetArrow:SetParent(slot0:GetCell(slot1, slot2).transform, false)

	slot0.rtTargetArrow.anchoredPosition = Vector2.zero
	slot0.rtTargetArrow.localEulerAngles = Vector3(-slot0.map.theme.angle, 0, 0)
	slot0.rtTargetArrow:GetComponent(typeof(Canvas)).sortingOrder = WorldConst.LOFleet + defaultValue(slot1, 0) * 10

	setActive(slot0.rtTargetArrow, true)
end

slot0.HideTargetArrow = function (slot0)
	slot0.rtTargetArrow:SetParent(slot0.transform, false)
	setActive(slot0.rtTargetArrow, false)
end

slot0.ClearTargetArrow = function (slot0)
	slot0.wsPool:Return("arrow_tpl", slot0.rtTargetArrow)
end

slot0.ShowScannerMap = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.wsMapQuads) do
		if slot1 then
			slot6:UpdateStatic(true, true)
		else
			slot6:UpdateStatic(false)
		end
	end
end

return slot0

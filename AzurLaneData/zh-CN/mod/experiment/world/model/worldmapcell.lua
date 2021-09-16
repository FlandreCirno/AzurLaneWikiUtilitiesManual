slot0 = class("WorldMapCell", import("...BaseEntity"))
slot0.Fields = {
	terrainDir = "number",
	discovered = "boolean",
	attachments = "table",
	fogSairen = "boolean",
	dir = "number",
	column = "number",
	walkable = "boolean",
	fog = "boolean",
	row = "number",
	infov = "number",
	terrain = "number",
	inLight = "number",
	terrainStrong = "number",
	fogLight = "boolean"
}
slot0.EventAddAttachment = "WorldMapCell.EventAddAttachment"
slot0.EventRemoveAttachment = "WorldMapCell.EventRemoveAttachment"
slot0.EventUpdateInFov = "WorldMapCell.EventUpdateInFov"
slot0.EventUpdateDiscovered = "WorldMapCell.EventUpdateDiscovered"
slot0.EventUpdateFog = "WorldMapCell.EventUpdateFog"
slot0.EventUpdateFogImage = "WorldMapCell.EventUpdateFogImage"
slot0.EventUpdateTerrain = "WorldMapCell.EventUpdateTerrain"

slot0.GetName = function (slot0, slot1)
	return "cell_" .. slot0 .. "_" .. slot1
end

slot0.TerrainNone = 0
slot0.TerrainStream = 1
slot0.TerrainIce = 2
slot0.TerrainWind = 3
slot0.TerrainFog = 4
slot0.TerrainFire = 5
slot0.TerrainPoison = 6

slot0.Build = function (slot0)
	slot0.attachments = {}
	slot0.dir = 0
	slot0.infov = 0
	slot0.inLight = 0
	slot0.fog = false
	slot0.fogLight = false
	slot0.fogSairen = false
end

slot0.Setup = function (slot0, slot1)
	slot0.row = slot1[1]
	slot0.column = slot1[2]
	slot0.walkable = slot1[3]
end

slot0.Dispose = function (slot0)
	WPool:ReturnArray(slot0.attachments)
	slot0:Clear()
end

slot0.AddAttachment = function (slot0, slot1)
	slot2 = WorldMapAttachment.SortOrder[slot1.type]
	slot3 = #slot0.attachments + 1

	for slot7, slot8 in ipairs(slot0.attachments) do
		if WorldMapAttachment.SortOrder[slot8.type] < slot2 then
			slot3 = slot7

			break
		end
	end

	table.insert(slot0.attachments, slot3, slot1)
	slot0:DispatchEvent(slot0.EventAddAttachment, slot1)

	if not slot0.discovered and slot1:ShouldMarkAsLurk() then
		slot1:UpdateLurk(true)
	end
end

slot0.RemoveAttachment = function (slot0, slot1)
	if slot1 == nil or type(slot1) == "number" then
		table.remove(slot0.attachments, slot1 or #slot0.attachments)
		slot0:DispatchEvent(slot0.EventRemoveAttachment, slot0.attachments[slot1 or #slot0.attachments])
		WPool:Return(slot0.attachments[slot1 or #slot0.attachments])
	elseif slot1.class == WorldMapAttachment then
		for slot5 = #slot0.attachments, 1, -1 do
			if slot0.attachments[slot5] == slot1 then
				slot0:RemoveAttachment(slot5)

				break
			end
		end
	end
end

slot0.ContainsAttachment = function (slot0, slot1)
	return _.any(slot0.attachments, function (slot0)
		return slot0 == slot0
	end)
end

slot0.GetInFOV = function (slot0)
	if slot0.fog then
		return slot0.fogLight
	else
		return slot0.infov > 0 or slot0.inLight > 0
	end
end

slot0.UpdateInFov = function (slot0, slot1)
	AfterCheck({
		{
			function ()
				return slot0:GetInFOV()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateInFov)
			end
		}
	}, function ()
		slot0.infov = slot1
	end)
end

slot0.ChangeInLight = function (slot0, slot1)
	AfterCheck({
		{
			function ()
				return slot0:GetInFOV()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateInFov)
			end
		}
	}, function ()
		slot0.inLight = slot1 + ((slot0.inLight and 1) or -1)
	end)
end

slot0.InFog = function (slot0)
	if slot0.fog then
		return not slot0.fogLight
	else
		return slot0:GetTerrain() == slot0.TerrainFog
	end
end

slot0.LookSairenFog = function (slot0)
	return slot0.fogSairen or slot0:IsTerrainSairenFog()
end

slot0.UpdateFog = function (slot0, slot1, slot2, slot3)
	AfterCheck({
		{
			function ()
				return slot0:GetInFOV()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateInFov)
			end
		},
		{
			function ()
				return slot0:InFog()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateFog)
			end
		},
		{
			function ()
				return slot0:LookSairenFog()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateFogImage)
			end
		}
	}, function ()
		slot0.fog = defaultValue(defaultValue, slot0.fog)
		slot0.fogLight = defaultValue(defaultValue, slot0.fogLight)
		slot0.fogSairen = defaultValue(slot0.fogLight, slot0.fogSairen)
	end)
end

slot0.UpdateDiscovered = function (slot0, slot1)
	if slot0.discovered ~= slot1 then
		slot0.discovered = slot1

		slot0:DispatchEvent(slot0.EventUpdateDiscovered)
	end
end

slot0.GetTerrain = function (slot0)
	return slot0.terrain or slot0.TerrainNone
end

slot0.UpdateTerrain = function (slot0, slot1, slot2, slot3)
	AfterCheck({
		{
			function ()
				return slot0:InFog()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateFog)
			end
		},
		{
			function ()
				return slot0:LookSairenFog()
			end,
			function ()
				slot0:DispatchEvent(slot1.EventUpdateFogImage)
			end
		}
	}, function ()
		slot0.terrain = slot1

		if slot0.terrain == slot2.TerrainStream then
			slot0.terrainDir = slot3
		elseif slot0.terrain == slot2.TerrainWind then
			slot0.terrainDir = slot3
			slot0.terrainStrong = slot4
		elseif slot0.terrain == slot2.TerrainFog then
			slot0.terrainStrong = slot4
		elseif slot0.terrain == slot2.TerrainPoison then
			slot0.terrainStrong = slot4
		end

		slot0:DispatchEvent(slot2.EventUpdateTerrain)
	end)
end

slot0.GetAliveAttachments = function (slot0)
	return _.filter(slot0.attachments, function (slot0)
		return slot0:IsAlive()
	end)
end

slot0.GetAliveAttachment = function (slot0)
	return _.detect(slot0.attachments, function (slot0)
		return slot0:IsAlive()
	end)
end

slot0.GetDisplayAttachment = function (slot0)
	return _.detect(slot0.attachments, function (slot0)
		return slot0:IsAlive() and slot0:IsVisible()
	end)
end

slot0.GetInterativeAttachment = function (slot0)
	return _.detect(slot0.attachments, function (slot0)
		return WorldMapAttachment.IsInteractiveType(slot0.type) and slot0:IsAlive() and slot0:IsVisible()
	end)
end

slot0.GetEventAttachment = function (slot0)
	return _.detect(slot0.attachments, function (slot0)
		return slot0:IsAlive() and slot0.type == WorldMapAttachment.TypeEvent
	end)
end

slot0.GetCompassAttachment = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.attachments) do
		table.insert(slot1, slot5)
	end

	return _.detect(_.sort(slot1, function (slot0, slot1)
		return (slot0.attachments[slot0].config.compass_index or 0) > (slot0.attachments[slot1].config.compass_index or 0)
	end), function (slot0)
		if slot0.attachments[slot0]:ShouldMarkAsLurk() then
			return slot1:IsAlive() and slot1:IsVisible() and slot0.discovered
		elseif slot1.type == WorldMapAttachment.TypeEvent then
			return slot1:IsAlive() and slot1.config.visuality == 0
		elseif slot1.type ~= WorldMapAttachment.TypeFleet and slot1.type ~= WorldMapAttachment.TypePort then
			return slot1:IsAlive()
		end
	end) and slot0.attachments[slot2]
end

slot0.FindAliveAttachment = function (slot0, slot1)
	return _.detect(slot0.attachments, function (slot0)
		return slot0:IsAlive() and slot0.type == slot0
	end)
end

slot0.IsTerrainSairenFog = function (slot0)
	return slot0.terrain == slot0.TerrainFog and slot0.terrainStrong == 0
end

slot0.CanLeave = function (slot0)
	return slot0.walkable and slot0:GetTerrainObstacleConfig("leave") and underscore.all(slot0.attachments, function (slot0)
		return not slot0:IsAlive() or slot0:CanLeave()
	end)
end

slot0.CanArrive = function (slot0)
	return slot0.walkable and slot0:GetTerrainObstacleConfig("arrive") and underscore.all(slot0.attachments, function (slot0)
		return not slot0:IsAlive() or slot0:CanArrive()
	end)
end

slot0.CanPass = function (slot0)
	return slot0.walkable and slot0:GetTerrainObstacleConfig("pass") and underscore.all(slot0.attachments, function (slot0)
		return not slot0:IsAlive() or slot0:CanPass()
	end)
end

slot0.IsSign = function (slot0)
	return _.any(slot0.attachments, function (slot0)
		return slot0:IsAlive() and slot0:IsSign()
	end)
end

slot0.ExistEnemy = function (slot0)
	return tobool(slot0:GetStageEnemy())
end

slot0.GetStageEnemy = function (slot0)
	return _.detect(slot0.attachments, function (slot0)
		return slot0:IsAlive() and WorldMapAttachment.IsEnemyType(slot0.type)
	end)
end

slot0.GetDisplayQuad = function (slot0)
	slot1 = nil
	slot2 = slot0:GetDisplayAttachment()

	if not slot0:InFog() and slot2 then
		if slot2.type == WorldMapAttachment.TypeEvent then
			if slot2.config.object_icon and #slot3 > 0 then
				slot1 = slot3
			end
		elseif WorldMapAttachment.IsEnemyType(slot2.type) then
			slot1 = {
				"cell_red"
			}
		elseif slot2.type == WorldMapAttachment.TypePort or slot2.type == WorldMapAttachment.TypeBox then
			slot1 = {
				"cell_yellow"
			}
		end
	end

	return slot1
end

slot0.GetEmotion = function (slot0)
	return (slot0.terrain == slot0.TerrainPoison and WorldConst.PoisonEffect) or nil
end

slot0.GetScannerAttachment = function (slot0)
	slot2, slot3 = nil

	for slot7, slot8 in ipairs(slot1) do
		if slot8:IsScannerAttachment() and (not slot2 or slot3 < slot9) then
			slot2 = slot8
			slot3 = slot9
		end
	end

	return slot2
end

slot0.TerrainObstacleConfig = {
	SairenFog = 4,
	[slot0.TerrainNone] = 7,
	[slot0.TerrainStream] = 6,
	[slot0.TerrainIce] = 6,
	[slot0.TerrainWind] = 2,
	[slot0.TerrainFog] = 6,
	[slot0.TerrainFire] = 7,
	[slot0.TerrainPoison] = 7
}

slot0.GetTerrainObstacleConfig = function (slot0, slot1)
	return bit.band(slot0.TerrainObstacleConfig[(slot0:IsTerrainSairenFog() and "SairenFog") or slot0:GetTerrain()], WorldConst.GetObstacleKey(slot1)) > 0
end

slot0.IsMovingTerrain = function (slot0)
	return slot0 == slot0.TerrainStream or slot0 == slot0.TerrainIce or slot0 == slot0.TerrainWind
end

return slot0

slot0 = class("WSMapCellEffect", import(".WSMapEffect"))
slot0.Fields = {
	cell = "table",
	theme = "table"
}
slot0.Listeners = {
	onUpdate = "Update"
}

slot0.GetName = function (slot0, slot1)
	return "cell_effect_" .. slot0 .. "_" .. slot1
end

slot0.Setup = function (slot0, slot1, slot2)
	slot0.cell = slot1

	slot0.cell:AddListener(WorldMapCell.EventUpdateInFov, slot0.onUpdate)
	slot0.cell:AddListener(WorldMapCell.EventUpdateDiscovered, slot0.onUpdate)
	slot0.cell:AddListener(WorldMapCell.EventUpdateFog, slot0.onUpdate)

	slot0.theme = slot2

	slot0.super.Setup(slot0, WorldConst.GetTerrainEffectRes(slot0.cell:GetTerrain(), slot0.cell.terrainDir, slot0.cell.terrainStrong))
	slot0:Load(function ()
		if slot0.cell.GetTerrain(slot0) == WorldMapCell.TerrainStream then
			slot0:SetModelOrder(WorldConst.LOEffectB, slot0.row)
		elseif slot1 == WorldMapCell.TerrainWind then
			slot0:SetModelOrder(WorldConst.LOEffectC, slot0.row)
			setActive(slot0.model:GetChild(0):Find("Xyz/Arrow"), slot0.terrainStrong > 0)
			slot0:UpdateModelScale(WorldConst.GetWindScale(slot0.terrainStrong))
		elseif slot1 == WorldMapCell.TerrainIce then
			slot0:SetModelOrder(WorldConst.LOEffectA, slot0.row)
		elseif slot1 == WorldMapCell.TerrainPoison then
			slot0:SetModelOrder(WorldConst.LOEffectA, slot0.row)
		end
	end)
	slot0.Init(slot0)
end

slot0.Dispose = function (slot0)
	slot0.cell:RemoveListener(WorldMapCell.EventUpdateInFov, slot0.onUpdate)
	slot0.cell:RemoveListener(WorldMapCell.EventUpdateDiscovered, slot0.onUpdate)
	slot0.cell:RemoveListener(WorldMapCell.EventUpdateFog, slot0.onUpdate)
	slot0.super.Dispose(slot0)
end

slot0.Init = function (slot0)
	slot0.transform.name = slot0.GetName(slot0.cell.row, slot0.cell.column)
	slot0.transform.anchoredPosition3D = slot0.theme:GetLinePosition(slot0.cell.row, slot0.cell.column)

	slot0:Update()
end

slot0.Update = function (slot0, slot1)
	slot2 = slot0.cell

	if slot1 == nil or slot1 == WorldMapCell.EventUpdateInFov or slot1 == WorldMapCell.EventUpdateFog then
		setActive(slot0.transform, slot2:GetInFOV() and not slot2:InFog())
	end
end

return slot0

slot0 = class("WSMapItem", import("...BaseEntity"))
slot0.Fields = {
	cell = "table",
	transform = "userdata",
	rtArtifacts = "userdata",
	theme = "table"
}

slot0.GetName = function (slot0, slot1)
	return "item_" .. slot0 .. "_" .. slot1
end

slot0.Setup = function (slot0, slot1, slot2)
	slot0.cell = slot1
	slot0.theme = slot2
end

slot0.Dispose = function (slot0)
	slot0:Unload()
	slot0:Clear()
end

slot0.Load = function (slot0)
	PoolMgr.GetInstance():GetPrefab("world/object/world_cell_item", "world_cell_item", false, function (slot0)
		slot0.transform = slot0.transform

		slot0:Init()
	end)
end

slot0.Unload = function (slot0)
	if slot0.transform then
		PoolMgr.GetInstance():ReturnPrefab("world/object/world_cell_item", "world_cell_item", slot0.transform.gameObject)
	end

	slot0.transform = nil
end

slot0.Init = function (slot0)
	slot0.transform.name = slot0.GetName(slot0.cell.row, slot0.cell.column)
	slot0.transform.anchoredPosition = slot0.theme:GetLinePosition(slot0.cell.row, slot0.cell.column)
	slot0.transform.sizeDelta = slot0.theme.cellSize
	slot0.rtArtifacts = slot0.transform.Find(slot2, "artifacts")
	slot0.rtArtifacts.localEulerAngles = Vector3(-slot0.theme.angle, 0, 0)
end

return slot0

slot0 = class("ItemCell", import("view.level.cell.LevelCellView"))

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.super.Ctor(slot0)

	slot0.go = slot1
	slot0.tf = slot0.go.transform
	slot0.line = {
		row = slot2,
		column = slot3
	}
	slot0.assetName = nil

	slot0:OverrideCanvas()
	slot0:ResetCanvasOrder()
end

slot0.Init = function (slot0, slot1)
	if not slot1 then
		return
	end

	slot0.info = CreateShell(slot1)
end

slot0.GetInfo = function (slot0)
	return slot0.info
end

slot0.GetOriginalInfo = function (slot0)
	return slot0.info and getmetatable(slot0.info) and slot0.info and getmetatable(slot0.info).__index
end

slot0.Update = function (slot0)
	slot0.loader:GetPrefabBYStopLoading("chapter/" .. slot0.info.item, slot0.info.item, function (slot0)
		slot0.transform.name = slot0.item

		slot0.transform.SetParent(slot1, slot1.go, false)

		slot0.transform.anchoredPosition3D = slot0.itemOffset

		slot1:RecordCanvasOrder(slot1)
		slot1:AddCanvasOrder(slot0.transform, slot1:GetCurrentOrder())
	end, "ChapterItem" .. slot0.line.row .. "_" .. slot0.line.column)
end

slot0.UpdateAsset = function (slot0, slot1)
	if not slot0.info or not slot1 or slot1 == rawget(slot0.info, "item") then
		return
	end

	slot0.info.item = slot1

	slot0:Update()
end

slot0.ClearLoader = function (slot0)
	return
end

slot0.Clear = function (slot0)
	slot0.loader:ClearRequest("ChapterItem" .. slot0.line.row .. "_" .. slot0.line.column)
	slot0.super.Clear(slot0)
end

return slot0

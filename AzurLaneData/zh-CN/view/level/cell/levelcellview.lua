slot0 = class("LevelCellView")

slot0.Ctor = function (slot0)
	slot0.sortingOrderOffset = 0
	slot0.orderTable = {}
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityNone
end

slot0.SetLoader = function (slot0, slot1)
	slot0.loader = slot1
end

slot0.GetLoader = function (slot0)
	slot0.loader = slot0.loader or AutoLoader.New()

	return slot0.loader
end

slot0.ClearLoader = function (slot0)
	if slot0.loader then
		slot0.loader:Clear()
	end
end

slot0.GetLine = function (slot0)
	return slot0.line
end

slot0.SetLine = function (slot0, slot1)
	slot0.line = {
		row = slot1.row,
		column = slot1.column
	}
end

slot0.OverrideCanvas = function (slot0)
	pg.ViewUtils.SetLayer(tf(slot0.go), Layer.UI)

	slot0.canvas = GetOrAddComponent(slot0.go, typeof(Canvas))
	slot0.canvas.overrideSorting = true
end

slot0.ResetCanvasOrder = function (slot0)
	if not slot0.canvas then
		return
	end

	pg.ViewUtils.SetSortingOrder(slot0.tf, slot0.line.row * ChapterConst.PriorityPerRow + slot0:GetOrder())
end

slot0.GetCurrentOrder = function (slot0)
	return slot0.line.row * ChapterConst.PriorityPerRow + slot0:GetOrder()
end

slot0.AddCanvasOrder = function (slot0, slot1, slot2)
	for slot7 = 0, tf(slot1).GetComponents(slot1, typeof(Renderer)).Length - 1, 1 do
		slot3[slot7].sortingOrder = (slot0.orderTable[slot3[slot7]] or 0) + slot2
	end

	if slot1:GetComponent(typeof(Canvas)) then
		slot4.sortingOrder = (slot0.orderTable[slot4] or 0) + slot2
	end

	for slot8 = 0, slot1.childCount - 1, 1 do
		slot0:AddCanvasOrder(slot1:GetChild(slot8), slot2)
	end
end

slot0.RecordCanvasOrder = function (slot0, slot1)
	for slot6 = 0, tf(slot1).GetComponents(slot1, typeof(Renderer)).Length - 1, 1 do
		slot0.orderTable[slot2[slot6]] = slot2[slot6].sortingOrder
	end

	if slot1:GetComponent(typeof(Canvas)) then
		slot0.orderTable[slot3] = slot3.sortingOrder
	end

	for slot7 = 0, slot1.childCount - 1, 1 do
		slot0:RecordCanvasOrder(slot1:GetChild(slot7))
	end
end

slot0.Clear = function (slot0)
	for slot4, slot5 in pairs(slot0.orderTable) do
		if not IsNil(slot4) then
			slot4.sortingOrder = slot5
		end
	end

	table.clear(slot0.orderTable)
	slot0:ClearLoader()
end

return slot0

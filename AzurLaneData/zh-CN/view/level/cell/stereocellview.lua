slot0 = class("StereoCellView", import("view.level.cell.LevelCellView"))

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0)

	slot0.assetName = nil
	slot0.line = {
		row = slot1,
		column = slot2
	}
	slot0.buffer = FuncBuffer.New()
end

slot0.UpdateGO = function (slot0, slot1, slot2)
	if slot0:GetLoader():GetRequestPackage("main") and slot3.name == slot0.assetName then
		return
	end

	slot0.buffer:Clear()
	slot0.buffer:SetNotifier(nil)
	slot0:GetLoader():GetPrefab(slot1, slot2, function (slot0)
		slot0.go = slot0
		slot0.tf = slot0.go.transform

		slot0:OnLoaded(slot0)
		slot0.buffer:SetNotifier(slot0)
		slot0.buffer:ExcuteAll()
		slot0:OverrideCanvas()
		slot0:ResetCanvasOrder()
	end, "main")
end

slot0.OnLoaded = function (slot0, slot1)
	return
end

return slot0

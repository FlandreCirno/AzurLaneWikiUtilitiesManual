slot0 = class("AttachmentBarrierCell", import("view.level.cell.StaticCellView"))

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot0:PrepareBase("zulanwangheng")
		slot0:GetLoader():GetPrefab("chapter/zulanwangheng", "zulanwangheng", function (slot0)
			setParent(slot0, slot0.tf)
			setActive(slot0, true)

			slot0.barrier = slot0

			slot0:Update()
		end)
	end

	setActive(slot0.tf, slot1.flag == ChapterConst.CellFlagActive)
end

return slot0

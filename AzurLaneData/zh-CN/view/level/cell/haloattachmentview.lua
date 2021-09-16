slot0 = class("HaloAttachmentView", import(".StaticCellView"))

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.super.Ctor(slot0, slot1)

	slot0.line = {
		row = slot2,
		column = slot3
	}
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityUpperEffect
end

slot0.Update = function (slot0)
	slot2 = slot0.info.flag == ChapterConst.CellFlagTriggerActive and slot1.trait ~= ChapterConst.TraitLurk

	if IsNil(slot0.go) then
		slot5 = slot0.chapter

		slot0:PrepareBase("story_" .. slot3 .. "_" .. slot4 .. "_" .. slot1.attachmentId .. "_upper")

		if pg.map_event_template[slot1.attachmentId].icon and #slot8 > 0 then
			slot0:GetLoader():GetPrefab("ui/" .. slot9, slot8 .. "_1shangceng", function (slot0)
				tf(slot0):SetParent(slot0.tf, false)
				slot0:ResetCanvasOrder()
			end)
		end
	end

	setActive(slot0.tf, slot2)
end

return slot0

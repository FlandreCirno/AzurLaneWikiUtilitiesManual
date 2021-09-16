slot0 = class("MapEventStoryObstacleCellView", import("view.level.cell.StaticCellView"))

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot2 = slot0.info.row
	slot3 = slot0.info.column
	slot4 = slot0.info.data
	slot6 = pg.map_event_template[slot0.info.attachmentId].icon

	if IsNil(slot0.go) then
		slot0:PrepareBase(slot7)
		slot0:GetLoader():GetPrefab("ui/" .. slot6 .. "_2", slot6 .. "_2", function (slot0)
			slot0.transform:SetParent(slot0.tf, false)
			slot0:ResetCanvasOrder()
		end)
	end

	slot8 = pg.map_event_template[slot1.attachmentId]

	if not (slot1.flag == ChapterConst.CellFlagTriggerActive) and slot8 and slot8.animation and not slot0.disappearAnim and slot8.animation and #slot9 > 0 then
		slot0.GetLoader(slot0):GetPrefab("ui/" .. slot9, slot9, function (slot0)
			setParent(slot0.transform, slot0.tf, false)
			slot0:ResetCanvasOrder()

			if not IsNil(slot0:GetComponent(typeof(ParticleSystemEvent))) then
				slot1:SetEndEvent(function ()
					slot0:GetLoader():ClearRequest("DisapperAnim")

					slot0.GetLoader().ClearRequest.playingAnim = false

					slot0.GetLoader().ClearRequest:Update()
				end)
			end
		end, "DisapperAnim")

		slot0.disappearAnim = true
		slot0.playingAnim = true
	end

	setActive(slot0.tf, slot7 or slot0.playingAnim)
end

return slot0

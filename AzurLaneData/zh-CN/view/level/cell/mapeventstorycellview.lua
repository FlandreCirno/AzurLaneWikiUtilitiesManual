slot0 = class("MapEventStoryCellView", import("view.level.cell.StaticCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.attachTw = nil
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot4 = slot1.data
		slot6 = pg.map_event_template[slot1.attachmentId].icon

		slot0:PrepareBase(slot7)
		setAnchoredPosition(slot0.tf, Vector2(0, 30))

		slot0.attachTw = LeanTween.moveY(rtf(slot0.go), 40, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		slot0:GetLoader():GetPrefab("leveluiview/tpl_box", "tpl_box", function (slot0)
			slot0.name = slot0

			setParent(slot0, slot1.tf)
			setAnchoredPosition(slot0, Vector2.zero)
			setAnchoredPosition:GetLoader():GetPrefab("boxprefab/" .. slot0, slot0, function (slot0)
				setParent(slot0, tf(slot0):Find("icon"))
			end)
		end)
	end

	slot2 = slot1.flag == ChapterConst.CellFlagActive

	setActive(slot0.tf, slot2)
end

slot0.DestroyGO = function (slot0)
	if slot0.attachTw then
		LeanTween.cancel(slot0.attachTw.uniqueId)

		slot0.attachTw = nil
	end

	slot0.super.DestroyGO(slot0)
end

return slot0

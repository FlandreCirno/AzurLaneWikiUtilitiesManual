slot0 = class("WSMapQuad", import("...BaseEntity"))
slot0.Fields = {
	static = "boolean",
	rtWalkQuad = "userdata",
	twId = "number",
	transform = "userdata",
	cell = "table",
	twTimer = "userdata",
	theme = "table",
	rtQuad = "userdata"
}
slot0.Listeners = {
	onAddAttachment = "OnAddAttachment",
	onUpdate = "Update",
	onRemoveAttachment = "OnRemoveAttachment",
	onUpdateAttachment = "OnUpdateAttachment"
}

slot0.GetName = function (slot0, slot1)
	return "world_quad_" .. slot0 .. "_" .. slot1
end

slot0.Setup = function (slot0, slot1, slot2)
	slot0.cell = slot1

	slot0.cell:AddListener(WorldMapCell.EventUpdateInFov, slot0.onUpdate)
	slot0.cell:AddListener(WorldMapCell.EventAddAttachment, slot0.onAddAttachment)
	slot0.cell:AddListener(WorldMapCell.EventRemoveAttachment, slot0.onRemoveAttachment)
	slot0.cell:AddListener(WorldMapCell.EventUpdateFog, slot0.onUpdate)
	_.each(slot0.cell.attachments, function (slot0)
		slot0:OnAddAttachment(nil, slot0.cell, slot0)
	end)

	slot0.theme = slot2
end

slot0.Dispose = function (slot0)
	if slot0.twId then
		LeanTween.cancel(slot0.twId)
	end

	slot0.cell:RemoveListener(WorldMapCell.EventUpdateInFov, slot0.onUpdate)
	slot0.cell:RemoveListener(WorldMapCell.EventAddAttachment, slot0.onAddAttachment)
	slot0.cell:RemoveListener(WorldMapCell.EventRemoveAttachment, slot0.onRemoveAttachment)
	slot0.cell:RemoveListener(WorldMapCell.EventUpdateFog, slot0.onUpdate)
	_.each(slot0.cell.attachments, function (slot0)
		slot0:OnRemoveAttachment(nil, slot0.cell, slot0)
	end)
	slot0.Unload(slot0)
	slot0:Clear()
end

slot0.Load = function (slot0)
	PoolMgr.GetInstance().GetPrefab(slot1, "world/object/world_cell_quad", "world_cell_quad", false, function (slot0)
		slot0.transform = slot0.transform
	end)
	slot0.Init(slot0)
end

slot0.Unload = function (slot0)
	if slot0.transform then
		PoolMgr.GetInstance():ReturnPrefab("world/object/world_cell_quad", "world_cell_quad", slot0.transform.gameObject)
	end

	slot0.transform = nil
end

slot0.Init = function (slot0)
	slot0.rtQuad = slot0.transform.Find(slot2, "quad")
	slot0.transform.name = slot0.GetName(slot0.cell.row, slot0.cell.column)
	slot0.transform.anchoredPosition = slot0.theme:GetLinePosition(slot0.cell.row, slot0.cell.column)
	slot0.rtQuad.sizeDelta = slot0.theme.cellSize

	setActive(slot0.rtQuad, true)

	slot0.rtWalkQuad = slot0.transform:Find("walk_quad") or cloneTplTo(slot0.rtQuad, slot0.rtQuad.parent, "walk_quad")

	slot0.rtWalkQuad:SetSiblingIndex(slot0.rtQuad:GetSiblingIndex())
	setActive(slot0.rtWalkQuad, true)
	setImageAlpha(slot0.rtWalkQuad, 0)
	GetImageSpriteFromAtlasAsync(WorldConst.QuadSpriteAtlas, WorldConst.QuadSpriteWhite, slot0.rtWalkQuad)
	slot0:Update()
end

slot0.Update = function (slot0, slot1)
	slot2 = slot0.cell

	if slot1 == nil or slot1 == WorldMapCell.EventUpdateInFov or slot1 == WorldMapCell.EventUpdateFog then
		setActive(slot0.rtQuad, slot2:GetInFOV() and not slot2:InFog())
		slot0:OnUpdateAttachment()
	end
end

slot0.OnAddAttachment = function (slot0, slot1, slot2, slot3)
	slot3:AddListener(WorldMapAttachment.EventUpdateFlag, slot0.onUpdateAttachment)
	slot3:AddListener(WorldMapAttachment.EventUpdateData, slot0.onUpdateAttachment)
	slot3:AddListener(WorldMapAttachment.EventUpdateLurk, slot0.onUpdateAttachment)

	if slot1 then
		slot0:OnUpdateAttachment()
	end
end

slot0.OnRemoveAttachment = function (slot0, slot1, slot2, slot3)
	slot3:RemoveListener(WorldMapAttachment.EventUpdateFlag, slot0.onUpdateAttachment)
	slot3:RemoveListener(WorldMapAttachment.EventUpdateData, slot0.onUpdateAttachment)
	slot3:RemoveListener(WorldMapAttachment.EventUpdateLurk, slot0.onUpdateAttachment)

	if slot1 then
		slot0:OnUpdateAttachment()
	end
end

slot0.UpdateStatic = function (slot0, slot1, slot2)
	if slot0.static ~= slot1 then
		slot0.static = slot1

		setActive(slot0.rtQuad, false)

		if slot2 then
			slot0:UpdateScannerQuad()
		else
			slot0:OnUpdateAttachment()
		end
	end
end

slot0.OnUpdateAttachment = function (slot0)
	if slot0.twId then
		LeanTween.cancel(slot0.twId)

		slot0.twId = nil
	end

	if slot0.cell:GetInFOV() and not slot0.static then
		setActive(slot0.rtQuad, slot0.cell:GetDisplayQuad())

		if slot0.cell.GetDisplayQuad() then
			GetImageSpriteFromAtlasAsync(WorldConst.QuadSpriteAtlas, slot1[1], slot0.rtQuad)
			setLocalScale(slot0.rtQuad, Vector3.one)

			slot5 = LeanTween.alpha(slot0.rtQuad, (slot1[4] and slot1[4] / 100) or 0, slot1[2] or WorldConst.QuadBlinkDuration):setFrom((slot1[3] and slot1[3] / 100) or 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
			slot5.passed = slot0.twTimer.passed
			slot5.direction = slot0.twTimer.direction
			slot0.twId = slot5.uniqueId

			setImageAlpha(slot0.rtQuad, (slot5.direction > 0 and slot5.passed / (slot1[2] or WorldConst.QuadBlinkDuration) * (((slot1[3] and slot1[3] / 100) or 1) - ((slot1[4] and slot1[4] / 100) or 0)) + ((slot1[4] and slot1[4] / 100) or 0)) or 1 - (slot5.passed / (slot1[2] or WorldConst.QuadBlinkDuration) * (((slot1[3] and slot1[3] / 100) or 1) - ((slot1[4] and slot1[4] / 100) or 0)) + ((slot1[4] and slot1[4] / 100) or 0)))
		end
	end
end

slot0.UpdateScannerQuad = function (slot0)
	if slot0.twId then
		LeanTween.cancel(slot0.twId)

		slot0.twId = nil
	end

	if slot0.cell:GetInFOV() and slot0.cell:GetScannerAttachment() then
		setActive(slot0.rtQuad, true)
		setImageAlpha(slot0.rtQuad, 1)
		GetImageSpriteFromAtlasAsync(WorldConst.QuadSpriteAtlas, "cell_yellow", slot0.rtQuad)
	end
end

return slot0

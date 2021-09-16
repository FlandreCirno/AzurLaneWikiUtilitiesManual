slot0 = class("SpineCellView", import("view.level.cell.LevelCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0)

	slot0.go = slot1
	slot0.tf = slot0.go.transform
	slot0.tfShip = slot0.tf:Find("ship")
	slot0._attachmentList = {}
	slot0._extraEffect = nil

	slot0:OverrideCanvas()
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityNone
end

slot0.getPrefab = function (slot0)
	return slot0.prefab
end

slot0.setPrefab = function (slot0, slot1)
	slot0.prefab = slot1
end

slot0.getAction = function (slot0)
	return slot0.action
end

slot0.setAction = function (slot0, slot1)
	slot0.action = slot1

	if slot0.anim then
		slot0.anim:SetAction(slot1, 0)
	end
end

slot0.getModel = function (slot0)
	return slot0.model
end

slot0.setModel = function (slot0, slot1)
	slot1.transform.GetComponent(slot2, "SkeletonGraphic").raycastTarget = false

	slot1.transform.SetParent(slot2, slot0.tfShip, false)

	slot1.transform.localPosition = Vector3.zero
	slot1.transform.localScale = Vector3(0.4, 0.4, 1)
	slot0.model = slot1
	slot0.anim = slot1.transform.GetComponent(slot2, "SpineAnimUI")

	slot0:setAction(slot0:getAction())
end

slot0.setAttachment = function (slot0, slot1)
	slot0._attachmentInfo = slot1
end

slot0.SetExtraEffect = function (slot0, slot1)
	slot0._extraEffect = slot1
end

slot0.loadSpine = function (slot0, slot1)
	if slot0.lastPrefab == slot0:getPrefab() then
		if not IsNil(slot0.model) and slot1 then
			slot1()
		end

		return
	end

	slot0:unloadSpine()
	slot0:GetLoader():GetSpine(slot0:getPrefab(), function (slot0)
		slot0:setModel(slot0)

		if slot0.setModel then
			slot1()
		end

		slot0:LoadAttachments()
		slot0:OnLoadSpine()
	end)

	slot0.lastPrefab = slot0.getPrefab()
end

slot0.OnLoadSpine = function (slot0)
	return
end

slot0.OnLoadAttachment = function (slot0)
	return
end

slot0.LoadAttachments = function (slot0)
	if slot0._attachmentInfo then
		for slot4, slot5 in pairs(slot0._attachmentInfo) do
			if slot5.attachment_combat_ui[1] ~= "" then
				slot0:GetLoader():LoadPrefab("Effect/" .. slot6, slot6, function (slot0)
					slot0._attachmentList[] = slot0

					tf(slot0):SetParent(tf(slot0.model))

					tf(slot0).localPosition = BuildVector3(slot2.attachment_combat_ui[2])
				end)
			end
		end
	end

	if slot0._extraEffect and #slot0._extraEffect > 0 then
		slot0:GetLoader():LoadPrefab("effect/" .. slot1, slot0._extraEffect, function (slot0)
			slot0._attachmentList[] = slot0

			tf(slot0):SetParent(tf(slot0.model), false)
			slot0:OnLoadAttachment()
		end)
	end
end

slot0.unloadSpine = function (slot0)
	if slot0.prefab and slot0.model then
		slot0:SetSpineVisible(true)

		slot0.model:GetComponent("SkeletonGraphic").raycastTarget = true

		slot0:setAction(ChapterConst.ShipIdleAction)
		slot0:ClearAttachments()

		slot0.model = nil
		slot0._attachmentInfo = nil
		slot0._extraEffect = nil
	end

	if slot0.loader then
		slot0.loader:ClearRequests()
	end
end

slot0.ClearAttachments = function (slot0)
	for slot4, slot5 in pairs(slot0._attachmentList) do
		if not IsNil(slot5) then
			Destroy(slot5)
		end
	end

	table.clear(slot0._attachmentList)
end

slot0.SetSpineVisible = function (slot0, slot1)
	if not slot0.model then
		return
	end

	slot2:GetComponent("SkeletonGraphic").color = Color.New(1, 1, 1, (slot1 and 1) or 0)
end

slot0.Clear = function (slot0)
	slot0:unloadSpine()

	slot0.prefab = nil
	slot0.anim = nil
end

return slot0

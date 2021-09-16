slot0 = class("OniCellView", import(".SpineCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.tfShadow = slot0.tf:Find("shadow")
	slot0.tfIcon = slot0.tf:Find("ship/icon")
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityLittle
end

slot0.getModel = function (slot0)
	return slot0.tfIcon.gameObject
end

slot0.setModel = function (slot0, slot1)
	return
end

slot0.SetActive = function (slot0, slot1)
	slot0.showFlag = slot1

	slot0:SetActiveModel(slot1)
	setActive(slot0.tfShadow, slot1)
end

slot0.SetActiveModel = function (slot0, slot1)
	slot0:SetSpineVisible(slot1 and slot0.showFlag)
end

slot0.setAttachment = function (slot0, slot1)
	slot0._attachmentInfo = slot1
end

slot0.loadSpine = function (slot0, slot1)
	if slot0.lastPrefab == slot0:getPrefab() then
		if slot1 then
			slot1()
		end

		return
	end

	slot0:ClearAttachments()
	slot0:LoadAttachments()

	slot0.lastPrefab = slot0:getPrefab()

	if slot1 then
		slot1()
	end
end

slot0.unloadSpine = function (slot0)
	slot0:ClearAttachments()
end

return slot0

slot0 = class("ChampionCellView", import(".SpineCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.tfShadow = slot0.tf:Find("shadow")
	slot0.tfFighting = slot0.tf:Find("fighting")
	slot0.tfEffectFound = slot0.tf:Find("effect_found")
	slot0.tfDamageCount = slot0.tf:Find("damage_count")
	slot0.tfBufficons = slot0.tf:Find("random_buff_container")
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityEnemy
end

slot0.SetActive = function (slot0, slot1)
	slot0.showFlag = slot1

	slot0:SetActiveModel(slot1)
	setActive(slot0.tfShadow, slot1)

	for slot5, slot6 in pairs(slot0._attachmentList) do
		if not IsNil(slot6) then
			setActive(slot6, slot1)
		end
	end
end

slot0.OnLoadAttachment = function (slot0)
	slot0.super.OnLoadAttachment(slot0)
	slot0:SetActive(slot0.showFlag)
end

slot0.SetActiveModel = function (slot0, slot1)
	slot0:SetSpineVisible(slot1 and slot0.showFlag)
end

slot0.PlayShuiHua = function (slot0)
	return
end

return slot0

slot0 = class("SubCellView", import(".SpineCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.tfShadow = slot0.tf:Find("shadow")
	slot0.tfAmmo = slot0.tf:Find("ammo")
	slot0.tfAmmoText = slot0.tfAmmo:Find("text")
	slot0.showFlag = true
	slot0.shuihuaLoader = AutoLoader.New()

	slot0:LoadEffectShuihua()
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityFleet
end

slot0.LoadEffectShuihua = function (slot0)
	slot0.shuihuaLoader:GetPrefab("Effect/" .. slot1, "qianting_01", function (slot0)
		slot0.effect_shuihua = slot0

		tf(slot0):SetParent(slot0.tf)

		tf(slot0).localPosition = Vector3.zero

		setActive(slot0, false)
	end, "Shuihua")
end

slot0.PlayShuiHua = function (slot0)
	if not slot0.effect_shuihua then
		return
	end

	setActive(slot0.effect_shuihua, false)
	setActive(slot0.effect_shuihua, true)
end

slot0.SetActive = function (slot0, slot1)
	slot0.showFlag = slot1

	slot0:SetActiveModel(slot1)
end

slot0.SetActiveModel = function (slot0, slot1)
	setActive(slot0.tfShadow, slot1 and slot0.showFlag)
	slot0:SetSpineVisible(slot1 and slot0.showFlag)
end

slot0.Clear = function (slot0)
	slot0.showFlag = nil

	slot0.shuihuaLoader:Clear()
	slot0.super.Clear(slot0)
end

return slot0

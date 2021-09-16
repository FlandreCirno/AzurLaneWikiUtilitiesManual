slot0 = class("FleetCellView", import(".SpineCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.tfShadow = slot0.tf:Find("shadow")
	slot0.tfArrow = slot0.tf:Find("arrow")
	slot0.tfAmmo = slot0.tf:Find("ammo")
	slot0.tfAmmoText = slot0.tfAmmo:Find("text")
	slot0.tfOp = slot0.tf:Find("op")
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityFleet
end

slot0.showPoisonDamage = function (slot0, slot1)
	slot3 = slot0.tfShip.localPosition

	slot0:GetLoader():GetPrefab("ui/" .. slot2, "banai_dian01", function (slot0)
		setParent(slot0.transform, slot0.tf, false)

		slot1 = LeanTween.moveY(slot0.tfShip, slot1.y - 10, 0.1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		if not IsNil(slot0:GetComponent(typeof(ParticleSystemEvent))) then
			slot2:AddEndEvent(function (slot0)
				slot0.tfShip.localPosition = slot0.tfShip

				slot0.loader:ClearRequest("PoisonDamage")
				LeanTween.cancel(slot0.tfShip.gameObject)

				if slot0.tfShip.gameObject then
					slot2()
				end
			end)
		end
	end, "PoisonDamage")
end

slot0.SetActiveNoPassIcon = function (slot0, slot1)
	slot2 = "NoPassIcon"

	if not slot1 then
		slot0.loader:ClearRequest(slot2)
	else
		slot4 = "event_task_small"

		if slot0:GetLoader():GetRequestPackage(slot2) and slot3.name == slot4 then
			return
		end

		slot0:GetLoader():GetPrefabBYStopLoading("boxprefab/" .. slot4, slot4, function (slot0)
			setParent(slot0.transform, slot0.tf, false)
			setLocalPosition(slot0, Vector3(0, 150, 0))

			slot2 = LeanTween.moveY(rtf(slot0), 150 - 10, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		end, slot2)
	end
end

return slot0

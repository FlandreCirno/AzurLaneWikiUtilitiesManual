ys = ys or {}
slot1 = class("AutoPilotHiveRelativeStay", ys.Battle.IPilot)
ys.Battle.AutoPilotHiveRelativeStay = slot1
slot1.__name = "AutoPilotHiveRelativeStay"

slot1.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)
end

slot1.SetParameter = function (slot0, slot1, slot2)
	slot0.super.SetParameter(slot0, slot1, slot2)

	slot0._distX = slot1.x
	slot0._distZ = slot1.z
end

slot1.GetDirection = function (slot0, slot1)
	if not slot0._pilot:GetHiveUnit():IsAlive() then
		slot0._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	slot5 = Vector3(slot2:GetPosition().x + slot0._distX, slot1.y, slot2.GetPosition().z + slot0._distZ) - slot1

	if slot0:IsExpired() then
		slot0:Finish()
	end

	if slot5.magnitude < 0.4 then
		return Vector3.zero
	else
		slot5.y = 0

		return slot5:SetNormalize()
	end
end

return

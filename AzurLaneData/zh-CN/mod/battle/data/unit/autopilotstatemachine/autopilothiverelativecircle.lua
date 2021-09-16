ys = ys or {}
slot1 = Vector3.up
slot2 = class("AutoPilotHiveRelativeCircle", ys.Battle.IPilot)
ys.Battle.AutoPilotHiveRelativeCircle = slot2
slot2.__name = "AutoPilotHiveRelativeCircle"

slot2.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)
end

slot2.SetParameter = function (slot0, slot1, slot2)
	slot0.super.SetParameter(slot0, slot1, slot2)

	slot0._radius = slot1.radius

	if slot1.antiClockWise == true then
		slot0.GetDirection = slot0._antiClockWise
	else
		slot0.GetDirection = slot0._clockWise
	end
end

slot2._clockWise = function (slot0, slot1)
	if slot0:IsExpired() then
		slot0:Finish()

		return Vector3.zero
	end

	if not slot0._pilot:GetHiveUnit():IsAlive() then
		slot0._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	if slot0._radius < slot1 - slot2:GetPosition().magnitude then
		return slot3 - slot1.normalized
	else
		return Vector3(-slot3 - slot1.normalized.z, 0, slot3 - slot1.normalized.x)
	end
end

slot2._antiClockWise = function (slot0, slot1)
	if slot0._duration > 0 and slot0._duration < pg.TimeMgr.GetInstance():GetCombatTime() - slot0._startTime then
		slot0:Finish()

		return Vector3.zero
	end

	if not slot0._pilot:GetHiveUnit():IsAlive() then
		slot0._pilot:OnHiveUnitDead()

		return Vector3.zero
	end

	if slot0._radius < slot1 - slot2:GetPosition().magnitude then
		return slot3 - slot1.normalized
	else
		return Vector3(slot3 - slot1.normalized.z, 0, -slot3 - slot1.normalized.x)
	end
end

return

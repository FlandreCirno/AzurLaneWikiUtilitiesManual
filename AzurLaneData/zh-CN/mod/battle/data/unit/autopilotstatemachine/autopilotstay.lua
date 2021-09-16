ys = ys or {}
slot1 = class("AutoPilotStay", ys.Battle.IPilot)
ys.Battle.AutoPilotStay = slot1
slot1.__name = "AutoPilotStay"

slot1.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)
end

slot1.GetDirection = function (slot0)
	if slot0:IsExpired() then
		slot0:Finish()
	end

	return Vector3.zero
end

return

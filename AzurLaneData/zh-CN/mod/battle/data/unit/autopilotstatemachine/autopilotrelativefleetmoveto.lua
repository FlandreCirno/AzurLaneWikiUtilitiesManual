ys = ys or {}
slot1 = class("AutoPilotRelativeFleetMoveTo", ys.Battle.IPilot)
ys.Battle.AutoPilotRelativeFleetMoveTo = slot1
slot1.__name = "AutoPilotRelativeFleetMoveTo"

slot1.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)
end

slot1.SetParameter = function (slot0, slot1, slot2)
	slot0.super.SetParameter(slot0, slot1, slot2)

	slot0._offsetX = slot1.offsetX
	slot0._offsetZ = slot1.offsetZ
	slot0._fixX = slot1.X
	slot0._fixZ = slot1.Z
	slot0._targetFleetVO = slot1.Battle.BattleDataProxy.GetInstance():GetFleetByIFF(slot1.Battle.BattleConfig.FRIENDLY_CODE)
end

slot1.GetDirection = function (slot0, slot1)
	if slot0:IsExpired() then
		slot0:Finish()

		return Vector3.zero
	end

	slot2, slot3 = nil
	Vector3.New((slot0._offsetX and slot0._targetFleetVO:GetMotion():GetPos().x + slot0._offsetX) or ((not slot0._fixX or slot0._fixX) and slot1.x), 0, (slot0._offsetZ and slot0._targetFleetVO.GetMotion().GetPos().z + slot0._offsetZ) or ((not slot0._fixZ or slot0._fixZ) and slot1.z)) - slot1.y = 0

	if Vector3.New((slot0._offsetX and slot0._targetFleetVO.GetMotion().GetPos().x + slot0._offsetX) or ((not slot0._fixX or slot0._fixX) and slot1.x), 0, (slot0._offsetZ and slot0._targetFleetVO.GetMotion().GetPos().z + slot0._offsetZ) or ((not slot0._fixZ or slot0._fixZ) and slot1.z)) - slot1.magnitude < slot0._valve then
		slot6 = Vector3.zero
	end

	return slot6.normalized
end

return

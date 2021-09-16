ys = ys or {}
slot1 = Vector3.up
slot2 = ys.Battle.BattleTargetChoise
slot3 = class("BattleTrackingAAMissileUnit", ys.Battle.BattleBulletUnit)
slot3.__name = "BattleTrackingAAMissileUnit"
ys.Battle.BattleTrackingAAMissileUnit = slot3

slot3.doAccelerate = function (slot0, slot1)
	slot2, slot3 = slot0:GetAcceleration(slot1)

	if slot2 == 0 and slot3 == 0 then
		return
	end

	if slot2 < 0 and slot0._speedLength + slot2 < 0 then
		slot0:reverseAcceleration()
	end

	slot0._speed:Set(slot0._speed.x + slot0._speedNormal.x * slot2 + slot0._speedCross.x * slot3, slot0._speed.y + slot0._speedNormal.y * slot2 + slot0._speedCross.y * slot3, slot0._speed.z + slot0._speedNormal.z * slot2 + slot0._speedCross.z * slot3)

	slot0._speedLength = slot0._speed:Magnitude()

	if slot0._speedLength ~= 0 then
		slot0._speedNormal:Copy(slot0._speed)
		slot0._speedNormal:Div(slot0._speedLength)
	end

	slot0._speedCross:Copy(slot0._speedNormal)
	slot0._speedCross:Cross2(slot0)
end

slot3.doTrack = function (slot0)
	if slot0:getTrackingTarget() == nil and slot0:TargetWeightiest(nil, slot0:GetFilteredList())[1] ~= nil then
		slot0:setTrackingTarget(slot2)
	end

	if slot0:getTrackingTarget() == nil or slot1 == -1 then
		return
	elseif not slot1:IsAlive() then
		slot0:CleanAimMark()
		slot0:setTrackingTarget(-1)

		return
	end

	if not slot1:GetBeenAimedPosition() then
		return
	end

	slot2 - slot0:GetPosition().SetNormalize(slot3)

	slot4 = Vector3.Normalize(slot0._speed)
	slot7 = slot0:GetSpeedRatio()

	slot0._speed:Set(slot0._speed.x * Vector3.Dot(slot4, slot3) + slot0._speed.z * (slot4.z * slot2 - slot0.GetPosition().x - slot4.x * slot2 - slot0.GetPosition().z), 0, slot0._speed.z * Vector3.Dot(slot4, slot3) - slot0._speed.x * (slot4.z * slot2 - slot0.GetPosition().x - slot4.x * slot2 - slot0.GetPosition().z))
end

slot3.doNothing = function (slot0)
	if slot0._gravity ~= 0 then
		slot0._verticalSpeed = slot0._verticalSpeed + slot0._gravity * slot0:GetSpeedRatio()
	end
end

slot3.GetFilteredList = function (slot0)
	return slot0:FilterAngle(slot0:FilterRange(slot0:TargetAllHarm()))
end

slot3.FilterRange = function (slot0, slot1)
	if not slot0._trackDist then
		return slot1
	end

	for slot5 = #slot1, 1, -1 do
		if slot0:IsOutOfRange(slot1[slot5]) then
			table.remove(slot1, slot5)
		end
	end

	return slot1
end

slot3.IsOutOfRange = function (slot0, slot1)
	if not slot0._trackDist then
		return true
	end

	return slot0._trackDist < slot0:GetDistance(slot1)
end

slot3.FilterAngle = function (slot0, slot1)
	if not slot0._trackAngle or slot0._trackAngle >= 360 then
		return slot1
	end

	for slot5 = #slot1, 1, -1 do
		if slot0:IsOutOfAngle(slot1[slot5]) then
			table.remove(slot1, slot5)
		end
	end

	return slot1
end

slot3.IsOutOfAngle = function (slot0, slot1)
	if not slot0._trackAngle or slot0._trackAngle >= 360 then
		return false
	end

	return slot0._trackRadian < math.acos(slot6) or slot7 < -slot0._trackRadian
end

slot3.SetTrackingFXData = function (slot0, slot1)
	slot0._trackingFXData = slot1
end

slot3.InitSpeed = function (slot0, slot1)
	if slot0._yAngle == nil then
		if slot0._targetPos ~= nil then
			slot0._yAngle = slot1 + slot0._barrageAngle
		else
			slot0._yAngle = slot0._baseAngle + slot0._barrageAngle
		end
	end

	slot0:calcSpeed()

	slot2 = {}

	function slot3(slot0, slot1)
		for slot5, slot6 in ipairs(slot0) do
			slot6(slot0, slot1)
		end

		if slot1:getTrackingTarget() and slot2 ~= -1 and not slot1._trackingFXData.aimingFX and slot1._trackingFXData.fxName and slot1._trackingFXData.fxName ~= "" then
			slot1._trackingFXData.aimingFX = slot2.Battle.BattleState.GetInstance():GetSceneMediator().GetCharacter(slot3, slot2:GetUniqueID()):AddFX(slot1._trackingFXData.fxName)
		end
	end

	if slot0.IsTracker(slot0) then
		slot0._trackAngle = slot0._accTable.tracker.angular
		slot0._trackDist = slot0._accTable.tracker.range

		if slot0._accTable.tracker.angular then
			slot0._trackRadian = math.deg2Rad * slot0._trackAngle * 0.5
		end

		table.insert(slot2, slot0.doTrack)
	end

	if slot0:HasAcceleration() then
		slot0._speedLength = slot0._speed:Magnitude()
		slot0._speedNormal = slot0._speed / slot0._speedLength
		slot0._speedCross = Vector3.Cross(slot0._speedNormal, slot1)

		table.insert(slot2, function (slot0, ...)
			slot0._speedLength = slot0._speed:Magnitude()
			slot0._speedNormal = slot0._speed / slot0._speedLength
			slot0._speedCross = Vector3.Cross(slot0._speedNormal, slot0)

			slot0:doAccelerate(...)
		end)
	end

	if #slot2 == 0 then
		table.insert(slot2, slot0.doNothing)
	end

	slot0.updateSpeed = slot3
end

slot3.CleanAimMark = function (slot0)
	if slot0:getTrackingTarget() and slot1 ~= -1 and slot0._trackingFXData.aimingFX then
		if slot0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(slot1:GetUniqueID()) then
			slot3:RemoveFX(slot0._trackingFXData.aimingFX)
		end

		slot0._trackingFXData.aimingFX = nil
	end
end

slot3.OutRange = function (slot0, ...)
	slot0:CleanAimMark()
	slot0.super.OutRange(slot0, ...)
end

return

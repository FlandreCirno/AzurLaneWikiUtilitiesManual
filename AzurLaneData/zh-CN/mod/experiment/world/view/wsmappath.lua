slot0 = class("WSMapPath", import("...BaseEntity"))
slot0.Fields = {
	wsObject = "table",
	startPos = "table",
	upOffset = "number",
	theme = "table",
	moveAction = "string",
	path = "table",
	twId = "number",
	paused = "boolean",
	dirType = "number",
	step = "number"
}
slot0.EventStartTrip = "WSMapPath.EventStartTrip"
slot0.EventArrivedStep = "WSMapPath.EventArrivedStep"
slot0.EventArrived = "WSMapPath.EventArrived"

slot0.Setup = function (slot0, slot1)
	slot0.theme = slot1
end

slot0.Dispose = function (slot0)
	if slot0.twId then
		LeanTween.cancel(slot0.twId)
	end

	slot0:Clear()
end

slot0.UpdateObject = function (slot0, slot1)
	slot0.wsObject = slot1
end

slot0.UpdateAction = function (slot0, slot1)
	slot0.moveAction = slot1
end

slot0.UpdateDirType = function (slot0, slot1)
	slot0.dirType = slot1
end

slot0.StartMove = function (slot0, slot1, slot2, slot3)
	slot0.startPos = slot1
	slot0.path = slot2
	slot0.upOffset = slot3 or 0
	slot0.step = 0
	slot0.wsObject.isMoving = true

	slot0.wsObject:UpdateModelAction(slot0.moveAction)
	slot0:DispatchEvent(slot0.EventStartTrip)
	slot0:MoveStep()
end

slot0.MoveStep = function (slot0)
	slot3 = (slot0.step > 0 and slot0.path[slot0.step]) or slot0.startPos
	slot4 = slot0.path[slot0.step + 1]
	slot5 = slot0.path[#slot0.path]
	slot6 = slot0.wsObject:GetModelAngles()

	if slot0.dirType == WorldConst.DirType4 then
		if slot4.column < slot3.column then
			slot6.z = 180
		elseif slot3.column < slot4.column then
			slot6.z = 0
		elseif slot4.row < slot3.row then
			slot6.z = 90
		elseif slot3.row < slot4.row then
			slot6.z = 270
		end

		slot1:UpdateModelAngles(slot6)
	elseif slot0.dirType == WorldConst.DirType2 then
		if slot4.column < slot3.column or (slot4.column == slot3.column and slot5.column < slot3.column) then
			slot6.y = 180
		elseif slot4.column ~= slot3.column or slot5.column ~= slot3.column then
			slot6.y = 0
		end

		slot1:UpdateModelAngles(slot6)
	end

	slot7 = slot0.theme:GetLinePosition(slot3.row, slot3.column)
	slot8 = slot0.theme:GetLinePosition(slot4.row, slot4.column)
	slot0.twId = LeanTween.value(slot1.transform.gameObject, 0, 1, slot4.duration):setOnUpdate(System.Action_float(function (slot0)
		slot2, slot4 = slot0:CalcUpOffset(slot2.step, slot0)
		slot3.transform.localPosition = Vector3.Lerp(slot0, Vector3.Lerp, slot0) + slot2

		if slot3.rtShadow then
			slot3.rtShadow.localPosition = Vector3(0, -slot3, 0)
		end
	end)).setOnComplete(slot9, System.Action(function ()
		slot0.step = slot0.step + 1

		if slot0.step >= #(slot0.step + 1) then
			slot0.twId = nil

			slot2:UpdateModelAction(WorldConst.ActionIdle)

			slot2.isMoving = false

			slot2:DispatchEvent(slot3.EventArrived)
		else
			slot0:DispatchEvent(slot3.EventArrivedStep, slot4)
			onDelayTick(function ()
				slot0:MoveStep()
			end, 0.015)
		end
	end)).uniqueId

	slot0.FlushPaused(slot0)
end

slot0.UpdatePaused = function (slot0, slot1)
	if slot0.paused ~= slot1 then
		slot0.paused = slot1

		slot0:FlushPaused()
	end
end

slot0.FlushPaused = function (slot0)
	if slot0.paused then
		LeanTween.pause(slot0.twId)
		slot0.wsObject:UpdateModelAction(WorldConst.ActionIdle)
	else
		LeanTween.resume(slot0.twId)
		slot0.wsObject:UpdateModelAction(slot0.moveAction)
	end
end

slot0.CalcUpOffset = function (slot0, slot1, slot2)
	return Vector3(0, slot0.theme.cosAngle * math.clamp(slot3, 0, 1) * slot0.upOffset, -slot0.theme.sinAngle * math.clamp(slot3, 0, 1) * slot0.upOffset), math.clamp(slot3, 0, 1) * slot0.upOffset
end

slot0.IsMoving = function (slot0)
	return slot0.twId ~= nil
end

return slot0

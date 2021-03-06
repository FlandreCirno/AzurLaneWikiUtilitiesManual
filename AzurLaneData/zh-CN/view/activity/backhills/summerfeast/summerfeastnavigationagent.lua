slot0 = class("SummerFeastNavigationAgent", require("view.main.NavalAcademyStudent"))

slot0.Ctor = function (slot0, slot1)
	slot0.onTransEdge = nil

	slot0.super.Ctor(slot0, slot1)
end

slot0.init = function (slot0)
	return
end

slot0.normalSpeed = 150
slot0.normalScale = 0.5

slot0.SetOnTransEdge = function (slot0, slot1)
	slot0.onTransEdge = slot1
end

slot0.setCurrentIndex = function (slot0, slot1)
	if not slot1 then
		return
	end

	slot0.currentPoint = slot0.pathFinder:getPoint(slot1)
end

slot0.updateStudent = function (slot0, slot1)
	if slot1 == nil or slot1 == "" then
		setActive(slot0._go, false)

		return
	end

	setActive(slot0._go, true)

	if slot0.prefabName ~= slot1 then
		if not IsNil(slot0.model) then
			PoolMgr.GetInstance():ReturnSpineChar(slot0.prefab, slot0.model)
		end

		slot0.prefab = slot1
		slot0.currentPoint = slot0.currentPoint or slot0.pathFinder:getRandomPoint()
		slot0.targetPoint = slot0.currentPoint
		slot2 = slot0.currentPoint.id
		slot0._tf.anchoredPosition = slot0.currentPoint

		if slot0.onTransEdge then
			slot0:onTransEdge(slot2, slot2)
		end

		PoolMgr.GetInstance():GetSpineChar(slot0.prefab, true, function (slot0)
			if slot0 ~= slot1.prefab then
				PoolMgr.GetInstance():ReturnSpineChar(slot0, slot0)

				return
			end

			slot1.model = slot0
			slot1.model.transform.localScale = Vector3.one
			slot1.model.transform.model.transform.localPosition = Vector3.zero

			slot1.model.transform.model.transform.model.transform:SetParent(slot1._tf, false)

			slot1.model.transform.model.transform.model.transform.SetParent.anim = slot1.model:GetComponent(typeof(SpineAnimUI))

			slot1.model.transform.model.transform.model.transform.SetParent:updateState(slot2.ShipState.Walk)
		end)
	end

	slot0.prefabName = slot1
end

slot0.updateLogic = function (slot0)
	slot0:clearLogic()

	if slot0.state == slot0.ShipState.Walk then
		slot0._tf.localScale = (slot0.currentPoint.scale or slot0.normalScale) * Vector2.one

		LeanTween.value(slot0._go, 0, 1, Vector2.Distance(slot1, slot2) / 15):setOnUpdate(System.Action_float(function (slot0)
			slot0._tf.anchoredPosition = Vector2.Lerp(slot0._tf, Vector2.Lerp, slot0)
			slot3 = slot1.scale or slot3.normalScale.scale or slot3.normalScale

			if slot1.id == (slot1.x < Vector2.one.x and 1) or -1.id then
				slot2 = (math.random(0, 1) == 1 and 1) or -1
			end

			if slot1.fixedDirection then
				slot2 = math.sign(slot1.fixedDirection)
			end

			slot1.x = math.abs(slot1.x) * slot2
			slot0._tf.localScale = slot1
		end)).setOnComplete(slot5, System.Action(function ()
			slot0.currentPoint = slot0.targetPoint
			slot2 = slot0.currentPoint.nexts[math.random(1, #slot0.currentPoint.nexts)]

			if slot0.onTransEdge and slot2 then
				slot0.targetPoint = slot0.pathFinder:getPoint(slot2)

				slot0:onTransEdge(slot0, slot2)
			end

			slot0:updateState(slot1.ShipState.Idle)
		end))

		return
	end

	if slot0.state == slot0.ShipState.Idle then
		if not slot0.currentPoint.isBan then
			slot1 = math.random(10, 20)
			slot0.idleTimer = Timer.New(function ()
				slot0:updateState(slot1.ShipState.Walk)
			end, slot1, 1)

			slot0.idleTimer:Start()
		else
			slot0.idleTimer = Timer.New(function ()
				slot0:updateState(slot1.ShipState.Walk)
			end, 0.001, 1)

			slot0.idleTimer.Start(slot1)
		end
	elseif slot0.state == slot0.ShipState.Touch then
		slot0:onClickShip()
	end
end

return slot0

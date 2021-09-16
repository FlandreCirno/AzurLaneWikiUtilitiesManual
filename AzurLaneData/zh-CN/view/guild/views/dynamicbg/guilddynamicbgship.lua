slot0 = class("GuildDynamicBgShip")

slot0.Ctor = function (slot0, slot1)
	slot0.id = slot1.id
	slot0._go = slot1.go
	slot0._tf = tf(slot0._go)
	slot0.parent = slot0._tf.parent
	slot0.spineAnimUI = slot0._go:GetComponent("SpineAnimUI")
	slot0.path = slot1.path
	slot0.speed = 1
	slot0.stepCnt = 0
	slot0.scale = slot0._tf.localScale.x
	slot0.furnitures = slot1.furnitures
	slot0.interAction = nil
	slot0.interActionRatio = 10000 / GuildConst.MAX_DISPLAY_MEMBER_SHIP
	slot0.name = slot1.name
	slot0.isCommander = slot1.isCommander

	slot0:Init(slot1)
end

slot0.Init = function (slot0, slot1)
	slot0:SetPosition(slot1.grid, true)

	slot0.nameTF = slot0._tf:Find("name")
	slot0.nameTF.localScale = Vector3(1 / slot0.scale, 1 / slot0.scale, 1)
	slot0.nameTF.localPosition = Vector3(0, 300, 0)

	setText(slot0.nameTF, slot0.name)

	if slot0.isCommander then
		slot0.tagTF = slot0._tf:Find("tag")
		slot0.tagTF.localScale = Vector3(1 / slot0.scale, 1 / slot0.scale, 1)
		slot0.tagTF.localPosition = Vector3(0, 380, 0)
	end

	if not slot1.stand then
		slot0:AddRandomMove()
	end
end

slot0.SetOnMoveCallBack = function (slot0, slot1)
	slot0.callback = slot1
end

slot0.SetPosition = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	if slot0.grid then
		slot0.grid:UnlockAll()
	end

	slot0.grid = slot1

	if slot2 then
		slot0._tf.localPosition = slot0.grid:GetCenterPosition()

		slot0:SetAction("stand2")
	end

	if slot0.callback then
		slot0.callback()
	end
end

slot0.AddRandomMove = function (slot0)
	slot0.stepCnt = math.random(1, 10)
	slot1 = math.random(1, 8)
	slot0.timer = Timer.New(function ()
		slot0.timer:Stop()

		slot0.timer.Stop.timer = nil

		slot0.timer.Stop:StartMove()
	end, slot1, 1)

	slot0.timer:Start()
end

slot0.IsCanWalkPonit = function (slot0, slot1)
	if not slot0.path[slot1.x] then
		return false
	end

	if slot0.path[slot1.x][slot1.y] then
		return slot2:CanWalk()
	else
		return false
	end
end

slot0.StartMove = function (slot0)
	if not _.select(slot0.grid:GetAroundGrids(), function (slot0)
		return slot0:IsCanWalkPonit(slot0)
	end) or #slot2 == 0 then
		slot0.AddRandomMove(slot0)
	else
		slot0.stepCnt = slot0.stepCnt - 1

		slot0:MoveToGrid(slot0.path[slot2[math.random(1, #slot2)].x][slot2[math.random(1, #slot2)].y])
	end
end

slot0.MoveToGrid = function (slot0, slot1)
	function slot2()
		slot0:SetAction("stand2")

		slot0.idleTimer = Timer.New(function ()
			slot0.idleTimer:Stop()

			slot0.idleTimer.Stop.idleTimer = nil

			slot0.idleTimer.Stop:AddRandomMove()
		end, slot0, 1)

		slot0.idleTimer:Start()
	end

	slot0.MoveNext(slot0, slot1, false, function ()
		if slot0.stepCnt ~= 0 then
			slot0:StartMove()

			return
		end

		slot0, slot1 = slot0:CanInterAction(slot0.interActionRatio)

		if slot0 then
			slot0:MoveToFurniture(slot1)
		else
			slot1()
		end
	end)
end

slot0.MoveNext = function (slot0, slot1, slot2, slot3)
	if not slot2 and not slot1:CanWalk() then
		return
	end

	if slot0.exited then
		return
	end

	slot1:Lock()
	slot0:SetAction("walk")
	slot0:UpdateShipDir((slot1.position.x < slot0.grid.position.x and -1) or 1)
	LeanTween.moveLocal(slot0._go, Vector3(slot1:GetCenterPosition().x, slot1.GetCenterPosition().y, 0), 1 / slot0.speed):setOnComplete(System.Action(function ()
		if slot0.exited then
			return
		end

		slot0:SetPosition(slot0)
		slot0()
	end))
end

slot0.MoveLeft = function (slot0)
	if slot0.path[Vector2(slot0.grid.position.x - 1, slot0.grid.position.y).x] and slot0.path[slot2.x][slot2.y] then
		slot0:MoveNext(slot3, false, function ()
			slot0:SetAction("stand2")
		end)
	end
end

slot0.MoveRight = function (slot0)
	if slot0.path[Vector2(slot0.grid.position.x + 1, slot0.grid.position.y).x] and slot0.path[slot2.x][slot2.y] then
		slot0:MoveNext(slot3, false, function ()
			slot0:SetAction("stand2")
		end)
	end
end

slot0.MoveDown = function (slot0)
	if slot0.path[Vector2(slot0.grid.position.x, slot0.grid.position.y - 1).x] and slot0.path[slot2.x][slot2.y] then
		slot0:MoveNext(slot3, false, function ()
			slot0:SetAction("stand2")
		end)
	end
end

slot0.MoveUp = function (slot0)
	if slot0.path[Vector2(slot0.grid.position.x, slot0.grid.position.y + 1).x] and slot0.path[slot2.x][slot2.y] then
		slot0:MoveNext(slot3, false, function ()
			slot0:SetAction("stand2")
		end)
	end
end

slot0.SetAction = function (slot0, slot1)
	if slot0.actionName == slot1 then
		return
	end

	slot0.actionName = slot1

	slot0.spineAnimUI:SetAction(slot1, 0)
end

slot0.SetAsLastSibling = function (slot0)
	slot0._tf:SetAsLastSibling()
end

slot0.MoveToFurniture = function (slot0, slot1)
	slot1[1].Lock(slot2)

	for slot7, slot8 in ipairs(slot3) do
		slot0.path[slot8.x][slot8.y]:Lock()
	end

	slot0:MoveByPath(slot3, function ()
		slot0:InterActionFurniture(slot0)
	end)
end

slot0.UpdateShipDir = function (slot0, slot1)
	slot0._tf.localScale = Vector3(slot1 * slot0.scale, slot0.scale, slot0.scale)
	slot0.nameTF.localScale = Vector3(1 / slot0.scale * slot1, slot0.nameTF.localScale.y, 1)

	if slot0.isCommander then
		slot0.tagTF.localScale = Vector3(slot2, slot0.tagTF.localScale.y, 1)
	end
end

slot0.InterActionFurniture = function (slot0, slot1)
	setParent(slot0._tf, slot1._tf)
	slot0:UpdateShipDir(slot2)

	slot0._tf.anchoredPosition = slot1:GetInterActionPos()
	slot5 = nil

	if GuildDynamicFurniture.INTERACTION_MODE_SIT == slot1:GetInterActionMode() then
		slot5 = "sit"
	end

	slot0:SetAction(slot5)
	slot0:CancelInterAction(slot1)
end

slot0.CancelInterAction = function (slot0, slot1)
	slot2 = math.random(15, 30)
	slot0.interActionTimer = Timer.New(function ()
		slot0.interActionTimer:Stop()

		slot0.interActionTimer.Stop.interActionTimer = nil

		nil:Unlock()
		setParent(slot0._tf, slot0.parent)
		setParent:SetPosition(slot0.grid, true)
		setParent.SetPosition:AddRandomMove()
	end, slot2, 1)

	slot0.interActionTimer:Start()
end

slot0.MoveByPath = function (slot0, slot1, slot2)
	slot3 = {}

	for slot7, slot8 in ipairs(slot1) do
		table.insert(slot3, function (slot0)
			if slot0.exited then
				return
			end

			slot0:MoveNext(slot0.path[slot1.x][slot1.y], true, slot0)
		end)
	end

	seriesAsync(slot3, slot2)
end

slot0.SearchPoint = function (slot0, slot1, slot2)
	function slot3(slot0, slot1, slot2, slot3)
		if _.any(slot0, function (slot0)
			return slot0 == slot0.point
		end) or _.any(slot1, function (slot0)
			return slot0 == slot0
		end) then
			return false
		end

		if slot0.path[slot2.x] then
			return slot0.path[slot2.x][slot2.y] and slot4.CanWalk(slot4)
		end

		return false
	end

	function slot4(slot0)
		table.insert(slot1, Vector2(slot0.x + 1, slot0.y))
		table.insert(slot1, Vector2(slot0.x - 1, slot0.y))
		table.insert(slot1, Vector2(slot0.x, slot0.y + 1))
		table.insert({}, Vector2(slot0.x, slot0.y - 1))

		return 
	end

	function slot5(slot0, slot1, slot2)
		return math.abs(slot2.x - slot0.x) + math.abs(slot2.y - slot0.y) < math.abs(slot2.x - slot1.x) + math.abs(slot2.y - slot1.y)
	end

	slot6 = {}
	slot7 = {}
	slot8 = {}
	slot9 = nil

	table.insert(slot6, {
		parent = 0,
		point = slot1
	})

	while #slot6 > 0 do
		if table.remove(slot6, 1).point == slot2 then
			slot9 = slot10

			break
		end

		table.insert(slot7, slot11)

		for slot15, slot16 in ipairs(slot4(slot11)) do
			if slot3(slot6, slot7, slot16, slot2) then
				table.insert(slot6, {
					point = slot16,
					parent = slot10
				})
			else
				if slot16 == slot2 then
					slot9 = slot10

					break
				end

				table.insert(slot7, slot16)
			end
		end

		table.sort(slot6, function (slot0, slot1)
			return slot0(slot0.point, slot1.point, slot1)
		end)
	end

	if slot9 then
		while slot9.parent ~= 0 do
			table.insert(slot8, 1, slot9.point)

			slot9 = slot9.parent
		end
	end

	return slot8
end

slot0.CanInterAction = function (slot0, slot1)
	if slot1 < math.random(1, 10000) then
		return false
	end

	slot3 = {}

	for slot7, slot8 in ipairs(slot0.furnitures) do
		if not slot8:BeLock() then
			table.insert(slot3, slot8)
		end
	end

	if #slot3 == 0 then
		return false
	end

	slot7 = 999999
	slot8 = nil
	slot9 = slot0.grid.position

	for slot13, slot14 in ipairs(slot6) do
		if slot7 > math.abs(slot9.x - slot14.position.x) + math.abs(slot9.y - slot14.position.y) then
			slot7 = slot16
			slot8 = slot15
		end
	end

	if not slot0:SearchPoint(slot0.grid.position, slot8) or #slot10 == 0 then
		return false
	end

	return true, {
		slot5,
		slot10
	}
end

slot0.Dispose = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end

	if slot0.idleTimer then
		slot0.idleTimer:Stop()

		slot0.idleTimer = nil
	end

	if slot0.interActionTimer then
		slot0.interActionTimer:Stop()

		slot0.interActionTimer = nil
	end

	if not IsNil(slot0._go) and LeanTween.isTweening(slot0._go) then
		LeanTween.cancel(slot0._go)
	end

	Destroy(slot0.nameTF)

	if slot0.isCommander then
		Destroy(slot0.tagTF)
	end

	slot0.actionName = nil

	slot0:SetOnMoveCallBack()

	slot0.exited = true
end

return slot0

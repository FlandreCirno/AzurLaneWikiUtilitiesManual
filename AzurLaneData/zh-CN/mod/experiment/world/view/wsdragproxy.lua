slot0 = class("WSDragProxy", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	transform = "userdata",
	leftExtend = "number",
	gid = "number",
	longPressTrigger = "userdata",
	topExtend = "number",
	twFocusId = "number",
	dragTrigger = "userdata",
	wsTimer = "table",
	onDragFunction = "function",
	isDraging = "boolean",
	rightExtend = "number",
	callInfo = "table",
	bottomExtend = "number"
}

slot0.Setup = function (slot0, slot1)
	slot0.callInfo = slot1
	slot0.dragTrigger = GetOrAddComponent(slot0.transform, typeof(EventTriggerListener))

	slot0.dragTrigger:AddBeginDragFunc(function ()
		slot0.isDraging = true
	end)
	slot0.dragTrigger.AddDragEndFunc(slot2, function ()
		slot0.isDraging = false
	end)
	slot0.dragTrigger.AddPointClickFunc(slot2, function (slot0, slot1)
		if not slot0.isDraging then
			slot0.callInfo.clickCall(slot0, slot1)
		end
	end)

	slot0.dragTrigger.enabled = true
	slot0.longPressTrigger = GetOrAddComponent(slot0.transform, typeof(UILongPressTrigger))
	slot2 = slot0.callInfo.longPressCall

	slot0.callInfo.longPressCall = function (...)
		if slot0.isDraging then
			return
		end

		slot1(...)
	end

	slot0.longPressTrigger.onLongPressed.AddListener(slot3, slot0.callInfo.longPressCall)

	slot0.longPressTrigger.enabled = true
end

slot0.Dispose = function (slot0)
	slot0.transform.localPosition = Vector3.zero

	if slot0.map then
		slot0.dragTrigger:RemoveDragFunc()
	end

	slot0.dragTrigger:RemoveBeginDragFunc()
	slot0.dragTrigger:RemoveDragEndFunc()
	slot0.dragTrigger:RemovePointClickFunc()

	slot0.dragTrigger.enabled = true

	slot0.longPressTrigger.onLongPressed:RemoveListener(slot0.callInfo.longPressCall)

	slot0.longPressTrigger.enabled = true

	slot0:Clear()
end

slot0.Focus = function (slot0, slot1, slot2, slot3, slot4)
	slot6 = slot0.transform:Find("plane")
	slot7 = slot0.transform.parent:InverseTransformVector(slot1 - slot6.position)
	slot7.x = slot7.x + slot6.localPosition.x
	slot7.y = (slot7.y + slot6.localPosition.y) - slot6.localPosition.z * math.tan(math.pi / 180 * slot0.map.theme.angle)
	slot7.x = math.clamp(-slot7.x, -slot0.rightExtend, slot0.leftExtend)
	slot7.y = math.clamp(-slot7.y, -slot0.topExtend, slot0.bottomExtend)
	slot7.z = 0

	if slot0.twFocusId then
		slot0.wsTimer:RemoveInMapTween(slot0.twFocusId)
	end

	slot8 = {}

	if slot3 then
		table.insert(slot8, function (slot0)
			if slot0.isDraging then
				slot0.isDraging = false
			end

			slot0.dragTrigger.enabled = false
			slot0.longPressTrigger.enabled = false

			if not slot0.longPressTrigger then
				slot1 = (slot0.transform.localPosition - slot2.magnitude > 0 and slot1 / (40 * math.sqrt(slot1))) or 0
			end

			slot0.twFocusId = LeanTween.moveLocal(slot0.transform.gameObject, LeanTween.moveLocal, slot1):setEase(LeanTween.moveLocal(slot0.transform.gameObject, LeanTween.moveLocal, slot1)):setOnComplete(System.Action(slot0)).uniqueId

			slot0.wsTimer:AddInMapTween(slot0.twFocusId)
		end)
	else
		slot0.transform.localPosition = slot7
	end

	seriesAsync(slot8, function ()
		slot0.dragTrigger.enabled = true
		slot0.dragTrigger.longPressTrigger.enabled = true

		if true then
			slot1()
		end
	end)
end

slot0.UpdateMap = function (slot0, slot1)
	if slot0.map ~= slot1 or slot0.gid ~= slot1.gid then
		slot0.map = slot1
		slot0.gid = slot1.gid

		slot0:UpdateDrag()
	end
end

slot0.UpdateDrag = function (slot0)
	Vector2.New(pg.UIMgr.GetInstance().UIMain.transform.rect.width / UnityEngine.Screen.width, pg.UIMgr.GetInstance().UIMain.transform.rect.height / UnityEngine.Screen.height).x = Vector2.New(pg.UIMgr.GetInstance().UIMain.transform.rect.width / UnityEngine.Screen.width, pg.UIMgr.GetInstance().UIMain.transform.rect.height / UnityEngine.Screen.height).x * math.clamp(((pg.UIMgr.GetInstance().UIMain.transform.rect.width * 0.5) / math.tan(math.pi / 180 * slot0.map.theme.fov) - Vector3(0, slot0.map.theme.offsety, slot0.map.theme.offsetz) + WorldConst.DefaultMapOffset.magnitude) / ((pg.UIMgr.GetInstance().UIMain.transform.rect.width * 0.5) / math.tan(math.pi / 180 * slot0.map.theme.fov)), 0, 1)
	slot0.leftExtend, slot0.rightExtend, slot0.topExtend, slot0.bottomExtend = slot0:GetDragExtend(slot2, slot3)
	slot0.transform.sizeDelta = Vector2(pg.UIMgr.GetInstance().UIMain.transform.rect.width + math.max(slot0.leftExtend, slot0.rightExtend) * 2, pg.UIMgr.GetInstance().UIMain.transform.rect.height + math.max(slot0.topExtend, slot0.bottomExtend) * 2)

	slot0.dragTrigger:RemoveDragFunc()
	slot0.dragTrigger:AddDragFunc(function (slot0, slot1)
		if slot0.onDragFunction then
			slot0.onDragFunction()
		end

		slot0.transform.localPosition.x = math.clamp(slot0.transform.localPosition.x + slot1.delta.x * slot1.x, -slot0.rightExtend, slot0.leftExtend)
		slot0.transform.localPosition.y = math.clamp(slot0.transform.localPosition.y + slot1.delta.y * slot1.y, -slot0.topExtend, slot0.bottomExtend)
		slot0.transform.localPosition = slot0.transform.localPosition
	end)
end

slot0.GetDragExtend = function (slot0, slot1, slot2)
	slot5 = slot0.transform:Find("plane")
	slot6 = slot5.localPosition.x
	slot7 = slot5.localPosition.y - slot5.localPosition.z * math.tan(math.pi / 180 * slot0.map.theme.angle)
	slot8 = 99999999
	slot9 = 0
	slot10 = 0

	for slot14, slot15 in pairs(slot0.map.cells) do
		if slot15.row < slot8 then
			slot8 = slot15.row
		end

		if slot9 < slot15.row then
			slot9 = slot15.row
		end

		if slot10 < slot15.column then
			slot10 = slot15.column
		end
	end

	return 1000 - slot6, math.max(slot10 * slot3.theme.cellSize + slot3.theme.cellSpace.x - slot1 * 0.5, 0) + slot6, math.max((WorldConst.MaxRow * 0.5 - slot8) * slot3.theme.cellSize + slot3.theme.cellSpace.y, 0) + slot7, math.max((slot9 - WorldConst.MaxRow * 0.5) * slot3.theme.cellSize + slot3.theme.cellSpace.y, 0) - slot7
end

slot0.ShakePlane = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.dragTrigger.enabled = false
	slot0.longPressTrigger.enabled = false

	slot0.wsTimer.AddInMapTween(slot18, LeanTween.moveLocal(slot0.transform.gameObject, slot9, slot12).uniqueId)
	slot0.wsTimer:AddInMapTween(LeanTween.moveLocal(slot0.transform.gameObject, slot10, slot13):setDelay(slot12):setLoopPingPong(slot4).uniqueId)
	slot0.wsTimer:AddInMapTween(LeanTween.moveLocal(slot0.transform.gameObject, slot8, slot14):setDelay(0.0333 * math.max(slot3, 1) * 0.5 + 0.0333 * math.max(slot3, 1) * math.max(slot4, 1) * 2):setOnComplete(System.Action(function ()
		slot0.dragTrigger.enabled = true
		slot0.dragTrigger.longPressTrigger.enabled = true

		true()
	end)).uniqueId)
end

return slot0

slot0 = class("WSMapTransport", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	wsMapPath = "table",
	rtForbid = "userdata",
	transform = "userdata",
	dir = "number",
	column = "number",
	updateTimer = "table",
	row = "number",
	rtClick = "userdata",
	rtBottom = "userdata",
	rtDanger = "userdata"
}
slot0.Listeners = {
	onStartTrip = "OnStartTrip",
	onArrived = "OnArrived"
}

slot0.GetName = function (slot0, slot1, slot2)
	return "transport_" .. slot0 .. "_" .. slot1 .. "_" .. slot2
end

slot0.Setup = function (slot0, slot1, slot2, slot3, slot4)
	slot0.row = slot1
	slot0.column = slot2
	slot0.dir = slot3
	slot0.map = slot4

	slot0.wsMapPath:AddListener(WSMapPath.EventStartTrip, slot0.onStartTrip)
	slot0.wsMapPath:AddListener(WSMapPath.EventArrived, slot0.onArrived)
end

slot0.Dispose = function (slot0)
	slot0.wsMapPath:RemoveListener(WSMapPath.EventStartTrip, slot0.onStartTrip)
	slot0.wsMapPath:RemoveListener(WSMapPath.EventArrived, slot0.onArrived)
	slot0:DisposeUpdateTimer()
	slot0:UpdateAlpha(1)
	slot0:Unload()
	slot0:Clear()
end

slot0.Load = function (slot0)
	PoolMgr.GetInstance():GetPrefab("world/object/world_cell_transport", "world_cell_transport", false, function (slot0)
		slot0.transform = slot0.transform

		slot0:Init()
	end)
end

slot0.Unload = function (slot0)
	if slot0.transform then
		PoolMgr.GetInstance():ReturnPrefab("world/object/world_cell_transport", "world_cell_transport", slot0.transform.gameObject)
	end

	slot0.transform = nil
end

slot0.Init = function (slot0)
	slot0.rtClick = slot0.transform.Find(slot1, "click")
	slot0.rtBottom = slot0.transform.Find(slot1, "bottom")
	slot0.rtDanger = slot0.transform.Find(slot1, "danger")
	slot0.rtForbid = slot0.transform.Find(slot1, "forbid")
	slot0.transform.name = slot0.GetName(slot2, slot0.column, slot0.dir)
	slot5 = 0

	if slot0.dir == WorldConst.DirDown then
		slot2 = slot2 + 1
		slot5 = -90
	elseif slot4 == WorldConst.DirLeft then
		slot3 = slot3 - 1
		slot5 = 180
	elseif slot4 == WorldConst.DirUp then
		slot2 = slot2 - 1
		slot5 = 90
	elseif slot4 == WorldConst.DirRight then
		slot3 = slot3 + 1
		slot5 = 0
	end

	slot1.localEulerAngles = Vector3(0, 0, slot5)
	slot1.anchoredPosition = slot0.map.theme:GetLinePosition(slot2, slot3)
	slot1.localScale = Vector3(slot0.map.theme.cellSize.x / slot1.sizeDelta.x, slot0.map.theme.cellSize.y / slot1.sizeDelta.y, 1)

	if slot0.wsMapPath:IsMoving() then
		slot0:OnStartTrip()
	end
end

slot0.UpdateAlpha = function (slot0, slot1)
	setImageAlpha(slot0.rtBottom, slot1)
	setImageAlpha(slot0.rtDanger, slot1)
	setImageAlpha(slot0.rtForbid, slot1)
end

slot0.OnStartTrip = function (slot0)
	slot0:StartUpdateTimer()
end

slot0.OnArrived = function (slot0)
	slot0:DisposeUpdateTimer()
end

slot0.StartUpdateTimer = function (slot0)
	if slot0.wsMapPath.wsObject.class == WSMapFleet then
		slot0:DisposeUpdateTimer()

		slot3 = slot0.map.theme.GetLinePosition(slot2, slot0.row, slot0.column)
		slot4 = math.min(slot0.map.theme.cellSize.x + slot0.map.theme.cellSpace.x, slot0.map.theme.cellSize.y + slot0.map.theme.cellSpace.y)
		slot5 = slot1.fleet
		slot7 = _.map(slot6, function (slot0)
			return Vector3.Distance(slot0:GetLinePosition(slot0.row, slot0.column), )
		end)
		slot0.updateTimer = Timer.New(function ()
			slot0[slot1.index] = Vector3.Distance(slot2.transform.anchoredPosition3D, )

			slot5:UpdateAlpha(math.max(1 - _.min(slot0) / slot4, 0))
		end, 0.033, -1)

		slot0.updateTimer.Start(slot8)
		slot0.updateTimer.func()
	end
end

slot0.DisposeUpdateTimer = function (slot0)
	if slot0.updateTimer then
		slot0.updateTimer:Stop()

		slot0.updateTimer = nil
	end
end

return slot0

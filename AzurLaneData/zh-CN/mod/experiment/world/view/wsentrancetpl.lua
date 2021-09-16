slot0 = class("WSEntranceTpl", import("...BaseEntity"))
slot0.Fields = {
	markSigns = "table",
	portCamp = "number",
	world = "table",
	transform = "userdata",
	tfMap = "userdata",
	entrance = "table",
	markTFs = "table",
	tfArea = "userdata"
}
slot0.Listeners = {
	onUpdateDisplayMarks = "OnUpdateDisplayMarks"
}
slot0.DisplayOrder = {
	"step",
	"task_main",
	"task",
	"treasure_sairen",
	"treasure",
	"sairen",
	"task_following_main",
	"task_following"
}
slot0.prefabName = {
	task_main = "DSJ_BX05_3D",
	task = "DSJ_BX03_3D",
	port_gray_2 = "mark_port_gray_2",
	port_task = "mark_port_task",
	port_2 = "mark_port_2",
	buff_d = "buff_d",
	task_following_main = "DSJ_BX05_3D",
	buff_a = "buff_a",
	treasure_sairen = "DSJ_BX06_3D",
	buff_h = "buff_h",
	buff_d2 = "buff_d2",
	currency = "currency",
	port_gray_1 = "mark_port_gray_1",
	port_1 = "mark_port_1",
	mate = "mate",
	buff_a2 = "buff_a2",
	task_following = "DSJ_BX03_3D",
	treasure = "DSJ_BX01_3D",
	sairen = "guangzhu",
	core = "core",
	buff_h2 = "buff_h2",
	step = "DSJ_BX05_3D"
}
slot0.offsetField = {
	task_main = "offset_pos",
	task = "offset_pos",
	treasure = "offset_pos",
	task_following = "offset_pos",
	treasure_sairen = "offset_pos",
	task_following_main = "offset_pos",
	step = "offset_pos"
}

slot0.Build = function (slot0)
	slot0.transform = tf(GameObject.New())
end

slot0.Setup = function (slot0)
	pg.DelegateInfo.New(slot0)
	slot0:Init()
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
	slot0:RemoveEntranceListener()

	slot1 = PoolMgr.GetInstance()

	for slot5, slot6 in pairs(slot0.markTFs) do
		slot6.localPosition = Vector3.zero

		slot1:ReturnPrefab("world/mark/" .. slot0.prefabName[slot5], slot0.prefabName[slot5], go(slot6), true)
	end

	Destroy(slot0.transform)
	slot0:Clear()
end

slot0.Init = function (slot0)
	slot0.markTFs = {}
end

slot0.UpdateEntrance = function (slot0, slot1, slot2)
	if slot2 or slot0.entrance ~= slot1 then
		slot0:RemoveEntranceListener()
		_.each(slot0.markTFs, function (slot0)
			setActive(slot0, false)
		end)

		slot0.entrance = slot1
		slot0.portCamp = (slot0.entrance.HasPort(slot3) and pg.world_port_data[slot0.entrance.config.port_map_icon].port_camp) or nil

		slot0:AddEntranceListener()
		slot0:InitMarksValue()

		slot0.transform.name = (slot0.portCamp and "port_" .. slot1.id) or slot1:GetColormaskUniqueID()

		slot0:DoUpdateMark(slot0:GetShowMark(), true)
	end
end

slot0.InitMarksValue = function (slot0)
	slot0.markSigns = {}

	for slot5, slot6 in pairs(slot1) do
		slot0.markSigns[slot5] = slot6 > 0
	end
end

slot0.AddEntranceListener = function (slot0)
	if slot0.entrance then
		slot0.entrance:AddListener(WorldEntrance.EventUpdateDisplayMarks, slot0.onUpdateDisplayMarks)
	end
end

slot0.RemoveEntranceListener = function (slot0)
	if slot0.entrance then
		slot0.entrance:RemoveListener(WorldEntrance.EventUpdateDisplayMarks, slot0.onUpdateDisplayMarks)
	end
end

slot0.LoadPrefab = function (slot0, slot1, slot2)
	PoolMgr.GetInstance():GetPrefab("world/mark/" .. slot0.prefabName[slot1], slot0.prefabName[slot1], true, function (slot0)
		if slot0.markTFs and not slot0.markTFs[] then
			slot0.markTFs[] = tf(slot0)

			SetParent(slot0.markTFs[slot1], slot0.transform, false)

			slot0.markTFs[].localPosition = slot0:GetPrefabOffset(slot0.markTFs[])

			if slot0.GetPrefabOffset(slot0.markTFs[]) then
				SetParent(slot0.markTFs[slot1], , true)
			end

			setActive(slot0.markTFs[slot1], true)
		else
			slot3:ReturnPrefab("world/mark/" .. slot4.prefabName[slot1], slot4.prefabName[slot1].prefabName[slot1], slot0, true)
		end
	end)
end

slot0.GetPrefabOffset = function (slot0, slot1)
	return Vector3((slot0.offsetField[slot1] and slot0.entrance.config[slot0.offsetField[slot1]]) or {
		0,
		0
	}[1] / PIXEL_PER_UNIT, 0, (slot0.offsetField[slot1] and slot0.entrance.config[slot0.offsetField[slot1]]) or [2] / PIXEL_PER_UNIT)
end

slot0.UpdateMark = function (slot0, slot1, slot2)
	slot0:DoUpdateMark(slot0:GetShowMark(), false)

	slot0.markSigns[slot1] = slot2

	slot0:DoUpdateMark(slot0:GetShowMark(), true)
end

slot0.OnUpdateDisplayMarks = function (slot0, slot1, slot2, slot3, slot4)
	slot0:UpdateMark(slot3, slot4)
end

slot0.DoUpdateMark = function (slot0, slot1, slot2, slot3)
	if slot1 then
		if slot0.markTFs[slot1] then
			setActive(slot0.markTFs[slot1], slot2)
		elseif slot2 then
			slot0:LoadPrefab(slot1, slot3)
		end
	end
end

slot0.GetShowMark = function (slot0)
	for slot4, slot5 in ipairs(slot0.DisplayOrder) do
		if slot0.markSigns[slot5] then
			return slot5
		end
	end
end

slot0.UpdatePort = function (slot0, slot1, slot2)
	slot0:DoUpdateMark("port_" .. slot0.portCamp, slot1)
	slot0:DoUpdateMark("port_gray_" .. slot0.portCamp, not slot1)
	slot0:DoUpdateMark("port_task", slot2)
end

slot0.UpdatePressingAward = function (slot0)
	if nowWorld:GetPressingAward(slot0.entrance.id) then
		slot0:DoUpdateMark(pg.world_event_complete[slot1.id].map_icon, slot1.flag, slot0.tfMap)
	end
end

return slot0

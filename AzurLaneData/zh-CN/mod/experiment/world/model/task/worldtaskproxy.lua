slot0 = class("WorldTaskProxy", import("....BaseEntity"))
slot0.Fields = {
	list = "table",
	itemListenerList = "table",
	taskFinishCount = "number",
	mapList = "table",
	mapListenerList = "table"
}
slot0.EventUpdateTask = "WorldTaskProxy.EventUpdateTask"

slot0.Build = function (slot0)
	slot0.list = {}
	slot0.itemListenerList = {}
	slot0.mapListenerList = {}
end

slot0.Setup = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		slot0:addTask(WorldTask.New(slot6))
	end
end

slot0.Dispose = function (slot0)
	slot0:Clear()
end

slot0.getTaskById = function (slot0, slot1)
	return slot0.list[slot1]
end

slot0.addTaskListener = function (slot0, slot1)
	if slot1.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		slot0.itemListenerList[slot2] = slot0.itemListenerList[slot1.config.complete_parameter[1]] or {}

		table.insert(slot0.itemListenerList[slot2], slot1.id)
	elseif slot1.config.complete_condition == WorldConst.TaskTypePressingMap then
		for slot5, slot6 in ipairs(slot1.config.complete_parameter) do
			slot0.mapListenerList[slot6] = slot0.mapListenerList[slot6] or {}

			table.insert(slot0.mapListenerList[slot6], slot1.id)
		end
	end
end

slot0.removeTaskListener = function (slot0, slot1)
	if slot1.config.complete_condition == WorldConst.TaskTypeSubmitItem then
		table.removebyvalue(slot0.itemListenerList[slot1.config.complete_parameter[1]], slot1.id)
	elseif slot1.config.complete_condition == WorldConst.TaskTypePressingMap then
		for slot5, slot6 in ipairs(slot1.config.complete_parameter) do
			table.removebyvalue(slot0.mapListenerList[slot6], slot1.id)
		end
	end
end

slot0.doUpdateTaskByItem = function (slot0, slot1)
	if not slot0.itemListenerList[slot1.id] then
		return
	end

	for slot5, slot6 in ipairs(slot0.itemListenerList[slot1.id]) do
		slot7 = slot0:getTaskById(slot6)

		slot7:updateProgress(slot1.count)
		slot0:updateTask(slot7)
	end
end

slot0.doUpdateTaskByMap = function (slot0, slot1, slot2)
	if not slot0.mapListenerList[slot1] then
		return
	end

	for slot6, slot7 in ipairs(slot0.mapListenerList[slot1]) do
		slot8 = slot0:getTaskById(slot7)

		slot8:updateProgress(slot8:getProgress() + ((slot2 and 1) or -1))
		slot0:updateTask(slot8)
	end
end

slot0.addTask = function (slot0, slot1)
	slot0.list[slot1.id] = slot1

	slot0:addTaskListener(slot1)
	slot0:DispatchEvent(slot0.EventUpdateTask, slot1)
end

slot0.deleteTask = function (slot0, slot1)
	if not slot0.list[slot1] then
		return
	end

	slot0.list[slot1] = nil

	slot0:removeTaskListener(slot2)
	slot0:DispatchEvent(slot0.EventUpdateTask, slot0.list[slot1])
end

slot0.updateTask = function (slot0, slot1)
	if slot1:getState() == WorldTask.STATE_RECEIVED then
		slot0:deleteTask(slot1.id)
	else
		slot0.list[slot1.id] = slot1

		slot0:DispatchEvent(slot0.EventUpdateTask, slot1)
	end
end

slot0.getTasks = function (slot0)
	return slot0.list
end

slot0.getTaskVOs = function (slot0)
	return _.values(slot0.list)
end

slot0.getDoingTaskVOs = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0:getTasks()) do
		if slot6:getState() == WorldTask.STATE_ONGOING or slot7 == WorldTask.STATE_FINISHED then
			table.insert(slot1, slot6)
		end
	end

	return slot1
end

slot0.getAutoSubmitTaskVO = function (slot0)
	for slot4, slot5 in pairs(slot0:getTasks()) do
		if slot5:IsAutoSubmit() and slot5:getState() == WorldTask.STATE_FINISHED then
			return slot5
		end
	end

	return nil
end

slot0.riseTaskFinishCount = function (slot0)
	slot0.taskFinishCount = slot0.taskFinishCount + 1
end

return slot0

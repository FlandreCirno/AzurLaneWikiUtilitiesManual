slot0 = class("EquipmentProxy", import(".NetProxy"))
slot0.EQUIPMENT_ADDED = "equipment added"
slot0.EQUIPMENT_UPDATED = "equipment updated"
slot0.EQUIPMENT_SKIN_UPDATED = "equipment skin updated"

slot0.register = function (slot0)
	slot0.data = {}
	slot0.equipmentSkinIds = {}
	slot0.shipIdListInTimeLimit = {}

	slot0:on(14001, function (slot0)
		slot0.data.equipments = {}

		for slot4, slot5 in ipairs(slot0.equip_list) do
			slot0.data.equipments[Equipment.New(slot5).id] = Equipment.New(slot5)
		end

		for slot4, slot5 in ipairs(slot0.ship_id_list) do
			table.insert(slot0.shipIdListInTimeLimit, slot5)
		end
	end)
	slot0.on(slot0, 14101, function (slot0)
		for slot4, slot5 in ipairs(slot0.equip_skin_list) do
			slot0.equipmentSkinIds[slot5.id] = {
				id = slot5.id,
				count = slot5.count
			}
		end
	end)

	slot0.weakTable = setmetatable({}, {
		__mode = "v"
	})
end

slot0.getEquipmentSkins = function (slot0)
	return slot0.equipmentSkinIds or {}
end

slot0.getSkinsByType = function (slot0, slot1)
	slot2 = {}
	slot3 = pg.equip_skin_template

	for slot8, slot9 in pairs(slot4) do
		if table.contains(slot3[slot9.id].equip_type, slot1) then
			table.insert(slot2, slot9)
		end
	end

	return slot2
end

slot0.getSkinsByTypes = function (slot0, slot1)
	if not slot1 or #slot1 <= 0 then
		return {}
	end

	slot2 = {}
	slot3 = pg.equip_skin_template

	for slot8, slot9 in pairs(slot4) do
		slot10 = false

		for slot14 = 1, #slot1, 1 do
			if table.contains(slot3[slot9.id].equip_type, slot1[slot14]) then
				slot10 = true
			end
		end

		if slot10 then
			table.insert(slot2, slot9)
		end
	end

	return slot2
end

slot0.getEquipmnentSkinById = function (slot0, slot1)
	return slot0.equipmentSkinIds[slot1]
end

slot0.addEquipmentSkin = function (slot0, slot1, slot2)
	if slot0.equipmentSkinIds[slot1] then
		slot0.equipmentSkinIds[slot1].count = slot0.equipmentSkinIds[slot1].count + 1
	else
		slot0.equipmentSkinIds[slot1] = {
			id = slot1,
			count = slot2
		}
	end

	slot0:sendNotification(slot0.EQUIPMENT_SKIN_UPDATED, {
		id = slot1,
		count = slot0.equipmentSkinIds[slot1].count
	})
end

slot0.useageEquipmnentSkin = function (slot0, slot1)
	slot0.equipmentSkinIds[slot1].count = slot0.equipmentSkinIds[slot1].count - 1

	slot0:sendNotification(slot0.EQUIPMENT_SKIN_UPDATED, {
		id = slot1,
		count = slot0.equipmentSkinIds[slot1].count
	})
end

slot0.addEquipment = function (slot0, slot1)
	if slot0.data.equipments[slot1.id] == nil then
		slot0.data.equipments[slot1.id] = slot1:clone()

		slot0.data.equipments[slot1.id]:display("added")
		slot0:OnEquipsUpdate(slot0.data.equipments[slot1.id])
		slot0.facade:sendNotification(slot0.EQUIPMENT_ADDED, slot1:clone())
	else
		slot2.count = slot2.count + slot1.count

		slot0:updateEquipment(slot2)
	end
end

slot0.addEquipmentById = function (slot0, slot1, slot2, slot3)
	slot0:addEquipment(Equipment.New({
		id = slot1,
		count = slot2,
		new = (not slot3 or 0) and 1
	}))
end

slot0.updateEquipment = function (slot0, slot1)
	slot0.data.equipments[slot1.id] = (slot1.count ~= 0 and slot1:clone()) or nil

	slot1:display("updated")
	slot0:OnEquipsUpdate(slot0.data.equipments[slot1.id] or slot1)
	slot0.facade:sendNotification(slot0.EQUIPMENT_UPDATED, slot1:clone())
end

slot0.removeEquipmentById = function (slot0, slot1, slot2)
	slot0.data.equipments[slot1].count = math.max(slot0.data.equipments[slot1].count - slot2, 0)

	slot0:updateEquipment(slot0.data.equipments[slot1])
end

slot0.getEquipments = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data.equipments) do
		if slot7.count > 0 then
			table.insert(slot2, slot7:clone())

			if slot1 then
				slot7.new = 0
			end
		end
	end

	return slot2
end

slot0.GetEquipmentsRaw = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.data.equipments) do
		if slot6.count > 0 then
			table.insert(slot1, slot6)
		end
	end

	return slot1
end

slot0.getEquipmentById = function (slot0, slot1)
	if slot0.data.equipments[slot1] ~= nil then
		return slot0.data.equipments[slot1]:clone()
	end

	return nil
end

slot0.getSameTypeEquipmentId = function (slot0, slot1)
	slot2 = Equipment.New({
		id = slot1.config.id
	})
	slot3 = nil

	while slot2.config.next ~= 0 do
		if slot0:getEquipmentById(slot2.config.next) and slot4.count > 0 then
			slot3 = slot4
		end

		slot2 = Equipment.New({
			id = slot2.config.next
		})
	end

	if not slot3 then
		slot2 = Equipment.New({
			id = slot1.config.id
		})

		while slot2.config.prev ~= 0 do
			if slot0:getEquipmentById(slot2.config.prev) and slot4.count > 0 then
				slot3 = slot4

				break
			end

			slot2 = Equipment.New({
				id = slot2.config.prev
			})
		end
	end

	if slot3 then
		return slot3.id
	end
end

slot0.getEquipCount = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.data.equipments) do
		slot1 = slot1 + slot6.count
	end

	return slot1
end

slot0.getEquipmentSkinCount = function (slot0)
	slot2 = 0

	for slot6, slot7 in pairs(slot1) do
		slot2 = slot2 + slot7.count
	end

	return slot2
end

slot0.getCapacity = function (slot0)
	return slot0:getEquipCount()
end

slot0.getTimeLimitShipList = function (slot0)
	slot1 = getProxy(BayProxy)
	slot2 = {}
	slot3 = nil

	for slot7, slot8 in ipairs(slot0.shipIdListInTimeLimit) do
		if slot1:getShipById(slot8) then
			table.insert(slot2, {
				count = 1,
				type = 4,
				id = slot3.configId
			})
		end
	end

	return slot2
end

slot0.clearTimeLimitShipList = function (slot0)
	slot0.shipIdListInTimeLimit = {}
end

slot0.EquipTransformTargetDict = {}

for slot4, slot5 in ipairs(pg.equip_upgrade_data.all) do
	slot0.EquipTransformTargetDict[pg.equip_upgrade_data[slot5].upgrade_from] = slot0.EquipTransformTargetDict[pg.equip_upgrade_data[slot5].upgrade_from] or {}
	slot0.EquipTransformTargetDict[slot6.upgrade_from].targets = slot0.EquipTransformTargetDict[slot6.upgrade_from].targets or {}

	table.insert(slot0.EquipTransformTargetDict[slot6.upgrade_from].targets, slot5)

	slot0.EquipTransformTargetDict[slot6.target_id] = slot0.EquipTransformTargetDict[slot6.target_id] or {}
	slot0.EquipTransformTargetDict[slot6.target_id].sources = slot0.EquipTransformTargetDict[slot6.target_id].sources or {}

	table.insert(slot0.EquipTransformTargetDict[slot6.target_id].sources, slot5)
end

slot0.GetTransformTargets = function (slot0)
	return (slot0.EquipTransformTargetDict[slot0] and slot0.EquipTransformTargetDict[slot0].targets) or {}
end

slot0.GetTransformSources = function (slot0)
	return (slot0.EquipTransformTargetDict[slot0] and slot0.EquipTransformTargetDict[slot0].sources) or {}
end

slot0.EquipmentTransformTreeTemplate = {}

for slot4 = 1, 4, 1 do
	slot0.EquipmentTransformTreeTemplate[slot4] = {}
end

for slot4, slot5 in pairs(pg.equip_upgrade_template.all) do
	slot0.EquipmentTransformTreeTemplate[pg.equip_upgrade_template[slot5].category1] = slot0.EquipmentTransformTreeTemplate[pg.equip_upgrade_template[slot5].category1] or {}
	slot0.EquipmentTransformTreeTemplate[slot6.category1][slot6.category2] = slot6
end

slot0.SameEquip = function (slot0, slot1)
	if not slot0 or not slot1 then
		return false
	end

	return slot0.id == slot1.id and slot0.shipId == slot1.shipId and slot0.shipPos == slot1.shipPos
end

slot0.GetWeakEquipsDict = function (slot0)
	if slot0.weakTable.equipsDict then
		return slot0.weakTable.equipsDict
	end

	slot0.weakTable.equipsDict = EquipmentsDict.New()

	collectgarbage("collect")

	return EquipmentsDict.New()
end

slot0.OnEquipsUpdate = function (slot0, slot1)
	if not slot0.weakTable.equipsDict then
		return
	end

	slot0.weakTable.equipsDict:UpdateEquipment(slot1)
end

slot0.OnShipEquipsAdd = function (slot0, slot1, slot2, slot3)
	if not slot0.weakTable.equipsDict then
		return
	end

	CreateShell(slot1).shipId = slot2
	CreateShell(slot1).shipPos = slot3

	slot0.weakTable.equipsDict:AddEquipment(CreateShell(slot1))
end

slot0.OnShipEquipsRemove = function (slot0, slot1, slot2, slot3)
	if not slot0.weakTable.equipsDict then
		return
	end

	CreateShell(slot1).shipId = slot2
	CreateShell(slot1).shipPos = slot3

	slot0.weakTable.equipsDict:RemoveEquipment(CreateShell(slot1))
end

return slot0

slot0 = class("BayProxy", import(".NetProxy"))
slot0.SHIP_ADDED = "ship added"
slot0.SHIP_REMOVED = "ship removed"
slot0.SHIP_UPDATED = "ship updated"

slot0.register = function (slot0)
	slot0:on(12001, function (slot0)
		slot0.data = {}
		slot0.activityNpcShipIds = {}
		slot0.metaShipIDList = {}

		for slot4, slot5 in ipairs(slot0.shiplist) do
			slot6 = Ship.New(slot5)

			slot6:display("loaded")

			slot0.shipHighestLevel = math.max(slot0.shipHighestLevel, slot6.level)

			if slot6:getConfigTable() then
				slot0.data[slot6.id] = slot6

				if slot6:isActivityNpc() then
					table.insert(slot0.activityNpcShipIds, slot6.id)
				elseif slot6:isMetaShip() and not table.contains(slot0.metaShipIDList, slot6.id) then
					table.insert(slot0.metaShipIDList, slot6.id)
				end

				slot1.recordShipLevelVertify(slot6)
			else
				warning("不存在的角色: " .. slot6.id)
			end
		end

		if #slot0.metaShipIDList > 0 then
			getProxy(MetaCharacterProxy):requestMetaTacticsInfo(slot0.metaShipIDList)
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end)
	slot0.on(slot0, 12031, function (slot0)
		slot0.energyRecoverTime = slot0.energy_auto_increase_time + Ship.ENERGY_RECOVER_TIME

		slot0:addEnergyListener(slot0.energyRecoverTime - pg.TimeMgr.GetInstance():GetServerTime())
	end)
	slot0.on(slot0, 12010, function (slot0)
		slot2 = getProxy(PlayerProxy).getInited(slot1)
		slot3 = 0
		slot0.newShipList = {}

		for slot7, slot8 in ipairs(slot0.ship_list) do
			if Ship.New(slot8):getConfigTable() then
				if slot9:isMetaShip() and not slot9.virgin and Player.isMetaShipNeedToTrans(slot9.configId) then
					if MetaCharacterConst.addReMetaTransItem(slot9) then
						slot9:setReMetaSpecialItemVO(slot10)
					end

					slot0.newShipList[#slot0.newShipList + 1] = slot9
				else
					slot0:addShip(slot9, false)

					if slot2 then
						slot3 = slot3 + 1
					end

					slot0.newShipList[#slot0.newShipList + 1] = slot9
				end
			else
				warning("不存在的角色: " .. slot9.id)
			end
		end

		if slot3 > 0 then
			slot0:countShip(slot3)
		end
	end)

	slot1 = getProxy(PlayerProxy)

	slot0.on(slot0, 12019, function (slot0)
		slot1 = slot0:getData()
		slot2 = slot1:getShipById(slot1.character)

		slot2:setLikability(slot0.intimacy)
		slot1:updateShip(slot2)
	end)

	slot0.handbookTypeAssign = {}

	slot0.buildHandbookTypeAssign(slot0)

	slot0.shipHighestLevel = 0
end

slot0.buildHandbookTypeAssign = function (slot0)
	slot1 = _.filter(pg.ship_data_group.all, function (slot0)
		return pg.ship_data_group[slot0].handbook_type ~= 0
	end)

	for slot5, slot6 in ipairs(slot1) do
		slot0.handbookTypeAssign[pg.ship_data_group[slot6].group_type] = pg.ship_data_group[slot6].handbook_type
	end
end

slot0.recoverAllShipEnergy = function (slot0)
	slot1 = getProxy(DormProxy)
	slot2 = pg.energy_template[4].lower_bound - 2
	slot3 = pg.energy_template[4].upper_bound

	for slot7, slot8 in pairs(slot0.data) do
		if slot8.state == Ship.STATE_REST or slot8.state == Ship.STATE_TRAIN then
			slot10 = slot8:getRecoverEnergyPoint() + Ship.BACKYARD_1F_ENERGY_ADDITION

			if slot8.state == Ship.STATE_REST then
				slot10 = slot9 + Ship.BACKYARD_2F_ENERGY_ADDITION
			end

			if slot3 > slot8.energy + slot10 then
				slot8:addEnergy(slot10)
			else
				slot8:setEnergy(slot3)
			end
		elseif slot2 > slot8.energy + slot8:getRecoverEnergyPoint() then
			slot8:addEnergy(slot8:getRecoverEnergyPoint())
		elseif slot2 < slot8.energy then
			slot8:setEnergy(slot8.energy)
		else
			slot8:setEnergy(slot2)
		end

		slot0:updateShip(slot8)
	end
end

slot0.addEnergyListener = function (slot0, slot1)
	if slot1 <= 0 then
		slot0:recoverAllShipEnergy()
		slot0:addEnergyListener(Ship.ENERGY_RECOVER_TIME)

		return
	end

	if slot0.energyTimer then
		slot0.energyTimer:Stop()

		slot0.energyTimer = nil
	end

	slot0.energyTimer = Timer.New(function ()
		slot0:recoverAllShipEnergy()
		slot0.recoverAllShipEnergy:addEnergyListener(Ship.ENERGY_RECOVER_TIME)
	end, slot1, 1)

	slot0.energyTimer:Start()
end

slot0.remove = function (slot0)
	if slot0.energyTimer then
		slot0.energyTimer:Stop()

		slot0.energyTimer = nil
	end
end

slot0.recordShipLevelVertify = function (slot0)
	if slot0 then
		ys.BattleShipLevelVertify[slot0.id] = slot0.generateLevelVertify(slot0.level)
	end
end

slot0.checkShiplevelVertify = function (slot0)
	if slot0.generateLevelVertify(slot0.level) == ys.BattleShipLevelVertify[slot0.id] then
		return true
	else
		return false
	end
end

slot0.generateLevelVertify = function (slot0)
	return (slot0 + 1114) * 824
end

slot0.addShip = function (slot0, slot1, slot2)
	slot0.data[slot1.id] = slot1:clone()

	slot0.recordShipLevelVertify(slot1)

	if defaultValue(slot2, true) then
		slot0:countShip()
	end

	slot0.shipHighestLevel = math.max(slot0.shipHighestLevel, slot1.level)

	if slot1:isActivityNpc() then
		table.insert(slot0.activityNpcShipIds, slot1.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	else
		if slot1:isMetaShip() and not table.contains(slot0.metaShipIDList, slot1.id) then
			table.insert(slot0.metaShipIDList, slot1.id)
			getProxy(MetaCharacterProxy):requestMetaTacticsInfo({
				slot1.id
			})
		end

		if getProxy(CollectionProxy) then
			slot3:flushCollection(slot1)
		end
	end

	slot0.facade:sendNotification(slot0.SHIP_ADDED, slot1:clone())
end

slot0.countShip = function (slot0, slot1)
	slot2 = getProxy(PlayerProxy)
	slot3 = slot2:getData()

	slot3:increaseShipCount(slot1)
	slot2:updatePlayer(slot3)
end

slot0.getNewShip = function (slot0, slot1)
	slot1 = slot1 or true
	slot2 = slot0.newShipList or {}

	if slot1 then
		slot0.newShipList = nil
	end

	return slot2
end

slot0.getShipsByFleet = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(slot1:getShipIds()) do
		table.insert(slot2, slot0.data[slot7])
	end

	return slot2
end

slot0.getSortShipsByFleet = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(slot1.mainShips) do
		table.insert(slot2, slot0.data[slot7])
	end

	for slot6, slot7 in ipairs(slot1.vanguardShips) do
		table.insert(slot2, slot0.data[slot7])
	end

	return slot2
end

slot0.getShipByTeam = function (slot0, slot1, slot2)
	slot3 = {}

	if slot2 == TeamType.Vanguard then
		for slot7, slot8 in ipairs(slot1.vanguardShips) do
			table.insert(slot3, slot0.data[slot8])
		end
	elseif slot2 == TeamType.Main then
		for slot7, slot8 in ipairs(slot1.mainShips) do
			table.insert(slot3, slot0.data[slot8])
		end
	elseif slot2 == TeamType.Submarine then
		for slot7, slot8 in ipairs(slot1.subShips) do
			table.insert(slot3, slot0.data[slot8])
		end
	end

	return Clone(slot3)
end

slot0.getShipsByTypes = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		if table.contains(slot1, slot7:getShipType()) then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.getShipsByStatus = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		if slot7.status == slot1 then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.getShipsByTeamType = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		if slot7:getTeamType() == slot1 then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.getConfigShipCount = function (slot0, slot1)
	slot2 = 0

	for slot6, slot7 in pairs(slot0.data) do
		if slot7.configId == slot1 then
			slot2 = slot2 + 1
		end
	end

	return slot2
end

slot0.getShips = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.data) do
		table.insert(slot1, slot6)
	end

	return slot1
end

slot0.getShipCount = function (slot0)
	return table.getCount(slot0.data)
end

slot0.getShipById = function (slot0, slot1)
	if slot0.data[slot1] ~= nil then
		return slot0.data[slot1]:clone()
	end
end

slot0.getMetaShipByGroupId = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.data) do
		if slot6:isMetaShip() and slot6.metaCharacter.id == slot1 then
			return slot6
		end
	end
end

slot0.getMetaShipIDList = function (slot0)
	return slot0.metaShipIDList
end

slot0.updateShip = function (slot0, slot1)
	if slot1.isNpc then
		return
	end

	if slot0.shipHighestLevel < slot1.level then
		slot0.shipHighestLevel = slot1.level

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_HIGHEST_LEVEL, slot0.shipHighestLevel)
	end

	slot0.data[slot1.id] = slot1:clone()

	slot0.recordShipLevelVertify(slot1)

	if slot0.data[slot1.id]:isActivityNpc() and not slot1:isActivityNpc() then
		table.removebyvalue(slot0.activityNpcShipIds, slot1.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	if slot2.level < slot1.level then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIP_LEVEL_UP, slot1.level - slot2.level)
	end

	if (slot2:getStar() < slot1:getStar() or slot2.intimacy < slot1.intimacy or slot2.level < slot1.level or (not slot2.propose and slot1.propose)) and getProxy(CollectionProxy) and not slot1:isActivityNpc() then
		slot3:flushCollection(slot1)
	end

	slot0.facade:sendNotification(slot0.SHIP_UPDATED, slot1:clone())
end

slot0.removeShip = function (slot0, slot1)
	slot0:removeShipById(slot1.id)
end

slot0.getEquipment2ByflagShip = function (slot0)
	return slot0:getShipById(getProxy(PlayerProxy).getData(slot1).character):getEquip(2)
end

slot0.removeShipById = function (slot0, slot1)
	if slot0.data[slot1]:isActivityNpc() then
		table.removebyvalue(slot0.activityNpcShipIds, slot2.id)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("isActivityNpc")
	end

	slot0.data[slot2.id] = nil

	slot2:display("removed")
	slot0.facade:sendNotification(slot0.SHIP_REMOVED, slot2)
end

slot0.findShipByGroup = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.data) do
		if slot6.groupId == slot1 then
			return slot6
		end
	end

	return nil
end

slot0.findShipsByGroup = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		if slot7.groupId == slot1 then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.getSameGroupShipCount = function (slot0, slot1)
	slot2 = 0

	for slot6, slot7 in pairs(slot0.data) do
		if slot7.groupId == slot1 then
			slot2 = slot2 + 1
		end
	end

	return slot2
end

slot0.getUpgradeShips = function (slot0, slot1)
	slot2 = slot1:getConfig("rarity")
	slot3 = slot1.groupId
	slot4 = {}

	for slot8, slot9 in pairs(slot0.data) do
		if slot9.groupId == slot3 or (slot9:isTestShip() and slot9:canUseTestShip(slot2)) then
			table.insert(slot4, slot9)
		end
	end

	return slot4
end

slot0.getBayPower = function (slot0)
	slot1 = {}
	slot2 = 0

	for slot6, slot7 in pairs(slot0.data) do
		slot8 = slot7.configId
		slot9 = slot7:getShipCombatPower()

		if defaultValue(slot0.handbookTypeAssign[slot7:getGroupId()], 0) ~= 1 and (not slot1[slot8] or slot1[slot8] < slot9) then
			slot1[slot8] = slot9
			slot2 = slot2 - defaultValue(slot1[slot8], 0) + slot9
		end
	end

	return slot2
end

slot0.getBayPowerRooted = function (slot0)
	return slot0:getBayPower()^0.667
end

slot0.getEquipsInShips = function (slot0, slot1, slot2)
	function slot3(slot0, slot1, slot2)
		slot0.shipId = slot1
		slot0.shipPos = slot2

		return slot0
	end

	slot4 = {}

	for slot8, slot9 in pairs(slot0.data) do
		if not slot1 or slot1.id ~= slot9.id then
			for slot13, slot14 in pairs(slot9.equipments) do
				if slot14 and (not slot1 or not slot2 or not slot1.isForbiddenAtPos(slot1, slot14, slot2)) then
					table.insert(slot4, slot3(Clone(slot14), slot9.id, slot13))
				end
			end
		end
	end

	return slot4
end

slot0.GetEquipsInShipsRaw = function (slot0)
	function slot1(slot0, slot1, slot2)
		slot3 = CreateShell(slot0)
		slot3.shipId = slot1
		slot3.shipPos = slot2

		return slot3
	end

	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		for slot11, slot12 in pairs(slot7.equipments) do
			if slot12 then
				table.insert(slot2, slot1(slot12, slot7.id, slot11))
			end
		end
	end

	return slot2
end

slot0.getEquipmentSkinInShips = function (slot0, slot1, slot2)
	function slot3(slot0)
		slot1 = false

		if slot0 and slot0 > 0 then
			slot3 = _.any(pg.equip_skin_template[slot0].equip_type, function (slot0)
				return not slot0 or table.contains(slot0, slot0)
			end)
			slot1 = slot3
		end

		return slot1
	end

	slot4 = {}

	for slot8, slot9 in pairs(slot0.data) do
		if not slot1 or slot1.id ~= slot9.id then
			for slot13, slot14 in pairs(slot9.getEquipSkins(slot9)) do
				slot15 = slot3(slot14)

				if slot14 and slot15 then
					table.insert(slot4, {
						id = slot14,
						shipId = slot9.id,
						shipPos = slot13
					})
				end
			end
		end
	end

	return slot4
end

slot0.setSelectShipId = function (slot0, slot1)
	slot0.selectShipId = slot1
end

slot0.getProposeGroupList = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.data) do
		if slot6.propose then
			slot1[slot6.groupId] = true
		end
	end

	return slot1
end

slot0.getEliteRecommendShip = function (slot0, slot1, slot2, slot3)
	slot5 = {}

	for slot9, slot10 in ipairs(slot4) do
		slot5[slot10] = slot10:getShipCombatPower()
	end

	table.sort(slot4, function (slot0, slot1)
		return slot0[slot0] < slot0[slot1]
	end)

	slot6 = {}

	for slot10, slot11 in ipairs(slot2) do
		slot6[#slot6 + 1] = slot0.data[slot11]:getGroupId()
	end

	slot7 = #slot4
	slot8 = nil

	while slot7 > 0 do
		slot11 = slot4[slot7].getGroupId(slot9)

		if not table.contains(slot2, slot4[slot7].id) and not table.contains(slot6, slot11) and ShipStatus.ShipStatusCheck("inElite", slot9, nil, {
			inElite = slot3
		}) then
			slot8 = slot9

			break
		else
			slot7 = slot7 - 1
		end
	end

	return slot8
end

slot0.getChallengeRecommendShip = function (slot0, slot1, slot2, slot3)
	table.sort(slot4, function (slot0, slot1)
		return slot0:getShipCombatPower() < slot1:getShipCombatPower()
	end)

	slot5 = {}
	slot6 = {}

	for slot10, slot11 in ipairs(slot2) do
		slot5[#slot5 + 1] = slot0.data[slot11].getGroupId(slot12)

		if slot6[Challenge.shipTypeFixer(slot0.data[slot11]:getShipType())] == nil then
			slot6[slot13] = 0
		end

		slot6[slot13] = slot6[slot13] + 1
	end

	slot7 = #slot4
	slot8 = nil

	while slot7 > 0 do
		slot10 = slot4[slot7].id
		slot11 = slot4[slot7].getGroupId(slot9)

		if slot6[Challenge.shipTypeFixer(slot4[slot7]:getShipType())] == nil then
			slot6[slot12] = 0
		end

		if slot6[slot12] < Challenge.SAME_TYPE_LIMIT and not table.contains(slot2, slot10) and not table.contains(slot5, slot11) and ShipStatus.ShipStatusCheck("inActivity", slot9, nil, {
			inActivity = slot3
		}) then
			slot8 = slot9

			break
		else
			slot7 = slot7 - 1
		end
	end

	return slot8
end

slot0.getActivityRecommendShips = function (slot0, slot1, slot2, slot3, slot4)
	slot6 = {}

	for slot10, slot11 in ipairs(slot5) do
		slot6[slot11] = slot11:getShipCombatPower()
	end

	table.sort(slot5, function (slot0, slot1)
		return slot0[slot0] < slot0[slot1]
	end)

	slot7 = {}

	for slot11, slot12 in ipairs(slot2) do
		slot7[#slot7 + 1] = slot0.data[slot12]:getGroupId()
	end

	slot8 = #slot5
	slot9 = {}

	while slot8 > 0 and slot3 > 0 do
		slot12 = slot5[slot8].getGroupId(slot10)

		if not table.contains(slot2, slot5[slot8].id) and not table.contains(slot7, slot12) and ShipStatus.ShipStatusCheck("inActivity", slot10, nil, {
			inActivity = slot4
		}) then
			table.insert(slot9, slot10)
			table.insert(slot7, slot12)

			slot3 = slot3 - 1
		end

		slot8 = slot8 - 1
	end

	return slot9
end

slot0.getDelegationRecommendShips = function (slot0, slot1)
	slot2 = 6 - #slot1.shipIds
	slot4 = math.max(slot1.template.ship_lv, 2)
	slot5 = Clone(slot1.shipIds)

	table.sort(slot6, function (slot0, slot1)
		return slot1.level < slot0.level
	end)

	slot7 = {}
	slot8 = false

	for slot12, slot13 in ipairs(slot5) do
		if slot4 <= slot0.data[slot13].level then
			slot8 = true
		end

		slot7[#slot7 + 1] = slot14:getGroupId()
	end

	if slot8 then
		slot4 = 2
	end

	slot9 = {}
	slot10 = #slot6

	while slot10 > 0 do
		if slot2 <= 0 then
			break
		end

		slot12 = slot6[slot10].id
		slot13 = slot6[slot10].getGroupId(slot11)

		if slot4 <= slot6[slot10].level and slot11.lockState ~= Ship.LOCK_STATE_UNLOCK and not table.contains(slot5, slot12) and not table.contains(slot7, slot13) and not table.contains(slot9, slot12) and not slot11:getFlag("inElite") and ShipStatus.ShipStatusCheck("inEvent", slot11) then
			table.insert(slot7, slot13)
			table.insert(slot9, slot12)

			slot2 = slot2 - 1

			if slot8 == false then
				slot8 = true
				slot4 = 2
				slot10 = #slot6
				slot10 = slot10 - 1
			end
		end
	end

	return slot9
end

slot0.getWorldRecommendShip = function (slot0, slot1, slot2)
	slot4 = {}

	for slot8, slot9 in ipairs(slot3) do
		slot4[slot9] = slot9:getShipCombatPower()
	end

	table.sort(slot3, function (slot0, slot1)
		return slot0[slot0] < slot0[slot1]
	end)

	slot5 = {}

	for slot9, slot10 in ipairs(slot2) do
		slot5[#slot5 + 1] = slot0.data[slot10]:getGroupId()
	end

	slot6 = #slot3
	slot7 = nil

	while slot6 > 0 do
		slot10 = slot3[slot6].getGroupId(slot8)

		if not table.contains(slot2, slot3[slot6].id) and not table.contains(slot5, slot10) and ShipStatus.ShipStatusCheck("inWorld", slot8) then
			slot7 = slot8

			break
		else
			slot6 = slot6 - 1
		end
	end

	return slot7
end

slot0.getModRecommendShip = function (slot0, slot1, slot2)
	slot3 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_2, underscore.keys(slot0.data))

	function slot4(slot0)
		return slot0.level == 1 and slot0:getRarity() <= ShipRarity.Gray and slot0:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(slot0, slot0.id) and slot1.id ~= slot0.id and not table.contains(slot2, slot0.id)
	end

	slot5 = {}

	for slot9, slot10 in pairs(slot0.data) do
		if slot4(slot10) then
			table.insert(slot5, slot10)
		end
	end

	slot8 = pg.ship_data_by_type[slot1:getConfig("type")].strengthen_choose_type
	slot9 = {
		function (slot0)
			return (not slot0:isSameKind(slot0) or 0) and 1
		end,
		function (slot0)
			return table.indexof(slot0, slot0:getConfig("type"))
		end
	}

	table.sort(slot5, function (slot0, slot1)
		return CompareFuncs(slot0, slot1, slot0)
	end)

	slot10 = {}

	for slot14, slot15 in pairs(slot2) do
		table.insert(slot10, slot0.data[slot15])
	end

	for slot14, slot15 in ipairs(slot5) do
		if #slot10 == 12 then
			break
		end

		for slot21, slot22 in pairs(slot17) do
			slot16:addModAttrExp(slot21, slot22)
		end

		slot19 = {}

		for slot23, slot24 in pairs(slot18) do
			if slot24 > 0 then
				table.insert(slot19, {
					attrName = slot23,
					value = slot24
				})
			end
		end

		if not underscore.all(slot19, function (slot0)
			return slot0:leftModAdditionPoint(slot0.attrName) == 0
		end) then
			table.insert(slot10, slot15)
		end
	end

	return underscore.map(slot10, function (slot0)
		return slot0.id
	end)
end

slot0.getUpgradeRecommendShip = function (slot0, slot1, slot2, slot3)
	slot4 = slot0:getUpgradeShips(slot1)
	slot5 = pg.ShipFlagMgr.GetInstance():FilterShips(ShipStatus.FILTER_SHIPS_FLAGS_4, underscore.keys(slot0.data))

	function slot6(slot0)
		return slot0.level == 1 and slot0:GetLockState() ~= Ship.LOCK_STATE_LOCK and not table.contains(slot0, slot0.id) and slot1.id ~= slot0.id and not table.contains(slot2, slot0.id)
	end

	slot7 = {}

	for slot11, slot12 in ipairs(slot4) do
		if slot6(slot12) then
			table.insert(slot7, slot12)
		end
	end

	slot8 = {
		function (slot0)
			return (not slot0:isSameKind(slot0) or 0) and 1
		end
	}

	table.sort(slot7, function (slot0, slot1)
		return CompareFuncs(slot0, slot1, slot0)
	end)

	slot9 = {}

	for slot13, slot14 in pairs(slot2) do
		table.insert(slot9, slot0.data[slot14])
	end

	for slot13, slot14 in ipairs(slot7) do
		if #slot9 == slot3 then
			break
		end

		table.insert(slot9, slot14)
	end

	return underscore.map(slot9, function (slot0)
		return slot0.id
	end)
end

return slot0

slot0 = class("TechnologyProxy", import(".NetProxy"))
slot0.TECHNOLOGY_ADDED = "TechnologyProxy:TECHNOLOGY_ADDED"
slot0.TECHNOLOGY_UPDATED = "TechnologyProxy:TECHNOLOGY_UPDATED"
slot0.BLUEPRINT_ADDED = "TechnologyProxy:BLUEPRINT_ADDED"
slot0.BLUEPRINT_UPDATED = "TechnologyProxy:BLUEPRINT_UPDATED"
slot0.REFRESH_UPDATED = "TechnologyProxy:REFRESH_UPDATED"

slot0.register = function (slot0)
	slot0.tendency = {}

	slot0:on(63000, function (slot0)
		slot0:updateTechnologys(slot0)

		slot0.refreshTechnologysFlag = slot0.refresh_flag or 0

		slot0:updateTecCatchup(slot0)
	end)

	slot0.bluePrintData = {}
	slot0.item2blueprint = {}
	slot0.maxConfigVersion = 0

	_.each(pg.ship_data_blueprint.all, function (slot0)
		slot1 = ShipBluePrint.New({
			id = slot0,
			version = pg.ship_data_blueprint[slot0].blueprint_version
		})
		slot0.maxConfigVersion = math.max(slot0.maxConfigVersion, slot1.version)
		slot0.bluePrintData[slot1.id] = slot1
		slot0.item2blueprint[slot1:getItemId()] = slot1.id
	end)
	slot0.on(slot0, 63100, function (slot0)
		for slot4, slot5 in ipairs(slot0.blueprint_list) do
			slot0.bluePrintData[slot5.id]:updateInfo(slot5)
		end

		slot0.coldTime = slot0.cold_time or 0
		slot0.pursuingTimes = slot0.daily_catchup_strengthen or 0
	end)
end

slot0.setVersion = function (slot0, slot1)
	PlayerPrefs.SetInt("technology_version", slot1)
	PlayerPrefs.Save()
end

slot0.getVersion = function (slot0)
	if not PlayerPrefs.HasKey("technology_version") then
		slot0:setVersion(1)

		return 1
	else
		return PlayerPrefs.GetInt("technology_version")
	end
end

slot0.getConfigMaxVersion = function (slot0)
	return slot0.maxConfigVersion
end

slot0.setTendency = function (slot0, slot1, slot2)
	slot0.tendency[slot1] = slot2
end

slot0.getTendency = function (slot0, slot1)
	return slot0.tendency[slot1]
end

slot0.updateBlueprintStates = function (slot0)
	slot1 = pairs
	slot2 = slot0.bluePrintData or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:updateState()
	end
end

slot0.getColdTime = function (slot0)
	return slot0.coldTime
end

slot0.updateColdTime = function (slot0)
	slot0.coldTime = pg.TimeMgr.GetInstance():GetServerTime() + 86400
end

slot0.updateRefreshFlag = function (slot0, slot1)
	slot0.refreshTechnologysFlag = slot1

	slot0:sendNotification(slot0.REFRESH_UPDATED, slot0.refreshTechnologysFlag)
end

slot0.updateTechnologys = function (slot0, slot1)
	slot0.data = {}

	for slot5, slot6 in ipairs(slot1.refresh_list) do
		slot0.tendency[slot6.id] = slot6.target

		for slot10, slot11 in ipairs(slot6.technologys) do
			slot0:addTechnology(Technology.New({
				id = slot11.id,
				time = slot11.time,
				pool_id = slot6.id
			}))
		end
	end
end

slot0.updateTecCatchup = function (slot0, slot1)
	slot0.curCatchupTecID = slot1.catchup.version
	slot0.curCatchupGroupID = slot1.catchup.target
	slot0.catchupData = {}

	for slot5, slot6 in ipairs(slot1.catchup.pursuings) do
		slot0.catchupData[TechnologyCatchup.New(slot6).id] = TechnologyCatchup.New(slot6)
	end

	slot0.curCatchupPrintsNum = slot0:getCurCatchNum()

	print("?????????????????????????????????", slot0.curCatchupTecID, slot0.curCatchupGroupID, slot0.curCatchupPrintsNum)
end

slot0.getActiveTechnologyCount = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.data) do
		if slot6:isStart() then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot0.getActiveTechnology = function (slot0)
	slot1 = pairs
	slot2 = slot0.data or {}

	for slot4, slot5 in slot1(slot2) do
		if slot5:isStart() then
			return Clone(slot5)
		end
	end
end

slot0.getTechnologyById = function (slot0, slot1)
	return slot0.data[slot1]:clone()
end

slot0.addTechnology = function (slot0, slot1)
	slot0.data[slot1.id] = slot1

	slot0:sendNotification(slot0.TECHNOLOGY_ADDED, slot1:clone())
end

slot0.updateTechnology = function (slot0, slot1)
	slot0.data[slot1.id] = slot1

	slot0:sendNotification(slot0.TECHNOLOGY_UPDATED, slot1:clone())
end

slot0.getTechnologys = function (slot0)
	slot1 = {}
	slot2 = pairs
	slot3 = slot0.data or {}

	for slot5, slot6 in slot2(slot3) do
		table.insert(slot1, slot6)
	end

	return slot1
end

slot0.getBluePrints = function (slot0)
	return Clone(slot0.bluePrintData)
end

slot0.getBluePrintById = function (slot0, slot1)
	return Clone(slot0.bluePrintData[slot1])
end

slot0.getRawBluePrintById = function (slot0, slot1)
	return slot0.bluePrintData[slot1]
end

slot0.addBluePrint = function (slot0, slot1)
	slot0.bluePrintData[slot1.id] = slot1

	slot0:sendNotification(slot0.BLUEPRINT_ADDED, slot1:clone())
end

slot0.updateBluePrint = function (slot0, slot1)
	slot0.bluePrintData[slot1.id] = slot1

	slot0:sendNotification(slot0.BLUEPRINT_UPDATED, slot1:clone())
end

slot0.getBuildingBluePrint = function (slot0)
	for slot4, slot5 in pairs(slot0.bluePrintData) do
		if slot5:isDeving() or slot5:isFinished() then
			return slot5
		end
	end
end

slot0.GetBlueprint4Item = function (slot0, slot1)
	return slot0.item2blueprint[slot1]
end

slot0.getCatchupData = function (slot0, slot1)
	if not slot0.catchupData[slot1] then
		slot0.catchupData[slot1] = TechnologyCatchup.New({
			version = slot1
		})
	end

	return slot0.catchupData[slot1]
end

slot0.updateCatchupData = function (slot0, slot1, slot2, slot3)
	slot0.catchupData[slot1]:addTargetNum(slot2, slot3)
end

slot0.getCurCatchNum = function (slot0)
	if slot0.curCatchupTecID ~= 0 and slot0.curCatchupGroupID ~= 0 then
		return slot0.catchupData[slot0.curCatchupTecID]:getTargetNum(slot0.curCatchupGroupID)
	else
		return 0
	end
end

slot0.getCatchupState = function (slot0, slot1)
	if not slot0.catchupData[slot1] then
		return TechnologyCatchup.STATE_UNSELECT
	end

	return slot0.catchupData[slot1]:getState()
end

slot0.updateCatchupStates = function (slot0)
	for slot4, slot5 in ipairs(slot0.catchupData) do
		slot5:updateState()
	end
end

slot0.isOpenTargetCatchup = function (slot0)
	return pg.technology_catchup_template ~= nil and #pg.technology_catchup_template.all > 0
end

slot0.getNewestCatchupTecID = function (slot0)
	return math.max(unpack(pg.technology_catchup_template.all))
end

slot0.isOnCatchup = function (slot0)
	return slot0.curCatchupTecID ~= 0 and slot0.curCatchupGroupID ~= 0
end

slot0.getBluePrintVOByGroupID = function (slot0, slot1)
	return slot0.bluePrintData[slot1]
end

slot0.getCurCatchupTecInfo = function (slot0)
	return {
		tecID = slot0.curCatchupTecID,
		groupID = slot0.curCatchupGroupID,
		printNum = slot0.curCatchupPrintsNum
	}
end

slot0.setCurCatchupTecInfo = function (slot0, slot1, slot2)
	slot0.curCatchupTecID = slot1
	slot0.curCatchupGroupID = slot2
	slot0.curCatchupPrintsNum = slot0:getCurCatchNum()

	slot0:updateCatchupStates()
	print("??????????????????????????????", slot0.curCatchupTecID, slot0.curCatchupGroupID, slot0.curCatchupPrintsNum)
end

slot0.addCatupPrintsNum = function (slot0, slot1)
	slot0:updateCatchupData(slot0.curCatchupTecID, slot0.curCatchupGroupID, slot1)

	slot0.curCatchupPrintsNum = slot0:getCurCatchNum()

	print("??????????????????", slot1, slot0.curCatchupPrintsNum)
end

slot0.IsShowTip = function (slot0)
	slot3, slot4 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

	return (OPEN_TEC_TREE_SYSTEM and getProxy(TechnologyNationProxy):getShowRedPointTag()) or ((SelectTechnologyMediator.onBlueprintNotify() or SelectTechnologyMediator.onTechnologyNotify()) and slot3)
end

slot0.addPursuingTimes = function (slot0, slot1)
	slot0.pursuingTimes = slot0.pursuingTimes + slot1
end

slot0.resetPursuingTimes = function (slot0)
	slot0.pursuingTimes = 0

	slot0:sendNotification(GAME.PURSUING_RESET_DONE)
end

slot0.calcMaxPursuingCount = function (slot0, slot1)
	slot3 = getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold)
	slot4 = 0

	function slot5(slot0)
		slot1 = #slot0

		while slot0 < slot0[slot1][1] do
			slot1 = slot1 - 1
		end

		return slot0[slot1][2]
	end

	slot6 = nil

	for slot10 = slot0.pursuingTimes + 1, pg.gameset.blueprint_pursue_discount_ssr.description[#pg.gameset.blueprint_pursue_discount_ssr.description][1] - 1, 1 do
		if slot3 < slot1.getPursuingPrice(slot1, slot5(slot10)) then
			return slot4
		else
			slot3 = slot3 - slot6
			slot4 = slot4 + 1
		end
	end

	return slot4 + math.floor(slot3 / slot1:getPursuingPrice())
end

slot0.calcPursuingCost = function (slot0, slot1, slot2)
	slot4 = 0

	function slot5(slot0)
		slot1 = #slot0

		while slot0 < slot0[slot1][1] do
			slot1 = slot1 - 1
		end

		return slot0[slot1][2]
	end

	slot6 = nil

	for slot10 = slot0.pursuingTimes + 1, pg.gameset.blueprint_pursue_discount_ssr.description[#pg.gameset.blueprint_pursue_discount_ssr.description][1] - 1, 1 do
		slot6 = slot1.getPursuingPrice(slot1, slot5(slot10))

		if slot2 == 0 then
			return slot4
		else
			slot4 = slot4 + slot6
			slot2 = slot2 - 1
		end
	end

	return slot4 + slot2 * slot1:getPursuingPrice()
end

slot0.getPursuingDiscount = function (slot0)
	slot2 = #pg.gameset.blueprint_pursue_discount_ssr.description

	while slot0 < slot1[slot2][1] do
		slot2 = slot2 - 1
	end

	return slot1[slot2][2]
end

return slot0

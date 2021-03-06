slot0 = class("BuildShipProxy", import(".NetProxy"))
slot0.ADDED = "BuildShipProxy ADDED"
slot0.TIMEUP = "BuildShipProxy TIMEUP"
slot0.UPDATED = "BuildShipProxy UPDATED"
slot0.REMOVED = "BuildShipProxy REMOVED"
slot0.DRAW_COUNT_UPDATE = "BuildShipProxy DRAW_COUNT_UPDATE"
slot0.EXCHANGE_SHIP_UPDATED = "BuildShipProxy EXCHANGE_SHIP_UPDATED"
slot0.EXCHANGE_LIST_UPDATED = "BuildShipProxy EXCHANGE_LIST_UPDATED"
slot0.EXCHANGE_ITEM_LIST_UPDATED = "BuildShipProxy EXCHANGE_ITEM_LIST_UPDATED"
slot0.EXCHANGE_ITEM_STATE_UPDATED = "BuildShipProxy EXCHANGE_ITEM_STATE_UPDATED"

slot0.register = function (slot0)
	slot0:on(12024, function (slot0)
		slot0.data = {}
		slot0.workCount = slot0.worklist_count
		slot0.drawCount1 = slot0.draw_count_1
		slot0.drawCount10 = slot0.draw_count_10

		for slot4, slot5 in ipairs(slot0.worklist_list) do
			slot6 = BuildShip.New(slot5)

			slot6:setId(slot4)
			table.insert(slot0.data, slot6)
		end

		slot0:setBuildShipState()
	end)
end

slot0.updateExchangeList = function (slot0, slot1, slot2, slot3)
	slot0.exchangeFlagShipFlashTime = slot1
	slot0.exchangeFlashTime = slot2
	slot0.exchangeList = slot3

	slot0:sendNotification(slot0.EXCHANGE_LIST_UPDATED, {
		exchangeList = Clone(slot0.exchangeList),
		flashTime = slot2,
		flagShipFlashTime = slot1
	})
end

slot0.updateExchangeItemList = function (slot0, slot1, slot2)
	slot0.nextRefreshItemTime = slot1
	slot0.exchangeItemList = slot2

	slot0:sendNotification(slot0.EXCHANGE_ITEM_LIST_UPDATED, {
		flashTime = slot0.nextRefreshItemTime,
		exchangeItemList = slot2
	})
	slot0:addExChangeItemTimer()
end

slot0.addExChangeItemTimer = function (slot0)
	if slot0.exchangeItemTimer then
		slot0.exchangeItemTimer:Stop()

		slot0.exchangeItemTimer = nil
	end

	if slot0.nextRefreshItemTime - pg.TimeMgr.GetInstance():GetServerTime() + 1 > 0 then
		slot0.exchangeItemTimer = Timer.New(function ()
			slot0.exchangeItemTimer:Stop()

			slot0.exchangeItemTimer.Stop.exchangeItemTimer = nil

			slot0.exchangeItemTimer.Stop:sendNotification(GAME.GET_EXCHANGE_ITEMS, {
				type = 1
			})
		end, slot1, 1)

		slot0.exchangeItemTimer:Start()
	else
		slot0:sendNotification(GAME.GET_EXCHANGE_ITEMS, {
			type = 1
		})
	end
end

slot0.getExChangeItemInfo = function (slot0)
	return slot0.exchangeItemList, slot0.nextRefreshItemTime
end

slot0.getExChangeItemInfoByIndex = function (slot0, slot1)
	if slot0.exchangeItemList then
		return slot0.exchangeItemList[slot1]
	end
end

slot0.updateExchangeItem = function (slot0, slot1)
	if slot0.exchangeItemList then
		slot0.exchangeItemList[slot1].isFetched = true

		slot0:sendNotification(slot0.EXCHANGE_ITEM_STATE_UPDATED, slot1)
	end
end

slot0.getFlagShipFlashTime = function (slot0)
	return slot0.exchangeFlagShipFlashTime
end

slot0.getExchangeList = function (slot0)
	return Clone(slot0.exchangeList)
end

slot0.getExchangeFlashTime = function (slot0)
	return slot0.exchangeFlashTime
end

slot0.getExchangeShipByIndex = function (slot0, slot1)
	return Clone(slot0.exchangeList[slot1])
end

slot0.updateExchangeShip = function (slot0, slot1, slot2)
	slot0.exchangeList[slot1] = slot2

	slot0:sendNotification(slot0.EXCHANGE_SHIP_UPDATED, {
		index = slot1,
		exchangeShip = Clone(slot2)
	})
end

slot0.setBuildShipState = function (slot0)
	slot0:removeBuildTimer()

	slot0.buildIndex = 0
	slot0.buildTimers = {}
	slot1 = 0
	slot2 = ipairs
	slot3 = slot0.data or {}

	for slot5, slot6 in slot2(slot3) do
		if slot1 == slot0:getMaxWorkCount() then
			break
		end

		if not slot6:isFinish() then
			slot0.buildIndex = slot5
			slot1 = slot1 + 1

			slot0:addBuildTimer()
		end

		slot6.state = (slot6:isFinish() and BuildShip.FINISH) or BuildShip.ACTIVE
	end
end

slot0.getNextBuildShip = function (slot0)
	slot1 = nil

	if slot0.data[slot0.buildIndex + 1] and slot2.state == BuildShip.INACTIVE then
		slot0.buildIndex = slot0.buildIndex + 1
		slot1 = slot2
	end

	return slot1
end

slot0.activeNextBuild = function (slot0)
	if slot0:getNextBuildShip() then
		slot1:active()
		slot0:updateBuildShip(slot0.buildIndex, slot1)
		slot0:addBuildTimer()
	end
end

slot0.addBuildTimer = function (slot0)
	if slot0.buildTimers[slot0.buildIndex] then
		slot0.buildTimers[slot1]:Stop()

		slot0.buildTimers[slot1] = nil
	end

	function slot2()
		slot0:activeNextBuild()
		slot0.activeNextBuild.data[slot0]:finish()
		slot0.activeNextBuild.data[slot0].finish.data[slot0.activeNextBuild.data[slot0]]:display("- build finish -")
		slot0.activeNextBuild.data[slot0].finish.data[slot0.activeNextBuild.data[slot0]].display:updateBuildShip(slot0.activeNextBuild.data[slot0].finish.data[slot0.activeNextBuild.data[slot0]].display, slot0.data[slot0.activeNextBuild.data[slot0].finish.data[slot0.activeNextBuild.data[slot0]].display])
	end

	if slot0.data[slot1].finishTime - pg.TimeMgr.GetInstance().GetServerTime(slot4) > 0 then
		slot0.buildTimers[slot1] = Timer.New(function ()
			slot0.buildTimers[slot1]:Stop()

			slot0.buildTimers[slot1].Stop.buildTimers[slot0.buildTimers[slot1]] = nil

			nil()
		end, slot3, 1)

		slot0.buildTimers[slot1]:Start()
	else
		slot2()
	end
end

slot0.getMaxWorkCount = function (slot0)
	return slot0.workCount
end

slot0.getBuildShipCount = function (slot0)
	return table.getCount(slot0.data)
end

slot0.removeBuildTimer = function (slot0)
	slot1 = pairs
	slot2 = slot0.buildTimers or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:Stop()
	end

	slot0.buildTimers = nil
end

slot0.remove = function (slot0)
	slot0:removeBuildTimer()

	if slot0.exchangeItemTimer then
		slot0.exchangeItemTimer:Stop()

		slot0.exchangeItemTimer = nil
	end
end

slot0.getBuildShip = function (slot0, slot1)
	return Clone(slot0.data[slot1])
end

slot0.getFinishCount = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.data) do
		if slot6.state == BuildShip.FINISH then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot0.getNeedFinishCount = function (slot0)
	return table.getCount(slot0.data) - slot0:getFinishCount()
end

slot0.getActiveCount = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.data) do
		if slot6.state == BuildShip.ACTIVE then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot0.getFinishedIndex = function (slot0)
	for slot4, slot5 in ipairs(slot0.data) do
		if slot5.state == BuildShip.FINISH then
			return slot4
		end
	end
end

slot0.canBuildShip = function (slot0, slot1)
	slot2 = slot0:getActiveCount()

	if getProxy(BagProxy):getItemById(pg.ship_data_create_material[slot1].use_item) and slot3.number_1 <= slot5.count then
		return slot3.use_gold <= getProxy(PlayerProxy).getData(slot6).gold and slot2 == 0
	end
end

slot0.getActiveOrFinishedCount = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.data) do
		if slot6.state == BuildShip.ACTIVE or slot6.state == BuildShip.FINISH then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot0.getDrawCount = function (slot0)
	return {
		drawCount1 = slot0.drawCount1,
		drawCount10 = slot0.drawCount10
	}
end

slot0.increaseDrawCount = function (slot0, slot1)
	if slot1 == 1 then
		slot0.drawCount1 = slot0.drawCount1 + 1
	elseif slot1 == 10 then
		slot0.drawCount10 = slot0.drawCount10 + 1
	end

	slot0.facade:sendNotification(slot0.DRAW_COUNT_UPDATE, slot0:getDrawCount())
end

slot0.addBuildShip = function (slot0, slot1)
	table.insert(slot0.data, slot1)

	if slot0:getActiveCount() < slot0:getMaxWorkCount() then
		slot1:setState(BuildShip.ACTIVE)

		slot0.buildIndex = #slot0.data

		slot0:addBuildTimer()
	elseif slot2 == slot3 then
		slot1:setState(BuildShip.INACTIVE)
	end

	slot0.facade:sendNotification(slot0.ADDED, slot1:clone())
end

slot0.finishBuildShip = function (slot0, slot1)
	if slot0.buildTimers[slot1] then
		slot0.buildTimers[slot1].func()
	end
end

slot0.updateBuildShip = function (slot0, slot1, slot2)
	slot0.data[slot1] = slot2:clone()

	slot0.facade:sendNotification(slot0.UPDATED, {
		index = slot1,
		buildShip = slot2:clone()
	})
end

slot0.removeBuildShipByIndex = function (slot0, slot1)
	slot0.lastPoolType = slot0.data[slot1].type

	table.remove(slot0.data, slot1)
	slot0.facade:sendNotification(slot0.REMOVED, {
		index = slot1,
		buildShip = slot0.data[slot1]:clone()
	})
end

slot0.getSkipBatchBuildFlag = function (slot0)
	return slot0.skipBatchFlag or false
end

slot0.setSkipBatchBuildFlag = function (slot0, slot1)
	slot0.skipBatchFlag = slot1
end

slot0.getLastBuildShipPoolType = function (slot0)
	return slot0.lastPoolType or 0
end

return slot0

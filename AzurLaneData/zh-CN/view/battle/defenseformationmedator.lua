slot0 = class("DefenseFormationMedator", import("..base.ContextMediator"))
slot0.OPEN_SHIP_INFO = "DefenseFormationMedator:OPEN_SHIP_INFO"
slot0.ON_CHANGE_FLEET = "DefenseFormationMedator:ON_CHANGE_FLEET"
slot0.CHANGE_FLEET_NAME = "DefenseFormationMedator:CHANGE_FLEET_NAME"
slot0.CHANGE_FLEET_SHIP = "DefenseFormationMedator:CHANGE_FLEET_SHIP"
slot0.REMOVE_SHIP = "DefenseFormationMedator:REMOVE_SHIP"
slot0.CHANGE_FLEET_FORMATION = "DefenseFormationMedator:CHANGE_FLEET_FORMATION"
slot0.CHANGE_FLEET_SHIPS_ORDER = "DefenseFormationMedator:CHANGE_FLEET_SHIPS_ORDER"
slot0.COMMIT_FLEET = "DefenseFormationMedator:COMMIT_FLEET"

slot0.register = function (slot0)
	slot1 = getProxy(BayProxy)

	slot1:setSelectShipId(nil)

	slot0.ships = slot1:getRawData()

	slot0.viewComponent:setShips(slot0.ships)

	slot5 = getProxy(FleetProxy).getFleetById(slot4, 1)

	slot0.viewComponent:SetFleet(slot3)
	slot0:bind(slot0.OPEN_SHIP_INFO, function (slot0, slot1, slot2, slot3)
		slot0.contextData.number = slot2.id
		slot0.contextData.toggle = slot3
		slot4 = {}

		for slot8, slot9 in ipairs(slot2:getShipIds()) do
			table.insert(slot4, slot0.ships[slot9])
		end

		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1,
			shipVOs = slot4
		})
	end)
	slot0.bind(slot0, slot0.COMMIT_FLEET, function (slot0, slot1)
		slot0:save(nil, slot1)
	end)
	slot0.bind(slot0, slot0.CHANGE_FLEET_SHIPS_ORDER, function (slot0, slot1)
		slot0:save(slot1)
		slot0:refreshView()
	end)
	slot0.bind(slot0, slot0.REMOVE_SHIP, function (slot0, slot1, slot2)
		slot2:removeShip(slot1)
		slot0:save(slot2)
		slot0:refreshView()
	end)
	slot0.bind(slot0, slot0.CHANGE_FLEET_SHIP, function (slot0, slot1, slot2)
		slot3 = (slot1 and slot1.id) or nil
		slot4 = slot0:getSeasonInfo()
		slot5 = slot4:getMainShipIds()
		slot6 = slot4:getVanguardShipIds()

		for slot11 = #pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true,
			inExercise = true
		}), 1, -1 do
			if slot7[slot11] == slot3 then
				table.remove(slot7, slot11)

				break
			end
		end

		slot14.onSelected, slot14.onShip = slot1.configDockYardFunc(slot1.ships, slot5, slot6, slot3, slot2, function (slot0, slot1)
			slot0:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
				fleet = slot0,
				callback = slot1
			})

			slot0 = nil
		end)

		slot1.sendNotification(slot10, GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			callbackQuit = true,
			quitTeam = slot1 ~= nil,
			teamFilter = slot2,
			ignoredIds = slot7,
			hideTagFlags = ShipStatus.TAG_HIDE_DEFENSE,
			leftTopInfo = i18n("word_formation"),
			onShip = slot9,
			onSelected = slot8
		})
	end)
end

slot0.refreshView = function (slot0, slot1)
	slot0.viewComponent:UpdateFleetView(slot1)
end

slot0.save = function (slot0, slot1, slot2)
	if slot1 then
		slot0:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
			fleet = slot1,
			callback = slot2
		})
	elseif slot2 then
		slot2()
	end
end

slot0.configDockYardFunc = function (slot0, slot1, slot2, slot3, slot4, slot5)
	function slot6(slot0, slot1)
		slot2 = {}

		function slot3(slot0)
			if not slot0 then
				for slot4, slot5 in ipairs(_.reverse(slot0)) do
					if not table.contains(slot1, slot5) then
						table.insert(slot1, 1, slot5)
					end
				end
			elseif slot0 and table.getCount(table.getCount) == 0 then
				for slot4, slot5 in ipairs(slot0) do
					if slot5 ~= slot0 and not table.contains(slot1, slot5) then
						table.insert(slot1, slot5)
					end
				end
			elseif slot0 then
				for slot4, slot5 in ipairs(slot0) do
					if slot5 == slot0 then
						slot0[slot4] = slot1[1]
					end
				end

				slot1 = slot0
			end
		end

		function slot4(slot0)
			if slot0 == TeamType.Main then
				slot1.mainShips = (slot0 and slot2) or slot3
				slot1.vanguardShips = slot4
			elseif slot0 == TeamType.Vanguard then
				slot1.mainShips = slot3
				slot1.vanguardShips = (slot0 and slot2) or slot4
			end

			if slot5 then
				slot5(slot5, slot6)
			end
		end

		if slot1 == TeamType.Main then
			slot3(slot2)
		elseif slot1 == TeamType.Vanguard then
			slot3(slot3)
		end

		if #slot0 > 0 then
			slot4(true)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function ()
					slot0(true)
				end,
				onNo = function ()
					slot0(false)
				end
			})
		end
	end

	return slot6, function (slot0, slot1, slot2)
		slot3 = pg.ship_data_template[slot0.configId].group_type

		function slot4(slot0)
			for slot4, slot5 in ipairs(slot0) do
				slot6 = pg.ship_data_template[slot0[slot5].configId].group_type

				if (not slot1 or slot1 ~= slot5 or slot6 ~= slot2) and slot6 == slot2 then
					return false
				end
			end

			return true
		end

		if slot2 == TeamType.Main then
			if not slot4(slot3) then
				return false, i18n("ship_vo_mainFleet_exist_same_ship")
			end
		elseif slot2 == TeamType.Vanguard and not slot4(slot4) then
			return false, i18n("ship_vo_vanguardFleet_exist_same_ship")
		end

		return true
	end
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.EXERCISE_FLEET_RESET
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if GAME.EXERCISE_FLEET_RESET == slot1:getName() then
		slot0.viewComponent:SetFleet(slot3)
		slot0.viewComponent:UpdateFleetView(true)
	end
end

return slot0

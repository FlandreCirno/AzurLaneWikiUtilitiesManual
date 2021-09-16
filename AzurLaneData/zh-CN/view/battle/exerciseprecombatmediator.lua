slot0 = class("ExercisePreCombatMediator", import("..base.ContextMediator"))
slot0.ON_START = "ExercisePreCombatMediator:ON_START"
slot0.ON_CHANGE_FLEET = "ExercisePreCombatMediator:ON_CHANGE_FLEET"
slot0.ON_COMMIT_EDIT = "ExercisePreCombatMediator:ON_COMMIT_EDIT"
slot0.OPEN_SHIP_INFO = "ExercisePreCombatMediator:OPEN_SHIP_INFO"
slot0.REMOVE_SHIP = "ExercisePreCombatMediator:REMOVE_SHIP"
slot0.CHANGE_FLEET_SHIPS_ORDER = "ExercisePreCombatMediator:CHANGE_FLEET_SHIPS_ORDER"
slot0.CHANGE_FLEET_SHIP = "ExercisePreCombatMediator:CHANGE_FLEET_SHIP"
slot0.ON_AUTO = "ExercisePreCombatMediator:ON_AUTO"
slot0.ON_SUB_AUTO = "ExercisePreCombatMediator:ON_SUB_AUTO"
slot0.GET_CHAPTER_DROP_SHIP_LIST = "ExercisePreCombatMediator:GET_CHAPTER_DROP_SHIP_LIST"

slot0.register = function (slot0)
	slot0:bind(slot0.GET_CHAPTER_DROP_SHIP_LIST, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.GET_CHAPTER_DROP_SHIP_LIST, {
			chapterId = slot1,
			callback = slot2
		})
	end)

	slot1 = getProxy(BayProxy)

	slot1.setSelectShipId(slot1, nil)

	slot0.ships = slot1:getRawData()

	slot0.viewComponent:SetShips(slot0.ships)

	slot3 = getProxy(FleetProxy)
	slot4 = nil

	if slot0.contextData.system == SYSTEM_HP_SHARE_ACT_BOSS or slot2 == SYSTEM_BOSS_EXPERIMENT or slot2 == SYSTEM_ACT_BOSS then
		slot4 = slot0.contextData.fleets
	else
		slot4 = slot3:getData()

		if slot0.contextData.EdittingFleet then
			slot3.EdittingFleet = slot0.contextData.EdittingFleet
			slot0.contextData.EdittingFleet = nil
		end

		if slot3.EdittingFleet ~= nil then
			slot4[slot3.EdittingFleet.id] = slot3.EdittingFleet
		end
	end

	slot0.viewComponent:SetFleets(slot4)
	slot0.viewComponent:SetPlayerInfo(getProxy(PlayerProxy).getData(slot5))

	if slot2 == SYSTEM_DUEL then
		slot0.viewComponent:SetCurrentFleet(FleetProxy.PVP_FLEET_ID)
	elseif slot2 == SYSTEM_HP_SHARE_ACT_BOSS or slot2 == SYSTEM_BOSS_EXPERIMENT or slot2 == SYSTEM_ACT_BOSS then
		slot0.viewComponent:SetCurrentFleet(slot4[1].id)

		for slot11, slot12 in ipairs(slot4) do
			if slot12:isSubmarineFleet() and slot12:isLegalToFight() then
				slot0.viewComponent:SetSubFlag(true)

				break
			end
		end

		if pg.activity_event_worldboss[getProxy(ActivityProxy).getActivityById(slot8, slot0.contextData.actID).getConfig(slot9, "config_id")] then
			slot0.viewComponent:SetTicketItemID(slot11.ticket)
		end
	elseif slot2 == SYSTEM_SUB_ROUTINE then
		slot0.viewComponent:SetStageID(slot0.contextData.stageId)
		slot0.viewComponent:SetCurrentFleet(slot0.contextData.fleetID)
	else
		slot0.viewComponent:SetStageID(slot0.contextData.stageId)
		slot0.viewComponent:SetCurrentFleet(slot5.combatFleetId)
	end

	slot0:bind(slot0.ON_CHANGE_FLEET, function (slot0, slot1)
		slot0:changeFleet(slot1)
	end)
	slot0.bind(slot0, slot0.ON_AUTO, function (slot0, slot1)
		slot0:onAutoBtn(slot1)
	end)
	slot0.bind(slot0, slot0.ON_SUB_AUTO, function (slot0, slot1)
		slot0:onAutoSubBtn(slot1)
	end)
	slot0.bind(slot0, slot0.CHANGE_FLEET_SHIPS_ORDER, function (slot0, slot1)
		slot0:refreshEdit(slot1)
	end)
	slot0.bind(slot0, slot0.REMOVE_SHIP, function (slot0, slot1, slot2)
		FormationMediator.removeShipFromFleet(slot2, slot1)
		slot0:refreshEdit(slot2)
	end)
	slot0.bind(slot0, slot0.OPEN_SHIP_INFO, function (slot0, slot1, slot2)
		slot0.contextData.form = ExercisePreCombatLayer.FORM_EDIT
		slot0.contextData.fleetID = slot2.id
		slot3 = {}

		for slot7, slot8 in ipairs(slot2:getShipIds()) do
			table.insert(slot3, slot0.ships[slot8])
		end

		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1,
			shipVOs = slot3
		})
	end)
	slot0.bind(slot0, slot0.CHANGE_FLEET_SHIP, function (slot0, slot1, slot2, slot3)
		slot0.contextData.form = ExercisePreCombatLayer.FORM_EDIT
		slot0.contextData.fleetID = slot2.id

		FormationMediator.saveEdit()

		slot5 = (slot1 == SYSTEM_DUEL and ShipStatus.TAG_HIDE_PVP) or ShipStatus.TAG_HIDE_NORMAL
		slot6 = (slot1 == SYSTEM_DUEL and ShipStatus.TAG_BLOCK_PVP) or nil
		slot7, slot8, slot9 = slot0:getDockCallbackFuncsForExercise(slot1, slot2, slot3)
		slot10 = {}

		for slot14, slot15 in ipairs(slot2.ships) do
			if not slot1 or slot15 ~= slot1.id then
				table.insert(slot10, slot15)
			end
		end

		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			energyDisplay = true,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			}),
			leastLimitMsg = i18n("battle_preCombatMediator_leastLimit"),
			quitTeam = slot1 ~= nil,
			teamFilter = slot3,
			onShip = slot7,
			confirmSelect = slot8,
			onSelected = slot9,
			hideTagFlags = slot5,
			blockTagFlags = slot6,
			otherSelectedIds = slot10
		})
	end)
	slot0.bind(slot0, slot0.ON_COMMIT_EDIT, function (slot0, slot1)
		slot0:commitEdit(slot1)
	end)
	slot0.bind(slot0, slot0.ON_START, function (slot0, slot1)
		function slot2()
			if slot0.contextData.customFleet then
				slot0.contextData.func()
			else
				slot0 = (not slot0.contextData.rivalId or slot0.contextData.rivalId) and slot0.contextData.stageId

				seriesAsync({
					function (slot0)
						if slot0.contextData.OnConfirm then
							slot0.contextData.OnConfirm(slot0)
						else
							slot0()
						end
					end,
					function ()
						slot0:sendNotification(GAME.BEGIN_STAGE, {
							stageId = slot1,
							mainFleetId = slot2,
							system = slot0.contextData.system,
							actID = slot0.contextData.actID,
							rivalId = slot0.contextData.rivalId
						})
					end
				})
			end
		end

		if slot1 == SYSTEM_DUEL then
			slot2()
		else
			slot3, slot4 = nil

			if slot1 == SYSTEM_HP_SHARE_ACT_BOSS or slot1 == SYSTEM_BOSS_EXPERIMENT or slot1 == SYSTEM_ACT_BOSS then
				slot3 = slot2[1]
				slot4 = "ship_energy_low_warn_no_exp"
			else
				slot3 = slot3:getFleetById(slot1)
			end

			slot5 = {}

			for slot9, slot10 in ipairs(slot3.ships) do
				table.insert(slot5, slot4:getShipById(slot10))
			end

			if slot3.name == "" or slot6 == nil then
				slot6 = Fleet.DEFAULT_NAME[slot1]
			end

			Fleet.EnergyCheck(slot5, slot6, function (slot0)
				if slot0 then
					slot0()
				end
			end, nil, slot4)
		end
	end)
end

slot0.changeFleet = function (slot0, slot1)
	if slot0.contextData.system ~= SYSTEM_SUB_ROUTINE then
		getProxy(PlayerProxy).combatFleetId = slot1
	end

	slot0.viewComponent:SetCurrentFleet(slot1)
	slot0.viewComponent:UpdateFleetView(true)
	slot0.viewComponent:SetFleetStepper()
end

slot0.refreshEdit = function (slot0, slot1)
	getProxy(FleetProxy).EdittingFleet = slot1

	if slot0.contextData.system ~= SYSTEM_SUB_ROUTINE then
		slot3 = nil
		(slot0.contextData.system ~= SYSTEM_HP_SHARE_ACT_BOSS or slot2:getActivityFleets()[slot0.contextData.actID]) and slot2:getData()[slot1.id] = slot1

		slot0.viewComponent:SetFleets((slot0.contextData.system ~= SYSTEM_HP_SHARE_ACT_BOSS or slot2.getActivityFleets()[slot0.contextData.actID]) and slot2.getData())
	end

	slot0.viewComponent:UpdateFleetView(false)
end

slot0.commitEdit = function (slot0, slot1)
	if getProxy(FleetProxy).EdittingFleet == nil or slot3:isFirstFleet() or slot3:isLegalToFight() == true then
		if slot0.contextData.system == SYSTEM_HP_SHARE_ACT_BOSS or slot0.contextData.system == SYSTEM_ACT_BOSS or slot0.contextData.system == SYSTEM_BOSS_EXPERIMENT then
			slot2:commitActivityFleet(slot0.contextData.actID)
			slot1()
		else
			slot2:commitEdittingFleet(slot1)
		end
	elseif #slot3.ships == 0 then
		slot2:commitEdittingFleet(slot1)

		if slot0.contextData.system == SYSTEM_SUB_ROUTINE then
		else
			slot0:changeFleet(1)
		end
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_formationMediaror_trash_warning", slot3.defaultName),
			onYes = function ()
				slot0 = getProxy(BayProxy)
				slot1 = slot0:getRawData()

				for slot6 = #slot0.ships, 1, -1 do
					slot0:removeShip(slot1[slot2[slot6]])
				end

				if slot0.id == FleetProxy.PVP_FLEET_ID then
					slot1:commitEdittingFleet()
					slot2:changeFleet(FleetProxy.PVP_FLEET_ID)
					slot2.viewComponent:swtichToPreviewMode()
				else
					slot1:commitEdittingFleet(slot1.commitEdittingFleet)
					slot2:changeFleet(1)
				end
			end
		})
	end
end

slot0.onAutoBtn = function (slot0, slot1)
	slot0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = slot1.isOn,
		toggle = slot1.toggle
	})
end

slot0.onAutoSubBtn = function (slot0, slot1)
	slot0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = slot1.isOn,
		toggle = slot1.toggle
	})
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.BEGIN_STAGE_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.BEGIN_STAGE_DONE then
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
	elseif slot2 == PlayerProxy.UPDATED then
		slot0.viewComponent:SetPlayerInfo(getProxy(PlayerProxy):getData())
	elseif slot2 == GAME.BEGIN_STAGE_ERRO and slot3 == 3 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("battle_preCombatMediator_timeout"),
			onYes = function ()
				slot0.viewComponent:emit(BaseUI.ON_CLOSE)
			end
		})
	end
end

slot0.getDockCallbackFuncsForExercise = function (slot0, slot1, slot2, slot3)
	slot4 = getProxy(FleetProxy)
	slot5 = getProxy(BayProxy)

	function slot6(slot0, slot1)
		slot2, slot3 = ShipStatus.ShipStatusCheck("inFleet", slot0, slot1)

		if not slot2 then
			return slot2, slot3
		end

		slot4, slot5 = FormationMediator.checkChangeShip(slot0, slot1, slot0)

		if not slot4 then
			return false, slot5
		end

		return true
	end

	return slot6, function (slot0, slot1, slot2)
		slot1()
	end, function (slot0)
		if (slot1:getShipPos(slot1.getShipPos) or -1) > 0 then
			slot1:removeShip(slot2)
		end

		if (slot1:getShipPos(slot1) or -1) > 0 then
			slot1:removeShip(slot1)
		end

		slot4 = {}

		if slot2 and slot3 > 0 then
			table.insert(slot4, {
				slot3,
				slot2
			})
		end

		if slot1 then
			table.insert(slot4, {
				slot2,
				slot1
			})
		end

		table.sort(slot4, function (slot0, slot1)
			return slot0[1] < slot1[1]
		end)

		for slot8, slot9 in ipairs(slot4) do
			slot1:insertShip(slot9[2], (slot9[1] > 0 and slot9[1]) or nil, slot3)
		end

		slot4.EdittingFleet = slot1
	end
end

return slot0

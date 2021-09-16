slot0 = class("WorldFleetSelectMediator", import("..base.ContextMediator"))
slot0.OnSelectShip = "WorldFleetSelectMediator.OnSelectShip"
slot0.OnGO = "WorldFleetSelectMediator.OnGO"
slot0.OnShipDetail = "WorldFleetSelectMediator.OnShipDetail"
slot0.OnSelectEliteCommander = "WorldFleetSelectMediator.OnSelectEliteCommander"
slot0.OnCommanderFormationOp = "WorldFleetSelectMediator.OnCommanderFormationOp"
slot0.OnCommanderSkill = "WorldFleetSelectMediator.OnCommanderSkill"

slot0.register = function (slot0)
	slot0:bind(slot0.OnSelectShip, function (slot0, slot1, slot2, slot3)
		slot4 = tobool(slot2[slot3])
		slot5 = {}

		for slot9, slot10 in pairs(slot0.contextData.fleets) do
			for slot14, slot15 in ipairs(slot10) do
				for slot19 = 1, 3, 1 do
					if slot15[slot1][slot19] then
						table.insert(slot5, slot15[slot1][slot19])
					end
				end
			end
		end

		slot13.onShip, slot13.confirmSelect, slot13.onSelected = slot0:GetDockCallbackFuncs(slot2, slot3, slot5)

		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = slot4,
			teamFilter = slot1,
			leftTopInfo = i18n("word_formation"),
			onShip = slot6,
			confirmSelect = slot7,
			onSelected = slot8,
			hideTagFlags = ShipStatus.TAG_HIDE_WORLD,
			otherSelectedIds = slot5
		})
	end)
	slot0.bind(slot0, slot0.OnGO, function (slot0)
		slot1 = nowWorld
		slot2 = slot0.contextData.fleets

		if slot0.contextData.mapId then
			slot0:sendNotification(GAME.WORLD_ACTIVATE, {
				id = slot0.contextData.mapId,
				enter_map_id = slot0.contextData.entranceId,
				elite_fleet_list = slot1:FormationIds2NetIds(slot2),
				camp = slot1:GetRealm()
			})
		else
			slot3 = {}

			if not slot1:CompareRedeploy(slot2) then
				table.insert(slot3, function (slot0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_redeploy_not_change"),
						onYes = slot0
					})
				end)
			end

			if #slot1.GetPortShips(slot1) > 0 then
				table.insert(slot3, function (slot0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("world_redeploy_warn"),
						onYes = slot0
					})
				end)
			end

			table.insert(slot3, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_redeploy_cost_tip", setColorStr(slot1, COLOR_GREEN), setColorStr(slot0.staminaMgr:GetTotalStamina(), (slot0:CalcOrderCost(WorldConst.OpReqRedeploy) <= slot0.staminaMgr.GetTotalStamina() and COLOR_GREEN) or COLOR_RED)),
					onYes = function ()
						if slot0.staminaMgr:GetTotalStamina() < slot0.staminaMgr then
							slot0.staminaMgr:Show()
						else
							slot2()
						end
					end
				})
			end)
			seriesAsync(slot3, function ()
				slot0:sendNotification(GAME.WORLD_FLEET_REDEPLOY, {
					elite_fleet_list = slot1:FormationIds2NetIds(GAME.WORLD_FLEET_REDEPLOY)
				})
			end)
		end
	end)
	slot0.bind(slot0, slot0.OnShipDetail, function (slot0, slot1)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1.shipId,
			shipVOs = slot1.shipVOs
		})
	end)
	slot0.bind(slot0, slot0.OnCommanderFormationOp, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnCommanderSkill, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = slot1
			}
		}))
	end)
	slot0.bind(slot0, slot0.OnSelectEliteCommander, function (slot0, slot1, slot2, slot3)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDROOM, {
			maxCount = 1,
			mode = CommandRoomScene.MODE_SELECT,
			fleetType = CommandRoomScene.FLEET_TYPE_WORLD,
			fleets = slot0.contextData.fleets,
			activeCommander = Fleet.New({
				ship_list = {},
				commanders = slot0.contextData.fleets[slot1][slot2].commanders
			}).getCommanders(slot5)[slot3],
			ignoredIds = {},
			onCommander = function (slot0)
				return true
			end,
			onSelected = function (slot0, slot1)
				slot4 = getProxy(CommanderProxy).getCommanderById(slot3, slot2)

				for slot8, slot9 in pairs(slot0.contextData.fleets) do
					for slot13, slot14 in ipairs(slot9) do
						if slot8 == slot1 and slot13 == slot2 then
							for slot18, slot19 in pairs(slot3) do
								if slot19.groupId == slot4.groupId and slot18 ~= slot4 then
									pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

									return
								end
							end
						else
							for slot18, slot19 in pairs(slot14.commanders) do
								if slot2 == slot19.id then
									pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

									return
								end
							end
						end
					end
				end

				slot5:updateCommanderByPos(slot4, slot4)

				slot5.commanders = slot5:outputCommanders()

				slot1()
			end,
			onQuit = function (slot0)
				slot0:updateCommanderByPos(slot0.updateCommanderByPos, nil)

				slot0.commanders = slot0:outputCommanders()

				slot0()
			end
		})

		slot0.contextData.editFleet = true
	end)
	slot0.viewComponent:setCommanderPrefabs(getProxy(CommanderProxy).getPrefabFleet(slot1))
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.WORLD_ACTIVATE_DONE,
		GAME.WORLD_FLEET_REDEPLOY_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE,
		GAME.COMMANDER_WORLD_FORMATION_OP_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.WORLD_ACTIVATE_DONE then
		if slot3.result == 0 then
			slot0:SetFleetSuccess()
		end
	elseif slot2 == GAME.WORLD_FLEET_REDEPLOY_DONE then
		slot0:SetFleetSuccess()
	elseif slot2 == CommanderProxy.PREFAB_FLEET_UPDATE then
		slot0.viewComponent:setCommanderPrefabs(getProxy(CommanderProxy):getPrefabFleet())
		slot0.viewComponent:updateCommanderPrefab()
	elseif slot2 == GAME.COMMANDER_WORLD_FORMATION_OP_DONE then
		slot0.viewComponent:UpdateFleets()
		slot0.viewComponent:updateCommanderFleet(slot3.fleet)
	end
end

slot0.GetDockCallbackFuncs = function (slot0, slot1, slot2, slot3)
	slot4 = getProxy(BayProxy)

	function slot5(slot0, slot1)
		slot2, slot3 = ShipStatus.ShipStatusCheck("inWorld", slot0, slot1)

		if not slot2 then
			return slot2, slot3
		end

		for slot7, slot8 in ipairs(slot0) do
			if slot0.id ~= slot8 and slot0:isSameKind(slot1:getShipById(slot8)) then
				return false, i18n("event_same_type_not_allowed")
			end
		end

		return true
	end

	return slot5, function (slot0, slot1, slot2)
		slot1()
	end, function (slot0)
		for slot4, slot5 in pairs(slot0.contextData.fleets) do
			for slot9, slot10 in ipairs(slot5) do
				for slot14, slot15 in pairs(slot10) do
					for slot19 = 3, 1, -1 do
						if slot1 == slot15 and slot19 == slot2 then
							slot15[slot19] = slot0[1]
						elseif slot15[slot19] == slot0[1] then
							slot15[slot19] = nil
						end
					end
				end
			end
		end
	end
end

slot0.SetFleetSuccess = function (slot0)
	slot1 = {
		inPort = true
	}

	if slot0.contextData.mapId and nowWorld:IsReseted() then
		slot1 = {
			inShop = true
		}
	end

	if getProxy(ContextProxy):getContextByMediator(WorldMediator) then
		slot2:extendData(slot1)
		slot0.viewComponent:closeView()
	else
		slot0:sendNotification(GAME.CHANGE_SCENE, SCENE.WORLD, slot1)
	end
end

return slot0

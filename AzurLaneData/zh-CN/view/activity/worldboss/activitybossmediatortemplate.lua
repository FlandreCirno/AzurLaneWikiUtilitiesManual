slot0 = class("ActivityBossMediatorTemplate", import("view.base.ContextMediator"))
slot0.ON_SUBMIT_TASK = "ActivityBossMediatorTemplate ON_SUBMIT_TASK"
slot0.ON_RANK = "ActivityBossMediatorTemplate ON_RANK"
slot0.ON_PRECOMBAT = "ActivityBossMediatorTemplate ON_PRECOMBAT"
slot0.ON_EX_PRECOMBAT = "ActivityBossMediatorTemplate ON_EX_PRECOMBAT"
slot0.ON_COMMIT_FLEET = "ActivityBossMediatorTemplate ON_COMMIT_FLEET"
slot0.ON_FLEET_RECOMMEND = "ActivityBossMediatorTemplate ON_FLEET_RECOMMEND"
slot0.ON_FLEET_CLEAR = "ActivityBossMediatorTemplate ON_FLEET_CLEAR"
slot0.ON_OPEN_DOCK = "ActivityBossMediatorTemplate ON_OPEN_DOCK"
slot0.ON_FLEET_SHIPINFO = "ActivityBossMediatorTemplate ON_FLEET_SHIPINFO"
slot0.ON_SELECT_COMMANDER = "ActivityBossMediatorTemplate ON_SELECT_COMMANDER"
slot0.ON_PERFORM_COMBAT = "ActivityBossMediatorTemplate ON_PERFORM_COMBAT"
slot0.COMMANDER_FORMATION_OP = "ActivityBossMediatorTemplate COMMANDER_FORMATION_OP"
slot0.ON_COMMANDER_SKILL = "ActivityBossMediatorTemplate ON_COMMANDER_SKILL"
slot1 = {
	"word_easy",
	"word_normal_junhe",
	"word_hard"
}

slot0.GetPairedFleetIndex = function (slot0)
	if slot0 < Fleet.SUBMARINE_FLEET_ID then
		return slot0 + 10
	else
		return slot0 - 10
	end
end

slot0.register = function (slot0)
	slot0.contextData.mediatorClass = slot0.class
	slot0.activityProxy = getProxy(ActivityProxy)
	slot0.timeMgr = pg.TimeMgr.GetInstance()

	if not slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2) then
		return
	end

	slot0:BindEvent()

	slot2 = getProxy(FleetProxy)
	slot0.contextData.activity = slot1
	slot0.contextData.activityID = slot1 and slot1.id

	if pg.activity_event_worldboss[slot1 and slot1:getConfig("config_id")] then
		slot0.contextData.TicketID = slot4.ticket
		slot0.contextData.BattleEndTimeStamp = slot4.time ~= "stop" and slot0.timeMgr:parseTimeFromConfig(slot4.time[2])
		slot0.contextData.exStageID = slot4.ex_expedition
		slot0.contextData.normalStageIDs = slot4.normal_expedition or {}
		slot0.contextData.groupNum = slot4.group_num
		slot0.contextData.submarineNum = slot4.submarine_num
		slot0.contextData.ticketInitPools = slot4.normal_expedition_drop_num or {}
		slot0.contextData.DisplayItems = (pg.extraenemy_template[slot4.boss_id[1]] and slot4.normal_expedition_drop_num or .reward_display) or {}
	end

	slot0.cbAfterReq = {}

	slot0:RequestAndUpdateView()

	slot0.contextData.actFleets = slot2:getActivityFleets()[slot1.id]

	if slot0.activityProxy:getActivityById(ActivityConst.ACTIVITY_BOSS_PT_ID) then
		slot0.contextData.ptData = ActivityBossPtData.New(slot7)
	end

	if slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_RANK) and not slot8:isEnd() then
		if getProxy(BillboardProxy):canFetch(PowerRank.TYPE_ACT_BOSS_BATTLE, slot8.id) then
			slot0:sendNotification(GAME.GET_POWERRANK, {
				type = slot10,
				activityId = slot11
			})
		else
			slot0:UpdateRankData(slot9:getRankList(slot10, slot11))
		end
	end

	slot0.viewComponent:setCommanderPrefabs(getProxy(CommanderProxy):getPrefabFleet())
	pg.GuildMsgBoxMgr.GetInstance():NotificationForBattle()
end

slot0.BindEvent = function (slot0)
	slot1 = getProxy(FleetProxy)
	slot2 = slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	slot0:bind(slot0.ON_RANK, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			index = BillboardLayer.PAGE_BOSS_BATTLE
		})
	end)
	slot0.bind(slot0, ActivityMediator.EVENT_PT_OPERATION, function (slot0, slot1)
		slot0:sendNotification(GAME.ACT_NEW_PT, slot1)
	end)
	slot0.bind(slot0, slot0.ON_SUBMIT_TASK, function (slot0, slot1)
		slot0:sendNotification(GAME.SUBMIT_TASK, slot1)
	end)
	slot0.bind(slot0, slot0.ON_PRECOMBAT, function (slot0, slot1)
		if not slot0:getActivityFleets()[slot1.id] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		slot2[slot1]:RemoveUnusedItems()

		if slot2[slot1]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		slot3, slot4 = slot2[slot1]:HaveShipsInEvent()

		if slot3 then
			pg.TipsMgr.GetInstance():ShowTips(slot4)

			return
		end

		slot5, slot6 = nil
		slot7 = {
			slot2[slot1]
		}
		slot5 = SYSTEM_ACT_BOSS
		slot6 = slot2.contextData.normalStageIDs[slot1]

		slot2[slot1 + 10]:RemoveUnusedItems()

		if slot2[slot1 + 10]:isLegalToFight() == true then
			table.insert(slot7, slot2[slot1 + 10])
		end

		slot2:addSubLayers(Context.New({
			mediator = PreCombatMediator,
			viewComponent = PreCombatLayer,
			data = {
				system = slot5,
				stageId = slot6,
				actID = slot1.id,
				fleets = slot7,
				OnConfirm = function (slot0)
					if not slot0:CheckInTime() then
						return
					end

					slot2 = getProxy(PlayerProxy):getRawData():getResource(slot0.contextData.TicketID) > 0 and (slot0.contextData.stageTickets[getProxy(SettingsProxy):isTipActBossExchangeTicket()] or 0) <= 0

					if not slot1 and slot2 then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							hideYes = true,
							noText = "text_inconsume",
							content = i18n("tip_exchange_ticket", i18n(slot2[pg.item_data_statistics[id2ItemId(slot0.contextData.TicketID or 1)]])),
							custom = {
								{
									text = "text_consume",
									sound = SFX_CONFIRM,
									onCallback = function ()
										slot0.contextData.ready2battleCb = slot1

										slot0.contextData:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
											stageId = GAME.ACT_BOSS_EXCHANGE_TICKET
										})
									end,
									btnType = pg.MsgboxMgr.BUTTON_BLUE_WITH_ICON,
									iconName = {
										pg.item_data_statistics[id2ItemId(slot0.contextData.TicketID or 1)].icon
									}
								}
							},
							onNo = function ()
								slot0()
							end,
							onClose = function ()
								return
							end
						})
					else
						slot3 = slot1 == 1

						if slot2 and slot3 then
							slot0.contextData.ready2battleCb = slot0

							slot0.sendNotification(slot4, GAME.ACT_BOSS_EXCHANGE_TICKET, {
								stageId = slot1
							})
						else
							slot0()
						end
					end
				end
			}
		}))
	end)
	slot0.bind(slot0, slot0.ON_EX_PRECOMBAT, function (slot0, slot1, slot2)
		if not slot0:getActivityFleets()[slot1.id] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_no_fleet"))

			return
		end

		slot3[slot1]:RemoveUnusedItems()

		if slot3[slot1]:isLegalToFight() ~= true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_formation_unsatisfied"))

			return
		end

		slot4, slot5 = slot3[slot1]:HaveShipsInEvent()

		if slot4 then
			pg.TipsMgr.GetInstance():ShowTips(slot5)

			return
		end

		seriesAsync({
			function (slot0)
				slot1 = "NG0017"

				if not slot0 and not pg.NewStoryMgr.GetInstance():IsPlayed(slot1) then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						hideNo = false,
						showStopRemind = true,
						hideYes = false,
						helps = pg.gametip.worldbossex_help.tip,
						type = MSGBOX_TYPE_HELP,
						stopRamindContent = i18n("dont_remind"),
						onYes = function ()
							if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
								pg.m02:sendNotification(GAME.STORY_UPDATE, {
									storyId = slot0
								})
							end

							slot1()
						end,
						onNo = function ()
							if pg.MsgboxMgr.GetInstance().stopRemindToggle.isOn then
								pg.m02:sendNotification(GAME.STORY_UPDATE, {
									storyId = slot0
								})
							end
						end
					})
				else
					slot0()
				end
			end,
			function (slot0)
				slot5, slot4 = nil
				slot2 = ({
					slot0[slot1]
				})["contextData"].exStageID

				slot0[((slot2 and SYSTEM_BOSS_EXPERIMENT) or SYSTEM_HP_SHARE_ACT_BOSS) + 10]:RemoveUnusedItems()

				if slot0[slot1 + 10]:isLegalToFight() == true then
					table.insert(slot3, slot0[slot1 + 10])
				end

				slot3:addSubLayers(Context.New({
					mediator = PreCombatMediator,
					viewComponent = PreCombatLayer,
					data = {
						system = slot1,
						stageId = slot2,
						actID = slot4.id,
						fleets = slot3,
						OnConfirm = function (slot0)
							if not slot0:CheckInTime() then
								return
							end

							slot0()
						end
					}
				}))
			end
		})
	end)
	slot0.bind(slot0, slot0.ON_COMMIT_FLEET, function ()
		slot0:commitActivityFleet(slot1.id)
	end)
	slot0.bind(slot0, slot0.ON_FLEET_RECOMMEND, function (slot0, slot1)
		slot0.activityProxy:recommendActivityFleet(slot1.id, slot1)

		slot0.contextData.actFleets = slot0.activityProxy.recommendActivityFleet:getActivityFleets()[slot1.id]

		slot0.viewComponent:updateEditPanel()
	end)
	slot0.bind(slot0, slot0.ON_FLEET_CLEAR, function (slot0, slot1)
		slot2 = slot0:getActivityFleets()

		slot2[slot1.id][slot1].clearFleet(slot4)

		slot2.contextData.actFleets = slot2[slot1.id]

		slot2.viewComponent:updateEditPanel()
	end)
	slot0.bind(slot0, slot0.ON_OPEN_DOCK, function (slot0, slot1)
		slot13.onShip, slot13.confirmSelect, slot13.onSelected = slot0.getDockCallbackFuncs4ActicityFleet(slot3, slot2, slot5)

		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			useBlackBlock = true,
			selectedMin = 0,
			skipSelect = true,
			leastLimitMsg = i18n("ship_formationMediator_leastLimit"),
			quitTeam = slot1.shipVO ~= nil,
			teamFilter = slot5,
			leftTopInfo = i18n("word_formation"),
			onShip = slot6,
			confirmSelect = slot7,
			onSelected = slot8,
			hideTagFlags = setmetatable({
				inActivity = slot1.id
			}, {
				__index = ShipStatus.TAG_HIDE_ACTIVITY_BOSS
			}),
			otherSelectedIds = slot1.fleet,
			ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
				isActivityNpc = true
			})
		})
	end)
	slot0.bind(slot0, slot0.ON_FLEET_SHIPINFO, function (slot0, slot1)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = slot1.shipId,
			shipVOs = slot1.shipVOs
		})
	end)
	slot0.bind(slot0, slot0.COMMANDER_FORMATION_OP, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_FORMATION_OP, {
			data = slot1
		})
	end)
	slot0.bind(slot0, slot0.ON_COMMANDER_SKILL, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = slot1
			}
		}))
	end)
	slot0.bind(slot0, slot0.ON_SELECT_COMMANDER, function (slot0, slot1, slot2)
		slot2:sendNotification(GAME.GO_SCENE, SCENE.COMMANDROOM, {
			maxCount = 1,
			mode = CommandRoomScene.MODE_SELECT,
			activeCommander = slot0:getActivityFleets()[slot1.id][slot1].getCommanders(slot4)[slot2],
			fleetType = CommandRoomScene.FLEET_TYPE_ACTBOSS,
			ignoredIds = {},
			onCommander = function (slot0)
				return true
			end,
			onSelected = function (slot0, slot1)
				slot4 = getProxy(CommanderProxy).getCommanderById(slot3, slot2)

				for slot8, slot9 in pairs(slot0) do
					if slot8 == slot1 then
						for slot13, slot14 in pairs(slot2) do
							if slot14.groupId == slot4.groupId and slot13 ~= slot3 then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

								return
							end
						end
					elseif slot8 == slot4.GetPairedFleetIndex(slot1) then
						for slot14, slot15 in pairs(slot10) do
							if slot2 == slot15.id then
								pg.TipsMgr.GetInstance():ShowTips(i18n("commander_is_in_fleet_already"))

								return
							end
						end
					end
				end

				slot5:updateCommanderByPos(slot3, slot4)
				slot5:updateActivityFleet(slot3.id, slot1, slot5.updateActivityFleet)
				slot1()
			end,
			onQuit = function (slot0)
				slot0:updateCommanderByPos(slot0.updateCommanderByPos, nil)
				slot0:updateActivityFleet(slot0.updateCommanderByPos.id, nil, slot0)
				slot0()
			end
		})
	end)
	slot0.bind(slot0, slot0.ON_PERFORM_COMBAT, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.BEGIN_STAGE, {
			mainFleetId = 1,
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = slot1,
			exitCallback = slot2
		})
	end)
end

slot0.listNotificationInterests = function (slot0)
	return {
		ActivityProxy.ACTIVITY_ADDED,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.SUBMIT_TASK_DONE,
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_DONE,
		GAME.ACT_NEW_PT_DONE,
		GAME.ACT_BOSS_EXCHANGE_TICKET_DONE,
		GAME.GET_POWERRANK_DONE,
		GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE,
		CommanderProxy.PREFAB_FLEET_UPDATE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == ActivityProxy.ACTIVITY_ADDED or slot2 == ActivityProxy.ACTIVITY_UPDATED then
		if slot3.id == ActivityConst.ACTIVITY_BOSS_PT_ID then
			if slot0.contextData.ptData then
				slot0.contextData.ptData:Update(slot3)
			else
				slot0.contextData.ptData = ActivityBossPtData.New(slot3)
			end

			slot0:UpdateView()
		elseif slot3.id == slot0.contextData.activityID then
			slot0.contextData.bossHP = slot3.data1
			slot0.contextData.mileStones = slot3.data1_list
			slot0.contextData.stageTickets = {}
			slot4 = slot0.contextData.stageTickets

			for slot8, slot9 in pairs(slot3.data1KeyValueList) do
				for slot13, slot14 in pairs(slot9) do
					slot4[slot13] = (slot4[slot13] or 0) + slot14
				end
			end

			if #slot0.cbAfterReq > 0 then
				for slot8, slot9 in ipairs(slot0.cbAfterReq) do
					slot9()
				end

				for slot8 = #slot0.cbAfterReq, 1, -1 do
					table.remove(slot0.cbAfterReq, slot8)
				end
			end

			slot0:UpdateView()
		end
	elseif slot2 == PlayerProxy.UPDATED then
		slot0:RequestAndUpdateView()
	elseif slot2 == GAME.BEGIN_STAGE_DONE then
		slot0.contextData.editFleet = nil

		if not getProxy(ContextProxy):getContextByMediator(PreCombatMediator) then
			slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
		end
	elseif slot2 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		if slot0.contextData.ready2battleCb then
			slot0.contextData.ready2battleCb()

			slot0.contextData.ready2battleCb = nil
		end
	elseif slot2 == GAME.GET_POWERRANK_DONE then
		if slot3.type == PowerRank.TYPE_ACT_BOSS_BATTLE then
			slot0:UpdateRankData(slot3.list)
		end
	elseif slot2 == GAME.ACT_NEW_PT_DONE then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3.awards)
	elseif slot2 == GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE then
		slot0.contextData.actFleets = getProxy(FleetProxy):getActivityFleets()[slot3.actId]

		slot0.viewComponent:updateEditPanel()
		slot0.viewComponent:updateCommanderFleet(getProxy(FleetProxy).getActivityFleets()[slot3.actId][slot3.fleetId])
	elseif slot2 == CommanderProxy.PREFAB_FLEET_UPDATE then
		slot0.viewComponent:setCommanderPrefabs(getProxy(CommanderProxy):getPrefabFleet())
		slot0.viewComponent:updateCommanderPrefab()
	end
end

slot0.RequestAndUpdateView = function (slot0, slot1)
	slot0:sendNotification(GAME.ACTIVITY_BOSS_PAGE_UPDATE, {
		activity_id = slot0.contextData.activityID
	})
	table.insert(slot0.cbAfterReq, slot1)
end

slot0.UpdateView = function (slot0)
	slot0.viewComponent:UpdateView()
end

slot0.CheckInTime = function (slot0)
	if not slot0.activityProxy:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2) or slot1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return false
	end

	if not slot0.contextData.BattleEndTimeStamp or slot0.contextData.BattleEndTimeStamp <= slot0.timeMgr:GetServerTime() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return false
	end

	return true
end

slot0.UpdateRankData = function (slot0, slot1)
	slot0.viewComponent:UpdateRank(slot1)
end

slot0.getDockCallbackFuncs4ActicityFleet = function (slot0, slot1, slot2)
	slot3 = getProxy(BayProxy)
	slot8 = getProxy(FleetProxy).getActivityFleets(slot4)[getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2).id][slot1]

	function slot9(slot0, slot1)
		slot2, slot3 = ShipStatus.ShipStatusCheck("inActivity", slot0, slot1, {
			inActivity = slot0.id
		})

		if not slot2 then
			return slot2, slot3
		end

		if slot1 and slot1:isSameKind(slot0) then
			return true
		end

		for slot7, slot8 in ipairs(slot2.ships) do
			if slot0:isSameKind(slot3:getShipById(slot8)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	return slot9, function (slot0, slot1, slot2)
		slot1()
	end, function (slot0)
		if slot0 then
			slot1:removeShip(slot0)
		end

		if #slot0 > 0 then
			if not slot1:containShip(slot2:getShipById(slot0[1])) then
				slot1:insertShip(slot1, nil, slot1)
			elseif slot0 then
				slot1:insertShip(slot0, nil, slot1)
			end

			slot1:RemoveUnusedItems()
			slot4:updateActivityFleet(slot5.id, slot6, slot1)
		end
	end
end

return slot0

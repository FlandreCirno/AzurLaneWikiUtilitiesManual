slot0 = class("CommanderInfoMediator", import("..base.ContextMediator"))
slot0.FETCH_NOT_LEARNED_TALENT = "CommanderInfoMediator:FETCH_NOT_LEARNED_TALENT"
slot0.RESET_TALENTS = "CommanderInfoMediator:RESET_TALENTS"
slot0.ON_LEARN_TALENT = "CommanderInfoMediator:ON_LEARN_TALENT"
slot0.ON_SELECT = "CommanderInfoMediator:ON_SELECT"
slot0.ON_UPGRADE = "CommanderInfoMediator:ON_UPGRADE"
slot0.ON_NEXT = "CommanderInfoMediator:ON_NEXT"
slot0.ON_PREV = "CommanderInfoMediator:ON_PREV"
slot0.ON_RENAME = "CommanderInfoMediator:ON_RENAME"
slot0.ON_CLOSE_PANEL = "CommanderInfoMediator:ON_CLOSE_PANEL"
slot0.ON_CLOSE_PANEL_SElF = "CommanderInfoMediator:ON_CLOSE_PANEL_SElF"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_CLOSE_PANEL_SElF, function (slot0)
		slot0.viewComponent:ClosePanelSelf()
	end)
	slot0.bind(slot0, slot0.ON_CLOSE_PANEL, function (slot0)
		slot0.viewComponent:ClosePanel()
	end)
	slot0.bind(slot0, CommandRoomMediator.OPEN_RENAME_PANEL, function (slot0, slot1)
		slot0.viewComponent:opeRenamePanel(slot1)
	end)
	slot0.bind(slot0, CommandRoomMediator.SHOW_MSGBOX, function (slot0, slot1)
		slot0.viewComponent:openMsgBox(slot1)
	end)
	slot0.bind(slot0, CommandRoomMediator.ON_TREE_MSGBOX, function (slot0, slot1)
		slot0.viewComponent:openTreePanel(slot1)
	end)
	slot0.bind(slot0, CommandRoomMediator.ON_CMD_SKILL, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = NewCommanderSkillLayer,
			data = {
				skill = slot1
			}
		}))
	end)
	slot0.bind(slot0, slot0.ON_RENAME, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.COMMANDER_RENAME, {
			commanderId = slot1,
			name = slot2
		})
	end)
	slot0.bind(slot0, slot0.ON_NEXT, function (slot0)
		slot0.contextData.materialIds = {}

		if table.indexof(slot0.contextData.displayIds or {}, slot2) + 1 <= #(slot0.contextData.displayIds or ) then
			slot0.contextData.commanderId = slot1[slot3 + 1]

			slot0:setCommander()

			CommandRoomScene.commanderId = slot1[slot3 + 1]
		end
	end)
	slot0.bind(slot0, slot0.ON_PREV, function (slot0)
		slot0.contextData.materialIds = {}

		if table.indexof(slot0.contextData.displayIds or {}, slot2) - 1 > 0 then
			slot0.contextData.commanderId = slot1[slot3 - 1]

			slot0:setCommander()

			CommandRoomScene.commanderId = slot1[slot3 - 1]
		end
	end)
	slot0.bind(slot0, CommandRoomMediator.ON_LOCK, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.COMMANDER_LOCK, {
			commanderId = slot1,
			flag = slot2
		})
	end)
	slot0.bind(slot0, slot0.FETCH_NOT_LEARNED_TALENT, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT, {
			id = slot1
		})
	end)
	slot0.bind(slot0, slot0.RESET_TALENTS, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_RESET_TALENTS, {
			id = slot1
		})
	end)
	slot0.bind(slot0, slot0.ON_LEARN_TALENT, function (slot0, slot1, slot2, slot3)
		slot0:sendNotification(GAME.COMMANDER_LEARN_TALENTS, {
			id = slot1,
			talentId = slot2,
			replaceid = slot3
		})
	end)
	slot0.bind(slot0, slot0.ON_SELECT, function (slot0)
		slot0.contextData.page = CommanderInfoScene.PAGE_PLAY
		slot1 = getProxy(CommanderProxy):getCommanderById(slot0.contextData.commanderId)
		slot3 = {}

		for slot7, slot8 in pairs(slot2) do
			if slot8:isLocked() then
				table.insert(slot3, slot8.id)
			end
		end

		if getProxy(ChapterProxy):getActiveChapter() then
			_.each(slot4.fleets, function (slot0)
				for slot5, slot6 in pairs(slot1) do
					table.insert(slot0, slot6.id)
				end
			end)
		end

		table.insert(slot3, slot0.contextData.commanderId)

		slot6 = getProxy(FleetProxy).getCommanders(slot5)

		slot0.sendNotification(slot8, GAME.GO_SCENE, SCENE.COMMANDROOM, {
			maxCount = 10,
			mode = CommandRoomScene.MODE_SELECT,
			fleetType = CommandRoomScene.FLEET_TYPE_COMMON,
			activeCommander = slot1,
			activeGroupId = slot1.groupId,
			selectedIds = slot0.contextData.materialIds,
			ignoredIds = slot3,
			onCommander = function (slot0, slot1, slot2, slot3)
				if nowWorld:CheckCommanderInFleet(slot0.id) then
					return false, i18n("commander_is_in_bigworld")
				end

				if slot0:isMaxLevel() and not slot0:isSameGroup(slot0.groupId) then
					return false, i18n("commander_select_matiral_erro")
				end

				if getProxy(CommanderProxy):IsHome(slot0.id) then
					return false, i18n("cat_sleep_notplay")
				end

				slot5 = getProxy(GuildProxy).getRawData(slot5)
				slot6, slot7 = nil

				if _.detect(slot1, function (slot0)
					return slot0.id == slot0.commanderId
				end) then
					slot6 = i18n("commander_material_is_in_fleet_tip")

					function slot7()
						slot0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
							commanderId = 0,
							fleetId = slot1.fleetId,
							pos = slot1.pos,
							callback = function ()
								slot0 = slot1:getCommanders()

								if slot2 then
									slot2()
								end
							end
						})
					end
				elseif slot5 and slot5.ExistCommander(slot5, slot0.id) then
					slot6 = i18n("commander_is_in_guild")

					function slot7()
						if not slot0:GetActiveEvent() then
							return
						end

						if not slot0:GetBossMission() or not slot1:IsActive() then
							return
						end

						if not slot1:GetFleetCommanderId(slot1.id) then
							return
						end

						if not Clone(slot2):GetCommanderPos(slot1.id) then
							return
						end

						slot3:RemoveCommander(slot4)
						slot2:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
							force = true,
							editFleet = {
								[slot3.id] = slot3
							},
							callback = slot3
						})
					end
				end

				if slot6 and slot7 then
					slot3.openMsgBox(slot3, {
						content = slot6,
						onYes = slot7,
						onNo = slot1,
						onClose = slot1
					})

					return false, nil
				end

				return true
			end,
			onSelected = function (slot0, slot1)
				slot0.contextData.materialIds = slot0

				slot1()
			end
		})
	end)
	slot0.bind(slot0, slot0.ON_UPGRADE, function (slot0, slot1, slot2, slot3)
		slot0:sendNotification(GAME.COMMANDER_UPGRADE, {
			id = slot1,
			materialIds = slot2,
			skillId = slot3
		})
	end)
	slot0.setCommander(slot0)
	slot0.viewComponent:setPlayer(getProxy(PlayerProxy).getData(slot1))
	slot0.viewComponent:setPools(getProxy(CommanderProxy):getPools())
end

slot0.setCommander = function (slot0)
	slot0:markFleet(slot2)
	slot0.viewComponent:setCommander(getProxy(CommanderProxy).getCommanderById(slot1, slot0.contextData.commanderId))
end

slot0.markFleet = function (slot0, slot1)
	for slot7, slot8 in pairs(slot3) do
		for slot12, slot13 in pairs(slot8:getCommanders()) do
			if slot13.id == slot1.id then
				slot14 = slot8.id

				if slot8.id > 10 then
					slot14 = slot8.id - 10
				end

				slot1.fleetId = slot14
				slot1.inFleet = true

				break
			end
		end
	end

	if getProxy(ChapterProxy):getActiveChapter() then
		_.each(slot4.fleets, function (slot0)
			if _.any(_.values(slot1), function (slot0)
				return slot0.id == slot0.id
			end) then
				slot0.inBattle = true
			end
		end)
	end
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE,
		CommanderProxy.COMMANDER_UPDATED,
		GAME.COMMANDER_LEARN_TALENTS_DONE,
		GAME.COMMANDER_UPGRADE_DONE,
		GAME.COMMANDER_LOCK_DONE,
		PlayerProxy.UPDATED,
		GAME.COMMANDER_RENAME_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if GAME.COMMANDER_FETCH_NOT_LEARNED_TALENT_DONE == slot1:getName() then
		slot0.viewComponent.panels[CommanderInfoScene.PAGE_TALENT].update(slot4, slot3.commander)
		slot0.viewComponent.panels[CommanderInfoScene.PAGE_TALENT]:openUseagePanel()
	elseif slot2 == CommanderProxy.COMMANDER_UPDATED then
		if slot0.viewComponent.commanderVO.id == slot3.id then
			slot0:markFleet(slot3)
			slot0.viewComponent:setCommander(slot3)
		end
	elseif slot2 == GAME.COMMANDER_LEARN_TALENTS_DONE then
		slot0.viewComponent.panels[CommanderInfoScene.PAGE_TALENT].update(slot4, slot3.commander)
		slot0.viewComponent.panels[CommanderInfoScene.PAGE_TALENT]:closeUsagePanel()
	elseif slot2 == GAME.COMMANDER_UPGRADE_DONE then
		for slot7 = #slot0.contextData.displayIds, 1, -1 do
			slot8 = slot0.contextData.displayIds[slot7]

			if _.any(slot0.contextData.materialIds, function (slot0)
				return slot0 == slot0
			end) then
				table.remove(slot0.contextData.displayIds, slot7)
			end
		end

		slot0.contextData.materialIds = {}

		pg.UIMgr.GetInstance():LoadingOn(false)
		slot0.viewComponent.panels[CommanderInfoScene.PAGE_PLAY]:playAnim(slot3.oldCommander, slot3.commander, function ()
			pg.UIMgr.GetInstance():LoadingOff(false)
		end)
	elseif slot2 == GAME.COMMANDER_LOCK_DONE then
		if slot3.flag == 1 then
			pg.TipsMgr.GetInstance().ShowTips(slot4, i18n("commander_lock_done"))
		elseif slot3.flag == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_unlock_done"))
		end
	elseif slot2 == PlayerProxy.UPDATED then
		slot0.viewComponent:setPlayer(slot3)
	elseif slot2 == GAME.COMMANDER_RENAME_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_rename_success_tip"))
	end
end

return slot0

slot0 = class("WorldMediator", import("..base.ContextMediator"))
slot0.OnMapOp = "WorldMediator.OnMapOp"
slot0.OnMapReq = "WorldMediator.OnMapReq"
slot0.OnOpenLayer = "WorldMediator.OnOpenLayer"
slot0.OnOpenScene = "WorldMediator.OnOpenScene"
slot0.OnChangeScene = "WorldMediator.OnChangeScene"
slot0.OnOpenMarkMap = "WorldMediator.OnOpenMarkMap"
slot0.OnTriggerTaskGo = "WorldMediator.OnTriggerTaskGo"
slot0.OnAutoSubmitTask = "WorldMediator.OnAutoSubmitTask"
slot0.OnAchieveStar = "WorldMediator.OnAchieveStar"
slot0.OnNotificationOpenLayer = "WorldMediator.OnNotificationOpenLayer"
slot0.OnStart = "WorldMediator.OnStart"

slot0.register = function (slot0)
	slot1 = nowWorld

	slot0:bind(slot0.OnMapOp, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_MAP_OP, slot1)
	end)
	slot0.bind(slot0, slot0.OnMapReq, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_MAP_REQ, {
			mapId = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnOpenLayer, function (slot0, slot1, slot2)
		slot0:addSubLayers(slot1, false, slot2)
	end)
	slot0.bind(slot0, slot0.OnOpenScene, function (slot0, slot1, ...)
		slot2 = {}

		if slot0.viewComponent:GetInMap() then
			table.insert(slot2, function (slot0)
				slot0.viewComponent:EaseOutMapUI(slot0)
			end)
		else
			table.insert(slot2, function (slot0)
				slot0.viewComponent:EaseOutAtlasUI(slot0)
			end)
		end

		slot3 = {
			len = select("#", ...),
			...
		}

		pg.UIMgr.GetInstance().LoadingOn(slot4)
		seriesAsync(slot2, function ()
			pg.UIMgr.GetInstance():LoadingOff()
			pg.UIMgr.GetInstance().LoadingOff:sendNotification(GAME.GO_SCENE, pg.UIMgr.GetInstance().LoadingOff, unpack(GAME.GO_SCENE, 1, slot2.len))
		end)
	end)
	slot0.bind(slot0, slot0.OnChangeScene, function (slot0, slot1, ...)
		slot2 = {}

		if slot0.viewComponent:GetInMap() then
			table.insert(slot2, function (slot0)
				slot0.viewComponent:EaseOutMapUI(slot0)
			end)
		else
			table.insert(slot2, function (slot0)
				slot0.viewComponent:EaseOutAtlasUI(slot0)
			end)
		end

		slot3 = {
			len = select("#", ...),
			...
		}

		pg.UIMgr.GetInstance().LoadingOn(slot4)
		seriesAsync(slot2, function ()
			pg.UIMgr.GetInstance():LoadingOff()
			pg.UIMgr.GetInstance().LoadingOff:sendNotification(GAME.CHANGE_SCENE, pg.UIMgr.GetInstance().LoadingOff, unpack(GAME.CHANGE_SCENE, 1, slot2.len))
		end)
	end)
	slot0.bind(slot0, slot0.OnAchieveStar, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_ACHIEVE, {
			list = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnStart, function (slot0, slot1, slot2, slot3)
		if slot3:GetLimitDamageLevel() < slot2.damageLevel then
			nowWorld:TriggerAutoFight(false)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				content = i18n("world_low_morale")
			})
		else
			slot0:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_WORLD,
				stageId = slot1
			})
		end
	end)
	slot0.bind(slot0, slot0.OnAutoSubmitTask, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_AUTO_SUMBMIT_TASK, {
			taskId = slot1.id
		})
	end)
	slot0.viewComponent.SetPlayer(slot2, getProxy(PlayerProxy):getRawData())
end

slot0.listNotificationInterests = function (slot0)
	_.each(WorldGuider.GetInstance():GetWorldGuiderNotifies(), function (slot0)
		slot0[#slot0 + 1] = slot0
	end)

	return {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE,
		GAME.BEGIN_STAGE_DONE,
		GAME.WORLD_STAMINA_EXCHANGE_DONE,
		WorldInventoryMediator.OnMap,
		slot0.OnOpenMarkMap,
		GAME.WORLD_TRIGGER_TASK_DONE,
		GAME.WORLD_SUMBMIT_TASK_DONE,
		GAME.WORLD_AUTO_SUMBMIT_TASK_DONE,
		GAME.WORLD_ITEM_USE_DONE,
		GAME.WORLD_RETREAT_FLEET,
		GAME.WORLD_ACHIEVE_DONE,
		slot0.OnTriggerTaskGo,
		GAME.WORLD_MAP_REQ_DONE,
		slot0.OnNotificationOpenLayer,
		GAME.ON_RECONNECTION_GAME,
		GAME.WORLD_TRIGGER_AUTO_FIGHT
	}
end

slot0.handleNotification = function (slot0, slot1)
	WorldGuider.GetInstance():WorldGuiderNotifyHandler(slot1:getName(), slot1:getBody(), slot0.viewComponent)

	slot4 = nowWorld

	if slot1.getName() == GAME.WORLD_MAP_OP_DONE then
		slot6 = slot0.viewComponent:GetCommand(slot3.mapOp.depth)

		if slot3.result ~= 0 then
			slot6:OpDone()

			if slot3.result == 130 then
				nowWorld.staminaMgr:Show()
			end

			return
		end

		slot7 = {}
		slot8 = nil

		slot0.viewComponent:RegistMapOp(slot5)

		if #slot5.drops > 0 then
			if slot5.op == WorldConst.OpReqCatSalvage then
				slot9 = nowWorld:GetFleet(slot5.id):GetSalvageScoreRarity()

				if nowWorld.isAutoFight then
					nowWorld:AddAutoInfo("salvage", {
						drops = slot5.drops,
						rarity = slot9
					})
				else
					table.insert(slot7, function (slot0)
						slot0.viewComponent:DisplayAwards(slot1.drops, {
							title = "commander",
							titleExtra = tostring(slot0.viewComponent)
						}, slot0)
					end)
				end
			elseif nowWorld.isAutoFight then
				nowWorld.AddAutoInfo(slot9, "drops", slot5.drops)
			else
				table.insert(slot7, function (slot0)
					slot0.viewComponent:DisplayAwards(slot1.drops, {}, slot0)
				end)
			end
		end

		if slot5.routine then
			function slot8()
				slot0.routine(slot0.routine)
			end
		else
			slot2 = WorldConst.ReqName[slot5.op]

			if slot5.op == WorldConst.OpReqTask then
			elseif slot9 == WorldConst.OpReqPressingMap or slot9 == WorldConst.OpReqCatSalvage then
				slot10 = slot7
				slot7 = {}

				function slot8()
					slot0:OpDone(slot1 .. "Done", , )
				end
			else
				function slot8()
					slot0:OpDone(slot1 .. "Done", )
				end
			end
		end

		seriesAsync(slot7, slot8)

		return
	end

	if slot2 == PlayerProxy.UPDATED then
		slot0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
	elseif slot2 == GAME.BEGIN_STAGE_DONE then
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
	elseif slot2 == GAME.WORLD_STAMINA_EXCHANGE_DONE then
		if not slot0.viewComponent:GetInMap() and slot0.viewComponent.svFloatPanel:isShowing() then
			slot5:UpdateCost()
		end
	elseif slot2 == WorldInventoryMediator.OnMap then
		slot0.viewComponent:Op("OpShowTresureMap", slot3.itemId)
	elseif slot2 == slot0.OnOpenMarkMap then
		slot0.viewComponent:Op("OpShowMarkOverall", slot3)
	elseif slot2 == GAME.WORLD_TRIGGER_TASK_DONE then
		pg.WorldToastMgr.GetInstance():ShowToast(slot3.task, false)
	elseif slot2 == GAME.WORLD_SUMBMIT_TASK_DONE then
		slot5 = {}

		if #slot3.task.config.task_ed > 0 then
			table.insert(slot5, function (slot0)
				pg.NewStoryMgr.GetInstance():Play(slot0.config.task_ed, slot0, true)
			end)
		end

		if slot3.drops and #slot3.drops > 0 then
			if nowWorld.isAutoFight then
				nowWorld.AddAutoInfo(slot7, "drops", slot3.drops)
			else
				table.insert(slot5, function (slot0)
					slot0.viewComponent:DisplayAwards(slot1.drops, {}, slot0)
				end)
			end
		end

		for slot10, slot11 in ipairs(slot3.expfleets) do
			table.insert(slot5, function (slot0)
				slot1.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = "without word",
					oldShips = slot0.oldships,
					newShips = slot0.newships
				}, slot0)
			end)
		end

		seriesAsync(slot5, function ()
			pg.WorldToastMgr.GetInstance():ShowToast(pg.WorldToastMgr.GetInstance().ShowToast, true)
		end)
	elseif slot2 == GAME.WORLD_AUTO_SUMBMIT_TASK_DONE then
		slot5 = {}

		if #slot3.task.config.task_ed > 0 then
			table.insert(slot5, function (slot0)
				pg.NewStoryMgr.GetInstance():Play(slot0.config.task_ed, slot0, true)
			end)
		end

		if slot3.drops and #slot3.drops > 0 then
			if nowWorld.isAutoFight then
				nowWorld.AddAutoInfo(slot7, "drops", slot3.drops)
			else
				table.insert(slot5, function (slot0)
					slot0.viewComponent:DisplayAwards(slot1.drops, {}, slot0)
				end)
			end
		end

		for slot10, slot11 in ipairs(slot3.expfleets) do
			table.insert(slot5, function (slot0)
				slot1.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = "without word",
					oldShips = slot0.oldships,
					newShips = slot0.newships
				}, slot0)
			end)
		end

		seriesAsync(slot5, function ()
			pg.WorldToastMgr.GetInstance():ShowToast(pg.WorldToastMgr.GetInstance().ShowToast, true)

			slot0 = slot1.viewComponent:GetCommand()

			slot0:OpDone("OpAutoSubmitTaskDone", slot0)
		end)
	elseif slot2 == GAME.WORLD_ITEM_USE_DONE then
		slot6 = slot3.drops
		slot7 = {}

		if slot3.item.getWorldItemType(slot5) == WorldItem.UsageWorldClean then
			table.insert(slot7, function (slot0)
				pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_story_recycle_item.description[1], slot0, true)
			end)
			table.insert(slot7, function (slot0)
				slot0.viewComponent:GetAllPessingAward(slot0)
			end)
		elseif slot5.getWorldItemType(slot5) == WorldItem.UsageWorldBuff then
			slot8, slot9 = slot5:getItemWorldBuff()
			slot9 = slot9 * slot5.count

			table.insert(slot7, function (slot0)
				nowWorld:GetGlobalBuff(slot0):GetFloor().viewComponent:ShowSubView("GlobalBuff", {
					{
						id = slot0,
						floor = slot1,
						before = nowWorld.GetGlobalBuff(slot0).GetFloor()
					},
					slot0
				})
			end)
			table.insert(slot7, function (slot0)
				nowWorld:AddGlobalBuff(slot0, nowWorld.AddGlobalBuff)
				slot0()
			end)
		end

		if #slot6 > 0 then
			if nowWorld.isAutoFight then
				nowWorld.AddAutoInfo(slot8, "drops", slot6)
			else
				table.insert(slot7, function (slot0)
					slot0.viewComponent:DisplayAwards(slot0.viewComponent.DisplayAwards, {}, slot0)
				end)
			end
		end

		seriesAsync(slot7, function ()
			return
		end)
	elseif slot2 == GAME.WORLD_RETREAT_FLEET then
		slot0.viewComponent:Op("OpReqRetreat", slot4.GetFleet(slot4))
	elseif slot2 == GAME.WORLD_ACHIEVE_DONE then
	elseif slot2 == slot0.OnTriggerTaskGo then
		slot0.viewComponent:Op("OpTaskGoto", slot3.taskId)
	elseif slot2 == GAME.WORLD_MAP_REQ_DONE then
		slot5 = slot0.viewComponent:GetCommand()

		if slot3.result == 0 then
			slot5:OpDone("OpFetchMapDone")
		else
			slot5:OpDone()
		end
	elseif slot2 == slot0.OnNotificationOpenLayer then
		slot0:addSubLayers(slot3.context)
	elseif slot2 == GAME.ON_RECONNECTION_GAME then
	elseif slot2 == GAME.WORLD_TRIGGER_AUTO_FIGHT then
		slot0.viewComponent:UpdateAutoFightDisplay()
	end
end

return slot0

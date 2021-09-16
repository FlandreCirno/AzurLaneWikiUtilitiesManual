slot0 = class("WorldPortMediator", import("..base.ContextMediator"))
slot0.OnOpenBay = "WorldPortMediator.OnOpenBay"
slot0.OnTaskGoto = "WorldPortMediator.OnTaskGoto"
slot0.OnAccepetTask = "WorldPortMediator.OnAccepetTask"
slot0.OnSubmitTask = "WorldPortMediator.OnSubmitTask"
slot0.OnReqPort = "WorldPortMediator.OnReqPort"
slot0.OnBuyGoods = "WorldPortMediator.OnBuyGoods"

slot0.register = function (slot0)
	slot0:bind(slot0.OnOpenBay, function ()
		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			selectedMin = 0,
			mode = DockyardScene.MODE_WORLD,
			hideTagFlags = ShipStatus.TAG_HIDE_WORLD
		})
	end)
	slot0.bind(slot0, slot0.OnTaskGoto, function (slot0, slot1)
		slot0.viewComponent:closeView()
		slot0:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnAccepetTask, function (slot0, slot1, slot2)
		slot3 = nowWorld

		slot0:sendNotification(GAME.WORLD_TRIGGER_TASK, {
			taskId = slot1.id,
			portId = slot2
		})
	end)
	slot0.bind(slot0, slot0.OnSubmitTask, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = slot1.id
		})
	end)
	slot0.bind(slot0, slot0.OnReqPort, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_PORT_REQ, {
			mapId = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnBuyGoods, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_PORT_SHOPPING, {
			goods = slot1
		})
	end)
	slot0.viewComponent.SetPlayer(slot1, getProxy(PlayerProxy):getRawData())
	slot0.viewComponent:SetPort(nowWorld:GetActiveMap():GetPort())
	slot0:CheckTaskNotify(nowWorld:GetTaskProxy())
end

slot0.listNotificationInterests = function (slot0)
	return {
		PlayerProxy.UPDATED,
		GAME.WORLD_PORT_SHOPPING_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == PlayerProxy.UPDATED then
		slot0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())
	elseif slot2 == GAME.WORLD_PORT_SHOPPING_DONE then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3.drops)
	end
end

slot0.CheckTaskNotify = function (slot0, slot1)
	for slot6, slot7 in pairs(slot2) do
		if slot7:getState() == WorldTask.STATE_ONGOING and slot7.config.complete_condition == WorldConst.TaskTypeArrivePort then
			WBank:Fetch(WorldMapOp).op = WorldConst.OpReqTask

			slot0:sendNotification(GAME.WORLD_MAP_OP, WBank.Fetch(WorldMapOp))
		end
	end
end

return slot0

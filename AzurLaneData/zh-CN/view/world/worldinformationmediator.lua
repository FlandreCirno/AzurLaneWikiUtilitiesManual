slot0 = class("WorldInformationMediator", import("..base.ContextMediator"))
slot0.OnTriggerTask = "WorldInformationMediator.OnTriggerTask"
slot0.OnSubmitTask = "WorldInformationMediator.OnSubmitTask"
slot0.OnTaskGoto = "WorldInformationMediator.OnTaskGoto"

slot0.register = function (slot0)
	slot0:bind(slot0.OnTaskGoto, function (slot0, slot1)
		slot0.viewComponent:closeView()
		slot0:sendNotification(WorldMediator.OnTriggerTaskGo, {
			taskId = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnTriggerTask, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_TRIGGER_TASK, {
			taskId = slot1
		})
	end)
	slot0.bind(slot0, slot0.OnSubmitTask, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_SUMBMIT_TASK, {
			taskId = slot1.id
		})
	end)
	slot0.viewComponent.setWorldTaskProxy(slot1, nowWorld:GetTaskProxy())
end

slot0.listNotificationInterests = function (slot0)
	return {}
end

slot0.handleNotification = function (slot0, slot1)
	slot2 = slot1:getName()
	slot3 = slot1:getBody()
end

return slot0

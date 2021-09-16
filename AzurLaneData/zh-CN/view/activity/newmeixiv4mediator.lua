slot0 = class("NewMeixiV4Mediator", import("view.base.ContextMediator"))
slot0.ON_TASK_GO = "ON_TASK_GO"
slot0.ON_TASK_SUBMIT = "ON_TASK_SUBMIT"
slot0.GO_STORY = "GO_STORY"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_TASK_GO, function (slot0, slot1)
		slot0:sendNotification(GAME.TASK_GO, {
			taskVO = slot1
		})
	end)
	slot0.bind(slot0, slot0.ON_TASK_SUBMIT, function (slot0, slot1)
		slot0:sendNotification(GAME.SUBMIT_TASK, slot1.id)
	end)
	slot0.bind(slot0, slot0.GO_STORY, function (slot0, slot1)
		WorldConst.ReqWorldCheck(function ()
			slot0:sendNotification(GAME.GO_SCENE, SCENE.WORLD_COLLECTION, {
				memoryGroup = slot0
			})
		end)
	end)
	slot0.viewComponent.setPlayer(slot2, getProxy(PlayerProxy):getData())
end

slot0.listNotificationInterests = function (slot0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		GAME.SUBMIT_TASK_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == ActivityProxy.ACTIVITY_UPDATED then
		if slot3.id == ActivityConst.NEWMEIXIV4_SKIRMISH_ID then
			slot0.viewComponent:onUpdateTask()
		end
	elseif slot2 == PlayerProxy.UPDATED then
		slot0.viewComponent:onUpdateRes(slot3)
	elseif slot2 == GAME.SUBMIT_TASK_DONE then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3, function ()
			slot0.viewComponent:onUpdateTask()
		end)
	end
end

return slot0

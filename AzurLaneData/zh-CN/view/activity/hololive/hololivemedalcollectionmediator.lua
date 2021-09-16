slot0 = class("HololiveMedalCollectionMediator", import("view.base.ContextMediator"))

slot0.register = function (slot0)
	slot0:BindEvent()
end

slot0.BindEvent = function (slot0)
	slot0:bind(ActivityMediator.ON_TASK_SUBMIT, function (slot0, slot1)
		slot0:sendNotification(GAME.SUBMIT_TASK, slot1.id)
	end)
	slot0.bind(slot0, ActivityMediator.ON_TASK_GO, function (slot0, slot1)
		slot0:sendNotification(GAME.TASK_GO, {
			taskVO = slot1
		})
	end)
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.SUBMIT_TASK_DONE,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.MEMORYBOOK_UNLOCK_DONE then
		slot0.viewComponent:UpdateView()
	elseif slot2 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		slot0.viewComponent:PlayStory(function ()
			slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot1.awards, slot1.callback)
		end)
	elseif slot2 == GAME.SUBMIT_TASK_DONE then
		slot0.viewComponent.emit(slot4, BaseUI.ON_ACHIEVE, slot3, function ()
			slot0.viewComponent:UpdateView()
		end)
	elseif slot2 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		slot0.viewComponent.UpdateView(slot4)
	end
end

return slot0

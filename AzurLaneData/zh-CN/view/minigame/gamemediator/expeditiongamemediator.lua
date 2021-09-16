slot0 = class("ExpeditionGameMediator", import(".MiniHubMediator"))

slot0.listNotificationInterests = function (slot0)
	table.insertto({
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.BEGIN_STAGE_DONE
	}, slot0.super.listNotificationInterests(slot0))

	return 
end

slot0.handleNotification = function (slot0, slot1)
	slot0.super.handleNotification(slot0, slot1)

	slot3 = slot1:getBody()

	if slot1:getName() == ActivityProxy.ACTIVITY_UPDATED then
		slot0.viewComponent:activityUpdate()
	elseif slot2 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3.awards, slot3.callback)
	elseif slot2 == GAME.BEGIN_STAGE_DONE then
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
	end
end

return slot0

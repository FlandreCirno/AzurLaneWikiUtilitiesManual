slot0 = class("WorldCollectionMediator", import("..base.ContextMediator"))
slot0.ON_ACHIEVE_STAR = "WorldCollectionMediator.ON_ACHIEVE_STAR"
slot0.ON_ACHIEVE_OVERVIEW = "WorldCollectionMediator.ON_ACHIEVE_OVERVIEW"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_ACHIEVE_STAR, function (slot0, slot1)
		slot0:sendNotification(GAME.WORLD_ACHIEVE, {
			list = slot1
		})
	end)
	slot0.bind(slot0, slot0.ON_ACHIEVE_OVERVIEW, function (slot0)
		slot0:sendNotification(WorldMediator.OnOpenMarkMap, {
			mode = "Achievement"
		})
	end)
	slot0.viewComponent.setCollectionProxy(slot1, nowWorld:GetCollectionProxy())
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.WORLD_ACHIEVE_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.WORLD_ACHIEVE_DONE then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3.drops, function ()
			slot0.viewComponent:flushAchieveUpdate(slot1.list)
		end)
	end
end

return slot0

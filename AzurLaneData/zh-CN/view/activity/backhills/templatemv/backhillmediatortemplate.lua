slot0 = class("BackHillMediatorTemplate", import("view.base.ContextMediator"))
slot0.MINI_GAME_OPERATOR = "MINI_GAME_OPERATOR"
slot0.GO_SCENE = "GO_SCENE"
slot0.GO_SUBLAYER = "GO_SUBLAYER"

slot0.register = function (slot0)
	slot0:BindEvent()
end

slot0.BindEvent = function (slot0)
	slot0:bind(slot0.GO_SCENE, function (slot0, slot1, ...)
		slot0:sendNotification(GAME.GO_SCENE, slot1, ...)
	end)
	slot0.bind(slot0, slot0.GO_SUBLAYER, function (slot0, slot1, slot2)
		slot0:addSubLayers(slot1, nil, slot2)
	end)
	slot0.bind(slot0, slot0.MINI_GAME_OPERATOR, function (slot0, ...)
		slot0:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.SEND_MINI_GAME_OP_DONE then
		slot4 = {
			function (slot0)
				if #slot0.awards > 0 then
					slot1.viewComponent:emit(BaseUI.ON_ACHIEVE, slot1, slot0)
				else
					slot0()
				end
			end,
			function (slot0)
				slot0.viewComponent:UpdateView()
			end
		}

		seriesAsync(slot4)
	elseif slot2 == ActivityProxy.ACTIVITY_UPDATED then
		slot0.viewComponent:UpdateActivity(slot3)
	end
end

return slot0

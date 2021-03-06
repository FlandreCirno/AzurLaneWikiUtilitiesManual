slot0 = class("BlackWhiteGridMediator", import("...base.ContextMediator"))
slot0.ON_FINISH = "VirtualSpaceMediator:ON_FINISH"
slot0.ON_UPDATE_SCORE = "VirtualSpaceMediator:ON_UPDATE_SCORE"

slot0.register = function (slot0)
	slot0.viewComponent:setActivity(slot2)
	slot0:bind(slot0.ON_FINISH, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.BLACK_WHITE_GRID_OP, {
			cmd = 1,
			activityId = slot1.id,
			id = slot1,
			score = slot2
		})
	end)
	slot0.bind(slot0, slot0.ON_UPDATE_SCORE, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.BLACK_WHITE_GRID_OP, {
			cmd = 2,
			activityId = slot1.id,
			id = slot1,
			score = slot2
		})
	end)
	slot0.viewComponent:setPlayer(getProxy(PlayerProxy).getRawData(slot3))
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.BLACK_WHITE_GRID_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.BLACK_WHITE_GRID_OP_DONE then
		slot4 = {
			function (slot0)
				slot0.viewComponent:playStory(slot0)
			end,
			function (slot0)
				if #slot0.awards > 0 then
					slot1.viewComponent:emit(BaseUI.ON_ACHIEVE, slot1, slot0)
				else
					slot0()
				end
			end,
			function (slot0)
				slot0.viewComponent:updateBtnsState()
				slot0()
			end
		}

		seriesAsync(slot4)
	elseif slot2 == ActivityProxy.ACTIVITY_UPDATED and slot0.viewComponent.activityVO.id == slot3.id then
		slot0.viewComponent:setActivity(slot3)
	end
end

return slot0

slot0 = class("ActivityMediator", import("..base.ContextMediator"))

slot0.register = function (slot0)
	slot0.contextData.singleActivity = true

	slot0:bind(ActivityMediator.EVENT_OPERATION, function (slot0, slot1)
		slot0:sendNotification(GAME.ACTIVITY_OPERATION, slot1)
	end)
	slot0.bind(slot0, ActivityMediator.EVENT_GO_SCENE, function (slot0, slot1, slot2)
		if slot1 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function ()
				slot0:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			slot0.sendNotification(slot3, GAME.GO_SCENE, slot1, slot2)
		end
	end)
	slot0.viewComponent:setPlayer(slot3)
	slot0.viewComponent:setFlagShip(slot5)
	slot0.viewComponent:selectActivity(getProxy(ActivityProxy).getActivityById(slot6, slot1))
end

slot0.listNotificationInterests = function (slot0)
	return {
		ActivityProxy.ACTIVITY_ADDED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.ACT_NEW_PT_DONE,
		GAME.RETURN_AWARD_OP_DONE,
		GAME.MONOPOLY_AWARD_DONE,
		GAME.SUBMIT_TASK_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == ActivityProxy.ACTIVITY_ADDED or slot2 == ActivityProxy.ACTIVITY_UPDATED then
		slot0.viewComponent:updateActivity(slot3)
	elseif slot2 == ActivityProxy.ACTIVITY_OPERATION_DONE then
	elseif slot2 == ActivityProxy.ACTIVITY_SHOW_AWARDS or slot2 == GAME.ACT_NEW_PT_DONE or slot2 == GAME.RETURN_AWARD_OP_DONE or slot2 == GAME.MONOPOLY_AWARD_DONE then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3.awards, slot3.callback)
	elseif slot2 == GAME.SUBMIT_TASK_DONE then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3, function ()
			slot0.viewComponent:updateTaskLayers()
		end)
	elseif slot2 == GAME.SEND_MINI_GAME_OP_DONE then
		slot4 = {
			function (slot0)
				if #slot0.awards > 0 then
					if slot1.viewComponent then
						slot1.viewComponent:emit(BaseUI.ON_ACHIEVE, slot1, slot0)
					else
						slot1:emit(BaseUI.ON_ACHIEVE, slot1, slot0)
					end
				else
					slot0()
				end
			end
		}

		seriesAsync(slot4)
	end
end

return slot0

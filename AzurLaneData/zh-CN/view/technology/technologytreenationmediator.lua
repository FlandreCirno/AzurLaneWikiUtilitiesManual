slot0 = class("TechnologyTreeNationMediator", import("..base.ContextMediator"))

slot0.register = function (slot0)
	slot0:bind(TechnologyConst.CLICK_UP_TEC_BTN, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.START_CAMP_TEC, {
			tecID = slot1,
			levelID = slot2
		})
	end)
	slot0.bind(slot0, TechnologyConst.FINISH_UP_TEC, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.FINISH_CAMP_TEC, {
			tecID = slot1,
			levelID = slot2
		})
	end)
	slot0.bind(slot0, TechnologyConst.OPEN_ALL_BUFF_DETAIL, function ()
		slot0:addSubLayers(Context.New({
			mediator = AllBuffDetailMediator,
			viewComponent = AllBuffDetailLayer,
			data = {}
		}))
	end)
end

slot0.listNotificationInterests = function (slot0)
	return {
		TechnologyConst.START_TEC_BTN_SUCCESS,
		TechnologyConst.FINISH_TEC_SUCCESS,
		TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == TechnologyConst.START_TEC_BTN_SUCCESS then
		slot0.viewComponent:updateTecListData()
		slot0.viewComponent:updateTecItem(slot3)
	elseif slot2 == TechnologyConst.FINISH_TEC_SUCCESS then
		slot0.viewComponent:updateTecListData()
		slot0.viewComponent:updateTecItem(slot3)
	elseif slot2 == TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER_NOTIFICATION then
		slot0.viewComponent:closeMyself()
	end
end

return slot0

slot0 = class("IdolMasterMedalCollectionMediator", import("view.base.ContextMediator"))

slot0.register = function (slot0)
	slot0:BindEvent()
end

slot0.BindEvent = function (slot0)
	return
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.MEMORYBOOK_UNLOCK_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.MEMORYBOOK_UNLOCK_DONE then
		slot0.viewComponent:updateAfterSubmit(slot3)
	elseif slot2 == ActivityProxy.ACTIVITY_UPDATED then
	elseif slot2 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		if getProxy(ContextProxy):getContextByMediator(ActivityMediator) then
			return
		end

		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot3.awards, slot3.callback)
	end
end

slot0.isHaveActivableMedal = function ()
	if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) or slot0:isEnd() then
		return
	end

	slot1 = slot0.data1_list
	slot2 = slot0.data2_list

	for slot7, slot8 in ipairs(slot3) do
		slot10 = table.contains(slot1, slot8)

		if not table.contains(slot2, slot8) and slot10 then
			return true
		end
	end

	return false
end

slot0.GetPicturePuzzleIds = function (slot0)
	table.insertto(Clone(pg.activity_event_picturepuzzle[slot0].pickup_picturepuzzle), pg.activity_event_picturepuzzle[slot0].drop_picturepuzzle)

	return Clone(pg.activity_event_picturepuzzle[slot0].pickup_picturepuzzle)
end

return slot0

slot0 = class("TechnologyMediator", import("..base.ContextMediator"))
slot0.ON_START = "TechnologyMediator:ON_START"
slot0.ON_FINISHED = "TechnologyMediator:ON_FINISHED"
slot0.ON_TIME_OVER = "TechnologyMediator:ON_TIME_OVER"
slot0.ON_REFRESH = "TechnologyMediator:ON_REFRESH"
slot0.ON_STOP = "TechnologyMediator:ON_STOP"
slot0.ON_CLICK_SETTINGS_BTN = "TechnologyMediator:ON_CLICK_SETTINGS_BTN"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_START, function (slot0, slot1)
		slot0:sendNotification(GAME.START_TECHNOLOGY, {
			id = slot1.id,
			pool_id = slot1.pool_id
		})
	end)
	slot0.bind(slot0, slot0.ON_TIME_OVER, function (slot0, slot1)
		if getProxy(TechnologyProxy).getTechnologyById(slot2, slot1):canFinish() then
			slot3:finish()
			slot2:updateTechnology(slot3)
		end
	end)
	slot0.bind(slot0, slot0.ON_FINISHED, function (slot0, slot1)
		slot0:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = slot1.id,
			pool_id = slot1.pool_id
		})
	end)
	slot0.bind(slot0, slot0.ON_REFRESH, function (slot0)
		slot0:sendNotification(GAME.REFRESH_TECHNOLOGYS)
	end)
	slot0.bind(slot0, slot0.ON_STOP, function (slot0, slot1)
		slot0:sendNotification(GAME.STOP_TECHNOLOGY, {
			id = slot1.id,
			pool_id = slot1.pool_id
		})
	end)
	slot0.bind(slot0, slot0.ON_CLICK_SETTINGS_BTN, function (slot0)
		slot0:addSubLayers(Context.New({
			viewComponent = TechnologySettingsLayer,
			mediator = TechnologySettingsMediator,
			onRemoved = function ()
				slot0.viewComponent:updateSettingsBtn()
			end
		}))
	end)

	slot1 = getProxy(TechnologyProxy)

	slot0.viewComponent.setTechnologys(slot2, slot1:getTechnologys())
	slot0.viewComponent:setRefreshFlag(slot1.refreshTechnologysFlag)
	slot0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

slot0.listNotificationInterests = function (slot0)
	return {
		TechnologyProxy.TECHNOLOGY_UPDATED,
		GAME.FINISH_TECHNOLOGY_DONE,
		GAME.REFRESH_TECHNOLOGYS_DONE,
		TechnologyProxy.REFRESH_UPDATED,
		PlayerProxy.UPDATED
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot2 = slot1:getBody()

	if slot1:getName() == TechnologyProxy.TECHNOLOGY_UPDATED then
		slot0.viewComponent:updateTechnology(slot2)
		slot0.viewComponent:updateSelectedInfo(slot2)
	else
		if slot3 == GAME.FINISH_TECHNOLOGY_DONE then
			slot6 = slot2.catchupItems
			slot7 = slot2.catchupActItems

			_.each(slot4, function (slot0)
				slot0.riraty = true

				table.insert(slot0, slot0)
			end)
			_.each(slot6, function (slot0)
				slot0.catchupTag = true

				table.insert(slot0, slot0)
			end)
			_.each(slot7, function (slot0)
				slot0.catchupActTag = true

				table.insert(slot0, slot0)
			end)

			if #slot2.commons > 0 then
				slot0.viewComponent.emit(slot8, BaseUI.ON_AWARD, {
					animation = true,
					items = slot5
				})
			end

			slot0:onRefresh()

			return
		end

		if GAME.REFRESH_TECHNOLOGYS_DONE == slot3 then
			slot0:onRefresh()
		elseif slot3 == TechnologyProxy.REFRESH_UPDATED then
			slot0.viewComponent:setRefreshFlag(slot2)
			slot0.viewComponent:updateRefreshBtn(slot2)
		elseif slot3 == PlayerProxy.UPDATED then
			slot0.viewComponent:setPlayer(slot2)
		end
	end
end

slot0.onRefresh = function (slot0)
	slot0.viewComponent:clearTimer()
	slot0.viewComponent:cancelSelected()
	slot0.viewComponent:setTechnologys(getProxy(TechnologyProxy):getTechnologys())
	slot0.viewComponent:initTechnologys()
	slot0.viewComponent:updateSettingsBtn()
end

return slot0

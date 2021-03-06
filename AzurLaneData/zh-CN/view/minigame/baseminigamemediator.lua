slot0 = class("BaseMiniGameMediator", import("..base.ContextMediator"))
slot0.MINI_GAME_SUCCESS = "BaseMiniGameMediator:MINI_GAME_SUCCESS"
slot0.MINI_GAME_FAILURE = "BaseMiniGameMediator:MINI_GAME_FAILURE"
slot0.MINI_GAME_OPERATOR = "BaseMiniGameMediator:MINI_GAME_OPERATOR"

slot0.register = function (slot0)
	slot0.miniGameId = slot0.contextData.miniGameId
	slot0.miniGameProxy = getProxy(MiniGameProxy)

	slot0.viewComponent:SetMGData(slot2)
	slot0.viewComponent:SetMGHubData(slot1)
	slot0.miniGameProxy:RequestInitData(slot0.miniGameId)
	slot0:bind(BaseMiniGameMediator.MINI_GAME_SUCCESS, function (slot0, ...)
		slot0:OnMiniGameSuccess(...)
	end)
	slot0.bind(slot0, BaseMiniGameMediator.MINI_GAME_FAILURE, function (slot0, ...)
		slot0:OnMiniGameFailure(...)
	end)
	slot0.bind(slot0, BaseMiniGameMediator.MINI_GAME_OPERATOR, function (slot0, ...)
		slot0:OnMiniGameOPeration(...)
	end)
end

slot0.OnMiniGameOPeration = function (slot0, ...)
	return
end

slot0.OnMiniGameSuccess = function (slot0, ...)
	return
end

slot0.OnMiniGameFailure = function (slot0, ...)
	return
end

slot0.listNotificationInterests = function (slot0)
	return {
		MiniGameProxy.ON_HUB_DATA_UPDATE,
		GAME.SEND_MINI_GAME_OP_DONE,
		GAME.MODIFY_MINI_GAME_DATA_DONE,
		GAME.ON_APPLICATION_PAUSE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == MiniGameProxy.ON_HUB_DATA_UPDATE then
		slot0.viewComponent:SetMGHubData(slot3)
	elseif slot2 == GAME.SEND_MINI_GAME_OP_DONE then
		slot4 = {
			function (slot0)
				if #slot0.awards > 0 then
					slot1.viewComponent:emit(BaseUI.ON_ACHIEVE, slot1, slot0)
				else
					slot0()
				end
			end,
			function (slot0)
				slot0.viewComponent:OnGetAwardDone(slot0.viewComponent.OnGetAwardDone)
				slot0()
			end
		}

		seriesAsync(slot4)
		slot0.viewComponent:OnSendMiniGameOPDone(slot3)
	elseif slot2 == GAME.MODIFY_MINI_GAME_DATA_DONE then
		slot0.viewComponent:OnModifyMiniGameDataDone(slot3)
	elseif slot2 == GAME.ON_APPLICATION_PAUSE then
		slot0.viewComponent:OnApplicationPaused(slot3)
	end
end

return slot0

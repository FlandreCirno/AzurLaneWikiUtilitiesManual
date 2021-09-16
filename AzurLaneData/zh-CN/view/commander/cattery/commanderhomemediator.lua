slot0 = class("CommanderHomeMediator", import("...base.ContextMediator"))
slot0.ON_CLEAN = "CommanderHomeMediator:ON_CLEAN"
slot0.ON_FEED = "CommanderHomeMediator:ON_FEED"
slot0.ON_PLAY = "CommanderHomeMediator:ON_PLAY"
slot0.ON_SEL_COMMANDER = "CommanderHomeMediator:ON_SEL_COMMANDER"
slot0.ON_CHANGE_STYLE = "CommanderHomeMediator:ON_CHANGE_STYLE"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_CLEAN, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 1
		})
	end)
	slot0.bind(slot0, slot0.ON_FEED, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 2
		})
	end)
	slot0.bind(slot0, slot0.ON_PLAY, function (slot0, slot1)
		slot0:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 3
		})
	end)
	slot0.bind(slot0, slot0.ON_SEL_COMMANDER, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.PUT_COMMANDER_IN_CATTERY, {
			id = slot1,
			commanderId = slot2
		})
	end)
	slot0.bind(slot0, slot0.ON_CHANGE_STYLE, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.COMMANDER_CHANGE_CATTERY_STYLE, {
			id = slot1,
			styleId = slot2
		})
	end)
	slot0.viewComponent.SetHome(slot1, getProxy(CommanderProxy):GetCommanderHome())
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.PUT_COMMANDER_IN_CATTERY_DONE,
		GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE,
		GAME.COMMANDER_CATTERY_OP_DONE,
		GAME.ZERO_HOUR_OP_DONE,
		GAME.CALC_CATTERY_EXP_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.PUT_COMMANDER_IN_CATTERY_DONE then
		slot0.viewComponent:OnCatteryUpdate(slot3.id)
	elseif slot2 == GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE then
		slot0.viewComponent:OnCatteryStyleUpdate(slot3.id)
	elseif slot2 == GAME.COMMANDER_CATTERY_OP_DONE then
		slot0.viewComponent.forbiddenClose = true

		seriesAsync({
			function (slot0)
				slot0.viewComponent:OnCatteryOPDone()
				slot0.viewComponent:OnOpAnimtion(slot1.cmd, slot1.opCatteries, slot0)
			end,
			function (slot0)
				slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot1.awards, slot0)

				slot0.viewComponent.forbiddenClose = false
			end,
			function (slot0)
				slot1.viewComponent:OnDisplayAwardDone(slot0)
			end
		})
	elseif slot2 == GAME.ZERO_HOUR_OP_DONE then
		slot0.viewComponent.OnZeroHour(slot4)
	elseif slot2 == GAME.CALC_CATTERY_EXP_DONE then
		slot0.viewComponent:OnCommanderExpChange(slot3.commanderExps)
	end
end

return slot0

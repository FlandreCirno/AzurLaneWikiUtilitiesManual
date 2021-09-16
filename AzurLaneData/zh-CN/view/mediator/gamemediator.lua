slot0 = class("GameMediator", pm.Mediator)

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.GO_SCENE,
		GAME.GO_MINI_GAME,
		GAME.LOAD_SCENE_DONE,
		GAME.SEND_CMD_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()
	slot4 = nil

	if slot1:getName() == GAME.GO_SCENE then
		Context.New().extendData(slot4, slot5)
		SCENE.SetSceneInfo(slot4, slot3)
		print("load scene: " .. slot3)
		slot0:sendNotification(GAME.LOAD_SCENE, {
			context = Context.New()
		})
	elseif slot2 == GAME.GO_MINI_GAME then
		Context.New().extendData(slot4, {
			miniGameId = slot3
		})

		Context.New().mediator = require("view.miniGame.gameMediator." .. pg.mini_game[slot3].mediator_name)
		Context.New().viewComponent = require("view.miniGame.gameView." .. pg.mini_game[slot3].view_name)
		Context.New().scene = pg.mini_game[slot3].view_name

		print("load minigame: " .. pg.mini_game[slot3].view_name)
		table.merge(slot9, slot10)
		slot0:sendNotification(GAME.LOAD_SCENE, {
			context = Context.New()
		})
	elseif slot2 == GAME.LOAD_SCENE_DONE then
		print("scene loaded: ", slot3)

		if slot3 == SCENE.LOGIN then
			pg.UIMgr.GetInstance():displayLoadingBG(false)
			pg.UIMgr.GetInstance():LoadingOff()
		end
	elseif slot2 == GAME.SEND_CMD_DONE then
	end
end

return slot0

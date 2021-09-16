class("ChangeSceneCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot6 = Context.New()

	slot6:extendData(slot3)
	SCENE.SetSceneInfo(slot6, slot2)
	slot0:sendNotification(GAME.LOAD_SCENE, {
		prevContext = getProxy(ContextProxy).popContext(slot4),
		context = slot6
	})
end

return class("ChangeSceneCommand", pm.SimpleCommand)

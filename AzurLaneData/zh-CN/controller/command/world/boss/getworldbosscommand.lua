class("GetWorldBossCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody() or {}.callback

	if not nowWorld.worldBossProxy then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(34501, {
		type = 0
	}, 34502, function (slot0)
		slot0.worldBossProxy.Setup(slot1, slot0)
		slot1:sendNotification(GAME.WORLD_GET_BOSS_DONE)

		if not slot0.worldBossProxy:IsOpen() and slot1:GetSelfBoss() ~= nil then
			print("Notification : boss is overtime")
			pg.ConnectionMgr.GetInstance():Send(34513, {
				type = 0
			}, 34514, function (slot0)
				return
			end)
		end

		if slot2 then
			slot2()
		end
	end)
end

return class("GetWorldBossCommand", pm.SimpleCommand)

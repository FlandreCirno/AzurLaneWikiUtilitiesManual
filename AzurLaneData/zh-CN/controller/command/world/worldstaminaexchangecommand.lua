class("WorldStaminaExchangeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot3 = getProxy(PlayerProxy)
	slot5, slot6, slot7, slot8 = nowWorld.staminaMgr.GetExchangeData(slot4)

	pg.ConnectionMgr.GetInstance():Send(33108, {
		type = 1
	}, 33109, function (slot0)
		if slot0.result == 0 then
			slot1 = slot0:getData()

			slot1:consume({
				oil = slot1
			})
			slot0:updatePlayer(slot1)
			slot0.updatePlayer:ExchangeStamina(slot0.updatePlayer, true)
			slot4:sendNotification(GAME.WORLD_STAMINA_EXCHANGE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_stamina_exchange_err_", slot0.result))
		end
	end)
end

return class("WorldStaminaExchangeCommand", pm.SimpleCommand)

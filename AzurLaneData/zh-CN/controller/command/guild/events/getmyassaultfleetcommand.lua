class("GetMyAssaultFleetCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(61009, {
		type = 0
	}, 61010, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(GuildProxy)
			slot2 = slot1:getData()

			_.each(slot0.person_ships, function (slot0)
				slot0[slot0.pos] = Ship.New(slot0.ship)
				Ship.New(slot0.ship)[slot0.pos] = slot0.last_time
			end)
			GuildAssaultFleet.New({}).InitShips(slot5, slot3, slot6)
			slot2:getMemberById(slot3).UpdateExternalAssaultFleet(slot4, slot5)
			slot1:updateGuild(slot2)

			slot1.isFetchAssaultFleet = true

			for slot11, slot12 in ipairs(slot7) do
				slot1:UpdatePosCdTime(slot11, slot12)
			end

			slot0:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET_DONE)

			if slot1 then
				slot1()
			end

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
	end)
end

return class("GetMyAssaultFleetCommand", import(".GuildEventBaseCommand"))

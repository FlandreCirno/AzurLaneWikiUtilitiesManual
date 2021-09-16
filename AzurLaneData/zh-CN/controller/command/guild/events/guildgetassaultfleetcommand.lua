class("GuildGetAssaultFleetCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback

	if not getProxy(GuildProxy):ShouldRequestForamtion() then
		if slot3 then
			slot3()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(61011, {
		type = 0
	}, 61012, function (slot0)
		if slot0.result == 0 then
			slot1 = slot0:getData()
			slot2 = {}
			slot3 = ipairs
			slot4 = slot0.recommends or {}

			for slot6, slot7 in slot3(slot4) do
				if not slot2[slot7.user_id] then
					slot2[slot7.user_id] = {}
				end

				table.insert(slot2[slot7.user_id], slot7.ship_id)
			end

			for slot6, slot7 in ipairs(slot0.ships) do
				if slot1:getMemberById(slot7.user_id) then
					slot10 = GuildAssaultFleet.New(slot7)

					if slot2[slot9.id] then
						slot10:SetRecommendList(slot11)
					end

					slot9:UpdateAssaultFleet(slot10)
				end
			end

			slot0:updateGuild(slot1)
			slot1:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")

			if slot2 then
				slot2()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildGetAssaultFleetCommand", import(".GuildEventBaseCommand"))

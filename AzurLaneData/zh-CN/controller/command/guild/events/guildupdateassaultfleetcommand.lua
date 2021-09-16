class("GuildUpdateAssaultFleetCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = slot1:getBody().fleet
	slot4 = slot1.getBody().callBack

	if getProxy(GuildProxy).getData(slot5):GetActiveEvent() and slot7:GetBossMission() and slot8:IsActive() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

		return
	end

	if not slot6:getMemberById(slot8):GetExternalAssaultFleet() then
		return
	end

	if not slot3 then
		return
	end

	if not slot10:AnyShipChanged(slot3) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_must_edit_fleet"))

		return
	end

	slot11 = {}

	for slot16, slot17 in pairs(slot12) do
		if slot10:PositionIsChanged(slot3, slot16) then
			table.insert(slot11, {
				pos = slot16,
				shipId = GuildAssaultFleet.GetRealId(slot17.id)
			})
		end
	end

	pg.ConnectionMgr.GetInstance():Send(61003, {
		shipIds = slot11
	}, 61004, function (slot0)
		if slot0.result == 0 then
			for slot4, slot5 in ipairs(slot0) do
				slot1:UpdatePosCdTime(slot5.pos, pg.TimeMgr.GetInstance():GetServerTime())
			end

			slot2:UpdateAssaultFleet(slot3)
			slot2:UpdateExternalAssaultFleet(slot3)
			slot2.UpdateExternalAssaultFleet:updateGuild(slot4)
			slot5:sendNotification(GAME.GUILD_UPDATE_MY_ASSAULT_FLEET_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end

		if slot6 then
			slot6()
		end
	end)
end

return class("GuildUpdateAssaultFleetCommand", import(".GuildEventBaseCommand"))

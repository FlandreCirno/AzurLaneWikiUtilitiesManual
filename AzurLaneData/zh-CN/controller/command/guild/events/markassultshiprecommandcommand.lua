class("MarkAssultShipRecommandCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().shipId
	slot4 = slot1.getBody().cmd

	if not getProxy(GuildProxy):getRawData() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_no_exist"))

		return
	end

	if not GuildMember.IsAdministrator(slot6:getSelfDuty()) then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_commander_and_sub_op"))

		return
	end

	print(slot8, slot9, slot4)
	pg.ConnectionMgr.GetInstance():Send(61033, {
		recommend_uid = GuildAssaultFleet.GetUserId(slot3),
		recommend_shipid = GuildAssaultFleet.GetRealId(slot3),
		cmd = slot4
	}, 61034, function (slot0)
		if slot0.result == 0 then
			slot1 = slot0:getData()
			slot2 = slot1:getMemberById(slot1)
			slot3 = slot2:GetAssaultFleet()

			if slot2 == GuildConst.RECOMMAND_SHIP then
				slot3:SetShipBeRecommanded(slot3, true)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_assult_ship_recommend"))
			elseif slot2 == GuildConst.CANCEL_RECOMMAND_SHIP then
				slot3:SetShipBeRecommanded(slot3, false)
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_cancel_assult_ship_recommend"))
			end

			slot0:updateGuild(slot1)
			slot0.updateGuild:sendNotification(GAME.GUILD_RECOMMAND_ASSULT_SHIP_DONE, {
				shipId = slot0.updateGuild
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("MarkAssultShipRecommandCommand", pm.SimpleCommand)

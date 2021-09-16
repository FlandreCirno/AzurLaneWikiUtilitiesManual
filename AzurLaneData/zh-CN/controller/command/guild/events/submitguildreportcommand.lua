class("SubmitGuildReportCommand", import(".GuildEventBaseCommand")).execute = function (slot0, slot1)
	slot3 = slot1:getBody().ids

	if getProxy(GuildProxy).getRawData(slot4).getMemberById(slot5, slot6):IsRecruit() then
		pg.TipsMgr:GetInstance():ShowTips(i18n("guild_duty_is_too_low"))

		return
	end

	if _.any(slot3, function (slot0)
		return not slot0:GetReportById(slot0):CanSubmit()
	end) then
		pg.TipsMgr.GetInstance(slot8):ShowTips(i18n("guild_get_report_failed"))

		return
	end

	slot8 = slot2.callback

	pg.ConnectionMgr.GetInstance():Send(61019, {
		ids = slot3
	}, 61020, function (slot0)
		if slot0.result == 0 then
			slot1 = PlayerConst.addTranDrop(slot0.drop_list)

			for slot5, slot6 in ipairs(slot0) do
				slot1:GetReportById(slot6):Submit()
			end

			slot2:sendNotification(GAME.SUBMIT_GUILD_REPORT_DONE, {
				awards = slot1,
				list = slot0,
				callback = slot2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("SubmitGuildReportCommand", import(".GuildEventBaseCommand"))

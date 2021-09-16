class("CommanderChangeCatteryStyleCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().id
	slot4 = slot1.getBody().styleId

	if not getProxy(CommanderProxy):GetCommanderHome() then
		return
	end

	if not slot6:GetCatteryById(slot3) then
		return
	end

	if slot7:GetStyle() == slot4 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25032, {
		slotidx = slot3,
		styleidx = slot4
	}, 25033, function (slot0)
		if slot0.result == 0 then
			slot0:UpdateStyle(slot0.UpdateStyle)
			pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_style_change_success"))
			pg.TipsMgr.GetInstance():sendNotification(GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE, {
				id = slot0.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("CommanderChangeCatteryStyleCommand", pm.SimpleCommand)

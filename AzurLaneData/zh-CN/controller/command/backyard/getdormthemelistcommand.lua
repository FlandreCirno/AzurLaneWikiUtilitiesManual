class("GetDormThemeListCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = 0
	slot4 = nil

	if slot1:getBody() and type(slot2) == "table" then
		slot4 = slot2.callback
	else
		pg.ConnectionMgr.GetInstance():Send(19018, {
			id = slot2 or 0
		}, 19019, function (slot0)
			slot1 = getProxy(DormProxy)

			if slot0 == 0 then
				slot1:initThemes(slot0.theme_list or {})
			else
				for slot5, slot6 in ipairs(slot0.theme_list) do
					slot1:updateTheme(slot6)
				end
			end

			slot1:sendNotification(GAME.GET_DORMTHEME_DONE)

			if slot1.sendNotification then
				slot2()
			end
		end)

		return
	end
end

return class("GetDormThemeListCommand", pm.SimpleCommand)

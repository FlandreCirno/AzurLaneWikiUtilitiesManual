class("BackYardSeachThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not slot1:getBody().str or slot3 == "" then
		slot0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO)

		return
	end

	function slot4(slot0)
		slot0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_DONE, {
			template = BackYardThemeTemplate.New({
				id = slot0.theme.id,
				name = slot0.theme.name,
				furniture_put_list = slot0.theme.furniture_put_list,
				user_id = slot0.theme.user_id,
				pos = slot0.theme.pos,
				like_count = slot0.theme.like_count,
				fav_count = slot0.theme.fav_count,
				upload_time = slot0.theme.upload_time,
				is_collection = (slot0.has_fav and 1) or 0,
				is_like = (slot0.has_like and 1) or 0,
				image_md5 = slot0.theme.image_md5,
				icon_image_md5 = slot0.theme.icon_image_md5
			})
		})
	end

	function slot5(slot0)
		slot0:sendNotification(GAME.BACKYARD_SEARCH_THEME_TEMPLATE_ERRO)
	end

	pg.ConnectionMgr.GetInstance().Send(slot6, 19113, {
		theme_id = slot3
	}, 19114, function (slot0)
		if slot0.result == 0 then
			slot0(slot0)
		else
			slot1(slot0)

			if slot0.result == 20 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_not_found_theme_template"))
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end
	end)
end

return class("BackYardSeachThemeTemplateCommand", pm.SimpleCommand)

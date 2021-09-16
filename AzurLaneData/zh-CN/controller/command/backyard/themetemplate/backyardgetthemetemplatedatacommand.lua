class("BackYardGetThemeTemplateDataCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(19113, {
		theme_id = slot1.getBody().templateId
	}, 19114, function (slot0)
		if slot0.result == 0 then
			slot4 = BackYardThemeTemplate.New({
				is_fetch = true,
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

			if getProxy(DormProxy):GetShopThemeTemplateById(slot0) then
				slot5:UpdateShopThemeTemplate(slot4)
			end

			if slot5:GetCollectionThemeTemplateById(slot0) then
				slot5:UpdateCollectionThemeTemplate(slot4)
			end

			if slot1 then
				slot1(slot4)
			end

			slot2:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DATA_DONE, {
				template = slot4
			})
		elseif slot0.result == 20 then
			if getProxy(DormProxy):GetShopThemeTemplateById(slot0) then
				slot1:DeleteShopThemeTemplate(slot0)
			end

			if slot1:GetCollectionThemeTemplateById(slot0) then
				slot1:DeleteCollectionThemeTemplate(slot0)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("Backyard_theme_template_be_delete_tip"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("BackYardGetThemeTemplateDataCommand", pm.SimpleCommand)

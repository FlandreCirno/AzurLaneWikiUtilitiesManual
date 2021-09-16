class("BackYardLikeThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	function slot5(slot0)
		if getProxy(DormProxy):GetCollectionThemeTemplateById(slot0) then
			slot2:AddLike()
			slot1:UpdateCollectionThemeTemplate(slot2)
		end

		if slot1:GetShopThemeTemplateById(slot0) then
			slot3:AddLike()
			slot1:UpdateShopThemeTemplate(slot3)
		end

		slot1:sendNotification(GAME.BACKYARD_LIKE_THEME_TEMPLATE_DONE)
	end

	pg.ConnectionMgr.GetInstance().Send(slot6, 19121, {
		theme_id = slot1:getBody().templateId,
		upload_time = slot1.getBody().uploadTime
	}, 19122, function (slot0)
		if slot0.result == 0 then
			slot0(slot0)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("BackYardLikeThemeTemplateCommand", pm.SimpleCommand)

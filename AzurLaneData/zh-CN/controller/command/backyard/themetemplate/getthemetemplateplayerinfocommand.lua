class("GetThemeTemplatePlayerInfoCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot4 = slot2.templateId
	slot5 = slot2.userId
	slot6 = slot2.callback
	slot7 = getProxy(DormProxy)

	if slot2.type == BackYardConst.THEME_TEMPLATE_TYPE_SHOP or slot3 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		function slot8(slot0)
			if slot0:GetShopThemeTemplateById(Player.New(slot0.player)) then
				slot2:SetPlayerInfo(slot1)
				slot0:UpdateShopThemeTemplate(slot2)
			end

			if slot0:GetCollectionThemeTemplateById(slot1) then
				slot3:SetPlayerInfo(slot1)
				slot0:UpdateCollectionThemeTemplate(slot3)
			end

			if slot2 then
				slot2(slot1)
			end
		end

		pg.ConnectionMgr.GetInstance().Send(slot9, 50113, {
			user_id = slot5
		}, 50114, function (slot0)
			if slot0.result == 0 then
				slot0(slot0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end)

		return
	end

	if slot3 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		slot8 = getProxy(PlayerProxy).getData(slot8)

		if slot7:GetCustomThemeTemplateById(slot4) then
			slot9:SetPlayerInfo(slot8)
			slot7:UpdateCustomThemeTemplate(slot9)
		end

		if slot6 then
			slot6(slot8)
		end
	end
end

return class("GetThemeTemplatePlayerInfoCommand", pm.SimpleCommand)

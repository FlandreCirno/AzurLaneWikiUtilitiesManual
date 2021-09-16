class("BackYardGetThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().callback
	slot5 = getProxy(DormProxy)

	function slot6(slot0, slot1)
		if slot0 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			slot2 = {}
			slot3 = ipairs
			slot4 = slot0.theme_id_list or {}

			for slot6, slot7 in slot3(slot4) do
				slot8 = nil

				BackYardThemeTemplate.New({
					id = slot7
				}):SetSortIndex(slot6)

				slot2[BackYardThemeTemplate.New().id] = BackYardThemeTemplate.New()
			end

			slot1:SetShopThemeTemplates(slot2)
		elseif slot0 == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			slot2 = {}
			slot3 = ipairs
			slot4 = slot0.theme_list or {}

			for slot6, slot7 in slot3(slot4) do
				slot8 = nil
				slot2[BackYardSelfThemeTemplate.New(slot7).id] = BackYardSelfThemeTemplate.New(slot7)
			end

			slot1:SetCustomThemeTemplates(slot2)
		elseif slot0 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
			slot2 = {}
			slot3 = ipairs
			slot4 = slot0.theme_profile_list or {}

			for slot6, slot7 in slot3(slot4) do
				slot8 = nil
				slot2[BackYardThemeTemplate.New({
					id = slot7.id,
					upload_time = slot7.upload_time
				}).id] = BackYardThemeTemplate.New()
			end

			slot1:SetCollectionThemeTemplates(slot2)
		end

		if slot1 then
			slot1()
		end
	end

	function slot7(slot0)
		slot0:sendNotification(GAME.BACKYARD_GET_IMG_MD5, {
			type = slot0.sendNotification,
			callback = slot0
		})
	end

	function slot8(slot0)
		seriesAsync({
			function (slot0)
				slot0(slot0, slot0)
			end,
			function (slot0)
				slot0(slot0)
			end
		}, function ()
			slot0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DONE)

			if slot0 then
				slot1()
			end
		end)
	end

	if slot1.getBody().type == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		pg.ConnectionMgr.GetInstance().Send(slot9, 19105, {
			typ = slot3
		}, 19106, function (slot0)
			if slot0.result == 0 then
				slot0(slot0)
				slot0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE_DONE)

				if slot0 then
					slot2()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end)
	elseif slot3 == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		pg.ConnectionMgr.GetInstance().Send(slot9, 19117, {
			typ = slot5.TYPE,
			page = slot5.PAGE,
			num = BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT
		}, 19118, function (slot0)
			if slot0.result == 0 then
				slot0(slot0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end)
	elseif slot3 == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		pg.ConnectionMgr.GetInstance().Send(slot9, 19115, {
			typ = 3
		}, 19116, function (slot0)
			if slot0.result == 0 then
				slot0(slot0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end)
	end
end

return class("BackYardGetThemeTemplateCommand", pm.SimpleCommand)

class("BackYardRefreshShopTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot3 = slot2.type
	slot5 = slot2.force
	slot7 = false

	if slot2.page == getProxy(DormProxy).MAX_PAGE then
		pg.TipsMgr.GetInstance():ShowTips("backyard_shop_reach_last_page")

		return
	end

	if slot6.lastPages[slot3] < slot4 then
		slot0:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_ERRO)

		return
	end

	function slot8(slot0, slot1)
		slot2 = {}
		slot3 = ipairs
		slot4 = slot0.theme_id_list or {}

		for slot6, slot7 in slot3(slot4) do
			if not slot0:GetShopThemeTemplateById(slot7) then
				slot1 = true
				slot9 = BackYardThemeTemplate.New({
					id = slot7
				})

				slot9:SetSortIndex(slot6)

				slot2[slot9.id] = slot9
			else
				slot8:SetSortIndex(slot6)

				slot2[slot8.id] = slot8
			end
		end

		if table.getCount(slot2) > 0 then
			slot0:SetShopThemeTemplates(slot2)

			slot0.TYPE = slot2
			slot0.PAGE = slot0
		end

		if table.getCount(slot2) < BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT then
			slot0.lastPages[slot2] = slot0.lastPages

			if not slot2 then
			end
		end

		if slot1 then
			slot1()
		end
	end

	function slot9(slot0)
		slot0:sendNotification(GAME.BACKYARD_GET_IMG_MD5, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
			callback = slot0
		})
	end

	function slot10(slot0)
		seriesAsync({
			function (slot0)
				slot0(slot0, slot0)
			end,
			function (slot0)
				slot0(slot0)
			end
		}, function ()
			slot0:sendNotification(GAME.BACKYARD_REFRESH_SHOP_TEMPLATE_DONE, {
				existNew = slot0
			})
		end)
	end

	pg.ConnectionMgr.GetInstance().Send(slot11, 19117, {
		typ = slot3,
		page = slot4,
		num = BackYardConst.THEME_TEMPLATE_SHOP_REFRSH_CNT
	}, 19118, function (slot0)
		if slot0.result == 0 then
			slot0(slot0)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("BackYardRefreshShopTemplateCommand", pm.SimpleCommand)

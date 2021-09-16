class("BackYardDeleteThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = getProxy(DormProxy).GetCustomThemeTemplateById(slot4, slot3)

	function slot6(slot0)
		if not slot0:IsPushed() then
			if slot0 then
				slot0()
			end

			return
		end

		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync({
			function (slot0)
				BackYardThemeTempalteUtil.DeleteTexture(slot0:GetTextureName(), function (slot0)
					if slot0 then
						slot0()
					end
				end)
			end,
			function (slot0)
				BackYardThemeTempalteUtil.DeleteTexture(slot0:GetTextureIconName(), function (slot0)
					if slot0 then
						slot0()
					end
				end)
			end
		}, function ()
			pg.UIMgr.GetInstance():LoadingOff()

			if pg.UIMgr.GetInstance().LoadingOff then
				slot0()
			end
		end)
	end

	function slot7(slot0)
		BackYardThemeTempalteUtil.ClearCaches({
			slot0:GetTextureName(),
			slot0:GetTextureIconName()
		})
		BackYardThemeTempalteUtil.ClearCaches:DeleteCustomThemeTemplate(BackYardThemeTempalteUtil.ClearCaches)

		if BackYardThemeTempalteUtil.ClearCaches.DeleteCustomThemeTemplate:IsInitShopThemeTemplates() then
			if slot1:GetShopThemeTemplateById(slot1) then
				slot1:DeleteShopThemeTemplate(slot1)
			end

			if slot1:GetCollectionThemeTemplateById(slot1) then
				slot1:DeleteCollectionThemeTemplate(slot1)
			end
		end

		slot3:sendNotification(GAME.BACKYARD_DELETE_THEME_TEMPLATE_DONE)
	end

	function slot8()
		pg.ConnectionMgr.GetInstance():Send(19123, {
			pos = slot0.pos
		}, 19124, function (slot0)
			if slot0.result == 0 then
				slot0(slot0)
				slot0()
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end)
	end

	slot8()
end

return class("BackYardDeleteThemeTemplateCommand", pm.SimpleCommand)

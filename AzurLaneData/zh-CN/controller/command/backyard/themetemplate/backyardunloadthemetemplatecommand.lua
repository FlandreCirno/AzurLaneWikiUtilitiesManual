class("BackYardUnloadThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = getProxy(DormProxy).GetCustomThemeTemplateById(slot4, slot3)

	function slot6(slot0)
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
		slot0:UnLoad()
		slot0.UnLoad:UpdateCustomThemeTemplate(slot0)

		if slot1:GetShopThemeTemplateById(slot0.id) then
			slot1:DeleteShopThemeTemplate(slot1)
		end

		if slot1:GetCollectionThemeTemplateById(slot1) then
			slot1:DeleteCollectionThemeTemplate(slot1)
		end

		slot2:sendNotification(GAME.BACKYARD_UNLOAD_THEME_TEMPLATE_DONE)
	end

	function slot8()
		pg.ConnectionMgr.GetInstance():Send(19125, {
			pos = slot0.pos
		}, 19126, function (slot0)
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

return class("BackYardUnloadThemeTemplateCommand", pm.SimpleCommand)

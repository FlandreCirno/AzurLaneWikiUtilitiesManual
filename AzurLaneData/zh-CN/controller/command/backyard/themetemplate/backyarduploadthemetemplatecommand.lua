class("BackYardUploadThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = getProxy(DormProxy).GetCustomThemeTemplateById(slot4, slot3)

	function slot6(slot0)
		pg.UIMgr.GetInstance():LoadingOn()
		seriesAsync({
			function (slot0)
				BackYardThemeTempalteUtil.UploadTexture(slot0:GetTextureName(), function (slot0)
					if slot0 then
						slot0()
					end
				end)
			end,
			function (slot0)
				BackYardThemeTempalteUtil.UploadTexture(slot0:GetTextureIconName(), function (slot0)
					if slot0 then
						slot0()
					end
				end)
			end
		}, function ()
			pg.UIMgr.GetInstance():LoadingOff()
			pg.UIMgr.GetInstance().LoadingOff()
		end)
	end

	function slot7(slot0)
		slot0:Upload()
		slot0.Upload:UpdateCustomThemeTemplate(slot0)
		slot0.Upload:sendNotification(GAME.BACKYARD_UPLOAD_THEME_TEMPLATE_DONE)
	end

	function slot8()
		pg.ConnectionMgr.GetInstance():Send(19111, {
			pos = slot0.pos
		}, 19112, function (slot0)
			if slot0.result == 0 then
				slot0(slot0)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
			end
		end)
	end

	slot6(function ()
		slot0()
	end)
end

return class("BackYardUploadThemeTemplateCommand", pm.SimpleCommand)

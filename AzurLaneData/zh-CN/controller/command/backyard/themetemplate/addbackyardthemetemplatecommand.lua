class("AddBackYardThemeTemplateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4, slot5 = Dorm.checkData(slot1:getBody().furnitureputList, getProxy(DormProxy):getData().level)

	if not slot4 then
		pg.TipsMgr.GetInstance():ShowTips(slot5)

		return
	end

	slot6 = {}

	for slot10, slot11 in pairs(slot2.furnitureputList) do
		slot12 = {}

		for slot16, slot17 in pairs(slot11.child) do
			table.insert(slot12, {
				id = tostring(slot16),
				x = slot17.x,
				y = slot17.y
			})
		end

		table.insert(slot6, {
			shipId = 0,
			id = tostring(slot11.configId),
			x = slot11.x,
			y = slot11.y,
			dir = slot11.dir,
			child = slot12,
			parent = slot11.parent
		})
	end

	pg.ConnectionMgr.GetInstance():Send(19109, {
		pos = slot2.id,
		name = slot2.name,
		furniture_put_list = slot6,
		icon_image_md5 = slot2.iconMd5,
		image_md5 = slot2.imageMd5
	}, 19110, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(DormProxy)
			slot1.id = BackYardBaseThemeTemplate.BuildId(slot0.id)

			slot1:AddCustomThemeTemplate(slot3)
			slot2:sendNotification(GAME.BACKYARD_SAVE_THEME_TEMPLATE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", slot0.result))
		end
	end)
end

return class("AddBackYardThemeTemplateCommand", pm.SimpleCommand)

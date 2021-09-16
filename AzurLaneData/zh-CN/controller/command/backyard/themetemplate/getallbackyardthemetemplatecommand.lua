slot0 = class("GetAllBackYardThemeTemplateCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback
	slot4 = {}
	slot5 = {}
	slot6 = {}

	seriesAsync({
		function (slot0)
			slot0:GetCustomThemeTemplate(function (slot0)
				slot0 = slot0

				slot1()
			end)
		end,
		function (slot0)
			slot0:GetShopThemeTemplate(function (slot0)
				slot0 = slot0

				slot1()
			end)
		end,
		function (slot0)
			slot0:GetCollectionThemeTemplate(function (slot0)
				slot0 = slot0

				slot1()
			end)
		end
	}, function ()
		if slot0 then
			slot0(slot1, slot2, slot3)
		end
	end)
end

function slot1(slot0, slot1)
	slot2 = {}
	slot3 = pairs
	slot4 = slot1 or {}

	for slot6, slot7 in slot3(slot4) do
		table.insert(slot2, slot7)
	end

	return slot2
end

slot0.GetCustomThemeTemplate = function (slot0, slot1)
	if not getProxy(DormProxy):GetCustomThemeTemplates() then
		slot0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
			callback = function ()
				slot0 = slot1:GetCustomThemeTemplates()

				slot2(slot3(slot4, slot2))
			end
		})
	else
		slot1(slot0(slot0, slot3))
	end
end

slot0.GetShopThemeTemplate = function (slot0, slot1)
	getProxy(DormProxy):SetShopThemeTemplates({})
	slot1()
end

slot0.GetCollectionThemeTemplate = function (slot0, slot1)
	if not getProxy(DormProxy):GetCollectionThemeTemplates() then
		slot0:sendNotification(GAME.BACKYARD_GET_THEME_TEMPLATE, {
			type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
			callback = function ()
				slot0 = slot1:GetCollectionThemeTemplates()

				slot2(slot3(slot4, slot2))
			end
		})
	else
		slot1(slot0(slot0, slot3))
	end
end

return slot0

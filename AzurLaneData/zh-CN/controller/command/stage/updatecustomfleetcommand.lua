class("UpdateCustomFleetCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = getProxy(BayProxy).getRawData(slot4)
	slot7 = getProxy(ChapterProxy).getChapterById(slot6, slot3)
	slot8 = slot7:getConfig("formation")
	slot10 = slot7:getEliteFleetCommanders()
	slot11 = {}

	for slot15, slot16 in ipairs(slot9) do
		slot17 = {}
		slot18 = {}
		slot19 = {}

		for slot23, slot24 in ipairs(slot16) do
			slot18[#slot18 + 1] = slot24
		end

		for slot24, slot25 in pairs(slot20) do
			table.insert(slot19, {
				pos = slot24,
				id = slot25
			})
		end

		slot17.map_id = slot8
		slot17.main_id = slot18
		slot17.commanders = slot19
		slot11[#slot11 + 1] = slot17
	end

	pg.ConnectionMgr.GetInstance():Send(13107, {
		id = slot8,
		elite_fleet_list = slot11
	}, 13108, function (slot0)
		if slot0.result == 0 then
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("update_custom_fleet", slot0.result))
		end
	end)
end

return class("UpdateCustomFleetCommand", pm.SimpleCommand)

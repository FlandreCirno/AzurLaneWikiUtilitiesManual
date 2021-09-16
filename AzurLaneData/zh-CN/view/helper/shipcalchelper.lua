slot0 = class("ShipCalcHelper")

slot0.CalcDestoryRes = function (slot0)
	slot1 = 0
	slot2 = 0
	slot3 = {}
	slot4 = false

	for slot8, slot9 in ipairs(slot0) do
		slot10, slot11, slot14 = slot9:calReturnRes()
		slot1 = slot1 + slot10
		slot2 = slot2 + slot11

		for slot16, slot17 in ipairs(slot12) do
			slot18 = slot17[1]
			slot20 = slot17[3]

			if not slot3[slot17[2]] then
				slot3[slot19] = {
					type = slot18,
					id = slot19,
					count = slot20
				}
			else
				slot3[slot19].count = slot3[slot19].count + slot20
			end
		end
	end

	for slot8, slot9 in pairs(slot3) do
		slot10 = pg.item_data_statistics[slot9.id]

		if slot9.count > 0 and slot9.type == DROP_TYPE_VITEM and slot10.virtual_type == 20 then
			slot4 = math.min(pg.gameset.urpt_chapter_max.description[2] - getProxy(BagProxy):GetLimitCntById(slot13), slot9.count) < slot9.count

			if slot16 <= 0 then
				slot3[slot8].count = 0
			else
				slot3[slot8].count = slot16
			end
		end
	end

	table.sort(slot5, function (slot0, slot1)
		return slot0.id < slot1.id
	end)

	return slot1, slot2, _.values(slot3), slot4
end

slot0.GetEliteAndHightLevelShips = function (slot0)
	slot1 = {}
	slot2 = {}

	for slot6, slot7 in ipairs(slot0) do
		if slot7:getRarity() >= 4 then
			table.insert(slot1, slot7)
		elseif slot7.level > 1 then
			table.insert(slot2, slot7)
		end
	end

	return slot1, slot2
end

slot0.GetEliteAndHightLevelAndResOverflow = function (slot0, slot1)
	slot9, slot10 = slot0.GetEliteAndHightLevelShips(slot2)
	slot5, slot6, slot7, slot11 = slot0.CalcDestoryRes(slot2)

	return slot3, slot4, slot8
end

return slot0

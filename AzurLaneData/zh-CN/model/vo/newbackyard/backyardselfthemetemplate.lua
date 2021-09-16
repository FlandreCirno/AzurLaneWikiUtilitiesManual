slot0 = class("BackYardSelfThemeTemplate", import(".BackYardBaseThemeTemplate"))

slot0.GetAllFurniture = function (slot0)
	if not slot0.furnitruesByIds then
		slot1 = slot0:GetRawPutList()
		slot2 = getProxy(DormProxy):getData().level
		slot4 = {}

		for slot8, slot9 in ipairs(slot3) do
			if slot4[tonumber(slot9.id)] then
				slot4[tonumber(slot9.id)].count = slot4[tonumber(slot9.id)].count + 1
			else
				slot4[tonumber(slot9.id)] = {
					count = 1,
					id = tonumber(slot9.id)
				}
			end
		end

		table.insert({}, {
			floor = 1,
			furniture_put_list = slot1 or {}
		})

		slot0.furnitruesByIds = GetBackYardDataCommand.initFurnitures({
			lv = slot2,
			furniture_id_list = _.values(slot4),
			furniture_put_list = slot5
		})
	end

	return slot0.furnitruesByIds
end

slot0.GetWarpFurnitures = function (slot0)
	if not slot0.furnitures then
		slot0.furnitures = {}

		BackYardBaseThemeTemplate.WarpPutInfo2BackYardFurnitrue(slot0.furnitures, getProxy(DormProxy).floor, slot0:GetRawPutList())
	end

	return slot0.furnitures
end

slot0.GetType = function (slot0)
	return BackYardConst.THEME_TEMPLATE_USAGE_TYPE_SELF
end

slot0.IsSystem = function (slot0)
	return false
end

slot0.IsCollected = function (slot0)
	return true
end

slot0.IsLiked = function (slot0)
	return true
end

slot0.UnLoad = function (slot0)
	slot0.time = 0
end

slot0.Upload = function (slot0)
	slot0.time = pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.CanDispaly = function (slot0)
	return slot0:IsPushed() or (not slot1 and slot0:ExistLocalImage())
end

slot0.IsUsing = function (slot0, slot1)
	if table.getCount(slot1) ~= table.getCount(slot0:GetWarpFurnitures()) then
		return false, Vector2(slot3, slot4)
	end

	function slot5(slot0)
		slot1 = {}

		for slot5, slot6 in pairs(slot0) do
			if slot6:getConfig("id") == slot0 then
				table.insert(slot1, slot6)
			end
		end

		return slot1
	end

	for slot9, slot10 in pairs(slot2) do
		if not slot1[slot10.id] then
			return false, 1
		end

		if not slot11:isPaper() then
			if not slot11.position then
				return false, 2
			end

			slot13 = false

			for slot17, slot18 in ipairs(slot12) do
				if slot18:isSame(slot10) then
					slot13 = true

					break
				end
			end

			if not slot13 then
				return false, 3
			end
		end
	end

	return true
end

slot0.GetMissFurnitures = function (slot0, slot1)
	if #slot1 == #slot0:GetWarpFurnitures() then
		return
	end

	slot3 = {}

	slot4(slot2, slot5)
	slot4(slot1, slot6)

	function slot7(slot0)
		return {
			count = 1,
			name = pg.furniture_data_template[slot0].name
		}
	end

	for slot11, slot12 in pairs(slot5) do
		if not slot6[slot11] then
			slot3[slot11] = slot7(slot11)
		elseif slot6[slot11] and slot6[slot11] < slot12 then
			if not slot3[slot11] then
				slot3[slot11] = slot7(slot11)
			end

			slot3[slot11].count = slot12 - slot6[slot11]
		end
	end

	return slot3
end

slot0.getName = function (slot0)
	return slot0:GetName()
end

slot0.getIcon = function (slot0)
	return "themeicon"
end

return slot0

slot0 = class("BackYardThemeTemplate", import(".BackYardBaseThemeTemplate"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.isFetched = slot1.is_fetch
end

slot0.GetType = function (slot0)
	return BackYardConst.THEME_TEMPLATE_USAGE_TYPE_OTHER
end

slot0.ShouldFetch = function (slot0)
	return not slot0.isFetched
end

slot0.GetWarpFurnitures = function (slot0)
	if not slot0.furnitures then
		slot0.furnitures = {}

		BackYardBaseThemeTemplate.WarpPutInfo2BackYardFurnitrue(slot0.furnitures, 1, slot0:GetRawPutList())
	end

	return slot0.furnitures
end

slot0.GetAllFurniture = function (slot0)
	if not slot0.furnitruesByIds then
		slot2 = {}

		for slot6, slot7 in ipairs(slot1) do
			if not slot2[tonumber(slot7.id)] then
				slot2[tonumber(slot7.id)] = {
					id = tonumber(slot7.id),
					count = slot7:getConfig("count")
				}
			end
		end

		table.insert({}, {
			floor = 1,
			furniture_put_list = slot0:GetRawPutList() or {}
		})

		slot0.furnitruesByIds = GetBackYardDataCommand.initFurnitures({
			lv = 4,
			skipCheck = true,
			furniture_id_list = _.values(slot2),
			furniture_put_list = slot3
		})
	end

	return slot0.furnitruesByIds
end

slot0.GetFurnitureCnt = function (slot0)
	if not slot0.furnitureCnts then
		slot0.furnitureCnts = {}

		for slot5, slot6 in ipairs(slot1) do
			if not slot0.furnitureCnts[slot6.id] then
				slot0.furnitureCnts[slot6.id] = 0
			end

			slot0.furnitureCnts[slot6.id] = slot0.furnitureCnts[slot6.id] + 1
		end
	end

	return slot0.furnitureCnts
end

return slot0

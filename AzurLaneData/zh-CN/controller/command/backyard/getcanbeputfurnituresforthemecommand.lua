slot0 = class("GetCanBePutFurnituresForThemeCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot4 = slot1:getBody().callback

	if slot1.getBody().theme:IsOccupyed(slot0.GetAllFloorFurnitures(), getProxy(DormProxy).floor) then
		slot0.SortListForPut(slot3:GetUsableFurnituresForFloor(slot6, slot5))

		if slot4 then
			slot4(false, slot8)
		end
	else
		slot9 = {}

		for slot13, slot14 in pairs(Clone(slot8)) do
			table.insert(slot9, slot14)
		end

		slot0.SortListForPut(slot9)

		if slot4 then
			slot4(true, slot9)
		end
	end
end

slot0.GetAllFloorFurnitures = function ()
	slot0:GetCurrFloorHouse()
	slot0.GetOtherFloorHouse({})

	return 
end

slot0.Insert = function (slot0, slot1)
	for slot6, slot7 in pairs(slot2) do
		slot0[slot7.id] = slot7
	end
end

slot0.GetCurrFloorHouse = function (slot0)
	slot0:Insert(getBackYardProxy(BackYardHouseProxy).getData(slot1))
end

slot0.GetOtherFloorHouse = function (slot0)
	slot0:Insert(StartUpBackYardCommand.GetHouseByDorm({
		furnitures = getProxy(DormProxy):getData().getOtherFloorFurnitrues(slot1, getProxy(DormProxy).floor)
	}))
end

slot0.IsUsing = function (slot0)
	GetCanBePutFurnituresForThemeCommand.GetCurrFloorHouse(slot1)
	GetCanBePutFurnituresForThemeCommand.GetOtherFloorHouse({})

	return slot0.id ~= "" and (slot0:IsUsing(slot1) or slot0:IsUsing(slot2))
end

slot0.SortListForPut = function (slot0)
	slot1 = pg.furniture_data_template

	table.sort(slot0, function (slot0, slot1)
		if ((slot0.parent ~= 0 and 1) or 0) == ((slot1.parent ~= 0 and 1) or 0) then
			if ((slot0[slot0.id] and slot0[slot0.id].type == Furniture.TYPE_STAGE and 1) or 0) == ((slot0[slot1.id] and slot0[slot1.id].type == Furniture.TYPE_STAGE and 1) or 0) then
				return table.getCount(slot1.child or {}) < table.getCount(slot0.child or {})
			else
				return slot5 < slot4
			end
		else
			return slot0.parent < slot1.parent
		end
	end)
end

return slot0

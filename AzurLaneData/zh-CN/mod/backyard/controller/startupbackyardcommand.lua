slot0 = class("StartUpBackYardCommand", pm.SimpleCommand)

slot0.GetHouseByDorm = function (slot0)
	slot1 = {}
	slot2 = pairs
	slot3 = slot0.ships or {}

	for slot5, slot6 in slot2(slot3) do
		slot1[slot5] = BackyardBoatVO.New(slot6)
	end

	slot2 = {}
	slot3, slot4 = nil

	for slot8, slot9 in pairs(slot0.furnitures) do
		slot10 = slot9:getConfig("type")

		if slot9.position and slot10 == Furniture.TYPE_WALLPAPER then
			slot3 = BackyardFurnitureVO.New(slot9)
		elseif slot9.position and slot10 == Furniture.TYPE_FLOORPAPER then
			slot4 = BackyardFurnitureVO.New(slot9)
		elseif slot9.position then
			slot2[slot8] = BackyardFurnitureVO.New(slot9)
		end
	end

	return BackYardHouseVO.New({
		ships = slot1,
		furnitures = slot2,
		level = slot0.level or 1,
		wallPaper = slot3,
		floorPaper = slot4
	})
end

slot0.execute = function (slot0, slot1)
	slot3 = slot0.GetHouseByDorm(slot2)

	if slot3:getEmptyGridCount() < table.getCount(slot3.ships) then
		slot6 = slot5 - slot4

		for slot10, slot11 in pairs(slot3.ships) do
			if slot6 == 0 then
				break
			end

			slot6 = slot6 - 1
			slot3.ships[slot10] = nil

			pg.m02:sendNotification(GAME.EXIT_SHIP, {
				shipId = slot10
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_notPosition_shipExit"))
		end
	end

	pg.backyard:registerProxy(BackYardHouseProxy.New(slot3))
end

return slot0

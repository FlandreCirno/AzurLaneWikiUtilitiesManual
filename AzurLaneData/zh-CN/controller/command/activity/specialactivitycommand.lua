slot0 = class("SpecialActivityCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot2 = getProxy(ActivityProxy):getActivityById(ActivityConst.ACT_NPC_SHIP_ID)

	if not getProxy(BayProxy).isClearNpc and (not slot2 or slot2:isEnd()) then
		for slot8, slot9 in pairs(slot4) do
			if slot9:isActivityNpc() then
				slot0:unloadEquipments(slot9)
				slot0:checkChapters(slot9)
				slot0:checkFormations(slot9)
				slot0:checkNavTactics(slot9)
				slot3:removeShipById(slot9.id)
			end
		end

		slot3.isClearNpc = true
	end

	if getProxy(ActivityProxy):getActiveBannerByType(GAMEUI_BANNER_10) then
		pg.item_data_statistics[50004].icon = "Props/" .. slot4.pic
		pg.item_data_statistics[50004].name = string.split(slot4.param, "|")[1]
		pg.item_data_statistics[50004].display = string.split(slot4.param, "|")[2]
	end
end

slot0.unloadEquipments = function (slot0, slot1)
	slot2 = getProxy(EquipmentProxy)

	for slot7, slot8 in pairs(slot3) do
		if slot8 then
			slot1:updateEquip(slot7, nil)
			slot2:addEquipmentById(slot8.id, 1)
		end

		if slot1:getEquipSkin(slot7) ~= 0 then
			slot1:updateEquipmentSkin(slot7, 0)
			slot2:addEquipmentSkin(slot8.skinId, 1)
		end
	end
end

slot0.checkChapters = function (slot0, slot1)
	if getProxy(ChapterProxy):getActiveChapter() then
		for slot8, slot9 in pairs(slot4) do
			if slot9:containsShip(slot1.id) then
				slot0:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRetreat
				})

				break
			end
		end
	end
end

slot0.checkFormations = function (slot0, slot1)
	for slot7, slot8 in pairs(slot3) do
		if slot8:containShip(slot1) then
			slot8:removeShip(slot1)
			slot2:updateFleet(slot8)
		end
	end
end

slot0.checkNavTactics = function (slot0, slot1)
	for slot7, slot8 in ipairs(slot3) do
		if slot8.shipId == slot1.id then
			slot2:deleteStudent(slot8.id)

			break
		end
	end
end

return slot0

slot0 = class("MetaCharActiveEnergyCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	if not getProxy(BayProxy):getShipById(slot1:getBody().shipId) then
		return
	end

	if not slot5:getMetaCharacter().getBreakOutInfo(slot6):getNextInfo() then
		return
	end

	slot9, slot10 = slot7:getLimited()

	if slot5.level < slot9 or slot6:getCurRepairExp() < slot10 then
		pg.TipsMgr.GetInstance():ShowTips("level or repair progress is not enough")

		return
	end

	slot11, slot12 = slot7:getConsume()

	if getProxy(PlayerProxy):getData().gold < slot11 then
		pg.TipsMgr.GetInstance():ShowTips("gold not enough")

		return
	end

	slot14 = getProxy(BagProxy)

	if _.any(slot12, function (slot0)
		return slot0:getItemCountById(slot0.itemId) < slot0.count
	end) then
		pg.TipsMgr.GetInstance().ShowTips(slot15, "item not enough")

		return
	end

	print("63303 meta energy", slot5.id)
	pg.ConnectionMgr.GetInstance():Send(63303, {
		ship_id = slot5.id
	}, 63304, function (slot0)
		if slot0.result == 0 then
			print("63304 meta energy success", slot0.id)

			slot1 = Clone(slot0)

			slot1:updateStar(slot0, slot1.configId, slot2.id)
			slot1:updateShip(slot0)

			if getProxy(CollectionProxy):getShipGroup(slot1.groupId) then
				slot3.star = slot0:getStar()

				slot2:updateShipGroup(slot3)
			end

			slot4:consume({
				gold = slot4
			})
			getProxy(PlayerProxy):updatePlayer(getProxy(PlayerProxy).updatePlayer)

			for slot7, slot8 in pairs(slot6) do
				slot1:sendNotification(GAME.CONSUME_ITEM, Item.New({
					count = slot8.count,
					id = slot8.itemId,
					type = DROP_TYPE_ITEM
				}))
			end

			getProxy(MetaCharacterProxy).getMetaProgressVOByID(slot4, slot7.id).updateShip(slot5, slot0)
			slot1:sendNotification(GAME.ENERGY_META_ACTIVATION_DONE, {
				newShip = slot0,
				oldShip = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", slot0.result))
		end
	end)
end

slot0.updateStar = function (slot0, slot1, slot2, slot3)
	slot1.configId = slot3

	for slot8, slot9 in ipairs(pg.ship_data_template[slot1.configId].buff_list) do
		if not slot1.skills[slot9] then
			slot1.skills[slot9] = {
				exp = 0,
				level = 1,
				id = slot9
			}
		end
	end

	slot1:updateMaxLevel(slot4.max_level)

	for slot9, slot10 in ipairs(slot5) do
		if not table.contains(slot4.buff_list, slot10) then
			slot1.skills[slot10] = nil
		end
	end
end

return slot0

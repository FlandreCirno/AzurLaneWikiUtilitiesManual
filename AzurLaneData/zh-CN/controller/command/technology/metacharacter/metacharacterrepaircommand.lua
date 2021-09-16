class("MetaCharacterRepairCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot9 = getProxy(BayProxy).getShipById(slot5, slot3).getMetaCharacter(slot6).getAttrVO(slot7, slot4).getItem(slot8)

	if getProxy(BagProxy):getItemCountById(slot9:getItemId()) < slot9:getTotalCnt() then
		return
	end

	if slot8:isMaxLevel() then
		return
	end

	print("63301 meta repair:", slot3, slot9.id)
	pg.ConnectionMgr.GetInstance():Send(63301, {
		ship_id = slot3,
		repair_id = slot9.id
	}, 63302, function (slot0)
		if slot0.result == 0 then
			print("63302 meta repair success:")
			slot0:levelUp()
			slot0.levelUp:updateShip(slot0.levelUp)

			slot2 = getProxy(MetaCharacterProxy).getMetaProgressVOByID(slot1, slot3.id)

			slot2:updateShip(slot2)
			slot2:sendNotification(GAME.CONSUME_ITEM, Item.New({
				count = slot5,
				id = slot6,
				type = DROP_TYPE_ITEM
			}))
			slot2:sendNotification(GAME.REPAIR_META_CHARACTER_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", slot0.result))
		end
	end)
end

return class("MetaCharacterRepairCommand", pm.SimpleCommand)

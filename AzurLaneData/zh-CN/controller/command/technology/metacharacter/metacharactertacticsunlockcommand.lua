class("MetaCharacterTacticsUnlockCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot6 = slot2.materialInfo

	print("63311 unlock skill", tostring(slot3), tostring(slot4), tostring(slot5))
	pg.ConnectionMgr.GetInstance():Send(63311, {
		ship_id = slot2.shipID,
		skill_id = slot2.skillID,
		index = slot2.materialIndex
	}, 63312, function (slot0)
		if slot0.result == 0 then
			print("63312 unlock success")

			slot1 = getProxy(BayProxy)
			slot2 = slot1:getShipById(slot0)
			slot3 = slot2:isAllMetaSkillLock()

			slot2:upSkillLevelForMeta(slot1)
			slot1:updateShip(slot2)
			slot2:sendNotification(GAME.CONSUME_ITEM, Item.New({
				count = slot3.count,
				id = slot3.id,
				type = DROP_TYPE_ITEM
			}))
			getProxy(MetaCharacterProxy):unlockMetaTacticsSkill(slot0, slot1, slot3)
			slot2:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL_DONE, {
				metaShipID = slot0,
				unlockSkillID = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", slot0.result))
		end
	end)
end

return class("MetaCharacterTacticsUnlockCommand", pm.SimpleCommand)

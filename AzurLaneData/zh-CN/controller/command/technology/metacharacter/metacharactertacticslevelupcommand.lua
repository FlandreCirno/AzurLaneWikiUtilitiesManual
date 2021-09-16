class("MetaCharacterTacticsLevelUpCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	print("63309 skill levelup", tostring(slot3), tostring(slot4))
	pg.ConnectionMgr.GetInstance():Send(63309, {
		ship_id = slot1:getBody().shipID,
		skill_id = slot1.getBody().skillID
	}, 63310, function (slot0)
		if slot0.result == 0 then
			print("63310 skill levelup success")

			slot1 = getProxy(BayProxy)
			slot2 = slot1:getShipById(slot0)

			slot2:upSkillLevelForMeta(slot1)
			slot1:updateShip(slot2)
			slot2:sendNotification(GAME.TACTICS_META_LEVELUP_SKILL_DONE, {
				skillID = slot1,
				leftSwitchCount = slot0.switch_cnt
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", slot0.result))
		end
	end)
end

return class("MetaCharacterTacticsLevelUpCommand", pm.SimpleCommand)

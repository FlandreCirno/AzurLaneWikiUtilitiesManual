class("MetaCharacterTacticsSwitchCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	print("63307 switch skill", tostring(slot3), tostring(slot4))
	pg.ConnectionMgr.GetInstance():Send(63307, {
		ship_id = slot1:getBody().shipID,
		skill_id = slot1.getBody().skillID
	}, 63308, function (slot0)
		if slot0.result == 0 then
			print("63308 switch success")
			getProxy(MetaCharacterProxy):switchMetaTacticsSkill(slot0, getProxy(MetaCharacterProxy).switchMetaTacticsSkill)
			getProxy(MetaCharacterProxy):tryRemoveMetaSkillLevelMaxInfo(slot0, getProxy(MetaCharacterProxy).tryRemoveMetaSkillLevelMaxInfo)
			getProxy(MetaCharacterProxy):sendNotification(GAME.TACTICS_META_SWITCH_SKILL_DONE, {
				metaShipID = slot0,
				skillID = slot0.switch_cnt,
				leftSwitchCount = slot0.switch_cnt
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", slot0.result))
		end
	end)
end

return class("MetaCharacterTacticsSwitchCommand", pm.SimpleCommand)

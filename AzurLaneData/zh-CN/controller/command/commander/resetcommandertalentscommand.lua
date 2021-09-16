class("ResetCommanderTalentsCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not getProxy(CommanderProxy):getCommanderById(slot1:getBody().id) then
		return
	end

	if pg.TimeMgr.GetInstance():GetServerTime() < slot5.abilityTime then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_time_no_rearch"))

		return
	end

	if #slot5:getTalentOrigins() == #slot5:getTalents() and _.all(slot6, function (slot0)
		return _.any(slot0, function (slot0)
			return slot0.id == slot0.id
		end)
	end) then
		pg.TipsMgr.GetInstance().ShowTips(slot8, i18n("commander_reset_talent_is_not_need"))

		return
	end

	if getProxy(PlayerProxy).getData(slot8).gold < slot5:getResetTalentConsume() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25014, {
		commanderid = slot3
	}, 25015, function (slot0)
		if slot0.result == 0 then
			slot0:consume({
				gold = slot0.consume
			})
			slot0:updatePlayer(slot0)
			slot3:resetTalents()
			slot3:updatePt(0)
			slot3:updateNotLearnedList({})
			slot4:updateCommander()
			slot3:updateAbilityTime(pg.TimeMgr.GetInstance():GetServerTime())
			slot5:sendNotification(GAME.COMMANDER_RESET_TALENTS_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reset_talent_erro", slot0.result))
		end
	end)
end

return class("ResetCommanderTalentsCommand", pm.SimpleCommand)

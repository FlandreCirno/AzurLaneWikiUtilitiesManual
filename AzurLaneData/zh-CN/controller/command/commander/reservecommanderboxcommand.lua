class("ReserveCommanderBoxCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().count

	if getProxy(CommanderProxy).getBoxUseCnt(slot4) == CommanderConst.MAX_GETBOX_CNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("commander_reserve_count_is_max"))

		return
	end

	slot7 = getProxy(PlayerProxy).getData(slot6)
	slot8 = 0

	for slot12 = slot5, (slot5 + slot3) - 1, 1 do
		slot8 = slot8 + CommanderConst.getBoxComsume(slot12)
	end

	if slot7.gold < slot8 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(25018, {
		type = slot3
	}, 25019, function (slot0)
		if slot0.result == 0 then
			slot0:consume({
				gold = slot0.consume
			})
			slot0:updatePlayer(slot0)
			slot0:updateBoxUseCnt(slot0.consume)
			slot5:sendNotification(GAME.COMMANDER_RESERVE_BOX_DONE, {
				awards = PlayerConst.addTranDrop(slot0.awards)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_lock_erro", slot0.result))
		end
	end)
end

return class("ReserveCommanderBoxCommand", pm.SimpleCommand)

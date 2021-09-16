class("SelectTecTargetCatchupCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(63011, {
		version = slot1:getBody().tecID,
		target = slot1.getBody().charID
	}, 63012, function (slot0)
		if slot0.result == 0 then
			slot2 = slot0.tecID
			slot3 = getProxy(TechnologyProxy)

			if getProxy(TechnologyProxy) == 0 then
			else
				slot1:setCurCatchupTecInfo(slot2, slot3)
			end

			slot2:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP_DONE, {
				tecID = slot2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. slot0.result)
		end
	end)
end

return class("SelectTecTargetCatchupCommand", pm.SimpleCommand)

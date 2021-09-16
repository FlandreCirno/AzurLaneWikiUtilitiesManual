class("CheckWorldBossStateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot4 = slot2.callback
	slot6 = slot2.time or 0

	function slot7()
		slot0 = getProxy(ChatProxy)

		for slot5, slot6 in ipairs(slot1) do
			slot6.args.isDeath = true

			slot0:UpdateMsg(slot6)
		end

		for slot7, slot8 in ipairs(slot3) do
			slot8.args.isDeath = true

			slot2:UpdateMsg(slot8)
		end

		if slot2 then
			slot2()
		end
	end

	print("boss id", slot3, " time:", tonumber)
	pg.ConnectionMgr.GetInstance():Send(34515, {
		boss_id = slot2.bossId,
		last_time = tonumber(slot2.failedCallback)
	}, 34516, function (slot0)
		if slot0.result == 0 then
			if slot0 then
				slot0()
			end
		elseif slot0.result == 1 then
			slot1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		elseif slot0.result == 3 then
			slot1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		elseif slot0.result == 6 then
			slot1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_max_challenge_cnt"))
		elseif slot0.result == 20 then
			slot1()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_none"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("CheckWorldBossStateCommand", pm.SimpleCommand)

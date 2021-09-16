class("SubmitWBAwardCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = nowWorld.GetBossProxy(slot4)

	pg.ConnectionMgr.GetInstance():Send(34511, {
		boss_id = slot1:getBody().bossId
	}, 34512, function (slot0)
		if slot0.result == 0 then
			slot0:RemoveSelfBoss()
			slot0:ClearRank(slot1)
			slot0.ClearRank:sendNotification(GAME.WORLD_BOSS_SUBMIT_AWARD_DONE, {
				items = PlayerConst.addTranDrop(slot0.drops)
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n1("领取失败") .. slot0.result)
		end
	end)
end

return class("SubmitWBAwardCommand", pm.SimpleCommand)

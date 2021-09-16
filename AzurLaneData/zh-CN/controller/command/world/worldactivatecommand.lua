class("WorldActivateCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(33101, slot1:getBody(), 33102, function (slot0)
		if slot0.result == 0 then
			getProxy(WorldProxy):NetUpdateWorld(slot0.world, slot0.vision_list or {}, slot0.camp)
			slot1:NetUpdateWorldPressingAward(slot0.chapter_award)
			slot1:NetUpdateWorldCountInfo(slot0.count_info)
			nowWorld:GetBossProxy():GenFleet()
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_activate_error_", slot0.result))
		end

		slot1:sendNotification(GAME.WORLD_ACTIVATE_DONE, {
			result = slot0.result
		})
	end)
end

return class("WorldActivateCommand", pm.SimpleCommand)

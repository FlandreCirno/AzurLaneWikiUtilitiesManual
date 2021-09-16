class("GuildFetchWeeklyTaskProgreeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if not getProxy(GuildProxy):getRawData() then
		return
	end

	if not slot4:getWeeklyTask() or slot5:getState() ~= GuildTask.STATE_ONGOING then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(62022, {
		type = 0
	}, 62023, function (slot0)
		if slot0.result == 0 then
			slot1:updateProgress(slot0.progress)
			slot0:updateGuild(slot1)
			slot0:getRawData():getWeeklyTask().setRefreshWeeklyTaskProgressTime(slot1)
			slot2:sendNotification(GAME.GUILD_WEEKLY_TASK_PROGREE_UPDATE_DONE)

			if slot1:getState() ~= slot1:getState() then
				slot2:sendNotification(GAME.GUILD_REFRESH_CAPITAL)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("GuildFetchWeeklyTaskProgreeCommand", pm.SimpleCommand)

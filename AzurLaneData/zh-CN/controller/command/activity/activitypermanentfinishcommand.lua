class("ActivityPermanentFinishCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(11208, {
		activity_id = slot1:getBody().activity_id
	}, 11209, function (slot0)
		if slot0.result == 0 then
			getProxy(ActivityPermanentProxy):finishNowActivity(slot0)
			getProxy(ActivityProxy):deleteActivityById(slot0)
			getProxy(ActivityProxy).deleteActivityById:sendNotification(GAME.ACTIVITY_PERMANENT_FINISH_DONE, {
				activity_id = slot0
			})
		else
			warning("error permanent")
		end
	end)
end

return class("ActivityPermanentFinishCommand", pm.SimpleCommand)

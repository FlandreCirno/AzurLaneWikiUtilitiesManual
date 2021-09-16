class("ActivityPermanentStartCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(11206, {
		activity_id = slot1:getBody().activity_id
	}, 11207, function (slot0)
		if slot0.result == 0 then
			getProxy(ActivityPermanentProxy):startSelectActivity(slot0)
			getProxy(ActivityPermanentProxy).startSelectActivity:sendNotification(GAME.ACTIVITY_PERMANENT_START_DONE, {
				id = slot0
			})
		else
			warning("error permanent")
		end
	end)
end

return class("ActivityPermanentStartCommand", pm.SimpleCommand)

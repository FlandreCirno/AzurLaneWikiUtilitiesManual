class("TimeSynchronizationCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.TimeMgr.GetInstance():SetServerTime(slot1:getBody().timestamp, slot1.getBody().monday_0oclock_timestamp)
	getProxy(BuildShipProxy).setBuildShipState(slot3)

	if getProxy(PlayerProxy):getData() then
		slot4:flushTimesListener()
	end

	slot5, slot6 = slot3:getExChangeItemInfo()

	if slot5 and slot6 then
		slot3:addExChangeItemTimer()
	end

	if getProxy(MilitaryExerciseProxy):getSeasonInfo() then
		slot7:addRefreshCountTimer()
		slot7:addSeasonOverTimer()
	end
end

return class("TimeSynchronizationCommand", pm.SimpleCommand)

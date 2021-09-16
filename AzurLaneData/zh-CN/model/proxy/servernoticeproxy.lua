slot0 = class("ServerNoticeProxy", import(".NetProxy"))
slot0.SERVER_NOTICES_UPDATE = "server notices update"
slot0.KEY_NEWLY_ID = "server_notice.newly_id"
slot0.KEY_STOP_REMIND = "server_notice.dont_remind"

slot0.register = function (slot0)
	slot0.data = {}

	slot0:on(11300, function (slot0)
		for slot4, slot5 in ipairs(slot0.notice_list) do
			slot6 = false

			for slot10 = 1, #slot0.data, 1 do
				if slot0.data[slot10].id == slot5.id then
					slot0.data[slot10] = ServerNotice.New(slot5)
					slot6 = true

					break
				end
			end

			if not slot6 then
				if #slot0.notice_list == 1 then
					table.insert(slot0.data, 1, ServerNotice.New(slot5))
				else
					table.insert(slot0.data, ServerNotice.New(slot5))
				end
			end
		end

		slot0:sendNotification(slot1.SERVER_NOTICES_UPDATE)
	end)
end

slot0.getServerNotices = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(slot0.data) do
		if not slot1 or not slot7.isRead then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.needAutoOpen = function (slot0)
	slot1 = true

	if PlayerPrefs.HasKey(slot0.KEY_STOP_REMIND) then
		slot2 = PlayerPrefs.GetInt(slot0.KEY_STOP_REMIND)
		slot3 = pg.TimeMgr.GetInstance()

		if not slot0:hasNewNotice() and slot3:IsSameDay(slot2, slot3:GetServerTime()) then
			slot1 = false
		end
	elseif slot0.runtimeUniqueCode and slot0.runtimeUniqueCode == slot0:getUniqueCode() then
		slot1 = false
	end

	slot0.runtimeUniqueCode = slot0:getUniqueCode()

	return slot1
end

slot0.setStopRemind = function (slot0, slot1)
	if slot1 then
		PlayerPrefs.SetInt(slot0.KEY_STOP_REMIND, pg.TimeMgr.GetInstance():GetServerTime())
	else
		PlayerPrefs.DeleteKey(slot0.KEY_STOP_REMIND)
	end

	PlayerPrefs.Save()
end

slot0.getStopRemind = function (slot0)
	return PlayerPrefs.HasKey(slot0.KEY_STOP_REMIND)
end

slot0.setStopNewTip = function (slot0)
	PlayerPrefs.SetInt(slot0.KEY_NEWLY_ID, slot0:getUniqueCode())
	PlayerPrefs.Save()
	slot0:sendNotification(slot0.SERVER_NOTICES_UPDATE)
end

slot0.hasNewNotice = function (slot0)
	if PlayerPrefs.HasKey(slot0.KEY_NEWLY_ID) and PlayerPrefs.GetInt(slot0.KEY_NEWLY_ID) == slot0:getUniqueCode() then
		return false
	end

	return true
end

slot0.getUniqueCode = function (slot0)
	return _.reduce(slot0.data, 0, function (slot0, slot1)
		return slot0 + slot1:getUniqueCode()
	end)
end

return slot0

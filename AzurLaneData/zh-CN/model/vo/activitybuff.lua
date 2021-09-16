slot0 = class("ActivityBuff", import(".CommonBuff"))

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.super.Ctor(slot0, {
		id = slot2,
		timestamp = slot3
	})

	slot0.activityId = slot1
end

slot0.IsActiveType = function (slot0)
	return true
end

function slot1(slot0, slot1, slot2)
	if slot1 == "<=" then
		return slot0 <= slot2
	elseif slot1 == "<" then
		return slot0 < slot2
	elseif slot1 == "==" then
		return slot0 == slot2
	elseif slot1 == ">=" then
		return slot2 <= slot0
	elseif slot1 == ">" then
		return slot2 < slot0
	end

	return false
end

slot0.isActivate = function (slot0)
	slot1 = false

	if getProxy(ActivityProxy):getActivityById(slot0.activityId) and not slot3:isEnd() then
		if slot0:getConfig("benefit_condition")[1] == "lv" then
			slot1 = slot0(getProxy(PlayerProxy).getRawData(slot5).level, slot4[2], slot4[3])
		end

		if slot4 == "" or slot4[1] == "activity" then
			slot1 = true
		end
	end

	return slot1
end

slot0.getLeftTime = function (slot0)
	return getProxy(ActivityProxy).getActivityById(slot2, slot0.activityId).stopTime - pg.TimeMgr.GetInstance():GetServerTime()
end

return slot0

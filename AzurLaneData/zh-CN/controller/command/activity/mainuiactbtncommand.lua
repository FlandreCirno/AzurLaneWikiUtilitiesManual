slot0 = class("MainUIActBtnCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot4 = 0
	slot5 = nil

	for slot9, slot10 in pairs(slot3) do
		if not slot10:isEnd() and slot0:shouldNotify(slot10) then
			slot4 = slot4 + 1

			if not slot5 or (slot5 and slot10.id < slot5.id) then
				slot5 = slot10
			end
		end
	end

	slot0.sendNotification(slot0, GAME.MAINUI_ACT_BTN_DONE, {
		cnt = slot4 + #_.filter(slot6, function (slot0)
			return slot0.isTip and slot0.isTip()
		end),
		priority = slot5
	})
end

slot0.shouldNotify = function (slot0, slot1)
	if not slot1:isShow() then
		return false
	end

	return slot1:readyToAchieve()
end

return slot0

class("MusicLikeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = getProxy(AppreciateProxy)

	pg.ConnectionMgr.GetInstance():Send(17507, {
		id = slot1:getBody().musicID,
		action = slot1.getBody().isAdd
	}, 17508, function (slot0)
		if slot0.result == 0 then
			if slot0 == 0 then
				slot1:addMusicIDToLikeList(slot1)
			elseif slot0 == 1 then
				slot1:removeMusicIDFromLikeList(slot1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("Like Fail" .. tostring(slot0.result))
		end
	end)
end

return class("MusicLikeCommand", pm.SimpleCommand)

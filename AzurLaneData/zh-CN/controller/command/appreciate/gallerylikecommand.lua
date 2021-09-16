class("GalleryLikeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot5 = slot2.likeCBFunc
	slot6 = getProxy(AppreciateProxy)

	pg.ConnectionMgr.GetInstance():Send(17505, {
		id = slot2.picID,
		action = slot2.isAdd
	}, 17506, function (slot0)
		if slot0.result == 0 then
			if slot0 == 0 then
				slot1:addPicIDToLikeList(slot1)
			elseif slot0 == 1 then
				slot1:removePicIDFromLikeList(slot1)
			end

			if slot3 then
				slot3()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("Like Fail" .. tostring(slot0.result))
		end
	end)
end

return class("GalleryLikeCommand", pm.SimpleCommand)

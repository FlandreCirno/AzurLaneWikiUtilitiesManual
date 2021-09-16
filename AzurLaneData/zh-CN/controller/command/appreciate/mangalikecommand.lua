class("MangaLikeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot5 = slot2.mangaCB
	slot6 = getProxy(AppreciateProxy)

	print("17511 Send Manga ID", slot3)
	pg.ConnectionMgr.GetInstance():Send(17511, {
		id = slot2.mangaID,
		action = slot2.action
	}, 17512, function (slot0)
		if slot0.result == 0 then
			if slot0 == MangaConst.SET_MANGA_LIKE then
				slot1:addMangaIDToLikeList(slot1)
			else
				slot1:removeMangaIDFromLikeList(slot1)
			end

			if slot3 then
				slot3()
			end

			slot4:sendNotification(GAME.APPRECIATE_MANGA_LIKE_DONE, {
				mangaID = slot2,
				action = slot0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("17512 Manga Like Fail:" .. tostring(slot0.result))
		end
	end)
end

return class("MangaLikeCommand", pm.SimpleCommand)

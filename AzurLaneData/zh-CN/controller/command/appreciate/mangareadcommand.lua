class("MangaReadCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().mangaCB
	slot5 = getProxy(AppreciateProxy)

	print("17509 Send Manga ID", slot3)
	pg.ConnectionMgr.GetInstance():Send(17509, {
		id = slot1.getBody().mangaID
	}, 17510, function (slot0)
		if slot0.result == 0 then
			slot0:addMangaIDToReadList(slot0.addMangaIDToReadList)

			if slot0 then
				slot2()
			end

			slot3:sendNotification(GAME.APPRECIATE_MANGA_READ_DONE, {
				mangaID = slot3.sendNotification
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("17510 Manga Read Fail" .. tostring(slot0.result))
		end
	end)
end

return class("MangaReadCommand", pm.SimpleCommand)

MangaConst = {
	Version = 0,
	NewCount = 0,
	setVersionAndNewCount = function ()
		slot0.Version = pg.cartoon[pg.cartoon.all[#pg.cartoon.all]].mark
		slot2 = 0

		for slot6 = #pg.cartoon.all, 1, -1 do
			if pg.cartoon[pg.cartoon.all[slot6]].mark == slot0.Version then
				slot2 = slot2 + 1
			elseif slot8 < slot0.Version then
				break
			end
		end

		slot0.NewCount = slot2
	end,
	MANGA_PATH_PREFIX = "mangapic/",
	SET_MANGA_LIKE = 0,
	CANCEL_MANGA_LIKE = 1,
	isMangaEverReadByID = function (slot0)
		return table.contains(getProxy(AppreciateProxy).getMangaReadIDList(slot1), slot0)
	end,
	isMangaNewByID = function (slot0)
		return slot0.Version <= pg.cartoon[slot0].mark
	end,
	isMangaLikeByID = function (slot0)
		return table.contains(getProxy(AppreciateProxy).getMangaLikeIDList(slot1), slot0)
	end
}

return MangaConst

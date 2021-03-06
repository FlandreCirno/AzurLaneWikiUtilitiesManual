class("GetRemasterCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(13503, {
		type = 0
	}, 13504, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(ChapterProxy)

			slot1:updateDailyCount()
			slot0:sendNotification(GAME.ADD_ITEM, slot2)
			slot0:sendNotification(GAME.GET_REMASTER_TICKETS_DONE, {
				Item.New({
					type = DROP_TYPE_VITEM,
					id = ITEM_ID_REACT_CHAPTER_TICKET,
					count = math.min(pg.gameset.reactivity_ticket_daily.key_value, pg.gameset.reactivity_ticket_max.key_value - slot1.remasterTickets)
				})
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("领取失败")
		end
	end)
end

return class("GetRemasterCommand", pm.SimpleCommand)

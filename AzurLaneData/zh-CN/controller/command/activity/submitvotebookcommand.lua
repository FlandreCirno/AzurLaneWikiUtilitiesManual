class("SubmitVoteBookCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().callback
	slot6 = getProxy(VoteProxy).GetOrderBook(slot5)

	pg.ConnectionMgr.GetInstance():Send(11202, {
		arg2 = 0,
		arg3 = 0,
		cmd = 3,
		activity_id = slot6.activityId,
		arg1 = slot6:GetIntByBit(slot3),
		arg_list = {}
	}, 11203, function (slot0)
		if slot0.result == 0 then
			slot2.sendNotification(slot3, GAME.SUBMIT_VOTE_BOOK_DONE, {
				awards = PlayerConst.addTranDrop(slot0.award_list),
				callback = function ()
					slot0:RemoveOrderBook()
					slot0()
				end
			})
		elseif slot1 then
			slot1()
		end
	end)
end

return class("SubmitVoteBookCommand", pm.SimpleCommand)

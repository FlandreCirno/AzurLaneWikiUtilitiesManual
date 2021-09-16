class("UseTecSpeedUpItemCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	pg.ConnectionMgr.GetInstance():Send(63210, {
		blueprintid = slot2.blueprintid,
		itemid = slot2.itemid,
		number = slot2.number,
		task_id = slot2.taskID
	}, 63211, function (slot0)
		if slot0.result == 0 then
			getProxy(BagProxy):removeItemById(slot0, getProxy(BagProxy).removeItemById)
			getProxy(BagProxy):sendNotification(GAME.USE_TEC_SPEEDUP_ITEM_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. slot0.result)
		end
	end)
end

return class("UseTecSpeedUpItemCommand", pm.SimpleCommand)

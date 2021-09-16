class("ProposeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not getProxy(BayProxy):getShipById(slot1:getBody().shipId) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", slot3))

		return
	end

	if getProxy(BagProxy):getItemCountById((slot5:getProposeType() == "imas" and ITEM_ID_FOR_PROPOSE_IMAS) or ITEM_ID_FOR_PROPOSE) < 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12032, {
		ship_id = slot3
	}, 12033, function (slot0)
		if slot0.result == 0 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_PROPOSE_SHIP, slot0.groupId)
			pg.TrackerMgr.GetInstance().Tracking:removeItemById(pg.TrackerMgr.GetInstance().Tracking, 1)

			slot0.propose = true
			slot0.proposeTime = pg.TimeMgr.GetInstance():GetServerTime()

			slot3:updateShip(slot0)
			getProxy(CollectionProxy).shipGroups[slot0.groupId].updateMarriedFlag(slot2)
			slot2:sendNotification(GAME.PROPOSE_SHIP_DONE, {
				ship = slot0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_proposeShip", slot0.result))
		end
	end)
end

return class("ProposeCommand", pm.SimpleCommand)

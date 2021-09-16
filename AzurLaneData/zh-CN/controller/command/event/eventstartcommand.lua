slot0 = class("EventStartCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot4 = slot1:getBody().shipIds

	if not getProxy(EventProxy).findInfoById(slot5, slot3):IsActivityType() and slot5.maxFleetNums <= slot5.busyFleetNums then
		pg.TipsMgr.GetInstance():ShowTips(i18n("event_fleet_busy"))

		return
	end

	slot8, slot9 = slot5:CanJoinEvent(slot6)

	if not slot8 then
		if slot9 then
			pg.TipsMgr.GetInstance():ShowTips(slot9)
		end

		return
	end

	function slot10()
		if slot0 then
			slot1:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
				arg2 = 0,
				cmd = ActivityConst.COLLETION_EVENT_OP_JOIN,
				arg1 = slot2,
				arg_list = 
			})
		else
			pg.ConnectionMgr.GetInstance():Send(13003, {
				id = slot2,
				ship_id_list = slot3
			}, 13004, function (slot0)
				if slot0.result == 0 then
					slot0.OnStart(slot0.OnStart)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("event_start_fail", slot0.result))
				end
			end)
		end
	end

	if slot6.getOilConsume(slot6) > 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_oil_consume", slot11),
			onYes = slot10
		})
	else
		slot10()
	end
end

slot0.OnStart = function (slot0)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_start_success"))

	slot2 = getProxy(EventProxy).findInfoById(slot1, slot0)
	slot3 = getProxy(PlayerProxy)
	slot4 = slot3:getData()
	slot2.finishTime = pg.TimeMgr.GetInstance():GetServerTime() + slot2.template.collect_time
	slot2.state = EventInfo.StateActive

	slot4:consume({
		oil = slot2:getOilConsume()
	})
	slot3:updatePlayer(slot4)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
end

return slot0

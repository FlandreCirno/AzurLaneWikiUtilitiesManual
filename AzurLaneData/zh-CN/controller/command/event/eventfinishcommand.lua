slot0 = class("EventFinishCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot4 = slot2.callback
	slot5 = slot2.onConfirm
	slot6 = getProxy(EventProxy)
	slot8, slot9 = slot6:CanFinishEvent(slot6:findInfoById(slot3))

	if not slot8 then
		if slot9 then
			pg.TipsMgr.GetInstance():ShowTips(slot9)
		end

		if slot4 then
			slot4()
		end

		return
	end

	if slot7:IsActivityType() then
		slot0:sendNotification(GAME.ACT_COLLECTION_EVENT_OP, {
			arg2 = 0,
			cmd = ActivityConst.COLLETION_EVENT_OP_SUBMIT,
			arg1 = slot3,
			arg_list = {},
			callBack = slot4,
			onConfirm = slot5
		})
	else
		pg.ConnectionMgr.GetInstance():Send(13005, {
			id = slot3
		}, 13006, function (slot0)
			if slot0.result == 0 then
				slot1 = getProxy(EventProxy)

				slot1:findInfoById(slot0):SavePrevFormation()
				slot1.OnFinish(slot0, slot0, slot1.OnFinish)

				if slot0 then
					slot3()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("event_finish_fail", slot0.result))

				if errorTip then
					slot3()
				end
			end
		end)
	end
end

slot0.OnFinish = function (slot0, slot1, slot2)
	pg.TipsMgr.GetInstance():ShowTips(i18n("event_finish_success"))

	slot3 = getProxy(EventProxy)
	slot4 = {}
	slot5 = {}

	if slot1.exp > 0 then
		slot6 = getProxy(BayProxy)

		for slot11, slot12 in ipairs(slot7) do
			if slot6:getShipById(slot12) then
				slot14 = Clone(slot13)

				slot14:addExp(slot1.exp)
				slot6:updateShip(slot14)
				table.insert(slot4, slot13)
				table.insert(slot5, slot14)
			end
		end
	end

	slot7 = getProxy(PlayerProxy)
	slot8 = slot7:getData()
	slot8.collect_attack_count = slot8.collect_attack_count + 1

	slot7:updatePlayer(slot8)

	slot9, slot13 = slot3:findInfoById(slot0)

	table.remove(slot3.eventList, slot10)
	_.each(slot1.new_collection, function (slot0)
		table.insert(slot0.eventList, EventInfo.New(slot0))
	end)
	pg.ShipFlagMgr.GetInstance().UpdateFlagShips(slot11, "inEvent")
	pg.m02:sendNotification(GAME.EVENT_LIST_UPDATE)
	pg.m02:sendNotification(GAME.EVENT_SHOW_AWARDS, {
		eventId = slot0,
		oldShips = slot4,
		newShips = slot5,
		awards = PlayerConst.addTranDrop(slot1.drop_list),
		isCri = slot1.is_cri > 0,
		onConfirm = slot2
	})
end

return slot0

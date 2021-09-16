EventConst = require("view/event/EventConst")
slot0 = class("EventMediator", import("..base.ContextMediator"))

slot0.register = function (slot0)
	slot0:bind(EventConst.EVEN_USE_PREV_FORMATION, function (slot0, slot1, slot2)
		slot3 = getProxy(EventProxy)
		slot4 = getProxy(BayProxy)
		slot5 = slot4:getData()
		slot6 = {}
		slot7 = false
		slot8 = false

		function (slot0)
			for slot4, slot5 in ipairs(slot0) do
				if slot0[slot5] then
					slot7, slot8 = ShipStatus.ShipStatusConflict("inEvent", slot6)

					if slot7 == ShipStatus.STATE_CHANGE_FAIL then
						slot1 = true
					elseif slot7 == ShipStatus.STATE_CHANGE_CHECK then
						slot2 = true
					else
						table.insert(slot3, slot5)
					end
				end
			end

			if slot1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip"))
			end

			if slot2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("collect_tip2"))
			end

			slot4.selectedEvent = slot5
			slot4.selectedEvent.shipIds = slot3

			slot6:updateEventList(true)

			slot4.selectedEvent = nil
		end(slot4.getRawData(slot4))
	end)
	slot0.bind(slot0, EventConst.EVENT_LIST_UPDATE, function (slot0)
		slot0:updateEventList(true)
	end)
	slot0.bind(slot0, EventConst.EVENT_OPEN_DOCK, function (slot0, slot1)
		slot4 = {}

		for slot8, slot9 in pairs(slot3) do
			if not table.contains(slot1.template.ship_type, slot9:getShipType()) or slot9:isActivityNpc() then
				table.insert(slot4, slot8)
			end
		end

		getProxy(EventProxy).selectedEvent = slot1
		slot13.onShip, slot13.confirmSelect, slot13.onSelected = slot0:getDockCallbackFuncs()

		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 6,
			useBlackBlock = true,
			selectedMin = 1,
			skipSelect = true,
			ignoredIds = slot4,
			selectedIds = (getProxy(EventProxy).selectedEvent and slot5.selectedEvent.shipIds) or {},
			onShip = slot6,
			confirmSelect = slot7,
			onSelected = slot8,
			leftTopInfo = i18n("word_operation"),
			hideTagFlags = ShipStatus.TAG_HIDE_EVENT,
			blockTagFlags = ShipStatus.TAG_BLOCK_EVENT
		})
	end)
	slot0.bind(slot0, EventConst.EVENT_FLUSH_NIGHT, function (slot0)
		slot0:sendNotification(GAME.EVENT_FLUSH_NIGHT)
	end)
	slot0.bind(slot0, EventConst.EVENT_START, function (slot0, slot1)
		slot0:sendNotification(GAME.EVENT_START, {
			id = slot1.id,
			shipIds = slot1.shipIds
		})
	end)
	slot0.bind(slot0, EventConst.EVENT_GIVEUP, function (slot0, slot1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("event_confirm_giveup"),
			onYes = function ()
				slot0:sendNotification(GAME.EVENT_GIVEUP, {
					id = slot1.id
				})
			end
		})
	end)
	slot0.bind(slot0, EventConst.EVENT_FINISH, function (slot0, slot1)
		slot0:sendNotification(GAME.EVENT_FINISH, {
			id = slot1.id
		})
	end)
	slot0.bind(slot0, EventConst.EVENT_RECOMMEND, function (slot0, slot1)
		getProxy(EventProxy).selectedEvent = slot1

		getProxy(EventProxy):fillRecommendShip(slot1)
		slot0:updateEventList(true, true)

		getProxy(EventProxy).selectedEvent = nil

		if not slot1:reachNum() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("event_recommend_fail"))
		end
	end)
	slot0.updateEventList(slot0, false)
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_SHOW_AWARDS
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.EVENT_LIST_UPDATE then
		slot0:updateEventList(true)
	elseif slot2 == GAME.EVENT_SHOW_AWARDS then
		slot4 = nil
		slot5 = coroutine.wrap(function ()
			if #slot0.oldShips > 0 then
				slot1.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
					title = pg.collection_template[slot0.eventId].title,
					oldShips = slot0.oldShips,
					newShips = slot0.newShips,
					isCri = slot0.isCri
				}, )
				coroutine.yield()
			end

			slot1.viewComponent:emit(BaseUI.ON_ACHIEVE, slot0.awards)
		end)

		slot5()
	end
end

slot0.updateEventList = function (slot0, slot1, slot2)
	slot3 = getProxy(BayProxy)
	getProxy(EventProxy).virgin = false

	table.sort(slot5, function (slot0, slot1)
		if slot0.state ~= slot1.state then
			return slot1.state < slot0.state
		elseif slot0.template.type ~= slot1.template.type then
			return slot1.template.type < slot0.template.type
		elseif slot0.template.lv ~= slot1.template.lv then
			return slot1.template.lv < slot0.template.lv
		else
			return slot1.id < slot0.id
		end
	end)

	for slot9, slot10 in ipairs(slot5) do
		slot10.ships = {}

		if slot10.state == EventInfo.StateNone and slot10 ~= slot4.selectedEvent then
			slot10.shipIds = {}
		else
			for slot14 = #slot10.shipIds, 1, -1 do
				if slot3:getShipById(slot10.shipIds[slot14]) then
					table.insert(slot10.ships, 1, slot15)
				else
					table.remove(slot10.shipIds, slot14)
				end
			end
		end
	end

	slot4.busyFleetNums = slot4:countBusyFleetNums()

	slot0.viewComponent:updateAll(slot4, slot1, slot2)

	if getProxy(SettingsProxy):ShouldShowEventActHelp() and _.any(slot5, function (slot0)
		return slot0:IsActivityType()
	end) then
		getProxy(SettingsProxy).MarkEventActHelpFlag(slot6)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_act_event.tip
		})
	end
end

slot0.getDockCallbackFuncs = function (slot0)
	function slot1(slot0, slot1, slot2)
		slot3, slot4 = ShipStatus.ShipStatusCheck("inEvent", slot0, slot1)

		if not slot3 then
			return slot3, slot4
		end

		slot5 = getProxy(BayProxy)

		for slot9, slot10 in ipairs(slot2) do
			if slot0:isSameKind(slot5:getShipById(slot10)) then
				return false, i18n("ship_formationMediator_changeNameError_sameShip")
			end
		end

		return true
	end

	return slot1, function (slot0, slot1, slot2)
		slot1()
	end, function (slot0)
		getProxy(EventProxy).selectedEvent.shipIds = slot0
	end
end

return slot0

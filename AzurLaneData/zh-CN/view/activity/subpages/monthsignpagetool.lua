slot0 = class("MonthSignPageTool")

slot0.Ctor = function (slot0, slot1)
	slot0._event = slot1
end

slot0.onAcheve = function (slot0, slot1, slot2)
	slot3 = nil
	slot5 = coroutine.create(function ()
		if table.getCount(table.getCount) > 0 then
			slot0 = getProxy(ActivityProxy):getActivityById(ActivityConst.MONTH_SIGN_ACTIVITY_ID)
			slot1 = pg.activity_month_sign[slot0.data2].resign_count
			slot3 = pg.TimeMgr.GetInstance():STimeDescS(slot2, "*t")

			if slot0:getSpecialData("reMonthSignDay") ~= nil then
				slot1.reMonthSignItems = (slot1.reMonthSignItems and slot1.reMonthSignItems) or {}

				for slot7, slot8 in pairs(slot0) do
					table.insert(slot1.reMonthSignItems, slot8)
				end

				if slot3.day > #slot0.data1_list and slot0.data3 < slot1 then
					Timer.New(function ()
						slot0()
					end, 0.3, 1).Start(slot4)

					return
				else
					slot1._event:emit(MonthSignPage.SHOW_RE_MONTH_SIGN, slot1.reMonthSignItems, slot3)

					slot0 = slot1.reMonthSignItems
				end
			else
				slot1.reMonthSignItems = nil

				slot1._event:emit(BaseUI.ON_AWARD, {
					items = slot0,
					removeFunc = slot3
				})
			end

			coroutine.yield()

			slot4 = #_.filter(slot0, function (slot0)
				return slot0.type == DROP_TYPE_SHIP
			end) + #_.filter(slot0, function (slot0)
				return slot0.type == DROP_TYPE_NPC_SHIP
			end)
			slot7 = getProxy(BayProxy).getNewShip(slot6, true)

			_.each(_.filter(slot0, function (slot0)
				return slot0.type == DROP_TYPE_NPC_SHIP
			end), function (slot0)
				table.insert(slot0, slot1:getShipById(slot0.id))
			end)

			slot8 = (pg.gameset.award_ship_limit and pg.gameset.award_ship_limit.key_value) or 20

			if slot4 <= slot8 then
				for slot12 = math.max(1, #slot7 - slot4 + 1), #slot7, 1 do
					slot1._event.emit(slot13, ActivityMediator.OPEN_LAYER, Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = slot7[slot12]
						},
						onRemoved = slot3
					}))
					coroutine.yield()
				end
			end

			for slot12, slot13 in pairs(slot0) do
				if slot13.type == DROP_TYPE_SKIN then
					if pg.ship_skin_template[slot13.id].skin_type == ShipSkin.SKIN_TYPE_REMAKE then
					elseif not getProxy(ShipSkinProxy):hasOldNonLimitSkin(slot13.id) then
						slot1._event:emit(ActivityMediator.OPEN_LAYER, Context.New({
							mediator = NewSkinMediator,
							viewComponent = NewSkinLayer,
							data = {
								skinId = slot13.id
							},
							onRemoved = slot3
						}))
					end

					coroutine.yield()
				end
			end
		end

		if slot2 then
			slot2()
		end
	end)
	slot3 = slot5

	function ()
		if slot0 and coroutine.status(coroutine.status) == "suspended" then
			slot0, slot1 = coroutine.resume(coroutine.resume)
		end
	end()
end

return slot0

slot0 = class("ActivityOperationCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	if getProxy(ActivityProxy):getActivityById(slot1:getBody().activity_id).getConfig(slot3, "type") == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or slot4 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY then
		slot5, slot6, slot7 = BuildShip.canBuildShipByBuildId(slot2.buildId, slot2.arg1)

		if not slot5 then
			if slot7 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_1"), ChargeScene.TYPE_ITEM, slot7)
			else
				pg.TipsMgr.GetInstance():ShowTips(slot6)
			end

			return
		end
	end

	if slot4 == ActivityConst.ACTIVITY_TYPE_SHOP then
		if getProxy(PlayerProxy):getData()[id2res(getProxy(ShopsProxy):getActivityShopById(slot3.id).bindConfigTable(slot6)[slot2.arg1].resource_type)] < getProxy(ShopsProxy).getActivityShopById(slot3.id).bindConfigTable(slot6)[slot2.arg1].resource_num * (slot2.arg2 or 1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		if slot7.commodity_type == 1 then
			if slot7.commodity_id == 1 and slot5:GoldMax(slot7.num * slot8) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end

			if slot7.commodity_id == 2 and slot5:OilMax(slot7.num * slot8) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = slot2.activity_id,
		cmd = slot2.cmd,
		arg1 = slot2.arg1,
		arg2 = slot2.arg2,
		arg_list = {}
	}, 11203, function (slot0)
		if slot0.result == 0 then
			slot1 = slot0:getAwards(slot0.getAwards, slot0)

			slot0:performance(slot1, slot0, slot0:updateActivityData(slot1, slot0, slot0.updateActivityData, slot1), slot1)
		else
			print("activity op ret code: " .. slot0.result)

			if slot0.result == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN or slot3 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN or slot3 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN or slot3 == ActivityConst.ACTIVITY_TYPE_REFLUX then
				slot2.autoActionForbidden = true

				getProxy(ActivityProxy):updateActivity(getProxy(ActivityProxy))
			elseif slot3 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 then
				if slot0.result == 1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("activity_build_end_tip"))
				end
			elseif slot3 == 17 then
				pg.TipsMgr.GetInstance():ShowTips("??????!:" .. slot0.result)
			elseif slot3 == ActivityConst.ACTIVITY_TYPE_FRESH_TEC_CATCHUP then
			elseif slot0.result == 3 or slot0.result == 4 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("activity_op_error", slot0.result))
			end

			slot0:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = slot1.activity_id,
				code = slot0.result
			})
		end
	end)
end

slot0.getAwards = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = {}

	for slot8, slot9 in ipairs(slot2.award_list) do
		table.insert(slot3, {
			type = slot9.type,
			id = slot9.id,
			count = slot9.number
		})
	end

	slot4 = PlayerConst.addTranDrop(slot3)

	for slot8, slot9 in ipairs(slot3) do
		if slot9.type == DROP_TYPE_SHIP and not getProxy(CollectionProxy):getShipGroup(pg.ship_data_template[slot9.id].group_type) and Ship.inUnlockTip(slot9.id) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_award_ship", slot10.name))
		end
	end

	if slot1.isAwardMerge then
		slot5 = {}
		slot6 = nil

		for slot10, slot11 in ipairs(slot4) do
			function slot12()
				for slot3, slot4 in ipairs(ipairs) do
					if slot1.id == slot4.id then
						slot0[slot3].count = slot0[slot3].count + slot1.count

						return false
					end
				end

				return true
			end

			if slot12() then
				table.insert(slot5, slot11)
			end
		end

		slot4 = slot5
	end

	return slot4
end

slot0.updateActivityData = function (slot0, slot1, slot2, slot3, slot4)
	slot6 = getProxy(PlayerProxy)
	slot7 = getProxy(TaskProxy)

	if slot3:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
		slot3.data1 = slot3.data1 + 1
		slot3.data2 = pg.TimeMgr.GetInstance():GetServerTime()
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
		if slot1.cmd == 1 then
			slot3.data1 = slot3.data1 + 1
			slot3.data2 = pg.TimeMgr.GetInstance():GetServerTime()
		elseif slot1.cmd == 2 then
			slot3.achieved = true
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_LEVELAWARD then
		table.insert(slot3.data1_list, slot1.arg1)
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_STORY_AWARD then
		table.insert(slot3.data1_list, slot1.arg1)
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_LEVELPLAN then
		if slot1.cmd == 1 then
			slot3.data1 = true
		elseif slot1.cmd == 2 then
			table.insert(slot3.data1_list, slot1.arg1)
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
		slot9 = pg.TimeMgr.GetInstance():STimeDescS(slot8, "*t")
		slot10 = nil

		if slot3:getSpecialData("reMonthSignDay") ~= nil then
			slot10 = slot3:getSpecialData("reMonthSignDay")
			slot3.data3 = (slot3.data3 and slot3.data3 + 1) or 1
		else
			slot10 = slot9.day
		end

		getProxy(ActivityProxy):updateActivity(slot3)
		table.insert(slot3.data1_list, slot10)
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
		slot3.data2 = 1
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_1 or slot5 == ActivityConst.ACTIVITY_TYPE_BUILDSHIP_PRAY then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_BUILD_SHIP, slot1.arg1)
		getProxy(BagProxy):removeItemById(pg.ship_data_create_material[slot1.buildId].use_item, pg.ship_data_create_material[slot1.buildId].number_1 * slot1.arg1)

		slot9 = slot6:getData()

		slot9:consume({
			gold = pg.ship_data_create_material[slot1.buildId].use_gold * slot1.arg1
		})
		slot6:updatePlayer(slot9)

		slot10 = getProxy(BuildShipProxy)

		for slot14, slot15 in ipairs(slot2.build) do
			slot10:addBuildShip(BuildShip.New(slot15))
		end

		slot3.data1 = slot3.data1 + slot1.arg1

		slot0:sendNotification(GAME.BUILD_SHIP_DONE)
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_SHOP then
		slot8 = getProxy(ShopsProxy)
		slot9 = slot8:getActivityShopById(slot3.id)

		slot8:UpdateActivityGoods(slot3.id, slot1.arg1, slot1.arg2)

		if table.contains(slot3.data1_list, slot1.arg1) then
			for slot13, slot14 in ipairs(slot3.data1_list) do
				if slot14 == slot1.arg1 then
					slot3.data2_list[slot13] = slot3.data2_list[slot13] + slot1.arg2

					break
				end
			end
		else
			table.insert(slot3.data1_list, slot1.arg1)
			table.insert(slot3.data2_list, slot1.arg2)
		end

		slot12 = slot6:getData()

		slot12:consume({
			[id2res(slot9:bindConfigTable()[slot1.arg1].resource_type)] = slot9.bindConfigTable()[slot1.arg1].resource_num * slot1.arg2
		})
		slot6:updatePlayer(slot12)
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_ZPROJECT then
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_TASK_LIST then
		if slot1.cmd == 1 then
			slot8, slot9 = getActivityTask(slot3)

			if slot9 and not slot9:isReceive() then
				for slot14, slot15 in ipairs(slot10) do
					if table.contains(_.flatten({
						slot15
					}), slot8) then
						slot3.data3 = slot14

						break
					end
				end
			end
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_TASK_RES then
		if slot1.cmd == 1 then
			slot8, slot9 = getActivityTask(slot3)

			if slot9 and not slot9:isReceive() then
				for slot14, slot15 in ipairs(slot10) do
					if table.contains(_.flatten({
						slot15
					}), slot8) then
						slot3.data3 = slot14

						break
					end
				end
			end
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_PUZZLA then
		if slot1.cmd == 1 then
			slot3.data1 = 1
		elseif slot1.cmd == 4 then
			slot3.data1 = 2
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_VOTE then
		slot9 = getProxy(VoteProxy).getVoteGroup(slot8)

		if slot1.cmd == 1 then
			slot9:voteShip(slot1.arg2)

			slot8.votes = slot8.votes - 1
		elseif slot1.cmd == 2 then
			slot9:loveShip(slot1.arg2)

			slot8.loves = slot8.loves - 1
		end

		slot9:sortList()
		slot8:setVoteGroup(slot9)
		pg.TipsMgr.GetInstance():ShowTips(i18n("vote_success"))
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_BB then
		slot3.data1 = slot3.data1 + 1
		slot3.data2 = slot3.data2 - 1
		slot3.data1_list = slot2.number
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_LOTTERY then
		if slot1.cmd == 1 then
			slot10 = slot1.arg1 * ActivityItemPool.New({
				id = slot1.arg2
			}).getComsume(slot8).count

			if ActivityItemPool.New().getComsume(slot8).type == DROP_TYPE_RESOURCE then
				slot11 = slot6:getData()

				slot11:consume({
					[id2res(slot9.id)] = slot10
				})
				slot6:updatePlayer(slot11)
			elseif slot9.type == DROP_TYPE_ITEM then
				getProxy(BagProxy):removeItemById(slot9.id, slot10)
			end

			slot3:updateData(slot8.id, slot2.number)
		elseif slot1.cmd == 2 then
			slot3.data1 = slot1.arg1
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_CARD_PAIRS or slot5 == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
		if slot1.cmd == 1 then
			slot8 = slot3:getConfig("config_data")[4]

			if #slot4 > 0 then
				slot3.data2 = slot3.data2 + 1

				if slot8 <= slot3.data2 then
					slot3.data1 = 1
				end
			end

			if slot3.data4 == 0 then
				slot3.data4 = slot1.arg2
			elseif slot1.arg2 < slot3.data4 then
				slot3.data4 = slot1.arg2
			end
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_REFLUX then
		if slot1.cmd == 1 then
			slot3.data1_list[1] = pg.TimeMgr.GetInstance():GetServerTime()
			slot3.data1_list[2] = slot3.data1_list[2] + 1
		elseif slot1.cmd == 2 then
			slot3.data4 = slot1.arg1
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
		if slot1.cmd == 1 then
			slot3.data1 = slot3.data1 + 1
			slot3.data2 = slot2.number[1]
		elseif slot1.cmd == 2 then
			table.insert(slot3.data1_list, slot3.data1)
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_DODGEM then
		if slot1.cmd == 1 then
			slot0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = slot1.statistics,
				score = slot1.statistics._battleScore,
				system = SYSTEM_DODGEM
			})

			slot3.data1_list[1] = math.max(slot3.data1_list[1], slot1.arg2)
			slot3.data2_list[1] = slot2.number[1]
			slot3.data2_list[2] = slot2.number[2]
		elseif slot1.cmd == 2 then
			slot3.data2 = slot2.number[1]
			slot3.data3 = slot2.number[2]
			slot3.data2_list[1] = 0
			slot3.data2_list[2] = 0
		elseif slot1.cmd == 3 then
			slot3.data4 = defaultValue(slot3.data4, 0) + 1
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN then
		if slot1.cmd == 1 then
			slot0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = slot1.statistics,
				score = slot1.statistics._battleScore,
				system = SYSTEM_SUBMARINE_RUN
			})

			slot3.data1_list[1] = math.max(slot3.data1_list[1], slot1.arg2)
			slot3.data2_list[1] = slot2.number[1]
			slot3.data2_list[2] = slot2.number[2]
		elseif slot1.cmd == 2 then
			slot3.data2 = slot2.number[1]
			slot3.data3 = slot2.number[2]
			slot3.data2_list[1] = 0
			slot3.data2_list[2] = 0
		elseif slot1.cmd == 3 then
			slot3.data4 = defaultValue(slot3.data4, 0) + 1
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_TURNTABLE then
		if slot1.cmd == 2 then
			slot3.data4 = 0
		elseif slot1.cmd == 1 then
			if slot3.data3 == pg.activity_event_turning[slot3:getConfig("config_id")].total_num then
				slot3.data2 = 1
				slot3.data3 = slot3.data3 + 1
			else
				slot3.data3 = slot3.data3 + 1
				slot3.data4 = slot2.number[1]
			end
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_SHRINE then
		slot3.data1 = 1
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_RED_PACKETS then
		slot3.data1 = slot3.data1 - 1

		if slot3.data2 > 0 then
			slot3.data2 = slot3.data2 - 1
		end

		if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY) and not slot9:isEnd() and slot9.data2_list[2] < slot9.data2_list[1] then
			slot9.data2_list[2] = slot9.data2_list[2] + 1

			slot8:updateActivity(slot9)
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		slot3.data1KeyValueList[2][slot1.arg1] = (slot3.data1KeyValueList[2][slot1.arg1] or 1) + 1

		if (slot3.data1KeyValueList[2][slot1.arg1] or 1) < #pg.activity_event_building[slot1.arg1].buff then
			slot3.data1KeyValueList[1][slot10] = math.max((slot3.data1KeyValueList[1][slot8.material_id] or 0) - slot8.material[slot9], 0)
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_EXPEDITION then
		if slot1.cmd == 0 then
			return slot3
		end

		if slot1.cmd == 3 then
			slot0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = slot1.statistics,
				score = slot1.statistics._battleScore,
				system = SYSTEM_REWARD_PERFORM
			})

			return slot3
		end

		if slot1.cmd == 4 then
			slot3.data2_list[1] = slot3.data2_list[1] + 1

			return slot3
		end

		if slot1.cmd == 1 then
			slot3.data3 = slot3.data3 - 1
		end

		slot8 = slot1.arg1

		if slot1.cmd ~= 2 then
			slot3.data2 = slot8
		end

		slot3.data1_list[slot8] = slot2.number[1]

		print("??????:" .. slot8 .. " ???:" .. slot2.number[1])

		if slot2.number[2] and slot3.data1 ~= slot2.number[2] then
			print("????????????" .. slot2.number[2])

			slot3.data1 = slot3.data1 + 1
			slot3.data2 = 0

			for slot13 = 1, #slot3.data1_list, 1 do
				slot3.data1_list[slot13] = 0
			end
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_AIRFIGHT_BATTLE then
		if slot1.cmd == 1 then
			slot0:sendNotification(GAME.FINISH_STAGE_DONE, {
				statistics = slot1.statistics,
				score = slot1.statistics._battleScore,
				system = SYSTEM_AIRFIGHT
			})

			slot3.data1KeyValueList[1] = slot3.data1KeyValueList[1] or {}
			slot3.data1KeyValueList[1][slot1.arg1] = (slot3.data1KeyValueList[1][slot1.arg1] or 0) + 1
		elseif slot1.cmd == 2 then
			slot3.data1KeyValueList[2] = slot3.data1KeyValueList[2] or {}
			slot3.data1KeyValueList[2][slot1.arg1] = 1
		end
	elseif slot5 == ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS then
		if slot1.cmd == 1 then
			slot3.data1 = slot3.data1 - 1
			slot3.data1KeyValueList[1][slot2.number[1]] = slot3.data1KeyValueList[1][slot2.number[1]] + 1
		elseif slot1.cmd == 2 then
			slot3.data2 = 1
		end
	end

	return slot3
end

slot0.performance = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot3:getConfig("type")
	slot6 = nil
	slot8 = coroutine.create(function ()
		if slot0 == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
			if slot1:getConfig("config_client").story and slot0[slot1.data1] and slot0[slot1.data1][1] then
				pg.NewStoryMgr.GetInstance():Play(slot0[slot1.data1][1], pg.NewStoryMgr.GetInstance())
				coroutine.yield()
			end
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_BB then
			if pg.gameset.bobing_memory.description[slot1.data1] and #slot0 > 0 then
				pg.NewStoryMgr.GetInstance():Play(slot0, pg.NewStoryMgr.GetInstance())
				coroutine.yield()
			end

			slot3:sendNotification(ActivityProxy.ACTIVITY_SHOW_BB_RESULT, {
				numbers = slot4.number,
				callback = slot2,
				awards = slot2
			})
			coroutine.yield()
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_LOTTERY_AWARD then
			if slot6.cmd == 1 then
				if slot1:getConfig("config_client").story and slot0[slot1.data1] and slot0[slot1.data1][1] then
					pg.NewStoryMgr.GetInstance():Play(slot0[slot1.data1][1], pg.NewStoryMgr.GetInstance())
					coroutine.yield()
				end

				slot3:sendNotification(ActivityProxy.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT, {
					activityID = slot1.id,
					awards = slot1.id,
					number = slot4.number[1],
					callback = slot2
				})

				slot5 = {}

				coroutine.yield()
			end
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_CARD_PAIRS or slot0 == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
			if slot1:getConfig("config_client")[1] and slot1:getConfig("config_client")[1][slot1.data2 + 1] then
				pg.NewStoryMgr.GetInstance():Play(slot0, pg.NewStoryMgr.GetInstance())
				coroutine.yield()
			end
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_DODGEM or slot0 == ActivityConst.ACTIVITY_TYPE_SUBMARINE_RUN then
			if slot6.cmd == 2 and slot4.number[3] > 0 then
				table.insert(slot5, {
					type = slot1:getConfig("config_client")[1][1],
					id = slot1.getConfig("config_client")[1][2],
					count = slot1.getConfig("config_client")[1][3]
				})
			end
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_SHOP then
			if #slot5 == 1 and slot5[1].type == DROP_TYPE_ITEM then
				slot1 = Item.EQUIPMENT_SKIN_BOX == pg.item_data_statistics[slot5[1].id].type

				if slot0.type == DROP_TYPE_ITEM and slot1 then
					slot5 = {}

					slot3:sendNotification(GAME.USE_ITEM, {
						skip_check = true,
						id = slot0.id,
						count = slot0.count
					})
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
				end
			end
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
			pg.TipsMgr.GetInstance():ShowTips(i18n("building_complete_tip"))
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
			if slot6.cmd == 3 then
				slot0 = slot1:getSpecialData("month_sign_awards") or {}

				for slot4 = 1, #slot5, 1 do
					table.insert(slot0, slot5[slot4])
				end

				slot1:setSpecialData("month_sign_awards", slot0)

				slot5 = {}
			end
		elseif slot0 == ActivityConst.ACTIVITY_TYPE_SHAKE_BEADS and slot6.cmd == 1 then
			slot3:sendNotification(ActivityProxy.ACTIVITY_SHOW_SHAKE_BEADS_RESULT, {
				number = slot4.number[1],
				callback = slot2,
				awards = slot5
			})
			coroutine.yield()
		end

		if #slot5 > 0 then
			slot3:sendNotification(slot1:getNotificationMsg(), {
				activityId = slot6.activity_id,
				awards = slot5,
				callback = slot1.getNotificationMsg()
			})
			coroutine.yield()
		end

		if slot0 == 17 and slot6.cmd and slot6.cmd == 2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mingshi_get_tip"))
		end

		getProxy(ActivityProxy):updateActivity(getProxy(ActivityProxy))
		slot3:sendNotification(ActivityProxy.ACTIVITY_OPERATION_DONE, slot6.activity_id)
	end)
	slot6 = slot8

	function ()
		if slot0 and coroutine.status(coroutine.status) == "suspended" then
			slot0, slot1 = coroutine.resume(coroutine.resume)
		end
	end()
end

return slot0

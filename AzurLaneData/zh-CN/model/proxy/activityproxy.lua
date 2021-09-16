slot0 = class("ActivityProxy", import(".NetProxy"))
slot0.ACTIVITY_ADDED = "ActivityProxy ACTIVITY_ADDED"
slot0.ACTIVITY_UPDATED = "ActivityProxy ACTIVITY_UPDATED"
slot0.ACTIVITY_DELETED = "ActivityProxy ACTIVITY_DELETED"
slot0.ACTIVITY_OPERATION_DONE = "ActivityProxy ACTIVITY_OPERATION_DONE"
slot0.ACTIVITY_SHOW_AWARDS = "ActivityProxy ACTIVITY_SHOW_AWARDS"
slot0.ACTIVITY_SHOP_SHOW_AWARDS = "ActivityProxy ACTIVITY_SHOP_SHOW_AWARDS"
slot0.ACTIVITY_SHOW_BB_RESULT = "ActivityProxy ACTIVITY_SHOW_BB_RESULT"
slot0.ACTIVITY_LOTTERY_SHOW_AWARDS = "ActivityProxy ACTIVITY_LOTTERY_SHOW_AWARDS"
slot0.ACTIVITY_HITMONSTER_SHOW_AWARDS = "ActivityProxy ACTIVITY_HITMONSTER_SHOW_AWARDS"
slot0.ACTIVITY_SHOW_REFLUX_AWARDS = "ActivityProxy ACTIVITY_SHOW_REFLUX_AWARDS"
slot0.ACTIVITY_OPERATION_ERRO = "ActivityProxy ACTIVITY_OPERATION_ERRO"
slot0.ACTIVITY_SHOW_LOTTERY_AWARD_RESULT = "ActivityProxy ACTIVITY_SHOW_LOTTERY_AWARD_RESULT"
slot0.ACTIVITY_SHOW_RED_PACKET_AWARDS = "ActivityProxy ACTIVITY_SHOW_RED_PACKET_AWARDS"
slot0.ACTIVITY_SHOW_SHAKE_BEADS_RESULT = "ActivityProxy ACTIVITY_SHOW_SHAKE_BEADS_RESULT"
slot0.ACTIVITY_PT_ID = 110

slot0.register = function (slot0)
	slot0:on(11200, function (slot0)
		slot0.data = {}
		slot0.params = {}

		for slot4, slot5 in ipairs(slot0.activity_list) do
			if not pg.activity_template[slot5.id] then
				Debugger.LogError("活动acvitity_template不存在: " .. slot5.id)
			else
				if Activity.Create(slot5).getConfig(slot6, "type") == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 or slot7 == ActivityConst.ACTIVITY_TYPE_CHALLENGE then
					slot0:updateActivityFleet(slot5)
				elseif slot7 == ActivityConst.ACTIVITY_TYPE_PARAMETER then
					slot0:addActivityParameter(slot6)
				end

				slot0.data[slot5.id] = slot6
			end
		end

		for slot4, slot5 in pairs(slot0.data) do
			slot0:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
				isInit = true,
				activity = slot5
			})
		end

		if slot0.data[ActivityConst.MILITARY_EXERCISE_ACTIVITY_ID] then
			getProxy(MilitaryExerciseProxy):addSeasonOverTimer()
		end

		if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_CHALLENGE) and not slot1:isEnd() then
			slot0:sendNotification(GAME.CHALLENGE2_INFO, {})
		end

		if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR) and not slot2:isEnd() and slot2.data1 == 0 then
			slot0:monitorTaskList(slot2)
		end

		if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2) and not slot3:isEnd() then
			slot0:InitActivityBossData(slot0.data[slot3.id])
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	end)
	slot0.on(slot0, 11201, function (slot0)
		if Activity.Create(slot0.activity_info).getConfig(slot1, "type") == ActivityConst.ACTIVITY_TYPE_PARAMETER then
			slot0:addActivityParameter(slot1)
		end

		if not slot0.data[slot1.id] then
			slot0:addActivity(slot1)
		else
			slot0:updateActivity(slot1)
		end

		if slot2 == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			slot0:updateActivityFleet(slot0.activity_info)
			slot0:InitActivityBossData(slot1)
		end

		slot0:sendNotification(GAME.ACTIVITY_BE_UPDATED, {
			activity = slot1
		})
	end)

	slot0.requestTime = {}
end

slot0.getActivityByType = function (slot0, slot1)
	slot2 = nil

	for slot6, slot7 in pairs(slot0.data) do
		if slot7:getConfig("type") == slot1 then
			slot2 = slot7

			break
		end
	end

	return slot2
end

slot0.getActivitiesByType = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		if slot7:getConfig("type") == slot1 then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.getActivitiesByTypes = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.data) do
		if table.contains(slot1, slot7:getConfig("type")) then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.GetEarliestActByType = function (slot0, slot1)
	table.sort(slot3, function (slot0, slot1)
		return slot0.id < slot1.id
	end)

	return _.select(slot2, function (slot0)
		return not slot0:isEnd()
	end)[1]
end

slot0.getMilitaryExerciseActivity = function (slot0)
	slot1 = nil

	for slot5, slot6 in pairs(slot0.data) do
		if slot6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MILITARY_EXERCISE then
			slot1 = slot6

			break
		end
	end

	return Clone(slot1)
end

slot0.getPanelActivities = function (slot0)
	return _(_.values(slot0.data)):chain():filter(function (slot0)
		slot1 = slot0:getConfig("type")

		if slot0:isShow() then
			if slot1 == ActivityConst.ACTIVITY_TYPE_CHARGEAWARD then
				slot2 = slot0.data2 == 0
			elseif slot1 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				return (slot0.data1 < 7 or not slot0.achieved) and not slot0:isEnd()
			end
		end
	end).sort(slot1, function (slot0, slot1)
		if slot0:getConfig("login_pop") == slot1:getConfig("login_pop") then
			return slot0.id < slot1.id
		else
			return slot3 < slot2
		end
	end).value(slot1)
end

slot0.getBannerDisplays = function (slot0)
	return _(pg.activity_banner.all):chain():map(function (slot0)
		return pg.activity_banner[slot0]
	end).filter(slot1, function (slot0)
		return pg.TimeMgr.GetInstance():inTime(slot0.time) and slot0.type ~= GAMEUI_BANNER_9 and slot0.type ~= GAMEUI_BANNER_10
	end).value(slot1)
end

slot0.getActiveBannerByType = function (slot0, slot1)
	if #_(pg.activity_banner.all):chain():map(function (slot0)
		return pg.activity_banner[slot0]
	end).filter(slot2, function (slot0)
		return pg.TimeMgr.GetInstance():inTime(slot0.time) and slot0.type == slot0
	end).value(slot2) > 0 then
		return slot2[1]
	end

	return nil
end

slot0.getNoticeBannerDisplays = function (slot0)
	return _.map(pg.activity_banner_notice.all, function (slot0)
		return pg.activity_banner_notice[slot0]
	end)
end

slot0.findNextAutoActivity = function (slot0)
	slot1 = nil
	slot3 = pg.TimeMgr.GetInstance().GetServerTime(slot2)

	for slot7, slot8 in ipairs(slot0:getPanelActivities()) do
		if slot8:isShow() and not slot8.autoActionForbidden then
			if slot8:getConfig("type") == ActivityConst.ACTIVITY_TYPE_7DAYSLOGIN then
				slot12 = #pg.activity_7_day_sign[slot8:getConfig("config_id")].front_drops + 1

				if slot8.getConfig("config_id") == 3 then
					slot12 = #slot11
				end

				if slot8.data1 < slot12 and not slot2:IsSameDay(slot3, slot8.data2) then
					slot1 = slot8

					break
				end
			elseif slot9 == ActivityConst.ACTIVITY_TYPE_PROGRESSLOGIN then
				slot10 = getProxy(ChapterProxy)

				if (slot8.data1 < 7 and not slot2:IsSameDay(slot3, slot8.data2)) or (slot8.data1 == 7 and not slot8.achieved and slot10:isClear(204)) then
					slot1 = slot8

					break
				end
			elseif slot9 == ActivityConst.ACTIVITY_TYPE_MONTHSIGN then
				slot8:setSpecialData("reMonthSignDay", nil)

				if pg.TimeMgr.GetInstance():STimeDescS(slot3, "*t").year ~= slot8.data1 or slot10.month ~= slot8.data2 then
					slot8.data1 = slot10.year
					slot8.data2 = slot10.month
					slot8.data1_list = {}
					slot1 = slot8

					break
				elseif not table.contains(slot8.data1_list, slot10.day) then
					slot1 = slot8

					break
				elseif slot10.day > #slot8.data1_list and slot8.data3 < pg.activity_month_sign[slot8.data2].resign_count then
					for slot15 = slot10.day, 1, -1 do
						if not table.contains(slot8.data1_list, slot15) then
							slot8:setSpecialData("reMonthSignDay", slot15)

							break
						end
					end

					slot1 = slot8
				end
			elseif slot8.id == ActivityConst.SHADOW_PLAY_ID and slot8.clientData1 == 0 and (getProxy(TaskProxy):getTaskById(slot8:getConfig("config_data")[1]) or slot11:getFinishTaskById(slot10)) and not slot12:isReceive() then
				slot1 = slot8

				break
			end
		end
	end

	return slot1
end

slot0.findRefluxAutoActivity = function (slot0)
	if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX) and not slot1:isEnd() and not slot1.autoActionForbidden then
		slot2 = pg.TimeMgr.GetInstance()

		if slot1.data1_list[2] < #pg.return_sign_template.all and not slot2:IsSameDay(slot2:GetServerTime(), slot1.data1_list[1]) then
			return 1
		end
	end
end

slot0.existRefluxAwards = function (slot0)
	if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX) and not slot1:isEnd() then
		for slot6 = #pg.return_pt_template.all, 1, -1 do
			if slot2[slot2.all[slot6]].pt_require <= slot1.data3 and slot1.data4 < slot7 then
				return true
			end
		end

		slot3 = getProxy(TaskProxy)

		if _.any(_(slot1:getConfig("config_data")[7]):chain():map(function (slot0)
			return slot0[2]
		end).flatten(slot4):map(function (slot0)
			return slot0:getTaskById(slot0) or slot0:getFinishTaskById(slot0) or false
		end).filter(slot4, function (slot0)
			return not not slot0
		end).value(slot4), function (slot0)
			return slot0:getTaskStatus() == 1
		end) then
			return true
		end
	end
end

slot0.getActivityById = function (slot0, slot1)
	return Clone(slot0.data[slot1])
end

slot0.updateActivity = function (slot0, slot1)
	slot0.data[slot1.id] = slot1

	slot0.facade:sendNotification(slot0.ACTIVITY_UPDATED, slot1:clone())
end

slot0.addActivity = function (slot0, slot1)
	slot0.data[slot1.id] = slot1

	slot0.facade:sendNotification(slot0.ACTIVITY_ADDED, slot1:clone())
end

slot0.deleteActivityById = function (slot0, slot1)
	slot0.data[slot1] = nil

	slot0.facade:sendNotification(slot0.ACTIVITY_DELETED, slot1)
end

slot0.IsActivityNotEnd = function (slot0, slot1)
	return slot0.data[slot1] and not slot0.data[slot1]:isEnd()
end

slot0.readyToAchieveByType = function (slot0, slot1)
	slot2 = false

	for slot7, slot8 in ipairs(slot3) do
		if slot8:readyToAchieve() then
			slot2 = true

			break
		end
	end

	return slot2
end

slot0.getBuildBgActivityByID = function (slot0, slot1)
	for slot6, slot7 in ipairs(slot2) do
		if not slot7:isEnd() and slot7:getConfig("config_client") and slot8.id == slot1 then
			return slot8.bg
		end
	end

	return nil
end

slot0.getBuildTipActivityByID = function (slot0, slot1)
	for slot6, slot7 in ipairs(slot2) do
		if not slot7:isEnd() and slot7:getConfig("config_client") and slot8.id == slot1 then
			return slot8.rate_tip
		end
	end

	return nil
end

slot0.getBuildActivityCfgByID = function (slot0, slot1)
	for slot6, slot7 in ipairs(slot2) do
		if not slot7:isEnd() and slot7:getConfig("config_client") and slot8.id == slot1 then
			return slot8
		end
	end

	return nil
end

slot0.getBuffShipList = function (slot0)
	_.each(slot0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHIP_BUFF), function (slot0)
		if slot0 and not slot0:isEnd() then
			if not pg.activity_expup_ship[slot0:getConfig("config_id")] then
				return
			end

			for slot7, slot8 in pairs(slot3) do
				slot0[slot8[1]] = slot8[2]
			end
		end
	end)

	return {}
end

slot0.getVirtualItemNumber = function (slot0, slot1)
	if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) and not slot2:isEnd() then
		return (slot2.data1KeyValueList[1][slot1] and slot2.data1KeyValueList[1][slot1]) or 0
	end

	return 0
end

slot0.removeVitemById = function (slot0, slot1, slot2)
	if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) and not slot3:isEnd() then
		slot3.data1KeyValueList[1][slot1] = slot3.data1KeyValueList[1][slot1] - slot2
	end

	slot0:updateActivity(slot3)
end

slot0.addVitemById = function (slot0, slot1, slot2)
	if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG) and not slot3:isEnd() then
		if not slot3.data1KeyValueList[1][slot1] then
			slot3.data1KeyValueList[1][slot1] = 0
		end

		slot3.data1KeyValueList[1][slot1] = slot3.data1KeyValueList[1][slot1] + slot2
	end

	slot0:updateActivity(slot3)

	if pg.item_data_statistics[slot1].link_id ~= 0 and slot0:getActivityById(slot5) and not slot6:isEnd() then
		PlayerResChangeCommand.UpdateActivity(slot6, slot2)
	end
end

slot0.monitorTaskList = function (slot0, slot1)
	if slot1 and not slot1:isEnd() and slot1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR and getProxy(TaskProxy):isReceiveTasks(slot1:getConfig("config_data")[1] or {}) then
		pg.m02:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = slot1.id
		})
	end
end

slot0.updateActivityFleet = function (slot0, slot1)
	getProxy(FleetProxy):addActivityFleet(slot1.id, slot1.group_list)
end

slot0.recommendActivityFleet = function (slot0, slot1, slot2)
	slot5 = getProxy(BayProxy)
	slot6 = getProxy(FleetProxy):getActivityFleets()[slot1][slot2]

	function slot7(slot0, slot1)
		for slot7, slot8 in ipairs(slot3) do
			slot1:insertShip(slot8, nil, slot0)
		end
	end

	if Fleet.SUBMARINE_FLEET_ID <= slot2 then
		if not slot6.isFull(slot6) then
			slot7(TeamType.Submarine, TeamType.SubmarineMax - #slot6.subShips)
		end
	else
		slot9 = TeamType.MainMax - #slot6.mainShips

		if TeamType.VanguardMax - #slot6.vanguardShips > 0 then
			slot7(TeamType.Vanguard, slot8)
		end

		if slot9 > 0 then
			slot7(TeamType.Main, slot9)
		end
	end

	getProxy(FleetProxy):updateActivityFleet(slot1, slot2, slot6)
end

slot0.GetVoteBookActivty = function (slot0)
	return slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_1) or slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_3) or slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_4) or slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_5) or slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_6) or slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_7) or slot0:getActivityById(ActivityConst.VOTE_ORDER_BOOK_PHASE_8)
end

slot0.GetVoteActivity = function (slot0)
	for slot5, slot6 in ipairs(slot1) do
		if slot6:getConfig("config_id") ~= 6 then
			return slot6
		end
	end
end

slot0.InitActivityBossData = function (slot0, slot1)
	if not pg.activity_event_worldboss[slot1:getConfig("config_id")] then
		return
	end

	slot3 = slot1.data1KeyValueList
	slot4 = pairs
	slot5 = slot2.normal_expedition_drop_num or {}

	for slot7, slot8 in slot4(slot5) do
		for slot12, slot13 in pairs(slot8[1]) do
			slot3[1][slot13] = math.max(slot8[2] - (slot3[1][slot13] or 0), 0)
			slot3[2][slot13] = slot3[2][slot13] or 0
		end
	end
end

slot0.AddInstagramTimer = function (slot0, slot1)
	slot0:RemoveInstagramTimer()

	slot3, slot4 = slot0.data[slot1].GetNextPushTime(slot2)

	if slot3 then
		function slot7()
			slot0:sendNotification(GAME.ACT_INSTAGRAM_OP, {
				arg2 = 0,
				activity_id = slot1,
				cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
				arg1 = GAME.ACT_INSTAGRAM_OP
			})
		end

		if slot3 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			slot7()
		else
			slot0.instagramTimer = Timer.New(function ()
				slot0()
				slot1:RemoveInstagramTimer()
			end, slot6, 1)

			slot0.instagramTimer:Start()
		end
	end
end

slot0.RemoveInstagramTimer = function (slot0)
	if slot0.instagramTimer then
		slot0.instagramTimer:Stop()

		slot0.instagramTimer = nil
	end
end

slot0.RegisterRequestTime = function (slot0, slot1, slot2)
	if not slot1 or slot1 <= 0 then
		return
	end

	slot0.requestTime[slot1] = slot2
end

slot0.remove = function (slot0)
	slot0:RemoveInstagramTimer()
end

slot0.ShouldShowInsTip = function (slot0)
	if not slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM) or slot1:isEnd() then
		return false
	end

	return slot1:ShouldShowTip()
end

slot0.ExistSkinCouponActivityAndShopId = function (slot0, slot1)
	return slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON) and not slot2:isEnd() and table.contains(slot2.data1_list, slot1)
end

slot0.ExistSkinCouponActivity = function (slot0)
	return slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON) and not slot1:isEnd()
end

slot0.MarkSkinCoupon = function (slot0, slot1)
	if slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SKIN_COUPON) and not slot2:isEnd() then
		slot2.data1 = slot2.data1 + 1

		if not table.contains(slot2.data1_list, slot1) then
			table.insert(slot2.data1_list, slot1)
		end

		slot0:updateActivity(slot2)
	end
end

slot0.addActivityParameter = function (slot0, slot1)
	slot3 = slot1.stopTime

	for slot7, slot8 in ipairs(slot2) do
		slot0.params[slot8[1]] = {
			slot8[2],
			slot3
		}
	end
end

slot0.getActivityParameter = function (slot0, slot1)
	if slot0.params[slot1] then
		slot2, slot3 = unpack(slot0.params[slot1])

		if slot3 <= 0 or slot3 > pg.TimeMgr.GetInstance():GetServerTime() then
			return slot2
		end
	end
end

return slot0

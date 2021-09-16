slot0 = class("GuildProxy", import(".NetProxy"))
slot0.NEW_GUILD_ADDED = "GuildProxy:NEW_GUILD_ADDED"
slot0.GUILD_UPDATED = "GuildProxy:GUILD_UPDATED"
slot0.EXIT_GUILD = "GuildProxy:EXIT_GUILD"
slot0.REQUEST_ADDED = "GuildProxy:REQUEST_ADDED"
slot0.REQUEST_DELETED = "GuildProxy:REQUEST_DELETED"
slot0.NEW_MSG_ADDED = "GuildProxy:NEW_MSG_ADDED"
slot0.REQUEST_COUNT_UPDATED = "GuildProxy:REQUEST_COUNT_UPDATED"
slot0.LOG_ADDED = "GuildProxy:LOG_ADDED"
slot0.WEEKLYTASK_UPDATED = "GuildProxy:WEEKLYTASK_UPDATED"
slot0.SUPPLY_STARTED = "GuildProxy:SUPPLY_STARTED"
slot0.WEEKLYTASK_ADDED = "GuildProxy:WEEKLYTASK_ADDED"
slot0.DONATE_UPDTAE = "GuildProxy:DONATE_UPDTAE"
slot0.TECHNOLOGY_START = "GuildProxy:TECHNOLOGY_START"
slot0.TECHNOLOGY_STOP = "GuildProxy:TECHNOLOGY_STOP"
slot0.CAPITAL_UPDATED = "GuildProxy:CAPITAL_UPDATED"
slot0.GUILD_BATTLE_STARTED = "GuildProxy:GUILD_BATTLE_STARTED"
slot0.GUILD_BATTLE_CLOSED = "GuildProxy:GUILD_BATTLE_CLOSED"
slot0.ON_DELETED_MEMBER = "GuildProxy:ON_DELETED_MEMBER"
slot0.ON_ADDED_MEMBER = "GuildProxy:ON_ADDED_MEMBER"
slot0.BATTLE_BTN_FLAG_CHANGE = "GuildProxy:BATTLE_BTN_FLAG_CHANGE"
slot0.ON_EXIST_DELETED_MEMBER = "GuildProxy:ON_EXIST_DELETED_MEMBER"
slot0.ON_DONATE_LIST_UPDATED = "GuildProxy:ON_DONATE_LIST_UPDATED"

slot0.register = function (slot0)
	slot0:Init()
	slot0:on(60000, function (slot0)
		if Guild.New(slot0.guild).id == 0 then
			slot0:exitGuild()
		elseif slot0.data == nil then
			slot0:addGuild(slot1)

			if not getProxy(GuildProxy).isGetChatMsg then
				slot0:sendNotification(GAME.GET_GUILD_CHAT_LIST)
			end

			slot0:sendNotification(GAME.GUILD_GET_USER_INFO)
			slot0:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET, {})
			slot0:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {})
			slot0:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
				force = true
			})
			slot0:sendNotification(GAME.GUILD_GET_REQUEST_LIST, slot1.id)
		else
			slot0:updateGuild(slot1)
		end
	end)
	slot0.on(slot0, 60009, function (slot0)
		slot0.requestCount = slot0.count

		slot0:sendNotification(slot1.REQUEST_COUNT_UPDATED, slot0.count)
	end)
	slot0.on(slot0, 60030, function (slot0)
		if not slot0:getData() then
			return
		end

		slot1:updateBaseInfo({
			base = slot0.guild
		})
		slot0:updateGuild(slot1)
	end)
	slot0.on(slot0, 60031, function (slot0)
		if not slot0:getData() then
			return
		end

		slot2 = false

		for slot6, slot7 in ipairs(slot0.member_list) do
			if GuildMember.New(slot7).duty == 0 then
				slot1:deleteMember(slot8.id)
				slot0:sendNotification(GuildProxy.ON_DELETED_MEMBER, {
					member = slot1:getMemberById(slot8.id):clone()
				})

				slot2 = true
			elseif slot1.member[slot8.id] then
				slot1:updateMember(slot8)
			else
				slot1:addMember(slot8)
				slot0:sendNotification(GuildProxy.ON_ADDED_MEMBER, {
					member = slot8
				})
			end
		end

		for slot6, slot7 in ipairs(slot0.log_list) do
			slot1:addLog(slot8)
			slot0:sendNotification(slot1.LOG_ADDED, Clone(GuildLogInfo.New(slot7)))
		end

		slot1:setMemberCount(table.getCount(slot1.member or {}))
		slot0:updateGuild(slot1)

		if slot2 then
			slot0:sendNotification(GuildProxy.ON_EXIST_DELETED_MEMBER)
		end
	end)
	slot0.on(slot0, 60032, function (slot0)
		if not slot0:getData() then
			return
		end

		slot1:updateExp(slot0.exp)
		slot1:updateLevel(slot0.lv)
		slot0:updateGuild(slot1)
	end)
	slot0.on(slot0, 60008, function (slot0)
		if slot0.data:warpChatInfo(slot0.chat) then
			slot0:AddNewMsg(slot2)
		end
	end)
	slot0.on(slot0, 62004, function (slot0)
		if not slot0:getData() or not slot1:IsCompletion() then
			return
		end

		slot1:updateWeeklyTask(slot2)
		slot1:setWeeklyTaskFlag(0)
		slot0:updateGuild(slot1)
		slot0:sendNotification(slot1.WEEKLYTASK_ADDED)
	end)
	slot0.on(slot0, 62005, function (slot0)
		if not slot0:getData() or not slot1:IsCompletion() then
			return
		end

		slot1:startSupply(slot0.benefit_finish_time)
		slot1:consumeCapital(slot2)
		slot0:updateGuild(slot1)
		slot0:sendNotification(slot1.CAPITAL_UPDATED)
		slot0:sendNotification(slot1.SUPPLY_STARTED)
	end)
	slot0.on(slot0, 62018, function (slot0)
		if not slot0:getData() or not slot1:IsCompletion() then
			return
		end

		slot2 = pg.guild_technology_template[slot0.id].group

		if slot1:getActiveTechnologyGroup() then
			slot3:Stop()
		end

		slot1:getTechnologyGroupById(slot2).Start(slot4)
		slot1:UpdateTechCancelCnt()
		slot0:updateGuild(slot1)
		slot0:sendNotification(slot1.TECHNOLOGY_START)
	end)
	slot0.on(slot0, 62019, function (slot0)
		if not slot0:getData() or not slot1:IsCompletion() then
			return
		end

		slot2 = GuildDonateTask.New({
			id = slot0.id
		})
		slot3 = slot0.has_capital == 1
		slot4 = slot0.has_tech_point == 1
		slot5 = slot0.user_id
		slot6 = getProxy(PlayerProxy):getRawData().id

		if slot3 then
			slot1:updateCapital(slot1:getCapital() + slot2:getCapital())

			if slot6 == slot5 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_addition_capital_tip", slot7))
			end
		end

		if slot4 and slot1:getActiveTechnologyGroup() then
			slot7:AddProgress(slot2:getConfig("award_tech_exp"))

			if slot7.pid ~= slot7.pid and slot7:GuildMemberCntType() then
				slot1:getTechnologyById(slot7.id):Update(slot10, slot7)
			end

			if slot6 == slot5 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_addition_techpoint_tip", slot9))
			end
		end

		if slot3 or slot4 then
			slot0:updateGuild(slot1)
			slot0:sendNotification(slot1.DONATE_UPDTAE)
		end

		if slot3 then
			slot0:sendNotification(slot1.CAPITAL_UPDATED)
		end

		if not slot3 and slot5 == slot6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_capital_toplimit"))
		end

		if not slot4 and slot5 == slot6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_donate_techpoint_toplimit"))
		end
	end)
	slot0.on(slot0, 62031, function (slot0)
		if not slot0:getData() or not slot1:IsCompletion() then
			return
		end

		slot2 = {}

		for slot6, slot7 in ipairs(slot0.donate_tasks) do
			table.insert(slot2, GuildDonateTask.New({
				id = slot7
			}))
		end

		if slot1 then
			slot1.donateCount = 0

			slot1:updateDonateTasks(slot2)
			slot0:updateGuild(slot1)
			slot0:sendNotification(slot1.ON_DONATE_LIST_UPDATED)
		elseif slot0:GetPublicGuild() then
			slot3:ResetDonateCnt()
			slot3:UpdateDonateTasks(slot2)
			slot0:sendNotification(GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE)
		end
	end)
	slot0.on(slot0, 61021, function (slot0)
		slot0.refreshActivationEventTime = 0

		if slot0.user_id ~= getProxy(PlayerProxy):getData().id then
			slot0:sendNotification(slot1.GUILD_BATTLE_STARTED)
		end
	end)
end

slot0.AddPublicGuild = function (slot0, slot1)
	slot0.publicGuild = slot1
end

slot0.GetPublicGuild = function (slot0)
	return slot0.publicGuild
end

slot0.Init = function (slot0)
	slot0.data = nil
	slot0.chatMsgs = {}
	slot0.bossRanks = {}
	slot0.isGetChatMsg = false
	slot0.refreshActivationEventTime = 0
	slot0.nextRequestBattleRankTime = 0
	slot0.refreshBossTime = 0
	slot0.bossRankUpdateTime = 0
	slot0.isFetchAssaultFleet = false
	slot0.battleRanks = {}
	slot0.ranks = {}
	slot0.requests = nil
	slot0.rankUpdateTime = 0
	slot0.requestReportTime = 0
	slot0.newChatMsgCnt = 0
	slot0.requestCount = 0
	slot0.cdTime = {
		0,
		0
	}
end

slot0.AddNewMsg = function (slot0, slot1)
	slot0.newChatMsgCnt = slot0.newChatMsgCnt + 1

	slot0:addMsg(slot1)
	slot0:sendNotification(slot0.NEW_MSG_ADDED, slot1)
end

slot0.ResetRequestCount = function (slot0)
	slot0.requestCount = 0
end

slot0.UpdatePosCdTime = function (slot0, slot1, slot2)
	slot0.cdTime[slot1] = slot2
end

slot0.GetNextCanFormationTime = function (slot0, slot1)
	return (slot0.cdTime[slot1] or 0) + pg.guildset.operation_assault_team_cd.key_value
end

slot0.CanFormationPos = function (slot0, slot1)
	return slot0:GetNextCanFormationTime(slot1) <= pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.ClearNewChatMsgCnt = function (slot0)
	slot0.newChatMsgCnt = 0
end

slot0.GetNewChatMsgCnt = function (slot0)
	return slot0.newChatMsgCnt
end

slot0.setRequestList = function (slot0, slot1)
	slot0.requests = slot1
end

slot0.addGuild = function (slot0, slot1)
	slot0.data = slot1

	slot0:sendNotification(slot0.NEW_GUILD_ADDED, Clone(slot1))
end

slot0.updateGuild = function (slot0, slot1)
	slot0.data = slot1

	slot0:sendNotification(slot0.GUILD_UPDATED, Clone(slot1))
end

slot0.exitGuild = function (slot0)
	slot0:Init()
	slot0:sendNotification(slot0.EXIT_GUILD)
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildEvent")
	pg.ShipFlagMgr.GetInstance():ClearShipsFlag("inGuildBossEvent")
end

slot0.getRequests = function (slot0)
	return slot0.requests
end

slot0.getSortRequest = function (slot0)
	if not slot0.requests then
		return nil
	end

	slot1 = {}

	for slot5, slot6 in pairs(slot0.requests) do
		table.insert(slot1, slot6)
	end

	return slot1
end

slot0.deleteRequest = function (slot0, slot1)
	if not slot0.requests then
		return
	end

	slot0.requests[slot1] = nil

	slot0:sendNotification(slot0.REQUEST_DELETED, slot1)
end

slot0.addMsg = function (slot0, slot1)
	table.insert(slot0.chatMsgs, slot1)

	if GuildConst.CHAT_LOG_MAX_COUNT < #slot0.chatMsgs then
		table.remove(slot0.chatMsgs, 1)
	end
end

slot0.getChatMsgs = function (slot0)
	return slot0.chatMsgs
end

slot0.GetMessagesByUniqueId = function (slot0, slot1)
	return _.select(slot0.chatMsgs, function (slot0)
		return slot0.uniqueId == slot0
	end)
end

slot0.UpdateMsg = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.chatMsgs) do
		if slot6:IsSame(slot1.uniqueId) then
			slot0.data[slot5] = slot1
		end
	end
end

slot0.ShouldFetchActivationEvent = function (slot0)
	return slot0.refreshActivationEventTime < pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.AddFetchActivationEventCDTime = function (slot0)
	slot0.refreshActivationEventTime = GuildConst.REFRESH_ACTIVATION_EVENT_TIME + pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.AddActivationEventTimer = function (slot0, slot1)
	return
end

slot0.RemoveActivationEventTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.remove = function (slot0)
	slot0:RemoveActivationEventTimer()
end

slot0.SetRank = function (slot0, slot1, slot2)
	slot0.ranks[slot1] = slot2
	slot0["rankTimer" .. slot1] = pg.TimeMgr.GetInstance():GetServerTime() + 1800
end

slot0.GetRanks = function (slot0)
	return slot0.ranks
end

slot0.ShouldRefreshRank = function (slot0, slot1)
	if not slot0["rankTimer" .. slot1] or slot0["rankTimer" .. slot1] <= pg.TimeMgr.GetInstance():GetServerTime() then
		return true
	end

	return false
end

slot0.SetReports = function (slot0, slot1)
	slot0.reports = slot1
end

slot0.GetReports = function (slot0)
	return slot0.reports or {}
end

slot0.GetReportById = function (slot0, slot1)
	return slot0.reports[slot1]
end

slot0.AddReport = function (slot0, slot1)
	if not slot0.reports then
		slot0.reports = {}
	end

	slot0.reports[slot1.id] = slot1
end

slot0.GetMaxReportId = function (slot0)
	slot2 = 0

	for slot6, slot7 in pairs(slot1) do
		if slot2 < slot7.id then
			slot2 = slot7.id
		end
	end

	return slot2
end

slot0.AnyRepoerCanGet = function (slot0)
	return #slot0:GetCanGetReports() > 0
end

slot0.GetCanGetReports = function (slot0)
	slot1 = {}

	for slot6, slot7 in pairs(slot2) do
		if slot7:CanSubmit() then
			table.insert(slot1, slot7.id)
		end
	end

	return slot1
end

slot0.ShouldRequestReport = function (slot0)
	if not slot0.requestReportTime then
		slot0.requestReportTime = 0
	end

	function slot1()
		if slot0:getRawData():GetActiveEvent() and slot1:GetMissionFinishCnt() > 0 then
			return true
		end

		return false
	end

	slot2 = pg.TimeMgr.GetInstance().GetServerTime(slot2)

	if (not slot0.reports and slot1()) or slot0.requestReportTime < slot2 then
		slot0.requestReportTime = slot2 + GuildConst.REQUEST_REPORT_CD

		return true
	end

	return false
end

slot0.ShouldRequestForamtion = function (slot0)
	if not slot0.requestFormationTime then
		slot0.requestFormationTime = 0
	end

	if slot0.requestFormationTime < pg.TimeMgr.GetInstance():GetServerTime() then
		slot0.requestFormationTime = slot1 + GuildConst.REQUEST_FORMATION_CD

		return true
	end

	return false
end

slot0.GetRecommendShipsForMission = function (slot0, slot1)
	if slot1:IsEliteType() then
		return slot0:GetRecommendShipsForEliteMission(slot1)
	else
		slot2 = {}
		slot5 = {}

		for slot9, slot10 in pairs(slot4) do
			table.insert(slot5, {
				id = slot10.id,
				power = slot10:getShipCombatPower(),
				nation = slot10:getNation(),
				type = slot10:getShipType(),
				level = slot10.level,
				tagList = slot10:getConfig("tag_list"),
				configId = slot10.configId,
				attrs = slot10:getProperties(),
				isActivityNpc = function ()
					return slot0:isActivityNpc()
				end
			})
		end

		table.sort(slot5, function (slot0, slot1)
			return slot0:CompareRecommendShip(slot0, slot1)
		end)

		for slot9, slot10 in ipairs(slot5) do
			if GuildEventMediator.OnCheckMissionShip(slot1.id, slot2, slot10) then
				table.insert(slot2, slot10.id)
			end

			if #slot2 == 4 then
				break
			end
		end

		return slot2
	end
end

slot0.GetRecommendShipsForEliteMission = function (slot0, slot1)
	slot2 = {}
	slot5 = {}
	slot6 = {}
	slot7 = {}

	for slot11, slot12 in pairs(slot4) do
		if slot1.SameSquadron(slot1, {
			id = slot12.id,
			power = slot12:getShipCombatPower(),
			nation = slot12:getNation(),
			type = slot12:getShipType(),
			level = slot12.level,
			tagList = slot12:getConfig("tag_list"),
			configId = slot12.configId,
			attrs = slot12:getProperties(),
			isActivityNpc = function ()
				return slot0:isActivityNpc()
			end
		}) then
			table.insert(slot6, slot13)
		else
			table.insert(slot7, slot13)
		end
	end

	function slot8(slot0)
		if slot0 and not table.contains(slot0, slot0.id) and GuildEventMediator.OnCheckMissionShip(slot1.id, slot0, slot0) then
			table.insert(slot0, slot0.id)
		end
	end

	slot9 = slot1.GetEffectAttr(slot1)

	function slot10(slot0, slot1)
		if (slot0.attrs[slot0] or 0) == (slot1.attrs[slot0] or 0) then
			if slot0.level == slot1.level then
				return slot1.power < slot0.power
			else
				return slot1.level < slot0.level
			end
		else
			return slot3 < slot2
		end
	end

	function slot11(slot0, slot1)
		if 0 + ((slot0:MatchAttr(slot0) and 1000) or 0) + ((slot0:MatchNation(slot0) and 100) or 0) + ((slot0:MatchShipType(slot0) and 10) or 0) == 0 + ((slot0:MatchAttr(slot1) and 1000) or 0) + ((slot0:MatchNation(slot1) and 100) or 0) + ((slot0:MatchShipType(slot1) and 10) or 0) then
			return slot1(slot0, slot1)
		else
			return slot3 < slot2
		end
	end

	slot12 = slot1.GetSquadronTargetCnt(slot1)

	if #slot6 > 0 and slot12 > 0 then
		table.sort(slot6, slot11)

		for slot16 = 1, slot12, 1 do
			slot8(slot6[slot16])
		end
	end

	if #slot2 < 4 and #slot7 > 0 then
		table.sort(slot7, slot11)

		for slot16 = 1, #slot7, 1 do
			if #slot2 == 4 then
				break
			end

			slot8(slot7[slot16])
		end
	end

	if #slot2 < 4 and slot12 > 0 and slot12 < #slot6 then
		for slot16 = slot12 + 1, #slot6, 1 do
			if #slot2 == 4 then
				break
			end

			slot8(slot6[slot16])
		end
	end

	return slot2
end

slot0.ShouldShowApplyTip = function (slot0)
	if slot0.data and GuildMember.IsAdministrator(slot0.data:getSelfDuty()) then
		if not slot0.requests then
			return slot0.requestCount > 0
		end

		return table.getCount(slot0.requests) + slot0.requestCount > 0
	end

	return false
end

slot0.ShouldShowBattleTip = function (slot0)
	slot2 = false

	function slot3(slot0)
		if slot0 and slot0:IsParticipant() then
			return slot0:GetBossMission() and slot1:IsActive() and slot1:CanEnterBattle()
		end

		return false
	end

	function slot4()
		for slot3, slot4 in ipairs(pg.guild_operation_template.all) do
			if pg.guild_operation_template[slot4].unlock_guild_level <= slot0.level and slot5.consume <= slot0:getCapital() then
				return true
			end
		end

		return false
	end

	if slot0:getData() then
		slot2 = slot0:ShouldShowMainTip() or (not slot1.GetActiveEvent(slot1) and GuildMember.IsAdministrator(slot1:getSelfDuty()) and slot4()) or (slot1.GetActiveEvent(slot1) and not slot0:GetBattleBtnRecord())

		if slot5 then
			return slot2 or (slot5:IsParticipant() and slot5:AnyMissionCanFormation()) or slot3(slot5) or (not slot7 and not slot5:IsLimitedJoin())
		end
	end
end

slot0.SetBattleBtnRecord = function (slot0)
	if not slot0:GetBattleBtnRecord() and slot0:getRawData() and slot2:GetActiveEvent() then
		PlayerPrefs.SetInt("guild_battle_btn_flag" .. getProxy(PlayerProxy):getRawData().id, 1)
		PlayerPrefs.Save()
		slot0:sendNotification(slot0.BATTLE_BTN_FLAG_CHANGE)
	end
end

slot0.GetBattleBtnRecord = function (slot0)
	return PlayerPrefs.GetInt("guild_battle_btn_flag" .. getProxy(PlayerProxy):getRawData().id, 0) > 0
end

slot0.ShouldShowMainTip = function (slot0)
	function slot1()
		return slot0.data:getMemberById(slot0):IsRecruit()
	end

	return _.any(slot0.reports or {}, function (slot0)
		return slot0:CanSubmit()
	end) and not slot1()
end

slot0.ShouldShowTip = function (slot0)
	slot1 = {}

	if slot0:getData() then
		table.insert(slot1, slot2:ShouldShowDonateTip())
		table.insert(slot1, slot0:ShouldShowApplyTip())
		table.insert(slot1, slot2:ShouldWeeklyTaskTip())
		table.insert(slot1, slot2:ShouldShowSupplyTip())
		table.insert(slot1, slot2:ShouldShowTechTip())

		if not LOCK_GUILD_BATTLE then
			table.insert(slot1, slot0:ShouldShowBattleTip())
		end
	end

	return #slot1 > 0 and _.any(slot1, function (slot0)
		return slot0 == true
	end)
end

slot0.SetRefreshBossTime = function (slot0, slot1)
	slot0.refreshBossTime = slot1 + GuildConst.REFRESH_BOSS_TIME
end

slot0.ShouldRefreshBoss = function (slot0)
	return slot0:getRawData():GetActiveEvent() and not slot1:IsExpired() and slot0.refreshBossTime <= pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.ResetRefreshBossTime = function (slot0)
	slot0.refreshBossTime = 0
end

slot0.ShouldRefreshBossRank = function (slot0)
	return slot0:getRawData():GetActiveEvent() and GuildConst.REFRESH_MISSION_BOSS_RANK_TIME <= pg.TimeMgr.GetInstance():GetServerTime() - slot0.bossRankUpdateTime
end

slot0.UpdateBossRank = function (slot0, slot1)
	slot0.bossRanks = slot1
end

slot0.GetBossRank = function (slot0)
	return slot0.bossRanks
end

slot0.ResetBossRankTime = function (slot0)
	slot0.rankUpdateTime = 0
end

slot0.UpdateBossRankRefreshTime = function (slot0, slot1)
	slot0.rankUpdateTime = slot1
end

slot0.GetAdditionGuild = function (slot0)
	if slot0.data == nil then
		return slot0.publicGuild
	else
		return slot0.data
	end
end

return slot0

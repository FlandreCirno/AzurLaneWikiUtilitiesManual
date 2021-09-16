slot0 = class("WorldBossProxy", import("....BaseEntity"))
slot0.CacheKey = "WorldbossFleet"
slot0.INFINITY = 9999999999.0
slot0.Fields = {
	ptTime = "number",
	cacheLock = "number",
	isFetched = "boolean",
	boss = "table",
	ranks = "table",
	isSetup = "boolean",
	unlockTip = "boolean",
	fleet = "table",
	otherBosses = "table",
	timers = "table",
	cacheBosses = "table",
	pt = "number",
	refreshBossesTime = "number"
}
slot0.REFRESH_BOSSES_TIME = 300
slot0.VIRTUAL_ITEM_ID = 100001
slot0.EventProcessBossListUpdated = "WorldBossProxy.EventProcessBossListUpdated"
slot0.EventCacheBossListUpdated = "WorldBossProxy.EventCacheBossListUpdated"
slot0.EventBossUpdated = "WorldBossProxy.EventBossUpdated"
slot0.EventFleetUpdated = "WorldBossProxy.EventFleetUpdated"
slot0.EventPtUpdated = "WorldBossProxy.EventPtUpdated"
slot0.EventRankListUpdated = "WorldBossProxy.EventRankListUpdated"
slot0.EventUnlockProgressUpdated = "WorldBossProxy.EventUnlockProgressUpdated"

slot0.Setup = function (slot0, slot1)
	slot0.pt = slot0:GetMaxPt() - (slot1.fight_count or 0)

	if slot1.self_boss then
		slot3 = WorldBoss.New()

		slot3:Setup(slot1.self_boss, getProxy(PlayerProxy):getData())

		if slot3:Active() then
			slot0.boss = slot3
		end
	end

	slot0.cacheBosses = {}
	slot0.ranks = {}
	slot0.timers = {}
	slot0.fleet = nil

	slot0:GenFleet()

	slot0.refreshBossesTime = 0
	slot0.isSetup = true
	slot0.isFetched = false
end

slot0.GenFleet = function (slot0)
	slot0.fleet = Fleet.New({
		0,
		id = 1,
		name = i18n("world_boss_fleet"),
		ship_list = slot0:GetCacheShips()
	})
end

slot0.GetCacheShips = function (slot0)
	slot3 = {}

	if string.split(slot1, "|") and #slot2 > 0 and (#slot2 ~= 1 or slot2[1] ~= "") then
		for slot7, slot8 in ipairs(slot2) do
			if getProxy(BayProxy):getShipById(tonumber(slot8)) then
				table.insert(slot3, slot9)
			end
		end
	end

	return slot3
end

slot0.SavaCacheShips = function (slot0, slot1)
	slot3 = ""

	for slot7, slot8 in ipairs(slot2) do
		slot3 = slot3 .. slot8 .. "|"
	end

	PlayerPrefs.SetString(slot0.CacheKey .. getProxy(PlayerProxy):getRawData().id, slot3)
	PlayerPrefs.Save()
end

slot0.ClearCacheShips = function (slot0)
	PlayerPrefs.DeleteKey(slot0.CacheKey .. getProxy(PlayerProxy):getRawData().id)
	PlayerPrefs.Save()
end

slot0.UpdteRefreshBossesTime = function (slot0)
	slot0.refreshBossesTime = pg.TimeMgr.GetInstance():GetServerTime() + slot0.REFRESH_BOSSES_TIME
end

slot0.ShouldRefreshBosses = function (slot0)
	return slot0.refreshBossesTime <= pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.UpdateCacheBoss = function (slot0, slot1)
	if slot0:IsSelfBoss(slot1) then
		slot0:UpdateSelfBoss(slot1)
	else
		slot0.cacheBosses[slot1.id] = slot1

		slot0:BalanceMaxBossCnt()
	end
end

slot0.BalanceMaxBossCnt = function (slot0)
	if table.getCount(slot0.cacheBosses) < pg.gameset.boss_cnt_limit.description[1] then
		return
	end

	slot2 = {}
	slot3 = {}
	slot4 = {}
	slot5 = {}

	for slot9, slot10 in pairs(slot0.cacheBosses) do
		slot11 = slot10:GetType()

		if slot10:isDeath() or slot10:IsExpired() then
			table.insert(slot5, slot10)
		elseif slot11 == WorldBoss.BOSS_TYPE_FRIEND then
			table.insert(slot4, slot10)
		elseif slot11 == WorldBoss.BOSS_TYPE_GUILD then
			table.insert(slot3, slot10)
		elseif slot11 == WorldBoss.BOSS_TYPE_WORLD then
			table.insert(slot2, slot10)
		end
	end

	if slot1[2] < #slot2 then
		table.sort(slot2, function (slot0, slot1)
			return slot0:GetJoinTime() < slot1:GetJoinTime()
		end)

		if slot2[1] then
			table.insert(slot5, slot2[1])
		end
	end

	if slot1[3] < #slot3 then
		table.sort(slot3, function (slot0, slot1)
			return slot0:GetJoinTime() < slot1:GetJoinTime()
		end)

		if slot3[1] then
			table.insert(slot5, slot3[1])
		end
	end

	if slot1[4] < #slot4 then
		table.sort(slot4, function (slot0, slot1)
			return slot0:GetJoinTime() < slot1:GetJoinTime()
		end)

		if slot4[1] then
			table.insert(slot5, slot4[1])
		end
	end

	if #slot5 > 0 then
		for slot9, slot10 in ipairs(slot5) do
			if slot0.cacheBosses[slot10.id] and slot10.id ~= slot0.cacheLock then
				slot0.cacheBosses[slot10.id] = nil
			end
		end

		slot0:DispatchEvent(slot0.EventCacheBossListUpdated)
	end
end

slot0.RemoveCacheBoss = function (slot0, slot1)
	if slot0.cacheBosses[slot1] then
		slot0.cacheBosses[slot1] = nil

		slot0:DispatchEvent(slot0.EventCacheBossListUpdated)
	end
end

slot0.GetCacheBoss = function (slot0, slot1)
	return slot0.cacheBosses[slot1]
end

slot0.LockCacheBoss = function (slot0, slot1)
	slot0.cacheLock = slot1
end

slot0.UnlockCacheBoss = function (slot0)
	slot0.cacheLock = nil
end

slot0.canGetSelfAward = function (slot0)
	return slot0:GetSelfBoss() and slot1:isDeath()
end

slot0.UpdateFleet = function (slot0, slot1)
	slot0.fleet = slot1

	slot0:DispatchEvent(slot0.EventFleetUpdated)
end

slot0.UpdateSelfBoss = function (slot0, slot1)
	if slot0.boss and slot1 and not slot1:isSameLevel(slot0.boss) then
		slot0.fleet:clearFleet()
	end

	slot0.boss = slot1

	slot0:DispatchEvent(slot0.EventBossUpdated)
end

slot0.RemoveSelfBoss = function (slot0)
	slot0:UpdateSelfBoss(nil)
end

slot0.updateBossHp = function (slot0, slot1, slot2)
	if slot0.boss and slot1 == slot0.boss.id then
		slot0.boss:UpdateHp(slot2)
		slot0:UpdateSelfBoss(slot0.boss)
	elseif slot0.cacheBosses[slot1] then
		slot3:UpdateHp(slot2)
		slot0:UpdateCacheBoss(slot3)
	end
end

slot0.GetBossById = function (slot0, slot1)
	if slot0.boss and slot0.boss.id == slot1 then
		return slot0.boss
	end

	if slot0.cacheBosses[slot1] then
		return slot2
	end
end

slot0.GetSelfBoss = function (slot0)
	return slot0.boss
end

slot0.IsSelfBoss = function (slot0, slot1)
	return (slot0.boss and slot0.boss.id == slot1.id) or slot1:IsSelf()
end

slot0.GetBoss = function (slot0)
	return slot0.boss
end

slot0.ExistSelfBoss = function (slot0)
	return slot0.boss ~= nil and not slot0.boss:IsExpired()
end

slot0.GetCacheBossList = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.cacheBosses) do
		if not slot0:IsSelfBoss(slot6) then
			table.insert(slot1, slot6)
		end
	end

	return slot1
end

slot0.reducePt = function (slot0)
	slot0.pt = slot0.pt - 1

	slot0:DispatchEvent(slot0.EventPtUpdated)
end

slot0.increasePt = function (slot0)
	slot0.pt = math.min(slot1, slot0.pt + pg.gameset.joint_boss_ap_recove_cnt_pre_day.key_value)

	slot0:DispatchEvent(slot0.EventPtUpdated)
end

slot0.SetRank = function (slot0, slot1, slot2)
	slot0.ranks[slot1] = slot2

	if slot0:GetBossById(slot1) then
		slot3:SetRankCnt(#slot2)
	end

	slot0:addTimer(slot1)
	slot0:DispatchEvent(slot0.EventRankListUpdated, slot1)
end

slot0.GetRank = function (slot0, slot1)
	return slot0.ranks[slot1]
end

slot0.ClearRank = function (slot0, slot1)
	slot0.ranks[slot1] = nil
end

slot0.GetFleet = function (slot0)
	for slot4 = #slot0.fleet.ships, 1, -1 do
		if not getProxy(BayProxy):getShipById(slot0.fleet.ships[slot4]) then
			slot0.fleet:removeShipById(slot5)
		end
	end

	return slot0.fleet
end

slot0.addTimer = function (slot0, slot1)
	if not slot1 then
		return
	end

	if slot0.timers[slot1] then
		slot0.timers[slot1]:Stop()

		slot0.timers[slot1] = nil
	end

	slot0.timers[slot1] = Timer.New(function ()
		if slot0.ranks then
			slot0.ranks[slot1] = nil

			slot0.ranks.timers[slot1]:Stop()

			slot0.ranks.timers[slot1].Stop.timers[slot0.ranks.timers[slot1]] = nil
		end
	end, 300, 1)

	slot0.timers[slot1].Start(slot2)
end

slot0.GetPt = function (slot0)
	return slot0.pt
end

slot0.GetMaxPt = function (slot0)
	return pg.gameset.joint_boss_ap_max.key_value
end

slot0.isMaxPt = function (slot0)
	return slot0.pt == slot0:GetMaxPt()
end

slot0.GetRecoverPtTime = function (slot0)
	return pg.gameset.joint_boss_ap_recover_time.key_value
end

slot0.GetNextReconveTime = function (slot0)
	return slot0.ptTime
end

slot0.updatePtTime = function (slot0, slot1)
	slot0.ptTime = slot1
end

slot0.Dispose = function (slot0)
	slot0.super.Dispose(slot0)

	slot1 = pairs
	slot2 = slot0.timers or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:Stop()
	end

	slot0.timers = nil
end

slot0.NeedTip = function (slot0)
	function slot1()
		if slot0.boss and slot0.boss:isDeath() and not slot0.boss:IsExpired() and not slot0.boss:ShouldWaitForResult() then
			return true
		end

		return false
	end

	return slot1()
end

slot0.UpdatedUnlockProgress = function (slot0)
	if slot0:CanUnlock() then
		slot0.unlockTip = true
	end

	slot0:DispatchEvent(slot0.EventUnlockProgressUpdated)
end

slot0.GetUnlockProgress = function (slot0)
	slot1 = 0
	slot2 = 1

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) and not slot3:isEnd() then
		slot1 = slot3.data1
		slot2 = slot3.data2 + 1
	end

	return math.min(pg.gameset.joint_boss_ticket.description[slot2] or slot0.INFINITY, slot1), pg.gameset.joint_boss_ticket.description[slot2] or slot0.INFINITY, slot2, #slot4, slot4[#slot4]
end

slot0.CanUnlock = function (slot0)
	slot1, slot2 = slot0:GetUnlockProgress()

	return slot2 <= slot1
end

slot0.GetCanGetAwardBoss = function (slot0)
	return nil
end

slot0.ExistSelfBossAward = function (slot0)
	if slot0.boss and slot0.boss:isDeath() and not slot0.boss:IsExpired() then
		return true
	end

	return false
end

slot0.ExistCacheBoss = function (slot0)
	return table.getCount(slot0.cacheBosses) ~= 0
end

slot0.IsOpen = function (slot0)
	return getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) and not slot1:isEnd()
end

slot0.IsNeedSupport = function ()
	if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) or slot0:isEnd() then
		return
	end

	if slot0:getDayIndex() < pg.gameset.world_metaboss_supportattack.description[1] then
		return
	end

	return true, math.min(slot1, slot2[2])
end

slot0.GetSupportValue = function ()
	slot0, slot1 = WorldBossProxy.IsNeedSupport()

	if not slot0 then
		return
	end

	return true, slot1, pg.gameset.world_metaboss_supportattack.description[3]
end

return slot0

slot0 = class("Map", import(".BaseVO"))
slot0.INVALID = 0
slot0.SCENARIO = 1
slot0.ELITE = 2
slot0.EVENT = 3
slot0.ACTIVITY_EASY = 4
slot0.ACTIVITY_HARD = 5
slot0.ACT_EXTRA = 8
slot0.ESCORT = 9
slot0.SKIRMISH = 10
slot0.NORMAL_MAP = {
	slot0.INVALID,
	slot0.SCENARIO,
	slot0.ELITE,
	slot0.EVENT,
	slot0.ACTIVITY_EASY,
	slot0.ACTIVITY_HARD,
	slot0.SHAM,
	slot0.GUILD_BOSS,
	slot0.ACT_EXTRA
}

slot0.Ctor = function (slot0, slot1)
	slot0.configId = slot1.id
	slot0.id = slot0.configId
	slot0.chapterIds = slot1.chapterIds
end

slot0.bindConfigTable = function (slot0)
	return pg.expedition_data_by_map
end

slot0.isUnlock = function (slot0)
	if getProxy(PlayerProxy):getRawData().level < slot0:getConfig("level_limit") then
		return false, i18n("levelScene_chapter_unlock_tip", slot0:getConfig("level_limit"))
	elseif slot0:isActivity() then
		if slot0:isRemaster() then
			if slot0:isAnyChapterUnlocked() then
				return true
			else
				return false, i18n("battle_levelScene_lock")
			end
		elseif not getProxy(ActivityProxy):getActivityById(slot0:getConfig("on_activity")) or slot2:isEnd() then
			return false, i18n("common_activity_end")
		else
			slot3, slot4 = slot0:isAnyChapterUnlocked(true)

			if slot3 then
				return true
			elseif slot4 then
				return false, i18n("battle_levelScene_lock_1")
			else
				return false, i18n("battle_levelScene_lock")
			end
		end
	elseif slot0:getMapType() == Map.SCENARIO then
		if slot0:isAnyChapterUnlocked(false, true) then
			return true
		else
			return false, i18n("levelScene_map_lock")
		end
	elseif slot0:getMapType() == Map.ELITE then
		if slot0:isEliteEnabled() then
			return true
		else
			return false, i18n("levelScene_map_lock")
		end
	else
		return true
	end
end

slot0.setRemaster = function (slot0, slot1)
	slot0.remasterId = slot1
end

slot0.isRemaster = function (slot0)
	return slot0.remasterId ~= nil
end

slot0.getMapType = function (slot0)
	return slot0:getConfig("type")
end

slot0.getMapTitleNumber = function (slot0)
	return slot0:getConfig("title")
end

slot0.getBindMapId = function (slot0)
	return slot0:getConfig("bind_map")
end

slot0.getBindMap = function (slot0)
	return getProxy(ChapterProxy):getMapById(slot0:getBindMapId())
end

slot0.getChapters = function (slot0, slot1)
	slot2 = getProxy(ChapterProxy)

	return underscore.map(slot0.chapterIds, function (slot0)
		return slot0:getChapterById(slot0, slot0.getChapterById)
	end)
end

slot0.getEscortConfig = function (slot0)
	if slot0:isEscort() then
		return pg.escort_map_template[slot0.id]
	end
end

slot0.getChapterTimeLimit = function (slot0)
	if not slot0:isActivity() or slot0:isRemaster() then
		return 0
	end

	slot1 = pg.TimeMgr.GetInstance()
	slot2 = 0

	for slot6, slot7 in ipairs(slot0:getChapters(true)) do
		if pg.activity_template[slot7:getConfig("act_id")] and slot8.time and #slot8.time == 3 and slot1:parseTimeFromConfig(slot8.time[2]) - slot1:GetServerTime() > 0 then
			slot2 = (slot2 == 0 and slot9) or math.min(slot2, slot9)
		end
	end

	return slot2
end

slot0.isClear = function (slot0)
	if slot0:getMapType() == slot0.SCENARIO then
		return slot0:isAllChaptersClear()
	elseif slot0:isActivity() then
		return slot0:isClearForActivity()
	else
		return true
	end
end

slot0.isClearForActivity = function (slot0)
	for slot5, slot6 in ipairs(slot1) do
		if slot5 > 1 and slot6.id - slot1[slot5 - 1].id > 1 then
			break
		elseif not slot6:isClear() then
			return false
		end
	end

	return true
end

slot0.isEliteEnabled = function (slot0)
	slot1 = nil

	return (slot0:getMapType() ~= slot0.ELITE or getProxy(ChapterProxy):getMapById(slot0:getBindMapId())) and slot0:isAllChaptersClear() and (slot0.getMapType() ~= slot0.ELITE or getProxy(ChapterProxy).getMapById(slot0.getBindMapId())) and slot0:isAllChaptersAchieve()
end

slot0.isAnyChapterUnlocked = function (slot0, slot1, slot2)
	slot3 = false

	for slot7, slot8 in ipairs(slot0:getChapters(true)) do
		if (not slot2 or slot8:getPlayType() ~= ChapterConst.TypeMainSub) and slot8:isUnlock() then
			if not slot1 or slot8:inActTime() then
				return true
			else
				slot3 = true
			end
		end
	end

	return false, slot3
end

slot0.isAnyChapterClear = function (slot0, slot1)
	return underscore.any(slot0:getChapters(true), function (slot0)
		return (not slot0 or slot0:getPlayType() ~= ChapterConst.TypeMainSub) and slot0:isClear()
	end)
end

slot0.isAllChaptersClear = function (slot0)
	for slot4, slot5 in ipairs(slot0:getChapters(true)) do
		if not slot5:isClear() then
			return false
		end
	end

	return true
end

slot0.isAllChaptersAchieve = function (slot0)
	for slot4, slot5 in ipairs(slot0:getChapters(true)) do
		if not slot5:isAllAchieve() then
			return false
		end
	end

	return true
end

slot0.getLastUnlockChapterName = function (slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0:getChapters(true)) do
		if slot6:getPlayType() == ChapterConst.TypeMainSub or not slot6:isUnlock() then
			break
		end

		slot1 = slot6
	end

	return slot1:getConfig("chapter_name")
end

slot0.isActivity = function (slot0)
	if slot0:getMapType() == Map.EVENT then
		return true, false
	elseif slot1 == Map.ACTIVITY_EASY or slot1 == Map.ACTIVITY_HARD or slot1 == Map.ACT_EXTRA then
		return true, true
	else
		return false
	end
end

slot0.isHardMap = function (slot0)
	return slot0:getMapType() == Map.ELITE or slot1 == Map.ACTIVITY_HARD
end

slot0.isActExtra = function (slot0)
	return slot0:getMapType() == Map.ACT_EXTRA
end

slot0.isEscort = function (slot0)
	return slot0:getMapType() == Map.ESCORT
end

slot0.isSkirmish = function (slot0)
	return slot0:getMapType() == Map.SKIRMISH
end

slot0.isNormalMap = function (slot0)
	return table.contains(Map.NORMAL_MAP, slot0:getMapType())
end

slot0.NeedRecordMap = function (slot0)
	return slot0:getMapType() == slot0.INVALID or slot1 == slot0.SCENARIO or slot1 == slot0.ELITE
end

return slot0

slot0 = class("ChapterProxy", import(".NetProxy"))
slot0.CHAPTER_UPDATED = "ChapterProxy:CHAPTER_UPDATED"
slot0.CHAPTER_TIMESUP = "ChapterProxy:CHAPTER_TIMESUP"
slot0.CHAPTER_CELL_UPDATED = "ChapterProxy:CHAPTER_CELL_UPDATED"
slot0.CHAPTER_EXTAR_FLAG_UPDATED = "ChapterProxy:CHAPTER_EXTAR_FLAG_UPDATED"
slot0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED = "CHAPTERPROXY:CHAPTER_AUTO_FIGHT_FLAG_UPDATED"
slot0.CHAPTER_SKIP_PRECOMBAT_UPDATED = "CHAPTERPROXY:CHAPTER_SKIP_PRECOMBAT_UPDATED"
slot0.LAST_MAP_FOR_ACTIVITY = "last_map_for_activity"
slot0.LAST_MAP = "last_map"

slot0.register = function (slot0)
	slot0:on(13001, function (slot0)
		slot0.mapEliteFleetCache = {}
		slot0.mapEliteCommanderCache = {}
		slot1 = {}

		for slot5, slot6 in ipairs(slot0.fleet_list) do
			slot1[slot6.map_id] = slot1[slot6.map_id] or {}

			table.insert(slot1[slot6.map_id], slot6)
		end

		for slot5, slot6 in pairs(slot1) do
			slot0.mapEliteFleetCache[slot5], slot0.mapEliteCommanderCache[slot5] = Chapter.BuildEliteFleetList(slot6)
		end

		for slot5, slot6 in ipairs(slot0.chapter_list) do
			if not pg.chapter_template[slot6.id] then
				errorMsg("chapter_template not exist: " .. slot6.id)
			else
				slot7 = Chapter.New(slot6)

				slot7:setEliteFleetList(Clone(slot0.mapEliteFleetCache[slot7:getConfig("formation")]) or {
					{},
					{},
					{}
				})
				slot7:setEliteCommanders(Clone(slot0.mapEliteCommanderCache[slot8]) or {
					{},
					{},
					{}
				})
				slot0:updateChapter(slot7)
			end
		end

		if slot0.current_chapter and slot0.current_chapter.id > 0 then
			slot3 = slot0:getChapterById(slot2, true)

			slot3:update(slot0.current_chapter)
			slot0:updateChapter(slot3)
		end

		slot0.repairTimes = slot0.daily_repair_count

		if slot0.react_chapter then
			slot0.remasterTickets = slot0.react_chapter.count
			slot0.remasterDailyCount = slot0.react_chapter.daily_count
			slot0.remasterTip = slot0.remasterDailyCount <= 0
		end

		Map.lastMap = slot0:getLastMap(slot1.LAST_MAP)
		Map.lastMapForActivity = slot0:getLastMap(slot1.LAST_MAP_FOR_ACTIVITY)

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")
	end)
	slot0.on(slot0, 13105, function (slot0)
		if slot0:getActiveChapter() then
			slot2 = 0

			function slot3()
				if not getProxy(ContextProxy) then
					return
				end

				if slot0:getCurrentContext().mediator == LevelMediator2 then
					slot0 = bit.bor(slot0, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)

					slot1:SetChapterAutoFlag(slot2.id, false)

					return
				end

				if not slot0:getContextByMediator(LevelMediator2) then
					return
				end

				slot2.data.StopAutoFightFlag = true
			end

			if _.any(slot0.ai_list, function (slot0)
				return slot0.item_type == ChapterConst.AttachOni
			end) then
				slot1.onOniEnter(slot1)
				slot3()
			end

			if _.any(slot0.map_update, function (slot0)
				return slot0.item_type == ChapterConst.AttachBomb_Enemy
			end) then
				slot1.onBombEnemyEnter(slot1)
				slot3()
			end

			if #slot0.map_update > 0 then
				_.each(slot0.map_update, function (slot0)
					if slot0.item_type == ChapterConst.AttachStory and slot0.item_data == ChapterConst.StoryTrigger then
						if slot0.cellAttachments[ChapterCell.Line2Name(slot0.pos.row, slot0.pos.column)] then
							if slot2.flag == ChapterConst.CellFlagTriggerActive and slot0.item_flag == ChapterConst.CellFlagTriggerDisabled and pg.map_event_template[slot2.attachmentId].gametip ~= "" then
								pg.TipsMgr.GetInstance():ShowTips(i18n(slot3))
							end

							slot2.attachment = slot0.item_type
							slot2.attachmentId = slot0.item_id
							slot2.flag = slot0.item_flag
							slot2.data = slot0.item_data
						else
							slot0.cellAttachments[slot1] = ChapterCell.New(slot0)
						end
					elseif slot0.item_type ~= ChapterConst.AttachNone and slot0.item_type ~= ChapterConst.AttachBorn and slot0.item_type ~= ChapterConst.AttachBorn_Sub and slot0.item_type ~= ChapterConst.AttachOni_Target and slot0.item_type ~= ChapterConst.AttachOni then
						slot0:mergeChapterCell(ChapterCell.New(slot0))
					end
				end)

				slot2 = bit.bor(slot2, ChapterConst.DirtyAttachment, ChapterConst.DirtyAutoAction)
			end

			if #slot0.ai_list > 0 then
				_.each(slot0.ai_list, function (slot0)
					slot0:mergeChampion(ChapterChampionPackage.New(slot0))
				end)

				slot2 = bit.bor(slot2, ChapterConst.DirtyChampion, ChapterConst.DirtyAutoAction)
			end

			if #slot0.add_flag_list > 0 or #slot0.del_flag_list > 0 then
				slot2 = bit.bor(slot2, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems)

				slot0:updateExtraFlag(slot1, slot0.add_flag_list, slot0.del_flag_list)
			end

			if #slot0.buff_list > 0 then
				slot2 = bit.bor(slot2, ChapterConst.DirtyStrategyComboPanel)

				slot1:UpdateBuffList(slot0.buff_list)
			end

			slot0:updateChapter(slot1, slot2)
		end
	end)

	slot0.timers = {}
	slot0.escortChallengeTimes = 0
	slot0.subNextReqTime = 0
	slot0.subRefreshCount = 0
	slot0.subProgress = 1
	slot0.defeatedEnemiesBuffer = {}
	slot0.comboHistoryBuffer = {}
	slot0.justClearChapters = {}
	slot0.chaptersExtend = {}

	slot0.buildMaps(slot0)
end

slot0.buildMaps = function (slot0)
	slot0:initChapters()
	slot0:buildBaseMaps()
	slot0:buildRemasterMaps()
end

slot0.initChapters = function (slot0)
	slot0.MapToChapters = {}
	slot0.FormationToChapters = {}

	for slot4, slot5 in ipairs(pg.chapter_template.all) do
		slot0.MapToChapters[pg.chapter_template[slot5].map] = slot0.MapToChapters[pg.chapter_template[slot5].map] or {}

		table.insert(slot0.MapToChapters[slot6.map], slot5)

		if slot6.type == Chapter.CustomFleet then
			slot0.FormationToChapters[slot6.formation] = slot0.FormationToChapters[slot6.formation] or {}

			table.insert(slot0.FormationToChapters[slot6.formation], slot5)
		end
	end
end

slot0.buildBaseMaps = function (slot0)
	slot0.ActToMaps = {}
	slot0.TypeToMaps = {}
	slot1 = {}

	for slot5, slot6 in ipairs(pg.expedition_data_by_map.all) do
		slot7 = Map.New({
			id = slot6,
			chapterIds = slot0.MapToChapters[slot6]
		})
		slot1[slot6] = slot7

		if slot7:getConfig("on_activity") ~= 0 then
			slot0.ActToMaps[slot8] = slot0.ActToMaps[slot8] or {}

			table.insert(slot0.ActToMaps[slot8], slot7.id)
		end

		slot0.TypeToMaps[slot9] = slot0.TypeToMaps[slot7:getMapType()] or {}

		table.insert(slot0.TypeToMaps[slot9], slot7.id)
	end

	slot0.baseMaps = slot1
end

slot0.buildRemasterMaps = function (slot0)
	slot0.RemasterToMaps = {}
	slot1 = {}

	_.each(pg.re_map_template.all, function (slot0)
		_.each(pg.re_map_template[slot0].config_data, function (slot0)
			if not slot1[slot0.baseMaps[pg.chapter_template[slot0].map].id] then
				slot1[slot1.id] = slot1

				slot1:setRemaster(slot1.setRemaster)

				slot2[slot3] = slot3.RemasterToMaps[slot3.RemasterToMaps] or {}

				table.insert(slot3.RemasterToMaps[slot2], slot1.id)
			end
		end)
	end)
end

slot0.IsChapterInRemaster = function (slot0, slot1)
	return _.detect(pg.re_map_template.all, function (slot0)
		return _.any(pg.re_map_template[slot0].config_data, function (slot0)
			return slot0 == slot0
		end)
	end)
end

slot0.getMaxEscortChallengeTimes = function (slot0)
	return getProxy(ActivityProxy):getActivityParameter("escort_daily_count") or 0
end

slot0.getEscortChapterIds = function (slot0)
	return getProxy(ActivityProxy):getActivityParameter("escort_exp_id") or {}
end

slot0.resetEscortChallengeTimes = function (slot0)
	slot0.escortChallengeTimes = 0
end

slot0.addChapterListener = function (slot0, slot1)
	if not slot1.dueTime or not slot0.timers then
		return
	end

	if slot0.timers[slot1.id] then
		slot0.timers[slot1.id]:Stop()

		slot0.timers[slot1.id] = nil
	end

	function slot3()
		slot0.data[slot1.id].dueTime = nil

		slot0.data[slot1.id].data[nil.id]:display("times'up")
		slot0.data[slot1.id].data[nil.id].display:sendNotification("times'up".CHAPTER_UPDATED, {
			dirty = 0,
			chapter = slot0.data[slot1.id]:clone()
		})
		slot0.data[slot1.id].data[nil.id].display.sendNotification:sendNotification("times'up".CHAPTER_UPDATED.CHAPTER_TIMESUP)
	end

	if slot1.dueTime - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
		slot0.timers[slot1.id] = Timer.New(function ()
			slot0()
			slot1.timers[slot2.id]:Stop()

			slot1.timers[slot2.id] = nil
		end, slot2, 1)

		slot0.timers[slot1.id]:Start()
	else
		slot3()
	end
end

slot0.removeChapterListener = function (slot0, slot1)
	if slot0.timers[slot1] then
		slot0.timers[slot1]:Stop()

		slot0.timers[slot1] = nil
	end
end

slot0.remove = function (slot0)
	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Stop()
	end

	slot0.timers = nil
end

slot0.GetRawChapterById = function (slot0, slot1)
	return slot0.data[slot1]
end

slot0.getChapterById = function (slot0, slot1, slot2)
	if not slot0.data[slot1] then
		if Chapter.New({
			id = slot1
		}).getConfig(slot3, "type") == Chapter.CustomFleet then
			slot3:setEliteFleetList(Clone(slot0.mapEliteFleetCache[slot3:getConfig("formation")]) or {
				{},
				{},
				{}
			})
			slot3:setEliteCommanders(Clone(slot0.mapEliteCommanderCache[slot4]) or {
				{},
				{},
				{}
			})
		end

		slot0.data[slot1] = slot3
	end

	return (slot2 and slot3) or slot3:clone()
end

slot0.updateChapter = function (slot0, slot1, slot2)
	slot0.data[slot1.id] = slot1:clone()

	if slot0.data[slot1.id] then
		slot0:removeChapterListener(slot3.id)
	end

	slot0:addChapterListener(slot4)
	slot0.facade:sendNotification(slot0.CHAPTER_UPDATED, {
		chapter = slot4,
		dirty = defaultValue(slot2, 0)
	})

	if slot4.fleet then
		slot4.fleet:clearShipHpChange()
	end

	if tobool(checkExist(slot3, {
		"active"
	})) ~= tobool(slot4.active) then
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChapter")
	end
end

slot0.getMapById = function (slot0, slot1)
	return slot0.baseMaps[slot1]
end

slot0.getNormalMaps = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.baseMaps) do
		table.insert(slot1, slot6)
	end

	return slot1
end

slot0.getMapsByType = function (slot0, slot1)
	slot2 = {}

	if slot0.TypeToMaps[slot1] then
		return _.map(slot0.TypeToMaps[slot1], function (slot0)
			return slot0:getMapById(slot0)
		end)
	else
		return {}
	end

	return slot2
end

slot0.getMapsByActId = function (slot0, slot1)
	if slot0.ActToMaps[slot1] then
		return underscore.map(slot0.ActToMaps[slot1], function (slot0)
			return slot0:getMapById(slot0)
		end)
	else
		return {}
	end
end

slot0.getRemasterMaps = function (slot0, slot1)
	if slot0.RemasterToMaps[slot1] then
		return underscore.map(slot0.RemasterToMaps[slot1], function (slot0)
			return slot0:getMapById(slot0)
		end)
	else
		return {}
	end
end

slot0.getMapsByActivities = function (slot0)
	underscore.each(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT), function (slot0)
		if not slot0:isEnd() then
			slot0 = table.mergeArray(slot0, slot1:getMapsByActId(slot0.id))
		end
	end)

	return {}
end

slot0.getLastUnlockMap = function (slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0:getNormalMaps()) do
		if not slot6:isUnlock() then
			break
		end

		slot1 = slot6
	end

	return slot1
end

slot0.updateExtraFlag = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot1:updateExtraFlags(slot2, slot3)

	if not slot4 and not slot5 then
		return
	end

	slot6 = {}

	for slot10, slot11 in ipairs(slot2) do
		table.insert(slot6, slot11)
	end

	slot0.chaptersExtend[slot1.id] = slot0.chaptersExtend[slot1.id] or {}
	slot0.chaptersExtend[slot1.id].extraFlagUpdate = slot6

	slot0.facade:sendNotification(slot0.CHAPTER_EXTAR_FLAG_UPDATED, slot6)

	return true
end

slot0.extraFlagUpdated = function (slot0, slot1)
	slot0:removeExtendChapterData(slot1, "extraFlagUpdate")
end

slot0.removeExtendChapterData = function (slot0, slot1, slot2)
	if not slot0.chaptersExtend[slot1] then
		return
	end

	slot0.chaptersExtend[slot1][slot2] = nil

	if next(slot0.chaptersExtend[slot1]) then
		return
	end

	slot0.chaptersExtend[slot1] = nil
end

slot0.getUpdatedExtraFlags = function (slot0, slot1)
	return slot0.chaptersExtend[slot1] and slot0.chaptersExtend[slot1].extraFlagUpdate
end

slot0.SetExtendChapterData = function (slot0, slot1, slot2, slot3)
	slot0.chaptersExtend[slot1] = slot0.chaptersExtend[slot1] or {}
	slot0.chaptersExtend[slot1][slot2] = slot3
end

slot0.AddExtendChapterDataArray = function (slot0, slot1, slot2, slot3, slot4)
	slot0.chaptersExtend[slot1] = slot0.chaptersExtend[slot1] or {}

	if type(slot0.chaptersExtend[slot1][slot2]) ~= "table" then
		slot0.chaptersExtend[slot1][slot2] = {}
	end

	slot0.chaptersExtend[slot1][slot2][slot4 or #slot0.chaptersExtend[slot1][slot2] + 1] = slot3
end

slot0.AddExtendChapterDataTable = function (slot0, slot1, slot2, slot3, slot4)
	slot0.chaptersExtend[slot1] = slot0.chaptersExtend[slot1] or {}

	if type(slot0.chaptersExtend[slot1][slot2]) ~= "table" then
		slot0.chaptersExtend[slot1][slot2] = {}
	end

	slot0.chaptersExtend[slot1][slot2][slot3] = slot4
end

slot0.GetExtendChapterData = function (slot0, slot1, slot2)
	if not slot2 or not slot0.chaptersExtend[slot1] then
		return
	end

	return slot0.chaptersExtend[slot1][slot2]
end

slot0.RemoveExtendChapterData = function (slot0, slot1, slot2)
	if not slot2 or not slot0.chaptersExtend[slot1] then
		return
	end

	slot0.chaptersExtend[slot1][slot2] = nil

	if next(slot0.chaptersExtend[slot1]) then
		return
	end

	slot0:RemoveExtendChapter(slot1)
end

slot0.GetExtendChapter = function (slot0, slot1)
	return slot0.chaptersExtend[slot1]
end

slot0.RemoveExtendChapter = function (slot0, slot1)
	if not slot0.chaptersExtend[slot1] then
		return
	end

	slot0.chaptersExtend[slot1] = nil
end

slot0.duplicateEliteFleet = function (slot0, slot1)
	if slot1:getConfig("type") == Chapter.CustomFleet then
		slot4 = slot1:getConfig("formation")
		slot0.mapEliteFleetCache[slot4] = Clone(slot2)
		slot0.mapEliteCommanderCache[slot4] = Clone(slot3)

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inElite")

		for slot8, slot9 in ipairs(slot0.FormationToChapters[slot4]) do
			if slot0:getChapterById(slot9, true).configId ~= slot1.configId then
				slot10:setEliteFleetList(Clone(slot2))
				slot10:setEliteCommanders(Clone(slot3))
				slot0:updateChapter(slot10)
			end
		end
	end
end

slot0.getActiveChapter = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.data) do
		if slot6.active then
			return (slot1 and slot6) or slot6:clone()
		end
	end
end

slot0.getLastMapForActivity = function (slot0)
	slot1, slot2 = nil

	if slot0:getActiveChapter() and slot0:getMapById(slot2:getConfig("map")):isActivity() and not slot1:isRemaster() then
		return slot1.id, slot2.id
	end

	if Map.lastMapForActivity and slot0:getMapById(Map.lastMapForActivity) and not slot1:isRemaster() and slot1:isUnlock() then
		return Map.lastMapForActivity
	end

	if Map.lastMapForActivity then
		Map.lastMapForActivity = nil

		slot0:recordLastMap(slot0.LAST_MAP_FOR_ACTIVITY, 0)
	end

	table.sort(slot3, function (slot0, slot1)
		return slot1.id < slot0.id
	end)

	slot4 = {}

	if _.all(slot3, function (slot0)
		return slot0:getConfig("type") == Map.EVENT
	end) then
		slot4 = slot3
	else
		for slot8, slot9 in ipairs({
			Map.ACTIVITY_EASY,
			Map.ACTIVITY_HARD
		}) do
			if #underscore.filter(slot3, function (slot0)
				return slot0:getMapType() == slot0
			end) > 0 and underscore.any(slot10, function (slot0)
				return not slot0:isClearForActivity()
			end) then
				break
			end
		end
	end

	for slot8 = #slot4, 1, -1 do
		if slot4[slot8].isUnlock(slot9) then
			return slot9.id
		end
	end

	if #slot3 > 0 then
		return slot3[1].id
	end
end

slot0.inWarTime = function (slot0)
	if slot0:getActiveChapter() then
		return slot1:inWartime()
	end
end

slot0.isInVaildFleet = function (slot0)
	return not slot0:getActiveChapter() or not slot1.fleet:isValid()
end

slot0.checkNextFleet = function (slot0)
	return not slot0:getActiveChapter() or slot1.fleet:isValid() or slot1:getNextValidIndex() <= 0
end

slot0.inChapterLine = function (slot0, slot1)
	if slot0:getActiveChapter() and slot2.fleet.line.row == slot1.row and slot2.fleet.line.column == slot1.column then
		if slot1.attachment and slot1.flag then
			return slot0:getChapterCell(slot1)
		end

		return true
	end
end

slot0.getChapterCell = function (slot0, slot1)
	if slot0:getActiveChapter() then
		return slot2:getChapterCell(slot1.row, slot1.column).attachment == slot1.attachment and slot3.flag == slot1.flag
	end
end

slot0.updateActiveChapterShips = function (slot0)
	if slot0:getActiveChapter(true) then
		_.each(slot1.fleets, function (slot0)
			slot0:flushShips()
		end)
		slot0.updateChapter(slot0, slot1, ChapterConst.DirtyFleet)
	end
end

slot0.resetRepairTimes = function (slot0)
	slot0.repairTimes = 0
end

slot0.getUseableEliteMap = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0:getMapsByType(Map.ELITE)) do
		if slot6:isEliteEnabled() then
			slot1[#slot1 + 1] = slot6
		end
	end

	return slot1
end

slot0.getUseableMaxEliteMap = function (slot0)
	if #slot0:getUseableEliteMap() == 0 then
		return false
	else
		slot2 = nil

		for slot6, slot7 in ipairs(slot1) do
			if not slot2 or slot2.id < slot7.id then
				slot2 = slot7
			end
		end

		return slot2
	end
end

slot0.getHigestClearChapterAndMap = function (slot0)
	slot1 = slot0.baseMaps[1]

	for slot5, slot6 in ipairs(slot0:getNormalMaps()) do
		if not slot6:isAnyChapterClear(true) then
			break
		end

		slot1 = slot6
	end

	slot2 = slot0:getChapterById(slot1.chapterIds[1])

	for slot6, slot7 in ipairs(slot1:getChapters()) do
		if not slot7:isClear() then
			break
		end

		slot2 = slot7
	end

	return slot2, slot1
end

slot0.eliteFleetRecommend = function (slot0, slot1, slot2)
	slot3 = getProxy(BayProxy)
	slot4 = slot1:getEliteFleetList()[slot2]

	slot6((slot1:getConfig("limitation")[slot2] and Clone(slot5[1])) or {
		0,
		0,
		0
	})
	function (slot0)
		table.sort(slot0, function (slot0, slot1)
			if type(slot0) == type(slot1) then
				return slot3 < slot2
			elseif slot2 == "string" then
				return slot1 == 0
			else
				return slot0 ~= 0
			end
		end)
	end((slot5 and Clone(slot5[2])) or {
		0,
		0,
		0
	})
	function (slot0)
		table.sort(slot0, function (slot0, slot1)
			if type(slot0) == type(slot1) then
				return slot3 < slot2
			elseif slot2 == "string" then
				return slot1 == 0
			else
				return slot0 ~= 0
			end
		end)
	end(slot9)

	slot10 = {}

	for slot14, slot15 in ipairs(slot1:getEliteFleetList()) do
		for slot19, slot20 in ipairs(slot15) do
			slot10[#slot10 + 1] = slot20
		end
	end

	slot11 = {
		[TeamType.Main] = slot7,
		[TeamType.Vanguard] = slot8,
		[TeamType.Submarine] = slot9
	}

	function slot12(slot0, slot1)
		if type(slot1) == "string" then
			return table.contains(ShipType.BundleList[slot1], slot0)
		elseif type(slot1) == "number" then
			return slot1 == 0 or slot0 == slot1
		end
	end

	slot13 = getProxy(BayProxy).getRawData(slot13)

	for slot17, slot18 in ipairs(slot4) do
		slot22 = 0

		for slot27, slot28 in ipairs(slot23) do
			if slot12(slot20, slot28) then
				slot22 = slot28

				break
			end
		end

		for slot27, slot28 in ipairs(slot23) do
			if slot28 == slot22 then
				table.remove(slot23, slot27)

				break
			end
		end
	end

	function slot14(slot0)
		if slot0:getEliteRecommendShip(slot0, slot0.getEliteRecommendShip, slot2:getConfig("formation")) then
			slot1[#slot1 + 1] = slot1.id
			slot1[#slot3 + 1] = slot1.id
		end
	end

	if slot2 >= 1 and slot2 <= 2 then
		for slot18, slot19 in ipairs(slot7) do
			slot20 = nil

			if type(slot19) == "string" then
				slot20 = Clone(ShipType.BundleList[slot19])
			elseif type(slot19) == "number" then
				slot14((slot19 ~= 0 or TeamType.MainShipType) and {
					slot19
				})
			end
		end

		for slot18, slot19 in ipairs(slot8) do
			slot20 = nil

			if type(slot19) == "string" then
				slot20 = Clone(ShipType.BundleList[slot19])
			elseif type(slot19) == "number" then
				slot14((slot19 ~= 0 or TeamType.VanguardShipType) and {
					slot19
				})
			end
		end
	else
		for slot18, slot19 in ipairs(slot9) do
			slot20 = nil

			if type(slot19) == "string" then
				slot20 = Clone(ShipType.BundleList[slot19])
			elseif type(slot19) == "number" then
				slot14((slot19 ~= 0 or TeamType.SubShipType) and {
					slot19
				})
			end
		end
	end
end

slot0.isClear = function (slot0, slot1)
	return slot0:getChapterById(slot1):isClear()
end

slot0.getEscortShop = function (slot0)
	return Clone(slot0.escortShop)
end

slot0.updateEscortShop = function (slot0, slot1)
	slot0.escortShop = slot1
end

slot0.recordLastMap = function (slot0, slot1, slot2)
	slot3 = false

	if slot1 == slot0.LAST_MAP_FOR_ACTIVITY then
		Map.lastMapForActivity = slot2
		slot3 = true
	elseif slot1 == slot0.LAST_MAP and slot2 ~= Map.lastMap then
		Map.lastMap = slot2
		slot3 = true
	end

	if slot3 then
		PlayerPrefs.SetInt(slot1 .. getProxy(PlayerProxy):getRawData().id, slot2)
		PlayerPrefs.Save()
	end
end

slot0.getLastMap = function (slot0, slot1)
	if PlayerPrefs.GetInt(slot1 .. getProxy(PlayerProxy):getRawData().id) ~= 0 then
		return slot3
	end
end

slot0.getSubAidFlag = function (slot0)
	slot1 = ys.Battle.BattleConst.SubAidFlag
	slot2 = slot0.fleet
	slot3 = false

	if _.detect(slot0.fleets, function (slot0)
		return slot0:getFleetType() == FleetType.Submarine and slot0:isValid()
	end) then
		if slot4.inHuntingRange(slot4, slot2.line.row, slot2.line.column) then
			slot3 = true
		elseif _.detect(slot4:getStrategies(), function (slot0)
			return slot0.id == ChapterConst.StrategyCallSubOutofRange
		end) and slot6.count > 0 then
			slot3 = true
		end
	end

	if slot3 then
		slot6 = getProxy(PlayerProxy).getRawData(slot5)
		slot7, slot8 = slot0:getFleetCost(slot2)
		slot9, slot10 = slot0:getFleetAmmo(slot4)
		slot11 = slot4:getSummonCost() * slot0:GetExtraCostRate()

		if slot10 <= 0 then
			return slot1.AMMO_EMPTY
		elseif slot6.oil < slot11 + slot8.oil then
			return slot1.OIL_EMPTY
		else
			return true, slot4
		end
	else
		return slot1.AID_EMPTY
	end
end

slot0.GetChapterAuraBuffs = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.fleets) do
		for slot11, slot12 in ipairs(slot7) do
			table.insert(slot1, slot12)
		end
	end

	return slot1
end

slot0.GetChapterAidBuffs = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.fleets) do
		if slot6 ~= slot0.fleet then
			for slot11, slot12 in pairs(slot7) do
				slot1[slot11] = slot12
			end
		end
	end

	return slot1
end

slot0.RecordComboHistory = function (slot0, slot1, slot2)
	if not slot1 or slot1 <= 0 then
		return
	end

	slot0.comboHistoryBuffer[slot1] = slot2
end

slot0.GetComboHistory = function (slot0, slot1)
	return slot0.comboHistoryBuffer[slot1]
end

slot0.RecordJustClearChapters = function (slot0, slot1, slot2)
	if not slot1 or slot1 <= 0 then
		return
	end

	slot0.justClearChapters[slot1] = slot2
end

slot0.GetJustClearChapters = function (slot0, slot1)
	return slot0.justClearChapters[slot1]
end

slot0.RecordLastDefeatedEnemy = function (slot0, slot1, slot2)
	if not slot1 or slot1 <= 0 then
		return
	end

	slot0.defeatedEnemiesBuffer[slot1] = slot2
end

slot0.GetLastDefeatedEnemy = function (slot0, slot1)
	return slot0.defeatedEnemiesBuffer[slot1]
end

slot0.ifShowRemasterTip = function (slot0)
	return slot0.remasterTip
end

slot0.setRemasterTip = function (slot0, slot1)
	slot0.remasterTip = slot1
end

slot0.updateRemasterTicketsNum = function (slot0, slot1)
	slot0.remasterTickets = slot1
end

slot0.resetDailyCount = function (slot0)
	slot0.remasterDailyCount = 0
end

slot0.updateDailyCount = function (slot0)
	slot0.remasterDailyCount = slot0.remasterDailyCount + pg.gameset.reactivity_ticket_daily.key_value
end

slot0.GetSkipPrecombat = function (slot0)
	if slot0.skipPrecombat == nil then
		slot0.skipPrecombat = PlayerPrefs.GetInt("chapter_skip_precombat", 0)
	end

	return (slot0.skipPrecombat > 0 and true) or false
end

slot0.UpdateSkipPrecombat = function (slot0, slot1)
	if ((tobool(slot1) and 1) or 0) ~= slot0:GetSkipPrecombat() then
		PlayerPrefs.SetInt("chapter_skip_precombat", slot1)

		slot0.skipPrecombat = slot1

		slot0:sendNotification(slot0.CHAPTER_SKIP_PRECOMBAT_UPDATED, slot1)
	end
end

slot0.GetChapterAutoFlag = function (slot0, slot1)
	return slot0:GetExtendChapterData(slot1, "AutoFightFlag")
end

slot0.SetChapterAutoFlag = function (slot0, slot1, slot2)
	if tobool(slot2) == slot0:GetChapterAutoFlag(slot1) == 1 then
		return
	end

	slot0:SetExtendChapterData(slot1, "AutoFightFlag", (slot2 and 1) or 0)

	if slot2 then
		slot0:UpdateSkipPrecombat(true)

		if AutoBotCommand.autoBotSatisfied() then
			PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(), 1)
		end

		getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(true)

		if not LOCK_BATTERY_SAVEMODE and PlayerPrefs.GetInt(AUTOFIGHT_BATTERY_SAVEMODE, 0) == 1 then
			pg.BrightnessMgr.GetInstance():EnterManualMode()

			if PlayerPrefs.GetInt(AUTOFIGHT_DOWN_FRAME, 0) == 1 then
				getProxy(SettingsProxy):RecordFrameRate()

				Application.targetFrameRate = 30
			end
		end
	else
		pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)

		if not LOCK_BATTERY_SAVEMODE then
			pg.BrightnessMgr.GetInstance():ExitManualMode()
			getProxy(SettingsProxy):RestoreFrameRate()
		end
	end

	slot0.facade:sendNotification(slot0.CHAPTER_AUTO_FIGHT_FLAG_UPDATED, (slot2 and 1) or 0)
end

slot0.StopAutoFight = function (slot0)
	if not slot0:getActiveChapter(true) then
		return
	end

	slot0:SetChapterAutoFlag(slot1.id, false)
end

return slot0

slot0 = class("MapBuilderShinano", import(".MapBuilderNormal"))
slot1 = import(".MapBuilder")

slot0.GetType = function (slot0)
	return slot0.TYPESHINANO
end

slot0.getUIName = function (slot0)
	return "Shinano_levels"
end

slot0.Load = function (slot0)
	slot0:Load()
end

slot0.Destroy = function (slot0)
	slot0:Destroy()
end

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot1 = slot0._tf:Find("preloadResources"):GetComponent(typeof(ItemList))
	slot2 = Instantiate(slot1.prefabItem[0])

	setAnchoredPosition(slot0._tf:Find("rumeng"), tf(slot2).anchoredPosition)
	setParent(slot2, slot0._tf:Find("rumeng"))
	setAnchoredPosition(slot2, Vector2.zero)
	slot0:InitTransformMapBtn(slot0._tf:Find("rumeng"), 1, slot1.prefabItem[1])

	slot3 = Instantiate(slot1.prefabItem[2])

	setAnchoredPosition(slot0._tf:Find("huigui"), tf(slot3).anchoredPosition)
	setParent(slot3, slot0._tf:Find("huigui"))
	setAnchoredPosition(slot3, Vector2.zero)
	slot0:InitTransformMapBtn(slot0._tf:Find("huigui"), -1, slot1.prefabItem[3])
end

slot0.OnShow = function (slot0)
	slot0.super.OnShow(slot0)
	setActive(slot0.sceneParent.topChapter:Find("type_skirmish"), true)
end

slot0.OnHide = function (slot0)
	setActive(slot0.sceneParent.topChapter:Find("type_skirmish"), false)
	slot0.super.OnHide(slot0)
end

slot0.InitTransformMapBtn = function (slot0, slot1, slot2, slot3)
	function slot4()
		if slot0.sceneParent.maps[slot0.sceneParent.contextData.mapIdx + ] then
			if slot2:getMapType() == Map.ELITE and not slot2:isEliteEnabled() then
				slot1 = slot0.maps[slot2:getBindMapId()].id

				pg.TipsMgr.GetInstance():ShowTips(i18n("elite_disable_unusable"))
			end

			if slot3 == Map.ACTIVITY_EASY or slot3 == Map.ACTIVITY_HARD then
				if slot0.maps[slot1 - 1] and not slot4:isClearForActivity() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_map_lock"))

					return
				elseif not slot2:isUnlock() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_lock_1"))

					return
				end
			end

			if not slot2:isUnlock() then
				slot4 = i18n("levelScene_map_lock")

				if slot0.maps[slot1 - 1] and slot5:isClear() then
					slot4 = i18n("levelScene_chapter_unlock_tip", slot2:getConfig("level_limit"))
				end

				pg.TipsMgr.GetInstance():ShowTips(slot4)

				return
			end

			return true
		end
	end

	onButton(slot0.sceneParent, slot1, function ()
		if slot0.sceneParent:isfrozen() then
			return
		end

		slot0 = nil

		seriesAsync({
			function (slot0)
				if not slot0() then
					return
				end

				pg.CriMgr.GetInstance():StopBGM(CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)

				slot1 = CueData.New()
				slot1.channelName = pg.CriMgr.C_SE
				slot1.cueSheetName = "se-ui"
				slot1.cueName = "ui-qiehuan"

				CriWareMgr.Inst:PlaySound(slot1, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)
				setParent(slot1, CriWareMgr.Inst.PlaySound._tf:Find(slot3.name .. "(Clone)") or Instantiate(slot3)._tf)
				setAnchoredPosition(slot1, rtf(rtf).anchoredPosition)

				if Map.bindConfigTable()[setAnchoredPosition.contextData.mapIdx + slot5] and #slot3.bg > 0 then
					GetSpriteFromAtlasAsync("levelmap/" .. slot3.bg, "", function (slot0)
						return
					end)
				end

				slot2.sceneParent.frozen(slot4)
				LeanTween.delayedCall(go(slot4), 2.3, System.Action(slot0))
			end,
			function (slot0)
				slot0.sceneParent:setMap(slot0.contextData.mapIdx + slot0.sceneParent.setMap)
				LeanTween.delayedCall(go(go), 0.5, System.Action(slot0))
			end,
			function (slot0)
				if not IsNil(slot0) then
					Destroy(slot0)
				end

				slot1.sceneParent:unfrozen()
			end
		})
	end)
end

slot0.PostUpdateMap = function (slot0, slot1)
	slot0.super.PostUpdateMap(slot0, slot1)
	setActive(slot4, false)
	setActive(slot0._tf:Find("huigui"), false)

	if not (slot0.contextData.map:getConfig("type") == Map.ACT_EXTRA) then
		setActive(slot0.sceneParent.btnPrev, false)
		setActive(slot0.sceneParent.btnNext, false)
		setActive(slot4, slot0.sceneParent.maps[slot1.id + 1])
		setActive(slot5, slot0.sceneParent.maps[slot1.id - 1])
		LeanTween.cancel(go(slot4), true)
		LeanTween.cancel(go(slot5), true)

		if slot0.sceneParent.maps[slot1.id + 1] then
			slot6 = tf(slot4).localScale
			slot9 = Clone(slot8)

			slot0.RecordTween(slot0, "rumengAlphaTween", LeanTween.value(go(slot4), 0, 1, 0.8):setOnUpdate(System.Action_float(function (slot0)
				slot0.a = slot1.a * slot0

				slot1.a * slot0:SetColor("_MainColor", slot0)
			end)).setEase(slot10, LeanTweenType.easeInCubic):setOnComplete(System.Action(function ()
				slot0:SetColor("_MainColor", slot0)
			end)).id)

			return
		end

		if slot0.sceneParent.maps[slot1.id - 1] then
			slot6 = tf(slot5).localScale
			slot9 = Clone(slot8)

			slot0.RecordTween(slot0, "huiguiAlphaTween", LeanTween.value(go(slot5), 0, 1, 0.8):setOnUpdate(System.Action_float(function (slot0)
				slot0.a = slot1.a * slot0

				slot1.a * slot0:SetColor("_MainColor", slot0)
			end)).setEase(slot10, LeanTweenType.easeInCubic):setOnComplete(System.Action(function ()
				slot0:SetColor("_MainColor", slot0)
			end)).id)
		end
	end
end

slot0.UpdateMapItems = function (slot0)
	if not slot0:isShowing() then
		return
	end

	slot0:UpdateMapItems()

	slot2 = getProxy(ChapterProxy)

	table.clear(slot0.chapterTFsById)

	slot3 = {}

	for slot7, slot8 in pairs(slot0.contextData.map.getChapters(slot1)) do
		if (slot8:activeAlways() or slot8:isUnlock()) and (not slot8:ifNeedHide() or slot2:GetJustClearChapters(slot8.id)) then
			table.insert(slot3, slot8)
		end
	end

	slot0:StopMapItemTimers()
	UIItemList.StaticAlign(slot0.itemHolder, slot0.tpl, #slot3, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1:UpdateMapItem(slot2, slot0[slot1 + 1])

			slot2.name = "Chapter_" .. slot0[slot1 + 1].id
			slot1.chapterTFsById[slot0[slot1 + 1].id] = slot2
		end
	end)

	slot4 = {}

	for slot8, slot9 in pairs(slot3) do
		slot4[slot9:getConfigTable().pos_x] = slot4[slot9.getConfigTable().pos_x] or {}
		slot9.getConfigTable().pos_x[slot10.pos_y] = slot4[slot10.pos_x][slot10.pos_y] or {}

		table.insert(slot9.getConfigTable().pos_x[slot10.pos_y], slot9)
	end

	for slot8, slot9 in pairs(slot4) do
		for slot13, slot14 in pairs(slot9) do
			slot15 = {}

			seriesAsync({
				function (slot0)
					slot1 = 0

					for slot5, slot6 in pairs(slot0) do
						if slot6:ifNeedHide() and slot1:GetJustClearChapters(slot6.id) and slot2.chapterTFsById[slot6.id] then
							slot1 = slot1 + 1

							setActive(slot7, true)
							slot2:PlayChapterItemAnimationBackward(slot7, slot6, function ()
								slot0 = slot0 - 1

								setActive(slot1, false)
								slot2:RecordJustClearChapters(slot3.id, nil)

								if slot2.RecordJustClearChapters <= 0 then
									slot4()
								end
							end)

							slot3[slot6.id] = true
						elseif slot2.chapterTFsById[slot6.id] then
							setActive(slot2.chapterTFsById[slot6.id], false)
						end
					end

					if slot1 <= 0 then
						slot0()
					end
				end,
				function (slot0)
					slot1 = 0

					for slot5, slot6 in pairs(slot0) do
						if not slot1[slot6.id] then
							slot1 = slot1 + 1

							setActive(slot2.chapterTFsById[slot6.id], true)
							slot2:PlayChapterItemAnimation(slot2.chapterTFsById[slot6.id], slot6, function ()
								if slot0 - 1 <= 0 then
									slot1()
								end
							end)
						end
					end
				end
			})
		end
	end
end

slot0.UpdateMapItem = function (slot0, slot1, slot2)
	slot3 = slot2:getConfigTable()

	setAnchoredPosition(slot1, {
		x = slot0.mapWidth * slot3.pos_x,
		y = slot0.mapHeight * slot3.pos_y
	})
	setActive(slot4, true)
	setActive(findTF(slot4, "info/bk/fordark"), slot3.icon_outline == 1)

	slot6 = findTF(slot4, "circle/clear_flag")
	slot7 = findTF(slot4, "circle/lock")

	setText(findTF(slot4, "info/bk/title_form/title_index"), setColorStr(slot3.chapter_name .. "  ", (not slot2.active and not slot2:isUnlock() and "#737373") or "#FFFFFF"))
	setText(findTF(slot4, "info/bk/title_form/title"), setColorStr(string.split(slot3.name, "|")[1], (not slot2.active and not slot2.isUnlock() and "#737373") or "#FFFFFF"))
	setText(findTF(slot4, "info/bk/title_form/title_en"), setColorStr(string.split(slot3.name, "|")[2] or "", (not slot2.active and not slot2.isUnlock() and "#737373") or "#FFFFFF"))
	setFillAmount(findTF(slot4, "circle/progress"), slot2.progress / 100)
	setText(findTF(slot4, "circle/progress_text"), string.format("%d%%", slot2.progress))
	setActive(findTF(slot4, "circle/stars"), slot2:existAchieve())

	if slot2:existAchieve() then
		for slot17, slot18 in ipairs(slot2.achieves) do
			setActive(slot11:Find("star" .. slot17 .. "/light"), ChapterConst.IsAchieved(slot18))
		end
	end

	setActive(slot6, not slot2.active and slot2:isClear())
	setActive(slot7, slot8)
	setActive(slot10, not (not slot2.active and slot2.isClear()) and not slot8)
	slot0:DeleteTween("fighting" .. slot2.id)
	setText(findTF(setActive, "Text"), i18n("tag_level_fighting"))
	setText(findTF(slot10, "Text"), i18n("tag_level_oni"))
	setText(findTF(not (not slot2.active and slot2.isClear()) and not slot8, "Text"), i18n("tag_level_narrative"))
	setActive(setActive, false)
	setActive(slot10, false)
	setActive(not (not slot2.active and slot2.isClear()) and not slot8, false)

	slot18, slot19 = nil

	if slot2:getConfig("chapter_tag") == 1 then
		slot18 = slot17
	end

	if (slot2:existOni() and slot16) or slot15 then
		setActive(slot18, true)

		GetOrAddComponent(slot18, "CanvasGroup").alpha = 1

		slot0:RecordTween("fighting" .. slot2.id, LeanTween.alphaCanvas(slot19, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	setActive(slot20, false)

	if slot2:isTriesLimit() then
		slot22 = slot2:getConfig("count")

		setText(slot20:Find("label"), i18n("levelScene_chapter_count_tip"))
		setText(slot20:Find("Text"), setColorStr(slot22 - slot2:getTodayDefeatCount() .. "/" .. slot22, (slot22 <= slot2:getTodayDefeatCount() and COLOR_RED) or COLOR_GREEN))
	end

	slot23 = 0

	for slot27, slot28 in ipairs(slot22) do
		slot23 = math.max(slot23, (pg.expedition_activity_template[slot28] and slot29.bonus_time) or 0)
	end

	if pg.chapter_defense[slot2.id] then
		slot23 = math.max(slot23, slot24.bonus_time or 0)
	end

	slot25 = findTF(slot4, "mark")

	setActive(slot25:Find("bonus"), not slot0.data:isRemaster() and slot23 > 0 and math.max(slot23 - slot2.todayDefeatCount, 0) > 0)
	setActive(slot25, not slot0.data.isRemaster() and slot23 > 0 and math.max(slot23 - slot2.todayDefeatCount, 0) > 0)

	if slot27 then
		slot0.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", (slot0.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard") or "bonus_us", slot25:Find("bonus"))

		slot31 = slot25.anchoredPosition.y
		slot25:GetComponent(typeof(CanvasGroup)).alpha = 0

		LeanTween.cancel(go(slot25))
		LeanTween.value(go(slot25), 0, 1, 0.2):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
			slot0.anchoredPosition.y = slot2 * slot0
			slot0.anchoredPosition.anchoredPosition = slot0.anchoredPosition
		end)).setEase(slot32, LeanTweenType.easeOutSine):setDelay(0.7)
	end

	slot28 = slot2.id

	onButton(slot0.sceneParent, slot4, function ()
		if slot0:InvokeParent("isfrozen") then
			return
		end

		if slot0.chaptersInBackAnimating[slot1] then
			return
		end

		if not getProxy(ChapterProxy):getChapterById(slot1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_tracking_error_pre", slot0:getPrevChapterName()))

			return
		end

		if not getProxy(ChapterProxy):getMapById(slot0:getConfig("map")):isRemaster() and not slot0:inActTime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("battle_levelScene_lock_1"))

			return
		end

		if slot0.sceneParent.player.level < slot0:getConfig("unlocklevel") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", slot2))

			return
		end

		slot3 = nil

		for slot7, slot8 in pairs(slot0.sceneParent.maps) do
			if slot8:getActiveChapter() then
				break
			end
		end

		if slot3 and slot3 ~= slot0 then
			slot0:InvokeParent("emit", LevelMediator2.ON_STRATEGYING_CHAPTER)

			return
		end

		if slot0.active then
			slot0:InvokeParent("switchToChapter", slot0)
		else
			slot0:InvokeParent("displayChapterPanel", slot0, Vector3(slot2.localPosition.x - 10, slot2.localPosition.y + 150))
		end
	end, SFX_UI_WEIGHANCHOR_SELECT)
end

slot0.TryOpenChapter = function (slot0, slot1)
	if slot0.chapterTFsById[slot1] then
		triggerButton(slot2:Find("main"))
	end
end

return slot0

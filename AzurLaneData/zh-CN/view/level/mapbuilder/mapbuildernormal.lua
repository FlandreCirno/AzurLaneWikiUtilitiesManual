slot1 = class("MapBuilderNormal", import(".MapBuilder"))

slot1.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)

	slot0.mapItemTimer = {}
	slot0.chapterTFsById = {}
	slot0.chaptersInBackAnimating = {}
end

slot1.GetType = function (slot0)
	return slot0.TYPENORMAL
end

slot1.getUIName = function (slot0)
	return "levels"
end

slot1.Load = function (slot0)
	if slot0._state ~= slot0.STATES.NONE then
		return
	end

	slot0._state = slot0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()
	slot0:Loaded(slot0.float:Find("levels").gameObject)
	slot0:Init()
end

slot1.Destroy = function (slot0)
	if slot0._state == slot0.STATES.DESTROY then
		return
	end

	if not slot0:GetLoaded() then
		slot0._state = slot0.STATES.DESTROY

		return
	end

	slot0:Hide()
	slot0:OnDestroy()
	pg.DelegateInfo.Dispose(slot0)

	slot0._go = nil

	slot0:disposeEvent()
	slot0:cleanManagedTween()

	slot0._state = slot0.STATES.DESTROY
end

slot1.OnInit = function (slot0)
	slot0.tpl = slot0._tf:Find("level_tpl")

	setActive(slot0.tpl, false)

	slot0.itemHolder = slot0._tf:Find("items")
end

slot1.OnShow = function (slot0)
	setActive(slot0.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(slot0.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(slot0.sceneParent.topChapter:Find("type_chapter"), true)
end

slot1.OnHide = function (slot0)
	setActive(slot0.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(slot0.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(slot0.sceneParent.topChapter:Find("type_chapter"), false)
	table.clear(slot0.chaptersInBackAnimating)
	slot0:StopMapItemTimers()

	for slot4, slot5 in pairs(slot0.chapterTFsById) do
		LeanTween.cancel(rtf(findTF(slot5, "main/info/bk")))
	end

	slot0.super.OnHide(slot0)
end

slot1.OnDestroy = function (slot0)
	slot0.mapItemTimer = nil

	slot0.super.OnDestroy(slot0)
end

slot1.StartTimer = function (slot0, slot1, slot2, slot3)
	if not slot0.mapItemTimer[slot1] then
		slot0.mapItemTimer[slot1] = Timer.New(slot2, slot3)
	else
		slot0.mapItemTimer[slot1]:Reset(slot2, slot3)
	end

	slot0.mapItemTimer[slot1]:Start()
end

slot1.StopMapItemTimers = function (slot0)
	for slot4, slot5 in pairs(slot0.mapItemTimer) do
		slot5:Stop()
	end

	table.clear(slot0.mapItemTimer)
end

slot1.Update = function (slot0, slot1)
	slot0.float.pivot = Vector2(0.5, 0.5)
	slot0.float.localPosition = Vector2(0, 0)

	setText(slot0.sceneParent.chapterName, string.split(slot1:getConfig("name"), "||")[1])
	slot0.sceneParent.loader:GetSprite("chapterno", "chapter" .. slot3, slot0.sceneParent.chapterNoTitle, true)
	slot0.super.Update(slot0, slot1)
end

slot1.UpdateButtons = function (slot0)
	slot0.sceneParent:updateDifficultyBtns()
	slot0.sceneParent:updateActivityBtns()
end

slot1.UpdateMapItems = function (slot0)
	slot0.super.UpdateMapItems(slot0)

	slot2 = getProxy(ChapterProxy)

	table.clear(slot0.chapterTFsById)

	slot3 = {}

	for slot7, slot8 in ipairs(slot0.data.getChapters(slot1)) do
		if (slot8:isUnlock() or slot8:activeAlways()) and slot8:isValid() and (not slot8:ifNeedHide() or slot2:GetJustClearChapters(slot8.id)) then
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
						if slot6:ifNeedHide() and slot1:GetJustClearChapters(slot6.id) then
							slot1 = slot1 + 1

							setActive(slot2.chapterTFsById[slot6.id], true)
							slot2:PlayChapterItemAnimationBackward(slot2.chapterTFsById[slot6.id], slot6, function ()
								slot0 = slot0 - 1

								setActive(slot1.chapterTFsById[slot2.id], false)
								slot3:RecordJustClearChapters(false.id, nil)

								if slot3.RecordJustClearChapters <= 0 then
									slot4()
								end
							end)

							slot3[slot6.id] = true
						else
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

slot1.UpdateMapItem = function (slot0, slot1, slot2)
	setAnchoredPosition(slot1, {
		x = slot0.mapWidth * slot2:getConfigTable().pos_x,
		y = slot0.mapHeight * slot2.getConfigTable().pos_y
	})

	slot4 = findTF(slot1, "main")
	slot5 = findTF(slot1, "sub")

	if slot2:getPlayType() == ChapterConst.TypeMainSub then
		setActive(slot4, false)
		setActive(slot5, true)

		slot6 = findTF(slot5, "mask/count_down")
		slot0.mapItemTimer[slot1] = Timer.New(slot7, 1, -1)

		slot0.mapItemTimer[slot1]:Start()
		slot7()
		slot0:DeleteTween("fighting" .. slot2.id)
		setText(findTF(slot8, "Text"), i18n("tag_level_fighting"))
		setText(findTF(slot9, "Text"), i18n("tag_level_oni"))
		setText(findTF(slot10, "Text"), i18n("tag_level_narrative"))
		setActive(slot8, false)
		setActive(slot9, false)
		setActive(slot10, false)

		slot11, slot12 = nil

		if slot2:getConfig("chapter_tag") == 1 then
			slot11 = slot10
		end

		if slot2.active then
			slot11 = slot8

			if slot2:existOni() then
				slot11 = slot9
			end
		end

		if slot11 then
			setActive(slot11, true)

			GetOrAddComponent(slot11, "CanvasGroup").alpha = 1

			slot0:RecordTween("fighting" .. slot2.id, LeanTween.alphaCanvas(slot12, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
		end
	else
		setActive(slot4, true)
		setActive(slot5, false)
		setActive(findTF(slot4, "circle/fordark"), slot3.icon_outline == 1)
		setActive(findTF(slot4, "info/bk/fordark"), slot3.icon_outline == 1)

		slot8 = findTF(slot4, "circle/clear_flag")

		setText(findTF(slot4, "info/bk/title_form/title_index"), slot3.chapter_name .. "  ")
		setText(findTF(slot4, "info/bk/title_form/title"), string.split(slot3.name, "|")[1])
		setText(findTF(slot4, "info/bk/title_form/title_en"), string.split(slot3.name, "|")[2] or "")
		setFillAmount(findTF(slot4, "circle/progress"), slot2.progress / 100)
		setText(findTF(slot4, "circle/progress_text"), string.format("%d%%", slot2.progress))
		setActive(findTF(slot4, "circle/stars"), slot2:existAchieve())

		if slot2:existAchieve() then
			for slot16, slot17 in ipairs(slot2.achieves) do
				setActive(slot11:Find("star" .. slot16 .. "/light"), ChapterConst.IsAchieved(slot17))
			end
		end

		setActive(slot8, not slot2.active and slot2:isClear())
		setActive(slot10, not (not slot2.active and slot2.isClear()))
		slot0:DeleteTween("fighting" .. slot2.id)
		setText(findTF(slot14, "Text"), i18n("tag_level_fighting"))
		setText(findTF(slot15, "Text"), i18n("tag_level_oni"))
		setText(findTF(slot16, "Text"), i18n("tag_level_narrative"))
		setActive(slot14, false)
		setActive(slot15, false)
		setActive(slot16, false)

		slot17, slot18 = nil

		if slot2:getConfig("chapter_tag") == 1 then
			slot17 = slot16
		end

		if (slot2:existOni() and slot15) or slot14 then
			setActive(slot17, true)

			GetOrAddComponent(slot17, "CanvasGroup").alpha = 1

			slot0:RecordTween("fighting" .. slot2.id, LeanTween.alphaCanvas(slot18, 0, 0.5):setFrom(1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
		end

		setActive(slot19, false)

		if slot2:isTriesLimit() then
			slot21 = slot2:getConfig("count")

			setText(slot19:Find("label"), i18n("levelScene_chapter_count_tip"))
			setText(slot19:Find("Text"), setColorStr(slot21 - slot2:getTodayDefeatCount() .. "/" .. slot21, (slot21 <= slot2:getTodayDefeatCount() and COLOR_RED) or COLOR_GREEN))
		end

		slot21 = slot2:GetDailyBonusQuota()
		slot22 = findTF(slot4, "mark")

		setActive(slot22:Find("bonus"), slot21)
		setActive(slot22, slot21)

		if slot21 then
			slot0.sceneParent.loader:GetSprite("ui/levelmainscene_atlas", (slot0.sceneParent.contextData.map:getConfig("type") == Map.ACTIVITY_HARD and "bonus_us_hard") or "bonus_us", slot22:Find("bonus"))
			LeanTween.cancel(go(slot22), true)

			slot26 = slot22.anchoredPosition.y
			slot22:GetComponent(typeof(CanvasGroup)).alpha = 0

			LeanTween.value(go(slot22), 0, 1, 0.2):setOnUpdate(System.Action_float(function (slot0)
				slot0.alpha = slot0
				slot0.anchoredPosition.y = slot2 * slot0
				slot0.anchoredPosition.anchoredPosition = slot0.anchoredPosition
			end)).setOnComplete(slot27, System.Action(function ()
				slot0.alpha = 1
				slot1.anchoredPosition.y = slot2
				slot2.anchoredPosition = slot1.anchoredPosition
			end)).setEase(slot27, LeanTweenType.easeOutSine):setDelay(0.7)
		end
	end

	slot6 = slot2.id

	onButton(slot0.sceneParent, (isActive(slot4) and slot4) or slot5, function ()
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

		if slot0.sceneParent.player.level < slot0:getConfig("unlocklevel") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_level_limit", slot1))

			return
		end

		if getProxy(ChapterProxy):getActiveChapter() and slot2.id ~= slot0.id then
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

slot1.PlayChapterItemAnimation = function (slot0, slot1, slot2, slot3)
	slot4 = findTF(slot1, "main")
	slot5 = findTF(slot1, "sub")

	if slot2:getPlayType() == ChapterConst.TypeMainSub then
		slot5:GetComponent("Animator").enabled = true

		slot5:GetComponent("DftAniEvent"):SetEndEvent(function (slot0)
			slot0.enabled = false

			if slot0 then
				slot1()
			end
		end)

		return
	end

	slot7 = findTF(slot4, "circle")
	slot8 = findTF(slot4, "info/bk")

	LeanTween.cancel(go(slot7))

	slot7.localScale = Vector3.zero

	slot0:RecordTween(LeanTween.scale(slot7, Vector3.one, 0.3):setDelay(0.3).uniqueId)
	LeanTween.cancel(go(slot8))
	setAnchoredPosition(slot8, {
		x = -1 * slot4.Find(slot4, "info").rect.width
	})
	shiftPanel(slot8, 0, nil, 0.4, 0.4, true, true, nil, function ()
		if slot0:isTriesLimit() then
			setActive(findTF(findTF, "triesLimit"), true)
		end

		if slot2 then
			slot2()
		end
	end)
end

slot1.PlayChapterItemAnimationBackward = function (slot0, slot1, slot2, slot3)
	slot4 = findTF(slot1, "main")
	slot5 = findTF(slot1, "sub")

	if slot2:getPlayType() == ChapterConst.TypeMainSub then
		if slot3 then
			slot3()
		end
	else
		slot7 = findTF(slot4, "circle")
		slot8 = findTF(slot4, "info/bk")

		LeanTween.cancel(go(slot7))

		slot7.localScale = Vector3.one

		slot0:RecordTween(LeanTween.scale(go(slot7), Vector3.zero, 0.3):setDelay(0.3).uniqueId)

		slot0.chaptersInBackAnimating[slot2.id] = true

		LeanTween.cancel(go(slot8))
		setAnchoredPosition(slot8, {
			x = 0
		})
		shiftPanel(slot8, -1 * slot4:Find("info").rect.width, nil, 0.4, 0.4, true, true, nil, function ()
			slot0.chaptersInBackAnimating[slot1.id] = nil

			if nil then
				slot2()
			end
		end)

		if slot2.isTriesLimit(slot2) then
			setActive(findTF(slot4, "triesLimit"), false)
		end
	end
end

slot1.UpdateChapterTF = function (slot0, slot1)
	if slot0.chapterTFsById[slot1] then
		slot0:UpdateMapItem(slot2, slot3)
		slot0:PlayChapterItemAnimation(slot2, getProxy(ChapterProxy):getChapterById(slot1))
	end
end

slot1.TryOpenChapter = function (slot0, slot1)
	if slot0.chapterTFsById[slot1] then
		triggerButton((isActive(slot2:Find("main")) and slot3) or slot2:Find("sub"))
	end
end

return slot1

slot0 = class("DailyLevelScene", import("..base.BaseUI"))
slot1 = 3
slot2 = 4

slot0.getUIName = function (slot0)
	return "dailylevelui"
end

slot0.init = function (slot0)
	slot0.blurPanel = slot0:findTF("blur_panel")
	slot0.topPanel = slot0:findTF("blur_panel/adapt/top")
	slot0.backBtn = slot0:findTF("back_button", slot0.topPanel)
	slot0.resPanel = PlayerResource.New()

	SetParent(slot0.resPanel._go, slot0:findTF("res", slot0.topPanel), false)

	slot0.listPanel = slot0:findTF("list_panel")
	slot0.content = slot0:findTF("list", slot0.listPanel)

	setActive(slot0.content, true)

	slot0.dailylevelTpl = slot0:getTpl("list_panel/list/captertpl")
	slot0.descPanel = slot0:findTF("desc_panel")
	slot0.selectedPanel = slot0.descPanel:Find("selected")
	slot0.descMain = slot0:findTF("main_mask/main", slot0.descPanel)
	slot0.stageTpl = slot0:getTpl("scrollview/content/stagetpl", slot0.descMain)
	slot0.stageScrollRect = slot0:findTF("scrollview", slot0.descMain):GetComponent(typeof(ScrollRect))
	slot0.stageContain = slot0:findTF("scrollview/content", slot0.descMain)
	slot0.arrows = slot0:findTF("arrows")
	slot0.itemTpl = slot0:getTpl("item_tpl")
	slot0.selStageTF = slot0.selectedPanel:Find("stagetpl/info")
	slot0.selQuicklyTF = slot0.selStageTF.parent:Find("quickly/bg")
	slot0.selQuicklyTFSizeDeltaY = slot0.selQuicklyTF.sizeDelta.y
	slot0.descChallengeNum = slot0:findTF("challenge_count", slot0.descMain)
	slot0.descChallengeText = slot0:findTF("Text", slot0.descChallengeNum)
	slot0.challengeQuotaDaily = slot0:findTF("challenge_count/label", slot0.descMain)
	slot0.challengeQuotaWeekly = slot0:findTF("challenge_count/week_label", slot0.descMain)
	slot0.fleetEditView = slot0:findTF("fleet_edit")
	slot0.resource = slot0:findTF("resource")
	slot0.rightBtn = slot0:findTF("arrows/arrow1")
	slot0.leftBtn = slot0:findTF("arrows/arrow2")

	slot0:initItems()
end

slot0.getWeek = function (slot0)
	return pg.TimeMgr.GetInstance():GetServerWeek()
end

slot0.setDailyCounts = function (slot0, slot1)
	slot0.dailyCounts = slot1
end

slot0.setShips = function (slot0, slot1)
	slot0.shipVOs = slot1
end

slot0.updateRes = function (slot0, slot1)
	slot0.resPanel:setResources(slot1)

	slot0.player = slot1
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0:findTF("help_btn"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_daily_task.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.backBtn, function ()
		if slot0.descMode then
			slot0:enableDescMode(false)
		else
			slot0:emit(slot1.ON_BACK)
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0.leftBtn, function ()
		slot0:flipToSpecificCard(slot0:getNextCardId(true))
	end)
	onButton(slot0, slot0.rightBtn, function ()
		slot0:flipToSpecificCard(slot0:getNextCardId(false))
	end)
	slot0.displayDailyLevels(slot0)

	if slot0.contextData.dailyLevelId then
		slot0:tryOpenDesc(slot0.contextData.dailyLevelId)
	else
		slot0:enableDescMode(false)
	end

	slot0:tryPlayGuide()
	slot0:ShowGuildTaskTip()
end

slot0.initItems = function (slot0)
	slot0.dailyLevelTFs = {}
	slot0.dailyList = _.reverse(Clone(pg.expedition_daily_template.all))

	for slot5, slot6 in pairs(slot0.dailyList) do
		if table.contains(pg.expedition_daily_template[slot6].weekday, tonumber(slot0:getWeek())) then
			table.remove(slot0.dailyList, slot5)
			table.insert(slot0.dailyList, math.ceil(#slot1.all / 2), slot6)

			break
		end
	end

	if slot0.contextData.dailyLevelId then
		table.removebyvalue(slot0.dailyList, slot2)
		table.insert(slot0.dailyList, math.ceil(#slot1.all / 2), slot0.contextData.dailyLevelId)
	end

	for slot5, slot6 in pairs(slot0.dailyList) do
		slot0.dailyLevelTFs[slot6] = cloneTplTo(slot0.dailylevelTpl, slot0.content, slot6)
	end
end

slot0.displayDailyLevels = function (slot0)
	for slot4, slot5 in pairs(slot0.dailyLevelTFs) do
		slot0:initDailyLevel(slot4)
	end

	slot0.content:GetComponent(typeof(EnhancelScrollView)).onCenterClick = function (slot0)
		slot0:tryOpenDesc(tonumber(slot0.name))
	end

	slot0.centerAniItem = nil
	slot0.centerCardId = nil
	slot0.checkAniTimer = Timer.New(function ()
		for slot3, slot4 in pairs(slot0.dailyLevelTFs) do
			slot6 = slot4.localScale.x >= 0.98

			if slot0.centerAniItem == slot4 and slot6 then
				return
			else
				if slot6 then
					slot0.centerAniItem = slot4
					slot0.centerCardId = slot3
				end

				if slot0:findTF("icon/card", slot4) then
					setActive(slot0:findTF("effect", slot7), slot6)

					if slot0:findTF("mask/char", slot7):GetComponent(typeof(Animator)) then
						slot8.speed = (slot6 and 1) or 0
					end
				end
			end
		end
	end, 0.2, -1)

	slot0.checkAniTimer.Start(slot2)
end

slot0.tryOpenDesc = function (slot0, slot1)
	slot2 = slot0.dailyLevelTFs[slot1]

	if table.contains(pg.expedition_daily_template[slot1].weekday, tonumber(slot0:getWeek())) then
		slot0:openDailyDesc(slot1)
	else
		pg.TipsMgr.GetInstance():ShowTips(slot3.tips)
	end
end

slot0.CanOpenDailyLevel = function (slot0)
	slot2 = false

	if table.contains(pg.expedition_daily_template[slot0].weekday, tonumber(slot0.getWeek())) then
		slot2 = true
	end

	return slot2, slot1.tips
end

slot0.getNextCardId = function (slot0, slot1)
	slot2 = table.indexof(slot0.dailyList, slot0.centerCardId)

	if slot1 then
		if slot2 - 1 <= 0 then
			slot2 = #slot0.dailyList or slot2
		end
	elseif slot2 + 1 > #slot0.dailyList then
		slot2 = 1
	end

	return slot0.dailyList[slot2]
end

slot0.initDailyLevel = function (slot0, slot1)
	slot3 = slot0.dailyLevelTFs[slot1]

	if table.contains(pg.expedition_daily_template[slot1].weekday, tonumber(slot0:getWeek())) then
		slot0.index = slot1
	end

	setActive(findTF(slot3, "lock"), not slot4 and not table.isEmpty(slot2.weekday))
	setText(findTF(slot3, "name"), slot2.title)
	setActive(findTF(slot3, "time"), false)

	slot5 = findTF(slot3, "icon")

	PoolMgr.GetInstance():GetPrefab("dailyui/" .. slot2.pic, "", true, function (slot0)
		tf(slot0):SetParent(tf(slot0), false)

		tf(slot0).localPosition = Vector3.zero
		tf(slot0).name = "card"
	end)
	setText(findTF(slot3, "Text"), "")
	slot0:UpdateDailyLevelCnt(slot1)
end

slot0.UpdateDailyLevelCnt = function (slot0, slot1)
	slot2 = pg.expedition_daily_template[slot1]
	slot4 = findTF(slot3, "count")
	slot5 = slot0.dailyCounts[slot1] or 0

	if slot2.limit_time == 0 then
		setText(slot4, "N/A")
	else
		setText(slot4, string.format("%d/%d", slot2.limit_time - slot5, slot2.limit_time))
	end

	setActive(slot4, slot2.limit_time > 0)
end

slot0.openDailyDesc = function (slot0, slot1)
	slot0.curId = slot1

	slot0:enableDescMode(true)
	slot0:displayStageList(slot1)
end

slot0.UpdateDailyLevelCntForDescPanel = function (slot0, slot1)
	slot2 = pg.expedition_daily_template[slot1]
	slot3 = slot0.dailyCounts[slot1] or 0

	if slot2.limit_time == 0 then
		setText(slot0.descChallengeText, i18n("challenge_count_unlimit"))
	else
		setText(slot0.descChallengeText, string.format("%d/%d", slot2.limit_time - slot3, slot2.limit_time))
	end
end

slot0.displayStageList = function (slot0, slot1)
	slot0.dailyLevelId = slot1
	slot0.contextData.dailyLevelId = slot0.dailyLevelId

	slot0:UpdateDailyLevelCntForDescPanel(slot1)
	setActive(slot0.challengeQuotaDaily, pg.expedition_daily_template[slot1].limit_type == 1)
	setActive(slot0.challengeQuotaWeekly, slot2.limit_type == 2)
	removeAllChildren(slot0.stageContain)

	slot0.stageTFs = {}
	slot3 = _.sort(slot2.expedition_and_lv_limit_list, function (slot0, slot1)
		slot2 = (slot0[2] <= slot0.player.level and 1) or 0
		slot3 = (slot1[2] <= slot0.player.level and 1) or 0

		if slot0[2] == slot1[2] then
			return slot0[1] < slot1[1]
		end

		if slot2 == slot3 then
			if slot2 == 1 then
				return slot1[2] < slot0[2]
			else
				return slot0[2] < slot1[2]
			end
		else
			return slot3 < slot2
		end
	end)

	for slot7, slot8 in ipairs(slot3) do
		slot0.stageTFs[slot8[1]] = cloneTplTo(slot0.stageTpl, slot0.stageContain)
		slot11 = {
			id = slot8[1],
			level = slot8[2]
		}

		if slot1 == CHALLENGE_CARD_ID then
			slot0:updateChallenge(slot11)
		else
			slot0:updateStage(slot11)
		end
	end
end

slot0.updateStageTF = function (slot0, slot1, slot2)
	setText(findTF(slot1, "left_panel/name"), pg.expedition_data_template[slot2.id].name)
	setText(findTF(slot1, "left_panel/lv/Text"), "Lv." .. slot2.level)
	setActive(slot0:findTF("mask", slot1), slot0.player.level < slot2.level)

	if slot0.player.level < slot2.level then
		setText(slot0:findTF("msg/msg_contain/Text", slot4), "Lv." .. slot2.level .. " ")
	end

	slot5 = UIItemList.New(slot0:findTF("scrollView/right_panel", slot1), slot0.itemTpl)

	slot5:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, {
				type = slot0.award_display[slot1 + 1][1],
				id = slot0.award_display[slot1 + 1][2],
				count = slot0.award_display[slot1 + 1][3]
			})
		end
	end)
	slot5.align(slot5, #slot3.award_display)
	setImageSprite(slot1, getImageSprite(findTF(slot0.resource, "normal_bg")))
	setActive(findTF(slot1, "score"), false)
	onButton(slot0, slot4, function ()
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_unopened"))
	end, SFX_PANEL)
end

slot0.updateStage = function (slot0, slot1)
	slot0:updateStageTF(slot2, slot1)
	onButton(slot0, slot0.stageTFs[slot1.id]:Find("info"), function ()
		if getProxy(DailyLevelProxy):CanQuickBattle(slot0.id) then
			if pg.expedition_daily_template[slot1.dailyLevelId].limit_time <= (slot1.dailyLevelId.dailyCounts[slot1.dailyLevelId] or 0) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

				return
			end

			slot1:OnSelectStage(slot0)
		else
			slot1:OnOpenPreCombat(slot1.OnOpenPreCombat)
		end
	end, SFX_PANEL)
end

slot0.OnOpenPreCombat = function (slot0, slot1)
	if pg.expedition_daily_template[slot0.dailyLevelId].limit_time <= (slot0.dailyCounts[slot0.dailyLevelId] or 0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	setActive(slot0.blurPanel, false)
	slot0:emit(DailyLevelMediator.ON_STAGE, slot1)
end

slot0.OnSelectStage = function (slot0, slot1)
	onButton(slot0, slot2, function ()
		slot0:EnableOrDisable(slot0, false)
	end, SFX_PANEL)
	onButton(slot0, slot0.selectedPanel, function ()
		slot0:EnableOrDisable(slot0, false)
	end, SFX_PANEL)
	slot0.EnableOrDisable(slot0, slot1, true)
end

slot0.EnableOrDisable = function (slot0, slot1, slot2)
	slot3 = slot0.stageTFs[slot1.id]:Find("quickly")

	if LeanTween.isTweening(go(slot0.stageContain)) or LeanTween.isTweening(go(slot0.selQuicklyTF)) then
		return
	end

	slot6 = -1 * slot0.stageContain:GetComponent(typeof(VerticalLayoutGroup)).padding.top - slot0.stageContain.parent:InverseTransformPoint(slot3.parent.position).y

	if slot2 then
		slot0:updateStageTF(slot0.selStageTF, slot1)
		slot0:UpdateBattleBtn(slot1)
		slot0:DoSelectedAnimation(slot3, slot6, function ()
			slot0.selectedStage = slot1
		end)
	else
		slot0.DoUnselectAnimtion(slot0, slot3, function ()
			slot0.selectedStage = nil
		end)
	end
end

slot0.DoSelectedAnimation = function (slot0, slot1, slot2, slot3)
	slot4 = math.abs(slot2) / 2000

	seriesAsync({
		function (slot0)
			slot0.stageScrollRect.enabled = false

			pg.UIMgr.GetInstance():BlurPanel(slot0.selectedPanel)
			setParent(slot0.blurPanel, pg.UIMgr.GetInstance().OverlayMain)

			setParent.sizeDelta = Vector2(slot1.sizeDelta.x, 0)

			setActive(setActive, true)

			slot0.stageContainLposY = slot0.stageContain.anchoredPosition.y
			slot0.offsetY = slot0

			LeanTween.value(go(slot0.stageContain), slot0.stageContain.anchoredPosition.y, slot0.stageContain.anchoredPosition.y + slot2, ):setOnUpdate(System.Action_float(function (slot0)
				slot0.stageContain.anchoredPosition = Vector3(slot1.x, slot0, 0)
				slot0.selStageTF.parent.localPosition = Vector3(slot0.selectedPanel:InverseTransformPoint(slot2.parent.position).x, slot0.selectedPanel.InverseTransformPoint(slot2.parent.position).y, 0)
				slot0.selQuicklyTF.sizeDelta = Vector2(slot0.selQuicklyTF.sizeDelta.x, 0)

				setActive(slot0.selectedPanel, true)
			end)).setEase(slot2, LeanTweenType.easeInOutCirc):setOnComplete(System.Action(slot0))
		end,
		function (slot0)
			LeanTween.value(go(slot1.selQuicklyTF), 0, slot1.selQuicklyTFSizeDeltaY, 0.1):setOnUpdate(System.Action_float(function (slot0)
				slot0.preferredHeight = slot0
				slot0.selQuicklyTF.sizeDelta = Vector2(slot1.selQuicklyTF.sizeDelta.x, slot0)
			end)).setEase(slot2, LeanTweenType.easeInOutCirc):setOnComplete(System.Action(slot0))
		end
	}, slot3)
end

slot0.DoUnselectAnimtion = function (slot0, slot1, slot2)
	slot3 = slot0.stageContain.anchoredPosition

	seriesAsync({
		function (slot0)
			pg.UIMgr.GetInstance():UnblurPanel(slot0.selectedPanel, slot0._tf)
			setParent(slot0.blurPanel, slot0._tf)
			setActive(slot0.selectedPanel, false)

			slot1 = setActive:GetComponent(typeof(LayoutElement))

			LeanTween.value(go(slot0.selQuicklyTF), slot0.selQuicklyTFSizeDeltaY, 0, 0.1):setOnUpdate(System.Action_float(function (slot0)
				slot0.preferredHeight = slot0
				slot0.selQuicklyTF.sizeDelta = Vector2(slot1.selQuicklyTF.sizeDelta.x, slot0)
			end)).setEase(slot2, LeanTweenType.easeInOutCirc):setOnComplete(System.Action(slot0))
		end,
		function (slot0)
			slot2 = (slot0.y - slot1.offsetY) / 2000

			LeanTween.value(go(slot1.stageContain), slot0.y, slot1, 0.15):setOnUpdate(System.Action_float(function (slot0)
				slot0.stageContain.anchoredPosition = Vector3(slot1.x, slot0, 0)
			end)).setDelay(slot3, 0.1):setEase(LeanTweenType.easeInOutCirc):setOnComplete(System.Action(slot0))
		end
	}, function ()
		slot0.stageScrollRect.enabled = true

		true()
	end)
end

slot0.UpdateBattleBtn = function (slot0, slot1)
	slot3 = slot0.selectedPanel:Find("stagetpl/info").parent:Find("quickly/bg")

	onButton(slot0, slot7, function ()
		slot0:OnOpenPreCombat(slot0)
	end, SFX_PANEL)
	setText(slot3:Find("challenge").Find(slot7, "Text"), i18n("daily_level_quick_battle_label2"))

	slot8 = slot3:Find("mult")

	onButton(slot0, slot8, function ()
		slot0:OnQuickBattle(slot0, )
	end, SFX_PANEL)
	setText(slot8.Find(slot8, "label"), i18n("daily_level_quick_battle_label1", "   ", COLOR_WHITE))
	setText(slot8:Find("Text"), "<color=" .. COLOR_GREEN .. ">" .. math.max(1, pg.expedition_daily_template[slot0.dailyLevelId].limit_time - (slot0.dailyCounts[slot0.dailyLevelId] or 0)) .. "</color>")

	slot9 = slot3:Find("once")

	onButton(slot0, slot9, function ()
		slot0:OnQuickBattle(slot0, 1)
	end, SFX_PANEL)
	setText(slot9.Find(slot9, "label"), i18n("daily_level_quick_battle_label3"))
	setText(slot9:Find("Text"), "")

	if pg.expedition_daily_template[slot0.dailyLevelId].limit_time - (slot0.dailyCounts[slot0.dailyLevelId] or 0) == 0 then
		slot0:EnableOrDisable(slot1, false)
	end
end

slot0.OnQuickBattle = function (slot0, slot1, slot2)
	if slot2 <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dailyLevel_restCount_notEnough"))

		return
	end

	if PlayerPrefs.GetInt("daily_level_quick_battle_tip", 0) == 0 then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dailyLevel_quickfinish"),
			onYes = function ()
				slot0:emit(DailyLevelMediator.ON_QUICK_BATTLE, slot0.dailyLevelId, slot1.id, )
			end
		})
		PlayerPrefs.SetInt("daily_level_quick_battle_tip", 1)
		PlayerPrefs.Save()
	else
		slot0.emit(slot0, DailyLevelMediator.ON_QUICK_BATTLE, slot0.dailyLevelId, slot1.id, slot2)
	end
end

slot0.enableDescMode = function (slot0, slot1, slot2)
	slot0.descMode = slot1

	setActive(slot0:findTF("help_btn"), not slot1)

	function slot3(slot0, slot1, slot2)
		if LeanTween.isTweening(go(slot0)) then
			LeanTween.cancel(go(slot0))
		end

		LeanTween.moveX(rtf(slot0), slot1, 0.3):setEase(LeanTweenType.linear):setOnComplete(System.Action(function ()
			if slot0 then
				slot0()
			end
		end))
	end

	function slot4()
		for slot3, slot4 in pairs(slot0.dailyLevelTFs) do
			setButtonEnabled(slot4, not slot1)

			if slot3 ~= slot0.curId then
				if LeanTween.isTweening(go(slot4)) then
					LeanTween.cancel(go(slot4))
				end

				slot5 = GetComponent(slot4, typeof(CanvasGroup))

				if slot1 then
					LeanTween.value(go(slot4), 1, 0, 0.3):setOnUpdate(System.Action_float(function (slot0)
						slot0.alpha = slot0
					end))
				else
					LeanTween.value(go(slot4), 0, 1, 0.3):setOnUpdate(System.Action_float(function (slot0)
						slot0.alpha = slot0
					end))
				end
			end
		end
	end

	function slot5()
		setActive(slot0.listPanel, true)
		setActive(slot0.content, true)
		setActive(slot0.descPanel, )
		setActive(slot0.arrows, not slot1)
	end

	if slot1 then
		slot5()
		slot4()
		slot3(slot0.listPanel, -622, function ()
			slot0(slot1.descMain, 0, )
		end)
	else
		if slot0.selectedStage then
			slot0.EnableOrDisable(slot0, slot0.selectedStage, false)
		end

		slot5()
		slot4()
		slot3(slot0.listPanel, 0)
		slot3(slot0.descMain, -1342, slot2)
	end
end

slot0.flipToSpecificCard = function (slot0, slot1)
	slot2 = slot0.content:GetComponent(typeof(EnhancelScrollView))

	for slot6, slot7 in pairs(slot0.dailyLevelTFs) do
		if slot1 == slot6 then
			slot2:SetHorizontalTargetItemIndex(slot7:GetComponent(typeof(EnhanceItem)).scrollViewItemIndex)
		end
	end
end

slot0.tryPlayGuide = function (slot0)
	pg.SystemGuideMgr.GetInstance():PlayDailyLevel(function ()
		triggerButton(slot0:findTF("help_btn"))
	end)
end

slot0.ShowGuildTaskTip = function (slot0)
	pg.GuildMsgBoxMgr.GetInstance():NotificationForDailyBattle()
end

slot0.clearTween = function (slot0)
	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	function slot1(slot0)
		if LeanTween.isTweening(go(slot0)) then
			LeanTween.cancel(go(slot0))
		end
	end

	for slot5, slot6 in pairs(slot0.dailyLevelTFs) do
		slot1(slot6)
	end

	slot1(slot0.listPanel)
	slot1(slot0.descMain)
end

slot0.willExit = function (slot0)
	if slot0.selectedStage then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.selectedPanel, slot0._tf)
		setParent(slot0.blurPanel, slot0._tf)
	end

	slot0:clearTween()

	if slot0.checkAniTimer then
		slot0.checkAniTimer:Stop()

		slot0.checkAniTimer = nil
	end

	if slot0.resPanel then
		slot0.resPanel:exit()

		slot0.resPanel = nil
	end
end

return slot0

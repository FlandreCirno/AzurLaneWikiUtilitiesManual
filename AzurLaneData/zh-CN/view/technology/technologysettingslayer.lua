slot0 = class("TechnologySettingsLayer", import("..base.BaseUI"))
slot0.TEC_PAGE_TENDENCY = 1
slot0.TEC_PAGE_CATCHUP_TARGET1 = 2
slot0.TEC_PAGE_CATCHUP_TARGET2 = 3
slot0.TEC_PAGE_CATCHUP_ACT = 4
slot0.PANEL_INTO_TIME = 0.15
slot0.SELECT_TENDENCY_FADE_TIME = 0.3
slot0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3
slot0.CATCHUP_VERSION = 2

slot0.getUIName = function (slot0)
	return "TechnologySettingsUI"
end

slot0.preload = function (slot0, slot1)
	slot0.catchupPanels = {}
	slot0.rightPageTFList = {}

	seriesAsync({
		function (slot0)
			if slot0.CATCHUP_VERSION >= 1 then
				slot1.catchupPanels[1] = TargetCatchupPanel1.New(nil, function ()
					slot0.rightPageTFList[slot1.TEC_PAGE_CATCHUP_TARGET1] = slot0.catchupPanels[1]._go

					setActive(slot0.rightPageTFList[slot1.TEC_PAGE_CATCHUP_TARGET1], false)
					false()
				end)
			else
				slot0()
			end
		end,
		function (slot0)
			if slot0.CATCHUP_VERSION >= 2 then
				slot1.catchupPanels[2] = TargetCatchupPanel2.New(nil, function ()
					slot0.rightPageTFList[slot1.TEC_PAGE_CATCHUP_TARGET2] = slot0.catchupPanels[2]._go

					setActive(slot0.rightPageTFList[slot1.TEC_PAGE_CATCHUP_TARGET2], false)
					false()
				end)
			else
				slot0()
			end
		end
	}, slot1)
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
	slot0:initTendencyPage()
	slot0:initActCatchupPage()
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:resetLeftBtnUnsel()
	slot0:updateTendencyBtn(slot0.curTendency)
	slot0:updateTargetCatchupBtns()
	slot0:updateActCatchupBtn()
	triggerButton(slot0.leftBtnList[1])
	triggerToggle(slot0.showFinish, (slot0.showFinishFlag == 1 and true) or false)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)

	if slot0.actCatchupTimer then
		slot0.actCatchupTimer:Stop()

		slot0.actCatchupTimer = nil
	end

	for slot4, slot5 in pairs(slot0.catchupPanels) do
		slot5:willExit()
	end

	slot0.loader:Clear()
end

slot0.initData = function (slot0)
	slot0.technologyProxy = getProxy(TechnologyProxy)
	slot0.bayProxy = getProxy(BayProxy)
	slot0.bagProxy = getProxy(BagProxy)
	slot0.curPageID = 0
	slot0.curTendency = slot0.technologyProxy:getTendency(2)
	slot0.curSelectedIndex = 0
	slot0.reSelectTag = false
	slot0.actCatchup = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP)
	slot0.isShowActCatchup = slot0.actCatchup and not slot0.actCatchup:isEnd()
	slot0.loader = AutoLoader.New()
end

slot0.findUI = function (slot0)
	slot0.bg = slot0:findTF("BG")

	setText(slot1, i18n("click_back_tip"))

	slot3 = slot0:findTF("LeftBtnList", slot2)
	slot0.tendencyBtn = slot0:findTF("TendencyBtn", slot3)
	slot0.catchupBtns = {
		slot0:findTF("TargetCatchupBtn1", slot3),
		slot0:findTF("TargetCatchupBtn2", slot3)
	}
	slot0.actCatchupBtn = slot0:findTF("ActCatchupBtn", slot3)
	slot0.leftBtnList = {
		[slot0.TEC_PAGE_TENDENCY] = slot0.tendencyBtn,
		[slot0.TEC_PAGE_CATCHUP_TARGET1] = slot0.catchupBtns[1],
		[slot0.TEC_PAGE_CATCHUP_TARGET2] = slot0.catchupBtns[2],
		[slot0.TEC_PAGE_CATCHUP_ACT] = slot0.actCatchupBtn
	}
	slot0.tendencyPanel = slot0:findTF("TecTendencyPanel", slot4)
	slot0.actCatchupPanel = slot0:findTF("ActCatchupPanel", slot4)
	slot0.rightPageTFList[slot0.TEC_PAGE_TENDENCY] = slot0.tendencyPanel
	slot0.rightPageTFList[slot0.TEC_PAGE_CATCHUP_ACT] = slot0.actCatchupPanel

	for slot8, slot9 in pairs(slot0.catchupPanels) do
		SetParent(slot9._go, slot4, false)
	end

	slot0.showFinish = slot0:findTF("ShowFinishToggle")

	setText(slot0:findTF("Label", slot0.showFinish), i18n("tec_target_catchup_show_the_finished_version"))

	slot0.showFinishFlag = PlayerPrefs.GetInt("isShowFinishCatchupVersion") or 0
	slot0.giveupMsgBox = slot0:findTF("GiveUpMsgBox")

	if slot0.CATCHUP_VERSION < 2 then
		setActive(slot0.catchupBtns[2], false)
	end

	if slot0.CATCHUP_VERSION < 1 then
		setActive(slot0.catchupBtns[1], false)
		setActive(slot0.showFinish, false)
	end
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.bg, function ()
		slot0:closeView()
	end, SFX_PANEL)

	for slot4, slot5 in pairs(slot0.leftBtnList) do
		onButton(slot0, slot5, function ()
			if slot0.onPageSwitchAnim then
				return
			end

			if slot0.curPageID ~= slot1 then
				slot0:resetLeftBtnUnsel()
				setActive(slot0:findTF("Selected", slot0), true)
				setActive:switchRightPage(setActive)
			end
		end, SFX_PANEL)
	end

	onToggle(slot0, slot0.showFinish, function (slot0)
		if slot0.CATCHUP_VERSION < 1 then
			return
		end

		for slot4, slot5 in pairs(slot1.catchupBtns) do
			if slot4 <= slot0.CATCHUP_VERSION then
				if slot1.technologyProxy:getCatchupState(slot4) == TechnologyCatchup.STATE_FINISHED_ALL and not slot0 then
					setActive(slot5, false)
				else
					setActive(slot5, true)
				end
			end
		end

		slot1.showFinishFlag = (slot0 and 1) or 0

		PlayerPrefs.SetInt("isShowFinishCatchupVersion", slot1.showFinishFlag)
		triggerButton(slot1.leftBtnList[1])
	end, SFX_PANEL)
end

slot0.resetLeftBtnUnsel = function (slot0)
	for slot4, slot5 in pairs(slot0.leftBtnList) do
		setActive(slot0:findTF("Selected", slot5), false)
	end
end

slot0.switchRightPage = function (slot0, slot1)
	setActive(slot3, true)

	slot0.onPageSwitchAnim = true

	slot0:managedTween(LeanTween.alphaCanvas, function ()
		slot0.onPageSwitchAnim = false
	end, GetOrAddComponent(slot3, typeof(CanvasGroup)), 1, slot0.PANEL_INTO_TIME):setFrom(0)

	if slot0.rightPageTFList[slot0.curPageID] then
		slot0:managedTween(LeanTween.alphaCanvas, function ()
			setActive(setActive, false)
		end, GetOrAddComponent(slot2, typeof(CanvasGroup)), 0, slot0.PANEL_INTO_TIME):setFrom(1)
	end

	slot0.curPageID = slot1

	if slot1 == slot0.TEC_PAGE_TENDENCY then
		slot0:updateTendencyPage(slot0.curTendency)
	elseif slot1 == slot0.TEC_PAGE_CATCHUP_TARGET1 then
		slot0:updateTargetCatchupPage(1)
	elseif slot1 == slot0.TEC_PAGE_CATCHUP_TARGET2 then
		slot0:updateTargetCatchupPage(2)
	elseif slot1 == slot0.TEC_PAGE_CATCHUP_ACT then
		slot0:updateActCatchupPage()
	end
end

slot0.initTendencyPage = function (slot0)
	slot0.tendencyItemList = {}
	slot2 = "tec_tendency_"
	slot4 = getProxy(TechnologyProxy):getConfigMaxVersion()

	for slot8 = 1, slot0:findTF("TecItemList", slot0.tendencyPanel).childCount, 1 do
		setActive(slot1:GetChild(slot8 - 1), slot4 >= slot8 - 1)

		if slot4 >= slot8 - 1 then
			table.insert(slot0.tendencyItemList, slot9)
			setText(slot10, i18n(slot12))
			setText(slot0:findTF("Selected/Text", slot9), i18n(slot2 .. slot8 - 1))
		end
	end

	slot0.tendencyNumList = {}

	eachChild(slot5, function (slot0)
		table.insert(slot0.tendencyNumList, 1, slot0)
	end)

	for slot9, slot10 in ipairs(slot0.tendencyItemList) do
		onButton(slot0, slot10, function ()
			if slot0.curTendency ~= slot1 - 1 then
				slot0:emit(TechnologySettingsMediator.CHANGE_TENDENCY, slot1 - 1)
			end
		end, SFX_PANEL)
	end
end

slot0.updateTendencyPage = function (slot0, slot1)
	slot0.curTendency = slot1

	for slot5, slot6 in ipairs(slot0.tendencyItemList) do
		setActive(slot0:findTF("Selected", slot6), slot1 == slot5 - 1)

		if slot1 == slot5 - 1 then
			setImageAlpha(slot8, 0)
			slot0:managedTween(LeanTween.alpha, nil, rtf(slot8), 1, slot0.SELECT_TENDENCY_FADE_TIME):setFrom(0)
		end
	end

	for slot5, slot6 in ipairs(slot0.tendencyNumList) do
		setActive(slot6, slot5 == slot1)

		if slot5 == slot1 then
			setImageAlpha(slot6, 0)
			slot0:managedTween(LeanTween.alpha, nil, rtf(slot6), 1, slot0.SELECT_TENDENCY_FADE_TIME):setFrom(0)
		end
	end
end

slot0.updateTendencyBtn = function (slot0, slot1)
	setText(slot2, i18n(slot4))
	setText(slot0:findTF("Selected/Text", slot0.tendencyBtn), i18n("tec_tendency_cur_" .. slot1))
end

slot0.updateTargetCatchupPage = function (slot0, slot1)
	slot0.catchupPanels[slot1]:updateTargetCatchupPage()
end

slot0.updateTargetCatchupBtns = function (slot0)
	for slot4, slot5 in pairs(slot0.catchupBtns) do
		if slot4 <= slot0.CATCHUP_VERSION then
			slot8 = slot0:findTF("UnSelect/Text", slot5)
			slot9 = slot0:findTF("Selected/Text", slot5)
			slot12 = slot0:findTF("ProgressText", slot10)
			slot13 = slot0:findTF("ProgressText", slot11)

			setActive(slot10, slot0.technologyProxy:getCatchupState(slot4) == TechnologyCatchup.STATE_CATCHUPING)
			setActive(slot0:findTF("Selected/CharImg", slot5), slot0.technologyProxy.getCatchupState(slot4) == TechnologyCatchup.STATE_CATCHUPING)

			if slot0.technologyProxy.getCatchupState(slot4) == TechnologyCatchup.STATE_CATCHUPING then
				setText(slot8, i18n("tec_target_catchup_selected_" .. slot4))
				setText(slot9, i18n("tec_target_catchup_selected_" .. slot4))

				slot14 = slot0.technologyProxy:getCurCatchupTecInfo()
				slot16 = slot14.groupID
				slot17 = slot14.printNum
				slot18 = pg.technology_catchup_template[slot14.tecID].obtain_max

				for slot22, slot23 in ipairs(slot0.catchupPanels[slot4].UR_LIST) do
					if slot16 == slot23 then
						slot18 = pg.technology_catchup_template[slot15].obtain_max_per_ur
					end
				end

				setImageSprite(slot10, LoadSprite("TecCatchup/QChar" .. slot16, tostring(slot16)))
				setImageSprite(slot11, LoadSprite("TecCatchup/QChar" .. slot16, tostring(slot16)))
				setText(slot12, slot17 .. "/" .. slot18)
				setText(slot13, slot17 .. "/" .. slot18)
			elseif slot6 == TechnologyCatchup.STATE_UNSELECT then
				setText(slot8, i18n("tec_target_catchup_none_" .. slot4))
				setText(slot9, i18n("tec_target_catchup_none_" .. slot4))
			elseif slot6 == TechnologyCatchup.STATE_FINISHED_ALL then
				setText(slot8, i18n("tec_target_catchup_finish_" .. slot4))
				setText(slot9, i18n("tec_target_catchup_finish_" .. slot4))
			end
		end
	end
end

slot0.initActCatchupPage = function (slot0)
	if slot0.isShowActCatchup then
		slot0.loader:GetPrefab("ui/" .. slot1, "", function (slot0)
			setParent(slot0, slot0.actCatchupPanel)
			setLocalScale(slot0, {
				x = 0.925,
				y = 0.923
			})
			setAnchoredPosition(slot0, Vector2.zero)

			slot0.actCatchupTF = slot0:findTF("AD", tf(slot0))
			slot0.actCatchupItemTF = slot0:findTF("Award", slot0.actCatchupTF)
			slot0.actCatchupSliderTF = slot0:findTF("Slider", slot0.actCatchupTF)
			slot0.actCatchupProgressText = slot0:findTF("Progress", slot0.actCatchupTF)

			if slot0:findTF("GoBtn", slot0.actCatchupTF) then
				setActive(slot1, false)
			end

			if slot0:findTF("FinishBtn", slot0.actCatchupTF) then
				setActive(slot2, false)
			end

			updateDrop(slot0.actCatchupItemTF, slot7)
			onButton(slot0, slot0.actCatchupItemTF, function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setSlider(slot0.actCatchupSliderTF, 0, slot5, slot3)
			setText(slot0.actCatchupProgressText, slot3 .. "/" .. pg.activity_event_blueprint_catchup[slot0.actCatchup:getConfig("config_id")].obtain_max)
			setActive(slot0, true)
		end)
	end
end

slot0.updateActCatchupPage = function (slot0)
	return
end

slot0.updateActCatchupBtn = function (slot0)
	setText(slot1, i18n("tec_act_catchup_btn_word"))
	setText(slot2, i18n("tec_act_catchup_btn_word"))

	slot5 = slot0:findTF("ProgressText", slot3)
	slot6 = slot0:findTF("ProgressText", slot4)
	slot7 = false

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP) and not slot8:isEnd() then
		setImageSprite(slot3, LoadSprite("TecCatchup/QChar" .. slot11, tostring(slot11)))
		setImageSprite(slot4, LoadSprite("TecCatchup/QChar" .. slot11, tostring(pg.activity_event_blueprint_catchup[slot8:getConfig("config_id")].char_choice)))
		setText(slot5, slot9 .. "/" .. slot12)
		setText(slot6, slot9 .. "/" .. pg.activity_event_blueprint_catchup[slot8.getConfig("config_id")].obtain_max)

		slot13 = slot8.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

		if slot0.actCatchupTimer then
			slot0.actCatchupTimer:Stop()

			slot0.actCatchupTimer = nil
		end

		slot14 = slot0:findTF("TimeLeft/Day", slot0.actCatchupBtn)
		slot15 = slot0:findTF("TimeLeft/Hour", slot0.actCatchupBtn)
		slot16 = slot0:findTF("TimeLeft/Min", slot0.actCatchupBtn)
		slot17 = slot0:findTF("TimeLeft/NumText", slot0.actCatchupBtn)

		function slot18()
			slot4, slot1, slot2, slot3 = pg.TimeMgr.GetInstance():parseTimeFrom(pg.TimeMgr.GetInstance().parseTimeFrom)

			if slot0 - 1 >= 1 then
				setActive(slot1, true)
				setActive(slot2, false)
				setActive(slot3, false)
				setText(setText, slot0)
			elseif slot0 <= 0 and slot1 > 0 then
				setActive(slot1, false)
				setActive(slot2, true)
				setActive(slot3, false)
				setText(setText, slot1)
			elseif slot0 <= 0 and slot1 <= 0 and (slot2 > 0 or slot3 > 0) then
				setActive(slot1, false)
				setActive(slot2, false)
				setActive(slot3, true)
				setText(setText, math.max(slot2, 1))
			elseif slot0 <= 0 and slot1 <= 0 and slot2 <= 0 and slot3 <= 0 and slot5.actCatchupTimer then
				slot5.actCatchupTimer:Stop()

				slot5.actCatchupTimer.actCatchupTimer = nil

				nil:switchRightPage(slot6.TEC_PAGE_TENDENCY)
				setActive(nil.actCatchupBtn, false)
			end
		end

		slot0.actCatchupTimer = Timer.New(slot18, 1, -1, 1)

		slot0.actCatchupTimer:Start()
		slot0.actCatchupTimer.func()

		slot7 = true
	end

	setActive(slot0.actCatchupBtn, slot7)
end

slot0.initGiveUpMsgBox = function (slot0)
	slot0.giveupMsgboxIntro = slot0.giveupMsgBox:Find("window/info/intro")
	slot0.giveupMsgBoxConfirmBtn = slot0.giveupMsgBox:Find("window/button_container/confirm_btn")
	slot0.giveupMsgBoxCancelBtn = slot0.giveupMsgBox:Find("window/button_container/cancel_btn")
	slot0.giveupMsgBoxInput = slot0.giveupMsgBox:Find("window/info/InputField")
	slot0.giveupMsgboxBackBtn = slot0.giveupMsgBox:Find("window/top/btnBack")

	onButton(slot0, slot0.giveupMsgBoxConfirmBtn, function ()
		if not getInputText(slot0.giveupMsgBoxInput) or slot0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_should_input"))

			return
		end

		if slot0 ~= i18n("tec_target_catchup_giveup_confirm") then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tec_target_catchup_giveup_input_err"))

			return
		end

		pg.m02:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP, {
			tecID = 0,
			charID = 0
		})
		slot0:closeGiveupPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.giveupMsgBoxCancelBtn, function ()
		slot0:closeGiveupPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.giveupMsgboxBackBtn, function ()
		slot0:closeGiveupPanel()
	end, SFX_PANEL)
end

slot0.openGiveupPanel = function (slot0)
	setActive(slot0.giveupMsgBox, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.giveupMsgBox)

	slot0.giveupMsgboxIntro = slot0.giveupMsgBox:Find("window/info/intro")

	setText(slot0.giveupMsgboxIntro, i18n("tec_target_catchup_giveup_tip", ShipGroup.getDefaultShipNameByGroupID(slot0.technologyProxy:getCurCatchupTecInfo().groupID)))
end

slot0.closeGiveupPanel = function (slot0)
	setActive(slot0.giveupMsgBox, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.giveupMsgBox)
end

return slot0

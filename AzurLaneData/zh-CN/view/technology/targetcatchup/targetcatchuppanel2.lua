slot0 = class("TargetCatchupPanel2", import("...base.BaseUI"))
slot0.TEC_ID = 2
slot0.UR_LIST = {
	39904,
	49902
}
slot0.SELECT_CHAR_LIGHT_FADE_TIME = 0.3

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0)
	PoolMgr.GetInstance():GetUI("TargetCatchupPanel2", true, function (slot0)
		slot0.transform:SetParent(slot0, false)
		slot0.transform.SetParent:onUILoaded(slot0)

		if slot0.transform.SetParent then
			slot2()
		end
	end)
end

slot0.getUIName = function (slot0)
	return "TargetCatchupPanel2"
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:initUI()
end

slot0.initData = function (slot0)
	slot0.curSelectedIndex = 0
	slot0.technologyProxy = getProxy(TechnologyProxy)
	slot0.bayProxy = getProxy(BayProxy)
	slot0.bagProxy = getProxy(BagProxy)
	slot0.configCatchup = pg.technology_catchup_template
	slot0.charIDList = slot0.configCatchup[slot0.TEC_ID].char_choice
	slot0.state = slot0.technologyProxy:getCatchupState(slot0.TEC_ID)
end

slot0.initUI = function (slot0)
	slot0.choosePanel = slot0:findTF("ChoosePanel")
	slot0.selectedImgUIItemList = UIItemList.New(slot2, slot1)

	slot0.selectedImgUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setActive(slot0:findTF("Selected", slot2), slot1 + 1 == slot0.curSelectedIndex)

			if slot1 == slot0.curSelectedIndex then
				setImageAlpha(slot3, 0)
				slot0:updateProgress(slot0.charIDList[slot0.curSelectedIndex])
				slot0:managedTween(LeanTween.alpha, nil, rtf(slot3), 1, slot1.SELECT_CHAR_LIGHT_FADE_TIME):setFrom(0)
			end
		end
	end)
	slot0.selectedImgUIItemList.align(slot3, #slot0.charIDList)

	slot0.charUIItemList = UIItemList.New(slot4, slot3)

	slot0.charUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:updateCharTpl(slot1, slot2)
			onButton(slot0, slot2, function ()
				if slot0 ~= slot1.curSelectedIndex then
					slot1.curSelectedIndex = slot1

					slot1.selectedImgUIItemList:align(#slot1.charIDList)
				end
			end, SFX_PANEL)
		end
	end)
	slot0.charUIItemList.align(slot5, #slot0.charIDList)

	slot0.confirmBtn = slot0:findTF("ConfirmBtn", slot0.choosePanel)

	onButton(slot0, slot0.confirmBtn, function ()
		if slot0.curSelectedIndex and slot0.curSelectedIndex ~= 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tec_target_catchup_select_tip", HXSet.hxLan(ShipGroup.getDefaultShipNameByGroupID(slot0.charIDList[slot0.curSelectedIndex]))),
				onYes = function ()
					pg.m02:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP, {
						tecID = slot0.TEC_ID,
						charID = pg.m02
					})
				end
			})
		end
	end, SFX_PANEL)

	slot0.proTitle = slot0.findTF(slot0, "ProgressTitle/Text", slot0.choosePanel)

	setText(slot0.proTitle, i18n("tec_target_catchup_progress"))

	slot0.ssrProgress = slot0:findTF("ProgressTitle/Progress_SSR", slot0.choosePanel)
	slot0.urProgress = slot0:findTF("ProgressTitle/Progress_UR", slot0.choosePanel)

	setText(slot0:findTF("FinishAll/BG/Text", slot0.choosePanel), i18n("tec_target_catchup_all_finish_tip"))
	setText(slot0:findTF("FinishPart/BG/Text", slot0.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
	setText(slot0:findTF("Finish_39904/BG/Text", slot0.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
	setText(slot0:findTF("Finish_49902/BG/Text", slot0.choosePanel), i18n("tec_target_catchup_dr_finish_tip"))
	setText(slot0:findTF("CharListBG/SSRTag/Text", slot0.choosePanel), i18n("tec_target_catchup_pry_char"))
	setText(slot0:findTF("CharListBG/URTag/Text", slot0.choosePanel), i18n("tec_target_catchup_dr_char"))

	slot0.showPanel = slot0:findTF("ShowPanel", slot0.targetCatchupPanel)
	slot0.showBG = slot0:findTF("BG", slot0.showPanel)
	slot0.nameText = slot0:findTF("NameText", slot0.showPanel)
	slot0.progressText = slot0:findTF("Progress/ProgressText", slot0.showPanel)
	slot0.tipText = slot0:findTF("Progress/Text", slot0.showPanel)

	setText(slot0.tipText, i18n("tec_target_catchup_progress"))

	slot0.selectedImg = slot0:findTF("Selected", slot0.showPanel)
	slot0.giveupBtn = slot0:findTF("GiveupBtn", slot0.showPanel)
	slot0.finishedImg = slot0:findTF("Finished", slot0.showPanel)
	slot0.helpBtn = slot0:findTF("HelpBtn", slot0.targetCatchupPanel)

	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tec_target_catchup_help_tip.tip
		})
	end, SFX_PANEL)
end

slot0.updateTargetCatchupPage = function (slot0)
	slot0.state = slot0.technologyProxy:getCatchupState(slot0.TEC_ID)

	if slot0.state == TechnologyCatchup.STATE_CATCHUPING then
		slot0:updateShowPanel()
	else
		slot0:updateChoosePanel()
	end
end

slot0.updateCharTpl = function (slot0, slot1, slot2)
	setText(slot3, i18n("tec_target_need_print"))

	slot12 = (slot0.bayProxy:findShipByGroup(slot8) and math.floor(slot0:getShipBluePrintCurExp(slot0.technologyProxy:getBluePrintVOByGroupID(slot0.charIDList[slot1])) / pg.item_data_template[pg.ship_data_blueprint[slot0.charIDList[slot1]].strengthen_item].usage_arg[1])) or 0

	setText(slot0:findTF("PrintNum/NumText", slot2), slot15)
	setText(slot0:findTF("NameText", slot2), slot16)
	setActive(slot0:findTF("LevelText", slot2), slot9)
	setActive(slot0:findTF("NotGetTag", slot2), not slot9)

	if slot9 then
		slot17 = slot0.technologyProxy:getBluePrintVOByGroupID(slot8)

		setText(slot6, "Lv. " .. slot17.level .. "/" .. slot17:getMaxLevel())
	end
end

slot0.updateShowPanel = function (slot0)
	setActive(slot0.showPanel, true)
	setActive(slot0.choosePanel, false)

	slot1 = slot0.technologyProxy:getCurCatchupTecInfo()
	slot4 = slot1.printNum

	setImageSprite(slot0.showBG, LoadSprite("TecCatchup/selbg" .. slot3, slot3))
	setText(slot0.nameText, slot5)

	slot6 = pg.technology_catchup_template[slot1.tecID].obtain_max

	for slot10, slot11 in ipairs(slot0.UR_LIST) do
		if slot3 == slot11 then
			slot6 = pg.technology_catchup_template[slot2].obtain_max_per_ur
		end
	end

	setText(slot0.progressText, slot4 .. "/" .. slot6)
	setActive(slot0.finishedImg, slot0.state == TechnologyCatchup.STATE_FINISHED_ALL)
	setActive(slot0.selectedImg, not (slot0.state == TechnologyCatchup.STATE_FINISHED_ALL))
	onButton(slot0, slot0.selectedImg, function ()
		slot0:updateChoosePanel()
		setActive(slot0:findTF("ProgressTitle", slot0.choosePanel), false)
	end, SFX_PANEL)
end

slot0.updateChoosePanel = function (slot0)
	setActive(slot0.showPanel, false)
	setActive(slot0.choosePanel, true)

	slot1 = slot0.technologyProxy:getCatchupData(slot0.TEC_ID)
	slot2 = slot0.state == TechnologyCatchup.STATE_FINISHED_ALL

	if slot2 then
		setActive(slot0:findTF("FinishAll", slot0.choosePanel), true)
		setActive(slot0:findTF("ProgressTitle", slot0.choosePanel), false)
	else
		setActive(slot0:findTF("FinishAll", slot0.choosePanel), false)
		setActive(slot0:findTF("FinishPart", slot0.choosePanel), slot3)

		for slot7, slot8 in ipairs(slot0.UR_LIST) do
			setActive(slot0:findTF("Finish_" .. slot8, slot0.choosePanel), slot1:isFinish(slot8))
		end
	end
end

slot0.updateProgress = function (slot0, slot1)
	setActive(slot0:findTF("ProgressTitle", slot0.choosePanel), true)

	slot3 = slot0.technologyProxy:getCatchupData(slot0.TEC_ID).getTargetNum(slot2, slot1)
	slot4 = slot0:getMaxNum(slot1)

	if slot0:isUR(slot1) then
		setActive(slot0.urProgress, true)
		setActive(slot0.ssrProgress, false)
		setText(slot0:findTF("Text", slot0.urProgress), slot3 .. "/" .. slot4)
	else
		setActive(slot0.urProgress, false)
		setActive(slot0.ssrProgress, true)
		setText(slot0:findTF("Text", slot0.ssrProgress), slot3 .. "/" .. slot4)
	end
end

slot0.isUR = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.UR_LIST) do
		if slot1 == slot6 then
			return true
		end
	end

	return false
end

slot0.getMaxNum = function (slot0, slot1)
	return (slot0:isUR(slot1) and pg.technology_catchup_template[slot0.TEC_ID].obtain_max_per_ur) or pg.technology_catchup_template[slot0.TEC_ID].obtain_max
end

slot0.willExit = function (slot0)
	PoolMgr.GetInstance():ReturnUI(slot0:getUIName(), slot0._go)
end

slot0.getShipBluePrintCurExp = function (slot0, slot1)
	slot3 = slot1.fateLevel
	slot5 = slot1:getConfig("strengthen_effect")
	slot6 = slot1:getConfig("fate_strengthen")
	slot7 = 0 + slot1.exp

	for slot11 = 1, slot1.level, 1 do
		slot7 = slot7 + pg.ship_strengthen_blueprint[slot5[slot11]].need_exp
	end

	for slot11 = 1, slot3, 1 do
		slot7 = slot7 + pg.ship_strengthen_blueprint[slot6[slot11]].need_exp
	end

	return slot7
end

return slot0

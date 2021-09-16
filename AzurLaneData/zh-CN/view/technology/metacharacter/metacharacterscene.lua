slot0 = class("MetaCharacterScene", import("...base.BaseUI"))
slot0.PAGES = {
	REPAIR = 3,
	ENERGY = 1,
	TACTICS = 2,
	SYN = 4
}
slot0.PAGES_EVENTS = {
	MetaCharacterMediator.ON_ENERGY,
	MetaCharacterMediator.ON_TACTICS,
	MetaCharacterMediator.ON_REPAIR,
	MetaCharacterMediator.ON_SYN
}
slot0.SCALE_ON_PITCH = {
	x = 1.7,
	y = 1.7
}
slot0.ON_SKILL = "MetaCharacterScene:ON_SKILL"

slot0.getUIName = function (slot0)
	return "MetaCharacterUI"
end

slot0.init = function (slot0)
	slot0:initUITextTips()
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
	slot0:initMetaProgressList()
	slot0:initBannerList()
end

slot0.didEnter = function (slot0)
	slot0:overLayPanel(true)

	slot1 = slot0.metaCharacterProxy:isHaveVaildMetaProgressVO()

	setActive(slot0.noCharTF, not slot1)
	setActive(slot0.hidePanel, slot1)

	if not slot1 then
		return
	end

	slot0:updateBannerUIList()
	triggerButton(slot0.bannerTFList[1])
	slot0:autoOpenFunc()
end

slot0.willExit = function (slot0)
	slot0:overLayPanel(false)
end

slot0.initUITextTips = function (slot0)
	slot1 = slot0:findTF("HidePanel/ScrollPanel/ListPanel/BannerTpl/ForScale")

	setText(slot2, i18n("meta_syn_rate"))
	setText(slot3, i18n("meta_build"))
	setText(slot4, i18n("meta_repair_rate"))
	setText(slot5, i18n("meta_build"))
	setText(slot6, i18n("meta_story_tip_1"))
	setText(slot7, i18n("meta_story_tip_2"))
	setText(slot0:findTF("HidePanel/ActTimeTip/Tip"), i18n("meta_acttime_limit"))
end

slot0.initData = function (slot0)
	slot0.metaProgressVOList = {}
	slot0.curMetaGroupID = nil
	slot0.curMetaProgress = nil
	slot0.toggleList = {}
	slot0.bannerTFList = {}
	slot0.curPageIndex = nil
	slot0.curMetaIndex = nil
	slot0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	slot0.bayProxy = getProxy(BayProxy)
end

slot0.findUI = function (slot0)
	slot0.shipImg = slot0:findTF("HidePanel/ShipImg")
	slot0.shipNameImg = slot0:findTF("HidePanel/NameImg")
	slot0.noCharTF = slot0:findTF("BG/NoCharacter")
	slot0.hidePanel = slot0:findTF("HidePanel")
	slot0.scrollPanel = slot0:findTF("ScrollPanel", slot0.hidePanel)
	slot0.bannerListPanel = slot0:findTF("ListPanel", slot0.scrollPanel)
	slot0.bannerContainer = slot0:findTF("Container", slot0.bannerListPanel)
	slot0.bannerTpl = slot0:findTF("BannerTpl", slot0.bannerListPanel)
	slot0.actTimePanel = slot0:findTF("ActTimeTip", slot0.hidePanel)
	slot0.actTimeText = slot0:findTF("Text", slot0.actTimePanel)
	slot0.menuPanel = slot0:findTF("MenuPanel", slot0.hidePanel)
	slot0.energyBtn = slot0:findTF("EnergyBtn", slot0.menuPanel)
	slot0.repairBtn = slot0:findTF("RepairBtn", slot0.menuPanel)
	slot0.tacticsBtn = slot0:findTF("TacticsBtn", slot0.menuPanel)
	slot0.synBtn = slot0:findTF("SynBtn", slot0.menuPanel)
	slot0.synDecorateTF = slot0:findTF("SynDecorate", slot0.menuPanel)
	slot0.synBtnLimitTimeTF = slot0:findTF("Limit", slot0.synBtn)
	slot0.synBtnLock = slot0:findTF("LockMask", slot0.synBtn)
	slot0.ptPanel = slot0:findTF("PTPanel", slot0.hidePanel)
	slot0.ptRedBarImg = slot0:findTF("RedBar", slot0.ptPanel)
	slot0.ptPreviewBtn = slot0:findTF("PreviewBtn", slot0.ptPanel)
	slot0.ptGetBtn = slot0:findTF("SynBtn", slot0.ptPanel)
	slot0.ptGetBtnTag = slot0:findTF("Tag", slot0.ptGetBtn)
	slot0.ptShowWayBtn = slot0:findTF("ShowWayBtn", slot0.ptPanel)
	slot1 = slot0:findTF("Progress", slot0.ptPanel)
	slot0.ptProgressImg = slot0:findTF("CircleProgress/ProgressImg", slot1)
	slot0.ptProgressScaleLine = slot0:findTF("CircleProgress/ScaleLine", slot1)
	slot0.ptInfoPanel = slot0:findTF("PT", slot1)
	slot0.ptProgressRedRightNumText = slot0:findTF("ProgressTextBG/PointRedText/RightNumText", slot0.ptInfoPanel)
	slot0.ptProgressRedLeftNumText = slot0:findTF("ProgressTextBG/PointRedText/LeftNumText", slot0.ptInfoPanel)
	slot0.ptProgressWhiteRightNumText = slot0:findTF("ProgressTextBG/PointText/RightNumText", slot0.ptInfoPanel)
	slot0.ptProgressWhiteLeftNumText = slot0:findTF("ProgressTextBG/PointText/LeftNumText", slot0.ptInfoPanel)
	slot0.ptIcon = slot0:findTF("PTProgressText/PTIcon", slot0.ptInfoPanel)
	slot0.ptProgressRedText = slot0:findTF("PTProgressRedText", slot0.ptInfoPanel)
	slot0.ptProgressWhiteText = slot0:findTF("PTProgressText", slot0.ptInfoPanel)
	slot0.storyInfoPanel = slot0:findTF("Story", slot1)
	slot2 = slot0:findTF("TipText1", slot0.storyInfoPanel)
	slot3 = slot0:findTF("TipText2", slot0.storyInfoPanel)
	slot0.storyNameText = slot0:findTF("StroyNameText", slot0.storyInfoPanel)
	slot0.getShipBtn = slot0:findTF("FinishBtn", slot1)
	slot0.buildPanel = slot0:findTF("BuildPanel", slot0.hidePanel)
	slot0.buildBtn = slot0:findTF("BuildBtn", slot0.buildPanel)
	slot0.blurPanel = slot0:findTF("blur_panel")
	slot4 = slot0:findTF("adapt", slot0.blurPanel)
	slot0.backBtn = slot0:findTF("top/back", slot4)
	slot0.helpBtn = slot0:findTF("top/help", slot4)
	slot0.toggleBtnsTF = slot0:findTF("left/Btns", slot4)
	slot0.toggleList[1] = slot0:findTF("Energy", slot0.toggleBtnsTF)
	slot0.toggleList[2] = slot0:findTF("Tactics", slot0.toggleBtnsTF)
	slot0.toggleList[3] = slot0:findTF("Repair", slot0.toggleBtnsTF)
	slot0.toggleList[4] = slot0:findTF("Syn", slot0.toggleBtnsTF)
	slot0.synToggleLock = slot0:findTF("SynLock", slot0.toggleBtnsTF)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		if slot0.curPageIndex then
			slot0:enterMenuPage(false)
			slot0:emit(slot1.PAGES_EVENTS[slot0.curPageIndex], nil, false)

			if slot0 == slot0.emit.PAGES.REPAIR then
				slot0:backFromRepair()
			else
				slot0:backFromNotRepair()
			end
		else
			slot0:closeView()
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.meta_help.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.buildBtn, function ()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.ptPreviewBtn, function ()
		slot0:emit(MetaCharacterMediator.OPEN_PT_PREVIEW_LAYER, slot0:getCurMetaProgressVO())
	end, SFX_PANEL)
	onButton(slot0, slot0.ptGetBtn, function ()
		if slot0:getCurMetaProgressVO().getMetaProgressPTState(slot0) == MetaProgress.STATE_CAN_AWARD then
			slot3, slot8.arg1 = slot0:getOneStepPTAwardLevelAndCount()

			pg.m02:sendNotification(GAME.ACT_NEW_PT, {
				cmd = 4,
				activity_id = slot0.metaPtData:GetId(),
				arg1 = slot4
			})
		elseif slot1 == MetaProgress.STATE_LESS_PT then
			slot2 = false

			if nowWorld then
				slot2 = nowWorld:IsSystemOpen(WorldConst.SystemWorldBoss)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n((slot2 and "meta_pt_notenough") or "meta_boss_unlock"))
		elseif slot1 == MetaProgress.STATE_LESS_STORY then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_story_lock"))
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.ptShowWayBtn, function ()
		slot0 = false

		if nowWorld then
			slot0 = nowWorld:IsSystemOpen(WorldConst.SystemWorldBoss)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n((slot0 and "meta_pt_notenough") or "meta_boss_unlock"))
	end, SFX_PANEL)
	onButton(slot0, slot0.getShipBtn, function ()
		slot2, slot7.arg1 = slot0:getCurMetaProgressVO().metaPtData:GetResProgress()

		pg.m02:sendNotification(GAME.ACT_NEW_PT, {
			cmd = 1,
			activity_id = slot0.getCurMetaProgressVO().metaPtData:GetId(),
			arg1 = slot3
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.synToggleLock, function ()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end, SFX_PANEL)
	onButton(slot0, slot0.synBtnLock, function ()
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
	end)
	onButton(slot0, slot0:findTF("RepairBtn", slot0.repairBtn), function ()
		slot0:switchPage(slot1.PAGES.REPAIR)
	end, SFX_PANEL)
	onButton(slot0, slot0.energyBtn, function ()
		slot0.isMainOpenLayerTag = true

		slot0:switchPage(slot1.PAGES.ENERGY)
	end, SFX_PANEL)
	onButton(slot0, slot0.tacticsBtn, function ()
		slot0.isMainOpenLayerTag = true

		slot0:switchPage(slot1.PAGES.TACTICS)
	end, SFX_PANEL)
	onButton(slot0, slot0.synBtn, function ()
		if not isActive(slot0.synBtnLock) then
			slot0.isMainOpenLayerTag = true

			slot0:switchPage(slot1.PAGES.SYN)
		end
	end, SFX_PANEL)

	for slot4, slot5 in ipairs(slot0.toggleList) do
		onToggle(slot0, slot5, function (slot0)
			if slot0.curPageIndex ==  and slot0 == true then
				return
			end

			slot1 = slot0:getCurMetaProgressVO()
			slot2 = slot1:getShip()

			if slot0.curPageIndex == slot1 and slot0 == false then
				slot0:enterMenuPage(false)
				slot0:emit(slot2.PAGES_EVENTS[slot1], slot2.id, false)
			end

			if slot0.curPageIndex ~= slot1 and slot0 == true then
				slot0:enterMenuPage(true)

				slot0.curPageIndex = slot1

				slot0:emit(slot2.PAGES_EVENTS[slot1], slot2.id, true)
			end
		end)
	end
end

slot0.resetToggleList = function (slot0)
	for slot4, slot5 in ipairs(slot0.toggleList) do
		setActive(slot0:findTF("On", slot5), false)
		setActive(slot0:findTF("Off", slot5), true)
	end
end

slot0.initMetaProgressList = function (slot0)
	slot0.metaProgressVOList = slot0:getMetaProgressListForShow()

	if #slot0.metaProgressVOList < 5 then
		for slot4 = #slot0.metaProgressVOList + 1, 5, 1 do
			table.insert(slot0.metaProgressVOList, false)
		end
	end
end

slot0.initBannerList = function (slot0)
	slot0.scrollUIItemList = UIItemList.New(slot0.bannerContainer, slot0.bannerTpl)

	slot0.scrollUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			table.insert(slot0.bannerTFList, slot2)
			slot0:updateBannerTF(slot0.metaProgressVOList[slot1 + 1], slot2, slot1 + 1)
		end
	end)
end

slot0.updateBannerTF = function (slot0, slot1, slot2, slot3)
	slot4 = slot2
	slot5 = slot0:findTF("ForScale", slot2)
	slot6 = slot0:findTF("WillCome", slot5)
	slot7 = slot0:findTF("Empty", slot5)
	slot8 = slot0:findTF("Active", slot5)

	if slot1 then
		slot9 = slot1:isInAct()

		setActive(slot10, slot9)
		setActive(slot11, slot9)
		setActive(slot12, slot9)
		setActive(slot0:findTF("BuildType/Tag", slot8), slot9)
	end

	if slot1 then
		slot10 = Ship.New({
			configId = tonumber(slot1.configId .. 1)
		}).getName(slot9)
		slot11 = nil

		setText(slot11, slot10)
		setActive(slot11, true)
		setText(slot11, slot10)
		setActive(slot11, true)
		setText(slot11, slot10)
		setActive(slot11, true)
		setText(slot11, slot10)
		setActive(slot0:findTF("Active/BuildType/ShipNameText", slot5), true)
	end

	if slot1 == false then
		setActive(slot6, true)

		return
	else
		setActive(slot6, false)

		slot9 = slot1:isUnlocked()

		setActive(slot7, not slot9)
		setActive(slot8, slot9)

		slot10 = slot1:isPtType()
		slot11 = slot1:isBuildType()

		if not slot9 then
			setActive(slot12, slot10)
			setActive(slot13, slot11)

			slot19, slot20 = slot1:getBannerPathAndName()

			setImageSprite(slot12, LoadSprite(slot14, slot15))
			setImageSprite(slot0:findTF("Empty/BuildType", slot5), LoadSprite(slot14, slot15))

			if slot10 then
				setText(slot16, slot17)
				setSlider(slot0:findTF("Slider", slot12), 0, 1, slot1:getSynRate())
			end

			slot17 = Ship.New({
				configId = pg.ship_strengthen_meta[slot1.configId].ship_id
			})
			slot19 = slot17:getStar()
			slot22 = UIItemList.New(slot21, slot20)

			slot22:make(function (slot0, slot1, slot2)
				if slot0 == UIItemList.EventUpdate then
					setActive(slot0:findTF("On", slot2), slot1 + 1 <= )
				end
			end)
			slot22.align(slot22, slot17:getMaxStar())
		else
			setActive(slot12, slot10)
			setActive(slot13, slot11)

			slot19, slot20 = slot1:getBannerPathAndName()

			setImageSprite(slot0:findTF("Active", slot5), LoadSprite(slot14, slot15))
			setImageSprite(slot13, LoadSprite(slot14, slot15))

			slot17 = slot1:getShip():getMetaCharacter()

			if slot10 then
				setText(slot18, slot19)
				setSlider(slot0:findTF("Slider", slot12), 0, 1, slot17:getRepairRate())
			end

			slot19 = slot16:getStar()
			slot22 = UIItemList.New(slot21, slot20)

			slot22:make(function (slot0, slot1, slot2)
				if slot0 == UIItemList.EventUpdate then
					setActive(slot0:findTF("On", slot2), slot1 + 1 <= )
				end
			end)
			slot22.align(slot22, slot16:getMaxStar())
		end

		onButton(slot0, slot4, function ()
			if slot0.curMetaIndex ~= slot1 then
				if slot0.curMetaIndex and slot0.curMetaIndex > 0 then
					slot0:changeBannerOnClick(slot0.bannerTFList[slot0.curMetaIndex], false)
				end

				slot0.curMetaIndex = slot1

				slot0:changeBannerOnClick(slot2, true)
				slot0.changeBannerOnClick:updateMain()
			end
		end, SFX_PANEL)
	end
end

slot0.changeBannerOnClick = function (slot0, slot1, slot2)
	slot3 = slot1:GetComponent("LayoutElement")
	slot4 = slot0:findTF("ForScale", slot1)

	if slot2 == true then
		setLocalScale(slot4, slot0.SCALE_ON_PITCH)

		slot3.preferredWidth = 338.3
		slot3.preferredHeight = 102
	else
		setLocalScale(slot4, Vector2.one)

		slot3.preferredWidth = 199
		slot3.preferredHeight = 60
	end

	setActive(slot0:findTF("SelectedTag", slot4), slot2)
end

slot0.updateBannerShipName = function (slot0, slot1)
	slot2 = slot0:findTF("ForScale", slot1)
	slot4 = isActive(slot3)
	slot5 = nil

	setActive(slot5, slot4)
	setActive(slot5, slot4)
	setActive(slot5, slot4)
	setActive(slot5, slot4)

	slot6 = nil

	setActive(slot6, not slot4)
	setActive(slot6, not slot4)
	setActive(slot6, not slot4)
	setActive(slot0:findTF("Active/BuildType/Text", slot2), not slot4)
end

slot0.updateBannerUIList = function (slot0)
	slot0.bannerTFList = {}

	slot0.scrollUIItemList:align(#slot0.metaProgressVOList)
end

slot0.updateMain = function (slot0, slot1)
	slot3 = slot0:getCurMetaProgressVO().isUnlocked(slot2)

	setActive(slot0.menuPanel, slot3)
	setActive(slot0.ptPanel, not slot3)
	setActive(slot0.buildPanel, not slot3)
	slot0:updateActTimePanel()

	if not slot3 then
		setActive(slot0.ptPanel, slot4)
		setActive(slot0.buildPanel, slot2:isBuildType())

		if slot2:isPtType() then
			slot0:updatePTPanel(slot1)
		end
	else
		slot0:updateRedPoints()
		slot0:TryPlayGuide()
	end

	slot9, slot10 = slot2:getPaintPathAndName()

	setImageSprite(slot0.shipImg, LoadSprite(slot4, slot5), true)

	slot4, slot5 = slot2:getBGNamePathAndName()

	setImageSprite(slot0.shipNameImg, LoadSprite(slot4, slot5), true)
	setLocalPosition(slot0.shipImg, {
		x = MetaCharacterConst.UIConfig[slot2.id][1],
		y = MetaCharacterConst.UIConfig[slot2.id][2]
	})
	setLocalScale(slot0.shipImg, {
		x = MetaCharacterConst.UIConfig[slot2.id][3],
		y = MetaCharacterConst.UIConfig[slot2.id][4]
	})
end

slot0.TryPlayGuide = function (slot0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0024")
end

slot0.updateActTimePanel = function (slot0)
	slot1 = slot0:getCurMetaProgressVO()

	setActive(slot0.actTimePanel, not slot1:isUnlocked() and slot1:isInAct())
	setActive(slot0.synBtnLimitTimeTF, slot1.isInAct())

	if slot3 then
		setText(slot0.actTimeText, slot6)
		setText(slot0:findTF("Text", slot0.synBtnLimitTimeTF), i18n("meta_pt_left", pg.TimeMgr.GetInstance():DiffDay(slot8, slot7)))
	end
end

slot0.updatePTPanel = function (slot0, slot1)
	slot2 = slot0:getCurMetaProgressVO()
	slot3 = slot2:getSynRate()
	slot4 = tonumber(tostring(slot3 * 100))

	setImageSprite(slot0.ptIcon, LoadSprite(slot2:getPtIconPath()))
	setFillAmount(slot0.ptProgressImg, slot3)
	setActive(slot0.ptProgressScaleLine, slot3 < 1)

	slot0.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * slot3)

	setText(slot0.ptProgressRedLeftNumText, string.format("%d", slot4))
	setText(slot0.ptProgressWhiteLeftNumText, string.format("%d", slot4))
	setText(slot0.ptProgressRedRightNumText, ((slot4 - math.floor(slot4)) * 100 == 0 and string.format("%2d", (slot4 - math.floor(slot4)) * 100) .. "0%") or string.format("%2d", (slot4 - math.floor(slot4)) * 100) .. "%")
	setText(slot0.ptProgressWhiteRightNumText, ((slot4 - math.floor(slot4)) * 100 == 0 and string.format("%2d", (slot4 - math.floor(slot4)) * 100) .. "0%") or string.format("%2d", (slot4 - math.floor(slot4)) * 100) .. "%")

	slot8, slot9, slot10 = slot2.metaPtData:GetResProgress()

	setText(slot0.ptProgressRedText, ((slot10 >= 1 and setColorStr(slot8, COLOR_GREEN)) or setColorStr(slot8, COLOR_RED)) .. "/" .. slot9)
	setText(slot0.ptProgressWhiteText, ((slot10 >= 1 and setColorStr(slot8, COLOR_GREEN)) or setColorStr(slot8, COLOR_RED)) .. "/" .. slot9)

	if slot2:getMetaProgressPTState() == MetaProgress.STATE_CAN_FINISH then
		setActive(slot0.ptRedBarImg, true)
		setActive(slot0.ptPreviewBtn, false)
		setActive(slot0.ptGetBtn, false)
		setActive(slot0.ptShowWayBtn, false)
		setActive(slot0.ptInfoPanel, false)
		setActive(slot0.storyInfoPanel, false)
		setActive(slot0.getShipBtn, true)
	elseif slot11 == MetaProgress.STATE_CAN_AWARD then
		setActive(slot0.ptRedBarImg, false)
		setActive(slot0.ptPreviewBtn, true)
		setActive(slot0.ptGetBtn, true)
		setActive(slot0.ptShowWayBtn, false)
		setActive(slot0.ptGetBtnTag, true)
		setActive(slot0.ptInfoPanel, true)
		setActive(slot0.storyInfoPanel, false)
		setActive(slot0.getShipBtn, false)
		setImageAlpha(slot0.ptPreviewBtn, 0)
		setImageAlpha(slot0.ptGetBtn, 0)
		setImageAlpha(slot0.ptGetBtnTag, 0)
		setImageAlpha(slot0.ptShowWayBtn, 0)
	elseif slot11 == MetaProgress.STATE_LESS_STORY then
		setActive(slot0.ptRedBarImg, true)
		setActive(slot0.ptPreviewBtn, true)
		setActive(slot0.ptGetBtn, true)
		setActive(slot0.ptShowWayBtn, false)
		setActive(slot0.ptGetBtnTag, false)
		setActive(slot0.ptInfoPanel, false)
		setActive(slot0.storyInfoPanel, true)
		setActive(slot0.getShipBtn, false)
		setText(slot0.storyNameText, slot2:getCurLevelStoryName())
	elseif slot11 == MetaProgress.STATE_LESS_PT then
		setActive(slot0.ptRedBarImg, false)
		setActive(slot0.ptPreviewBtn, true)
		setActive(slot0.ptGetBtn, false)
		setActive(slot0.ptShowWayBtn, true)
		setActive(slot0.ptGetBtnTag, false)
		setActive(slot0.ptInfoPanel, true)
		setActive(slot0.storyInfoPanel, false)
		setActive(slot0.getShipBtn, false)
		setImageAlpha(slot0.ptPreviewBtn, 0)
		setImageAlpha(slot0.ptGetBtn, 0)
		setImageAlpha(slot0.ptShowWayBtn, 0)
	end

	if slot3 > 0 and not slot1 then
		if slot11 == MetaProgress.STATE_CAN_AWARD or slot11 == MetaProgress.STATE_LESS_PT then
			slot0:managedTween(LeanTween.value, nil, go(slot0.ptPanel), 0, slot3, math.min(slot3, 1)):setOnUpdate(System.Action_float(function (slot0)
				setFillAmount(slot0.ptProgressImg, slot0)
				setActive(slot0.ptProgressScaleLine, slot0 < 1)

				slot0.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * slot0)

				setText(slot0.ptProgressRedLeftNumText, string.format("%d", setActive))
				setText(slot0.ptProgressWhiteLeftNumText, string.format("%d", setActive))
				setText(slot0.ptProgressRedRightNumText, ((slot0 * 100 - math.floor(slot0 * 100)) * 100 == 0 and string.format("%2d", (setActive - math.floor(setActive)) * 100) .. "0%") or string.format("%2d", (setActive - math.floor(setActive)) * 100) .. "%")
				setText(slot0.ptProgressWhiteRightNumText, ((slot0 * 100 - math.floor(slot0 * 100)) * 100 == 0 and string.format("%2d", (setActive - math.floor(setActive)) * 100) .. "0%") or string.format("%2d", (setActive - math.floor(setActive)) * 100) .. "%")
			end)).setOnComplete(slot13, System.Action(function ()
				setFillAmount(slot0.ptProgressImg, )
				slot0(slot1, slot0.ptProgressScaleLine < 1)

				slot0.ptProgressScaleLine.localEulerAngles = Vector3(0, 0, -360 * slot1)
				slot0 = string.format("%d", 0)

				setText(slot0.ptProgressRedLeftNumText, slot0)
				setText(slot0.ptProgressWhiteLeftNumText, slot0)
				setText(slot0.ptProgressRedRightNumText, ((0 - math.floor(math.floor)) * 100 == 0 and string.format("%2d", ((slot0.ptProgressScaleLine < 1) - math.floor(string.format)) * 100) .. "0%") or string.format("%2d", ((slot0.ptProgressScaleLine < 1) - math.floor(string.format)) * 100) .. "%")
				setText(slot0.ptProgressWhiteRightNumText, ((0 - math.floor(math.floor)) * 100 == 0 and string.format("%2d", ((slot0.ptProgressScaleLine < 1) - math.floor(string.format)) * 100) .. "0%") or string.format("%2d", ((slot0.ptProgressScaleLine < 1) - math.floor(string.format)) * 100) .. "%")
				slot0:managedTween(LeanTween.value, nil, go(slot0.ptPanel), 0, 1, slot3 / 2):setOnUpdate(System.Action_float(function (slot0)
					setImageAlpha(slot0.ptPreviewBtn, slot0)
					setImageAlpha(slot0.ptGetBtn, slot0)
					setImageAlpha(slot0.ptGetBtnTag, slot0)
					setImageAlpha(slot0.ptShowWayBtn, slot0)
				end)).setOnComplete(slot3, System.Action(function ()
					setImageAlpha(slot0.ptPreviewBtn, 1)
					setImageAlpha(slot0.ptGetBtn, 1)
					setImageAlpha(slot0.ptGetBtnTag, 1)
					setImageAlpha(slot0.ptShowWayBtn, 1)
				end))
			end))
		end
	else
		setImageAlpha(slot0.ptPreviewBtn, 1)
		setImageAlpha(slot0.ptGetBtn, 1)
		setImageAlpha(slot0.ptGetBtnTag, 1)
		setImageAlpha(slot0.ptShowWayBtn, 1)
	end
end

slot0.updateRedPoints = function (slot0)
	slot1 = slot0:getCurMetaProgressVO()

	setActive(slot0:findTF("RepairBtn/Tag", slot0.repairBtn), slot3)
	setActive(slot0:findTF("Tag", slot0.energyBtn), slot4)
	setActive(slot0:findTF("Tag", slot0.tacticsBtn), slot5)

	slot6 = slot1:isPtType()

	setActive(slot0.synDecorateTF, slot8)
	setActive(slot0.synBtn, slot6)
	setActive(slot0.synBtnLock, slot6 and not slot1:isInAct())
	setActive(slot0.toggleList[4], slot6)
	setActive(slot0.synToggleLock, slot6 and not slot1.isInAct())

	slot9 = nil

	if slot8 then
		setActive(slot0:findTF("Tag", slot0.synBtn), MetaCharacterConst.isMetaSynRedTag(slot2))
	end

	setActive(slot0:findTF("Tip", slot0.toggleList[slot0.PAGES.REPAIR]), slot3)
	setActive(slot0:findTF("Tip", slot0.toggleList[slot0.PAGES.ENERGY]), slot4)
	setActive(slot0:findTF("Tip", slot0.toggleList[slot0.PAGES.TACTICS]), slot5)
	setActive(slot0:findTF("Tip", slot0.toggleList[slot0.PAGES.SYN]), slot9)
end

slot0.getCurMetaProgressVO = function (slot0)
	return slot0.metaProgressVOList[slot0.curMetaIndex]
end

slot0.refreshBannerTF = function (slot0)
	slot0:updateBannerTF(slot0:getCurMetaProgressVO(), slot0.bannerTFList[slot0.curMetaIndex], slot0.curMetaIndex)
end

slot0.enterMenuPage = function (slot0, slot1)
	setActive(slot0.hidePanel, not slot1)
	setActive(slot0.toggleBtnsTF, slot1)
end

slot0.switchPage = function (slot0, slot1)
	if not slot0.curPageIndex then
		triggerToggle(slot0.toggleList[slot1], true)
	end
end

slot0.backFromRepair = function (slot0)
	setActive(slot0.menuPanel, false)
	slot0:managedTween(LeanTween.alpha, nil, slot0.shipImg, 1, 0.3):setFrom(0):setOnComplete(System.Action(function ()
		setActive(slot0.menuPanel, true)
		setActive(slot0.hidePanel, true)
	end))
end

slot0.backFromNotRepair = function (slot0)
	setActive(slot0.menuPanel, false)
	slot0:managedTween(LeanTween.moveX, nil, rtf(slot0.shipImg), MetaCharacterConst.UIConfig[slot0:getCurMetaProgressVO().id][1], 0.3):setFrom(slot3):setOnComplete(System.Action(function ()
		setActive(slot0.menuPanel, true)
		setActive(slot0.hidePanel, true)
	end))
end

slot0.autoOpenFunc = function (slot0)
	if slot0.contextData.autoOpenShipConfigID then
		slot1 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(slot0.contextData.autoOpenShipConfigID)
		slot3 = 0

		for slot7, slot8 in ipairs(slot2) do
			if slot8 and slot8.id == slot1 then
				triggerButton(slot0.bannerTFList[slot7])

				slot0.contextData.autoOpenShipConfigID = nil
			end
		end
	end

	if slot0.contextData.autoOpenTactics then
		triggerButton(slot0.tacticsBtn)

		slot0.contextData.autoOpenTactics = nil
	end

	if slot0.contextData.autoOpenSyn then
		if slot0:getCurMetaProgressVO():isUnlocked() then
			triggerButton(slot0.synBtn)
		end

		slot0.contextData.autoOpenSyn = nil
	end

	if slot0.contextData.lastPageIndex then
		triggerToggle(slot0.toggleList[slot0.contextData.lastPageIndex], true)

		slot0.contextData.lastPageIndex = nil
	end
end

slot0.overLayPanel = function (slot0, slot1)
	if slot1 == true then
		pg.UIMgr.GetInstance():OverlayPanel(slot0.blurPanel, {
			groupName = LayerWeightConst.GROUP_META
		})
	elseif slot1 == false then
		pg.UIMgr.GetInstance():UnOverlayPanel(slot0.blurPanel, slot0._tf)
	end
end

slot0.getMetaProgressListForShow = function (slot0)
	slot1 = {}

	for slot6, slot7 in ipairs(slot2) do
		if slot7:isShow() then
			if slot7:isPtType() and slot7:isInAct() then
				table.insert(slot1, 1, slot7)
			else
				table.insert(slot1, slot7)
			end
		end
	end

	return slot1
end

slot0.getOneStepPTAwardLevelAndCount = function (slot0)
	slot1 = slot0:getCurMetaProgressVO()
	slot2 = slot1.metaPtData:GetResProgress()
	slot3 = slot1.metaPtData.targets
	slot4 = slot1:getStoryIndexList()
	slot6 = 0

	for slot10 = 1, slot1.unlockPTLevel - 1, 1 do
		slot11 = false
		slot12 = false

		if slot3[slot10] <= slot2 then
			slot11 = true
		end

		if slot4[slot10] == 0 then
			slot12 = true
		elseif pg.NewStoryMgr.GetInstance():IsPlayed(slot14) then
			slot12 = true
		end

		if slot11 and slot12 then
			slot6 = slot10
		else
			break
		end
	end

	return slot6, slot3[slot6]
end

return slot0

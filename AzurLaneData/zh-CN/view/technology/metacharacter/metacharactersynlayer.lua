slot0 = class("MetaCharacterSynLayer", import("...base.BaseUI"))

slot0.getUIName = function (slot0)
	return "MetaCharacterSynUI"
end

slot0.init = function (slot0)
	slot0:initUITextTips()
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
end

slot0.didEnter = function (slot0)
	slot0:updateShipImg()
	slot0:updatePtPanel()
	slot0:updateTaskList()
	slot0:updateGetAwardBtn()
	slot0:updateActTimePanel()
	slot0:enablePartialBlur()

	if slot0.contextData.isMainOpen then
		slot0.contextData.isMainOpen = nil

		slot0:moveShipImg(true)
	end

	slot0:movePanel()
	slot0:TryPlayGuide()
end

slot0.willExit = function (slot0)
	slot0:moveShipImg(false)
	slot0:disablePartialBlur()
end

slot0.initUITextTips = function (slot0)
	setText(slot1, i18n("meta_cur_pt"))
	setText(slot0:findTF("TaskPanel/ActTimePanel/Tip"), i18n("meta_acttime_limit"))
end

slot0.initData = function (slot0)
	slot0.curMetaShipID = slot0.contextData.shipID
	slot0.curShipVO = nil
	slot0.curMetaCharacterVO = nil
	slot0.curMetaProgressVO = nil

	slot0:updateData()
end

slot0.updateData = function (slot0)
	slot0.curShipVO = getProxy(BayProxy):getShipById(slot0.curMetaShipID)
	slot0.curMetaCharacterVO = slot0.curShipVO:getMetaCharacter()
	slot0.curMetaProgressVO = getProxy(MetaCharacterProxy):getMetaProgressVOByID(slot0.curMetaCharacterVO.id)

	slot0.curMetaProgressVO:updateDataAfterActOP()
end

slot0.findUI = function (slot0)
	slot0.shipImg = slot0:findTF("ShipImg")
	slot0.ptPanel = slot0:findTF("PTPanel")
	slot0.ptSynRateText = slot0:findTF("ProgressText", slot0.ptPanel)
	slot0.ptNumText = slot0:findTF("Count/NumText", slot0.ptPanel)
	slot0.ptIconLeft = slot0:findTF("Icon", slot0.ptPanel)
	slot0.showWayBtn = slot0:findTF("ShowWayBtn", slot0.ptPanel)
	slot0.taskPanel = slot0:findTF("TaskPanel")
	slot0.taskTplContainer = slot0:findTF("Scroll/Viewport/Content", slot0.taskPanel)
	slot0.taskTpl = slot0:findTF("TaskTpl", slot0.taskPanel)
	slot0.getAllBtn = slot0:findTF("BtnGetAll", slot0.taskPanel)
	slot0.getAllBtnDisable = slot0:findTF("BtnGetAllDisable", slot0.taskPanel)
	slot0.getNextBtn = slot0:findTF("BtnGetMore", slot0.taskPanel)
	slot0.taskUIItemList = UIItemList.New(slot0.taskTplContainer, slot0.taskTpl)
	slot0.sizeH = GetComponent(slot0.taskTpl, "LayoutElement").preferredHeight
	slot0.spaceH = GetComponent(slot0.taskTplContainer, "VerticalLayoutGroup").spacing
	slot0.topH = GetComponent(slot0.taskTplContainer, "VerticalLayoutGroup").padding.top
	slot0.scrollSC = GetComponent(slot0:findTF("Scroll", slot0.taskPanel), "ScrollRect")
	slot0.actTimeText = slot0:findTF("TaskPanel/ActTimePanel/Text")
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.getAllBtn, function ()
		slot1, slot6.arg1 = slot0:getOneStepPTAwardLevelAndCount()

		pg.m02:sendNotification(GAME.ACT_NEW_PT, {
			cmd = 4,
			activity_id = slot0.curMetaProgressVO.metaPtData:GetId(),
			arg1 = slot2
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.getAllBtnDisable, function ()
		return
	end)
	onButton(slot0, slot0.getNextBtn, function ()
		pg.TipsMgr.GetInstance():ShowTips(i18n("meta_pt_notenough"))
	end)
	onButton(slot0, slot0.showWayBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				count = 0,
				type = DROP_TYPE_RESOURCE,
				id = slot0.curMetaProgressVO.metaPtData.resId
			}
		})
	end, SFX_PANEL)
end

slot0.TryPlayGuide = function (slot0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0028")
end

slot0.updateActTimePanel = function (slot0)
	setText(slot0.actTimeText, i18n("meta_pt_left", pg.TimeMgr.GetInstance():DiffDay(slot3, slot2)))
end

slot0.updateShipImg = function (slot0)
	slot6, slot7 = MetaCharacterConst.GetMetaCharacterPaintPath(slot0.curMetaCharacterVO.id, true)

	setImageSprite(slot0.shipImg, LoadSprite(slot1, slot2), true)
	setLocalPosition(slot0.shipImg, {
		x = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][9],
		y = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][10]
	})
	setLocalScale(slot0.shipImg, {
		x = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][3],
		y = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][4]
	})
end

slot0.updatePtPanel = function (slot0)
	setImageSprite(slot0.ptIconLeft, LoadSprite(slot0.curMetaProgressVO:getPtIconPath()))
	setText(slot0.ptSynRateText, string.format("%d", slot0.curMetaProgressVO:getSynRate() * 100) .. "%")
	setText(slot0.ptNumText, slot0.curMetaProgressVO.metaPtData:GetResProgress())
end

slot0.updateTaskList = function (slot0)
	slot0.taskUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:updateTaskTpl(slot2, slot1 + 1)
		end
	end)

	slot1, slot6, slot3 = slot0.curMetaProgressVO.metaPtData.GetLevelProgress(slot1)

	slot0.taskUIItemList:align(slot2)
	setLocalPosition(slot0.taskTplContainer, {
		y = slot0.topH + (slot1 - 1) * (slot0.sizeH + slot0.spaceH)
	})
end

slot0.updateTaskTpl = function (slot0, slot1, slot2)
	slot9 = slot0:findTF("Info/AwardInfo/Award/Tag/Get", slot1)
	slot10 = slot0:findTF("Info/AwardInfo/Award/Tag/Got", slot1)
	slot11 = slot0:findTF("GotMask", slot1)

	setText(slot3, slot2)
	setText(slot4, slot12)
	setImageSprite(slot5, LoadSprite(slot0.curMetaProgressVO:getPtIconPath()))
	updateDrop(slot8, slot14, {
		hideName = true
	})
	onButton(slot0, slot0:findTF("Info/AwardInfo/Award", slot1), function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	updateDropCfg(slot14)
	setText(slot6, shortenString(HXSet.hxLan(({
		type = slot0.curMetaProgressVO.metaPtData.dropList[slot2][1],
		id = slot0.curMetaProgressVO.metaPtData.dropList[slot2][2],
		count = slot0.curMetaProgressVO.metaPtData.dropList[slot2][3]
	})["cfg"].name), 6))
	setText(slot0:findTF("Info/AwardInfo/SynProgressText", slot1), math.round(slot0.curMetaProgressVO.metaPtData.targets[slot2] / slot0.curMetaProgressVO.unlockPTNum * 100) .. "%")

	if slot2 < slot0.curMetaProgressVO.metaPtData.level + 1 then
		setActive(slot10, true)
		setActive(slot9, false)
		setActive(slot11, true)
		setGray(slot1, true, true)
	else
		if slot0.curMetaProgressVO.metaPtData.count < slot12 then
			setActive(slot10, false)
			setActive(slot9, false)
		else
			setActive(slot10, false)
			setActive(slot9, true)
		end

		setActive(slot11, false)
		setGray(slot1, false, true)
	end
end

slot0.updateGetAwardBtn = function (slot0)
	slot2 = slot0.curMetaProgressVO.metaPtData:CanGetNextAward()

	if slot0.curMetaProgressVO.metaPtData:CanGetAward() then
		setActive(slot0.getAllBtn, true)
		setActive(slot0.getAllBtnDisable, false)
		setActive(slot0.getNextBtn, false)
	elseif slot2 then
		setActive(slot0.getAllBtn, false)
		setActive(slot0.getAllBtnDisable, false)
		setActive(slot0.getNextBtn, true)
	else
		setActive(slot0.getAllBtn, false)
		setActive(slot0.getAllBtnDisable, true)
		setActive(slot0.getNextBtn, false)
	end
end

slot0.moveShipImg = function (slot0, slot1)
	slot0:managedTween(LeanTween.moveX, nil, rtf(slot0.shipImg), (slot1 and MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][9]) or -2000, 0.3):setFrom((slot1 and -2000) or MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][9])
end

slot0.movePanel = function (slot0)
	slot0:managedTween(LeanTween.moveX, nil, rtf(slot0.taskPanel), slot2, 0.3):setFrom(slot1)
	slot0:managedTween(LeanTween.moveX, nil, rtf(slot0.ptPanel), -516, 0.3):setFrom(-2000)
end

slot0.enablePartialBlur = function (slot0)
	if slot0._tf then
		table.insert(slot1, slot0.taskPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(slot0._tf, {
			pbList = {},
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

slot0.disablePartialBlur = function (slot0)
	if slot0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
	end
end

slot0.getOneStepPTAwardLevelAndCount = function (slot0)
	slot2 = slot0.curMetaProgressVO.metaPtData:GetResProgress()
	slot4 = slot0.curMetaProgressVO.getStoryIndexList(slot1)
	slot5 = slot0.curMetaProgressVO.unlockPTLevel
	slot6 = 0

	for slot10 = 1, #slot0.curMetaProgressVO.metaPtData.targets, 1 do
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

	print("calc max level", slot6, slot3[slot6])

	return slot6, slot3[slot6]
end

slot0.goWorldFunc = function (slot0)
	getProxy(ContextProxy):getContextByMediator(MetaCharacterMediator).data.lastPageIndex = pg.m02:retrieveMediator("MetaCharacterMediator").viewComponent.curPageIndex

	slot0:closeView()
	pg.m02:sendNotification(GAME.ENTER_WORLD, {
		inWorldBoss = true
	})
end

return slot0

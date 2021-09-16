slot0 = class("ShipMainScene", import("...base.BaseUI"))
slot1 = 0
slot2 = 0.2
slot3 = 0.3
slot4 = 3
slot5 = 0.5
slot6 = 11

slot0.getUIName = function (slot0)
	return "ShipMainScene"
end

slot0.preload = function (slot0, slot1)
	slot3 = getProxy(BayProxy).getShipById(slot2, slot0.contextData.shipId)

	parallelAsync({
		function (slot0)
			GetSpriteFromAtlasAsync("bg/star_level_bg_" .. slot0:rarity2bgPrintForGet(), "", slot0)
		end,
		function (slot0)
			if not PoolMgr.GetInstance():HasCacheUI("ShipDetailView") then
				slot1:GetUI(slot2, true, function (slot0)
					slot0:ReturnUI(slot0.ReturnUI, slot0)
					slot0()
				end)
			else
				slot0()
			end
		end
	}, slot1)
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1

	slot0:GetShareData():SetPlayer(slot1)

	if slot0._resPanel then
		slot0._resPanel:setResources(slot1)
	end
end

slot0.setShipList = function (slot0, slot1)
	slot0.shipList = slot1
end

slot0.setShip = function (slot0, slot1)
	slot0:GetShareData():SetShipVO(slot1)

	slot2 = false

	if slot0.shipVO and slot0.shipVO.id ~= slot1.id then
		slot0:StopPreVoice()

		slot2 = true
	end

	slot0.shipVO = slot1

	setActive(slot0.npcFlagTF, slot1:isActivityNpc())

	if slot2 and not slot0:checkToggleActive(ShipViewConst.currentPage) then
		triggerToggle(slot0.detailToggle, true)
	end

	slot0:setToggleEnable()

	slot0.isSpBg = pg.ship_skin_template[slot0.shipVO.skinId].rarity_bg and slot3.rarity_bg ~= ""

	slot0:updatePreference(slot1)
	slot0.shipDetailView:ActionInvoke("UpdateUI")
	slot0.shipFashionView:ActionInvoke("UpdateUI")
	slot0.shipEquipView:ActionInvoke("UpdateUI")
end

slot0.setToggleEnable = function (slot0)
	for slot4, slot5 in pairs(slot0.togglesList) do
		setActive(slot5, slot0:checkToggleActive(slot4))
	end

	setActive(slot0.technologyToggle, slot0.shipVO:isBluePrintShip())
	SetActive(slot0.metaToggle, slot0.shipVO:isMetaShip())
end

slot0.checkToggleActive = function (slot0, slot1)
	if slot1 == ShipViewConst.PAGE.DETAIL then
		return true
	elseif slot1 == ShipViewConst.PAGE.EQUIPMENT then
		return true
	elseif slot1 == ShipViewConst.PAGE.INTENSIFY then
		return not slot0.shipVO:isTestShip() and not slot0.shipVO:isBluePrintShip() and not slot0.shipVO:isMetaShip()
	elseif slot1 == ShipViewConst.PAGE.UPGRADE then
		return not slot0.shipVO:isTestShip() and not slot0.shipVO:isBluePrintShip() and not slot0.shipVO:isMetaShip()
	elseif slot1 == ShipViewConst.PAGE.REMOULD then
		return not slot0.shipVO:isTestShip() and not slot0.shipVO:isBluePrintShip() and pg.ship_data_trans[slot0.shipVO.groupId] and not slot0.shipVO:isMetaShip()
	elseif slot1 == ShipViewConst.PAGE.FASHION then
		return slot0:hasFashion()
	else
		return false
	end
end

slot0.setSkinList = function (slot0, slot1)
	slot0.shipFashionView:ActionInvoke("SetSkinList", slot1)
end

slot0.updateLock = function (slot0)
	slot0.shipDetailView:ActionInvoke("UpdateLock")
end

slot0.updatePreferenceTag = function (slot0)
	slot0.shipDetailView:ActionInvoke("UpdatePreferenceTag")
end

slot0.closeRecordPanel = function (slot0)
	slot0.shipDetailView:ActionInvoke("CloseRecordPanel")
end

slot0.updateRecordEquipments = function (slot0, slot1)
	slot0.shipDetailView:UpdateRecordEquipments(slot1)
end

slot0.setModPanel = function (slot0, slot1)
	slot0.modPanel = slot1
end

slot0.setMaxLevelHelpFlag = function (slot0, slot1)
	slot0.maxLevelHelpFlag = slot1
end

slot0.checkMaxLevelHelp = function (slot0)
	if not slot0.maxLevelHelpFlag and slot0.shipVO and slot0.shipVO:isReachNextMaxLevel() then
		slot0:openHelpPage()

		slot0.maxLevelHelpFlag = true

		getProxy(SettingsProxy):setMaxLevelHelp(true)
	end
end

slot0.GetShareData = function (slot0)
	if not slot0.shareData then
		slot0.shareData = ShipViewShareData.New(slot0.contextData)

		slot0.shipDetailView:SetShareData(slot0.shareData)
		slot0.shipFashionView:SetShareData(slot0.shareData)
		slot0.shipEquipView:SetShareData(slot0.shareData)
		slot0.shipEquipView:ActionInvoke("InitEvent")
		slot0.shipHuntingRangeView:SetShareData(slot0.shareData)
		slot0.shipCustomMsgBox:SetShareData(slot0.shareData)
		slot0.shipChangeNameView:SetShareData(slot0.shareData)
	end

	return slot0.shareData
end

slot0.hasFashion = function (slot0)
	return slot0.shareData:HasFashion()
end

slot0.DisplayRenamePanel = function (slot0, slot1)
	slot0.shipChangeNameView:Load()
	slot0.shipChangeNameView:ActionInvoke("DisplayRenamePanel", slot1)
end

slot0.init = function (slot0)
	slot0:initShip()
	slot0:initPages()
	slot0:initEvents()

	slot0.mainCanvasGroup = slot0._tf:GetComponent(typeof(CanvasGroup))
	slot0.commonCanvasGroup = slot0:findTF("blur_panel/adapt"):GetComponent(typeof(CanvasGroup))
	Input.multiTouchEnabled = false
end

slot0.initShip = function (slot0)
	slot0.shipInfo = slot0:findTF("main/character")

	setActive(slot0.shipInfo, true)

	slot0.tablePainting = {
		slot0:findTF("painting", slot0.shipInfo),
		slot0:findTF("painting2", slot0.shipInfo)
	}
	slot0.nowPainting = nil
	slot0.isRight = true
	slot0.blurPanel = slot0:findTF("blur_panel")
	slot0.common = slot0.blurPanel:Find("adapt")
	slot0.npcFlagTF = slot0.common:Find("name/npc")
	slot0.shipName = slot0.common:Find("name")
	slot0.shipInfoStarTpl = slot0.shipName:Find("star_tpl")
	slot0.nameEditFlag = slot0.shipName:Find("nameRect/editFlag")

	setActive(slot0.shipName, true)
	setActive(slot0.shipInfoStarTpl, false)
	setActive(slot0.nameEditFlag, false)

	slot0.energyTF = slot0.shipName:Find("energy")
	slot0.energyDescTF = slot0.energyTF:Find("desc")
	slot0.energyText = slot0.energyTF:Find("desc/desc")

	setActive(slot0.energyDescTF, false)

	slot0.character = slot0:findTF("main/character")
	slot0.chat = slot0:findTF("main/character/chat")
	slot0.chatBg = slot0:findTF("main/character/chat/chatbgtop")
	slot0.chatText = slot0:findTF("Text", slot0.chat)
	rtf(slot0.chat).localScale = Vector3.New(0, 0, 1)
	slot0.initChatBgH = slot0.chatBg.sizeDelta.y
	slot0.initChatTextH = slot0.chatText.sizeDelta.y
	slot0.initfontSize = slot0.chatText:GetComponent(typeof(Text)).fontSize

	pg.UIMgr.GetInstance():OverlayPanel(slot0.chat, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})

	slot0._playerResOb = slot0:findTF("blur_panel/adapt/top/playerRes")
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)
end

slot0.initPages = function (slot0)
	ShipViewConst.currentPage = nil
	slot0.background = slot0:findTF("background")

	setActive(slot0.background, true)

	slot0.main = slot0:findTF("main")
	slot0.mainMask = slot0.main:GetComponent(typeof(RectMask2D))
	slot0.toggles = slot0:findTF("left_length/frame/root", slot0.common)
	slot0.detailToggle = slot0.toggles:Find("detail_toggle")
	slot0.equipmentToggle = slot0.toggles:Find("equpiment_toggle")
	slot0.intensifyToggle = slot0.toggles:Find("intensify_toggle")
	slot0.upgradeToggle = slot0.toggles:Find("upgrade_toggle")
	slot0.remouldToggle = slot0.toggles:Find("remould_toggle")
	slot0.technologyToggle = slot0.toggles:Find("technology_toggle")
	slot0.metaToggle = slot0.toggles:Find("meta_toggle")
	slot0.togglesList = {
		[ShipViewConst.PAGE.DETAIL] = slot0.detailToggle,
		[ShipViewConst.PAGE.EQUIPMENT] = slot0.equipmentToggle,
		[ShipViewConst.PAGE.INTENSIFY] = slot0.intensifyToggle,
		[ShipViewConst.PAGE.UPGRADE] = slot0.upgradeToggle,
		[ShipViewConst.PAGE.REMOULD] = slot0.remouldToggle
	}
	slot0.detailContainer = slot0.main:Find("detail_container")

	setAnchoredPosition(slot0.detailContainer, {
		x = 1300
	})

	slot0.fashionContainer = slot0.main:Find("fashion_container")

	setAnchoredPosition(slot0.fashionContainer, {
		x = 900
	})

	slot0.equipContainer = slot0.main:Find("equip_container")
	slot0.equipLCon = slot0.equipContainer:Find("equipment_l_container")
	slot0.equipRCon = slot0.equipContainer:Find("equipment_r_container")

	setAnchoredPosition(slot0.equipRCon, {
		x = 750
	})
	setAnchoredPosition(slot0.equipLCon, {
		x = -700
	})

	slot0.shipDetailView = ShipDetailView.New(slot0.detailContainer, slot0.event, slot0.contextData)
	slot0.shipFashionView = ShipFashionView.New(slot0.fashionContainer, slot0.event, slot0.contextData)
	slot0.shipEquipView = ShipEquipView.New(slot0.equipContainer, slot0.event, slot0.contextData)
	slot0.shipHuntingRangeView = ShipHuntingRangeView.New(slot0._tf, slot0.event, slot0.contextData)
	slot0.shipCustomMsgBox = ShipCustomMsgBox.New(slot0._tf, slot0.event, slot0.contextData)
	slot0.shipChangeNameView = ShipChangeNameView.New(slot0._tf, slot0.event, slot0.contextData)
	slot0.viewList = {
		[ShipViewConst.PAGE.DETAIL] = slot0.shipDetailView,
		[ShipViewConst.PAGE.FASHION] = slot0.shipFashionView,
		[ShipViewConst.PAGE.EQUIPMENT] = slot0.shipEquipView
	}

	onButton(slot0, slot0.shipName, function ()
		if slot0.shipVO.propose and not slot0.shipVO:IsXIdol() then
			if not pg.PushNotificationMgr.GetInstance():isEnableShipName() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_switch_tip"))

				return
			end

			if (slot0.shipVO.renameTime + 2592000) - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
				if math.floor(slot0 / 60 / 60 / 24) < 1 then
					slot1 = 1
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("word_rename_time_tip", slot1))
			else
				slot0:DisplayRenamePanel(true)
			end
		end
	end, SFX_PANEL)
end

slot0.initEvents = function (slot0)
	slot0:bind(ShipViewConst.SWITCH_TO_PAGE, function (slot0, slot1)
		slot0:gotoPage(slot1)
	end)
	slot0.bind(slot0, ShipViewConst.LOAD_PAINTING, function (slot0, slot1, slot2)
		slot0:loadPainting(slot1, slot2)
	end)
	slot0.bind(slot0, ShipViewConst.LOAD_PAINTING_BG, function (slot0, slot1, slot2, slot3)
		slot0:loadSkinBg(slot1, slot2, slot3, slot0.isSpBg)
	end)
	slot0.bind(slot0, ShipViewConst.HIDE_SHIP_WORD, function (slot0)
		slot0:hideShipWord()
	end)
	slot0.bind(slot0, ShipViewConst.SET_CLICK_ENABLE, function (slot0, slot1)
		slot0.mainCanvasGroup.blocksRaycasts = slot1
		slot0.commonCanvasGroup.blocksRaycasts = slot1
		GetComponent(slot0.detailContainer, "CanvasGroup").blocksRaycasts = slot1
	end)
	slot0.bind(slot0, ShipViewConst.SHOW_CUSTOM_MSG, function (slot0, slot1)
		slot0.shipCustomMsgBox:Load()
		slot0.shipCustomMsgBox:ActionInvoke("showCustomMsgBox", slot1)
	end)
	slot0.bind(slot0, ShipViewConst.HIDE_CUSTOM_MSG, function (slot0)
		slot0.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")
	end)
	slot0.bind(slot0, ShipViewConst.DISPLAY_HUNTING_RANGE, function (slot0, slot1)
		if slot1 then
			slot0.shipHuntingRangeView:Load()
			slot0.shipHuntingRangeView:ActionInvoke("DisplayHuntingRange")
		else
			slot0.shipHuntingRangeView:HideHuntingRange()
		end
	end)
	slot0.bind(slot0, ShipViewConst.PAINT_VIEW, function (slot0, slot1)
		if slot1 then
			slot0:paintView()
		else
			slot0:hidePaintView(true)
		end
	end)
end

slot0.didEnter = function (slot0)
	slot0:addRingDragListenter()
	onButton(slot0, slot0:findTF("top/back_btn", slot0.common), function ()
		GetOrAddComponent(slot0._tf, typeof(CanvasGroup)).interactable = false

		if not slot0.everTriggerBack then
			LeanTween.delayedCall(0.3, System.Action(function ()
				slot0:closeView()
			end))

			slot0.everTriggerBack = true
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0.npcFlagTF, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_actnpc.tip
		})
	end, SFX_PANEL)

	slot0.helpBtn = slot0.findTF(slot0, "help_btn", slot0.common)

	onButton(slot0, slot0.helpBtn, function ()
		slot0:openHelpPage(ShipViewConst.currentPage)
	end, SFX_PANEL)

	for slot4, slot5 in pairs(slot0.togglesList) do
		if slot5 == slot0.upgradeToggle or slot5 == slot0.remouldToggle or slot5 == slot0.equipmentToggle then
			onToggle(slot0, slot5, function (slot0)
				if slot0 then
					if LeanTween.isTweening(go(slot0.chat)) then
						LeanTween.cancel(go(slot0.chat))
					end

					rtf(slot0.chat).localScale = Vector3.New(0, 0, 1)
					slot0.chatFlag = false

					slot0:switchToPage(slot0.switchToPage)
				end
			end, SFX_PANEL)
		else
			onToggle(slot0, slot5, function (slot0)
				if slot0 then
					slot0:switchToPage(slot0.switchToPage)
				end
			end, SFX_PANEL)
		end
	end

	onButton(slot0, slot0.technologyToggle, function ()
		slot0:emit(ShipMainMediator.ON_TECHNOLOGY, slot0.shipVO)
	end, SFX_PANEL)
	onButton(slot0, slot0.metaToggle, function ()
		slot0:emit(ShipMainMediator.ON_META, slot0.shipVO)
	end, SFX_PANEL)
	onButton(slot0, tf(slot0.character), function ()
		if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
			slot0:displayShipWord("detail")
		end
	end)
	onButton(slot0, slot0.energyTF, function ()
		slot0:showEnergyDesc()
	end)
	pg.UIMgr.GetInstance().OverlayPanel(slot1, slot0.blurPanel, {
		groupName = LayerWeightConst.GROUP_SHIPINFOUI
	})
	slot0:gotoPage((slot0:checkToggleActive(slot0.contextData.page) and slot0.contextData.page) or ShipViewConst.PAGE.DETAIL)

	if ShipViewConst.currentPage == ShipViewConst.PAGE.DETAIL then
		slot0:displayShipWord(slot0:getInitmacyWords())
		slot0:checkMaxLevelHelp()
	end
end

slot0.openHelpPage = function (slot0, slot1)
	if slot1 == ShipViewConst.PAGE.EQUIPMENT then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_equip.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif slot1 == ShipViewConst.PAGE.DETAIL then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_detail.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif slot1 == ShipViewConst.PAGE.INTENSIFY then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_intensify.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif slot1 == ShipViewConst.PAGE.UPGRADE then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_upgrate.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	elseif slot1 == ShipViewConst.PAGE.FASHION then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_fashion.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_shipinfo_maxlevel.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end
end

slot0.showAwakenCompleteAni = function (slot0, slot1)
	function slot2()
		slot0.awakenAni:SetActive(true)

		slot0.awakenAni.SetActive.awakenPlay = true

		onButton(onButton, slot0.awakenAni, function ()
			slot0.awakenAni:GetComponent("Animator"):SetBool("endFlag", true)
		end)

		slot0 = tf(slot0.awakenAni)

		pg.UIMgr.GetInstance().BlurPanel(slot1, slot0)
		setText(slot0:findTF("window/desc", slot0.awakenAni), setText)
		slot0:GetComponent("DftAniEvent"):SetEndEvent(function (slot0)
			slot0.awakenAni:GetComponent("Animator"):SetBool("endFlag", false)
			pg.UIMgr.GetInstance():UnblurPanel(pg.UIMgr.GetInstance().UnblurPanel, slot0.common)
			slot0.awakenAni:SetActive(false)

			slot0.awakenPlay = false
		end)
	end

	if slot0.findTF(slot0, "AwakenCompleteWindows(Clone)") then
		slot0.awakenAni = go(slot3)
	end

	if not slot0.awakenAni then
		PoolMgr.GetInstance():GetUI("AwakenCompleteWindows", true, function (slot0)
			slot0:SetActive(true)

			slot0.awakenAni = slot0

			slot0()
		end)
	else
		slot2()
	end
end

slot0.updatePreference = function (slot0, slot1)
	setScrollText(slot0.shipName:Find("nameRect/name_mask/Text"), slot3)
	setText(slot0:findTF("english_name", slot0.shipName), slot1:getConfigTable().english_name)
	setActive(slot0.nameEditFlag, slot1.propose and not slot1:IsXIdol())

	if not GetSpriteFromAtlas("energy", slot1:getEnergyPrint()) then
		warning("找不到疲劳")
	end

	setImageSprite(slot0.energyTF, slot4, true)
	setActive(slot0.energyTF, true)
	removeAllChildren(slot5)

	slot6 = slot1:getStar()

	for slot11 = 1, slot1:getMaxStar(), 1 do
		setActive(cloneTplTo(slot0.shipInfoStarTpl, slot5, "star_" .. slot11):Find("star_tpl"), slot11 <= slot6)
		setActive(slot12:Find("empty_star_tpl"), true)
	end

	if ShipViewConst.currentPage ~= ShipViewConst.PAGE.FASHION then
		slot0:loadPainting(slot0.shipVO:getPainting())
		slot0:loadSkinBg(slot0.shipVO:rarity2bgPrintForGet(), slot0.shipVO:isBluePrintShip(), slot0.shipVO:isMetaShip(), slot0.isSpBg)
	end

	if not GetSpriteFromAtlas("shiptype", slot1:getShipType()) then
		warning("找不到船形, shipConfigId: " .. slot1.configId)
	end

	setImageSprite(slot0:findTF("type", slot0.shipName), slot8, true)
end

slot0.doUpgradeMaxLeveAnim = function (slot0, slot1, slot2, slot3)
	slot0.inUpgradeAnim = true

	slot0.shipDetailView:DoLeveUpAnim(slot1, slot2, function ()
		if slot0 then
			slot0()
		end

		slot1.inUpgradeAnim = nil
	end)
end

slot0.addRingDragListenter = function (slot0)
	slot1 = GetOrAddComponent(slot0._tf, "EventTriggerListener")
	slot2 = nil
	slot3 = 0
	slot4 = nil

	slot1:AddBeginDragFunc(function ()
		slot0 = 0
		slot1 = nil
	end)
	slot1.AddDragFunc(slot1, function (slot0, slot1)
		if not slot0.inPaintingView then
			slot2 = slot1.position

			if not slot1 then
				slot1 = slot2
			end

			slot2 = slot2.x - slot1.x
		end
	end)
	slot1.AddDragEndFunc(slot1, function (slot0, slot1)
		if not slot0.inPaintingView then
			if slot1 < -50 then
				if not slot0.isLoading then
					slot0:emit(ShipMainMediator.NEXTSHIP, -1)
				end
			elseif slot1 > 50 and not slot0.isLoading then
				slot0:emit(ShipMainMediator.NEXTSHIP)
			end
		end
	end)
end

slot0.showEnergyDesc = function (slot0)
	if slot0.energyTimer then
		return
	end

	setActive(slot0.energyDescTF, true)

	slot1, slot6 = slot0.shipVO:getEnergyPrint()

	setText(slot0.energyText, i18n(slot2))

	slot0.energyTimer = Timer.New(function ()
		setActive(slot0.energyDescTF, false)
		setActive.energyTimer:Stop()

		setActive.energyTimer.Stop.energyTimer = nil
	end, 2, 1)

	slot0.energyTimer.Start(slot3)
end

slot0.displayShipWord = function (slot0, slot1, slot2)
	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT or ShipViewConst.currentPage == ShipViewConst.PAGE.UPGRADE then
		rtf(slot0.chat).localScale = Vector3.New(0, 0, 1)

		return
	end

	if slot2 or not slot0.chatFlag then
		slot0.chatFlag = true
		slot0.chat.localScale = Vector3.zero

		setActive(slot0.chat, true)

		slot0.chat.localPosition = Vector3(slot0.character.localPosition.x + 100, slot0.chat.localPosition.y, 0)
		slot3 = slot0.shipVO:getCVIntimacy()

		slot0.chat:SetAsLastSibling()

		if findTF(slot0.nowPainting, "fitter").childCount > 0 then
			ShipExpressionHelper.SetExpression(findTF(slot0.nowPainting, "fitter"):GetChild(0), slot0.paintingCode, slot1, slot3)
		end

		slot4, slot5, slot6 = ShipWordHelper.GetWordAndCV(slot0.shipVO.skinId, slot1, nil, nil, slot3)
		slot7 = slot0.chatText:GetComponent(typeof(Text))

		if PLATFORM_CODE ~= PLATFORM_US then
			setText(slot0.chatText, SwitchSpecialChar(slot6))
		else
			slot7.fontSize = slot0.initfontSize

			setTextEN(slot0.chatText, slot6)

			while slot0.initChatTextH < slot7.preferredHeight do
				slot7.fontSize = slot7.fontSize - 2

				setTextEN(slot0.chatText, slot6)

				if slot7.fontSize < 20 then
					break
				end
			end
		end

		if CHAT_POP_STR_LEN < #slot7.text then
			slot7.alignment = TextAnchor.MiddleLeft
		else
			slot7.alignment = TextAnchor.MiddleCenter
		end

		if slot0.initChatBgH < slot7.preferredHeight + 120 then
			slot0.chatBg.sizeDelta = Vector2.New(slot0.chatBg.sizeDelta.x, slot8)
		else
			slot0.chatBg.sizeDelta = Vector2.New(slot0.chatBg.sizeDelta.x, slot0.initChatBgH)
		end

		slot9 = slot0

		function slot10()
			if slot0.chatFlag then
				if slot0.chatani1Id then
					LeanTween.cancel(slot0.chatani1Id)
				end

				if slot0.chatani2Id then
					LeanTween.cancel(slot0.chatani2Id)
				end
			end

			slot0.chatani1Id = LeanTween.scale(rtf(slot0.chat.gameObject), Vector3.New(1, 1, 1), LeanTween.scale):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function ()
				slot0.chatani2Id = LeanTween.scale(rtf(slot0.chat.gameObject), Vector3.New(0, 0, 1), LeanTween.scale):setEase(LeanTweenType.easeInBack):setDelay(slot1 + LeanTween.scale(rtf(slot0.chat.gameObject), Vector3.New(0, 0, 1), LeanTween.scale).setEase(LeanTweenType.easeInBack)):setOnComplete(System.Action(function ()
					slot0.chatFlag = nil
				end)).uniqueId
			end)).uniqueId
		end

		if slot5 then
			slot0.StopPreVoice(slot0)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot5, function (slot0)
				slot0 = slot0 and slot0:GetLength() * 0.001

				slot1()
			end)

			slot0.preVoiceContent = slot5
		else
			slot10()
		end
	end
end

slot0.StopPreVoice = function (slot0)
	if slot0.preVoiceContent ~= nil then
		pg.CriMgr:UnloadSoundEffect_V3(slot0.preVoiceContent)
	end
end

slot0.startChatTimer = function (slot0)
	if slot0.chatFlag then
		return
	end

	if slot0.chatTimer then
		slot0.chatTimer:Stop()

		slot0.chatTimer = nil
	end

	slot0.chatTimer = Timer.New(function ()
		slot0:displayShipWord(slot0:getInitmacyWords())
	end, slot0, 1)

	slot0.chatTimer.Start(slot1)
end

slot0.hideShipWord = function (slot0)
	if slot0.chatFlag then
		if slot0.chatani1Id then
			LeanTween.cancel(slot0.chatani1Id)
		end

		if slot0.chatani2Id then
			LeanTween.cancel(slot0.chatani2Id)
		end

		LeanTween.scale(rtf(slot0.chat.gameObject), Vector3.New(0, 0, 1), slot0):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function ()
			slot0.chatFlag = nil
		end))
	end

	slot0.StopPreVoice(slot0)
end

slot0.gotoPage = function (slot0, slot1)
	if slot1 == ShipViewConst.PAGE.FASHION then
		slot0:switchToPage(slot1)
	else
		triggerToggle(slot0.togglesList[slot1], true)
	end
end

slot0.switchToPage = function (slot0, slot1, slot2)
	function slot3(slot0, slot1)
		setActive(slot0.detailContainer, false)

		if slot0 == ShipViewConst.PAGE.DETAIL then
			setActive(slot0.detailContainer, slot1)
			shiftPanel(slot0.detailContainer, (slot1 and {
				slot0.detailContainer.rect.width + 200,
				0
			}) or {
				0,
				slot0.detailContainer.rect.width + 200
			}[2], 0, slot1, 0):setFrom((slot1 and ) or [1])
		elseif slot0 == ShipViewConst.PAGE.EQUIPMENT then
			shiftPanel(slot0.equipLCon, (slot1 and {
				-(slot0.equipLCon.rect.width + 190),
				190
			}) or {
				190,
				-(slot0.equipLCon.rect.width + 190)
			}[2], 0, slot1, 0):setFrom((slot1 and ) or [1])
			shiftPanel(slot0.equipRCon, (slot1 and {
				slot0.equipRCon.rect.width,
				10
			}) or {
				10,
				slot0.equipRCon.rect.width
			}[2], 0, slot1, 0):setFrom((slot1 and ) or [1])
		elseif slot0 == ShipViewConst.PAGE.FASHION then
			shiftPanel(slot0.fashionContainer, (slot1 and {
				slot0.fashionContainer.rect.width + 150,
				0
			}) or {
				0,
				slot0.fashionContainer.rect.width + 150
			}[2], 0, slot1, 0):setFrom((slot1 and ) or [1])
			slot0.shipFashionView:ActionInvoke("UpdateFashion")
		elseif slot0 == ShipViewConst.PAGE.INTENSIFY then
			if slot1 then
				slot0:emit(ShipMainMediator.OPEN_INTENSIFY)
			else
				slot0:emit(ShipMainMediator.CLOSE_INTENSIFY)
			end
		elseif slot0 == ShipViewConst.PAGE.UPGRADE then
			if slot1 then
				slot0:emit(ShipMainMediator.ON_UPGRADE)
			else
				slot0:emit(ShipMainMediator.CLOSE_UPGRADE)
			end
		elseif slot0 == ShipViewConst.PAGE.REMOULD then
			if slot1 then
				slot0:emit(ShipMainMediator.OPEN_REMOULD)
			else
				slot0:emit(ShipMainMediator.CLOSE_REMOULD)
			end
		end

		slot0:blurPage(slot0, slot1)

		if slot0 ~= ShipViewConst.PAGE.FASHION then
			slot0.fashionSkinId = slot0.shipVO.skinId

			slot0:loadPainting(slot0.shipVO:getPainting())
		end

		slot2 = not ShipViewConst.IsSubLayerPage(slot0)

		if slot0.bgEffect[slot0.shipVO:getRarity()] then
			setActive(slot3, slot0 ~= ShipViewConst.PAGE.REMOULD and slot0.shipVO.bluePrintFlag and slot0.shipVO.bluePrintFlag == 0)
		end

		setActive(slot0.helpBtn, slot2)
	end

	function switchHandler()
		if slot0 == ShipViewConst.currentPage and slot1 then
			slot2(slot2, true)
		elseif slot0 ~= ShipViewConst.currentPage then
			if ShipViewConst.currentPage then
				slot2(ShipViewConst.currentPage, false)
			end

			ShipViewConst.currentPage = ShipViewConst
			slot3.contextData.page = slot3.contextData

			slot2(slot2, true)
			slot3:switchPainting()
		end
	end

	if slot0.viewList[slot1] ~= nil then
		if not slot0.viewList[slot1].GetLoaded(slot4) then
			slot4:Load()
			slot4:CallbackInvoke(switchHandler)
		else
			switchHandler()
		end
	else
		switchHandler()
	end
end

slot0.blurPage = function (slot0, slot1, slot2)
	slot3 = pg.UIMgr.GetInstance()

	if slot1 == ShipViewConst.PAGE.DETAIL then
		slot0.shipDetailView:ActionInvoke("OnSelected", slot2)
	elseif slot1 == ShipViewConst.PAGE.EQUIPMENT then
		slot0.shipEquipView:ActionInvoke("OnSelected", slot2)
	elseif slot1 == ShipViewConst.PAGE.FASHION then
		slot0.shipFashionView:ActionInvoke("OnSelected", slot2)
	elseif slot1 == ShipViewConst.PAGE.INTENSIFY then
	elseif slot1 == ShipViewConst.PAGE.UPGRADE then
	elseif slot1 == ShipViewConst.PAGE.REMOULD then
	end
end

slot0.switchPainting = function (slot0)
	setActive(slot0.shipInfo, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
	setActive(slot0.shipName, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))

	if ShipViewConst.currentPage == ShipViewConst.PAGE.EQUIPMENT then
		shiftPanel(slot0.shipInfo, -20, 0, slot0, 0)

		slot0.paintingFrameName = "zhuangbei"
	else
		shiftPanel(slot0.shipInfo, -460, 0, slot0, 0)

		slot0.paintingFrameName = "chuanwu"
	end

	slot1 = GetOrAddComponent(findTF(slot0.nowPainting, "fitter"), "PaintingScaler")

	slot1:Snapshoot()

	slot1.FrameName = slot0.paintingFrameName
	slot2 = LeanTween.value(go(slot0.nowPainting), 0, 1, slot0):setOnUpdate(System.Action_float(function (slot0)
		slot0.Tween = slot0
		slot0.chat.localPosition = Vector3(slot1.character.localPosition.x + 100, slot1.chat.localPosition.y, 0)
	end)).setEase(slot2, LeanTweenType.easeInOutSine)
end

slot0.setPreOrNext = function (slot0, slot1, slot2)
	if slot1 then
		slot0.isRight = true
	else
		slot0.isRight = false
	end

	if slot0.shipVO:getGroupId() ~= slot2:getGroupId() then
		slot0.switchCnt = (slot0.switchCnt or 0) + 1
	end

	if slot0.switchCnt and slot0.switchCnt >= 10 then
		gcAll()

		slot0.switchCnt = 0
	end
end

slot0.loadPainting = function (slot0, slot1, slot2)
	if slot0.isLoading == true then
		return
	end

	for slot6, slot7 in pairs(slot0.tablePainting) do
		slot7.localScale = Vector3(1, 1, 1)
	end

	if slot0.LoadShipVOId and not slot2 and slot0.LoadShipVOId == slot0.shipVO.id and slot0.LoadPaintingCode == slot1 and not slot2 then
		return
	end

	slot3 = 0
	slot3 = (slot0.isRight and 1800) or -1800
	slot0.isLoading = true
	slot5 = slot0.paintingCode
	slot6 = {}

	if slot0:getPaintingFromTable(false) then
		table.insert(slot6, function (slot0)
			LeanTween.cancel(go(slot2))
			LeanTween.alphaCanvas(slot2, 0, 0.3):setFrom(1):setUseEstimatedTime(true)
			LeanTween.moveX(slot1, -slot1, 0.3):setFrom(0):setOnComplete(System.Action(function ()
				retPaintingPrefab(retPaintingPrefab, )
				retPaintingPrefab()
			end))
		end)
	end

	slot7 = slot0.getPaintingFromTable(slot0, true)
	slot0.paintingCode = slot1

	if slot0.paintingCode and slot7 then
		slot8 = slot7:GetComponent(typeof(RectTransform))

		table.insert(slot6, function (slot0)
			slot0.nowPainting = slot0

			slot1(setPaintingPrefabAsync, slot0.paintingCode, slot0.paintingFrameName or "chuanwu", function ()
				ShipExpressionHelper.SetExpression(findTF(slot0, "fitter"):GetChild(0), slot1.paintingCode)
				slot1.paintingCode()
			end)
		end)
		table.insert(slot6, function (slot0)
			LeanTween.cancel(go(slot0))
			LeanTween.moveX(slot0, 0, 0.3):setFrom(LeanTween.moveX(slot0, 0, 0.3).setFrom):setOnComplete(System.Action(slot0))
			LeanTween.alphaCanvas(slot1, 1, 0.3):setFrom(0):setUseEstimatedTime(true)
		end)
	end

	parallelAsync(slot6, function ()
		slot0.LoadShipVOId = slot0.shipVO.id
		slot0.LoadPaintingCode = slot0.shipVO.id
		slot0.isLoading = false
	end)
end

slot0.getPaintingFromTable = function (slot0, slot1)
	if slot0.tablePainting == nil then
		print("self.tablePainting为空")

		return
	end

	for slot5 = 1, #slot0.tablePainting, 1 do
		if findTF(slot0.tablePainting[slot5], "fitter").childCount == 0 then
			if slot1 == true and slot0.tablePainting[slot5] then
				return slot0.tablePainting[slot5]
			end
		elseif slot1 == false and slot0.tablePainting[slot5] then
			return slot0.tablePainting[slot5]
		end
	end
end

slot0.loadSkinBg = function (slot0, slot1, slot2, slot3, slot4)
	if not slot0.bgEffect then
		slot0.bgEffect = {}
	end

	if slot0.shipSkinBg ~= slot1 or slot0.isDesign ~= slot2 or slot0.isMeta ~= slot3 then
		slot0.shipSkinBg = slot1
		slot0.isDesign = slot2
		slot0.isMeta = slot3

		if slot0.isDesign then
			if slot0.metaBg then
				setActive(slot0.metaBg, false)
			end

			if slot0.bgEffect then
				for slot8, slot9 in pairs(slot0.bgEffect) do
					setActive(slot9, false)
				end
			end

			if slot0.designBg and slot0.designName ~= "raritydesign" .. slot0.shipVO:getRarity() then
				PoolMgr.GetInstance():ReturnUI(slot0.designName, slot0.designBg)

				slot0.designBg = nil
			end

			if not slot0.designBg then
				PoolMgr.GetInstance():GetUI("raritydesign" .. slot0.shipVO:getRarity(), true, function (slot0)
					slot0.designBg = slot0
					slot0.designName = "raritydesign" .. slot0.shipVO:getRarity()

					slot0.transform:SetParent(slot0._tf, false)

					slot0.transform.localPosition = Vector3(1, 1, 1)
					slot0.transform.localScale = Vector3(1, 1, 1)

					slot0.transform:SetSiblingIndex(1)
					setActive(slot0, true)
				end)
			else
				setActive(slot0.designBg, true)
			end
		elseif slot0.isMeta then
			if slot0.designBg then
				setActive(slot0.designBg, false)
			end

			if slot0.metaBg and slot0.metaName ~= "raritymeta" .. slot0.shipVO.getRarity(slot7) then
				PoolMgr.GetInstance():ReturnUI(slot0.metaName, slot0.metaBg)

				slot0.metaBg = nil
			end

			if not slot0.metaBg then
				PoolMgr.GetInstance():GetUI("raritymeta" .. slot0.shipVO:getRarity(), true, function (slot0)
					slot0.metaBg = slot0
					slot0.metaName = "raritymeta" .. slot0.shipVO:getRarity()

					slot0.transform:SetParent(slot0._tf, false)

					slot0.transform.localPosition = Vector3(1, 1, 1)
					slot0.transform.localScale = Vector3(1, 1, 1)

					slot0.transform:SetSiblingIndex(1)
					setActive(slot0, true)
				end)
			else
				setActive(slot0.metaBg, true)
			end
		else
			if slot0.designBg then
				setActive(slot0.designBg, false)
			end

			if slot0.metaBg then
				setActive(slot0.metaBg, false)
			end

			for slot8 = 1, 5, 1 do
				slot9 = slot0.shipVO.getRarity(slot9)

				if slot0.bgEffect[slot8] then
					setActive(slot0.bgEffect[slot8], slot8 == slot9 and ShipViewConst.currentPage ~= ShipViewConst.PAGE.REMOULD and not slot4)
				elseif slot9 > 2 and slot9 == slot8 and not slot4 then
					PoolMgr.GetInstance():GetUI("al_bg02_" .. slot9 - 1, true, function (slot0)
						slot0.bgEffect[] = slot0

						slot0.transform:SetParent(slot0._tf, false)

						slot0.transform.localPosition = Vector3(0, 0, 0)
						slot0.transform.localScale = Vector3(1, 1, 1)

						slot0.transform:SetSiblingIndex(1)
						setActive(slot0, not ShipViewConst.IsSubLayerPage(ShipViewConst.currentPage))
					end)
				end
			end
		end

		GetSpriteFromAtlasAsync("bg/star_level_bg_" .. slot1, "", function (slot0)
			if not slot0.exited and slot0.shipSkinBg ==  then
				setImageSprite(slot0.background, slot0)
			end
		end)
	end
end

slot0.getInitmacyWords = function (slot0)
	return "feeling" .. Mathf.Clamp(slot0.shipVO:getIntimacyLevel(), 1, 5)
end

slot0.paintView = function (slot0)
	slot0.character:GetComponent("Image").enabled = false
	slot0.inPaintingView = true
	slot1 = {}
	slot2 = slot0._tf.childCount
	slot3 = 0

	while slot2 > slot3 do
		if slot0._tf:GetChild(slot3).gameObject.activeSelf and slot4 ~= slot0.main and slot4 ~= slot0.background then
			slot1[#slot1 + 1] = slot4

			setActive(slot4, false)
		end

		slot3 = slot3 + 1
	end

	slot2 = slot0.main.childCount
	slot3 = 0

	while slot2 > slot3 do
		if slot0.main:GetChild(slot3).gameObject.activeSelf and slot4 ~= slot0.shipInfo then
			slot1[#slot1 + 1] = slot4

			setActive(slot4, false)
		end

		slot3 = slot3 + 1
	end

	for slot8 = 1, tf(pg.UIMgr.GetInstance().OverlayMain).childCount, 1 do
		if slot4:GetChild(slot8 - 1).gameObject.activeSelf then
			slot1[#slot1 + 1] = slot9

			setActive(slot9, false)
		end
	end

	slot1[#slot1 + 1] = slot0.chat

	openPortrait()
	setActive(slot0.common, false)

	slot0.mainMask.enabled = false

	slot0.mainMask:PerformClipping()

	slot6 = slot0.nowPainting.anchoredPosition.x
	slot7 = slot0.nowPainting.anchoredPosition.y
	slot10 = slot0._tf.rect.width / UnityEngine.Screen.width
	slot11 = slot0._tf.rect.height / UnityEngine.Screen.height
	slot12 = slot0.nowPainting.rect.width / 2
	slot13 = slot0.nowPainting.rect.height / 2
	slot14, slot15 = nil

	GetOrAddComponent(slot0.background, "MultiTouchZoom").SetZoomTarget(slot16, slot0.nowPainting)

	slot17 = GetOrAddComponent(slot0.background, "EventTriggerListener")
	slot18 = true
	slot19 = false

	slot17:AddPointDownFunc(function (slot0)
		if Input.touchCount == 1 or Application.isEditor then
			slot0 = true
			slot1 = true
		elseif Input.touchCount >= 2 then
			slot1 = false
			slot0 = false
		end
	end)
	slot17.AddPointUpFunc(slot17, function (slot0)
		if Input.touchCount <= 2 then
			slot0 = true
		end
	end)
	slot17.AddBeginDragFunc(slot17, function (slot0, slot1)
		slot0 = false
		slot5 = slot1.position.x *  - slot1.position.x - tf(slot4.nowPainting).localPosition.x.position.y * slot6 - slot7 - tf(slot4.nowPainting.nowPainting).localPosition.y
	end)
	slot17.AddDragFunc(slot17, function (slot0, slot1)
		if slot0 then
			tf(slot1.nowPainting).localPosition = Vector3(slot1.position.x * slot2 - slot3 - slot4, slot1.position.y * slot5 -  - slot1.position.y * slot5, -22)
		end
	end)
	onButton(slot0, slot0.background, function ()
		slot0:hidePaintView()
	end, SFX_CANCEL)

	slot0.hidePaintView = function (slot0, slot1)
		if not slot1 and not slot0 then
			return
		end

		slot0.character:GetComponent("Image").enabled = true
		Input.multiTouchEnabled = false

		setActive(slot0.common, true)
		SwitchPanel(slot0.shipInfo, -460, nil, slot1 * 2)

		SwitchPanel.enabled = false
		false.enabled = false

		for slot5, slot6 in ipairs(slot4) do
			setActive(slot6, true)
		end

		closePortrait()

		slot0.nowPainting.localScale = Vector3(1, 1, 1)

		setAnchoredPosition(slot0.nowPainting, {
			x = 1,
			y = 1
		})

		slot0.background:GetComponent("Button").enabled = false
		slot0.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = true
		slot0.mainMask.enabled = true

		slot0.mainMask:PerformClipping()

		slot0.inPaintingView = false
	end

	SwitchPanel(slot0.shipInfo, slot2, nil, slot1 * 2).setOnComplete(slot20, System.Action(function ()
		slot0.enabled = true
		true.enabled = true
		slot2.background:GetComponent("Button").enabled = true
		slot2.nowPainting:GetComponent("CanvasGroup").blocksRaycasts = false
	end))
end

slot0.onBackPressed = function (slot0)
	if slot0.inUpgradeAnim then
		return
	end

	if slot0.awakenPlay then
		return
	end

	if slot0.shipChangeNameView.isOpenRenamePanel then
		slot0.shipChangeNameView:ActionInvoke("DisplayRenamePanel", false)

		return
	end

	if slot0.shipCustomMsgBox.isShowCustomMsgBox then
		slot0.shipCustomMsgBox:ActionInvoke("hideCustomMsgBox")

		return
	end

	if slot0.shipHuntingRangeView.onSelected then
		slot0.shipHuntingRangeView:ActionInvoke("HideHuntingRange")

		return
	end

	if slot0.inPaintingView then
		slot0:hidePaintView(true)

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(slot0:findTF("top/back_btn", slot0.common))
end

slot0.willExit = function (slot0)
	Input.multiTouchEnabled = true

	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.chat, slot0.character)
	slot0:blurPage(ShipViewConst.currentPage)
	setActive(slot0.background, false)

	if slot0.designBg then
		PoolMgr.GetInstance():ReturnUI(slot0.designName, slot0.designBg)
	end

	if slot0.metaBg then
		PoolMgr.GetInstance():ReturnUI(slot0.metaName, slot0.metaBg)
	end

	slot0.intensifyToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	slot0.upgradeToggle:GetComponent("Toggle").onValueChanged:RemoveAllListeners()
	LeanTween.cancel(slot0.chat.gameObject)

	if slot0.paintingCode then
		for slot4 = 1, #slot0.tablePainting, 1 do
			if LeanTween.isTweening(go(slot0.tablePainting[slot4])) then
				LeanTween.cancel(go(slot5))
			end
		end

		retPaintingPrefab(slot0.nowPainting, slot0.paintingCode)
	end

	slot0.shipDetailView:Destroy()
	slot0.shipFashionView:Destroy()
	slot0.shipEquipView:Destroy()
	slot0.shipHuntingRangeView:Destroy()
	slot0.shipCustomMsgBox:Destroy()
	slot0.shipChangeNameView:Destroy()
	clearImageSprite(slot0.background)

	if slot0.energyTimer then
		slot0.energyTimer:Stop()

		slot0.energyTimer = nil
	end

	if slot0.chatTimer then
		slot0.chatTimer:Stop()

		slot0.chatTimer = nil
	end

	slot0:StopPreVoice()
	cameraPaintViewAdjust(false)

	if slot0.tweens then
		cancelTweens(slot0.tweens)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.blurPanel, slot0._tf)

	slot0.shareData = nil
end

return slot0

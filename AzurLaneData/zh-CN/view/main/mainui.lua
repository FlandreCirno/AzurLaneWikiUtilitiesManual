slot0 = class("MainUI", import("..base.BaseUI"))
slot1 = Mathf
slot0.EJECT_DURATION = 0.5
slot0.EJECT_DURATION_ENTER = 0.4
slot0.DIRECTION_RIGHT = 1
slot0.DIRECTION_DOWN = 2
slot0.DIRECTION_LEFT = 3
slot0.DIRECTION_UP = 4
slot0.DIRECTION_DOWN_RIGHT = 5
slot0.DIRECTION_UP_LEFT = 6
slot0.REVERT_VERTICAL = -1
slot0.REVERT_HERIZONTAL = -2
slot0.REVERT_HERIZONTAL_VERTICAL = -3
slot0.STATE_MAIN = 1
slot0.STATE_SECONDARY = 2
slot0.STATE_ALL_HIDE = 3
slot0.TOUCH_HEIGHT = 20
slot0.TOUCH_LOOP = 1
slot0.TOUCH_DURATION = 0.1
slot0.BREATH_HEIGHT = -20
slot0.DEFAULT_HEIGHT = -10
slot0.BREATH_DURATION = 2.3
slot0.CHAT_HEIGHT = 15
slot0.CHAT_DURATION = 0.3
slot0.PAINT_DEFAULT_POS_X = -600
slot0.CHAT_SHOW_TIME = 3
slot0.CHAT_INTERVAL = 30
slot0.CHAT_ANIMATION_TIME = 0.3
slot0.BASE_TIME_INFO = {
	{
		{
			0,
			5
		},
		"bg_main_night"
	},
	{
		{
			5,
			8
		},
		"bg_main_twilight"
	},
	{
		{
			8,
			16
		},
		"bg_main_day"
	},
	{
		{
			16,
			19
		},
		"bg_main_twilight"
	},
	{
		{
			19,
			24
		},
		"bg_main_night"
	}
}
slot0.BUFFTEXT_SHOW_TIME = 7
slot2 = nil
slot3 = pg.ship_spine_shift

slot0.getUIName = function (slot0)
	return "MainUI"
end

slot0.getDiffTimeInfo = function (slot0)
	slot1 = slot0.BASE_TIME_INFO

	if checkExist(getProxy(ActivityProxy):getActivityById(pg.gameset.dayandnight_bgm.key_value), {
		"isEnd"
	}) == false then
		slot1 = pg.gameset.dayandnight_bgm.description
	end

	slot2 = pg.TimeMgr.GetInstance():GetServerHour()

	for slot6, slot7 in ipairs(slot1) do
		if slot7[1][1] <= slot2 and slot2 < slot8[2] then
			return slot7
		end
	end
end

slot0.getBGM = function (slot0)
	if slot0:getCurrentFlagship():IsBgmSkin() and getProxy(SettingsProxy):IsBGMEnable() then
		return slot1:GetSkinBgm()
	end

	return slot0:getDiffTimeInfo()[3] or slot0.super.getBGM(slot0)
end

slot0.getCurrentFlagship = function (slot0)
	return getProxy(BayProxy):getShipById(getProxy(PlayerProxy).getData(slot1).characters[getProxy(SettingsProxy):getCurrentSecretaryIndex()] or slot2.character)
end

slot0.setShips = function (slot0, slot1)
	slot0.ships = slot1
end

slot0.setBG = function (slot0)
	PoolMgr.GetInstance():GetSprite("commonbg/" .. slot0:getDiffTimeInfo()[2], "", false, function (slot0)
		slot0.bgLoading = false

		slot0:setChangeBtnInteractable()
		setImageSprite(slot0._bg:Find("bg"), slot0)
	end)
end

slot0.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot1 = pg.AssistantInfo
end

slot0.init = function (slot0)
	slot0.redDotHelper = MainSceneRetDotHelper.New(slot0._go)
	slot0._leftPanel = slot0:findTF("toTop/frame/leftPanel")
	slot0._hideBtn = slot0:findTF("toTop/frame/leftPanel/hideButton")
	slot0._cameraBtn = slot0:findTF("toTop/frame/leftPanel/cameraButton")
	slot0._changeBtn = slot0:findTF("toTop/frame/leftPanel/changeBtn")
	slot0._chatBtn = slot0:findTF("toTop/frame/leftPanel/chatButton")
	slot0._monthCardBtn = slot0:findTF("toTop/frame/leftPanel/monthCardButton")
	slot0._commissionBtn = slot0:findTF("toTop/frame/leftPanel/commissionButton")
	slot0._commissionBtn.localPosition = Vector3(0, slot0._commissionBtn.localPosition.y, 0)
	slot0._wordBtn = slot0:findTF("toTop/frame/leftPanel/wordBtn")
	slot0._wordBtnOpen = slot0:findTF("toTop/frame/leftPanel/wordBtn/open")
	slot0._wordBtnClose = slot0:findTF("toTop/frame/leftPanel/wordBtn/close")
	slot0._rightPanel = slot0:findTF("toTop/frame/rightPanel")
	slot0._combatBtn = slot0:findTF("toTop/frame/rightPanel/eventPanel/combatBtn")
	slot0._formationBtn = slot0:findTF("toTop/frame/rightPanel/eventPanel/formationButton")
	slot0._rightTopPanel = slot0:findTF("toTop/frame/rightTopPanel")
	slot0._friendBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/friendButton")
	slot0._mailBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/mailButton")
	slot0._noticeBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/noticeButton")
	slot0._settingBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/settingButton")
	slot0._rankBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/rankButton")
	slot0._collectionBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/collectionButton")
	slot0._memoryBtn = slot0:findTF("toTop/frame/rightTopPanel/bg/btnsArea/memoryButton")
	slot0._monopolyBtn = slot0:findTF("rightPanel/linkBtns/monopoly_btn")
	slot0._blackWhitBtn = slot0:findTF("rightPanel/linkBtns/blackwhite_btn")
	slot0._memoryBookBtn = slot0:findTF("rightPanel/linkBtns/memorybook_btn")
	slot0._ActivityBtns = slot0:findTF("linkBtns", slot0._rightPanel)
	slot0._ActivityBtnTpl = slot0:findTF("buttonTpl", slot0._rightPanel)
	rtf(slot0._ActivityBtnTpl).anchoredPosition = Vector2.zero
	slot0._bottomPanel = slot0:findTF("toTop/frame/bottomPanel")
	slot0._dockBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/dockBtn")
	slot0._equipBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/equipButton")
	slot0._phonyui = slot0:findTF("toTop/frame/phonyui")
	slot0._settingBottom = slot0:findTF("toTop/frame/settingBottom")
	slot0._moveBtn = slot0:findTF("toTop/frame/settingBottom/move")
	slot0._setBtn = slot0:findTF("toTop/frame/settingBottom/set")
	slot0._setOn = slot0:findTF("toTop/frame/settingBottom/set/on")
	slot0._setOff = slot0:findTF("toTop/frame/settingBottom/set/off")
	slot0._moveOn = slot0:findTF("toTop/frame/settingBottom/move/on")
	slot0._moveOff = slot0:findTF("toTop/frame/settingBottom/move/off")
	slot0._settingRight = slot0:findTF("toTop/frame/settingRight")
	slot0._resetBtn = slot0:findTF("toTop/frame/settingRight/reset")
	slot0._saveBtn = slot0:findTF("toTop/frame/settingRight/save")
	slot0._backBtn = slot0:findTF("toTop/frame/settingRight/back")
	slot0._voteBtn = slot0:findTF("vote_btn", slot0._ActivityBtns)
	slot0._voteBookBtn = slot0:findTF("btm/vote_book_btn", slot0._bottomPanel)
	slot0._buildBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/buildButton")
	slot0._taskBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/taskButton")
	slot0._guildButton = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/guildButton")
	slot0._mallBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/mallBtn")
	slot0._mallSellTag = slot0:findTF("SellTag", slot0._mallBtn)
	slot0._skinSellTag = slot0:findTF("skinTag", slot0._mallBtn)
	slot0._montgcardTag = slot0:findTF("MonthcardTag", slot0._mallBtn)
	slot0._liveBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/liveButton")
	slot0._technologyBtn = slot0:findTF("toTop/frame/bottomPanel/btm/buttons_container/technologyButton")
	slot0._bottomBlur = slot0._bottomPanel:Find("btm")
	slot0._rightTopBlur = slot0._rightTopPanel:Find("bg")
	slot0._playerResOb = slot0:findTF("toTop/frame/playerRes")
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)

	slot0._commanderPanel = slot0:findTF("toTop/frame/commanderPanel")
	slot0._commanderPanelbg = slot0:findTF("toTop/top")
	slot0._commanderInfoBtn = slot0:findTF("top/iconBack", slot0._commanderPanel)
	slot0._nameLabel = slot0:findTF("top/playerInfoBg2/playerInfoBg/nameLabel", slot0._commanderPanel)
	slot0._levelLabel = slot0:findTF("top/playerInfoBg2/playerInfoBg/levelLabel", slot0._commanderPanel)
	slot0._expBar = slot0:findTF("top/playerInfoBg2/playerInfoBg/expArea", slot0._commanderPanel):GetComponent(typeof(Slider))
	slot0._icon = slot0:findTF("top/iconBack/icon", slot0._commanderPanel)
	slot0._buffList = slot0:findTF("buffList", slot0._commanderPanel)
	slot0._buffTpl = slot0:findTF("buff", slot0._buffList)
	slot0._buffText = slot0:findTF("buffText", slot0._commanderPanel)
	slot0._linkBtns = slot0:findTF("link_btns", slot0._commanderPanel)
	slot0.traingCampBtn = slot0:findTF("traningcamp", slot0._linkBtns)
	slot0.refluxBtn = slot0:findTF("return", slot0._linkBtns)
	slot0.exSkinBtn = slot0:findTF("ex_skin_btn", slot0._commanderPanel)

	setActive(slot0.exSkinBtn, false)
	setActive(slot0._buffText, false)

	slot0._btmbg = slot0:findTF("toTop/btm")
	slot0._paintingTF = slot0:findTF("paint")
	slot0._paintingBgTf = slot0:findTF("paintBg")
	slot0._paintingContainer = slot0:findTF("paint/fitter")
	slot0._chatTextBg = slot0:findTF("chat/chatbgtop")
	slot0._chatText = slot0:findTF("chat/Text")
	slot0._chat = slot0:findTF("chat")
	slot0.initChatBgH = slot0._chatTextBg.sizeDelta.y
	slot0.effectTF = slot0:findTF("effect", slot0._paintingTF)
	slot0._chatBg = slot0:findTF("chatPreview", slot0._rightPanel)
	slot0._chatEmptySign = slot0:findTF("EmptySign", slot0._chatBg)

	setActive(slot0._chatEmptySign, false)

	slot0._chatList = slot0:findTF("list", slot0._chatBg)
	slot0._chatItem = slot0:findTF("item", slot0._chatBg).gameObject

	slot0._chatItem:SetActive(false)

	slot0._chatActBtn = slot0:findTF("ActivityBtn", slot0._chatBg)
	slot0._chatActBtnDisable = slot0:findTF("ActivityBtnDisable", slot0._chatBg)
	slot0.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

	setActive(slot0._chatActBtn, slot0.hideChatFlag)
	setActive(slot0._chatActBtnDisable, not slot0.hideChatFlag)

	if LOCK_HIDE_CHAT then
		SetActive(slot0._chatActBtn, false)
	end

	slot0._bg = slot0:findTF("Sea")
	slot0._currentState = slot0.STATE_MAIN
	slot0._chat.localScale = Vector3(0, 0)
	slot0._paintingOffset = 0
	slot0.toTopPanel = slot0:findTF("toTop")
	slot0.skinExpireDisplayPage = SkinExpireDisplayPage.New(slot0.toTopPanel, slot0.event)
	slot0.attireExpireDisplayPage = AttireExpireDisplayPage.New(slot0.toTopPanel, slot0.event)
	slot0.skinExperienceDiplayPage = SkinExperienceDiplayPage.New(slot0.toTopPanel, slot0.event)
	slot0.secondaryPage = MainUISecondaryPage.New(slot0:findTF("MainUISecondaryPanel"), slot0)
	slot0._paintingTimer = Timer.New(function ()
		slot0._paintingBgTf.localScale = slot0._paintingTF.localScale
		slot0._paintingBgTf._paintingBgTf.localPosition = slot0._paintingBgTf.localPosition + (slot0._paintingTF.localPosition - slot0._paintingBgTf.localPosition) * 0.6
	end, 0.033, -1)

	slot0._paintingTimer.Start(slot1)
	slot0._paintingTimer:Pause()
end

slot0.uiEnterAnim = function (slot0)
	slot1 = nil

	if slot0.contextData.isFromLogin or getProxy(PlayerProxy):getFlag("battle") then
		function slot1(...)
			slot0:enablePartialBlur()

			if slot0.enablePartialBlur.tempFlagShip then
				slot1.blocksRaycasts = true
			else
				slot1.blocksRaycasts = true
			end
		end

		GetOrAddComponent(slot0._tf, typeof(CanvasGroup)).blocksRaycasts = false
	else
		slot0.enablePartialBlur(slot0)
	end

	slot2 = getProxy(PlayerProxy)
	slot3 = slot2:getData()
	slot4 = getProxy(SettingsProxy):getCurrentSecretaryIndex()

	if slot2:getFlag("battle") then
		getProxy(SettingsProxy):setCurrentSecretaryIndex(math.random(#slot3.characters))
	end

	slot0:loadChar(slot5)

	slot0.tempFlagShip = getProxy(BayProxy):getShipById(slot3.characters[slot4])

	if slot0.tempFlagShip then
		slot0:updateFlagShip(slot0.tempFlagShip)
	end

	setAnchoredPosition(slot0._bottomPanel, Vector2(0, -128))
	setAnchoredPosition(slot0._btmbg, Vector2(0, -128))
	setAnchoredPosition(slot0._commanderPanel, Vector2(0, 141))
	setAnchoredPosition(slot0._commanderPanelbg, Vector2(0, 141))
	setAnchoredPosition(slot0._leftPanel, Vector2(-222, 0))
	setAnchoredPosition(slot0._rightPanel, Vector2(847, 0))
	setAnchoredPosition(slot0._rightTopPanel, Vector2(847, 0))
	setAnchoredPosition(slot0._playerResOb, Vector2(0, 77))
	slot0:ejectGimmick(slot0._bottomPanel, slot0.REVERT_VERTICAL, slot0.EJECT_DURATION_ENTER, nil, 0, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._btmbg, slot0.REVERT_VERTICAL, slot0.EJECT_DURATION_ENTER, nil, 0, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._playerResOb, slot0.REVERT_VERTICAL, slot0.EJECT_DURATION_ENTER, nil, 0, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._commanderPanel, slot0.REVERT_HERIZONTAL_VERTICAL, slot0.EJECT_DURATION_ENTER, nil, 0, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._commanderPanelbg, slot0.REVERT_HERIZONTAL_VERTICAL, slot0.EJECT_DURATION_ENTER, nil, 0, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._rightTopPanel, slot0.REVERT_HERIZONTAL, slot0.EJECT_DURATION_ENTER, nil, 0.1, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._rightPanel, slot0.REVERT_HERIZONTAL, slot0.EJECT_DURATION_ENTER, nil, 0.2, {
		0,
		1
	})
	slot0:ejectGimmick(slot0._leftPanel, slot0.REVERT_HERIZONTAL, slot0.EJECT_DURATION_ENTER, slot1, 0.2, {
		0,
		1
	})
end

slot0.openSecondaryPanel = function (slot0)
	slot0.secondaryPage:Show(slot0._player)
end

slot0.closeSecondaryPanel = function (slot0, slot1)
	if slot1 then
		slot0:enablePartialBlur()
	end

	if slot0.secondaryPage then
		slot0.secondaryPage:Hide()
	end
end

slot0.disablePartialBlur = function (slot0)
	if slot0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(slot0.toTopPanel, slot0._tf)
	end
end

slot0.enablePartialBlur = function (slot0)
	if slot0._tf then
		table.insert(slot1, slot0.toTopPanel:Find("frame/rightTopPanel/bg"))
		table.insert(slot1, slot0.toTopPanel:Find("frame/rightPanel/eventPanel"))
		table.insert(slot1, slot0.toTopPanel:Find("frame/rightPanel/chatPreview"))
		pg.UIMgr.GetInstance():OverlayPanelPB(slot0.toTopPanel, {
			pbList = {}
		})
	end
end

slot0.emit = function (slot0, ...)
	if slot0.event then
		slot0.event:emit(...)
	end
end

slot4, slot5 = nil

slot0.didEnter = function (slot0)
	slot0:setBG()
	setActive(slot0._phonyui, false)

	if getProxy(UserProxy).data.limitServerIds and #slot1.data.limitServerIds > 0 then
		return
	end

	onToggle(slot0, slot0._moveBtn, function (slot0)
		setActive(slot0._moveOn, slot0)
		setActive(slot0._moveOff, not slot0)

		if slot0 then
			LeanTween.cancel(go(slot0._paintingTF))

			slot0.paintMoving = true
			slot0._setBtn:GetComponent(typeof(Toggle)).interactable = false
			slot0._setBtn:Find("off"):GetComponent("Image").color = Color.New(1, 1, 1, 0.5)
			slot0._setBtn:Find("on"):GetComponent("Image").color = Color.New(1, 1, 1, 0.5)
			slot0._bg:GetComponent(typeof(Button)).enabled = false
			slot0._paintingTF:GetComponent("CanvasGroup").blocksRaycasts = false
			slot2 = slot0.flagShip.getPainting(slot1)
			slot3 = getProxy(SettingsProxy):getCharacterSetting(slot0.flagShip.id, SHIP_FLAG_L2D) and (slot2 == "biaoqiang" or slot2 == "z23" or slot2 == "lafei" or slot2 == "lingbo" or slot2 == "mingshi" or slot2 == "xuefeng")
			slot5 = slot0._paintingTF.anchoredPosition.x
			slot6 = slot0._paintingTF.anchoredPosition.y
			slot0.anchoredY = slot0._paintingTF.anchoredPosition.y
			slot9 = slot0._tf.rect.width / UnityEngine.Screen.width
			slot10 = slot0._tf.rect.height / UnityEngine.Screen.height
			slot11 = slot0._paintingTF.rect.width / 2
			slot12 = slot0._paintingTF.rect.height / 2
			slot13, slot14 = nil
			slot15 = GetOrAddComponent(slot0._bg, "MultiTouchZoom")

			slot15:SetZoomTarget(slot0._paintingTF)

			slot16 = GetOrAddComponent(slot0._bg, "EventTriggerListener")
			slot16.enabled = true
			slot15.enabled = true
			slot17 = true

			slot16:AddPointDownFunc(function (slot0)
				if Input.touchCount == 1 or Application.isEditor then
					slot0 = true
				elseif Input.touchCount >= 2 then
					slot0 = false
				end
			end)
			slot16.AddPointUpFunc(slot16, function (slot0)
				if Input.touchCount <= 2 then
					slot0 = true
				end
			end)
			slot16.AddBeginDragFunc(slot16, function (slot0, slot1)
				slot0 = slot1.position.x * slot1 -  - tf(slot3._paintingTF).localPosition.x
				slot4 = slot1.position.y * slot5 - slot6 - tf(slot3._paintingTF).localPosition.y
			end)
			slot16.AddDragFunc(slot16, function (slot0, slot1)
				if slot0 then
					if tf(slot1._paintingTF).localPosition then
						tf(slot1._paintingTF).localPosition = Vector3(slot1.position.x * slot3 - slot4 - (), tf(slot1._paintingTF).localPosition.y, -22)
					else
						tf(slot1._paintingTF).localPosition = Vector3(slot1.position.x * slot3 - slot4 - (), slot1.position.y *  - slot1.position.y - slot8, -22)
					end

					slot1.anchoredY = slot9.anchoredPosition.y
				end
			end)

			function slot1()
				slot0.enabled = false
				false.enabled = false
			end

			return
		end

		slot0.paintMoving = false
		slot0._bg.GetComponent(slot1, typeof(Button)).enabled = true
		slot0._paintingTF:GetComponent("CanvasGroup").blocksRaycasts = true

		slot0:paintBreath()

		slot0.toTopPanel:GetComponent("CanvasGroup").interactable = true
		slot0._setBtn:GetComponent(typeof(Toggle)).interactable = true
		slot0._setBtn:Find("off"):GetComponent("Image").color = Color.New(1, 1, 1, 1)
		slot0._setBtn:Find("on"):GetComponent("Image").color = Color.New(1, 1, 1, 1)

		if slot0._setBtn.Find("on").GetComponent("Image") then
			slot1()
		end
	end)

	GetComponent(slot0._moveBtn, typeof(Toggle)).isOn = false

	onToggle(slot0, slot0._setBtn, function (slot0)
		setActive(slot0._setOn, slot0)
		setActive(slot0._setOff, not slot0)

		if slot0 then
			triggerToggle(slot0._moveBtn, false)
			LeanTween.moveX(slot0._setBtn, -220, 0.5)
			setToggleEnabled(slot0._moveBtn, false)
			setActive(slot0._moveBtn, false)
			setImageAlpha(slot0._backBtn, 0)
			setButtonEnabled(slot0._backBtn, false)
			setActive(slot0._backBtn, false)
			setActive(slot0._resetBtn, true)
			LeanTween.alpha(slot0._resetBtn, 1, 0.5):setOnComplete(System.Action(function ()
				setButtonEnabled(slot0._resetBtn, true)
			end))
			setActive(slot0._saveBtn, true)
			LeanTween.alpha(slot0._saveBtn, 1, 0.5).setOnComplete(slot1, System.Action(function ()
				setButtonEnabled(slot0._saveBtn, true)
			end))
			setActive(slot0._phonyui, true)
			LeanTween.cancel(go(slot0._paintingTF))

			slot0.paintMoving = true

			GetOrAddComponent(findTF(slot0._paintingTF, "fitter"), "PaintingScaler").Snapshoot(slot1)

			GetOrAddComponent(findTF(slot0._paintingTF, "fitter"), "PaintingScaler").FrameName = "mainNormal"
			findTF(slot0._paintingTF, "live2d").anchoredPosition = Vector2(170, 0)
			slot2, slot3, slot4 = getProxy(SettingsProxy):getSkinPosSetting(slot0.flagShip.skinId)

			if slot2 then
				slot0._paintingTF.anchoredPosition = Vector2(slot2, slot3)
				slot0._paintingTF.localScale = Vector3(slot4, slot4, 1)
			else
				slot0._paintingTF.anchoredPosition = Vector2(slot1.PAINT_DEFAULT_POS_X, slot1.DEFAULT_HEIGHT)
				slot0._paintingTF.localScale = Vector3.one
			end

			slot0._bg:GetComponent(typeof(Button)).enabled = false
			slot0._paintingTF:GetComponent("CanvasGroup").blocksRaycasts = false
			slot6 = slot0.flagShip.getPainting(slot5)
			slot7 = getProxy(SettingsProxy):getCharacterSetting(slot0.flagShip.id, SHIP_FLAG_L2D) and (slot6 == "biaoqiang" or slot6 == "z23" or slot6 == "lafei" or slot6 == "lingbo" or slot6 == "mingshi" or slot6 == "xuefeng")
			slot9 = slot0._paintingTF.anchoredPosition.x
			slot10 = slot0._paintingTF.anchoredPosition.y
			slot13 = slot0._tf.rect.width / UnityEngine.Screen.width
			slot14 = slot0._tf.rect.height / UnityEngine.Screen.height
			slot15 = slot0._paintingTF.rect.width / 2
			slot16 = slot0._paintingTF.rect.height / 2
			slot17, slot18 = nil
			slot19 = GetOrAddComponent(slot0._bg, "MultiTouchZoom")

			slot19:SetZoomTarget(slot0._paintingTF)

			slot20 = GetOrAddComponent(slot0._bg, "EventTriggerListener")
			slot20.enabled = true
			slot19.enabled = true
			slot21 = true

			slot20:AddPointDownFunc(function (slot0)
				if Input.touchCount == 1 or Application.isEditor then
					slot0 = true
				elseif Input.touchCount >= 2 then
					slot0 = false
				end
			end)
			slot20.AddPointUpFunc(slot20, function (slot0)
				if Input.touchCount <= 2 then
					slot0 = true
				end
			end)
			slot20.AddBeginDragFunc(slot20, function (slot0, slot1)
				slot0 = slot1.position.x * slot1 -  - tf(slot3._paintingTF).localPosition.x
				slot4 = slot1.position.y * slot5 - slot6 - tf(slot3._paintingTF).localPosition.y
			end)
			slot20.AddDragFunc(slot20, function (slot0, slot1)
				if slot0 then
					if tf(slot1._paintingTF).localPosition then
						tf(slot1._paintingTF).localPosition = Vector3(slot1.position.x * slot3 - slot4 - (), tf(slot1._paintingTF).localPosition.y, -22)
					else
						tf(slot1._paintingTF).localPosition = Vector3(slot1.position.x * slot3 - slot4 - (), slot1.position.y *  - slot1.position.y - slot8, -22)
					end
				end
			end)

			function slot2()
				slot0.enabled = false
				false.enabled = false
			end

			return
		end

		LeanTween.moveX(slot0._setBtn, -450, 0.5).setOnComplete(slot1, System.Action(function ()
			setToggleEnabled(slot0._moveBtn, true)
			setActive(slot0._moveBtn, true)
		end))
		setActive(slot0._backBtn, true)
		LeanTween.alpha(slot0._backBtn, 1, 0.5).setOnComplete(slot1, System.Action(function ()
			setButtonEnabled(slot0._backBtn, true)
		end))
		setImageAlpha(slot0._resetBtn, 0)
		setButtonEnabled(slot0._resetBtn, false)
		setActive(slot0._resetBtn, false)
		setImageAlpha(slot0._saveBtn, 0)
		setButtonEnabled(slot0._saveBtn, false)
		setActive(slot0._saveBtn, false)
		setActive(slot0._phonyui, false)

		slot0.paintMoving = false

		if false then
			slot2()
		end

		slot0._moveBtn.GetComponent(slot1, typeof(Toggle)).interactable = true

		slot0:paintMove(slot0._paintingOffset, "mainFullScreen", true, 0, 0)

		slot0._bg:GetComponent(typeof(Button)).enabled = true
		slot0._paintingTF:GetComponent("CanvasGroup").blocksRaycasts = true
		slot0.anchoredY = slot1.DEFAULT_HEIGHT

		slot0:paintBreath()
	end)
	setActive(slot0._setBtn, SECRETARY_POS)
	onButton(slot0, slot0._saveBtn, function ()
		slot1 = slot0._paintingTF.localScale.x

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("secretary_pos_save"),
			onYes = function ()
				getProxy(SettingsProxy):setSkinPosSetting(slot0.flagShip.skinId, slot1.x, slot1.y, )
				pg.TipsMgr.GetInstance():ShowTips(i18n("secretary_pos_save_success"))
				triggerToggle(slot0._setBtn, false)
				triggerToggle:switchForm(slot3.STATE_MAIN)
			end
		})
	end)
	setImageAlpha(slot0._saveBtn, 0)
	setButtonEnabled(slot0._saveBtn, false)
	setActive(slot0._saveBtn, false)
	onButton(slot0, slot0._resetBtn, function ()
		getProxy(SettingsProxy):resetSkinPosSetting(slot0.flagShip.skinId)

		getProxy(SettingsProxy).resetSkinPosSetting._paintingTF.anchoredPosition = Vector2(slot1.PAINT_DEFAULT_POS_X, slot1.DEFAULT_HEIGHT)
		getProxy(SettingsProxy).resetSkinPosSetting._paintingTF._paintingTF.localScale = Vector3.one
		findTF(slot0._paintingTF, "live2d").anchoredPosition = Vector2(170, 0)
	end)
	setImageAlpha(slot0._resetBtn, 0)
	setButtonEnabled(slot0._resetBtn, false)
	setActive(slot0._resetBtn, false)
	onButton(slot0, slot0._backBtn, function ()
		triggerToggle(slot0._moveBtn)
		triggerToggle:switchForm(slot1.STATE_MAIN)
	end)
	onButton(slot0, slot0.traingCampBtn, function ()
		slot0:emit(MainUIMediator.OPEN_TRANINGCAMP)
	end, SFX_PANEL)
	slot0.uiEnterAnim(slot0)
	onButton(slot0, slot0.traingCampBtn, function ()
		slot0:emit(MainUIMediator.OPEN_TRANINGCAMP)
	end, SFX_PANEL)
	onButton(slot0, slot0.refluxBtn, function ()
		slot0:emit(MainUIMediator.GO_SCENE, {
			SCENE.REFLUX
		})
	end, SFX_PANEL)
	onButton(slot0, slot0._combatBtn, function ()
		slot0:emit(MainUIMediator.OPEN_LEVEL)
	end, SFX_UI_WEIGHANCHOR_BATTLE)
	onButton(slot0, slot0._dockBtn, function ()
		slot0:emit(MainUIMediator.OPEN_CHUANWUSTART, DockyardScene.MODE_OVERVIEW)
	end, SFX_MAIN)
	onButton(slot0, slot0._hideBtn, function ()
		slot0:switchForm(slot1.STATE_ALL_HIDE)
	end, SFX_MAIN)
	onButton(slot0, slot0._cameraBtn, function ()
		if PLATFORM_CODE == PLATFORM_CH and pg.SdkMgr.GetInstance():GetChannelUID() == "yun" then
			pg.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持该功能哦")

			return
		end

		if CheckPermissionGranted(ANDROID_CAMERA_PERMISSION) then
			slot0:openSnapShot()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("apply_permission_camera_tip1"),
				onYes = function ()
					ApplyPermission({
						ANDROID_CAMERA_PERMISSION
					})
				end
			})
		end
	end, SFX_MAIN)
	setActive(slot0._changeBtn, #getProxy(PlayerProxy).getData(slot4).characters > 1)
	onButton(slot0, slot0._changeBtn, function ()
		if slot0._currentVoice then
			slot0._currentVoice:Stop(true)
		end

		slot0._currentVoice = nil

		slot0:stopCurVoice()

		slot0.stopCurVoice.chatFlag = false

		if slot0.stopCurVoice._delayL2dSeID then
			LeanTween.cancel(slot0._delayL2dSeID)

			LeanTween.cancel._delayL2dSeID = nil
		end

		if slot0._delayVoiceTweenID then
			LeanTween.cancel(slot0._delayVoiceTweenID)

			LeanTween.cancel._delayVoiceTweenID = nil
		end

		slot0._changeBtn:GetComponent(typeof(Button)).interactable = false
		slot0._changeBtn.GetComponent(typeof(Button)).bgLoading = true
		slot0._changeBtn.GetComponent(typeof(Button)).paintingLoading = true

		if #getProxy(PlayerProxy).getData(slot0).characters == 1 then
			return
		end

		slot0:updateFlagShip(slot3)
		slot0:setFlagShip(getProxy(BayProxy):getShipById(slot1.characters[getProxy(SettingsProxy):rotateCurrentSecretaryIndex()]))

		if slot0.shipPrefab and slot0.shipModel then
			PoolMgr.GetInstance():ReturnSpineChar(slot0.shipPrefab, slot0.shipModel)

			slot0.shipPrefab = nil
			slot0.shipModel = nil
		end

		slot0:loadChar(slot3:getPainting())

		if slot0._lastChatTween then
			slot0._lastChatTween:setDelay(0)
		end

		slot0:PlayBGM()
	end)
	onButton(slot0, slot0._mallBtn, function ()
		slot0:emit(MainUIMediator.GO_MALL)
	end, SFX_MAIN)
	onButton(slot0, slot0._commissionBtn, function ()
		if not LeanTween.isTweening(go(slot0._commissionBtn)) then
			LeanTween.moveX(slot0._commissionBtn, -1 * slot0._commissionBtn.rect.width, 0.2):setOnComplete(System.Action(function ()
				slot0:emit(MainUIMediator.OPEN_COMMISSION_INFO)
			end))
		end
	end, SFX_UI_INFO)
	onButton(slot0, slot0._friendBtn, function ()
		slot0:emit(MainUIMediator.OPEN_FRIEND)
	end, SFX_UI_MENU)
	onButton(slot0, slot0._buildBtn, function ()
		slot0:emit(MainUIMediator.GETBOAT)
	end, SFX_UI_BUILDING)
	onButton(slot0, slot0._taskBtn, function ()
		slot0:emit(MainUIMediator.OPEN_TASK)
	end, SFX_MAIN)
	onButton(slot0, slot0._equipBtn, function ()
		slot0:emit(MainUIMediator.OPEN_ARMORYSCENE)
	end, SFX_MAIN)
	onButton(slot0, slot0._formationBtn, function ()
		slot0:emit(MainUIMediator.OPEN_BIANDUI, defaultValue(slot0.contextData.fleetId, 1))
	end, SFX_UI_FORMATION)
	onButton(slot0, slot0._collectionBtn, function ()
		slot0:emit(MainUIMediator.OPEN_COLLECT_SHIP)
	end, SFX_UI_MENU)
	onButton(slot0, slot0._memoryBtn, function ()
		slot0:emit(MainUIMediator.OPEN_MEMORY)
	end, SFX_UI_MENU)

	if not pg.SystemOpenMgr.GetInstance().isOpenSystem(slot2, slot0._player.level, "NewGuildMediator") then
		setActive(slot0:findTF("lock", slot0._guildButton), true)

		slot0._guildButton:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		setActive(slot0:findTF("lock", slot0._guildButton), false)

		slot0._guildButton:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	onButton(slot0, slot0._guildButton, function ()
		slot0:emit(MainUIMediator.OPEN_GUILD)
	end, SFX_MAIN)
	onButton(slot0, slot0._mailBtn, function ()
		if BATTLE_DEBUG then
			slot0:emit(MainUIMediator.TMP_DEBUG)
		else
			slot0:emit(MainUIMediator.OPEN_MAIL)
		end
	end, SFX_UI_MENU)
	onButton(slot0, slot0._chatBtn, function ()
		if not slot0.hideChatFlag or slot0.hideChatFlag ~= 1 then
			slot0:emit(MainUIMediator.OPEN_CHATVIEW)
		end
	end, SFX_UI_CHAT)
	onButton(slot0, slot0._chatBg, function ()
		if not LeanTween.isTweening(go(slot0._commissionBtn)) and (not slot0.hideChatFlag or slot0.hideChatFlag ~= 1) then
			slot0:emit(MainUIMediator.OPEN_CHATVIEW)
		end
	end, SFX_UI_CHAT)
	onButton(slot0, slot0._settingBtn, function ()
		slot0:emit(MainUIMediator.OPEN_SETTINGS)
	end, SFX_UI_MENU)
	onButton(slot0, slot0._chatActBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n((slot0.hideChatFlag and slot0.hideChatFlag == 1 and "show_chat_warning") or "hide_chat_warning"),
			onYes = function ()
				if slot0 then
					PlayerPrefs.SetInt(HIDE_CHAT_FLAG, 0)
				else
					PlayerPrefs.SetInt(HIDE_CHAT_FLAG, 1)
				end

				slot1.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

				PlayerPrefs.GetInt(HIDE_CHAT_FLAG):sethideChatBtn()
			end
		})
	end, SFX_UI_PANEL)
	onButton(slot0, slot0._chatActBtnDisable, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n((slot0.hideChatFlag and slot0.hideChatFlag == 1 and "show_chat_warning") or "hide_chat_warning"),
			onYes = function ()
				if slot0 then
					PlayerPrefs.SetInt(HIDE_CHAT_FLAG, 0)
				else
					PlayerPrefs.SetInt(HIDE_CHAT_FLAG, 1)
				end

				slot1.hideChatFlag = PlayerPrefs.GetInt(HIDE_CHAT_FLAG)

				PlayerPrefs.GetInt(HIDE_CHAT_FLAG):sethideChatBtn()
			end
		})
	end, SFX_UI_PANEL)
	slot0.sethideChatBtn(slot0)
	onButton(slot0, slot0._noticeBtn, function ()
		slot0:emit(MainUIMediator.OPEN_BULLETINBOARD)
	end, SFX_UI_MENU)
	SetActive(slot0._rankBtn, slot3)
	onButton(slot0, slot0._rankBtn, function ()
		slot0:emit(MainUIMediator.OPEN_RANK)
	end, SFX_UI_MENU)
	onButton(slot0, slot0._commanderInfoBtn, function ()
		slot0:emit(MainUIMediator.OPEN_PLAYER_INFO_LAYER)
	end, SFX_MAIN)
	onButton(slot0, slot0._bg, function ()
		if slot0._currentState == slot1.STATE_ALL_HIDE then
			slot0:switchForm(slot1.STATE_MAIN)
		end
	end, SFX_MAIN)
	onButton(slot0, slot0._paintingTF, function ()
		if slot0._currentState == slot1.STATE_ALL_HIDE and getToggleState(slot0._moveBtn) then
		elseif slot0.live2dChar then
			slot0:AssistantEventEffect()
		else
			slot0 = slot0.flagShip:getCVIntimacy()
			slot1 = slot2.filterAssistantEvents(slot2.PaintingTouchEvents, slot0.flagShip.skinId, slot0)

			slot0:AssistantEventEffect(slot1[math.ceil(math.random(#slot1))])
			slot0:paintClimax(slot1.TOUCH_HEIGHT, slot1.TOUCH_DURATION, slot1.TOUCH_LOOP)
		end

		if slot0.flagShip then
			slot0:emit(MainUIMediator.ON_TOUCHSHIP, slot0.flagShip.groupId)
		end
	end)
	onButton(slot0, slot0._liveBtn, function ()
		slot0:openSecondaryPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0._technologyBtn, function ()
		slot0:emit(MainUIMediator.OPEN_TECHNOLOGY)
	end, SFX_PANEL)

	function slot4(slot0)
		setActive(slot0._wordBtnOpen, not slot0)
		setActive(slot0._wordBtnClose, slot0)
	end

	slot0.showWord = getProxy(SettingsProxy).ShouldShipMainSceneWord(slot5)

	onButton(slot0, slot0._wordBtn, function ()
		slot0.showWord = not slot0.showWord

		getProxy(SettingsProxy):SaveMainSceneWordFlag(slot0.showWord)
		pg.TipsMgr.GetInstance():ShowTips((getProxy(SettingsProxy).SaveMainSceneWordFlag.showWord and i18n("game_openwords")) or i18n("game_stopwords"))

		if not (getProxy(SettingsProxy).SaveMainSceneWordFlag.showWord and i18n("game_openwords")) or i18n("game_stopwords").showWord and LeanTween.isTweening(slot0._chat.gameObject) then
			LeanTween.cancel(slot0._chat.gameObject)

			slot0._chat.localScale = Vector3(0, 0, 0)
			slot0._lastChatTween = nil
			slot0.chatFlag = nil

			slot0:startChatTimer()
		end

		slot1(slot0.showWord)
	end, SFX_PANEL)
	slot4(slot0.showWord)
	pg.DelegateInfo.Add(slot0, slot5)
	GetOrAddComponent(slot0._paintingTF, "UILongPressTrigger").onLongPressed.RemoveAllListeners(slot5)
	GetOrAddComponent(slot0._paintingTF, "UILongPressTrigger").onLongPressed.AddListener(slot5, function ()
		if slot0.live2dChar then
			return
		end

		slot0._paintingTF.localScale = Vector3.one
		slot0._paintingTF._settingBottom.anchoredPosition = Vector2(0, -105)
		slot0._paintingTF._settingBottom._settingRight.anchoredPosition = Vector2(865, 0)

		setActive(slot0._settingBottom, false)
		setActive(slot0._settingRight, false)
		setActive:emit(MainUIMediator.ON_SHIP_DETAIL, slot0.flagShip)
	end)
	slot0.paintMove(slot0, slot1.PAINT_DEFAULT_POS_X, "mainNormal", false, 0)

	slot0._settingBottom.anchoredPosition = Vector2(0, -105)
	slot0._settingRight.anchoredPosition = Vector2(865, 0)

	setActive(slot0._settingBottom, false)
	setActive(slot0._settingRight, false)
	setActive(slot0.refluxBtn, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_REFLUX) and not slot6:isEnd())
	setActive(slot0.traingCampBtn, TrainingCampScene.isNormalActOn() or TrainingCampScene.isTecActOn())
	TagTipHelper.MonthCardTagTip(slot0._montgcardTag)
	TagTipHelper.SkinTagTip(slot0._skinSellTag)
	TagTipHelper.FuDaiTagTip(slot0._mallSellTag)
end

slot0.openSnapShot = function (slot0)
	slot0:emit(MainUIMediator.OPEN_SNAPSHOT, {
		skinId = slot0.flagShip.skinId,
		live2d = slot0.Live2dChar ~= nil
	})
end

slot0.updateMonopolyBtn = function (slot0, slot1)
	setActive(slot0._monopolyBtn, slot1 and not slot1:isEnd())

	if slot1 and not slot1.isEnd() then
		onButton(slot0, slot0._monopolyBtn, function ()
			slot0:emit(MainUIMediator.ON_MONOPOLY)
		end, SFX_PANEL)
	end
end

slot0.onBackPressed = function (slot0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if slot0.secondaryPage and slot0.secondaryPage:isShowing() then
		slot0:closeSecondaryPanel()

		return
	end

	if slot0._currentState == slot0.STATE_ALL_HIDE then
		if getToggleState(slot0._setBtn) then
			triggerToggle(slot0._setBtn, false)
		else
			slot0:switchForm(slot0.STATE_MAIN)
		end
	else
		pg.SdkMgr.GetInstance():OnAndoridBackPress()
		pg.PushNotificationMgr.GetInstance():PushAll()
	end
end

slot0.ResetActivityBtns = function (slot0)
	slot2 = slot0._ActivityBtns:GetComponent(typeof(GridLayoutGroup))

	if import("GameCfg.activity.MainUIEntranceData").LayoutProperty.CellSize then
		slot2.cellSize = slot1.LayoutProperty.CellSize
	end

	if slot1.LayoutProperty.Spacing then
		slot2.spacing = slot1.LayoutProperty.Spacing
	end

	if slot1.LayoutProperty.Padding then
		slot2.padding = slot2.padding.New(unpack(slot1.LayoutProperty.Padding))
	end

	slot3 = slot0._ActivityBtnTpl

	for slot7, slot8 in ipairs(slot1.CurrentEntrancesList) do
		if IsNil(tf(slot2):Find(slot1[slot8].ButtonName)) then
			cloneTplTo(slot3, slot2, slot9.ButtonName).SetSiblingIndex(slot10, slot7 - 1)
			slot0:RefreshBtn(cloneTplTo(slot3, slot2, slot9.ButtonName), slot9)

			if slot9.Tip then
				setImageSprite(slot10:Find("Tip"), LoadSprite("ui/mainui_atlas", slot9.Tip), true)
			else
				setActive(slot10:Find("Tip"), false)
			end

			if slot9.CtorButton then
				slot9.CtorButton(slot0, slot10)
			end
		elseif slot9.forceRefreshImage then
			slot0:RefreshBtn(slot10, slot9)
		end

		if slot1.LayoutProperty.CellScale then
			slot10.localScale = slot1.LayoutProperty.CellScale
		end

		if slot9.UpdateButton then
			slot9.UpdateButton(slot0, slot10)
		else
			setActive(slot10, false)
		end
	end
end

slot0.RefreshBtn = function (slot0, slot1, slot2)
	if slot1:Find("Image") == nil then
		slot3 = slot1
	end

	if type(slot2.Image) == "function" then
		if slot2.Image() then
			setImageSprite(slot3, slot4, true)
		end
	else
		setImageSprite(slot3, LoadSprite("ui/mainui_atlas", slot2.Image), true)
	end
end

slot0.UpdateActivityBtn = function (slot0, slot1)
	for slot6, slot7 in ipairs(import("GameCfg.activity.MainUIEntranceData").CurrentEntrancesList) do
		if slot2[slot7] and slot8.ButtonName == slot1 then
			if not IsNil(slot0._ActivityBtns:Find(slot8.ButtonName)) then
				if slot8.UpdateButton then
					slot8.UpdateButton(slot0, slot9)
				else
					setActive(slot9, false)
				end

				if slot8.forceRefreshImage then
					slot0:RefreshBtn(slot9, slot8)
				end
			end

			break
		end
	end
end

slot0.HandleMiniGameBtns = function (slot0)
	for slot5, slot6 in ipairs(import("GameCfg.activity.MainUIEntranceData").CurrentEntrancesList) do
		if slot1[slot6] and slot7.Tag and slot7.Tag == "MiniGameHub" then
			slot0:UpdateActivityBtn(slot7.ButtonName)
		end
	end
end

slot0.updateAnniversaryBtn = function (slot0, slot1)
	setActive(slot0._anniversaryBtn, slot1 and not slot1:isEnd())

	if slot1 and not slot1.isEnd() then
		onButton(slot0, slot0._anniversaryBtn, function ()
			slot0:emit(MainUIMediator.ON_ANNIVERSARY)
		end, SFX_PANEL)
	end
end

slot0.updateBlackWhitBtn = function (slot0, slot1)
	setActive(slot0._blackWhitBtn, slot1 and not slot1:isEnd())

	if slot1 and not slot1.isEnd() then
		onButton(slot0, slot0._blackWhitBtn, function ()
			slot0:emit(MainUIMediator.ON_BLACKWHITE)
		end, SFX_PANEL)
	end
end

slot0.updateMemoryBookBtn = function (slot0, slot1)
	setActive(slot0._memoryBookBtn, slot1 and not slot1:isEnd() and not slot1:isShow())

	if slot1 and not slot1.isEnd() and not slot1.isShow() then
		onButton(slot0, slot0._memoryBookBtn, function ()
			slot0:emit(MainUIMediator.ON_MEMORYBOOK)
		end, SFX_PANEL)
	end
end

slot0.updateVoteBtn = function (slot0, slot1, slot2)
	slot0:updateVoteBookBtn(slot2)
end

slot0.updateVoteBookBtn = function (slot0, slot1)
	setActive(slot0._voteBookBtn, slot1 and not slot1:IsExpired())
	slot0:RemoveVoteBookTimer()

	if slot1 and not slot1.IsExpired() then
		onButton(slot0, slot0._voteBookBtn, function ()
			slot0:emit(MainUIMediator.ON_VOTE_BOOK)
		end, SFX_PANEL)

		slot3 = slot0._voteBookBtn.Find(slot3, "tip/Text"):GetComponent(typeof(Text))
		slot0.voteBookTimer = Timer.New(function ()
			slot0.text = slot1:GetCDTime("#9BB8FFFF")
		end, 1, -1)

		slot0.voteBookTimer.Start(slot4)
		slot0.voteBookTimer.func()
	end
end

slot0.RemoveVoteBookTimer = function (slot0)
	if slot0.voteBookTimer then
		slot0.voteBookTimer:Stop()

		slot0.voteBookTimer = nil
	end
end

slot0.updateLotteryBtn = function (slot0, slot1)
	setActive(slot0._lotteryBtn, slot1 and not slot1:isEnd())

	if slot1 and not slot1.isEnd() then
		onButton(slot0, slot0._lotteryBtn, function ()
			slot0:emit(MainUIMediator.ON_LOTTERY, slot1.id)
		end, SFX_PANEL)
	end
end

slot0.updateActivityPtBtn = function (slot0, slot1)
	setActive(slot0._activityPtBtn, slot1 and not slot1:isEnd())

	if slot1 and not slot1.isEnd() then
		onButton(slot0, slot0._activityPtBtn, function ()
			slot0:emit(MainUIMediator.ON_ACTIVITY_PT, slot1.id)
		end, SFX_PANEL)
	end

	setActive(slot0._activityPtBtn, false)
end

slot0.updateActivityWowsBtn = function (slot0, slot1)
	setActive(slot0._activityTaskWowsBtn, slot1 and not slot1:isEnd())

	if slot1 and not slot1.isEnd() then
		onButton(slot0, slot0._activityTaskWowsBtn, function ()
			slot0:emit(MainUIMediator.ON_ACTIVITY_WOWS, slot1.id)
		end, SFX_PANEL)
	end
end

slot0.switchForm = function (slot0, slot1)
	if slot0._currentState ~= slot1 then
		slot0._currentState = slot1

		if slot1 == slot0.STATE_MAIN then
			slot0:ejectGimmick(slot0._bottomPanel, slot0.REVERT_VERTICAL)
			slot0:ejectGimmick(slot0._btmbg, slot0.REVERT_VERTICAL)
			slot0:ejectGimmick(slot0._leftPanel, slot0.REVERT_HERIZONTAL)
			slot0:ejectGimmick(slot0._rightPanel, slot0.REVERT_HERIZONTAL)
			slot0:ejectGimmick(slot0._rightTopPanel, slot0.REVERT_HERIZONTAL)
			slot0:ejectGimmick(slot0._playerResOb, slot0.REVERT_VERTICAL)
			slot0:ejectGimmick(slot0._commanderPanel, slot0.REVERT_HERIZONTAL_VERTICAL)
			slot0:ejectGimmick(slot0._commanderPanelbg, slot0.REVERT_HERIZONTAL_VERTICAL)
			slot0:concealGimmick(slot0._settingBottom, slot0.DIRECTION_DOWN)
			slot0:concealGimmick(slot0._settingRight, slot0.DIRECTION_RIGHT)

			slot0._paintingTF.localScale = Vector3(1, 1, 1)

			triggerToggle(slot0._moveBtn, false)
			slot0:paintMove(slot0.PAINT_DEFAULT_POS_X, "mainNormal", true, 0)
			slot0:managedTween(LeanTween.delayedCall, function ()
				slot0._paintingTimer:Pause()
			end, slot0.EJECT_DURATION + 0.3, nil)
		elseif slot1 == slot0.STATE_ALL_HIDE then
			slot0._paintingTimer.Resume(slot2)
			slot0:concealGimmick(slot0._bottomPanel, slot0.DIRECTION_DOWN)
			slot0:concealGimmick(slot0._btmbg, slot0.DIRECTION_DOWN)
			slot0:concealGimmick(slot0._rightPanel, slot0.DIRECTION_RIGHT)
			slot0:concealGimmick(slot0._leftPanel, slot0.DIRECTION_LEFT)
			slot0:concealGimmick(slot0._playerResOb, slot0.DIRECTION_UP)
			slot0:concealGimmick(slot0._rightTopPanel, slot0.DIRECTION_RIGHT)
			slot0:concealGimmick(slot0._commanderPanel, slot0.DIRECTION_UP_LEFT)
			slot0:concealGimmick(slot0._commanderPanelbg, slot0.DIRECTION_UP_LEFT)
			slot0:ejectGimmick(slot0._settingBottom, slot0.REVERT_VERTICAL)
			slot0:ejectGimmick(slot0._settingRight, slot0.REVERT_HERIZONTAL)
			slot0:paintMove(slot0._paintingOffset, "mainFullScreen", true, 0, 0)

			slot0.anchoredY = slot0.DEFAULT_HEIGHT
		end
	end
end

slot0.paintBreath = function (slot0)
	if slot0.live2dChar or slot0.paintMoving then
		return
	end

	slot1 = slot0.BREATH_HEIGHT
	slot2 = slot0.DEFAULT_HEIGHT
	slot3, slot4, slot5 = getProxy(SettingsProxy):getSkinPosSetting(slot0.flagShip.skinId)

	if slot4 and slot0._currentState == slot0.STATE_MAIN then
		slot2 = slot4
		slot1 = slot4 - 10
	end

	if slot0._currentState == slot0.STATE_ALL_HIDE then
		slot1 = slot0.anchoredY - 10
	end

	LeanTween.cancel(go(slot0._paintingTF))
	LeanTween.moveY(rtf(slot0._paintingTF), slot1, slot0.BREATH_DURATION):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(slot2)
end

slot0.paintClimax = function (slot0, slot1, slot2, slot3)
	if slot0.spinePainting then
		return
	end

	if slot0.live2dChar or slot0.paintMoving then
		return
	end

	slot4, slot5, slot6 = getProxy(SettingsProxy):getSkinPosSetting(slot0.flagShip.skinId)
	slot7 = slot1

	if slot5 then
		slot7 = slot1 - slot0.DEFAULT_HEIGHT + slot5
	end

	if slot0._currentState == slot0.STATE_ALL_HIDE then
		slot7 = slot1 - slot0.DEFAULT_HEIGHT + slot0.anchoredY
	end

	if (slot3 or math.random(3) - 1) ~= 0 then
		LeanTween.cancel(go(slot0._paintingTF))
		LeanTween.moveY(rtf(slot0._paintingTF), slot7, slot2):setLoopPingPong(slot3):setOnComplete(System.Action(function ()
			slot0:paintBreath()
		end))
	end
end

slot0.paintMove = function (slot0, slot1, slot2, slot3, slot4, slot5)
	LeanTween.cancel(go(slot0._paintingTF))
	LeanTween.moveY(rtf(slot0._paintingTF), 0, slot0.EJECT_DURATION)
	LeanTween.moveY(findTF(slot0._paintingTF, "live2d"), slot4 or 0, slot0.EJECT_DURATION)

	slot6 = GetOrAddComponent(findTF(slot0._paintingTF, "fitter"), "PaintingScaler")

	slot6:Snapshoot()

	slot6.FrameName = slot2

	if slot3 then
		slot7 = LeanTween.value(go(slot0._paintingTF), 0, 1, slot0.EJECT_DURATION):setOnUpdate(System.Action_float(function (slot0)
			slot0.Tween = slot0
		end)).setEase(slot7, LeanTweenType.easeInOutSine)
	end

	slot0._bg:GetComponent("Button").enabled = false
	slot0._paintingTF:GetComponent("Button").enabled = false
	slot0.paintMoving = true

	setActive(slot0._chat, false)
	LeanTween.moveX(rtf(slot0._chat), (slot0._currentState == slot0.STATE_MAIN and slot1 + 140) or slot1, slot0.EJECT_DURATION):setOnComplete(System.Action(function ()
		setActive(slot0._chat, true)
	end))

	slot7, slot8, slot9 = getProxy(SettingsProxy).getSkinPosSetting(slot7, slot0.flagShip.skinId)
	slot10 = nil

	if slot9 and slot2 == "mainNormal" then
		slot10 = LeanTween.moveX(rtf(slot0._paintingTF), slot7, slot0.EJECT_DURATION)

		LeanTween.moveY(rtf(slot0._paintingTF), slot8, slot0.EJECT_DURATION):setEase(LeanTweenType.easeInOutExpo)
		LeanTween.scale(rtf(slot0._paintingTF), Vector3(slot9, slot9, 1), slot0.EJECT_DURATION):setEase(LeanTweenType.easeInOutExpo)
	else
		slot10 = LeanTween.moveX(rtf(slot0._paintingTF), slot1, slot0.EJECT_DURATION)

		LeanTween.moveY(rtf(slot0._paintingTF), slot0.DEFAULT_HEIGHT, slot0.EJECT_DURATION):setEase(LeanTweenType.easeInOutExpo)
		LeanTween.scale(rtf(slot0._paintingTF), Vector3(1, 1, 1), slot0.EJECT_DURATION):setEase(LeanTweenType.easeInOutExpo)
	end

	moveTweenL2D = LeanTween.moveX(findTF(slot0._paintingTF, "live2d"), slot5 or 170, slot0.EJECT_DURATION):setEase(LeanTweenType.easeInOutExpo)

	slot10:setEase(LeanTweenType.easeInOutExpo)
	slot10:setOnComplete(System.Action(function ()
		slot0.paintMoving = false

		slot0:paintBreath()

		slot0.paintBreath._bg:GetComponent("Button").enabled = true
		slot0.paintBreath._bg.GetComponent("Button")._paintingTF:GetComponent("Button").enabled = true
	end))
end

slot0.getCvData = function (slot0, slot1)
	if slot1 == "" then
		return nil
	end

	slot2 = slot0.flagShip:getCVIntimacy()
	slot4, slot5, slot6, slot7, slot8, slot9 = nil

	if string.split(slot1, "_")[1] == "main" then
		slot4, slot6, slot5 = ShipWordHelper.GetWordAndCV(slot0.flagShip.skinId, slot3[1], tonumber(slot3[2]), nil, slot2)
		slot7 = ShipWordHelper.GetL2dCvCalibrate(slot0.flagShip.skinId, slot3[1], tonumber(slot3[2]))
		slot8 = ShipWordHelper.GetL2dSoundEffect(slot0.flagShip.skinId, slot3[1], tonumber(slot3[2]))
	else
		slot4, slot6, slot5 = ShipWordHelper.GetWordAndCV(slot0.flagShip.skinId, slot1, nil, nil, slot2)
		slot7 = ShipWordHelper.GetL2dCvCalibrate(slot0.flagShip.skinId, slot1)
		slot8 = ShipWordHelper.GetL2dSoundEffect(slot0.flagShip.skinId, slot1)
	end

	slot9 = slot7 == -1

	if slot0.l2dEventFlag then
		slot7 = 0
	end

	return slot4, slot6, slot5, slot7, slot8, slot9
end

slot0.displayShipWord = function (slot0, slot1)
	if slot0.chatFlag then
		return
	end

	slot2 = slot0.flagShip:getCVIntimacy()
	slot3 = string.split(slot1, "_")
	slot4, slot5, slot6, slot7, slot8, slot9 = slot0:getCvData(slot1)

	if not slot6 or slot6 == nil or slot6 == "" or slot6 == "nil" then
		return
	end

	slot0.chatFlag = true

	if slot0.chatTimer then
		slot0.chatTimer:Stop()

		slot0.chatTimer = nil
	end

	if PLATFORM_CODE == PLATFORM_US then
		setTextEN(slot0._chatText, slot6)
	else
		setText(slot0._chatText, SwitchSpecialChar(slot6))
	end

	if CHAT_POP_STR_LEN < #slot0._chatText:GetComponent(typeof(Text)).text then
		slot10.alignment = TextAnchor.MiddleLeft
	else
		slot10.alignment = TextAnchor.MiddleCenter
	end

	if slot0.initChatBgH < slot10.preferredHeight + 26 then
		slot0._chatTextBg.sizeDelta = Vector2.New(slot0._chatTextBg.sizeDelta.x, slot11)
	else
		slot0._chatTextBg.sizeDelta = Vector2.New(slot0._chatTextBg.sizeDelta.x, slot0.initChatBgH)
	end

	slot12 = slot0.CHAT_SHOW_TIME

	if findTF(slot0._paintingTF, "fitter").childCount > 0 then
		ShipExpressionHelper.SetExpression(findTF(slot0._paintingTF, "fitter"):GetChild(0), slot0.flagShip:getPainting(), slot1, slot2, slot0.flagShip.skinId)
	end

	function slot13()
		if not slot0.showWord then
			slot0()

			return
		end

		LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(1, 1, 1), slot0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function ()
			slot0._lastChatTween = LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(0, 0, 1), slot0.CHAT_ANIMATION_TIME):setEase(LeanTweenType.easeInBack):setDelay(slot0.CHAT_ANIMATION_TIME + LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(0, 0, 1), slot0.CHAT_ANIMATION_TIME).setEase(LeanTweenType.easeInBack).setDelay):setOnComplete(System.Action(LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(0, 0, 1), slot0.CHAT_ANIMATION_TIME).setEase(LeanTweenType.easeInBack).setDelay(slot0.CHAT_ANIMATION_TIME + LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(0, 0, 1), slot0.CHAT_ANIMATION_TIME).setEase(LeanTweenType.easeInBack).setDelay)))
		end))
	end

	if slot0._delayL2dSeID then
		LeanTween.cancel(slot0._delayL2dSeID)

		slot0._delayL2dSeID = nil
	end

	if slot0.live2dChar and slot8 then
		slot0._delayL2dSeID = LeanTween.delayedCall(slot8[2], System.Action(function ()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/" .. slot0[1])

			pg.CriMgr.GetInstance()._delayL2dSeID = nil
		end)).id
	end

	slot14 = pg.NewStoryMgr.GetInstance().IsRunning(slot14)

	if getProxy(ContextProxy):getContextByMediator(NewShipMediator) then
	elseif slot5 and not slot14 then
		function slot15()
			if slot0._currentVoice then
				slot0._currentVoice:Stop(true)
			end

			if slot0._delayVoiceTweenID then
				LeanTween.cancel(slot0._delayVoiceTweenID)

				slot0._delayVoiceTweenID = nil
			end

			if slot0.live2dChar and slot4 and slot4 ~= 0 then
				slot0._delayVoiceTweenID = LeanTween.delayedCall(slot4, System.Action(function ()
					slot0()

					slot1._delayVoiceTweenID = nil
				end)).id
			else
				slot0()
			end
		end

		slot16 = ShipWordHelper.RawGetCVKey(slot0.flagShip.skinId)

		pg.CriMgr.GetInstance():LoadCueSheet(pg.CriMgr.GetCVBankName(slot16), function (slot0)
			if slot0 then
				slot0()
			else
				slot1()
			end
		end)

		slot0.preCvCueSheetName = pg.CriMgr.GetCVBankName(slot16)
	elseif slot6 then
		slot13()
	else
		slot0.chatFlag = false
	end

	removeOnButton(slot0._chat)
	onButton(slot0, slot0._chat, function ()
		if slot0 == "mission_complete" or slot0 == "mission" then
			slot1:emit(MainUIMediator.OPEN_TASK)
		elseif slot0 == "collection" then
			slot1:emit(MainUIMediator.OPEN_EVENT)
		elseif slot0 == "event_complete" then
			slot1:emit(LevelMediator2.ON_OPEN_EVENT_SCENE)
		end
	end, SFX_MAIN)
end

slot0.stopCurVoice = function (slot0)
	if slot0._currentVoice then
		slot0._currentVoice:Stop(true)
	end

	if slot0.preCvCueSheetName then
		pg.CriMgr.GetInstance():UnloadCueSheet(slot0.preCvCueSheetName)

		slot0.preCvCueSheetName = nil
	end
end

slot0.startChatTimer = function (slot0)
	if slot0.chatFlag or slot0.exited then
		return
	end

	if slot0.chatTimer then
		slot0.chatTimer:Stop()

		slot0.chatTimer = nil
	end

	slot0.chatTimer = Timer.New(function ()
		slot0:paintClimax(slot1.CHAT_HEIGHT, slot1.CHAT_DURATION)

		slot0 = {}

		if getProxy(EventProxy):hasFinishState() and slot0.lastChatEvent ~= "event_complete" then
			table.insert(slot0, "event_complete")
		else
			if go(slot0._taskBtn:Find("tip")).activeSelf and slot0.lastChatEvent ~= "mission_complete" then
				table.insert(slot0, "mission_complete")
			end

			if getProxy(MailProxy):GetAttachmentCount() > 0 and slot0.lastChatEvent ~= "mail" then
				table.insert(slot0, "mail")
			end

			if #slot0 == 0 then
				slot0 = slot0.flagShip.filterAssistantEvents(Clone(slot2.IdleEvents), slot0.flagShip.skinId, slot0.flagShip:getCVIntimacy())

				if getProxy(TaskProxy):getNotFinishCount() and getProxy(TaskProxy):getNotFinishCount() > 0 and slot0.lastChatEvent ~= "mission" then
					table.insert(slot0, "mission")
				end
			end
		end

		slot0.chatTimer:Stop()

		slot0.chatTimer = nil
		slot0.lastChatEvent = slot0[math.ceil(math.random(#slot0))]

		slot0:AssistantEventEffect(slot0.lastChatEvent)
	end, slot0.CHAT_INTERVAL, 1)

	slot0.chatTimer.Start(slot1)
end

slot0.initShipChat = function (slot0)
	if slot0.contextData.isFromLogin then
		slot0.contextData.isFromLogin = nil

		slot0:AssistantEventEffect("event_login")
	elseif getProxy(PlayerProxy):getFlag("battle") then
		getProxy(PlayerProxy):setFlag("battle", nil)
		slot0:AssistantEventEffect("home")
	else
		slot0:startChatTimer()
	end
end

slot0.ShowAssistInfo = function (slot0, slot1, slot2)
	slot3 = findTF(slot0._paintingTF, "live2d")
	slot4 = findTF(slot0._paintingTF, "spinePainting")
	slot5 = findTF(slot0._paintingBgTf, "spinePainting")
	slot6 = getProxy(SettingsProxy)

	if slot0.live2dChar then
		slot0.live2dChar:Dispose()

		slot0.live2dChar = nil
	end

	if slot0.spinePainting then
		slot0.spinePainting:Dispose()

		slot0.spinePainting = nil
	end

	slot7, slot8, slot9 = getProxy(SettingsProxy):getSkinPosSetting(slot0.flagShip.skinId)

	if slot7 then
		slot0._paintingTF.anchoredPosition = Vector2(slot7, slot8)
		slot0._paintingTF.localScale = Vector3(slot9, slot9, 1)
		slot0._paintingBgTf.anchoredPosition = Vector2(slot7, slot8)
		slot0._paintingBgTf.localScale = Vector3(slot9, slot9, 1)
	else
		slot0._paintingTF.anchoredPosition = Vector2(slot0.PAINT_DEFAULT_POS_X, slot0.DEFAULT_HEIGHT)
		slot0._paintingTF.localScale = Vector3.one
		slot0._paintingBgTf.anchoredPosition = Vector2(slot0.PAINT_DEFAULT_POS_X, slot0.DEFAULT_HEIGHT)
		slot0._paintingBgTf.localScale = Vector3.one
	end

	slot11 = PathMgr.FileExists(PathMgr.getAssetBundle(slot10))
	slot13 = PathMgr.FileExists(PathMgr.getAssetBundle(slot12))

	if slot6:getCharacterSetting(slot2.id, SHIP_FLAG_SP) and slot11 then
		LeanTween.cancel(go(slot0._paintingTF))

		slot0.spinePainting = SpinePainting.New(SpinePainting.GenerateData({
			ship = slot2,
			position = Vector3(0, 0, 0),
			parent = slot4,
			effectParent = slot5
		}), function ()
			slot0:initShipChat()

			slot0.initShipChat.paintingLoading = false

			slot0.initShipChat:setChangeBtnInteractable()
		end)
	elseif slot6.getCharacterSetting(slot6, slot2.id, SHIP_FLAG_L2D) and slot13 then
		LeanTween.cancel(go(slot0._paintingTF))

		slot0.live2dChar = Live2D.New(Live2D.GenerateData({
			ship = slot2,
			scale = Vector3(52, 52, 52),
			position = Vector3(0, 0, 100),
			parent = slot3
		}), function ()
			slot0:initShipChat()

			slot0.initShipChat.paintingLoading = false

			slot0.initShipChat:setChangeBtnInteractable()
		end)
	else
		SetActive(slot3, false)
		setPaintingPrefabAsync(slot0._paintingTF, slot1, "mainNormal", function ()
			if slot0.exited then
				return
			end

			if not findTF(findTF(slot0._paintingTF, "fitter"):GetChild(0), "Touch") then
				return
			end

			setActive(slot0, true)
			eachChild(slot0, function (slot0)
				onButton(slot0, slot0, function ()
					if slot0._currentState == slot1.STATE_ALL_HIDE and getToggleState(slot0._moveBtn) then
						slot0:switchForm(slot1.STATE_MAIN)
					else
						slot0:AssistantEventEffect(slot2.getPaintingTouchEvents(slot3.name))
						slot0.AssistantEventEffect:paintClimax(slot1.TOUCH_HEIGHT, slot1.TOUCH_DURATION, slot1.TOUCH_LOOP)
					end

					if slot0.flagShip then
						slot0:emit(MainUIMediator.ON_TOUCHSHIP, slot0.flagShip.groupId)
					end
				end)
			end)
			slot0.initShipChat(slot1)

			slot0.paintingLoading = false

			slot0:setChangeBtnInteractable()
		end)
		slot0.paintBreath(slot0)
	end
end

slot0.AssistantEventEffect = function (slot0, slot1)
	if not slot1 and slot0.live2dChar and slot0.live2dChar.state == Live2D.STATE_INITED and not Input.mousePosition then
		return
	end

	if not ((slot0.live2dChar:GetTouchPart() <= 0 or slot0.filterAssistantEvents(slot0.getAssistantTouchEvents(slot3), slot0.flagShip.skinId, 0)[math.ceil(math.random(#slot0.filterAssistantEvents(slot0.getAssistantTouchEvents(slot3), slot0.flagShip.skinId, 0)))]) and slot0.filterAssistantEvents(slot0.IdleEvents, slot0.flagShip.skinId, 0)[math.floor(math.Random(0, #slot0.filterAssistantEvents(slot0.IdleEvents, slot0.flagShip.skinId, 0))) + 1]) then
		return
	end

	slot3, slot4, slot5, slot6, slot7, slot8 = slot0:getCvData(slot0.assistantEvents[slot1].dialog)
	slot9 = false

	if slot0.live2dChar then
		if not slot8 then
			slot0.live2dChar:TriggerAction(slot2.action)
		else
			slot9 = true

			slot0.live2dChar:TriggerAction(slot2.action, nil, nil, function ()
				slot0:displayShipWord(slot1.dialog)
			end)
		end
	end

	if slot2.dialog ~= "" and not slot9 then
		slot0.displayShipWord(slot0, slot2.dialog)
	else
		slot0:startChatTimer()
	end
end

slot0.tweenBG = function (slot0, slot1)
	LeanTween.moveX(rtf(slot0._bg), slot1, slot0.EJECT_DURATION):setEase(LeanTweenType.easeInOutExpo)
end

slot0.ejectGimmick = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	LeanTween.cancel(slot1.gameObject)
	SetActive(slot1, true)

	slot7 = GetOrAddComponent(slot1, "CanvasGroup")

	if not slot0.leans then
		slot0.leans = {}
	end

	if slot2 then
		table.insert(slot0.leans, slot1)
		slot0:generateGimmickLean(slot1, slot2, slot3).setOnComplete(slot8, System.Action(function ()
			slot0.blocksRaycasts = true

			if true then
				slot1()
			end
		end)).setEase(slot9, LeanTweenType.easeInOutExpo):setDelay(slot5 or 0)
	end

	if slot6 then
		slot7.alpha = slot6[1]

		LeanTween.alphaCanvas(slot7, slot6[2], slot3):setFrom(slot6[1]):setDelay(slot5 or 0)
	end
end

slot0.concealGimmick = function (slot0, slot1, slot2, slot3)
	GetOrAddComponent(slot1, "CanvasGroup").blocksRaycasts = false

	slot0:generateGimmickLean(slot1, slot2, duration).setOnComplete(slot4, System.Action(function ()
		SetActive(SetActive, false)
	end)).setEase(slot5, LeanTweenType.easeInOutExpo):setDelay(slot3 or 0)
end

slot0.generateGimmickLean = function (slot0, slot1, slot2, slot3)
	slot3 = slot3 or slot0.EJECT_DURATION
	slot4 = slot1:GetComponent("RectTransform").rect
	slot5 = nil

	if slot2 == slot0.DIRECTION_RIGHT then
		slot5 = LeanTween.moveX(rtf(slot1), slot4.width, slot3)
	elseif slot2 == slot0.DIRECTION_LEFT then
		slot5 = LeanTween.moveX(rtf(slot1), slot4.width * -1, slot3)
	elseif slot2 == slot0.DIRECTION_UP then
		slot5 = LeanTween.moveY(rtf(slot1), slot4.height, slot3)
	elseif slot2 == slot0.DIRECTION_DOWN then
		slot5 = LeanTween.moveY(rtf(slot1), slot4.height * -1, slot3)
	elseif slot2 == slot0.DIRECTION_DOWN_RIGHT then
		slot5 = LeanTween.moveY(rtf(slot1), Vector3(slot4.width, slot4.height * -1, 0), slot3)
	elseif slot2 == slot0.DIRECTION_UP_LEFT then
		slot5 = LeanTween.move(rtf(slot1), Vector3(slot4.width * -1, slot4.height, 0), slot3)
	elseif slot2 == slot0.REVERT_VERTICAL then
		slot5 = LeanTween.moveY(rtf(slot1), 0, slot3)
	elseif slot2 == slot0.REVERT_HERIZONTAL then
		slot5 = LeanTween.moveX(rtf(slot1), 0, slot3)
	elseif slot2 == slot0.REVERT_HERIZONTAL_VERTICAL then
		slot5 = LeanTween.move(rtf(slot1), Vector3(0, 0, 0), slot3)
	end

	return slot5
end

slot0.updatePlayerInfo = function (slot0, slot1)
	slot0._player = slot1

	slot0._resPanel:setResources(slot1)
	slot0:setProfileInfo(slot1, slot0.ships)
end

slot0.setProfileInfo = function (slot0, slot1, slot2)
	setText(slot0._nameLabel, slot1.name)
	setText(slot0._levelLabel, "LV." .. slot1.level)

	slot3 = getConfigFromLevel1(pg.user_level, slot1.level)

	if slot1.level == slot0._player:getMaxLevel() then
		slot0._expBar.value = 1
	else
		slot0._expBar.value = slot1.exp / slot3.exp_interval
	end

	if not getProxy(PlayerProxy):getFlag("battle") then
		slot0:loadChar(slot2[slot1.characters[getProxy(SettingsProxy):getCurrentSecretaryIndex()]]:getPainting())
	end
end

slot0.updateBuffList = function (slot0, slot1)
	slot2 = UIItemList.New(slot0._buffList, slot0._buffTpl)

	slot2:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			if slot0[slot1 + 1].IsVirtualIcon then
				slot1:RefreshBtn(slot2, slot3)

				if slot3.UpdateButton then
					slot3.UpdateButton(slot1, slot2)
				end
			else
				LoadImageSpriteAsync(slot3:getConfig("icon"), slot2)
				onButton(slot1, slot2, function ()
					if slot0._buffTextTimer then
						slot0._buffTextTimer:Stop()
					end

					setActive(slot0._buffText, true)

					slot0 = slot0._buffText:getConfig("desc")

					if slot0._buffText:getConfig("max_time") > 0 then
						slot2 = pg.TimeMgr:GetInstance():GetServerTime()

						if slot1.timestamp then
							setText(slot0._buffText:Find("Text"), string.gsub(slot0, "$" .. 1, pg.TimeMgr.GetInstance():DescCDTime(slot4)))

							slot0._buffTimeCountDownTimer = Timer.New(function ()
								if slot0 > 0 then
									slot0 = slot0 - 1

									setText(slot1._buffText:Find("Text"), string.gsub(slot1._buffText.Find("Text"), "$" .. 1, pg.TimeMgr.GetInstance():DescCDTime(pg.TimeMgr.GetInstance().DescCDTime)))
								else
									slot1._buffTimeCountDownTimer:Stop()
									setActive(slot1._buffTimeCountDownTimer._buffText, false)
									setActive(slot3, false)
								end
							end, 1, -1)

							slot0._buffTimeCountDownTimer.Start(slot6)
						end
					else
						setText(slot0._buffText:Find("Text"), slot0)
					end

					slot0._buffTextTimer = Timer.New(function ()
						setActive(slot0._buffText, false)

						if setActive._buffTimeCountDownTimer ~= nil then
							slot0._buffTimeCountDownTimer:Stop()
						end
					end, slot3.BUFFTEXT_SHOW_TIME, 1)

					slot0._buffTextTimer.Start(slot2)
				end, SFX_PANEL)
			end
		end
	end)
	slot2.align(slot2, #slot1)
end

slot0.setChangeBtnInteractable = function (slot0)
	slot0._changeBtn:GetComponent(typeof(Button)).interactable = not slot0.paintingLoading and not slot0.bgLoading
end

slot0.updateFlagShip = function (slot0, slot1)
	if not slot0.live2dChar and slot0.flagShip then
		retPaintingPrefab(slot0._paintingTF, slot0.flagShip:getPainting())
	end

	slot0.flagShip = slot1

	slot0:ShowAssistInfo(slot2, slot1)

	if not (getProxy(SettingsProxy):getCharacterSetting(slot1.id, SHIP_FLAG_L2D) and isHalfBodyLive2D(slot2)) then
		rtf(slot0._paintingTF).anchorMin = Vector2(0.5, 0.5)
		rtf(slot0._paintingTF).anchorMax = Vector2(0.5, 0.5)
		rtf(slot0._paintingTF).pivot = Vector2(0.5, 0.5)
	else
		rtf(slot0._paintingTF).anchorMin = Vector2(0.5, 0)
		rtf(slot0._paintingTF).anchorMax = Vector2(0.5, 0)
		rtf(slot0._paintingTF).pivot = Vector2(0.5, 0)
	end

	slot4 = nil

	if pg.ship_skin_template[slot0.flagShip.skinId].main_UI_FX ~= "" then
		slot4 = slot5
	elseif slot1.propose then
		slot4 = "jiehuntexiao"
	end

	setActive(slot0.effectTF, slot4 ~= nil)

	if slot0._paintingFX then
		PoolMgr.GetInstance():ReturnPrefab("Effect/" .. slot6, slot0._paintingFX.name, slot0._paintingFX.obj)

		slot0._paintingFX = nil
	end

	if slot4 then
		PoolMgr.GetInstance():GetPrefab("Effect/" .. slot4, slot4, true, function (slot0)
			if not slot0.exited then
				slot0._paintingFX = {
					name = slot0,
					obj = slot0
				}

				slot0.transform:SetParent(slot0.effectTF, true)

				slot0.transform.localPosition = Vector3.zero
				slot0.transform.localScale = Vector3.one
			else
				PoolMgr.GetInstance():ReturnPrefab("Effect/" .. slot1, PoolMgr.GetInstance().ReturnPrefab, slot0)
			end
		end)
	end

	if slot0.flagShip then
		slot6 = getProxy(SettingsProxy).getCharacterSetting(slot6, slot0.flagShip.id, SHIP_FLAG_BG)
		slot8 = slot0._bg:Find("bg")

		if slot0.flagShip:getShipBgPrint() ~= slot0.flagShip:rarity2bgPrintForGet() and slot6 then
			pg.DynamicBgMgr.GetInstance():LoadBg(slot0, slot7, slot0._bg, slot8, function (slot0)
				slot0.bgLoading = false

				slot0:setChangeBtnInteractable()

				rtf(slot0).localPosition = Vector3(0, 0, 200)
			end, function (slot0)
				slot0.bgLoading = false

				slot0:setChangeBtnInteractable()

				slot0.defaultBgSprite = getImageSprite(slot0)
			end)
		else
			pg.DynamicBgMgr.GetInstance().ClearBg(slot9, slot0:getUIName())
			setActive(slot8, true)
			slot0:setBG()
		end
	end
end

slot0.setFlagShip = function (slot0, slot1)
	slot0.tempFlagShip = slot1
end

slot0.notifyActivitySummary = function (slot0, slot1, slot2)
	slot0._activitySummaryBtn = slot0:findTF("activityButton", slot0._ActivityBtns)

	setActive(slot0._activitySummaryBtn, true)
	setActive(slot0._activitySummaryBtn:Find("Tip/Text").parent, slot1 > 0)

	if slot1 > 0 then
		setText(slot3, slot1)
	end

	onButton(slot0, slot0._activitySummaryBtn, function ()
		slot0.emit(slot1, MainUIMediator.OPEN_ACTIVITY_PANEL, {
			id = slot0.emit and slot1.id
		})
	end, SFX_PANEL)
end

slot0.updateChat = function (slot0, slot1)
	if slot0.exited then
		return
	end

	if slot0.hideChatFlag and slot0.hideChatFlag == 1 then
		return
	end

	for slot6 = slot0._chatList.childCount, #slot1 - 1, 1 do
		cloneTplTo(slot0._chatItem, slot0._chatList)
	end

	setActive(slot0._chatEmptySign, PLATFORM_CODE == PLATFORM_JP and slot0._chatList.childCount <= 0)

	for slot6 = 0, slot2 - 1, 1 do
		slot0._chatList:GetChild(slot6).gameObject:SetActive(slot6 < #slot1)
	end

	for slot6, slot7 in ipairs(slot1) do
		slot0:findTF("channel", slot8):GetComponent("Image").sprite = GetSpriteFromAtlas("channel", ChatConst.GetChannelSprite(slot7.type) .. "_1920", true)
		slot10 = slot0:findTF("text", slot0._chatList:GetChild(slot6 - 1)):GetComponent("RichText")

		if slot7.type == ChatConst.ChannelPublic then
			slot10.supportRichText = true

			ChatProxy.InjectPublic(slot10, slot7, true)
		elseif slot7:IsWorldBossNotify() then
			slot10.supportRichText = true
			slot10.text = i18n("ad_4", slot7.args.supportType, slot7.args.playerName, slot7.args.bossName, slot7.args.level)
		else
			slot10.supportRichText = slot7.emojiId ~= nil
			slot11 = false
			slot13 = false

			for slot18 in nil do
				if table.contains(pg.emoji_small_template.all, tonumber(slot18)) then
					slot13 = true

					slot10:AddSprite(slot18, LoadSprite("emoji/" .. pg.emoji_small_template[tonumber(slot18)].pic .. "_small", nil))
				end
			end

			if not slot7.emojiId then
				slot10.text = string.gsub((not slot13 or shortenString(slot12, 20)) and shortenString(slot12, 24), ChatConst.EmojiIconCodeMatch, function (slot0)
					if table.contains(pg.emoji_small_template.all, tonumber(slot0)) then
						return string.format("<icon name=%s w=0.7 h=0.7/>", slot0)
					end
				end)
			end
		end
	end
end

slot0.clearChat = function (slot0, slot1)
	childCount = slot0._chatList.childCount

	for slot5 = 0, childCount - 1, 1 do
		slot0._chatList:GetChild(slot5).gameObject:SetActive(false)
	end
end

slot0.updateBanner = function (slot0, slot1)
	slot2 = slot0:findTF("eventPanel/mask/event", slot0._rightPanel):GetComponent("HScrollSnap")

	slot2:Init()

	slot3 = slot0:findTF("content", slot2)
	slot5 = slot0:findTF("eventPanel/dots", slot0._rightPanel)

	setActive(slot4, false)
	setActive(slot6, false)

	for slot10 = 0, #slot1 - 1, 1 do
		cloneTplTo(slot6, slot5)

		slot12 = Instantiate(slot4)

		LoadImageSpriteAsync("activitybanner/" .. slot1[slot10 + 1].pic, slot12)
		slot2:AddChild(slot12)
		onButton(slot0, slot12, function ()
			if slot0.type == GAMEUI_BANNER_1 then
				Application.OpenURL(slot0.param)
			elseif slot0.type == GAMEUI_BANNER_2 then
				slot1:emit(MainUIMediator.GO_SCENE, slot0.param)
			elseif slot0.type == GAMEUI_BANNER_3 then
				slot1:emit(MainUIMediator.OPEN_ACTIVITY_PANEL, tonumber(slot0.param))
			elseif slot0.type == GAMEUI_BANNER_4 then
				slot1:emit(MainUIMediator.OPEN_SHOP_LAYER, slot0.param)
			elseif slot0.type == GAMEUI_BANNER_5 then
				slot1:emit(MainUIMediator.OPEN_SCROLL, tonumber(slot0.param))
			elseif slot0.type == GAMEUI_BANNER_6 then
				slot1:emit(MainUIMediator.OPEN_TECHNOLOGY)
			elseif slot0.type == GAMEUI_BANNER_7 then
				slot1:emit(MainUIMediator.GO_MINI_GAME, slot0.param[1])
			elseif slot0.type == GAMEUI_BANNER_8 then
				slot1:emit(MainUIMediator.OPEN_GUILD)
			end
		end, SFX_MAIN)
		setActive(findTF(slot12, "red"), false)

		if slot1[slot10 + 1].type == 3 and tonumber(slot11.param) == nil then
			setActive(slot13, getProxy(ActivityProxy):readyToAchieveByType(ActivityConst.ACTIVITY_TYPE_LEVELAWARD))
		end

		slot12:SetActive(true)
	end

	slot2.autoSnap = 5
	slot0.bannerSnap = slot2
	slot0.bannerContent = slot3
	slot0.bannerDots = slot5
end

slot0.activeEffect = function (slot0, slot1)
	setActive(slot0._paintingTF, slot1)
	setActive(slot0._linkBtns, slot1)
end

slot0.resetCommissionBtn = function (slot0)
	LeanTween.moveX(slot0._commissionBtn, 0, 0.2)
end

slot0.updateExSkinBtn = function (slot0, slot1)
	setActive(slot0.exSkinBtn, #slot1 > 0)

	if #slot1 > 0 then
		onButton(slot0, slot0.exSkinBtn, function ()
			slot0:showExSkinWindow(slot0)
		end, SFX_PANEL)
	end

	slot0._buffList.localPosition = Vector3((#slot1 > 0 and 390) or 285, slot0._buffList.localPosition.y, slot0._buffList.localPosition.z)
	slot0._buffText.localPosition = Vector3((#slot1 > 0 and 339) or 234, -90, slot0._buffList.localPosition.z)
end

slot0.showExSkinWindow = function (slot0, slot1)
	slot0.skinExperienceDiplayPage:ExecuteAction("Show", slot1)
end

slot0.showOverDueExSkins = function (slot0, slot1)
	slot0.skinExpireDisplayPage:ExecuteAction("Show", slot1)
end

slot0.resumePaitingState = function (slot0)
	GetOrAddComponent(slot0._tf, typeof(CanvasGroup)).blocksRaycasts = true
	GetOrAddComponent(slot0._paintingTF, typeof(CanvasGroup)).alpha = 1
end

slot0.willExit = function (slot0)
	if slot0._paintingTimer then
		slot0._paintingTimer:Stop()

		slot0._paintingTimer = nil
	end

	if slot0.redDotHelper then
		slot0.redDotHelper:Dispose()

		slot0.redDotHelper = nil
	end

	slot0:RemoveVoteBookTimer()
	slot0:disablePartialBlur()

	if slot0.leans then
		for slot4, slot5 in ipairs(slot0.leans) do
			LeanTween.cancel(go(slot5))
		end

		slot0.leans = {}
	end

	LeanTween.cancel(go(slot0._paintingTF))
	slot0:resumePaitingState()
	LeanTween.cancel(slot0._chat.gameObject)

	if slot0._delayVoiceTweenID then
		LeanTween.cancel(slot0._delayVoiceTweenID)

		slot0._delayVoiceTweenID = nil
	end

	if slot0._delayL2dSeID then
		LeanTween.cancel(slot0._delayL2dSeID)

		slot0._delayL2dSeID = nil
	end

	if slot0._paintingFX then
		PoolMgr.GetInstance():ReturnPrefab("Effect/" .. slot1, slot0._paintingFX.name, slot0._paintingFX.obj)

		slot0._paintingFX = nil
	end

	if slot0.chatTimer then
		slot0.chatTimer:Stop()

		slot0.chatTimer = nil
	end

	pg.TimeMgr.GetInstance():RemoveTimer(slot0._timeSchedule)

	slot0._timeSchedule = nil

	if slot0._resPanel then
		slot0._resPanel:exit()

		slot0._resPanel = nil
	end

	if slot0.flagShip then
		retPaintingPrefab(slot0._paintingTF, slot0.flagShip:getPainting())
	end

	if slot0.live2dChar then
		slot0.live2dChar:Dispose()

		slot0.live2dChar = nil
	end

	if slot0.spinePainting then
		slot0.spinePainting:Dispose()

		slot0.spinePainting = nil
	end

	for slot4 = slot0.bannerContent.childCount - 1, 0, -1 do
		clearImageSprite(slot0.bannerContent:GetChild(slot4))
		Destroy(slot0.bannerSnap:RemoveChild(slot4))
	end

	removeAllChildren(slot0.bannerDots)

	if slot0._currentVoice then
		slot0._currentVoice:Stop(true)
	end

	slot0._currentVoice = nil

	slot0:stopCurVoice()
	setActive(slot0._bg:Find("bg"), true)

	if slot0.defaultBgSprite then
		setImageSprite(slot0._bg:Find("bg"), slot0.defaultBgSprite)

		slot0.defaultBgSprite = nil
	end

	if slot0._buffTextTimer then
		slot0._buffTextTimer:Stop()

		slot0._buffTextTimer = nil
	end

	if slot0._buffTimeCountDownTimer then
		slot0._buffTimeCountDownTimer:Stop()

		slot0._buffTimeCountDownTimer = nil
	end

	slot0:recycleSpineChar()
	slot0.skinExpireDisplayPage:Destroy()

	slot0.skinExpireDisplayPage = nil

	slot0.attireExpireDisplayPage:Destroy()

	slot0.attireExpireDisplayPage = nil

	slot0.skinExperienceDiplayPage:Destroy()

	slot0.skinExperienceDiplayPage = nil

	slot0.secondaryPage:Destroy()

	slot0.secondaryPage = nil
end

slot0.sethideChatBtn = function (slot0)
	setActive(slot0._chatActBtn, slot0.hideChatFlag and slot0.hideChatFlag == 1)
	setActive(slot0._chatActBtnDisable, not (slot0.hideChatFlag and slot0.hideChatFlag == 1))

	if slot0.hideChatFlag and slot0.hideChatFlag == 1 then
		slot0:clearChat()
	end

	slot0._chatBg:GetComponent(typeof(Button)).enabled = not slot1
	slot0._chatBtn:GetComponent(typeof(Button)).enabled = not slot1
end

slot0.showOverDueAttire = function (slot0, slot1)
	slot0.attireExpireDisplayPage:ExecuteAction("Show", slot1)
end

slot0.loadChar = function (slot0, slot1)
	if not slot0.shipPrefab then
		slot0.shipPrefab = slot1

		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetSpineChar(slot1, true, function (slot0)
			pg.UIMgr.GetInstance():LoadingOff()

			slot0.shipModel = slot0
			tf(slot0).localScale = Vector3(0.75, 0.75, 1)
			tf(slot0).localPosition = Vector3((tf(slot0)[Vector3(0.75, 0.75, 1)] and slot1.mainui_shift[1]) or 0, (slot1 and slot1.mainui_shift[2]) or 0, 0)

			setParent(slot0, slot0._icon)
			slot0:GetComponent("SpineAnimUI"):SetAction("normal", 0)
		end)
	end
end

slot0.recycleSpineChar = function (slot0)
	if slot0.shipPrefab and slot0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(slot0.shipPrefab, slot0.shipModel)

		slot0.shipPrefab = nil
		slot0.shipModel = nil
	end
end

slot0.checkRefundInfo = function (slot0, slot1)
	if getProxy(PlayerProxy):getRefundInfo() then
		slot3 = getProxy(ServerProxy)
		slot4 = true

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideClose = true,
			content = i18n("Supplement_pay1"),
			onYes = function ()
				if slot0 then
					slot1:emit(MainUIMediator.GO_SCENE, {
						SCENE.BACK_CHARGE
					})
				else
					Application.Quit()
				end

				slot2()
			end,
			onNo = function ()
				slot0:emit(MainUIMediator.LOG_OUT)
			end,
			yesText = i18n("Supplement_pay4"),
			noText = i18n("word_back")
		})
	end
end

return slot0

slot0 = class("DecodeGameView")

slot0.Ctor = function (slot0, slot1)
	pg.DelegateInfo.New(slot0)

	slot0.controller = slot1
end

slot0.SetUI = function (slot0, slot1)
	slot0._tf = slot1
	slot0._go = go(slot1)
	slot0.mapItemContainer = slot0._tf:Find("game/container")
	slot0.itemList = UIItemList.New(slot0.mapItemContainer, slot0._tf:Find("game/container/tpl"))
	slot0.mapLine = slot0._tf:Find("game/line")

	setActive(slot0.mapLine, false)

	slot0.mapBtns = {
		slot0._tf:Find("btn/btn1"),
		slot0._tf:Find("btn/btn2"),
		slot0._tf:Find("btn/btn3")
	}
	slot0.engines = {
		slot0._tf:Find("tuitong/1"),
		slot0._tf:Find("tuitong/2"),
		slot0._tf:Find("tuitong/3")
	}
	slot0.engineBottom = slot0._tf:Find("tuitong/4")
	slot0.number1 = slot0._tf:Find("shuzi/1"):GetComponent(typeof(Image))
	slot0.number2 = slot0._tf:Find("shuzi/2"):GetComponent(typeof(Image))
	slot0.awardProgressTF = slot0._tf:Find("zhuanpanxinxi/jindu")
	slot0.awardProgress1TF = slot0._tf:Find("zhuanpanxinxi/jindu/zhuanpan")
	slot0.mapProgreeses = {
		slot0._tf:Find("zhuanpanxinxi/deng1"),
		slot0._tf:Find("zhuanpanxinxi/deng2"),
		slot0._tf:Find("zhuanpanxinxi/deng3")
	}
	slot0.mapPasswords = {
		slot0._tf:Find("dengguang/code1/1"),
		slot0._tf:Find("dengguang/code1/2"),
		slot0._tf:Find("dengguang/code1/3"),
		slot0._tf:Find("dengguang/code1/4"),
		slot0._tf:Find("dengguang/code1/5"),
		slot0._tf:Find("dengguang/code1/6")
	}
	slot0.encodingPanel = slot0._tf:Find("encoding")
	slot0.encodingSlider = slot0._tf:Find("encoding/slider/bar")

	setActive(slot0.encodingPanel, false)

	slot0.enterAnim = slot0._tf:Find("enter_anim")
	slot0.enterAnimTop = slot0._tf:Find("enter_anim/top")
	slot0.enterAnimBottom = slot0._tf:Find("enter_anim/bottom")

	setActive(slot0.enterAnim, false)

	slot0.bookBtn = slot0._tf:Find("btn/mima/unlock")
	slot0.mimaLockBtn = slot0._tf:Find("btn/mima/lock")
	slot0.mimaLockBlink = slot0._tf:Find("btn/mima/blink")
	slot0.code1Panel = slot0._tf:Find("dengguang/code1")
	slot0.code2Panel = slot0._tf:Find("dengguang/code2")
	slot0.passWordTF = slot0._tf:Find("game/password")
	slot0.containerSize = slot0.mapItemContainer.sizeDelta
	slot0.mosaic = slot0._tf:Find("game/Mosaic")
	slot0.lines = slot0._tf:Find("game/grids")
	slot0.code2 = {
		slot0._tf:Find("dengguang/code2/1"),
		slot0._tf:Find("dengguang/code2/2"),
		slot0._tf:Find("dengguang/code2/3"),
		slot0._tf:Find("dengguang/code2/4"),
		slot0._tf:Find("dengguang/code2/5"),
		slot0._tf:Find("dengguang/code2/6"),
		slot0._tf:Find("dengguang/code2/7"),
		slot0._tf:Find("dengguang/code2/8"),
		slot0._tf:Find("dengguang/code2/9")
	}
	slot0.lightRight = slot0._tf:Find("dengguang/code2/light_right")
	slot0.lightLeft = slot0._tf:Find("dengguang/code2/light_left")
	slot0.awardLock = slot0._tf:Find("zhuanpanxinxi/item/lock")
	slot0.awardGot = slot0._tf:Find("zhuanpanxinxi/item/got")
	slot0.screenHeight = slot0._tf.rect.height
	slot0.engineBottom.localPosition = Vector3(slot0.engineBottom.localPosition.x, -slot0.screenHeight / 2, 0)
	slot0.code2Panel.localPosition = Vector3(slot0.code2Panel.localPosition.x, slot0.screenHeight / 2, 0)
	slot0.line1 = slot0._tf:Find("game/lines/line1")
	slot0.blinkFlag = false
	slot0.helperTF = slot0._tf:Find("helper")
	slot0.tips = slot0._tf:Find("btn/tips")
	slot0.animCallbacks = {}
	slot0.decodeTV = slot0._tf:Find("game/zhezhao/DecodeTV")
	slot0.anim = slot0.decodeTV:GetComponent(typeof(Animator))
	slot0.dftAniEvent = slot0.decodeTV:GetComponent(typeof(DftAniEvent))

	slot0.dftAniEvent:SetEndEvent(function (slot0)
		for slot4, slot5 in ipairs(slot0.animCallbacks) do
			slot5()
		end

		slot0.animCallbacks = {}

		setActive(slot0.decodeTV, false)
	end)

	slot0.codeHeight = slot0.screenHeight / 2 - slot0.code1Panel.anchoredPosition.y
	slot0.code2Panel.sizeDelta = Vector2(slot0.code2Panel.sizeDelta.x, slot0.codeHeight)
	slot0.code1Panel.sizeDelta = Vector2(slot0.code1Panel.sizeDelta.x, slot0.codeHeight)
end

slot0.DoEnterAnim = function (slot0, slot1)
	setActive(slot0.enterAnim, true)
	LeanTween.moveLocalY(go(slot0.enterAnimTop), slot0.screenHeight / 2, 1):setFrom(-75):setDelay(DecodeGameConst.OPEN_DOOR_DELAY)
	LeanTween.moveLocalY(go(slot0.enterAnimBottom), -slot0.screenHeight / 2, 1):setFrom(75):setDelay(DecodeGameConst.OPEN_DOOR_DELAY):setOnComplete(System.Action(function ()
		slot0()
		setActive(slot1.enterAnim, false)
	end))
	updateDrop(slot0._tf.Find(slot3, "zhuanpanxinxi/item"), {
		id = DecodeGameConst.AWARD[2],
		type = DecodeGameConst.AWARD[1],
		count = DecodeGameConst.AWARD[3]
	})
end

slot0.Inited = function (slot0, slot1)
	onButton(slot0, slot0._tf:Find("btn/back"), function ()
		slot0.controller:ExitGame()
	end, SFX_CANCEL)
	onButton(slot0, slot0._tf:Find("btn/help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.decodegame_gametip.tip
		})
	end, SFX_PANEL)

	slot0.ison = false

	onButton(slot0, slot0.bookBtn, function ()
		if slot0.controller:CanSwitch() then
			slot0.ison = not slot0.ison

			slot0.controller:SwitchToDecodeMap(slot0.ison)
			setActive(slot0.bookBtn:Find("Image"), slot0.ison)
		end
	end)

	for slot5, slot6 in ipairs(slot0.mapBtns) do
		onButton(slot0, slot6, function ()
			slot0.controller:SwitchMap(slot0.controller)
		end)
	end

	setActive(slot0.awardLock, not slot1)
	setActive(slot0.awardGot, slot1)
end

slot0.UpdateMap = function (slot0, slot1)
	slot0.mapItems = {}

	slot0.itemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1:UpdateMapItem(slot2, slot0, slot0.items[slot1 + 1], slot1 + 1)
		end
	end)
	slot0.itemList.align(slot2, #slot1.items)

	slot2 = _.flatten(slot1.password)

	for slot6, slot7 in ipairs(slot0.mapPasswords) do
		slot8 = "-"

		if slot1.isUnlock then
			slot8 = slot2[slot6]
		end

		slot7:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/DecodeGameUI_atlas", slot8 .. "-1")
	end

	setActive(slot0.mosaic, not slot1.isUnlock)
end

slot0.UpdateMapItem = function (slot0, slot1, slot2, slot3, slot4)
	slot1.localPosition = slot3.position
	go(slot1).name = slot3.index
	slot7 = slot1:Find("rect/icon").GetComponent(slot6, typeof(Image))
	slot7.sprite = GetSpriteFromAtlas("puzzla/bg_" .. slot2.id + DecodeGameConst.MAP_NAME_OFFSET, slot2.id .. "-" .. ((slot2.isUnlock and slot4) or DecodeGameConst.DISORDER[slot4]))

	slot7:SetNativeSize()

	slot6:GetComponent(typeof(CanvasGroup)).alpha = (slot3.isUnlock and 1) or 0

	setActive(slot1:Find("rays"), false)
	setActive(slot1:Find("rays/yellow"), false)
	setActive(slot1:Find("rays/blue"), false)
	onButton(slot0, slot1, function ()
		slot0.controller:Unlock(slot1.index)
	end, SFX_PANEL)

	slot0.mapItems[slot3.index] = slot1
end

slot0.OnMapRepairing = function (slot0, slot1)
	pg.UIMgr.GetInstance():BlurPanel(slot0.encodingPanel)
	setActive(slot0.encodingPanel, true)
	LeanTween.value(go(slot0.encodingSlider), 0, 1, DecodeGameConst.DECODE_MAP_TIME):setOnUpdate(System.Action_float(function (slot0)
		setFillAmount(slot0.encodingSlider, slot0)
	end)).setOnComplete(slot2, System.Action(function ()
		pg.UIMgr.GetInstance():UnblurPanel(slot0.encodingPanel, slot0._tf)
		setActive(slot0.encodingPanel, false)
		slot0.encodingPanel()
	end))
end

slot0.OnSwitch = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot8 = slot0.mapBtns[slot1]
	slot12 = slot0.engines[slot1].Find(slot9, "tui").sizeDelta.y

	LeanTween.moveLocalX(slot10, slot2, DecodeGameConst.SWITCH_MAP):setFrom(slot3)
	LeanTween.value(go(slot11), slot4, slot5, DecodeGameConst.SWITCH_MAP):setOnUpdate(System.Action_float(function (slot0)
		slot0.sizeDelta = Vector2(slot0, slot0)
	end))
	LeanTween.rotateZ(go(slot8), slot6, DecodeGameConst.SWITCH_MAP):setOnComplete(System.Action(slot7))
end

slot0.OnExitMap = function (slot0, slot1, slot2, slot3)
	if slot2 then
		slot0.mapItemContainer.sizeDelta = Vector2(slot0.containerSize.x, 0)
	end

	slot0:OnSwitch(slot1, -11, -150, 158, 23, 0, slot3)
end

slot0.OnEnterMap = function (slot0, slot1, slot2, slot3)
	parallelAsync({
		function (slot0)
			slot0:OnSwitch(slot0.OnSwitch, -150, -11, 23, 158, 90, function ()
				slot0()
			end)
		end,
		function (slot0)
			if not slot0 then
				slot0()

				return
			end

			setActive(slot1.mapLine, true)
			LeanTween.value(go(slot1.mapItemContainer), 0, slot1.containerSize.y, DecodeGameConst.SCAN_MAP_TIME):setOnUpdate(System.Action_float(function (slot0)
				slot0.mapItemContainer.sizeDelta = Vector2(slot0.containerSize.x, slot0)
			end)).setOnComplete(slot1, System.Action(function ()
				setActive(slot0.mapLine, false)
				slot0.mapLine()
			end))
			LeanTween.value(go(slot1.mapLine), 286, 286 - slot1.containerSize.y, DecodeGameConst.SCAN_MAP_TIME).setOnUpdate(slot1, System.Action_float(function (slot0)
				slot0.mapLine.localPosition = Vector2(slot0.mapLine.localPosition.x, slot0, 0)
			end))
		end
	}, slot3)
end

slot0.UnlockMapItem = function (slot0, slot1, slot2)
	slot4 = slot0.mapItems[slot1].Find(slot3, "rect/icon")
	slot5 = slot4:GetComponent(typeof(CanvasGroup))

	LeanTween.value(go(slot4), 0, 1, 0.3):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end)).setOnComplete(slot6, System.Action(slot2))
end

slot0.UpdateCanUseCnt = function (slot0, slot1)
	slot0.number1.sprite = GetSpriteFromAtlas("ui/DecodeGameUI_atlas", slot2)
	slot0.number2.sprite = GetSpriteFromAtlas("ui/DecodeGameUI_atlas", slot1 % 10)
	tf(slot0.number1).localPosition = (math.floor(slot1 / 10) == 1 and Vector3(-625, -17)) or Vector3(-660, -17)
	tf(slot0.number2).localPosition = (slot3 == 1 and Vector3(-516.8, -17)) or Vector3(-546.3, -17)
end

slot0.UpdateProgress = function (slot0, slot1, slot2, slot3, slot4)
	if slot1 < DecodeGameConst.MAP_ROW * DecodeGameConst.MAP_COLUMN * DecodeGameConst.MAX_MAP_COUNT then
		setFillAmount(slot0.awardProgressTF, slot5 * DecodeGameConst.PROGRESS2FILLAMOUMT)
	else
		setFillAmount(slot0.awardProgressTF, 1)
	end

	slot0.awardProgress1TF.eulerAngles = Vector3(0, 0, 180 - slot5 * DecodeGameConst.PROGRESS2ANGLE)

	setActive(slot0.bookBtn, slot2 == DecodeGameConst.MAX_MAP_COUNT)
	setActive(slot0.mapProgreeses[1], slot3[1])
	setActive(slot0.mapProgreeses[2], slot3[2])
	setActive(slot0.mapProgreeses[3], slot3[3])

	if slot2 == DecodeGameConst.MAX_MAP_COUNT and not slot0.blinkFlag then
		LeanTween.moveLocalX(go(slot0.mimaLockBtn), 150, 0.3):setOnComplete(System.Action(function ()
			setActive(slot0.mimaLockBlink, true)
			blinkAni(go(slot0.mimaLockBlink), 0.2, 2):setOnComplete(System.Action(function ()
				setActive(slot0.mimaLockBlink, false)
				slot0.mimaLockBlink()
			end))
		end))

		slot0.blinkFlag = true
	elseif slot2 == DecodeGameConst.MAX_MAP_COUNT then
		slot0.mimaLockBtn.localPosition = Vector3(150, 0, 0)

		setActive(slot0.mimaLockBlink, false)
	else
		slot0.mimaLockBtn.localPosition = Vector3(0, 0, 0)

		slot4()
	end
end

slot0.OnEnterDecodeMapBefore = function (slot0, slot1)
	setActive(slot0.mosaic, true)
	setActive(slot0.lines, false)
	LeanTween.moveLocalY(go(slot0.code1Panel), slot0.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(slot1))
end

slot0.OnEnterDecodeMap = function (slot0, slot1, slot2)
	parallelAsync({
		function (slot0)
			_.each(slot0.code2, function (slot0)
				setActive(slot0, false)
			end)
			LeanTween.moveLocalY(go(slot0.engineBottom), -500, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2)
			LeanTween.moveLocalY(go(slot0.code2Panel), 303, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2).setOnComplete(slot1, System.Action(slot0))
		end
	}, function ()
		setActive(slot0.mosaic, false)
		setActive(slot0.lines, false)

		for slot3, slot4 in ipairs(slot0.lines) do
			slot0:UpdatePassWord(slot4, slot3)
		end

		setActive(slot0.passWordTF, true)
		true()
	end)
end

slot0.OnEnterNormalMapBefore = function (slot0, slot1)
	parallelAsync({
		function (slot0)
			LeanTween.moveLocalY(go(slot0.code2Panel), slot0.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(slot0))
		end,
		function (slot0)
			LeanTween.moveLocalY(go(slot0.engineBottom), -slot0.screenHeight / 2, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(slot0))
		end
	}, slot1)
end

slot0.OnEnterNormalMap = function (slot0, slot1, slot2)
	seriesAsync({
		function (slot0)
			LeanTween.moveLocalY(go(slot0.code1Panel), 303, DecodeGameConst.SWITCH_TO_DECODE_TIME / 2):setOnComplete(System.Action(slot0))
		end,
		function (slot0)
			setActive(slot0.passWordTF, false)
			slot0()
		end,
		function (slot0)
			slot0.mapItemContainer.sizeDelta = slot0.containerSize

			for slot4, slot5 in ipairs(slot1.passwordIndexs) do
				slot0.mapItems[slot5].Find(slot6, "rect/icon"):GetComponent(typeof(CanvasGroup)).alpha = 1

				setActive(slot0.mapItems[slot5].Find(slot6, "rays"), false)
			end

			slot0()
		end
	}, slot2)
end

slot0.OnDecodeMap = function (slot0, slot1, slot2)
	slot3 = {}

	function slot4(slot0)
		for slot4, slot5 in ipairs(slot0.items) do
			if slot5.index == slot0 then
				return slot5
			end
		end
	end

	for slot8, slot9 in ipairs(slot1.passwordIndexs) do
		slot0.mapItems[slot9].SetAsLastSibling(slot10)
		table.insert(slot3, {
			target = slot0.mapItems[slot9],
			sizeDelta = slot0.mapItems[slot9].Find(slot10, "rect").sizeDelta,
			starPosition = Vector2(slot0.mapItems[slot9].localPosition.x + slot0.mapItems[slot9].Find(slot10, "rect").sizeDelta.x / 2, slot0.mapItems[slot9].localPosition.y - slot0.mapItems[slot9].Find(slot10, "rect").sizeDelta.y / 2),
			endPosition = Vector2(slot0.mapItems[slot9].localPosition.x - slot0.mapItems[slot9].Find(slot10, "rect").sizeDelta.x / 2, slot0.mapItems[slot9].localPosition.y + slot0.mapItems[slot9].Find(slot10, "rect").sizeDelta.y / 2),
			item = slot4(slot9)
		})
	end

	function slot5()
		slot0 = Vector2(0, slot0.line1.localPosition.y)

		for slot4, slot5 in ipairs(ipairs) do
			slot8 = slot5.endPosition
			slot10 = slot5.target.Find(slot6, "rect").sizeDelta

			if slot5.starPosition.y <= slot0.y and slot0.y <= slot8.y then
				slot9.sizeDelta = Vector2(slot10.x, slot5.sizeDelta.y - (slot0.y - slot7.y))
			end
		end
	end

	setActive(slot0.line1, true)

	slot6 = DecodeGameConst.BLOCK_SIZE[1] * DecodeGameConst.MAP_ROW

	LeanTween.value(go(slot0.line1), 0, slot6, DecodeGameConst.SCAN_GRID_TIME):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0.line1, {
			y = slot0
		})
		setAnchoredPosition()
	end)).setOnComplete(slot7, System.Action(function ()
		setActive(slot0.line1, false)

		for slot3, slot4 in ipairs(slot0.line1) do
			slot4.target:Find("rect/icon"):GetComponent(typeof(CanvasGroup)).alpha = 0
			slot4.target:Find("rect").sizeDelta = slot4.sizeDelta

			setActive(slot4.target:Find("rays"), true)
			setActive(slot4.target:Find("rays/blue"), slot4.item.isUsed)
		end

		slot2()
	end))
end

slot0.UpdatePassWord = function (slot0, slot1, slot2)
	if slot1 == false then
		return
	end

	slot0.code2[slot2].GetComponent(slot3, typeof(Image)).sprite = GetSpriteFromAtlas("ui/DecodeGameUI_atlas", slot1 .. "-1")

	setActive(slot0.code2[slot2], true)
end

slot0.OnRightCode = function (slot0, slot1, slot2, slot3)
	slot0:UpdatePassWord(slot2, slot3)
	setActive(slot0.mapItems[slot1].Find(slot4, "rays/blue"), true)
	setActive(slot0.lightRight, true)

	slot0.timer2 = Timer.New(function ()
		setActive(slot0.lightRight, false)
	end, 1, 1)

	slot0.timer2.Start(slot5)
end

slot0.OnFalseCode = function (slot0, slot1)
	slot0:RemoveTimers()
	setActive(slot0.lightLeft, true)

	slot0.timer1 = Timer.New(function ()
		setActive(slot0.lightLeft, false)
	end, 1, 1)

	slot0.timer1.Start(slot2)
	setActive(slot3, true)
	blinkAni(slot3, 0.2, 2):setOnComplete(System.Action(function (...)
		setActive(setActive, false)
	end))
end

slot0.RemoveTimers = function (slot0)
	if slot0.timer1 then
		slot0.timer1:Stop()

		slot0.timer1 = nil
	end

	if slot0.timer2 then
		slot0.timer2:Stop()

		slot0.timer2 = nil
	end
end

slot0.OnSuccess = function (slot0, slot1)
	LeanTween.value(slot2, 0, -140, DecodeGameConst.GET_AWARD_ANIM_TIME / 2):setOnUpdate(System.Action_float(function (slot0)
		tf(slot0).eulerAngles = Vector3(0, 0, slot0)
	end)).setOnComplete(slot3, System.Action(function ()
		LeanTween.moveLocalX(LeanTween.moveLocalX, 132, DecodeGameConst.GET_AWARD_ANIM_TIME / 2):setFrom(0):setOnComplete(System.Action(function ()
			setActive(slot0.awardLock, false)
			setActive(slot0.awardGot, true)
			slot0.awardGot()
		end))
	end))
end

slot0.ShowHelper = function (slot0, slot1, slot2)
	if PlayerPrefs.GetInt("DecodeGameHelpBg" .. slot3 .. slot1, 0) > 0 then
		slot2()

		return
	end

	PlayerPrefs.SetInt("DecodeGameHelpBg" .. slot3 .. slot1, 1)
	PlayerPrefs.Save()
	setActive(slot0.helperTF, true)

	slot5 = slot0.helperTF:Find("Image")

	setImageSprite(slot5, slot8)

	slot5.sizeDelta = Vector2(DecodeGameConst.HELP_BGS[slot1][2][1], DecodeGameConst.HELP_BGS[slot1][2][2])
	slot5.localPosition = Vector3(DecodeGameConst.HELP_BGS[slot1][3][1], DecodeGameConst.HELP_BGS[slot1][3][2], 0)

	onButton(slot0, slot0.helperTF, function ()
		setActive(slot0.helperTF, false)
		slot0.helperTF()
	end, SFX_PANEL)
end

slot0.ShowTip = function (slot0, slot1)
	eachChild(slot0.tips, function (slot0)
		setActive(slot0, go(slot0).name == tostring(slot0))
	end)
end

slot0.PlayVoice = function (slot0, slot1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot1)
end

slot0.OnSwitchMap = function (slot0, slot1)
	slot0:PlayerMapStartAnim(slot1)
end

slot0.PlayerMapStartAnim = function (slot0, slot1)
	setActive(slot0.decodeTV, true)
	table.insert(slot0.animCallbacks, slot1)
	slot0.anim:SetTrigger("trigger")
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)

	slot0.mapItems = nil

	slot0:RemoveTimers()
	slot0.dftAniEvent:SetEndEvent(nil)

	slot0.animCallbacks = nil
end

return slot0

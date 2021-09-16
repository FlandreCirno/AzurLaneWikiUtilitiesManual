slot0 = class("GuessForkGameView", import("..BaseMiniGameView"))
slot1 = {
	100,
	50
}
slot2 = {
	10
}
slot3 = {
	20
}
slot4 = {
	3,
	3,
	3,
	4,
	4,
	4,
	5,
	5,
	5,
	6,
	6,
	6,
	7,
	7,
	7,
	8,
	8,
	8,
	8,
	9,
	9,
	9,
	9,
	9,
	10,
	10,
	10,
	10,
	10,
	10,
	11,
	11,
	11,
	11,
	11,
	12
}
slot5 = {
	1000,
	200
}
slot6 = 10000
slot7 = 2
slot8 = 2
slot9 = "event:/ui/ddldaoshu2"
slot10 = "event:/ui/taosheng"
slot11 = "event:/ui/zhengque"
slot12 = "event:/ui/shibai"
slot13 = "backyard"
slot14 = {
	"Cup_B",
	"Cup_G",
	"Cup_P",
	"Cup_R",
	"Cup_Y"
}
slot15 = 3
slot16 = 0.5
slot17 = "Thinking_Loop"
slot18 = {
	"Select_L",
	"Select_M",
	"Select_R"
}
slot19 = {
	"Correct_L",
	"Correct_M",
	"Correct_R"
}
slot20 = {
	"Incorrect_L",
	"Incorrect_M",
	"Incorrect_R"
}
slot21 = "Manjuu_Correct"
slot22 = {
	"Ayanami",
	"Cheshire",
	"Eldridge",
	"Formidable",
	"Javelin",
	"Laffey",
	"LeMalin",
	"Merkuria",
	"PingHai",
	"Roon",
	"Saratoga",
	"Shiratsuyu",
	"Yukikaze",
	"Z23"
}

slot0.getUIName = function (slot0)
	return "GuessForkGameUI"
end

slot0.getBGM = function (slot0)
	return slot0
end

slot0.init = function (slot0)
	slot0.countUI = slot0:findTF("count_ui")
	slot0.countAnimator = slot0:findTF("count_bg/count", slot0.countUI):GetComponent(typeof(Animator))
	slot0.countDft = slot0:findTF("count_bg/count", slot0.countUI):GetComponent(typeof(DftAniEvent))

	slot0.countDft:SetEndEvent(function ()
		setActive(slot0.countUI, false)
		setActive:startGame()
	end)

	slot0.pauseUI = slot0.findTF(slot0, "pause_ui")
	slot0.resuemBtn = slot0:findTF("box/sure_btn", slot0.pauseUI)

	setText(slot0:findTF("box/content", slot0.pauseUI), i18n("idolmaster_game_tip1"))

	slot0.exitUI = slot0:findTF("exit_ui")
	slot0.exitSureBtn = slot0:findTF("box/sure_btn", slot0.exitUI)
	slot0.exitCancelBtn = slot0:findTF("box/cancel_btn", slot0.exitUI)

	setText(slot0:findTF("box/content", slot0.exitUI), i18n("idolmaster_game_tip2"))

	slot0.endUI = slot0:findTF("end_ui")
	slot0.endSureBtn = slot0:findTF("box/sure_btn", slot0.endUI)

	setText(slot0:findTF("box/cur_score", slot0.endUI), i18n("idolmaster_game_tip3"))

	slot0.endScoreTxt = slot0:findTF("box/cur_score/score", slot0.endUI)
	slot0.newTag = slot0:findTF("new", slot0.endScoreTxt)

	setText(slot0:findTF("box/highest_score", slot0.endUI), i18n("idolmaster_game_tip4"))

	slot0.highestScoreTxt = slot0:findTF("box/highest_score/score", slot0.endUI)
	slot0.gameUI = slot0:findTF("game_ui")
	slot0.returnBtn = slot0:findTF("top/return_btn", slot0.gameUI)
	slot0.pauseBtn = slot0:findTF("top/pause_btn", slot0.gameUI)
	slot0.roundTxt = slot0:findTF("top/title/round/num", slot0.gameUI)
	slot0.roundNum = 0
	slot0.curScoreTxt = slot0:findTF("top/title/score_title/score", slot0.gameUI)
	slot0.curScore = 0

	setText(slot0.curScoreTxt, slot0.curScore)

	slot0.curTimeTxt = slot0:findTF("top/time_bg/time", slot0.gameUI)
	slot0.curTime = 0

	setText(slot0:findTF("top/title/score_title", slot0.gameUI), i18n("idolmaster_game_tip5"))

	slot0.correctBar = slot0:findTF("correct_bar", slot0.gameUI)
	slot0.failBar = slot0:findTF("fail_bar", slot0.gameUI)
	slot0.manjuu = slot0:findTF("play/manjuu", slot0.gameUI)
	slot0.manjuuAnimator = slot0.manjuu:GetComponent(typeof(Animator))
	slot0.manjuuDft = slot0.manjuu:GetComponent(typeof(DftAniEvent))
	slot0.result = slot0:findTF("result", slot0.gameUI)
	slot0.resultAnimator = slot0.result:GetComponent(typeof(Animator))
	slot0.resultDft = slot0.result:GetComponent(typeof(DftAniEvent))
	slot0.scoreAni = slot0:findTF("score", slot0.gameUI)
	slot0.cupContainer = slot0:findTF("cup_container", slot0.gameUI)
	slot0.fork = slot0:findTF("fork", slot0.gameUI)
	slot0.isGuessTime = false
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.pauseBtn, function ()
		setActive(slot0.pauseUI, true)
		setActive:pauseGame()
	end, SFX_PANEL)
	onButton(slot0, slot0.resuemBtn, function ()
		setActive(slot0.pauseUI, false)
		setActive:resumeGame()
	end, SFX_PANEL)
	onButton(slot0, slot0.returnBtn, function ()
		setActive(slot0.exitUI, true)
		setActive:pauseGame()
	end, SFX_PANEL)
	onButton(slot0, slot0.exitSureBtn, function ()
		setActive(slot0.exitUI, false)
		setActive:enterResultUI()
	end, SFX_PANEL)
	onButton(slot0, slot0.exitCancelBtn, function ()
		setActive(slot0.exitUI, false)
		setActive:resumeGame()
	end, SFX_PANEL)
	onButton(slot0, slot0.endSureBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_PANEL)
	eachChild(slot0.cupContainer, function (slot0)
		onButton(slot0, slot0, function ()
			if not slot0.isGuessTime then
				return
			end

			setActive(slot0:findTF("select", slot0.findTF), true)

			setActive.isGuessTime = false
			slot0 = string.gsub(false.name, "cup_", "")
			slot0.selectIndex = tonumber(slot0)

			slot0:endRound(slot0.selectIndex == slot0.forkIndex)
		end, SFX_PANEL)
	end)
	slot0.initGameData(slot0)
	setActive(slot0.countUI, true)
	slot0.countAnimator:Play("countDown")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(pg.CriMgr.GetInstance().PlaySoundEffect_V3)
end

slot0.initGameData = function (slot0)
	eachChild(slot0.cupContainer, function (slot0)
		GetSpriteFromAtlasAsync("ui/minigameui/guessforkgameui", slot0, function (slot0)
			setImageSprite(slot0:findTF("front", setImageSprite), slot0, true)
		end)
	end)

	slot0.forkIndex = math.random(slot1)
	slot0.selectIndex = nil
	slot0.roundNum = slot0.roundNum + 1

	setText(slot0.roundTxt, slot0.roundNum)

	slot0.curTime = slot2[slot0.roundNum] or slot2[#slot2]

	setText(slot0.curTimeTxt, slot0.curTime)
	setActive(slot0.result, false)
end

slot0.startGame = function (slot0)
	slot0.manjuuAnimator:Play(slot0)

	slot1 = slot0.manjuuAnimator.Play[slot0.roundNum] or slot1[#slot1]

	slot0:playForkAni(function ()
		slot0:startSwap(slot0)
	end)

	slot0.gameStartFlag = true
end

slot0.playForkAni = function (slot0, slot1)
	setParent(slot0.fork, slot0:findTF("fork_node", slot2), false)
	setLocalScale(slot0.fork, Vector3.one)
	setLocalPosition(slot0.fork, Vector3(0, 50, 0))
	setActive(slot0.fork, true)
	slot0:managedTween(LeanTween.delayedCall, function ()
		slot0:managedTween(LeanTween.moveY, function ()
			setActive(slot0.fork, false)

			if slot0.fork then
				slot1()
			end
		end, slot0.fork, -20, ).setEase(slot0, LeanTweenType.linear)
	end, 0.5, nil)
end

slot0.startSwap = function (slot0, slot1)
	if slot1 < 1 then
		slot0.isGuessTime = true

		slot0:startTimer()

		return
	end

	table.remove(slot2, slot3)
	slot0:swapCup(slot0:findTF("cup_" .. ({
		1,
		2,
		3
	})[1], slot0.cupContainer), slot0:findTF("cup_" .. ()[2], slot0.cupContainer), function ()
		slot0:startSwap(slot1 - 1)
	end)
end

slot0.swapCup = function (slot0, slot1, slot2, slot3)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)
	slot0:managedTween(LeanTween.moveX, nil, slot1, slot2.anchoredPosition.x, slot8):setEase(LeanTweenType.linear)
	slot0:managedTween(LeanTween.moveX, function ()
		if slot0 then
			slot0()
		end
	end, slot2, slot1.anchoredPosition.x, math.abs(slot2.anchoredPosition.x - slot1.anchoredPosition.x) / ((slot1[1] + (slot0.roundNum - 1) * slot1[2] < slot2 and slot4) or slot2)):setEase(LeanTweenType.linear)
end

slot0.startTimer = function (slot0)
	slot1 = slot0.curTime
	slot0.timer = Timer.New(function ()
		slot0.curTime = slot0.curTime - 1

		if slot0.curTime <= 0 then
			slot0:endRound(false)
		end

		setText(slot0.curTimeTxt, slot0.curTime)
	end, 1, -1)

	slot0.timer.Start(slot2)
end

slot0.stopTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.pauseGame = function (slot0)
	slot0:pauseManagedTween()

	if slot0.timer then
		slot0.timer:Pause()
	end

	slot0.manjuuAnimator.speed = 0
	slot0.resultAnimator.speed = 0
end

slot0.resumeGame = function (slot0)
	slot0:resumeManagedTween()

	if slot0.timer then
		slot0.timer:Resume()
	end

	slot0.manjuuAnimator.speed = 1
	slot0.resultAnimator.speed = 1
end

slot0.endRound = function (slot0, slot1)
	slot0:stopTimer()

	if slot0.selectIndex then
		slot0:playManjuuAni(slot1)
	else
		slot0:playTimeOutAni()
		slot0:endGame()
	end
end

slot0.playManjuuAni = function (slot0, slot1)
	slot0.manjuuAnimator:Play(slot0[(slot0:findTF("cup_" .. slot0.selectIndex, slot0.cupContainer).anchoredPosition.x + 480) / 480 + 1])
	slot0.manjuuDft:SetEndEvent(function ()
		slot0.manjuuDft:SetEndEvent(nil)
		setActive((slot0.manjuuDft and slot2[slot3]) or slot4[slot3]:findTF("select", slot5), false)
		(slot0.manjuuDft and slot2[slot3]) or slot4[slot3].manjuuAnimator:Play((slot0.manjuuDft and slot2[slot3]) or slot4[slot3])
		(slot0.manjuuDft and slot2[slot3]) or slot4[slot3]:playResultAni((slot0.manjuuDft and slot2[slot3]) or slot4[slot3].playResultAni)
	end)
end

slot0.playResultAni = function (slot0, slot1)
	setParent(slot0.result, slot0:findTF("result_node", slot0:findTF("cup_" .. slot0.selectIndex, slot0.cupContainer)), false)
	setLocalScale(slot0.result, Vector3.one)
	setLocalPosition(slot0.result, Vector3.zero)
	setActive(slot0.result, true)

	if slot1 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)
		slot0.resultAnimator:Play(slot1)
		slot0.resultDft:SetEndEvent(function ()
			slot0.resultDft:SetEndEvent(nil)
			slot0.resultDft.SetEndEvent:showCorrectBar()
		end)
	else
		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot3, slot2)
		slot0.resultAnimator:Play(slot3)
		slot0.resultDft:SetEndEvent(function ()
			slot0.resultDft:SetEndEvent(nil)
			slot0.resultDft.SetEndEvent:endGame()
		end)
	end
end

slot0.showCorrectBar = function (slot0)
	setActive(slot0.correctBar, true)

	slot0.curScore = slot0.curScore + slot0[1] + (slot0.roundNum - 1) * slot0[2]

	setText(slot0.curScoreTxt, slot0.curScore)
	setLocalPosition(slot0.scoreAni, Vector3(0, 250, 0))
	setText(slot0.scoreAni, "+" .. slot1)
	setActive(slot0.scoreAni, true)
	LeanTween.moveY(slot0.scoreAni, 300, 1):setOnComplete(System.Action(function ()
		setActive(slot0.scoreAni, false)
	end))

	slot4 = slot0.curScore + (slot1[slot0.roundNum] or slot1[#slot1]) * slot0.curTime

	LeanTween.value(go(slot0.curScoreTxt), slot0.curScore, slot4, 0.5):setOnUpdate(System.Action_float(function (slot0)
		setText(slot0.curScoreTxt, math.ceil(slot0))
	end)).setOnComplete(slot5, System.Action(function ()
		slot0.curScore = slot1

		setText(slot0.curScoreTxt, slot0.curScore)
	end))
	LeanTween.value(go(slot0.curTimeTxt), slot0.curTime, 0, slot2):setOnUpdate(System.Action_float(function (slot0)
		setText(slot0.curTimeTxt, math.ceil(slot0))
	end)).setOnComplete(slot5, System.Action(function ()
		slot0.curScore = slot1

		setText(slot0.curTimeTxt, 0)
	end))
	onButton(slot0, slot0.correctBar, function ()
		setActive(slot0.correctBar, false)
		setActive(slot0.scoreAni, false)
		setActive:initGameData()
		setActive.initGameData:startGame()
	end, SFX_PANEL)
	slot0.managedTween(slot0, LeanTween.delayedCall, function ()
		if isActive(slot0.correctBar) then
			triggerButton(slot0.correctBar)
		end
	end, 0.5, nil)
end

slot0.playTimeOutAni = function (slot0)
	setParent(slot0.result, slot0:findTF("result_node", slot0:findTF("cup_" .. slot0.forkIndex, slot0.cupContainer)), false)
	setLocalScale(slot0.result, Vector3.one)
	setLocalPosition(slot0.result, Vector3.zero)
	setActive(slot0.result, true)
	slot0.resultAnimator:Play(slot0)
	slot0.resultDft:SetEndEvent(function ()
		slot0.resultDft:SetEndEvent(nil)
	end)
end

slot0.endGame = function (slot0)
	setActive(slot0.failBar, true)
	onButton(slot0, slot0.failBar, function ()
		setActive(slot0.failBar, false)
		setActive:enterResultUI()
	end, SFX_PANEL)
	slot0.managedTween(slot0, LeanTween.delayedCall, function ()
		if isActive(slot0.failBar) then
			triggerButton(slot0.failBar)
		end
	end, slot0, nil)
end

slot0.enterResultUI = function (slot0)
	slot0.gameStartFlag = false

	setActive(slot0.endUI, true)
	setText(slot0.endScoreTxt, slot0.curScore)
	setActive(slot0.newTag, ((slot0:GetMGData():GetRuntimeData("elements") and #slot1 > 0 and slot1[1]) or 0) < slot0.curScore)

	if slot2 <= slot0.curScore then
		slot0:StoreDataToServer({
			slot0.curScore
		})
	end

	setText(slot0.highestScoreTxt, slot2)

	if slot0:GetMGHubData().count > 0 then
		slot0:SendSuccess(0)
	end
end

slot0.OnGetAwardDone = function (slot0, slot1)
	if slot1.cmd == MiniGameOPCommand.CMD_COMPLETE and slot0:GetMGHubData().ultimate == 0 and slot2:getConfig("reward_need") <= slot2.usedtime then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = slot2.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

slot0.onBackPressed = function (slot0)
	if not slot0.gameStartFlag then
		slot0:emit(slot0.ON_BACK_PRESSED)
	else
		setActive(slot0.exitUI, true)
		slot0:pauseGame()
	end
end

return slot0

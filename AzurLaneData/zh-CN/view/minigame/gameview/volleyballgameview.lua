slot0 = class("VolleyballGameView", import("..BaseMiniGameView"))
slot1 = {
	"maliluosi_2_DOA",
	"suixiang_2_doa",
	"xia_2_DOA",
	"haixiao_2_DOA",
	"zhixiao_2_DOA",
	"nvtiangou_2_DOA",
	"monika_2_DOA"
}
slot2 = {
	10600010,
	10600020,
	10600030,
	10600040,
	10600050,
	10600060,
	10600070
}
slot3 = 1
slot4 = 2
slot5 = -1
slot6 = 0
slot7 = 0.35
slot8 = 0.15
slot9 = 0
slot10 = 1
slot11 = 2
slot12 = 0
slot13 = 1
slot14 = 2
slot15 = 1.5
slot16 = 1
slot17 = 0.5
slot18 = 0.5
slot19 = 0.43
slot20 = 0.5
slot21 = 0.76
slot22 = 0.83
slot23 = -30
slot24 = 50
slot25 = 60
slot26 = 230
slot27 = 60
slot28 = "event:/ui/ddldaoshu2"
slot29 = "event:/ui/fighterplane_click"
slot30 = "event:/ui/jieqiu"
slot31 = "event:/ui/kouqiu"
slot32 = 0.8
slot33 = -1000

slot0.getUIName = function (slot0)
	return "VolleyballGameUI"
end

slot0.init = function (slot0)
	slot0.countTimeUI = slot0:findTF("count_time_ui")
	slot0.countTimeImage = slot0:findTF("time", slot0.countTimeUI)
	slot0.countTimeNumImage = slot0:findTF("nums", slot0.countTimeUI)
	slot0.mainUI = slot0:findTF("main_ui")
	slot0.returnBtn = slot0:findTF("return_btn", slot0.mainUI)
	slot0.mainStartBtn = slot0:findTF("start_btn", slot0.mainUI)
	slot0.ruleBtn = slot0:findTF("rule_btn", slot0.mainUI)
	slot0.progressScroll = slot0:findTF("right_panel/scroll_view/", slot0.mainUI)
	slot0.progressContent = slot0:findTF("right_panel/scroll_view/viewport/content", slot0.mainUI)
	slot0.colors = slot0:findTF("right_panel/colors", slot0.mainUI)
	slot0.icons = slot0:findTF("right_panel/icons", slot0.mainUI)
	slot0.gotIcon = slot0:findTF("bg/got", slot0.mainUI)
	slot0.selectUI = slot0:findTF("select_ui")
	slot0.selectBackBtn = slot0:findTF("back_btn", slot0.selectUI)
	slot0.selectStartBtn = slot0:findTF("start_btn", slot0.selectUI)
	slot0.tags = slot0:findTF("select_panel/tags", slot0.selectUI)
	slot0.paints = slot0:findTF("select_panel/paints", slot0.selectUI)
	slot0.freeTitle = slot0:findTF("select_panel/title/free", slot0.selectUI)
	slot0.dayTitle = slot0:findTF("select_panel/title/challenge", slot0.selectUI)
	slot0.titleDayNum = slot0:findTF("select_panel/title/challenge/num", slot0.selectUI)
	slot0.ruleTxt = slot0:findTF("select_panel/rule/rule_txt", slot0.selectUI)
	slot0.select4Chars = slot0:findTF("select_panel/chars", slot0.selectUI)
	slot0.selectWindow = slot0:findTF("select_windows", slot0.selectUI)
	slot0.selectSureBtn = slot0:findTF("windows/sure_btn", slot0.selectWindow)
	slot0.select9Chars = slot0:findTF("windows/char_layout", slot0.selectWindow)
	slot0.selectNum = slot0:findTF("windows/tips/num", slot0.selectWindow)
	slot0.gameUI = slot0:findTF("game_ui")
	slot0.bgEffect = slot0:findTF("bg/shatanpaiqiu_hailang", slot0.gameUI)
	slot0.hitEffect = slot0:findTF("shatanpaiqiu_jida", slot0.gameUI)
	slot0.upEffect = slot0:findTF("shatanpaiqiu_jieqiu", slot0.gameUI)
	slot0.ball = slot0:findTF("ball", slot0.gameUI)
	slot0.ballShadow = slot0:findTF("ball_shadow", slot0.gameUI)
	slot0.pauseBtn = slot0:findTF("pause_btn", slot0.gameUI)
	slot0.backBtn = slot0:findTF("back_btn", slot0.gameUI)
	slot0.qteBtn = slot0:findTF("qte_btn", slot0.gameUI)
	slot0.pos = slot0:findTF("pos", slot0.gameUI)

	slot0:initPos()

	slot0.ourScore = slot0:findTF("score/our", slot0.gameUI)
	slot0.enemyScore = slot0:findTF("score/enemy", slot0.gameUI)
	slot0.qte = slot0:findTF("qte", slot0.gameUI)
	slot0.qteCircles = slot0:findTF("circles", slot0.qte)
	slot0.qteCircle = slot0:findTF("circles/big", slot0.qte)
	slot0.result = slot0:findTF("result", slot0.qte)
	slot0.resultTxt = slot0:findTF("txts", slot0.qte)
	slot0.cutin = slot0:findTF("cutin", slot0.gameUI)
	slot0.cutinPaint = slot0:findTF("cutin/paint", slot0.gameUI)
	slot0.cutinPaints = slot0:findTF("cutin_paints", slot0.gameUI)
	slot0.scoreCutin = slot0:findTF("score_cutin", slot0.gameUI)
	slot0.scoreCutinNums = slot0:findTF("score_cutin/nums", slot0.gameUI)
	slot0.ourScoreCutin = slot0:findTF("score_cutin/our", slot0.gameUI)
	slot0.enemyScoreCutin = slot0:findTF("score_cutin/enemy", slot0.gameUI)
	slot0.charTF = {
		our1 = slot0:findTF("char/our1", slot0.gameUI),
		our2 = slot0:findTF("char/our2", slot0.gameUI),
		enemy1 = slot0:findTF("char/enemy1", slot0.gameUI),
		enemy2 = slot0:findTF("char/enemy2", slot0.gameUI)
	}
	slot0.charModels = {}
	slot0.charactor = {}
	slot0.cutinMask = slot0:findTF("cutin_mask", slot0.gameUI)
	slot0.endUI = slot0:findTF("end_ui")
	slot0.endDayTitle = slot0:findTF("title/race", slot0.endUI)
	slot0.endFreeTitle = slot0:findTF("title/free", slot0.endUI)
	slot0.endTitleDay = slot0:findTF("title/race/num", slot0.endUI)
	slot0.titleDays = slot0:findTF("title_days", slot0.endUI)
	slot0.endOurScore = slot0:findTF("score_panel/score/our", slot0.endUI)
	slot0.endEnemyScore = slot0:findTF("score_panel/score/enemy", slot0.endUI)
	slot0.endScoreNums = slot0:findTF("nums", slot0.endUI)
	slot0.sureBtn = slot0:findTF("sure_btn", slot0.endUI)
	slot0.winTag = slot0:findTF("score_panel/score/win", slot0.endUI)
	slot0.loseTag = slot0:findTF("score_panel/score/lose", slot0.endUI)
	slot0.helpUI = slot0:findTF("help_ui")
end

slot0.initPos = function (slot0)
	slot0.orgPos = {
		our_serve = slot0:findTF("our_pos/serve_pos", slot0.pos).anchoredPosition,
		our1 = slot0:findTF("our_pos/drop_pos1", slot0.pos).anchoredPosition,
		our2 = slot0:findTF("our_pos/drop_pos2", slot0.pos).anchoredPosition,
		enemy_serve = slot0:findTF("enemy_pos/serve_pos", slot0.pos).anchoredPosition,
		enemy1 = slot0:findTF("enemy_pos/drop_pos1", slot0.pos).anchoredPosition,
		enemy2 = slot0:findTF("enemy_pos/drop_pos2", slot0.pos).anchoredPosition
	}

	slot0:resetPos()
end

slot0.resetPos = function (slot0)
	slot0.anchoredPos = Clone(slot0.orgPos)
	slot0.anchoredPos.our1 = slot0:getRandomPos("our1")
	slot0.anchoredPos.our2 = slot0:getRandomPos("our2")
	slot0.anchoredPos.enemy1 = slot0:getRandomPos("enemy1")
	slot0.anchoredPos.enemy2 = slot0:getRandomPos("enemy2")
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.returnBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_PANEL)
	onButton(slot0, slot0.ruleBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("venusvolleyball_help")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.mainStartBtn, function ()
		setActive(slot0.selectUI, true)
		pg.UIMgr.GetInstance():BlurPanel(slot0.selectUI)
		pg.UIMgr.GetInstance().BlurPanel:initSelectUI()
	end, SFX_PANEL)
	onButton(slot0, slot0.selectBackBtn, function ()
		setActive(slot0.selectUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(slot0.selectUI, slot0._tf)
	end, SFX_PANEL)

	slot0.canStartGame = false

	onButton(slot0, slot0.selectStartBtn, function ()
		if not slot0.canStartGame then
			return
		end

		setActive(slot0.mainUI, false)
		setActive(slot0.selectUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(slot0.selectUI, slot0._tf)
		setActive(slot0.gameUI, true)
		setActive:resetGameData()

		if setActive.resetGameData.isFirstgame == 0 then
			slot0:firstShow(function ()
				slot0:startCountTimer()
			end)
		else
			slot0.startCountTimer(slot0)
		end
	end, SFX_PANEL)

	slot0.canSureChar = false

	onButton(slot0, slot0.selectSureBtn, function ()
		if not slot0.canSureChar then
			return
		end

		if slot0.selectCharCamp == "enemy" then
			slot0.charNames.enemy1 = slot1[slot0.selectSDIndex1]
			slot0.charNames.charNames.enemy2 = slot1[slot0.selectSDIndex1][slot0.selectSDIndex2]
		elseif slot0.selectCharCamp == "our" then
			slot0.charNames.our1 = slot1[slot0.selectSDIndex1]
			slot0.charNames.charNames.our2 = slot1[slot0.selectSDIndex1][slot0.selectSDIndex2]
		end

		setActive(slot0.selectWindow, false)
		setActive:refreshSelectUI()
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("mask", slot0.selectWindow), function ()
		setActive(slot0.selectWindow, false)
	end, SFX_PANEL)
	onButton(slot0, slot0.pauseBtn, function ()
		if not slot0.btnAvailable then
			return
		end

		slot0:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("venusvolleyball_suspend_tip"),
			onNo = function ()
				slot0:resumeGame()
			end,
			onYes = function ()
				slot0:resumeGame()
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.backBtn, function ()
		if not slot0.btnAvailable then
			return
		end

		slot0:pauseGame()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("venusvolleyball_return_tip"),
			onNo = function ()
				slot0:resumeGame()
			end,
			onYes = function ()
				slot0:exitGame()
				setActive(slot0.mainUI, true)
				setActive(slot0.gameUI, false)
				setActive:clearSpineChars()
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.qteBtn, function ()
		if slot0.qteBtnStatus == slot1 then
			return
		end

		slot0:qteResult()
	end)
	onButton(slot0, slot0.sureBtn, function ()
		setActive(slot0.mainUI, true)
		setActive:initMainUI()
		setActive(slot0.gameUI, false)
		setActive(slot0.endUI, false)
		setActive:clearSpineChars()
		pg.UIMgr.GetInstance():UnblurPanel(slot0.endUI, slot0._tf)
	end, SFX_PANEL)
	slot0.initMainUI(slot0)
end

slot0.playEffect = function (slot0, slot1, slot2)
	if slot2 then
		slot1.anchoredPosition = slot2
	else
		slot1.anchoredPosition = slot0.ball.anchoredPosition
	end

	setActive(slot1, false)
	setActive(slot1, true)
end

slot0.getGameData = function (slot0)
	slot0.mgProxy = getProxy(MiniGameProxy)
	slot0.hubData = slot0.mgProxy:GetHubByHubId(13)
	slot0.curDay = (slot0.hubData.ultimate == 0 and slot0.hubData.usedtime + 1) or 8
	slot0.unlockDay = slot0.hubData.usedtime + slot0.hubData.count
	slot0.curDay = (slot0.curDay <= slot0.unlockDay and slot0.curDay) or slot0.unlockDay
	slot0.mgData = slot0.mgProxy:GetMiniGameData(17)
	slot0.endScore = slot0.mgData:GetSimpleValue("endScore")[slot0.curDay]
	slot0.storylist = slot0.mgData:GetSimpleValue("story")
	slot0.isFirstgame = PlayerPrefs.GetInt("volleyballgame_first_" .. getProxy(PlayerProxy):getData().id)
end

slot0.getEnemyCharsIndex = function (slot0)
	return slot0.mgData:GetSimpleValue("mainChar")[slot0.curDay], slot0.mgData:GetSimpleValue("minorChar")[slot0.curDay]
end

slot0.initMainUI = function (slot0)
	slot0.isInGame = false

	slot0:getGameData()

	if slot0.hubData.ultimate == 0 and slot0.hubData:getConfig("reward_need") <= slot0.hubData.usedtime then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = slot0.hubData.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end

	slot0.isFree = (slot0.hubData.ultimate ~= 0 and true) or false

	setActive(slot0:findTF("free_tag", slot0.mainStartBtn), slot0.isFree)
	setActive(slot0.gotIcon, slot0.isFree)
	eachChild(slot0.progressContent, function (slot0)
		slot3 = slot0[slot1.mgData:GetSimpleValue("mainChar")[tonumber(slot0.name)]]

		setActive(slot1:findTF("char_bg/mask", slot0), false)
		setActive(slot1:findTF("name_bg/mask", slot0), false)
		setActive(slot1:findTF("pass", slot0), false)

		if tonumber(slot0.name) == slot1.curDay and slot1.hubData.count > 0 then
			setImageSprite(slot1:findTF("char_bg/icon", slot0), slot1.icons:Find(slot1:getCharIndex(slot3)):GetComponent(typeof(Image)).sprite, true)
		elseif slot2 < slot1.curDay or (slot2 == slot1.curDay and slot1.hubData.count == 0) then
			setImageSprite(slot1:findTF("char_bg/icon", slot0), slot1.icons:Find(slot1:getCharIndex(slot3)):GetComponent(typeof(Image)).sprite, true)
			setActive(slot1:findTF("char_bg/mask", slot0), true)
			setActive(slot1:findTF("name_bg/mask", slot0), true)
			setActive(slot1:findTF("pass", slot0), true)
		elseif slot1.curDay < slot2 and slot2 <= slot1.unlockDay then
			setImageSprite(slot1:findTF("char_bg/icon", slot0), slot1.icons:Find(slot1:getCharIndex(slot3)):GetComponent(typeof(Image)).sprite, true)
		else
			setImageSprite(slot1:findTF("char_bg/icon", slot0), slot1.colors:Find("unkonwn"):GetComponent(typeof(Image)).sprite)
		end

		setImageSprite(slot1:findTF("name_bg", slot0), slot1.colors:Find(slot1):GetComponent(typeof(Image)).sprite)
	end)

	slot0.progressContent.anchoredPosition = {
		x = 0,
		y = math.min(645, (slot0.curDay - 1) * 215)
	}

	onScroll(slot0, slot0.progressScroll, function (slot0)
		setActive(slot0:findTF("right_panel/arraws_up", slot0.mainUI), (slot0.y < 1 and true) or false)
		setActive(slot0:findTF("right_panel/arraws_down", slot0.mainUI), (slot0.y > 0 and true) or false)
	end)
end

slot0.initSelectUI = function (slot0)
	setActive(slot0.freeTitle, slot0.isFree)
	setActive(slot0.dayTitle, not slot0.isFree)
	setText(slot0.titleDayNum, slot0.curDay)
	setText(slot0.ruleTxt, i18n("venusvolleyball_rule_tip", slot0.endScore))

	slot0.charNames = {}
	slot0.lastSelectNames = {}

	eachChild(slot0.select4Chars, function (slot0)
		slot1 = slot0.name

		onButton(slot0, slot0, function ()
			if not slot0.isFree and string.find(slot1, "enemy") then
				return
			end

			slot0.selectCharCamp = (string.find(string.find, "enemy") and "enemy") or "our"

			slot0:openSelectWindow()
		end)
	end)

	if not slot0.isFree then
		slot1, slot2 = slot0.getEnemyCharsIndex(slot0)
		slot0.charNames.enemy2 = slot0[slot2]
		slot0.charNames.enemy1 = slot0[slot1]
	end

	slot0:refreshSelectUI()
end

slot0.getCharIndex = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0) do
		if slot6 == slot1 then
			return slot5
		end
	end

	return 1
end

slot0.refreshSelectUI = function (slot0)
	eachChild(slot0.select4Chars, function (slot0)
		if slot0.charNames[slot0.name] then
			setActive(slot0:findTF("select_btn", slot0), false)
			setActive(slot0:findTF("char", slot0), true)
			setImageSprite(slot0:findTF("char/icon", slot0), slot0.paints:Find(slot0:getCharIndex(slot0.charNames[slot1])):GetComponent(typeof(Image)).sprite, true)
			setImageSprite(slot0:findTF("char/tag", slot0), slot0.tags:Find(slot0:getCharIndex(slot0.charNames[slot1])):GetComponent(typeof(Image)).sprite, true)
		else
			setActive(slot0:findTF("select_btn", slot0), true)
			setActive(slot0:findTF("char", slot0), false)
		end
	end)

	slot0.canStartGame = (slot0.charNames.our1 and slot0.charNames.our2 and slot0.charNames.enemy1 and slot0.charNames.enemy2 and true) or false

	setGray(slot0.selectStartBtn, not slot0.canStartGame, not slot0.canStartGame)
end

slot0.isSelected = function (slot0, slot1, slot2)
	slot3 = false

	for slot7, slot8 in pairs(slot0.charNames) do
		if slot1 == slot8 then
			slot3 = (not string.find(slot7, slot2) and true) or false
		end
	end

	return slot3
end

slot0.openSelectWindow = function (slot0)
	setActive(slot0.selectWindow, true)

	slot0.hasSelectNum = 0

	setText(slot0.selectNum, setColorStr(slot0.hasSelectNum, COLOR_GREEN) .. "/2")

	slot0.selectSDIndex1 = nil
	slot0.selectSDIndex2 = nil

	eachChild(slot0.select9Chars, function (slot0)
		setImageSprite(slot0:findTF("char/frame/icon", slot0), slot0.icons:Find(slot1):GetComponent(typeof(Image)).sprite, true)
		onButton(slot0, slot0, function ()
			if slot0:isSelected(slot1[], slot0.selectCharCamp) then
				return
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot3)

			if isActive(slot0:findTF("selected", slot4), true) then
				setActive(slot0:findTF("selected", slot4), false)

				if setActive.selectSDIndex1 and slot0.selectSDIndex1 == slot2 then
					slot0.selectSDIndex1 = nil
				end

				if slot0.selectSDIndex2 and slot0.selectSDIndex2 == slot2 then
					slot0.selectSDIndex2 = nil
				end

				slot0.hasSelectNum = slot0.hasSelectNum - 1
			elseif slot0.selectSDIndex1 and slot0.selectSDIndex2 then
			elseif slot0.selectSDIndex1 then
				slot0.selectSDIndex2 = slot2
				slot0.hasSelectNum = slot0.hasSelectNum + 1
			else
				slot0.selectSDIndex1 = slot2
				slot0.hasSelectNum = slot0.hasSelectNum + 1
			end

			slot0:refreshSelectWindow()
		end)
	end)
	slot0.refreshSelectWindow(slot0)
end

slot0.refreshSelectWindow = function (slot0)
	eachChild(slot0.select9Chars, function (slot0)
		setActive(slot0:findTF("char/mask", slot0), (slot0:isSelected(slot1[tonumber(slot0.name)], slot0.selectCharCamp) and true) or false)

		if slot1 == slot0.selectSDIndex1 or slot1 == slot0.selectSDIndex2 then
			setActive(slot0:findTF("selected", slot0), true)
		else
			setActive(slot0:findTF("selected", slot0), false)
		end
	end)
	setText(slot0.selectNum, setColorStr(slot0.hasSelectNum, COLOR_GREEN) .. "/2")

	slot0.canSureChar = (slot0.selectSDIndex1 and slot0.selectSDIndex2 and true) or false

	setGray(slot0.selectSureBtn, not slot0.canSureChar, not slot0.canSureChar)
end

slot0.firstShow = function (slot0, slot1)
	setActive(slot0.helpUI, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.helpUI)
	onButton(slot0, slot0.helpUI, function ()
		PlayerPrefs.SetInt("volleyballgame_first_" .. slot0, 1)
		setActive(slot0.helpUI, false)
		pg.UIMgr.GetInstance():UnblurPanel(slot0.helpUI, slot0._tf)

		if pg.UIMgr.GetInstance().UnblurPanel then
			slot1()
		end
	end, SFX_PANEL)
end

slot0.startCountTimer = function (slot0)
	slot0:setBtnAvailable(false)
	setActive(slot0.countTimeUI, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.countTimeUI)

	slot0.countTime = 3

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)
	setImageSprite(slot0.countTimeImage, slot0.countTimeNumImage:Find(slot0.countTime):GetComponent(typeof(Image)).sprite)

	function slot1()
		slot0.countTime = slot0.countTime - 1

		if slot0.countTime <= 0 then
			setActive(slot0.countTimeUI, false)
			pg.UIMgr.GetInstance():UnblurPanel(slot0.countTimeUI, slot0._tf)
			pg.UIMgr.GetInstance().UnblurPanel:resetGameAni()
			pg.UIMgr.GetInstance().UnblurPanel.resetGameAni:startGame()
		else
			setImageSprite(slot0.countTimeImage, slot0.countTimeNumImage:Find(slot0.countTime):GetComponent(typeof(Image)).sprite)
		end
	end

	if slot0.countTimer then
		slot0.countTimer.Reset(slot2, slot1, 1, -1)
	else
		slot0.countTimer = Timer.New(slot1, 1, -1)
	end

	slot0.countTimer:Start()
end

slot0.setBtnAvailable = function (slot0, slot1)
	slot0.btnAvailable = slot1

	setGray(slot0.backBtn, not slot1, not slot1)
	setGray(slot0.pauseBtn, not slot1, not slot1)
end

slot0.startGame = function (slot0)
	slot0.isInGame = true

	slot0:setBtnAvailable(true)
	setActive(slot0.bgEffect, false)
	setActive(slot0.bgEffect, true)

	if slot0.beginTeam == slot0 then
		slot0:ourServe(function ()
			slot0:enemyUp2Up(function ()
				slot0:enemyUp2Hit(function ()
					slot0:enemyThrow(function ()
						slot0:enterLoop()
					end)
				end)
			end)
		end)
	else
		slot0.enemyServe(slot0, function ()
			slot0:enterLoop()
		end)
	end
end

slot0.enterLoop = function (slot0)
	slot0:ourUp2Up(function ()
		slot0:ourUp2Hit(function ()
			slot0:ourThrow(function ()
				slot0:enemyUp2Up(function ()
					slot0:enemyUp2Hit(function ()
						slot0:enemyThrow(function ()
							slot0:enterLoop()
						end)
					end)
				end)
			end)
		end)
	end)
end

slot0.ourServe = function (slot0, slot1)
	slot0.ballPosTag = "our_serve"

	setActive(slot0.ball, true)
	slot0:charServeBall()
	slot0:managedTween(LeanTween.delayedCall, function ()
		slot0.ballPosTag = "enemy" .. math.random(2)
		slot0.anchoredPos[slot0.ballPosTag] = slot0:getRandomPos(slot0.ballPosTag)

		slot0:ballServe(slot0.ball, slot0.ballServe, slot0.anchoredPos["enemy" .. math.random(2)], function ()
			if slot0 then
				slot0()
			end
		end)
		slot0.managedTween(slot1, LeanTween.delayedCall, function ()
			slot0:charUpBall()
		end, slot1 - slot3, nil)
	end, slot2 + 0.5, nil)
end

slot0.enemyServe = function (slot0, slot1)
	slot0.ballPosTag = "enemy_serve"

	setActive(slot0.ball, true)
	slot0:charServeBall()
	slot0:managedTween(LeanTween.delayedCall, function ()
		slot0.ballPosTag = "our" .. math.random(2)
		slot0.anchoredPos[slot0.ballPosTag] = slot0:getRandomPos(slot0.ballPosTag)

		slot0:ballServe(slot0.ball, slot0.ballServe, slot0.anchoredPos["our" .. math.random(2)], function ()
			if slot0 then
				slot0()
			end
		end)
		slot0.managedTween(slot1, LeanTween.delayedCall, function ()
			slot0:charUpBall()
		end, slot1 - slot3, nil)
	end, slot2 + 0.5, nil)
end

slot0.ourUp2Up = function (slot0, slot1)
	if slot0.qteStatus == slot0 and slot0.qteType == slot1 then
		slot0:ourFly()

		return
	end

	slot0.ballPosTag = (slot0.ballPosTag == "our1" and "our2") or "our1"

	slot0:ballUp2Up(slot0.ball, (slot0.ballPosTag == "our1" and "our2") or "our1", slot0.anchoredPos[slot0.ballPosTag], function ()
		if slot0 then
			slot0()
		end
	end)
	slot0.managedTween(slot0, LeanTween.delayedCall, function ()
		slot0:charUpBall()
	end, 0.3, nil)
end

slot0.ourUp2Hit = function (slot0, slot1)
	slot2 = {}
	slot0.ballPosTag = (slot0.ballPosTag == "our1" and "our2") or "our1"
	slot0.anchoredPos[slot0.ballPosTag] = slot0:getRandomPos(slot0.ballPosTag)
	slot0.qteType = slot0

	slot0:charHitBall()

	slot4 = false

	function slot5(slot0)
		if slot0 then
			slot0()
		else
			slot0 = true
		end
	end

	table.insert(slot2, function (slot0)
		function slot1()
			if slot0.isCutin then
				slot0:showcutin(function ()
					slot0.isCutin = false

					false()
				end)
			else
				slot1()
			end
		end

		slot0.managedTween(slot2, LeanTween.delayedCall, function ()
			slot0(slot1)
		end, slot2 - 0.2, nil)
		slot0.managedTween(slot2, LeanTween.delayedCall, function ()
			slot0:startQTE(slot0, 200, slot0.anchoredPos[slot0.ballPosTag], function ()
				slot0(slot1)
			end)
		end, slot2 - slot3 - 0.2, nil)
	end)
	table.insert(slot2, function (slot0)
		slot0:ballUp2Hit(slot0.ball, slot0.ballUp2Hit, slot0.anchoredPos[slot0.ballPosTag], slot0)
	end)
	parallelAsync(slot2, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.ourThrow = function (slot0, slot1)
	slot0.ballPosTag = "enemy" .. math.random(2)
	slot0.anchoredPos[slot0.ballPosTag] = slot0:getRandomPos(slot0.ballPosTag)

	slot0:ballHit(slot0.ball, slot0, slot0.anchoredPos["enemy" .. math.random(2)], function ()
		if slot0 then
			slot0()
		end
	end)
	slot0.charUpBall(slot0)
end

slot0.enemyUp2Up = function (slot0, slot1)
	if slot0.qteStatus == slot0 and slot0.qteType == slot1 then
		slot0:enemyFly()

		return
	end

	slot0.ballPosTag = (slot0.ballPosTag == "enemy1" and "enemy2") or "enemy1"

	slot0:ballUp2Up(slot0.ball, (slot0.ballPosTag == "enemy1" and "enemy2") or "enemy1", slot0.anchoredPos[slot0.ballPosTag], function ()
		if slot0 then
			slot0()
		end
	end)
	slot0.managedTween(slot0, LeanTween.delayedCall, function ()
		slot0:charUpBall()
	end, 0.3, nil)
end

slot0.enemyUp2Hit = function (slot0, slot1)
	slot0.ballPosTag = (slot0.ballPosTag == "enemy1" and "enemy2") or "enemy1"
	slot0.anchoredPos[slot0.ballPosTag] = slot0:getRandomPos(slot0.ballPosTag)
	slot0.randomQtePos = "our" .. math.random(2)
	slot0.anchoredPos[slot0.randomQtePos] = slot0:getRandomPos(slot0.randomQtePos)
	slot0.qteType = slot0

	slot0:managedTween(LeanTween.delayedCall, function ()
		slot0:startQTE(slot0, 0, slot0.anchoredPos[slot0.randomQtePos])
	end, ((slot0.ballPosTag == "enemy1" and "enemy2") or "enemy1") - slot1, nil)
	slot0.ballUp2Hit(slot0, slot0.ball, (slot0.ballPosTag == "enemy1" and "enemy2") or "enemy1", slot0.anchoredPos[slot0.ballPosTag], function ()
		if slot0 then
			slot0()
		end
	end)
	slot0.charHitBall(slot0)
end

slot0.enemyThrow = function (slot0, slot1)
	slot0.ballPosTag = slot0.randomQtePos

	slot0:ballHit(slot0.ball, slot0, slot0.anchoredPos[slot0.ballPosTag], function ()
		if slot0 then
			slot0()
		end
	end)
	slot0.charUpBall(slot0)
end

slot0.ourFly = function (slot0)
	slot0.ballPosTag = "out"

	slot0:hitFly(slot0.ball, slot0, {
		x = -math.random(1000, 1100),
		y = math.random(0, 200) - 100
	}, function ()
		slot0.qteStatus = slot1

		setGray(slot0.qteBtn, true, true)

		setGray.enemyScoreNum = slot0.enemyScoreNum + 1

		setGray:updateScore()
	end)
end

slot0.enemyFly = function (slot0)
	slot0.ballPosTag = "out"

	slot0:hitFly(slot0.ball, slot0, {
		x = math.random(1000, 1100),
		y = math.random(0, 200) - 100
	}, function ()
		slot0.qteStatus = slot1

		setGray(slot0.qteBtn, true, true)

		setGray.ourScoreNum = slot0.ourScoreNum + 1

		setGray:updateScore()
	end)
end

slot0.qteSuccess = function (slot0)
	slot0.qteStatus = slot0
	slot0.beginTeam = slot0

	slot0:changeQTEBtnStatus(slot0)
end

slot0.qteFail = function (slot0)
	slot0.qteStatus = slot0
	slot0.beginTeam = slot0

	slot0:changeQTEBtnStatus(slot0)
end

slot0.GetBeziersPoints = function (slot0, slot1, slot2, slot3, slot4)
	table.insert(slot6, Vector3(0, 0, 0))
	table.insert(slot6, slot5(0))

	for slot10 = 1, slot4, 1 do
		table.insert(slot6, slot5(slot10 / slot4))
	end

	table.insert(slot6, Vector3(0, 0, 0))

	return slot6
end

slot0.ballParabolaMove = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot9 = Vector2(slot3.x, slot3.y).x - Vector2(slot1.anchoredPosition.x, slot1.anchoredPosition.y - slot5).x
	slot10 = Vector2(slot3.x, slot3.y).y - Vector2(slot1.anchoredPosition.x, slot1.anchoredPosition.y - slot5).y
	slot12 = DOAParabolaCalc(slot2, math.abs(slot0), math.abs(slot6 - slot5))
	slot13, slot14 = nil

	if slot5 < slot6 then
		slot13 = slot12 + slot11
		slot14 = slot12
	else
		slot13 = slot12
		slot14 = slot12 + slot11
	end

	slot15 = math.sqrt(2 * math.abs(slot0) * slot13)

	slot0:managedTween(LeanTween.value, function ()
		if slot0 then
			slot0()
		end
	end, go(slot1), 0, slot2, slot2):setOnUpdate(System.Action_float(function (slot0)
		slot5.anchoredPosition = Vector2(slot6.x + (slot0 * slot0) / (), slot6.y + (slot0 * slot0 * slot0) / slot1 +  + slot1 * slot0 + 0.5 * slot4 * slot0 * slot0)
	end))
end

slot0.ballServe = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ballParabolaMove(slot1, slot2, slot3, function ()
		if slot0 then
			slot0()
		end
	end, slot0, slot1)
	slot0.managedTween(slot0, LeanTween.move, nil, slot0.ballShadow, Vector3(slot3.x, slot3.y + slot2), slot2):setEase(LeanTweenType.linear)
end

slot0.ballUp2Up = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ballParabolaMove(slot1, slot2, slot3, function ()
		if slot0 then
			slot0()
		end
	end, slot0, slot0)
	slot0.managedTween(slot0, LeanTween.move, nil, slot0.ballShadow, Vector3(slot3.x, slot3.y + slot1), slot2):setEase(LeanTweenType.linear)
end

slot0.ballUp2Hit = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ballParabolaMove(slot1, slot2, slot5, function ()
		if slot0 then
			slot0()
		end
	end, slot0, slot1)
	slot0.managedTween(slot0, LeanTween.move, nil, slot0.ballShadow, Vector3(slot3.x, slot3.y + slot2), slot2):setEase(LeanTweenType.linear)
end

slot0.ballHit = function (slot0, slot1, slot2, slot3, slot4)
	slot0:managedTween(LeanTween.moveX, function ()
		if slot0 then
			slot0()
		end
	end, slot1, Vector2(slot3.x, slot3.y + slot0).x, slot2):setEase(LeanTweenType.linear)
	slot0:managedTween(LeanTween.moveY, nil, slot1, Vector2(slot3.x, slot3.y + slot0).y, slot2):setEase(LeanTweenType.linear)
	slot0:managedTween(LeanTween.move, nil, slot0.ballShadow, Vector3(Vector2(slot3.x, slot3.y + slot0).x, Vector2(slot3.x, slot3.y + slot0).y + slot1), slot2):setEase(LeanTweenType.linear)
end

slot0.charMove = function (slot0, slot1, slot2, slot3, slot4)
	slot0:managedTween(LeanTween.moveX, nil, slot1, slot3.x, slot2):setEase(LeanTweenType.easeOutQuad)
	slot0:managedTween(LeanTween.moveY, function ()
		if slot0 then
			slot0()
		end
	end, slot1, slot3.y, slot2):setEase(LeanTweenType.linear)
end

slot0.hitFly = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ballParabolaMove(slot1, slot2, slot3, function ()
		if slot0 then
			slot0()
		end
	end, slot0, slot1)
	slot0.managedTween(slot0, LeanTween.move, nil, slot0.ballShadow, Vector3(slot3.x, slot3.y + slot2), slot2):setEase(LeanTweenType.linear)
end

slot0.startQTE = function (slot0, slot1, slot2, slot3, slot4)
	slot0:changeQTEBtnStatus(slot0)

	slot0.qte.anchoredPosition = {
		x = slot3.x,
		y = slot3.y + slot2
	}

	setActive(slot0.qte, true)
	setActive(slot0.qteCircles, true)
	setActive(slot0.result, false)
	setLocalScale(slot0.qteCircle, Vector3(1, 1, 1))
	slot0.result:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot5, function (slot0)
		setActive(slot0.result, false)
	end)

	slot0.qteCallback = slot4
	slot0.qteTween = LeanTween.scale(slot0.qteCircle, Vector3(0, 0, 1), slot1):setOnComplete(System.Action(function ()
		slot0:changeQTEBtnStatus(slot0)
		setImageSprite(slot0.result, slot0.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		setActive(slot0.result, true)
		setActive:qteFail()

		setActive.qteFail.isCutin = false

		setActive(slot0.qteCircles, false)
		existCall(slot0.qteCallback)

		existCall.qteCallback = nil
	end)).uniqueId
end

slot0.qteResult = function (slot0)
	if LeanTween.isTweening(slot0.qteTween) then
		LeanTween.cancel(slot0.qteTween, false)
	end

	setActive(slot0.result, true)

	slot0.isCutin = false

	if math.abs(slot0.qteCircle.localScale.x) <= 0 or slot0 < slot1 then
		setImageSprite(slot0.result, slot0.resultTxt:Find("miss"):GetComponent(typeof(Image)).sprite, true)
		slot0:qteFail()
	elseif slot1 < slot1 then
		setImageSprite(slot0.result, slot0.resultTxt:Find("good"):GetComponent(typeof(Image)).sprite, true)
		slot0:qteSuccess()
	else
		setImageSprite(slot0.result, slot0.resultTxt:Find("perfect"):GetComponent(typeof(Image)).sprite, true)
		slot0:qteSuccess()

		if slot0.qteType ==  then
			slot0.isCutin = true
		else
			slot0.isCutin = false
		end
	end

	setActive(slot0.qteCircles, false)
	existCall(slot0.qteCallback)

	slot0.qteCallback = nil
end

function slot34(slot0, slot1, slot2, slot3, slot4)
	({
		_tf = slot1,
		spineAnim = slot2,
		skele = slot3,
		posTag = slot4,
		ctor = function (slot0)
			slot0._tf.anchoredPosition = slot1.anchoredPos[]
		end,
		setPosTag = function (slot0, slot1)
			slot0._tf.anchoredPosition = slot1.anchoredPos[slot1]
			slot0.posTag = slot1
		end,
		getPosTag = function (slot0)
			return slot0.posTag
		end,
		pauseSpine = function (slot0)
			slot0.skele.timeScale = 0
		end,
		resumeSpine = function (slot0)
			slot0.skele.timeScale = 1
		end,
		setActionOnce = function (slot0, slot1, slot2)
			slot0.spineAnim:SetActionCallBack(function (slot0)
				if slot0 == "action" then
					if slot0 == "chuanqiu" or slot0 == "dianqiu" then
						slot1:playEffect(slot1.upEffect, Vector2(slot2._tf.anchoredPosition.x, slot2._tf.anchoredPosition.y + slot1.upEffect))
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(Vector2)
					elseif slot0 == "kouqiu" then
						slot1:playEffect(slot1.hitEffect, Vector2(slot2._tf.anchoredPosition.x, slot2._tf.anchoredPosition.y + slot3 + slot2._tf.anchoredPosition.x))
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot2._tf.anchoredPosition.y + slot3 + slot2._tf.anchoredPosition.x)
					elseif slot0 == "faqiu" then
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot4)
						pg.CriMgr.GetInstance().PlaySoundEffect_V3:playEffect(slot1.upEffect, Vector2(slot2._tf.anchoredPosition.x, slot2._tf.anchoredPosition.y + slot7))
					end
				end

				if slot0 == "finish" then
					slot2.spineAnim:SetActionCallBack(nil)

					if slot8 then
						slot8()
					else
						slot2.spineAnim:SetAction("normal2", 0)
					end
				end
			end)
			slot0.spineAnim.SetAction(slot3, slot1, 0)
		end,
		move = function (slot0, slot1, slot2, slot3, slot4)
			function slot5()
				slot0.spineAnim:SetAction("run", 0)

				slot0.spineAnim.SetAction.posTag = slot0.spineAnim

				slot2:charMove(slot0._tf, 0, slot2.anchoredPos[slot1], function ()
					if slot0 then
						slot0()
					else
						slot1.spineAnim:SetAction("normal2", 0)
					end
				end)
			end

			if slot3 then
				slot0.setActionOnce(slot6, slot3, function ()
					slot0()
				end)
			else
				slot5()
			end
		end
	})["ctor"](slot5)

	return 
end

slot0.getRandomPos = function (slot0, slot1)
	slot5 = slot0.orgPos[slot1]

	return (not string.find(slot1, "our") or {
		x = (slot4.x + math.random(0, 300)) - 50,
		y = (slot4.y + math.random(0, 50)) - 25
	}) and {
		x = (slot4.x + math.random(0, 300)) - 250,
		y = (slot4.y + math.random(0, 50)) - 25
	}
end

slot0.loadSpineChars = function (slot0)
	slot0:clearSpineChars()

	slot0.beginTeam = math.random(2)

	if slot0.beginTeam == slot0 then
		slot0.serveChar = "our" .. math.random(2)
	else
		slot0.serveChar = "enemy" .. math.random(2)
	end

	slot0:setBallPos()

	for slot4, slot5 in pairs(slot0.charNames) do
		slot0:loadOneSpineChar(slot4, slot0.serveChar)
	end
end

slot0.loadOneSpineChar = function (slot0, slot1, slot2)
	if not slot0.charNames[slot1] then
		slot0.charNames[slot1] = false

		return
	end

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar(slot0.charNames[slot1], true, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()

		slot1 = ""

		if string.find(slot0, "our") then
			tf(slot0).localScale = Vector3(0.6, 0.6, 1)
			tf(slot0).localPosition = Vector3(-20, 0, 0)

			if string.find(slot0, "1") then
				slot1 = "our1"
			else
				slot1 = "our2"
			end
		else
			tf(slot0).localScale = Vector3(-0.6, 0.6, 1)
			tf(slot0).localPosition = Vector3(20, 0, 0)
			(string.find(slot0, "1") and "enemy1") or "enemy2".charModels[slot0] = slot0
			slot2 = slot0:GetComponent("SpineAnimUI")

			slot2:SetAction("normal2", 0)

			slot0:GetComponent("SkeletonGraphic").timeScale = 1

			setParent(slot0, slot4)

			(string.find(slot0, "1") and "enemy1") or "enemy2".charactor[slot0] = slot2((string.find(slot0, "1") and "enemy1") or "enemy2", (string.find(slot0, "1") and "enemy1") or "enemy2"._tf:Find("game_ui/char/" .. slot0), slot2, slot0.GetComponent("SkeletonGraphic"), )
		end

		if slot0 == slot3 then
			if slot1.beginTeam == slot4 then
				slot1.charactor[slot0]:setPosTag("our_serve")
			else
				slot1.charactor[slot0]:setPosTag("enemy_serve")
			end
		end
	end)
end

slot0.clearSpineChars = function (slot0)
	for slot4, slot5 in pairs(slot0.charModels) do
		if slot0.charModels[slot4] and slot0.charNames[slot4] then
			PoolMgr.GetInstance():ReturnSpineChar(slot0.charNames[slot4], slot0.charModels[slot4])
		end
	end

	slot0.charModels = {}
end

slot0.getCharWithTag = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.charactor) do
		if slot6:getPosTag() == slot1 then
			return slot5, slot6
		end
	end

	return nil
end

slot0.getAnotherChar = function (slot0, slot1)
	slot2 = ""

	if string.find(slot1, "our") then
		slot2 = (slot1 == "our1" and "our2") or "our1"
	elseif string.find(slot1, "enemy") then
		return (slot1 == "enemy1" and "enemy2") or "enemy1", slot0.charactor[(slot1 == "enemy1" and "enemy2") or "enemy1"]
	end
end

slot0.setBallPos = function (slot0)
	setActive(slot0.ball, true)

	slot0.ball.anchoredPosition = {
		x = slot0.orgPos[(string.find(slot0.serveChar, "our") and "our_serve") or "enemy_serve"].x,
		y = slot0.orgPos[(string.find(slot0.serveChar, "our") and "our_serve") or "enemy_serve"].y + 300
	}
	slot0.ballShadow.anchoredPosition = Vector3(slot0.orgPos[(string.find(slot0.serveChar, "our") and "our_serve") or "enemy_serve"].x, slot0.orgPos[(string.find(slot0.serveChar, "our") and "our_serve") or "enemy_serve"].y, 0)

	slot0:managedTween(LeanTween.rotate, nil, slot0.ball, 360, 0.5):setLoopClamp()
end

slot0.resetChar = function (slot0)
	slot0:resetPos()

	for slot4, slot5 in pairs(slot0.charactor) do
		if LeanTween.isTweening(go(slot5._tf)) then
			LeanTween.cancel(go(slot5._tf))
		end
	end

	slot0.charactor.our1:setPosTag("our1")
	slot0.charactor.our2:setPosTag("our2")
	slot0.charactor.enemy1:setPosTag("enemy1")
	slot0.charactor.enemy2:setPosTag("enemy2")

	if slot0.beginTeam == slot0 then
		slot0.serveChar = "our" .. math.random(2)

		slot0.charactor[slot0.serveChar]:setPosTag("our_serve")
	else
		slot0.serveChar = "enemy" .. math.random(2)

		slot0.charactor[slot0.serveChar]:setPosTag("enemy_serve")
	end

	slot0:setBallPos()
end

slot0.charServeBall = function (slot0)
	slot0:managedTween(LeanTween.rotate, nil, slot0.ball, 360, 0.5):setLoopClamp()

	slot1 = (string.find(slot0.serveChar, "our") and "our_serve") or "enemy_serve"

	slot0:managedTween(LeanTween.delayedCall, function ()
		slot0:managedTween(LeanTween.moveY, nil, slot0.ball, slot0.orgPos[slot1].y + slot2, 0.5):setEase(LeanTweenType.linear)
		slot0.managedTween(LeanTween.moveY, nil, slot0.ball, slot0.orgPos[slot1].y + slot2, 0.5).setEase.charactor[slot0.serveChar]:setActionOnce("faqiu", function ()
			slot0:managedTween(LeanTween.delayedCall, function ()
				slot0.charactor[slot0.serveChar]:move(1, slot0.serveChar)
			end, 0.2, nil)
		end)
	end, 0.5, nil)
end

slot0.charUpBall = function (slot0, slot1)
	slot2, slot3 = slot0:getCharWithTag(slot0.ballPosTag)

	if not slot3 then
		return
	end

	slot0.upChar = slot2
	slot0.hitChar = slot0:getAnotherChar(slot0.upChar)

	slot3:move(0.45, slot0.ballPosTag, nil, function ()
		slot0:setActionOnce("chuanqiu")
	end)
end

slot0.charHitBall = function (slot0)
	slot0.charactor[slot0.hitChar]:move(0.5, slot0.ballPosTag, nil, function ()
		slot0:setActionOnce("kouqiu")
	end)
end

slot0.showcutin = function (slot0, slot1)
	slot0:setBtnAvailable(false)
	slot0:pauseGame()
	setActive(slot0.cutin, true)

	slot2 = ""

	for slot6, slot7 in pairs(slot0.charNames) do
		if slot6 == slot0.hitChar then
			slot2 = slot7
		end
	end

	slot3, slot8, slot5 = ShipWordHelper.GetWordAndCV(slot0[slot0:getCharIndex(slot2)], "skill")

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot4)
	setActive(slot0:findTF("line", slot0.gameUI), true)
	setActive(slot0:findTF("shatanpaiqiu_cutin", slot0.cutin), false)
	setActive(slot0:findTF("shatanpaiqiu_cutin", slot0.cutin), true)
	setImageSprite(slot0.cutinPaint, slot0.cutinPaints:Find(slot0:getCharIndex(slot2)):GetComponent(typeof(Image)).sprite, true)
	LeanTween.moveX(slot0.cutin, 0, 0.3):setOnComplete(System.Action(function ()
		LeanTween.delayedCall(1, System.Action(function ()
			setActive(slot0:findTF("line", slot0.gameUI), false)
			LeanTween.moveX(slot0.cutin, -567, 0.3):setOnComplete(System.Action(function ()
				setActive(slot0.cutin, false)
				setActive:setBtnAvailable(true)
				setActive.setBtnAvailable:resumeGame()

				if setActive.setBtnAvailable then
					slot1()
				end
			end))
		end))
	end))
end

slot0.showScoreCutin = function (slot0, slot1)
	slot0:setBtnAvailable(false)
	slot0:pauseGame()
	setImageSprite(slot0.ourScoreCutin, slot0.scoreCutinNums:Find(slot0.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(slot0.enemyScoreCutin, slot0.scoreCutinNums:Find(slot0.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)
	setActive(slot0.scoreCutin, true)
	setLocalScale(slot0.scoreCutin, Vector3(1, 0, 1))
	LeanTween.scale(slot0.scoreCutin, Vector3(1, 1, 1), 0.2):setOnComplete(System.Action(function ()
		slot0:resetChar()
		LeanTween.delayedCall(0.6, System.Action(function ()
			LeanTween.scale(slot0.scoreCutin, Vector3(1, 0, 1), 0.2):setOnComplete(System.Action(function ()
				setActive(slot0.scoreCutin, false)
				setActive:setBtnAvailable(true)
				setActive.setBtnAvailable:resumeGame()

				if setActive.setBtnAvailable then
					slot1()
				end
			end))
		end))
	end))
end

slot0.updateScore = function (slot0)
	setText(slot0.ourScore, slot0.ourScoreNum)
	setText(slot0.enemyScore, slot0.enemyScoreNum)
	setActive(slot0.qte, false)

	if slot0.endScore <= slot0.ourScoreNum or slot0.endScore <= slot0.enemyScoreNum then
		slot0:endGame()
	else
		slot0:showScoreCutin(function ()
			slot0:startGame()
		end)
	end
end

slot0.endGame = function (slot0)
	slot0:setBtnAvailable(false)

	slot0.isInGame = false

	pg.UIMgr.GetInstance():BlurPanel(slot0.endUI)
	setActive(slot0.endUI, true)
	setActive(slot0.endFreeTitle, slot0.isFree)
	setActive(slot0.endDayTitle, not slot0.isFree)
	setImageSprite(slot0.endTitleDay, slot0.titleDays:Find(slot0.curDay):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(slot0.endOurScore, slot0.endScoreNums:Find(slot0.ourScoreNum):GetComponent(typeof(Image)).sprite, true)
	setImageSprite(slot0.endEnemyScore, slot0.endScoreNums:Find(slot0.enemyScoreNum):GetComponent(typeof(Image)).sprite, true)

	slot1 = -20

	if slot0.enemyScoreNum < slot0.ourScoreNum then
		slot0.winTag.anchoredPosition = Vector3(-170, 200, 0)
		slot0.loseTag.anchoredPosition = Vector3(180, 200, 0)
		slot1 = -20
	else
		slot0.winTag.anchoredPosition = Vector3(170, 200, 0)
		slot0.loseTag.anchoredPosition = Vector3(-180, 200, 0)
		slot1 = 20
	end

	setActive(slot0.winTag:GetChild(0), false)
	setActive(slot0.winTag:GetChild(0), true)
	setLocalRotation(slot0.loseTag, Vector3(0, 0, 0))
	LeanTween.rotateZ(go(slot0.loseTag), slot1, 0.2):setOnComplete(System.Action(function ()
		if slot0:GetMGHubData().count > 0 then
			slot0:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
		end
	end))
end

slot0.OnGetAwardDone = function (slot0, slot1)
	if slot1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		slot2 = slot0:GetMGHubData()
		slot3 = slot2.ultimate
		slot4 = slot2.usedtime
		slot5 = slot2:getConfig("reward_need")
		slot6 = slot0:GetMGHubData().count
		slot7 = pg.NewStoryMgr.GetInstance()
		slot8 = (slot0.storylist[slot0:GetMGHubData().usedtime] and slot0.storylist[slot0:GetMGHubData().usedtime][1]) or nil

		if slot4 ~= 7 and slot8 and not slot7:IsPlayed(slot8) then
			slot7:Play(slot8)
		end

		if slot3 == 0 and slot5 <= slot4 then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = slot2.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif slot1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		slot3 = pg.NewStoryMgr.GetInstance()

		if ((slot0.storylist[7][1] and slot0.storylist[7][1]) or nil) and not slot3:IsPlayed(slot2) then
			slot3:Play(slot2)
		end
	end
end

slot0.pauseGame = function (slot0)
	slot0:pauseManagedTween()

	if slot0.qteTimer then
		slot0.qteTimer:Pause()
	end

	if slot0.qteTween and LeanTween.isTweening(slot0.qteTween) then
		LeanTween.pause(slot0.qteTween)
	end

	for slot4, slot5 in pairs(slot0.charactor) do
		slot5:pauseSpine()
	end
end

slot0.resumeGame = function (slot0)
	slot0:resumeManagedTween()

	if slot0.qteTimer then
		slot0.qteTimer:Resume()
	end

	if slot0.qteTween and LeanTween.isTweening(slot0.qteTween) then
		LeanTween.resume(slot0.qteTween)
	end

	for slot4, slot5 in pairs(slot0.charactor) do
		slot5:resumeSpine()
	end
end

slot0.clearTimer = function (slot0)
	if slot0.qteTimer then
		slot0.qteTimer:Stop()

		slot0.qteTimer = nil
	end

	if slot0.countTimer then
		slot0.countTimer:Stop()

		slot0.countTimer = nil
	end
end

slot0.changeQTEBtnStatus = function (slot0, slot1)
	slot0.qteBtnStatus = slot1
end

slot0.resetGameData = function (slot0)
	slot0.qteStatus = slot0
	slot0.qteType = slot0

	slot0:changeQTEBtnStatus(slot0)

	slot0.ballPosTag = ""
	slot0.isCutin = false
	slot0.cutin.anchoredPosition = {
		x = -567,
		y = 582
	}
	slot0.isScoreCutin = false

	setActive(slot0.scoreCutin, false)

	slot0.ourScoreNum = 0
	slot0.enemyScoreNum = 0

	setText(slot0.ourScore, slot0.ourScoreNum)
	setText(slot0.enemyScore, slot0.enemyScoreNum)
	setActive(slot0.qte, false)
	slot0:loadSpineChars()
end

slot0.exitGame = function (slot0)
	slot0.isInGame = false

	slot0:setBtnAvailable(true)
	slot0:resetGameAni()
end

slot0.resetGameAni = function (slot0)
	slot0:cleanManagedTween()

	if slot0.qteTween and LeanTween.isTweening(slot0.qteTween) then
		LeanTween.cancel(slot0.qteTween, false)
	end

	slot0:clearTimer()
end

slot0.willExit = function (slot0)
	slot0:clearSpineChars()
	pg.UIMgr.GetInstance():UnblurPanel(slot0.selectUI, slot0._tf)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.endUI, slot0._tf)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.countTimeUI, slot0._tf)
end

slot0.onBackPressed = function (slot0)
	if slot0.isInGame then
		triggerButton(slot0.backBtn)
	elseif isActive(slot0.selectUI) then
		triggerButton(slot0.selectBackBtn)
	elseif isActive(slot0.mainUI) then
		triggerButton(slot0.returnBtn)
	end
end

return slot0

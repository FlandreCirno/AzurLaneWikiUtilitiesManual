slot0 = class("QTEGameView", import("..BaseMiniGameView"))

slot0.getUIName = function (slot0)
	return "QTEGameUI"
end

slot0.init = function (slot0)
	slot0.STATE_BEGIN = 1
	slot0.STATE_COUNT = 2
	slot0.STATE_CLICK = 3
	slot0.STATE_SHOW = 4
	slot0.STATE_END = 5
	slot0.gameState = -1
	slot0.typeNum = 3
	slot0.idNum = 3
	slot0.limitNum = 5
	slot0.TYPE_A = 1
	slot0.TYPE_B = 2
	slot0.TYPE_C = 3
	slot0.ITEM_ID_1 = 1
	slot0.ITEM_ID_2 = 2
	slot0.ITEM_ID_3 = 3
	slot0.startUI = slot0:findTF("start_ui")
	slot0.startBtn = slot0:findTF("start_btn", slot0.startUI)
	slot0.ruleBtn = slot0:findTF("rule_btn", slot0.startUI)
	slot0.qBtn = slot0:findTF("q_btn", slot0.startUI)
	slot0.countUI = slot0:findTF("count_ui")
	slot0.countNumTxt = slot0:findTF("num", slot0.countUI)
	slot0.endUI = slot0:findTF("end_ui")
	slot0.endExitBtn = slot0:findTF("exit_btn", slot0.endUI)
	slot0.endBestTxt = slot0:findTF("rope/paper/best_txt", slot0.endUI)
	slot0.endScoreTxt = slot0:findTF("rope/paper/score_txt", slot0.endUI)
	slot0.endComboTxt = slot0:findTF("rope/paper/combo_txt", slot0.endUI)
	slot0.endMissTxt = slot0:findTF("rope/paper/miss_txt", slot0.endUI)
	slot0.endHitTxt = slot0:findTF("rope/paper/hit_txt", slot0.endUI)
	slot0.endUIEvent = slot0:findTF("rope", slot0.endUI):GetComponent("DftAniEvent")
	slot0.content = slot0:findTF("content")
	slot0.res = slot0:findTF("res")
	slot0.gameBg = slot0:findTF("game_bg", slot0.content)
	slot0.xgmPos = slot0:findTF("xiongguimao_pos", slot0.content)
	slot0.guinuPos = slot0:findTF("guinu_pos", slot0.content)
	slot0.bucketA = slot0:findTF("content/bucket_A")
	slot0.bucketASpine = slot0.bucketA:GetComponent("SpineAnimUI")
	slot0.bucketAGraphic = slot0.bucketA:GetComponent("SkeletonGraphic")
	slot0.bucketB = slot0:findTF("content/bucket_B")
	slot0.bucketBSpine = slot0.bucketB:GetComponent("SpineAnimUI")
	slot0.bucketBGraphic = slot0.bucketB:GetComponent("SkeletonGraphic")
	slot0.bucketC = slot0:findTF("content/bucket_C")
	slot0.msHand = slot0:findTF("ani", slot0.bucketC)
	slot0.msHandAnimator = slot0.msHand:GetComponent("Animator")
	slot0.msHandSlot = slot0:findTF("slot", slot0.msHand)
	slot0.msHandEvent = slot0.msHand:GetComponent("DftAniEvent")
	slot0.msBlockList = {}

	slot0.msHandEvent:SetEndEvent(function ()
		slot0:msClearHold()
		setActive(slot0.msHand, false)
	end)

	slot0.xgmAnimLength = {
		idle = 1,
		attack = 1
	}
	slot0.xgmAnimTargetLength = {
		idle = 1,
		attack = 0.5
	}
	slot0.guinuAnimLength = {
		action = 1.333,
		normal = 4.667
	}
	slot0.guinuAnimTargetLength = {
		action = 0.5,
		normal = 4.667
	}
	slot0.bucketAAnimLength = {
		idle = 0.167,
		attack = 0.8
	}
	slot0.bucketAAnimTargetLength = {
		idle = 1,
		attack = 0.6
	}
	slot0.bucketBAnimLength = {
		idle = 0.167,
		attack = 0.8
	}
	slot0.bucketBAnimTargetLength = {
		idle = 1,
		attack = 0.6
	}
	slot0.cut1 = slot0.findTF(slot0, "cut_1", slot0.bucketB)
	slot0.cut2 = slot0:findTF("cut_2", slot0.bucketB)
	slot0.cut3 = slot0:findTF("cut_3", slot0.bucketB)
	slot0.cut1Animator = slot0.cut1:GetComponent("Animator")
	slot0.cut2Animator = slot0.cut2:GetComponent("Animator")
	slot0.cut3Animator = slot0.cut3:GetComponent("Animator")
	slot0.cut1Event = slot0.cut1:GetComponent("DftAniEvent")
	slot0.cut2Event = slot0.cut2:GetComponent("DftAniEvent")
	slot0.cut3Event = slot0.cut3:GetComponent("DftAniEvent")

	slot0.cut1Event:SetEndEvent(function ()
		setActive(slot0.cut1, false)
	end)
	slot0.cut2Event.SetEndEvent(slot1, function ()
		setActive(slot0.cut2, false)
	end)
	slot0.cut3Event.SetEndEvent(slot1, function ()
		setActive(slot0.cut3, false)
	end)

	slot0.keyUI = slot0.findTF(slot0, "key_ui", slot0.content)
	slot0.keyBar = slot0:findTF("key_bar", slot0.keyUI)
	slot0.aBtn = slot0:findTF("A_btn", slot0.keyUI)
	slot0.bBtn = slot0:findTF("B_btn", slot0.keyUI)
	slot0.cBtn = slot0:findTF("C_btn", slot0.keyUI)
	slot0.comboAni = slot0:findTF("combo_bar/center", slot0.content):GetComponent("Animator")
	slot0.comboTxt = slot0:findTF("combo_bar/center/combo_txt", slot0.content)
	slot0.comboAni.enabled = false
	slot0.scoreTxt = slot0:findTF("score_bar/txt", slot0.content)
	slot0.remainTxt = slot0:findTF("remain_time_bar/txt", slot0.content)

	pg.UIMgr.GetInstance():OverlayPanelPB(slot0.keyBar, {
		pbList = {
			slot0.keyBar
		}
	})

	slot0.roundTxt = slot0:findTF("round_time_bar/txt", slot0.keyUI)
	slot0.firePos = slot0:findTF("content/pos/fire_pos").anchoredPosition
	slot0.hitPos = slot0:findTF("content/pos/hit_pos").anchoredPosition
	slot0.aPos = slot0:findTF("content/pos/a_pos").anchoredPosition
	slot0.bPos = slot0:findTF("content/pos/b_pos").anchoredPosition
	slot0.cPos = slot0:findTF("content/pos/c_pos").anchoredPosition
	slot0.missPos = slot0:findTF("content/pos/miss_pos").anchoredPosition
	slot0.backBtn = slot0:findTF("back_btn", slot0.content)
	slot0.autoLoader = AutoLoader.New()

	slot0.autoLoader:LoadSprite("ui/minigameui/qtegameuiasync/backgroud", "background", slot0.gameBg, false)
end

slot0.didEnter = function (slot0)
	slot0:initGame()
	onButton(slot0, slot0.backBtn, function ()
		slot0:setGameState(slot0.STATE_BEGIN)
	end, SFX_PANEL)
	onButton(slot0, slot0.qBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_PANEL)
	onButton(slot0, slot0.ruleBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.qte_game_help.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end)
	onButton(slot0, slot0.startBtn, function ()
		setButtonEnabled(slot0.startBtn, false)
		parallelAsync({
			function (slot0)
				slot0:loadXGM(slot0)
			end,
			function (slot0)
				slot0:loadGuinu(slot0)
			end
		}, function ()
			slot0:setGameState(slot0.STATE_COUNT)
		end)
	end, SFX_PANEL)

	if QTEGAME_DEBUG then
		onButton(slot0, slot0.xgm, function ()
			slot0:setGameState(slot0.STATE_SHOW)
		end)
	end

	onButton(slot0, slot0.endExitBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_PANEL)
	slot0.endUIEvent.SetEndEvent(slot1, function ()
		if slot0:GetMGHubData().count > 0 then
			slot0:SendSuccess(0)
		end

		setActive(slot0.endExitBtn, true)
	end)

	function slot1(slot0)
		if slot0.gameState == slot0.STATE_CLICK and slot0.curShowBlock then
			slot0.curShowBlock:select(slot0)

			slot0.curShowBlock = slot0.curShowBlock.nextBlock

			if slot0.curShowBlock == nil then
				slot0:managedTween(LeanTween.delayedCall, function ()
					slot0:setGameState(slot0.STATE_SHOW)
				end, 0.2, nil)
			end
		end
	end

	onButton(slot0, slot0.aBtn, function ()
		slot0(slot1.TYPE_A)
	end, SFX_PANEL)
	onButton(slot0, slot0.bBtn, function ()
		slot0(slot1.TYPE_B)
	end, SFX_PANEL)
	onButton(slot0, slot0.cBtn, function ()
		slot0(slot1.TYPE_C)
	end, SFX_PANEL)
	slot0.setGameState(slot0, slot0.STATE_BEGIN)
	slot0:checkHelp()
end

slot0.initGame = function (slot0)
	slot0.curShowBlock = nil
	slot0.randomBlockList = nil
	slot0.scorePerHit = slot0:GetMGData():GetSimpleValue("scorePerHit")
	slot0.comboRange = slot0:GetMGData():GetSimpleValue("comboRange")
	slot0.comboAddScore = slot0:GetMGData():GetSimpleValue("comboAddScore")
	slot0.targetCombo = slot0:GetMGData():GetSimpleValue("targetCombo")
	slot0.targetComboScore = slot0:GetMGData():GetSimpleValue("targetComboScore")
	slot0.usingBlockList = {}
	slot0.blockUniId = 0

	slot0:resetGame()
	slot0.bucketASpine:SetActionCallBack(function (slot0)
		if slot0 == "FINISH" then
			slot0:setBucketAAction("idle")
		end
	end)
	slot0.bucketBSpine.SetActionCallBack(slot1, function (slot0)
		if slot0 == "FINISH" then
			slot0:setBucketBAction("idle")
		end
	end)
end

slot0.resetGame = function (slot0)
	slot0:setXgmAction("idle")
	slot0:setGuinuAction("normal")
	slot0:setBucketAAction("idle")
	slot0:setBucketBAction("idle")
	setActive(slot0.msHand, false)

	slot0.score = 0
	slot0.bestComboNum = 0
	slot0.comboNum = 0
	slot0.missNum = 0
	slot0.hitNum = 0
	slot0.remainTime = slot0:GetMGData():GetSimpleValue("gameTime")
	slot0.roundTime = slot0:GetMGData():GetSimpleValue("roundTime")

	setText(slot0.comboTxt, 0)
	setText(slot0.scoreTxt, 0)
	setText(slot0.remainTxt, slot0.remainTime .. "S")
	setText(slot0.roundTxt, slot0.roundTime)
	slot0:clearTimer()
	slot0:hideRandomList()
	slot0:clearUsingBlock()
	slot0:cleanManagedTween()
end

slot0.setGameState = function (slot0, slot1)
	if slot1 == slot0.gameState then
		return
	end

	slot0.gameState = slot1

	function slot2(slot0)
		for slot5, slot6 in pairs(slot1) do
			setActive(slot6, table.indexof(slot0, slot6) and true)
		end

		if isActive(slot0.endUI) then
			pg.UIMgr.GetInstance():BlurPanel(slot0.endUI)
		else
			pg.UIMgr.GetInstance():UnblurPanel(slot0.endUI, slot0._tf)
		end
	end

	if slot0.gameState == slot0.STATE_BEGIN then
		setButtonEnabled(slot0.startBtn, true)
		slot2({
			slot0.startUI
		})
		slot0:resetGame()
	else
		if slot0.gameState == slot0.STATE_COUNT then
			slot2({
				slot0.countUI,
				slot0.content
			})

			slot3 = Time.realtimeSinceStartup

			slot0:managedTween(LeanTween.delayedCall, function ()
				slot0:startGameTimer()
				slot0.startGameTimer:setGameState(slot0.STATE_CLICK)
			end, 3, nil).setOnUpdate(slot4, System.Action_float(function (slot0)
				setText(slot0.countNumTxt, math.ceil(3 - (Time.realtimeSinceStartup - setText)))
			end))

			return
		end

		if slot0.gameState == slot0.STATE_CLICK then
			slot2({
				slot0.content,
				slot0.keyUI,
				slot0.keyBar
			})

			slot0.randomBlockList, slot0.curShowBlock, slot0.firstShowBlock = slot0:getRandomList()

			slot0:startRoundTimer()
		elseif slot0.gameState == slot0.STATE_SHOW then
			slot2({
				slot0.content
			})
			slot0:hideRandomList()
			slot0:playArchiveAnim(slot0.randomBlockList, slot0:getUserResult())
		elseif slot0.gameState == slot0.STATE_END then
			slot2({
				slot0.content,
				slot0.endUI
			})
			setActive(slot0.endExitBtn, false)

			slot3 = 0

			if slot0:GetMGData():GetRuntimeData("elements") and #slot4 > 0 then
				slot3 = slot4[1]
			end

			if slot3 < slot0.score then
				slot0:StoreDataToServer({
					slot0.score
				})
			end

			setText(slot0.endBestTxt, slot3)
			setText(slot0.endScoreTxt, slot0.score)
			setText(slot0.endComboTxt, slot0.bestComboNum)
			setText(slot0.endMissTxt, slot0.missNum)
			setText(slot0.endHitTxt, slot0.hitNum)
			slot0:clearTimer()
		end
	end
end

slot0.fireBlocks = function (slot0)
	slot6 = slot0:getBlock(slot2, slot3).tf

	slot0:addUsingBlock(slot0.getBlock(slot2, slot3))

	slot7 = nil

	if slot0.opList[slot0.opIndex] then
		if slot2 == slot0.TYPE_A then
			slot7 = slot0.aPos
		elseif slot2 == slot0.TYPE_B then
			slot7 = slot0.bPos
		elseif slot2 == slot0.TYPE_C then
			slot7 = slot0.cPos
		end
	else
		slot7 = slot0.missPos
	end

	slot6.anchoredPosition = slot0.firePos

	slot0:hitFly(slot6, 0.5, slot0.hitPos, function ()
		slot0.anchoredPosition = slot1.hitPos

		if slot2 then
			slot0 = 0.4

			if slot3 == slot1.TYPE_A then
				slot0 = 0.3

				slot1:setBucketAAction("attack")
			elseif slot3 == slot1.TYPE_B then
				slot1:managedTween(LeanTween.delayedCall, function ()
					slot0:setBucketBAction("attack")
				end, 0.2, nil)
			elseif slot3 == slot1.TYPE_C then
				slot0 = 0.3

				setActive(slot1.msHand, true)
				slot1.msHandAnimator.Play(slot2, "mingshi_hand", -1, 0)
			end

			slot1(slot1, slot0, slot0, , function ()
				if slot0 == slot1.TYPE_A then
					slot1:removeUsingBlock(slot2)
					slot1:showBucketAEffect()
					pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_hitcake")
				elseif slot0 == slot1.TYPE_B then
					setActive(slot1["cut" .. slot3], true)
					slot1["cut" .. slot3]["cut" .. slot3 .. "Animator"]:Play("cut_fruit", -1, 0)
					slot1["cut" .. slot3]["cut" .. slot3 .. "Animator"]:removeUsingBlock("cut_fruit")
					pg.CriMgr.GetInstance():PlaySE_V3("ui-minigame_sword")
				elseif slot0 == slot1.TYPE_C then
					slot1:msClearHold()
					slot1:msHoldBlock(slot2)
				end

				slot1:checkEnd(slot4)
			end)
		else
			slot1.hitFly(slot0, slot1.hitFly, 0.6, slot4, function ()
				slot0:removeUsingBlock(slot0)
				slot0.removeUsingBlock:checkEnd(slot0)
			end)
		end

		pg.CriMgr.GetInstance().PlaySE_V3(slot0, "ui-minigame_hitwood")
		slot0:countScore("ui-minigame_hitwood")
	end)
	slot0.managedTween(slot0, LeanTween.delayedCall, function ()
		slot0:setGuinuAction("action")
	end, 0.2, nil)
end

slot0.getRandomList = function (slot0)
	if not slot0.allList then
		slot0.allList = {}

		for slot4 = 1, slot0.typeNum, 1 do
			for slot8 = 1, slot0.idNum, 1 do
				slot0.allList[#slot0.allList + 1] = {
					type = slot4,
					id = slot8
				}
			end
		end
	end

	slot1 = Clone(slot0.allList)
	slot2 = {}

	for slot6 = 1, slot0.limitNum, 1 do
		slot2[#slot2 + 1] = table.remove(slot1, math.random(1, #slot1))
	end

	slot3, slot4, slot5 = nil

	for slot9, slot10 in ipairs(slot2) do
		slot11 = slot0:getShowBlock(slot10.type, slot10.id)

		if slot3 then
			slot3.nextBlock = slot11
		end

		if slot0.limitNum <= slot9 then
			slot11.nextBlock = nil
		end

		if slot9 == 1 then
			slot4 = slot11
			slot5 = slot11
		end

		slot11:showOrHide(true)

		slot3 = slot11
	end

	return slot2, slot4, slot5
end

slot0.hideRandomList = function (slot0)
	slot1 = slot0.firstShowBlock

	while slot1 do
		slot1:showOrHide(false)

		slot1 = slot1.nextBlock
	end
end

slot0.countScore = function (slot0, slot1)
	if slot1 then
		slot2 = nil

		for slot6, slot7 in ipairs(slot0.comboRange) do
			if slot0.comboNum < slot7 then
				slot2 = slot6 - 1

				break
			elseif slot6 == #slot0.comboRange then
				slot2 = #slot0.comboRange
			end
		end

		slot0.comboNum = slot0.comboNum + 1
		slot0.score = slot0.score + slot0.scorePerHit + (slot0.comboAddScore[slot2] or 0) + (slot0.targetComboScore[table.indexof(slot0.targetCombo, slot0.comboNum)] or 0)
		slot0.hitNum = slot0.hitNum + 1
		slot0.comboAni.enabled = true

		slot0.comboAni:Play("combo_shake", -1, 0)
	else
		slot0.comboNum = 0
		slot0.missNum = slot0.missNum + 1
	end

	if slot0.bestComboNum < slot0.comboNum then
		slot0.bestComboNum = slot0.comboNum
	end

	setText(slot0.comboTxt, (slot0.comboNum >= 0 or 0) and slot0.comboNum)
	setText(slot0.scoreTxt, slot0.score)
end

slot0.getUserResult = function (slot0)
	slot1 = {}
	slot2 = slot0.firstShowBlock

	while slot2 do
		slot1[#slot1 + 1] = slot2:isRight()
		slot2 = slot2.nextBlock
	end

	return slot1
end

slot0.playArchiveAnim = function (slot0, slot1, slot2)
	slot0.arBlockList = slot1
	slot0.opList = slot2
	slot0.opIndex = 1

	slot0:setXgmAction("attack")
end

slot0.checkPlayFinished = function (slot0)
	if slot0.opIndex >= #slot0.opList and slot0.remainTime > 0 then
		slot0:setGameState(slot0.STATE_CLICK)
	end
end

slot0.checkEnd = function (slot0, slot1)
	if slot1 >= #slot0.opList and slot0.remainTime <= 0 then
		slot0:setGameState(slot0.STATE_END)
	end
end

slot0.parabolaMove = function (slot0, slot1, slot2, slot3, slot4)
	slot0:managedTween(LeanTween.rotate, nil, slot1, 135, slot2)
	slot0:managedTween(LeanTween.moveX, nil, slot1, slot3.x, slot2):setEase(LeanTweenType.linear)
	slot0:managedTween(LeanTween.moveY, function ()
		if slot0 then
			slot0()
		end
	end, slot1, slot3.y, slot2):setEase(LeanTweenType.easeInQuad)
end

slot0.parabolaMove_center = function (slot0, slot1, slot2, slot3, slot4)
	slot0:managedTween(LeanTween.rotate, nil, slot1, 135, slot2)
	slot0:managedTween(LeanTween.moveX, nil, slot1, slot3.x, slot2):setEase(LeanTweenType.easeOutQuad)
	slot0:managedTween(LeanTween.moveY, function ()
		if slot0 then
			slot0()
		end
	end, slot1, slot3.y, slot2):setEase(LeanTweenType.linear)
end

slot0.hitFly = function (slot0, slot1, slot2, slot3, slot4)
	slot0:managedTween(LeanTween.rotate, nil, slot1, 135, slot2)
	slot0:managedTween(LeanTween.moveX, nil, slot1, slot3.x, slot2):setEase(LeanTweenType.linear)
	slot0:managedTween(LeanTween.moveY, function ()
		if slot0 then
			slot0()
		end
	end, slot1, slot3.y, slot2):setEase(LeanTweenType.easeOutQuad)
end

slot0.loadXGM = function (slot0, slot1)
	if slot0.xgm then
		slot1()
	else
		slot0.autoLoader:LoadPrefab("ui/minigameui/qtegameuiasync/xiongguimao", nil, function (slot0)
			slot0.xgm = tf(slot0)
			slot0.xgmSpine = slot0.xgm:GetComponent("SpineAnimUI")
			slot0.xgmSklGraphic = slot0.xgm:GetComponent("SkeletonGraphic")

			setParent(slot0.xgm, slot0.xgmPos, false)
			slot0:initXGM()
			slot0.initXGM()
		end)
	end
end

slot0.initXGM = function (slot0)
	slot0.xgmSpine:SetActionCallBack(function (slot0)
		if slot0 == "FIRE" then
			slot0:fireBlocks()
		elseif slot0 == "FINISH" then
			if slot0.opIndex < #slot0.opList then
				slot0.opIndex = slot0.opIndex + 1

				slot0:setXgmAction("attack")
			else
				slot0:setXgmAction("idle")
				slot0:checkPlayFinished()
			end
		end
	end)
end

slot0.loadGuinu = function (slot0, slot1)
	if slot0.guinu then
		slot1()
	else
		slot0.autoLoader:GetSpine("guinu_2", function (slot0)
			slot0.guinu = tf(slot0)
			slot0.guinuSpine = slot0.guinu:GetComponent("SpineAnimUI")
			slot0.guinuSklGraphic = slot0.guinu:GetComponent("SkeletonGraphic")

			setParent(slot0.guinu, slot0.guinuPos, false)
			slot0:initGuinu()
			slot0.initGuinu()
		end)
	end
end

slot0.initGuinu = function (slot0)
	slot0.guinu.localScale = Vector3.one

	slot0:setGuinuAction("normal")
	slot0.guinuSpine:SetActionCallBack(function (slot0)
		if slot0 == "finish" then
			slot0:setGuinuAction("normal")
		end
	end)
end

slot0.setXgmAction = function (slot0, slot1)
	if not slot0.xgm then
		return
	end

	slot0.xgmSklGraphic.timeScale = slot0.xgmAnimLength[slot1] / slot0.xgmAnimTargetLength[slot1]

	slot0.xgmSpine:SetAction(slot1, 0)
end

slot0.setGuinuAction = function (slot0, slot1)
	if not slot0.guinu then
		return
	end

	slot0.guinuSklGraphic.timeScale = slot0.guinuAnimLength[slot1] / slot0.guinuAnimTargetLength[slot1]

	slot0.guinuSpine:SetAction(slot1, 0)
end

slot0.setBucketAAction = function (slot0, slot1)
	slot0.bucketAGraphic.timeScale = slot0.bucketAAnimLength[slot1] / slot0.bucketAAnimTargetLength[slot1]

	slot0.bucketASpine:SetAction(slot1, 0)
end

slot0.setBucketBAction = function (slot0, slot1)
	slot0.bucketBGraphic.timeScale = slot0.bucketBAnimLength[slot1] / slot0.bucketBAnimTargetLength[slot1]

	slot0.bucketBSpine:SetAction(slot1, 0)
end

slot0.showBucketAEffect = function (slot0)
	slot0.aEffectList = slot0.aEffectList or {}
	slot0.aEffectUsingList = slot0.aEffectUsingList or {}

	function slot1()
		slot0 = table.remove(slot0.aEffectList, #slot0.aEffectList)
		slot0.aEffectUsingList[#slot0.aEffectUsingList + 1] = slot0

		setParent(slot0, slot0.bucketA, false)

		slot0.localScale = Vector3.one

		setActive(slot0, true)
		slot0:managedTween(LeanTween.delayedCall, function ()
			slot0:recycleBucketAEffect(slot0)
		end, 2, nil)
	end

	if #slot0.aEffectList == 0 then
		slot0.autoLoader.LoadPrefab(slot2, "effect/xinnianyouxi_baozha", nil, function (slot0)
			slot0.aEffectList[#slot0.aEffectList + 1] = tf(slot0)

			slot0.aEffectList()
		end)
	else
		slot1()
	end
end

slot0.recycleBucketAEffect = function (slot0, slot1)
	for slot5 = #slot0.aEffectUsingList, 1, -1 do
		if slot0.aEffectUsingList[slot5] == slot1 then
			setActive(slot1, false)

			slot0.aEffectList[#slot0.aEffectList + 1] = table.remove(slot0.aEffectUsingList, slot5)
		end
	end
end

slot0.getBlock = function (slot0, slot1, slot2)
	slot3 = slot1 .. "-" .. slot2

	if not slot0.blockPool then
		slot0.blockPool = {}
		slot0.blockSource = {}

		for slot7 = 1, 3, 1 do
			for slot11 = 1, 3, 1 do
				slot0.blockPool[slot7 .. "-" .. slot11] = {
					[#slot0.blockPool[slot7 .. "-" .. slot11] + 1] = slot0:findTF("res/item" .. slot7 .. "-" .. slot11)
				}
				slot0.blockSource[slot7 .. "-" .. slot11] = slot0.findTF("res/item" .. slot7 .. "-" .. slot11)
			end
		end
	end

	slot4 = nil

	if #slot0.blockPool[slot3] > 0 then
		table.remove(slot0.blockPool[slot3], #slot0.blockPool[slot3]):SetParent(slot0.content, false)
	else
		slot4 = cloneTplTo(slot0.blockSource[slot3], slot0.content)
	end

	setActive(slot4, true)

	slot0.blockUniId = slot0.blockUniId + 1

	return {
		uid = slot0.blockUniId,
		key = slot3,
		tf = slot4
	}
end

slot0.recycleBlock = function (slot0, slot1)
	slot0.blockPool[slot1.key][#slot0.blockPool[slot1.key] + 1] = slot1.tf

	slot1.tf.SetParent(slot2, slot0.res, false)
	setActive(slot1.tf, false)
end

slot0.msHoldBlock = function (slot0, slot1)
	setParent(slot1.tf, slot0.msHandSlot, false)

	slot1.tf.localPosition = Vector2.zero
	slot0.msBlockList[#slot0.msBlockList + 1] = slot1
end

slot0.msClearHold = function (slot0)
	for slot4 = #slot0.msBlockList, 1, -1 do
		slot0:removeUsingBlock(table.remove(slot0.msBlockList, slot4))
	end
end

slot0.addUsingBlock = function (slot0, slot1)
	slot0.usingBlockList[#slot0.usingBlockList + 1] = slot1
end

slot0.removeUsingBlock = function (slot0, slot1)
	for slot5 = #slot0.usingBlockList, 1, -1 do
		if slot0.usingBlockList[slot5].uid == slot1.uid then
			slot0:recycleBlock(slot0.usingBlockList[slot5])
			table.remove(slot0.usingBlockList, slot5)
		end
	end
end

slot0.clearUsingBlock = function (slot0)
	for slot4 = #slot0.usingBlockList, 1, -1 do
		slot0:recycleBlock(slot0.usingBlockList[slot4])
		table.remove(slot0.usingBlockList, slot4)
	end
end

slot0.getShowBlock = function (slot0, slot1, slot2)
	slot4 = "item" .. slot3
	slot0.showBlockDic = slot0.showBlockDic or {}
	slot5 = nil

	(not slot0.showBlockDic[slot3] or slot0.showBlockDic[slot3]) and false.init(slot5)

	return (not slot0.showBlockDic[slot3] or slot0.showBlockDic[slot3]) and false
end

slot0.startGameTimer = function (slot0)
	slot0.remainTime = slot0:GetMGData():GetSimpleValue("gameTime")

	setText(slot0.remainTxt, slot0.remainTime .. "S")

	function slot1()
		slot0.remainTime = slot0.remainTime - 1

		setText(slot0.remainTxt, slot0.remainTime .. "S")

		if setText.remainTime <= 0 then
			slot0.remainTimer:Stop()
		end
	end

	if slot0.remainTimer then
		slot0.remainTimer.Reset(slot2, slot1, 1, -1)
	else
		slot0.remainTimer = Timer.New(slot1, 1, -1)
	end

	slot0.remainTimer:Start()
end

slot0.startRoundTimer = function (slot0)
	slot0.roundTime = slot0:GetMGData():GetSimpleValue("roundTime")

	setText(slot0.roundTxt, slot0.roundTime)

	function slot1()
		slot0.roundTime = slot0.roundTime - 1

		setText(slot0.roundTxt, slot0.roundTime)

		if setText.roundTime <= 0 then
			slot0.roundTimer:Stop()

			if not QTEGAME_DEBUG then
				slot0:setGameState(slot0.STATE_SHOW)
			end
		end
	end

	if slot0.roundTimer then
		slot0.roundTimer.Reset(slot2, slot1, 1, -1)
	else
		slot0.roundTimer = Timer.New(slot1, 1, -1)
	end

	slot0.roundTimer:Start()
end

slot0.clearTimer = function (slot0)
	if slot0.remainTimer then
		slot0.remainTimer:Stop()

		slot0.remainTimer = nil
	end

	if slot0.roundTimer then
		slot0.roundTimer:Stop()

		slot0.roundTimer = nil
	end
end

slot0.OnSendMiniGameOPDone = function (slot0, slot1)
	slot2 = slot1.argList

	if slot1.cmd == MiniGameOPCommand.CMD_COMPLETE and slot2[1] == 0 then
		slot0:SendOperator(MiniGameOPCommand.CMD_SPECIAL_GAME, {
			slot0:GetMGData():GetSimpleValue("shrineGameId"),
			1
		})
	end
end

slot0.checkHelp = function (slot0)
	if PlayerPrefs.GetInt("QTEGameGuide", 0) == 0 then
		triggerButton(slot0.ruleBtn)
		PlayerPrefs.SetInt("QTEGameGuide", 1)
		PlayerPrefs.Save()
	end
end

slot0.willExit = function (slot0)
	slot0:clearTimer()
	pg.UIMgr.GetInstance():UnblurPanel(slot0.endUI, slot0._tf)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.keyBar, slot0.content)

	slot0.xgm = nil
	slot0.xgmSpine = nil
	slot0.xgmSklGraphic = nil
	slot0.guinu = nil
	slot0.guinuSpine = nil
	slot0.guinuSklGraphic = nil

	slot0.autoLoader:Clear()
end

return slot0

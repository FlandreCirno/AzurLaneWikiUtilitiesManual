slot0 = class("ShootingGameView", import("..BaseMiniGameView"))
slot0.animTime = 0.3333333333333333
slot0.moveModulus = 120

slot0.getUIName = function (slot0)
	return "ShootingGameUI"
end

slot0.init = function (slot0)
	slot0.uiMGR = pg.UIMgr.GetInstance()
	slot0.blurPanel = slot0._tf:Find("noAdaptPanel/blur_panel")
	slot0.top = slot0.blurPanel:Find("top")
	slot0.backBtn = slot0.top:Find("back")
	slot0.scoreTF = slot0.top:Find("score/Text")

	setText(slot0.scoreTF, 0)

	slot0.bestScoreTF = slot0.top:Find("score_heightest/Text")
	slot0.ticketTF = slot0.top:Find("ticket/Text")
	slot0.helpBtn = slot0.top:Find("help_btn")
	slot0.sightTF = slot0.blurPanel:Find("MoveArea/Sight")

	setActive(slot0.sightTF, false)

	slot0.corners = slot0.blurPanel:Find("Corners")
	slot0.shootAreaTF = slot0._tf:Find("noAdaptPanel/ShootArea")
	slot0.targetPanel = slot0.shootAreaTF:Find("target_panel")
	slot0.targetTpl = {}

	for slot5 = 1, slot0.shootAreaTF:Find("tpl").childCount, 1 do
		slot0.targetTpl[slot5] = slot1:GetChild(slot5 - 1)
	end

	setActive(slot1, false)

	slot0.startMaskTF = slot0.shootAreaTF:Find("start_mask")
	slot0.countdownTF = slot0.startMaskTF:Find("count")
	slot0.lastTimeTF = slot0.shootAreaTF:Find("time_word")
	slot0.bottomTF = slot0._tf:Find("noAdaptPanel/bottom")
	slot0.joyStrickTF = slot0.bottomTF:Find("Stick")
	slot0.fireBtn = slot0.bottomTF:Find("fire/ActCtl")
	slot0.fireBtnDelegate = GetOrAddComponent(slot0.fireBtn, "EventTriggerListener")

	setActive(slot0.fireBtn:Find("block"), false)

	slot0.resultPanel = slot0._tf:Find("result_panel")

	setActive(slot0.resultPanel, false)
end

slot0.initData = function (slot0)
	slot0.tempConfig = slot0:GetMGData():getConfig("simple_config_data")
	slot0.tempConfig.waitCountdown = 3
	slot0.tempConfig.half = 56
end

slot0.addTimer = function (slot0, slot1, slot2, slot3)
	slot0.timerList = slot0.timerList or {}
	slot0.timerList[slot1] = {
		timeMark = Time.realtimeSinceStartup + slot2,
		func = slot3
	}
end

slot0.updateTimers = function (slot0)
	slot1 = Time.realtimeSinceStartup

	for slot5, slot6 in pairs(slot0.timerList) do
		if slot6.timeMark < slot1 then
			slot0.timerList[slot5] = nil

			slot6.func()
		end
	end
end

slot0.stopTimers = function (slot0)
	slot0.isStopped = true
	slot1 = Time.realtimeSinceStartup

	for slot5, slot6 in pairs(slot0.timerList) do
		slot6.timeMark = slot6.timeMark - slot1
	end
end

slot0.restartTimers = function (slot0)
	slot0.isStopped = false
	slot1 = Time.realtimeSinceStartup

	for slot5, slot6 in pairs(slot0.timerList) do
		slot6.timeMark = slot6.timeMark + slot1
	end
end

slot0.clearTimers = function (slot0)
	slot0.timerList = {}
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		if slot0.isPlaying then
			slot0:stopTimers()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tips_summergame_exit"),
				onYes = function ()
					slot0:gameFinish(true)
					slot0.gameFinish:closeView()
				end,
				onNo = function ()
					slot0:restartTimers()
				end
			})
		else
			slot0.closeView(slot0)
		end
	end)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_summer_shooting.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.startMaskTF, function ()
		if not slot0.isPlaying then
			slot0:gameStart()
		end
	end)
	slot0.initData(slot0)
	slot0:updateCount()
	slot0:resetTime()
	slot0:initFireFunc()
	slot0:setFireLink(false)
	setActive(slot0.startMaskTF, true)
end

slot0.onBackPressed = function (slot0)
	triggerButton(slot0.backBtn)
end

function slot1(slot0, slot1)
	return Vector2(math.clamp(slot0.x, -slot1.x, slot1.x), math.clamp(slot0.y, -slot1.y, slot1.y))
end

slot0.update = function (slot0)
	slot1 = Time.GetTimestamp()

	if not slot0.isStopped then
		if slot0.isAfterCount and slot0.sightTimeMark then
			if not slot0.moveRect then
				slot0.moveRect = Vector2(tf(slot0.sightTF.parent).rect.width - slot0.sightTF.rect.width, tf(slot0.sightTF.parent).rect.height - slot0.sightTF.rect.height) / 2
			end

			slot0.sightTF.anchoredPosition = slot1(slot0.sightTF.anchoredPosition + Vector2(slot0.uiMGR.hrz, slot0.uiMGR.vtc) * slot0.tempConfig.moveSpeed * (slot1 - slot0.sightTimeMark) * slot0.moveModulus * ((slot0.isDown and 0.5) or 1), slot0.moveRect)
		end

		slot0:updateTimers()
	end

	slot0.sightTimeMark = slot1
end

slot0.resetTime = function (slot0)
	slot0.countdown = slot0.tempConfig.waitCountdown

	setText(slot0.countdownTF, slot0.countdown)

	slot0.lastTime = slot0.tempConfig.baseTime

	setText(slot0.lastTimeTF, slot0.lastTime)
end

slot0.gameStart = function (slot0)
	slot0.isPlaying = true

	UpdateBeat:Add(slot0.update, slot0)
	setActive(slot0.countdownTF, true)
	setActive(slot0.startMaskTF:Find("word"), false)
	slot1(function (slot0)
		slot0:addTimer("start countdown", 1, function ()
			slot0.countdown = slot0.countdown - 1

			setText(slot0.countdownTF, slot0.countdown)

			if setText.countdown > 0 then
				slot1(slot1)
			else
				slot0:afterCountDown()
			end
		end)
	end)
end

slot0.afterCountDown = function (slot0)
	slot0.isAfterCount = true

	slot0.uiMGR:AttachStickOb(slot0.joyStrickTF)
	setActive(slot0.sightTF, true)
	setAnchoredPosition(slot0.sightTF, Vector2.zero)
	slot0:setFireLink(true)
	setActive(slot0.startMaskTF, false)

	slot0.score = 0

	slot0:flushTarget(true)
	slot1(function (slot0)
		slot0:addTimer("gamefinish", 1, function ()
			slot0.lastTime = slot0.lastTime - 1

			setText(slot0.lastTimeTF, slot0.lastTime)

			if setText.lastTime > 0 then
				slot1(slot1)
			else
				slot0:gameFinish()
			end
		end)
	end)
end

slot0.gameFinish = function (slot0, slot1)
	if slot0.isAfterCount then
		slot0:setFireLink(false)
		slot0.uiMGR:ClearStick()

		slot0.isAfterCount = false
	end

	slot0:clearTimers()
	UpdateBeat:Remove(slot0.update, slot0)
	setActive(slot0.sightTF, false)
	setActive(slot0.countdownTF, false)
	slot0:resetTime()

	slot0.isPlaying = false

	if not slot1 then
		for slot5 = 1, 3, 1 do
			for slot9 = 1, 6, 1 do
				if slot0.cell[slot5][slot9] then
					slot0.targetPanel:Find("line_" .. slot5):GetChild(slot9 - 1):GetChild(0):GetComponent(typeof(Animator)):Play("targetDown")
				end
			end
		end

		Timer.New(function ()
			setActive(slot0.startMaskTF, true)
			setActive(slot0.startMaskTF:Find("word"), true)
		end, slot0.animTime).Start(slot2)
		slot0:resultFinish()
	end
end

slot0.resultFinish = function (slot0)
	slot2 = nil

	for slot6 = 1, #slot0.tempConfig.score_level, 1 do
		if slot1[#slot1 - slot6 + 1] <= slot0.score then
			slot2 = slot6

			break
		end
	end

	slot0.awardLevel = slot2

	if slot0:GetMGHubData().count > 0 then
		slot0:SendSuccess(slot2)
	else
		slot0:showResultPanel({})
	end
end

slot0.showResultPanel = function (slot0, slot1, slot2)
	onButton(slot0, slot0.resultPanel:Find("bg"), slot3)
	onButton(slot0, slot0.resultPanel:Find("main/btn_confirm"), function ()
		setActive(slot0.resultPanel, false)

		if slot0.resultPanel then
			slot1()
		else
			slot0:updateCount()
		end
	end)

	slot4 = slot0.resultPanel:Find("main")

	if slot0.bestScore < slot0.score then
		slot0:StoreDataToServer({
			slot0.score
		})
		GetImageSpriteFromAtlasAsync("ui/shootinggameui_atlas", "new_recode", slot4:Find("success"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/shootinggameui_atlas", "success", slot4:Find("success"), true)
	end

	GetImageSpriteFromAtlasAsync("ui/shootinggameui_atlas", "level_" .. #slot0.tempConfig.score_level - slot0.awardLevel + 1, slot4:Find("success/level"), true)
	setText(slot4:Find("right/score/number"), slot0.score)
	setActive(slot4:Find("right/awards/list"), #slot1 > 0)
	setActive(slot4:Find("right/awards/nothing"), #slot1 == 0)

	slot0.itemList = slot0.itemList or UIItemList.New(slot4:Find("right/awards/list"), slot4:Find("right/awards/list/item"))

	slot0.itemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, slot0[slot1 + 1])
			setText(slot2:Find("number"), "x" .. slot0[slot1 + 1].count)
		end
	end)
	slot0.itemList.align(slot5, #slot1)
	setActive(slot0.resultPanel, true)
end

slot0.updateAfterFinish = function (slot0)
	pg.m02:sendNotification(GAME.MODIFY_MINI_GAME_DATA, {
		id = MiniGameDataCreator.ShrineGameID,
		map = {
			count = (getProxy(MiniGameProxy):GetMiniGameData(MiniGameDataCreator.ShrineGameID):GetRuntimeData("count") or 0) + 1
		}
	})
end

slot0.OnGetAwardDone = function (slot0, slot1)
	if slot1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		if slot0:GetMGHubData().ultimate == 0 and slot2:getConfig("reward_need") <= slot2.usedtime then
			pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
				hubid = slot2.id,
				cmd = MiniGameOPCommand.CMD_ULTIMATE,
				args1 = {}
			})
		end
	elseif slot1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI2")
	end
end

slot0.OnSendMiniGameOPDone = function (slot0, slot1)
	slot0:updateCount()
end

slot0.updateCount = function (slot0)
	setText(slot0.ticketTF, slot0:GetMGHubData().count)

	slot0.bestScore = checkExist(slot0:GetMGData():GetRuntimeData("elements"), {
		1
	}) or 0

	setText(slot0.bestScoreTF, slot0.bestScore)
end

slot0.initFireFunc = function (slot0)
	slot1 = pg.TipsMgr.GetInstance()
	slot2 = pg.TimeMgr.GetInstance()

	setImageAlpha(slot3, 1)
	setImageAlpha(slot4, 0)

	function slot5()
		setActive(slot0.corners, true)
		LeanTween.scale(slot0.corners, Vector3(1.95, 1.95, 1), 0.1):setOnComplete(System.Action(function ()
			LeanTween.alpha(LeanTween.alpha, 0, 0.1)
			LeanTween.alpha(LeanTween.alpha, 1, 0.1)
		end))
	end

	function slot6()
		setActive(slot0.corners, false)
		LeanTween.alpha(slot0.corners, 1, 0.1)
		LeanTween.alpha(1, 0, 0.1):setOnComplete(System.Action(function ()
			LeanTween.scale(LeanTween.scale, Vector3.one, 0.1)
		end))
	end

	slot0._downFunc = function ()
		slot0()
	end

	slot0._upFunc = function ()
		LeanTween.scale(LeanTween.scale, Vector3(2, 2, 2), 0.03):setOnComplete(System.Action(function ()
			LeanTween.scale(LeanTween.scale, Vector3.one, 0.07):setOnComplete(System.Action(function ()
				slot0()
			end))
		end))

		slot0, slot1, slot2 = slot2.checkHit(slot0)

		if slot0 then
			slot2.cell[slot1][slot2] = nil
			slot2.score = slot2.score + slot2.tempConfig.targetScore[slot2.cell[slot1][slot2]]
			slot2.targetCount[slot2.cell[slot1][slot2]] = slot2.targetCount[slot2.cell[slot1][slot2]] - 1
			slot2.lastTime = slot2.lastTime + slot2.tempConfig.bonusTime

			setText(slot2.lastTimeTF, slot2.lastTime)
			slot2.targetPanel:Find("line_" .. slot1):GetChild(slot2 - 1):GetChild(0):GetComponent(typeof(Animator)).Play(slot4, "targetDown")
			slot2:addTimer("flush call", 0.2 + slot3.animTime, function ()
				slot0:flushTarget()
			end)

			if not _.any(slot2.targetCount, function (slot0)
				return slot0 > 0
			end) then
				slot2.gameFinish(slot5)
			end
		end

		slot2:setFireLink(false)
		slot2:addTimer("fire cd", slot2.tempConfig.fireCD, function ()
			slot0:setFireLink(true)
		end)
	end

	slot0._cancelFunc = function ()
		slot0()
	end

	slot0._emptyFunc = nil
end

slot0.setFireLink = function (slot0, slot1)
	if slot1 then
		setButtonEnabled(slot0.fireBtn, true)

		if slot0._downFunc ~= nil then
			slot0.fireBtnDelegate:AddPointDownFunc(function ()
				slot0.isDown = true

				if slot0._main_cannon_sound then
					slot0._main_cannon_sound:Stop(true)
				end

				slot0._main_cannon_sound = pg.CriMgr.GetInstance():PlaySE_V3("battle-cannon-main-prepared")

				slot0._downFunc()
			end)
		end

		if slot0._upFunc ~= nil then
			slot0.fireBtnDelegate.AddPointUpFunc(slot2, function ()
				if slot0.isDown then
					if slot0._main_cannon_sound then
						slot0._main_cannon_sound:Stop(true)
					end

					pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/battle/boom2")

					pg.CriMgr.GetInstance().PlaySoundEffect_V3.isDown = false

					pg.CriMgr.GetInstance().PlaySoundEffect_V3._upFunc()
				end
			end)
		end

		if slot0._cancelFunc ~= nil then
			slot0.fireBtnDelegate.AddPointExitFunc(slot2, function ()
				if slot0.isDown then
					if slot0._main_cannon_sound then
						slot0._main_cannon_sound:Stop(true)
					end

					slot0.isDown = false

					slot0._cancelFunc()
				end
			end)
		end
	else
		if slot0.isDown then
			slot0.isDown = false

			slot0._cancelFunc()
		end

		setButtonEnabled(slot0.fireBtn, false)
		slot0.fireBtnDelegate.RemovePointDownFunc(slot2)
		slot0.fireBtnDelegate:RemovePointUpFunc()
		slot0.fireBtnDelegate:RemovePointExitFunc()
	end
end

slot0.flushTarget = function (slot0, slot1)
	if slot1 then
		slot0.targetCount = {
			2,
			4,
			6
		}
	end

	for slot5 = 1, 3, 1 do
		for slot9 = 1, 6, 1 do
			removeAllChildren(slot0.targetPanel:Find("line_" .. slot5):GetChild(slot9 - 1))
		end
	end

	slot2 = {
		0,
		0,
		0
	}
	slot0.cell = {
		{},
		{},
		{}
	}

	for slot6, slot7 in ipairs(slot0.targetCount) do
		for slot11 = 1, slot7, 1 do
			slot12 = math.random(3)
			slot13 = math.random(6)

			while slot0.cell[slot12][slot13] or (slot1 and slot2[slot12] >= 4) do
				slot13 = math.random(6)
				slot12 = math.random(3)
			end

			slot2[slot12] = slot2[slot12] + 1
			slot0.cell[slot12][slot13] = slot6

			cloneTplTo(slot0.targetTpl[slot6], slot0.targetPanel:Find("line_" .. slot12):GetChild(slot13 - 1))
		end
	end

	setText(slot0.scoreTF, slot0.score)
end

slot0.checkHit = function (slot0)
	for slot4 = 1, 3, 1 do
		for slot8 = 1, 6, 1 do
			if slot0.cell[slot4][slot8] then
				slot9 = slot0.targetPanel:Find("line_" .. slot4):GetChild(slot8 - 1):GetChild(0):Find("icon/face")
				slot10 = slot0.sightTF:InverseTransformPoint(slot9:TransformPoint(slot9.position))

				if slot10.x * slot10.x + slot10.y * slot10.y < slot0.tempConfig.half * slot0.tempConfig.half then
					return true, slot4, slot8
				end
			end
		end
	end
end

slot0.willExit = function (slot0)
	return
end

return slot0

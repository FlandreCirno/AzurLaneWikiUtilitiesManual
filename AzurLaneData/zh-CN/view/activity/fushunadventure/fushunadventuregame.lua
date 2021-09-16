slot0 = class("FushunAdventureGame")
slot1 = false
slot2 = 0
slot3 = 1
slot4 = 2
slot5 = 3
slot6 = 4

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	pg.DelegateInfo.New(slot0)

	pg.fushunLoader = BundleLoaderPort.New()
	slot0.state = slot0
	slot0._go = slot1
	slot0.gameData = slot2
	slot0.highestScore = slot3:GetRuntimeData("elements") or {}[1] or 0

	slot0:Init()
end

slot0.SetOnShowResult = function (slot0, slot1)
	slot0.OnShowResult = slot1
end

slot0.SetOnLevelUpdate = function (slot0, slot1)
	slot0.OnLevelUpdate = slot1
end

slot0.Init = function (slot0)
	if slot0.state ~= slot0 then
		return
	end

	slot0.state = slot1

	slot0:InitMainUI()
end

slot0.InitMainUI = function (slot0)
	onButton(slot0, findTF(slot1, "btn_help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fushun_adventure_help.tip
		})
	end, SFX_PANEL)
	onButton(slot0, findTF(slot1, "btn_start"), function ()
		pg.CriMgr.GetInstance():StopBGM()
		pg.CriMgr.GetInstance().StopBGM:StartGame()
	end, SFX_PANEL)

	slot0.levelList = UIItemList.New(findTF(slot1, "levels/scrollrect/content"), findTF(slot1, "levels/scrollrect/content/level"))
	slot0.arrUp = findTF(slot1, "levels/arr_up")
	slot0.arrDown = findTF(slot1, "levels/arr_bottom")

	onScroll(slot0, findTF(slot1, "levels/scrollrect"), function (slot0)
		setActive(slot0.arrUp, slot0.y < 1)
		setActive(slot0.arrDown, slot0.y > 0)
	end)
	slot0.RefreshLevels(slot0)
end

slot0.RefreshLevels = function (slot0)
	slot1 = nil

	slot0.levelList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot2:Find("Text"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/FushunAdventureGame_atlas", "level_" .. slot1 + 1)

			setActive(slot2:Find("lock"), slot1 >= slot0.gameData.usedtime + ((slot0.gameData.count > 0 and 1) or 0))
			setActive(slot2:Find("cleared"), slot1 < slot0.gameData.usedtime)
			setActive(slot2:Find("Text"), not (slot1 >= slot0.gameData.usedtime + ((slot0.gameData.count > 0 and 1) or 0)))

			if not (slot1 < slot0.gameData.usedtime) and not slot1 then
				slot1 = slot1
			end

			slot2:GetComponent(typeof(Image)).enabled = not slot4
		end
	end)
	slot0.levelList.align(slot2, FushunAdventureGameConst.LEVEL_CNT)
	setActive(findTF(slot0._go, "tip/got"), slot0.gameData.ultimate ~= 0)

	if slot1 then
		setAnchoredPosition(slot0.levelList.container, {
			y = slot0.levelList.container.anchoredPosition.y + slot1 * (slot0.levelList.item.rect.height + 50)
		})
	end

	if slot0.OnLevelUpdate then
		slot0.OnLevelUpdate()
	end
end

slot0.InitGameUI = function (slot0)
	slot0.btnA = findTF(slot1, "UI/A")
	slot0.btnB = findTF(slot1, "UI/B")
	slot0.btnAEffect = slot0.btnA:Find("effect")
	slot0.btnBEffect = slot0.btnB:Find("effect")
	slot0.btnAExEffect = slot0.btnA:Find("effect_ex")
	slot0.btnBExEffect = slot0.btnB:Find("effect_ex")
	slot0.keys = {
		findTF(slot1, "UI/keys/1"):GetComponent(typeof(Image)),
		findTF(slot1, "UI/keys/2"):GetComponent(typeof(Image)),
		findTF(slot1, "UI/keys/3"):GetComponent(typeof(Image))
	}
	slot0.btnSprites = {
		slot0.keys[1].sprite,
		slot0.btnA:GetComponent(typeof(Image)).sprite,
		slot0.btnB:GetComponent(typeof(Image)).sprite
	}
	slot0.hearts = {
		findTF(slot1, "UI/heart_score/hearts/1/mark"),
		findTF(slot1, "UI/heart_score/hearts/2/mark"),
		findTF(slot1, "UI/heart_score/hearts/3/mark")
	}
	slot0.numbers = {
		findTF(slot1, "UI/countdown_panel/timer/3"),
		findTF(slot1, "UI/countdown_panel/timer/2"),
		findTF(slot1, "UI/countdown_panel/timer/1")
	}
	slot0.scoreTxt = findTF(slot1, "UI/heart_score/score/Text"):GetComponent(typeof(Text))
	slot0.energyBar = findTF(slot1, "UI/ex/bar"):GetComponent(typeof(Image))
	slot0.energyIcon = findTF(slot1, "UI/ex/icon")
	slot0.energyLight = findTF(slot1, "UI/ex/light")
	slot0.exTipPanel = findTF(slot1, "UI/ex_tip_panel")
	slot0.comboTxt = findTF(slot1, "UI/combo/Text"):GetComponent(typeof(Text))
	slot0.countdownPanel = findTF(slot1, "UI/countdown_panel")
	slot0.resultPanel = findTF(slot1, "UI/result_panel")
	slot0.resultCloseBtn = findTF(slot0.resultPanel, "frame/close")
	slot0.resultHighestScoreTxt = findTF(slot0.resultPanel, "frame/highest/Text"):GetComponent(typeof(Text))
	slot0.resultScoreTxt = findTF(slot0.resultPanel, "frame/score/Text"):GetComponent(typeof(Text))
	slot0.msgboxPanel = findTF(slot1, "UI/msg_panel")
	slot0.exitMsgboxWindow = findTF(slot0.msgboxPanel, "frame/exit_mode")
	slot0.pauseMsgboxWindow = findTF(slot0.msgboxPanel, "frame/pause_mode")
	slot0.helpWindow = findTF(slot1, "UI/help")
	slot0.lightTF = findTF(slot1, "game/range")
	slot0.lightMark = slot0.lightTF:Find("Image")
	slot0.pauseBtn = findTF(slot1, "UI/pause")
	slot0.exitBtn = findTF(slot1, "UI/back")
	slot0.energyBar.fillAmount = 0
end

slot0.EnterAnimation = function (slot0, slot1)
	setActive(slot0.countdownPanel, true)

	function slot2(slot0)
		for slot4, slot5 in ipairs(slot0.numbers) do
			setActive(slot5, slot4 == slot0)
		end
	end

	slot0.countdownTimer = Timer.New(function ()
		if slot0 + 1 > 3 then
			setActive(slot1.countdownPanel, false)
			false()
		else
			slot3(slot3)
		end
	end, 1, 3)

	slot2(slot3)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.COUNT_DOWN_VOICE)
	slot0.countdownTimer:Start()
end

slot0.ShowHelpWindow = function (slot0, slot1)
	setActive(slot0.helpWindow, true)
	onButton(slot0, slot0.helpWindow, function ()
		setActive(slot0.helpWindow, false)
		PlayerPrefs.SetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 1)
		"FushunAdventureGame" .. getProxy(PlayerProxy).getRawData().id()
	end, SFX_PANEL)
end

slot0.DisplayKey = function (slot0)
	function slot1(slot0, slot1)
		slot2 = nil

		if not slot1 or slot1 == "" then
			slot2 = slot0.btnSprites[1]
		elseif slot1 == "A" then
			slot2 = slot0.btnSprites[2]
		elseif slot1 == "B" then
			slot2 = slot0.btnSprites[3]
		end

		if slot0.sprite ~= slot2 then
			slot0.sprite = slot2
		end
	end

	for slot5, slot6 in ipairs(slot0.keys) do
		slot1(slot6, string.sub(slot0.key, slot5, slot5) or "")
	end
end

slot0.DisplayeHearts = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.hearts) do
		setActive(slot6, slot5 <= slot1)
	end
end

slot0.DisplayScore = function (slot0)
	slot0.scoreTxt.text = slot0.score
end

slot0.DisplayeEnergy = function (slot0, slot1, slot2)
	slot3 = math.min(1, slot1 / slot2)
	slot0.energyBar.fillAmount = slot3

	setAnchoredPosition(slot0.energyIcon, {
		x = math.max(0, slot0.energyIcon.parent.rect.width * slot3 - slot0.energyIcon.rect.width)
	})

	slot6 = 0

	if slot3 >= 1 then
		slot6 = tf(slot0.energyBar.gameObject).rect.width
	elseif slot4 > 0 then
		slot6 = slot4
	end

	setActive(slot0.energyLight, slot3 >= 0.01)

	slot0.energyLight.sizeDelta = Vector2(slot6, slot0.energyLight.sizeDelta.y)
end

slot0.StartGame = function (slot0)
	if slot0.state ~= slot0 then
		return
	end

	slot0.enemys = {}
	slot0.hitList = {}
	slot0.missFlags = {}
	slot0.score = 0
	slot0.combo = 0
	slot0.pause = false
	slot0.schedule = FushunSchedule.New()
	slot0.specailSchedule = FushunSchedule.New()

	slot0:LoadScene(function ()
		slot0:EnterGame()
		pg.CriMgr.GetInstance():PlayBGM(FushunAdventureGameConst.GAME_BGM_NAME)
	end)

	slot0.state = slot0.LoadScene
end

slot0.LoadScene = function (slot0, slot1)
	seriesAsync({
		function (slot0)
			if slot0.gameUI then
				setActive(slot0.gameUI, true)
				slot0()
			else
				pg.fushunLoader:LoadPrefab("ui/FushunAdventureGame", "", "FushunAdventureGame", function (slot0)
					slot0.gameUI = slot0

					slot0.transform:SetParent(slot0._go.transform, false)
					slot0:InitGameUI()
					slot0.InitGameUI()
				end)
			end
		end,
		function (slot0)
			slot0:DisplayeHearts(3)
			slot0:DisplayScore()
			slot0:DisplayeEnergy(0, 1)

			if not (PlayerPrefs.GetInt("FushunAdventureGame" .. getProxy(PlayerProxy):getRawData().id, 0) > 0) then
				slot0:ShowHelpWindow(slot0)
			else
				slot0()
			end
		end,
		function (slot0)
			parallelAsync({
				function (slot0)
					slot0:EnterAnimation(slot0)
				end,
				function (slot0)
					pg.fushunLoader:LoadPrefab("FushunAdventure/fushun", "", "fushun", function (slot0)
						slot0.fushun = FushunChar.New(slot0)

						slot0.fushun:SetPosition(FushunAdventureGameConst.FUSHUN_INIT_POSITION)
						slot0.transform:SetParent(slot0.gameUI.transform:Find("game"), false)
						slot0.transform.SetParent()
					end)
				end
			}, slot0)
		end
	}, slot1)
end

slot0.EnterGame = function (slot0)
	if not slot0.handle then
		slot0.handle = UpdateBeat:CreateListener(slot0.UpdateGame, slot0)
	end

	UpdateBeat:AddListener(slot0.handle)

	slot0.lightTF.sizeDelta = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_RANGE, slot0.lightTF.sizeDelta.y)
	slot0.lightTF.localPosition = Vector2(FushunAdventureGameConst.FUSHUN_ATTACK_DISTANCE + slot0.fushun:GetPosition().x, slot0.lightTF.localPosition.y)

	slot0:SpawnEnemys()
	slot0:RegisterEventListener()

	slot0.key = ""

	slot0.fushun:SetOnAnimEnd(function ()
		slot0.key = ""

		slot0:DisplayKey()
	end)
end

slot0.UpdateGame = function (slot0)
	if slot0.state == slot0 then
		slot0:ExitGame(true)

		return
	end

	if not slot0.pause then
		slot0.spawner:Update()
		slot0:AddDebugInput()

		if slot0.fushun:IsDeath() then
			slot0.fushun:Die()

			slot0.state = slot0

			return
		elseif slot0.fushun:ShouldInvincible() then
			slot0:EnterInvincibleMode()
		elseif slot0.fushun:ShouldVincible() then
			slot0:ExitInvincibleMode()
		end

		slot1 = false

		for slot5 = #slot0.enemys, 1, -1 do
			if slot0.enemys[slot5]:IsFreeze() then
			elseif slot0:CheckEnemyDeath(slot5) then
			else
				slot6:Move()
				slot0:CheckCollision(slot0.fushun, slot6)

				if slot0:CheckAttackRange(slot6) then
					slot1 = true
				end
			end
		end

		slot0:RangeLightDisplay(slot1)
		slot0:DisplayeEnergy(slot0.fushun:GetEnergy(), slot0.fushun:GetEnergyTarget())
		slot0.specailSchedule:Update()
	else
		for slot4 = #slot0.enemys, 1, -1 do
			slot0:CheckEnemyDeath(slot4)
		end
	end

	slot0.schedule:Update()
end

slot0.RangeLightDisplay = function (slot0, slot1)
	setActive(slot0.lightMark, slot1)
end

slot0.CheckAttackRange = function (slot0, slot1)
	return slot1:GetPosition().x <= slot0.fushun:GetAttackPosition().x
end

slot0.CheckEnemyDeath = function (slot0, slot1)
	slot2 = false

	if slot0.enemys[slot1]:IsDeath() then
		if slot0.hitList[slot3.index] and not slot3:IsEscape() then
			slot0:AddScore(slot3:GetScore())
			slot0:AddEnergy(slot3:GetEnergyScore())
		end

		slot3:Vanish()
		table.remove(slot0.enemys, slot1)

		slot2 = true
	end

	return slot2
end

slot0.EnterInvincibleMode = function (slot0)
	slot2 = FushunAdventureGameConst.EX_TIME

	slot0.fushun:Invincible()
	setActive(slot0.exTipPanel, true)

	slot0.pause = true

	blinkAni(slot0.energyBar.gameObject, 0.5, -1)
	slot0.schedule:AddSchedule(slot1, 1, function ()
		setActive(slot0.exTipPanel, false)
		setActive.spawner:CarzyMode()

		setActive.spawner.CarzyMode.pause = false

		setActive.spawner.CarzyMode.fushun:StartAction("EX")
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.ENTER_EX_VOICE)
		slot0.specailSchedule:AddSchedule(1, pg.CriMgr.GetInstance().PlaySoundEffect_V3.fushun:GetEnergyTarget() / pg.CriMgr.GetInstance().PlaySoundEffect_V3.fushun, function ()
			slot0.fushun:ReduceEnergy(slot0.fushun)
		end)
	end)
	setActive(slot0.btnAExEffect, true)
	setActive(slot0.btnBExEffect, true)

	slot0.key = ""

	slot0.DisplayKey(slot0)
end

slot0.ExitInvincibleMode = function (slot0)
	slot0.fushun:Vincible()

	slot0.energyBar.color = Color.New(1, 1, 1, 1)

	LeanTween.cancel(slot0.energyBar.gameObject)

	for slot4, slot5 in ipairs(slot0.enemys) do
		slot0.hitList[slot5.index] = nil

		slot5:Die()
	end

	slot0.spawner:NormalMode()
	setActive(slot0.btnAExEffect, false)
	setActive(slot0.btnBExEffect, false)
end

slot0.CheckCollision = function (slot0, slot1, slot2)
	if slot0.IsCollision(slot2.effectCollider2D, slot1.collider2D) then
		slot1:Hurt()
		slot2:OnHit()
		slot0:DisplayeHearts(slot0.fushun:GetHp())
		slot0:AddCombo(-slot0.combo)
	elseif slot0.fushun:InvincibleState() and not slot2:IsDeath() and slot2:GetPosition().x <= slot1:GetAttackPosition().x then
		slot2:Hurt(1)

		slot0.hitList[slot2.index] = true

		slot0:AddHitEffect(slot2)
	elseif slot0.IsNearby(slot1:GetPosition(), slot2:GetAttackPosition()) then
		slot2:Attack()
	end
end

slot0.AddHitEffect = function (slot0, slot1)
	slot6 = Vector3(slot0.gameUI.transform:InverseTransformPoint(slot4).x, slot0.gameUI.transform:InverseTransformPoint(slot2).y, 0)

	pg.fushunLoader:GetPrefab("FushunAdventure/attack_effect", "", function (slot0)
		slot0.transform:SetParent(slot0.gameUI.transform, false)

		slot0.transform.localPosition = slot1

		slot0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function ()
			slot0:SetEndEvent(nil)
			pg.fushunLoader:ReturnPrefab("FushunAdventure/attack_effect", "", pg.fushunLoader, true)
		end)
	end)
	slot0.ShakeScreen(slot0, slot0.gameUI)
end

slot0.ShakeScreen = function (slot0, slot1)
	if LeanTween.isTweening(slot1) then
		LeanTween.cancel(slot1)
	end

	LeanTween.rotateAroundLocal(slot1, Vector3(0, 0, 1), FushunAdventureGameConst.SHAKE_RANGE, FushunAdventureGameConst.SHAKE_TIME):setLoopPingPong(FushunAdventureGameConst.SHAKE_LOOP_CNT):setFrom(-1 * FushunAdventureGameConst.SHAKE_RANGE):setOnComplete(System.Action(function ()
		slot0.transform.localEulerAngles = Vector3(0, 0, 0)
	end))
end

slot0.SpawnEnemys = function (slot0)
	slot1 = {
		FushunBeastChar,
		FushunEliteBeastChar,
		FushunEliteBeastChar
	}

	function slot2(slot0)
		slot2 = nil

		for slot6, slot7 in ipairs(slot1) do
			slot9 = slot7[1][2]

			if slot7[1][1] <= slot0 and slot0 <= slot9 then
				slot2 = slot7

				break
			end
		end

		return slot2 or slot1[#slot1][2]
	end

	slot0.spawner = FuShunEnemySpawner.New(slot0.gameUI.transform.Find(slot5, "game").transform, function (slot0)
		slot4 = slot0[slot0.config.id].New(slot0.go, slot3, slot1)

		slot3.LOG("  顺序 :", slot3, " id :", slot0.config.id, " speed :", slot0.speed + slot1(slot2.score))
		slot4:SetSpeed(slot6)
		slot4:SetPosition(FushunAdventureGameConst.ENEMY_SPAWN_POSITION)
		table.insert(slot2.enemys, slot4)
	end)

	slot0.spawner:NormalMode()
end

slot0.AddScore = function (slot0, slot1)
	slot0:AddCombo(1)

	slot0.score = slot0.score + slot1 + ((FushunAdventureGameConst.COMBO_SCORE_TARGET <= slot0.combo and FushunAdventureGameConst.COMBO_EXTRA_SCORE) or 0)

	slot0:DisplayScore()
	slot0.spawner:UpdateScore(slot0.score)
end

slot0.AddEnergy = function (slot0, slot1)
	slot0.fushun:AddEnergy(slot1)
end

slot0.AddCombo = function (slot0, slot1)
	if slot1 > 0 then
		pg.fushunLoader:GetPrefab("UI/fushun_combo", "", function (slot0)
			if not pg.fushunLoader then
				Destroy(slot0)

				return
			end

			slot0.transform:SetParent(slot0.gameUI.transform:Find("UI"), false)
			Timer.New(function ()
				if not pg.fushunLoader then
					return
				end

				pg.fushunLoader:ReturnPrefab("UI/fushun_combo", "", pg.fushunLoader.ReturnPrefab, true)
			end, 2, 1).Start(slot1)
		end)
	end

	slot0.combo = slot0.combo + slot1
	slot0.comboTxt.text = slot0.combo

	setActive(slot0.comboTxt.gameObject.transform.parent, slot0.combo > 0)
end

slot0.Action = function (slot0, slot1)
	if slot0.fushun:InvincibleState() then
		slot0:AddScore(FushunAdventureGameConst.EX_CLICK_SCORE)
	else
		slot0:OnFushunAttack(slot1)
	end
end

slot0.OnFushunAttack = function (slot0, slot1)
	if #slot0.key == 3 or slot0.fushun:IsMissState() or slot0.fushun:IsDamageState() then
		return
	end

	slot0.key = slot0.key .. slot1

	slot0:DisplayKey()

	slot2 = {}
	slot3 = slot0.fushun

	for slot7, slot8 in ipairs(slot0.enemys) do
		if not slot8:WillDeath() and slot8:GetPosition().x <= slot3:GetAttackPosition().x then
			table.insert(slot2, slot7)
		end
	end

	slot0.fushun:TriggerAction(slot0.key, function ()
		if #slot0 == 0 then
			slot1.fushun:Miss()
		end

		slot1.key = ""

		"":DisplayKey()
	end)

	if #slot2 > 0 then
		for slot7, slot8 in ipairs(slot2) do
			slot0.enemys[slot8].Hurt(slot9, 1)

			slot0.hitList[slot0.enemys[slot8].index] = true

			slot0:AddHitEffect(slot0.enemys[slot8])
		end
	end
end

slot0.PauseGame = function (slot0)
	slot0.pause = true
end

slot0.ResumeGame = function (slot0)
	slot0.pause = false
end

slot0.ExitGame = function (slot0, slot1)
	function slot2()
		slot0:ClearGameScene()
	end

	if slot0.btnA then
		ClearEventTrigger(slot0.btnA.GetComponent(slot4, "EventTriggerListener"))
	end

	if slot0.btnB then
		ClearEventTrigger(slot0.btnB:GetComponent("EventTriggerListener"))
	end

	if slot0.handle then
		UpdateBeat:RemoveListener(slot0.handle)

		slot0.handle = nil
	end

	if slot0.schedule then
		slot0.schedule:Dispose()

		slot0.schedule = nil
	end

	if slot0.specailSchedule then
		slot0.specailSchedule:Dispose()

		slot0.specailSchedule = nil
	end

	if slot1 then
		if slot0.OnShowResult then
			slot0.OnShowResult(slot0.score)
		end

		slot0:ShowResultWindow(function ()
			slot0()
		end)
	else
		slot2()
	end
end

slot0.ClearGameScene = function (slot0)
	if slot0.fushun then
		slot0.fushun:Destory()

		slot0.fushun = nil
	end

	if slot0.spawner then
		slot0.spawner:Dispose()

		slot0.spawner = nil
	end

	if slot0.enemys then
		for slot4, slot5 in ipairs(slot0.enemys) do
			slot5:Dispose()
		end

		slot0.enemys = nil
	end

	slot0.state = slot0

	if slot0.gameUI then
		slot0:HideExitMsgbox()
		slot0:HideResultWindow()
		slot0:HidePauseMsgbox()
		setActive(slot0.gameUI, false)
		pg.CriMgr.GetInstance():StopBGM()
		pg.CriMgr.GetInstance():PlayBGM(FushunAdventureGameConst.BGM_NAME)
	end
end

slot0.IsStarting = function (slot0)
	return slot0.state == slot0
end

slot0.Dispose = function (slot0)
	if slot0.countdownTimer then
		slot0.countdownTimer:Stop()

		slot0.countdownTimer = nil
	end

	slot0:ExitGame()
	pg.DelegateInfo.Dispose(slot0)

	if slot0.gameUI then
		Destroy(slot0.gameUI)

		slot0.gameUI = nil
	end

	slot0._go = nil
	slot0.btnSprites = nil
	slot0.state = slot0

	pg.fushunLoader:Clear()

	pg.fushunLoader = nil
	slot0.OnShowResult = nil
	slot0.OnLevelUpdate = nil
end

slot0.AddDebugInput = function (slot0)
	if Application.isEditor then
		if Input.GetKeyDown(KeyCode.A) then
			slot0:OnShowBtnEffect("A", true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			slot0:Action("A")
			slot0:OnShowBtnEffect("A", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
		end

		if Input.GetKeyDown(KeyCode.S) then
			slot0:OnShowBtnEffect("B", true)
		end

		if Input.GetKeyUp(KeyCode.S) then
			slot0:Action("B")
			slot0:OnShowBtnEffect("B", false)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
		end
	end
end

slot0.RegisterEventListener = function (slot0)
	slot1 = slot0.btnA:GetComponent("EventTriggerListener")

	slot1:AddPointDownFunc(function ()
		slot0:OnShowBtnEffect("A", true)
	end)
	slot1.AddPointExitFunc(slot1, function ()
		slot0:OnShowBtnEffect("A", false)
	end)
	slot1.AddPointUpFunc(slot1, function ()
		if slot0.pause then
			return
		end

		slot0:Action("A")
		slot0.Action:OnShowBtnEffect("A", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.A_BTN_VOICE)
	end)

	slot2 = slot0.btnB.GetComponent(slot2, "EventTriggerListener")

	slot2:AddPointDownFunc(function ()
		slot0:OnShowBtnEffect("B", true)
	end)
	slot2.AddPointExitFunc(slot2, function ()
		slot0:OnShowBtnEffect("B", false)
	end)
	slot2.AddPointUpFunc(slot2, function ()
		if slot0.pause then
			return
		end

		slot0:Action("B")
		slot0.Action:OnShowBtnEffect("B", false)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(FushunAdventureGameConst.B_BTN_VOICE)
	end)
	onButton(slot0, slot0.pauseBtn, function ()
		slot0:ShowPauseMsgbox()
	end, SFX_PANEL)
	onButton(slot0, slot0.exitBtn, function ()
		slot0:ShowExitMsgbox()
	end, SFX_PANEL)
end

slot0.OnShowBtnEffect = function (slot0, slot1, slot2)
	setActive(slot0["btn" .. slot1 .. "Effect"], slot2)
end

slot0.ShowResultWindow = function (slot0, slot1)
	setActive(slot0.resultPanel, true)
	onButton(slot0, slot0.resultCloseBtn, function ()
		slot0:HideResultWindow()

		if slot0 then
			slot1()
		end
	end, SFX_PANEl)

	slot0.resultHighestScoreTxt.text = slot0.highestScore
	slot0.resultScoreTxt.text = slot0.score

	if slot0.highestScore < slot0.score then
		slot0.highestScore = slot0.score
	end
end

slot0.HideResultWindow = function (slot0)
	setActive(slot0.resultPanel, false)
end

slot0.ShowPauseMsgbox = function (slot0)
	slot0:PauseGame()
	setActive(slot0.msgboxPanel, true)
	setActive(slot0.pauseMsgboxWindow, true)
	setActive(slot0.exitMsgboxWindow, false)
	onButton(slot0, slot0.pauseMsgboxWindow:Find("continue_btn"), function ()
		slot0:ResumeGame()
		slot0.ResumeGame:HidePauseMsgbox()
	end, SFX_PANEL)
end

slot0.HidePauseMsgbox = function (slot0)
	setActive(slot0.msgboxPanel, false)
	setActive(slot0.pauseMsgboxWindow, false)
end

slot0.ShowExitMsgbox = function (slot0)
	slot0:PauseGame()
	setActive(slot0.msgboxPanel, true)
	setActive(slot0.pauseMsgboxWindow, false)
	setActive(slot0.exitMsgboxWindow, true)
	onButton(slot0, slot0.exitMsgboxWindow:Find("cancel_btn"), function ()
		slot0:ResumeGame()
		slot0.ResumeGame:HideExitMsgbox()
	end, SFX_PANEL)
	onButton(slot0, slot0.exitMsgboxWindow:Find("confirm_btn"), function ()
		slot0:HideExitMsgbox()

		if slot0.HideExitMsgbox.OnShowResult then
			slot0.OnShowResult(slot0.score)
		end

		slot0:ExitGame()
	end, SFX_PANEL)
end

slot0.HideExitMsgbox = function (slot0)
	setActive(slot0.msgboxPanel, false)
	setActive(slot0.exitMsgboxWindow, false)
end

slot0.IsCollision = function (slot0, slot1)
	return slot0.enabled and slot1.enabled and slot0.gameObject.activeSelf and slot0.bounds:Intersects(slot1.bounds)
end

slot0.IsNearby = function (slot0, slot1)
	return slot1.x - slot0.x <= 0
end

slot0.LOG = function (...)
	if slot0 then
		print(...)
	end
end

return slot0

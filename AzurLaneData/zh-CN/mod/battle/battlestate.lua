ys = ys or {}
ys or .Battle = ys.Battle or {}
pg.bfConsts = {
	DFT_CRIT_EFFECT = 1.5,
	DFT_CRIT_RATE = 0.05,
	SECONDs = 60,
	PERCENT = 0.01,
	PERCENT1 = 0.001,
	PERCENT2 = 0.0001,
	HUNDRED = 100,
	SCORE_RATE = {
		0.7,
		0.8,
		0.3
	},
	CRASH_RATE = {
		0.05,
		0.025
	},
	SUBMARINE_KAMIKAZE = {
		80,
		3.5,
		1.5,
		1,
		0.5,
		0.5,
		1,
		0.005
	},
	LEAK_RATE = {
		10,
		2.2,
		0.7,
		0.3,
		1,
		0.005,
		0.5
	},
	PLANE_LEAK_RATE = {
		1,
		1,
		0.01,
		0.5,
		0.7,
		0.3,
		1,
		0.005,
		150,
		150,
		1,
		1
	},
	METEO_RATE = {
		0.05,
		20,
		0.6,
		0.4
	},
	NUM1 = 1,
	NUM0 = 0,
	NUM10000 = 10000,
	ACCURACY = {
		0.1,
		2
	},
	DRATE = {
		25,
		0.02,
		0.0002,
		2000,
		0.1,
		0.8,
		150
	},
	SPEED_CONST = 0.02,
	HP_CONST = 1.5
}
slot2 = singletonClass("BattleState", ys or .MVC.Facade)
ys or .Battle.BattleState = slot2
slot2.__name = "BattleState"
slot2.BATTLE_STATE_IDLE = "BATTLE_IDLE"
slot2.BATTLE_STATE_OPENING = "BATTLE_OPENING"
slot2.BATTLE_STATE_FIGHT = "BATTLE_FIGHT"
slot2.BATTLE_STATE_REPORT = "BATTLE_REPORT"

slot2.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
	slot0:ChangeState(slot0.BATTLE_STATE_IDLE)
end

slot2.IsAutoBotActive = function (slot0)
	return PlayerPrefs.GetInt("autoBotIsAcitve" .. slot1, 0) == 1 and AutoBotCommand.autoBotSatisfied()
end

slot2.IsAutoSubActive = function (slot0)
	return PlayerPrefs.GetInt("autoSubIsAcitve" .. slot1, 0) == 1
end

slot2.ChatUseable = function (slot0)
	return (not PlayerPrefs.GetInt(HIDE_CHAT_FLAG) or slot1 ~= 1) and (slot0:GetBattleType() == SYSTEM_DUEL or slot0.IsAutoBotActive(slot3))
end

slot2.GetState = function (slot0)
	return slot0._state
end

slot2.GetBattleType = function (slot0)
	return slot0._battleType
end

slot2.SetBattleUI = function (slot0, slot1)
	slot0._baseUI = slot1
end

slot2.EnterBattle = function (slot0, slot1, slot2)
	pg.TimeMgr.GetInstance():ResetCombatTime()
	slot0:Active()
	slot0:ResetTimer()

	slot0._dataProxy = slot0:AddDataProxy(slot0.Battle.BattleDataProxy.GetInstance())
	slot0._uiMediator = slot0:AddMediator(slot0.Battle.BattleUIMediator.New())

	if slot1.battleType == SYSTEM_DUEL then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleDuelArenaCommand.New())

		slot0._battleCommand:ConfigBattleData(slot1)
	elseif slot1.battleType == SYSTEM_CHALLENGE then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleSingleChallengeCommand.New())

		slot0._battleCommand:ConfigBattleData(slot1)
	elseif slot1.battleType == SYSTEM_DODGEM then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleDodgemCommand.New())
	elseif slot1.battleType == SYSTEM_SUBMARINE_RUN then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleSubmarineRunCommand.New())
	elseif slot1.battleType == SYSTEM_SUB_ROUTINE then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleSubRoutineCommand.New())
	elseif slot1.battleType == SYSTEM_HP_SHARE_ACT_BOSS or slot1.battleType == SYSTEM_BOSS_EXPERIMENT then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleInheritDungeonCommand.New())
	elseif slot1.battleType == SYSTEM_WORLD_BOSS then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleWorldBossCommand.New())
	elseif slot1.battleType == SYSTEM_DEBUG then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleDebugCommand.New())
	elseif slot1.battleType == SYSTEM_AIRFIGHT then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleAirFightCommand.New())
	elseif slot1.battleType == SYSTEM_GUILD then
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleGuildBossCommand.New())
	else
		slot0._battleCommand = slot0:AddCommand(slot0.Battle.BattleSingleDungeonCommand.New())
	end

	slot0._battleType = slot1.battleType
	slot0._sceneMediator = slot0:AddMediator(slot0.Battle.BattleSceneMediator.New())
	slot0._weaponCommand = slot0:AddCommand(slot0.Battle.BattleControllerWeaponCommand.New())

	slot0._dataProxy:InitBattle(slot1)

	if BATTLE_DEFAULT_UNIT_DETAIL then
		slot0:AddMediator(slot0.Battle.BattleReferenceBoxMediator.New())
		slot0:GetMediatorByName(slot0.Battle.BattleReferenceBoxMediator.__name):ActiveUnitDetail(true)
	end

	if slot2 then
	else
		slot0:ChangeState(slot1.BATTLE_STATE_OPENING)
		UpdateBeat:Add(slot0.Update, slot0)
	end

	if PLATFORM_CODE ~= PLATFORM_CH then
		GCThread.GetInstance():StartWatch(110)
	end
end

slot2.GetSceneMediator = function (slot0)
	return slot0._sceneMediator
end

slot2.GetUIMediator = function (slot0)
	return slot0._uiMediator
end

slot2.ActiveBot = function (slot0, slot1)
	slot0._weaponCommand:ActiveBot(slot1, true)
	slot0._uiMediator:EnableJoystick(not slot1)
end

slot2.IsBotActive = function (slot0)
	return slot0._weaponCommand:GetWeaponBot():IsActive()
end

slot2.Update = function (slot0)
	if not slot0._isPause then
		for slot4, slot5 in pairs(slot0._mediatorList) do
			slot5:Update()
		end
	else
		for slot4, slot5 in pairs(slot0._mediatorList) do
			slot5:UpdatePause()
		end
	end
end

slot2.GenerateVertifyData = function (slot0)
	return
end

slot2.Vertify = function ()
	return true, -1
end

slot2.ChangeState = function (slot0, slot1)
	slot0._state = slot1

	if slot1 == slot0.BATTLE_STATE_OPENING then
		slot0._dataProxy:Start()

		if slot0._dataProxy._dungeonInfo.beginStoy then
			pg.NewStoryMgr.GetInstance():Play(slot2, function ()
				slot0._battleCommand:DoPrologue()
			end)
		else
			slot0._battleCommand.DoPrologue(slot3)
		end
	elseif slot1 == slot0.BATTLE_STATE_FIGHT then
		slot0:ActiveAutoComponentTimer()
	elseif slot1 == slot0.BATTLE_STATE_REPORT then
	end
end

slot2.GetUI = function (slot0)
	return slot0._baseUI
end

slot2.ConfigBattleEndFunc = function (slot0, slot1)
	slot0._endFunc = slot1
end

slot2.BattleEnd = function (slot0)
	slot0:disableCommon()

	if slot0.Battle.BattleConst.BattleScore.B <= slot0._dataProxy:GetStatistics()._battleScore then
		slot0._dataProxy:CelebrateVictory(slot0._dataProxy:GetFriendlyCode())
		slot0:reportDelayTimer(function ()
			slot0:DoResult()
		end, slot0.Battle.BattleConfig.CelebrateDuration)
	else
		slot0.DoResult(slot0)
	end
end

slot2.BattleTimeUp = function (slot0)
	slot0:disableCommon()
	slot0:ActiveEscape()
	slot0:reportDelayTimer(function ()
		slot0:DeactiveEscape()
		slot0.DeactiveEscape:DoResult()
	end, slot0.Battle.BattleConfig.EscapeDuration)
end

slot2.DoResult = function (slot0)
	slot0._sceneMediator:PauseCharacterAction(true)
	slot0._dataProxy:BotPercentage(slot0._weaponCommand:GetBotActiveDuration())
	slot0._dataProxy:HPRatioStatistics()
	slot0._endFunc(slot0._dataProxy:GetStatistics())
end

slot2.ExitBattle = function (slot0)
	slot0.Battle.BattleCameraUtil.GetInstance():Clear()

	for slot4, slot5 in pairs(slot0._mediatorList) do
		slot0:RemoveMediator(slot5)
	end

	for slot4, slot5 in pairs(slot0._commandList) do
		slot0:RemoveCommand(slot5)
	end

	for slot4, slot5 in pairs(slot0._proxyList) do
		slot0:RemoveProxy(slot5)
	end

	slot0.Battle.BattleConfig.BASIC_TIME_SCALE = 1

	slot0:RemoveAllTimer()
	slot0.Battle.BattleResourceManager.GetInstance():Clear()

	slot0._takeoverProcess = nil

	slot0:ChangeState(slot1.BATTLE_STATE_IDLE)

	slot0._baseUI = nil
	slot0._endFunc = nil
	slot0._uiMediator = nil
	slot0._sceneMediator = nil
	slot0._battleCommand = nil
	slot0._weaponCommand = nil

	removeSingletonInstance(slot0.Battle.BattleDataProxy)

	slot0._dataProxy = nil

	slot0.Battle.BattleVariable.Clear()
	slot0.Battle.BattleBulletFactory.DestroyFactory()
	UpdateBeat:Remove(slot0.Update, slot0)
	pg.EffectMgr.GetInstance():ClearBattleEffectMap()

	if PLATFORM_CODE ~= PLATFORM_CH then
		GCThread.GetInstance():StopWatch()
	end

	slot0._timeScale = nil
	slot0._timescalerCache = nil
end

slot2.Stop = function (slot0, slot1)
	slot0:disableCommon()
	slot0._baseUI:exitBattle(slot1)
end

slot2.disableCommon = function (slot0)
	slot0._weaponCommand:ActiveBot(false)
	slot0:ScaleTimer()
	slot0.Battle.BattleCameraUtil.GetInstance():ResetFocus()
	slot0:ChangeState(slot1.BATTLE_STATE_REPORT)
	slot0._dataProxy:ClearAirFighterTimer()
	slot0._dataProxy:KillAllAircraft()
	slot0._sceneMediator:AllBulletNeutralize()
	slot0._sceneMediator:AllCharAnimAutoCalcComplex(false)
	slot0.Battle.BattleCameraUtil.GetInstance():StopShake()
	slot0.Battle.BattleCameraUtil.GetInstance():Deactive()
	slot0._uiMediator:DisableComponent()
	slot0:Deactive()
end

slot2.reportDelayTimer = function (slot0, slot1, slot2)
	slot3 = nil

	slot0.RemoveAllTimer(slot0)
	pg.TimeMgr.GetInstance():ResumeBattleTimer()

	slot3 = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, slot2, function ()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(pg.TimeMgr.GetInstance().RemoveBattleTimer)

		slot0 = nil

		pg.TimeMgr.GetInstance()()
	end)
end

slot2.SetTakeoverProcess = function (slot0, slot1)
	slot0._takeoverProcess = slot1

	slot0:_pause()
end

slot2.ClearTakeoverProcess = function (slot0)
	slot0._takeoverProcess = nil

	slot0:_resume()
end

slot2.IsPause = function (slot0)
	return slot0._isPause
end

slot2.Pause = function (slot0)
	if slot0._takeoverProcess then
		slot1.Pause()
	else
		slot0:_pause()
	end
end

slot2._pause = function (slot0)
	slot0:Deactive()
	slot0._sceneMediator:Pause()

	if slot0._timeScale ~= 1 then
		slot0:CacheTimescaler(slot0._timeScale)
		slot0:ScaleTimer(1)
	end

	slot0.Battle.BattleCameraUtil.GetInstance():PauseCameraTween()
end

slot2.Resume = function (slot0)
	if slot0._state == slot0.BATTLE_STATE_IDLE then
		slot0:ChangeState(slot0.BATTLE_STATE_OPENING)
		UpdateBeat:Add(slot0.Update, slot0)
	elseif slot0._state == slot0.BATTLE_STATE_REPORT then
		return
	end

	if slot0._takeoverProcess then
		slot1.Resume()
	else
		slot0:_resume()
	end
end

slot2._resume = function (slot0)
	slot0._sceneMediator:Resume()
	slot0:Active()

	if slot0._timescalerCache then
		slot0:ScaleTimer(slot0._timescalerCache)
		slot0:CacheTimescaler()
	end

	slot0.Battle.BattleCameraUtil.GetInstance():ResumeCameraTween()
end

slot2.ScaleTimer = function (slot0, slot1)
	pg.TimeMgr.GetInstance():ScaleBattleTimer(slot1 or slot0.Battle.BattleConfig.BASIC_TIME_SCALE)

	slot0._timeScale = slot1 or slot0.Battle.BattleConfig.BASIC_TIME_SCALE
end

slot2.GetTimeScaleRate = function (slot0)
	return slot0._timeScale or 1
end

slot2.CacheTimescaler = function (slot0, slot1)
	slot0._timescalerCache = slot1
end

ys or .Battle.PlayBattleSFX = function (slot0)
	if slot0 ~= "" then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/" .. slot0)
	end
end

slot2.OpenConsole = function (slot0)
	slot0._uiMediator:InitDebugConsole()
	slot0._uiMediator:ActiveDebugConsole()
end

slot2.ActiveReference = function (slot0)
	slot0._controllerCommand = slot0:AddCommand(slot0.Battle.BattleControllerCommand.New())
end

return

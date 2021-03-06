ys = ys or {}
slot1 = ys.Battle.BattleEvent
slot2 = ys.Battle.BattleUnitEvent
slot3 = ys.Battle.BattleConst
slot4 = ys.Battle.BattleVariable
slot5 = ys.Battle.BattleConfig
slot6 = class("BattleUIMediator", ys.MVC.Mediator)
ys.Battle.BattleUIMediator = slot6
slot6.__name = "BattleUIMediator"

slot6.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot6.SetBattleUI = function (slot0)
	slot0._ui = slot0._state:GetUI()
end

slot6.Initialize = function (slot0)
	slot0.super.Initialize(slot0)

	slot0._dataProxy = slot0._state:GetProxyByName(slot1.Battle.BattleDataProxy.__name)
	slot0._uiMGR = pg.UIMgr.GetInstance()
	slot0._fxPool = pg.UIMgr.GetInstance().Battle.BattleFXPool.GetInstance()
	slot0._updateViewList = {}

	slot0:SetBattleUI()
	slot0:AddUIEvent()
	slot0:InitCamera()
	slot0:InitGuide()
end

slot6.Reinitialize = function (slot0)
	slot0._skillView:Dispose()
end

slot6.EnableComponent = function (slot0, slot1)
	slot0._ui:findTF("PauseBtn"):GetComponent(typeof(Button)).enabled = slot1

	slot0._skillView:EnableWeaponButton(slot1)
end

slot6.EnableJoystick = function (slot0, slot1)
	slot0._stickController.enabled = slot1

	setActive(slot0._joystick, slot1)
end

slot6.EnableWeaponButton = function (slot0, slot1)
	slot0._skillView:EnableWeaponButton(slot1)
end

slot6.EnableSkillFloat = function (slot0, slot1)
	slot0._ui:EnableSkillFloat(slot1)
end

slot6.GetAppearFX = function (slot0)
	return slot0._appearEffect
end

slot6.DisableComponent = function (slot0)
	slot0._ui:findTF("PauseBtn"):GetComponent(typeof(Button)).enabled = false

	slot0._skillView:DisableWeapnButton()
	SetActive(slot0._ui:findTF("HPBarContainer"), false)
	SetActive(slot0._ui:findTF("flagShipMark"), false)

	if slot0._jammingView then
		slot0._jammingView:Eliminate(false)
	end

	if slot0._inkView then
		slot0._inkView:SetActive(false)
	end
end

slot6.ActiveDebugConsole = function (slot0)
	slot0._debugConsoleView:SetActive(true)
end

slot6.OpeningEffect = function (slot0, slot1, slot2)
	slot0._uiMGR:SetActive(false)

	if slot2 == SYSTEM_SUBMARINE_RUN then
		slot0._skillView:SubmarineButton()

		slot0._joystick.anchorMin = Vector2(slot0.JOY_STICK_DEFAULT_PREFERENCE.x, slot0.JOY_STICK_DEFAULT_PREFERENCE.y)
		slot0._joystick.anchorMax = Vector2(slot0.JOY_STICK_DEFAULT_PREFERENCE.x, slot0.JOY_STICK_DEFAULT_PREFERENCE.y)
	elseif slot2 == SYSTEM_SUB_ROUTINE then
		slot0._skillView:SubRoutineButton()
	elseif slot2 == SYSTEM_AIRFIGHT then
		slot0._skillView:AirFightButton()
	elseif slot2 == SYSTEM_DEBUG then
		slot0._skillView:NormalButton()
	elseif pg.SeriesGuideMgr.GetInstance().currIndex and slot3:isEnd() then
		slot0._skillView:NormalButton()
	else
		slot0._skillView:CustomButton(slot0._dataProxy:GetDungeonData().skill_hide or {})
	end

	slot0._ui._go:GetComponent("DftAniEvent").SetEndEvent(slot3, function (slot0)
		slot0._uiMGR:SetActive(true)
		slot0:EnableComponent(true)

		if slot0.EnableComponent then
			slot1()
		end
	end)
	SetActive(slot0._ui._go, true)
end

slot6.InitScene = function (slot0)
	slot0._mapId = slot0._dataProxy._mapId
	slot0._seaView = slot0.Battle.BattleMap.New(slot0._mapId)
end

slot6.InitJoystick = function (slot0)
	slot0._joystick = slot0._ui:findTF("Stick")
	slot1 = slot0.JOY_STICK_DEFAULT_PREFERENCE
	slot2 = slot0._joystick

	if Screen.dpi / CameraUtil.finalWidth * 5 <= 0 then
		slot3 = 1
	end

	slot0._joystick.localScale = Vector3(slot3, slot3, 1)
	slot2.anchoredPosition = slot2.anchoredPosition * slot3 * PlayerPrefs.GetFloat("joystick_scale", slot1.scale)
	slot0._joystick.anchorMin = Vector2(slot5, slot6)
	slot0._joystick.anchorMax = Vector2(slot5, PlayerPrefs.GetFloat("joystick_anchorY", slot1.y))
	slot0._stickController = slot0._joystick:GetComponent("StickController")

	slot0._uiMGR:AttachStickOb(slot0._joystick)
end

slot6.InitTimer = function (slot0)
	if slot0._dataProxy:GetInitData().battleType == SYSTEM_DUEL then
		slot0._timerView = slot0.Battle.BattleTimerView.New(slot0._ui:findTF("DuelTimer"))
	else
		slot0._timerView = slot0.Battle.BattleTimerView.New(slot0._ui:findTF("Timer"))
	end
end

slot6.InitEnemyHpBar = function (slot0)
	slot0._enemyHpBar = slot0.Battle.BattleEnmeyHpBarView.New(slot0._ui:findTF("EnemyHPBar"))
end

slot6.InitAirStrikeIcon = function (slot0)
	slot0._airStrikeView = slot0.Battle.BattleAirStrikeIconView.New(slot0._ui:findTF("AirFighterContainer/AirStrikeIcon"))
end

slot6.InitCommonWarning = function (slot0)
	slot0._warningView = slot0.Battle.BattleCommonWarningView.New(slot0._ui:findTF("WarningView"))
end

slot6.InitScoreBar = function (slot0)
	slot0._scoreBarView = slot0.Battle.BattleScoreBarView.New(slot0._ui:findTF("DodgemCountBar"))
end

slot6.InitAirFightScoreBar = function (slot0)
	slot0._scoreBarView = slot0.Battle.BattleScoreBarView.New(slot0._ui:findTF("AirFightCountBar"))
end

slot6.InitAutoBtn = function (slot0)
	slot0._autoBtn = slot0._ui:findTF("AutoBtn")
	slot0._autoBtn.localScale = Vector3(slot2, slot2, 1)
	slot0._autoBtn.anchorMin = Vector2(slot3, slot4)
	slot0._autoBtn.anchorMax = Vector2(PlayerPrefs.GetFloat("auto_anchorX", slot0.AUTO_DEFAULT_PREFERENCE.x), PlayerPrefs.GetFloat("auto_anchorY", slot0.AUTO_DEFAULT_PREFERENCE.y))
end

slot6.InitDuelRateBar = function (slot0)
	slot0._duelRateBar = slot0.Battle.BattleDuelDamageRateView.New(slot0._ui:findTF("DuelDamageRate"))

	return slot0._duelRateBar
end

slot6.InitSimulationBuffCounting = function (slot0)
	slot0._simulationBuffCountView = slot0.Battle.BattleSimulationBuffCountView.New(slot0._ui:findTF("SimulationWarning"))

	return slot0._simulationBuffCountView
end

slot6.InitMainDamagedView = function (slot0)
	slot0._mainDamagedView = slot0.Battle.BattleMainDamagedView.New(slot0._ui:findTF("HPWarning"))
end

slot6.InitInkView = function (slot0, slot1)
	slot0._inkView = slot0.Battle.BattleInkView.New(slot0._ui:findTF("InkContainer"))

	slot1:RegisterEventListener(slot0, slot1.FLEET_HORIZON_UPDATE, slot0.onFleetHorizonUpdate)
end

slot6.InitDebugConsole = function (slot0)
	slot0._debugConsoleView = slot0._debugConsoleView or slot0.Battle.BattleDebugConsole.New(slot0._ui:findTF("Debug_Console"), slot0._state)
end

slot6.InitCameraGestureSlider = function (slot0)
	slot0._gesture = slot0.Battle.BattleCameraSlider.New(slot0._ui:findTF("CameraController"))

	slot0.Battle.BattleCameraUtil.GetInstance():SetCameraSilder(slot0._gesture)
	slot0._cameraUtil:SwitchCameraPos("FOLLOW_GESTURE")
end

slot6.InitGuide = function (slot0)
	return
end

slot6.InitCamera = function (slot0)
	slot0._camera = pg.UIMgr.GetInstance():GetMainCamera():GetComponent(typeof(Camera))
	slot0._uiCamera = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	slot0._cameraUtil = slot0.Battle.BattleCameraUtil.GetInstance()

	slot0._cameraUtil:RegisterEventListener(slot0, slot1.CAMERA_FOCUS, slot0.onCameraFocus)
	slot0._cameraUtil:RegisterEventListener(slot0, slot1.SHOW_PAINTING, slot0.onShowPainting)
	slot0._cameraUtil:RegisterEventListener(slot0, slot1.BULLET_TIME, slot0.onBulletTime)
end

slot6.Update = function (slot0)
	for slot4, slot5 in pairs(slot0._updateViewList) do
		slot4:Update()
	end
end

slot6.AddUIEvent = function (slot0)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.STAGE_DATA_INIT_FINISH, slot0.onStageInit)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.COMMON_DATA_INIT_FINISH, slot0.onCommonInit)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.ADD_FLEET, slot0.onAddFleet)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.ADD_UNIT, slot0.onAddUnit)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.REMOVE_UNIT, slot0.onRemoveUnit)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.HIT_ENEMY, slot0.onEnemyHit)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.CAST_SKILL, slot0.onCastSkill)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.ADD_AIR_FIGHTER_ICON, slot0.onAddAirStrike)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.REMOVE_AIR_FIGHTER_ICON, slot0.onRemoveAirStrike)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_HOSTILE_SUBMARINE, slot0.onUpdateHostileSubmarine)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_ENVIRONMENT_WARNING, slot0.onUpdateEnvironmentWarning)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_COUNT_DOWN, slot0.onUpdateCountDown)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.ADD_UI_FX, slot0.OnAddUIFX)
end

slot6.RemoveUIEvent = function (slot0)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.COMMON_DATA_INIT_FINISH)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.STAGE_DATA_INIT_FINISH)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.ADD_FLEET)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.ADD_UNIT)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.REMOVE_UNIT)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.HIT_ENEMY)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.CAST_SKILL)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.UPDATE_COUNT_DOWN)
	slot0._cameraUtil:UnregisterEventListener(slot0, slot0.SHOW_PAINTING)
	slot0._cameraUtil:UnregisterEventListener(slot0, slot0.CAMERA_FOCUS)
	slot0._cameraUtil:UnregisterEventListener(slot0, slot0.BULLET_TIME)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.ADD_SUBMARINE_WARINING)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.REMOVE_SUBMARINE_WARINING)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.UPDATE_DODGEM_SCORE)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.UPDATE_DODGEM_COMBO)
	slot0._userFleet:UnregisterEventListener(slot0, slot0.SHOW_BUFFER)
	slot0._userFleet:UnregisterEventListener(slot0, slot1.POINT_HIT_CHARGE)
	slot0._userFleet:UnregisterEventListener(slot0, slot1.POINT_HIT_CANCEL)
	slot0._userFleet:UnregisterEventListener(slot0, slot0.MANUAL_SUBMARINE_SHIFT)
	slot0._userFleet:UnregisterEventListener(slot0, slot0.FLEET_BLIND)
	slot0._userFleet:UnregisterEventListener(slot0, slot0.FLEET_HORIZON_UPDATE)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.UPDATE_HOSTILE_SUBMARINE)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.UPDATE_ENVIRONMENT_WARNING)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.ADD_UI_FX)
end

slot6.ShowSkillPainting = function (slot0, slot1, slot2, slot3)
	slot0._ui:painting(slot1:GetTemplate(), slot3 or 1, slot1:GetIFF())
end

slot6.ShowSkillFloat = function (slot0, slot1, slot2, slot3)
	slot0._ui:appendSkill(slot2, slot1, slot3)
end

slot6.ShowSkillFloatCover = function (slot0, slot1, slot2, slot3)
	slot0._ui:appendSkillCover(slot2, slot1, slot3)
end

slot6.SeaSurfaceShift = function (slot0, slot1, slot2, slot3, slot4)
	slot0._seaView:ShiftSurface(slot1, slot2, slot3 or slot0.Battle.BattleConfig.calcInterval, slot4)
end

slot6.ShowAutoBtn = function (slot0)
	SetActive(slot0._autoBtn.transform, true)
	triggerToggle(slot0._autoBtn, slot0.Battle.BattleState.IsAutoBotActive(slot0:GetState():GetBattleType()))
end

slot6.ShowTimer = function (slot0)
	slot0._timerView:SetActive(true)
end

slot6.ShowDuelBar = function (slot0)
	slot0._duelRateBar:SetActive(true)
end

slot6.ShowSimulationView = function (slot0)
	slot0._simulationBuffCountView:SetActive(true)
end

slot6.ShowPauseButton = function (slot0, slot1)
	setActive(slot0._ui:findTF("PauseBtn"), slot1)
end

slot6.ShowDodgemScoreBar = function (slot0)
	slot0:InitScoreBar()
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_DODGEM_SCORE, slot0.onUpdateDodgemScore)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_DODGEM_COMBO, slot0.onUpdateDodgemCombo)
	slot0._scoreBarView:UpdateScore(0)
	slot0._scoreBarView:SetActive(true)
end

slot6.ShowAirFightScoreBar = function (slot0)
	slot0:InitAirFightScoreBar()
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_DODGEM_SCORE, slot0.onUpdateDodgemScore)
	slot0._dataProxy:RegisterEventListener(slot0, slot0.UPDATE_DODGEM_COMBO, slot0.onUpdateDodgemCombo)
	slot0._scoreBarView:UpdateScore(0)
	slot0._scoreBarView:SetActive(true)
end

slot6.onStageInit = function (slot0, slot1)
	slot0:InitJoystick()
	slot0:InitScene()
	slot0:InitTimer()
	slot0:InitEnemyHpBar()
	slot0:InitAirStrikeIcon()
	slot0:InitCommonWarning()
	slot0:InitAutoBtn()
	slot0:InitMainDamagedView()
end

slot6.onEnemyHit = function (slot0, slot1)
	if slot1.Data:GetDiveInvisible() and not slot2:GetDiveDetected() then
		return
	end

	if slot0._enemyHpBar:GetCurrentTarget() then
		if slot3 ~= slot2 then
			slot0._enemyHpBar:SwitchTarget(slot2, slot0._dataProxy:GetUnitList())
		end
	else
		slot0._enemyHpBar:SwitchTarget(slot2, slot0._dataProxy:GetUnitList())
	end
end

slot6.onEnemyHpUpdate = function (slot0, slot1)
	if slot1.Dispatcher == slot0._enemyHpBar:GetCurrentTarget() and (not slot2:GetDiveInvisible() or slot2:GetDiveDetected()) then
		slot0._enemyHpBar:UpdateHpBar()
	end
end

slot6.onPlayerMainUnitHpUpdate = function (slot0, slot1)
	if slot1.Data.dHP < 0 then
		slot0._mainDamagedView:Play()
	end
end

slot6.onCastSkill = function (slot0, slot1)
	slot4 = slot1.Data.caster

	if slot0.Battle.BattleDataFunction.GetSkillTemplate(slot3).uiEffect ~= "" then
		pg.EffectMgr.GetInstance():BattleUIEffect(slot6, function (slot0)
			slot0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function (slot0)
				Destroy(slot0)
			end)
		end)
	end
end

slot6.onCommonInit = function (slot0, slot1)
	slot0._skillView = slot0.Battle.BattleSkillView.New(slot0, slot1.Data)
	slot0._updateViewList[slot0._skillView] = true
	slot0._userFleet = slot0._dataProxy:GetFleetByIFF(slot1.FRIENDLY_CODE)

	slot0._userFleet:RegisterEventListener(slot0, slot2.SHOW_BUFFER, slot0.onShowBuffer)
	slot0._userFleet:RegisterEventListener(slot0, slot3.POINT_HIT_CHARGE, slot0.onPointHitSight)
	slot0._userFleet:RegisterEventListener(slot0, slot3.POINT_HIT_CANCEL, slot0.onPointHitSight)
	slot0._userFleet:RegisterEventListener(slot0, slot2.MANUAL_SUBMARINE_SHIFT, slot0.onManualSubShift)
	slot0._userFleet:RegisterEventListener(slot0, slot2.FLEET_BLIND, slot0.onFleetBlind)

	slot0._sightView = slot0.Battle.BattleOpticalSightView.New(slot0._ui:findTF("ChargeAreaContainer"))

	slot0._sightView:SetFleetVO(slot0._userFleet)

	slot2, slot3, slot8, slot9 = slot0._dataProxy:GetTotalBounds()

	slot0._sightView:SetAreaBound(slot4, slot5)
end

slot6.onAddFleet = function (slot0, slot1)
	slot2 = slot1.Data.fleetVO

	if PlayerPrefs.GetInt(BATTLE_EXPOSE_LINE, 1) == 1 then
		slot0:SetFleetCloakLine(slot2)
	end
end

slot6.SetFleetCloakLine = function (slot0, slot1)
	if #slot1:GetCloakList() > 0 then
		slot0._seaView:SetExposeLine(slot1:GetIFF(), slot1:GetFleetVisionLine(), slot1:GetFleetExposeLine())
	end
end

slot6.onAddUnit = function (slot0, slot1)
	slot2 = slot1.Data.type

	if slot1.Data.unit:IsBoss() and slot0._dataProxy:GetActiveBossCount() == 1 then
		slot0:AddBossWarningUI()
	elseif slot2 == slot0.UnitType.ENEMY_UNIT then
		slot0:registerUnitEvent(slot3)
	elseif slot2 == slot0.UnitType.NPC_UNIT and slot3:GetIFF() == slot1.FOE_CODE then
		slot0:registerUnitEvent(slot3)
	elseif slot2 == slot0.UnitType.PLAYER_UNIT and slot3:IsMainFleetUnit() and slot3:GetIFF() == slot1.FRIENDLY_CODE then
		slot0:registerPlayerMainUnitEvent(slot3)
	end
end

slot6.onSubmarineDetected = function (slot0, slot1)
	slot2 = slot1.Dispatcher

	if slot0._enemyHpBar:GetCurrentTarget() and slot0._enemyHpBar:GetCurrentTarget() == slot2 and slot2:GetDiveDetected() == false then
		slot0._enemyHpBar:RemoveUnit()
	end
end

slot6.onRemoveUnit = function (slot0, slot1)
	slot2 = slot1.Data.unit

	if slot1.Data.type == slot0.UnitType.ENEMY_UNIT and not slot2:IsBoss() then
		slot0:unregisterUnitEvent(slot2)
	elseif slot2:GetIFF() == slot1.FRIENDLY_CODE and slot2:IsMainFleetUnit() then
		slot0:unregisterPlayerMainUnitEvent(slot2)
	end

	if slot1.Data.deadReason == slot0.UnitDeathReason.LEAVE and slot0._enemyHpBar:GetCurrentTarget() and slot0._enemyHpBar:GetCurrentTarget() == slot1.Data.unit then
		slot0._enemyHpBar:RemoveUnit(slot1.Data.deadReason)
	end
end

slot6.onUpdateCountDown = function (slot0, slot1)
	slot0._timerView:SetCountDownText(slot0._dataProxy:GetCountDown())
end

slot6.onUpdateDodgemScore = function (slot0, slot1)
	slot0._scoreBarView:UpdateScore(slot1.Data.totalScore)
end

slot6.onUpdateDodgemCombo = function (slot0, slot1)
	slot0._scoreBarView:UpdateCombo(slot1.Data.combo)
end

slot6.onAddAirStrike = function (slot0, slot1)
	slot0._airStrikeView:AppendIcon(slot1.Data.index, slot0._dataProxy:GetAirFighterInfo(slot2))
end

slot6.onRemoveAirStrike = function (slot0, slot1)
	slot0._airStrikeView:RemoveIcon(slot1.Data.index, slot0._dataProxy:GetAirFighterInfo(slot2))
end

slot6.onUpdateHostileSubmarine = function (slot0, slot1)
	slot0._warningView:UpdateHostileSubmarineCount(slot0._dataProxy:GetEnemySubmarineCount())
end

slot6.onUpdateEnvironmentWarning = function (slot0, slot1)
	if slot1.Data.isActive then
		slot0._warningView:ActiveWarning(slot0._warningView.WARNING_TYPE_ARTILLERY)
	else
		slot0._warningView:DeactiveWarning(slot0._warningView.WARNING_TYPE_ARTILLERY)
	end
end

slot6.onCameraFocus = function (slot0, slot1)
	if slot1.Data.unit ~= nil then
		slot0:EnableComponent(false)
		slot0:EnableSkillFloat(slot2.skill or false)
	else
		LeanTween.delayedCall(slot0._ui._go, slot2.duration + slot2.extraBulletTime, System.Action(function ()
			slot0:EnableComponent(true)
			slot0.EnableComponent:EnableSkillFloat(true)
		end))
	end
end

slot6.onShowPainting = function (slot0, slot1)
	slot0:ShowSkillPainting(slot1.Data.caster, slot1.Data.skill, slot1.Data.speed)
end

slot6.onBulletTime = function (slot0, slot1)
	slot3 = slot1.Data.key

	if slot1.Data.rate then
		slot0.AppendMapFactor(slot3, slot4)
	else
		slot0.RemoveMapFactor(slot3)
	end

	slot0._seaView:UpdateSpeedScaler()
end

slot6.onShowBuffer = function (slot0, slot1)
	slot0._seaView:UpdateBufferAlpha(slot1.Data.dist)
end

slot6.onManualSubShift = function (slot0, slot1)
	slot0._skillView:ShiftSubmarineManualButton(slot1.Data.state)
end

slot6.onPointHitSight = function (slot0, slot1)
	if slot1.ID == slot0.POINT_HIT_CHARGE then
		slot0._sightView:SetActive(true)

		slot0._updateViewList[slot0._sightView] = true
	elseif slot2 == slot0.POINT_HIT_CANCEL then
		slot0._sightView:SetActive(false)

		slot0._updateViewList[slot0._sightView] = nil
	end
end

slot6.onFleetBlind = function (slot0, slot1)
	slot2 = slot1.Data.isBlind
	slot3 = slot1.Dispatcher

	if not slot0._inkView then
		slot0:InitInkView(slot3)
	end

	if slot2 then
		slot0._inkView:SetActive(true, slot3:GetUnitList())
		slot0._skillView:HideSkillButton(true)

		slot0._updateViewList[slot0._inkView] = true
	else
		slot0._inkView:SetActive(false)
		slot0._skillView:HideSkillButton(false)

		slot0._updateViewList[slot0._inkView] = nil
	end
end

slot6.onFleetHorizonUpdate = function (slot0, slot1)
	if not slot0._inkView then
		return
	end

	slot0._inkView:UpdateHollow(slot1.Dispatcher.GetUnitList(slot2))
end

slot6.OnAddUIFX = function (slot0, slot1)
	slot0:AddUIFX(slot1.Data.orderDiff, slot1.Data.FXID, slot1.Data.position, slot1.Data.localScale)
end

slot6.AddUIFX = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot0._fxPool:GetFX(slot2)
	slot6 = (slot1 or 1) > 0
	slot7 = slot0._ui:AddUIFX(slot5, slot1 or 1)
	slot5.transform.localScale = Vector3((slot4 or 1) / slot7.x, (slot4 or 1) / slot7.y, (slot4 or 1) / slot7.z)

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot5, slot3, true)
end

slot6.AddBossWarningUI = function (slot0)
	slot0._dataProxy:BlockManualCast(true)

	slot0._appearEffect = slot0.Battle.BattleResourceManager.GetInstance().InstBossWarningUI(slot1)

	slot0._state.SetTakeoverProcess(slot4, slot3)

	slot0._appearEffect:GetComponent(typeof(Animator)).speed = 1 / slot0._state:GetTimeScaleRate()

	setParent(slot0._appearEffect, slot0._ui.uiCanvas, false)
	slot0._appearEffect:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot4, function (slot0)
		slot0._userFleet:CoupleEncourage()
		slot0._dataProxy:BlockManualCast(false)
		slot0._state:ClearTakeoverProcess()
		slot0._state.ClearTakeoverProcess:DestroyOb(slot0._appearEffect)

		slot0._appearEffect = nil
	end)
	SetActive(slot0._appearEffect, true)
end

slot6.registerUnitEvent = function (slot0, slot1)
	slot1:RegisterEventListener(slot0, slot0.UPDATE_HP, slot0.onEnemyHpUpdate)

	if table.contains(TeamType.SubShipType, slot1:GetTemplate().type) then
		slot1:RegisterEventListener(slot0, slot0.SUBMARINE_DETECTED, slot0.onSubmarineDetected)
	end
end

slot6.registerPlayerMainUnitEvent = function (slot0, slot1)
	slot1:RegisterEventListener(slot0, slot0.UPDATE_HP, slot0.onPlayerMainUnitHpUpdate)
end

slot6.unregisterUnitEvent = function (slot0, slot1)
	slot1:UnregisterEventListener(slot0, slot0.UPDATE_HP)

	if table.contains(TeamType.SubShipType, slot1:GetTemplate().type) then
		slot1:UnregisterEventListener(slot0, slot0.SUBMARINE_DETECTED)
	end
end

slot6.unregisterPlayerMainUnitEvent = function (slot0, slot1)
	slot1:UnregisterEventListener(slot0, slot0.UPDATE_HP)
end

slot6.Dispose = function (slot0)
	LeanTween.cancel(slot0._ui._go)
	slot0._uiMGR:ClearStick()

	slot0._uiMGR = nil

	if slot0._appearEffect then
		Destroy(slot0._appearEffect)
	end

	slot0:RemoveUIEvent()
	slot0._timerView:Dispose()
	slot0._enemyHpBar:Dispose()
	slot0._skillView:Dispose()
	slot0._seaView:Dispose()
	slot0._airStrikeView:Dispose()
	slot0._sightView:Dispose()
	slot0._mainDamagedView:Dispose()
	slot0._warningView:Dispose()

	slot0._seaView = nil
	slot0._enemyHpBar = nil
	slot0._skillView = nil
	slot0._timerView = nil
	slot0._joystick = nil
	slot0._airStrikeView = nil
	slot0._warningView = nil
	slot0._mainDamagedView = nil

	if slot0._duelRateBar then
		slot0._duelRateBar:Dispose()

		slot0._duelRateBar = nil
	end

	if slot0._simulationBuffCountView then
		slot0._simulationBuffCountView:Dispose()

		slot0._simulationBuffCountView = nil
	end

	if slot0._jammingView then
		slot0._jammingView:Dispose()

		slot0._jammingView = nil
	end

	if slot0._inkView then
		slot0._inkView:Dispose()

		slot0._inkView = nil
	end

	slot0.super.Dispose(slot0)
end

return

slot0 = class("WorldScene", import("..base.BaseUI"))
slot0.SceneOp = "WorldScene.SceneOp"
slot0.Listeners = {
	onAchievementAchieved = "OnAchievementAchieved",
	onUpdateEventTips = "OnUpdateEventTips",
	onSelectFleet = "OnSelectFleet",
	onUpdateSubmarineSupport = "OnUpdateSubmarineSupport",
	onClearMoveQueue = "ClearMoveQueue",
	onModelSelectMap = "OnModelSelectMap",
	onUpdateRound = "OnUpdateRound",
	onUpdateProgress = "OnUpdateProgress",
	onUpdateScale = "OnUpdateScale",
	onDisposeMap = "OnDisposeMap",
	onFleetSelected = "OnFleetSelected"
}
slot0.optionsPath = {
	"top/adapt/top_chapter/option",
	"top/adapt/top_stage/option"
}

slot0.getUIName = function (slot0)
	return "WorldUI"
end

slot0.getBGM = function (slot0)
	slot1 = {}

	if slot0:GetInMap() == false then
	else
		table.insert(slot1, nowWorld:GetActiveMap():GetBGM() or "")
	end

	for slot5, slot6 in ipairs(slot1) do
		if slot6 ~= "" then
			return slot6
		end
	end

	return slot0.super.getBGM(slot0)
end

slot0.init = function (slot0)
	for slot4, slot5 in pairs(slot0.Listeners) do
		slot0[slot4] = function (...)
			slot0[slot1](slot2, ...)
		end
	end

	slot0.bind(slot0, slot0.SceneOp, function (slot0, ...)
		slot0:Op(...)
	end)

	slot0.camera = GameObject.Find("LevelCamera").transform.GetComponent(slot1, typeof(Camera))
	slot0.rtUIMain = GameObject.Find("LevelCamera").transform.Find(slot1, "Canvas/UIMain")

	setActive(slot0.rtUIMain, false)

	GetOrAddComponent(slot0.rtUIMain, typeof(Image)).color = Color.New(0, 0, 0, 0.5)
	slot0.rtGrid = slot0.rtUIMain:Find("LevelGrid")

	setActive(slot0.rtGrid, true)

	slot0.rtDragLayer = slot0.rtGrid:Find("DragLayer")

	setImageAlpha(slot0.rtDragLayer, 0)

	slot0.rtEnvBG = slot0:findTF("main/bg")
	slot0.rtTop = slot0:findTF("top")
	slot0.rtTopAtlas = slot0.rtTop:Find("adapt/top_chapter")

	setActive(slot0.rtTopAtlas, false)

	slot0.rtRightAtlas = slot0.rtTop:Find("adapt/right_chapter")

	setActive(slot0.rtRightAtlas, false)

	slot0.rtBottomAtlas = slot0.rtTop:Find("adapt/bottom_chapter")

	setActive(slot0.rtBottomAtlas, false)

	slot0.rtTransportAtlas = slot0.rtTop:Find("transport_chapter")

	setActive(slot0.rtTransportAtlas, false)

	slot0.rtTopMap = slot0.rtTop:Find("adapt/top_stage")

	setActive(slot0.rtTopMap, false)

	slot0.rtLeftMap = slot0.rtTop:Find("adapt/left_stage")

	setActive(slot0.rtLeftMap, false)

	slot0.rtRightMap = slot0.rtTop:Find("adapt/right_stage")

	setActive(slot0.rtRightMap, false)

	slot0.rtOutMap = slot0.rtTop:Find("effect_stage")

	setActive(slot0.rtOutMap, false)

	slot0.rtClickStop = slot0.rtTop:Find("stop_click")

	onButton(slot0, slot0.rtClickStop:Find("long_move"), function ()
		if #slot0.moveQueue > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_fleet_stop"))
			pg.TipsMgr.GetInstance().ShowTips:ClearMoveQueue()
		end
	end)
	onButton(slot0, slot0.rtClickStop:Find("auto_fight"), function ()
		if nowWorld.isAutoFight then
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_stop"))
			nowWorld:TriggerAutoFight(false)
		end
	end)
	setActive(slot0.rtClickStop, false)

	slot0.resAtlas = WorldResource.New()

	slot0.resAtlas.setParent(slot2, slot0.rtTopAtlas:Find("resources"), false)

	slot0.resMap = WorldResource.New()

	slot0.resMap:setParent(slot0.rtTopMap:Find("resources"), false)

	slot0.wsPool = WSPool.New()

	slot0.wsPool:Setup(slot0:findTF("resources"))

	slot0.wsAnim = WSAnim.New()

	slot0.wsAnim:Setup()

	slot0.wsTimer = WSTimer.New()

	slot0.wsTimer:Setup()

	slot0.wsDragProxy = WSDragProxy.New()
	slot0.wsDragProxy.transform = slot0.rtDragLayer
	slot0.wsDragProxy.wsTimer = slot0.wsTimer

	slot0.wsDragProxy:Setup({
		clickCall = function (slot0, slot1)
			if slot0.svScannerPanel:isShowing() then
				slot2, slot3 = slot0:CheckScannerEnable(slot0:ScreenPos2MapPos(slot1.position))

				if slot2 then
					slot0.svScannerPanel:ActionInvoke("DisplayWindow", slot2, slot3)
				else
					slot0.svScannerPanel:ActionInvoke("HideWindow")
				end
			else
				slot0:OnClickMap(slot0:ScreenPos2MapPos(slot1.position))
			end
		end,
		longPressCall = function ()
			slot0:OnLongPressMap(slot0:ScreenPos2MapPos(Vector3(Input.mousePosition.x, Input.mousePosition.y)))
		end
	})

	slot0.wsMapCamera = WSMapCamera.New()
	slot0.wsMapCamera.camera = slot0.camera

	slot0.wsMapCamera.Setup(slot2)
	slot0:InitSubView()
	slot0:AddWorldListener()

	slot0.moveQueue = {}
	slot0.achievedList = {}
	slot0.mapOps = {}
	slot0.wsCommands = {}

	WSCommand.Bind(slot0)
	slot0:OpOpen()
end

slot0.InitSubView = function (slot0)
	slot0.rtPanelList = slot0:findTF("panel_list")
	slot0.svOrderPanel = SVOrderPanel.New(slot0.rtPanelList, slot0.event, {
		wsPool = slot0.wsPool
	})
	slot0.svScannerPanel = SVScannerPanel.New(slot0.rtPanelList, slot0.event)

	slot0:bind(SVScannerPanel.ShowView, function (slot0)
		slot0.wsMap:ShowScannerMap(true)
		setActive(slot0.wsMap.rtTop, false)
		slot0:HideMapUI()
	end)
	slot0.bind(slot0, SVScannerPanel.HideView, function (slot0)
		slot0.wsMap:ShowScannerMap(false)
		setActive(slot0.wsMap.rtTop, true)
		slot0:DisplayMapUI()
	end)
	slot0.bind(slot0, SVScannerPanel.HideGoing, function (slot0, slot1, slot2)
		slot0.wsMap:ShowScannerMap(false)
		setActive(slot0.wsMap.rtTop, true)
		slot0:DisplayMapUI()
		slot0:OnClickCell(slot1, slot2)
	end)

	slot0.svRealmPanel = SVRealmPanel.New(slot0.rtPanelList, slot0.event)
	slot0.svAchievement = SVAchievement.New(slot0.rtPanelList, slot0.event)

	slot0.bind(slot0, SVAchievement.HideView, function (slot0)
		table.remove(slot0.achievedList, 1)

		slot1 = (#slot0.achievedList > 0 and function ()
			slot0:ShowSubView("Achievement", slot0.achievedList[1])
		end) or function ()
			slot0:Op("OpInteractive")
		end

		return slot1()
	end)

	slot0.svDebugPanel = SVDebugPanel.New(slot0.rtPanelList, slot0.event)
	slot0.svMarkOverall = SVMarkOverall.New(slot0.rtPanelList, slot0.event)

	slot0.bind(slot0, SVMarkOverall.ShowView, function (slot0, slot1, slot2)
		slot3 = {}

		_.each(slot1, function (slot0)
			slot0[slot0] = true
		end)

		if #slot1 > 0 then
			slot0.wsAtlasOverall.UpdateTargetEntrance(slot4, slot1[1])
		end

		slot0.wsAtlasOverall:UpdateStaticMark(slot3, slot2)
		slot0:DisplayAtlasOverall()
	end)
	slot0.bind(slot0, SVMarkOverall.HideView, function (slot0, slot1)
		slot0:HideAtlasOverall()

		return existCall(slot1)
	end)

	slot0.svFloatPanel = SVFloatPanel.New(slot0.rtTop, slot0.event)

	slot0.bind(slot0, SVFloatPanel.ReturnCall, function (slot0, slot1)
		slot0:Op("OpCall", function (slot0)
			slot0()

			if slot0.id == nowWorld:GetActiveEntrance().id then
				slot1.wsAtlas:UpdateSelect()
				slot1.wsAtlas:UpdateSelect(slot0)
			else
				slot1:ClickAtlas(slot1)
			end
		end)
	end)

	slot0.svPoisonPanel = SVPoisonPanel.New(slot0.rtPanelList, slot0.event)
	slot0.svGlobalBuff = SVGlobalBuff.New(slot0.rtPanelList, slot0.event)

	slot0.bind(slot0, SVGlobalBuff.HideView, function (slot0, slot1)
		return existCall(slot1)
	end)

	slot0.svBossProgress = SVBossProgress.New(slot0.rtPanelList, slot0.event)

	slot0.bind(slot0, SVBossProgress.HideView, function (slot0, slot1)
		return existCall(slot1)
	end)

	slot0.svSalvageResult = SVSalvageResult.New(slot0.rtPanelList, slot0.event)
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.rtTop)

	slot0.warningSairen = not slot0.contextData.inSave

	if slot0.contextData.inWorld then
		slot0:Op("OpSetInMap", false, function ()
			slot0.wsAtlas:UpdateSelect(nowWorld:GetActiveEntrance())
		end)
	else
		slot0.Op(slot0, "OpSetInMap", true)
	end
end

slot0.onBackPressed = function (slot0)
	if slot0.inCutIn then
		return
	elseif slot0.svDebugPanel:isShowing() then
		slot0:HideSubView("DebugPanel")
	elseif slot0.svAchievement:isShowing() then
		slot0:HideSubView("Achievement")
	elseif slot0.svGlobalBuff:isShowing() then
		slot0:HideSubView("GlobalBuff")
	elseif slot0.svBossProgress:isShowing() then
		slot0:HideSubView("BossProgress")
	elseif slot0.svMarkOverall:isShowing() then
		slot0:HideSubView("MarkOverall")
	elseif slot0.svOrderPanel:isShowing() then
		slot0:HideSubView("OrderPanel")
	elseif slot0.svScannerPanel:isShowing() then
		slot0:HideSubView("ScannerPanel")
	elseif slot0.svPoisonPanel:isShowing() then
		slot0:HideSubView("PoisonPanel")
	elseif slot0.svSalvageResult:isShowing() then
		slot0:HideSubView("SalvageResult")
	elseif slot0.wsMapLeft and isActive(slot0.wsMapLeft.toggleMask) then
		slot0.wsMapLeft:HideToggleMask()
	elseif slot0:GetInMap() then
		triggerButton(slot0.wsMapTop.btnBack)
	else
		triggerButton(slot0.rtTopAtlas:Find("back_button"))
	end
end

slot0.quickExitFunc = function (slot0)
	slot0:Op("OpCall", function (slot0)
		slot0()

		slot1 = {}

		if nowWorld:CheckReset() then
			table.insert(slot1, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_recycle_notice"),
					onYes = slot0
				})
			end)
		end

		seriesAsync(slot1, function ()
			slot0.super.quickExitFunc(slot1)
		end)
	end)
end

slot0.ExitWorld = function (slot0, slot1, slot2)
	slot3 = {}

	if not slot2 then
		table.insert(slot3, function (slot0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_exit_tip"),
				onYes = slot0,
				onNo = function ()
					return existCall(existCall)
				end
			})
		end)
	end

	if not slot2 and nowWorld.CheckReset(slot4) then
		table.insert(slot3, function (slot0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_recycle_notice"),
				onYes = slot0,
				onNo = function ()
					return existCall(existCall)
				end
			})
		end)
	end

	table.insert(slot3, function (slot0)
		if slot0:GetInMap() then
			slot0:EaseOutMapUI(slot0)
		else
			slot0:EaseOutAtlasUI(slot0)
		end
	end)
	seriesAsync(slot3, function ()
		existCall(existCall)
		existCall:closeView()
	end)
end

slot0.SaveState = function (slot0)
	slot0.contextData.inSave = true
	slot0.contextData.inWorld = slot0:GetInMap() == false
	slot0.contextData.inShop = false
	slot0.contextData.inPort = false
end

slot0.willExit = function (slot0)
	slot0:SaveState()
	slot0:RemoveWorldListener()
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.rtTop, slot0._tf)
	slot0.svOrderPanel:Destroy()
	slot0.svScannerPanel:Destroy()
	slot0.svAchievement:Destroy()
	slot0.svMarkOverall:Destroy()
	slot0.svRealmPanel:Destroy()
	slot0.svDebugPanel:Destroy()
	slot0.svFloatPanel:Destroy()
	slot0.svPoisonPanel:Destroy()
	slot0.svGlobalBuff:Destroy()
	slot0.svBossProgress:Destroy()
	slot0:DisposeAtlas()
	slot0:DisposeAtlasUI()
	slot0:DisposeMap()
	slot0:DisposeMapUI()
	slot0:DisposeAtlasOverall()
	slot0.wsPool:Dispose()

	slot0.wsPool = nil

	slot0.wsAnim:Dispose()

	slot0.wsAnim = nil

	slot0.wsTimer:Dispose()

	slot0.wsTimer = nil

	slot0.wsDragProxy:Dispose()

	slot0.wsDragProxy = nil

	slot0.wsMapCamera:Dispose()

	slot0.wsMapCamera = nil

	slot0.resAtlas:exit()

	slot0.resAtlas = nil

	slot0.resMap:exit()

	slot0.resMap = nil

	slot0:VerifyMapOp()
	slot0:OpDispose()
	WSCommand.Unbind(slot0)
	WBank:Recycle(WorldMapOp)

	slot1 = pg.PoolMgr.GetInstance()

	slot1:DestroyPrefab("world/object/world_cell", "world_cell")
	slot1:DestroyPrefab("world/object/world_cell_quad", "world_cell_quad")
	slot1:DestroyPrefab("world/object/world_cell_transport", "world_cell_transport")
	slot1:DestroyPrefab("world/object/world_cell_item", "world_cell_item")
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.player = slot1

	slot0.resAtlas:setPlayer(slot0.player)
	slot0.resMap:setPlayer(slot0.player)
end

slot0.AddWorldListener = function (slot0)
	nowWorld:AddListener(World.EventUpdateProgress, slot0.onUpdateProgress)
end

slot0.RemoveWorldListener = function (slot0)
	nowWorld:RemoveListener(World.EventUpdateProgress, slot0.onUpdateProgress)
end

slot0.SetInMap = function (slot0, slot1, slot2)
	slot3 = {}

	if slot0.inMap ~= slot1 then
		slot0:StopAnim()

		if slot0.inMap ~= nil then
			table.insert(slot3, (slot1 and function (slot0)
				slot0:Op("OpSwitchOutWorld", slot0)
			end) or function (slot0)
				slot0:Op("OpSwitchOutMap", slot0)
			end)
		end

		table.insert(slot3, (slot1 and function (slot0)
			slot0:Op("OpSwitchInMap", slot0)
		end) or function (slot0)
			slot0:Op("OpSwitchInWorld", slot0)
		end)
		table.insert(slot3, function (slot0)
			slot0:PlayBGM()

			if slot0.PlayBGM then
				slot2 = defaultValue(slot2, function ()
					slot0:Op("OpInteractive")
				end)
			end

			slot0()
		end)

		slot0.inMap = slot1
	end

	seriesAsync(slot3, function ()
		if not slot0 and slot1.atlasDisplayInfo then
			slot1.atlasDisplayInfo = nil

			return existCall(nil, slot1.atlasDisplayInfo.entrance, slot1.atlasDisplayInfo.mapId, slot1.atlasDisplayInfo.mapTypes)
		else
			return existCall(slot2)
		end
	end)
end

slot0.GetInMap = function (slot0)
	return slot0.inMap
end

slot0.ShowSubView = function (slot0, slot1, slot2, slot3)
	slot0["sv" .. slot1].Load(slot4)
	slot0["sv" .. slot1]:ActionInvoke("Setup", unpack(slot2 or {}))
	slot4:ActionInvoke("Show", unpack(slot3 or {}))
end

slot0.HideSubView = function (slot0, slot1, ...)
	slot0["sv" .. slot1]:ActionInvoke("Hide", ...)
end

slot0.DisplayAtlasUI = function (slot0)
	slot0:DisplayAtlasTop()
	slot0:DisplayAtlasRight()
	slot0:DisplayAtlasBottom()
	slot0:UpdateSystemOpen()
end

slot0.HideAtlasUI = function (slot0)
	slot0:HideAtlasTop()
	slot0:HideAtlasRight()
	slot0:HideAtlasBottom()
end

slot0.EaseInAtlasUI = function (slot0, slot1)
	slot0:CancelAtlasUITween()
	parallelAsync({
		function (slot0)
			setAnchoredPosition(slot0.rtTopAtlas, {
				y = slot0.rtTopAtlas.rect.height
			})
			slot0.wsTimer:AddTween(LeanTween.moveY(slot0.rtTopAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtBottomAtlas, {
				y = -slot0.rtBottomAtlas.rect.height
			})
			slot0.wsTimer:AddTween(LeanTween.moveY(slot0.rtBottomAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtRightAtlas, {
				x = slot0.rtRightAtlas.rect.width
			})
			slot0.wsTimer:AddTween(LeanTween.moveX(slot0.rtRightAtlas, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(slot0)).uniqueId)
		end
	}, function ()
		return existCall(existCall)
	end)
end

slot0.EaseOutAtlasUI = function (slot0, slot1)
	slot0:CancelAtlasUITween()
	parallelAsync({
		function (slot0)
			setAnchoredPosition(slot0.rtTopAtlas, {
				y = 0
			})
			slot0.wsTimer:AddTween(LeanTween.moveY(slot0.rtTopAtlas, slot0.rtTopAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtBottomAtlas, {
				y = 0
			})
			slot0.wsTimer:AddTween(LeanTween.moveY(slot0.rtBottomAtlas, -slot0.rtBottomAtlas.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtRightAtlas, {
				x = 0
			})
			slot0.wsTimer:AddTween(LeanTween.moveX(slot0.rtRightAtlas, slot0.rtRightAtlas.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end
	}, function ()
		return existCall(existCall)
	end)
end

slot0.CancelAtlasUITween = function (slot0)
	LeanTween.cancel(go(slot0.rtTransportAtlas))
	LeanTween.cancel(go(slot0.rtTopAtlas))
	LeanTween.cancel(go(slot0.rtBottomAtlas))
	LeanTween.cancel(go(slot0.rtRightAtlas))
end

slot0.DisposeAtlasUI = function (slot0)
	slot0:HideAtlasUI()
	slot0:DisposeAtlasTransport()
	slot0:DisposeAtlasTop()
	slot0:DisposeAtlasRight()
	slot0:DisposeAtlasBottom()
end

slot0.DisplayAtlas = function (slot0)
	slot0.wsAtlas:SwitchArea((slot0.atlasDisplayInfo and slot0.atlasDisplayInfo.entrance) or nowWorld:GetActiveEntrance():GetAreaId())
	slot0.wsAtlas:UpdateActiveMark()
	slot0.wsAtlas:ShowOrHide(true)
end

slot0.HideAtlas = function (slot0)
	slot0.wsAtlas:UpdateSelect()
	slot0.wsAtlas:ShowOrHide(false)
end

slot0.ClickAtlas = function (slot0, slot1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	if not nowWorld:CheckAreaUnlock(slot1:GetAreaId()) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("area_lock"))

		return
	end

	if slot0.wsAtlas.nowArea then
		slot0.wsAtlas:UpdateSelect()

		if slot0.wsAtlas.selectEntrance ~= slot1 then
			slot0.wsAtlas:UpdateSelect(slot1)
		end
	else
		slot0:EnterToModelMap(slot2)
	end
end

slot0.LoadAtlas = function (slot0, slot1)
	slot2 = {}

	if not slot0.wsAtlas then
		table.insert(slot2, function (slot0)
			slot0.wsAtlas = slot0:NewAtlas()

			slot0.wsAtlas:LoadScene(function ()
				slot0.wsAtlas:AddListener(WSAtlasWorld.EventUpdateselectEntrance, slot0.onModelSelectMap)
				slot0.wsAtlas.AddListener.wsAtlas:UpdateAtlas(nowWorld:GetAtlas())

				return slot0.wsAtlas.AddListener.wsAtlas()
			end)
		end)
	end

	seriesAsync(slot2, function ()
		return existCall(existCall)
	end)
end

slot0.NewAtlas = function (slot0)
	slot1 = WSAtlasWorld.New()
	slot1.wsTimer = slot0.wsTimer

	slot1.onClickColor = function (slot0, slot1)
		if slot0.wsAtlas:CheckIsTweening() then
			return
		end

		slot0:Op("OpCall", function (slot0)
			slot0()
			slot0:ClickAtlas(slot0.ClickAtlas)
		end)
	end

	slot1.Setup(slot1)

	return slot1
end

slot0.DisposeAtlas = function (slot0)
	if slot0.wsAtlas then
		slot0:HideAtlas()
		slot0.wsAtlas:RemoveListener(WSAtlasWorld.EventUpdateselectEntrance, slot0.onModelSelectMap)
		slot0.wsAtlas:Dispose()

		slot0.wsAtlas = nil
	end
end

slot0.DisplayAtlasTop = function (slot0)
	slot0.wsAtlasTop = slot0.wsAtlasTop or slot0:NewAtlasTop(slot0.rtTopAtlas)

	setActive(slot0.rtTopAtlas, true)
	setActive(slot0.rtTopAtlas:Find("print/title_world"), true)
	setActive(slot0.rtTopAtlas:Find("print/title_view"), false)
	setActive(slot0.rtTopAtlas:Find("sairen_warning"), slot0.warningSairen and #nowWorld:GetAtlas().sairenEntranceList > 0)

	slot0.warningSairen = false
end

slot0.HideAtlasTop = function (slot0)
	setActive(slot0.rtTopAtlas, false)
end

slot0.NewAtlasTop = function (slot0, slot1)
	onButton(slot0, slot1:Find("back_button"), function ()
		slot0:Op("OpCall", function (slot0)
			slot0()
			slot0:BackToMap()
		end)
	end, SFX_CANCEL)

	return {
		transform = slot1
	}
end

slot0.DisposeAtlasTop = function (slot0)
	slot0.wsAtlasTop = nil
end

slot0.DisplayAtlasRight = function (slot0)
	slot0.wsAtlasRight = slot0.wsAtlasRight or slot0:NewAtlasRight(slot0.rtRightAtlas)

	slot0.wsAtlasRight:SetOverSize(slot0.rtTop:Find("adapt").offsetMax.x)
	setActive(slot0.rtRightAtlas, true)
end

slot0.HideAtlasRight = function (slot0)
	setActive(slot0.rtRightAtlas, false)
end

slot0.NewAtlasRight = function (slot0, slot1, slot2)
	slot3 = WSAtlasRight.New()
	slot3.transform = slot1

	slot3:Setup()
	onButton(slot0, slot3.btnSettings, function ()
		slot0:Op("OpOpenScene", SCENE.SETTINGS, {
			scroll = "world_settings",
			toggle = SettingsScene.EnterToggle.options
		})
	end, SFX_PANEL)

	return slot3
end

slot0.DisposeAtlasRight = function (slot0)
	if slot0.wsAtlasRight then
		slot0.wsAtlasRight:Dispose()

		slot0.wsAtlasRight = nil
	end
end

slot0.DisplayAtlasBottom = function (slot0)
	slot0.wsAtlasBottom = slot0.wsAtlasBottom or slot0:NewAtlasBottom(slot0.rtBottomAtlas)

	slot0.wsAtlasBottom:SetOverSize(slot0.rtTop:Find("adapt").offsetMax.x)
	slot0.wsAtlasBottom:UpdateScale(1)
	setActive(slot0.rtBottomAtlas, true)
end

slot0.HideAtlasBottom = function (slot0)
	setActive(slot0.rtBottomAtlas, false)
end

slot0.NewAtlasBottom = function (slot0, slot1)
	slot2 = WSAtlasBottom.New()
	slot2.transform = slot1
	slot2.wsTimer = slot0.wsTimer

	slot2:Setup()

	if CAMERA_MOVE_OPEN then
		slot2:AddListener(WSAtlasBottom.EventUpdateScale, slot0.onUpdateScale)
	end

	onButton(slot0, slot2.btnOverview, function ()
		if slot0.wsAtlas:CheckIsTweening() then
			return
		end

		slot0:Op("OpCall", function (slot0)
			slot0.wsAtlas:LoadModel(function ()
				slot0()
				slot1:ReturnToModelArea()
			end)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot2.btnBoss, function ()
		if nowWorld:GetBossProxy():IsOpen() then
			slot0:Op("OpOpenScene", SCENE.WORLDBOSS)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(slot0, slot2.btnShop, function ()
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldShopMediator,
			viewComponent = WorldShopLayer
		}))
	end, SFX_PANEL)
	onButton(slot0, slot2.btnCollection, function ()
		WorldConst.ReqWorldCheck(function ()
			slot0:Op("OpOpenScene", SCENE.WORLD_COLLECTION, {
				page = WorldMediaCollectionScene.PAGE_RECORD
			})
		end)
	end, SFX_PANEL)

	return slot2
end

slot0.DisposeAtlasBottom = function (slot0)
	if slot0.wsAtlasBottom then
		slot0.wsAtlasBottom:Dispose()

		slot0.wsAtlasBottom = nil
	end
end

slot0.DisplayAtlasTransport = function (slot0)
	slot0.wsAtlasTransport = slot0.wsAtlasTransport or slot0:NewAtlasTransport(slot0.rtTransportAtlas)

	setActive(slot0.rtTransportAtlas, true)
end

slot0.HideAtlasTransport = function (slot0)
	setActive(slot0.rtTransportAtlas, false)
end

slot0.NewAtlasTransport = function (slot0, slot1)
	onButton(slot0, ({
		transform = slot1,
		btnBack = slot1:Find("adapt/btn_back")
	})["btnBack"], function ()
		slot0:BackToMap()
	end, SFX_CANCEL)

	return 
end

slot0.DisposeAtlasTransport = function (slot0)
	slot0.wsAtlasTransport = nil
end

slot0.DisplayMapUI = function (slot0)
	slot0:DisplayMapTop()
	slot0:DisplayMapLeft()
	slot0:DisplayMapRight()
	slot0:DisplayMapOut()
	slot0:UpdateSystemOpen()
end

slot0.HideMapUI = function (slot0)
	slot0:HideMapTop()
	slot0:HideMapLeft()
	slot0:HideMapRight()
	slot0:HideMapOut()
end

slot0.UpdateMapUI = function (slot0)
	slot2 = nowWorld:GetActiveMap()

	slot0.wsMapTop:Update(slot1, slot2)
	slot0.wsMapLeft:UpdateMap(slot2)
	slot0.wsMapRight:Update(slot1, slot2)
	slot0.wsMapOut:UpdateMap(slot2)
end

slot0.EaseInMapUI = function (slot0, slot1)
	slot0:CancelMapUITween()
	parallelAsync({
		function (slot0)
			setAnchoredPosition(slot0.rtTopMap, {
				y = slot0.rtTopMap.rect.height
			})
			slot0.wsTimer:AddTween(LeanTween.moveY(slot0.rtTopMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtLeftMap, {
				x = -slot0.rtLeftMap.rect.width
			})
			slot0.wsTimer:AddTween(LeanTween.moveX(slot0.rtLeftMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtRightMap, {
				x = slot0.rtRightMap.rect.width
			})
			slot0.wsTimer:AddTween(LeanTween.moveX(slot0.rtRightMap, 0, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeInSine):setOnComplete(System.Action(slot0)).uniqueId)
		end
	}, function ()
		return existCall(existCall)
	end)
end

slot0.EaseOutMapUI = function (slot0, slot1)
	slot0:CancelMapUITween()
	parallelAsync({
		function (slot0)
			setAnchoredPosition(slot0.rtTopMap, {
				y = 0
			})
			slot0.wsTimer:AddTween(LeanTween.moveY(slot0.rtTopMap, slot0.rtTopMap.rect.height, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtLeftMap, {
				x = 0
			})
			slot0.wsTimer:AddTween(LeanTween.moveX(slot0.rtLeftMap, -slot0.rtLeftMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end,
		function (slot0)
			setAnchoredPosition(slot0.rtRightMap, {
				x = 0
			})
			slot0.wsTimer:AddTween(LeanTween.moveX(slot0.rtRightMap, slot0.rtRightMap.rect.width, WorldConst.UIEaseFasterDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end
	}, function ()
		return existCall(existCall)
	end)
end

slot0.CancelMapUITween = function (slot0)
	LeanTween.cancel(go(slot0.rtTopMap))
	LeanTween.cancel(go(slot0.rtLeftMap))
	LeanTween.cancel(go(slot0.rtRightMap))
end

slot0.DisposeMapUI = function (slot0)
	slot0:DisposeMapTop()
	slot0:DisposeMapLeft()
	slot0:DisposeMapRight()
	slot0:DisposeMapOut()
end

slot0.DisplayMap = function (slot0)
	setActive(slot0.rtUIMain, true)
end

slot0.HideMap = function (slot0)
	setActive(slot0.rtUIMain, false)
end

slot0.ShowMargin = function (slot0, slot1)
	if slot0.wsMap then
		slot0.wsMap:UpdateTransportDisplay(slot1)
	end
end

slot0.LoadMap = function (slot0, slot1, slot2)
	slot3 = {}

	if not slot1:IsValid() then
		table.insert(slot3, function (slot0)
			slot0:OpPush("OpFetchMap", slot1.id, slot0)
		end)
	end

	seriesAsync(slot3, function ()
		if slot0.wsMap then
			return existCall(slot1)
		else
			slot2:AddListener(WorldMap.EventUpdateActive, slot0.onDisposeMap)
			slot2:AddListener(WorldMap.EventUpdateMoveSpeed, slot0.onClearMoveQueue)

			slot2.AddListener.wsMap = slot0:NewMap(slot0)

			slot2.AddListener.wsMap:Load(function ()
				slot0.wsMap.transform:SetParent(slot0.rtDragLayer, false)
				setActive(slot0.wsMap.transform, true)
				setActive:InitMap()

				return existCall(setActive)
			end)
		end
	end)
end

slot0.InitMap = function (slot0)
	for slot4, slot5 in ipairs(slot0.wsMap.wsMapFleets) do
		onButton(slot0, slot5.rtRetreat, function ()
			slot0:Op("OpReqRetreat", slot1.fleet)
		end, SFX_PANEL)
		slot5.AddListener(slot5, WSMapFleet.EventUpdateSelected, slot0.onFleetSelected)
	end

	slot0.wsMap:AddListener(WSMap.EventUpdateEventTips, slot0.onUpdateEventTips)
	nowWorld:AddListener(World.EventUpdateSubmarineSupport, slot0.onUpdateSubmarineSupport)
	nowWorld:AddListener(World.EventAchieved, slot0.onAchievementAchieved)
	slot0.wsDragProxy:UpdateMap(slot1)
	slot0.wsDragProxy:Focus(slot0.wsMap:GetFleet().transform.position)
	slot0.wsMapCamera:UpdateMap(slot0.wsMap.map)
	slot0:OnUpdateSubmarineSupport()
end

slot0.NewMap = function (slot0, slot1)
	slot2 = WSMap.New()
	slot2.wsPool = slot0.wsPool
	slot2.wsTimer = slot0.wsTimer

	slot2:Setup(slot1)

	slot0.rtGrid.localEulerAngles = Vector3(slot1.theme.angle, 0, 0)

	return slot2
end

slot0.DisposeMap = function (slot0)
	if slot0.wsMap then
		slot0.wsTimer:ClearInMapTimers()
		slot0.wsTimer:ClearInMapTweens()
		slot0:HideMap()
		nowWorld.RemoveListener(slot1, World.EventUpdateSubmarineSupport, slot0.onUpdateSubmarineSupport)
		nowWorld.RemoveListener(slot1, World.EventAchieved, slot0.onAchievementAchieved)
		slot0.wsMap.map.RemoveListener(slot2, WorldMap.EventUpdateActive, slot0.onDisposeMap)
		slot0.wsMap.map.RemoveListener(slot2, WorldMap.EventUpdateMoveSpeed, slot0.onClearMoveQueue)
		slot0.wsMap:Dispose()

		slot0.wsMap = nil
	end
end

slot0.OnDisposeMap = function (slot0, slot1, slot2)
	slot3 = false

	if slot1 == WorldMap.EventUpdateActive then
		slot3 = not slot2.active
	end

	if slot3 then
		slot0:DisposeMap()
	end
end

slot0.DisplayMapTop = function (slot0)
	slot0.wsMapTop = slot0.wsMapTop or slot0:NewMapTop(slot0.rtTopMap)

	setActive(slot0.rtTopMap, true)
end

slot0.HideMapTop = function (slot0)
	setActive(slot0.rtTopMap, false)
end

slot0.NewMapTop = function (slot0, slot1)
	slot2 = WSMapTop.New()
	slot2.transform = slot1

	slot2:Setup()

	slot2.cmdSkillFunc = function (slot0)
		slot0:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = slot0
			}
		}))
	end

	slot2.poisonFunc = function (slot0)
		slot0:ShowSubView("PoisonPanel", {
			slot0
		})
	end

	onButton(slot0, slot2.btnBack, function ()
		slot0:Op("OpCall", function (slot0)
			slot0:ExitWorld(slot0)
		end)
	end, SFX_CANCEL)

	return slot2
end

slot0.DisposeMapTop = function (slot0)
	if slot0.wsMapTop then
		slot0:HideMapTop()
		slot0.wsMapTop:Dispose()

		slot0.wsMapTop = nil
	end
end

slot0.DisplayMapLeft = function (slot0)
	slot0.wsMapLeft = slot0.wsMapLeft or slot0:NewMapLeft(slot0.rtLeftMap)

	setActive(slot0.rtLeftMap, true)
end

slot0.HideMapLeft = function (slot0)
	setActive(slot0.rtLeftMap, false)
end

slot0.NewMapLeft = function (slot0, slot1)
	slot2 = WSMapLeft.New()
	slot2.transform = slot1

	slot2:Setup()

	slot2.onAgonyClick = function ()
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld:GetActiveMap().findex
			}
		}))
	end

	slot2.onLongPress = function (slot0)
		slot0:Op("OpOpenScene", SCENE.SHIPINFO, {
			shipId = slot0.id,
			shipVOs = nowWorld:GetFleet(slot0.fleetId).GetShipVOs(slot1, true)
		})
	end

	slot2.onClickSalvage = function (slot0)
		slot0:Op("OpCall", function (slot0)
			slot0()
			slot0:ShowSubView("SalvageResult", {
				slot0.ShowSubView
			})
		end)
	end

	slot2.AddListener(slot2, WSMapLeft.EventSelectFleet, slot0.onSelectFleet)

	return slot2
end

slot0.DisposeMapLeft = function (slot0)
	if slot0.wsMapLeft then
		slot0:HideMapLeft()
		slot0.wsMapLeft:RemoveListener(WSMapLeft.EventSelectFleet, slot0.onSelectFleet)
		slot0.wsMapLeft:Dispose()

		slot0.wsMapLeft = nil
	end
end

slot0.DisplayMapRight = function (slot0)
	slot0.wsMapRight = slot0.wsMapRight or slot0:NewMapRight(slot0.rtRightMap)

	setActive(slot0.rtRightMap, true)
	slot0:UpdateAutoFightDisplay()
end

slot0.HideMapRight = function (slot0)
	setActive(slot0.rtRightMap, false)
end

slot0.HideMapRightCompass = function (slot0)
	return
end

slot0.HideMapRightMemo = function (slot0)
	return
end

slot0.NewMapRight = function (slot0, slot1)
	slot2 = WSMapRight.New()
	slot2.transform = slot1
	slot2.wsPool = slot0.wsPool
	slot2.wsTimer = slot0.wsTimer

	slot2:Setup()
	slot2:OnUpdateInfoBtnTip()
	slot2:OnUpdateHelpBtnTip()
	onButton(slot0, slot2.btnOrder, function ()
		slot0:Op("OpShowOrderPanel")
	end, SFX_PANEL)
	onButton(slot0, slot2.btnScan, function ()
		slot0:Op("OpShowScannerPanel")
	end, SFX_PANEL)
	onButton(slot0, slot2.btnDefeat, function ()
		slot0:OnUpdateHelpBtnTip(true)
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 4,
				pageId = 5
			}
		}))
	end, SFX_PANEL)
	onButton(slot0, slot2.btnDetail, function ()
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldDetailMediator,
			viewComponent = WorldDetailLayer,
			data = {
				fleetId = nowWorld:GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(slot0, slot2.btnInformation, function ()
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldInformationMediator,
			viewComponent = WorldInformationLayer,
			data = {
				fleetId = nowWorld:GetActiveMap():GetFleet().id
			}
		}))
	end, SFX_PANEL)
	onButton(slot0, slot2.btnInventory, function ()
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldInventoryMediator,
			viewComponent = WorldInventoryLayer,
			data = {
				currentFleetIndex = nowWorld:GetActiveMap().findex
			}
		}))
	end, SFX_PANEL)
	onButton(slot0, slot2.btnTransport, function ()
		slot0:OnClickTransport()
	end, SFX_PANEL)
	onButton(slot0, slot2.btnPort, function ()
		slot0:Op("OpReqEnterPort")
	end, SFX_PANEL)
	onButton(slot0, slot2.btnExit, function ()
		slot1 = {}

		if nowWorld:GetActiveMap():CheckFleetSalvage(true) then
			table.insert(slot1, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_catsearch_leavemap"),
					onYes = slot0
				})
			end)
		end

		seriesAsync(slot1, function ()
			slot0:Op("OpReqJumpOut", slot1.gid)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot2.btnHelp, function ()
		slot0:OnUpdateHelpBtnTip(true)
		slot0:Op("OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer
		}))
	end, SFX_PANEL)
	onButton(slot0, slot2.toggleAutoFight:Find("off"), function ()
		slot0:Op("OpCall", function (slot0)
			slot0()

			slot1 = {}

			if PlayerPrefs.GetInt("first_auto_fight_mark", 0) == 0 then
				table.insert(slot1, function (slot0)
					PlayerPrefs.SetInt("first_auto_fight_mark", 1)
					slot0:Op("OpOpenLayer", Context.New({
						mediator = WorldHelpMediator,
						viewComponent = WorldHelpLayer,
						data = {
							titleId = 2,
							pageId = 8
						},
						onRemoved = slot0
					}))
				end)
			end

			if nowWorld.IsSystemOpen(slot2, WorldConst.SystemOrderSubmarine) and PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1 and nowWorld:GetActiveMap():GetConfig("instruction_available")[1] == 1 and nowWorld:CanCallSubmarineSupport() and not nowWorld:IsSubmarineSupporting() then
				if nowWorld:CalcOrderCost(WorldConst.OpReqSub) <= PlayerPrefs.GetInt("world_sub_call_line", 0) and slot2 <= nowWorld.staminaMgr:GetTotalStamina() then
					if slot2 > 0 then
						table.insert(slot1, function (slot0)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("world_instruction_submarine_2", setColorStr(slot0, COLOR_GREEN)),
								onYes = function ()
									PlayerPrefs.SetInt("autoSubIsAcitve" .. "_" .. SYSTEM_WORLD, 1)
									PlayerPrefs.SetInt:Op("OpReqSub", PlayerPrefs.SetInt)
								end,
								onNo = slot0
							})
						end)
					else
						PlayerPrefs.SetInt("autoSubIsAcitve" .. "_" .. SYSTEM_WORLD, 1)
						table.insert(slot1, function (slot0)
							slot0:Op("OpReqSub", slot0)
						end)
					end
				end
			end

			seriesAsync(slot1, function ()
				pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_begin"))
				getProxy(MetaCharacterProxy):setMetaTacticsInfoOnStart()
				triggerToggle(slot0.wsMapRight.toggleSkipPrecombat, true)
				PlayerPrefs.SetInt("autoBotIsAcitve" .. AutoBotCommand.GetAutoBotMark(SYSTEM_WORLD), 1)
				nowWorld:TriggerAutoFight(true)
				nowWorld.TriggerAutoFight:Op("OpInteractive")
			end)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot2.toggleAutoFight:Find("on"), function ()
		slot0:Op("OpCall", function (slot0)
			slot0()
			nowWorld:TriggerAutoFight(false)
			slot0:Op("OpInteractive")
		end)
	end, SFX_PANEL)

	return slot2
end

slot0.DisposeMapRight = function (slot0)
	if slot0.wsMapRight then
		slot0:HideMapRight()
		slot0.wsMapRight:Dispose()

		slot0.wsMapRight = nil
	end
end

slot0.DisplayMapOut = function (slot0)
	slot0.wsMapOut = slot0.wsMapOut or slot0:NewMapOut(slot0.rtOutMap)

	setActive(slot0.rtOutMap, true)
end

slot0.HideMapOut = function (slot0)
	setActive(slot0.rtOutMap, false)
end

slot0.NewMapOut = function (slot0, slot1)
	slot2 = WSMapOut.New()
	slot2.transform = slot1

	slot2:Setup()

	return slot2
end

slot0.DisposeMapOut = function (slot0)
	if slot0.wsMapOut then
		slot0:HideMapOut()
		slot0.wsMapOut:Dispose()

		slot0.wsMapOut = nil
	end
end

slot0.DisplayAtlasOverall = function (slot0)
	if slot0.wsAtlasOverall then
		slot0.wsAtlasOverall:ShowOrHide(true)
	end
end

slot0.HideAtlasOverall = function (slot0)
	if slot0.wsAtlasOverall then
		slot0.wsAtlasOverall:ShowOrHide(false)
	end
end

slot0.LoadAtlasOverall = function (slot0, slot1)
	slot2 = {}

	if not slot0.wsAtlasOverall then
		table.insert(slot2, function (slot0)
			slot0.wsAtlasOverall = slot0:NewAtlasOverall()

			slot0.wsAtlasOverall:LoadScene(function ()
				slot0.wsAtlasOverall:UpdateAtlas(nowWorld:GetAtlas())

				return slot0.wsAtlasOverall()
			end)
		end)
	end

	seriesAsync(slot2, function ()
		return existCall(existCall)
	end)
end

slot0.NewAtlasOverall = function (slot0)
	slot1 = WSAtlasOverall.New()

	slot1.onClickColor = function (slot0, slot1)
		return
	end

	slot1.Setup(slot1)

	return slot1
end

slot0.DisposeAtlasOverall = function (slot0)
	if slot0.wsAtlasOverall then
		slot0.wsAtlasOverall:Dispose()

		slot0.wsAtlasOverall = nil
	end
end

slot0.OnUpdateProgress = function (slot0, slot1, slot2, slot3, slot4)
	slot0:UpdateSystemOpen()

	if slot0.wsMapRight then
		slot0.wsMapRight:OnUpdateHelpBtnTip()
	end
end

slot0.OnUpdateScale = function (slot0, slot1, slot2, slot3)
	if slot0.wsAtlas and not slot0.wsAtlasBottom:CheckIsTweening() then
		slot0.wsAtlas:UpdateScale(slot3)
	end
end

slot0.OnModelSelectMap = function (slot0, slot1, slot2, slot3, slot4, slot5)
	if slot3 then
		slot0:ShowSubView("FloatPanel", {
			slot3,
			slot4,
			slot5,
			slot2
		})
	else
		slot0:HideSubView("FloatPanel")
	end
end

slot0.OnUpdateSubmarineSupport = function (slot0, slot1)
	slot0.wsMap:UpdateSubmarineSupport()

	if slot0.wsMapLeft then
		slot0.wsMapLeft:OnUpdateSubmarineSupport()
	end
end

slot0.OnFleetSelected = function (slot0, slot1, slot2)
	if slot2.selected then
		slot0.wsDragProxy:Focus(slot2.transform.position, nil, LeanTweenType.easeInOutSine)
	end
end

slot0.OnSelectFleet = function (slot0, slot1, slot2, slot3)
	if slot3 == nowWorld:GetActiveMap():GetFleet() then
		slot0:Op("OpMoveCamera", 0, 0.1)
	else
		slot0:Op("OpReqSwitchFleet", slot3)
	end
end

slot0.OnClickCell = function (slot0, slot1, slot2)
	slot3 = nowWorld:GetActiveMap()
	slot4 = slot3:GetFleet()

	if slot3:FindFleet(slot3:GetCell(slot1, slot2).row, slot3.GetCell(slot1, slot2).column) and slot6 ~= slot4 then
		slot0:Op("OpReqSwitchFleet", slot6)
	elseif slot3:CheckInteractive() then
		slot0:Op("OpInteractive", true)
	elseif slot3:IsSign(slot1, slot2) and ManhattonDist({
		row = slot4.row,
		column = slot4.column
	}, {
		row = slot5.row,
		column = slot5.column
	}) <= 1 then
		slot0:Op("OpTriggerSign", slot4, slot5:GetEventAttachment(), function ()
			slot0:Op("OpInteractive")
		end)
	elseif slot3.CanLongMove(slot3, slot4) then
		slot0:Op("OpLongMoveFleet", slot4, slot5.row, slot5.column)
	else
		slot0:Op("OpReqMoveFleet", slot4, slot5.row, slot5.column)
	end
end

slot0.OnClickTransport = function (slot0)
	if slot0.svScannerPanel:isShowing() then
		return
	end

	slot0:Op("OpCall", function (slot0)
		slot0()
		slot0:QueryTransport(function ()
			slot0:EnterTransportWorld()
		end)
	end)
end

slot0.QueryTransport = function (slot0, slot1)
	slot2 = nowWorld:GetActiveMap()
	slot3 = {}

	if not nowWorld:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))

		return
	end

	if slot2:CheckAttachmentTransport() == "story" then
		slot5 = pg.gameset.world_transfer_eventstory.description[1]

		table.insert(slot3, function (slot0)
			pg.NewStoryMgr.GetInstance():Play(slot0, function (slot0, slot1)
				if slot1 == 1 then
					slot0()
				end
			end, true)
		end)
	end

	if nowWorld.IsSubmarineSupporting(slot5) and slot2:GetSubmarineFleet():GetAmmo() > 0 then
		table.insert(slot3, function (slot0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_instruction_submarine_6"),
				onYes = slot0
			})
		end)
	end

	if slot2.CheckFleetSalvage(slot2, true) then
		table.insert(slot3, function (slot0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_catsearch_leavemap"),
				onYes = slot0
			})
		end)
	end

	slot5 = nil

	for slot9, slot10 in ipairs(slot2.GetNormalFleets(slot2)) do
		for slot14, slot15 in ipairs(slot10:GetCarries()) do
			if slot15.config.out_story ~= "" then
				slot5 = slot15.config.out_story
			end
		end
	end

	if slot5 then
		slot6 = pg.NewStoryMgr.GetInstance()

		table.insert(slot3, function (slot0)
			slot0:Play(slot0.Play, function (slot0, slot1)
				if slot1 == 1 then
					slot0()
				end
			end, true)
		end)
	end

	slot6, slot7 = slot2.CkeckTransport(slot2)

	if not slot6 then
		table.insert(slot3, function (slot0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = slot0,
				onYes = slot0
			})
		end)
	end

	seriesAsync(slot3, slot1)
end

slot0.OnUpdateEventTips = function (slot0, slot1, slot2)
	if slot0.wsMapRight then
		slot0.wsMapRight:OnUpdateEventTips()
	end

	if slot0.wsMapTop then
		slot0.wsMapTop:OnUpdatePoison()
	end
end

slot0.OnClickMap = function (slot0, slot1, slot2)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

	slot5 = slot0.wsMap.map.bottom
	slot6 = slot0.wsMap.map.left
	slot7 = slot0.wsMap.map.right

	if slot1 < slot0.wsMap.map.top or slot5 < slot1 or slot2 < slot6 or slot7 < slot2 then
		slot0:OnClickTransport()
	else
		slot0:OnClickCell(slot1, slot2)
	end
end

slot0.CheckScannerEnable = function (slot0, slot1, slot2)
	if nowWorld:IsSystemOpen(WorldConst.SystemScanner) and slot0.wsMap.map:GetCell(slot1, slot2) and slot4:GetInFOV() and not slot4:InFog() and slot4:GetScannerAttachment() then
		return slot5, slot0.camera:WorldToScreenPoint(slot0.wsMap:GetCell(slot1, slot2).rtAttachments.position)
	end
end

slot0.OnLongPressMap = function (slot0, slot1, slot2)
	if not slot0.svScannerPanel:isShowing() then
		slot3, slot4 = slot0:CheckScannerEnable(slot1, slot2)

		if slot3 then
			slot0:Op("OpShowScannerPanel", slot3, slot4)
		end
	end
end

slot0.OnAchievementAchieved = function (slot0, slot1, slot2, slot3, slot4)
	for slot8, slot9 in ipairs(slot3) do
		pg.TipsMgr.GetInstance():ShowTips(slot9)
	end

	if slot4 then
		if nowWorld.isAutoFight then
			nowWorld:AddAutoInfo("message", i18n("autofight_discovery", slot4.config.target_desc))
		else
			table.insert(slot0.achievedList, {
				slot4,
				slot0.wsMapRight.btnInformation.position
			})
		end
	end
end

slot0.DoAnim = function (slot0, slot1, slot2)
	if not slot0.wsAnim:GetAnim(slot1) then
		slot3:SetAnim(slot1, slot0:NewUIAnim(slot1))
	end

	slot3:GetAnim(slot1):Play(slot2)
end

slot0.NewUIAnim = function (slot0, slot1)
	slot2 = UIAnim.New()

	slot2:Setup(slot1)
	slot2:AddListener(UIAnim.EventLoaded, function ()
		slot0.transform:SetParent(slot1.rtTop, false)
	end)
	slot2.Load(slot2)

	return slot2
end

slot0.DoStrikeAnim = function (slot0, slot1, slot2, slot3)
	if not slot0.wsAnim:GetAnim(slot1) then
		slot4:SetAnim(slot1, slot0:NewStrikeAnim(slot1, slot2))
	else
		slot4:GetAnim(slot1):ReloadShip(slot2)
	end

	slot4:GetAnim(slot1):Play(slot3)
end

slot0.NewStrikeAnim = function (slot0, slot1, slot2)
	slot3 = UIStrikeAnim.New()

	slot3:Setup(slot1, slot2)
	slot3:AddListener(UIStrikeAnim.EventLoaded, function ()
		slot0.transform:SetParent(slot1.rtTop, false)
	end)
	slot3.Load(slot3)

	return slot3
end

slot0.StopAnim = function (slot0)
	slot0.wsAnim:Stop()
end

slot0.UpdateSystemOpen = function (slot0)
	if slot0:GetInMap() then
		slot0.wsMapLeft.onAgonyClickEnabled = nowWorld:IsSystemOpen(WorldConst.SystemInventory)

		setActive(slot0.wsMapRight.btnInventory, nowWorld:IsSystemOpen(WorldConst.SystemInventory))
		setActive(slot0.wsMapRight.btnTransport, nowWorld:IsSystemOpen(WorldConst.SystemOutMap))
		setActive(slot0.wsMapRight.btnDetail, nowWorld:IsSystemOpen(WorldConst.SystemFleetDetail))
		setActive(slot0.wsMapRight.rtCompassPanel, nowWorld:IsSystemOpen(WorldConst.SystemCompass))
		setActive(slot0.wsMapRight.toggleAutoFight, nowWorld:GetActiveMap():CanAutoFight())
	else
		setActive(slot0.wsAtlasBottom.btnBoss, nowWorld:IsSystemOpen(WorldConst.SystemWorldBoss))
		setActive(slot0.wsAtlasBottom.btnBoss:Find("tip"), nowWorld:GetBossProxy():NeedTip() or nowWorld:GetBossProxy():CanUnlock())
		setActive(slot0.wsAtlasBottom.btnBoss:Find("sel"), not (not nowWorld:GetBossProxy():ExistSelfBoss() and not nowWorld.GetBossProxy().CanUnlock()))

		if slot3 then
			WorldGuider.GetInstance():PlayGuideAndUpdateOnEnd("WorldG191")
		end

		onButton(slot0, slot5, function ()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("world_reset_tip")
			})
		end, SFX_PANEL)
		setActive(slot5, nowWorld.IsSystemOpen(slot6, WorldConst.SystemResetCountDown) and nowWorld:CheckResetProgress())

		if nowWorld.IsSystemOpen(slot6, WorldConst.SystemResetCountDown) and nowWorld.CheckResetProgress() then
			if math.floor(nowWorld:GetResetWaitingTime() / 86400) > 0 then
				setText(slot5:Find("Text"), i18n("world_reset_1", string.format("  %d  ", slot8)))
			elseif slot8 == 0 then
				setText(slot5:Find("Text"), i18n("world_reset_2", string.format("  %d  ", 0)))
			elseif slot8 < 0 then
				setText(slot5:Find("Text"), i18n("world_reset_3"))
			end
		end

		setActive(slot0.wsAtlasBottom.btnShop, nowWorld:IsSystemOpen(WorldConst.SystemResetShop))
	end

	setActive(slot0.resAtlas._tf, nowWorld:IsSystemOpen(WorldConst.SystemResource))
	setActive(slot0.resMap._tf, nowWorld:IsSystemOpen(WorldConst.SystemResource))
end

slot0.EnterToModelMap = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		setActive(slot0.rtTopAtlas:Find("print/title_world"), true)
		setActive(slot0.rtTopAtlas:Find("print/title_view"), false)
		slot0.wsAtlasBottom:UpdateScale(1, true, slot0)
	end)
	table.insert(slot2, function (slot0)
		slot0.wsAtlas:SwitchArea(slot0.wsAtlas.SwitchArea, true, slot0)
	end)
	parallelAsync(slot2, function ()
		slot0 = nowWorld:GetAtlas():GetActiveEntrance()

		if slot0 == slot0:GetAreaId() then
			slot1.wsAtlas:UpdateSelect(slot0)
		end
	end)
end

slot0.ReturnToModelArea = function (slot0)
	slot0.wsAtlas:UpdateSelect()
	table.insert(slot1, function (slot0)
		setActive(slot0.rtTopAtlas:Find("print/title_world"), false)
		setActive(slot0.rtTopAtlas:Find("print/title_view"), true)
		slot0.wsAtlasBottom:UpdateScale(0, true, slot0)
	end)
	table.insert(slot1, function (slot0)
		slot0.wsAtlas:SwitchArea(nil, true, slot0)
	end)
	parallelAsync(slot1, function ()
		return
	end)
end

slot0.EnterTransportWorld = function (slot0)
	slot0:Op("OpSetInMap", false, function (slot0, slot1, slot2)
		slot0.wsAtlas:SwitchArea(slot0 or nowWorld:GetActiveEntrance():GetAreaId(), false, function ()
			slot0.wsAtlas:UpdateSelect(slot0.wsAtlas, , )
			slot0(slot0.wsAtlas.UpdateSelect.wsAtlas, slot0.contextData.displayTransDic or {}, function ()
				slot0.contextData.displayTransDic = Clone(nowWorld:GetAtlas().transportDic)
			end)
		end)
	end)
end

slot0.BackToMap = function (slot0)
	if slot0.wsAtlas:CheckIsTweening() then
		return
	end

	slot0:Op("OpSetInMap", true)
end

slot0.DisplayEnv = function (slot0)
	if nowWorld:GetActiveMap() and #slot1.config.map_bg > 0 then
		GetImageSpriteFromAtlasAsync("world/map/" .. slot1.config.map_bg[1], "", slot0.rtEnvBG)
	else
		GetImageSpriteFromAtlasAsync("world/map/model_bg", "model_bg", slot0.rtEnvBG)
	end
end

slot0.ScreenPos2MapPos = function (slot0, slot1)
	slot3 = slot0.wsMap.map
	slot6, slot7 = Plane.New(slot0.wsMap.rtQuads.forward, -Vector3.Dot(slot0.wsMap.rtQuads.position, slot0.wsMap.rtQuads.forward)).Raycast(slot5, slot0.camera:ScreenPointToRay(slot1))

	if slot6 then
		return slot3.theme:Y2Row(slot2.rtQuads:InverseTransformPoint(slot8).y), slot3.theme:X2Column(slot2.rtQuads.InverseTransformPoint(slot8).x)
	end
end

slot0.BuildCutInAnim = function (slot0, slot1, slot2)
	slot0.tfAnim = slot0.rtPanelList:Find(slot1 .. "(Clone)")
	slot3 = {}

	if not slot0.tfAnim then
		table.insert(slot3, function (slot0)
			PoolMgr.GetInstance():GetUI(slot0, true, function (slot0)
				slot0:SetActive(false)

				slot0.tfAnim = tf(slot0)

				slot0.tfAnim:SetParent(slot0.rtPanelList, false)

				return slot0.tfAnim.SetParent()
			end)
		end)
	end

	table.insert(slot3, function (slot0)
		slot0.inCutIn = true

		slot0.tfAnim:GetComponent("DftAniEvent"):SetEndEvent(function (slot0)
			if not IsNil(slot0.tfAnim) then
				slot0.inCutIn = false

				pg.UIMgr.GetInstance():UnOverlayPanel(slot0.tfAnim, slot0.rtPanelList)
				setActive(slot0.tfAnim, false)

				return setActive()
			end
		end)
		pg.UIMgr.GetInstance().OverlayPanel(slot1, slot0.tfAnim)
		setActive(slot0.tfAnim, true)
	end)
	seriesAsync(slot3, function ()
		return existCall(existCall)
	end)
end

slot0.PlaySound = function (slot0, slot1, slot2)
	if slot0.cueName then
		pg.CriMgr.GetInstance():StopSE_V3()

		slot0.cueName = nil
	end

	pg.CriMgr.GetInstance():PlaySE_V3(slot1, function ()
		slot0.cueName = nil
	end)

	return existCall(slot2)
end

slot0.ChangeTopRaycasts = function (slot0, slot1)
	GetComponent(slot0.rtTop, typeof(CanvasGroup)).blocksRaycasts = tobool(slot1)
end

slot0.DoTopBlock = function (slot0, slot1)
	slot0:ChangeTopRaycasts(false)

	return function (...)
		slot0:ChangeTopRaycasts(true)

		return existCall(slot0, ...)
	end
end

slot0.SetMoveQueue = function (slot0, slot1)
	slot0:ReContinueMoveQueue()

	slot0.moveQueue = slot1
end

slot0.ClearMoveQueue = function (slot0)
	slot0:DisplayMoveStopClick(false)

	slot0.moveQueueInteractive = true

	if #slot0.moveQueue > 0 then
		slot0.moveQueue = {}
	end

	slot0:ShowFleetMoveTurn(false)
end

slot0.DoQueueMove = function (slot0, slot1)
	slot0:DisplayMoveStopClick(true)

	slot2 = nowWorld:GetActiveMap()
	slot3 = _.detect(slot0.moveQueue, function (slot0)
		return slot0.stay
	end)

	if #slot0.moveQueue == 1 and slot2.IsSign(slot2, slot3.row, slot3.column) then
		slot0:ClearMoveQueue()
		slot0:Op("OpTriggerSign", slot1, slot2:GetCell(slot3.row, slot3.column).GetEventAttachment(slot4), function ()
			slot0:Op("OpInteractive")
		end)
	else
		slot0.ReContinueMoveQueue(slot0)
		slot0:ShowFleetMoveTurn(true)
		slot0:Op("OpReqMoveFleet", slot1, slot3.row, slot3.column)
	end
end

slot0.CheckMoveQueue = function (slot0, slot1)
	if #slot0.moveQueue < #slot1 or #slot1 == 0 then
		slot0:ClearMoveQueue()
	elseif slot0.moveQueue[#slot1].row ~= slot1[#slot1].row or slot0.moveQueue[#slot1].column ~= slot2.column then
		slot0:ClearMoveQueue()
	else
		for slot6 = 1, #slot1, 1 do
			table.remove(slot0.moveQueue, 1)
		end

		if #slot0.moveQueue == 0 then
			slot0.moveQueueInteractive = true
		end
	end
end

slot0.InteractiveMoveQueue = function (slot0)
	if slot0.moveQueueInteractive then
		slot0:ClearMoveQueue()
	else
		slot0:DisplayMoveStopClick(false)

		slot0.moveQueueInteractive = true
	end
end

slot0.ReContinueMoveQueue = function (slot0)
	slot0.moveQueueInteractive = false
end

slot0.DisplayMoveStopClick = function (slot0, slot1)
	setActive(slot0.rtClickStop, slot1)

	if slot1 then
		setActive(slot0.rtClickStop:Find("long_move"), not nowWorld.isAutoFight)
		setActive(slot0.rtClickStop:Find("auto_fight"), nowWorld.isAutoFight)
	end
end

slot0.ShowFleetMoveTurn = function (slot0, slot1)
	if slot0.wsMap then
		if slot1 then
			slot0.wsMap:GetFleet():PlusMoveTurn()
		else
			slot0.wsMap:GetFleet():ClearMoveTurn()
		end
	end
end

slot0.GetAllPessingAward = function (slot0, slot1)
	slot3 = nowWorld.GetAtlas(slot2)
	slot4 = {}

	for slot8, slot9 in pairs(nowWorld.pressingAwardDic) do
		if slot9.flag then
			slot2:FlagMapPressingAward(slot8)
			slot3:MarkMapTransport(slot8)

			if #pg.world_event_complete[slot9.id].event_reward_slgbuff > 0 then
				slot4[slot11[1]] = defaultValue(slot4[slot11[1]], 0) + slot11[2]
			end
		end
	end

	if not nowWorld:GetActiveMap().visionFlag and nowWorld:IsMapVisioned(slot5.id) then
		slot5:UpdateVisionFlag(true)
	end

	if slot0.wsAtlas then
		slot0.wsAtlas:OnUpdatePressingAward()
	end

	if slot0.wsAtlasOverall then
		slot0.wsAtlasOverall:OnUpdatePressingAward()
	end

	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		table.insert(slot6, function (slot0)
			nowWorld:GetGlobalBuff(slot0):GetFloor():ShowSubView("GlobalBuff", {
				{
					id = slot0,
					floor = slot1,
					before = nowWorld.GetGlobalBuff(slot0).GetFloor()
				},
				slot0
			})
		end)
		table.insert(slot6, function (slot0)
			nowWorld:AddGlobalBuff(slot0, nowWorld.AddGlobalBuff)
			slot0()
		end)
	end

	seriesAsync(slot6, function ()
		return existCall(existCall)
	end)
end

slot0.CheckGuideSLG = function (slot0, slot1, slot2)
	table.insert(slot3, {
		"WorldG007",
		function ()
			return slot0:InPort(slot1.id, nowWorld:GetRealm())
		end
	})
	table.insert(slot3, {
		"WorldG111",
		function ()
			return slot0:canExit()
		end
	})
	table.insert(slot3, {
		"WorldG112",
		function ()
			return nowWorld:GetActiveEntrance().becomeSairen and slot0:GetSairenMapId() == slot0.id
		end
	})
	table.insert(slot3, {
		"WorldG124",
		function ()
			return nowWorld:IsSystemOpen(WorldConst.SystemOrderSubmarine) and slot0:GetConfig("instruction_available")[1] ~= 0 and nowWorld:CanCallSubmarineSupport()
		end
	})
	table.insert(slot3, {
		"WorldG162",
		function ()
			return _.any(slot0:GetNormalFleets(), function (slot0)
				return _.any(slot0:GetShips(true), function (slot0)
					return slot0:IsBroken()
				end)
			end)
		end
	})
	table.insert(slot3, {
		"WorldG163",
		function ()
			return underscore.any(nowWorld:GetTaskProxy():getDoingTaskVOs(), function (slot0)
				return not slot0:IsAutoSubmit() and slot0:isFinished()
			end)
		end
	})
	table.insert(slot3, {
		"WorldG164",
		function ()
			return slot0:CheckFleetSalvage(true)
		end
	})
	table.insert(slot3, {
		"WorldG181",
		function ()
			return nowWorld:GetInventoryProxy().GetItemCount(slot0, 102) > 0
		end
	})

	slot4 = _.filter(slot1.FindAttachments(slot1, WorldMapAttachment.TypeEvent), function (slot0)
		return slot0:IsAlive()
	end)

	for slot8, slot9 in ipairs(pg.gameset.world_guide_event.description) do
		table.insert(slot3, {
			slot9[2],
			function ()
				return _.any(_.any, function (slot0)
					return slot0.id == slot0[1]
				end)
			end
		})
	end

	slot5 = pg.NewStoryMgr.GetInstance()

	for slot9, slot10 in ipairs(slot3) do
		if not slot5:IsPlayed(slot10[1]) and slot10[2]() then
			WorldGuider.GetInstance():PlayGuide(slot10[1])

			break
		end
	end
end

slot0.CheckEventForMsg = function (slot0, slot1)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "EventMediator") and getProxy(EventProxy).eventForMsg
end

slot0.CheckMarkOverallClose = function (slot0)
	if slot0.svMarkOverall:isShowing() then
		slot0:HideSubView("MarkOverall")

		return true
	else
		return false
	end
end

slot0.OpenPortLayer = function (slot0, slot1)
	slot0:Op("OpOpenLayer", Context.New({
		mediator = WorldPortMediator,
		viewComponent = WorldPortLayer,
		data = slot1
	}))
end

slot0.ShowTransportMarkOverall = function (slot0, slot1, slot2)
	if nowWorld:GetActiveMap():CheckFleetSalvage(true) then
		slot0:Op("OpShowMarkOverall", slot1, function ()
			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_special.description[1], pg.NewStoryMgr.GetInstance().Play, true)
		end)
	else
		slot0.Op(slot0, "OpShowMarkOverall", slot1, slot2)
	end
end

slot0.UpdateAutoFightDisplay = function (slot0)
	slot0:ClearMoveQueue()

	slot1 = nowWorld.isAutoFight

	if slot0.wsMapRight then
		setActive(slot0.wsMapRight.toggleAutoFight:Find("off"), not slot1)
		setActive(slot0.wsMapRight.toggleAutoFight:Find("on"), slot1)
		setActive(slot0.wsMapRight.toggleSkipPrecombat, not slot1)
	end
end

slot0.GuideShowScannerEvent = function (slot0, slot1)
	slot8, slot9 = slot0:CheckScannerEnable(slot0.wsMap.map:FindAttachments(WorldMapAttachment.TypeEvent, slot1)[1].row, slot0.wsMap.map.FindAttachments(WorldMapAttachment.TypeEvent, slot1)[1].column)

	slot0.svScannerPanel:ActionInvoke("DisplayWindow", slot3, slot4)
end

slot0.DisplayAwards = function (slot0, slot1, slot2, slot3)
	slot4 = {}
	slot5 = {}

	for slot9, slot10 in ipairs(slot1) do
		if slot10.type == DROP_TYPE_WORLD_COLLECTION then
			table.insert(slot5, slot10)
		else
			table.insert(slot4, slot10)
		end
	end

	seriesAsync({
		function (slot0)
			if #slot0 == 0 then
				return slot0()
			end

			slot1.items = slot0
			slot1.removeFunc = slot0

			slot0:emit(BaseUI.ON_WORLD_ACHIEVE, slot0.emit)
		end,
		function (slot0)
			if not slot0[1] then
				slot0()

				return
			end

			slot1:emit(WorldMediator.OnOpenLayer, Context.New({
				mediator = WorldMediaCollectionFilePreviewMediator,
				viewComponent = WorldMediaCollectionFilePreviewLayer,
				data = {
					collectionId = slot1.id
				},
				onRemoved = slot0
			}))
		end
	}, slot3)
end

slot0.DisplayPhaseAction = function (slot0, slot1)
	function slot2(slot0)
		if table.remove(slot0, 1).anim then
			slot1:BuildCutInAnim(slot1.anim, slot0)
		elseif slot1.story then
			if nowWorld.isAutoFight then
				slot0()
			else
				pg.NewStoryMgr.GetInstance():Play(slot1.story, slot0, true)
			end
		elseif slot1.drops then
			if nowWorld.isAutoFight then
				nowWorld:AddAutoInfo("drops", slot1.drops)
				slot0()
			else
				slot1:DisplayAwards(slot1.drops, {}, slot0)
			end
		end
	end

	slot3 = {}

	for slot7 = 1, #slot1, 1 do
		table.insert(slot3, slot2)
	end

	seriesAsync(slot3, function ()
		slot0:Op("OpInteractive")
	end)
end

slot0.GetDepth = function (slot0)
	return #slot0.wsCommands
end

slot0.GetCommand = function (slot0, slot1)
	return slot0.wsCommands[slot1 or slot0:GetDepth()]
end

slot0.Op = function (slot0, slot1, ...)
	slot0:GetCommand():Op(slot1, ...)
end

slot0.OpPush = function (slot0, slot1, ...)
	slot0:GetCommand():OpPush(slot1, ...)
end

slot0.OpOpen = function (slot0)
	WorldConst.Print("open operation stack: " .. slot0:GetDepth() + 1)
	table.insert(slot0.wsCommands, WSCommand.New(slot0.GetDepth() + 1))
end

slot0.OpClose = function (slot0)
	slot1 = slot0:GetDepth()

	WorldConst.Print("close operation stack: " .. slot1)
	slot0.wsCommands[slot1].Dispose(slot2)
	table.remove(slot0.wsCommands, slot1)
end

slot0.OpClear = function (slot0)
	for slot4, slot5 in ipairs(slot0.wsCommands) do
		slot5:OpClear()
	end
end

slot0.OpDispose = function (slot0)
	for slot4, slot5 in ipairs(slot0.wsCommands) do
		slot5:Dispose()
	end

	slot0.wsCommands = nil
end

slot0.NewMapOp = function (slot0, slot1)
	WBank:Fetch(WorldMapOp).depth = slot0:GetDepth()

	for slot6, slot7 in pairs(slot1) do
		slot2[slot6] = slot7
	end

	return slot2
end

slot0.RegistMapOp = function (slot0, slot1)
	table.insert(slot0.mapOps, slot1)
	slot1:AddCallbackWhenApplied(function ()
		for slot3 = #slot0.mapOps, 1, -1 do
			if slot0.mapOps[slot3] == slot1 then
				table.remove(slot0.mapOps, slot3)
			end
		end
	end)
end

slot0.VerifyMapOp = function (slot0)
	for slot4 = #slot0.mapOps, 1, -1 do
		if not table.remove(slot0.mapOps, slot4).applied then
			slot5:Apply()
		end
	end

	slot0:OpClear()
end

slot0.GetCompassGridPos = function (slot0, slot1, slot2, slot3)
	WorldGuider.GetInstance():SetTempGridPos(slot0.wsMapRight.wsCompass:GetMarkPosition(slot1, slot2), slot3)
end

slot0.GetEntranceTrackMark = function (slot0, slot1, slot2)
	WorldGuider.GetInstance():SetTempGridPos(slot0.wsMapRight.wsCompass:GetEntranceTrackMark(slot1), slot2)
end

slot0.GetSlgTilePos = function (slot0, slot1, slot2, slot3)
	WorldGuider.GetInstance():SetTempGridPos2(slot0.wsMap:GetCell(slot1, slot2):GetWorldPos(), slot3)
end

slot0.GetScannerPos = function (slot0, slot1)
	WorldGuider.GetInstance():SetTempGridPos(slot0.svScannerPanel.rtPanel.transform.TransformPoint(slot2, slot4), slot1)
end

slot0.GuideSelectModelMap = function (slot0, slot1)
	slot0:ClickAtlas(nowWorld:GetEntrance(slot1))
end

return slot0

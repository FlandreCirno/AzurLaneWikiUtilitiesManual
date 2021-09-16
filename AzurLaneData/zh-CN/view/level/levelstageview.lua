slot0 = class("LevelStageView", import("..base.BaseSubView"))

slot0.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)
	slot0:bind(LevelUIConst.ON_FROZEN, function ()
		slot0.isFrozen = true
	end)
	slot0.bind(slot0, LevelUIConst.ON_UNFROZEN, function ()
		slot0.isFrozen = nil
	end)
end

slot0.getUIName = function (slot0)
	return "LevelStageView"
end

slot0.OnInit = function (slot0)
	slot0:InitUI()
	slot0:AddListener()

	slot0.loader = AutoLoader.New()

	setActive(slot0._tf, true)
end

slot0.OnDestroy = function (slot0)
	if slot0.stageTimer then
		slot0.stageTimer:Stop()

		slot0.stageTimer = nil
	end

	if slot0.resPanel1 then
		slot0.resPanel1:exit()

		slot0.resPanel1 = nil
	end

	if not IsNil(slot0.winCondPanel) then
		slot0.winCondPanel:Destroy()

		slot0.winCondPanel = nil
	end

	if not IsNil(slot0.combomsg) then
		Destroy(slot0.combomsg)

		slot0.combomsg = nil

		if slot0.comboAnimId then
			LeanTween.cancel(slot0.comboAnimId)

			slot0.comboAnimId = nil
		end
	end

	slot0:ClearSubViews()
	slot0:DestroyAutoFightPanel()
	slot0.loader:Clear()
end

slot1 = -300

slot0.InitUI = function (slot0)
	slot0.topStage = slot0:findTF("top_stage", slot0._tf)
	slot0.resStage = slot0:findTF("resources", slot0.topStage)
	slot0.resPanel1 = PlayerResource.New()

	slot0.resPanel1:setParent(slot0.resStage, false)
	setActive(slot0.topStage, true)

	slot0.bottomStage = slot0:findTF("bottom_stage", slot0._tf)
	slot0.normalRole = findTF(slot0.bottomStage, "normal")
	slot0.funcBtn = slot0:findTF("func_button", slot0.normalRole)
	slot0.retreatBtn = slot0:findTF("retreat_button", slot0.normalRole)
	slot0.switchBtn = slot0:findTF("switch_button", slot0.normalRole)
	slot0.helpBtn = slot0:findTF("help_button", slot0.normalRole)
	slot0.shengfuBtn = slot0:findTF("shengfu/shengfu_button", slot0.normalRole)
	slot0.teleportSubRole = findTF(slot0.bottomStage, "teleportSub")
	slot0.deployBtn = slot0:findTF("confirm_button", slot0.teleportSubRole)
	slot0.undeployBtn = slot0:findTF("cancel_button", slot0.teleportSubRole)

	setActive(slot0.bottomStage, true)
	setAnchoredPosition(slot0.normalRole, {
		x = 0,
		y = 0
	})
	setAnchoredPosition(slot0.teleportSubRole, {
		x = 0,
		y = slot0
	})
	setActive(slot0.teleportSubRole, false)

	slot0.leftStage = slot0:findTF("left_stage", slot0._tf)

	setActive(slot0.leftStage, true)

	slot0.rightStage = slot0:findTF("right_stage", slot0._tf)
	slot0.bombPanel = slot0.rightStage:Find("bomb_panel")
	slot0.panelBarrier = slot0:findTF("panel_barrier", slot0.rightStage)
	slot0.strategyPanelAnimator = slot0:findTF("event", slot0.rightStage):GetComponent(typeof(Animator))
	slot0.autoBattleBtn = slot0:findTF("event/collapse/lock_fleet", slot0.rightStage)
	slot0.showDetailBtn = slot0:findTF("event/detail/show_detail", slot0.rightStage)

	setActive(slot0.panelBarrier, false)
	setActive(slot0.rightStage, true)

	slot0.airSupremacy = slot0:findTF("msg_panel/air_supremacy", slot0.topStage)

	setAnchoredPosition(slot0.topStage, {
		y = slot0.topStage.rect.height
	})
	setAnchoredPosition(slot0.leftStage, {
		x = -slot0.leftStage.rect.width - 200
	})
	setAnchoredPosition(slot0.rightStage, {
		x = slot0.rightStage.rect.width + 200
	})
	setAnchoredPosition(slot0.bottomStage, {
		y = -slot0.bottomStage.rect.height
	})

	slot0.attachSubViews = {}
end

slot0.AddListener = function (slot0)
	slot0:bind(LevelUIConst.TRIGGER_ACTION, function ()
		slot0:tryAutoTrigger()
	end)
	slot0.bind(slot0, LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, function (slot0, slot1)
		slot0.strategyPanelAnimator:SetBool("IsActive", slot1)

		slot0.bottomStageInactive = slot1

		slot0:ShiftBottomStage(not slot1)
	end)
	onButton(slot0, slot0:findTF("option", slot0.topStage), function ()
		slot0:emit(BaseUI.ON_HOME)
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("back_button", slot0.topStage), function ()
		slot0:emit(LevelUIConst.SWITCH_TO_MAP)
	end, SFX_CANCEL)
	onButton(slot0, slot0.retreatBtn, function ()
		slot1 = slot0.contextData.map
		slot2 = "levelScene_whether_to_retreat"
		slot3 = nil

		if slot0.contextData.chapterVO:existOni() then
			slot2 = "levelScene_oni_retreat"
		elseif slot0:isPlayingWithBombEnemy() then
			slot2 = "levelScene_bomb_retreat"
		elseif slot0:getPlayType() == ChapterConst.TypeTransport and not slot1:isSkirmish() then
			slot2 = "levelScene_escort_retreat"
		elseif slot1:isRemaster() then
			slot2 = "archives_whether_to_retreat"
		end

		slot0:HandleShowMsgBox({
			content = i18n(slot2),
			onYes = ChapterOpCommand.PrepareChapterRetreat
		})
	end, SFX_UI_WEIGHANCHOR_WITHDRAW)
	onButton(slot0, slot0.switchBtn, function ()
		if slot0.contextData.chapterVO.getNextValidIndex(slot0) > 0 then
			slot0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpSwitch,
				id = slot0.fleets[slot1].id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_failed"))
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.autoBattleBtn, function ()
		slot0 = getProxy(ChapterProxy)

		slot0:UpdateSkipPrecombat(not slot0:GetSkipPrecombat())
	end, SFX_PANEL)
	onButton(slot0, slot0.showDetailBtn, function ()
		slot0._showStrategyDetail = not slot0._showStrategyDetail and true

		slot0:updateStageStrategy()
	end, SFX_PANEL)
	onButton(slot0, slot0.funcBtn, function ()
		if not slot0.contextData.chapterVO:inWartime() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_time_out"))

			return
		end

		slot3 = slot0:getChapterCell(slot0.fleet.line.row, slot0.fleet.line.column)
		slot4 = false

		if slot0:existChampion(slot0.fleet.line.row, slot0.fleet.line.column) then
			slot4 = true

			if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
				slot0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSkipBattle,
					id = slot1.id
				})
			elseif slot0:IsSkipPrecombat() then
				slot0:emit(LevelMediator2.ON_START)
			else
				slot0:emit(LevelMediator2.ON_STAGE)
			end
		elseif slot3.attachment == ChapterConst.AttachAmbush and slot3.flag == ChapterConst.CellFlagAmbush then
			slot5 = nil
			slot6 = coroutine.wrap(function ()
				slot0:emit(LevelUIConst.DO_AMBUSH_WARNING, slot0)
				coroutine.yield()
				coroutine.yield:emit(LevelUIConst.DISPLAY_AMBUSH_INFO, coroutine.yield)
				coroutine.yield()
			end)

			slot6()

			slot4 = true
		elseif slot3.attachment == ChapterConst.AttachEnemy or slot3.attachment == ChapterConst.AttachElite or slot3.attachment == ChapterConst.AttachAmbush or slot3.attachment == ChapterConst.AttachBoss then
			if slot3.flag == ChapterConst.CellFlagActive then
				slot4 = true

				if chapter_skip_battle == 1 and pg.SdkMgr.GetInstance():CheckPretest() then
					slot0:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpSkipBattle,
						id = slot1.id
					})
				elseif slot0:IsSkipPrecombat() then
					slot0:emit(LevelMediator2.ON_START)
				else
					slot0:emit(LevelMediator2.ON_STAGE)
				end
			end
		elseif slot3.attachment == ChapterConst.AttachBox then
			if slot3.flag == ChapterConst.CellFlagActive then
				slot4 = true

				slot0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpBox,
					id = slot1.id
				})
			end
		elseif slot3.attachment == ChapterConst.AttachSupply and slot3.attachmentId > 0 then
			slot4 = true
			slot5, slot6 = slot0:getFleetAmmo(slot0.fleet)

			if slot6 < slot5 then
				slot0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSupply,
					id = slot1.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_enough"))
			end
		elseif slot3.attachment == ChapterConst.AttachStory then
			slot4 = true
			slot6 = pg.map_event_template[slot3.attachmentId].gametip

			if pg.map_event_template[slot3.attachmentId].memory == 0 then
				return
			end

			pg.ConnectionMgr.GetInstance():Send(11017, {
				story_id = slot5
			}, 11018, function (slot0)
				return
			end)
			pg.NewStoryMgr.GetInstance().Play(slot8, pg.NewStoryMgr.GetInstance():StoryId2StoryName(slot5), function (slot0, slot1)
				slot3 = slot1 or 1

				if slot0.flag == ChapterConst.CellFlagActive then
					slot1:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpStory,
						id = slot2.id,
						arg1 = slot3
					})
				end

				if slot3 ~= "" then
					slot4 = nil

					for slot8, slot9 in pairs(pg.memory_template) do
						if slot9.story == slot4 then
							slot4 = slot9.title
						end
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n(slot3, slot4))
				end
			end)
		end

		if not slot4 then
			if slot0.getRound(slot0) == ChapterConst.RoundEnemy then
				slot0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpEnemyRound
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_click_to_move"))
			end
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		if slot0.contextData.chapterVO then
			if slot0:existOni() then
				slot0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_sphunt_help_tip")
				})
			elseif slot0:isTypeDefence() then
				slot0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("help_battle_defense")
				})
			elseif slot0:isPlayingWithBombEnemy() then
				slot0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = i18n("levelScene_bomb_help_tip")
				})
			elseif pg.map_event_list[slot0.id] and pg.map_event_list[slot0.id].help_pictures and next(pg.map_event_list[slot0.id].help_pictures) ~= nil then
				slot1 = {
					disableScroll = true,
					pageMode = true,
					ImageMode = true,
					defaultpage = 1,
					windowSize = {
						x = 1263,
						y = 873
					},
					windowPos = {
						y = -70
					},
					helpSize = {
						x = 1176,
						y = 1024
					}
				}

				for slot5, slot6 in pairs(pg.map_event_list[slot0.id].help_pictures) do
					table.insert(slot1, {
						icon = {
							path = "",
							atlas = slot6
						}
					})
				end

				slot0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = slot1
				})
			else
				slot0:HandleShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = pg.gametip.help_level_ui.tip
				})
			end
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.airSupremacy, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_ac")
		})
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.deployBtn, function ()
		slot1, slot2 = slot0.contextData.chapterVO.GetSubmarineFleet(slot0)
		slot3 = slot1.startPos

		if not slot0.grid.subTeleportTargetLine then
			return
		end

		slot5, slot6 = slot0:findPath(nil, slot3, slot4)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tips_confirm_teleport_sub", slot0.grid:TransformLine2PlanePos(slot3), slot0.grid:TransformLine2PlanePos(slot4), slot5, math.ceil(pg.strategy_data_template[ChapterConst.StrategySubTeleport].arg[2] * #slot1:getShips(false) * slot5 - 1e-05)),
			onYes = function ()
				slot0:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpSubTeleport,
					id = slot1.id,
					arg1 = slot2.row,
					arg2 = slot2.column
				})
			end
		})
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.undeployBtn, function ()
		slot0:SwitchBottomStage(false)
		slot0.SwitchBottomStage.grid:TurnOffSubTeleport()
		slot0.SwitchBottomStage.grid.TurnOffSubTeleport.grid:updateQuadCells(ChapterConst.QuadStateNormal)
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.shengfuBtn, function ()
		slot0:DisplayWinConditionPanel()
	end)
end

slot0.SetSeriesOperation = function (slot0, slot1)
	slot0.seriesOperation = slot1
end

slot0.SetGrid = function (slot0, slot1)
	slot0.grid = slot1
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.resPanel1:setResources(slot1)
end

slot0.SwitchToChapter = function (slot0, slot1)
	slot3 = findTF(slot0.rightStage, "target")
	slot4 = findTF(slot0.rightStage, "skip_events")

	setActive(slot2, slot1:existAmbush())
	setActive(slot0.airSupremacy, OPEN_AIR_DOMINANCE and slot1:getConfig("air_dominance") > 0)
	setActive(slot0.autoBattleBtn, slot1:isLoop())

	if slot1.isLoop() then
		slot0:UpdateSkipPreCombatMark()
		slot0:UpdateAutoFightPanel()
		slot0:UpdateAutoFightMark()
	end

	slot0.achieveOriginalY = -240

	setText(slot4:Find("Label"), i18n("map_event_skip"))

	slot6 = "skip_events_on_" .. slot1.id

	if slot1:getConfig("event_skip") == 1 then
		if slot1.progress > 0 or slot1.defeatCount > 0 or slot1.passCount > 0 then
			setActive(slot4, true)

			slot3.anchoredPosition = Vector2.New(slot3.anchoredPosition.x, slot0.achieveOriginalY - 40)
			GetComponent(slot4, typeof(Toggle)).isOn = PlayerPrefs.GetInt(slot6, 1) == 1

			onToggle(slot0, slot4, function (slot0)
				PlayerPrefs.SetInt(slot0, (slot0 and 1) or 0)
			end)
		else
			setActive(slot4, false)

			if not PlayerPrefs.HasKey(slot6) then
				PlayerPrefs.SetInt(slot6, 0)
			end
		end
	else
		setActive(slot4, false)

		slot3.anchoredPosition = Vector2.New(slot3.anchoredPosition.x, slot0.achieveOriginalY)
	end

	setActive(slot3, slot1:existAchieve())
	setActive(slot0.retreatBtn, true)
	slot0.seriesOperation()
end

slot0.SwitchToMap = function (slot0)
	slot0:DestroyAutoFightPanel()
end

slot0.UpdateSkipPreCombatMark = function (slot0)
	slot0.loader:GetOffSpriteRequest(slot0.autoBattleBtn)
	slot0.loader:GetSprite("ui/levelstageview_atlas", (getProxy(ChapterProxy):GetSkipPrecombat() and "auto_battle_on") or "auto_battle_off", slot0.autoBattleBtn, true)
end

slot0.updateStageInfo = function (slot0)
	slot1 = slot0.contextData.chapterVO
	slot3 = findTF(slot0.topStage, "unlimit")

	setWidgetText(findTF(slot0.topStage, "timer"), "--:--:--")

	if slot0.stageTimer then
		slot0.stageTimer:Stop()
	end

	if slot1:getConfig("time") < slot1:getRemainTime() or slot1:getConfig("time") >= 8640000 then
		setActive(slot2, false)
		setActive(slot3, true)
	else
		setActive(slot2, true)
		setActive(slot3, false)

		slot0.stageTimer = Timer.New(function ()
			if IsNil(IsNil) then
				return
			end

			setWidgetText(slot1:getRemainTime(), pg.TimeMgr.GetInstance():DescCDTime(slot1.getRemainTime()))
		end, 1, -1)

		slot0.stageTimer.Start(slot4)
		slot0.stageTimer.func()
	end
end

slot0.updateAmbushRate = function (slot0, slot1, slot2)
	if not slot0.contextData.chapterVO:existAmbush() then
		return
	end

	slot9 = findTF(slot0.topStage, "msg_panel/ambush/value2")

	setText(slot6, i18n("level_scene_title_word_1"))
	setText(slot8, math.floor(slot5))
	setText(findTF(slot0.topStage, "msg_panel/ambush/label2"), i18n("level_scene_title_word_2"))

	if not slot3.activateAmbush then
		setText(slot9, i18n("ambush_display_none"))
		setTextColor(slot9, Color.New(0.4, 0.4, 0.4))
	else
		setText(slot9, ChapterConst.GetAmbushDisplay)
		setTextColor(slot9, (not slot2 or not slot3:existEnemy(ChapterConst.SubjectPlayer, slot1.row, slot1.column)) and slot3:getAmbushRate(slot4, slot1))
	end
end

slot0.updateStageAchieve = function (slot0)
	if not slot0.contextData.chapterVO:existAchieve() then
		return
	end

	slot3 = findTF(slot0.rightStage, "target")

	setActive(slot3, true)

	slot4 = findTF(slot3, "detail")
	slot7 = findTF(slot4, "click")

	setActive(slot5, false)
	setActive(slot9, false)
	removeAllChildren(slot6)
	removeAllChildren(slot10)

	for slot14, slot15 in ipairs(slot2) do
		setActive(findTF(slot16, "star"), slot17)
		setText(slot18, ChapterConst.GetAchieveDesc(slot15.type, slot1))
		setTextColor(findTF(slot16, "desc"), (ChapterConst.IsAchieved(slot15) and Color.yellow) or Color.white)

		cloneTplTo(slot9, slot10):GetComponent(typeof(Image)).enabled = slot17
	end

	onButton(slot0, slot7, function ()
		shiftPanel(shiftPanel, slot0.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(shiftPanel, 0, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(slot0, slot8, function ()
		shiftPanel(shiftPanel, 30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(shiftPanel, slot1.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)

	if not slot0.isAchieveFirstInit then
		slot0.isAchieveFirstInit = true

		triggerButton(slot7)
	end
end

slot0.updateStageBarrier = function (slot0)
	setActive(slot0.panelBarrier, slot0.contextData.chapterVO:existOni())

	if slot0.contextData.chapterVO:existOni() then
		slot2 = slot0.panelBarrier:Find("btn_barrier")

		setText(slot2:Find("nums"), slot1.modelCount)
		onButton(slot0, slot2, function ()
			if slot0.grid.quadState == ChapterConst.QuadStateStrategy then
				slot0.grid:updateQuadCells(ChapterConst.QuadStateNormal)

				return
			end

			slot0:selectSquareBarrieredCell(1, function (slot0, slot1)
				if not slot0:existBarrier(slot0, slot1) and slot0.modelCount <= 0 then
					return
				end

				slot1:emit(LevelMediator2.ON_OP, {
					type = ChapterConst.OpBarrier,
					id = slot0.fleet.id,
					arg1 = slot0,
					arg2 = slot1
				})
			end)
		end, SFX_PANEL)
	end
end

slot0.updateBombPanel = function (slot0, slot1)
	setActive(slot0.bombPanel, slot0.contextData.chapterVO:isPlayingWithBombEnemy())

	if slot0.contextData.chapterVO:isPlayingWithBombEnemy() then
		setText(slot0.bombPanel:Find("tx_step"), slot2:getBombChapterInfo().action_times - math.floor(slot2.roundIndex / 2))

		slot4 = tonumber(getText(slot3))
		slot5 = slot2.modelCount

		LeanTween.cancel(go(slot0.bombPanel:Find("tx_score")))

		if slot1 and slot4 ~= slot5 then
			LeanTween.scale(go(slot3), Vector3(1.5, 1.5, 1), 0.2)
			LeanTween.value(go(slot3), slot4, slot5, (slot5 - slot4) * 0.1):setOnUpdate(System.Action_float(function (slot0)
				setText(slot0, math.floor(slot0))
			end)).setOnComplete(slot7, System.Action(function ()
				setText(setText, )
			end)).setEase(slot7, LeanTweenType.easeInOutSine):setDelay(0.2)
			LeanTween.scale(go(slot3), Vector3.one, 0.3):setDelay(1 + (slot5 - slot4) * 0.1)
		else
			slot3.localScale = Vector3.one

			setText(slot3, slot5)
		end
	end
end

slot0.selectSquareBarrieredCell = function (slot0, slot1, slot2)
	slot0.grid:updateQuadCells(ChapterConst.QuadStateStrategy, slot0.contextData.chapterVO.calcSquareBarrierCells(slot3, slot0.contextData.chapterVO.fleet.line.row, slot0.contextData.chapterVO.fleet.line.column, slot1), function (slot0)
		if slot0 and _.any(slot0, function (slot0)
			return slot0.row == slot0.row and slot0.column == slot0.column
		end) then
			slot1(slot0.row, slot0.column)
		else
			slot2.grid.updateQuadCells(slot1, ChapterConst.QuadStateNormal)
		end
	end)
end

slot0.updateFleetBuff = function (slot0)
	slot2 = slot0.contextData.chapterVO.fleet
	slot3 = slot0.contextData.chapterVO.GetShowingStartegies(slot1)
	slot4 = {}

	if slot0.contextData.chapterVO:GetSubmarineFleet() and _.filter(slot5:getStrategies(), function (slot0)
		return pg.strategy_data_template[slot0.id].type == ChapterConst.StgTypePassive and slot0.count > 0
	end) and #slot6 > 0 then
		_.each(slot6, function (slot0)
			table.insert(slot0, {
				id = slot0.id,
				count = slot0.count
			})
		end)
	end

	slot6 = nil
	slot7 = 0

	if slot1.ExistDivingChampion(slot1) then
		slot6 = {
			icon = "submarine_approach"
		}
		slot7 = 1
	end

	setActive(slot10, false)

	slot11 = UIItemList.New(slot9, slot10)

	slot11:make(function (slot0, slot1, slot2)
		setActive(findTF(slot2, "frame"), false)
		setActive(findTF(slot2, "Text"), false)
		setActive(findTF(slot2, "times"), false)

		if slot0 == UIItemList.EventUpdate then
			if slot1 + 1 <= #slot0 then
				GetImageSpriteFromAtlasAsync("strategyicon/" .. pg.strategy_data_template[slot0[slot1 + 1]].icon, "", slot2)
				onButton(slot1, slot2, function ()
					slot0:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = slot1.id,
							cfg = slot0
						}
					})
				end, SFX_PANEL)

				return
			end

			if slot1 + 1 <= #slot0 + #slot2 then
				GetImageSpriteFromAtlasAsync("strategyicon/" .. pg.strategy_data_template[slot2[(slot1 + 1) - #slot0].id].icon, "", slot2)
				setActive(findTF(slot2, "times"), true)
				setText(findTF(slot2, "times"), slot2[(slot1 + 1) - #slot0].count)
				onButton(slot1, slot2, function ()
					slot0:HandleShowMsgBox({
						hideNo = true,
						content = "",
						yesText = "text_confirm",
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_STRATEGY,
							id = slot1.id,
							cfg = slot1
						},
						extendDesc = string.format(i18n("word_rest_times"), slot2.count)
					})
				end, SFX_PANEL)
			elseif slot1 + 1 <= #slot0 + #slot2 + slot1 + 1 then
				GetImageSpriteFromAtlasAsync("strategyicon/" .. slot4.icon, "", slot2)

				slot3 = slot2:GetComponent(typeof(Image))

				onButton(slot1, slot2, function ()
					slot0:HandleShowMsgBox({
						hideNo = true,
						yesText = "text_confirm",
						type = MSGBOX_TYPE_DROP_ITEM,
						name = i18n("submarine_approach"),
						content = i18n("submarine_approach_desc"),
						sprite = slot1.sprite
					})
				end, SFX_PANEL)
			else
				GetImageSpriteFromAtlasAsync("commanderskillicon/" .. slot5[(slot1 + 1) - #slot0 - #slot2 - slot5].getConfig(slot3, "icon"), "", slot2)
				setText(findTF(slot2, "Text"), "Lv." .. slot5[(slot1 + 1) - #slot0 - #slot2 - slot5].getConfig(slot3, "lv"))
				setActive(findTF(slot2, "Text"), true)
				setActive(findTF(slot2, "frame"), true)
				onButton(slot1, slot2, function ()
					slot0:emit(LevelMediator2.ON_COMMANDER_SKILL, slot0)
				end, SFX_PANEL)
			end
		end
	end)
	slot11.align(slot11, #slot3 + #slot4 + slot7 + #_.map(_.values(slot2:getCommanders()), function (slot0)
		return slot0:getSkills()[1]
	end))

	if OPEN_AIR_DOMINANCE and slot1:getConfig("air_dominance") > 0 then
		slot0:updateAirDominance()
	end

	slot0:updateChapterBuff()
end

slot0.updateChapterBuff = function (slot0)
	SetActive(findTF(slot0.topStage, "chapter_buff"), slot0.contextData.chapterVO.hasMitigation(slot1))

	if slot0.contextData.chapterVO.hasMitigation(slot1) then
		GetImageSpriteFromAtlasAsync("passstate", slot4 .. "_icon", slot2)
		onButton(slot0, slot2, function ()
			if not slot0:hasMitigation() then
				return
			end

			slot1:HandleShowMsgBox({
				hideNo = true,
				type = MSGBOX_TYPE_DROP_ITEM,
				name = slot0:getChapterState(),
				sprite = getImageSprite(slot2),
				content = i18n("level_risk_level_mitigation_rate", slot0:getRemainPassCount(), slot0:getMitigationRate())
			})
		end, SFX_PANEL)
	end
end

slot0.updateAirDominance = function (slot0)
	slot1, slot2, slot3 = slot0.contextData.chapterVO:getAirDominanceValue()

	if not slot3 or slot3 ~= slot2 then
		slot0.contextData.chapterVO:setAirDominanceStatus(slot2)
		getProxy(ChapterProxy):updateChapter(slot0.contextData.chapterVO)
	end

	if slot3 then
		slot4 = (slot2 == 0 and 3) or slot2
		slot4 = slot4 - ((slot3 == 0 and 3) or slot3)
	end

	slot0.isChange = slot4

	slot0:updateAirDominanceTitle(slot1, slot2, slot0.isChange or 0)
end

slot0.updateAirDominanceTitle = function (slot0, slot1, slot2, slot3)
	slot7 = findTF(slot0.airSupremacy, "value2")

	setText(slot4, i18n("level_scene_title_word_3"))
	setText(slot5, i18n("level_scene_title_word_4"))
	setText(slot6, math.floor(slot1))
	setActive(slot8, false)
	setActive(findTF(slot0.airSupremacy, "down"), false)

	if slot3 ~= 0 then
		if LeanTween.isTweening(go(slot7)) then
			LeanTween.cancel(go(slot7))
		end

		LeanTween.value(go(slot7), 1, 0, 0.5):setOnUpdate(System.Action_float(function (slot0)
			setTextAlpha(slot0, slot0)
		end)).setOnComplete(slot10, System.Action(function ()
			setText(setText, ChapterConst.AirDominance[setText].name)
			setTextColor(setTextColor, ChapterConst.AirDominance[setTextColor].color)
			LeanTween.value(go(slot0), 0, 1, 0.5):setOnUpdate(System.Action_float(function (slot0)
				setTextAlpha(slot0, slot0)
			end))
		end))
		slot8.GetComponent(slot8, typeof(DftAniEvent)):SetEndEvent(slot10)
		slot9:GetComponent(typeof(DftAniEvent)):SetEndEvent(slot10)
		setActive(slot8, slot3 > 0)
		setActive(slot9, slot3 < 0)
	else
		setText(slot7, ChapterConst.AirDominance[slot2].name)
		setTextColor(slot7, ChapterConst.AirDominance[slot2].color)
	end
end

slot0.UpdateDefenseStatus = function (slot0)
	setActive(findTF(slot0.bottomStage, "normal/shengfu"), slot0.contextData.chapterVO.getPlayType(slot1) == ChapterConst.TypeDefence)

	if not (slot0.contextData.chapterVO.getPlayType(slot1) == ChapterConst.TypeDefence) then
		return
	end

	findTF(slot3, "hp"):GetComponent(typeof(Text)).text = i18n("desc_base_hp", "<color=#92FC63>" .. tostring(slot1.BaseHP) .. "</color>", pg.chapter_defense[slot1.id].port_hp)
end

slot0.DisplayWinConditionPanel = function (slot0)
	if IsNil(slot0.winCondPanel) then
		slot0.winCondPanel = WinConditionDisplayPanel.New(slot0._tf.parent, slot0._event, slot0.contextData)
		slot0.winCondPanel.ParentView = slot0

		slot0.winCondPanel:Load()
	end

	slot0.winCondPanel:ActionInvoke("Enter", slot0.contextData.chapterVO)
end

slot0.UpdateComboPanel = function (slot0)
	if pg.chapter_pop_template[slot0.contextData.chapterVO.id] and slot2.combo_on then
		slot3, slot4 = slot0:GetSubView("LevelStageComboPanel")

		if slot4 then
			slot3:Load()
			slot3.buffer:SetParent(slot0.leftStage, false)
		end

		slot3.buffer:UpdateView(getProxy(ChapterProxy):GetComboHistory(slot1.id) or slot1)
		slot3.buffer:UpdateViewAnimated(slot1)
	end
end

slot2 = {
	[777.0] = "LevelStageDOAFeverPanel",
	[4050.0] = "LevelStageIMasFeverPanel"
}

slot0.UpdateDOALinkFeverPanel = function (slot0)
	if slot0.contextData.chapterVO.getPlayType(slot1) ~= ChapterConst.TypeDOALink then
		return
	end

	slot4, slot5 = slot0:GetSubView(slot0[slot1:getConfig("act_id")])

	if slot5 then
		slot4:Load()
		slot4.buffer:SetParent(slot0._tf, false)
	end

	slot4.buffer:UpdateView(slot1, getProxy(ChapterProxy):GetLastDefeatedEnemy(slot1.id))
end

slot3 = Vector2(396, 128)
slot4 = Vector2(128, 128)

slot0.updateStageStrategy = function (slot0)
	slot2 = slot0.contextData.chapterVO.fleet
	findTF(slot4, "items").GetComponent(slot6, typeof(GridLayoutGroup)).cellSize = (slot0._showStrategyDetail and slot0) or slot1

	setActive((slot0._showStrategyDetail and slot0) or slot1, false)
	UIItemList.StaticAlign(slot6, (slot0._showStrategyDetail and slot0) or slot1, #slot1:GetActiveStrategies(), nil)
	onButton(slot0, findTF(slot4, "click"), function ()
		shiftPanel(shiftPanel, slot0.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(shiftPanel, -30, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
	onButton(slot0, findTF(slot3, "collapse"), function ()
		shiftPanel(shiftPanel, 35, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
		shiftPanel(shiftPanel, slot1.rect.width + 200, nil, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	end, SFX_PANEL)
end

slot0.GetSubView = function (slot0, slot1)
	if slot0.attachSubViews[slot1] then
		return slot0.attachSubViews[slot1]
	end

	slot0.attachSubViews[slot1] = _G[slot1].New(slot0)

	return _G[slot1].New(slot0), true
end

slot0.RemoveSubView = function (slot0, slot1)
	if not slot0.attachSubViews[slot1] then
		return false
	end

	slot0.attachSubViews[slot1]:Destroy()

	slot0.attachSubViews[slot1] = nil

	return true
end

slot0.ClearSubViews = function (slot0)
	for slot4, slot5 in pairs(slot0.attachSubViews) do
		slot5:Destroy()
	end

	table.clear(slot0.attachSubViews)
end

slot0.updateStageFleet = function (slot0)
	slot2 = findTF(slot0.leftStage, "fleet")

	setActive(slot3, false)
	setText(slot4, slot0.contextData.chapterVO.fleet.id)

	slot5 = slot0.contextData.chapterVO.fleet:getShips(true)

	slot6(slot2:Find("main"), slot0.contextData.chapterVO.fleet:getShipsByTeam(TeamType.Main, true))
	slot6(slot2:Find("vanguard"), slot0.contextData.chapterVO.fleet:getShipsByTeam(TeamType.Vanguard, true))
	slot0.contextData.chapterVO.fleet:clearShipHpChange()
end

slot0.ShiftStagePanelIn = function (slot0, slot1)
	shiftPanel(slot0.topStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine, slot1)
	slot0:ShiftBottomStage(true)
	shiftPanel(slot0.leftStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(slot0.rightStage, 0, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

slot0.ShiftStagePanelOut = function (slot0, slot1)
	shiftPanel(slot0.topStage, 0, slot0.topStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine, slot1)
	slot0:ShiftBottomStage(false)
	shiftPanel(slot0.leftStage, -slot0.leftStage.rect.width - 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
	shiftPanel(slot0.rightStage, slot0.rightStage.rect.width + 200, 0, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

slot0.ShiftBottomStage = function (slot0, slot1)
	if not slot0.bottomStageInactive then
	else
		slot1 = false
		slot1 = true
	end

	shiftPanel(slot0.bottomStage, 0, (not slot1 or 0) and -slot0.bottomStage.rect.height, 0.3, 0, true, nil, LeanTweenType.easeOutSine)
end

slot0.SwitchBottomStage = function (slot0, slot1)
	setActive(slot0.teleportSubRole, true)
	setActive(slot0.normalRole, true)
	shiftPanel(slot0.teleportSubRole, 0, (not slot1 or 0) and slot0, 0.3, 0, true, true, nil, function ()
		setActive(slot0.teleportSubRole, )
	end)
	shiftPanel(slot0.normalRole, 0, (slot1 and slot0) or 0, 0.3, 0, true, true, nil, function ()
		setActive(slot0.normalRole, not slot1)
	end)
	shiftPanel(slot0.leftStage, (slot1 and -slot0.leftStage.rect.width - 200) or 0, 0, 0.3, 0, true)
	shiftPanel(slot0.rightStage, (slot1 and slot0.rightStage.rect.width + 200) or 0, 0, 0.3, 0, true)
end

slot0.clickGridCell = function (slot0, slot1)
	slot3 = slot0.contextData.chapterVO.fleet

	if _.detect(slot0.contextData.chapterVO.fleets, function (slot0)
		return slot0:getFleetType() == FleetType.Normal and slot0.line.row == slot0.row and slot0.line.column == slot0.column
	end) and slot4.isValid(slot4) and slot4.id ~= slot3.id then
		slot0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = slot4.id
		})

		return
	end

	if slot2:checkAnyInteractive() then
		triggerButton(slot0.funcBtn)
	elseif slot2:getRound() == ChapterConst.RoundEnemy then
		slot0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpEnemyRound
		})
	elseif slot2:IsAutoFight() then
		slot0:TryAutoFight()
	elseif slot1.row ~= slot3.line.row or slot1.column ~= slot3.line.column then
		if slot2:getChapterCell(slot1.row, slot1.column).attachment == ChapterConst.AttachStory and slot6.data == ChapterConst.StoryObstacle and slot6.flag == ChapterConst.CellFlagTriggerActive then
			if pg.map_event_template[slot6.attachmentId] and slot7.gametip and #slot7.gametip > 0 and slot2:getPlayType() ~= ChapterConst.TypeDefence then
				pg.TipsMgr.GetInstance():ShowTips(i18n(slot7.gametip))
			end

			return
		elseif not slot2:considerAsStayPoint(ChapterConst.SubjectPlayer, slot1.row, slot1.column) then
			return
		elseif slot2:existMoveLimit() and not _.any(slot2:calcWalkableCells(ChapterConst.SubjectPlayer, slot3.line.row, slot3.line.column, slot3:getSpeed()), function (slot0)
			return slot0.row == slot0.row and slot0.column == slot0.column
		end) then
			pg.TipsMgr.GetInstance().ShowTips(slot8, i18n("destination_not_in_range"))

			return
		end

		if slot2:findPath(ChapterConst.SubjectPlayer, slot3.line, {
			row = slot1.row,
			column = slot1.column
		}) < PathFinding.PrioObstacle then
			slot0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpMove,
				id = slot3.id,
				arg1 = slot1.row,
				arg2 = slot1.column
			})
		elseif slot7 < PathFinding.PrioForbidden then
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
		end
	end
end

slot0.tryAutoAction = function (slot0, slot1)
	if slot0.doingAutoAction then
		return
	end

	slot0.doingAutoAction = true

	if not slot0.contextData.chapterVO then
		if slot1 then
			slot1()
		end

		return
	end

	if slot0:SafeCheck() then
		if slot1 then
			slot1()
		end

		return
	end

	slot4 = false

	for slot8, slot9 in pairs(slot2.cells) do
		if slot9.trait == ChapterConst.TraitLurk then
			slot4 = true

			break
		end
	end

	for slot8, slot9 in ipairs(slot2.champions) do
		if slot9.trait == ChapterConst.TraitLurk then
			slot4 = true

			break
		end
	end

	slot5 = slot2:existOni()
	slot6 = slot2:isPlayingWithBombEnemy()

	seriesAsync({
		function (slot0)
			slot0:emit(LevelUIConst.FROZEN)

			if not slot0.emit then
				slot0()
			elseif slot2 or slot3 then
				slot1 = nil

				if slot2 then
					slot1 = "SpUnit"
				end

				if slot3 then
					slot1 = "SpBomb"
				end

				if slot1 then
					slot0.emit(slot3, LevelUIConst.DO_PLAY_ANIM, {
						name = slot1,
						callback = function (slot0)
							setActive(slot0, false)
							slot0()
						end
					})
				end
			else
				slot0:emit(LevelUIConst.DO_TRACKING, slot0)
			end
		end,
		function (slot0)
			if slot0 and (slot1 or slot2) and slot3:getSpAppearStory() and #slot1 > 0 then
				pg.NewStoryMgr.GetInstance():Play(slot1, slot0)

				return
			end

			slot0()
		end,
		function (slot0)
			if slot0 and (slot1 or slot2) and slot3:getSpAppearGuide() and #slot1 > 0 then
				pg.SystemGuideMgr.GetInstance():PlayByGuideId(slot1, nil, function ()
					onNextTick(onNextTick)
				end)

				return
			end

			slot0()
		end,
		function (slot0)
			if not slot0 then
				return slot0()
			end

			parallelAsync({
				function (slot0)
					slot0:tryPlayChapterStory(slot0)
				end,
				function (slot0)
					if slot0:findChapterCell(ChapterConst.AttachBoss) and slot1.trait == ChapterConst.TraitLurk then
						slot1.grid:focusOnCell(slot1, slot0)

						return
					end

					slot0()
				end
			}, slot0)
		end,
		function (slot0)
			slot1, slot2 = slot0:GetAttachmentStories()

			if slot1 then
				table.eachAsync(slot1, function (slot0, slot1, slot2)
					if slot0 <= slot0 and slot1 then
						ChapterOpCommand.PlayChapterStory(pg.NewStoryMgr:StoryId2StoryName(tonumber(slot1)), slot2, slot1:IsAutoFight())
					else
						slot2()
					end
				end, slot0)

				return
			end

			slot0()
		end,
		function (slot0)
			if slot0 then
				slot1:updateTrait(ChapterConst.TraitVirgin)
				slot1.updateTrait.grid:updateAttachments()
				slot1.updateTrait.grid.updateAttachments.grid:updateChampions()
				slot1.updateTrait.grid.updateAttachments.grid.updateChampions:updateTrait(ChapterConst.TraitNone)
				slot1.updateTrait.grid.updateAttachments.grid.updateChampions.updateTrait:emit(LevelMediator2.ON_OVERRIDE_CHAPTER)
			end

			Timer.New(slot0, 0.5, 1):Start()
		end,
		function (slot0)
			if slot0.exited then
				return
			end

			slot0:emit(LevelUIConst.UN_FROZEN)
			slot0()
		end,
		function (slot0)
			if slot0.exited then
				return
			end

			if slot1 then
				slot1()
			end

			slot0.doingAutoAction = nil

			if nil then
				slot0:TryEnterChapterStoryStage()
			end
		end
	})
end

slot0.tryPlayChapterStory = function (slot0, slot1)
	slot3 = slot0.contextData.chapterVO.getWaveCount(slot2)

	seriesAsync({
		function (slot0)
			pg.SystemGuideMgr.GetInstance():PlayChapter(slot0, slot0)
		end,
		function (slot0)
			if slot0:getConfig("story_refresh") and slot1[slot1] and slot2 ~= "" and type(slot2) == "string" then
				ChapterOpCommand.PlayChapterStory(slot2, slot0, slot0:IsAutoFight())

				return
			end

			slot0()
		end,
		function (slot0)
			if slot0:getConfig("story_refresh_boss") and slot1 ~= "" and type(slot1) == "string" and slot0:bossRefreshed() then
				ChapterOpCommand.PlayChapterStory(slot1, slot0, slot0:IsAutoFight())

				return
			end

			slot0()
		end,
		function (slot0)
			if slot0 == 1 and pg.map_event_list[slot1.id] and pg.map_event_list[slot1.id].help_open == 1 and PlayerPrefs.GetInt("help_displayed_on_" .. slot1.id, 0) == 0 then
				triggerButton(slot2.helpBtn)
				PlayerPrefs.SetInt("help_displayed_on_" .. slot1.id, 1)
			end

			slot0()
		end,
		function ()
			existCall(existCall)
		end
	})
end

slot0.TryEnterChapterStoryStage = function (slot0)
	slot2 = slot0.contextData.chapterVO.getWaveCount(slot1)

	seriesAsync({
		function (slot0)
			slot3 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(slot0:getConfig("story_refresh") and slot1[slot1])

			if slot0.getConfig("story_refresh") and slot1[slot1] and type(slot2) == "number" and not pg.NewStoryMgr.GetInstance():IsPlayed(slot3) then
				slot2:emit(LevelMediator2.ON_PERFORM_COMBAT, slot2, slot0)
			else
				slot0()
			end
		end,
		function (slot0)
			slot2 = pg.NewStoryMgr.GetInstance():StoryId2StoryName(slot0:getConfig("story_refresh_boss"))

			if slot0.getConfig("story_refresh_boss") and slot1 ~= "" and type(slot1) == "number" and slot0:bossRefreshed() and not pg.NewStoryMgr.GetInstance():IsPlayed(slot2) then
				slot1:emit(LevelMediator2.ON_PERFORM_COMBAT, slot1, slot0)
			else
				slot0()
			end
		end
	})
end

slot5 = {
	[ChapterConst.KizunaJammingDodge] = "kizunaOperationSafe",
	[ChapterConst.KizunaJammingEngage] = "kizunaOperationDanger",
	[ChapterConst.StatusDay] = "HololiveDayBar",
	[ChapterConst.StatusNight] = "HololiveNightBar",
	[ChapterConst.StatusAirportUnderControl] = "AirportCaptureBar",
	[ChapterConst.StatusSunset] = "SunsetBar",
	[ChapterConst.StatusMaze1] = "MazeBar",
	[ChapterConst.StatusMaze2] = "MazeBar",
	[ChapterConst.StatusMaze3] = "MazeBar"
}

slot0.PopBar = function (slot0)
	if not getProxy(ChapterProxy):getUpdatedExtraFlags(slot0.contextData.chapterVO.id) then
		return
	end

	getProxy(ChapterProxy):extraFlagUpdated(slot1)

	if #slot2 < 1 then
		return
	end

	if not slot0[slot2[1]] then
		return
	end

	slot5, slot6 = slot0:GetSubView(slot4)

	if slot6 then
		slot5:Load()
	end

	slot5.buffer:PlayAnim()
end

slot0.updateTrait = function (slot0, slot1)
	for slot6, slot7 in pairs(slot0.contextData.chapterVO.cells) do
		if slot7.trait ~= ChapterConst.TraitNone then
			slot7.trait = slot1
		end
	end

	for slot6, slot7 in ipairs(slot2.champions) do
		if slot7.trait ~= ChapterConst.TraitNone then
			slot7.trait = slot1
		end
	end
end

slot0.CheckFleetChange = function (slot0)
	slot2 = slot0.contextData.chapterVO.fleet

	if _.detect(slot0.contextData.chapterVO.fleets, function (slot0)
		return not slot0:isValid()
	end) then
		slot0.emit(slot0, LevelMediator2.ON_OP, {
			type = ChapterConst.OpRetreat,
			id = slot3.id
		})
	end

	if not slot2:isValid() then
		if slot1:getNextValidIndex() > 0 then
			slot0.HandleShowMsgBox(slot0, {
				modal = true,
				hideNo = true,
				content = i18n("formation_switch_tip", slot1.fleets[slot4].name),
				onYes = function ()
					slot0:emit(LevelMediator2.ON_OP, {
						type = ChapterConst.OpSwitch,
						id = slot1.id
					})
				end,
				onNo = function ()
					slot0.emit(LevelMediator2.ON_OP, )
				end
			})
		end

		return true
	end

	return false
end

slot0.tryAutoTrigger = function (slot0, slot1)
	slot2 = slot0.contextData.chapterVO

	if slot0:DoBreakAction() then
		return true
	end

	if not slot0:CheckFleetChange() then
		if slot2:checkAnyInteractive() then
			if not slot1 or slot2:IsAutoFight() then
				triggerButton(slot0.funcBtn)
			end
		elseif slot2:getRound() == ChapterConst.RoundEnemy then
			slot0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpEnemyRound
			})
		elseif slot2:getRound() == ChapterConst.RoundPlayer then
			slot0.grid:updateQuadCells(ChapterConst.QuadStateNormal)
			slot0:TryAutoFight()
		end
	end

	return slot3
end

slot0.DoBreakAction = function (slot0)
	slot1 = slot0.contextData.chapterVO
	slot2, slot3 = slot0:SafeCheck()

	if slot2 then
		slot4 = ChapterOpCommand.PrepareChapterRetreat

		if slot3 == ChapterConst.ReasonVictory then
			seriesAsync({
				function (slot0)
					slot0(slot0)
				end,
				function (slot0)
					if slot0:getConfig("win_condition_display") and #slot1 > 0 and slot1 .. "_tip" and pg.gametip[slot1] then
						pg.TipsMgr.GetInstance():ShowTips(i18n(slot1))
					else
						pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_chapter_win"))
					end

					slot0()
				end
			})
		elseif slot3 == ChapterConst.ReasonDefeat then
			if slot1.getPlayType(slot1) == ChapterConst.TypeTransport then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_escort_lose"))
				slot4()
			else
				slot0:HandleShowMsgBox({
					modal = true,
					hideNo = true,
					content = i18n("formation_invalide"),
					onYes = slot4,
					onClose = slot4
				})
			end
		elseif slot3 == ChapterConst.ReasonDefeatDefense then
			slot0:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("harbour_bomb_tip"),
				onYes = slot4,
				onClose = slot4
			})
		elseif slot3 == ChapterConst.ReasonVictoryOni then
			slot4()
		elseif slot3 == ChapterConst.ReasonDefeatOni then
			slot4()
		elseif slot3 == ChapterConst.ReasonDefeatBomb then
			slot4()
		elseif slot3 == ChapterConst.ReasonOutTime then
			slot0:emit(LevelMediator2.ON_TIME_UP)
		elseif slot3 == ChapterConst.ReasonActivityOutTime then
			slot0:HandleShowMsgBox({
				modal = true,
				hideNo = true,
				content = i18n("battle_preCombatMediator_activity_timeout"),
				onYes = slot4,
				onClose = slot4
			})
		end

		return true
	end

	return slot2
end

slot0.SafeCheck = function (slot0)
	slot2 = slot0.contextData.chapterVO.fleet

	if slot0.contextData.chapterVO:existOni() then
		if slot1:checkOniState() == 1 then
			return true, ChapterConst.ReasonVictoryOni
		elseif slot3 == 2 then
			return true, ChapterConst.ReasonDefeatOni
		else
			return false
		end
	elseif slot1:isPlayingWithBombEnemy() then
		if slot1:getBombChapterInfo().action_times * 2 <= slot1.roundIndex then
			return true, ChapterConst.ReasonDefeatBomb
		else
			return false
		end
	end

	slot3, slot4 = slot1:CheckChapterWin()

	if slot3 then
		return true, slot4
	end

	slot5, slot6 = slot1:CheckChapterLose()

	if slot5 then
		return true, slot6
	end

	if not slot1:inWartime() then
		return true, ChapterConst.ReasonOutTime
	end

	slot7 = slot1:getConfig("act_id")

	if not slot0.contextData.map:isRemaster() and slot7 ~= 0 and (not getProxy(ActivityProxy):getActivityById(slot7) or slot9:isEnd()) then
		return true, ChapterConst.ReasonActivityOutTime
	end

	return false
end

slot0.TryAutoFight = function (slot0)
	if not slot0.contextData.chapterVO:IsAutoFight() then
		return
	end

	if slot1.GetFleetofDuty(slot1, tobool(_.detect(slot2, function (slot0)
		return slot0.attachment == ChapterConst.AttachBoss
	end))) and slot4.id ~= slot1.fleet.id then
		slot0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpSwitch,
			id = slot4.id
		})
		slot0:tryAutoTrigger()

		return
	end

	if slot1:checkAnyInteractive() then
		slot0:tryAutoTrigger()

		return
	end

	if slot3 then
		slot5, slot11 = slot1:FindBossPath(ChapterConst.SubjectPlayer, slot4.line, slot3)
		slot7 = {}
		slot8, slot9 = nil

		for slot13, slot14 in ipairs(slot6) do
			table.insert(slot7, slot14)

			if slot1:existEnemy(ChapterConst.SubjectPlayer, slot14.row, slot14.column) then
				slot5 = slot13
				slot8 = slot14

				break
			end
		end

		slot2 = {
			{
				target = slot8 or slot3,
				priority = slot5 or 0,
				path = slot7
			}
		}
	else
		slot5 = _.map(slot2, function (slot0)
			slot3.priority, slot3.path = slot0:findPath(ChapterConst.SubjectPlayer, slot1.line, slot0)

			return {
				target = slot0,
				priority = slot1,
				path = slot2
			}
		end)
		slot2 = slot5

		function slot5(slot0)
			slot2 = pg.expedition_data_template[slot0.target.attachmentId]

			if slot0.target.flag == ChapterConst.CellFlagDisabled then
				return 0
			end

			return ChapterConst.EnemyPreference[slot2.type]
		end

		slot6 = slot4.row
		slot7 = slot4.column

		table.sort(slot2, function (slot0, slot1)
			if (PathFinding.PrioObstacle <= slot0.priority) ~= (PathFinding.PrioObstacle <= slot1.priority) then
				return not slot2
			end

			if slot0(slot0) ~= slot0(slot1) then
				return slot5 < slot4
			end

			return slot0.priority < slot1.priority
		end)
	end

	if slot2[1] and slot5.priority < PathFinding.PrioObstacle then
		slot0.emit(slot0, LevelMediator2.ON_OP, {
			type = ChapterConst.OpMove,
			id = slot4.id,
			arg1 = slot5.target.row,
			arg2 = slot5.target.column
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_errors_tip"))
		getProxy(ChapterProxy):SetChapterAutoFlag(slot1.id, false)
	end
end

slot0.popStageStrategy = function (slot0)
	if slot0:findTF("event/collapse", slot0.rightStage).anchoredPosition.x <= 1 then
		triggerButton(slot1)
	end
end

slot0.UpdateAutoFightPanel = function (slot0)
	if slot0.contextData.chapterVO:CanActivateAutoFight() then
		if not slot0.autoFightPanel then
			slot0.autoFightPanel = LevelStageAutoFightPanel.New(slot0.rightStage:Find("event/collapse"), slot0.event, slot0.contextData)

			slot0.autoFightPanel:Load()

			slot0.autoFightPanel.isFrozen = slot0.isFrozen
		end

		slot0.autoFightPanel.buffer:Show()
	elseif slot0.autoFightPanel then
		slot0.autoFightPanel.buffer:Hide()
	end
end

slot0.UpdateAutoFightMark = function (slot0)
	if not slot0.autoFightPanel then
		return
	end

	slot0.autoFightPanel.buffer:UpdateAutoFightMark()
end

slot0.DestroyAutoFightPanel = function (slot0)
	if not slot0.autoFightPanel then
		return
	end

	slot0.autoFightPanel:Destroy()

	slot0.autoFightPanel = nil
end

slot0.HandleShowMsgBox = function (slot0, slot1)
	slot1.blurLevelCamera = true

	pg.MsgboxMgr.GetInstance():ShowMsgBox(slot1)
end

return slot0

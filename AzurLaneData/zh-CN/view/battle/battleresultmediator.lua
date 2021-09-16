slot0 = class("BattleResultMediator", import("..base.ContextMediator"))
slot0.ON_BACK_TO_LEVEL_SCENE = "BattleResultMediator.ON_BACK_TO_LEVEL_SCENE"
slot0.ON_BACK_TO_DUEL_SCENE = "BattleResultMediator.ON_BACK_TO_DUEL_SCENE"
slot0.ON_GO_TO_TASK_SCENE = "BattleResultMediator.ON_GO_TO_TASK_SCENE"
slot0.GET_NEW_SHIP = "BattleResultMediator.GET_NEW_SHIP"
slot0.ON_GO_TO_MAIN_SCENE = "BattleResultMediator.ON_GO_TO_MAIN_SCENE"
slot0.ON_NEXT_CHALLENGE = "BattleResultMediator.ON_NEXT_CHALLENGE"
slot0.ON_CHALLENGE_RANK = "BattleResultMediator:ON_CHALLENGE_RANK"
slot0.ON_CHALLENGE_SHARE = "BattleResultMediator:ON_CHALLENGE_SHARE"
slot0.ON_CHALLENGE_DEFEAT_SCENE = "BattleResultMediator:ON_CHALLENGE_DEFEAT_SCENE"
slot0.DIRECT_EXIT = "BattleResultMediator:DIRECT_EXIT"
slot0.OPEN_FAIL_TIP_LAYER = "BattleResultMediator:OPEN_FAIL_TIP_LAYER"
slot0.PRE_BATTLE_FAIL_EXIT = "BattleResultMediator:PRE_BATTLE_FAIL_EXIT"

slot0.register = function (slot0)
	slot2 = getProxy(PlayerProxy).getData(slot1)
	slot3 = getProxy(FleetProxy)
	slot4 = getProxy(BayProxy)
	slot5 = getProxy(ChapterProxy)
	slot6 = getProxy(ActivityProxy)

	if slot0.contextData.system == SYSTEM_DUEL then
		slot8 = getProxy(MilitaryExerciseProxy)

		slot0.viewComponent:setRivalVO(slot9)
		slot0.viewComponent:setRank(slot2, slot8:getSeasonInfo())
	elseif slot7 == SYSTEM_CHALLENGE then
		slot8 = getProxy(ChallengeProxy)

		slot0.viewComponent:setChallengeInfo(slot8:getUserChallengeInfo(slot0.contextData.mode), slot8:userSeaonExpire(slot0.contextData.mode))
	else
		if slot7 == SYSTEM_SCENARIO or slot7 == SYSTEM_ROUTINE or slot7 == SYSTEM_ACT_BOSS or slot7 == SYSTEM_HP_SHARE_ACT_BOSS or slot7 == SYSTEM_SUB_ROUTINE or slot7 == SYSTEM_WORLD then
			slot0.viewComponent:setExpBuff(_.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function (slot0)
				return slot0:getConfig("benefit_type") == "rookie_battle_exp"
			end), slot6.getBuffShipList(slot6))
		end

		slot0.viewComponent:setPlayer(slot2)
	end

	slot8 = nil

	if slot7 == SYSTEM_SCENARIO then
		slot8 = {}
		slot9 = nil

		if slot7 == SYSTEM_SCENARIO then
			slot9 = slot5:getActiveChapter()
		end

		slot12 = slot9.fleet[TeamType.Vanguard]

		for slot16, slot17 in ipairs(slot11) do
			table.insert(slot8, slot17)
		end

		for slot16, slot17 in ipairs(slot12) do
			table.insert(slot8, slot17)
		end

		if _.detect(slot9.fleets, function (slot0)
			return slot0:getFleetType() == FleetType.Submarine
		end) then
			for slot18, slot19 in ipairs(slot14) do
				table.insert(slot8, slot19)
			end
		end

		slot0.viewComponent:SetSkipFlag(slot5:GetChapterAutoFlag(slot9.id) == 1)
	elseif slot7 == SYSTEM_WORLD then
		slot8 = {}
		slot11 = nowWorld.GetActiveMap(slot9).GetFleet(slot10)
		slot13 = slot11:GetTeamShipVOs(TeamType.Vanguard, true)

		for slot17, slot18 in ipairs(slot12) do
			table.insert(slot8, slot18)
		end

		for slot17, slot18 in ipairs(slot13) do
			table.insert(slot8, slot18)
		end

		if slot10:GetSubmarineFleet() then
			for slot19, slot20 in ipairs(slot15) do
				table.insert(slot8, slot20)
			end
		end

		slot0.viewComponent:SetSkipFlag(nowWorld.isAutoFight)
	elseif slot7 == SYSTEM_CHALLENGE then
		slot0:bind(slot0.ON_CHALLENGE_SHARE, function (slot0)
			slot0:addSubLayers(Context.New({
				mediator = ChallengeShareMediator,
				viewComponent = ChallengeShareLayer,
				data = {
					mode = slot0.contextData.mode
				}
			}))
		end)
		slot0.bind(slot0, slot0.ON_CHALLENGE_DEFEAT_SCENE, function (slot0, slot1)
			slot0:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = ChallengePassedLayer,
				data = {
					mode = slot0.contextData.mode
				},
				onRemoved = slot1.callback
			}))
		end)
	elseif slot7 == SYSTEM_WORLD_BOSS then
		slot8 = getProxy(BayProxy).getShipsByFleet(slot12, slot11)

		slot0.viewComponent:setTitle(slot0.contextData.name)
	elseif slot7 == SYSTEM_DODGEM then
	elseif slot7 == SYSTEM_SUBMARINE_RUN then
	elseif slot7 == SYSTEM_REWARD_PERFORM then
	elseif slot7 == SYSTEM_AIRFIGHT then
	elseif slot7 == SYSTEM_HP_SHARE_ACT_BOSS or slot7 == SYSTEM_ACT_BOSS or slot7 == SYSTEM_BOSS_EXPERIMENT then
		slot9 = slot0.contextData.actId

		if slot7 == SYSTEM_HP_SHARE_ACT_BOSS then
			slot0.viewComponent:setActId(slot9)
		end

		slot8 = slot4:getShipsByFleet(slot11)

		for slot17, slot18 in ipairs(slot13) do
			table.insert(slot8, slot18)
		end
	elseif slot7 == SYSTEM_GUILD then
		slot8 = {}

		for slot16, slot17 in ipairs(getProxy(GuildProxy):getData().GetActiveEvent(slot9).GetBossMission(slot10).GetMainFleet(slot11).GetShips(slot12)) do
			table.insert(slot8, slot17.ship)
		end

		for slot17, slot18 in ipairs(slot11:GetSubFleet().GetShips(slot13)) do
			table.insert(slot8, slot18.ship)
		end
	else
		slot8 = slot4:getShipsByFleet(slot3:getFleetById(slot9))
	end

	slot0.viewComponent:setShips(slot8)
	slot0:bind(slot0.ON_BACK_TO_LEVEL_SCENE, function (slot0, slot1)
		slot2 = getProxy(ContextProxy)

		if slot0 == SYSTEM_ACT_BOSS then
			slot3, slot4 = slot2:getContextByMediator(PreCombatMediator)

			if slot3 then
				slot4:removeChild(slot3)
			end
		elseif slot0 == SYSTEM_ROUTINE or slot0 == SYSTEM_SUB_ROUTINE then
			if slot2:getContextByMediator(DailyLevelMediator) then
				slot3:removeChild(slot3:getContextByMediator(PreCombatMediator))
			end
		elseif slot0 == SYSTEM_SCENARIO then
			if slot2:getContextByMediator(LevelMediator2):getContextByMediator(ChapterPreCombatMediator) then
				slot3:removeChild(slot4)
			end

			if slot1.contextData.score > 1 then
				slot1:showExtraChapterActSocre()
			end

			if getProxy(ChapterProxy):getActiveChapter() then
				if slot6:existOni() then
					slot6:clearSubmarineFleet()
					slot5:updateChapter(slot6)
				elseif slot6:isPlayingWithBombEnemy() then
					slot6.fleets = {
						slot6.fleet
					}
					slot6.findex = 1

					slot5:updateChapter(slot6)
				end
			end
		elseif slot0 == SYSTEM_CHALLENGE then
			slot5 = getProxy(ChallengeProxy).getUserChallengeInfo(slot3, slot4)

			if slot1.contextData.score < ys.Battle.BattleConst.BattleScore.S then
				slot1:sendNotification(GAME.CHALLENGE2_RESET, {
					mode = slot4
				})
			else
				slot6 = slot5:IsFinish()

				slot5:updateLevelForward()

				if slot5:getMode() == ChallengeProxy.MODE_INFINITE and slot6 then
					slot5:setInfiniteDungeonIDListByLevel()
				end
			end

			slot6 = slot3:getChallengeInfo()

			if not slot3:userSeaonExpire(slot5:getMode()) then
				slot6:checkRecord(slot5)
			end

			if not slot1.goToNext and slot2:getContextByMediator(ChallengeMainMediator) then
				slot7:removeChild(slot7:getContextByMediator(ChallengePreCombatMediator))
			end
		elseif slot0 == SYSTEM_HP_SHARE_ACT_BOSS then
			slot3, slot4 = slot2:getContextByMediator(PreCombatMediator)

			if slot3 then
				slot4:removeChild(slot3)
			end
		elseif slot0 == SYSTEM_WORLD_BOSS then
			if slot2:getContextByMediator(WorldBossMediator):getContextByMediator(WorldBossFormationMediator) then
				slot3:removeChild(slot4)
			end
		elseif slot0 == SYSTEM_WORLD then
			if slot2:getContextByMediator(WorldMediator):getContextByMediator(WorldPreCombatMediator) or slot3:getContextByMediator(WorldBossInformationMediator) then
				slot3:removeChild(slot4)
			end
		elseif slot2:getContextByMediator(LevelMediator2) then
			slot3:removeChild(slot3:getContextByMediator(PreCombatMediator))
		end

		slot1:sendNotification(GAME.GO_BACK)
	end)
	slot0.bind(slot0, slot0.ON_GO_TO_MAIN_SCENE, function (slot0)
		slot0:sendNotification(GAME.CHANGE_SCENE, SCENE.MAINUI)
	end)
	slot0.bind(slot0, slot0.ON_GO_TO_TASK_SCENE, function (slot0)
		if getProxy(ContextProxy):getContextByMediator(LevelMediator2) then
			slot2:removeChild(slot2:getContextByMediator(PreCombatMediator))
		end

		slot0:sendNotification(GAME.CHANGE_SCENE, SCENE.TASK)
	end)
	slot0.bind(slot0, slot0.ON_BACK_TO_DUEL_SCENE, function (slot0)
		if getProxy(ContextProxy):getContextByMediator(MilitaryExerciseMediator) then
			slot2:removeChild(slot2:getContextByMediator(ExercisePreCombatMediator))
		end

		slot0:sendNotification(GAME.GO_BACK)
	end)
	slot0.bind(slot0, slot0.GET_NEW_SHIP, function (slot0, slot1, slot2, slot3)
		slot0:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = slot1,
				autoExitTime = slot3
			},
			onRemoved = slot2
		}))
	end)
	slot0.bind(slot0, slot0.OPEN_FAIL_TIP_LAYER, function (slot0)
		setActive(slot0.viewComponent._tf, false)
		slot0:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = slot1,
				battleSystem = slot0.contextData.system
			},
			onRemoved = function ()
				slot0.viewComponent.failTag = nil

				triggerButton(slot0.viewComponent._confirmBtn)
			end
		}))
	end)
	slot0.bind(slot0, slot0.DIRECT_EXIT, function (slot0, slot1)
		slot0:sendNotification(GAME.GO_BACK)
	end)
	slot0.bind(slot0, slot0.PRE_BATTLE_FAIL_EXIT, function (slot0)
		if slot0 == SYSTEM_SCENARIO then
			getProxy(ChapterProxy):StopAutoFight()
		end
	end)

	slot9 = 0

	if slot8 then
		for slot13, slot14 in ipairs(slot8) do
			slot9 = slot14:getBattleTotalExpend() + slot9
		end
	end

	print("耗时：", slot0.contextData.statistics._totalTime, "秒")
	print("编队基础油耗：", slot9)

	if slot0.contextData.statistics._enemyInfoList then
		for slot13, slot14 in pairs(slot0.contextData.statistics._enemyInfoList) do
			print("目标ID>>", slot14.id, "<< 受到伤害共 >>", slot14.damage, "<< 点")
		end
	end

	slot10 = false

	if slot7 == SYSTEM_SCENARIO then
		slot10 = getProxy(ChapterProxy):GetChapterAutoFlag(slot5:getActiveChapter().id) == 1
	elseif slot7 == SYSTEM_WORLD then
		slot10 = nowWorld.isAutoFight
	end

	slot11 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if ys.Battle.BattleState.IsAutoBotActive() and slot11 and not slot10 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end
end

slot0.showExtraChapterActSocre = function (slot0)
	slot2 = getProxy(ActivityProxy).getActivitiesByType(slot1, ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	slot5 = getProxy(ChapterProxy):getActiveChapter() and slot3:getMapById(slot4:getConfig("map"))

	for slot9, slot10 in ipairs(slot2) do
		if slot10 and not slot10:isEnd() and slot10:getConfig("config_data")[1] == slot0.contextData.stageId and slot5 and slot5:isActExtra() then
			slot15, slot16 = ActivityLevelConst.getExtraChapterSocre(slot12, math.floor(slot0.contextData.statistics._totalTime), ActivityLevelConst.getShipsPower(slot0.contextData.prefabFleet or slot0.contextData.oldMainShips), slot10)
			slot17 = (slot16 < slot15 and i18n("extra_chapter_record_updated")) or i18n("extra_chapter_record_not_updated")

			if slot16 < slot15 then
				slot10.data1 = slot15

				slot1:updateActivity(slot10)

				slot16 = slot15
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("extra_chapter_socre_tip", slot15, slot16, slot17),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	end
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.BEGIN_STAGE_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.BEGIN_STAGE_DONE then
		slot0:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, slot3)
	end
end

slot0.GetResultView = function (slot0)
	slot0.RESULT_VIEW_TRANSFORM = slot0.RESULT_VIEW_TRANSFORM or {
		[SYSTEM_CHALLENGE] = BattleChallengeResultLayer,
		[SYSTEM_DODGEM] = BattleDodgemResultLayer,
		[SYSTEM_SUBMARINE_RUN] = BattleSubmarineRunResultLayer,
		[SYSTEM_SUB_ROUTINE] = BattleSubmarineRoutineResultLayer,
		[SYSTEM_HP_SHARE_ACT_BOSS] = BattleContributionResultLayer,
		[SYSTEM_BOSS_EXPERIMENT] = BattleExperimentResultLayer,
		[SYSTEM_ACT_BOSS] = BattleActivityBossResultLayer,
		[SYSTEM_WORLD_BOSS] = BattleWorldBossResultLayer,
		[SYSTEM_REWARD_PERFORM] = BattleRewardPerformResultLayer,
		[SYSTEM_AIRFIGHT] = BattleAirFightResultLayer,
		[SYSTEM_GUILD] = BattleGuildBossResultLayer
	}

	return slot0.RESULT_VIEW_TRANSFORM[slot0] or BattleResultLayer
end

return slot0

slot0 = class("BattleResultLayer", import("..base.BaseUI"))
slot0.DURATION_MOVE = 0.35
slot0.DURATION_WIN_SCALE = 0.4
slot0.CONDITIONS_FREQUENCE = 0.15
slot0.STATE_RANK_ANIMA = "rankAnima"
slot0.STATE_REPORT = "report"
slot0.STATE_REPORTED = "reported"
slot0.STATE_REWARD = "reward"
slot0.STATE_DISPLAY = "display"
slot0.STATE_DISPLAYED = "displayed"
slot0.STATE_SUB_DISPLAY = "subDisplay"
slot0.STATE_SUB_DISPLAYED = "subDisplayed"
slot0.ObjectiveList = {
	"battle_result_victory",
	"battle_result_undefeated",
	"battle_result_sink_limit",
	"battle_preCombatLayer_time_hold",
	"battle_result_time_limit",
	"battle_result_boss_destruct",
	"battle_preCombatLayer_damage_before_end",
	"battle_result_defeat_all_enemys"
}

slot0.getUIName = function (slot0)
	return "BattleResultUI"
end

slot0.setRivalVO = function (slot0, slot1)
	slot0.rivalVO = slot1
end

slot0.setRank = function (slot0, slot1, slot2)
	slot0.player = slot1
	slot0.season = slot2

	setText(slot0._playerName, "<color=#FFFFFF>" .. slot0.player.name .. "</color><size=32> / C O M M A N D E R</size>")

	slot4, slot5 = SeasonInfo.getNextMilitaryRank(slot2.score, slot2.rank)

	setText(slot0._playerLv, SeasonInfo.getMilitaryRank(slot2.score, slot2.rank).name)
	setText(slot0._playerExpLabel, i18n("word_rankScore"))

	slot0._playerExpProgress:GetComponent(typeof(Image)).fillAmount = slot2.score / slot5

	setText(slot0._playerBonusExp, "+0")

	slot0.calcPlayerProgress = slot0.calcPlayerRank
end

slot0.setShips = function (slot0, slot1)
	slot0.shipVOs = slot1
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1

	setText(slot0._playerName, "<color=#FFFFFF>" .. slot0.player.name .. "</color><size=32> / C O M M A N D E R</size>")
	setText(slot0._playerLv, "Lv." .. slot0.player.level)

	slot0._playerExpProgress:GetComponent(typeof(Image)).fillAmount = slot0.player.exp / getConfigFromLevel1(pg.user_level, slot0.player.level).exp_interval

	if slot0.player.level == pg.user_level[#pg.user_level].level then
		slot0._playerExpProgress:GetComponent(typeof(Image)).fillAmount = 1
	end

	setText(slot0._playerBonusExp, "+0")

	slot0.calcPlayerProgress = slot0.calcPlayerExp

	for slot7, slot8 in ipairs(slot3) do
		if pg.benefit_buff_template[slot8].benefit_type == Chapter.OPERATION_BUFF_TYPE_EXP then
			setActive(slot0._playerExpExtra, true)
		end
	end
end

slot0.setExpBuff = function (slot0, slot1, slot2)
	slot0.expBuff = slot1
	slot0.shipBuff = slot2
end

slot0.init = function (slot0)
	slot0._grade = slot0:findTF("grade")
	slot0._levelText = slot0:findTF("chapterName/Text22", slot0._grade)
	slot0.clearFX = slot0:findTF("clear")
	slot0._main = slot0:findTF("main")
	slot0._blurConatiner = slot0:findTF("blur_container")
	slot0._bg = slot0:findTF("main/jiesuanbeijing")
	slot0._painting = slot0:findTF("painting", slot0._blurConatiner)
	slot0._failPainting = slot0:findTF("fail", slot0._painting)
	slot0._chat = slot0:findTF("chat", slot0._painting)
	slot0._leftPanel = slot0:findTF("leftPanel", slot0._main)
	slot0._expResult = slot0:findTF("expResult", slot0._leftPanel)
	slot0._expContainer = slot0:findTF("expContainer", slot0._expResult)
	slot0._extpl = slot0:getTpl("ShipCardTpl", slot0._expContainer)
	slot0._playerExp = slot0:findTF("playerExp", slot0._leftPanel)
	slot0._playerName = slot0:findTF("name_text", slot0._playerExp)
	slot0._playerLv = slot0:findTF("lv_text", slot0._playerExp)
	slot0._playerExpLabel = slot0:findTF("exp_label", slot0._playerExp)
	slot0._playerExpProgress = slot0:findTF("exp_progress", slot0._playerExp)
	slot0._playerBonusExp = slot0:findTF("exp_text", slot0._playerExp)
	slot0._playerExpExtra = slot0:findTF("operation_bonus", slot0._playerExp)
	slot0._atkBG = slot0:findTF("atkPanel", slot0._blurConatiner)
	slot0._atkPanel = slot0:findTF("atkResult", slot0._atkBG)
	slot0._atkResult = slot0:findTF("atkResult/result", slot0._atkBG)
	slot0._atkContainer = slot0:findTF("Grid", slot0._atkResult)
	slot0._atkContainerNext = slot0:findTF("Grid_next", slot0._atkResult)
	slot0._atkToggle = slot0:findTF("switchAtk", slot0._atkPanel)
	slot0._atkTpl = slot0:getTpl("resulttpl", slot0._atkResult)
	slot0._mvpFX = slot0:findTF("mvpFX", slot0._atkPanel)
	slot0._rightBottomPanel = slot0:findTF("rightBottomPanel", slot0._blurConatiner)
	slot0._confirmBtn = slot0:findTF("confirmBtn", slot0._rightBottomPanel)
	slot0._statisticsBtn = slot0:findTF("statisticsBtn", slot0._rightBottomPanel)
	slot0._subExpResult = slot0:findTF("subExpResult", slot0._leftPanel)
	slot0._subExpContainer = slot0:findTF("expContainer", slot0._subExpResult)
	slot0._subToggle = slot0:findTF("switchFleet", slot0._leftPanel)
	slot0._skipBtn = slot0:findTF("skipLayer", slot0._tf)
	slot0.UIMain = pg.UIMgr.GetInstance().UIMain
	slot0.overlay = pg.UIMgr.GetInstance().OverlayMain
	slot0._conditions = slot0:findTF("main/conditions")
	slot0._conditionContainer = slot0:findTF("bg16/list", slot0._conditions)
	slot0._conditionTpl = slot0:findTF("bg16/conditionTpl", slot0._conditions)
	slot0._conditionSubTpl = slot0:findTF("bg16/conditionSubTpl", slot0._conditions)
	slot0._conditionContributeTpl = slot0:findTF("bg16/conditionContributeTpl", slot0._conditions)
	slot0._conditionBGNormal = slot0:findTF("bg16/bg_normal", slot0._conditions)
	slot0._conditionBGContribute = slot0:findTF("bg16/bg_contribute", slot0._conditions)
	slot0._cmdExp = slot0:findTF("commanderExp", slot0._leftPanel)
	slot0._cmdContainer = slot0:findTF("commander_container", slot0._cmdExp)
	slot0._cmdTpl = slot0:findTF("commander_tpl", slot0._cmdExp)

	slot0:setGradeLabel()
	SetActive(slot0._levelText, false)

	slot0._delayLeanList = {}
end

slot0.setGradeLabel = function (slot0)
	slot1 = {
		"d",
		"c",
		"b",
		"a",
		"s"
	}
	slot2 = slot0:findTF("grade/Xyz/bg13")
	slot3 = slot0:findTF("grade/Xyz/bg14")
	slot4, slot5, slot6 = nil
	slot8 = nil

	setActive(slot0:findTF("jieuan01/BG/bg_victory", slot0._bg), slot0.contextData.score > 0)
	setActive(slot0:findTF("jieuan01/BG/bg_fail", slot0._bg), not (slot0.contextData.score > 0))

	if slot9 then
		slot4 = "battlescore/battle_score_" .. slot6 .. "/letter_" .. slot6
		slot5 = "battlescore/battle_score_" .. slot1[slot7 + 1] .. "/label_" .. slot1[slot7 + 1]
	else
		if slot0.contextData.statistics._scoreMark == ys.Battle.BattleConst.DEAD_FLAG then
			slot6 = slot1[2]
			slot8 = "flag_destroy"
		else
			slot6 = slot1[1]
		end

		slot4 = "battlescore/battle_score_" .. slot6 .. "/letter_" .. slot6
		slot5 = "battlescore/battle_score_" .. slot6 .. "/label_" .. (slot8 or slot6)
	end

	LoadImageSpriteAsync(slot4, slot2, false)
	LoadImageSpriteAsync(slot5, slot3, false)

	if (slot0.contextData.system == SYSTEM_SCENARIO or slot10 == SYSTEM_ROUTINE or slot10 == SYSTEM_SUB_ROUTINE or slot10 == SYSTEM_DUEL) and (slot6 == slot1[1] or slot6 == slot1[2]) then
		slot0.failTag = true
	end
end

slot0.displayerCommanders = function (slot0, slot1)
	slot0.commanderExps = slot0.contextData.commanderExps or {}
	slot2 = getProxy(CommanderProxy)

	removeAllChildren(slot0._cmdContainer)

	slot3 = nil

	if slot1 then
		slot3 = slot0.commanderExps.submarineCMD or {}
	else
		slot3 = slot0.commanderExps.surfaceCMD or {}

		setActive(slot0._cmdExp, true)
	end

	for slot7, slot8 in ipairs(slot3) do
		slot9 = slot2:getCommanderById(slot8.commander_id)
		slot10 = cloneTplTo(slot0._cmdTpl, slot0._cmdContainer)

		GetImageSpriteFromAtlasAsync("commandericon/" .. slot9:getPainting(), "", slot10:Find("icon/mask/pic"))
		setText(slot10:Find("exp/name_text"), slot9:getName())
		setText(slot10:Find("exp/lv_text"), "Lv." .. slot9.level)
		setText(slot10:Find("exp/exp_text"), "+" .. slot8.exp)

		slot11 = nil
		slot10:Find("exp/exp_progress"):GetComponent(typeof(Image)).fillAmount = (slot9:isMaxLevel() and 1) or slot8.curExp / slot9:getNextLevelExp()
	end
end

slot0.didEnter = function (slot0)
	slot0:setStageName()

	slot0._subShipResultCardList = {}
	slot0._shipResultCardList = {}
	slot0._gradeUpperLeftPos = rtf(slot0._grade).localPosition
	rtf(slot0._grade).localPosition = Vector3(0, 25, 0)

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, true)

	slot0._grade.transform.localScale = Vector3(1.5, 1.5, 0)

	LeanTween.scale(slot0._grade, Vector3(0.88, 0.88, 1), slot0.DURATION_WIN_SCALE):setOnComplete(System.Action(function ()
		SetActive(slot0._levelText, true)
		SetActive:rankAnimaFinish()
	end))

	slot0._tf.GetComponent(slot2, typeof(Image)).color = Color.New(0, 0, 0, 0.5)

	SetActive(slot0._atkBG, false)
	onToggle(slot0, slot0._subToggle, function (slot0)
		SetActive(slot0._subExpResult, not slot0)
		SetActive(slot0._expResult, slot0)
		setActive(slot0:findTF("off", slot0._subToggle), not slot0)
		slot0:displayerCommanders(not slot0)
	end, SFX_PANEL)

	slot0._stateFlag = slot0.STATE_RANK_ANIMA

	onButton(slot0, slot0._skipBtn, function ()
		slot0:skip()
	end, SFX_CONFIRM)
end

slot0.setStageName = function (slot0)
	if slot0.contextData.system and slot0.contextData.system == SYSTEM_DUEL then
		setText(slot0._levelText, slot0.rivalVO.name)
	else
		setText(slot0._levelText, pg.expedition_data_template[slot0.contextData.stageId].name)
	end
end

slot0.rankAnimaFinish = function (slot0)
	SetActive(slot1, true)
	slot4(pg.expedition_data_template[slot0.contextData.stageId].objective_1)
	slot4(pg.expedition_data_template[slot0.contextData.stageId].objective_2)
	slot4(pg.expedition_data_template[slot0.contextData.stageId].objective_3)
	table.insert(slot0._delayLeanList, LeanTween.delayedCall(1, System.Action(function ()
		slot0._stateFlag = slot1.STATE_REPORTED

		SetActive(slot0:findTF("jieuan01/tips", slot0._bg), true)

		if SetActive.skipFlag then
			slot0:skip()
		end
	end)).id)

	slot0._stateFlag = slot0.STATE_REPORT
end

slot0.objectiveCheck = function (slot0, slot1)
	if slot0 == 1 or slot0 == 4 or slot0 == 8 then
		return slot1.score > 1
	elseif slot0 == 2 or slot0 == 3 then
		return not slot1.statistics._deadUnit
	elseif slot0 == 6 then
		return slot1.statistics._boss_destruct < 1
	elseif slot0 == 5 then
		return not slot1.statistics._badTime
	elseif slot0 == 7 then
		return true
	end
end

slot0.setCondition = function (slot0, slot1, slot2)
	slot3 = cloneTplTo(slot0._conditionTpl, slot0._conditionContainer)

	setActive(slot3, false)

	slot4 = nil
	slot5 = slot3:Find("text"):GetComponent(typeof(Text))

	if slot2 == nil then
		slot4 = "resources/condition_check"
		slot5.text = setColorStr(slot1, "#FFFFFFFF")
	elseif slot2 == true then
		slot4 = "resources/condition_done"
		slot5.text = setColorStr(slot1, "#FFFFFFFF")
	else
		slot4 = "resources/condition_fail"
		slot5.text = setColorStr(slot1, "#FFFFFF80")
	end

	slot0:setSpriteTo(slot4, slot3:Find("checkBox"), true)

	if slot0._conditionContainer.childCount - 1 > 0 then
		table.insert(slot0._delayLeanList, LeanTween.delayedCall(slot0.CONDITIONS_FREQUENCE * slot6, System.Action(function ()
			setActive(setActive, true)
		end)).id)
	else
		setActive(slot3, true)
	end
end

slot0.showRewardInfo = function (slot0)
	slot0._stateFlag = slot0.STATE_REWARD

	SetActive(slot0:findTF("jieuan01/tips", slot0._bg), false)
	setParent(slot0._tf, slot0.UIMain)

	slot1 = nil
	slot3 = coroutine.create(function ()
		slot0 = slot0.contextData.drops

		if getProxy(ActivityProxy):getActivityById(ActivityConst.UTAWARERU_ACTIVITY_PT_ID) and not slot2:isEnd() then
			slot3 = slot2:getConfig("config_client").pt_id

			if _.detect(slot1:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_PT_RANK), function (slot0)
				return slot0:getConfig("config_id") == slot0
			end).getData1(slot4) >= 1500 then
				slot4 = slot4 - 1500
				slot6 = _.filter(slot0, function (slot0)
					return slot0.dropType ~= DROP_TYPE_RESOURCE or slot0.id ~= slot0
				end)
				slot0 = slot6

				if _.detect(slot0, function (slot0)
					return slot0.dropType == DROP_TYPE_RESOURCE and slot0.id == slot0
				end) and slot4 < slot5.count then
					slot5.count = slot5.count - slot4

					table.insert(slot0, slot5)
				end
			end
		end

		slot3 = {}

		for slot7, slot8 in ipairs(slot0.contextData.drops) do
			table.insert(slot3, slot8)
		end

		for slot7, slot8 in ipairs(slot0.contextData.extraDrops) do
			slot8.riraty = true

			table.insert(slot3, slot8)
		end

		slot4 = false

		for slot9, slot10 in ipairs(slot5) do
			if pg.benefit_buff_template[slot10].benefit_type == Chapter.OPERATION_BUFF_TYPE_REWARD then
				slot4 = true

				break
			end
		end

		if table.getCount(slot0) > 0 then
			slot6 = slot0.skipFlag
			slot7 = false

			if slot0.contextData.system == SYSTEM_SCENARIO and getProxy(ChapterProxy):getActiveChapter(true) and slot8:isLoop() then
				getProxy(ChapterProxy):AddExtendChapterDataArray(slot8.id, "TotalDrops", slot3)

				slot7 = getProxy(ChapterProxy):GetChapterAutoFlag(slot8.id) == 1

				slot0:emit(BaseUI.ON_AWARD, {
					items = slot3,
					extraBonus = slot4,
					removeFunc = slot1,
					closeOnCompleted = slot6
				})
				coroutine.yield()
			end

			for slot14 = math.max(1, #getProxy(BayProxy).getNewShip(slot9, true) - #_.filter(slot3, function (slot0)
				return slot0.type == DROP_TYPE_SHIP
			end) + 1), #getProxy(BayProxy).getNewShip(slot9, true), 1 do
				slot16 = PlayerPrefs.GetInt(DISPLAY_SHIP_GET_EFFECT) == 1 or slot10[slot14].virgin or ShipRarity.Purple <= slot10[slot14]:getRarity()

				if slot16 then
					slot0:emit(BattleResultMediator.GET_NEW_SHIP, slot15, slot1, (slot7 and not slot15.virgin and 3) or nil)
					coroutine.yield()
				end
			end
		end

		setParent(slot0._tf, slot0.overlay)
		slot0:displayBG()
	end)
	slot1 = slot3

	function ()
		if slot0 and coroutine.status(coroutine.status) == "suspended" then
			slot0, slot1 = coroutine.resume(coroutine.resume)
		end
	end()
end

slot0.displayBG = function (slot0)
	LeanTween.moveX(rtf(slot0._conditions), 1300, slot0.DURATION_MOVE)
	LeanTween.scale(slot0._grade, Vector3(0.6, 0.6, 0), slot0.DURATION_MOVE)
	LeanTween.moveLocal(go(slot1), slot0._gradeUpperLeftPos, slot0.DURATION_MOVE):setOnComplete(System.Action(function ()
		slot0:displayShips()
		slot0.displayShips:displayPlayerInfo()
		slot0.displayShips.displayPlayerInfo:displayerCommanders()
		slot0.displayShips.displayPlayerInfo.displayerCommanders:initMetaBtn()

		slot0.displayShips.displayPlayerInfo.displayerCommanders.initMetaBtn._stateFlag = slot0.displayShips.displayPlayerInfo.displayerCommanders.STATE_DISPLAY

		if slot0.displayShips.displayPlayerInfo.displayerCommanders.initMetaBtn.skipFlag then
			slot0:skip()
		end
	end))
	setActive(slot0.findTF(slot0, "jieuan01/Bomb", slot0._bg), false)
end

slot0.displayPlayerInfo = function (slot0)
	slot1 = slot0:calcPlayerProgress()

	SetActive(slot0._leftPanel, true)
	SetActive(slot0._playerExp, true)

	slot0._main:GetComponent("Animator").enabled = true

	table.insert(slot0._delayLeanList, LeanTween.moveX(rtf(slot0._leftPanel), 0, 0.5):setOnComplete(System.Action(function ()
		table.insert(slot0._delayLeanList, LeanTween.value(go(slot0._tf), 0, , 1):setOnUpdate(System.Action_float(function (slot0)
			setText(slot0._playerBonusExp, "+" .. math.floor(slot0))
		end)).id)
	end)).id)
end

slot0.calcPlayerExp = function (slot0)
	slot2 = slot0.contextData.oldPlayer.level
	slot3 = slot0.player.level
	slot4 = slot0.player.exp - slot0.contextData.oldPlayer.exp

	while slot2 < slot3 do
		slot4 = slot4 + pg.user_level[slot2].exp
		slot2 = slot2 + 1
	end

	if slot2 == pg.user_level[#pg.user_level].level then
		slot4 = 0
	end

	return slot4
end

slot0.calcPlayerRank = function (slot0)
	slot2 = slot0.contextData.oldRank.score

	return slot0.season.score - slot0.contextData.oldRank.score
end

slot0.displayShips = function (slot0)
	slot1 = {}

	for slot6, slot7 in ipairs(slot2) do
		slot1[slot7.id] = slot7
	end

	slot3 = slot0.contextData.statistics

	for slot7, slot8 in ipairs(slot2) do
		if slot3[slot8.id] then
			slot3[slot8.id].vo = slot8
		end
	end

	slot4, slot5 = nil

	if slot3.mvpShipID == -1 then
		slot5 = 0

		for slot9, slot10 in ipairs(slot0.contextData.oldMainShips) do
			slot5 = math.max(slot3[slot10.id].output, slot5)
		end
	else
		slot5 = (not slot3.mvpShipID or slot3.mvpShipID == 0 or slot3[slot3.mvpShipID].output) and 0
		slot0._atkFuncs = {}
		slot7, slot8 = nil

		SetActive(slot0._atkToggle, #slot0.contextData.oldMainShips > 6)
	end

	if #slot6 > 6 then
		onToggle(slot0, slot0._atkToggle, function (slot0)
			SetActive(slot0._atkContainer, slot0)
			SetActive(slot0._atkContainerNext, not slot0)

			if slot0 then
				slot0:skipAtkAnima(slot0._atkContainerNext)
			else
				slot0:skipAtkAnima(slot0._atkContainer)
			end
		end, SFX_PANEL)
	end

	slot9 = {}
	slot10 = {}

	for slot14, slot15 in ipairs(slot6) do
		slot16 = slot1[slot15.id]

		if slot3[slot15.id] then
			slot18 = table.contains(TeamType.SubShipType, slot17)
			slot19, slot20 = nil
			slot21 = 0

			if slot14 > 6 then
				slot20 = slot0._atkContainerNext
				slot21 = 7
			else
				slot20 = slot0._atkContainer
				slot21 = 1
			end

			cloneTplTo(slot0._atkTpl, slot20).localPosition.x = cloneTplTo(slot0._atkTpl, slot20).localPosition.x + (slot14 - slot21) * 74
			cloneTplTo(slot0._atkTpl, slot20).localPosition.y = cloneTplTo(slot0._atkTpl, slot20).localPosition.y + (slot14 - slot21) * -124
			cloneTplTo(slot0._atkTpl, slot20).localPosition = cloneTplTo(slot0._atkTpl, slot20).localPosition
			slot23 = findTF(slot19, "result/stars")
			slot24 = findTF(slot19, "result/stars/star_tpl")
			slot25 = slot15:getStar()
			slot26 = slot15:getMaxStar()

			while slot26 > 0 do
				SetActive(cloneTplTo(slot24, slot23):Find("empty"), slot25 < slot26)
				SetActive(slot27:Find("star"), slot26 <= slot25)

				slot26 = slot26 - 1
			end

			slot0:findTF("result/mask/icon", slot19).GetComponent(slot27, typeof(Image)).sprite = LoadSprite("herohrzicon/" .. slot15:getPainting())

			setImageSprite(slot28, slot30, true)
			slot0:setAtkAnima(slot19, slot20, slot3[slot15.id].output / slot5, slot5, slot4 and slot15.id == slot4.id, slot3[slot15.id].output, slot3[slot15.id].kill_count)

			slot31 = nil
			slot32 = false

			if slot4 and slot15.id == slot4.id then
				slot32 = true
				slot0.mvpShipVO = slot15
				slot33, slot34, slot35 = nil

				if slot0.contextData.score > 1 then
					slot33, slot35, slot34 = ShipWordHelper.GetWordAndCV(slot0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, slot0.mvpShipVO:getCVIntimacy())
				else
					slot33, slot35, slot34 = ShipWordHelper.GetWordAndCV(slot0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if slot35 then
					slot0:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot35, function (slot0)
						slot0._currentVoice = slot0
					end)
				end
			end

			if slot15.id == slot3._flagShipID then
				slot0.flagShipVO = slot15
			end

			slot33 = nil
			slot34 = slot0.shipBuff and slot0.shipBuff[slot15.getGroupId(slot15)]

			if slot0.expBuff or slot34 then
				slot33 = (slot0.expBuff and slot0.expBuff:getConfig("name")) or (slot34 and i18n("Word_Ship_Exp_Buff"))
				slot36 = nil
			end

			if not slot18 then
				table.insert(slot0._shipResultCardList, BattleResultShipCard.New(slot37))

				if slot8 then
					slot8:ConfigCallback(function ()
						slot0:Play()
					end)
				else
					slot36.Play(slot36)
				end

				slot8 = slot36
			else
				table.insert(slot0._subShipResultCardList, BattleResultShipCard.New(slot37))

				if not slot7 then
					slot0._subFirstExpCard = slot36
				else
					slot7:ConfigCallback(function ()
						slot0:Play()
					end)
				end

				slot7 = slot36
			end

			slot36:SetShipVO(slot15, slot16, slot32, slot33)
		end
	end

	if slot8 then
		slot8:ConfigCallback(function ()
			slot0._stateFlag = slot1.STATE_DISPLAYED

			if not slot0._subFirstExpCard then
				slot0:skip()
			end
		end)
	end

	if slot7 then
		slot7.ConfigCallback(slot7, function ()
			slot0._stateFlag = slot1.STATE_SUB_DISPLAYED

			slot0:skip()
		end)
	end
end

slot0.stopVoice = function (slot0)
	if slot0._currentVoice then
		slot0._currentVoice:PlaybackStop()

		slot0._currentVoice = nil
	end
end

slot0.setAtkAnima = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot12 = slot0:findTF("result", slot1).GetComponent(slot8, typeof(DftAniEvent))

	setText(slot9, 0)
	setText(slot11, 0)

	slot0:findTF("result/dmg_progress/progress_bar", slot1).GetComponent(slot10, typeof(Image)).fillAmount = 0

	if slot5 then
		setParent(slot0._mvpFX, slot13)

		slot0._mvpFX.localPosition = Vector3(-368.5, 0, 0)

		setActive(slot13, true)
		setActive(slot0:findTF("result/bg", slot1), false)
	end

	slot12:SetEndEvent(function (slot0)
		if slot0 then
			setActive(slot1._mvpFX, true)
		end

		LeanTween.value(go(go), 0, , ):setOnUpdate(System.Action_float(function (slot0)
			slot0:GetComponent(typeof(Image)).fillAmount = slot0
		end))

		if 0 ~= 0 then
			LeanTween.value(go(go), 0, slot6, ).setOnUpdate(slot1, System.Action_float(function (slot0)
				setText(slot0, math.floor(slot0))
			end))
			LeanTween.value(go(go), 0, slot8, ).setOnUpdate(slot1, System.Action_float(function (slot0)
				setText(slot0, math.floor(slot0))
			end))
		end
	end)

	if slot2.childCount > 1 then
		slot0.findTF(slot0, "result", slot2:GetChild(slot2.childCount - 2)).GetComponent(slot13, typeof(DftAniEvent)):SetTriggerEvent(function (slot0)
			setActive(slot0, true)
		end)
	else
		setActive(slot8, true)
	end

	function slot13()
		slot0:GetComponent(typeof(Image)).fillAmount = slot0

		setText(typeof, slot3)
		setText(slot4, slot5)

		slot6.localPosition = Vector3(280, 46, 0)
		slot6:GetComponent(typeof(Animator)).enabled = false

		setActive(slot6, true)
		setActive(slot7._mvpFX, true)
	end

	if slot0._atkFuncs[slot2] == nil then
		slot0._atkFuncs[slot2] = {}
	end

	table.insert(slot0._atkFuncs[slot2], slot13)
end

slot0.skipAtkAnima = function (slot0, slot1)
	if slot0._atkFuncs[slot1] then
		for slot5, slot6 in ipairs(slot0._atkFuncs[slot1]) do
			slot6()
		end

		slot0._atkFuncs[slot1] = nil
	end
end

slot0.showPainting = function (slot0)
	slot1, slot2, slot3 = nil

	SetActive(slot0._painting, true)

	if slot0.contextData.score > 1 then
		slot0.paintingName = slot0.mvpShipVO or slot0.flagShipVO:getPainting()
		slot5 = slot0.mvpShipVO or slot0.flagShipVO:getCVIntimacy()

		setPaintingPrefabAsync(slot0._painting, slot0.paintingName, "jiesuan", function ()
			if findTF(slot0._painting, "fitter").childCount > 0 then
				ShipExpressionHelper.SetExpression(findTF(slot0._painting, "fitter"):GetChild(0), slot0.paintingName, "win_mvp", )
			end
		end)

		slot1, slot3, slot2 = ShipWordHelper.GetWordAndCV(slot0.mvpShipVO or slot0.flagShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, slot5)

		SetActive(slot0._failPainting, false)
	else
		slot1, slot3, slot2 = ShipWordHelper.GetWordAndCV(slot0.contextData.oldMainShips[math.random(#slot0.contextData.oldMainShips)].skinId, ShipWordHelper.WORD_TYPE_LOSE)
	end

	setText(slot0._chat:Find("Text"), slot2)

	if CHAT_POP_STR_LEN < #slot0._chat:Find("Text"):GetComponent(typeof(Text)).text then
		slot4.alignment = TextAnchor.MiddleLeft
	else
		slot4.alignment = TextAnchor.MiddleCenter
	end

	SetActive(slot0._chat, true)

	slot0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(slot0._painting))
	LeanTween.moveX(rtf(slot0._painting), 50, 0.25):setOnComplete(System.Action(function ()
		LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(1, 1, 1), 0.3):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function ()
			slot0._statisticsBtn:GetComponent("Button").enabled = true
			slot0._statisticsBtn.GetComponent("Button")._confirmBtn:GetComponent("Button").enabled = true
			slot0._statisticsBtn.GetComponent("Button")._confirmBtn.GetComponent("Button")._atkBG:GetComponent("Button").enabled = true
		end))
	end))
end

slot0.hidePainting = function (slot0)
	SetActive(slot0._chat, false)

	slot0._chat.transform.localScale = Vector3.New(0, 0, 0)

	LeanTween.cancel(go(slot0._painting))
	LeanTween.scale(rtf(slot0._chat.gameObject), Vector3.New(0, 0, 0), 0.1):setEase(LeanTweenType.easeOutBack)
	LeanTween.moveX(rtf(slot0._painting), 720, 0.2):setOnComplete(System.Action(function ()
		SetActive(slot0._painting, false)
	end))
end

slot0.skip = function (slot0)
	for slot4, slot5 in ipairs(slot0._delayLeanList) do
		LeanTween.cancel(slot5)
	end

	if slot0._stateFlag == slot0.STATE_RANK_ANIMA then
	elseif slot0._stateFlag == slot0.STATE_REPORT then
		slot1 = slot0._conditionContainer.childCount

		while slot1 > 0 do
			SetActive(slot0._conditionContainer:GetChild(slot1 - 1), true)

			slot1 = slot1 - 1
		end

		SetActive(slot0:findTF("jieuan01/tips", slot0._bg), true)

		slot0._stateFlag = slot0.STATE_REPORTED

		slot0:skip()
	elseif slot0._stateFlag == slot0.STATE_REPORTED then
		slot0:showRewardInfo()
	elseif slot0._stateFlag == slot0.STATE_REWARD then
	elseif slot0._stateFlag == slot0.STATE_DISPLAY then
		for slot4, slot5 in ipairs(slot0._shipResultCardList) do
			slot5:SkipAnimation()
		end

		slot0._stateFlag = slot0.STATE_DISPLAYED

		setText(slot0._playerBonusExp, "+" .. slot0:calcPlayerProgress())

		if not slot0._subFirstExpCard then
			slot0:playSubExEnter()
		elseif slot0.skipFlag then
			slot0:skip()
		end
	elseif slot0._stateFlag == slot0.STATE_DISPLAYED then
		setText(slot0._playerBonusExp, "+" .. slot0:calcPlayerProgress())
		slot0:playSubExEnter()
	elseif slot0._stateFlag == slot0.STATE_SUB_DISPLAY then
		for slot4, slot5 in ipairs(slot0._subShipResultCardList) do
			slot5:SkipAnimation()
		end

		slot0._stateFlag = slot0.STATE_SUB_DISPLAYED

		if slot0.skipFlag then
			slot0:skip()
		end
	elseif slot0._stateFlag == slot0.STATE_SUB_DISPLAYED then
		slot0:showRightBottomPanel()
	end
end

slot0.playSubExEnter = function (slot0)
	slot0._stateFlag = slot0.STATE_SUB_DISPLAY

	if slot0._subFirstExpCard then
		triggerToggle(slot0._subToggle, false)
		slot0._subFirstExpCard:Play()
	else
		slot0:showRightBottomPanel()
	end

	if slot0.skipFlag then
		slot0:skip()
	end
end

slot0.showRightBottomPanel = function (slot0)
	SetActive(slot0._skipBtn, false)
	SetActive(slot0._rightBottomPanel, true)
	SetActive(slot0._subToggle, slot0._subFirstExpCard ~= nil)
	onButton(slot0, slot0._statisticsBtn, function ()
		if slot0._atkBG.gameObject.activeSelf then
			slot0:closeStatistics()
		else
			slot0:showStatistics()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._confirmBtn, function ()
		if slot0.failTag == true then
			slot0:emit(BattleResultMediator.PRE_BATTLE_FAIL_EXIT)
			slot0.emit:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)
		elseif slot0.contextData.system == SYSTEM_DUEL then
			slot0:emit(BattleResultMediator.ON_BACK_TO_DUEL_SCENE)
		else
			slot0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
		end
	end, SFX_CONFIRM)
	onButton(slot0, slot0._atkBG, function ()
		slot0:closeStatistics()
	end, SFX_CANCEL)

	slot0._stateFlag = nil
	slot0._subFirstExpCard = nil

	if slot0.skipFlag then
		triggerButton(slot0._confirmBtn)
	end
end

slot0.showStatistics = function (slot0)
	setActive(slot0._leftPanel, false)
	slot0:enabledStatisticsGizmos(false)
	SetActive(slot0._atkBG, true)

	slot0._atkBG:GetComponent("Button").enabled = false
	slot0._confirmBtn:GetComponent("Button").enabled = false
	slot0._statisticsBtn:GetComponent("Button").enabled = false

	slot0:showPainting()
	LeanTween.moveX(rtf(slot0._atkPanel), 0, 0.25):setOnComplete(System.Action(function ()
		SetActive(slot0._atkContainer, true)
	end))
end

slot0.closeStatistics = function (slot0)
	setActive(slot0._leftPanel, true)
	slot0:skipAtkAnima(slot0._atkContainerNext)
	slot0:skipAtkAnima(slot0._atkContainer)
	slot0:enabledStatisticsGizmos(true)
	slot0:hidePainting()

	slot0._atkBG:GetComponent("Button").enabled = false

	LeanTween.cancel(slot0._atkPanel.gameObject)
	LeanTween.moveX(rtf(slot0._atkPanel), -700, 0.2):setOnComplete(System.Action(function ()
		SetActive(slot0._atkBG, false)
	end))
end

slot0.enabledStatisticsGizmos = function (slot0, slot1)
	setActive(slot0:findTF("gizmos/xuxian_down", slot0._main), slot1)
	setActive(slot0:findTF("gizmos/xuxian_middle", slot0._main), slot1)
end

slot0.PlayAnimation = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	LeanTween.value(slot1.gameObject, slot2, slot3, slot4):setDelay(slot5):setOnUpdate(System.Action_float(function (slot0)
		slot0(slot0)
	end))
end

slot0.SetSkipFlag = function (slot0, slot1)
	slot0.skipFlag = slot1
end

slot0.initMetaBtn = function (slot0)
	slot0.metaBtn = slot0:findTF("MetaBtn", slot0._main)

	setActive(slot0.metaBtn, (getProxy(MetaCharacterProxy):getLastMetaSkillExpInfoList() and #slot1 > 0) or false)
	onButton(slot0, slot0.metaBtn, function ()
		setActive(slot0.metaBtn, false)

		if not setActive.metaExpView then
			slot0.metaExpView = BattleResultMetaExpView.New(slot0._blurConatiner, slot0.event, slot0.contextData)

			slot0.metaExpView:Reset()
			slot0.metaExpView.Reset.metaExpView:Load()
			slot0.metaExpView.Reset.metaExpView.Load.metaExpView:setData(slot0.metaExpView.Reset.metaExpView.Load.metaExpView, function ()
				if slot0.metaBtn then
					setActive(slot0.metaBtn, true)
				end

				slot0.metaExpView = nil
			end)
			slot0.metaExpView.Reset.metaExpView.Load.metaExpView.setData.metaExpView.ActionInvoke(slot0, "Show")
			slot0.metaExpView.Reset.metaExpView.Load.metaExpView.setData.metaExpView.ActionInvoke.metaExpView:ActionInvoke("openPanel")
		end
	end, SFX_PANEL)
end

slot0.onBackPressed = function (slot0)
	if slot0.metaExpView then
		slot0.metaExpView:closePanel()

		slot0.metaExpView = nil

		return
	end

	if slot0._stateFlag == slot0.STATE_RANK_ANIMA then
	elseif slot0._stateFlag == slot0.STATE_REPORT then
		triggerButton(slot0._bg)
	elseif slot0._stateFlag == slot0.STATE_DISPLAY then
		triggerButton(slot0._skipBtn)
	else
		triggerButton(slot0._confirmBtn)
	end
end

slot0.willExit = function (slot0)
	for slot4, slot5 in ipairs(slot0._shipResultCardList) do
		slot5:Dispose()
	end

	for slot4, slot5 in ipairs(slot0._subShipResultCardList) do
		slot5:Dispose()
	end

	slot0._atkFuncs = nil

	LeanTween.cancel(go(slot0._tf))

	if slot0._atkBG.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(slot0._blurConatiner, slot0._tf)
	end

	if slot0.paintingName then
		retPaintingPrefab(slot0._painting, slot0.paintingName)
	end

	if slot0._rightTimer then
		slot0._rightTimer:Stop()
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
	slot0:stopVoice()
	getProxy(MetaCharacterProxy):clearLastMetaSkillExpInfoList()

	if slot0.metaExpView then
		slot0.metaExpView:Destroy()

		slot0.metaExpView = nil
	end
end

return slot0

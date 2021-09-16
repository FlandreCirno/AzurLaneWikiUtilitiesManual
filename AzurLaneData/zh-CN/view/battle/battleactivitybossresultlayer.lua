class("BattleActivityBossResultLayer", import(".BattleResultLayer")).showRightBottomPanel = function (slot0)
	SetActive(slot0._skipBtn, false)
	setActive(slot1, true)
	SetActive(slot0._subToggle, slot0._subFirstExpCard ~= nil)
	onButton(slot0, slot1:Find("statisticsBtn"), function ()
		if slot0._atkBG.gameObject.activeSelf then
			slot0:closeStatistics()
		else
			slot0:showStatistics()
		end
	end, SFX_PANEL)
	setText(slot1.Find(slot1, "confirmBtn/Image"), i18n("text_confirm"))
	onButton(slot0, slot1:Find("confirmBtn"), function ()
		if slot0.contextData.system == SYSTEM_DUEL then
			if slot0.failTag == true then
				slot0:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)
			else
				slot0:emit(BattleResultMediator.ON_BACK_TO_DUEL_SCENE)
			end
		elseif slot0.failTag == true then
			slot0:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)
		else
			slot0:emit(BattleResultMediator.ON_BACK_TO_LEVEL_SCENE)
		end
	end, SFX_CONFIRM)
	setText(slot1.Find(slot1, "playAgain/Image"), i18n("re_battle"))
	onButton(slot0, slot1:Find("playAgain"), function ()
		slot0:emit(BattleResultMediator.DIRECT_EXIT)
	end)
	onButton(slot0, slot0._atkBG, function ()
		slot0:closeStatistics()
	end, SFX_CANCEL)

	slot0._stateFlag = nil
	slot0._subFirstExpCard = nil
end

return class("BattleActivityBossResultLayer", import(".BattleResultLayer"))

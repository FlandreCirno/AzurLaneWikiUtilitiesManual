slot0 = class("BattleFailTipLayer", import("..base.BaseUI"))
slot0.PowerUpBtn = {
	ShipBreakUp = 4,
	SkillLevelUp = 3,
	ShipLevelUp = 1,
	EquipLevelUp = 2
}

slot0.getUIName = function (slot0)
	return "BattleFailTipUI"
end

slot0.init = function (slot0)
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
end

slot0.initData = function (slot0)
	slot0.battleSystem = slot0.contextData.battleSystem
end

slot0.findUI = function (slot0)
	slot0.powerUpTipPanel = slot0:findTF("Main")
	slot0.shipLevelUpBtn = slot0:findTF("ShipLevelUpBtn", slot0.powerUpTipPanel)
	slot0.equipLevelUpBtn = slot0:findTF("EquipLevelUpBtn", slot0.powerUpTipPanel)
	slot0.skillLevelUpBtn = slot0:findTF("SkillLevelUpBtn", slot0.powerUpTipPanel)
	slot0.shipBreakUpBtn = slot0:findTF("ShipBreakUpBtn", slot0.powerUpTipPanel)
	slot0.closeBtn = slot0:findTF("CloseBtn", slot0.powerUpTipPanel)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, slot0.shipLevelUpBtn, function ()
		if slot0.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fightfail_up"),
				onYes = function ()
					if slot0.contextData.battleSystem == SYSTEM_SCENARIO then
						slot0.lastClickBtn = slot1.PowerUpBtn.ShipLevelUp

						slot0:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						slot0:emit(BattleFailTipMediator.GO_HIGEST_CHAPTER)
					end
				end
			})
		else
			slot0.emit(slot0, BattleFailTipMediator.GO_HIGEST_CHAPTER)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.equipLevelUpBtn, function ()
		if slot0.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fightfail_equip"),
				onYes = function ()
					if slot0.contextData.battleSystem == SYSTEM_SCENARIO then
						slot0.lastClickBtn = slot1.PowerUpBtn.EquipLevelUp

						slot0:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						slot0:emit(BattleFailTipMediator.GO_DOCKYARD_EQUIP)
					end
				end
			})
		else
			slot0.emit(slot0, BattleFailTipMediator.GO_DOCKYARD_EQUIP)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.skillLevelUpBtn, function ()
		slot0:emit(BattleFailTipMediator.GO_NAVALTACTICS)
	end, SFX_PANEL)
	onButton(slot0, slot0.shipBreakUpBtn, function ()
		if slot0.battleSystem == SYSTEM_SCENARIO then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("fight_strengthen"),
				onYes = function ()
					if slot0.contextData.battleSystem == SYSTEM_SCENARIO then
						slot0.lastClickBtn = slot1.PowerUpBtn.ShipBreakUp

						slot0:emit(BattleFailTipMediator.CHAPTER_RETREAT)
					else
						slot0:emit(BattleFailTipMediator.GO_DOCKYARD_SHIP)
					end
				end
			})
		else
			slot0.emit(slot0, BattleFailTipMediator.GO_DOCKYARD_SHIP)
		end
	end, SFX_PANEL)
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:aniBeforeEnter()
end

slot0.onBackPressed = function (slot0)
	slot0:closeView()
end

slot0.willExit = function (slot0)
	LeanTween.cancel(go(slot0._tf))
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

slot0.aniBeforeEnter = function (slot0)
	slot1 = GetComponent(slot0._tf, "CanvasGroup")

	LeanTween.value(go(slot0._tf), 0, 1, 0.6):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))
end

return slot0

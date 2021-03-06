ys = ys or {}
slot1 = ys.Battle.BattleConfig
ys.Battle.BattleSkillView = class("BattleSkillView")
ys.Battle.BattleSkillView.__name = "BattleSkillView"

ys.Battle.BattleSkillView.Ctor = function (slot0, slot1)
	slot0.EventListener.AttachEventListener(slot0)

	slot0._mediator = slot1
	slot0._ui = slot1._ui

	slot0:InitBtns()
	slot0:EnableWeaponButton(false)
end

ys.Battle.BattleSkillView.EnableWeaponButton = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._skillBtnList) do
		slot6:Enabled(slot1)
	end
end

ys.Battle.BattleSkillView.DisableWeapnButton = function (slot0)
	for slot4, slot5 in ipairs(slot0._skillBtnList) do
		slot5:Disable()
	end
end

ys.Battle.BattleSkillView.JamSkillButton = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._skillBtnList) do
		slot6:SetJam(slot1)
	end
end

ys.Battle.BattleSkillView.ShiftSubmarineManualButton = function (slot0, slot1)
	if slot1 == slot0.Battle.OxyState.STATE_FREE_FLOAT then
		slot0._diveBtn:SetActive(true)
		slot0._floatBtn:SetActive(false)
	elseif slot1 == slot0.Battle.OxyState.STATE_FREE_DIVE then
		slot0._diveBtn:SetActive(false)
		slot0._floatBtn:SetActive(true)
	end
end

ys.Battle.BattleSkillView.InitBtns = function (slot0)
	slot0._skillBtnList = {}
	slot0._activeBtnList = {}
	slot0._fleetVO = slot0._mediator._dataProxy:GetFleetByIFF(slot0.Battle.BattleConfig.FRIENDLY_CODE)
	slot0._chargeBtn = slot0.Battle.BattleWeaponButton.New()

	table.insert(slot0._skillBtnList, slot0._chargeBtn)
	slot0._chargeBtn.ConfigCallback(slot5, slot2, slot3, slot4, slot1)
	slot0:setSkillButtonPreferences(slot5, 1)
	slot0._chargeBtn:ConfigSkin(slot5)
	slot0._chargeBtn:SetTextActive(true)
	slot0._chargeBtn:SetProgressInfo(slot6)

	slot0._torpedoBtn = slot0.Battle.BattleWeaponButton.New()

	table.insert(slot0._skillBtnList, slot0._torpedoBtn)
	slot0._torpedoBtn.ConfigCallback(slot10, slot7, slot8, slot9, slot1)
	slot0:setSkillButtonPreferences(slot10, 2)
	slot0._torpedoBtn:ConfigSkin(slot10)
	slot0._torpedoBtn:SetTextActive(true)
	slot0._torpedoBtn:SetProgressInfo(slot11)

	slot0._airStrikeBtn = slot0.Battle.BattleWeaponButton.New()

	table.insert(slot0._skillBtnList, slot0._airStrikeBtn)
	slot0._airStrikeBtn.ConfigCallback(slot15, slot14, slot12, slot13, slot1)
	slot0:setSkillButtonPreferences(slot15, 3)
	slot0._airStrikeBtn:ConfigSkin(slot15)
	slot0._airStrikeBtn:SetTextActive(true)
	slot0._airStrikeBtn:SetProgressInfo(slot16)

	slot0._diveBtn = slot0.Battle.BattleSubmarineFuncButton.New()

	table.insert(slot0._skillBtnList, slot0._diveBtn)
	slot0._diveBtn.ConfigCallback(slot20, slot17, slot18, slot19, slot1)
	slot0._diveBtn:ConfigSkin(slot20)
	slot0._diveBtn:SetTextActive(true)
	slot0._diveBtn:SetProgressInfo(slot21)
	slot0._diveBtn:SetActive(false)

	slot0._floatBtn = slot0.Battle.BattleSubmarineFuncButton.New()

	table.insert(slot0._skillBtnList, slot0._floatBtn)
	slot0._floatBtn.ConfigCallback(slot25, slot22, slot23, slot24, slot1)
	slot0._floatBtn:ConfigSkin(slot25)
	slot0._floatBtn:SetTextActive(true)
	slot0._floatBtn:SetProgressInfo(slot26)
	slot0._floatBtn:SetActive(false)

	slot0._boostBtn = slot0.Battle.BattleSubmarineFuncButton.New()

	table.insert(slot0._skillBtnList, slot0._boostBtn)
	slot0._boostBtn.ConfigCallback(slot30, slot27, slot28, slot29, slot1)
	slot0._boostBtn:ConfigSkin(slot30)
	slot0._boostBtn:SetTextActive(true)
	slot0._boostBtn:SetProgressInfo(slot31)

	slot0._specialBtn = slot0.Battle.BattleSubmarineButton.New()

	table.insert(slot0._skillBtnList, slot0._specialBtn)
	slot0._specialBtn.ConfigCallback(slot35, slot32, slot33, slot34, slot1)
	slot0._specialBtn:ConfigSkin(slot35)
	slot0._specialBtn:SetTextActive(true)
	slot0._specialBtn:SetProgressInfo(slot36)

	slot0._shiftBtn = slot0.Battle.BattleSubmarineFuncButton.New()

	table.insert(slot0._skillBtnList, slot0._shiftBtn)
	slot0._shiftBtn.ConfigCallback(slot40, slot37, slot38, slot39, slot1)
	slot0._shiftBtn:ConfigSkin(slot40)
	slot0._shiftBtn:SetTextActive(true)
	slot0._shiftBtn:SetProgressInfo(slot41)

	slot42 = slot0._ui:findTF("Skill_4")

	if not slot0._fleetVO._submarineVO:GetUseable() or slot43:GetCount() <= 0 then
		SetActive(slot42, false)
	else
		slot0._subStriveBtn = slot0.Battle.BattleSubmarineButton.New()

		table.insert(slot0._skillBtnList, slot0._subStriveBtn)
		slot0._subStriveBtn.ConfigCallback(slot47, slot46, slot44, slot45, slot1)
		slot0:setSkillButtonPreferences(slot42, 4)
		slot0._subStriveBtn:ConfigSkin(slot42)
		slot0._subStriveBtn:SetTextActive(true)
		slot0._subStriveBtn:SetProgressInfo(slot43)

		slot47 = slot42:GetComponent(typeof(Animator))

		slot42:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot48, function (slot0)
			slot0.enabled = false
		end)
		table.insert(slot0._activeBtnList, slot0._subStriveBtn)
	end

	slot44 = slot0.Battle.BattleWeaponButton.New()

	table.insert(slot0._skillBtnList, slot44)
	slot44:ConfigCallback(slot7, slot8, slot9, slot1)

	slot45 = slot0._ui:findTF("Skill_10")

	slot0:setSkillButtonPreferences(slot45, 2)

	slot45.anchoredPosition = Vector2.zero

	slot44:ConfigSkin(slot45)
	slot44:SetTextActive(true)
	slot44:SetProgressInfo(slot11)
	slot44:SetActive(false)
	slot0._boostBtn:SetActive(false)
	slot0._diveBtn:SetActive(false)
	slot0._floatBtn:SetActive(false)
	slot0._specialBtn:SetActive(false)
	slot0._shiftBtn:SetActive(false)
end

ys.Battle.BattleSkillView.CustomButton = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		slot0._skillBtnList[slot6]:SetActive(false)
	end
end

ys.Battle.BattleSkillView.NormalButton = function (slot0)
	slot0._chargeBtn:SetActive(true)
	slot0._torpedoBtn:SetActive(true)
	slot0._airStrikeBtn:SetActive(true)
	slot0._boostBtn:SetActive(false)
	slot0._diveBtn:SetActive(false)
	slot0._floatBtn:SetActive(false)
	slot0._specialBtn:SetActive(false)
	slot0._shiftBtn:SetActive(false)
	table.insert(slot0._activeBtnList, slot0._chargeBtn)
	table.insert(slot0._activeBtnList, slot0._torpedoBtn)
	table.insert(slot0._activeBtnList, slot0._airStrikeBtn)
end

ys.Battle.BattleSkillView.SubmarineButton = function (slot0)
	slot0._chargeBtn:SetActive(false)
	slot0._torpedoBtn:SetActive(true)
	slot0._airStrikeBtn:SetActive(false)
	slot0._boostBtn:SetActive(true)
	slot0._diveBtn:SetActive(true)
	slot0._floatBtn:SetActive(true)
	table.insert(slot0._activeBtnList, slot0._diveBtn)
	table.insert(slot0._activeBtnList, slot0._torpedoBtn)
	table.insert(slot0._activeBtnList, slot0._boostBtn)
	table.insert(slot0._activeBtnList, slot0._floatBtn)

	slot0._torpedoBtn:GetSkin().transform.anchorMin = Vector2(slot0.SKILL_BUTTON_DEFAULT_PREFERENCE[2].x, slot0.SKILL_BUTTON_DEFAULT_PREFERENCE[2].y)
	slot0._torpedoBtn.GetSkin().transform.anchorMax = Vector2(slot0.SKILL_BUTTON_DEFAULT_PREFERENCE[2].x, slot0.SKILL_BUTTON_DEFAULT_PREFERENCE[2].y)
end

ys.Battle.BattleSkillView.SubRoutineButton = function (slot0)
	slot0._chargeBtn:SetActive(false)
	slot0._torpedoBtn:SetActive(true)
	slot0._airStrikeBtn:SetActive(false)
	slot0._boostBtn:SetActive(false)
	slot0._diveBtn:SetActive(true)
	slot0._floatBtn:SetActive(true)
	slot0._specialBtn:SetActive(true)
	slot0._shiftBtn:SetActive(true)
	table.insert(slot0._activeBtnList, slot0._diveBtn)
	table.insert(slot0._activeBtnList, slot0._torpedoBtn)
	table.insert(slot0._activeBtnList, slot0._specialBtn)
	table.insert(slot0._activeBtnList, slot0._floatBtn)
	table.insert(slot0._activeBtnList, slot0._shiftBtn)
	slot0:setSkillButtonPreferences(slot0._diveBtn:GetSkin(), 1)
	slot0:setSkillButtonPreferences(slot0._floatBtn:GetSkin(), 1)
	slot0:setSkillButtonPreferences(slot0._torpedoBtn:GetSkin(), 2)
	slot0:setSkillButtonPreferences(slot0._shiftBtn:GetSkin(), 3)
	slot0:setSkillButtonPreferences(slot0._specialBtn:GetSkin(), 4)
end

ys.Battle.BattleSkillView.AirFightButton = function (slot0)
	slot1 = {
		9
	}

	for slot5, slot6 in ipairs(slot0._skillBtnList) do
		slot6:SetActive(table.indexof(slot1, slot5))

		if table.indexof(slot1, slot5) then
			table.insert(slot0._activeBtnList, slot6)
			slot0:setSkillButtonPreferences(slot6:GetSkin(), slot7)
		end
	end
end

ys.Battle.BattleSkillView.HideSkillButton = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._activeBtnList) do
		slot6:SetActive(not slot1)
	end
end

ys.Battle.BattleSkillView.OnSkillCd = function (slot0, slot1)
	slot2 = slot1.Data.skillID

	if slot1.Data.coolDownTime < pg.TimeMgr.GetInstance():GetCombatTime() then
		return
	end

	slot0._skillCd[slot2] = slot3
end

ys.Battle.BattleSkillView.Dispose = function (slot0)
	slot0._activeBtnList = nil

	for slot4, slot5 in ipairs(slot0._skillBtnList) do
		slot5:Dispose()
	end

	slot0._ui = nil

	if slot0._main_cannon_sound then
		slot0._main_cannon_sound:Stop(true)

		slot0._main_cannon_sound = nil
	end

	slot0.EventListener.DetachEventListener(slot0)
end

ys.Battle.BattleSkillView.Update = function (slot0)
	for slot4, slot5 in ipairs(slot0._skillBtnList) do
		slot5:Update()
	end
end

ys.Battle.BattleSkillView.setSkillButtonPreferences = function (slot0, slot1, slot2)
	slot1.transform.localScale = Vector3(slot4, slot4, 0)
	slot1.transform.anchorMin = Vector2(slot5, slot6)
	slot1.transform.anchorMax = Vector2(PlayerPrefs.GetFloat("skill_" .. slot2 .. "_anchorX", slot0.SKILL_BUTTON_DEFAULT_PREFERENCE[slot2].x), PlayerPrefs.GetFloat("skill_" .. slot2 .. "_anchorY", slot0.SKILL_BUTTON_DEFAULT_PREFERENCE[slot2].y))
end

return

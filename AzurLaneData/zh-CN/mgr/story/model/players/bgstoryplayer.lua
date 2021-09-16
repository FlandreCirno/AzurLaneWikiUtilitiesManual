slot0 = class("BgStoryPlayer", import(".DialogueStoryPlayer"))

slot0.Reset = function (slot0, slot1, slot2)
	slot0.super.super.Reset(slot0, slot1, slot2)
	setActive(slot0.bgPanel, true)
	slot0:RecyclePainting({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	})
end

slot0.OnBgUpdate = function (slot0, slot1)
	slot0:TweenValueForcanvasGroup(slot0.bgPanelCg, 0, 1, slot1:GetFadeSpeed(), 0, nil)
end

slot0.UpdateBg = function (slot0, slot1)
	if not slot1:GetBgName() then
		return
	end

	slot0.super.UpdateBg(slot0, slot1)
end

slot0.OnInit = function (slot0, slot1, slot2)
	if slot1:ShouldBlackScreen() then
		setActive(slot0.curtain, true)
		slot0.curtain:SetAsLastSibling()
		slot2()
	else
		slot0.super.OnInit(slot0, slot1, slot2)
	end
end

slot0.OnEnter = function (slot0, slot1, slot2, slot3)
	if slot1:ShouldBlackScreen() then
		slot0:DelayCall(slot1:ShouldBlackScreen(), function ()
			setActive(slot0.curtain, true)
			setActive.curtain:SetAsFirstSibling()
			slot1()
			triggerButton(slot0._go)
		end)
	else
		slot4 = slot1.GetUnscaleDelay(slot1)

		if slot0.autoNext then
			slot4 = slot4 - slot0.script:GetTriggerDelayTime()
		end

		slot0:UnscaleDelayCall(slot4, function ()
			slot0.super.OnEnter(slot1, slot2, slot3, slot4)
		end)
	end
end

slot0.GetSideTF = function (slot0, slot1)
	slot2, slot3, slot4, slot5 = nil

	if DialogueStep.SIDE_LEFT == slot1 then
		slot5 = nil
		slot4 = slot0.nameLeftTxt
		slot3 = slot0.nameLeft
		slot2 = nil
	elseif DialogueStep.SIDE_RIGHT == slot1 then
		slot5 = nil
		slot4 = slot0.nameRightTxt
		slot3 = slot0.nameRight
		slot2 = nil
	elseif DialogueStep.SIDE_MIDDLE == slot1 then
		slot5 = nil
		slot4 = slot0.nameLeftTxt
		slot3 = slot0.nameLeft
		slot2 = nil
	end

	return slot2, slot3, slot4, slot5
end

return slot0

slot0 = class("Story")
slot0.MODE_ASIDE = 1
slot0.MODE_DIALOGUE = 2
slot0.MODE_BG = 3
slot0.MODE_CAROUSE = 4
slot0.STORY_AUTO_SPEED = {
	-9,
	0,
	5,
	9
}
slot0.TRIGGER_DELAY_TIME = {
	4,
	3,
	1.5,
	0
}

slot0.GetStoryStepCls = function (slot0)
	return ({
		AsideStep,
		DialogueStep,
		BgStep,
		CarouselStep
	})[slot0]
end

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.name = slot1.id
	slot0.mode = slot1.mode
	slot0.once = slot1.once
	slot0.fadeOut = slot1.fadeOut
	slot0.hideSkip = slot1.hideSkip
	slot0.skipTip = defaultValue(slot1.skipTip, true)
	slot0.noWaitFade = defaultValue(slot1.noWaitFade, false)
	slot0.speedData = slot1.speed or getProxy(SettingsProxy):GetStorySpeed() or 0
	slot0.steps = {}
	slot5 = 0
	slot6 = slot3 or {}

	for slot10, slot11 in ipairs(slot1.scripts) do
		if slot0.GetStoryStepCls(slot11.mode or slot0.mode).New(slot11):ExistOption() and slot6[slot5 + 1] then
			slot14:SetOptionSelCodes(slot6[slot5])
		end

		table.insert(slot0.steps, slot14)
	end

	slot0.branchCode = nil
	slot0.force = slot2
	slot0.isPlayed = pg.NewStoryMgr:GetInstance():IsPlayed(slot0.name)
	slot0.nextScriptName = nil
	slot0.skipAll = false
	slot0.isAuto = false
	slot0.speed = 0
end

slot0.GetTriggerDelayTime = function (slot0)
	if table.indexof(slot0.STORY_AUTO_SPEED, slot0.speedData) then
		return slot0.TRIGGER_DELAY_TIME[slot1] or 0
	end

	return 0
end

slot0.SetAutoPlay = function (slot0)
	slot0.isAuto = true

	slot0:SetPlaySpeed(slot0.speedData)
end

slot0.StopAutoPlay = function (slot0)
	slot0.isAuto = false

	slot0:ResetSpeed()
end

slot0.SetPlaySpeed = function (slot0, slot1)
	slot0.speed = slot1
end

slot0.ResetSpeed = function (slot0)
	slot0.speed = 0
end

slot0.GetPlaySpeed = function (slot0)
	return slot0.speed
end

slot0.GetAutoPlayFlag = function (slot0)
	return slot0.isAuto
end

slot0.ShowSkipTip = function (slot0)
	return slot0.skipTip
end

slot0.ShouldWaitFadeout = function (slot0)
	return not slot0.noWaitFade
end

slot0.ShouldHideSkip = function (slot0)
	return slot0.hideSkip
end

slot0.CanPlay = function (slot0)
	return slot0.force or not slot0.isPlayed
end

slot0.GetId = function (slot0)
	return slot0.name
end

slot0.GetName = function (slot0)
	return slot0.name
end

slot0.GetStepByIndex = function (slot0, slot1)
	if not slot0.steps[slot1] or (slot0.branchCode and not slot2:IsSameBranch(slot0.branchCode)) then
		return nil
	end

	return slot2
end

slot0.GetNextStep = function (slot0, slot1)
	if slot1 >= #slot0.steps then
		return nil
	end

	if not slot0:GetStepByIndex(slot1 + 1) and slot2 < #slot0.steps then
		return slot0:GetNextStep(slot2)
	else
		return slot3
	end
end

slot0.GetPrevStep = function (slot0, slot1)
	if slot1 <= 1 then
		return nil
	end

	if not slot0:GetStepByIndex(slot1 - 1) and slot2 > 1 then
		return slot0:GetPrevStep(slot2)
	else
		return slot3
	end
end

slot0.ShouldFadeout = function (slot0)
	return slot0.fadeOut ~= nil
end

slot0.GetFadeoutTime = function (slot0)
	return slot0.fadeOut
end

slot0.IsPlayed = function (slot0)
	return slot0.isPlayed
end

slot0.SetBranchCode = function (slot0, slot1)
	slot0.branchCode = slot1
end

slot0.GetBranchCode = function (slot0)
	return slot0.branchCode
end

slot0.GetNextScriptName = function (slot0)
	return slot0.nextScriptName
end

slot0.SetNextScriptName = function (slot0, slot1)
	slot0.nextScriptName = slot1
end

slot0.SkipAll = function (slot0)
	slot0.skipAll = true
end

slot0.StopSkip = function (slot0)
	slot0.skipAll = false
end

slot0.ShouldSkipAll = function (slot0)
	return slot0.skipAll
end

return slot0

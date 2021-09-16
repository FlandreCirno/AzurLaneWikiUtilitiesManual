slot0 = class("StoryStep")

slot0.Ctor = function (slot0, slot1)
	slot0.flashout = slot1.flashout
	slot0.flashin = slot1.flashin
	slot0.bgName = slot1.bgName
	slot0.bgShadow = slot1.bgShadow
	slot0.blackBg = slot1.blackBg
	slot0.bgGlitchArt = slot1.bgNoise
	slot0.oldPhoto = slot1.oldPhoto
	slot0.bgm = slot1.bgm
	slot0.bgmDelay = slot1.bgmDelay or 0
	slot0.stopbgm = slot1.stopbgm
	slot0.effects = slot1.effects or {}
	slot0.blink = slot1.flash
	slot0.blinkWithColor = slot1.flashN
	slot0.soundeffect = slot1.soundeffect
	slot0.seDelay = slot1.seDelay or 0
	slot0.voice = slot1.voice
	slot0.voiceDelay = slot1.voiceDelay or 0
	slot0.options = slot1.options
	slot0.important = slot1.important
	slot0.branchCode = slot1.optionFlag
	slot0.nextScriptName = slot1.jumpto
end

slot0.OldPhotoEffect = function (slot0)
	return slot0.oldPhoto
end

slot0.ShouldBgGlitchArt = function (slot0)
	return slot0.bgGlitchArt
end

slot0.IsSameBranch = function (slot0, slot1)
	return not slot0.branchCode or slot0.branchCode == slot1
end

slot0.GetMode = function (slot0)
	return
end

slot0.GetFlashoutData = function (slot0)
	if slot0.flashout then
		return slot0.flashout.alpha[1], slot0.flashout.alpha[2], slot0.flashout.dur, slot0.flashout.black
	end
end

slot0.GetFlashinData = function (slot0)
	if slot0.flashin then
		return slot0.flashin.alpha[1], slot0.flashin.alpha[2], slot0.flashin.dur, slot0.flashin.black, slot0.flashin.delay
	end
end

slot0.IsBlackBg = function (slot0)
	return slot0.blackBg
end

slot0.GetBgName = function (slot0)
	return slot0.bgName
end

slot0.GetBgShadow = function (slot0)
	return slot0.bgShadow
end

slot0.IsDialogueMode = function (slot0)
	return slot0:GetMode() == Story.MODE_DIALOGUE
end

slot0.GetBgmData = function (slot0)
	return slot0.bgm, slot0.bgmDelay, slot0.stopbgm
end

slot0.ShoulePlayBgm = function (slot0)
	return slot0.bgm ~= nil
end

slot0.ShouldStopBgm = function (slot0)
	return slot0.stopbgm
end

slot0.GetEffects = function (slot0)
	return slot0.effects
end

slot0.ShouldBlink = function (slot0)
	return slot0.blink ~= nil
end

slot0.GetBlinkData = function (slot0)
	return slot0.blink
end

slot0.ShouldBlinkWithColor = function (slot0)
	return slot0.blinkWithColor ~= nil
end

slot0.GetBlinkWithColorData = function (slot0)
	return slot0.blinkWithColor
end

slot0.ShouldPlaySoundEffect = function (slot0)
	return slot0.soundeffect ~= nil
end

slot0.GetSoundeffect = function (slot0)
	return slot0.soundeffect, slot0.seDelay
end

slot0.ShouldPlayVoice = function (slot0)
	return slot0.voice ~= nil
end

slot0.GetVoice = function (slot0)
	return slot0.voice, slot0.voiceDelay
end

slot0.ExistOption = function (slot0)
	return slot0.options ~= nil and #slot0.options > 0
end

slot0.SetOptionSelCodes = function (slot0, slot1)
	slot0.optionSelCode = slot1
end

slot0.GetOptionIndexByAutoSel = function (slot0)
	slot1 = 0
	slot2 = 0

	for slot6, slot7 in ipairs(slot0.options) do
		if slot0.optionSelCode and slot7.flag == slot0.optionSelCode then
			slot1 = slot6

			break
		end

		if slot7.autochoice and slot7.autochoice == 1 then
			slot2 = slot6
		end
	end

	if slot1 > 0 then
		return slot1
	end

	if slot2 > 0 then
		return slot2
	end

	return nil
end

slot0.IsImport = function (slot0)
	return slot0.important
end

slot0.GetOptions = function (slot0)
	return _.map(slot0.options or {}, function (slot0)
		return {
			HXSet.hxLan(slot0.content),
			slot0.flag
		}
	end)
end

slot0.ShouldJumpToNextScript = function (slot0)
	return slot0.nextScriptName ~= nil
end

slot0.GetNextScriptName = function (slot0)
	return slot0.nextScriptName
end

return slot0

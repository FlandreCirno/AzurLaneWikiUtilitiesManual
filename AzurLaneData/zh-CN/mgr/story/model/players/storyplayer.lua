slot0 = class("StoryPlayer", import("..animation.StoryAnimtion"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0)
	pg.DelegateInfo.New(slot0)

	slot0._go = slot1
	slot0._tf = slot1.transform
	slot0.goCG = GetOrAddComponent(slot0._tf, typeof(CanvasGroup))
	slot0.asidePanel = slot0:findTF("aside_panel")
	slot0.bgGlitch = slot0:findTF("bg_glitch")
	slot0.oldPhoto = slot0:findTF("oldphoto"):GetComponent(typeof(Image))
	slot0.bgPanel = slot0:findTF("bg")
	slot0.bgPanelCg = slot0.bgPanel:GetComponent(typeof(CanvasGroup))
	slot0.bgImage = slot0:findTF("image", slot0.bgPanel):GetComponent(typeof(Image))
	slot0.dialoguePanel = slot0:findTF("dialogue")
	slot0.effectPanel = slot0:findTF("effect")
	slot0.curtain = slot0:findTF("curtain")
	slot0.curtainCg = slot0.curtain:GetComponent(typeof(CanvasGroup))
	slot0.flash = slot0:findTF("flash")
	slot0.flashImg = slot0.flash:GetComponent(typeof(Image))
	slot0.flashCg = slot0.flash:GetComponent(typeof(CanvasGroup))
	slot0.optionUIlist = UIItemList.New(slot0:findTF("options_panel/options"), slot0:findTF("options_panel/options/option_tpl"))
	slot0.optionPrint = slot0:findTF("options_panel/bg")
	slot0.optionsCg = slot0:findTF("options_panel"):GetComponent(typeof(CanvasGroup))
	slot0.bgs = {}
	slot0.stop = false
	slot0.pause = false
end

slot0.Pause = function (slot0)
	slot0.pause = true

	slot0:PauseAllAnimation()
	setActive(slot0.effectPanel, false)
end

slot0.Resume = function (slot0)
	slot0.pause = false

	slot0:ResumeAllAnimation()
	setActive(slot0.effectPanel, true)
end

slot0.Stop = function (slot0)
	slot0.stop = true

	slot0:NextOneImmediately()
end

slot0.Play = function (slot0, slot1, slot2, slot3)
	if not slot1 then
		slot3()

		return
	end

	if slot1:GetNextScriptName() or slot0.stop then
		slot3()

		return
	end

	if not slot1:GetStepByIndex(slot2) then
		slot3()

		return
	end

	if slot4:ShouldJumpToNextScript() then
		slot1:SetNextScriptName(slot4:GetNextScriptName())
		slot3()

		return
	end

	if slot1:ShouldSkipAll() and slot4:ExistOption() and not pg.NewStoryMgr.GetInstance():IsReView() then
		slot1:StopSkip()
	elseif slot1:ShouldSkipAll() then
		slot3()

		return
	end

	slot0.script = slot1
	slot0.callback = slot3
	slot0.step = slot4
	slot0.autoNext = slot1:GetAutoPlayFlag()
	slot0.isRegisterEvent = false

	if slot0.autoNext and slot4:IsImport() then
		slot0.autoNext = nil
	end

	slot0:SetTimeScale(1 - slot1:GetPlaySpeed() * 0.1)

	slot5 = slot1:GetNextStep(slot2)
	slot6 = slot1:GetPrevStep(slot2)

	seriesAsync({
		function (slot0)
			slot0:Reset(slot0.Reset, slot0)
			slot0:UpdateBg(slot0.UpdateBg)
			slot0:PlayBgm(slot0.PlayBgm)
			parallelAsync({
				function (slot0)
					slot0:LoadEffects(slot0.LoadEffects, slot0)
				end,
				function (slot0)
					slot0:flashin(slot0.flashin, slot0)
				end
			}, slot0)
		end,
		function (slot0)
			parallelAsync({
				function (slot0)
					slot0:OnInit(slot0.OnInit, slot0)
				end,
				function (slot0)
					slot0:PlaySoundEffect(slot0.PlaySoundEffect)
					slot0:StartUIAnimations(slot0.StartUIAnimations, slot0)
				end,
				function (slot0)
					slot0:OnEnter(slot0.OnEnter, slot0, slot0)
				end
			}, slot0)
		end,
		function (slot0)
			function slot1()
				slot0.isRegisterEvent = true

				if slot0.pause or slot0.stop then
					return
				end

				if slot0.autoNext then
					slot0.autoNext = nil

					slot0:UnscaleDelayCall(nil:GetTriggerDelayTime(), function ()
						slot0:TriggerEventAuto()
					end)
				end
			end

			if slot2.ExistOption(slot2) then
				slot0:InitBranches(slot1, slot0.InitBranches, slot0, slot1)
			else
				slot0:RegisetEvent(slot0)
				slot1()
			end
		end,
		function (slot0)
			parallelAsync({
				function (slot0)
					slot0:ClearAnimation()
					slot0:OnWillExit(slot0.OnWillExit, slot0, slot0)
				end,
				function (slot0)
					if not slot0 then
						slot0()

						return
					end

					slot1:Flashout(slot0, slot0)
				end,
				function (slot0)
					if slot0 then
						slot0()

						return
					end

					slot1:FadeOutStory(slot1, slot0)
				end
			}, slot0)
		end,
		function (slot0)
			slot0:Clear(slot0)
		end
	}, slot3)
end

slot0.CanSkip = function (slot0)
	return slot0.step and not slot0.step:ExistOption()
end

slot0.NextOne = function (slot0)
	slot0.timeScale = 0.0001

	if slot0.isRegisterEvent then
		slot0:TriggerEventAuto()
	else
		slot0.autoNext = true
	end
end

slot0.NextOneImmediately = function (slot0)
	if slot0.callback then
		slot0:ClearAnimation()
		slot0:Clear()
		slot1()
	end
end

slot0.TriggerEventAuto = function (slot0)
	if slot0.step:ExistOption() then
		if slot0.step:GetOptionIndexByAutoSel() ~= nil then
			triggerButton(slot0.optionUIlist.container:GetChild(slot1 - 1):Find("content"))
		end
	else
		triggerButton(slot0._go)
	end
end

slot0.InitBranches = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = false

	slot0.optionUIlist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot2:Find("content")
			slot5 = slot0[slot1 + 1][2]

			onButton(slot1, slot3, function ()
				if slot0.pause or slot0.stop then
					return
				end

				if not slot1 then
					return
				end

				slot2:SetBranchCode(slot3)
				slot2.SetBranchCode:ShowOrHideBranches(false, slot4)
			end, SFX_PANEL)
			setText(slot3.Find(slot3, "Text"), slot4)
			setActive(slot3, false)
		end
	end)
	slot0.optionUIlist.align(slot7, #slot2:GetOptions())
	slot0:ShowOrHideBranches(true, function ()
		slot0 = true

		if slot1 then
			slot1()
		end
	end)
end

slot0.ShowOrHideBranches = function (slot0, slot1, slot2)
	if LeanTween.isTweening(go(slot0.optionsCg)) then
		return
	end

	setActive(slot0.optionsCg.gameObject, true)

	if slot1 then
		slot0:TweenRotate(slot0.optionPrint, 360, 5, -1, 0)
	else
		slot0:CancelTween(slot0.optionPrint.gameObject)
	end

	table.insert(slot3, function (slot0)
		slot2 = (not slot0 or 0) and 1264
		slot3 = (slot0 and 1264) or 0

		({})["optionUIlist"]:eachActive(function (slot0, slot1)
			setAnchoredPosition(slot2, {
				x = slot0
			})
			table.insert(slot1, function (slot0)
				setActive(slot0, true)
				setActive:TweenValue(slot0, slot0.localPosition.x, setActive, 0.5, slot3 * 0.1, function (slot0)
					setAnchoredPosition(slot0, {
						x = slot0
					})
				end, slot0)
			end)
		end)
		parallelAsync(slot1, slot0)
	end)
	table.insert(slot3, function (slot0)
		(not slot0 or 0) and 525:TweenMovex(rtf((not slot0 or 0) and 525.optionPrint), (not slot0 or 0) and 525, (slot0 and 525) or 0, 0.5, 0, nil, slot0)
	end)
	table.insert(slot3, function (slot0)
		(not slot0 or 0) and 1:TweenValue(go((not slot0 or 0) and 1.optionsCg), (not slot0 or 0) and 1, (slot0 and 1) or 0, 0.2, 0, function (slot0)
			slot0.optionsCg.alpha = slot0
		end, slot0)
	end)
	parallelAsync(slot3, slot2)
end

slot0.FadeOutStory = function (slot0, slot1, slot2)
	if not slot1:ShouldFadeout() then
		slot2()

		return
	end

	slot3 = slot1:GetFadeoutTime()

	if not slot1:ShouldWaitFadeout() then
		slot0:fadeTransform(slot0._go, 1, 0.3, slot3, true)
		slot2()
	else
		slot0:fadeTransform(slot0._go, 1, 0.3, slot3, true, slot2)
	end
end

slot0.fadeTransform = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot7 = {}
	slot8 = {}

	for slot13 = 0, slot1:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
		slot15 = {
			name = "_Color",
			color = Color.white
		}

		if slot9[slot13].material.shader.name == "UI/GrayScale" then
			slot15 = {
				name = "_GrayScale",
				color = Color.New(0.21176470588235294, 0.7137254901960784, 0.07058823529411765)
			}
		elseif slot14.material.shader.name == "UI/Line_Add_Blue" then
			slot15 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.5882352941176471)
			}
		end

		table.insert(slot8, slot15)

		if slot14.material == slot14.defaultGraphicMaterial then
			slot14.material = Material.Instantiate(slot14.defaultGraphicMaterial)
		end

		table.insert(slot7, slot14.material)
	end

	LeanTween.value(go(slot1), slot2, slot3, slot4):setOnUpdate(System.Action_float(function (slot0)
		for slot4, slot5 in ipairs(slot0) do
			if not IsNil(slot5) then
				slot5:SetColor(slot1[slot4].name, slot1[slot4].color * Color.New(slot0, slot0, slot0))
			end
		end
	end)).setOnComplete(slot10, System.Action(function ()
		if slot0 then
			for slot3, slot4 in ipairs(slot1) do
				if not IsNil(slot4) then
					slot4:SetColor(slot2[slot3].name, slot2[slot3].color)
				end
			end
		end

		if slot3 then
			slot3()
		end
	end))
end

slot0.setPaintingAlpha = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = {}

	for slot9 = 0, slot1:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
		slot11 = {
			name = "_Color",
			color = Color.white
		}

		if slot5[slot9].material.shader.name == "UI/GrayScale" then
			slot11 = {
				name = "_GrayScale",
				color = Color.New(0.21176470588235294, 0.7137254901960784, 0.07058823529411765)
			}
		elseif slot10.material.shader.name == "UI/Line_Add_Blue" then
			slot11 = {
				name = "_GrayScale",
				color = Color.New(1, 1, 1, 0.5882352941176471)
			}
		end

		table.insert(slot4, slot11)

		if slot10.material == slot10.defaultGraphicMaterial then
			slot10.material = Material.Instantiate(slot10.defaultGraphicMaterial)
		end

		table.insert(slot3, slot10.material)
	end

	for slot9, slot10 in ipairs(slot3) do
		if not IsNil(slot10) then
			slot10:SetColor(slot4[slot9].name, slot4[slot9].color * Color.New(slot2, slot2, slot2))
		end
	end
end

slot0.RegisetEvent = function (slot0, slot1)
	setButtonEnabled(slot0._go, not slot0.autoNext)
	onButton(slot0, slot0._go, function ()
		if slot0.pause or slot0.stop then
			return
		end

		removeOnButton(slot0._go)
		slot0._go()
	end, SFX_PANEL)
end

slot0.flashEffect = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot0.flashImg.color = (slot4 and Color(0, 0, 0)) or Color(1, 1, 1)
	slot0.flashCg.alpha = slot1

	setActive(slot0.flash, true)
	slot0:TweenValueForcanvasGroup(slot0.flashCg, slot1, slot2, slot3, slot5, slot6)
end

slot0.Flashout = function (slot0, slot1, slot2)
	slot3, slot4, slot5, slot6 = slot1:GetFlashoutData()

	if not slot3 then
		slot2()

		return
	end

	slot0:flashEffect(slot3, slot4, slot5, slot6, 0, slot2)
end

slot0.flashin = function (slot0, slot1, slot2)
	slot3, slot4, slot5, slot6, slot7 = slot1:GetFlashinData()

	if not slot3 then
		slot2()

		return
	end

	slot0:flashEffect(slot3, slot4, slot5, slot6, slot7, slot2)
end

slot0.UpdateBg = function (slot0, slot1)
	if slot1:ShouldBgGlitchArt() then
		slot0:SetBgGlitchArt(slot1)
	else
		if slot1:GetBgName() then
			setActive(slot0.bgPanel, true)

			slot0.bgPanelCg.alpha = 1
			slot0.bgImage.color = Color.New(1, 1, 1)
			slot0.bgImage.sprite = slot0:GetBg(slot2)
		end

		if slot1:GetBgShadow() then
			slot0:TweenValue(slot0.bgImage, slot3[1], slot3[2], slot3[3], 0, function (slot0)
				slot0.color = Color.New(slot0, slot0, slot0)
			end, nil)
		end

		if slot1.IsBlackBg(slot1) then
			setActive(slot0.curtain, true)

			slot0.curtainCg.alpha = 1
		end
	end

	slot0:ApplyOldPhotoEffect(slot1)
	slot0:OnBgUpdate(slot1)
end

slot0.ApplyOldPhotoEffect = function (slot0, slot1)
	setActive(slot0.oldPhoto.gameObject, slot1:OldPhotoEffect() ~= nil)

	if slot1.OldPhotoEffect() ~= nil then
		if type(slot2) == "table" then
			slot0.oldPhoto.color = Color.New(slot2[1], slot2[2], slot2[3], slot2[4])
		else
			slot0.oldPhoto.color = Color.New(0.62, 0.58, 0.14, 0.36)
		end
	end
end

slot0.SetBgGlitchArt = function (slot0, slot1)
	setActive(slot0.bgPanel, false)
	setActive(slot0.bgGlitch, true)
end

slot0.GetBg = function (slot0, slot1)
	if not slot0.bgs[slot1] then
		slot0.bgs[slot1] = LoadSprite("bg/" .. slot1)
	end

	return slot0.bgs[slot1]
end

slot0.LoadEffects = function (slot0, slot1, slot2)
	if #slot1:GetEffects() <= 0 then
		slot2()

		return
	end

	slot4 = {}

	for slot8, slot9 in ipairs(slot3) do
		slot11 = slot9.active

		if slot0.effectPanel:Find(slot9.name) then
			setActive(slot12, slot11)
		else
			slot13 = ""

			if PathMgr.FileExists(PathMgr.getAssetBundle("ui/" .. slot10)) then
				slot13 = "ui"
			elseif PathMgr.FileExists(PathMgr.getAssetBundle("effect/" .. slot10)) then
				slot13 = "effect"
			end

			if slot13 and slot13 ~= "" then
				table.insert(slot4, function (slot0)
					LoadAndInstantiateAsync(slot0, LoadAndInstantiateAsync, function (slot0)
						setParent(slot0, slot0.effectPanel.transform)
						setActive(slot0, setActive)

						slot0.name = slot2

						setActive()
					end)
				end)
			else
				print("not found effect", slot10)
			end
		end
	end

	parallelAsync(slot4, slot2)
end

slot0.ClearEffects = function (slot0)
	removeAllChildren(slot0.effectPanel)
end

slot0.PlaySoundEffect = function (slot0, slot1)
	if slot1:ShouldPlaySoundEffect() then
		slot2, slot6 = slot1:GetSoundeffect()

		slot0:DelayCall(slot3, function ()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(pg.CriMgr.GetInstance().PlaySoundEffect_V3)
		end)
	end

	if slot1.ShouldPlayVoice(slot1) then
		slot0:PlayVoice(slot1)
	end
end

slot0.PlayVoice = function (slot0, slot1)
	if slot0.voiceDelayTimer then
		slot0.voiceDelayTimer:Stop()

		slot0.voiceDelayTimer = nil
	end

	if slot0.currentVoice then
		slot0.currentVoice:Stop(true)

		slot0.currentVoice = nil
	end

	slot2, slot7 = slot1:GetVoice()
	slot4 = nil
	slot5 = slot0:CreateDelayTimer(slot3, function ()
		if slot0 then
			slot0:Stop()
		end

		if slot1.voiceDelayTimer then
			slot1.voiceDelayTimer = nil
		end

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot2, function (slot0)
			if slot0 then
				slot0.currentVoice = slot0.playback
			end
		end)
	end)
	slot0.voiceDelayTimer = slot5
end

slot0.Reset = function (slot0, slot1, slot2)
	setActive(slot0.bgPanel, false)
	setActive(slot0.dialoguePanel, false)
	setActive(slot0.asidePanel, false)
	setActive(slot0.curtain, false)
	setActive(slot0.flash, false)
	setActive(slot0.optionsCg.gameObject, false)
	setActive(slot0.bgGlitch, false)

	slot0.flashCg.alpha = 1
	slot0.goCG.alpha = 1

	slot0:OnReset(slot1, slot2)
end

slot0.Clear = function (slot0, slot1)
	slot0.bgs = {}
	slot0.goCG.alpha = 1
	slot0.callback = nil
	slot0.autoNext = nil
	slot0.script = nil

	slot0:OnClear()

	if slot1 then
		slot1()
	end

	pg.DelegateInfo.New(slot0)
end

slot0.StoryStart = function (slot0, slot1)
	slot0:OnStart()
end

slot0.StoryEnd = function (slot0)
	slot0.stop = false
	slot0.pause = false

	if slot0.voiceDelayTimer then
		slot0.voiceDelayTimer:Stop()

		slot0.voiceDelayTimer = nil
	end

	if slot0.currentVoice then
		slot0.currentVoice:Stop(true)

		slot0.currentVoice = nil
	end

	slot0:ClearEffects()
	slot0:Clear()
	slot0:OnEnd()
end

slot0.PlayBgm = function (slot0, slot1)
	if slot1:ShouldStopBgm() then
		slot0:StopBgm()
	end

	if slot1:ShoulePlayBgm() then
		slot2, slot6 = slot1:GetBgmData()

		slot0:DelayCall(slot3, function ()
			pg.CriMgr.GetInstance():PlayBGM(pg.CriMgr.GetInstance().PlayBGM, "story")
		end)
	end
end

slot0.StopBgm = function (slot0, slot1)
	pg.CriMgr.GetInstance():StopBGM(true)
end

slot0.StartUIAnimations = function (slot0, slot1, slot2)
	parallelAsync({
		function (slot0)
			slot0:StartBlinkAnimation(slot0.StartBlinkAnimation, slot0)
		end,
		function (slot0)
			slot0:StartBlinkWithColorAnimation(slot0.StartBlinkWithColorAnimation, slot0)
		end,
		function (slot0)
			slot0:OnStartUIAnimations(slot0.OnStartUIAnimations, slot0)
		end
	}, slot2)
end

slot0.StartBlinkAnimation = function (slot0, slot1, slot2)
	if slot1:ShouldBlink() then
		slot3 = slot1:GetBlinkData()
		slot5 = slot3.number
		slot6 = slot3.dur
		slot7 = slot3.delay
		slot8 = slot3.alpha[1]
		slot9 = slot3.alpha[2]
		slot10 = slot3.wait
		slot0.flashImg.color = (slot3.black and Color(0, 0, 0)) or Color(1, 1, 1)

		setActive(slot0.flash, true)

		slot11 = {}

		for slot15 = 1, slot5, 1 do
			table.insert(slot11, function (slot0)
				slot0:TweenAlpha(slot0.flash, slot0.TweenAlpha, slot0, slot3 / 2, 0, function ()
					slot0:TweenAlpha(slot0.flash, slot0, , slot3 / 2, , )
				end)
			end)
		end

		seriesAsync(slot11, function ()
			setActive(slot0.flash, false)
		end)
	end

	slot2()
end

slot0.StartBlinkWithColorAnimation = function (slot0, slot1, slot2)
	if slot1:ShouldBlinkWithColor() then
		slot0.flashImg.color = Color(slot1:GetBlinkWithColorData().color[1], slot1.GetBlinkWithColorData().color[2], slot1.GetBlinkWithColorData().color[3], slot1.GetBlinkWithColorData().color[4])

		setActive(slot0.flash, true)

		slot6 = {}

		for slot10, slot11 in ipairs(slot5) do
			slot12 = slot11[1]
			slot13 = slot11[2]
			slot14 = slot11[3]
			slot15 = slot11[4]

			table.insert(slot6, function (slot0)
				slot0:TweenValue(slot0.flash, slot0.TweenValue, slot0, , , function (slot0)
					slot0.flashCg.alpha = slot0
				end, slot0)
			end)
		end

		parallelAsync(slot6, function ()
			setActive(slot0.flash, false)
		end)
	end

	slot2()
end

slot0.findTF = function (slot0, slot1, slot2)
	return findTF(slot2 or slot0._tf, slot1)
end

slot0.OnStart = function (slot0)
	return
end

slot0.OnReset = function (slot0, slot1)
	return
end

slot0.OnBgUpdate = function (slot0, slot1)
	return
end

slot0.OnInit = function (slot0, slot1, slot2)
	if slot2 then
		slot2()
	end
end

slot0.OnStartUIAnimations = function (slot0, slot1, slot2)
	if slot2 then
		slot2()
	end
end

slot0.OnEnter = function (slot0, slot1, slot2, slot3)
	if slot3 then
		slot3()
	end
end

slot0.OnWillExit = function (slot0, slot1, slot2, slot3)
	slot3()
end

slot0.OnClear = function (slot0)
	return
end

slot0.OnEnd = function (slot0)
	return
end

return slot0

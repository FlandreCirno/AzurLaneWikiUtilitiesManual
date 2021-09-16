slot0 = class("FurnitureDescWindow")

slot0.Ctor = function (slot0, slot1)
	pg.DelegateInfo.New(slot0)

	slot0._go = slot1
	slot0.descPanel = tf(slot1)
	slot0.maxFrame = findTF(slot0.descPanel, "max_panel")
	slot0.maxPanel = findTF(slot0.maxFrame, "max")
	slot0.maxIcon = findTF(slot0.maxPanel, "desc/iconframe/icon"):GetComponent(typeof(Image))
	slot0.maxName = findTF(slot0.maxPanel, "desc/Text"):GetComponent(typeof(Text))
	slot0.maxType = findTF(slot0.maxPanel, "desc/container/frame/type"):GetComponent(typeof(Text))
	slot0.maxContent = findTF(slot0.maxPanel, "desc/container/frame/content"):GetComponent(typeof(Text))
	slot0.maxComfortable = findTF(slot0.maxPanel, "desc/container/frame/comfortable_container/Text"):GetComponent(typeof(Text))
	slot0.maxApproach = findTF(slot0.maxPanel, "desc/container/frame/approach_container/Text"):GetComponent(typeof(Text))
	slot0.maxdate = findTF(slot0.maxPanel, "desc/container/frame/date_container/Text"):GetComponent(typeof(Text))
	slot0.descPanelParent = slot0.descPanel.parent
	slot0.descPanelVoiceBtn = findTF(slot0.maxPanel, "desc/container/frame/voice")
	slot0.descPanelBgVoiceBtn = findTF(slot0.maxPanel, "desc/container/frame/bg_voice")
	slot0.descPanelBgVoiceMark = findTF(slot0.maxPanel, "desc/container/frame/bg_voice/mark")

	slot0:Init()
end

slot0.Init = function (slot0)
	onButton(slot0, slot0.descPanel, function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0.maxFrame, function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0.maxPanel:Find("ok_btn"), function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0.descPanelVoiceBtn, function ()
		slot4, slot1 = slot0.furnitureVO:getVoice()

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)

		slot0.curVoiceKey = slot0

		print(slot0, slot1.action)

		if slot0.onPlaySound then
			slot0.onPlaySound(slot0.furnitureVO.id, true, slot1)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.descPanelBgVoiceBtn, function ()
		if slot0.playData and slot0.playData.id == slot0.furnitureVO.id then
			playBGM("backyard")

			if slot0.onPlaySound then
				slot0.onPlaySound(slot0.furnitureVO.id, false, {
					action = "normal",
					effect = slot0.playData.effect
				})
			end

			setActive(slot0.descPanelBgVoiceMark, false)

			slot0.playData = nil
		elseif slot0.playData and slot0.playData.id ~= slot0.furnitureVO.id then
			if slot0.onPlaySound then
				slot0.onPlaySound(slot0.playData.id, false, {
					action = "normal",
					effect = slot0.playData.effect
				})
			end

			slot0.playData = nil

			slot0()
		else
			slot0()
		end
	end, SFX_PANEL)
end

slot0.SetUp = function (slot0, slot1)
	slot0.onPlaySound = slot1
end

slot0.Show = function (slot0, slot1)
	slot0.furnitureVO = slot1

	setActive(slot0.descPanelVoiceBtn, slot1:existVoice() and slot1:descVoiceType() == BackYardConst.SOUND_TYPE_EFFECT)
	setActive(slot0.descPanelBgVoiceBtn, slot2 and slot1.descVoiceType() == BackYardConst.SOUND_TYPE_BG)
	setActive(slot0.descPanel, true)
	SetActive(slot0.maxFrame, false)
	setActive(slot0.descPanelBgVoiceMark, slot0.playData and slot0.playData.id == slot1.id)
	LoadSpriteAsync("FurnitureIcon/" .. slot1:getConfig("icon"), function (slot0)
		if not slot0.exited then
			slot0.maxIcon.sprite = slot0
		end
	end)
	setActive(slot0.maxFrame, true)

	slot0.maxName.text = shortenString(slot1.getConfig(slot1, "name"), 6)
	slot0.maxdate.text = slot1:getDate()
	slot0.maxComfortable.text = "+" .. slot1:getConfig("comfortable")
	slot0.maxContent.text = slot1:getConfig("describe")
	slot0.maxApproach.text = slot1:getGainby()
	slot0.maxType.text = slot1:getChineseType()

	pg.UIMgr.GetInstance():BlurPanel(slot0.maxFrame)
end

slot0.Close = function (slot0)
	slot0:stopCV()
	setActive(slot0.descPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.maxFrame, slot0.descPanel)
end

slot0.stopCV = function (slot0)
	if slot0.curVoiceKey then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(slot0.curVoiceKey)

		slot0.curVoiceKey = nil
	end
end

slot0.Destroy = function (slot0)
	slot0.playData = nil
	slot0.exited = true

	slot0:Close()
	pg.DelegateInfo.Dispose(slot0)
end

return slot0

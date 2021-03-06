slot0 = class("ShipProfileInformationPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "ShipProfileInformationPage"
end

slot0.OnLoaded = function (slot0)
	slot0.voiceActor = slot0:findTF("bg/author_panel/cvPanel/label/mask/Text"):GetComponent("ScrollText")
	slot0.illustrator = slot0:findTF("bg/author_panel/illustPanel/illustrator/label/mask/Text"):GetComponent("ScrollText")
	slot0.cvContainer = slot0:findTF("bg/lines_panel/lines_list/Grid")
	slot0.cvTpl = slot0:getTpl("bg/lines_panel/lines_list/Grid/lines_tpl")
	slot0.weddingReview = slot0:findTF("bg/wedding")
	slot0.voiceBtnCN = slot0:findTF("bg/language_change/btn_ch")
	slot0.voiceBtnJP = slot0:findTF("bg/language_change/btn_jp")
	slot0.profilePlayBtn = slot0:findTF("bg/prototype_panel/title/playButton")
	slot0.profileTxt = slot0:findTF("bg/prototype_panel/desc/scroll/Text"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.weddingReview, function ()
		slot0:emit(ShipProfileScene.WEDDING_REVIEW, {
			group = slot0.shipGroup,
			skinID = slot0.skin.id
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.voiceBtnCN, function ()
		if pg.ship_skin_words[ShipGroup.getDefaultSkin(slot0).id].voice_key < 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))

			return
		end

		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. slot0, 1)
		setActive(slot0.voiceBtnCN, false)
		setActive(slot0.voiceBtnJP, true)
		slot0.cvLoader:Load(slot0.skin.id)
		slot0:SetAuthorInfo()
		slot0:UpdateCvList(slot0.isLive2d)
	end, SFX_PANEL)
	onButton(slot0, slot0.voiceBtnJP, function ()
		if pg.ship_skin_words[ShipGroup.getDefaultSkin(slot0).id].voice_key_2 < 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))

			return
		end

		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. slot0, 2)
		setActive(slot0.voiceBtnCN, true)
		setActive(slot0.voiceBtnJP, false)
		slot0.cvLoader:Load(slot0.skin.id)
		slot0:SetAuthorInfo()
		slot0:UpdateCvList(slot0.isLive2d)
	end, SFX_PANEL)
end

slot0.EnterAnim = function (slot0, slot1, slot2)
	LeanTween.moveX(rtf(slot0._tf), 0, slot1):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(slot2))
end

slot0.ExistAnim = function (slot0, slot1, slot2)
	LeanTween.moveX(rtf(slot0._tf), 1000, slot1):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(function ()
		if slot0 then
			slot0()
		end

		slot1:Hide()
	end))
end

slot0.Update = function (slot0, slot1, slot2, slot3)
	slot0:Show()

	slot0.shipGroup = slot1
	slot0.showTrans = slot2

	setActive(slot0.weddingReview, slot1.married == 1)

	if isActive(slot0.weddingReview) then
		slot4 = slot1:getProposeType()

		eachChild(slot0.weddingReview, function (slot0)
			setActive(slot0, slot0.name == slot0)
		end)
	end

	if slot3 then
		slot3()
	end
end

slot0.Flush = function (slot0, slot1, slot2)
	if slot0.skin and slot0.skin.id == slot1.id and slot0.isLive2d == slot2 then
		return
	end

	slot0.skin = slot1
	slot0.isLive2d = slot2

	slot0:SetAuthorInfo()
	slot0:SetIllustrator()
	slot0:UpdateLanguage()
	slot0:UpdateProfileInfo()
	slot0:UpdateCvList(slot2)
	slot0.cvLoader:Load(slot0.skin.id)
end

slot0.UpdateProfileInfo = function (slot0)
	slot1, slot2, slot6 = ShipWordHelper.GetWordAndCV(slot0.skin.id, ShipWordHelper.WORD_TYPE_PROFILE)
	slot0.profileTxt.text = SwitchSpecialChar(slot3, true)
	slot5 = pg.ship_skin_words[slot0.skin.id] and (slot4.voice_key >= 0 or slot4.voice_key == -2)

	if slot5 then
		onButton(slot0, slot0.profilePlayBtn, function ()
			slot0.cvLoader:PlaySound(slot0.cvLoader)
		end, SFX_PANEL)
	end

	setActive(slot0.profilePlayBtn, slot5)
end

slot0.SetCvLoader = function (slot0, slot1)
	slot0.cvLoader = slot1
end

slot0.SetCallback = function (slot0, slot1)
	slot0.callback = slot1
end

slot0.UpdateLanguage = function (slot0)
	slot4 = PlayerPrefs.GetInt(CV_LANGUAGE_KEY .. slot0.skin.ship_group)
	slot5 = pg.ship_skin_words[ShipGroup.getDefaultSkin(slot1).id].voice_key_2 >= 0 or slot3.voice_key_2 == -2

	if slot3.voice_key_2 >= 0 and slot4 == 0 then
		PlayerPrefs.SetInt(CV_LANGUAGE_KEY .. slot1, pg.gameset.language_default.key_value)
	end

	setActive(slot0.voiceBtnJP, slot4 ~= 2 and slot5)
	setActive(slot0.voiceBtnCN, slot4 == 2 and slot5)
end

slot0.SetAuthorInfo = function (slot0)
	slot0.voiceActor:SetText(ShipWordHelper.GetCVAuthor(slot0.skin.id))
end

slot0.SetIllustrator = function (slot0)
	slot0.illustrator:SetText(slot0.shipGroup:GetNationTxt())
end

slot0.GetCvList = function (slot0, slot1)
	slot2 = {}

	return (not slot1 or pg.AssistantInfo.GetCVListForProfile()) and ShipWordHelper.GetCVList()
end

slot0.UpdateCvList = function (slot0, slot1)
	slot0:DestroyCvBtns()

	slot0.cvBtns = {}
	slot0.dispalys = slot0:GetCvList(slot1)

	table.sort(slot0.dispalys, function (slot0, slot1)
		return slot0.profile_index < slot1.profile_index
	end)

	for slot5, slot6 in ipairs(slot0.dispalys) do
		slot0.AddCvBtn(slot0, slot6)
		slot0:AddExCvBtn(slot6)
	end

	if slot0.cvBtns[(pg.character_voice.touch.profile_index - 1) * 2] then
		slot2 = slot3._tf:GetSiblingIndex() or slot2
	end

	if ShipWordHelper.GetMainSceneWordCnt(slot0.skin.id, -1) < ShipWordHelper.GetMainSceneWordCnt(slot0.skin.id, slot0.shipGroup:GetMaxIntimacy()) then
		for slot10 = slot4 + 1, slot6, 1 do
			slot0:AddMainExBtn(slot10, slot2)

			slot2 = slot2 + 1
		end
	end
end

slot0.AddMainExBtn = function (slot0, slot1, slot2)
	slot3 = ShipProfileMainExCvBtn.New(cloneTplTo(slot0.cvTpl, slot0.cvContainer))

	onButton(slot0, slot3._tf, function ()
		if slot0.callback then
			slot0.callback(slot1)
		end
	end, SFX_PANEL)
	slot3.Init(slot3, slot0.shipGroup, slot0.skin, slot0.isLive2d, slot1)
	slot3:Update()
	slot3._tf:SetSiblingIndex(slot2)
	table.insert(slot0.cvBtns, slot3)
end

slot0.AddCvBtn = function (slot0, slot1)
	slot2 = ShipProfileCvBtn.New(cloneTplTo(slot0.cvTpl, slot0.cvContainer))

	onButton(slot0, slot2._tf, function ()
		if slot0.callback then
			slot0.callback(slot1)
		end
	end, SFX_PANEL)
	slot2.Init(slot2, slot0.shipGroup, slot0.skin, slot0.isLive2d, slot1)
	slot2:Update()
	table.insert(slot0.cvBtns, slot2)
end

slot0.AddExCvBtn = function (slot0, slot1)
	slot2 = ShipProfileExCvBtn.New(cloneTplTo(slot0.cvTpl, slot0.cvContainer))

	onButton(slot0, slot2._tf, function ()
		if slot0.callback then
			slot0.callback(slot1)
		end
	end, SFX_PANEL)
	slot2:Init(slot0.shipGroup, slot0.skin, slot0.isLive2d, slot1, slot0.shipGroup.GetMaxIntimacy(slot3))
	slot2:Update()
	table.insert(slot0.cvBtns, slot2)
end

slot0.DestroyCvBtns = function (slot0)
	if not slot0.cvBtns then
		return
	end

	for slot4, slot5 in ipairs(slot0.cvBtns) do
		slot5:Destroy()
	end
end

slot0.OnDestroy = function (slot0)
	slot0:DestroyCvBtns()

	slot0.cvLoader = nil
	slot0.callback = nil
end

return slot0

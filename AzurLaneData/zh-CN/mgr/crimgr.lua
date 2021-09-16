pg = pg or {}
pg.CriMgr = singletonClass("CriMgr")
pg.CriMgr.Category_CV = "Category_CV"
pg.CriMgr.Category_BGM = "Category_BGM"
pg.CriMgr.Category_SE = "Category_SE"
pg.CriMgr.C_BGM = "C_BGM"
pg.CriMgr.C_VOICE = "cv"
pg.CriMgr.C_SE = "C_SE"
pg.CriMgr.C_BATTLE_SE = "C_BATTLE_SE"
pg.CriMgr.C_GALLERY_MUSIC = "C_GALLERY_MUSIC"
pg.CriMgr.NEXT_VER = 40

pg.CriMgr.Init = function (slot0, slot1)
	print("initializing cri manager...")
	seriesAsync({
		function (slot0)
			slot0:InitCri(slot0)
		end,
		function (slot0)
			slot1 = CueData.New()
			slot1.cueSheetName = "se-ui"
			slot1.channelName = slot0.C_SE

			CriWareMgr.Inst:LoadCueSheet(slot1, function (slot0)
				slot0()
			end, true)
		end,
		function (slot0)
			slot1 = CueData.New()
			slot1.cueSheetName = "se-battle"
			slot1.channelName = slot0.C_BATTLE_SE

			CriWareMgr.Inst:LoadCueSheet(slot1, function (slot0)
				slot0()
			end, true)
		end
	}, slot1)
end

pg.CriMgr.InitCri = function (slot0, slot1)
	slot0.criInitializer = GameObject.Find("CRIWARE").GetComponent(slot2, typeof(CriWareInitializer))
	slot0.criInitializer.fileSystemConfig.numberOfLoaders = 128
	slot0.criInitializer.manaConfig.numberOfDecoders = 128
	slot0.criInitializer.atomConfig.useRandomSeedWithTime = true

	slot0.criInitializer:Initialize()
	CriWareMgr.Inst:Init(function ()
		CriAtom.SetCategoryVolume(slot0.Category_CV, slot1:getCVVolume())
		CriAtom.SetCategoryVolume(slot0.Category_SE, slot1:getSEVolume())
		CriAtom.SetCategoryVolume(slot0.Category_BGM, slot1:getBGMVolume())
		CriWareMgr.Inst:RemoveChannel("C_VOICE")
		Object.Destroy(GameObject.Find("CRIWARE/C_VOICE"))
		CriWareMgr.Inst:CreateChannel(slot0.C_VOICE, CriWareMgr.CRI_CHANNEL_TYPE.MULTI_NOT_REPEAT)

		CriWareMgr.C_VOICE = slot0.C_VOICE

		CriWareMgr.Inst:CreateChannel(slot0.C_GALLERY_MUSIC, CriWareMgr.CRI_CHANNEL_TYPE.SINGLE)

		CriWareMgr.Inst:GetChannelData(slot0.C_BGM).channelPlayer.loop = true

		slot0.C_BGM()
	end)

	slot0.typeNow = nil
	slot0.bgmNow = nil
	slot0.lastNormalBGMName = nil
end

pg.CriMgr.SetTypeBGM = function (slot0, slot1, slot2)
	slot0.typeNow = slot2
	slot0.bgmNow = slot1

	if not slot2 then
		slot0.lastNormalBGMName = slot1
	end
end

pg.CriMgr.ResumeLastNormalBGM = function (slot0)
	if slot0.lastNormalBGMName then
		slot0:PlayBGM(slot0.lastNormalBGMName)
	end
end

pg.CriMgr.PlayBGM = function (slot0, slot1, slot2)
	slot0:SetTypeBGM(slot1, slot2)

	if slot0.bgmName == "bgm-" .. slot1 then
		return
	elseif slot0.bgmName ~= nil and slot0.bgmPlaybackInfo == nil then
		slot0:UnloadCueSheet(slot0.bgmName)
	end

	slot0.bgmName = slot3
	slot0.bgmPlaybackInfo = nil
	slot4 = nil

	if slot0.NEXT_VER <= CSharpVersion then
		slot4 = CriWareMgr.Inst:GetChannelData(slot0.C_BGM).curCueDataKey
	end

	CriWareMgr.Inst:PlayBGM(slot3, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function (slot0)
		if slot0 == nil then
			warning("Missing BGM :" .. (slot0 or "NIL"))
		else
			slot1.bgmPlaybackInfo = slot0
		end
	end)

	if slot0.NEXT_VER <= CSharpVersion and slot4 ~= nil then
		CriWareMgr.Inst.GetChannelData(slot5, slot0.C_BGM).curCueDataKey = slot4
	end
end

pg.CriMgr.StopBGM = function (slot0, slot1)
	CriWareMgr.Inst:StopBGM(CriWareMgr.CRI_FADE_TYPE.FADE_INOUT)

	slot0.bgmPlaybackInfo = nil
	slot0.bgmName = nil
end

pg.CriMgr.LoadCV = function (slot0, slot1, slot2)
	slot0:LoadCueSheet(slot0.GetCVBankName(slot1), slot2)
end

pg.CriMgr.LoadBattleCV = function (slot0, slot1, slot2)
	slot0:LoadCueSheet(slot0.GetBattleCVBankName(slot1), slot2)
end

pg.CriMgr.UnloadCVBank = function (slot0)
	slot0.GetInstance():UnloadCueSheet(slot0)
end

pg.CriMgr.GetCVBankName = function (slot0)
	return "cv-" .. slot0
end

pg.CriMgr.GetBattleCVBankName = function (slot0)
	return "cv-" .. slot0 .. "-battle"
end

pg.CriMgr.CheckFModeEvent = function (slot0, slot1, slot2, slot3)
	if not slot1 then
		return
	end

	string.gsub(slot1, "event:/cv/(.+)/(.+)", function (slot0, slot1)
		slot0 = "cv-" .. slot0 .. ((tobool(ShipWordHelper.CVBattleKey[string.gsub(slot1, "_%w+", "")]) and "-battle") or "")
		slot1 = slot1
	end)
	string.gsub(slot1, "event:/tb/(.+)/(.+)", function (slot0, slot1)
		slot0 = "tb-" .. slot0
		slot1 = slot1
	end)

	if nil and slot5 then
		slot2(slot4, slot5)
	else
		slot3(string.gsub(string.gsub(slot1, "event:/(battle)/(.+)", "%1-%2"), "event:/(ui)/(.+)", "%1-%2"))
	end
end

pg.CriMgr.CheckHasCue = function (slot0, slot1, slot2)
	return CriAtom.GetCueSheet(slot1) ~= nil and slot3.acb:Exists(slot2)
end

pg.CriMgr.PlaySoundEffect_V3 = function (slot0, slot1, slot2)
	slot0:CheckFModeEvent(slot1, function (slot0, slot1)
		slot0:PlayCV_V3(slot0, slot1, slot1)
	end, function (slot0)
		slot0:PlaySE_V3(slot0, slot0.PlaySE_V3)
	end)
end

pg.CriMgr.StopSoundEffect_V3 = function (slot0, slot1)
	slot0:CheckFModeEvent(slot1, function (slot0, slot1)
		slot0:StopCV_V3()
	end, function (slot0)
		slot0:StopSE_V3()
	end)
end

pg.CriMgr.UnloadSoundEffect_V3 = function (slot0, slot1)
	slot0:CheckFModeEvent(slot1, function (slot0, slot1)
		slot0:UnloadCueSheet(slot0)
	end, function (slot0)
		slot0:StopSE_V3()
	end)
end

pg.CriMgr.PlayCV_V3 = function (slot0, slot1, slot2, slot3)
	CriWareMgr.Inst:PlayVoice(slot2, CriWareMgr.CRI_FADE_TYPE.NONE, slot1, function (slot0)
		if slot0 ~= nil then
			slot0(slot0)
		end
	end)
end

pg.CriMgr.StopCV_V3 = function (slot0)
	CriWareMgr.Inst:GetChannelData(slot0.C_VOICE).channelPlayer:Stop()
end

pg.CriMgr.PlaySE_V3 = function (slot0, slot1, slot2)
	if CriAtom.GetCueSheet("se-ui") and slot3.acb and slot3.acb:Exists(slot1) then
		CriWareMgr.Inst:PlaySE(slot1, nil, function (slot0)
			if slot0 ~= nil then
				slot0(slot0)
			end
		end)
	end

	if CriAtom.GetCueSheet("se-battle") and slot4.acb and slot4.acb.Exists(slot5, slot1) then
		CriWareMgr.Inst:PlayBattleSE(slot1, nil, function (slot0)
			if slot0 ~= nil then
				slot0(slot0)
			end
		end)
	end
end

pg.CriMgr.StopSE_V3 = function (slot0)
	CriWareMgr.Inst:GetChannelData(slot0.C_SE).channelPlayer:Stop()
	CriWareMgr.Inst:GetChannelData(slot0.C_BATTLE_SE).channelPlayer:Stop()
end

pg.CriMgr.StopSEBattle_V3 = function (slot0)
	CriWareMgr.Inst:GetChannelData(slot0.C_BATTLE_SE).channelPlayer:Stop()
end

pg.CriMgr.LoadCueSheet = function (slot0, slot1, slot2)
	CueData.New().cueSheetName = slot1

	CriWareMgr.Inst:LoadCueSheet(CueData.New(), function (slot0)
		slot0(slot0)
	end, true)
end

pg.CriMgr.UnloadCueSheet = function (slot0, slot1)
	CriWareMgr.Inst:UnloadCueSheet(slot1)
end

pg.CriMgr.getCVVolume = function (slot0)
	return PlayerPrefs.GetFloat("cv_vol", DEFAULT_CVVOLUME)
end

pg.CriMgr.setCVVolume = function (slot0, slot1)
	PlayerPrefs.SetFloat("cv_vol", slot1)
	CriAtom.SetCategoryVolume(slot0.Category_CV, slot1)
end

pg.CriMgr.getBGMVolume = function (slot0)
	return PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME)
end

pg.CriMgr.setBGMVolume = function (slot0, slot1)
	PlayerPrefs.SetFloat("bgm_vol", slot1)
	CriAtom.SetCategoryVolume(slot0.Category_BGM, slot1)
end

pg.CriMgr.getSEVolume = function (slot0)
	return PlayerPrefs.GetFloat("se_vol", DEFAULT_SEVOLUME)
end

pg.CriMgr.setSEVolume = function (slot0, slot1)
	PlayerPrefs.SetFloat("se_vol", slot1)
	CriAtom.SetCategoryVolume(slot0.Category_SE, slot1)
end

return

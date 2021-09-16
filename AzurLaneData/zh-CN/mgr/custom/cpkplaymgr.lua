pg = pg or {}
pg.CpkPlayMgr = singletonClass("CpkPlayMgr")
this = pg.CpkPlayMgr

this.Ctor = function (slot0)
	slot0._onPlaying = false
	slot0._mainTF = nil
	slot0._closeLimit = nil
	slot0._animator = nil
	slot0._criUsm = nil
	slot0._criCpk = nil
	slot0._stopGameBGM = false
end

this.Reset = function (slot0)
	slot0._onPlaying = false
	slot0._mainTF = nil
	slot0._closeLimit = nil
	slot0._animator = nil
	slot0._criUsm = nil
	slot0._criCpk = nil
	slot0._stopGameBGM = false
end

this.OnPlaying = function (slot0)
	return slot0._onPlaying
end

this.PlayCpkMovie = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	pg.DelegateInfo.New(slot0)

	slot0._onPlaying = true
	slot0._stopGameBGM = slot6

	pg.UIMgr.GetInstance():LoadingOn()

	function slot8()
		if not slot0._mainTF then
			return
		end

		if Time.realtimeSinceStartup < slot0._closeLimit then
			return
		end

		setActive(slot0._mainTF, false)
		setActive:DisposeCpkMovie()

		if setActive then
			slot1()
		end
	end

	function slot9()
		slot0._animator.enabled = true

		onButton(onButton, slot0._mainTF, function ()
			if slot0 then
				slot1()
			end
		end)

		if onButton._criUsm then
			slot0._criUsm.player.SetVolume(slot0, PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
			slot0._criUsm.player.SetVolume._criUsm.player:SetShaderDispatchCallback(function (slot0, slot1)
				slot0:checkBgmStop(slot0)

				return nil
			end)
		end

		if slot0._criCpk then
			slot0._criCpk.player.SetVolume(slot0, PlayerPrefs.GetFloat("bgm_vol", DEFAULT_BGMVOLUME))
			slot0._criCpk.player.SetVolume._criCpk.player:SetShaderDispatchCallback(function (slot0, slot1)
				slot0:checkBgmStop(slot0)

				return nil
			end)
		end

		slot0 = slot0._mainTF.GetComponent(slot0, "DftAniEvent")

		slot0:SetStartEvent(function (slot0)
			if slot0._criUsm then
				slot0._criUsm:Play()
			end
		end)
		slot0.SetEndEvent(slot0, function (slot0)
			slot0()
		end)
		setActive(slot0._mainTF, true)

		if slot0._stopGameBGM then
			pg.CriMgr.GetInstance().StopBGM(slot1)
		end

		if slot3 then
			slot3()
		end
	end

	if IsNil(slot0._mainTF) then
		LoadAndInstantiateAsync(slot3, slot4, function (slot0)
			pg.UIMgr.GetInstance():LoadingOff()

			slot0._closeLimit = Time.realtimeSinceStartup + 1

			if not slot0._onPlaying then
				Destroy(slot0)

				return
			end

			slot0._mainTF = slot0

			pg.UIMgr.GetInstance():OverlayPanel(slot0._mainTF.transform, pg.UIMgr.GetInstance().OverlayPanel)

			slot0._criUsm = tf(slot0._mainTF):Find("usm"):GetComponent("CriManaEffectUI")
			slot0._criCpk = tf(slot0._mainTF):Find("usm"):GetComponent("CriManaCpkUI")
			slot0._animator = slot0._mainTF:GetComponent("Animator")

			slot0._mainTF.GetComponent("Animator")()
		end)
	else
		slot9()
	end
end

this.checkBgmStop = function (slot0, slot1)
	if slot0._onPlaying and slot1.numAudioStreams and slot2 > 0 then
		pg.CriMgr.GetInstance():StopBGM()

		slot0._stopGameBGM = true
	end
end

this.DisposeCpkMovie = function (slot0)
	if slot0._onPlaying then
		if slot0._mainTF then
			pg.UIMgr.GetInstance():UnOverlayPanel(slot0._mainTF.transform, slot0._tf)
			Destroy(slot0._mainTF)

			slot0._animator.enabled = false

			if slot0._criUsm then
				slot0._criUsm:Stop()
			end

			if slot0._stopGameBGM then
				pg.CriMgr.GetInstance():ResumeLastNormalBGM()
			end

			slot0._onPlaying = false

			pg.DelegateInfo.Dispose(slot0)
		end

		slot0:Reset()
	end
end

return

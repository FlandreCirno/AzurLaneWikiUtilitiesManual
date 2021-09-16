slot0 = class("MusicCollectionView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "MusicCollectionUI"
end

slot0.OnInit = function (slot0)
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
	slot0:initPlateListPanel()
	slot0:initSongListPanel()
	slot0:Show()
	slot0:recoverRunData()
	slot0:initTimer()
	slot0:tryShowTipMsgBox()
end

slot0.OnDestroy = function (slot0)
	slot0:stopMusic()
	slot0.resLoader:Clear()

	if slot0.playProgressTimer then
		slot0.playProgressTimer:Stop()

		slot0.playProgressTimer = nil
	end

	if slot0.downloadCheckTimer then
		slot0.downloadCheckTimer:Stop()

		slot0.downloadCheckTimer = nil
	end

	if slot0.playbackInfo then
		slot0.playbackInfo = nil
	end

	if slot0.appreciateUnlockMsgBox and slot0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		slot0.appreciateUnlockMsgBox:Destroy()
	end

	slot0:closeSongListPanel(true)
end

slot0.onBackPressed = function (slot0)
	if slot0.appreciateUnlockMsgBox and slot0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		slot0.appreciateUnlockMsgBox:hideCustomMsgBox()
		slot0.appreciateUnlockMsgBox:Destroy()

		return false
	elseif isActive(slot0.songListPanel) then
		slot0:closeSongListPanel()

		return false
	else
		return true
	end
end

slot0.initData = function (slot0)
	slot0.appreciateProxy = getProxy(AppreciateProxy)

	slot0.appreciateProxy:checkMusicFileState()

	slot0.resLoader = AutoLoader.New()
	slot0.criMgr = pg.CriMgr.GetInstance()
	slot0.manager = BundleWizard.Inst:GetGroupMgr("GALLERY_BGM")
	slot0.downloadCheckIDList = {}
	slot0.downloadCheckTimer = nil
	slot0.musicForShowConfigList = {}
	slot0.plateTFList = {}
	slot0.songTFList = {}
	slot0.curMidddleIndex = 1
	slot0.sortValue = MusicCollectionConst.Sort_Order_Up
	slot0.likeValue = MusicCollectionConst.Filte_Normal_Value
	slot0.isPlayingAni = false
	slot0.cueData = nil
	slot0.playbackInfo = nil
	slot0.playProgressTimer = nil
	slot0.onDrag = false
	slot0.hadDrag = false
	slot0.isPlayingSong = false
end

slot0.saveRunData = function (slot0)
	slot0.appreciateProxy:updateMusicRunData(slot0.sortValue, slot0.curMidddleIndex, slot0.likeValue)
end

slot0.recoverRunData = function (slot0)
	slot1 = slot0.appreciateProxy:getMusicRunData()
	slot0.sortValue = slot1.sortValue
	slot0.curMidddleIndex = slot1.middleIndex
	slot0.likeValue = slot1.likeValue
	slot0.musicForShowConfigList = slot0:fliteMusicConfigForShow()

	slot0:sortMusicConfigList(slot0.sortValue == MusicCollectionConst.Sort_Order_Down)

	slot0.musicForShowConfigList = slot0:filteMusicConfigByLike()
	slot0.lScrollPageSC.MiddleIndexOnInit = slot0.curMidddleIndex - 1

	slot0:updatePlateListPanel()
	slot0:updateSongListPanel()
	slot0:updatePlayPanel()
	slot0:updateSortToggle()
	slot0:updateLikeToggle()

	if not slot0.appreciateProxy:isMusicHaveNewRes() then
		slot0:tryPlayMusic()
	end
end

slot0.findUI = function (slot0)
	setLocalPosition(slot0._tf, Vector2.zero)

	slot0._tf.anchorMin = Vector2.zero
	slot0._tf.anchorMax = Vector2.one
	slot0._tf.offsetMax = Vector2.zero
	slot0._tf.offsetMin = Vector2.zero
	slot0.topPanel = slot0:findTF("TopPanel")
	slot0.likeFilteToggle = slot0:findTF("LikeBtn", slot0.topPanel)
	slot0.sortToggle = slot0:findTF("SortBtn", slot0.topPanel)
	slot0.songNameText = slot0:findTF("MusicNameMask/MusicName", slot0.topPanel)
	slot0.staicImg = slot0:findTF("SoundImg", slot0.topPanel)
	slot0.playingAni = slot0:findTF("SoundAni", slot0.topPanel)
	slot0.resRepaireBtn = slot0:findTF("RepaireBtn", slot0.topPanel)

	setActive(slot0.likeFilteToggle, true)

	slot0.plateListPanel = slot0:findTF("PlateList")
	slot0.plateTpl = slot0:findTF("Plate", slot0.plateListPanel)
	slot0.lScrollPageSC = GetComponent(slot0.plateListPanel, "LScrollPage")
	slot0.playPanel = slot0:findTF("PLayPanel")
	slot0.playPanelNameText = slot0:findTF("NameText", slot0.playPanel)
	slot0.likeToggle = slot0:findTF("LikeBtn", slot0.playPanel)
	slot0.songImg = slot0:findTF("SongImg", slot0.playPanel)
	slot0.pauseBtn = slot0:findTF("PlayingBtn", slot0.playPanel)
	slot0.playBtn = slot0:findTF("StopingBtn", slot0.playPanel)
	slot0.lockImg = slot0:findTF("LockedBtn", slot0.playPanel)
	slot0.nextBtn = slot0:findTF("NextBtn", slot0.playPanel)
	slot0.preBtn = slot0:findTF("PreBtn", slot0.playPanel)
	slot0.playProgressBar = slot0:findTF("Progress", slot0.playPanel)
	slot0.nowTimeText = slot0:findTF("NowTimeText", slot0.playProgressBar)
	slot0.totalTimeText = slot0:findTF("TotalTimeText", slot0.playProgressBar)
	slot0.playSliderSC = GetComponent(slot0.playProgressBar, "LSlider")
	slot0.listBtn = slot0:findTF("ListBtn", slot0.playPanel)

	setActive(slot0.likeToggle, true)

	slot0.songListPanel = slot0:findTF("SongListPanel")
	slot0.closeBtn = slot0:findTF("BG", slot0.songListPanel)
	slot0.panel = slot0:findTF("Panel", slot0.songListPanel)
	slot0.songContainer = slot0:findTF("Container/Viewport/Content", slot0.panel)
	slot0.songTpl = slot0:findTF("SongTpl", slot0.panel)
	slot0.upToggle = slot0:findTF("BG2/UpToggle", slot0.panel)
	slot0.downToggle = slot0:findTF("BG2/DownToggle", slot0.panel)
	slot0.songUIItemList = UIItemList.New(slot0.songContainer, slot0.songTpl)
	slot0.emptyPanel = slot0:findTF("EmptyPanel")
	slot0.upImg1 = slot0:findTF("Up", slot0.sortToggle)
	slot0.downImg1 = slot0:findTF("Down", slot0.sortToggle)
	slot0.upImg2 = slot0:findTF("SelImg", slot0.upToggle)
	slot0.downImg2 = slot0:findTF("SelImg", slot0.downToggle)
	slot0.likeFilteOffImg = slot0:findTF("Off", slot0.likeFilteToggle)
	slot0.likeFilteOnImg = slot0:findTF("On", slot0.likeFilteToggle)
	slot0.likeOffImg = slot0:findTF("Off", slot0.likeToggle)
	slot0.likeOnImg = slot0:findTF("On", slot0.likeToggle)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.listBtn, function ()
		slot0:openSongListPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:closeSongListPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.resRepaireBtn, function ()
		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				{
					text = i18n("msgbox_repair"),
					onCallback = function ()
						if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-bgm.csv") then
							BundleWizard.Inst:GetGroupMgr("GALLERY_BGM"):StartVerifyForLua()
						else
							pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
						end
					end
				}
			}
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.sortToggle, function ()
		slot0.sortValue = (slot0.sortValue == MusicCollectionConst.Sort_Order_Up and MusicCollectionConst.Sort_Order_Down) or MusicCollectionConst.Sort_Order_Up

		slot0:saveRunData()
		slot0(slot0.saveRunData, slot0.sortValue == MusicCollectionConst.Sort_Order_Down)
	end, SFX_PANEL)
	onButton(slot0, slot0.upToggle, function ()
		if slot0.sortValue == MusicCollectionConst.Sort_Order_Up then
			return
		else
			slot0.sortValue = MusicCollectionConst.Sort_Order_Up

			slot0:saveRunData()
			slot0.saveRunData:sortAndUpdate(false)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.downToggle, function ()
		if slot0.sortValue == MusicCollectionConst.Sort_Order_Down then
			return
		else
			slot0.sortValue = MusicCollectionConst.Sort_Order_Down

			slot0:saveRunData()
			slot0.saveRunData:sortAndUpdate(true)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.likeFilteToggle, function ()
		slot0.likeValue = (slot0.likeValue == MusicCollectionConst.Filte_Normal_Value and MusicCollectionConst.Filte_Like_Value) or MusicCollectionConst.Filte_Normal_Value

		slot0:saveRunData()
		slot0(slot0.saveRunData, slot0.sortValue == MusicCollectionConst.Sort_Order_Down)
	end, SFX_PANEL)
	onButton(slot0, slot0.playBtn, function ()
		if not slot0.playbackInfo then
			slot0:playMusic()
		elseif slot0.hadDrag then
			slot0.hadDrag = false

			slot0.playbackInfo:SetStartTimeAndPlay(slot0.playSliderSC.value)
			slot0.playbackInfo.SetStartTimeAndPlay.playProgressTimer:Start()
		else
			slot0.playbackInfo.playback:Resume(CriAtomEx.ResumeMode.PausedPlayback)
		end

		setActive(slot0.playingAni, true)
		setActive(slot0.staicImg, false)
		SetActive(slot0.pauseBtn, true)
		SetActive(slot0.playBtn, false)
	end, SFX_PANEL)
	onButton(slot0, slot0.pauseBtn, function ()
		if slot0.playbackInfo then
			slot0.playbackInfo.playback:Pause()
		end

		setActive(slot0.playingAni, false)
		setActive(slot0.staicImg, true)
		SetActive(slot0.pauseBtn, false)
		SetActive(slot0.playBtn, true)
	end, SFX_PANEL)
	onButton(slot0, slot0.preBtn, function ()
		if slot0.curMidddleIndex == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("res_music_no_pre_tip"))
		elseif not slot0.isPlayingAni then
			slot0:setAniState(true)
			slot0.setAniState:closePlateAni(slot0.plateTFList[slot0.curMidddleIndex])
			slot0.setAniState.closePlateAni.lScrollPageSC:MoveToItemID(slot0.curMidddleIndex - 1 - 1)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.nextBtn, function ()
		if slot0.curMidddleIndex == #slot0.musicForShowConfigList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("res_music_no_next_tip"))
		elseif not slot0.isPlayingAni then
			slot0:setAniState(true)
			slot0.setAniState:closePlateAni(slot0.plateTFList[slot0.curMidddleIndex])
			slot0.setAniState.closePlateAni.lScrollPageSC:MoveToItemID((slot0.curMidddleIndex + 1) - 1)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.likeToggle, function ()
		if slot0.appreciateProxy:isLikedByMusicID(slot0:getMusicConfigForShowByIndex(slot0.curMidddleIndex).id) == true then
			pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
				isAdd = 1,
				musicID = slot1
			})
			setActive(slot0.likeOnImg, false)
			slot0:updateSongTFLikeImg(slot0.songTFList[slot0.curMidddleIndex], false)
		else
			pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
				isAdd = 0,
				musicID = slot1
			})
			setActive(slot0.likeOnImg, true)
			slot0:updateSongTFLikeImg(slot0.songTFList[slot0.curMidddleIndex], true)
		end
	end, SFX_PANEL)
	slot0.playSliderSC.AddPointDownFunc(slot1, function (slot0)
		if slot0.playbackInfo and not slot0.onDrag then
			slot0.onDrag = true

			if slot0.playbackInfo.playback:IsPaused() then
			else
				slot0.playbackInfo.playback:Stop(true)
			end

			slot0.playProgressTimer:Stop()
		end
	end)
	slot0.playSliderSC.AddPointUpFunc(slot1, function (slot0)
		if slot0.playbackInfo and slot0.onDrag then
			slot0.onDrag = false

			if slot0.playbackInfo.playback:IsPaused() then
				slot0.hadDrag = true
			else
				slot0.playbackInfo:SetStartTimeAndPlay(slot0.playSliderSC.value)
				slot0.playProgressTimer:Start()
			end
		else
			slot0.playSliderSC:SetValueWithoutEvent(0)
		end
	end)
end

slot0.tryShowTipMsgBox = function (slot0)
	if slot0.appreciateProxy:isMusicHaveNewRes() then
		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
			hideClose = true,
			hideNo = true,
			content = i18n("res_music_new_tip", MusicCollectionConst.NewCount),
			onYes = function ()
				slot0.lScrollPageSC:MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
				PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
				PlayerPrefs.SetInt:emit(CollectionScene.UPDATE_RED_POINT)
			end,
			onCancel = function ()
				slot0.lScrollPageSC.MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
				PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
				PlayerPrefs.SetInt.emit(CollectionScene.UPDATE_RED_POINT)
			end,
			onClose = function ()
				slot0.lScrollPageSC.MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
				PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
				PlayerPrefs.SetInt.emit(CollectionScene.UPDATE_RED_POINT)
			end
		})
	end
end

slot0.initPlateListPanel = function (slot0)
	slot0.lScrollPageSC.itemInitedCallback = function (slot0, slot1)
		slot0.plateTFList[slot0 + 1] = slot1

		slot0:updatePlateTF(slot1, slot0)
	end

	slot0.lScrollPageSC.itemClickCallback = function (slot0, slot1)
		if slot0.curMidddleIndex ~= slot0 + 1 and not slot0.isPlayingAni then
			slot0:setAniState(true)
			slot0:closePlateAni(slot0.plateTFList[slot0.curMidddleIndex])
			slot0.lScrollPageSC:MoveToItemID(slot0)
		end
	end

	slot0.lScrollPageSC.itemPitchCallback = function (slot0, slot1)
		slot2 = slot0 + 1

		slot0:stopMusic()
		slot0:checkUpdateSongTF()

		slot0.curMidddleIndex = slot0 + 1

		slot0:saveRunData()
		slot0:playPlateAni(slot1, true)
		slot0:updatePlayPanel()
		slot0:tryPlayMusic()
	end

	slot0.lScrollPageSC.itemRecycleCallback = function (slot0, slot1)
		slot0.plateTFList[slot0 + 1] = nil
	end

	addSlip(SLIP_TYPE_HRZ, slot0.plateListPanel, function ()
		if slot0.curMidddleIndex > 1 and not slot0.isPlayingAni then
			slot0:setAniState(true)
			slot0.setAniState.lScrollPageSC:MoveToItemID(slot0.curMidddleIndex - 1 - 1)
			slot0.setAniState.lScrollPageSC.MoveToItemID:closePlateAni(slot0.plateTFList[slot0.curMidddleIndex])
		end
	end, function ()
		if slot0.curMidddleIndex < slot0.lScrollPageSC.DataCount and not slot0.isPlayingAni then
			slot0:setAniState(true)
			slot0.setAniState.lScrollPageSC:MoveToItemID((slot0.curMidddleIndex + 1) - 1)
			slot0.setAniState.lScrollPageSC.MoveToItemID:closePlateAni(slot0.plateTFList[slot0.curMidddleIndex])
		end
	end)
end

slot0.updatePlateListPanel = function (slot0)
	slot0.plateTFList = {}

	if #slot0.musicForShowConfigList == 0 then
		setActive(slot0.plateListPanel, false)

		return
	else
		setActive(slot0.plateListPanel, true)
	end

	slot0.lScrollPageSC.DataCount = #slot0.musicForShowConfigList

	slot0.lScrollPageSC:Init(slot0.curMidddleIndex - 1)
end

slot0.updatePlateTF = function (slot0, slot1, slot2)
	if #slot0.musicForShowConfigList == 0 then
		return
	end

	slot3 = slot0:findTF("CirclePanel/SmallImg", slot1)
	slot6 = slot0:findTF("BlackMask", slot1)
	slot7 = slot0:findTF("Lock", slot6)
	slot8 = slot0:findTF("UnlockTipText", slot6)
	slot9 = slot0:findTF("UnlockBtn", slot6)
	slot10 = slot0:findTF("DownloadBtn", slot6)

	setText(slot11, i18n("res_downloading"))
	slot0.resLoader:LoadSprite(slot15, slot14, slot4, false)
	setText(slot5, "#" .. slot12)

	slot17, slot18 = nil
	slot18 = slot0.appreciateProxy:getMusicExistStateByID(slot16)

	if slot0:getMusicStateByID(slot0:getMusicConfigForShowByIndex(slot12).id) == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if slot18 then
			setActive(slot6, false)
		else
			setActive(slot6, true)
			setActive(slot7, false)
			setActive(slot8, false)
			setActive(slot9, false)
			setActive(slot10, true)
			setActive(slot11, false)
		end
	elseif slot17 == GalleryConst.CardStates.Unlocked then
		if slot18 then
			setActive(slot6, false)
		else
			if slot0.manager.state == DownloadState.None or slot19 == DownloadState.CheckFailure then
				slot0.manager:CheckD()
			end

			if slot0.manager:CheckF(MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. slot20 .. ".b") == DownloadState.None or slot22 == DownloadState.CheckToUpdate or slot22 == DownloadState.UpdateFailure then
				setActive(slot6, true)
				setActive(slot7, false)
				setActive(slot8, false)
				setActive(slot9, false)
				setActive(slot10, true)
				setActive(slot11, false)
				table.removebyvalue(slot0.downloadCheckIDList, slot16, true)
				onButton(slot0, slot10, function ()
					function slot0()
						setActive(setActive, true)
						setActive(setActive, false)
						setActive(false, false)
						setActive(slot3, false)
						setActive(slot4, false)
						setActive(slot5, true)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_BGM", slot6, false)

						if not table.contains(slot7.downloadCheckIDList, slot8) then
							table.insert(slot7.downloadCheckIDList, slot8)
						end

						slot7:tryStartDownloadCheckTimer()
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
							content = i18n("res_wifi_tip"),
							onYes = slot0
						})
					else
						slot0()
					end
				end, SFX_PANEL)
			elseif slot22 == DownloadState.Updating then
				setActive(slot6, true)
				setActive(slot7, false)
				setActive(slot8, false)
				setActive(slot9, false)
				setActive(slot10, false)
				setActive(slot11, true)
			elseif PathMgr.FileExists(PathMgr.getAssetBundle(slot21)) then
				slot0.appreciateProxy:updateMusicFileExistStateTable(slot16, true)
				table.removebyvalue(slot0.downloadCheckIDList, slot16, true)

				if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
					slot0.downloadCheckTimer:Stop()

					slot0.downloadCheckTimer = nil
				end

				setActive(slot6, false)
				slot0:updatePlayPanel()
			end
		end
	elseif slot17 == GalleryConst.CardStates.Unlockable then
		setActive(slot6, true)
		setActive(slot7, true)
		setActive(slot8, false)
		setActive(slot9, true)
		setActive(slot10, false)
		setActive(slot11, false)
		onButton(slot0, slot9, function ()
			if not slot0.appreciateUnlockMsgBox then
				slot0.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(slot0._tf, slot0.event, slot0.contextData)
			end

			slot0.appreciateUnlockMsgBox:Reset()
			slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox:Load()
			slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox.Load.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = slot0.appreciateProxy:getMusicUnlockMaterialByID(slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox.Load.appreciateUnlockMsgBox),
				onYes = function ()
					pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_UNLOCK, {
						musicID = slot0,
						unlockCBFunc = function ()
							slot0:updatePlateTF(slot0, )
							slot0.updatePlateTF:updateSongTF(slot0.songTFList[slot2 + 1], slot2 + 1)
							slot0.updatePlateTF.updateSongTF:updatePlayPanel()
							slot0.updatePlateTF.updateSongTF.updatePlayPanel:tryPlayMusic()
							slot0.updatePlateTF.updateSongTF.updatePlayPanel.tryPlayMusic.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif slot17 == GalleryConst.CardStates.DisUnlockable then
		setActive(slot6, true)
		setActive(slot7, true)
		setActive(slot8, true)
		setActive(slot9, false)
		setActive(slot10, false)
		setActive(slot11, false)
		setText(slot8, slot13.illustrate)
	end
end

slot0.initSongListPanel = function (slot0)
	slot0.songUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0.songTFList[slot1 + 1] = slot2

			slot0:updateSongTF(slot2, slot1 + 1)
		end
	end)
end

slot0.updateSongListPanel = function (slot0)
	slot0.songTFList = {}

	if #slot0.musicForShowConfigList == 0 then
		return
	end

	slot0.songUIItemList:align(#slot0.musicForShowConfigList)
end

slot0.updateSongTF = function (slot0, slot1, slot2)
	if #slot0.musicForShowConfigList == 0 then
		return
	end

	slot4 = slot0:findTF("IndexText", slot3)
	slot6 = slot0:findTF("NameText", slot3)
	slot7 = slot0:findTF("PlayingImg", slot3)
	slot8 = slot0:findTF("DownloadImg", slot3)
	slot9 = slot0:findTF("LockImg", slot3)

	setActive(slot5, true)
	slot0:updateSongTFLikeImg(slot1, slot0.appreciateProxy:isLikedByMusicID(slot11))

	slot12, slot13 = nil
	slot13 = slot0.appreciateProxy:getMusicExistStateByID(slot11)
	slot16 = slot0.manager:CheckF(slot15)
	slot17 = nil

	if slot0:getMusicStateByID(slot11) == MusicCollectionConst.MusicStates.Unlockable then
		slot17 = MusicCollectionConst.Color_Of_Empty_Song

		setActive(slot7, false)
		setActive(slot8, false)
		setActive(slot9, true)
	elseif slot12 == MusicCollectionConst.MusicStates.DisUnlockable then
		slot17 = MusicCollectionConst.Color_Of_Empty_Song

		setActive(slot7, false)
		setActive(slot8, false)
		setActive(slot9, true)
	elseif slot12 == MusicCollectionConst.MusicStates.Unlocked then
		if slot13 then
			slot18 = slot0.isPlayingSong
			slot19 = slot2 == slot0.curMidddleIndex

			if slot18 and slot19 then
				slot17 = MusicCollectionConst.Color_Of_Playing_Song

				setActive(slot7, true)
				setActive(slot8, false)
				setActive(slot9, false)
			else
				slot17 = MusicCollectionConst.Color_Of_Normal_Song

				setActive(slot7, false)
				setActive(slot8, false)
				setActive(slot9, false)
			end
		elseif slot16 == DownloadState.None or slot16 == DownloadState.CheckToUpdate or slot16 == DownloadState.UpdateFailure then
			slot17 = MusicCollectionConst.Color_Of_Empty_Song

			setActive(slot7, false)
			setActive(slot8, false)
			setActive(slot9, false)
			table.removebyvalue(slot0.downloadCheckIDList, slot11, true)

			if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
				slot0.downloadCheckTimer:Stop()

				slot0.downloadCheckTimer = nil

				return
			end
		elseif slot16 == DownloadState.Updating then
			slot17 = MusicCollectionConst.Color_Of_Empty_Song

			setActive(slot7, false)
			setActive(slot8, true)
			setActive(slot9, false)
		else
			setActive(slot7, false)
			setActive(slot8, false)
			setActive(slot9, false)

			if PathMgr.FileExists(PathMgr.getAssetBundle(slot15)) then
				slot17 = MusicCollectionConst.Color_Of_Normal_Song

				slot0.appreciateProxy:updateMusicFileExistStateTable(slot11, true)
				table.removebyvalue(slot0.downloadCheckIDList, slot11, true)

				if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
					slot0.downloadCheckTimer:Stop()

					slot0.downloadCheckTimer = nil
				end
			end
		end
	end

	setText(slot4, slot2)
	setText(slot6, setColorStr(slot10.name, slot17))
	onButton(slot0, slot3, function ()
		if slot0.isPlayingAni then
			return
		else
			if slot1 == MusicCollectionConst.MusicStates.Unlocked then
				if slot2 then
					if not isActive(slot3) then
						slot0:setAniState(true)
						slot0.setAniState:closePlateAni(slot0.plateTFList[slot0.curMidddleIndex])
						slot0.setAniState.closePlateAni.lScrollPageSC:MoveToItemID(slot4 - 1)
					end
				else
					function slot0()
						setActive(setActive, false)
						setActive(setActive, true)
						setActive(true, false)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_BGM", slot3, false)

						if not table.contains(slot4.downloadCheckIDList, slot5) then
							table.insert(slot4.downloadCheckIDList, slot5)
						end

						slot4:tryStartDownloadCheckTimer()
						slot4:setAniState(true)
						slot4:closePlateAni(slot4.plateTFList[slot4.curMidddleIndex])
						slot4.lScrollPageSC:MoveToItemID(slot6 - 1)
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
							content = i18n("res_wifi_tip"),
							onYes = slot0
						})
					else
						slot0()
					end
				end
			elseif slot1 == MusicCollectionConst.MusicStates.DisUnlockable then
				pg.TipsMgr.GetInstance():ShowTips(slot9.illustrate)
			elseif slot1 == MusicCollectionConst.MusicStates.Unlockable then
				if not slot0.appreciateUnlockMsgBox then
					slot0.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(slot0._tf, slot0.event, slot0.contextData)
				end

				slot0.appreciateUnlockMsgBox:Reset()
				slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox:Load()
				slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox.Load.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
					content = i18n("res_unlock_tip"),
					items = slot0.appreciateProxy:getMusicUnlockMaterialByID(slot8),
					onYes = function ()
						pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_UNLOCK, {
							musicID = slot0,
							unlockCBFunc = function ()
								slot0.lScrollPageSC:MoveToItemID(slot1 - 1)

								if slot0.lScrollPageSC.MoveToItemID.plateTFList[slot0.lScrollPageSC] then
									slot0:updatePlateTF(slot0.plateTFList[slot1], slot1 - 1)
								end

								slot0:updateSongTF(slot2, slot0)
								slot0.updateSongTF.appreciateUnlockMsgBox:hideCustomMsgBox()
							end
						})
					end
				})
			end

			slot0.closeSongListPanel(slot0)
		end
	end, SFX_PANEL)
end

slot0.updateSongTFLikeImg = function (slot0, slot1, slot2)
	setActive(slot4, true)
	triggerToggle(slot0:findTF("LikeToggle", slot3), slot2)
end

slot0.updateSortToggle = function (slot0)
	setActive(slot0.upImg1, slot0.sortValue == MusicCollectionConst.Sort_Order_Up)
	setActive(slot0.upImg2, slot0.sortValue == MusicCollectionConst.Sort_Order_Up)
	setActive(slot0.downImg1, slot0.sortValue == MusicCollectionConst.Sort_Order_Down)
	setActive(slot0.downImg2, slot0.sortValue == MusicCollectionConst.Sort_Order_Down)
end

slot0.updateLikeToggle = function (slot0)
	setActive(slot0.likeFilteOnImg, slot0.likeValue == MusicCollectionConst.Filte_Like_Value)
end

slot0.updatePlayPanel = function (slot0)
	if #slot0.musicForShowConfigList == 0 then
		setActive(slot0.playPanel, false)
		setActive(slot0.playingAni, false)
		setActive(slot0.staicImg, false)
		setActive(slot0.songNameText, false)
		setActive(slot0.emptyPanel, true)

		return
	else
		setActive(slot0.playPanel, true)
		setActive(slot0.playingAni, false)
		setActive(slot0.staicImg, true)
		setActive(slot0.songNameText, true)
		setActive(slot0.emptyPanel, false)
	end

	slot1 = slot0:getMusicConfigForShowByIndex(slot0.curMidddleIndex)

	slot0.resLoader:LoadSprite(slot3, slot2, slot0.songImg, false)
	setScrollText(slot0.songNameText, slot4)
	setText(slot0.playPanelNameText, slot4)
	setActive(slot0.likeOnImg, slot0.appreciateProxy:isLikedByMusicID(slot1.id))

	slot5 = nil

	if slot0:getMusicStateByID(slot1.id) == GalleryConst.CardStates.Unlockable or slot5 == GalleryConst.CardStates.DisUnlockable then
		setActive(slot0.likeToggle, false)
	else
		setActive(slot0.likeToggle, true)
	end

	if not slot0:isCanPlayByMusicID(slot1.id) then
		setActive(slot0.playBtn, false)
		setActive(slot0.pauseBtn, false)
		setActive(slot0.lockImg, true)

		slot0.playSliderSC.enabled = false

		slot0.playSliderSC:SetValueWithoutEvent(0)
		setActive(slot0.nowTimeText, false)
		setActive(slot0.totalTimeText, false)
	else
		setActive(slot0.playBtn, true)
		setActive(slot0.pauseBtn, false)
		setActive(slot0.lockImg, false)

		slot0.playSliderSC.enabled = true

		slot0.playSliderSC:SetValueWithoutEvent(0)
		setActive(slot0.nowTimeText, true)
		setActive(slot0.totalTimeText, true)
	end
end

slot0.sortAndUpdate = function (slot0, slot1)
	slot0.curMidddleIndex = 1

	slot0:saveRunData()

	slot0.musicForShowConfigList = slot0:fliteMusicConfigForShow()

	slot0:sortMusicConfigList(slot1)

	slot0.musicForShowConfigList = slot0:filteMusicConfigByLike()

	slot0:stopMusic()
	slot0:checkUpdateSongTF()
	slot0:updatePlateListPanel()
	slot0:updateSongListPanel()
	slot0:updatePlayPanel()
	slot0:updateSortToggle()
	slot0:updateLikeToggle()
	slot0:tryPlayMusic()
end

slot0.initTimer = function (slot0)
	slot0.playProgressTimer = Timer.New(function ()
		if slot0.playbackInfo then
			slot0 = slot0.playbackInfo:GetTime()

			slot0.playSliderSC:SetValueWithoutEvent(slot0)
			setText(slot0.nowTimeText, slot0:descTime(slot0))

			if slot0.playbackInfo.playback:GetStatus():ToInt() == 3 then
				slot0:stopMusic()
				slot0:checkUpdateSongTF()
				SetActive(slot0.pauseBtn, false)
				SetActive(slot0.playBtn, true)
				slot0:tryPlayMusic()
			end
		end
	end, 0.033, -1)

	slot0.playProgressTimer.Start(slot1)
end

slot0.playPlateAni = function (slot0, slot1, slot2, slot3, slot4)
	setActive(slot5, slot2)
	setActive(slot0:findTF("BoxImg", slot1), slot2)

	slot7 = 0.5

	if slot2 == true then
		slot10 = (443 - 198) / slot7
		slot13 = (-121 - 0) / slot7

		LeanTween.value(go(slot1), 0, slot7, slot7):setOnUpdate(System.Action_float(function (slot0)
			setAnchoredPosition(slot4, Vector2.New(slot1, 0))
			setAnchoredPosition(Vector2.New, Vector2.New(slot1 * slot0 + slot3 * slot0, 0))
		end)).setOnComplete(slot14, System.Action(function ()
			setAnchoredPosition(setAnchoredPosition, Vector2.New(setAnchoredPosition, 0))
			setAnchoredPosition(Vector2.New, Vector2.New(setAnchoredPosition, 0))
			slot4:setAniState(false)
		end))

		return
	end

	slot10 = (198 - 448) / slot7
	slot13 = ((slot3 - slot4) * (slot0.lScrollPageSC.ItemSize.x + slot0.lScrollPageSC.MarginSize.x) - getAnchoredPosition(slot1).x) / slot7

	setAnchoredPosition(slot5, Vector2.New(slot9, 0))
	setAnchoredPosition(slot1, Vector2.New((slot3 - slot4) * (slot0.lScrollPageSC.ItemSize.x + slot0.lScrollPageSC.MarginSize.x), 0))
end

slot0.closePlateAni = function (slot0, slot1)
	setActive(slot2, false)
	setActive(slot3, false)
	setAnchoredPosition(slot2, Vector2.New(198, 0))
	setAnchoredPosition(slot1, Vector2.zero)
end

slot0.setAniState = function (slot0, slot1)
	slot0.isPlayingAni = slot1
end

slot0.openSongListPanel = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0.songListPanel, false, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})

	slot0.songListPanel.offsetMax = slot0._tf.parent.offsetMax
	slot0.songListPanel.offsetMin = slot0._tf.parent.offsetMin

	setActive(slot0.songListPanel, true)
	LeanTween.value(go(slot0.panel), -460, 500, 0.3):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0.panel, {
			y = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setAnchoredPosition(slot0.panel, {
			y = 500
		})
	end))
end

slot0.closeSongListPanel = function (slot0, slot1)
	if slot1 == true then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.songListPanel, slot0._tf)
		setActive(slot0.songListPanel, false)
	end

	if isActive(slot0.songListPanel) then
		LeanTween.cancel(go(slot0.panel))
		LeanTween.value(go(slot0.panel), slot2, -460, 0.3):setOnUpdate(System.Action_float(function (slot0)
			setAnchoredPosition(slot0.panel, {
				y = slot0
			})
		end)).setOnComplete(slot3, System.Action(function ()
			setAnchoredPosition(slot0.panel, {
				y = -460
			})
			pg.UIMgr.GetInstance():UnblurPanel(slot0.songListPanel, slot0._tf)
			setActive(slot0.songListPanel, false)
		end))
	end
end

slot0.playMusic = function (slot0)
	slot2 = slot0:getMusicConfigForShowByIndex(slot0.curMidddleIndex).music

	if not slot0.cueData then
		slot0.cueData = CueData.New()
	end

	slot0.cueData.channelName = pg.CriMgr.C_GALLERY_MUSIC
	slot0.cueData.cueSheetName = slot2
	slot0.cueData.cueName = ""

	CriWareMgr.Inst:PlaySound(slot0.cueData, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function (slot0)
		slot0.playbackInfo = slot0

		slot0.playbackInfo:SetIgnoreAutoUnload(true)
		setSlider(slot0.playProgressBar, 0, slot0.playbackInfo:GetLength(), 0)
		setText(slot0.totalTimeText, slot0:descTime(slot0.playbackInfo:GetLength()))

		slot0.isPlayingSong = true

		setActive(slot0.playingAni, true)
		setActive(slot0.staicImg, false)
		slot0:updateSongTF(slot0.songTFList[slot0.curMidddleIndex], slot0.curMidddleIndex)
	end)
end

slot0.stopMusic = function (slot0)
	if slot0.playbackInfo then
		slot0.playbackInfo:SetStartTime(0)
		CriWareMgr.Inst:StopSound(slot0.cueData, CriWareMgr.CRI_FADE_TYPE.NONE)

		slot0.playbackInfo = nil
		slot0.isPlayingSong = false
	end

	setActive(slot0.playingAni, false)
	setActive(slot0.staicImg, true)
	slot0.playSliderSC:SetValueWithoutEvent(0)
	setText(slot0.nowTimeText, slot0:descTime(0))
end

slot0.checkUpdateSongTF = function (slot0)
	if #slot0.songTFList > 0 then
		slot0:updateSongTF(slot0.songTFList[slot0.curMidddleIndex], slot0.curMidddleIndex)
	end
end

slot0.tryPlayMusic = function (slot0)
	if #slot0.musicForShowConfigList == 0 then
		return
	end

	if slot0:isCanPlayByMusicID(slot0:getMusicConfigForShowByIndex(slot0.curMidddleIndex).id) and isActive(slot0.playBtn) then
		triggerButton(slot0.playBtn)
	end
end

slot0.tryPauseMusic = function (slot0)
	if isActive(slot0.pauseBtn) and slot0.playbackInfo then
		triggerButton(slot0.pauseBtn)
	end
end

slot0.fliteMusicConfigForShow = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(pg.music_collect_config.all) do
		slot7 = slot0.appreciateProxy:getSingleMusicConfigByID(slot6)

		if slot0.appreciateProxy:isMusicNeedUnlockByID(slot6) then
			if not slot0.appreciateProxy:isMusicUnlockedByID(slot6) then
				slot10, slot11 = slot0.appreciateProxy:isMusicUnlockableByID(slot6)

				if slot10 then
					slot1[#slot1 + 1] = slot7
				elseif slot11 then
					slot1[#slot1 + 1] = slot7
				end
			else
				slot1[#slot1 + 1] = slot7
			end
		else
			slot1[#slot1 + 1] = slot7
		end
	end

	return slot1
end

slot0.getMusicConfigForShowByIndex = function (slot0, slot1)
	if slot0.musicForShowConfigList[slot1] then
		return slot2
	end
end

slot0.getMusicStateByID = function (slot0, slot1)
	if not slot0.appreciateProxy:isMusicNeedUnlockByID(slot1) then
		return MusicCollectionConst.MusicStates.Unlocked
	elseif slot0.appreciateProxy:isMusicUnlockedByID(slot1) then
		return MusicCollectionConst.MusicStates.Unlocked
	elseif slot0.appreciateProxy:isMusicUnlockableByID(slot1) then
		return MusicCollectionConst.MusicStates.Unlockable
	else
		return MusicCollectionConst.MusicStates.DisUnlockable
	end
end

slot0.sortMusicConfigList = function (slot0, slot1)
	function slot2(slot0, slot1)
		slot2 = slot0.id
		slot3 = slot1.id

		if slot0 == true then
			return slot3 < slot2
		else
			return slot2 < slot3
		end
	end

	table.sort(slot0.musicForShowConfigList, slot2)
end

slot0.filteMusicConfigByLike = function (slot0)
	if slot0.likeValue == MusicCollectionConst.Filte_Normal_Value then
		return slot0.musicForShowConfigList
	end

	slot1 = {}

	for slot5, slot6 in ipairs(slot0.musicForShowConfigList) do
		if slot0.appreciateProxy:isLikedByMusicID(slot6.id) then
			slot1[#slot1 + 1] = slot6
		end
	end

	return slot1
end

slot0.isCanPlayByMusicID = function (slot0, slot1)
	slot2, slot3 = nil
	slot3 = slot0.appreciateProxy:getMusicExistStateByID(slot1)

	if slot0:getMusicStateByID(slot1) == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if slot3 then
			return true
		else
			return false
		end
	elseif slot2 == GalleryConst.CardStates.Unlocked then
		if slot3 then
			return true
		else
			return false
		end
	elseif slot2 == GalleryConst.CardStates.Unlockable then
		return false
	elseif slot2 == GalleryConst.CardStates.DisUnlockable then
		return false
	end
end

slot0.descTime = function (slot0, slot1)
	slot4 = math.floor((math.floor(slot1 / 1000) - math.floor(math.floor(slot1 / 1000) / 3600) * 3600) / 60)
	slot5 = (math.floor(slot1 / 1000) - math.floor(math.floor(slot1 / 1000) / 3600) * 3600) % 60

	if math.floor(math.floor(slot1 / 1000) / 3600) ~= 0 then
		return string.format("%02d:%02d:%02d", slot3, slot4, slot5)
	else
		return string.format("%02d:%02d", slot4, slot5)
	end
end

slot0.tryStartDownloadCheckTimer = function (slot0)
	if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
		slot0.downloadCheckTimer:Stop()

		slot0.downloadCheckTimer = nil

		return
	end

	if not slot0.downloadCheckTimer and #slot0.downloadCheckIDList > 0 then
		function slot1()
			for slot3, slot4 in ipairs(slot0.downloadCheckIDList) do
				slot5 = nil

				for slot9, slot10 in ipairs(slot0.musicForShowConfigList) do
					if slot10.id == slot4 then
						slot5 = slot9

						break
					end
				end

				if slot5 then
					slot0:updatePlateTF(slot6, slot5 - 1)
					slot0:updateSongTF(slot0.songTFList[slot5], slot5)
				end
			end
		end

		slot0.downloadCheckTimer = Timer.New(slot1, 1, -1)

		slot0.downloadCheckTimer:Start()
	end
end

return slot0

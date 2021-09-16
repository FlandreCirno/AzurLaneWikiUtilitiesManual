slot0 = class("MusicGameView", import("..BaseMiniGameView"))
slot0.loadMusicFlag = 0
slot1 = 1
slot2 = 3
slot3 = 3
slot4 = 4
slot5 = 2

slot0.getUIName = function (slot0)
	return "MusicGameUI"
end

slot0.MyGetRuntimeData = function (slot0)
	slot0.achieve_times = checkExist(slot0:GetMGData():GetRuntimeData("elements"), {
		1
	}) or 0
	slot0.isFirstgame = PlayerPrefs.GetInt("musicgame_first_" .. getProxy(PlayerProxy):getData().id)
	slot0.bestScorelist = {}

	for slot5 = 1, slot0.music_amount * 2, 1 do
		slot0.bestScorelist[slot5] = checkExist(slot0:GetMGData():GetRuntimeData("elements"), {
			slot5 + 2
		}) or 0
	end

	slot0:updatSelectview()
end

slot0.MyStoreDataToServer = function (slot0)
	slot2 = {
		slot0.achieve_times,
		1
	}

	PlayerPrefs.SetInt("musicgame_first_" .. slot1, 1)

	for slot6 = 1, slot0.music_amount * 2, 1 do
		table.insert(slot2, slot6 + 2, slot0.bestScorelist[slot6])
	end

	slot0:StoreDataToServer(slot2)
end

slot0.init = function (slot0)
	slot0.UIMgr = pg.UIMgr.GetInstance()
	slot0.useGetKey_flag = true
	slot0.game_playingflag = false
	slot0.countingfive_flag = false
	slot0.downingleft_flag = false
	slot0.downingright_flag = false
	slot0.downingright_lastflag = false
	slot0.downingleft_lastflag = false
	slot0.nowS_flag = false
	slot0.firstview_timerRunflag = false
	slot0.ahead_timeflag = false
	slot0.ahead_timerPauseFlag = false
	slot0.changeLocalposTimerflag = false
	slot0.piecelist_rf = {
		[0] = 0
	}
	slot0.piecelist_lf = {
		[0] = 0
	}
	slot0.piece_nowl = {}
	slot0.piece_nowr = {}
	slot0.piece_nowl_downflag = false
	slot0.piece_nowr_downflag = false
	slot0.piece_nowl_aloneflag = false
	slot0.piece_nowr_aloneflag = false
	slot0.SDmodel = {}
	slot0.SDmodel_idolflag = false
	slot0.musicgame_nowtime = 0
	slot0.musicgame_lasttime = 0
	slot0.time_interval = 0.01666
	slot0.music_amount = 5
	slot0.music_amount_middle = 3
	slot0.game_speed = (PlayerPrefs.GetInt("musicgame_idol_speed") > 0 and PlayerPrefs.GetInt("musicgame_idol_speed")) or 1
	slot0.game_dgree = 1

	slot0:updateMusic(slot0)

	slot0.BG = slot0:findTF("BG")
	slot0.top = slot0:findTF("top")
	slot0.btn_pause = slot0.top:Find("pause")
	slot0.score = slot0.top:Find("score")
	slot0.game_content = slot0:findTF("GameContent")
	slot0.pauseview = slot0:findTF("Pauseview")
	slot0.selectview = slot0:findTF("Selectview")
	slot1 = findTF(slot0.selectview, "bg")

	LoadSpriteAsync("ui/minigameui/musicgameother/selectbg", function (slot0)
		GetComponent(slot0, typeof(Image)).sprite = slot0

		setActive(slot0, true)
	end)

	slot0.firstview = slot0.findTF(slot0, "firstview")
	slot0.scoreview = slot0:findTF("ScoreView")

	setActive(slot0.scoreview, false)

	slot0.scoreview_flag = false
	slot0.fullComboEffect = slot0.game_content:Find("yinyue20_Fullcombo")
	slot0.liveClearEffect = slot0.game_content:Find("yinyue20_LiveClear")
	slot0.bg = findTF(slot0._tf, "bg")

	pg.CriMgr.GetInstance():StopBGM()
end

slot0.didEnter = function (slot0)
	slot1 = 0

	function slot2()
		if slot0 + slot1.time_interval == slot1.time_interval.time_interval then
			slot1:MyGetRuntimeData()
			slot1:showSelevtView()
		elseif slot0 == slot1.time_interval * 2 then
			slot1:updatSelectview()
			slot1.Getdata_timer:Stop()
		end
	end

	LeanTween.delayedCall(go(slot0.selectview), 2, System.Action(function ()
		slot0:MyGetRuntimeData()
	end))

	slot0.Getdata_timer = Timer.New(slot2, slot0.time_interval, -1)

	slot0.Getdata_timer:Start()

	slot0.score_number = 0
	slot0.combo_link = 0
	slot0.combo_number = 0
	slot0.perfect_number = 0
	slot0.good_number = 0
	slot0.miss_number = 0
	slot3 = slot0:GetMGData():getConfig("simple_config_data")
	slot0.piecelist_speed = slot3.speed
	slot0.piecelist_speedmin = slot3.speed_min
	slot0.piecelist_speedmax = slot3.speed_max
	slot0.score_blist = slot3.Blist
	slot0.score_alist = slot3.Alist
	slot0.score_slist = slot3.Slist
	slot0.score_sslist = slot3.SSlist
	slot0.specialcombo_number = slot3.special_combo
	slot0.specialscore_number = slot3.special_score
	slot0.score_perfect = slot3.perfect
	slot0.score_good = slot3.good
	slot0.score_miss = slot3.miss
	slot0.score_combo = slot3.combo
	slot0.time_perfect = slot3.perfecttime
	slot0.time_good = slot3.goodtime
	slot0.time_miss = slot3.misstime
	slot0.time_laterperfect = slot3.laterperfecttime
	slot0.time_latergood = slot3.latergoodtime
	slot0.combo_interval = slot3.combo_interval
	slot0.leftBtmBg = slot0.game_content:Find("bottomList2/bottom_leftbg")
	slot0.rightBtmBg = slot0.game_content:Find("bottomList2/bottom_rightbg")

	setActive(slot0.leftBtmBg, false)
	setActive(slot0.rightBtmBg, false)

	slot0.BtnRightDelegate = GetOrAddComponent(slot0.game_content:Find("btn_right"), "EventTriggerListener")

	slot0.BtnRightDelegate:AddPointDownFunc(function ()
		slot0.mousedowningright_flag = true

		setActive(slot0.rightBtmBg, true)
	end)
	slot0.BtnRightDelegate.AddPointUpFunc(slot4, function ()
		slot0.mousedowningright_flag = false

		setActive(slot0.rightBtmBg, false)
	end)

	slot0.BtnLeftDelegate = GetOrAddComponent(slot0.game_content.Find(slot5, "btn_left"), "EventTriggerListener")

	slot0.BtnLeftDelegate:AddPointDownFunc(function ()
		slot0.mousedowningleft_flag = true

		setActive(slot0.leftBtmBg, true)
	end)
	slot0.BtnLeftDelegate.AddPointUpFunc(slot4, function ()
		slot0.mousedowningleft_flag = false

		setActive(slot0.leftBtmBg, false)
	end)
	onButton(slot0, slot0.top:Find("pause"), function ()
		slot0.UIMgr:BlurPanel(slot0.pauseview)
		setActive(slot0.pauseview, true)

		setActive.game_playingflag = false

		setActive:effect_play("nothing")

		slot0 = setActive.effect_play.pauseview:Find("bottom/song"):GetComponent(typeof(Image))
		slot0.sprite = slot0.selectview:Find("Main/MusicList/img/" .. slot0.musicData.img):GetComponent(typeof(Image)).sprite

		if not slot0.ahead_timeflag then
			slot0:pauseBgm()

			slot1 = slot0.song_Tlength

			if slot0.pauseBgm:getStampTime() < 0 then
				slot0 = 0
			end

			if slot0 >= 0 and slot1 > 0 then
				setText(slot0.pauseview:Find("bottom/now"), slot4 .. ":" .. slot2(math.floor(slot0 % 60000 / 1000)))
				setText(slot0.pauseview:Find("bottom/total"), slot4 .. ":" .. slot3)
				setActive(slot0.pauseview:Find("bottom/triangle"), true)
				setActive(slot0.pauseview:Find("bottom/TimeSlider"), true)
				setActive(slot0.pauseview:Find("bottom/now"), true)
				setActive(slot0.pauseview:Find("bottom/total"), true)
				setSlider(slot0.pauseview:Find("bottom/TimeSlider"), 0, 1, slot0 / slot1)

				slot0.pauseview:Find("bottom/triangle/now").localPosition = Vector3(slot0.pauseview:Find("bottom/triangle/min").localPosition.x + slot0 / slot1 * (slot0.pauseview:Find("bottom/triangle/max").localPosition.x - slot0.pauseview.Find("bottom/triangle/min").localPosition.x), slot0.pauseview:Find("bottom/triangle/now").localPosition.y, slot0.pauseview.Find("bottom/triangle/now").localPosition.z)

				slot0:setActionSDmodel("stand2")
			end
		else
			setActive(slot0.pauseview:Find("bottom/triangle"), false)
			setActive(slot0.pauseview:Find("bottom/TimeSlider"), false)
			setActive(slot0.pauseview:Find("bottom/now"), false)
			setActive(slot0.pauseview:Find("bottom/total"), false)

			setActive.ahead_timerPauseFlag = true
		end
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.pauseview:Find("bottom/back"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("reselect_music_game"),
			onYes = function ()
				slot0.UIMgr:UnblurPanel(slot0.pauseview, slot0._tf)
				setActive(slot0.pauseview, false)
				setActive:stopTimer()

				if setActive.stopTimer.ahead_timer then
					slot0.ahead_timer:Stop()

					slot0.ahead_timer.Stop.ahead_timeflag = false
				end

				slot0:piecelistALLTtoF()
				setActive(slot0.selectview, true)

				GetOrAddComponent(slot0.selectview, "CanvasGroup").blocksRaycasts = true

				GetOrAddComponent(slot0.selectview, "CanvasGroup").song_btns[slot0.game_music]:GetComponent(typeof(Animator)):Play("plate_out")

				GetOrAddComponent(slot0.selectview, "CanvasGroup").song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play.game_playingflag = false

				GetOrAddComponent(slot0.selectview, "CanvasGroup").song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play:loadAndPlayMusic()
				GetOrAddComponent(slot0.selectview, "CanvasGroup").song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play.loadAndPlayMusic:rec_scorce()
			end
		})
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.pauseview:Find("bottom/restart"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("restart_music_game"),
			onYes = function ()
				slot0.UIMgr:UnblurPanel(slot0.pauseview, slot0._tf)
				setActive(slot0.pauseview, false)
				setActive:stopTimer()

				if setActive.stopTimer.ahead_timer then
					slot0.ahead_timer:Stop()

					slot0.ahead_timer.Stop.ahead_timeflag = false
				end

				slot0:piecelistALLTtoF()
				slot0.piecelistALLTtoF:rec_scorce()
				slot0.piecelistALLTtoF.rec_scorce:game_start()
				slot0.piecelistALLTtoF.rec_scorce.game_start:effect_play("prepare")
			end
		})
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.pauseview:Find("bottom/resume"), function ()
		slot0.UIMgr:UnblurPanel(slot0.pauseview, slot0._tf)
		setActive(slot0.pauseview, false)
		setActive:effect_play("prepare")

		if not setActive.effect_play.ahead_timeflag then
			slot0.count_five(slot1, function ()
				slot0:resumeBgm()

				slot0.resumeBgm.game_playingflag = true
			end)
		else
			slot0.count_five(slot1, function ()
				slot0.ahead_timerPauseFlag = false
				slot0.game_playingflag = true

				setActive(slot0.pauseview:Find("bottom/triangle"), true)
				setActive(slot0.pauseview:Find("bottom/TimeSlider"), true)
				setActive(slot0.pauseview:Find("bottom/now"), true)
				setActive(slot0.pauseview:Find("bottom/total"), true)
			end)
		end
	end, SFX_UI_CLICK)
	slot0.addRingDragListenter(slot0)
	setActive(slot0.selectview, true)

	GetOrAddComponent(slot0.selectview, "CanvasGroup").blocksRaycasts = true
	slot4 = slot0.top:Find("ScoreSlider")
	slot5 = slot0.top:Find("ScoreSlider/B")
	slot5.anchoredPosition = Vector3(slot4.rect.width * 0.53, slot5.anchoredPosition.y, slot5.anchoredPosition.z)
	slot0.top:Find("ScoreSlider/A").anchoredPosition = Vector3(slot4.rect.width * 0.72, slot5.anchoredPosition.y, slot5.anchoredPosition.z)
	slot0.top:Find("ScoreSlider/S").anchoredPosition = Vector3(slot4.rect.width * 0.885, slot5.anchoredPosition.y, slot5.anchoredPosition.z)
end

slot0.updateMusicPiece = function (slot0)
	slot0.music_piece = slot0.game_content:Find("MusicPiece" .. slot0.musicData.music_piece)

	for slot4 = 1, slot0, 1 do
		setActive(findTF(slot0.game_content, "MusicPiece" .. slot4), slot4 == slot0.musicData.music_piece)
	end
end

slot0.updateBg = function (slot0)
	if slot0.isLoading then
		slot0:dynamicBgHandler(slot0.bgGo, function ()
			setParent(slot0.bgGo, slot0.bg)
			setActive(slot0.bgGo, true)
		end)

		return
	end

	if slot0.bgGo and slot0.bgName then
		slot0.dynamicBgHandler(slot0, slot0.bgGo)
		PoolMgr.GetInstance():ReturnUI(slot0.bgName, slot0.bgGo)
	end

	slot0.bgName = "musicgamebg" .. slot0.musicBg
	slot0.isLoading = true

	PoolMgr.GetInstance():GetUI(slot0.bgName, true, function (slot0)
		slot0.bgGo = slot0

		if slot0.isLoading == false then
			slot0:dynamicBgHandler(slot0.bgGo)
			PoolMgr.GetInstance():ReturnUI(PoolMgr.GetInstance().ReturnUI, slot0.bgGo)
		else
			slot0.isLoading = false

			setParent(slot0.bgGo, slot0.bg)
			setActive(slot0.bgGo, true)
		end
	end)
end

slot0.dynamicBgHandler = function (slot0, slot1, slot2)
	if IsNil(slot1) then
		return
	end

	if slot2 ~= nil then
		slot2()
	end
end

slot0.onBackPressed = function (slot0)
	if not slot0.countingfive_flag and not slot0.firstview_timerRunflag then
		if slot0.game_playingflag then
			if not isActive(slot0.top:Find("pause_above")) then
				triggerButton(slot0.top:Find("pause"))
			end
		elseif isActive(slot0.selectview) and MusicGameView.loadMusicFlag == 0 then
			slot0:emit(slot0.ON_BACK)
		end
	end
end

slot0.OnApplicationPaused = function (slot0, slot1)
	if slot1 and not slot0.countingfive_flag and not slot0.firstview_timerRunflag and slot0.game_playingflag and not isActive(slot0.top:Find("pause_above")) then
		triggerButton(slot0.top:Find("pause"))
	end
end

slot0.willExit = function (slot0)
	slot0.isLoading = false

	if slot0.bgGo and slot0.bgName then
		slot0:dynamicBgHandler(slot0.bgGo)
		PoolMgr.GetInstance():ReturnUI(slot0.bgName, slot0.bgGo)
	end

	if slot0.timer then
		if slot0.timer.running then
			slot0.timer:Stop()
		end

		slot0.timer = nil
	end

	if slot0.ahead_timer then
		if slot0.ahead_timer.running then
			slot0.ahead_timer:Stop()
		end

		slot0.ahead_timer = nil
	end

	if slot0.firstview_timer then
		if slot0.firstview_timer.running then
			slot0.firstview_timer:Stop()
		end

		slot0.firstview_timer = nil
	end

	if slot0.changeLocalpos_timer then
		if slot0.changeLocalpos_timer.running then
			slot0.changeLocalpos_timer:Stop()
		end

		slot0.changeLocalpos_timer = nil
	end

	if slot0.count_timer then
		if slot0.count_timer.running then
			slot0.count_timer:Stop()
		end

		slot0.count_timer = nil
	end

	if slot0.Scoceview_timer then
		if slot0.Scoceview_timer.running then
			slot0.Scoceview_timer:Stop()
		end

		slot0.Scoceview_timer = nil
	end

	if slot0.Getdata_timer then
		if slot0.Getdata_timer.running then
			slot0.Getdata_timer:Stop()
		end

		slot0.Getdata_timer = nil
	end

	slot0:clearSDModel()

	slot0.piecelist_lt = {}
	slot0.piecelist_lf = {}
	slot0.musictable_l = {}
	slot0.piece_nowl = {}
	slot0.piecelist_rt = {}
	slot0.piecelist_rf = {}
	slot0.musictable_r = {}
	slot0.piece_nowr = {}

	if slot0.painting then
		retPaintingPrefab(slot0.scoreview:Find("paint"), slot0.painting)

		slot0.painting = nil
	end

	if slot0.criInfo then
		slot0.criInfo:PlaybackStop()
		slot0.criInfo:SetStartTimeAndPlay(0)
		pg.CriMgr.GetInstance():UnloadCueSheet("bgm-song" .. slot0.musicData.bgm)

		slot0.criInfo = nil
	end

	if LeanTween.isTweening(go(slot0.selectview)) then
		LeanTween.cancel(go(slot0.selectview))
	end

	if LeanTween.isTweening(go(slot0.BG)) then
		LeanTween.cancel(go(slot0.BG))
	end

	if LeanTween.isTweening(go(slot0.scoreview)) then
		LeanTween.cancel(go(slot0.scoreview))
	end

	if LeanTween.isTweening(go(slot0.game_content)) then
		LeanTween.cancel(go(slot0.game_content))
	end
end

slot0.clearSDModel = function (slot0)
	if not slot0.SDmodel or not slot0.SDname then
		return
	end

	for slot4 = 1, #slot0.SDmodel, 1 do
		if slot0.SDmodel[slot4] then
			PoolMgr.GetInstance():ReturnSpineChar(slot0.SDname[slot4], slot0.SDmodel[slot4])
		end
	end

	slot0.SDmodel = {}
end

slot0.list_push = function (slot0, slot1, slot2)
	slot1[slot1[0] + 1] = slot2
	slot1[0] = slot1[0] + 1
end

slot0.list_pop = function (slot0, slot1)
	if slot1[0] == 0 then
		return
	end

	slot2 = slot1[1]

	for slot6 = 1, slot1[0] - 1, 1 do
		slot1[slot6] = slot1[slot6 + 1]
	end

	slot1[0] = slot1[0] - 1

	return slot2
end

slot0.game_start = function (slot0)
	slot0:game_before()
	slot0:effect_play("prepare")

	slot0.game_playingflag = true
	slot0.SDmodel_jumpcount = 0
	slot0.gotspecialcombo_flag = false

	slot0:updateBg()

	slot0.song_Tlength = false

	slot0:effect_play("nothing")
	slot0:effect_play("prepare")

	if slot0.isFirstgame == 0 then
		slot0:Firstshow(slot0.firstview, function ()
			slot0:gameStart()
		end, 2)
		slot0.MyStoreDataToServer(slot0)
	else
		slot0:gameStart()
	end
end

slot0.game_before = function (slot0)
	slot0:effect_play("nothing")

	slot0.nowS_flag = false

	setActive(slot0.top:Find("ScoreSlider/House/yinyue20_S"), false)

	slot0.scoreSFlag = false

	setImageColor(slot0.top:Find("ScoreSlider/House"), Color(1, 1, 1, 1))

	slot1 = slot0.game_content:Find("evaluate")

	for slot5 = 1, 3, 1 do
		setActive(slot1:GetChild(slot5 - 1), false)
	end

	slot0:clearSDModel()

	for slot5 = 1, #slot0.SDname, 1 do
		slot0:loadSDModel(slot5)
	end

	slot0:setActionSDmodel("stand2")
	setActive(slot0.game_content:Find("combo"), false)
	setActive(slot0.game_content:Find("combo_n"), false)
	setActive(slot0.game_content:Find("MusicStar"), false)
	setActive(slot0.game_content, true)
	setActive(slot0._tf:Find("Spinelist"), true)
	setActive(slot0._tf:Find("lightList"), true)
	setActive(slot0._tf:Find("shadowlist"), true)
	setActive(slot0.top, true)
	setActive(slot0.fullComboEffect, false)
	setActive(slot0.liveClearEffect, false)

	slot0.leftPu = {}
	slot0.rightPu = {}

	for slot6, slot7 in ipairs(require("view/miniGame/gameView/musicGame/bgm_song" .. slot0.musicData.pu .. "_" .. slot0.game_dgree).left_track) do
		table.insert(slot0.leftPu, slot7)
	end

	for slot6, slot7 in ipairs(slot2.right_track) do
		table.insert(slot0.rightPu, slot7)
	end

	if not slot0.gameNoteLeft then
		slot0.gameNoteLeft = MusicGameNote.New(findTF(slot0.game_content, "MusicPieceLeft"), MusicGameNote.type_left)
	end

	if not slot0.gameNoteRight then
		slot0.gameNoteRight = MusicGameNote.New(findTF(slot0.game_content, "MusicPieceRight"), MusicGameNote.type_right)
	end

	slot0.gameNoteLeft:setStartData(slot0.leftPu, slot0.game_speed, slot0.game_dgree)
	slot0.gameNoteLeft:setStateCallback(function (slot0)
		slot0:onStateCallback(slot0)
	end)
	slot0.gameNoteLeft.setLongTimeCallback(slot3, function (slot0)
		slot0:onLongTimeCallback(slot0)
	end)
	slot0.gameNoteRight.setStartData(slot3, slot0.rightPu, slot0.game_speed, slot0.game_dgree)
	slot0.gameNoteRight:setStateCallback(function (slot0)
		slot0:onStateCallback(slot0)
	end)
	slot0.gameNoteRight.setLongTimeCallback(slot3, function (slot0)
		slot0:onLongTimeCallback(slot0)
	end)

	slot0.gameStepTime = 0
	slot0.musictable_l = {
		[0] = 0
	}
	slot0.musictable_r = {
		[0] = 0
	}
	slot0.nowmusic_l = nil
	slot0.nowmusic_r = nil
	slot0.musicpu = require("view/miniGame/gameView/musicGame/bgm_song" .. slot0.musicData.pu .. "_" .. slot0.game_dgree)

	for slot6, slot7 in ipairs(slot0.musicpu.left_track) do
		slot0.list_push(slot0, slot0.musictable_l, slot7)
	end

	for slot6, slot7 in ipairs(slot0.musicpu.right_track) do
		slot0:list_push(slot0.musictable_r, slot7)
	end

	slot0.piecelist = {}
	slot0.piece_n = 0
	slot0.piecelist_lt = {
		[0] = 0
	}
	slot0.piecelist_rt = {
		[0] = 0
	}
	slot0.pieceinit_xyz = {
		left = slot0.music_piece:Find("piece_left").localPosition,
		right = slot0.music_piece:Find("piece_right").localPosition
	}
end

slot0.stopTimer = function (slot0)
	if slot0.timer.running then
		slot0.timer:Stop()
	end
end

slot0.startTimer = function (slot0)
	if not slot0.timer.running then
		slot0.timer:Start()
	end
end

slot0.loadSDModel = function (slot0, slot1)
	if not slot0.SDname[slot1] then
		slot0.SDmodel[slot1] = false

		setActive(findTF(slot0._tf, "shadowlist/" .. slot1), false)
		setActive(findTF(slot0._tf, "lightList/" .. slot1), false)

		return
	end

	setActive(findTF(slot0._tf, "lightList/" .. slot1), true)

	if slot0.musicLight then
		setActive(findTF(slot0._tf, "shadowlist/" .. slot1), true)
	else
		setActive(findTF(slot0._tf, "shadowlist/" .. slot1), false)
	end

	for slot5 = 1, slot0, 1 do
		setActive(findTF(slot0._tf, "lightList/" .. slot1 .. "/" .. slot5), slot5 == slot0.musicLight)
	end

	PoolMgr.GetInstance():GetSpineChar(slot0.SDname[slot1], true, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()

		slot0.SDmodel[] = slot0
		tf(slot0).localScale = Vector3(1, 1, 1)

		slot0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(slot0, slot0._tf:Find("Spinelist/" .. setParent))
	end)
end

slot0.SDmodeljump_btnup = function (slot0)
	if slot0.downingright_flag or slot0.downingleft_flag then
		slot0.SDmodel_jumpcount = slot0.SDmodel_jumpcount + slot0.time_interval
		slot0.SDmodel_jumpcount = (slot0.SDmodel_jumpcount > 1 and 1) or slot0.SDmodel_jumpcount
	else
		if slot0.SDmodel_jumpcount == 1 then
			slot0:setActionSDmodel("jump")

			slot0.SDmodel_idolflag = false
		end

		if slot0.SDmodel_jumpcount > 0 then
			slot0.SDmodel_jumpcount = slot0.SDmodel_jumpcount - slot0.time_interval
			slot0.SDmodel_jumpcount = (slot0.SDmodel_jumpcount >= 0 or 0) and slot0.SDmodel_jumpcount
		end

		if slot0.SDmodel_jumpcount == 0 and not slot0.SDmodel_idolflag then
			slot0.SDmodel_idolflag = true

			slot0:setActionSDmodel("idol")
		end
	end
end

slot0.setActionSDmodel = function (slot0, slot1, slot2)
	slot2 = slot2 or 0

	for slot6 = 1, #slot0.SDmodel, 1 do
		if slot0.SDmodel[slot6] then
			slot0.SDmodel[slot6]:GetComponent("SpineAnimUI"):SetAction(slot1, slot2)
		end
	end
end

slot0.loadAndPlayMusic = function (slot0, slot1, slot2)
	slot3 = nil
	MusicGameView.loadMusicFlag = MusicGameView.loadMusicFlag + 1

	CriWareMgr.Inst:PlayBGM("bgm-song" .. slot4, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function (slot0)
		if slot0 == nil then
			warning("Missing BGM :" .. (slot0 or "NIL"))
		else
			print("加载完毕,开始播放音乐")

			if print.countingfive_flag then
				return
			end

			slot1.criInfo = slot0
			slot1.song_Tlength = slot0:GetLength()

			slot0:PlaybackStop()
			slot0.SetStartTimeAndPlay(slot2, (slot0 and slot2 >= 0 and slot2) or 0)

			MusicGameView.loadMusicFlag = MusicGameView.loadMusicFlag - 1

			if slot3 then
				slot3()
			end
		end
	end)
end

slot0.getStampTime = function (slot0)
	if slot0.aheadtime_count then
		return (slot0.aheadtime_count - 2) * 1000
	elseif slot0.criInfo then
		return slot0.criInfo:GetTime()
	end

	return nil
end

slot0.pauseBgm = function (slot0)
	if slot0.criInfo then
		slot0.pauseTime = slot0.criInfo:GetTime()

		slot0.criInfo:PlaybackStop()
	end

	if slot0.timer and slot0.timer.running then
		slot0.timer:Stop()
	end
end

slot0.resumeBgm = function (slot0)
	if not slot0.timer.running then
		slot0.timer:Start()
	end

	slot0:loadAndPlayMusic(function ()
		return
	end, slot0.pauseTime)
end

slot0.rec_scorce = function (slot0)
	slot0.score_number = 0
	slot0.combo_link = 0
	slot0.combo_number = 0
	slot0.perfect_number = 0
	slot0.good_number = 0
	slot0.miss_number = 0
	slot0.gotspecialcombo_flag = false

	setActive(slot0.top:Find("ScoreSlider/B/bl"), false)
	setActive(slot0.top:Find("ScoreSlider/A/al"), false)
	setActive(slot0.top:Find("ScoreSlider/S/sl"), false)
	setSlider(slot0.top:Find("ScoreSlider"), 0, 1, 0)
	setSlider(slot0.top:Find("ScoreSlider"), 0, 1, 0)
	setText(slot0.top:Find("score"), 0)
	setText(slot0.game_content:Find("combo_n"), 0)
end

slot0.effect_play = function (slot0, slot1, slot2)
	if slot1 == "nothing" then
		setActive(slot0.game_content:Find("yinyue_perfect_loop02"), false)
		setActive(slot0.top:Find("ScoreSlider/S/liubianxing"), false)
		setActive(slot0.game_content:Find("yinyue_good"), false)
		setActive(slot0.game_content:Find("yinyue_perfect"), false)
		setActive(slot0.game_content:Find("MusicStar"), false)
		SetActive(slot0.game_content:Find("yinyue_comboeffect"), false)
	elseif slot1 == "prepare" then
	elseif slot1 == "good" then
		setActive(slot0.game_content:Find("yinyue_good"), false)
		setActive(slot0.game_content:Find("yinyue_good"), true)
	elseif slot1 == "perfect" then
		setActive(slot0.game_content:Find("yinyue_perfect"), false)
		setActive(slot0.game_content:Find("yinyue_perfect"), true)
	elseif slot1 == "perfect_loop02" then
		if slot2 then
			if not isActive(slot0.game_content:Find("yinyue_perfect_loop02")) then
				setActive(slot0.game_content:Find("yinyue_perfect_loop02"), true)
			end
		else
			setActive(slot0.game_content:Find("yinyue_perfect_loop02"), false)
		end
	elseif slot1 == "S" then
		if slot2 then
			setActive(slot0.top:Find("ScoreSlider/House/yinyue20_S"), true)
			setActive(slot0.top:Find("ScoreSlider/S/liubianxing"), true)
		else
			setActive(slot0.top:Find("ScoreSlider/House/yinyue20_S"), false)
			setActive(slot0.top:Find("ScoreSlider/S/liubianxing"), false)
		end
	end
end

slot0.scoresliderAcombo_update = function (slot0)
	slot2 = 0

	setText(slot0.top:Find("score"), slot0.score_number)
	setSlider(slot0.top:Find("ScoreSlider"), 0, 1, (slot0.score_number < slot0.score_blist[slot0.game_music][slot0.game_dgree] and slot1 / slot0.score_blist[slot3][slot4] * 0.53) or (slot0.score_blist[slot3][slot4] <= slot1 and slot1 < slot0.score_alist[slot3][slot4] and 0.53 + (slot1 - slot0.score_blist[slot3][slot4]) / (slot0.score_alist[slot3][slot4] - slot0.score_blist[slot3][slot4]) * 0.19) or (slot0.score_alist[slot3][slot4] <= slot1 and slot1 < slot0.score_slist[slot3][slot4] and 0.72 + (slot1 - slot0.score_alist[slot3][slot4]) / (slot0.score_slist[slot3][slot4] - slot0.score_alist[slot3][slot4]) * 0.155) or 0.885 + (slot1 - slot0.score_slist[slot3][slot4]) / (slot0.score_sslist[slot3][slot4] - slot0.score_slist[slot3][slot4]) * 0.115)

	if ((slot0.score_number < slot0.score_blist[slot0.game_music][slot0.game_dgree] and slot1 / slot0.score_blist[slot3][slot4] * 0.53) or (slot0.score_blist[slot3][slot4] <= slot1 and slot1 < slot0.score_alist[slot3][slot4] and 0.53 + (slot1 - slot0.score_blist[slot3][slot4]) / (slot0.score_alist[slot3][slot4] - slot0.score_blist[slot3][slot4]) * 0.19) or (slot0.score_alist[slot3][slot4] <= slot1 and slot1 < slot0.score_slist[slot3][slot4] and 0.72 + (slot1 - slot0.score_alist[slot3][slot4]) / (slot0.score_slist[slot3][slot4] - slot0.score_alist[slot3][slot4]) * 0.155) or 0.885 + (slot1 - slot0.score_slist[slot3][slot4]) / (slot0.score_sslist[slot3][slot4] - slot0.score_slist[slot3][slot4]) * 0.115) < 0.53 then
		setActive(slot0.top:Find("ScoreSlider/B/bl"), false)
		setActive(slot0.top:Find("ScoreSlider/A/al"), false)
		setActive(slot0.top:Find("ScoreSlider/S/sl"), false)
	elseif slot2 >= 0.53 then
		setActive(slot0.top:Find("ScoreSlider/B/bl"), true)

		if slot2 >= 0.72 then
			setActive(slot0.top:Find("ScoreSlider/A/al"), true)

			if slot2 >= 0.885 then
				if not slot0.nowS_flag then
					slot0.nowS_flag = true

					slot0:effect_play("S", true)
				end

				setActive(slot0.top:Find("ScoreSlider/S/sl"), true)
				setImageColor(slot0.top:Find("ScoreSlider/House"), Color(1, 1, 1, 0))
			end
		end
	end

	setText(slot0.game_content:Find("combo_n"), slot0.combo_link)
end

slot0.piecelistALLTtoF = function (slot0)
	for slot5 = 1, slot0.piecelist_lt[0], 1 do
		slot6 = slot0:list_pop(slot0.piecelist_lt)
		slot6.ob.localPosition = slot0.pieceinit_xyz.left

		setActive(slot6.ob, false)
		slot0:list_push(slot0.piecelist_lf, slot6.ob)
	end

	if slot0.piece_nowl.ob then
		slot0.piece_nowl.ob.localPosition = slot0.pieceinit_xyz.left

		setActive(slot0.piece_nowl.ob, false)
		slot0:list_push(slot0.piecelist_lf, slot0.piece_nowl.ob)

		slot0.piece_nowl.ob = false
	end

	for slot5 = 1, slot0.piecelist_rt[0], 1 do
		slot6 = slot0:list_pop(slot0.piecelist_rt)
		slot6.ob.localPosition = slot0.pieceinit_xyz.right

		setActive(slot6.ob, false)
		slot0:list_push(slot0.piecelist_rf, slot6.ob)
	end

	if slot0.piece_nowr.ob then
		slot0.piece_nowr.ob.localPosition = slot0.pieceinit_xyz.right

		setActive(slot0.piece_nowr.ob, false)
		slot0:list_push(slot0.piecelist_rf, slot0.piece_nowr.ob)

		slot0.piece_nowr.ob = false
	end
end

slot0.score_update = function (slot0, slot1)
	slot2 = slot0.game_content:Find("evaluate")

	for slot6 = 1, 3, 1 do
		setActive(slot2:GetChild(slot6 - 1), false)
	end

	setActive(slot2:GetChild(slot1), true)

	if slot1 == 0 then
		slot0.combo_link = 0
		slot0.score_number = slot0.score_number + slot0.score_miss
		slot0.miss_number = slot0.miss_number + 1

		setActive(slot0.game_content:Find("combo"), false)
		setActive(slot0.game_content:Find("combo_n"), false)
	else
		slot0.combo_link = slot0.combo_link + 1
		slot0.combo_number = (slot0.combo_link < slot0.combo_number and slot0.combo_number) or slot0.combo_link

		if slot0.combo_link > 1 then
			setActive(slot0.game_content:Find("combo"), true)
			setActive(slot0.game_content:Find("combo_n"), true)
			slot0.game_content:Find("combo"):GetComponent(typeof(Animation)):Play()
			slot0.game_content:Find("combo_n"):GetComponent(typeof(Animation)):Play()
		else
			setActive(slot0.game_content:Find("combo"), false)
			setActive(slot0.game_content:Find("combo_n"), false)
		end

		pg.CriMgr.GetInstance():PlaySE_V3("ui-maoudamashii")
	end

	slot3 = 0

	for slot7 = 1, #slot0.combo_interval, 1 do
		if slot0.combo_interval[slot7] < slot0.combo_link then
			slot3 = slot3 + 1
		else
			break
		end
	end

	if slot1 == 1 then
		slot0.score_number = slot0.score_number + slot0.score_good + slot3 * slot0.score_combo
		slot0.good_number = slot0.good_number + 1

		slot0:effect_play("good")
	elseif slot1 == 2 then
		slot0.score_number = slot0.score_number + slot0.score_perfect + slot3 * slot0.score_combo
		slot0.perfect_number = slot0.perfect_number + 1

		slot0:effect_play("perfect")
	end

	if slot0.gameNoteLeft:loopTime() or slot0.gameNoteRight:loopTime() then
		slot0:effect_play("perfect_loop02", true)
	else
		slot0:effect_play("perfect_loop02", false)
	end

	slot4 = slot0.game_content:Find("yinyue_comboeffect")

	if (slot0.game_dgree == 2 and slot0.combo_link > 50) or (slot0.game_dgree == 1 and slot0.combo_link > 20) then
		if not isActive(slot4) then
			SetActive(slot4, true)
			setActive(slot0.game_content:Find("MusicStar"), true)
		end
	else
		SetActive(slot4, false)
		setActive(slot0.game_content:Find("MusicStar"), false)
	end
end

slot0.count_five = function (slot0, slot1)
	slot0.countingfive_flag = true

	setActive(slot0.BG, true)
	slot0:setActionSDmodel("stand2")
	setText(slot0.BG:Find("num"), slot2)

	slot5 = findTF(slot0.BG, "ready/ready_triangle")

	setActive(slot4, false)
	setActive(slot3, true)

	slot0.count_timer = Timer.New(function ()
		if slot0.criInfo and slot0.criInfo:GetTime() > 0 then
			slot0:pauseBgm()
		end

		slot1 = slot1 - 1
		slot1 = slot0.BG:Find("num")

		setText(slot1, slot1)

		if slot1 == 0 then
			setActive(slot2, false)
			setActive(slot3, true)
			LeanTween.value(go(slot0.BG), 0, 2, 2):setOnUpdate(System.Action_float(function (slot0)
				slot1 = nil

				if slot0 <= 0.25 then
					slot0.localScale = Vector3(slot1, slot1, slot1)

					setImageAlpha(findTF(slot0, "img"), slot1)
					setLocalScale(slot0 * 4, Vector3(slot0 * 4, , ))
				elseif slot0 >= 1.8 then
					slot0.localScale = Vector3(slot1, slot1, slot1)

					setLocalScale(slot1, Vector3(slot1, (2 - slot0) * 4, ))
					setImageAlpha(findTF(slot0, "img"), (2 - slot0) * 4)
				end
			end)).setEase(slot0, LeanTweenType.linear):setOnComplete(System.Action(function ()
				slot0.localScale = Vector3(1, 1, 1, 1)

				setLocalScale(Vector3(1, 1, 1, 1), Vector3(1, 1, 1, 1))
				setImageAlpha(findTF(slot0, "img"), 1)
				setActive(setActive, false)
				slot2.count_timer:Stop()

				slot2.countingfive_flag = false

				setActive(slot2.BG, false)
				slot2:setActionSDmodel("idol")
				"img"()
			end))
		end
	end, 1, -1)

	slot0.count_timer.Start(slot6)
end

slot0.showSelevtView = function (slot0)
	if slot0.isFirstgame == 0 then
		slot0:Firstshow(slot0.firstview, function ()
			return
		end, 1)
	end

	slot1 = slot0.selectview.Find(slot1, "Main")
	slot3 = slot1:Find("DgreeList")
	slot5 = slot1:Find("namelist")
	slot6 = slot0.selectview:Find("top")
	slot10 = slot0.selectview:GetComponent("Animator")

	slot0.selectview:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot11, function (slot0)
		setActive(slot0.selectview, false)
	end)
	onButton(slot0, slot8, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_music_game.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot9, function ()
		if MusicGameView.loadMusicFlag == 0 then
			slot0:emit(slot1.ON_BACK)
		end
	end, SFX_PANEL)
	onButton(slot0, slot2, function ()
		if MusicGameView.loadMusicFlag == 0 then
			slot0:Play("selectExitAnim")
			slot0:clearSDModel()
			slot0:updateMusic(slot1.musicData.music_id)
			slot0:game_start()

			GetOrAddComponent(slot0.selectview, "CanvasGroup").blocksRaycasts = false
		else
			slot1.startBtnReady = true
		end
	end, SFX_UI_CONFIRM)
	onButton(slot0, slot3:Find("easy"), function ()
		slot0.game_dgree = 1

		setActive(1:Find("hard/frame"), false)
		setActive(1.Find("hard/frame"):Find("easy/frame"), true)
		setActive:updatSelectview()
	end, SFX_UI_CLICK)
	onButton(slot0, slot3:Find("hard"), function ()
		slot0.game_dgree = 2

		setActive(2:Find("easy/frame"), false)
		setActive(2.Find("easy/frame"):Find("hard/frame"), true)
		setActive:updatSelectview()
	end, SFX_UI_CLICK)
	onButton(slot0, slot7, function ()
		slot1 = slot0:Find("x" .. slot1.game_speed)

		setActive(slot1, false)

		slot1.game_speed = (slot1.game_speed + 1 > 4 and 1) or slot1.game_speed + 1

		PlayerPrefs.SetInt("musicgame_idol_speed", (slot1.game_speed + 1 > 4 and 1) or slot1.game_speed + 1.game_speed)
		setActive(slot1:Find("x" .. (slot1.game_speed + 1 > 4 and 1) or slot1.game_speed + 1.game_speed), true)
	end, SFX_UI_CLICK)

	slot0.song_btn = slot1:Find("MusicList").Find(slot4, "song")

	setActive(slot0.song_btn, false)

	slot0.song_btns = {}
	slot12 = slot0.gameMusicIndex

	for slot16 = 1, slot0.music_amount, 1 do
		slot0.song_btns[slot16] = cloneTplTo(slot0.song_btn, slot4, "music" .. slot16)

		setActive(slot0.song_btns[slot16], true)

		slot0.song_btns[slot16].localPosition = Vector3(slot0.song_btn.localPosition.x + ((slot16 - slot12 < slot0.music_amount_middle and math.abs(slot16 - slot12)) or slot16 - slot0.music_amount_middle * 2) * 1022, slot0.song_btn.localPosition.y, slot0.song_btn.localPosition.z)
		slot0.song_btns[slot16].localScale = Vector3(slot0.song_btn.localScale.x - math.abs((slot16 - slot12 < slot0.music_amount_middle and math.abs(slot16 - slot12)) or slot16 - slot0.music_amount_middle * 2) * 0.2, slot0.song_btn.localScale.y - math.abs((slot16 - slot12 < slot0.music_amount_middle and math.abs(slot16 - slot12)) or slot16 - slot0.music_amount_middle * 2) * 0.2, slot0.song_btn.localScale.z - math.abs((slot16 - slot12 < slot0.music_amount_middle and math.abs(slot16 - slot12)) or slot16 - slot0.music_amount_middle * 2) * 0.2)
		slot0.song_btns[slot16]:Find("song"):GetComponent(typeof(Image)).sprite = slot4:Find("img/" .. MusicGameConst.music_game_data[slot16].img):GetComponent(typeof(Image)).sprite
		slot0.song_btns[slot16]:Find("zhuanji3/zhuanji2_5"):GetComponent(typeof(Image)).sprite = slot4:Find("img/" .. MusicGameConst.music_game_data[slot16].img .. "_1"):GetComponent(typeof(Image)).sprite
		slot0.song_btns[slot16].Find("song").GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1 - math.abs((slot16 - slot12 < slot0.music_amount_middle and math.abs(slot16 - slot12)) or slot16 - slot0.music_amount_middle * 2) * 0.6)

		onButton(slot0, slot0.song_btns[slot16], function ()
			slot0:clickSongBtns(slot0, )
		end, SFX_UI_CLICK)

		if slot16 == slot12 then
			slot0.song_btns[slot16].GetComponent(slot22, typeof(Animator)):Play("plate_out")

			slot0.song_btns[slot16]:GetComponent(typeof(Button)).interactable = false
		end
	end

	slot0:clickSongBtns(slot5, 1)
end

slot0.updateMusic = function (slot0, slot1)
	slot0.musicData = MusicGameConst.music_game_data[slot1]
	slot0.game_music = slot0.musicData.music_id

	if slot0.musicData.ships then
		slot0.musicShips = slot0.musicData.ships
		slot0.settlementPainting = slot0.musicData.settlement_painting
		slot0.musicLight = slot0.musicData.light
		slot0.musicBg = slot0.musicData.bg
	else
		slot2 = MusicGameConst.getRandomBand()
		slot0.musicShips = slot2.ships
		slot0.settlementPainting = slot2.settlement_painting
		slot0.musicLight = slot2.light
		slot0.musicBg = slot2.bg
	end

	slot0.gameMusicIndex = slot0
	slot0.SDname = slot0.musicShips
end

slot0.clickSongBtns = function (slot0, slot1, slot2)
	setActive(slot1:Find("song" .. slot0.musicData.img), false)
	slot0:MyGetRuntimeData()
	slot0:clearSDModel()
	slot0:updateMusic(slot2)
	slot0:loadAndPlayMusic()
	slot0:updatSelectview()
	slot0:changeLocalpos(slot2)
	setActive(slot1:Find("song" .. slot0.musicData.img), true)
	slot0:updateMusicPiece()
end

slot0.changeLocalpos = function (slot0, slot1)
	slot3 = slot0.music_amount_middle - slot1
	slot4 = 0.5
	slot5 = {}

	for slot9 = 1, slot0.music_amount, 1 do
		slot5[slot9] = slot0.song_btns[slot9].localPosition
	end

	slot6 = {}

	for slot10 = 1, slot0.music_amount, 1 do
		slot6[slot10] = slot0.song_btns[slot10].localScale
	end

	slot0.changeLocalpos_timer = Timer.New(function ()
		slot0 = slot0 - slot1.time_interval
		slot1.time_interval.changeLocalposTimerflag = true

		for slot3 = 1, true.music_amount, 1 do
			slot4 = slot3 + slot2

			if slot1.music_amount < slot3 + slot2 then
				slot4 = (slot3 + slot2) - slot1.music_amount
			end

			if slot3 + slot2 < 1 then
				slot4 = slot3 + slot2 + slot1.music_amount
			end

			if slot0 <= 0 then
				if slot4 == slot3 then
					slot1.song_btns[slot3]:GetComponent(typeof(Animator)):Play("plate_out")
				else
					slot1.song_btns[slot3]:GetComponent(typeof(Animator)):Play("plate_static")

					slot1.song_btns[slot3]:GetComponent(typeof(Button)).interactable = true
				end
			else
				slot1.song_btns[slot3]:GetComponent(typeof(Animator)):Play("plate_static")

				slot1.song_btns[slot3]:GetComponent(typeof(Button)).interactable = false
			end

			slot6 = math.abs(slot4 - slot3)
			slot8 = (slot4 - slot3 > 0 and 1) or -1
			slot1.song_btns[slot3].localPosition = Vector3(slot1.song_btn.localPosition.x, slot5.y, slot5.z)
			slot1.song_btns[slot3].localScale = Vector3(slot1.song_btn.localPosition.x, , (1 - slot6 * 0.2) * (1 - slot0 * 2) + slot5[slot3].x * slot0 * 2)
			slot7 = (1 - slot6 * 0.6) * (1 - slot0 * 2) + slot1.song_btns[slot3]:Find("song"):GetComponent(typeof(Image)).color.a * slot0 * 2
			slot1.song_btns[slot3].Find("song").GetComponent(typeof(Image)).color = Color.New(1, 1, 1, 1 - slot6 * 0.6)
		end

		if slot0 <= 0 then
			slot1.changeLocalposTimerflag = false

			slot1.changeLocalpos_timer:Stop()
		end
	end, slot0.time_interval, -1)

	slot0.changeLocalpos_timer.Start(slot7)
end

slot0.addRingDragListenter = function (slot0)
	slot1 = GetOrAddComponent(slot0.selectview, "EventTriggerListener")
	slot2 = nil
	slot3 = 0
	slot4 = nil

	slot1:AddBeginDragFunc(function ()
		slot0 = 0
		slot1 = nil
	end)
	slot1.AddDragFunc(slot1, function (slot0, slot1)
		if not slot0.inPaintingView then
			slot2 = slot1.position

			if not slot1 then
				slot1 = slot2
			end

			slot2 = slot2.x - slot1.x
		end
	end)
	slot1.AddDragEndFunc(slot1, function (slot0, slot1)
		if not slot0.inPaintingView and not slot0.changeLocalposTimerflag then
			if slot1 < -50 then
				if slot0.game_music < slot0.music_amount then
					triggerButton(slot0.song_btns[slot0.game_music + 1])
				else
					triggerButton(slot0.song_btns[1])
				end
			elseif slot1 > 50 then
				if slot0.game_music > 1 then
					triggerButton(slot0.song_btns[slot0.game_music - 1])
				else
					triggerButton(slot0.song_btns[slot0.music_amount])
				end
			end
		end
	end)
end

slot0.Firstshow = function (slot0, slot1, slot2, slot3)
	slot0.count = 0

	setActive(slot1, true)
	LoadSpriteAsync("ui/minigameui/musicgameother/help1", function (slot0)
		GetComponent(findTF(slot0.firstview, "num/img1"), typeof(Image)).sprite = slot0
	end)
	LoadSpriteAsync("ui/minigameui/musicgameother/help2", function (slot0)
		GetComponent(findTF(slot0.firstview, "num/img2"), typeof(Image)).sprite = slot0
	end)

	for slot7 = 1, 2, 1 do
		setActive(findTF(slot1, "num/img" .. slot7), (slot7 == slot3 and true) or false)
	end

	if slot0.firstview_timer then
		if slot0.firstview_timer.running then
			slot0.firstview_timer:Stop()
		end

		slot0.firstview_timer = nil
	end

	slot0.firstview_timerRunflag = true
	slot0.firstview_timer = Timer.New(function ()
		slot0.count = slot0.count + 1

		if slot0.count > 3 then
			onButton(onButton, slot0.firstview, function ()
				if slot0 then
					slot0()
				end

				slot1.firstview_timer:Stop()
				setActive(slot2, false)

				slot2.firstview_timerRunflag = false

				removeOnButton(false.firstview)
			end)
		end
	end, 1, -1)

	slot0.firstview_timer.Start(slot4)
end

slot0.updatSelectview = function (slot0)
	if not slot0.song_btns or #slot0.song_btns <= 0 or not slot0.selectview then
		return
	end

	setActive(slot0.selectview:Find("top/Speedlist/x" .. slot0.game_speed), true)

	for slot4 = 1, slot0.music_amount, 1 do
		setActive(slot0.song_btns[MusicGameConst.music_game_data[slot4].music_id]:Find("song/best"), false)
		slot0:setSelectview_pj("e", MusicGameConst.music_game_data[slot4].music_id)
	end

	slot3 = slot0.bestScorelist[slot0.game_music + (slot0.game_dgree - 1) * slot0.music_amount]

	if slot0.song_btns[slot0.game_music] and slot3 > 0 then
		setActive(slot0.song_btns[slot2]:Find("song/best"), true)
		setText(slot4, slot3)
		slot0:setSelectview_pj("e", slot2)

		if slot3 < slot0.score_blist[slot2][slot1] then
			slot0:setSelectview_pj("c", slot2)
		elseif slot0.score_blist[slot2][slot1] <= slot3 and slot3 < slot0.score_alist[slot2][slot1] then
			slot0:setSelectview_pj("b", slot2)
		elseif slot0.score_alist[slot2][slot1] <= slot3 and slot3 < slot0.score_slist[slot2][slot1] then
			slot0:setSelectview_pj("a", slot2)
		else
			slot0:setSelectview_pj("s", slot2)
		end
	end
end

slot0.setSelectview_pj = function (slot0, slot1, slot2)
	if slot1 == "e" then
		setActive(slot0.song_btns[slot2]:Find("song/c"), false)
		setActive(slot0.song_btns[slot2]:Find("song/b"), false)
		setActive(slot0.song_btns[slot2]:Find("song/a"), false)
		setActive(slot0.song_btns[slot2]:Find("song/s"), false)
	elseif slot1 == "c" then
		setActive(slot0.song_btns[slot2]:Find("song/c"), true)
	elseif slot1 == "b" then
		setActive(slot0.song_btns[slot2]:Find("song/b"), true)
	elseif slot1 == "a" then
		setActive(slot0.song_btns[slot2]:Find("song/a"), true)
	elseif slot1 == "s" then
		setActive(slot0.song_btns[slot2]:Find("song/s"), true)
	end
end

slot0.locadScoreView = function (slot0)
	slot0:effect_play("nothing")

	slot0.game_playingflag = false

	setActive(slot0.scoreview, true)

	slot0.scoreview_flag = true

	setImageColor(slot1, Color(0, 0, 0))
	LoadSpriteAsync("ui/minigameui/musicgameother/scoreBg" .. slot0.musicBg, function (slot0)
		if slot0 then
			GetComponent(slot0, typeof(Image)).sprite = slot0

			setImageColor(slot0, Color(1, 1, 1))
			setActive(slot0, true)
		end
	end)
	setActive(slot0.game_content.Find(slot3, "combo"), false)
	setActive(slot0.game_content:Find("MusicStar"), false)
	setActive(slot0.game_content:Find("combo_n"), false)
	setActive(slot0.game_content, false)
	setActive(slot0.top, false)
	setActive(slot0._tf:Find("Spinelist"), false)
	setActive(slot0._tf:Find("lightList"), false)
	setActive(slot0._tf:Find("shadowlist"), false)

	for slot5 = 1, slot0, 1 do
		setActive(slot0.scoreview:Find("maskBg/bg" .. slot5), slot5 == slot0.musicBg)
	end

	slot2 = slot0.game_dgree
	slot3 = slot0.game_music

	if slot0.painting then
		retPaintingPrefab(slot0.scoreview:Find("paint"), slot0.painting)
	end

	slot0.painting = slot0.settlementPainting[math.random(1, #slot0.settlementPainting)]

	setPaintingPrefabAsync(slot0.scoreview:Find("paint"), slot0.painting, "mainNormal")
	setActive(slot0.scoreview:Find("img_list/square/easy"), slot2 == 1)
	setActive(slot0.scoreview:Find("img_list/square/hard"), slot2 == 2)
	setActive(slot0.scoreview:Find("scorelist/fullCombo"), slot0.miss_number == 0)
	setActive(slot0.scoreview:Find("img_list/perfect/noMiss"), slot0.miss_number == 0 and slot0.good_number == 0)

	function slot4(slot0, slot1, slot2)
		LeanTween.value(go(slot0.scoreview), 0, slot1, 0.6):setOnUpdate(System.Action_float(function (slot0)
			setText(slot0, math.round(slot0))
		end)).setOnComplete(slot3, System.Action(function ()
			slot0()
		end))
	end

	seriesAsync({
		function (slot0)
			slot0(slot1.scoreview:Find("scorelist/perfect"), slot1.perfect_number, slot0)
		end,
		function (slot0)
			slot0(slot1.scoreview:Find("scorelist/good"), slot1.good_number, slot0)
		end,
		function (slot0)
			slot0(slot1.scoreview:Find("scorelist/miss"), slot1.miss_number, slot0)
		end,
		function (slot0)
			slot0(slot1.scoreview:Find("scorelist/combo"), slot1.combo_number, slot0)
		end,
		function (slot0)
			if not slot0.bestScorelist[slot1 + (slot2 - 1) * slot0.music_amount] or slot1 == 0 then
				slot1 = slot0.score_number
			end

			if slot0.bestScorelist[slot1 + (slot2 - 1) * slot0.music_amount] < slot0.score_number then
				setActive(slot0.scoreview:Find("img_list/square/newScore"), true)

				slot0.bestScorelist[slot1 + (slot2 - 1) * slot0.music_amount] = slot0.score_number
			else
				setActive(slot0.scoreview:Find("img_list/square/newScore"), false)
			end

			slot3(slot0.scoreview:Find("img_list/square/bestscore"), slot1, slot0)
			slot0.scoreview.Find("img_list/square/bestscore")(slot0.scoreview:Find("img_list/square/score"), slot0.score_number, function ()
				return
			end)
			slot0.MyStoreDataToServer(slot2)
			slot0:MyGetRuntimeData()
		end,
		function (slot0)
			slot1 = (slot0.score_number >= slot0.score_blist[slot1][slot0.score_number] or function ()
				slot0:setScoceview_pj("c")
			end) and (slot0.score_blist[slot1][slot0.score_number] > slot0.score_number or slot0.score_number >= slot0.score_alist[slot1][slot0.score_number] or function ()
				slot0:setScoceview_pj("b")
				slot0.setScoceview_pj:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
			end) and (slot0.score_alist[slot1][slot0.score_number] > slot0.score_number or slot0.score_number >= slot0.score_slist[slot1][slot0.score_number] or function ()
				slot0:setScoceview_pj("a")
				slot0.setScoceview_pj:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
			end) and function ()
				slot0:setScoceview_pj("s")
				slot0.setScoceview_pj:emit(BaseMiniGameMediator.MINI_GAME_SUCCESS, 0)
			end
			slot3 = pg.NewStoryMgr.GetInstance()
			slot5 = (slot0:GetMGData():getConfig("simple_config_data").story[slot0.GetMGHubData(slot2).usedtime + 1] and slot4[slot2.usedtime + 1][1]) or nil

			if slot2.count > 0 and slot5 and not slot3:IsPlayed(slot5) and slot0.score_blist[slot1][slot2] <= slot0.score_number then
				slot3:Play(slot5, slot1)
			else
				slot1()
			end

			slot0()
		end
	}, function ()
		return
	end)

	slot5 = slot0.scoreview.Find(slot5, "img_list/square/name"):GetComponent(typeof(Image))
	slot5.sprite = slot0.selectview:Find("Main/namelist/song" .. slot0.musicData.img):GetComponent(typeof(Image)).sprite

	slot5:SetNativeSize()

	slot0.scoreview:Find("img_list/square/song"):GetComponent(typeof(Image)).sprite = slot0.selectview:Find("Main/MusicList/img/" .. slot0.musicData.img):GetComponent(typeof(Image)).sprite

	onButton(slot0, slot0.scoreview:Find("btnlist/share"), function ()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSummary)
	end, SFX_PANEL)
	onButton(slot0, slot0.scoreview:Find("btnlist/restart"), function ()
		setActive(slot0.scoreview, false)

		setActive.scoreview_flag = false

		setActive:stopTimer()
		setActive.stopTimer:piecelistALLTtoF()
		setActive.stopTimer.piecelistALLTtoF:rec_scorce()
		setActive.stopTimer.piecelistALLTtoF.rec_scorce:game_start()
		setActive.stopTimer.piecelistALLTtoF.rec_scorce.game_start:setScoceview_pj("e")

		if setActive.stopTimer.piecelistALLTtoF.rec_scorce.game_start.setScoceview_pj.painting then
			retPaintingPrefab(slot0.scoreview:Find("paint"), slot0.painting)

			retPaintingPrefab.painting = nil
		end
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.scoreview:Find("btnlist/reselect"), function ()
		slot0:dynamicBgHandler(slot0.bgGo)
		setActive(slot0.scoreview, false)

		setActive.scoreview_flag = false

		setActive:stopTimer()
		setActive.stopTimer:piecelistALLTtoF()
		setActive(slot0.selectview, true)

		GetOrAddComponent(slot0.selectview, "CanvasGroup").blocksRaycasts = true

		GetOrAddComponent(slot0.selectview, "CanvasGroup"):updatSelectview()
		GetOrAddComponent(slot0.selectview, "CanvasGroup").updatSelectview.song_btns[slot0.game_music]:GetComponent(typeof(Animator)):Play("plate_out")
		GetOrAddComponent(slot0.selectview, "CanvasGroup").updatSelectview.song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play:loadAndPlayMusic()
		GetOrAddComponent(slot0.selectview, "CanvasGroup").updatSelectview.song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play.loadAndPlayMusic:rec_scorce()
		GetOrAddComponent(slot0.selectview, "CanvasGroup").updatSelectview.song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play.loadAndPlayMusic.rec_scorce:setScoceview_pj("e")

		if GetOrAddComponent(slot0.selectview, "CanvasGroup").updatSelectview.song_btns[slot0.game_music].GetComponent(typeof(Animator)).Play.loadAndPlayMusic.rec_scorce.setScoceview_pj.painting then
			retPaintingPrefab(slot0.scoreview:Find("paint"), slot0.painting)

			retPaintingPrefab.painting = nil
		end
	end, SFX_UI_CLICK)
end

slot0.setScoceview_pj = function (slot0, slot1)
	if slot1 == "e" then
		setActive(slot0.scoreview:Find("img_list/square/c"), false)
		setActive(slot0.scoreview:Find("img_list/square/b"), false)
		setActive(slot0.scoreview:Find("img_list/square/a"), false)
		setActive(slot0.scoreview:Find("img_list/square/s"), false)
	elseif slot1 == "c" then
		setActive(slot0.scoreview:Find("img_list/square/c"), true)
	elseif slot1 == "b" then
		setActive(slot0.scoreview:Find("img_list/square/b"), true)
	elseif slot1 == "a" then
		setActive(slot0.scoreview:Find("img_list/square/a"), true)
	elseif slot1 == "s" then
		setActive(slot0.scoreview:Find("img_list/square/s"), true)
	end
end

slot0.Scoceview_ani = function (slot0)
	slot1 = 0

	setActive(slot0.scoreview:Find("btnlist/reselect"), false)
	setActive(slot0.scoreview:Find("btnlist/restart"), false)
	setActive(slot0.scoreview:Find("btnlist/share"), false)

	function slot2()
		if slot0 + slot1.time_interval >= 0.99 then
			setActive(slot1.scoreview:Find("btnlist/reselect"), true)
			setActive(slot1.scoreview.Find("btnlist/reselect").scoreview:Find("btnlist/restart"), true)
			setActive(slot1.scoreview.Find("btnlist/reselect").scoreview.Find("btnlist/restart").scoreview:Find("btnlist/share"), true)

			slot1 = slot1.scoreview.Find("btnlist/reselect").scoreview.Find("btnlist/restart").scoreview.Find("btnlist/share").scoreview:Find("scorelist/perfect")

			setText(slot1, slot1.perfect_number)

			slot1 = slot1.scoreview:Find("scorelist/good")

			setText(slot1, slot1.good_number)

			slot1 = slot1.scoreview:Find("scorelist/miss")

			setText(slot1, slot1.miss_number)

			slot1 = slot1.scoreview:Find("scorelist/combo")

			setText(slot1, slot1.combo_number)
			setText(slot1.scoreview:Find("img_list/square/bestscore"), slot1.score_number)
		else
			slot1 = slot1.scoreview:Find("scorelist/perfect")

			setText(slot1, math.floor(slot1.perfect_number * setText))

			slot1 = slot1.scoreview:Find("scorelist/good")

			setText(slot1, math.floor(slot1.good_number * setText))

			slot1 = slot1.scoreview:Find("scorelist/miss")

			setText(slot1, math.floor(slot1.miss_number * setText))

			slot1 = slot1.scoreview:Find("scorelist/combo")

			setText(slot1, math.floor(slot1.combo_number * setText))
			setText(slot1.scoreview:Find("img_list/square/bestscore"), math.floor(slot1.score_number * setText))
		end

		if slot0 >= 1.03 then
			slot1.Scoceview_timer:Stop()
		end
	end

	slot0.Scoceview_timer = Timer.New(slot2, slot0.time_interval, -1)

	slot0.Scoceview_timer:Start()
end

slot0.gameStart = function (slot0)
	if not slot0.timer then
		slot0.timer = Timer.New(function ()
			slot0:gameStepNew()
		end, slot0.time_interval, -1)
	end

	slot0.aheadtime_count = 0
	slot1 = 2
	slot0.ahead_timerPauseFlag = false

	CriWareMgr.Inst.UnloadCueSheet(slot3, "bgm-song" .. slot0.musicData.bgm)

	slot0.ahead_timer = Timer.New(slot2, slot0.time_interval, -1)

	slot0:count_five(function ()
		slot0.ahead_timer:Start()
	end)
end

slot0.gameStepNew = function (slot0)
	slot1 = slot0.game_dgree
	slot0.gameStepTime = slot0:getStampTime()
	slot0.downingright_lastflag = slot0.downingright_flag
	slot0.downingleft_lastflag = slot0.downingleft_flag

	if Application.isEditor then
		if slot1 == 2 then
			slot0.downingright_flag = Input.GetKey(KeyCode.J)
			slot0.downingleft_flag = Input.GetKey(KeyCode.F)
		elseif slot1 == 1 then
			if Input.GetKey(KeyCode.J) or Input.GetKey(KeyCode.F) then
				slot0.downingright_flag = true
				slot0.downingleft_flag = true
			else
				slot0.downingright_flag = false
				slot0.downingleft_flag = false
			end
		end
	elseif slot1 == 2 then
		slot0.downingright_flag = slot0.mousedowningright_flag
		slot0.downingleft_flag = slot0.mousedowningleft_flag
	elseif slot1 == 1 then
		if slot0.mousedowningright_flag or slot0.mousedowningleft_flag then
			slot0.downingright_flag = true
			slot0.downingleft_flag = true
		else
			slot0.downingright_flag = false
			slot0.downingleft_flag = false
		end
	end

	if slot1 == 2 then
		if not slot0.downingleft_lastflag and slot0.downingleft_flag then
			slot0.gameNoteLeft:onKeyDown()

			slot0.leftDownStepTime = slot0.gameStepTime

			if slot0.rightDownStepTime and math.abs(slot0.leftDownStepTime - slot0.rightDownStepTime) < 100 then
				slot0.gameNoteLeft:bothDown()
				slot0.gameNoteRight:bothDown()
			end
		elseif slot0.downingleft_lastflag and not slot0.downingleft_flag then
			slot0.leftUpStepTime = slot0.gameStepTime

			slot0.gameNoteLeft:onKeyUp()

			if slot0.rightUpStepTime and math.abs(slot0.leftUpStepTime - slot0.rightUpStepTime) < 100 then
				slot0.gameNoteLeft:bothUp()
				slot0.gameNoteRight:bothUp()
			end
		end

		if not slot0.downingright_lastflag and slot0.downingright_flag then
			slot0.gameNoteRight:onKeyDown()

			slot0.rightDownStepTime = slot0.gameStepTime

			if slot0.leftDownStepTime and math.abs(slot0.leftDownStepTime - slot0.rightDownStepTime) < 200 then
				slot0.gameNoteLeft:bothDown()
				slot0.gameNoteRight:bothDown()
			end
		elseif slot0.downingright_lastflag and not slot0.downingright_flag then
			slot0.rightUpStepTime = slot0.gameStepTime

			slot0.gameNoteRight:onKeyUp()

			if slot0.leftUpStepTime and math.abs(slot0.leftUpStepTime - slot0.rightUpStepTime) < 200 then
				slot0.gameNoteLeft:bothUp()
				slot0.gameNoteRight:bothUp()
			end
		end
	elseif not slot0.downingright_lastflag and slot0.downingright_flag then
		slot0.gameNoteLeft:onKeyDown()
		slot0.gameNoteRight:onKeyDown()
	elseif slot0.downingleft_lastflag and not slot0.downingleft_flag then
		slot0.gameNoteLeft:onKeyUp()
		slot0.gameNoteRight:onKeyUp()
	end

	slot0.musicgame_lasttime = slot0.musicgame_nowtime or 0

	if slot0.criInfo then
		slot0.musicgame_nowtime = slot0:getStampTime() / 1000
	else
		slot0.musicgame_nowtime = 0
	end

	if slot0.song_Tlength and not slot0.scoreview_flag and long2int(slot0.song_Tlength) / 1000 - slot0.musicgame_nowtime <= 0.01666 then
		print("歌曲播放结束")
		slot0:pauseBgm()

		slot0.game_playingflag = false

		function slot2()
			slot0:locadScoreView()
		end

		if slot0.perfect_number > 0 and slot0.good_number == 0 and slot0.miss_number == 0 then
			setActive(slot0.fullComboEffect, true)

			if not slot0.gotspecialcombo_flag then
				slot0.score_number = slot0.score_number + slot0.specialscore_number
				slot0.gotspecialcombo_flag = true
			end

			LeanTween.delayedCall(go(slot0.fullComboEffect), 2, System.Action(function ()
				slot0()
			end))
		elseif (slot0.good_number > 0 or slot0.perfect_number > 0) and slot0.miss_number <= 0 then
			setActive(slot0.fullComboEffect, true)

			if not slot0.gotspecialcombo_flag then
				slot0.score_number = slot0.score_number + slot0.specialscore_number
				slot0.gotspecialcombo_flag = true
			end

			LeanTween.delayedCall(go(slot0.fullComboEffect), 2, System.Action(function ()
				slot0()
			end))
		else
			setActive(slot0.liveClearEffect, true)
			LeanTween.delayedCall(go(slot0.liveClearEffect), 2, System.Action(function ()
				slot0()
			end))
		end

		return
	end

	slot0.gameNoteLeft.step(slot2, slot0.gameStepTime)
	slot0.gameNoteRight:step(slot0.gameStepTime)
	slot0:scoresliderAcombo_update()

	if slot0.drumpFlag and not slot0.gameNoteLeft:loopTime() and not slot0.gameNoteRight:loopTime() then
		slot0.drumpFlag = false
		slot0.drupTime = Time.realtimeSinceStartup

		slot0:setActionSDmodel("jump")
		LeanTween.delayedCall(go(slot0.game_content), 1, System.Action(function ()
			slot0:setActionSDmodel("idol")
		end))
	end
end

slot0.onStateCallback = function (slot0, slot1)
	slot0:score_update(slot1)
end

slot0.onLongTimeCallback = function (slot0, slot1)
	if slot0.drupTime and Time.realtimeSinceStartup - slot0.drupTime < 2 then
		return
	end

	if slot1 > 0.5 then
		slot0.drumpFlag = true
	end
end

slot0.gameStep = function (slot0)
	slot0.downingright_lastflag = slot0.downingright_flag
	slot0.downingleft_lastflag = slot0.downingleft_flag
	slot1 = slot0.game_dgree

	if Application.isEditor then
		if slot1 == 2 then
			slot0.downingright_flag = Input.GetKey(KeyCode.J)
			slot0.downingleft_flag = Input.GetKey(KeyCode.F)
		elseif slot1 == 1 then
			if Input.GetKey(KeyCode.J) or Input.GetKey(KeyCode.F) then
				slot0.downingright_flag = true
				slot0.downingleft_flag = true
			else
				slot0.downingright_flag = false
				slot0.downingleft_flag = false
			end
		end
	elseif slot1 == 2 then
		slot0.downingright_flag = slot0.mousedowningright_flag
		slot0.downingleft_flag = slot0.mousedowningleft_flag
	elseif slot1 == 1 then
		if slot0.mousedowningright_flag or slot0.mousedowningleft_flag then
			slot0.downingright_flag = true
			slot0.downingleft_flag = true
		else
			slot0.downingright_flag = false
			slot0.downingleft_flag = false
		end
	end

	slot0:SDmodeljump_btnup()

	slot3 = slot0.pieceinit_xyz.right.x / (slot0.piecelist_speedmin + (slot0.piecelist_speedmax - slot0.piecelist_speedmin) * slot0.game_speed * 5)
	slot4 = -slot0.pieceinit_xyz.left.x / (slot0.piecelist_speedmin + (slot0.piecelist_speedmax - slot0.piecelist_speedmin) * slot0.game_speed * 5)
	slot0.musicgame_lasttime = slot0.musicgame_nowtime or 0

	if slot0.criInfo then
		slot0.musicgame_nowtime = slot0:getStampTime() / 1000
	else
		slot0.musicgame_nowtime = 0
	end

	if slot0.song_Tlength and not slot0.scoreview_flag and long2int(slot0.song_Tlength) / 1000 - slot0.musicgame_nowtime <= 0.01666 then
		slot0:pauseBgm()

		slot0.game_playingflag = false

		if slot0.perfect_number > 0 and slot0.good_number == 0 and slot0.miss_number == 0 then
			setActive(slot0.game_content:Find("yinyue20_Fullcombo"), true)

			if not slot0.gotspecialcombo_flag then
				slot0.score_number = slot0.score_number + slot0.specialscore_number
				slot0.gotspecialcombo_flag = true
			end

			slot0.locadScoreView(slot0)
			slot0.game_content:Find("yinyue20_Fullcombo"):GetComponent(typeof(ParticleSystemEvent)):SetEndEvent(function ()
				return
			end)
		elseif (slot0.good_number > 0 or slot0.perfect_number > 0) and slot0.miss_number <= 0 then
			setActive(slot0.game_content:Find("yinyue20_Fullcombo"), true)

			if not slot0.gotspecialcombo_flag then
				slot0.score_number = slot0.score_number + slot0.specialscore_number
				slot0.gotspecialcombo_flag = true
			end

			slot0.game_content.Find(slot6, "yinyue20_Fullcombo"):GetComponent(typeof(ParticleSystemEvent)):SetEndEvent(function ()
				slot0:locadScoreView()
			end)
		else
			slot0:locadScoreView()
		end

		return
	end

	if slot0.nowmusic_l == nil and slot0.musictable_l[0] ~= 0 then
		slot0.nowmusic_l = slot0:list_pop(slot0.musictable_l)
	end

	if slot0.nowmusic_r == nil and slot0.musictable_r[0] ~= 0 then
		slot0.nowmusic_r = slot0:list_pop(slot0.musictable_r)
	end

	if slot0.musictable_l[0] == 0 and slot0.musictable_r[0] == 0 then
		setActive(slot0.top:Find("pause_above"), true)
	else
		setActive(slot0.top:Find("pause_above"), false)
		setActive(slot0.game_content:Find("yinyue20_Fullcombo"), false)
	end

	slot0.nowmusic_l = slot5("left", slot0.nowmusic_l, slot4, slot0.piecelist_lf, slot0.piecelist_lt)
	slot0.nowmusic_r = slot5("right", slot0.nowmusic_r, slot3, slot0.piecelist_rf, slot0.piecelist_rt)

	slot6("left", slot4, slot0.piecelist_lt, slot0.piecelist_lf)
	slot6("right", slot3, slot0.piecelist_rt, slot0.piecelist_rf)

	if slot0.piece_nowr_downflag or (slot0.piece_nowl_downflag and slot0.game_playingflag) then
		slot0:effect_play("perfect_loop02", true)
	else
		slot0:effect_play("perfect_loop02", false)
	end

	slot0:scoresliderAcombo_update()
end

return slot0

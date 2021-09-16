slot0 = class("SettingsScene", import("..base.BaseUI"))
slot0.CLD_RED = Color.New(0.6, 0.05, 0.05, 0.5)
slot0.DEFAULT_GREY = Color.New(0.5, 0.5, 0.5, 0.5)
slot0.EnterToggle = {
	options = "options",
	res = "res",
	sound = "sound",
	interface = "interface"
}

slot0.getUIName = function (slot0)
	return "SettingsUI"
end

slot0.init = function (slot0)
	slot0.eventTriggers = {}
	slot0.top = slot0:findTF("blur_panel/adapt/top")
	slot0.backButton = slot0:findTF("blur_panel/adapt/top/back_btn")
	slot0.leftPanel = slot0:findTF("blur_panel/adapt/left_length")
	slot0.logoutButton = slot0:findTF("logout", slot0.leftPanel)
	slot0.bbsButton = slot0:findTF("bbs", slot0.leftPanel)
	slot0.soundToggle = slot0:findTF("resources", slot0.leftPanel)
	slot0.optionsToggle = slot0:findTF("options", slot0.leftPanel)
	slot0.otherToggle = slot0:findTF("other", slot0.leftPanel)
	slot0.interfaceToggle = slot0:findTF("battle_ui", slot0.leftPanel)
	slot0.resToggle = slot0:findTF("resources", slot0.leftPanel)
	slot0.helpUS = slot0:findTF("help_us", slot0.leftPanel)

	setActive(slot0.helpUS, PLATFORM_CODE == PLATFORM_US)

	slot0.repairMask = slot0:findTF("mask_repair")
	slot0.msgBox = SettingsMsgBosPage.New(slot0._tf, slot0.event)

	slot0:initSoundPanel(slot0:findTF("main/resources"))
	slot0:initOptionsPanel(slot0:findTF("main/options"))
	slot0:initInterfacePreference(slot0:findTF("main/battle_ui"))
	slot0:initOtherPanel(slot0:findTF("main/other"))
	slot0:initResDownloadPanel(slot0:findTF("main/resources"))
end

slot0.initResDownloadPanel = function (slot0, slot1)
	setActive(slot1, false)

	slot0.resRepairGroup = {}
	slot3 = slot0:findTF("main/resources/mask/main_panel").Find(slot2, "repair")
	slot0.resRepairGroup.Button = slot3
	slot0.resRepairGroup.Progress = slot3:Find("progress")
	slot0.resRepairGroup.ProgressHandle = slot3:Find("progress/handle")
	slot0.resRepairGroup.Info1 = slot3:Find("status")
	slot0.resRepairGroup.Info2 = slot3:Find("version")
	slot0.resRepairGroup.LabelNew = slot3:Find("version/new")
	slot0.resRepairGroup.Dot = slot3:Find("new")
	slot0.resRepairGroup.Loading = slot3:Find("loading")

	setText(slot3.Find(slot3, "title"), i18n("repair_setting_label"))
	slot4()
	onButton(slot0, slot0.resRepairGroup.Button, function ()
		showRepairMsgbox()
	end, SFX_PANEL)

	slot0.live2DDownloadBtn = slot0.findTF(slot0, "main/resources/mask/main_panel/live2d")
	slot0.live2DDownloadProgress = slot0:findTF("main/resources/mask/main_panel/live2d/progress")
	slot0.live2DDownloadProgressHandle = slot0:findTF("main/resources/mask/main_panel/live2d/progress/handle")
	slot0.live2DDownloadInfo1 = slot0:findTF("main/resources/mask/main_panel/live2d/status")
	slot0.live2DDownloadInfo2 = slot0:findTF("main/resources/mask/main_panel/live2d/version")
	slot0.live2DDownloadLabelNew = slot0:findTF("main/resources/mask/main_panel/live2d/version/new")
	slot0.live2DDownloadDot = slot0:findTF("main/resources/mask/main_panel/live2d/new")
	slot0.live2DDownloadLoading = slot0:findTF("main/resources/mask/main_panel/live2d/loading")

	setSlider(slot0.live2DDownloadProgress, 0, 1, 0)
	setActive(slot0.live2DDownloadDot, false)
	setActive(slot0.live2DDownloadLoading, false)

	slot0.live2DDownloadTimer = Timer.New(function ()
		slot0:updateLive2DDownloadState()
	end, 0.5, -1)

	slot0.live2DDownloadTimer.Start(slot6)
	slot0:updateLive2DDownloadState()

	if BundleWizard.Inst:GetGroupMgr("L2D").state == DownloadState.None then
		slot5:CheckD()
	end

	onButton(slot0, slot0.live2DDownloadBtn, function ()
		if slot0.state == DownloadState.CheckFailure then
			slot0:CheckD()
		elseif slot0 == DownloadState.CheckToUpdate or slot0 == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD("L2D", true)
		end
	end, SFX_PANEL)

	slot0.soundDownloadBtn = slot0.findTF(slot0, "main/resources/mask/main_panel/cv")
	slot0.soundDownloadProgress = slot0:findTF("main/resources/mask/main_panel/cv/progress")
	slot0.soundDownloadProgressHandle = slot0:findTF("main/resources/mask/main_panel/cv/progress/handle")
	slot0.soundDownloadInfo1 = slot0:findTF("main/resources/mask/main_panel/cv/status")
	slot0.soundDownloadInfo2 = slot0:findTF("main/resources/mask/main_panel/cv/version")
	slot0.soundDownloadLabelNew = slot0:findTF("main/resources/mask/main_panel/cv/version/new")
	slot0.soundDownloadDot = slot0:findTF("main/resources/mask/main_panel/cv/new")
	slot0.soundDownloadLoading = slot0:findTF("main/resources/mask/main_panel/cv/loading")

	setSlider(slot0.soundDownloadProgress, 0, 1, 0)
	setActive(slot0.soundDownloadDot, false)
	setActive(slot0.soundDownloadLoading, false)
	BundleWizard.Inst:GetGroupMgr("CV").CheckD(slot7)

	slot0.soundDownloadTimer = Timer.New(function ()
		slot0:updateSoundDownloadState()
	end, 0.5, -1)

	slot0.soundDownloadTimer.Start(slot8)
	slot0:updateSoundDownloadState()
	onButton(slot0, slot0.soundDownloadBtn, function ()
		if slot0.state == DownloadState.CheckFailure then
			slot0:CheckD()
		elseif slot0.state == DownloadState.CheckToUpdate or slot0.state == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD("CV", true)
		end
	end, SFX_PANEL)

	slot0.galleryDownloadBtn = slot0.findTF(slot0, "main/resources/mask/main_panel/gallery")
	slot0.galleryDownloadProgress = slot0:findTF("main/resources/mask/main_panel/gallery/progress")
	slot0.galleryDownloadProgressHandle = slot0:findTF("main/resources/mask/main_panel/gallery/progress/handle")
	slot0.galleryDownloadInfo1 = slot0:findTF("main/resources/mask/main_panel/gallery/status")
	slot0.galleryDownloadInfo2 = slot0:findTF("main/resources/mask/main_panel/gallery/version")
	slot0.galleryDownloadLabelNew = slot0:findTF("main/resources/mask/main_panel/gallery/version/new")
	slot0.galleryDownloadDot = slot0:findTF("main/resources/mask/main_panel/gallery/new")
	slot0.galleryDownloadLoading = slot0:findTF("main/resources/mask/main_panel/gallery/loading")

	setSlider(slot0.galleryDownloadProgress, 0, 1, 0)
	setActive(slot0.galleryDownloadDot, false)
	setActive(slot0.galleryDownloadLoading, false)
	BundleWizard.Inst:GetGroupMgr("GALLERY_PIC").CheckD(slot8)

	slot0.galleryDownloadTimer = Timer.New(function ()
		slot0:updateGalleryDownloadState()
	end, 0.5, -1)

	slot0.galleryDownloadTimer.Start(slot9)
	slot0:updateGalleryDownloadState()
	onButton(slot0, slot0.galleryDownloadBtn, function ()
		if slot0.state == DownloadState.CheckFailure then
			slot0:CheckD()
		elseif slot0.state == DownloadState.CheckToUpdate or slot0.state == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD("GALLERY_PIC", true)
		end
	end, SFX_PANEL)

	slot0.musicDownloadBtn = slot0.findTF(slot0, "main/resources/mask/main_panel/music")
	slot0.musicDownloadProgress = slot0:findTF("main/resources/mask/main_panel/music/progress")
	slot0.musicDownloadProgressHandle = slot0:findTF("main/resources/mask/main_panel/music/progress/handle")
	slot0.musicDownloadInfo1 = slot0:findTF("main/resources/mask/main_panel/music/status")
	slot0.musicDownloadInfo2 = slot0:findTF("main/resources/mask/main_panel/music/version")
	slot0.musicDownloadLabelNew = slot0:findTF("main/resources/mask/main_panel/music/version/new")
	slot0.musicDownloadDot = slot0:findTF("main/resources/mask/main_panel/music/new")
	slot0.musicDownloadLoading = slot0:findTF("main/resources/mask/main_panel/music/loading")

	setSlider(slot0.musicDownloadProgress, 0, 1, 0)
	setActive(slot0.musicDownloadDot, false)
	setActive(slot0.musicDownloadLoading, false)
	BundleWizard.Inst:GetGroupMgr("GALLERY_BGM").CheckD(slot9)

	slot0.musicDownloadTimer = Timer.New(function ()
		slot0:updateMusicDownloadState()
	end, 0.5, -1)

	slot0.musicDownloadTimer.Start(slot10)
	slot0:updateMusicDownloadState()
	onButton(slot0, slot0.musicDownloadBtn, function ()
		if slot0.state == DownloadState.CheckFailure then
			slot0:CheckD()
		elseif slot0.state == DownloadState.CheckToUpdate or slot0.state == DownloadState.UpdateFailure then
			VersionMgr.Inst:RequestUIForUpdateD("GALLERY_BGM", true)
		end
	end, SFX_PANEL)
end

slot0.initSoundPanel = function (slot0, slot1)
	setActive(slot1, false)

	slot2 = slot0:findTF("main/resources/mask/main_panel")
	slot0.bgmSlider = slot2:Find("settings/bgm/slider")

	function slot4()
		if pg.CriMgr.GetInstance():getBGMVolume() then
			slot0 = PlayerPrefs.GetFloat("bgm_vol_mute_setting", DEFAULT_BGMVOLUME)
		end

		setSlider(slot1.bgmSlider, 0, 1, slot0)
	end

	slot4()
	slot0:initSoundSlider(slot0.bgmSlider, function (slot0)
		if slot0 then
			return
		end

		pg.CriMgr.GetInstance():setBGMVolume(slot0)
	end)

	slot0.effectSlider = slot2.Find(slot2, "settings/sfx/slider")

	function slot5()
		if pg.CriMgr.GetInstance():getSEVolume() then
			slot0 = PlayerPrefs.GetFloat("se_vol_mute_setting", DEFAULT_SEVOLUME)
		end

		setSlider(slot1.effectSlider, 0, 1, slot0)
	end

	slot5()
	slot0:initSoundSlider(slot0.effectSlider, function (slot0)
		if slot0 then
			return
		end

		pg.CriMgr.GetInstance():setSEVolume(slot0)
	end)

	slot0.mainSlider = slot2.Find(slot2, "settings/cv/slider")

	function slot6()
		if pg.CriMgr.GetInstance():getCVVolume() then
			slot0 = PlayerPrefs.GetFloat("cv_vol_mute_setting", DEFAULT_CVVOLUME)
		end

		setSlider(slot1.mainSlider, 0, 1, slot0)
	end

	slot6()
	slot0:initSoundSlider(slot0.mainSlider, function (slot0)
		if slot0 then
			return
		end

		pg.CriMgr.GetInstance():setCVVolume(slot0)
	end)
	setText(slot2.Find(slot2, "settings/buttons/soundswitch/Text"), i18n("voice_control"))
	triggerToggle(slot7, not (PlayerPrefs.GetInt("mute_audio", 0) == 1))
	triggerToggle(slot8, PlayerPrefs.GetInt("mute_audio", 0) == 1)
	onToggle(slot0, slot7, function (slot0)
		if not slot0 then
			PlayerPrefs.SetFloat("bgm_vol_mute_setting", pg.CriMgr.GetInstance():getBGMVolume())
			PlayerPrefs.SetFloat("se_vol_mute_setting", pg.CriMgr.GetInstance():getSEVolume())
			PlayerPrefs.SetFloat("cv_vol_mute_setting", pg.CriMgr.GetInstance():getCVVolume())
			pg.CriMgr.GetInstance():setBGMVolume(0)
			pg.CriMgr.GetInstance():setSEVolume(0)
			pg.CriMgr.GetInstance():setCVVolume(0)
			PlayerPrefs.SetInt("mute_audio", 1)
		else
			pg.CriMgr.GetInstance():setBGMVolume(PlayerPrefs.GetFloat("bgm_vol_mute_setting", DEFAULT_BGMVOLUME))
			pg.CriMgr.GetInstance():setSEVolume(PlayerPrefs.GetFloat("se_vol_mute_setting", DEFAULT_SEVOLUME))
			pg.CriMgr.GetInstance():setCVVolume(PlayerPrefs.GetFloat("cv_vol_mute_setting", DEFAULT_CVVOLUME))
			PlayerPrefs.SetInt("mute_audio", 0)
		end

		slot0:setSliderEnable(slot0.bgmSlider, slot0)
		slot0:setSliderEnable(slot0.effectSlider, slot0)
		slot0:setSliderEnable(slot0.mainSlider, slot0)

		slot1 = not slot0
	end, SFX_UI_TAG, SFX_UI_TAG)
	slot0.setSliderEnable(slot0, slot0.bgmSlider, not (PlayerPrefs.GetInt("mute_audio", 0) == 1))
	slot0:setSliderEnable(slot0.effectSlider, not (PlayerPrefs.GetInt("mute_audio", 0) == 1))
	slot0:setSliderEnable(slot0.mainSlider, not (PlayerPrefs.GetInt("mute_audio", 0) == 1))

	slot0.soundRevertBtn = slot2:Find("settings/buttons/reset")

	onButton(slot0, slot0.soundRevertBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("sure_resume_volume"),
			onYes = function ()
				triggerToggle(triggerToggle, true)
				setSlider(triggerToggle.bgmSlider, 0, 1, DEFAULT_BGMVOLUME)
				setSlider(triggerToggle.bgmSlider.effectSlider, 0, 1, DEFAULT_SEVOLUME)
				setSlider(triggerToggle.bgmSlider.effectSlider.mainSlider, 0, 1, DEFAULT_CVVOLUME)
			end
		})
	end, SFX_UI_CLICK)
end

slot0.initSoundSlider = function (slot0, slot1, slot2)
	slot3 = slot1:GetComponent("Slider")

	slot3.onValueChanged:RemoveAllListeners()
	pg.DelegateInfo.Add(slot0, slot3.onValueChanged)
	slot3.onValueChanged:AddListener(slot2)

	slot4 = (slot3.maxValue - slot3.minValue) * 0.1

	onButton(slot0, slot1:Find("up"), function ()
		slot0.value = math.clamp(slot0.value + slot1, slot0.minValue, slot0.maxValue)
	end, SFX_PANEL)
	onButton(slot0, slot1:Find("down"), function ()
		slot0.value = math.clamp(slot0.value - slot1, slot0.minValue, slot0.maxValue)
	end, SFX_PANEL)
end

slot0.setSliderEnable = function (slot0, slot1, slot2)
	slot1:GetComponent("Slider").interactable = tobool(slot2)

	setButtonEnabled(slot1:Find("up"), slot2)
	setButtonEnabled(slot1:Find("down"), tobool(slot2))
end

slot1 = {}
slot2 = {
	{
		title = i18n("words_show_ship_name_label"),
		desc = i18n("option_desc1")
	},
	{
		title = i18n("words_auto_battle_label"),
		name = AUTO_BATTLE_LABEL,
		desc = i18n("option_desc2")
	},
	{
		default = 1,
		title = i18n("words_rare_ship_vibrate"),
		name = RARE_SHIP_VIBRATE,
		desc = i18n("option_desc3")
	},
	{
		default = 1,
		title = i18n("words_display_ship_get_effect"),
		name = DISPLAY_SHIP_GET_EFFECT,
		desc = i18n("option_desc4")
	},
	{
		default = 1,
		title = i18n("words_show_touch_effect"),
		name = SHOW_TOUCH_EFFECT,
		desc = i18n("option_desc5")
	},
	{
		default = 0,
		title = i18n("words_bg_fit_mode"),
		name = BG_FIT_MODE,
		desc = i18n("option_desc6")
	},
	{
		default = 1,
		title = i18n("words_battle_hide_bg"),
		name = BATTLE_HIDE_BG,
		desc = i18n("option_desc10")
	},
	{
		default = 0,
		alignment = 1,
		title = i18n("words_battle_expose_line"),
		name = BATTLE_EXPOSE_LINE,
		desc = i18n("option_desc11")
	}
}

if not LOCK_BATTERY_SAVEMODE then
	table.insert(slot2, {
		default = 0,
		title = i18n("words_autoFight_battery_savemode"),
		name = AUTOFIGHT_BATTERY_SAVEMODE,
		desc = i18n("words_autoFight_battery_savemode_des")
	})
	table.insert(slot2, {
		default = 0,
		title = i18n("words_autoFIght_down_frame"),
		name = AUTOFIGHT_DOWN_FRAME,
		desc = i18n("words_autoFIght_down_frame_des")
	})
end

slot3 = {
	{
		default = 1,
		title = i18n("words_visit_backyard_toggle"),
		name = ALLOW_FIREND_VISIT_BACKYARD,
		desc = i18n("option_desc7"),
		playerFlag = ALLOW_FIREND_VISIT_BACKYARD_FLAG
	},
	{
		default = 0,
		title = i18n("words_show_friend_backyardship_toggle"),
		name = SHOW_FIREND_BACKYARD_SHIP,
		desc = i18n("option_desc8"),
		playerFlag = SHOW_FIREND_BACKYARD_SHIP_FLAG
	},
	{
		default = 0,
		title = i18n("words_show_my_backyardship_toggle"),
		name = SHOW_MY_BACKYARD_SHIP,
		desc = i18n("option_desc9"),
		playerFlag = SHOW_MY_BACKYARD_SHIP_FLAG
	}
}

slot0.initOptionsPanel = function (slot0, slot1)
	onToggle(slot0, slot3, function (slot0)
		if slot0 then
			PlayerPrefs.SetInt("fps_limit", 30)

			Application.targetFrameRate = 30
		end
	end, SFX_UI_TAG, SFX_UI_TAG)
	onToggle(slot0, slot1:Find("scroll_view/Viewport/content/fps_setting"):Find("options/60fps"), function (slot0)
		if slot0 then
			PlayerPrefs.SetInt("fps_limit", 60)

			Application.targetFrameRate = 60
		end
	end, SFX_UI_TAG, SFX_UI_TAG)
	triggerToggle(slot3, PlayerPrefs.GetInt("fps_limit", 30) == 30)
	triggerToggle(slot4, slot5 == 60)

	slot7 = slot0:findTF("scroll_view/Viewport/content/other_settings/options", slot1)
	slot8 = slot0:findTF("scroll_view/Viewport/content/notifications/options", slot1).Find(triggerToggle, "notify_tpl")

	for slot13, slot14 in ipairs(slot9) do
		slot15 = cloneTplTo(slot8, slot6)

		setText(slot0:findTF("Text", slot15), slot14.title)
		onButton(slot0, slot0:findTF("Text", slot15), function ()
			slot0.msgBox:ExecuteAction("Show", slot1.desc, slot1.alignment)
		end)
		onToggle(slot0, slot15:Find("on"), function (slot0)
			pg.PushNotificationMgr.GetInstance():setSwitch(slot0.id, slot0)
		end, SFX_UI_TAG, SFX_UI_CANCEL)
		triggerToggle(slot15:Find("on"), slot16)
		triggerToggle(slot15:Find("off"), not pg.PushNotificationMgr.GetInstance().isEnabled(slot16, slot14.id))
	end

	slot8 = slot7:Find("notify_tpl")

	for slot13, slot14 in pairs(slot0) do
		setText(slot0:findTF("Text", slot15), slot14.title)
		onButton(slot0, slot0:findTF("Text", cloneTplTo(slot8, slot7)), function ()
			slot0.msgBox:ExecuteAction("Show", slot1.desc, slot1.alignment)
		end)

		if slot13 == 1 then
			onToggle(slot0, slot15:Find("on"), function (slot0)
				pg.PushNotificationMgr.GetInstance():setSwitchShipName(slot0)
			end, SFX_UI_TAG, SFX_UI_CANCEL)
			triggerToggle(slot15.Find(slot15, "on"), pg.PushNotificationMgr.GetInstance():isEnableShipName())
			triggerToggle(slot15:Find("off"), not pg.PushNotificationMgr.GetInstance():isEnableShipName())
		else
			slot0[slot14.name] = PlayerPrefs.GetInt(slot14.name, slot14.default or 0) > 0

			if slot14.name == AUTOFIGHT_BATTERY_SAVEMODE then
				onToggle(slot0, slot15:Find("on"), function (slot0)
					if slot0[slot1.name] ~= slot0 then
						slot1(slot1.name, (slot0 and 1) or 0)
						PlayerPrefs.Save()

						slot0[slot1.name] = slot0

						if slot0.name == AUTOFIGHT_BATTERY_SAVEMODE then
							slot1 = _.detect(slot2, function (slot0)
								return slot0.name == AUTOFIGHT_DOWN_FRAME
							end)

							if table.indexof(table.indexof, slot1) then
								triggerToggle(slot3:GetChild(slot2):Find((slot0 and "on") or "off"), true)
								triggerToggle.SetGrayAndUninteractable(slot3, slot0)
							end
						end
					end
				end, SFX_UI_TAG, SFX_UI_CANCEL)
			elseif slot14.name == AUTOFIGHT_DOWN_FRAME then
				onToggle(slot0, slot15:Find("on"), function (slot0)
					if not slot0[AUTOFIGHT_BATTERY_SAVEMODE] and slot0 then
						pg.TipsMgr.GetInstance():ShowTips(i18n("words_autoFight_tips"))
						triggerToggle(slot1:Find("off"), true)

						return
					end

					if slot0[slot2.name] ~= slot0 then
						PlayerPrefs.SetInt(slot2.name, (slot0 and 1) or 0)
						PlayerPrefs.Save()

						slot0[slot2.name.name] = slot0
					end
				end, SFX_UI_TAG, SFX_UI_CANCEL)
				slot1.SetGrayAndUninteractable(slot15, slot0[AUTOFIGHT_BATTERY_SAVEMODE])
			else
				onToggle(slot0, slot15:Find("on"), function (slot0)
					if slot0[slot1.name] ~= slot0 then
						slot1(slot1.name, (slot0 and 1) or 0)
						PlayerPrefs.Save()

						slot0[slot1.name] = slot0
					end

					if slot1.name == SHOW_TOUCH_EFFECT and pg.UIMgr.GetInstance().OverlayEffect then
						setActive(slot1, slot0)
					end
				end, SFX_UI_TAG, SFX_UI_CANCEL)
			end

			triggerToggle(slot15.Find(slot15, "on"), slot0[slot14.name])
			triggerToggle(slot15:Find("off"), not slot0[slot14.name])
		end
	end

	slot0:UpdateBackYardConfig()
	setActive(slot0:findTF("scroll_view/Viewport/content/world_boss_notifications", slot1), false)

	slot14, slot11 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "WorldMediator")

	setActive(slot1:Find("scroll_view/Viewport/content/world_settings"), slot10)

	if slot10 then
		slot0:InitWorldPanel(slot1)
	end

	slot0:InitStorySpeedPanel(slot1)
	slot0:InitStoryAutoPlayPanel(slot1)
end

slot0.SetGrayAndUninteractable = function (slot0, slot1)
	setGray(slot0:Find("on"), not slot1)
	setGray(slot0:Find("off"), not slot1)
end

slot0.InitStorySpeedPanel = function (slot0, slot1)
	setText(slot1:Find("scroll_view/Viewport/content/story_speed_setting/title"), i18n("story_setting_label"))
	setText(slot1:Find("scroll_view/Viewport/content/story_speed_setting/title/title_text"), i18n1("/AUTO SPEED"))

	slot3 = slot1:Find("scroll_view/Viewport/content/story_speed_setting/speeds")
	slot5 = table.indexof(Story.STORY_AUTO_SPEED, getProxy(SettingsProxy):GetStorySpeed()) or 2

	for slot9 = 1, slot3.childCount, 1 do
		onToggle(slot0, slot10, function (slot0)
			if slot0 then
				getProxy(SettingsProxy):SetStorySpeed(slot0[])
			end
		end, SFX_PANEL)
		setText(slot3:GetChild(slot9 - 1).Find(slot10, "Text"), i18n("setting_story_speed_" .. slot9))

		if slot9 == slot5 then
			triggerToggle(slot10, true)
		end
	end
end

slot0.InitStoryAutoPlayPanel = function (slot0, slot1)
	setText(slot1:Find("scroll_view/Viewport/content/story_autoplay_setting/title"), i18n("story_autoplay_setting_label"))
	setText(slot1:Find("scroll_view/Viewport/content/story_autoplay_setting/title/title_text"), i18n1("/AUTO"))

	slot2 = (getProxy(SettingsProxy):GetStoryAutoPlayFlag() and 2) or 1

	for slot7, slot8 in ipairs(slot3) do
		onToggle(slot0, slot8, function (slot0)
			if slot0 then
				getProxy(SettingsProxy):SetStoryAutoPlayFlag(slot0 - 1)
			end
		end, SFX_PANEL)
		setText(slot8.Find(slot8, "Text"), i18n("story_autoplay_setting_" .. slot7))

		if slot7 == slot2 then
			triggerToggle(slot8, true)
		end
	end
end

slot0.UpdateBackYardConfig = function (slot0)
	if not slot0.backyardConfigToggles then
		slot0.backyardConfigToggles = {}
		notiTpl = slot0:findTF("scroll_view/Viewport/content/other_settings/options", slot0:findTF("main/options")).Find(slot1, "notify_tpl")

		for slot5, slot6 in ipairs(slot0) do
			slot7 = cloneTplTo(notiTpl, slot1)

			setText(slot0:findTF("Text", slot7), slot6.title)
			onButton(slot0, slot0:findTF("Text", slot7), function ()
				slot0.msgBox:ExecuteAction("Show", slot1.desc, slot1.alignment)
			end)
			table.insert(slot0.backyardConfigToggles, {
				value = slot6,
				btn = slot7
			})
		end
	end

	for slot4, slot5 in ipairs(slot0.backyardConfigToggles) do
		slot0.InitOptionByPlayerFlag(slot0, slot5.value, slot5.btn)
	end
end

slot0.InitOptionByPlayerFlag = function (slot0, slot1, slot2)
	slot5 = nil

	onToggle(slot0, slot2:Find("on"), function (slot0)
		slot0:emit(SettingsMediator.SET_PLAYER_FLAG, slot1.playerFlag)
	end, SFX_UI_TAG, SFX_UI_CANCEL)
	triggerToggle(slot2.Find(slot2, "on"), not ((slot1.default == 1 and getProxy(PlayerProxy):getData().GetCommonFlag(slot3, slot1.playerFlag)) or not getProxy(PlayerProxy).getData().GetCommonFlag(slot3, slot1.playerFlag)))
	triggerToggle(slot2:Find("off"), (slot1.default == 1 and getProxy(PlayerProxy).getData().GetCommonFlag(slot3, slot1.playerFlag)) or not getProxy(PlayerProxy).getData().GetCommonFlag(slot3, slot1.playerFlag))
end

slot0.InitWorldBossPanel = function (slot0, slot1)
	slot3 = slot0:findTF("scroll_view/Viewport/content/world_boss_notifications/options", slot1).Find(slot2, "notify_tpl")

	for slot8, slot9 in ipairs(slot4) do
		slot10 = cloneTplTo(slot3, slot2)

		setText(slot10:Find("Text"), slot9)
		onToggle(slot0, slot10:Find("on"), function (slot0)
			if slot0 ~= slot0 then
				getProxy(SettingsProxy):SetWorldBossFlag(getProxy(SettingsProxy).SetWorldBossFlag, slot0)

				slot0 = slot0
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
		triggerToggle(slot10.Find(slot10, "on"), slot11)
		triggerToggle(slot10:Find("off"), not getProxy(SettingsProxy):GetWorldBossFlag(slot8))
	end
end

slot0.InitWorldPanel = function (slot0, slot1)
	slot3 = slot1:Find("scroll_view/Viewport/content/world_settings/options").Find(slot2, "notify_tpl")

	for slot8, slot9 in pairs(slot4) do
		slot10 = cloneTplTo(slot3, slot2)

		setText(slot10:Find("Text"), slot9.title)
		onButton(slot0, slot10:Find("Text"), function ()
			slot0.msgBox:ExecuteAction("Show", slot1.desc)
		end)
		onToggle(slot0, slot10:Find("on"), function (slot0)
			if slot0 ~= slot0 then
				getProxy(SettingsProxy):SetWorldFlag(slot1.key, slot0)

				slot0 = slot0
			end
		end, SFX_UI_TAG, SFX_UI_CANCEL)
		triggerToggle(slot10.Find(slot10, "on"), slot11)
		triggerToggle(slot10:Find("off"), not getProxy(SettingsProxy):GetWorldFlag(slot9.key))
	end

	setText(slot1:Find("scroll_view/Viewport/content/world_settings/title"), i18n("world_setting_title"))
end

slot0.initInterfacePreference = function (slot0, slot1)
	setActive(slot1, false)

	slot0.editPanel = slot1:Find("editor")
	slot0.normalBtns = findTF(slot2, "normal")
	slot0.editBtns = findTF(slot2, "editing")
	slot0.saveBtn = findTF(slot0.editBtns, "save")
	slot0.cancelBtn = findTF(slot0.editBtns, "cancel")
	slot0.editBtn = findTF(slot0.normalBtns, "edit")
	slot0.revertBtn = findTF(slot0.normalBtns, "reset")

	onButton(slot0, slot0.editBtn, function ()
		slot0:editModeEnabled(true)
	end, SFX_PANEL)
	onButton(slot0, slot0.revertBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("setting_interface_revert_check"),
			onYes = function ()
				slot0:revertInterfaceSetting(true)
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.cancelBtn, function ()
		if slot0._currentDrag then
			LuaHelper.triggerEndDrag(slot0._currentDrag)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = false,
			content = i18n("setting_interface_cancel_check"),
			onYes = function ()
				slot0:editModeEnabled(false)
				slot0.editModeEnabled:revertInterfaceSetting(false)
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.saveBtn, function ()
		if slot0._currentDrag then
			LuaHelper.triggerEndDrag(slot0._currentDrag)
		end

		slot0:editModeEnabled(false)
		slot0.editModeEnabled:saveInterfaceSetting()
		pg.TipsMgr.GetInstance():ShowTips(i18n("setting_interface_save_success"))
	end, SFX_PANEL)

	slot0.interface = slot0.findTF(slot0, "main/battle_ui/editor/editing_region")

	if rtf(slot0.interface).rect.width / rtf(slot0.interface).rect.height > rtf(slot0._tf).rect.width / rtf(slot0._tf).rect.height then
		slot8 = rtf(slot0.interface).sizeDelta.y
		slot0.scale = slot4 / slot6
		slot7 = rtf(slot0.interface).sizeDelta.x - (slot3 - (slot4 * slot5) / slot6)
	else
		slot7 = rtf(slot1).sizeDelta.x
		slot0.scale = slot3 / slot5
		slot8 = rtf(slot1).sizeDelta.y - (slot4 - (slot3 * slot6) / slot5)
	end

	slot7 = Vector3.New(slot0.scale, slot0.scale, 1)
	slot0.stick = findTF(slot0.interface, "Stick")
	slot0.skillBtn1 = findTF(slot0.interface, "Skill_1")
	slot0.skillBtn2 = findTF(slot0.interface, "Skill_2")
	slot0.skillBtn3 = findTF(slot0.interface, "Skill_3")
	slot0.skillBtn4 = findTF(slot0.interface, "Skill_4")
	slot0.mask = findTF(slot0.interface, "mask")

	slot0:initInterfaceComponent(slot0.stick, "joystick_anchorX", "joystick_anchorY", slot8)
	slot0:initInterfaceComponent(slot0.skillBtn1, "skill_1_anchorX", "skill_1_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[1])
	slot0:initInterfaceComponent(slot0.skillBtn2, "skill_2_anchorX", "skill_2_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[2])
	slot0:initInterfaceComponent(slot0.skillBtn3, "skill_3_anchorX", "skill_3_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[3])
	slot0:initInterfaceComponent(slot0.skillBtn4, "skill_4_anchorX", "skill_4_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[4])

	slot0.components = {
		findTF(slot0.interface, "top"),
		slot0.stick,
		slot0.skillBtn1,
		slot0.skillBtn2,
		slot0.skillBtn3,
		slot0.skillBtn4
	}

	for slot14 = 2, #slot0.components, 1 do
		setLocalScale(slot0.components[slot14], slot7)
	end

	slot0:editModeEnabled(false)
end

slot0.initInterfaceComponent = function (slot0, slot1, slot2, slot3, slot4)
	slot7 = rtf(slot0._tf).rect.width * 0.5 + slot0.interface.localPosition.x + slot0.interface.parent.localPosition.x + slot0.interface.parent.parent.localPosition.x
	slot8 = rtf(slot0._tf).rect.height * 0.5 + slot0.interface.localPosition.y + slot0.interface.parent.localPosition.y + slot0.interface.parent.parent.localPosition.y
	slot9 = GetOrAddComponent(slot1, "EventTriggerListener")
	slot0.eventTriggers[slot9] = true
	slot10, slot11, slot12, slot13 = nil

	slot9:AddBeginDragFunc(function (slot0, slot1)
		slot0._currentDrag = slot1
		slot2 = slot1 / UnityEngine.Screen.width
		slot4 = slot5 / UnityEngine.Screen.height

		for slot5 = 2, #slot0.components, 1 do
			if slot0.components[slot5] ~=  then
				GetOrAddComponent(slot6, "EventTriggerListener").enabled = false
			end
		end

		slot7 = slot6.localPosition.x
		slot8 = slot6.localPosition.y
	end)
	slot9.AddDragFunc(slot9, function (slot0, slot1)
		slot0.localPosition = Vector3(slot1.position.x * slot1 - slot2, slot1.position.y * slot3 - slot4, 0)

		slot5:checkInterfaceIntersect()
	end)
	slot9.AddDragEndFunc(slot9, function (slot0, slot1)
		slot0._currentDrag = nil

		if slot0:checkInterfaceIntersect() then
			slot1.localPosition = Vector3(slot2, slot1, 0)
		end

		for slot6 = 2, #slot0.components, 1 do
			GetOrAddComponent(slot0.components[slot6], "EventTriggerListener").enabled = true
		end

		slot0:checkInterfaceIntersect()
	end)
	slot0.setInterfaceAnchor(slot0, slot1, slot2, slot3, slot4)
end

slot0.editModeEnabled = function (slot0, slot1)
	setActive(slot0.normalBtns, not slot1)
	setActive(slot0.mask, not slot1)
	setActive(slot0.editBtns, slot1)

	for slot5, slot6 in ipairs(slot0.components) do
		setActive(findTF(slot6, "rect"), slot1)

		if slot5 > 1 then
			GetOrAddComponent(slot6, "EventTriggerListener").enabled = slot1
		end
	end

	slot0.backButton:GetComponent(typeof(Button)).interactable = not slot1
	slot0.otherToggle:GetComponent(typeof(Toggle)).interactable = not slot1
	slot0.optionsToggle:GetComponent(typeof(Toggle)).interactable = not slot1
	slot0.interfaceToggle:GetComponent(typeof(Toggle)).interactable = not slot1
	slot0.resToggle:GetComponent(typeof(Toggle)).interactable = not slot1
	slot0.logoutButton:GetComponent("ButtonExtend").interactable = not slot1
end

slot0.setInterfaceAnchor = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6, slot7 = nil

	if slot5 then
		slot6 = slot4.x
		slot7 = slot4.y
	else
		slot6 = PlayerPrefs.GetFloat(slot2, slot4.x)
		slot7 = PlayerPrefs.GetFloat(slot3, slot4.y)
	end

	slot1.localPosition = Vector3((slot6 - 0.5) * rtf(slot0.interface).rect.width, (slot7 - 0.5) * rtf(slot0.interface).rect.height, 0)
end

function slot4(slot0)
	slot1 = rtf(slot0)

	return UnityEngine.Rect.New(slot1.position.x - (slot1.rect.width * slot1.lossyScale.x) / 2, slot1.position.y - (slot1.rect.height * slot1.lossyScale.y) / 2, slot1.rect.width * slot1.lossyScale.x, slot1.rect.height * slot1.lossyScale.y)
end

slot0.checkInterfaceIntersect = function (slot0)
	slot1 = {}
	slot2 = false
	slot3 = {}
	slot4 = slot0(slot0.interface)

	for slot8, slot9 in ipairs(slot0.components) do
		slot3[slot9] = slot0(slot9:Find("rect"))
	end

	for slot8, slot9 in ipairs(slot0.components) do
		for slot13, slot14 in ipairs(slot0.components) do
			if slot9 ~= slot14 and slot3[slot9]:Overlaps(slot3[slot14]) then
				slot1[slot14] = true
			end
		end

		if slot8 > 1 then
			slot11 = Vector2.New(slot3[slot9].xMax, slot3[slot9].yMax)

			if not slot4:Contains(Vector2.New(slot3[slot9].xMin, slot3[slot9].yMin)) or not slot4:Contains(slot11) then
				slot1[slot9] = true
			end
		end
	end

	for slot8, slot9 in ipairs(slot0.components) do
		slot10 = findTF(slot9, "rect"):GetComponent(typeof(Image))

		if slot1[slot9] then
			slot10.color = slot1.CLD_RED
			slot2 = true
		else
			slot10.color = slot1.DEFAULT_GREY
		end
	end

	return slot2
end

slot0.revertInterfaceSetting = function (slot0, slot1)
	slot0:setInterfaceAnchor(slot0.stick, "joystick_anchorX", "joystick_anchorY", slot2, slot1)
	slot0:setInterfaceAnchor(slot0.skillBtn1, "skill_1_anchorX", "skill_1_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[1], slot1)
	slot0:setInterfaceAnchor(slot0.skillBtn2, "skill_2_anchorX", "skill_2_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[2], slot1)
	slot0:setInterfaceAnchor(slot0.skillBtn3, "skill_3_anchorX", "skill_3_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[3], slot1)
	slot0:setInterfaceAnchor(slot0.skillBtn4, "skill_4_anchorX", "skill_4_anchorY", ys.Battle.BattleConfig.SKILL_BUTTON_DEFAULT_PREFERENCE[4], slot1)
	slot0:saveInterfaceSetting()
end

slot0.saveInterfaceSetting = function (slot0)
	slot0:overrideInterfaceSetting(slot0.stick, "joystick_anchorX", "joystick_anchorY")
	slot0:overrideInterfaceSetting(slot0.skillBtn1, "skill_1_anchorX", "skill_1_anchorY")
	slot0:overrideInterfaceSetting(slot0.skillBtn2, "skill_2_anchorX", "skill_2_anchorY")
	slot0:overrideInterfaceSetting(slot0.skillBtn3, "skill_3_anchorX", "skill_3_anchorY")
	slot0:overrideInterfaceSetting(slot0.skillBtn4, "skill_4_anchorX", "skill_4_anchorY")
end

slot0.overrideInterfaceSetting = function (slot0, slot1, slot2, slot3)
	PlayerPrefs.SetFloat(slot2, slot6)
	PlayerPrefs.SetFloat(slot3, (slot1.localPosition.y + rtf(slot0.interface).rect.height * 0.5) / rtf(slot0.interface).rect.height)
end

slot0.updateSoundDownloadState = function (slot0)
	slot3, slot4, slot5, slot6, slot7 = nil
	slot8 = false

	if BundleWizard.Inst:GetGroupMgr("CV").state == DownloadState.None then
		slot3 = i18n("word_soundfiles_download_title")
		slot4 = i18n("word_soundfiles_download")
		slot5 = "DOWNLOAD"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Checking then
		slot3 = i18n("word_soundfiles_checking_title")
		slot4 = i18n("word_soundfiles_checking")
		slot5 = "CHECKING"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.CheckToUpdate then
		slot3 = i18n("word_soundfiles_checkend_title")
		slot4 = i18n("word_soundfiles_checkend")
		slot5 = string.format("V.%d > V.%d", slot1.localVersion.Build, slot1.serverVersion.Build)
		slot6 = 0
		slot7 = true
	elseif slot2 == DownloadState.CheckOver then
		slot3 = i18n("word_soundfiles_checkend_title")
		slot4 = i18n("word_soundfiles_noneedupdate")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.CheckFailure then
		slot3 = i18n("word_soundfiles_checkfailed")
		slot4 = i18n("word_soundfiles_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Updating then
		slot3 = i18n("word_soundfiles_update")
		slot4 = string.format("(%d/%d)", slot1.downloadCount, slot1.downloadTotal)
		slot5 = slot1.downPath
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = false
		slot8 = true
	elseif slot2 == DownloadState.UpdateSuccess then
		slot3 = i18n("word_soundfiles_update_end_title")
		slot4 = i18n("word_soundfiles_update_end")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.UpdateFailure then
		slot3 = i18n("word_soundfiles_update_failed")
		slot4 = i18n("word_soundfiles_update_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = true
	end

	if slot5:len() > 15 then
		slot5 = slot5:sub(1, 12) .. "..."
	end

	setText(slot0.soundDownloadInfo1, slot4)
	setText(slot0.soundDownloadInfo2, slot5)
	setAnchoredPosition(slot0.soundDownloadInfo2, {
		x = (slot2 == DownloadState.CheckToUpdate and 82.5) or 91.5
	})
	setSlider(slot0.soundDownloadProgress, 0, 1, slot6)
	setActive(slot0.soundDownloadProgressHandle, slot6 ~= 0 and slot6 ~= 1)
	setActive(slot0.soundDownloadDot, slot7)
	setActive(slot0.soundDownloadLoading, slot8)
	setActive(slot0.soundDownloadLabelNew, slot2 == DownloadState.CheckToUpdate)
end

slot0.updateLive2DDownloadState = function (slot0)
	slot3, slot4, slot5, slot6, slot7 = nil
	slot8 = false

	if BundleWizard.Inst:GetGroupMgr("L2D").state == DownloadState.None then
		slot3 = i18n("word_live2dfiles_download_title")
		slot4 = i18n("word_live2dfiles_download")
		slot5 = "DOWNLOAD"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Checking then
		slot3 = i18n("word_live2dfiles_checking_title")
		slot4 = i18n("word_live2dfiles_checking")
		slot5 = "CHECKING"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.CheckToUpdate then
		if slot1.serverVersion.Build <= slot1.localVersion.Build then
			slot1.state = DownloadState.CheckOver

			slot0:updateLive2DDownloadState()

			return
		end

		slot3 = i18n("word_live2dfiles_checkend_title")
		slot4 = i18n("word_live2dfiles_checkend")
		slot5 = string.format("V.%d > V.%d", slot1.localVersion.Build, slot1.serverVersion.Build)
		slot6 = 0
		slot7 = true
	elseif slot2 == DownloadState.CheckOver then
		slot3 = i18n("word_live2dfiles_checkend_title")
		slot4 = i18n("word_live2dfiles_noneedupdate")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.CheckFailure then
		slot3 = i18n("word_live2dfiles_checkfailed")
		slot4 = i18n("word_live2dfiles_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Updating then
		slot3 = i18n("word_live2dfiles_update")
		slot4 = string.format("(%d/%d)", slot1.downloadCount, slot1.downloadTotal)
		slot5 = slot1.downPath
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = false
		slot8 = true
	elseif slot2 == DownloadState.UpdateSuccess then
		slot3 = i18n("word_live2dfiles_update_end_title")
		slot4 = i18n("word_live2dfiles_update_end")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.UpdateFailure then
		slot3 = i18n("word_live2dfiles_update_failed")
		slot4 = i18n("word_live2dfiles_update_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = true
	end

	if slot5:len() > 15 then
		slot5 = slot5:sub(1, 12) .. "..."
	end

	setText(slot0.live2DDownloadInfo1, slot4)
	setText(slot0.live2DDownloadInfo2, slot5)
	setAnchoredPosition(slot0.live2DDownloadInfo2, {
		x = (slot2 == DownloadState.CheckToUpdate and 82.5) or 91.5
	})
	setSlider(slot0.live2DDownloadProgress, 0, 1, slot6)
	setActive(slot0.live2DDownloadProgressHandle, slot6 ~= 0 and slot6 ~= 1)
	setActive(slot0.live2DDownloadDot, slot7)
	setActive(slot0.live2DDownloadLoading, slot8)
	setActive(slot0.live2DDownloadLabelNew, slot2 == DownloadState.CheckToUpdate)
end

slot0.updateGalleryDownloadState = function (slot0)
	slot3, slot4, slot5, slot6, slot7 = nil
	slot8 = false

	if BundleWizard.Inst:GetGroupMgr("GALLERY_PIC").state == DownloadState.None then
		slot3 = i18n("word_soundfiles_download_title")
		slot4 = i18n("word_soundfiles_download")
		slot5 = "DOWNLOAD"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Checking then
		slot3 = i18n("word_soundfiles_checking_title")
		slot4 = i18n("word_soundfiles_checking")
		slot5 = "CHECKING"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.CheckToUpdate then
		slot3 = i18n("word_soundfiles_checkend_title")
		slot4 = i18n("word_soundfiles_checkend")
		slot5 = string.format("V.%d > V.%d", slot1.localVersion.Build, slot1.serverVersion.Build)
		slot6 = 0
		slot7 = true
	elseif slot2 == DownloadState.CheckOver then
		slot3 = i18n("word_soundfiles_checkend_title")
		slot4 = i18n("word_soundfiles_noneedupdate")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.CheckFailure then
		slot3 = i18n("word_soundfiles_checkfailed")
		slot4 = i18n("word_soundfiles_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Updating then
		slot3 = i18n("word_soundfiles_update")
		slot4 = string.format("(%d/%d)", slot1.downloadCount, slot1.downloadTotal)
		slot5 = slot1.downPath
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = false
		slot8 = true
	elseif slot2 == DownloadState.UpdateSuccess then
		slot3 = i18n("word_soundfiles_update_end_title")
		slot4 = i18n("word_soundfiles_update_end")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.UpdateFailure then
		slot3 = i18n("word_soundfiles_update_failed")
		slot4 = i18n("word_soundfiles_update_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = true
	end

	if slot5:len() > 15 then
		slot5 = slot5:sub(1, 12) .. "..."
	end

	setText(slot0.galleryDownloadInfo1, slot4)
	setText(slot0.galleryDownloadInfo2, slot5)
	setAnchoredPosition(slot0.galleryDownloadInfo2, {
		x = (slot2 == DownloadState.CheckToUpdate and 82.5) or 91.5
	})
	setSlider(slot0.galleryDownloadProgress, 0, 1, slot6)
	setActive(slot0.galleryDownloadProgressHandle, slot6 ~= 0 and slot6 ~= 1)
	setActive(slot0.galleryDownloadDot, slot7)
	setActive(slot0.galleryDownloadLoading, slot8)
	setActive(slot0.galleryDownloadLabelNew, slot2 == DownloadState.CheckToUpdate)
end

slot0.updateMusicDownloadState = function (slot0)
	slot3, slot4, slot5, slot6, slot7 = nil
	slot8 = false

	if BundleWizard.Inst:GetGroupMgr("GALLERY_BGM").state == DownloadState.None then
		slot3 = i18n("word_soundfiles_download_title")
		slot4 = i18n("word_soundfiles_download")
		slot5 = "DOWNLOAD"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Checking then
		slot3 = i18n("word_soundfiles_checking_title")
		slot4 = i18n("word_soundfiles_checking")
		slot5 = "CHECKING"
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.CheckToUpdate then
		slot3 = i18n("word_soundfiles_checkend_title")
		slot4 = i18n("word_soundfiles_checkend")
		slot5 = string.format("V.%d > V.%d", slot1.localVersion.Build, slot1.serverVersion.Build)
		slot6 = 0
		slot7 = true
	elseif slot2 == DownloadState.CheckOver then
		slot3 = i18n("word_soundfiles_checkend_title")
		slot4 = i18n("word_soundfiles_noneedupdate")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.CheckFailure then
		slot3 = i18n("word_soundfiles_checkfailed")
		slot4 = i18n("word_soundfiles_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = 0
		slot7 = false
	elseif slot2 == DownloadState.Updating then
		slot3 = i18n("word_soundfiles_update")
		slot4 = string.format("(%d/%d)", slot1.downloadCount, slot1.downloadTotal)
		slot5 = slot1.downPath
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = false
		slot8 = true
	elseif slot2 == DownloadState.UpdateSuccess then
		slot3 = i18n("word_soundfiles_update_end_title")
		slot4 = i18n("word_soundfiles_update_end")
		slot5 = "V." .. slot1.CurrentVersion.Build
		slot6 = 1
		slot7 = false
	elseif slot2 == DownloadState.UpdateFailure then
		slot3 = i18n("word_soundfiles_update_failed")
		slot4 = i18n("word_soundfiles_update_retry")
		slot5 = string.format("ERROR(CODE:%d)", slot1.errorCode)
		slot6 = slot1.downloadCount / math.max(slot1.downloadTotal, 1)
		slot7 = true
	end

	if slot5:len() > 15 then
		slot5 = slot5:sub(1, 12) .. "..."
	end

	setText(slot0.musicDownloadInfo1, slot4)
	setText(slot0.musicDownloadInfo2, slot5)
	setAnchoredPosition(slot0.musicDownloadInfo2, {
		x = (slot2 == DownloadState.CheckToUpdate and 82.5) or 91.5
	})
	setSlider(slot0.musicDownloadProgress, 0, 1, slot6)
	setActive(slot0.musicDownloadProgressHandle, slot6 ~= 0 and slot6 ~= 1)
	setActive(slot0.musicDownloadDot, slot7)
	setActive(slot0.musicDownloadLoading, slot8)
	setActive(slot0.musicDownloadLabelNew, slot2 == DownloadState.CheckToUpdate)
end

slot5 = nil

function slot6()
	return pg.SecondaryPWDMgr.GetInstance() or {
		[slot0.UNLOCK_SHIP] = {
			title = i18n("words_settings_unlock_ship")
		},
		[slot0.RESOLVE_EQUIPMENT] = {
			title = i18n("words_settings_resolve_equip")
		},
		[slot0.UNLOCK_COMMANDER] = {
			title = i18n("words_settings_unlock_commander")
		},
		[slot0.CREATE_INHERIT] = {
			title = i18n("words_settings_create_inherit")
		}
	}
end

slot0.initOtherPanel = function (slot0)
	if PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0 then
		setActive(slot0.otherToggle:Find("tip"), true)
	end

	slot0.otherContent = slot0:findTF("main/other/scroll_view/Viewport/content")
	slot0.redeem = slot0:findTF("redeem", slot0.otherContent)
	slot1 = true

	setActive(slot0:findTF("account", slot0.otherContent), false)

	if PLATFORM_CODE == PLATFORM_CH or PLATFORM_CODE == PLATFORM_KR then
		if PLATFORM_CODE == PLATFORM_KR then
			slot0:initKrHelp()
		end

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			slot1 = false
		end
	elseif PLATFORM_CODE == PLATFORM_JP then
		slot0.accountJP = slot0:findTF("account", slot0.otherContent)

		setActive(slot0.accountJP, true)
		slot0:initJPAccountPanel(slot0.accountJP)

		slot1 = false
	elseif PLATFORM_CODE == PLATFORM_US then
		slot0.accountUS = slot0:findTF("account_us", slot0.otherContent)

		setActive(slot0.accountUS, true)
		slot0:initUSAccountPanel(slot0.accountUS)

		slot1 = false
	elseif PLATFORM_CODE == PLATFORM_CHT then
		slot0.accountTw = slot0:findTF("account_tw", slot0.otherContent)

		setActive(slot0.accountTw, true)
		slot0:UpdateTwAccountPanel(slot0.accountTw)

		if PLATFORM == PLATFORM_IPHONEPLAYER then
			slot1 = false
		end
	end

	if slot1 then
		setActive(slot0.redeem, true)

		slot0.codeInput = slot0:findTF("voucher", slot0.redeem)
		slot0.placeholder = slot0:findTF("Placeholder", slot0.codeInput)
		slot0.placeholder:GetComponent(typeof(Text)).text = i18n("exchangecode_use_placeholder")
		slot0.achieveBtn = slot0:findTF("submit", slot0.codeInput)

		onButton(slot0, slot0.achieveBtn, function ()
			pg.m02:sendNotification(GAME.EXCHANGECODE_USE, {
				key = slot0.codeInput:GetComponent(typeof(InputField)).text
			})
		end, SFX_CONFIRM)
		setGray(slot0.achieveBtn, getInputText(slot0.codeInput) == "")
		onInputChanged(slot0, slot0.codeInput, function ()
			slot0(slot0.achieveBtn, getInputText(slot0.codeInput) == "")
		end)
	else
		setActive(slot0.redeem, false)
	end

	slot0.notchPanel = slot0.findTF(slot0, "main/options/scroll_view/Viewport/content/notch_setting")

	if ADAPT_NOTICE < Screen.width / Screen.height - 0.001 then
		setActive(slot0.notchPanel, true)

		slot0.notchSlider = slot0:findTF("slider", slot0.notchPanel)

		setSlider(slot0.notchSlider, ADAPT_MIN, slot2, getProxy(SettingsProxy):GetScreenRatio())
		slot0:initSoundSlider(slot0.notchSlider, function (slot0)
			slot0:SetScreenRatio(slot0)

			NotchAdapt.CheckNotchRatio = slot0

			NotchAdapt.AdjustUI()
		end)
	else
		setActive(slot0.notchPanel, false)
	end

	onButton(slot0, slot3, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("secondary_password_help")
		})
	end)

	slot4 = slot0.findTF(slot0, "secondpwd", slot0.otherContent)
	slot7 = pg.SecondaryPWDMgr.GetInstance()
	slot9 = getProxy(SecondaryPWDProxy).getRawData(slot8)

	onButton(slot0, slot5, function ()
		if slot0.state > 0 then
			slot1:ChangeSetting({}, function ()
				slot0:updateOtherPanel()
			end)
		end
	end, SFX_UI_TAG)
	onButton(slot0, slot6, function ()
		if slot0.state <= 0 then
			function slot0()
				slot0:SetPassword(function ()
					slot0:updateOtherPanel()
				end)
			end

			if PlayerPrefs.GetFloat("firstOpenSecondaryPassword") == 0 then
				pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
					type = MSGBOX_TYPE_HELP,
					helps = i18n("secondary_password_help"),
					onYes = slot0,
					onClose = slot0
				})
				PlayerPrefs.SetFloat("firstOpenSecondaryPassword", 1)
				PlayerPrefs.Save()
			else
				slot0()
			end
		end
	end, SFX_UI_TAG)

	slot10 = slot0.findTF(slot0, "limited_operations/options", slot0.otherContent)
	slot11 = slot0:findTF("notify_tpl")
	slot0.secPwdOpts = {}

	for slot15, slot16 in ipairs(slot0()) do
		if table.contains(slot7.LIMITED_OPERATION, slot15) then
			slot17 = cloneTplTo(slot11, slot10)
			slot0.secPwdOpts[slot15] = slot17

			setText(slot0:findTF("Text", slot17), slot16.title)
			onButton(slot0, slot17, function ()
				slot1 = nil

				if not table.contains(slot0.system_list, ) then
					Clone(slot0.system_list)[#Clone(slot0.system_list) + 1] = slot1

					table.sort(Clone(slot0.system_list), function (slot0, slot1)
						return slot0 < slot1
					end)
				elseif slot0 then
					slot2 = Clone(slot0.system_list)

					for slot5 = #slot2, 1, -1 do
						if slot1[slot5] == slot1 then
							table.remove(slot1, slot5)
						end
					end
				end

				slot2:ChangeSetting(slot1, function ()
					slot0:updateOtherPanel()
				end)
			end, SFX_UI_TAG)
		end
	end

	slot0.UpdateAgreementPanel(slot0)
	slot0:updateOtherPanel()
end

slot0.UpdateAgreementPanel = function (slot0)
	setActive(slot0:findTF("agreement", slot0.otherContent), PLATFORM_CODE == PLATFORM_CH)

	if slot2 then
		onButton(slot0, slot1:Find("private"), function ()
			pg.SdkMgr.GetInstance():ShowPrivate()
		end, SFX_PANEL)
		onButton(slot0, slot1:Find("licence"), function ()
			pg.SdkMgr.GetInstance():ShowLicence()
		end, SFX_PANEL)
	end
end

slot0.updateOtherPanel = function (slot0)
	slot1 = slot0:findTF("secondpwd", slot0.otherContent)
	slot2 = slot1:Find("options/close")
	slot3 = slot1:Find("options/open")
	slot4 = pg.SecondaryPWDMgr.GetInstance()

	setActive(slot2:Find("on"), not (getProxy(SecondaryPWDProxy).getRawData(slot5).state > 0))
	setActive(slot2:Find("off"), getProxy(SecondaryPWDProxy).getRawData(slot5).state > 0)
	setActive(slot3:Find("on"), getProxy(SecondaryPWDProxy).getRawData(slot5).state > 0)
	setActive(slot3:Find("off"), not (getProxy(SecondaryPWDProxy).getRawData(slot5).state > 0))

	for slot11, slot12 in pairs(slot0.secPwdOpts) do
		slot13 = table.contains(slot6.system_list, slot11)
		slot12:GetComponent(typeof(Button)).interactable = slot7

		setActive(slot12:Find("on/on_on"), slot13)
		setActive(slot12:Find("off/off_off"), slot13)
		setActive(slot12:Find("on/on_off"), not slot13)
		setActive(slot12:Find("off/off_on"), not slot13)
	end
end

slot0.clearExchangeCode = function (slot0)
	slot0.codeInput:GetComponent(typeof(InputField)).text = ""
end

slot7 = true

slot0.onAddToggleEvent = function (slot0, slot1, slot2, slot3, slot4, slot5)
	pg.DelegateInfo.Add(slot1, slot7)
	GetComponent(slot2, typeof(Toggle)).onValueChanged.AddListener(slot7, function (slot0)
		if slot0 then
			if slot0 and slot1 and slot2.isOn == slot0 then
				slot1 = SFX_UI_TAG

				pg.CriMgr.GetInstance():PlaySoundEffect_V3(pg.CriMgr.GetInstance().PlaySoundEffect_V3)
			elseif not slot0 and slot3 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot3)
			end
		end

		slot4(slot0)
	end)

	if not IsNil(GetComponent(slot2, typeof(UIToggleEvent))) then
		slot8:Rebind()
	end
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backButton, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_CANCEL)
	onButton(slot0, slot0.logoutButton, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("main_settingsScene_quest_exist"),
			onYes = function ()
				slot0:emit(SettingsMediator.ON_LOGOUT)
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.helpUS, function ()
		pg.SdkMgr.GetInstance():OpenYostarHelp()
	end)
	slot0.onAddToggleEvent(slot0, slot0, slot0.otherToggle, function (slot0)
		if slot0 and PlayerPrefs.GetFloat("firstIntoOtherPanel") == 0 then
			setActive(slot1, false)

			slot2 = slot0:findTF("main/other/scroll_view/Viewport/content")

			setAnchoredPosition(slot2, {
				x = slot2.anchoredPosition.x,
				y = -slot0:findTF("secondpwd", slot2).anchoredPosition.y
			})
			PlayerPrefs.SetFloat("firstIntoOtherPanel", 1)
			PlayerPrefs.Save()
		end
	end)

	slot1 = slot0.soundToggle

	if slot0.contextData.toggle and slot0.EnterToggle[slot0.contextData.toggle] then
		slot1 = slot0[slot0.contextData.toggle .. "Toggle"]
	end

	triggerToggle(slot1, true)

	if slot1 == slot0.optionsToggle and slot0.contextData.scroll then
		if slot0._tf:Find("main/options/scroll_view").Find(slot2, "Viewport").Find(slot3, "content"):Find(slot0.contextData.scroll) then
			onDelayTick(function ()
				scrollTo(slot3, nil, 1 - math.clamp(math.abs(slot0.anchoredPosition.y) / (slot0.anchoredPosition.y.rect.height - slot2.rect.height), 0, 1))
			end, 0.05)
		end
	end
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.repairMask) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(GameObject.Find("OverlayCamera/Overlay/UIMain/DialogPanel")) then
		triggerButton(slot1.transform:Find("dialog/title/back"))

		return
	end

	slot0:emit(slot0.ON_BACK)

	if BUTTON_SOUND_EFFECT then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	end
end

slot0.clearCV = function (slot0)
	if slot0._currentVoice then
		slot0._currentVoice:Stop(true)
	end

	slot0._currentVoice = nil

	if slot0._cvList then
		for slot4, slot5 in pairs(slot0._cvList) do
			pg.CriMgr.UnloadCVBank(pg.CriMgr.GetCVBankName(slot4))
			pg.CriMgr.UnloadCVBank(pg.CriMgr.GetBattleCVBankName(slot4))
		end
	end

	slot0._cvList = nil
end

slot0.willExit = function (slot0)
	if slot0.eventTriggers then
		for slot4, slot5 in pairs(slot0.eventTriggers) do
			ClearEventTrigger(slot4)
		end

		slot0.eventTriggers = nil
	end

	slot0:clearCV()
	slot0.soundDownloadTimer:Stop()

	slot0.soundDownloadTimer = nil

	slot0.live2DDownloadTimer:Stop()

	slot0.live2DDownloadTimer = nil

	slot0.galleryDownloadTimer:Stop()

	slot0.galleryDownloadTimer = nil

	slot0.musicDownloadTimer:Stop()

	slot0.musicDownloadTimer = nil
	slot0.userProxy = nil

	slot0.msgBox:Destroy()

	slot0.msgBox = nil
end

slot0.initJPAccountPanel = function (slot0, slot1)
	slot0.userProxy = getProxy(UserProxy)
	slot0.accountTwitterUI = slot0:findTF("page1", slot1)
	slot0.goTranscodeUIBtn = slot0:findTF("bind_account", slot2)
	slot3 = slot0:findTF("btn_layout/twitter_con", slot0.accountTwitterUI)
	slot0.twitterBtn = slot0:findTF("bind_twitter", slot3)
	slot0.twitterUnlinkBtn = slot0:findTF("unlink_twitter", slot3)
	slot0.twitterLinkSign = slot0:findTF("twitter_status", slot3)
	slot4 = slot0:findTF("btn_layout/apple_con", slot0.accountTwitterUI)
	slot0.appleBtn = slot0:findTF("bind_apple", slot4)
	slot0.appleUnlinkBtn = slot0:findTF("unlink_apple", slot4)
	slot0.appleLinkSign = slot0:findTF("apple_status", slot4)

	setActive(slot4, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "1")

	slot5 = slot0:findTF("btn_layout/amazon_con", slot0.accountTwitterUI)
	slot0.amazonBtn = slot0:findTF("bind_amazon", slot5)
	slot0.amazonUnlinkBtn = slot0:findTF("unlink_amazon", slot5)
	slot0.amazonLinkSign = slot0:findTF("amazon_status", slot5)

	setActive(slot5, PLATFORM_CODE == PLATFORM_JP and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	slot0.transcodeUI = slot0:findTF("page2", slot1)
	slot0.uidTxt = slot0:findTF("account_name/Text", slot0.transcodeUI)
	slot0.transcodeTxt = slot0:findTF("password/Text", slot0.transcodeUI)
	slot0.getCodeBtn = slot0:findTF("publish_transcode", slot0.transcodeUI)
	slot0.codeDesc = slot0:findTF("title_desc", slot0.transcodeUI)

	onButton(slot0, slot0.getCodeBtn, function ()
		if slot0.transcode == "" then
			pg.SecondaryPWDMgr.LimitedOperation(slot1, pg.SecondaryPWDMgr.CREATE_INHERIT, nil, function ()
				pg.SdkMgr.GetInstance():TranscodeRequest()
			end)
		end
	end)
	onButton(slot0, slot0.twitterBtn, function ()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(slot0, slot0.twitterUnlinkBtn, function ()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(slot0, slot0.appleBtn, function ()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(slot0, slot0.appleUnlinkBtn, function ()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(slot0, slot0.goTranscodeUIBtn, function ()
		setActive(slot0.accountTwitterUI, false)
		setActive(slot0.transcodeUI, true)
	end)
	slot0.checkAllAccountState(slot0)
end

slot0.checkAllAccountState = function (slot0)
	slot0:checkTranscodeView()
	slot0:checkAccountTwitterView()
	slot0:checkAccountAppleView()
	slot0:checkAccountAmazonView()
end

slot0.showTranscode = function (slot0, slot1)
	slot0.userProxy:saveTranscode(slot1)
	slot0:checkTranscodeView()
end

slot0.checkTranscodeView = function (slot0)
	slot0.transcode = pg.SdkMgr.GetInstance():GetYostarTransCode() or ""

	if not slot0.transcode or slot0.transcode == "" or slot0.transcode == "NULL" then
		slot0.transcode = slot0.userProxy:getTranscode()
	end

	setActive(slot0.codeDesc, slot0.transcode ~= "")
	setActive(slot0.getCodeBtn, slot0.transcode == "")

	if slot0.transcode ~= "" then
		setText(slot0.uidTxt, pg.SdkMgr.GetInstance():GetYostarUid())
		setText(slot0.transcodeTxt, slot0.transcode)
	end
end

slot0.checkAccountTwitterView = function (slot0)
	slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_TWITTER)

	setActive(slot0.twitterUnlinkBtn, slot1)
	setActive(slot0.twitterLinkSign, slot1)
	setActive(slot0.twitterBtn, not slot1)

	if slot1 then
		setText(slot0.twitterLinkSign, i18n("twitter_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_TWITTER)))
	end
end

slot0.checkAccountAppleView = function (slot0)
	slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_APPLE)

	setActive(slot0.appleUnlinkBtn, slot1)
	setActive(slot0.appleLinkSign, slot1)
	setActive(slot0.appleBtn, not slot1)

	if isTwitterLinked then
		setText(slot0.appleLinkSign, i18n("apple_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_APPLE)))
	end
end

slot0.checkAccountAmazonView = function (slot0)
	if pg.SdkMgr.GetInstance():GetChannelUID() == "3" then
		slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_AMAZON)

		setActive(slot0.amazonUnlinkBtn, slot1)
		setActive(slot0.amazonLinkSign, slot1)
		setActive(slot0.amazonBtn, not slot1)

		if isTwitterLinked then
			setText(slot0.amazonLinkSign, i18n("amazon_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_AMAZON)))
		end
	end
end

slot0.initUSAccountPanel = function (slot0, slot1)
	slot3 = slot0:findTF("btn_layout/twitter_con", slot2)
	slot0.btnBindTwitter = slot0:findTF("bind_twitter", slot3)
	slot0.btnUnlinkTwitter = slot0:findTF("unlink_twitter", slot3)
	slot0.twitterStatus = slot0:findTF("twitter_status", slot3)
	slot4 = slot0:findTF("btn_layout/facebook_con", slot2)
	slot0.btnBindFacebook = slot0:findTF("bind_facebook", slot4)
	slot0.btnUnlinkFacebook = slot0:findTF("unlink_facebook", slot4)
	slot0.facebookStatus = slot0:findTF("facebook_status", slot4)

	setActive(slot4, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3")

	slot5 = slot0:findTF("btn_layout/yostar_con", slot2)
	slot0.btnBindYostar = slot0:findTF("bind_yostar", slot5)
	slot0.btnUnlinkYostar = slot0:findTF("unlink_yostar", slot5)
	slot0.yostarStatus = slot0:findTF("yostar_status", slot5)
	slot6 = slot0:findTF("btn_layout/apple_con", slot2)
	slot0.btnBindApple = slot0:findTF("bind_apple", slot6)
	slot0.btnUnlinkApple = slot0:findTF("unlink_apple", slot6)
	slot0.appleStatus = slot0:findTF("apple_status", slot6)

	setActive(slot6, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "1")

	slot7 = slot0:findTF("btn_layout/amazon_con", slot2)
	slot0.btnBindAmazon = slot0:findTF("bind_amazon", slot7)
	slot0.btnUnlinkAmazon = slot0:findTF("unlink_amazon", slot7)
	slot0.amazonStatus = slot0:findTF("amazon_status", slot7)

	setActive(slot7, PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() == "3")

	slot0.yostarAlert = slot0:findTF("page2", slot1)
	slot0.yostarEmailTxt = slot0:findTF("email_input_txt", slot0.yostarAlert)
	slot0.yostarCodeTxt = slot0:findTF("code_input_txt", slot0.yostarAlert)
	slot0.yostarGenCodeBtn = slot0:findTF("gen_code_btn", slot0.yostarAlert)
	slot0.yostarGenTxt = slot0:findTF("Text", slot0.yostarGenCodeBtn)
	slot0.yostarSureBtn = slot0:findTF("login_btn", slot0.yostarAlert)

	onButton(slot0, slot0.btnBindTwitter, function ()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(slot0, slot0.btnUnlinkTwitter, function ()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_TWITTER)
	end)
	onButton(slot0, slot0.btnBindFacebook, function ()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(slot0, slot0.btnUnlinkFacebook, function ()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_FACEBOOK)
	end)
	onButton(slot0, slot0.btnBindApple, function ()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(slot0, slot0.btnUnlinkApple, function ()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_APPLE)
	end)
	onButton(slot0, slot0.btnBindAmazon, function ()
		pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(slot0, slot0.btnUnlinkAmazon, function ()
		pg.SdkMgr.GetInstance():UnlinkSocial(AIRI_PLATFORM_AMAZON)
	end)
	onButton(slot0, slot0.btnBindYostar, function ()
		pg.UIMgr.GetInstance():BlurPanel(slot0.yostarAlert, false)
		setActive(slot0.yostarAlert, true)
	end)
	onButton(slot0, slot0.yostarAlert, function ()
		pg.UIMgr.GetInstance():UnblurPanel(slot0.yostarAlert, slot0.accountUS)
		setActive(slot0.yostarAlert, false)
	end)
	onButton(slot0, slot0.yostarGenCodeBtn, function ()
		if getInputText(slot0.yostarEmailTxt) ~= "" then
			pg.SdkMgr.GetInstance():VerificationCodeReq(slot0)
			slot0:checkAiriGenCodeCounter_US()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip1"))
		end
	end)
	onButton(slot0, slot0.yostarSureBtn, function ()
		slot1 = getInputText(slot0.yostarCodeTxt)

		if getInputText(slot0.yostarEmailTxt) ~= "" and slot1 ~= "" then
			pg.UIMgr.GetInstance():LoadingOn()
			pg.SdkMgr.GetInstance():LinkSocial(AIRI_PLATFORM_YOSTAR, slot0, slot1)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("verification_code_req_tip3"))
		end

		triggerButton(slot0.yostarAlert)
	end)
	slot0.checkAllAccountState_US(slot0)
	slot0:checkAiriGenCodeCounter_US()
end

slot0.checkAllAccountState_US = function (slot0)
	slot0:checkAccountTwitterView_US()
	slot0:checkAccountFacebookView_US()
	slot0:checkAccountAppleView_US()
	slot0:checkAccountYostarView_US()
	slot0:checkAccountAmazonView_US()
end

slot0.checkAccountTwitterView_US = function (slot0)
	slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_TWITTER)

	setActive(slot0.btnUnlinkTwitter, slot1)
	setActive(slot0.twitterStatus, slot1)
	setActive(slot0.btnBindTwitter, not slot1)

	if slot1 then
		setText(slot0.twitterStatus, i18n("twitter_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_TWITTER)))
	end
end

slot0.checkAccountFacebookView_US = function (slot0)
	if PLATFORM_CODE == PLATFORM_US and pg.SdkMgr.GetInstance():GetChannelUID() ~= "3" then
		slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_FACEBOOK)

		setActive(slot0.btnUnlinkFacebook, slot1)
		setActive(slot0.facebookStatus, slot1)
		setActive(slot0.btnBindFacebook, not slot1)

		if slot1 then
			setText(slot0.facebookStatus, i18n("facebook_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_FACEBOOK)))
		end
	end
end

slot0.checkAccountAppleView_US = function (slot0)
	slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_APPLE)

	setActive(slot0.btnUnlinkApple, slot1)
	setActive(slot0.appleStatus, slot1)
	setActive(slot0.btnBindApple, not slot1)

	if slot1 then
		setText(slot0.appleStatus, i18n("apple_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_APPLE)))
	end
end

slot0.checkAccountAmazonView_US = function (slot0)
	if pg.SdkMgr.GetInstance():GetChannelUID() == "3" then
		slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_AMAZON)

		setActive(slot0.btnUnlinkAmazon, slot1)
		setActive(slot0.amazonStatus, slot1)
		setActive(slot0.btnBindAmazon, not slot1)

		if slot1 then
			setText(slot0.amazonStatus, i18n("amazon_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_AMAZON)))
		end
	end
end

slot0.checkAccountYostarView_US = function (slot0)
	slot1 = pg.SdkMgr.GetInstance():IsSocialLink(AIRI_PLATFORM_YOSTAR)

	setActive(slot0.btnUnlinkYostar, slot1)
	setActive(slot0.yostarStatus, slot1)
	setActive(slot0.btnBindYostar, not slot1)

	if slot1 then
		setText(slot0.yostarStatus, i18n("yostar_link_title", pg.SdkMgr.GetInstance():GetSocialName(AIRI_PLATFORM_YOSTAR)))
	end
end

slot0.checkAiriGenCodeCounter_US = function (slot0)
	if GetAiriGenCodeTimeRemain() > 0 then
		setButtonEnabled(slot0.yostarGenCodeBtn, false)

		slot0.genCodeTimer = Timer.New(function ()
			if GetAiriGenCodeTimeRemain() > 0 then
				setText(slot0.yostarGenTxt, "(" .. slot0 .. ")")
			else
				setText(slot0.yostarGenTxt, "Generate")
				slot0:clearAiriGenCodeTimer_US()
			end
		end, 1, -1).Start(slot1)
	end
end

slot0.clearAiriGenCodeTimer_US = function (slot0)
	setButtonEnabled(slot0.yostarGenCodeBtn, true)

	if slot0.genCodeTimer then
		slot0.genCodeTimer:Stop()

		slot0.genCodeTimer = nil
	end
end

slot0.initKrHelp = function (slot0)
	onButton(slot0, slot0:findTF("blur_panel/adapt/left_length/helpBtn"), function ()
		print("help:")
		pg.SdkMgr.GetInstance():BugReport()
	end, SFX_CANCEL)
end

slot0.UpdateTwAccountPanel = function (slot0)
	if PLATFORM == PLATFORM_ANDROID then
		setActive(slot0.accountTw:Find("page1/bind_google"), true)
		setActive(slot0.accountTw:Find("page1/bind_gamecenter"), false)
	else
		setActive(slot0.accountTw:Find("page1/bind_google"), true)
		setActive(slot0.accountTw:Find("page1/bind_gamecenter"), false)
	end

	slot2 = pg.SdkMgr.GetInstance()
	slot7 = {
		slot2:IsBindFaceBook(),
		slot2:IsBindGoogle(),
		slot2:IsBindPhone(),
		slot2:IsBindGameCenter()
	}

	for slot11, slot12 in ipairs(slot1) do
		setActive(slot12:Find("unbind"), not slot7[slot11])
		setActive(slot12:Find("bind"), slot13)
		onButton(slot0, slot12, function ()
			if not slot0 then
				slot1:BindSocial(slot2)
			end
		end, SFX_PANEL)
	end
end

return slot0

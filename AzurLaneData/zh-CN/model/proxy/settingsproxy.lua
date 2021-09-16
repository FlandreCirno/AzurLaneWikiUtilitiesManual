slot0 = class("SettingsProxy", pm.Proxy)

slot0.onRegister = function (slot0)
	slot0._isBgmEnble = PlayerPrefs.GetInt("ShipSkinBGM", 1) > 0
	slot0._ShowBg = PlayerPrefs.GetInt("disableBG", 1) > 0
	slot0._ShowLive2d = PlayerPrefs.GetInt("disableLive2d", 1) > 0
	slot0._selectedShipId = PlayerPrefs.GetInt("playerShipId")
	slot0._backyardFoodRemind = PlayerPrefs.GetString("backyardRemind")
	slot0._userAgreement = PlayerPrefs.GetInt("userAgreement", 0)
	slot0._showMaxLevelHelp = PlayerPrefs.GetInt("maxLevelHelp", 0) > 0
	slot0._nextTipAutoBattleTime = PlayerPrefs.GetInt("AutoBattleTip", 0)
	slot0._setFlagShip = PlayerPrefs.GetInt("setFlagShip", 0) > 0
	slot0._screenRatio = PlayerPrefs.GetFloat("SetScreenRatio", ADAPT_TARGET)
	slot0.storyAutoPlayCode = PlayerPrefs.GetInt("story_autoplay_flag", 0)
	NotchAdapt.CheckNotchRatio = slot0._screenRatio
	slot0.nextTipActBossExchangeTicket = nil

	slot0:resetEquipSceneIndex()

	slot0._isShowCollectionHelp = PlayerPrefs.GetInt("collection_Help", 0) > 0
	slot0.showMainSceneWordTip = PlayerPrefs.GetInt("main_scene_word_toggle", 1) > 0
	slot0.lastRequestVersionTime = nil
	slot0.worldBossFlag = {}
	slot0.worldFlag = {}
end

slot0.SetWorldBossFlag = function (slot0, slot1, slot2)
	if slot0.worldBossFlag[slot1] ~= slot2 then
		slot0.worldBossFlag[slot1] = slot2

		PlayerPrefs.SetInt("worldBossFlag" .. slot1, (slot2 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.GetWorldBossFlag = function (slot0, slot1)
	if not slot0.worldBossFlag[slot1] then
		slot0.worldBossFlag[slot1] = PlayerPrefs.GetInt("worldBossFlag" .. slot1, 1) > 0
	end

	return slot0.worldBossFlag[slot1]
end

slot0.SetWorldFlag = function (slot0, slot1, slot2)
	if slot0.worldFlag[slot1] ~= slot2 then
		slot0.worldFlag[slot1] = slot2

		PlayerPrefs.SetInt("world_flag_" .. slot1, (slot2 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.GetWorldFlag = function (slot0, slot1, slot2)
	if not slot0.worldFlag[slot1] then
		slot0.worldFlag[slot1] = PlayerPrefs.GetInt("world_flag_" .. slot1) > 0
	end

	return slot0.worldFlag[slot1]
end

slot0.Reset = function (slot0)
	slot0:resetEquipSceneIndex()
	slot0:resetActivityLayerIndex()

	slot0.isStopBuildSpeedupReamind = false

	slot0:RestoreFrameRate()
end

slot0.GetDockYardLockBtnFlag = function (slot0)
	if not slot0.dockYardLockFlag then
		slot0.dockYardLockFlag = PlayerPrefs.GetInt("DockYardLockFlag" .. slot1, 0) > 0
	end

	return slot0.dockYardLockFlag
end

slot0.SetDockYardLockBtnFlag = function (slot0, slot1)
	if slot0.dockYardLockFlag ~= slot1 then
		PlayerPrefs.SetInt("DockYardLockFlag" .. getProxy(PlayerProxy):getRawData().id, (slot1 and 1) or 0)
		PlayerPrefs.Save()

		slot0.dockYardLockFlag = slot1
	end
end

slot0.GetDockYardLevelBtnFlag = function (slot0)
	if not slot0.dockYardLevelFlag then
		slot0.dockYardLevelFlag = PlayerPrefs.GetInt("DockYardLevelFlag" .. slot1, 0) > 0
	end

	return slot0.dockYardLevelFlag
end

slot0.SetDockYardLevelBtnFlag = function (slot0, slot1)
	if slot0.dockYardLevelFlag ~= slot1 then
		PlayerPrefs.SetInt("DockYardLevelFlag" .. getProxy(PlayerProxy):getRawData().id, (slot1 and 1) or 0)
		PlayerPrefs.Save()

		slot0.dockYardLevelFlag = slot1
	end
end

slot0.IsShowCollectionHelp = function (slot0)
	return slot0._isShowCollectionHelp
end

slot0.SetCollectionHelpFlag = function (slot0, slot1)
	if slot0._isShowCollectionHelp ~= slot1 then
		slot0._isShowCollectionHelp = slot1

		PlayerPrefs.SetInt("collection_Help", (slot1 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.IsBGMEnable = function (slot0)
	return slot0._isBgmEnble
end

slot0.SetBgmFlag = function (slot0, slot1)
	if slot0._isBgmEnble ~= slot1 then
		slot0._isBgmEnble = slot1

		PlayerPrefs.SetInt("ShipSkinBGM", (slot1 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.getSkinPosSetting = function (slot0, slot1)
	if PlayerPrefs.HasKey(tostring(slot1) .. "_scale") then
		return PlayerPrefs.GetFloat(tostring(slot1) .. "_x", 0), PlayerPrefs.GetFloat(tostring(slot1) .. "_y", 0), PlayerPrefs.GetFloat(tostring(slot1) .. "_scale", 1)
	else
		return nil
	end
end

slot0.setSkinPosSetting = function (slot0, slot1, slot2, slot3, slot4)
	PlayerPrefs.SetFloat(tostring(slot1) .. "_x", slot2)
	PlayerPrefs.SetFloat(tostring(slot1) .. "_y", slot3)
	PlayerPrefs.SetFloat(tostring(slot1) .. "_scale", slot4)
	PlayerPrefs.Save()
end

slot0.resetSkinPosSetting = function (slot0, slot1)
	PlayerPrefs.DeleteKey(tostring(slot1) .. "_x")
	PlayerPrefs.DeleteKey(tostring(slot1) .. "_y")
	PlayerPrefs.DeleteKey(tostring(slot1) .. "_scale")
	PlayerPrefs.Save()
end

slot0.getCharacterSetting = function (slot0, slot1, slot2)
	return PlayerPrefs.GetInt(tostring(slot1) .. "_" .. slot2, 1) > 0
end

slot0.setCharacterSetting = function (slot0, slot1, slot2, slot3)
	PlayerPrefs.SetInt(tostring(slot1) .. "_" .. slot2, (slot3 and 1) or 0)
	PlayerPrefs.Save()
end

slot0.getCurrentSecretaryIndex = function (slot0)
	if PlayerPrefs.GetInt("currentSecretaryIndex", 1) > #getProxy(PlayerProxy):getData().characters then
		slot0:setCurrentSecretaryIndex(1)

		return 1
	else
		return slot1
	end
end

slot0.rotateCurrentSecretaryIndex = function (slot0)
	if #getProxy(PlayerProxy):getData().characters < PlayerPrefs.GetInt("currentSecretaryIndex", 1) + 1 then
		slot1 = 1
	end

	slot0:setCurrentSecretaryIndex(slot1)

	return slot1
end

slot0.setCurrentSecretaryIndex = function (slot0, slot1)
	PlayerPrefs.SetInt("currentSecretaryIndex", slot1)
	PlayerPrefs.Save()
end

slot0.SetFlagShip = function (slot0, slot1)
	if slot0._setFlagShip ~= slot1 then
		slot0._setFlagShip = slot1

		PlayerPrefs.SetInt("setFlagShip", (slot1 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.GetSetFlagShip = function (slot0)
	return slot0._setFlagShip
end

slot0.CheckNeedUserAgreement = function (slot0)
	if PLATFORM_CODE == PLATFORM_KR then
		return false
	elseif PLATFORM_CODE == PLATFORM_CH then
		return false
	else
		return slot0._userAgreement < slot0:GetUserAgreementFlag()
	end
end

slot0.GetUserAgreementFlag = function (slot0)
	slot1 = USER_AGREEMENT_FLAG_DEFAULT

	if PLATFORM_CODE == PLATFORM_CHT then
		slot1 = USER_AGREEMENT_FLAG_TW
	end

	return slot1
end

slot0.SetUserAgreement = function (slot0)
	if slot0:CheckNeedUserAgreement() then
		PlayerPrefs.SetInt("userAgreement", slot0:GetUserAgreementFlag())
		PlayerPrefs.Save()

		slot0._userAgreement = slot0.GetUserAgreementFlag()
	end
end

slot0.IsLive2dEnable = function (slot0)
	return slot0._ShowLive2d
end

slot0.IsBGEnable = function (slot0)
	return slot0._ShowBg
end

slot0.SetSelectedShipId = function (slot0, slot1)
	if slot0._selectedShipId ~= slot1 then
		slot0._selectedShipId = slot1

		PlayerPrefs.SetInt("playerShipId", slot1)
		PlayerPrefs.Save()
	end
end

slot0.GetSelectedShipId = function (slot0)
	return slot0._selectedShipId
end

slot0.setEquipSceneIndex = function (slot0, slot1)
	slot0._equipSceneIndex = slot1
end

slot0.getEquipSceneIndex = function (slot0)
	return slot0._equipSceneIndex
end

slot0.resetEquipSceneIndex = function (slot0)
	slot0._equipSceneIndex = StoreHouseConst.WARP_TO_MATERIAL
end

slot0.setActivityLayerIndex = function (slot0, slot1)
	slot0._activityLayerIndex = slot1
end

slot0.getActivityLayerIndex = function (slot0)
	return slot0._activityLayerIndex
end

slot0.resetActivityLayerIndex = function (slot0)
	slot0._activityLayerIndex = 1
end

slot0.setBackyardRemind = function (slot0)
	if slot0._backyardFoodRemind ~= tostring(GetZeroTime()) then
		PlayerPrefs.SetString("backyardRemind", slot1)
		PlayerPrefs.Save()

		slot0._backyardFoodRemind = slot1
	end
end

slot0.getBackyardRemind = function (slot0)
	if not slot0._backyardFoodRemind or slot0._backyardFoodRemind == "" then
		return 0
	else
		return tonumber(slot0._backyardFoodRemind)
	end
end

slot0.getMaxLevelHelp = function (slot0)
	return slot0._showMaxLevelHelp
end

slot0.setMaxLevelHelp = function (slot0, slot1)
	if slot0._showMaxLevelHelp ~= slot1 then
		slot0._showMaxLevelHelp = slot1

		PlayerPrefs.SetInt("maxLevelHelp", (slot1 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.setStopBuildSpeedupRemind = function (slot0)
	slot0.isStopBuildSpeedupReamind = true
end

slot0.getStopBuildSpeedupRemind = function (slot0)
	return slot0.isStopBuildSpeedupReamind
end

slot0.checkReadHelp = function (slot0, slot1)
	if not getProxy(PlayerProxy):getData() then
		return true
	end

	if slot1 == "help_backyard" then
		return true
	elseif pg.SeriesGuideMgr.GetInstance():isEnd() then
		slot4 = PlayerPrefs.GetInt(slot1, 0)

		return PlayerPrefs.GetInt(slot1, 0) > 0
	end

	return true
end

slot0.recordReadHelp = function (slot0, slot1)
	PlayerPrefs.SetInt(slot1, 1)
	PlayerPrefs.Save()
end

slot0.clearAllReadHelp = function (slot0)
	PlayerPrefs.DeleteKey("tactics_lesson_system_introduce")
	PlayerPrefs.DeleteKey("help_shipinfo_equip")
	PlayerPrefs.DeleteKey("help_shipinfo_detail")
	PlayerPrefs.DeleteKey("help_shipinfo_intensify")
	PlayerPrefs.DeleteKey("help_shipinfo_upgrate")
	PlayerPrefs.DeleteKey("help_backyard")
	PlayerPrefs.DeleteKey("has_entered_class")
	PlayerPrefs.DeleteKey("help_commander_info")
	PlayerPrefs.DeleteKey("help_commander_play")
	PlayerPrefs.DeleteKey("help_commander_ability")
end

slot0.setAutoBattleTip = function (slot0)
	slot0._nextTipAutoBattleTime = GetZeroTime()

	PlayerPrefs.SetInt("AutoBattleTip", GetZeroTime())
	PlayerPrefs.Save()
end

slot0.isTipAutoBattle = function (slot0)
	return slot0._nextTipAutoBattleTime < pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.setActBossExchangeTicketTip = function (slot0, slot1)
	slot0.nextTipActBossExchangeTicket = slot1
end

slot0.isTipActBossExchangeTicket = function (slot0)
	return slot0.nextTipActBossExchangeTicket
end

slot0.SetScreenRatio = function (slot0, slot1)
	if slot0._screenRatio ~= slot1 then
		slot0._screenRatio = slot1

		PlayerPrefs.SetFloat("SetScreenRatio", slot1)
		PlayerPrefs.Save()
	end
end

slot0.GetScreenRatio = function (slot0)
	return slot0._screenRatio
end

slot0.CheckLargeScreen = function (slot0)
	return Screen.width / Screen.height > 2
end

slot0.IsShowBeatMonseterNianCurtain = function (slot0)
	return tonumber(PlayerPrefs.GetString("HitMonsterNianLayer2020" .. getProxy(PlayerProxy):getRawData().id, "0")) < pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.SetBeatMonseterNianFlag = function (slot0)
	PlayerPrefs.SetString("HitMonsterNianLayer2020" .. getProxy(PlayerProxy):getRawData().id, GetZeroTime())
	PlayerPrefs.Save()
end

slot0.ShouldShowEventActHelp = function (slot0)
	if not slot0.actEventFlag then
		slot0.actEventFlag = PlayerPrefs.GetInt("event_act_help1" .. slot1, 0) > 0
	end

	return not slot0.actEventFlag
end

slot0.MarkEventActHelpFlag = function (slot0)
	if not slot0.actEventFlag then
		slot0.actEventFlag = true

		PlayerPrefs.SetInt("event_act_help1" .. slot1, 1)
		PlayerPrefs.Save()
	end
end

slot0.SetStorySpeed = function (slot0, slot1)
	slot0.storySpeed = slot1
	slot2 = nil

	PlayerPrefs.SetInt("story_speed_flag" .. ((not getProxy(PlayerProxy) or getProxy(PlayerProxy):getRawData().id) and 1), slot1)
	PlayerPrefs.Save()
end

slot0.GetStorySpeed = function (slot0)
	if not slot0.storySpeed then
		slot1 = nil
		slot0.storySpeed = PlayerPrefs.GetInt("story_speed_flag" .. ((not getProxy(PlayerProxy) or getProxy(PlayerProxy):getRawData().id) and 1), 0)
	end

	return slot0.storySpeed
end

slot0.GetStoryAutoPlayFlag = function (slot0)
	return slot0.storyAutoPlayCode > 0
end

slot0.SetStoryAutoPlayFlag = function (slot0, slot1)
	if slot0.storyAutoPlayCode ~= slot1 then
		PlayerPrefs.SetInt("story_autoplay_flag", slot1)
		PlayerPrefs.Save()

		slot0.storyAutoPlayCode = slot1
	end
end

slot0.ShouldShipMainSceneWord = function (slot0)
	return slot0.showMainSceneWordTip
end

slot0.SaveMainSceneWordFlag = function (slot0, slot1)
	if slot0.showMainSceneWordTip ~= slot1 then
		slot0.showMainSceneWordTip = slot1

		PlayerPrefs.SetInt("main_scene_word_toggle", (slot1 and 1) or 0)
		PlayerPrefs.Save()
	end
end

slot0.RecordFrameRate = function (slot0)
	if not slot0.originalFrameRate then
		slot0.originalFrameRate = Application.targetFrameRate
	end
end

slot0.RestoreFrameRate = function (slot0)
	if slot0.originalFrameRate then
		Application.targetFrameRate = slot0.originalFrameRate
		slot0.originalFrameRate = nil
	end
end

return slot0

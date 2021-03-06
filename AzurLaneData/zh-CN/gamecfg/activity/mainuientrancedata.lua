return {
	{
		Tip = "tip_1920",
		Image = "event_all",
		ButtonName = "activityButton"
	},
	{
		forceRefreshImage = true,
		ButtonName = "activity_map_btn",
		Image = function ()
			return (getProxy(ActivityProxy):GetEarliestActByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT) and not slot0:isEnd() and LoadSprite("ui/mainui_atlas", "event_map_" .. slot0.id)) or LoadSprite("ui/mainui_atlas", "event_map")
		end,
		UpdateButton = function (slot0, slot1)
			setActive(slot1, _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT), function (slot0)
				return not slot0:isEnd()
			end) and not slot3.isEnd(slot3))

			if _.detect(getProxy(ActivityProxy).getActivitiesByType(ActivityConst.ACTIVITY_TYPE_ZPROJECT), function (slot0)
				return not slot0.isEnd()
			end) and not slot3.isEnd(slot3) then
				onButton(slot0, slot1, function ()
					slot0:emit(MainUIMediator.ON_ACTIVITY_MAP, slot1.id)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_newyear",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(ActivityConst.NEWYEAR_SNACKSTREET_MINIGAME) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityById(ActivityConst.NEWYEAR_SNACKSTREET_MINIGAME) and not slot2.isEnd() then
				setActive(slot1:Find("Tip"), BackHillTemplate.IsMiniActNeedTip(ActivityConst.NEWYEAR_SNOWBALL_FIGHT) or NewYearSnackPage.IsTip() or NewYearShrineView.IsNeedShowTipWithoutActivityFinalReward())
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.NEWYEAR_BACKHILL)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tip = "tip",
		Image = "event_escort",
		ButtonName = "activity_escort",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ChapterProxy).getMaxEscortChallengeTimes(slot2) > 0)

			if slot3 > 0 then
				setActive(slot1:Find("Tip"), slot2.escortChallengeTimes < slot3)
				onButton(slot0, slot1, function ()
					slot0:emit(MainUIMediator.OPEN_ESCORT)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tip = "tip",
		Image = "event_boss",
		ButtonName = "activity_boss",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2) and not slot2.isEnd() then
				slot4 = false
				slot5 = false

				if pg.activity_event_worldboss[slot2:getConfig("config_id")] then
					slot5 = slot7.time ~= "stop" and pg.TimeMgr.GetInstance():parseTimeFromConfig(slot7.time[2]) and pg.TimeMgr.GetInstance():GetServerTime() <= (slot7.time ~= "stop" and pg.TimeMgr.GetInstance().parseTimeFromConfig(slot7.time[2]))
					slot5 = not slot5
				end

				if not slot5 then
					slot4 = slot2.data2 ~= 1
				elseif getProxy(ActivityProxy):getActivityById(ActivityConst.ACTIVITY_BOSS_PT_ID) then
					slot4 = ActivityBossPtData.New(slot8):CanGetAward()
				end

				setActive(slot1:Find("Tip"), slot4)
				onButton(slot0, slot1, function ()
					slot0:emit(MainUIMediator.GO_SCENE, {
						SCENE.ACT_BOSS_BATTLE,
						{
							showAni = true
						}
					})
				end, SFX_PANEL)
			end
		end
	},
	{
		ButtonName = "activity_ins",
		CtorButton = function (slot0, slot1)
			GetOrAddComponent(LayoutElement).ignoreLayout = true
			slot1.anchoredPosition = Vector2(104, -752.5)
		end,
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM) and not slot2.isEnd() then
				slot1:Find("icon"):GetComponent(typeof(Animator)).enabled = getProxy(InstagramProxy):ShouldShowTip()

				setActive(slot1:Find("Tip"), slot4)
				onButton(slot0, slot1, function ()
					slot0:emit(MainUIMediator.OPEN_INS)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_springfestival",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME) and not slot2.isEnd() then
				slot6 = getProxy(ActivityProxy)
				slot7 = getProxy(MiniGameProxy)
				slot5 = slot6:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
				slot5 = slot6:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME)

				setActive(slot1:Find("Tip"), nil or getProxy(ColoringProxy):CheckTodayTip() or RedPacketLayer.isShowRedPoint() or (slot5 and not slot5:isEnd() and slot5:readyToAchieve()) or (slot5 and not slot5:isEnd() and slot5:readyToAchieve()))
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SPRING_TOWN)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_LanternFestival",
		ButtonName = "activity_LanternFestival",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(ActivityConst.LANTERNFESTIVAL) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityById(ActivityConst.LANTERNFESTIVAL) and not slot2.isEnd() then
				setActive(slot1:Find("Tip"), getProxy(MiniGameProxy).GetHubByHubId(slot4, slot2:getConfig("config_id")).count > 0 and slot5.usedtime < 7)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_MINI_GAME, 22)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_musicfestival",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityById(ActivityConst.MUSIC_FESTIVAL_ID) and not slot2.isEnd() then
				slot6 = getProxy(ActivityProxy)

				function slot7()
					return getProxy(InstagramProxy):ShouldShowTip()
				end

				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MUSIC_FESTIVAL)
				end, SFX_PANEL)
				setActive(slot1:Find("Tip"), IdolPTPage.NeedTip() or IdolMedalCollectionMediator.isHaveActivableMedal() or slot7() or function ()
					if slot0:getActivityById(ActivityConst.MUSIC_FESTIVAL_ID) and not slot0:isEnd() then
						return slot0:readyToAchieve()
					end
				end() or function ()
					return slot0:getActivityById(ActivityConst.MUSIC_CHUIXUE7DAY_ID) and not slot0:isEnd() and slot0:readyToAchieve()
				end() or function ()
					return getProxy(MiniGameProxy).GetHubByHubId(slot0, 2).count > 0
				end())

				return
			end

			setActive(slot1, getProxy(ActivityProxy):getActivityById(ActivityConst.IDOL_MEDAL_COLLECTION) and not slot4:isEnd())

			if getProxy(ActivityProxy).getActivityById(ActivityConst.IDOL_MEDAL_COLLECTION) and not slot4.isEnd() then
				setActive(slot1:Find("Tip"), slot5)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.IDOL_MEDAL_COLLECTION_SCENE)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tip = "tip",
		Image = "event_LanternFestival",
		ButtonName = "activity_actpool",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_LOTTERY) and not slot2.isEnd() then
				slot4 = slot2:getAwardInfos()

				setActive(slot1.Find(slot1, "Tip"), slot6)
				onButton(slot0, slot1, function ()
					slot0:emit(MainUIMediator.ON_LOTTERY, slot1.id)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "main_decodegame",
		ButtonName = "activity_decode",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME), function (slot0)
				return slot0:getConfig("config_id") == 7
			end) and not slot3.isEnd(slot3))

			if _.detect(getProxy(ActivityProxy).getActivitiesByType(ActivityConst.ACTIVITY_TYPE_MINIGAME), function (slot0)
				return slot0.getConfig("config_id") == 7
			end) and not slot3.isEnd(slot3) then
				setActive(slot1:Find("Tip"), getProxy(MiniGameProxy).GetHubByHubId(slot5, slot3:getConfig("config_id")).count > 0)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.REQUEST_MINI_GAME, {
						type = MiniGameRequestCommand.REQUEST_HUB_DATA,
						callback = function ()
							pg.m02:sendNotification(GAME.GO_MINI_GAME, 11)
						end
					})
				end, SFX_PANEL)
			end
		end
	},
	{
		Tip = "tip",
		Image = "event_aprilFool",
		ButtonName = "activity_aprilFool",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot2.isEnd() then
				slot4 = pg.activity_event_picturepuzzle[slot2.id]

				setActive(slot1:Find("Tip"), slot5)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
						id = slot0.id
					})
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_thirdAnniversary",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF) and not slot2.isEnd() then
				setActive(slot1:Find("Tip"), slot2:readyToAchieve() or getProxy(MiniGameProxy):GetHubByHubId(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME):getConfig("config_id")).count > 0)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.THIRD_ANNIVERSARY_AKIBA)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_musicfestival2",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2) and not slot2.isEnd() then
				slot4 = getProxy(ActivityProxy)

				function slot5()
					return slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF) and not slot0:isEnd() and slot0:readyToAchieve()
				end

				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.MUSIC_FESTIVAL2)
				end, SFX_PANEL)
				setActive(slot1:Find("Tip"), slot5() or IdolMedalCollectionMediator.isHaveActivableMedal() or function ()
					slot0 = getProxy(MiniGameProxy):GetHubByHubId(slot0:getConfig("config_id"))

					return slot0:getConfig("reward_need") <= slot0.usedtime and slot0.ultimate == 0
				end() or function ()
					return getProxy(MiniGameProxy):GetHubByHubId(slot0:getConfig("config_id")).count > 0
				end())

				return
			end

			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot4:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot4.isEnd() then
				setActive(slot1:Find("Tip"), slot5)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.IDOL_MEDAL_COLLECTION_SCENE2)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_DOALink",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME) and not slot2.isEnd() then
				slot4 = getProxy(ActivityProxy)

				function slot5()
					return slot0:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF) and not slot0:isEnd() and slot0:readyToAchieve()
				end

				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DOALINK_ISLAND)
				end, SFX_PANEL)
				setActive(slot1:Find("Tip"), slot5() or DoaMedalCollectionView.isHaveActivableMedal() or function ()
					slot0 = getProxy(MiniGameProxy):GetHubByHubId(slot0:getConfig("config_id"))

					return slot0:getConfig("reward_need") <= slot0.usedtime and slot0.ultimate == 0
				end() or function ()
					return getProxy(MiniGameProxy):GetHubByHubId(slot0:getConfig("config_id")).count > 0
				end())

				return
			end

			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot4:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot4.isEnd() then
				setActive(slot1:Find("Tip"), slot5)
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.DOA_MEDAL_COLLECTION_SCENE)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_fourthAnniversary",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF) and not slot2.isEnd() then
				function slot5()
					return getProxy(MiniGameProxy).GetHubByHubId(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME):getConfig("config_id")).count > 0
				end

				setActive(slot1:Find("Tip"), slot2:readyToAchieve() or slot5() or AmusementParkShopPage.GetActivityShopTip())
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.AMUSEMENT_PARK)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_IMasLink",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(pg.activity_const.IDOL_MASTER_CHAPTER_ID.act_id) and not slot3:isEnd())

			if getProxy(ActivityProxy).getActivityById(pg.activity_const.IDOL_MASTER_CHAPTER_ID.act_id) and not slot3.isEnd() then
				function slot5()
					return slot0:getActivityById(ActivityConst.IDOL_MASTER_PT_ID) and not slot0:isEnd() and slot0:readyToAchieve()
				end

				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_MINI_GAME, 28)
				end, SFX_PANEL)
				setActive(slot1:Find("Tip"), slot5() or IdolMasterMedalCollectionMediator.isHaveActivableMedal() or function ()
					slot0 = getProxy(MiniGameProxy):GetHubByHubId(slot0:getConfig("config_id"))

					return slot0:getConfig("reward_need") <= slot0.usedtime and slot0.ultimate == 0
				end() or function ()
					return getProxy(MiniGameProxy):GetHubByHubId(slot0:getConfig("config_id")).count > 0
				end())
			else
				setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot5:isEnd())

				if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLA) and not slot5.isEnd() then
					setActive(slot1:Find("Tip"), slot6)
					onButton(slot0, slot1, function ()
						pg.m02:sendNotification(GAME.GO_SCENE, SCENE.IDOLMASTER_MEDAL_COLLECTION_SCENE)
					end, SFX_PANEL)
				end
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_rop_game",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(pg.activity_const.ROP_COW_ID.act_id) and not slot3:isEnd())

			if getProxy(ActivityProxy).getActivityById(pg.activity_const.ROP_COW_ID.act_id) and not slot3.isEnd() then
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_MINI_GAME, 28)
				end, SFX_PANEL)

				slot6 = (getProxy(MiniGameProxy).GetHubByGameId(slot5, 28).count and slot5.count > 0) or false

				if slot5.ultimate == 0 and slot5.usedtime == slot5:getConfig("reward_need") then
					slot6 = true
				end

				setActive(slot1:Find("Tip"), slot6)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_minigame",
		ButtonName = "activity_JPfourthAnniversary",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF) and not slot2:isEnd())

			if getProxy(ActivityProxy).getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF) and not slot2.isEnd() then
				function slot5()
					return getProxy(MiniGameProxy).GetHubByHubId(slot1, getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME):getConfig("config_id")).count > 0
				end

				setActive(slot1:Find("Tip"), slot2:readyToAchieve() or slot5())
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.AMUSEMENT_PARK2)
				end, SFX_PANEL)
			end
		end
	},
	{
		Tag = "MiniGameHub",
		Image = "event_us",
		ButtonName = "activity_catch_game",
		Tip = "tip",
		UpdateButton = function (slot0, slot1)
			setActive(slot1, getProxy(ActivityProxy):getActivityById(pg.activity_const.CATCH_TREASURE_ID.act_id) and not slot3:isEnd() and PLATFORM_CODE == PLATFORM_US)

			if getProxy(ActivityProxy).getActivityById(pg.activity_const.CATCH_TREASURE_ID.act_id) and not slot3.isEnd() and PLATFORM_CODE == PLATFORM_US then
				onButton(slot0, slot1, function ()
					pg.m02:sendNotification(GAME.GO_MINI_GAME, 30)
				end, SFX_PANEL)

				slot6 = (getProxy(MiniGameProxy).GetHubByGameId(slot5, 30).count and slot5.count > 0) or false

				if slot5.ultimate == 0 and slot5.usedtime == slot5:getConfig("reward_need") then
					slot6 = true
				end

				setActive(slot1:Find("Tip"), slot6)
			end
		end
	},
	LayoutProperty = {
		CellSize = Vector2(208, 215),
		Spacing = Vector2(0, -20),
		Padding = {
			0,
			0,
			-20,
			0
		},
		CellScale = Vector3(0.9, 0.9, 1)
	},
	CurrentEntrancesList = {
		1,
		2,
		4,
		6,
		19
	}
}

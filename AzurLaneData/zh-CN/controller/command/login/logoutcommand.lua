class("LogoutCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if PLATFORM_CHT == PLATFORM_CODE and slot2.code ~= SDK_EXIT_CODE then
		pg.SdkMgr.GetInstance():LogoutSDK()

		return
	end

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_ROLE_LOGOUT)

	if ys.Battle.BattleState.GetInstance().GetState(slot3) ~= ys.Battle.BattleState.BATTLE_STATE_IDLE then
		warning("stop and clean battle.")
		slot3:Stop("kick")
	end

	slot0:sendNotification(GAME.STOP_BATTLE_LOADING, {})
	pg.NewStoryMgr:GetInstance():Quit()

	if pg.MsgboxMgr.GetInstance()._go.activeSelf then
		pg.MsgboxMgr.GetInstance():hide()
	end

	getProxy(SettingsProxy).Reset(slot5)
	print("disconnect from server...-" .. tostring(slot2.code))
	pg.ConnectionMgr.GetInstance():Disconnect()

	BillboardMediator.time = nil
	Map.lastMap = nil
	Map.lastMapForActivity = nil
	BuildShipScene.Page = nil
	BuildShipScene.projectName = nil
	DockyardScene.selectedSort = nil
	DockyardScene.selectAsc = nil
	DockyardScene.indexFlag = nil
	DockyardScene.indexFlag2 = nil
	DockyardScene.indexFlag3 = nil
	DockyardScene.indexFlag4 = nil
	LevelMediator2.prevRefreshBossTimeTime = nil
	ActivityMainScene.FetchReturnersTime = nil
	ActivityMainScene.Data2Time = nil

	pg.BrightnessMgr.GetInstance():ExitManualMode()
	pg.SeriesGuideMgr.GetInstance():dispose()
	pg.GuideMgr.GetInstance():endGuider()
	PoolMgr.GetInstance():DestroyAllPrefab()
	pg.GuildMsgBoxMgr.GetInstance():Hide()

	if getProxy(UserProxy) then
		if slot6:getRawData() then
			slot7:clear()
		end

		slot6:SetLoginedFlag(false)
	end

	slot0.sendNotification(slot0, GAME.LOAD_SCENE, {
		context = Context.New({
			cleanStack = true,
			scene = SCENE.LOGIN,
			mediator = LoginMediator,
			viewComponent = LoginScene,
			data = slot2
		}),
		callback = function ()
			slot0.facade:removeProxy(PlayerProxy.__cname)
			slot0.facade.removeProxy.facade:removeProxy(BayProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade:removeProxy(FleetProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(EquipmentProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ChapterProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(WorldProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(BagProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(TaskProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(MailProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(NavalAcademyProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(DormProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ChatProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(FriendProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(NotificationProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(BuildShipProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(CollectionProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(EventProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ActivityProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(MilitaryExerciseProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ServerNoticeProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(DailyLevelProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ShopsProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(GuildProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(VoteProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ChallengeProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ColoringProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(AnswerProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(TechnologyProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(BillboardProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(TechnologyNationProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(AttireProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(ShipSkinProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(PrayProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(SecondaryPWDProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(SkirmishProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(InstagramProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(MiniGameProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(EmojiProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(AppreciateProxy.__cname)
			slot0.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade.removeProxy.facade:removeProxy(MetaCharacterProxy.__cname)
		end
	})

	if slot2.code ~= SDK_EXIT_CODE then
		pg.SdkMgr.GetInstance():LogoutSDK(slot2.code)
	end
end

return class("LogoutCommand", pm.SimpleCommand)

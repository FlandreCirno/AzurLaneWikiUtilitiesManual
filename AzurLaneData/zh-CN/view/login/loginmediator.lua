slot0 = class("LoginMediator", import("..base.ContextMediator"))
slot0.ON_LOGIN = "LoginMediator:ON_LOGIN"
slot0.ON_REGISTER = "LoginMediator:ON_REGISTER"
slot0.ON_SERVER = "LoginMediator:ON_SERVER"
slot0.ON_LOGIN_PROCESS = "LoginMediator:ON_LOGIN_PROCESS"
slot0.ON_SEARCH_ACCOUNT = "LoginMediator:ON_SEARCH_ACCOUNT"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_LOGIN, function (slot0, slot1)
		slot0:sendNotification(GAME.USER_LOGIN, slot1)
	end)
	slot0.bind(slot0, slot0.ON_REGISTER, function (slot0, slot1)
		slot0:sendNotification(GAME.USER_REGISTER, slot1)
	end)
	slot0.bind(slot0, slot0.ON_SERVER, function (slot0, slot1)
		slot0:sendNotification(GAME.SERVER_LOGIN, slot1)
	end)
	slot0.bind(slot0, slot0.ON_LOGIN_PROCESS, function (slot0)
		slot0:loginProcessHandler()
	end)
	slot0.bind(slot0, slot0.ON_SEARCH_ACCOUNT, function (slot0, slot1)
		slot0:sendNotification(GAME.ACCOUNT_SEARCH, slot1)
	end)
	slot0.loginProcessHandler(slot0)
end

slot0.loginProcessHandler = function (slot0)
	slot1 = getProxy(SettingsProxy)
	slot2 = pg.SdkMgr.GetInstance():GetLoginType()
	slot0.process = coroutine.wrap(function ()
		slot0.viewComponent:switchSubView({})

		if slot0.viewComponent:CheckNeedUserAgreement() then
			slot0.viewComponent:showUserAgreement(slot0.process)
			coroutine.yield()
			slot0.viewComponent:SetUserAgreement()
		end

		slot0 = nil

		if slot2 == LoginType.PLATFORM then
			slot0.viewComponent:switchToServer()
		elseif slot2 == LoginType.PLATFORM_TENCENT then
			slot0.viewComponent:switchToTencentLogin()
		elseif slot2 == LoginType.PLATFORM_INNER then
			slot0.viewComponent:switchToLogin()
			slot0.viewComponent:setLastLogin(getProxy(UserProxy).getLastLoginUser(slot1))
		elseif slot2 == LoginType.PLATFORM_AIRIJP or slot2 == LoginType.PLATFORM_AIRIUS then
			slot0.viewComponent:switchToAiriLogin()
		end

		if not Application.isEditor then
			slot0:CheckMaintain()
			coroutine.yield()
		end

		if slot0.contextData.code then
			if slot0.contextData.code ~= 0 then
				if slot0.contextData.code == SDK_EXIT_CODE then
				else
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						modal = true,
						hideNo = true,
						content = ({
							i18n("login_loginMediator_kickOtherLogin"),
							i18n("login_loginMediator_kickServerClose"),
							i18n("login_loginMediator_kickIntError"),
							i18n("login_loginMediator_kickTimeError"),
							i18n("login_loginMediator_kickLoginOut"),
							i18n("login_loginMediator_serverLoginErro"),
							i18n("login_loginMediator_vertifyFail"),
							[199] = i18n("login_loginMediator_dataExpired")
						})[slot0.contextData.code] or i18n("login_loginMediator_kickUndefined", slot0.contextData.code),
						onYes = function ()
							slot0.process()
						end
					})
					coroutine.yield()
				end
			end

			if slot0 then
				if slot0.type == 1 then
					slot0.arg3 = ""
				elseif slot0.type == 2 then
					slot0.arg2 = ""
				end

				slot0.viewComponent.setLastLogin(slot1, slot0)
			end
		else
			slot0.viewComponent:setAutoLogin()
		end

		if slot2 == LoginType.PLATFORM then
			pg.SdkMgr.GetInstance():LoginSdk()
		elseif slot2 == LoginType.PLATFORM_TENCENT then
			pg.SdkMgr.GetInstance():TryLoginSdk()
		elseif slot2 == LoginType.PLATFORM_INNER then
		end

		slot0.viewComponent:autoLogin()
	end)

	slot0.process()
end

slot0.CheckMaintain = function (slot0)
	slot1 = -1
	slot2 = 0
	slot3 = 1
	slot4 = 2

	GetServerState(function (slot0)
		if slot0 == slot0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("login_loginMediator_kickServerClose"),
				onNo = function ()
					slot0.process()
				end,
				onYes = function ()
					slot0.process()
				end
			})
		elseif slot0 == slot2 then
			print("All servers working well. thanks God.")
			print.process()
		elseif slot0 == slot3 then
			print("Check server maintain state failed. but it doesnt matter. keep going.")
			print.process()
		else
			print("no servers working. anyway. you should have a try. ")
			print.process()
		end
	end)
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.USER_LOGIN_SUCCESS,
		GAME.USER_LOGIN_FAILED,
		GAME.USER_REGISTER_SUCCESS,
		GAME.USER_REGISTER_FAILED,
		GAME.SERVER_LOGIN_SUCCESS,
		GAME.SERVER_LOGIN_FAILED,
		GAME.LOAD_PLAYER_DATA_DONE,
		ServerProxy.SERVERS_UPDATED,
		GAME.PLATFORM_LOGIN_DONE,
		GAME.SERVER_LOGIN_WAIT,
		GAME.BEGIN_STAGE_DONE,
		GAME.SERVER_LOGIN_FAILED_USER_BANNED
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == ServerProxy.SERVERS_UPDATED then
		slot0.viewComponent:updateServerList(slot3)
	elseif slot2 == GAME.USER_LOGIN_SUCCESS then
		pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginMediator_loginSuccess"))
		slot0.viewComponent:setLastLoginServer(slot5)
		slot0.viewComponent:switchToServer()

		slot6 = getProxy(UserProxy)

		if PLATFORM_CODE == PLATFORM_JP then
			slot0.viewComponent:setUserData(slot6.getLastLoginUser())
		end

		if #getProxy(GatewayNoticeProxy).getGatewayNotices(slot7, false) > 0 then
			slot0:addSubLayers(Context.New({
				mediator = GatewayNoticeMediator,
				viewComponent = GatewayNoticeLayer
			}))
		end

		if getProxy(UserProxy).data.limitServerIds and #slot9.data.limitServerIds > 0 then
			slot0.viewComponent:fillterRefundServer()
			slot0.viewComponent:setLastLoginServer(nil)
		end

		slot0.viewComponent.switchGatewayBtn:Flush()
	elseif slot2 == GAME.USER_REGISTER_SUCCESS then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = i18n("login_loginMediator_quest_RegisterSuccess"),
			onYes = function ()
				slot0:sendNotification(GAME.USER_LOGIN, slot0)
			end
		})
	elseif slot2 == GAME.SERVER_LOGIN_SUCCESS then
		if slot3.uid == 0 then
			if EPILOGUE_SKIPPABLE then
				slot0.sendNotification(slot0, GAME.GO_SCENE, SCENE.CREATE_PLAYER)
			else
				slot0:sendNotification(GAME.BEGIN_STAGE, {
					system = SYSTEM_PROLOGUE
				})
			end
		else
			slot0.facade:sendNotification(GAME.LOAD_PLAYER_DATA, {
				id = slot3.uid
			})
		end
	elseif slot2 == GAME.USER_REGISTER_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_registerFail", slot3)
		})
	elseif slot2 == GAME.USER_LOGIN_FAILED then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_userLoginFail_error", slot3),
			onYes = function ()
				if pg.SdkMgr.GetInstance():GetLoginType() == 20 then
					slot1.viewComponent:switchToRegister()
				elseif slot0 == 3 or slot0 == 6 then
					slot1.viewComponent:switchToServer()
				elseif slot0 == 1 or slot0 == 9 or slot0 == 11 or slot0 == 12 then
					if slot0 == LoginType.PLATFORM_AIRIJP or slot0 == LoginType.PLATFORM_AIRIUS then
						slot1.viewComponent:switchToAiriLogin()
					else
						slot1.viewComponent:switchToLogin()
					end
				elseif slot0 == LoginType.PLATFORM or slot0 == LoginType.PLATFORM_TENCENT then
					slot1.viewComponent:switchToServer()
				elseif slot0 == LoginType.PLATFORM_AIRIJP or slot0 == LoginType.PLATFORM_AIRIUS then
					slot1.viewComponent:switchToAiriLogin()
				else
					slot1.viewComponent:switchToLogin()
				end
			end
		})
	elseif slot2 == GAME.SERVER_LOGIN_FAILED then
		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot4, {
			modal = true,
			hideNo = true,
			content = errorTip("login_loginMediator_serverLoginFail", slot3),
			onYes = function ()
				if pg.SdkMgr.GetInstance():GetLoginType() == LoginType.PLATFORM or LoginType.PLATFORM_TENCENT then
					slot0.viewComponent:switchToServer()
				elseif slot0 == LoginType.PLATFORM_AIRIJP or slot0 == LoginType.PLATFORM_AIRIUS then
					slot0.viewComponent:switchToAiriLogin()
				else
					slot0.viewComponent:switchToLogin()
				end
			end
		})
	elseif slot2 == GAME.LOAD_PLAYER_DATA_DONE then
		slot0.viewComponent.unloadExtraVoice(slot4)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI, {
			isFromLogin = true
		})
	elseif slot2 == GAME.BEGIN_STAGE_DONE then
		slot0.viewComponent:unloadExtraVoice()
		slot0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, slot3)
	elseif slot2 == GAME.PLATFORM_LOGIN_DONE then
		slot0:sendNotification(GAME.USER_LOGIN, slot3.user)
	elseif slot2 == GAME.SERVER_LOGIN_WAIT then
		slot0.viewComponent:SwitchToWaitPanel(slot3)
	elseif slot2 == GAME.SERVER_LOGIN_FAILED_USER_BANNED then
		if slot3 == 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("user_is_forever_banned")
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("user_is_banned", pg.TimeMgr.GetInstance():STimeDescS(slot3, "%Y-%m-%d %H:%M"))
			})
		end
	end
end

return slot0

slot0 = class("LoginPanelView", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "LoginPanelView"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.SetShareData = function (slot0, slot1)
	slot0.shareData = slot1
end

slot0.OnInit = function (slot0)
	slot0.loginPanel = slot0._tf
	slot0.loginUsername = slot0:findTF("account/username", slot0.loginPanel)
	slot0.loginPassword = slot0:findTF("password/password", slot0.loginPanel)
	slot0.loginButton = slot0:findTF("login_button", slot0.loginPanel)
	slot0.registerButton = slot0:findTF("register_button", slot0.loginPanel)

	slot0:InitEvent()
end

slot0.InitEvent = function (slot0)
	onButton(slot0, slot0.loginButton, function ()
		if slot0.shareData.autoLoginEnabled and slot0.shareData.lastLoginUser then
			slot0.event:emit(LoginMediator.ON_LOGIN, slot0.shareData.lastLoginUser)

			return
		end

		if getInputText(slot0.loginUsername) == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("login_loginScene_error_noUserName"))
			ActivateInputField(slot0.loginUsername)

			return
		end

		if User.New({
			type = 2,
			arg1 = slot0,
			arg2 = getInputText(slot0.loginPassword) or ""
		}) then
			slot0.event:emit(LoginMediator.ON_LOGIN, slot2)
		end
	end, SFX_CONFIRM)
	onButton(slot0, slot0.registerButton, function ()
		slot0:emit(LoginSceneConst.SWITCH_SUB_VIEW, {
			LoginSceneConst.DEFINE.REGISTER_PANEL_VIEW
		})
		slot0.emit:emit(LoginSceneConst.CLEAR_REGISTER_VIEW)
	end, SFX_MAIN)
	onInputChanged(slot0, slot0.loginUsername, function ()
		slot0.shareData.autoLoginEnabled = false
	end)
	onInputChanged(slot0, slot0.loginPassword, function ()
		slot0.shareData.autoLoginEnabled = false
	end)
end

slot0.SetContent = function (slot0, slot1, slot2)
	setInputText(slot0.loginUsername, slot1)
	setInputText(slot0.loginPassword, slot2)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

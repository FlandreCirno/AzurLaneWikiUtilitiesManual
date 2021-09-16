slot0 = class("SVOrderPanel", import("view.base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "SVOrderPanel"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot2 = slot0._tf.Find(slot1, "adapt/order_list")
	slot0.btnRedeploy = slot2:Find("redeploy")
	slot0.btnExpansion = slot2:Find("expansion")
	slot0.btnMaintenance = slot2:Find("maintenance")
	slot0.btnFOV = slot2:Find("fov")
	slot0.btnSubmarine = slot2:Find("submarine")
	slot0.btnHelp = slot0._tf.Find(slot1, "adapt/help")

	onButton(slot0, slot0.btnHelp, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("world_instruction_help_1")
		})
	end, SFX_PANEL)

	slot0.btnBack = slot0._tf.Find(slot1, "adapt/back")

	onButton(slot0, slot0.btnBack, function ()
		slot0:Hide()
	end, SFX_CANCEL)

	slot0.rtRing = slot0._tf.Find(slot1, "bg/ring")
	slot0.wsCompass = WSCompass.New()
	slot0.wsCompass.tf = slot0._tf.Find(slot1, "bg/ring/compass")
	slot0.wsCompass.pool = slot0.contextData.wsPool

	slot0.wsCompass:Setup(true)

	slot0.rtMsgbox = slot0._tf.Find(slot1, "Msgbox")

	setActive(slot0.rtMsgbox, false)
	onButton(slot0, slot0.rtMsgbox:Find("bg"), function ()
		slot0:HideMsgbox()
	end, SFX_CANCEL)
	onButton(slot0, slot0.rtMsgbox:Find("window/top/btnBack"), function ()
		slot0:HideMsgbox()
	end, SFX_CANCEL)

	slot0.rtMsgStamina = slot0.rtMsgbox.Find(slot3, "window/top/bg/stamina")

	setText(slot0.rtMsgStamina:Find("name"), i18n("world_ap"))

	slot0.rtMsgBase = slot0.rtMsgbox:Find("window/msg_panel/base")
	slot0.rtMsgExtra = slot0.rtMsgbox:Find("window/msg_panel/extra")
	slot0.rtMsgBtns = slot0.rtMsgbox:Find("window/button_container")

	setText(slot0.rtMsgBtns:Find("btn_setting/pic"), i18n("msgbox_text_save"))
	setText(slot0.rtMsgBtns:Find("btn_confirm/pic"), i18n("text_confirm"))
	setText(slot0.rtMsgBtns:Find("btn_cancel/pic"), i18n("text_cancel"))
	onButton(slot0, slot0.rtMsgBtns:Find("btn_cancel"), function ()
		slot0:HideMsgbox()
	end, SFX_CANCEL)
end

slot0.OnDestroy = function (slot0)
	slot0:ClearBtnTimers()
	slot0.wsCompass:Dispose()
end

slot0.Show = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, false, {
		blurLevelCamera = true
	})
	setActive(slot0._tf, true)
	pg.CriMgr.GetInstance():PlayBGM("echo-loop", "sub_view")
end

slot0.Hide = function (slot0)
	if isActive(slot0.rtMsgbox) then
		slot0:HideMsgbox()
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
	pg.CriMgr.GetInstance():ResumeLastNormalBGM()
	slot0:ClearComppass()
	slot0:ClearBtnTimers()
end

slot0.Setup = function (slot0, slot1, slot2, slot3)
	slot0:Update(slot1, slot2)
	slot0.wsCompass:SetAnchorEulerAngles(slot3)
end

slot0.Update = function (slot0, slot1, slot2)
	if slot0.entrance ~= slot1 or slot0.map ~= slot2 or slot0.gid ~= slot2.gid then
		slot0.entrance = slot1
		slot0.map = slot2
		slot0.gid = slot2.gid
	end

	slot0:UpdateCompassMarks()
	slot0:UpdateOrderBtn()
end

slot0.SetButton = function (slot0, slot1, slot2)
	setActive(slot3, not nowWorld:IsSystemOpen(slot2.system))
	setActive(slot1:Find("type_unable"), not isActive(slot1:Find("type_lock")) and (slot2.isLock or (slot2.timeStamp and pg.TimeMgr.GetInstance():GetServerTime() < slot2.timeStamp)))
	setActive(slot1:Find("type_enable"), not isActive(slot3) and not isActive(slot4))

	if isActive(slot3) then
		onButton(slot0, slot3, function ()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_all_1"))
		end, SFX_CONFIRM)
	end

	if isActive(slot4) then
		setActive(slot4:Find("cost"), slot2.isLock)
		setActive(slot4:Find("time"), not slot2.isLock)

		if slot2.isLock then
			setText(slot4:Find("cost/Text"), slot2.cost)
			onButton(slot0, slot4, slot2.lockFunc, SFX_CONFIRM)
		else
			slot0.timers[slot4] = Timer.New(function ()
				if slot0.timeStamp - pg.TimeMgr.GetInstance():GetServerTime() < 0 then
					slot1:UpdateOrderBtn()
				else
					setText(slot2:Find("time/Text"), string.format("%d:%d:%d", math.floor(slot0 / 3600), math.floor(slot0 % 3600 / 60), slot0 % 60))
				end
			end, 1, -1)

			slot0.timers[slot4].func()
			slot0.timers[slot4].Start(slot7)
			onButton(slot0, slot4, slot2.timeFunc, SFX_CONFIRM)
		end
	end

	if isActive(slot5) then
		setText(slot5:Find("cost/Text"), slot2.cost)
		onButton(slot0, slot5, slot2.enableFunc, SFX_CONFIRM)
	end
end

slot0.UpdateOrderBtn = function (slot0)
	slot0:ClearBtnTimers()

	slot0.timers = {}

	slot0.SetButton(slot0, slot0.btnRedeploy, slot5)
	slot0:SetButton(slot0.btnExpansion, {
		system = WorldConst.SystemOrderRedeploy,
		isLock = not (nowWorld:IsSystemOpen(WorldConst.SystemOrderRedeploy) and nowWorld:GetRealm() == checkExist(checkExist(slot0.map, {
			"GetPort"
		}), {
			"GetRealm"
		}) and checkExist(checkExist(slot0.map, ), {
			"IsOpen",
			{
				nowWorld.GetRealm(),
				nowWorld:GetProgress()
			}
		}) and nowWorld:BuildFormationIds()),
		lockFunc = function ()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_1"))
		end,
		cost = nowWorld.CalcOrderCost(slot6, WorldConst.OpReqRedeploy),
		enableFunc = function (slot0, slot1)
			slot0:Hide()
			slot0:emit(WorldScene.SceneOp, "OpRedeploy")
		end
	})
	setActive(slot0.btnRedeploy, (nowWorld.IsSystemOpen(WorldConst.SystemOrderRedeploy) and nowWorld.GetRealm() == checkExist(checkExist(slot0.map, ), ) and checkExist(checkExist(slot0.map, ), ) and nowWorld.BuildFormationIds()) ~= WorldConst.FleetExpansion)
	setActive(slot0.btnExpansion, (nowWorld.IsSystemOpen(WorldConst.SystemOrderRedeploy) and nowWorld.GetRealm() == checkExist(checkExist(slot0.map, ), ) and checkExist(checkExist(slot0.map, ), ) and nowWorld.BuildFormationIds()) == WorldConst.FleetExpansion)

	slot6 = pg.TimeMgr.GetInstance()

	slot0:SetButton(slot0.btnMaintenance, {
		system = WorldConst.SystemOrderMaintenance,
		timeStamp = nowWorld:GetReqCDTime(WorldConst.OpReqMaintenance) + pg.gameset.world_instruction_maintenance.description[2],
		timeFunc = function (slot0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_supply_2", slot0:DescCDTime(slot1 - pg.TimeMgr.GetInstance():GetServerTime())))
		end,
		cost = nowWorld.CalcOrderCost(slot13, WorldConst.OpReqMaintenance),
		enableFunc = function ()
			slot0:ShowMsgbox(WorldConst.OpReqMaintenance)
		end
	})
	slot0.SetButton(slot0, slot0.btnSubmarine, {
		system = WorldConst.SystemOrderSubmarine,
		isLock = slot0.map:GetConfig("instruction_available")[1] == 0 or not nowWorld:CanCallSubmarineSupport() or (nowWorld:IsSubmarineSupporting() and nowWorld:GetSubAidFlag()),
		lockFunc = function ()
			if slot0[1] == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
			elseif not nowWorld:CanCallSubmarineSupport() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_4"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_3"))
			end
		end,
		cost = nowWorld.CalcOrderCost(slot13, WorldConst.OpReqSub),
		enableFunc = function ()
			slot0:ShowMsgbox(WorldConst.OpReqSub)
		end
	})
	slot0.SetButton(slot0, slot0.btnFOV, {
		system = WorldConst.SystemOrderFOV,
		isLock = slot0.map.GetConfig("instruction_available")[2] == 0 or slot0.map.visionFlag,
		lockFunc = function ()
			if slot0[2] == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_1"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_detect_2"))
			end
		end,
		cost = nowWorld.CalcOrderCost(slot13, WorldConst.OpReqVision),
		enableFunc = function ()
			slot0:ShowMsgbox(WorldConst.OpReqVision)
		end
	})
end

slot0.ClearBtnTimers = function (slot0)
	if slot0.timers then
		for slot4, slot5 in pairs(slot0.timers) do
			slot5:Stop()
		end
	end

	slot0.timers = nil
end

slot0.UpdateCompassMarks = function (slot0)
	slot0.wsCompass:ClearMarks()
	slot0.wsCompass:Update(slot0.entrance, slot0.map)
end

slot0.ClearComppass = function (slot0)
	slot0.wsCompass.map = nil

	slot0.wsCompass:RemoveCellsListener()
end

slot0.ShowMsgbox = function (slot0, slot1)
	setText(slot0.rtMsgStamina:Find("Text"), slot2)

	slot3 = nowWorld:CalcOrderCost(slot1)
	slot4 = ""
	slot5 = ""
	slot6 = nil

	if slot1 == WorldConst.OpReqMaintenance then
		slot4 = i18n("world_instruction_morale_1", setColorStr(slot3, COLOR_GREEN), setColorStr(slot2, (slot3 <= slot2 and COLOR_GREEN) or COLOR_RED))
		slot5 = i18n("world_instruction_morale_4")

		function slot6()
			slot0:emit(WorldScene.SceneOp, "OpReqMaintenance", slot0.map:GetFleet().id)
		end
	elseif slot1 == WorldConst.OpReqSub then
		slot4 = i18n((nowWorld.IsSubmarineSupporting(slot8) and "world_instruction_submarine_7") or "world_instruction_submarine_2", setColorStr(slot3, COLOR_GREEN), setColorStr(slot2, (slot3 <= slot2 and COLOR_GREEN) or COLOR_RED))
		slot5 = i18n("world_instruction_submarine_8")

		function slot6()
			slot0:emit(WorldScene.SceneOp, "OpReqSub")
		end
	elseif slot1 == WorldConst.OpReqVision then
		slot4 = i18n("world_instruction_detect_1", setColorStr(slot3, COLOR_GREEN), setColorStr(slot2, (slot3 <= slot2 and COLOR_GREEN) or COLOR_RED))
		slot5 = i18n("world_instruction_submarine_8")

		function slot6()
			slot0:emit(WorldScene.SceneOp, "OpReqVision")
		end
	end

	setText(slot0.rtMsgBase.Find(slot8, "content"), slot4)
	setText(slot0.rtMsgBase:Find("other"), slot5)
	onButton(slot0, slot0.rtMsgBtns:Find("btn_confirm"), function ()
		slot0:Hide()

		if nowWorld.staminaMgr:GetTotalStamina() < nowWorld.staminaMgr then
			nowWorld.staminaMgr:Show()
		else
			slot2()
		end
	end, SFX_CONFIRM)
	setActive(slot0.rtMsgExtra, slot1 == WorldConst.OpReqSub)

	if slot1 == WorldConst.OpReqSub then
		setText(slot0.rtMsgExtra.Find(slot8, "content/text_1"), i18n("world_instruction_submarine_9"))
		triggerToggle(slot0.rtMsgExtra:Find("content/toggle_area/toggle"), PlayerPrefs.GetInt("world_sub_auto_call", 0) == 1)
		onToggle(slot0, slot0.rtMsgExtra.Find("content/toggle_area/toggle"), function (slot0)
			slot0 = slot0

			slot1:DisplayAutoSetting(true)
		end, SFX_PANEL)

		slot9 = pg.gameset.world_instruction_submarine.description[1]
		slot11 = slot0.rtMsgExtra:Find("content/counter")

		setText(slot11:Find("number/Text"), slot10)
		pressPersistTrigger(slot11:Find("minus"), 0.5, function (slot0)
			if slot0 == 0 then
				if slot0 then
					slot0()
				end

				return
			end

			setText(slot0 - 1:Find("number/Text"), slot0)
			slot3:DisplayAutoSetting(true)
		end, nil, true, true, 0.1, SFX_PANEL)
		pressPersistTrigger(slot11.Find(slot11, "plus"), 0.5, function (slot0)
			if slot0 ==  then
				if slot0 then
					slot0()
				end

				return
			end

			setText(slot0 + 1:Find("number/Text"), slot0)
			slot3:DisplayAutoSetting(true)
		end, nil, true, true, 0.1, SFX_PANEL)
		onButton(slot0, slot0.rtMsgBtns:Find("btn_setting"), function ()
			isSetting = false

			slot0("world_sub_auto_call", (PlayerPrefs.SetInt and 1) or 0)
			PlayerPrefs.SetInt("world_sub_call_line", )
			(PlayerPrefs.SetInt and 1) or 0:DisplayAutoSetting(false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_submarine_11"))
		end, SFX_PANEL)
	end

	slot0.DisplayAutoSetting(slot0, false)
	setActive(slot0.rtMsgbox, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.rtMsgbox)
end

slot0.HideMsgbox = function (slot0)
	setActive(slot0.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.rtMsgbox)
end

slot0.DisplayAutoSetting = function (slot0, slot1)
	setActive(slot0.rtMsgBtns:Find("btn_confirm"), not slot1)
	setActive(slot0.rtMsgBtns:Find("btn_setting"), slot1)
end

return slot0

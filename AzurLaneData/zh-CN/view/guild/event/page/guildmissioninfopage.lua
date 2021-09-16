slot0 = class("GuildMissionInfoPage", import(".GuildEventBasePage"))
slot1 = 10001

slot0.AttrCnt2Desc = function (slot0, slot1)
	return i18n("guild_event_info_desc1", pg.attribute_info_by_type[slot0].condition, slot1.total, (slot1.goal <= slot1.value and COLOR_GREEN) or COLOR_RED, slot1.value, slot1.goal)
end

slot0.AttrAcc2Desc = function (slot0, slot1)
	slot2 = pg.attribute_info_by_type[slot0]
	slot3 = nil

	if slot1.op == 1 then
		slot3 = (slot1.goal <= slot1.value and COLOR_GREEN) or COLOR_RED
	elseif slot1.op == 2 then
		return i18n("guild_event_info_desc2", slot2.condition, (slot1.value <= slot1.goal and COLOR_GREEN) or COLOR_RED, slot1.value, slot1.goal)
	end
end

slot0.getUIName = function (slot0)
	return "GuildMissionInfoPage"
end

slot0.OnLoaded = function (slot0)
	slot0.closeBtn = slot0:findTF("top/close")
	slot0.sea = slot0:findTF("sea"):GetComponent(typeof(RawImage))
	slot0.titleTxt = slot0:findTF("top/title/Text"):GetComponent(typeof(Text))
	slot0.logBtn = slot0:findTF("bottom/log_btn")
	slot0.formationBtn = slot0:findTF("bottom/formationBtn")
	slot0.doingBtn = slot0:findTF("bottom/doing_btn")
	slot0.helpBtn = slot0:findTF("bottom/help")
	slot0.logPanel = slot0:findTF("log_panel")
	slot0.logList = UIItemList.New(slot0.logPanel:Find("scrollrect/content"), slot0.logPanel:Find("scrollrect/content/tpl"))
	slot0.peopleCnt = slot0:findTF("bottom/cnt/Text"):GetComponent(typeof(Text))
	slot0.effectCnt = slot0:findTF("bottom/effect/Text"):GetComponent(typeof(Text))

	setText(slot0:findTF("bottom/cnt"), i18n("guild_join_member_cnt"))
	setText(slot0:findTF("bottom/effect"), i18n("guild_total_effect"))

	slot0.areaTxt = slot0:findTF("top/title/Text/target/area"):GetComponent(typeof(Text))
	slot0.goalTxt = slot0:findTF("top/title/Text/target/goal"):GetComponent(typeof(Text))
	slot0.timeTxt = slot0:findTF("bottom/progress/time/Text"):GetComponent(typeof(Text))
	slot0.nodesUIlist = UIItemList.New(slot0:findTF("bottom/progress/nodes"), slot0:findTF("bottom/progress/nodes/tpl"))
	slot0.progress = slot0:findTF("bottom/progress")
	slot0.nodeLength = slot0.progress.rect.width
	slot0.healTF = slot0:findTF("resources/heal")
	slot0.nameTF = slot0:findTF("resources/name")
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.closeBtn, function ()
		slot0.contextData.mission = nil

		slot0.contextData:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_mission_info_tip.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.logBtn, function ()
		if slot0.isShowLogPanel then
			slot0:ShowOrHideLogPanel(false)
		else
			slot0:ShowOrHideLogPanel(true)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.logPanel, function ()
		slot0:ShowOrHideLogPanel(false)
	end, SFX_PANEL)
	onButton(slot0, slot0.formationBtn, function ()
		if slot0.mission:IsFinish() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		slot0:emit(GuildEventLayer.OPEN_MISSION_FORAMTION, slot0.mission)
	end, SFX_PANEL)
	onButton(slot0, slot0.doingBtn, function ()
		triggerButton(slot0.formationBtn)
	end, SFX_PANEL)
end

slot0.OnRefreshMission = function (slot0, slot1)
	slot0:Flush(slot1)
end

slot0.OnShow = function (slot0)
	slot0:Flush(slot0.extraData.mission)
	slot0:EnterFormation()
	slot0:AddOtherShipMoveTimer()
end

slot0.Flush = function (slot0, slot1)
	slot0.mission = slot1

	slot0:InitBattleSea()
	slot0:InitView()
	slot0:AddRefreshProgressTimer()
end

slot0.EnterFormation = function (slot0)
	if slot0.contextData.missionShips then
		triggerButton(slot0.formationBtn)
	end
end

slot0.InitView = function (slot0)
	slot0.titleTxt.text = slot0.mission.GetName(slot1)
	slot0.peopleCnt.text = slot0.mission.GetJoinMemberCnt(slot1) .. "/" .. slot0.guild.memberCount .. i18n("guild_word_people")
	slot0.effectCnt.text = slot0.mission.GetEfficiency(slot1) .. "(" .. slot0.mission.GetMyEffect(slot1) .. ")"
	slot4 = _.map(slot3, function (slot0)
		return i18n("guild_event_info_desc3", Nation.Nation2Name(slot0), #slot0:GetShipsByNation(slot0))
	end)
	slot0.areaTxt.text = i18n("guild_word_battle_area") .. table.concat(slot4, " 、")

	if table.concat(slot0.GetBattleTarget(slot1), " 、") ~= "" then
		slot0.goalTxt.text = i18n("guild_wrod_battle_target") .. slot6
	end

	setActive(slot0.goalTxt.gameObject, slot6 ~= "")
	slot0:UpdateNodes()
	slot0:UpdateFormationBtn()
end

slot0.UpdateFormationBtn = function (slot0)
	setActive(slot0.formationBtn, slot2)
	setActive(slot0.doingBtn, not slot0.mission.CanFormation(slot1))
end

slot0.GetBattleTarget = function (slot0)
	slot2 = slot0:GetAttrAcc()
	slot3 = {}

	for slot7, slot8 in pairs(slot1) do
		table.insert(slot3, slot0.AttrCnt2Desc(slot7, slot8))
	end

	for slot7, slot8 in pairs(slot2) do
		table.insert(slot3, slot0.AttrAcc2Desc(slot7, slot8))
	end

	return slot3
end

slot0.UpdateNodes = function (slot0)
	slot0.nodes = {}
	slot2 = slot0.mission.GetNodes(slot1)
	slot3 = 1

	if not slot0.mission:IsFinish() then
		slot0.nodesUIlist:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventUpdate then
				slot2:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/GuildMissionInfoUI_atlas", slot4)

				setAnchoredPosition(slot2, {
					x = slot1.nodeLength * slot0[slot1 + 1].GetPosition(slot3) / 100
				})

				slot2:Find("item"):GetComponent(typeof(Image)).sprite = LoadSprite("GuildNode/" .. slot0[slot1 + 1].GetIcon(slot3))

				table.insert(slot1.nodes, slot2)
			end
		end)
		slot0.nodesUIlist.align(slot4, #slot2)

		slot3 = slot1:GetProgress()
	end

	setSlider(slot0.progress, 0, 100, slot3 * 100)
end

slot0.InitBattleSea = function (slot0)
	if slot0.loading then
		return
	end

	slot0.loading = true
	slot1 = {}

	if not slot0.battleView then
		slot0.battleView = GuildMissionBattleView.New(slot0.sea)

		slot0.battleView:configUI(slot0.healTF, slot0.nameTF)
		table.insert(slot1, function (slot0)
			slot0.battleView:load(slot0.battleView.load, slot0)
		end)
	end

	slot4 = nil
	slot5 = {}
	slot6 = ""

	if slot0.mission.GetMyFlagShip(slot2) then
		slot7 = math.floor(getProxy(BayProxy):getShipById(slot3) or Ship.New({
			id = 9999,
			configId = 101171
		}).configId / 10)

		for slot11 = 1, 4, 1 do
			slot13 = (pg.ship_data_breakout[tonumber(slot7 .. slot11)] and slot12.weapon_ids) or {}

			for slot17, slot18 in ipairs(slot13) do
				if not table.contains(slot5, slot18) then
					table.insert(slot5, slot18)
				end
			end
		end

		slot6 = getProxy(PlayerProxy):getRawData().name
	end

	table.insert(slot1, function (slot0)
		slot0.battleView:LoadShip(slot0.battleView.LoadShip, slot0.battleView, , function ()
			if slot0 then
				slot1:CheckNodesState()
			end

			slot2()
		end)
	end)
	seriesAsync(slot1, function ()
		slot0.loading = false
	end)
end

slot0.AddOtherShipMoveTimer = function (slot0)
	function slot1(slot0)
		slot1 = {}

		if #slot0.mission.GetOtherShips(slot2) == 0 then
			return slot1
		end

		if slot0 >= #slot3 then
			return slot3
		end

		shuffle(slot3)

		for slot7 = 1, slot0, 1 do
			table.insert(slot1, slot3[slot7])
		end

		return slot1
	end

	slot2 = nil

	function slot2()
		if slot0.timer then
			slot0.timer:Stop()

			slot0.timer.Stop.timer = nil
		end

		slot0.timer = Timer.New(function ()
			slot1.battleView:PlayOtherShipAnim(slot0(slot0), slot1.battleView.PlayOtherShipAnim)
		end, slot0, 1)

		slot0.timer:Start()
	end

	slot2()
end

slot0.CheckNodesState = function (slot0)
	function slot1(slot0)
		if slot0:IsItemType() then
			slot0.battleView:PlayItemAnim()
		elseif slot0:IsBattleType() then
			slot0.battleView:PlayAttackAnim()
		end
	end

	if slot0.mission.GetNewestSuccessNode(slot2) and slot2:GetNodeAnimPosistion() < slot3:GetPosition() then
		slot1(slot3)
		slot0:emit(GuildEventMediator.ON_UPDATE_NODE_ANIM_FLAG, slot2.id, slot5)
	end
end

slot0.AddRefreshProgressTimer = function (slot0)
	slot0:RemoveCdTimer()
	slot0:RemoveRefreshTimer()

	slot3 = not slot0.mission:IsFinish() and slot0.mission.GetTotalTimeCost(slot1) > 0

	if slot3 then
		slot4 = slot2 * 0.01
		slot0.refreshTimer = Timer.New(function ()
			slot0:RemoveRefreshTimer()
			slot0.RemoveRefreshTimer:emit(GuildEventMediator.FORCE_REFRESH_MISSION, slot1.id)
		end, slot4, 1)

		slot0.refreshTimer:Start()

		if slot1:GetRemainingTime() > 0 then
			slot0.cdTimer = Timer.New(function ()
				if slot0 - 1 <= 0 then
					slot1:RemoveCdTimer()
					setActive(slot1.timeTxt.gameObject.transform.parent, false)
				else
					slot1.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(slot1.timeTxt)
				end
			end, 1, -1)

			slot0.cdTimer.Start(slot6)
			slot0.cdTimer.func()
		else
			setActive(slot0.timeTxt.gameObject.transform.parent, false)
		end
	end

	setActive(slot0.timeTxt.gameObject.transform.parent, slot3)
end

slot0.RemoveCdTimer = function (slot0)
	if slot0.cdTimer then
		slot0.cdTimer:Stop()

		slot0.cdTimer = nil
	end
end

slot0.ShowOrHideLogPanel = function (slot0, slot1, slot2)
	slot2 = slot2 or 0.3

	if LeanTween.isTweening(slot0.logPanel) then
		return
	end

	LeanTween.value(slot0.logPanel.gameObject, (slot1 and slot0.logPanel.rect.width + 300) or 0, (not slot1 or 0) and slot0.logPanel.rect.width + 300, slot2):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0.logPanel, {
			x = slot0
		})
	end)).setOnComplete(slot6, System.Action(function ()
		if not slot0 then
			setActive(slot1.logPanel, false)
		end
	end))

	slot0.isShowLogPanel = slot1

	if slot1 then
		setActive(slot0.logPanel, true)
		slot0.InitLogs(slot0)
	end
end

slot0.InitLogs = function (slot0)
	slot0.logList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2, slot0[slot1 + 1])
		end
	end)
	slot0.logList.align(slot3, #slot0.mission.GetLogs(slot1))
end

slot0.RemoveRefreshTimer = function (slot0)
	if slot0.refreshTimer then
		slot0.refreshTimer:Stop()

		refreshTimer = nil
	end
end

slot0.Hide = function (slot0)
	slot0:ShowOrHideLogPanel(false, 0)
	slot0.super.Hide(slot0)

	if slot0.battleView then
		slot0.battleView:clear()

		slot0.battleView = nil
	end

	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end

	slot0:RemoveRefreshTimer()
	slot0:RemoveCdTimer()
end

return slot0

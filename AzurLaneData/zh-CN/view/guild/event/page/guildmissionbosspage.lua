slot0 = class("GuildMissionBossPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "GuildMissionBossPage"
end

slot0.OnLoaded = function (slot0)
	slot0.hp = slot0:findTF("hp/bar")
	slot0.hpProgress = slot0:findTF("hp/bar/Text"):GetComponent(typeof(Text))
	slot0.hpL = slot0.hp.rect.width
	slot0.titleTxt = slot0:findTF("title"):GetComponent(typeof(Text))
	slot0.assaultBtn = slot0:findTF("btn_a_formation")
	slot0.battleBtn = slot0:findTF("btn_go")
	slot0.reportBtn = slot0:findTF("btn_report")
	slot0.reportTip = slot0:findTF("btn_report/tip")
	slot0.reportTipTxt = slot0:findTF("btn_report/tip/Text"):GetComponent(typeof(Text))
	slot0.cntTxt = slot0:findTF("btn_go/cnt/Text"):GetComponent(typeof(Text))
	slot0.rankList = UIItemList.New(slot0:findTF("rank/content"), slot0:findTF("rank/content/tpl"))
	slot0.paintingTF = slot0:findTF("painting")
	slot0.prefabTF = slot0:findTF("prefab")
	slot0.viewAllBtn = slot0:findTF("rank/view_all")
	slot0.allRankPage = GuildBossRankPage.New(slot0._parentTf, slot0._event)

	setActive(slot0.viewAllBtn, PLATFORM_CODE ~= PLATFORM_JP)

	slot0.eventTimerTxt = slot0:findTF("timer/Text"):GetComponent(typeof(Text))

	setText(slot0:findTF("timer/label"), i18n("guild_time_remaining_tip"))

	slot0.timeView = GuildEventTimerView.New()
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.assaultBtn, function ()
		slot0:emit(GuildEventLayer.OPEN_BOSS_ASSULT)
	end, SFX_PANEL)
	onButton(slot0, slot0.battleBtn, function ()
		if not slot0:ExistActiveEvent() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

			return
		end

		if slot0.bossMission:IsReachDailyCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_boss_cnt_no_enough"))

			return
		end

		if slot0.bossMission:IsDeath() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

			return
		end

		slot0:emit(GuildEventLayer.ON_OPEN_BOSS_FORMATION, slot0.bossMission)
	end, SFX_PANEL)
	onButton(slot0, slot0.reportBtn, function ()
		slot0:emit(GuildEventMediator.ON_OPEN_REPORT)
	end, SFX_PANEL)
end

slot0.UpdateMission = function (slot0, slot1)
	slot0.bossMission = slot1
end

slot0.OnReportUpdated = function (slot0)
	setActive(slot0.reportTip, #_.select(_.values(slot1), function (slot0)
		return slot0:CanSubmit()
	end) > 0)

	if #slot2 > 0 then
		slot0.reportTipTxt.text = #slot2
	end
end

slot0.Show = function (slot0, slot1)
	slot0:UpdateMission(slot1)
	slot0:InitRanks()
	slot0:UpdateView()
	slot0:UpdatePainting()

	if slot0.contextData.editBossFleet then
		triggerButton(slot0.battleBtn)
	end

	setActive(slot0.battleBtn:Find("selected"), slot2)
	slot0:OnReportUpdated()

	slot0.titleTxt.text = slot1:getConfig("name")

	slot0:CheckFleetShipState()
	slot0.timeView:Flush(slot0.eventTimerTxt, getProxy(GuildProxy):getRawData():GetActiveEvent())
end

slot0.CheckFleetShipState = function (slot0)
	slot3 = {}

	for slot7, slot8 in ipairs(slot2) do
		if slot8:ExistInvailShips() or slot8:ExistInvaildCommanders() then
			table.insert(slot3, slot8)
		end
	end

	if #slot3 > 0 then
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("guild_boss_formation_exist_invaild_ship")
		})

		slot0.contextData.editBossFleet = {}

		for slot7, slot8 in ipairs(slot3) do
			slot0.contextData.editBossFleet[slot8.id] = slot8
		end

		slot0:emit(GuildEventMediator.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP)
	end
end

slot0.UpdateView = function (slot0)
	if getProxy(GuildProxy):ShouldRefreshBoss() then
		slot0:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	else
		slot0:UpdateBossInfo()
		slot0:AddBossTimer()
		slot0.super.Show(slot0)
	end
end

slot0.UpdatePainting = function (slot0)
	if slot0.bossMission:GetPainting() and slot2 ~= "" then
		PoolMgr.GetInstance():GetPainting(slot2, true, function (slot0)
			setParent(slot0, slot0.paintingTF:Find("fitter"), false)
		end)
	else
		LoadSpriteAsync("guildboss/" .. slot4, function (slot0)
			if slot0:CheckState(BaseSubView.STATES.DESTROY) then
				return
			end

			if slot0 then
				slot1 = GetOrAddComponent(slot0.prefabTF:Find("frame/model"), "Image")
				slot1.sprite = slot0

				slot1:SetNativeSize()
			end
		end)

		slot5 = slot0.findTF(slot0, "name/Image", slot0.prefabTF):GetComponent(typeof(Image))
		slot5.sprite = GetSpriteFromAtlas("guildboss/name_" .. slot4, "")

		slot5:SetNativeSize()
	end

	setActive(slot0.paintingTF, slot3)
	setActive(slot0.prefabTF, not slot3)
end

slot0.UpdateBossInfo = function (slot0)
	tf(slot0.hp).sizeDelta = Vector2(slot5, tf(slot0.hp).sizeDelta.y)
	slot0.hpProgress.text = math.max(slot0.bossMission.GetHp(slot1) / math.max(slot3, 1) * 100 - (slot0.bossMission.GetHp(slot1) / math.max(slot3, 1) * 100) % 0.1, 1) .. "%"
	slot0.cntTxt.text = "<color=" .. ((slot0.bossMission.GetCanUsageCnt(slot1) > 0 and COLOR_GREEN) or COLOR_RED) .. ">" .. slot7 .. "</color>/" .. GuildConst.MISSION_BOSS_MAX_CNT()
end

slot0.InitRanks = function (slot0)
	if getProxy(GuildProxy):ShouldRefreshBossRank() then
		slot0:emit(GuildEventMediator.ON_REFRESH_BOSS_RANK)
	else
		slot0:UpdateRank()
		slot0:AddRankTimer()
	end
end

slot0.UpdateRank = function (slot0)
	table.sort(slot1, function (slot0, slot1)
		return slot1.damage < slot0.damage
	end)
	slot0.rankList.make(slot2, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("no"), slot1 + 1)
			setText(slot2:Find("name"), slot0[slot1 + 1].name)
			setText(slot2:Find("Text"), slot0[slot1 + 1].damage)
		end
	end)
	slot0.rankList.align(slot2, math.min(3, #getProxy(GuildProxy):GetBossRank()))
	onButton(slot0, slot0.viewAllBtn, function ()
		slot0.allRankPage:ExecuteAction("Show", slot0.allRankPage)
	end, SFX_PANEL)
end

slot0.ExistActiveEvent = function (slot0)
	return getProxy(GuildProxy):getRawData():GetActiveEvent() and not slot1:IsExpired()
end

slot0.AddRankTimer = function (slot0)
	if not slot0:ExistActiveEvent() then
		return
	end

	if slot0.rankTimer then
		slot0.rankTimer:Stop()

		slot0.rankTimer = nil
	end

	slot1 = slot0.bossMission
	slot0.rankTimer = Timer.New(function ()
		slot0:emit(GuildEventMediator.ON_REFRESH_BOSS_RANK)
	end, GuildConst.FORCE_REFRESH_MISSION_BOSS_RANK_TIME, 1)

	slot0.rankTimer.Start(slot2)
end

slot0.AddBossTimer = function (slot0)
	if not slot0:ExistActiveEvent() then
		return
	end

	if slot0.bossTimer then
		slot0.bossTimer:Stop()

		slot0.bossTimer = nil
	end

	slot0.bossTimer = Timer.New(function ()
		slot0:emit(GuildEventMediator.ON_GET_BOSS_INFO)
	end, GuildConst.FORCE_REFRESH_BOSS_TIME, 1)

	slot0.bossTimer.Start(slot1)
end

slot0.OnDestroy = function (slot0)
	if slot0.rankTimer then
		slot0.rankTimer:Stop()

		slot0.rankTimer = nil
	end

	if slot0.bossTimer then
		slot0.bossTimer:Stop()

		slot0.bossTimer = nil
	end

	slot0.allRankPage:Destroy()
	slot0.timeView:Dispose()
end

return slot0

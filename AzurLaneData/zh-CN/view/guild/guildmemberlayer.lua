slot0 = class("GuildMemberLayer", import("..base.BaseUI"))

slot0.setGuildVO = function (slot0, slot1)
	slot0.guildVO = slot1

	slot0:setMemberVOs(slot1:getSortMember())
end

slot0.setMemberVOs = function (slot0, slot1)
	slot0.memberVOs = slot1
end

slot0.setPlayerVO = function (slot0, slot1)
	slot0.playerVO = slot1
end

slot0.SetRanks = function (slot0, slot1)
	slot0.ranks = slot1
end

slot0.getUIName = function (slot0)
	return "GuildMemberUI"
end

slot0.init = function (slot0)
	slot0.buttonsPanel = slot0:findTF("buttons_panel")
	slot0.toggleGroup = slot0:findTF("buttons_panel"):GetComponent(typeof(ToggleGroup))
	slot0.chatPanel = slot0:findTF("chat")

	setActive(slot0.chatPanel, false)
	setActive(slot0.buttonsPanel, false)

	slot0.btns = {
		slot0:findTF("buttons_panel/info_btn"),
		slot0:findTF("buttons_panel/duty_btn"),
		slot0:findTF("buttons_panel/fire_btn"),
		slot0:findTF("buttons_panel/impeach_btn")
	}
	slot0.helpBtn = slot0:findTF("help")
	slot0.pages = {
		GuildMemberInfoPage.New(slot0._tf, slot0.event),
		GuildAppiontPage.New(slot0._tf, slot0.event),
		GuildFirePage.New(slot0._tf, slot0.event),
		GuildImpeachPage.New(slot0._tf, slot0.event)
	}
	slot0.contextData.rankPage = GuildRankPage.New(slot0._tf, slot0.event)
	slot0.listPage = GuildMemberListPage.New(slot0._tf, slot0.event, slot0.contextData)

	slot0.listPage.OnClickMember = function (slot0)
		slot0:LoadPainting(slot0)
	end

	slot0.buttonPos = slot0.buttonsPanel.localPosition
end

slot0.didEnter = function (slot0)
	function slot1()
		if slot0.page then
			setActive(slot0.btns[table.indexof(slot0.pages, slot0.page)].Find(slot1, "sel"), false)
		end
	end

	for slot5, slot6 in ipairs(slot0.btns) do
		onButton(slot0, slot6, function ()
			if slot0 == 2 and slot1.memberVO:IsRecruit() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_trainee_duty_change_tip"))

				return
			end

			if slot1.page and not slot1.page:GetLoaded() then
				return
			end

			pg.UIMgr.GetInstance():LoadingOn()
			slot1.pages[].ExecuteAction(slot0, "Show", slot1.guildVO, slot1.playerVO, slot1.memberVO, function ()
				if slot0.page then
					slot0.page:Hide()
				end

				slot1()
				setActive(slot2:Find("sel"), true)

				setActive.page = slot3

				pg.UIMgr.GetInstance():LoadingOff()
			end)
		end, SFX_PANEL)
		slot0.pages[slot5].SetCallBack(slot7, function (slot0)
			slot0.buttonsPanel.localPosition = slot0

			setParent(slot0.buttonsPanel, pg.UIMgr:GetInstance().OverlayMain)
		end, function ()
			slot0()
			setParent(slot1.buttonsPanel, slot1._tf)

			slot1.buttonsPanel.localPosition = slot1.buttonsPanel.buttonPos
		end)
	end

	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.guild_member_tip.tip
		})
	end, SFX_PANEL)
	slot0.listPage.ExecuteAction(slot2, "SetUp", slot0.guildVO, slot0.memberVOs, slot0.ranks)
end

slot0.LoadPainting = function (slot0, slot1)
	slot0.memberVO = slot1
	slot2 = slot1.duty
	slot3 = slot0.guildVO:getDutyByMemberId(slot0.playerVO.id)

	setActive(slot0.buttonsPanel, true)

	if not slot1.manifesto or slot1.manifesto == "" then
		setActive(slot0.chatPanel, false)
	else
		setActive(slot0.chatPanel, true)
		setText(slot0:findTF("Text", slot0.chatPanel), slot1.manifesto)
	end

	pg.GuildPaintingMgr:GetInstance():Update(slot5, Vector3(-484, 0, 0))
	setActive(slot0.btns[4], slot3 == GuildConst.DUTY_DEPUTY_COMMANDER and slot2 == GuildConst.DUTY_COMMANDER and slot1:isLongOffLine())
	setButtonEnabled(slot0.btns[2], (slot3 == GuildConst.DUTY_DEPUTY_COMMANDER or slot3 == GuildConst.DUTY_COMMANDER) and slot3 < slot2)
	setGray(slot0.btns[2], not ((slot3 == GuildConst.DUTY_DEPUTY_COMMANDER or slot3 == GuildConst.DUTY_COMMANDER) and slot3 < slot2), true)
	setButtonEnabled(slot0.btns[3], (slot3 == GuildConst.DUTY_DEPUTY_COMMANDER or slot3 == GuildConst.DUTY_COMMANDER) and slot3 < slot2)
	setGray(slot0.btns[3], not ((slot3 == GuildConst.DUTY_DEPUTY_COMMANDER or slot3 == GuildConst.DUTY_COMMANDER) and slot3 < slot2), true)
end

slot0.RefreshMembers = function (slot0)
	if slot0.listPage:GetLoaded() then
		slot0.listPage:Flush(slot0.guildVO, slot0.memberVOs, slot0.ranks)
	end
end

slot0.ActiveDefaultMenmber = function (slot0)
	if slot0.listPage:GetLoaded() then
		slot0.listPage:TriggerFirstCard()
	end
end

slot0.UpdateRankList = function (slot0, slot1, slot2)
	slot0.ranks[slot1] = slot2

	if slot0.contextData.rankPage and slot0.contextData.rankPage:GetLoaded() then
		slot0.contextData.rankPage:ExecuteAction("OnUpdateRankList", slot1, slot2)
	end
end

slot0.ShowInfoPanel = function (slot0, slot1)
	slot0.pages[1]:ExecuteAction("Flush", slot1)
end

slot0.onBackPressed = function (slot0)
	for slot4, slot5 in ipairs(slot0.pages) do
		if slot5:GetLoaded() and slot5:isShowing() then
			slot5:Hide()

			return
		end
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	slot0:emit(slot0.ON_BACK)
end

slot0.willExit = function (slot0)
	slot0.contextData.rankPage:Destroy()

	slot0.listPage.OnClickMember = nil

	slot0.listPage:Destroy()

	for slot4, slot5 in ipairs(slot0.pages) do
		slot5:Destroy()
	end

	if isActive(pg.MsgboxMgr:GetInstance()._go) then
		triggerButton(pg.MsgboxMgr:GetInstance()._closeBtn)
	end
end

return slot0

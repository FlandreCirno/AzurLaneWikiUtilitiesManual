slot0 = class("WorldBossHelpPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "WorldBossHelpUI"
end

slot0.OnLoaded = function (slot0)
	slot0.friendBtn = slot0:findTF("window/sliders/content/friend")
	slot0.friendRequested = slot0.friendBtn:Find("requested")
	slot0.friendMark = slot0.friendBtn:Find("mark")
	slot0.guildBtn = slot0:findTF("window/sliders/content/guild")
	slot0.guildRequested = slot0.guildBtn:Find("requested")
	slot0.guildMark = slot0.guildBtn:Find("mark")
	slot0.worldBtn = slot0:findTF("window/sliders/content/world")
	slot0.worldRequested = slot0.worldBtn:Find("requested")
	slot0.worldMark = slot0.worldBtn:Find("mark")
	slot0.worldSupportTimeTxt = slot0.worldBtn:Find("requested/Text"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("cancel_btn"), function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("window/top/btnBack"), function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.friendBtn, function ()
		slot0.friendFlag = not slot0.friendFlag

		setActive(slot0.friendMark, slot0.friendFlag)
	end, SFX_PANEL)
	onButton(slot0, slot0.guildBtn, function ()
		slot0.guildFlag = not slot0.guildFlag

		setActive(slot0.guildMark, slot0.guildFlag)
	end, SFX_PANEL)
	onButton(slot0, slot0.worldBtn, function ()
		if slot0.boss:WorldSupported() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_boss_ask_help"))

			return
		end

		slot0.worldFlag = not slot0.worldFlag

		setActive(slot0.worldMark, slot0.worldFlag)
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("confirm_btn"), function ()
		slot0:emit(WorldBossMediator.ON_SURPPORT, {
			slot0.friendFlag,
			slot0.guildFlag,
			slot0.worldFlag
		})
		slot0.emit:Hide()
	end, SFX_PANEL)
end

slot0.Reset = function (slot0)
	slot0.friendFlag = false
	slot0.guildFlag = false
	slot0.worldFlag = false
end

slot0.Update = function (slot0, slot1)
	slot0.boss = slot1

	slot0:Reset()
	slot0:UpdateRequestItems()
	slot0:UpdateWorldRequetItem()
	slot0:Show()
end

slot0.UpdateRequestItems = function (slot0)
	setButtonEnabled(slot0.friendBtn, not slot0.boss.FriendSupported(slot1))
	setActive(slot0.friendRequested, slot2)
	setActive(slot0.friendMark, false)
	setButtonEnabled(slot0.guildBtn, not slot0.boss.GuildSupported(slot1))
	setActive(slot0.guildRequested, slot3)
	setActive(slot0.guildMark, false)
end

slot0.UpdateWorldRequetItem = function (slot0)
	setActive(slot0.worldRequested, slot2)
	setActive(slot0.worldMark, false)
	slot0:RemoveRequestTimer()

	if slot0.boss.WorldSupported(slot1) then
		slot0:AddRequestTimer()
	end
end

slot0.AddRequestTimer = function (slot0)
	slot2 = slot0.boss.GetNextWorldSupportTime(slot1)
	slot0.timer = Timer.New(function ()
		if slot0 - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
			slot1.worldSupportTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(slot1)
		else
			slot1.worldSupportTimeTxt.text = ""

			slot1:RemoveRequestTimer()
			slot1:UpdateWorldRequetItem()
		end
	end, 1, -1)

	slot0.timer.Start(slot3)
	slot0.timer.func()
end

slot0.RemoveRequestTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()
	slot0:RemoveRequestTimer()
end

return slot0

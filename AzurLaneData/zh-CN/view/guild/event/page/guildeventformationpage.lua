slot0 = class("GuildEventFormationPage", import(".GuildEventBasePage"))

slot0.getUIName = function (slot0)
	return "GuildEventFormationUI"
end

slot0.OnLoaded = function (slot0)
	slot0.tpl = slot0._go:GetComponent("ItemList").prefabItem[0]
	slot0.closeBtn = slot0:findTF("frame/close")
	slot0.sendBtn = slot0:findTF("frame/btn")
	slot0.sendBtnGray = slot0:findTF("frame/btn/gray")
	slot0.slots = {
		slot0:findTF("frame/ship1"),
		slot0:findTF("frame/ship2")
	}
	slot0.items = {}
	slot0.cdTimer = {}
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()

		slot0.Hide.contextData.editFleet = nil
	end, SFX_PANEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()

		slot0.Hide.contextData.editFleet = nil
	end, SFX_PANEL)
end

slot0.OnFleetUpdated = function (slot0, slot1)
	slot0.extraData.fleet = slot1

	slot0:UpdateSlots()
end

slot0.OnFleetFormationDone = function (slot0)
	for slot4, slot5 in ipairs(slot0.slots) do
		slot0:RefreshCdTimer(slot4)
	end

	slot0:UpdateSendBtn()
end

slot0.OnShow = function (slot0)
	if not getProxy(GuildProxy).isFetchAssaultFleet then
		slot0:emit(GuildEventMediator.ON_GET_FORMATION)
	else
		slot0:UpdateSlots()
	end

	slot0:UpdateSendBtn()
end

slot0.UpdateSendBtn = function (slot0)
	setActive(slot0.sendBtnGray, not slot0.contextData.editFleet or (slot0.contextData.editFleet and not slot0.extraData.fleet:AnyShipChanged(slot0.contextData.editFleet)))

	if not slot0.contextData.editFleet or (slot0.contextData.editFleet and not slot0.extraData.fleet.AnyShipChanged(slot0.contextData.editFleet)) then
		removeOnButton(slot0.sendBtn)

		return
	end

	onButton(slot0, slot0.sendBtn, function ()
		if slot0.existBossBattle then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end

		slot0:emit(GuildEventMediator.UPDATE_FORMATION)
	end, SFX_PANEL)
end

slot0.UpdateSlots = function (slot0)
	slot0.fleet = slot0.contextData.editFleet or slot0.extraData.fleet
	slot1 = slot0.fleet
	slot0.existBossBattle = slot0.guild:GetActiveEvent() and slot3:GetBossMission() and slot0.guild.GetActiveEvent() and slot3.GetBossMission():IsActive()

	for slot8, slot9 in ipairs(slot0.slots) do
		slot0:UpdateSlot(slot8, slot9, slot0.fleet:GetShipByPos(slot8))
		slot0:RefreshCdTimer(slot8)
	end
end

slot0.ShipIsBattle = function (slot0, slot1)
	return slot0.existBossBattle
end

slot0.UpdateSlot = function (slot0, slot1, slot2, slot3)
	slot4 = slot0.guild
	slot5 = slot2:Find("ship")
	slot6 = slot2:Find("tag/tag")

	if slot3 then
		if not slot5 then
			cloneTplTo(slot0.tpl, slot2):SetAsFirstSibling()
		end

		slot0.items[slot1] or DockyardShipItem.New(slot5):update(slot3)

		slot0.items[slot1] or DockyardShipItem.New(slot5).go.name = "ship"

		setActive(slot6, slot0:ShipIsBattle(slot3))
	elseif slot5 then
		setActive(slot5, false)
		setActive(slot6, false)
	else
		setActive(slot6, false)
	end

	onButton(slot0, (slot3 and slot5) or slot2, function ()
		if not getProxy(GuildProxy):CanFormationPos(getProxy(GuildProxy).CanFormationPos) then
			return
		end

		if slot1.existBossBattle then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end

		slot1:emit(GuildEventMediator.ON_SELECT_SHIP, slot1.emit, , slot1.fleet)
	end, SFX_PANEL)
end

slot0.RefreshCdTimer = function (slot0, slot1)
	slot3 = slot0.slots[slot1].Find(slot2, "tag/timer")
	slot4 = slot3:Find("Text"):GetComponent(typeof(Text))
	slot5 = slot0.slots[slot1].Find(slot2, "tag/tag")

	setActive(slot3, false)
	slot0:RemoveTimer(slot1)

	if not getProxy(GuildProxy):CanFormationPos(slot1) then
		slot0.cdTimer[slot1] = Timer.New(function ()
			if getProxy(GuildProxy):GetNextCanFormationTime(getProxy(GuildProxy).GetNextCanFormationTime) - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
				slot1.text = pg.TimeMgr:GetInstance():DescCDTime(slot1)
			else
				setActive(setActive, false)
				setActive(setActive:Find("tag"), isActive(isActive))
			end
		end, 1, -1)

		slot0.cdTimer[slot1].Start(slot7)
		slot0.cdTimer[slot1].func()
		setActive(slot3, true)
	end

	setActive(slot2:Find("tag"), isActive(slot5) or slot6)
end

slot0.RemoveTimer = function (slot0, slot1)
	if slot0.cdTimer[slot1] then
		slot0.cdTimer[slot1]:Stop()

		slot0.cdTimer[slot1] = nil
	end
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)

	for slot4, slot5 in pairs(slot0.cdTimer) do
		slot0:RemoveTimer(slot4)
	end
end

return slot0

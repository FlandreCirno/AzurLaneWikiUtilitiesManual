slot0 = class("CommanderHomeSelCommanderPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "CommanderHomeSelCommanderPage"
end

slot0.OnCatteryUpdate = function (slot0, slot1)
	slot0.cattery = slot1

	slot0:Update(slot0.home, slot1)
end

slot0.OnLoaded = function (slot0)
	slot0.scrollrect = slot0:findTF("scrollrect"):GetComponent("LScrollRect")
	slot0.okBtn = slot0:findTF("ok_button")

	setActive(slot0._tf, true)
end

slot0.OnInit = function (slot0)
	slot0.selectedID = -1
	slot0.cards = {}

	slot0.scrollrect.onInitItem = function (slot0)
		slot0:OnInitItem(slot0)
	end

	slot0.scrollrect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end

	onButton(slot0, slot0.okBtn, function ()
		if slot0.selectedID >= 0 then
			slot0:emit(CommanderHomeMediator.ON_SEL_COMMANDER, slot0.cattery.id, slot0.selectedID)
		end
	end, SFX_PANEL)
end

slot0.OnInitItem = function (slot0, slot1)
	onButton(slot0, CommamderCard.New(slot1)._tf, function ()
		if slot0.commanderVO then
			slot1, slot2 = slot1:Check(slot0.commanderVO.id)

			if slot1 then
				if slot1.mark then
					setActive(slot1.mark, false)
				end

				if slot1.selectedID == slot0 then
					slot1.selectedID = 0
					slot1.mark = nil

					slot1:emit(CatteryDescPage.CHANGE_COMMANDER, nil)
				else
					setActive(slot0.mark2, true)

					slot1.mark = slot0.mark2
					slot1.selectedID = slot0

					slot1:emit(CatteryDescPage.CHANGE_COMMANDER, slot0.commanderVO)
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(slot2)
			end
		end
	end, SFX_PANEL)

	slot0.cards[slot1] = CommamderCard.New(slot1)
end

slot0.Check = function (slot0, slot1)
	for slot6, slot7 in ipairs(slot2) do
		if slot7:GetCommanderId() == slot1 and slot7.id ~= slot0.cattery.id then
			return false, i18n("commander_is_in_cattery")
		end
	end

	return true
end

slot0.CheckIncludeSelf = function (slot0, slot1)
	for slot6, slot7 in ipairs(slot2) do
		if slot7:GetCommanderId() == slot1 then
			return false
		end
	end

	return true
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	slot3 = slot0.cards[slot2]

	if not cards then
		slot0:OnInitItem(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:update(slot0.displays[slot1 + 1])

	if slot0.displays[slot1 + 1] then
		setActive(slot3.mark2, slot0.selectedID == slot5.id)

		if slot0.selectedID == slot5.id then
			slot0.mark = slot3.mark2
		end

		setActive(slot3._tf:Find("info/home"), not slot0:CheckIncludeSelf(slot5.id))
	end

	setActive(slot3._tf:Find("line"), slot4 % 4 == 1)
end

slot0.Update = function (slot0, slot1, slot2)
	slot0:Show()

	slot0.home = slot1
	slot0.cattery = slot2
	slot0.displays = {}

	for slot7, slot8 in pairs(slot3) do
		table.insert(slot0.displays, slot8)
	end

	if slot2:GetCommanderId() ~= 0 then
		slot0.selectedID = slot4
	end

	slot5 = getProxy(FleetProxy):getCommandersInFleet()

	table.sort(slot0.displays, function (slot0, slot1)
		if ((table.contains(slot0, slot0.id) and 1) or 0) == ((table.contains(slot0, slot1.id) and 1) or 0) then
			return slot1.level < slot0.level
		else
			return slot3 < slot2
		end
	end)

	slot7 = 8 - #slot0.displays

	for slot11 = 1, slot7, 1 do
		table.insert(slot0.displays, false)
	end

	slot0.scrollrect:SetTotalCount(#slot0.displays, -1)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)

	slot0.selectedID = -1
	slot0.mark = nil
end

slot0.OnDestroy = function (slot0)
	for slot4, slot5 in pairs(slot0.cards) do
		slot5:clear()
	end
end

return slot0

slot0 = class("WSFleetPanel", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	onCancel = "function",
	btnGo = "userdata",
	rtLimitTips = "userdata",
	toggles = "table",
	btnBack = "userdata",
	rtEmptyTpl = "userdata",
	fleets = "table",
	toggleMask = "userdata",
	rtShipTpl = "userdata",
	transform = "userdata",
	toggleList = "userdata",
	onConfirm = "function",
	rtFleets = "table",
	rtLimitElite = "userdata",
	rtLimit = "userdata",
	selectIds = "table"
}

slot0.Setup = function (slot0)
	pg.DelegateInfo.New(slot0)
	slot0:Init()
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
	slot0:Clear()
end

slot0.Init = function (slot0)
	slot0.rtShipTpl = slot0.transform.Find(slot1, "panel/shiptpl")
	slot0.rtEmptyTpl = slot0.transform.Find(slot1, "panel/emptytpl")
	slot0.rtFleets = {
		[FleetType.Normal] = {
			slot0.transform.Find(slot1, "panel/bg/content/fleet/1"),
			slot0.transform.Find(slot1, "panel/bg/content/fleet/2"),
			slot0.transform.Find(slot1, "panel/bg/content/fleet/3"),
			slot0.transform.Find(slot1, "panel/bg/content/fleet/4")
		},
		[FleetType.Submarine] = {
			slot0.transform:Find("panel/bg/content/sub/1")
		}
	}
	slot0.rtLimit = slot0.transform.Find(slot1, "panel/limit")
	slot0.rtLimitElite = slot0.transform.Find(slot1, "panel/limit_elite")
	slot0.rtLimitTips = slot0.transform.Find(slot1, "panel/limit_tip")
	slot0.btnBack = slot0.transform.Find(slot1, "panel/btnBack")
	slot0.btnGo = slot0.transform.Find(slot1, "panel/start_button")
	slot0.toggleMask = slot0.transform.Find(slot1, "mask")
	slot0.toggleList = slot0.transform.Find(slot1, "mask/list")
	slot0.toggles = {}

	for slot5 = 0, slot0.toggleList.childCount - 1, 1 do
		table.insert(slot0.toggles, slot0.toggleList:Find("item" .. slot5 + 1))
	end

	setActive(slot0.rtShipTpl, false)
	setActive(slot0.rtEmptyTpl, false)
	setActive(slot0.toggleMask, false)
end

slot0.UpdateMulti = function (slot0, slot1, slot2, slot3)
	slot0.map = slot1
	slot0.fleets = _(_.values(slot2)):chain():filter(function (slot0)
		return slot0:isRegularFleet()
	end).sort(slot4, function (slot0, slot1)
		return slot0.id < slot1.id
	end).value(slot4)
	slot0.selectIds = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}
	slot4 = ipairs
	slot5 = slot3 or {}

	for slot7, slot8 in slot4(slot5) do
		if slot0:getFleetById(slot8) and #slot0.selectIds[slot9:getFleetType()] < slot0:getLimitNums(slot9.getFleetType()) then
			table.insert(slot11, slot8)
		end
	end

	setActive(slot0.rtLimitElite, false)
	setActive(slot0.rtLimitTips, false)
	setActive(slot0.rtLimit, true)
	onButton(slot0, slot0.btnGo, function ()
		slot0.onConfirm(slot0:getSelectIds())
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(slot0, slot0.btnBack, function ()
		slot0.onCancel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.transform, function ()
		slot0.onCancel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.toggleMask, function ()
		slot0:hideToggleMask()
	end, SFX_CANCEL)
	slot0.clearFleets(slot0)
	slot0:updateFleets()
	slot0:updateLimit()
end

slot0.getFleetById = function (slot0, slot1)
	return _.detect(slot0.fleets, function (slot0)
		return slot0.id == slot0
	end)
end

slot0.getLimitNums = function (slot0, slot1)
	slot2 = 0

	if slot1 == FleetType.Normal then
		slot2 = 4
	elseif slot1 == FleetType.Submarine then
		slot2 = 1
	end

	return slot2
end

slot0.getSelectIds = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.selectIds) do
		for slot10, slot11 in ipairs(slot6) do
			if slot11 > 0 then
				table.insert(slot1, slot11)
			end
		end
	end

	_.sort(slot1, function (slot0, slot1)
		return slot0 < slot1
	end)

	return slot1
end

slot0.updateFleets = function (slot0)
	for slot4, slot5 in pairs(slot0.rtFleets) do
		for slot9 = 1, #slot5, 1 do
			slot0:updateFleet(slot4, slot9)
		end
	end
end

slot0.updateLimit = function (slot0)
	setText(slot0.rtLimit:Find("number"), string.format("%d/%d", slot1, slot3))
	setText(slot0.rtLimit:Find("number_sub"), string.format("%d/%d", #_.filter(slot0.selectIds[FleetType.Submarine], function (slot0)
		return slot0 > 0
	end), slot0:getLimitNums(FleetType.Submarine)))
end

slot0.selectFleet = function (slot0, slot1, slot2, slot3)
	if fleetId ~= slot3 then
		slot4 = slot0.selectIds[slot1]

		if slot3 > 0 and table.contains(slot4, slot3) then
			return
		end

		if slot1 == FleetType.Normal and slot0:getLimitNums(slot1) > 0 and slot3 == 0 and #_.filter(slot4, function (slot0)
			return slot0 > 0
		end) == 1 then
			pg.TipsMgr.GetInstance().ShowTips(slot5, i18n("level_fleet_lease_one_ship"))

			return
		end

		if slot0:getFleetById(slot3) then
			if not slot5:isUnlock() then
				return
			end

			if slot5:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

				return
			end
		end

		slot4[slot2] = slot3

		slot0:updateFleet(slot1, slot2)
		slot0:updateLimit()
	end
end

slot0.updateFleet = function (slot0, slot1, slot2)
	slot5 = slot0:getFleetById(slot4)
	slot10 = slot0.rtFleets[slot1][slot2].Find(slot7, "vanguard")
	slot11 = slot0.rtFleets[slot1][slot2].Find(slot7, "sub")

	setText(slot8, "")
	setActive(slot16, false)
	setActive(slot12, slot2 <= slot0:getLimitNums(slot1))
	setActive(slot14, slot2 <= slot0.getLimitNums(slot1))
	setActive(slot13, false)
	setActive(slot0.rtFleets[slot1][slot2].Find(slot7, "blank"), not (slot2 <= slot0.getLimitNums(slot1)))

	if slot0.rtFleets[slot1][slot2].Find(slot7, "main") then
		setActive(slot9, slot6 and slot5)
	end

	if slot10 then
		setActive(slot10, slot6 and slot5)
	end

	if slot11 then
		setActive(slot11, slot6 and slot5)
	end

	if slot6 then
		if slot5 then
			setText(slot8, (slot5.name == "" and Fleet.DEFAULT_NAME[slot5.id]) or slot5.name)

			if slot1 == FleetType.Submarine then
				slot0:updateShips(slot11, slot5.subShips)
			else
				slot0:updateShips(slot9, slot5.mainShips)
				slot0:updateShips(slot10, slot5.vanguardShips)
			end
		end

		onButton(slot0, slot12, function ()
			slot0.toggleList.position = (slot1.position + slot2.position) / 2
			slot0.toggleList.toggleList.anchoredPosition = slot0.toggleList.anchoredPosition + Vector2(-slot0.toggleList.rect.width / 2, -slot1.rect.height / 2)

			slot0.toggleList.toggleList:showToggleMask(-slot0.toggleList.rect.width / 2, function (slot0)
				slot0:hideToggleMask()
				slot0:selectFleet(slot0.selectFleet, slot0, slot0)
			end)
		end, SFX_UI_CLICK)
		onButton(slot0, slot14, function ()
			slot0:selectFleet(slot0, , 0)
		end, SFX_UI_CLICK)
	end
end

slot0.updateShips = function (slot0, slot1, slot2)
	slot3 = UIItemList.New(slot1, slot0.rtShipTpl)

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = getProxy(BayProxy).getShipById(slot3, slot0[slot1 + 1])

			updateShip(slot2, slot4)

			slot5 = slot2:Find("icon_bg/energy")

			if slot4:getEnergeConfig() and slot6.id <= 2 then
				setActive(slot5, true)
				GetImageSpriteFromAtlasAsync("energy", slot6.icon, slot5)
			else
				setActive(slot5, false)
			end
		end
	end)
	slot3.align(slot3, #slot2)
end

slot0.showToggleMask = function (slot0, slot1, slot2)
	setActive(slot0.toggleMask, true)

	slot3 = _.filter(slot0.fleets, function (slot0)
		return slot0:getFleetType() == slot0
	end)

	for slot7, slot8 in ipairs(slot0.toggles) do
		setActive(slot8, slot3[slot7])

		if slot3[slot7] then
			slot15, slot11 = slot9:isUnlock()

			setButtonEnabled(slot8, slot10)
			setActive(slot8:Find("lock"), not slot10)

			if slot10 then
				slot13 = table.contains(slot0.selectIds[slot1], slot9.id)

				setActive(slot8:Find("selected"), slot13)
				setActive(slot8:Find("text"), not slot13)
				setActive(slot8:Find("text_selected"), slot13)
				onButton(slot0, slot8, function ()
					slot0(slot1.id)
				end, SFX_UI_TAG)
			else
				onButton(slot0, slot12, function ()
					pg.TipsMgr.GetInstance():ShowTips(pg.TipsMgr.GetInstance().ShowTips)
				end, SFX_UI_CLICK)
			end
		end
	end
end

slot0.hideToggleMask = function (slot0)
	setActive(slot0.toggleMask, false)
end

slot0.clearFleets = function (slot0)
	for slot4, slot5 in pairs(slot0.rtFleets) do
		_.each(slot5, function (slot0)
			slot0:clearFleet(slot0)
		end)
	end
end

slot0.clearFleet = function (slot0, slot1)
	slot3 = slot1:Find("vanguard")
	slot4 = slot1:Find("sub")

	if slot1:Find("main") then
		removeAllChildren(slot2)
	end

	if slot3 then
		removeAllChildren(slot3)
	end

	if slot4 then
		removeAllChildren(slot4)
	end
end

return slot0

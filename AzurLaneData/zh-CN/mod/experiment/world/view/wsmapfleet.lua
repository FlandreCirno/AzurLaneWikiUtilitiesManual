slot0 = class("WSMapFleet", import(".WSMapTransform"))
slot0.Fields = {
	rtFx = "userdata",
	timerHealth = "table",
	rtArrow = "userdata",
	rtDamage = "userdata",
	selected = "boolean",
	rtHealth = "userdata",
	rtSub = "userdata",
	rtMoveTurn = "userdata",
	theme = "table",
	attaches = "table",
	moveTurnCount = "number",
	rtShadow = "userdata",
	rtRetreat = "userdata",
	fleet = "table",
	active = "boolean",
	submarineSupport = "boolean"
}
slot0.Listeners = {
	onUpdate = "Update"
}
slot0.EventUpdateSelected = "WSMapFleet.EventUpdateSelected"

slot0.GetResName = function (slot0)
	return "ship_tpl"
end

slot0.Setup = function (slot0, slot1, slot2)
	slot0.fleet = slot1

	slot0.fleet:AddListener(WorldMapFleet.EventUpdateLocation, slot0.onUpdate)
	slot0.fleet:AddListener(WorldMapFleet.EventUpdateShipOrder, slot0.onUpdate)
	slot0.fleet:AddListener(WorldMapFleet.EventUpdateBuff, slot0.onUpdate)
	slot0.fleet:AddListener(WorldMapFleet.EventUpdateDamageLevel, slot0.onUpdate)

	slot0.theme = slot2
	slot0.attaches = {}

	slot0:Init()
end

slot0.Dispose = function (slot0)
	slot0.fleet:RemoveListener(WorldMapFleet.EventUpdateLocation, slot0.onUpdate)
	slot0.fleet:RemoveListener(WorldMapFleet.EventUpdateShipOrder, slot0.onUpdate)
	slot0.fleet:RemoveListener(WorldMapFleet.EventUpdateBuff, slot0.onUpdate)
	slot0.fleet:RemoveListener(WorldMapFleet.EventUpdateDamageLevel, slot0.onUpdate)
	slot0:ClearAttaches()
	slot0:ClearHealthTimer()
	slot0.super.Dispose(slot0)
end

slot0.Init = function (slot0)
	slot0.rtRetreat = slot0.transform:Find("retreat")
	slot0.rtArrow = slot0.transform:Find("arrow")
	slot0.rtFx = slot0.transform:Find("fx")
	slot0.rtShadow = slot0.transform:Find("shadow")
	slot0.rtSub = slot0.transform:Find("marks/sub")
	slot0.rtDamage = slot0.transform:Find("marks/damage")
	slot0.rtMoveTurn = slot0.transform:Find("marks/move_turn")
	slot0.rtHealth = slot0.transform:Find("Health")

	setActive(slot0.rtRetreat, false)
	setActive(slot0.rtArrow, false)
	setActive(slot0.rtSub, false)
	setActive(slot0.rtDamage, false)
	setActive(slot0.rtMoveTurn, false)
	setActive(slot0.rtHealth, false)

	slot0.transform.name = "fleet_" .. slot0.fleet.id
	slot0.transform.localEulerAngles = Vector3(-slot0.theme.angle, 0, 0)
	slot0.rtShadow.localPosition = Vector3.zero

	slot0:Update()
	slot0:UpdateActive(slot0.active or true)
	slot0:UpdateSelected(slot0.selected or false)
	slot0:UpdateSubmarineSupport()
	slot0:UpdateModelScale(Vector3(0.4, 0.4, 1))
	slot0:UpdateModelAngles(Vector3.zero)

	slot0.moveTurnCount = 0
end

slot0.Update = function (slot0, slot1)
	slot2 = slot0.fleet

	if slot1 == nil or (slot1 == WorldMapFleet.EventUpdateLocation and not slot0.isMoving) then
		slot0.transform.anchoredPosition3D = slot0.theme:GetLinePosition(slot2.row, slot2.column)
	end

	if slot1 == nil or slot1 == WorldMapFleet.EventUpdateLocation then
		slot0:SetModelOrder(WorldConst.LOFleet, slot2.row)
		underscore.each(slot0.attaches, function (slot0)
			slot0.modelOrder = slot0.modelOrder
		end)
	end

	if slot1 == nil or slot1 == WorldMapFleet.EventUpdateShipOrder then
		slot0.LoadModel(slot0, WorldConst.ModelSpine, slot2:GetPrefab(), nil, true, function ()
			slot0.model:SetParent(slot0.transform:Find("ship"), false)
		end)
	end

	if slot1 == nil or slot1 == WorldMapFleet.EventUpdateBuff then
		slot0.UpdateAttaches(slot0)
	end

	if slot1 == nil or slot1 == WorldMapFleet.EventUpdateDamageLevel then
		slot0:UpdateDamageLevel()
	end
end

slot0.UpdateActive = function (slot0, slot1)
	if slot0.active ~= slot1 then
		slot0.active = slot1

		setActive(slot0.transform, slot0.active)
	end
end

slot0.UpdateSelected = function (slot0, slot1)
	if slot0.selected ~= slot1 then
		slot0.selected = slot1

		setActive(slot0.rtArrow, slot0.selected)
		slot0:DispatchEvent(slot0.EventUpdateSelected)
	end
end

slot0.UpdateSubmarineSupport = function (slot0)
	setActive(slot0.rtSub, nowWorld:IsSubmarineSupporting())

	if nowWorld.IsSubmarineSupporting() then
		setGray(slot0.rtSub, not nowWorld:GetSubAidFlag(), false)
	end
end

slot0.UpdateAttaches = function (slot0)
	for slot5 = #slot0.fleet:GetBuffFxList() + 1, #slot0.attaches, 1 do
		slot0.attaches[slot5]:Unload()
	end

	for slot5 = #slot0.attaches + 1, #slot1, 1 do
		slot6 = WPool:Get(WSMapEffect)
		slot6.transform = createNewGameObject("mapEffect")

		slot6.transform:SetParent(slot0.rtFx, false)

		slot6.modelOrder = slot0.modelOrder

		table.insert(slot0.attaches, slot6)
	end

	for slot5 = 1, #slot1, 1 do
		slot0.attaches[slot5].Setup(slot6, WorldConst.GetBuffEffect(slot1[slot5]))
		slot0.attaches[slot5]:Load()
	end
end

slot0.ClearAttaches = function (slot0)
	WPool.ReturnArray(slot2, slot0.attaches)

	for slot5, slot6 in ipairs(slot1) do
		Destroy(slot6)
	end

	slot0.attaches = {}
end

slot0.UpdateDamageLevel = function (slot0)
	setActive(slot0.rtDamage, slot0.fleet.damageLevel > 0)

	for slot5 = 1, #WorldConst.DamageBuffList, 1 do
		setActive(slot0.rtDamage:Find(slot5), slot1 == slot5)
	end
end

slot0.PlusMoveTurn = function (slot0)
	slot0.moveTurnCount = slot0.moveTurnCount + 1

	setText(slot0.rtMoveTurn:Find("Text"), slot0.moveTurnCount)
	setActive(slot0.rtMoveTurn, slot0.moveTurnCount > 0)
end

slot0.ClearMoveTurn = function (slot0)
	slot0.moveTurnCount = 0

	setActive(slot0.rtMoveTurn, false)
end

slot0.DisplayHealth = function (slot0)
	slot0:ClearHealthTimer()
	setActive(slot0.rtHealth, true)

	slot0.timerHealth = Timer.New(function ()
		setActive(slot0.rtHealth, false)

		setActive.timerHealth = nil
	end, 2)

	slot0.timerHealth.Start(slot1)
end

slot0.ClearHealthTimer = function (slot0)
	if slot0.timerHealth then
		slot0.timerHealth:Stop()

		slot0.timerHealth = nil

		setActive(slot0.rtHealth, false)
	end
end

return slot0

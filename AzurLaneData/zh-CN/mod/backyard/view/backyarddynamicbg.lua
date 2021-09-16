slot0 = class("BackYardDynamicBg")

slot0.Ctor = function (slot0, slot1)
	slot0.parent = slot1
	slot0.prefab = nil
	slot0.trigger = nil
end

slot0.Switch = function (slot0, slot1, slot2, slot3)
	slot4 = (slot0.prefab and slot0.prefab.name) or ""

	if slot1 and slot4 ~= slot2 then
		if slot0.trigger then
			triggerButton(slot0.trigger)

			slot0.trigger = nil
		end

		slot0:LoadBG(slot2)

		slot0.trigger = slot3
	elseif slot1 and slot4 == slot2 then
	elseif not slot1 and slot4 == slot2 then
		slot0:Clear()

		slot0.trigger = nil
	end
end

slot0.LoadBG = function (slot0, slot1)
	PoolMgr.GetInstance():GetPrefab("BackyardBG/" .. slot1, slot1, true, function (slot0)
		if slot0.exited then
			PoolMgr.GetInstance():ReturnPrefab("BackyardBG/" .. slot1, PoolMgr.GetInstance().ReturnPrefab, slot0)
		end

		slot0.name = slot1

		setParent(slot0, slot0.parent)
		setActive(slot0, true)

		slot0.prefab = slot0
	end)
end

slot0.Clear = function (slot0)
	if slot0.prefab then
		PoolMgr.GetInstance():ReturnPrefab("BackyardBG/" .. slot1, slot0.prefab.name, slot0.prefab)

		slot0.prefab = nil
	end
end

slot0.ClearByName = function (slot0, slot1)
	if slot0.prefab and slot0.prefab.name == slot1 then
		slot0:Clear()

		slot0.trigger = nil
	end
end

slot0.Dispose = function (slot0)
	slot0:Clear(true)

	slot0.exited = true
end

return slot0

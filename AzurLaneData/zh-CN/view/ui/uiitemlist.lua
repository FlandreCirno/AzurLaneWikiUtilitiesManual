slot0 = class("UIItemList")
slot0.EventInit = 1
slot0.EventUpdate = 2
slot0.EventExcess = 3

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.container = slot1
	slot0.item = slot2
end

slot0.make = function (slot0, slot1)
	slot0.callback = slot1
end

slot0.align = function (slot0, slot1)
	for slot7 = slot1, slot0.container.childCount - 1, 1 do
		setActive(slot2:GetChild(slot7), false)

		if slot0.callback then
			slot0.callback(slot0.EventExcess, slot7, slot8)
		end
	end

	for slot7 = slot3, slot1 - 1, 1 do
		slot8 = cloneTplTo(slot0.item, slot2)

		if slot0.callback then
			slot0.callback(slot0.EventInit, slot7, slot8)
		end
	end

	for slot7 = 0, slot1 - 1, 1 do
		setActive(slot2:GetChild(slot7), true)

		if slot0.callback then
			slot0.callback(slot0.EventUpdate, slot7, slot8)
		end
	end
end

slot0.each = function (slot0, slot1)
	for slot5 = slot0.container.childCount - 1, 0, -1 do
		slot1(slot5, slot0.container:GetChild(slot5))
	end
end

slot0.eachActive = function (slot0, slot1)
	for slot5 = 0, slot0.container.childCount - 1, 1 do
		if isActive(slot0.container:GetChild(slot5)) then
			slot1(slot5, slot6)
		end
	end
end

slot0.StaticAlign = function (slot0, slot1, slot2, slot3)
	for slot8 = slot2, slot0.childCount - 1, 1 do
		setActive(slot0:GetChild(slot8), false)

		if slot3 then
			slot3(slot0.EventExcess, slot8, slot9)
		end
	end

	for slot8 = slot4, slot2 - 1, 1 do
		slot9 = cloneTplTo(slot1, slot0)

		if slot3 then
			slot3(slot0.EventInit, slot8, slot9)
		end
	end

	for slot8 = 0, slot2 - 1, 1 do
		setActive(slot0:GetChild(slot8), true)

		if slot3 then
			slot3(slot0.EventUpdate, slot8, slot9)
		end
	end
end

return slot0

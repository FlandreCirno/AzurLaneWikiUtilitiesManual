pg = pg or {}
pg.BackYardSortMgr = singletonClass("BackYardSortMgr")

pg.BackYardSortMgr.Ctor = function (slot0)
	slot0:ResetSortGroup()

	slot0.sortGroupList = {}
	slot0.maxNum = 9999
end

pg.BackYardSortMgr.Init = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.sortGroup = slot1
	slot0.floorContain = slot2
	slot0.furModelDic = slot3
	slot0.shipModelDic = slot4
	slot0.map = slot5
end

pg.BackYardSortMgr.InitUISortingOrder = function (slot0, slot1, slot2)
	GetComponent(slot1, "Canvas").sortingOrder = -104
	GetComponent(slot2, "Canvas").sortingOrder = -102
end

pg.BackYardSortMgr.ResetSortGroup = function (slot0)
	slot0.sortDataPool = slot0.sortDataPool or {}
	slot0.sortDataList = slot0.sortDataList or {}

	for slot4 = #slot0.sortDataList, 1, -1 do
		slot0.sortDataPool[#slot0.sortDataPool + 1] = table.remove(slot0.sortDataList, slot4)
	end

	slot0.layerNum = -100
end

pg.BackYardSortMgr.SortHandler = function (slot0)
	slot0:ResetSortGroup()
	slot0:CheckCreateSortGroup()

	for slot4 = #slot0.map.sortedItems, 1, -1 do
		if slot0.map.sortedItems[slot4].ob.isBoat then
			slot0:AddShipToSortGroup(slot0.shipModelDic[slot5.ob.id], slot4 - 1)
		else
			slot0:AddToSortGroup(slot0.furModelDic[slot5.ob.id], slot4 - 1)
		end
	end
end

pg.BackYardSortMgr.AddShipToSortGroup = function (slot0, slot1, slot2, slot3)
	if slot1.onDrag then
		return
	end

	slot8, slot5 = slot0:GetSortGroupCon(slot2)

	slot1:SetParent(slot4, slot3)
	slot1:SetAsFirstSibling()
end

pg.BackYardSortMgr.AddToSortGroup = function (slot0, slot1, slot2, slot3)
	slot4, slot5, slot6 = slot0:GetSortGroupCon(slot2)

	if slot1.furnitureVO:is3DObject() then
		slot0:ChangeOrder(slot6 + 1, slot1._tf)
	end

	slot1:SetParent(slot4, slot3)
	slot1:SetAsFirstSibling()
end

pg.BackYardSortMgr.AddToTopSortGroup = function (slot0, slot1, slot2)
	slot7, slot4 = slot0:GetSortGroupCon(slot0.maxNum)

	slot1:SetParent(slot3, slot2)
end

pg.BackYardSortMgr.CheckCreateSortGroup = function (slot0)
	function slot1(slot0)
		slot3 = nil
		(#slot0.sortDataPool <= 0 or table.remove(slot0.sortDataPool)) and {}.startIndex = slot0
		(#slot0.sortDataPool <= 0 or table.remove(slot0.sortDataPool)) and .endIndex = slot0.maxNum
		(#slot0.sortDataPool <= 0 or table.remove(slot0.sortDataPool)) and .order = slot0.layerNum + slot1 * 2
		slot0.sortDataList[#slot0.sortDataList + 1] = (#slot0.sortDataPool <= 0 or table.remove(slot0.sortDataPool)) and 

		if slot0.sortDataList[slot1] then
			slot0.sortDataList[slot1].endIndex = slot0 - 1
		end

		slot5 = nil

		while slot2 > #slot0.sortGroupList do
			SetParent(slot5, slot0.floorContain, false)

			slot0.sortGroupList[#slot0.sortGroupList + 1] = tf(Instantiate(slot0.sortGroup))
		end

		GetComponent(slot0.sortGroupList[slot2], typeof(Canvas)).sortingOrder = slot4
	end

	slot2 = false

	for slot6, slot7 in ipairs(slot0.map.sortedItems) do
		if slot7.ob.isBoat then
			if #slot0.sortDataList == 0 then
				slot1(slot6 - 1)
			end
		elseif slot0.furModelDic[slot7.ob.id].furnitureVO:is3DObject() then
			slot1(slot6 - 1)

			slot2 = true
		elseif slot2 then
			slot1(slot6 - 1)

			slot2 = false
		elseif #slot0.sortDataList == 0 then
			slot1(slot6 - 1)
		end
	end
end

pg.BackYardSortMgr.ClearFurModel = function (slot0, slot1)
	if slot1.furnitureVO:is3DObject() then
		slot0:ChangeOrder(0, slot1._tf)
	end
end

pg.BackYardSortMgr.GetSortGroupCon = function (slot0, slot1)
	slot2 = slot1
	slot3 = 0
	slot4 = slot0.layerNum + #slot0.sortDataList * 2

	for slot8, slot9 in ipairs(slot0.sortDataList) do
		if slot9.startIndex <= slot1 and slot1 <= slot9.endIndex then
			slot3 = slot8
			slot2 = slot1 - slot9.startIndex
			slot4 = slot9.order
		end
	end

	SetActive(slot5, true)

	return slot0.sortGroupList[slot3], slot2, slot4
end

pg.BackYardSortMgr.ChangeOrder = function (slot0, slot1, slot2)
	if not IsNil(GetComponent(slot2, typeof(Renderer))) then
		slot3.sortingOrder = slot1
	end

	for slot7 = 0, slot2.childCount - 1, 1 do
		slot0:ChangeOrder(slot1, slot2:GetChild(slot7))
	end
end

pg.BackYardSortMgr.Dispose = function (slot0)
	slot0:ResetSortGroup()

	slot0.sortGroup = nil
	slot0.floorContain = nil
	slot0.sortDataList = nil
	slot0.sortDataPool = nil
	slot0.sortGroupList = {}
end

return

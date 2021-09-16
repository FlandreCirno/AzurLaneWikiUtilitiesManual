slot0 = class("BackYardShopFilterPanel", import("...Decoration.panles.BackYardDecorationFilterPanel"))

slot0.SortForDecorate = function (slot0, slot1, slot2)
	slot3 = slot2[1]
	slot4 = slot2[2]
	slot5 = slot2[3]

	function slot6(slot0)
		if slot0:canPurchaseByGem() and not slot0:canPurchaseByDormMoeny() then
			return 1
		elseif slot0:canPurchaseByGem() and slot0:canPurchaseByDormMoeny() then
			return 3
		elseif slot0:canPurchaseByDormMoeny() then
			return 4
		else
			return 5
		end
	end

	slot0.SortByDefault1 = function (slot0, slot1)
		slot4 = slot0:getConfig("new")
		slot5 = slot1:getConfig("new")

		if slot0(slot0) == slot0(slot1) then
			if slot4 == slot5 then
				return slot0.id < slot1.id
			else
				return slot4 < slot5
			end
		else
			return slot2 < slot3
		end
	end

	slot0.SortByDefault2 = function (slot0, slot1)
		slot4 = slot0:getConfig("new")
		slot5 = slot1:getConfig("new")

		if slot0(slot0) == slot0(slot1) then
			if slot4 == slot5 then
				return slot1.id < slot0.id
			else
				return slot5 < slot4
			end
		else
			return slot2 < slot3
		end
	end

	slot7 = (slot0.canPurchase(slot0) and 1) or 0

	if slot7 == ((slot1:canPurchase() and 1) or 0) then
		if slot3 == slot0.SORT_MODE.BY_DEFAULT then
			return slot0["SortByDefault" .. slot5](slot0, slot1)
		elseif slot3 == slot0.SORT_MODE.BY_FUNC then
			return slot0:SORT_BY_FUNC(slot1, slot4, slot5, function ()
				return slot0["SortByDefault" .. ]("SortByDefault", slot3)
			end)
		elseif slot3 == slot0.SORT_MODE.BY_CONFIG then
			return slot0.SORT_BY_CONFIG(slot0, slot1, slot4, slot5, function ()
				return slot0["SortByDefault" .. ]("SortByDefault", slot3)
			end)
		end
	else
		return slot8 < slot7
	end
end

slot0.sort = function (slot0, slot1)
	table.sort(slot1, function (slot0, slot1)
		return slot0:SortForDecorate(slot1, {
			slot1.sortData[1],
			slot1.sortData[2],
			slot1.orderMode
		})
	end)

	slot0.furnitures = slot1
end

return slot0

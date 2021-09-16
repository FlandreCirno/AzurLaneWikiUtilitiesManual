slot0 = class("BackYardShopBasePage", import("....base.BaseSubView"))

slot0.PlayerUpdated = function (slot0, slot1)
	slot0.player = slot1

	slot0:OnPlayerUpdated()
end

slot0.DormUpdated = function (slot0, slot1)
	slot0.dorm = slot1

	slot0:OnDormUpdated()
end

slot0.FurnituresUpdated = function (slot0, slot1)
	slot2 = slot0.dorm:GetAllFurniture()

	for slot6, slot7 in ipairs(slot1) do
		slot0:OnDisplayUpdated(slot8)
		slot0:OnCardUpdated(slot2[slot7])
	end
end

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	slot0:Show()

	slot0.pageType = slot1
	slot0.dorm = slot2
	slot0.player = slot3

	slot0:OnSetUp()
end

slot0.ShowFurnitureMsgBox = function (slot0, slot1)
	slot0.contextData.furnitureMsgBox:ExecuteAction("SetUp", slot1, slot0.dorm, slot0.player)
end

slot0.ShowThemeVOMsgBox = function (slot0, slot1)
	slot0.contextData.themeMsgBox:ExecuteAction("SetUp", slot1, slot0.dorm, slot0.player)
end

slot0.OnSetUp = function (slot0)
	return
end

slot0.OnPlayerUpdated = function (slot0)
	return
end

slot0.OnDisplayUpdated = function (slot0)
	return
end

slot0.OnCardUpdated = function (slot0)
	return
end

slot0.OnDormUpdated = function (slot0)
	return
end

return slot0

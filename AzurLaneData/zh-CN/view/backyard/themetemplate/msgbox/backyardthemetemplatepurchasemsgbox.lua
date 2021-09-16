slot0 = class("BackYardThemeTemplatePurchaseMsgbox", import("...Shop.msgbox.BackYardThemeMsgBoxPage"))

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	slot0.dorm = slot2
	slot0.template = slot1
	slot0.player = slot3
	slot0.count = 1
	slot0.maxCount = 1

	slot0:UpdateMainInfo()
	slot0:UpdateRes()
	slot0:UpdateBtns()
	slot0:UpdatePrice()
	slot0:Show()
end

slot0.UpdateMainInfo = function (slot0)
	slot0.nameTxt.text = slot0.template:GetName()
	slot0.descTxt.text = slot0.template:GetDesc()

	setActive(slot0.icon.gameObject, false)
	setActive(slot0.rawIcon.gameObject, false)
	BackYardThemeTempalteUtil.GetTexture(slot0.template:GetTextureIconName(), slot0.template:GetIconMd5(), function (slot0)
		if not IsNil(slot0.rawIcon) and slot0 then
			setActive(slot0.rawIcon.gameObject, true)

			slot0.rawIcon.texture = slot0
		end
	end)
end

slot0.GetAddList = function (slot0)
	slot1 = {}
	slot3 = slot0.dorm:GetAllFurniture()

	for slot7, slot8 in pairs(slot2) do
		if pg.furniture_data_template[slot7] then
			slot10 = 0

			if not slot3[slot7] then
				slot9 = Furniture.New({
					id = slot7
				})
			else
				slot10 = slot9.count
			end

			if slot9:canPurchase() and slot9:inTime() and slot9:canPurchaseByDormMoeny() then
				for slot14 = 1, slot8 - slot10, 1 do
					table.insert(slot1, slot9)
				end
			end
		end
	end

	return slot1
end

return slot0

slot0 = class("BackYardThemeTemplateInfoPage", import("...Shop.pages.BackYardThemeInfoPage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)
	onButton(slot0, slot0.purchaseBtn, function ()
		slot0.contextData.themeMsgBox:ExecuteAction("SetUp", slot0.template, slot0.dorm, slot0.player)
	end, SFX_PANEL)
	setActive(slot0.icon, false)

	slot0.iconRaw = slot0.findTF(slot0, "icon/Image_raw"):GetComponent(typeof(RawImage))

	setActive(slot0:findTF("number"), false)
	setActive(slot0.leftArrBtn, false)
	setActive(slot0.rightArrBtn, false)
end

slot0.OnInitCard = function (slot0, slot1)
	onButton(slot0, BackYardThemTemplateFurnitureCard.New(slot1)._go, function ()
		if slot0.furniture:canPurchase() and slot0.furniture:inTime() and (slot0.furniture:canPurchaseByGem() or slot0.furniture:canPurchaseByDormMoeny()) then
			slot1.contextData.furnitureMsgBox:ExecuteAction("SetUp", slot0.furniture, slot1.dorm, slot1.target)
		end
	end, SFX_PANEL)

	slot0.cards[slot1] = BackYardThemTemplateFurnitureCard.New(slot1)
end

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	slot0.template = slot1
	slot0.dorm = slot2
	slot0.target = slot3
	slot0.player = getProxy(PlayerProxy):getData()

	slot0:InitFurnitureList()
	slot0:UpdateThemeInfo()
	slot0:UpdateRes()
	slot0:Show()
end

slot0.InitFurnitureList = function (slot0)
	slot0.displays = {}
	slot2 = slot0.dorm:GetAllFurniture()

	for slot6, slot7 in pairs(slot1) do
		if pg.furniture_data_template[slot6] then
			table.insert(slot0.displays, slot2[slot6] or Furniture.New({
				id = slot6
			}))
		end
	end

	function slot3(slot0)
		if slot0:inTime() then
			if slot0:canPurchaseByGem() and not slot0:canPurchaseByDormMoeny() then
				return 1
			elseif slot0:canPurchaseByGem() and slot0:canPurchaseByDormMoeny() then
				return 2
			else
				return 3
			end
		else
			return 4
		end
	end

	table.sort(slot0.displays, function (slot0, slot1)
		if ((slot0:canPurchase() and 1) or 0) == ((slot1:canPurchase() and 1) or 0) then
			return slot0(slot0) < slot0(slot1)
		else
			return slot3 < slot2
		end
	end)
	slot0.scrollRect.SetTotalCount(slot4, #slot0.displays)
end

slot0.UpdateThemeInfo = function (slot0)
	slot0.nameTxt.text = slot0.template.GetName(slot1)
	slot0.enNameTxt.text = "FURNITURE"

	setActive(slot0.iconRaw.gameObject, false)
	BackYardThemeTempalteUtil.GetTexture(slot0.template.GetTextureName(slot1), slot2, function (slot0)
		if not IsNil(slot0.iconRaw) and slot0 then
			slot0.iconRaw.texture = slot0

			setActive(slot0.iconRaw.gameObject, true)
		end
	end)

	slot0.desc.text = slot0.template.GetDesc(slot1)

	slot0:UpdatePurchaseBtn()
end

slot0.UpdatePurchaseBtn = function (slot0)
	slot3 = _.any(_.keys(slot2), function (slot0)
		return Furniture.New({
			id = slot0
		}):inTime() and slot1:canPurchaseByDormMoeny()
	end)

	setActive(slot0.purchaseBtn, not slot0.dorm:OwnThemeTemplateFurniture(slot0.template) and slot3)
end

return slot0

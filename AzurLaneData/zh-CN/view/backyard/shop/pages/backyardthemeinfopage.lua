slot0 = class("BackYardThemeInfoPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "BackYardThemeInfoPage"
end

slot0.OnLoaded = function (slot0)
	slot0.scrollRect = slot0:findTF("list"):GetComponent("LScrollRect")
	slot0.nameTxt = slot0:findTF("name"):GetComponent(typeof(Text))
	slot0.enNameTxt = slot0:findTF("en_name"):GetComponent(typeof(Text))
	slot0.numberTxt = slot0:findTF("number/Text"):GetComponent(typeof(Text))
	slot0.icon = slot0:findTF("icon/Image"):GetComponent(typeof(Image))
	slot0.desc = slot0:findTF("desc"):GetComponent(typeof(Text))
	slot0.backBtn = slot0:findTF("back")
	slot0.leftArrBtn = slot0:findTF("arr_left")
	slot0.rightArrBtn = slot0:findTF("arr_right")
	slot0.gemTxt = slot0:findTF("res_gem/Text"):GetComponent(typeof(Text))
	slot0.goldTxt = slot0:findTF("res_gold/Text"):GetComponent(typeof(Text))
	slot0.gemAddBtn = slot0:findTF("res_gem/jiahao")
	slot0.goldAddBtn = slot0:findTF("res_gold/jiahao")
	slot0.purchaseBtn = slot0:findTF("purchase_btn")
end

slot0.OnInit = function (slot0)
	slot0.cards = {}

	slot0.scrollRect.onInitItem = function (slot0)
		slot0:OnInitCard(slot0)
	end

	slot0.scrollRect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateCard(slot0, slot1)
	end

	onButton(slot0, slot0.backBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.purchaseBtn, function ()
		slot0.contextData.themeMsgBox:ExecuteAction("SetUp", slot0.themeVO, slot0.dorm, slot0.player)
	end, SFX_PANEL)
	onButton(slot0, slot0.leftArrBtn, function ()
		if slot0.OnPrevTheme then
			slot0.OnPrevTheme()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.rightArrBtn, function ()
		if slot0.OnNextTheme then
			slot0.OnNextTheme()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.goldAddBtn, function ()
		slot0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(slot0, slot0.gemAddBtn, function ()
		slot0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
end

slot0.OnPlayerUpdated = function (slot0, slot1)
	slot0.player = slot1

	slot0:UpdateRes()
end

slot0.DormUpdated = function (slot0, slot1)
	slot0.dorm = slot1
end

slot0.FurnituresUpdated = function (slot0, slot1)
	slot2 = slot0.dorm:GetAllFurniture()

	for slot6, slot7 in ipairs(slot1) do
		slot0:OnDisplayUpdated(slot8)
		slot0:OnCardUpdated(slot2[slot7])
	end

	slot0:UpdatePurchaseBtn()
end

slot0.OnDisplayUpdated = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.displays) do
		if slot6.id == slot1.id then
			slot0.displays[slot5] = slot1
		end
	end
end

slot0.OnCardUpdated = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.cards) do
		if slot6.furniture.id == slot1.id then
			slot6:Update(slot1)
		end
	end
end

slot0.SetUp = function (slot0, slot1, slot2, slot3, slot4)
	slot0:Show()

	slot0.index = slot1
	slot0.dorm = slot3
	slot0.themeVO = slot2
	slot0.player = slot4

	slot0:InitFurnitureList()
	slot0:UpdateThemeInfo()
	slot0:UpdateRes()
end

slot0.UpdateRes = function (slot0)
	slot0.gemTxt.text = slot0.player:getTotalGem()
	slot0.goldTxt.text = slot0.player:getResource(PlayerConst.ResDormMoney)
end

slot0.InitFurnitureList = function (slot0)
	slot2 = slot0.dorm:GetAllFurniture()
	slot0.displays = {}

	for slot6, slot7 in ipairs(slot1) do
		table.insert(slot0.displays, slot2[slot7] or Furniture.New({
			id = slot7
		}))
	end

	table.sort(slot0.displays, function (slot0, slot1)
		return ((slot0:canPurchase() and 1) or 0) > ((slot1:canPurchase() and 1) or 0)
	end)
	slot0.scrollRect.SetTotalCount(slot3, #slot0.displays)
end

slot0.OnInitCard = function (slot0, slot1)
	onButton(slot0, BackYardFurnitureCard.New(slot1)._go, function ()
		if slot0.furniture:canPurchase() then
			slot1.contextData.furnitureMsgBox:ExecuteAction("SetUp", slot0.furniture, slot1.dorm, slot1.player)
		end
	end, SFX_PANEL)

	slot0.cards[slot1] = BackYardFurnitureCard.New(slot1)
end

slot0.OnUpdateCard = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitCard(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:Update(slot0.displays[slot1 + 1])
end

slot0.UpdateThemeInfo = function (slot0)
	slot0.nameTxt.text = slot0.themeVO:getConfig("name")
	slot0.enNameTxt.text = "FURNITURE"
	slot0.numberTxt.text = (slot0.index < 10 and "0" .. slot0.index) or slot0.index

	GetSpriteFromAtlasAsync("BackYardTheme/theme_" .. slot1.id, "", function (slot0)
		if IsNil(slot0.icon) then
			return
		end

		slot0.icon.sprite = slot0
	end)
	slot0.icon.SetNativeSize(slot3)

	slot0.desc.text = slot1:getConfig("desc")

	slot0:UpdatePurchaseBtn()
end

slot0.UpdatePurchaseBtn = function (slot0)
	slot2 = slot0.dorm:GetAllFurniture()
	slot3 = _.any(slot1, function (slot0)
		return not slot0[slot0]
	end)

	setActive(slot0.purchaseBtn, slot3)
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)

	if slot0.OnEnter then
		slot0.OnEnter()
	end
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)

	if slot0.OnExit then
		slot0.OnExit()
	end
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()

	for slot4, slot5 in pairs(slot0.cards) do
		slot5:Clear()
	end
end

return slot0

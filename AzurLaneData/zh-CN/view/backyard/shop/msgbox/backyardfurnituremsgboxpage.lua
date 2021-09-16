slot0 = class("BackYardFurnitureMsgBoxPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "FurnitureMsgboxPage"
end

slot0.OnLoaded = function (slot0)
	slot0.nameTxt = slot0:findTF("frame/name/Text"):GetComponent(typeof(Text))
	slot0.descTxt = slot0:findTF("frame/desc"):GetComponent(typeof(Text))
	slot0.icon = slot0:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	slot0.rawIcon = slot0:findTF("frame/icon/rawImage"):GetComponent(typeof(RawImage))
	slot0.leftArr = slot0:findTF("frame/count/left_arr")
	slot0.rightArr = slot0:findTF("frame/count/right_arr")
	slot0.countTxt = slot0:findTF("frame/count/Text"):GetComponent(typeof(Text))
	slot0.gemIcon = slot0:findTF("frame/count/price/gem")
	slot0.gemCount = slot0:findTF("frame/count/price/gem_text"):GetComponent(typeof(Text))
	slot0.goldIcon = slot0:findTF("frame/count/price/gold")
	slot0.goldCount = slot0:findTF("frame/count/price/gold_text"):GetComponent(typeof(Text))
	slot0.line = slot0:findTF("frame/count/price/line")
	slot0.energyYellow = slot0:findTF("frame/energy/yellow")
	slot0.energyGreen = slot0:findTF("frame/energy/green")
	slot0.energyTxt = slot0:findTF("frame/energy/Text"):GetComponent(typeof(Text))
	slot0.closeBtn = slot0:findTF("frame/close_btn")
	slot0.goldPurchaseBtn = slot0:findTF("frame/btns/gold_purchase_btn")

	setText(slot0.goldPurchaseBtn:Find("Text"), i18n("word_buy"))

	slot0.gemPurchaseBtn = slot0:findTF("frame/btns/gem_purchase_btn")

	setText(slot0.gemPurchaseBtn:Find("Text"), i18n("word_buy"))

	slot0.gemTxt = slot0:findTF("res_gem/Text"):GetComponent(typeof(Text))
	slot0.goldTxt = slot0:findTF("res_gold/Text"):GetComponent(typeof(Text))
	slot0.gemAddBtn = slot0:findTF("res_gem/jiahao")
	slot0.goldAddBtn = slot0:findTF("res_gold/jiahao")
	slot0.maxCnt = slot0:findTF("frame/max_cnt"):GetComponent(typeof(Text))
	slot0.maxBtn = slot0:findTF("frame/count/max")
	slot0.maxBtnTxt = slot0.maxBtn:Find("Text"):GetComponent(typeof(Text))

	setText(slot0:findTF("frame/count/price/label"), i18n("backyard_theme_total_print"))
	setActive(slot0.rawIcon, false)
end

slot0.OnInit = function (slot0)
	function slot1()
		for slot4 = 1, slot0.count, 1 do
			table.insert(slot0, slot0.furniture.id)
		end

		return slot0
	end

	onButton(slot0, slot0.goldPurchaseBtn, function ()
		slot1:emit(NewBackYardShopMediator.ON_SHOPPING, slot0(), PlayerConst.ResDormMoney)
		slot1.emit:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.gemPurchaseBtn, function ()
		slot1:emit(NewBackYardShopMediator.ON_SHOPPING, slot0(), PlayerConst.ResDiamond)
		slot1.emit:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.leftArr, function ()
		if slot0.count <= 1 then
			return
		end

		slot0.count = slot0.count - 1

		slot0:UpdatePrice()
	end, SFX_PANEL)
	onButton(slot0, slot0.rightArr, function ()
		if slot0.count == slot0.maxCount then
			return
		end

		slot0.count = slot0.count + 1

		slot0:UpdatePrice()
	end, SFX_PANEL)
	onButton(slot0, slot0.maxBtn, function ()
		slot0.count = slot0.maxCount

		slot0:UpdatePrice()
	end, SFX_PANEL)
	onButton(slot0, slot0.goldAddBtn, function ()
		slot0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(slot0, slot0.gemAddBtn, function ()
		slot0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
end

slot0.PlayerUpdated = function (slot0, slot1)
	slot0.player = slot1

	slot0:UpdateRes()
end

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	slot0.dorm = slot2
	slot0.furniture = slot1
	slot0.count = 1
	slot0.player = slot3
	slot0.maxCount = slot1:getConfig("count") - slot1.count
	slot0.maxBtnTxt.text = "+" .. slot0.maxCount

	slot0:UpdateMainInfo()
	slot0:UpdateRes()
	slot0:Show()
end

slot0.UpdateRes = function (slot0)
	slot0.gemTxt.text = slot0.player:getTotalGem()
	slot0.goldTxt.text = slot0.player:getResource(PlayerConst.ResDormMoney)
end

slot0.UpdateMainInfo = function (slot0)
	slot0.nameTxt.text = slot0.furniture.getConfig(slot1, "name")
	slot0.descTxt.text = slot0.furniture.getConfig(slot1, "describe")
	slot0.icon.sprite = GetSpriteFromAtlas("furnitureicon/" .. slot0.furniture.getConfig(slot1, "icon"), "")

	slot0.icon:SetNativeSize()
	slot0:UpdatePrice()

	slot2 = slot0.furniture.canPurchaseByDormMoeny(slot1)
	slot3 = slot0.furniture.canPurchaseByGem(slot1)

	setActive(slot0.goldPurchaseBtn, slot2)
	setActive(slot0.gemPurchaseBtn, slot3)
	setActive(slot0.gemIcon, slot3)
	setActive(slot0.gemCount, slot3)
	setActive(slot0.goldIcon, slot2)
	setActive(slot0.goldCount, slot2)
	setActive(slot0.line, slot2 and slot3)

	slot0.maxCnt.text = ""

	if slot1:getConfig("count") > 1 then
		slot0.maxCnt.text = slot1.count .. "/" .. slot1:getConfig("count")
	end
end

slot0.UpdateEnergy = function (slot0, slot1)
	setActive(slot0.energyYellow, slot0.dorm:getComfortable(slot1) - slot0.dorm:getComfortable() <= 0)
	setActive(slot0.energyGreen, slot4 > 0)

	slot0.energyTxt.text = " +" .. slot4
end

slot0.UpdatePrice = function (slot0)
	slot0.gemCount.text = slot0.furniture.getPrice(slot1, PlayerConst.ResDiamond) * slot0.count
	slot0.goldCount.text = slot0.furniture.getPrice(slot1, PlayerConst.ResDormMoney) * slot0.count
	slot0.countTxt.text = slot0.count
	slot4 = {}

	for slot8 = 1, slot0.count, 1 do
		table.insert(slot4, Furniture.New({
			id = slot0.furniture.id
		}))
	end

	slot0:UpdateEnergy(slot4)
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	SetParent(slot0._tf, pg.UIMgr.GetInstance().OverlayMain)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	SetParent(slot0._tf, slot0._parentTf)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

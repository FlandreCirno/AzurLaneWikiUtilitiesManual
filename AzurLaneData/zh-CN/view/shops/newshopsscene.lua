slot0 = class("NewShopsScene", import("..base.BaseUI"))
slot0.TYPE_ACTIVITY = 1
slot0.TYPE_SHOP_STREET = 2
slot0.TYPE_MILITARY_SHOP = 3
slot0.TYPE_SHAM_SHOP = 4
slot0.TYPE_FRAGMENT = 5
slot0.TYPE_GUILD = 6

slot0.getUIName = function (slot0)
	return "NewShopsUI"
end

slot0.preload = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		pg.m02:sendNotification(GAME.GET_OPEN_SHOPS, {
			callback = function (slot0)
				slot0:SetShops(slot0)
				slot0.SetShops()
			end
		})
	end)
	parallelAsync(slot2, slot1)
end

slot0.init = function (slot0)
	slot0.backBtn = slot0:findTF("blur_panel/adapt/top/back_button")
	slot0.frame = slot0:findTF("frame")
	slot0.toggleTpl = slot0:getTpl("frame/bottom/scrollrect/tpl")
	slot0.scrollrect = slot0:findTF("frame/bottom/scrollrect")
	slot0.toggleContainer = slot0:findTF("frame/bottom/scrollrect/toggle_list")
	slot0.pageContainer = slot0:findTF("frame/viewContainer")
	slot0.stamp = slot0:findTF("stamp")
	slot0.switchBtn = slot0:findTF("frame/switch_btn")
	slot0.skinBtn = slot0:findTF("frame/skin_btn")
	slot0.rightArr = slot0:findTF("frame/bottom/right_arr")
	slot0.leftArr = slot0:findTF("frame/bottom/left_arr")
	slot0.pages = {
		[slot0.TYPE_ACTIVITY] = ActivityShopPage.New(slot0.pageContainer, slot0.event, slot0.contextData),
		[slot0.TYPE_SHOP_STREET] = StreetShopPage.New(slot0.pageContainer, slot0.event, slot0.contextData),
		[slot0.TYPE_MILITARY_SHOP] = MilitaryShopPage.New(slot0.pageContainer, slot0.event, slot0.contextData),
		[slot0.TYPE_GUILD] = GuildShopPage.New(slot0.pageContainer, slot0.event, slot0.contextData),
		[slot0.TYPE_SHAM_SHOP] = ShamShopPage.New(slot0.pageContainer, slot0.event, slot0.contextData),
		[slot0.TYPE_FRAGMENT] = FragmentShopPage.New(slot0.pageContainer, slot0.event, slot0.contextData)
	}
	slot0.contextData.singleWindow = ShopSingleWindow.New(slot0._tf, slot0.event)
	slot0.contextData.multiWindow = ShopMultiWindow.New(slot0._tf, slot0.event)
	slot0.contextData.paintingView = ShopPaintingView.New(slot0:findTF("paint"))
	slot0.contextData.bgView = ShopBgView.New(slot0:findTF("bg"))
	slot0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(slot0, 60038, slot0.pageContainer)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	setActive(slot0.stamp, getProxy(TaskProxy).mingshiTouchFlagEnabled(slot3))

	if LOCK_CLICK_MINGSHI then
		setActive(slot0.stamp, false)
	end

	onButton(slot0, slot0.stamp, function ()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	onButton(slot0, slot0.switchBtn, function ()
		if slot0.contextData ~= nil and slot0.contextData.chargePage ~= nil then
			slot0 = slot0.contextData.chargePage
		end

		slot0:emit(NewShopsMediator.GO_MALL, slot0)
	end, SFX_CANCEL)
	onButton(slot0, slot0.skinBtn, function ()
		slot0:emit(NewShopsMediator.ON_SKIN_SHOP)
	end, SFX_PANEL)
	slot0.InitEntrances(slot0)
	slot0:BlurView()
end

slot0.UpdateItems = function (slot0, slot1)
	slot0.items = slot1

	if slot0.page then
		slot0.page:SetItems(slot1)
	end
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.player = slot1

	if slot0.page then
		slot0.page:SetPlayer(slot1)
	end
end

slot0.SetShops = function (slot0, slot1)
	slot0.shops = slot1
end

slot0.SetShop = function (slot0, slot1, slot2)
	if not slot0.shops then
		return
	end

	if slot0.shops[slot1] then
		for slot7, slot8 in ipairs(slot3) do
			if slot8:IsSameKind(slot2) then
				slot0.shops[slot1][slot7] = slot2

				break
			end
		end
	end
end

slot0.UpdateShop = function (slot0, slot1, slot2)
	slot0:SetShop(slot1, slot2)

	if slot0.page == slot0.pages[slot1] then
		slot0.page:ExecuteAction("UpdateShop", slot2)
	end
end

slot0.UpdateCommodity = function (slot0, slot1, slot2, slot3)
	slot0:SetShop(slot1, slot2)

	if slot0.page == slot0.pages[slot1] then
		slot0.page:ExecuteAction("UpdateCommodity", slot2, slot3)
	end
end

slot0.InitEntrances = function (slot0)
	slot1 = 0
	slot0.shopBtns = {}

	for slot5, slot6 in pairs(slot0.shops) do
		for slot10, slot11 in ipairs(slot6) do
			slot1 = slot1 + 1

			slot0:UpdateEntrance(slot5, slot10)
		end
	end

	slot0:ActiveDefaultShop()
	slot0:AddScrollrect(slot1)
end

slot0.ActiveDefaultShop = function (slot0)
	slot1 = {
		"activity",
		"shopstreet",
		"supplies",
		"sham",
		"fragment",
		"guild"
	}
	slot2 = slot0.contextData.warp or slot0.contextData.activeShop or slot0.TYPE_ACTIVITY

	if type(slot2) == "string" then
		slot2 = defaultValue(table.indexof(slot1, slot2), slot0.TYPE_ACTIVITY)
	end

	slot3 = slot0.contextData.index or 1

	if slot2 == slot0.TYPE_ACTIVITY and slot0.contextData.actId then
		slot4 = ipairs
		slot5 = slot0.shops[slot2] or {}

		for slot7, slot8 in slot4(slot5) do
			if slot8.activityId == slot0.contextData.actId then
				slot3 = slot7

				break
			end
		end
	end

	slot4 = nil

	if slot0.shops[slot2] then
		slot5, slot6 = slot0.pages[slot2]:CanOpen(nil, slot0.player)

		if slot5 then
			slot4 = slot0.toggleContainer:Find(slot2 .. "-" .. slot3)
		else
			pg.TipsMgr.GetInstance():ShowTips(slot6)
		end
	end

	if slot4 then
		triggerButton(slot4)
	else
		triggerButton(slot0.toggleContainer:Find(slot0.TYPE_SHOP_STREET .. "-1"))
	end
end

slot1 = 5

slot0.AddScrollrect = function (slot0, slot1)
	function slot2(slot0, slot1)
		return getBounds(slot0):Intersects(getBounds(slot1))
	end

	slot3 = slot0 < slot1
	slot4 = slot0.toggleContainer.GetChild(slot4, 0):Find("unsel")
	slot5 = slot0.toggleContainer:GetChild(slot0.toggleContainer.childCount - 1):Find("unsel")

	if slot3 then
		slot0.prevPos = -1

		onScroll(slot0, slot0.scrollrect, function (slot0)
			if math.abs(slot0.prevPos - slot0.x) > 0.1 then
				slot0.prevPos = slot0.x

				setActive(slot0.rightArr, not slot1(slot0.scrollrect, slot0.rightArr))
				setActive(slot0.leftArr, not slot1(slot0.scrollrect, slot1))
			end
		end)
		scrollTo(slot0.scrollrect, 1, 0)
		onNextTick(function ()
			if slot0.prevBtn and not slot1(slot0.scrollrect, slot0.prevBtn) then
				slot0 = slot0.toggleContainer:GetChild(slot0.toggleContainer.childCount - )
				slot0.toggleContainer.localPosition = Vector3(slot0.toggleContainer.localPosition.x + slot0.localPosition.x - slot0.prevBtn.localPosition.x, slot0.toggleContainer.localPosition.y, slot0.toggleContainer.localPosition.z)
			end
		end)
	end

	slot0.scrollrect.GetComponent(slot6, typeof(ScrollRect)).enabled = slot3

	setActive(slot0.scrollrect, false)
	setActive(slot0.scrollrect, true)
end

slot0.UpdateEntrance = function (slot0, slot1, slot2)
	slot3 = cloneTplTo(slot0.toggleTpl, slot0.toggleContainer, slot1 .. "-" .. slot2)

	slot0:OnSwitch(slot3, function ()
		slot2, slot3 = slot0.pages[].CanOpen(slot1, slot0.shops[slot1][slot2], slot0.player)

		if slot2 then
			if slot0.page and not slot0.page:GetLoaded() then
				return
			end

			if slot0.page then
				slot0.page:Hide()
			end

			slot0.contextData.bgView:Init(slot1:GetBg(slot0))
			slot1:ExecuteAction("SetUp", slot0, slot0.player, slot0.items)

			slot0.page = slot1
			slot0.contextData.activeShop = slot1

			return true
		else
			pg.TipsMgr.GetInstance():ShowTips(slot3)
		end

		return false
	end)
	slot3.SetAsFirstSibling(slot3)
	setImageSprite(slot3:Find("unsel"), GetSpriteFromAtlas("ui/ShopsUI_atlas", slot1 .. "_unsel"), true)
	setImageSprite(slot3:Find("sel"), GetSpriteFromAtlas("ui/ShopsUI_atlas", slot1), true)
end

slot0.OnSwitch = function (slot0, slot1, slot2)
	onButton(slot0, slot1, function ()
		if slot0.prevBtn == slot1 then
			return
		end

		if slot2() then
			if slot0.prevBtn then
				setActive(slot0.prevBtn:Find("unsel"), true)
				setActive(slot0.prevBtn:Find("sel"), false)
			end

			setActive(slot1:Find("unsel"), false)
			setActive(slot1:Find("sel"), true)

			slot0.prevBtn = slot0
		end
	end, SFX_PANEL)
end

slot0.onBackPressed = function (slot0)
	if slot0.contextData.singleWindow:GetLoaded() and slot0.contextData.singleWindow:isShowing() then
		slot0.contextData.singleWindow:Close()

		return
	end

	if slot0.contextData.multiWindow:GetLoaded() and slot0.contextData.multiWindow:isShowing() then
		slot0.contextData.multiWindow:Close()

		return
	end

	triggerButton(slot0.backBtn)
end

slot0.BlurView = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanelPB(slot0.pageContainer, {
		pbList = {
			slot0:findTF("blurBg", slot0.pageContainer)
		}
	})
end

slot0.UnBlurView = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.pageContainer, slot0.frame)
end

slot0.willExit = function (slot0)
	if slot0.bulinTip then
		slot0.bulinTip:Destroy()
	end

	for slot4, slot5 in pairs(slot0.pages) do
		slot5:Destroy()
	end

	slot0:UnBlurView()
	slot0.contextData.singleWindow:Destroy()
	slot0.contextData.multiWindow:Destroy()
	slot0.contextData.paintingView:Dispose()
	slot0.contextData.bgView:Dispose()

	slot0.contextData.singleWindow = nil
	slot0.contextData.multiWindow = nil
	slot0.contextData.paintingView = nil
	slot0.contextData.bgView = nil
	slot0.pages = nil
	slot0.bulinTip = nil
	slot0.shopBtns = nil
end

return slot0

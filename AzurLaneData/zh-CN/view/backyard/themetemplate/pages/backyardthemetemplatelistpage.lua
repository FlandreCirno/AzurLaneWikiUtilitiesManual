slot0 = class("BackYardThemeTemplateListPage", import("...Shop.pages.BackYardThemePage"))
slot0.nextClickRefreshTime = 0

slot0.LoadDetail = function (slot0)
	setActive(slot0:findTF("adpter/descript"), false)
end

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.tipBg = slot0:findTF("tip")
	slot0.tips = {
		slot0:findTF("tip1"),
		slot0:findTF("tip2"),
		slot0:findTF("tip3")
	}
	slot0.goBtn = slot0:findTF("go_btn")
	slot0.rawImage = slot0:findTF("preview_raw"):GetComponent(typeof(RawImage))
	slot0.listRect = slot0:findTF("adpter/list")
	slot0.sortBg = slot0:findTF("sort_bg")

	setActive(slot0.sortBg, false)

	slot0.refreshBtns = slot0:findTF("refresh_btns")

	setActive(slot0.refreshBtns, true)
	setText(slot0.refreshBtns:Find("random/Text"), i18n("word_random"))
	setText(slot0.refreshBtns:Find("hot/Text"), i18n("word_hot"))
	setText(slot0.refreshBtns:Find("new/Text"), i18n("word_new"))

	slot0.btns = {
		[5] = slot0.refreshBtns:Find("random"),
		[3] = slot0.refreshBtns:Find("hot"),
		[2] = slot0.refreshBtns:Find("new")
	}
	slot2 = slot0:findTF("search/Placeholder"):GetComponent(typeof(Image))
	slot2.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", "search_theme")

	slot2:SetNativeSize()

	for slot6, slot7 in pairs(slot0.btns) do
		onButton(slot0, slot7, function ()
			if slot0:CanClickRefBtn(slot0) then
				if slot0.selectedRefBtn then
					setActive(slot0.selectedRefBtn:Find("sel"), false)
				end

				setActive(slot2:Find("sel"), true)
				setActive:SwitchPage(setActive, 1)

				setActive.SwitchPage.selectedRefBtn = setActive
			end
		end, SFX_PANEL)
	end

	setActive(slot0.helpBtn, true)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.backyard_theme_template_shop_tip.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.goBtn, function ()
		slot0:emit(NewBackYardThemeTemplateMediator.GO_DECORATION)
	end, SFX_PANEL)
	slot0.scrollRect.onValueChanged.RemoveAllListeners(slot3)

	slot0.arrLeftBtnShop = slot0:findTF("adpter/list/zuobian_shop")
	slot0.arrRightBtnShop = slot0:findTF("adpter/list/youbian_shop")

	onButton(slot0, slot0.arrLeftBtnShop, function ()
		if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			slot1 = getProxy(DormProxy).TYPE

			if getProxy(DormProxy).PAGE > 1 then
				slot0:SwitchPage(slot1, slot0 - 1, true)
			end
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.arrRightBtnShop, function ()
		if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			getProxy(DormProxy).ClickPage = true

			slot0:SwitchPage(getProxy(DormProxy).TYPE, getProxy(DormProxy).PAGE + 1, true)
		end
	end, SFX_PANEL)

	function slot3()
		if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
			slot0:emit(NewBackYardThemeTemplateMediator.ON_GET_SPCAIL_TYPE_TEMPLATE, BackYardConst.ThemeSortIndex2ServerIndex(slot0.sortIndex, slot0.asc))
		else
			slot0:SetTotalCount()
		end
	end

	slot0.descPages = BackYardThemeTemplateDescPage.New(slot0._tf, slot0._event, slot0.contextData)

	slot0.descPages.OnSortChange = function (slot0)
		slot0.asc = slot0

		slot0()
	end

	slot0.contextData.sortPage = BackYardThemeTemplateSortPanel.New(slot0._parentTf, slot0._event, slot0.contextData)

	slot0.contextData.sortPage.OnConfirm = function ()
		slot0.sortIndex = slot0.contextData.sortPage.index

		slot0.contextData.sortPage.index()
	end

	slot0.contextData.infoPage = BackYardThemeTemplateInfoPage.New(slot0._parentTf, slot0.event, slot0.contextData)
	slot0.contextData.furnitureMsgBox = BackYardFurnitureMsgBoxPage.New(slot0._parentTf, slot0.event, slot0.contextData)
	slot0.contextData.themeMsgBox = BackYardThemeTemplatePurchaseMsgbox.New(slot0._parentTf, slot0.event, slot0.contextData)
end

slot0.UpdateArr = function (slot0)
	if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		setActive(slot0.arrLeftBtnShop, getProxy(DormProxy).PAGE > 1)
		setActive(slot0.arrRightBtnShop, slot1 < getProxy(DormProxy).lastPages[getProxy(DormProxy).TYPE] or not getProxy(DormProxy).ClickPage)
		setActive(slot0.arrLeftBtn, false)
		setActive(slot0.arrRightBtn, false)
	elseif slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		setActive(slot0.arrLeftBtn, false)
		setActive(slot0.arrRightBtn, false)
		setActive(slot0.arrLeftBtnShop, false)
		setActive(slot0.arrRightBtnShop, false)
	else
		setActive(slot0.arrLeftBtn, true)
		setActive(slot0.arrRightBtn, true)
		setActive(slot0.arrLeftBtnShop, false)
		setActive(slot0.arrRightBtnShop, false)
	end
end

slot0.CanClickRefBtn = function (slot0, slot1)
	slot2 = getProxy(DormProxy).TYPE

	if pg.TimeMgr.GetInstance():GetServerTime() < slot0.nextClickRefreshTime then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_shop_refresh_frequently", math.ceil(slot0.nextClickRefreshTime - slot3)))

		return false
	end

	if slot2 == slot1 and slot1 ~= 5 then
		return false
	end

	return true
end

slot0.SwitchPage = function (slot0, slot1, slot2, slot3)
	if getProxy(DormProxy).TYPE ~= slot1 or slot3 then
		slot0:emit(NewBackYardThemeTemplateMediator.ON_REFRESH, slot1, slot2, slot3)

		if not slot3 then
			slot0.nextClickRefreshTime = BackYardConst.MANUAL_REFRESH_THEME_TEMPLATE_TIME + pg.TimeMgr.GetInstance():GetServerTime()
		end
	end
end

slot0.UpdateDorm = function (slot0, slot1)
	slot0.dorm = slot1

	if slot0.contextData.infoPage:GetLoaded() and slot0.contextData.infoPage:isShowing() then
		slot0.contextData.infoPage:ExecuteAction("DormUpdated", slot1)
	end

	if slot0.descPages:GetLoaded() then
		slot0.descPages:ExecuteAction("UpdateDorm", slot1)
	end
end

slot0.PlayerUpdated = function (slot0, slot1)
	slot0.player = slot1

	if slot0.contextData.infoPage:GetLoaded() and slot0.contextData.infoPage:isShowing() then
		slot0.contextData.infoPage:ExecuteAction("OnPlayerUpdated", slot1)
	end

	if slot0.descPages:GetLoaded() then
		slot0.descPages:ExecuteAction("PlayerUpdated", slot1)
	end
end

slot0.FurnituresUpdated = function (slot0, slot1)
	if slot0.contextData.infoPage:GetLoaded() and slot0.contextData.infoPage:isShowing() then
		slot0.contextData.infoPage:ExecuteAction("FurnituresUpdated", slot1)
	end
end

slot0.ThemeTemplateUpdate = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.list) do
		if slot6.id == slot1.id then
			slot0.list[slot5] = slot1

			break
		end
	end

	for slot5, slot6 in pairs(slot0.cards) do
		if slot6.template.id == slot1.id then
			slot6:Update(slot1)
		end
	end

	if slot0.descPages:GetLoaded() then
		slot0.descPages:ThemeTemplateUpdate(slot1)
	end
end

slot0.ThemeTemplatesUpdate = function (slot0, slot1)
	slot0:Flush(slot1)
end

slot0.OnSearchKeyChange = function (slot0)
	slot0:emit(NewBackYardThemeTemplateMediator.ON_SEARCH, slot0.pageType, getInputText(slot0.searchInput))
end

slot0.ShopSearchKeyChange = function (slot0, slot1)
	slot0.searchTemplate = slot1

	slot0:InitThemeList()

	for slot5, slot6 in pairs(slot0.cards) do
		if slot6.themeVO.id == slot1.id then
			triggerButton(slot6._tf)

			break
		end
	end
end

slot0.OnSearchKeyEditEnd = function (slot0)
	if not getInputText(slot0.searchInput) or slot1 == "" then
		slot0:emit(NewBackYardThemeTemplateMediator.ON_SEARCH, slot0.pageType, slot1)
	end
end

slot0.ClearShopSearchKey = function (slot0)
	slot0.searchTemplate = nil

	slot0:InitThemeList()
	slot0:ForceActiveFirstCard()
end

slot0.DeleteCustomThemeTemplate = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.list) do
		if slot6.id == slot1 then
			table.remove(slot0.list, slot5)

			break
		end
	end

	slot0:InitThemeList()
	slot0:ForceActiveFirstCard()
end

slot0.DeleteCollectionThemeTemplate = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.list) do
		if slot6.id == slot1 then
			table.remove(slot0.list, slot5)

			break
		end
	end

	slot0:InitThemeList()
	slot0:ForceActiveFirstCard()
end

slot0.AddCollectionThemeTemplate = function (slot0, slot1)
	table.insert(slot0.list, slot1)
	slot0:InitThemeList()
end

slot0.DeleteShopThemeTemplate = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.list) do
		if slot6.id == slot1 then
			table.remove(slot0.list, slot5)

			break
		end
	end

	slot0:InitThemeList()
	slot0:ForceActiveFirstCard()
end

slot0.ThemeTemplatesErro = function (slot0)
	slot0:UpdateArr()
end

slot0.GetData = function (slot0)
	if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		table.sort(slot0.list, function (slot0, slot1)
			return slot0.sortIndex < slot1.sortIndex
		end)
	else
		slot1, slot2 = nil

		if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			slot1, slot4 = BackYardConst.ServerIndex2ThemeSortIndex(getProxy(DormProxy).TYPE)
			slot2 = slot4
		else
			slot1 = defaultValue(slot0.sortIndex, 1)
			slot2 = defaultValue(slot0.asc, true)
		end

		slot3 = BackYardThemeTemplateSortPanel.GetSortArr(slot1)

		table.sort(slot0.list, function (slot0, slot1)
			if slot0 then
				return slot0[slot1] < slot1[slot1]
			else
				return slot1[slot1] < slot0[slot1]
			end
		end)
	end

	return slot0.list
end

slot0.OnDormUpdated = function (slot0)
	return
end

slot0.OnPlayerUpdated = function (slot0)
	return
end

slot0.BlurView = function (slot0)
	return
end

slot0.UnBlurView = function (slot0)
	return
end

slot0.SetUp = function (slot0, slot1, slot2, slot3, slot4)
	slot0.searchTemplate = nil
	slot0.searchKey = ""
	slot0.pageType = slot1
	slot0.dorm = slot3
	slot0.player = slot4

	slot0:Flush(slot2)

	if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		slot6 = getProxy(DormProxy).PAGE

		setActive(slot0.btns[getProxy(DormProxy).TYPE]:Find("sel"), true)

		slot0.selectedRefBtn = slot0.btns[getProxy(DormProxy).TYPE]

		if getProxy(DormProxy):NeedRefreshThemeTemplateShop() then
			slot0:SwitchPage(slot5, slot6, true)
		end
	end

	setActive(slot0.refreshBtns, slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP)
	setActive(slot0.searchInput.gameObject, slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP)

	if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION and getProxy(DormProxy):NeedCollectionTip() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("BackYard_collection_be_delete_tip"))
	end

	if getProxy(DormProxy):NeedShopShowHelp() then
	end
end

slot0.Flush = function (slot0, slot1)
	slot0:Show()

	slot0.list = slot1 or {}

	slot0:InitThemeList()
	slot0:UpdateArr()
	onNextTick(function ()
		slot0:ForceActiveFirstCard()
	end)
end

slot0.InitThemeList = function (slot0)
	setActive(slot0.rawImage.gameObject, false)
	slot0:SetTotalCount()
end

slot0.SetTotalCount = function (slot0)
	slot0.disPlays = {}
	slot1 = slot0:GetData()

	if slot0.searchTemplate then
		table.insert(slot0.disPlays, slot0.searchTemplate)
	else
		for slot5, slot6 in ipairs(slot1) do
			if slot6:MatchSearchKey(slot0.searchKey) then
				table.insert(slot0.disPlays, slot6)
			end
		end
	end

	slot0.scrollRect:SetTotalCount(#slot0.disPlays)
end

slot0.ForceActiveFirstCard = function (slot0)
	setActive(slot0.tipBg, #slot0.disPlays == 0)

	GetOrAddComponent(slot0.listRect, typeof(CanvasGroup)).alpha = (not (#slot0.disPlays == 0) or 0) and 1
	GetOrAddComponent(slot0.listRect, typeof(CanvasGroup)).blocksRaycasts = not (#slot0.disPlays == 0)

	_.each(slot0.tips, function (slot0)
		setActive(slot0, slot0.gameObject.name == "tip" .. tostring(slot0.pageType) and #slot0.disPlays == 0)
	end)
	setActive(slot0.goBtn, slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM and #slot0.disPlays == 0)

	if #slot0.disPlays == 0 then
		slot0.descPages.ExecuteAction(slot3, "Hide")

		return
	end

	slot3 = slot0.disPlays[1]

	for slot7, slot8 in pairs(slot0.cards) do
		if slot3.id == slot8.template.id then
			triggerButton(slot8._tf)

			break
		end
	end
end

slot0.NoSelected = function (slot0)
	return false
end

slot0.CreateCard = function (slot0, slot1)
	return BackYardThemeTemplateCard.New(slot1)
end

slot0.OnCardClick = function (slot0, slot1)
	if slot1.template == slot0.card then
		return
	end

	if slot0.descPages:GetLoaded() then
		slot0.descPages:Hide()
	end

	setActive(slot0.rawImage.gameObject, false)

	function slot2(slot0)
		BackYardThemeTempalteUtil.GetTexture(slot0:GetTextureName(), slot1, function (slot0)
			if not IsNil(slot0.rawImage) and slot0 then
				slot0.rawImage.texture = slot0

				setActive(slot0.rawImage.gameObject, true)
			end
		end)
		slot0.descPages.ExecuteAction(slot2, "SetUp", slot0.pageType, slot1.template, slot0.dorm, slot0.player)
	end

	if slot1.template.ShouldFetch(slot3) then
		slot0:emit(NewBackYardThemeTemplateMediator.ON_GET_THEMPLATE_DATA, slot1.template.id, function (slot0)
			slot0(slot1.template)
		end)
	else
		slot2(slot1.template)
	end

	slot0.card = slot1.template
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)

	slot0.descPages.OnSortChange = nil

	slot0.descPages:Destroy()

	slot0.contextData.sortPage.OnConfirm = nil

	slot0.contextData.sortPage:Destroy()
	slot0.contextData.infoPage:Destroy()
	slot0.contextData.furnitureMsgBox:Destroy()
	slot0.contextData.themeMsgBox:Destroy()
end

return slot0

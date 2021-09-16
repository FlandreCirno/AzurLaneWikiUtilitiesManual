slot0 = class("BackYardThemePage", import(".BackYardShopBasePage"))

slot0.getUIName = function (slot0)
	return "BackYardThemePage"
end

slot0.OnLoaded = function (slot0)
	slot0:LoadList()
	slot0:LoadDetail()
end

slot0.LoadList = function (slot0)
	slot0.adpter = slot0:findTF("adpter")
	slot0.themeContainer = slot0:findTF("adpter/list")
	slot0.scrollRect = slot0:findTF("adpter/list/mask"):GetComponent("LScrollRect")
	slot0.scrollRectWidth = slot0:findTF("adpter/list/mask").rect.width
	slot0.arrLeftBtn = slot0:findTF("adpter/list/zuobian")
	slot0.arrRightBtn = slot0:findTF("adpter/list/youbian")
	slot0.preview = slot0:findTF("preview"):GetComponent(typeof(Image))
	slot0.helpBtn = slot0:findTF("adpter/help")

	setActive(slot0.helpBtn, false)
	setActive(slot0:findTF("sort_bg"), true)

	slot0.searchInput = slot0:findTF("search")
	slot0.searchBtn = slot0:findTF("search/btn")
end

slot0.LoadDetail = function (slot0)
	slot0.purchaseBtn = slot0:findTF("adpter/descript/btn_goumai")
	slot0.title = slot0:findTF("adpter/descript/title"):GetComponent(typeof(Text))
	slot0.desc = slot0:findTF("adpter/descript/desc"):GetComponent(typeof(Text))
	slot0.actualPrice = slot0:findTF("adpter/descript/price/actual_price")
	slot0.actualPriceTxt = slot0:findTF("adpter/descript/price/actual_price/Text"):GetComponent(typeof(Text))
	slot0.goldTxt = slot0:findTF("adpter/descript/price/price/Text"):GetComponent(typeof(Text))
	slot0.descript = slot0:findTF("adpter/descript")
	slot0.infoPage = BackYardThemeInfoPage.New(slot0._tf, slot0._event, slot0.contextData)

	slot0.infoPage.OnEnter = function ()
		slot0:UnBlurView()
	end

	slot0.infoPage.OnExit = function ()
		slot0:BlurView()
	end

	slot0.infoPage.OnPrevTheme = function ()
		slot0:OnInfoPagePrevTheme()
	end

	slot0.infoPage.OnNextTheme = function ()
		slot0:OnInfoPageNextTheme()
	end

	onButton(slot0, slot0.purchaseBtn, function ()
		slot0 = slot0:GetSelectedIndex()

		slot0.infoPage:ExecuteAction("SetUp", slot0, slot0.selected, slot0.dorm, slot0.player)
	end, SFX_PANEL)
end

slot0.OnInit = function (slot0)
	slot0.cards = {}

	slot0.scrollRect.onInitItem = function (slot0)
		slot0:OnInitCard(slot0)
	end

	slot0.scrollRect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateCard(slot0, slot1)
	end

	slot0.scrollRect.onValueChanged.AddListener(slot1, function (slot0)
		setActive(slot0.arrLeftBtn, slot0.x >= 0)
		setActive(slot0.arrRightBtn, slot0.x <= 1)
	end)
	onButton(slot0, slot0.arrLeftBtn, function ()
		slot0:OnSwitchToPrevTheme()
	end, SFX_PANEL)
	onButton(slot0, slot0.searchBtn, function ()
		slot0:OnSearchKeyChange()
	end)
	onInputEndEdit(slot0, slot0.searchInput, function ()
		slot0:OnSearchKeyEditEnd()
	end)
	onButton(slot0, slot0.arrRightBtn, function ()
		slot0:OnSwitchToNextTheme()
	end, SFX_PANEL)
end

slot0.GetData = function (slot0)
	slot1 = {}
	slot3 = getInputText(slot0.searchInput)

	for slot7, slot8 in ipairs(slot2) do
		if not slot8:IsOverTime() and slot8:MatchSearchKey(slot3) then
			table.insert(slot1, slot8)
		end
	end

	slot4 = slot0.dorm:GetAllFurniture()
	slot5 = {}

	for slot9, slot10 in ipairs(slot1) do
		slot5[slot10.id] = slot10:IsPurchased(slot4)
	end

	slot6 = pg.backyard_theme_template

	table.sort(slot1, function (slot0, slot1)
		if ((slot0[slot0.id] and 1) or 0) == ((slot0[slot1.id] and 1) or 0) then
			if slot1[slot0.id].new == slot1[slot1.id].new then
				return slot1.id < slot0.id
			else
				return slot1[slot1.id].new < slot1[slot0.id].new
			end
		else
			return slot2 < slot3
		end
	end)

	return slot1
end

slot0.FurnituresUpdated = function (slot0, slot1)
	if slot0.infoPage:GetLoaded() then
		slot0.infoPage:ExecuteAction("FurnituresUpdated", slot1)
	end

	slot0:InitThemeList()
end

slot0.OnDormUpdated = function (slot0)
	if slot0.infoPage:GetLoaded() then
		slot0.infoPage:ExecuteAction("DormUpdated", slot0.dorm)
	end
end

slot0.OnPlayerUpdated = function (slot0)
	if slot0.infoPage:GetLoaded() then
		slot0.infoPage:ExecuteAction("OnPlayerUpdated", slot0.player)
	end
end

slot0.OnSetUp = function (slot0)
	slot0:InitThemeList()
	slot0:BlurView()
end

slot0.InitThemeList = function (slot0)
	slot0.disPlays = slot0:GetData()

	slot0.scrollRect:SetTotalCount(#slot0.disPlays)
end

slot0.OnSearchKeyChange = function (slot0)
	slot0:InitThemeList()
end

slot0.OnSearchKeyEditEnd = function (slot0)
	if not getInputText(slot0.searchInput) or slot1 == "" then
		slot0:InitThemeList()
	end
end

slot0.CreateCard = function (slot0, slot1)
	return BackYardThemeCard.New(slot1)
end

slot0.OnInitCard = function (slot0, slot1)
	onButton(slot0, slot0:CreateCard(slot1)._go, function ()
		slot0:OnCardClick(slot0)

		slot0.OnCardClick.selected.selected = slot1.themeVO

		if slot0.OnCardClick.selected then
			for slot4, slot5 in pairs(slot0.cards) do
				if slot5.themeVO.id == slot0.id and slot5._go.name ~= "-1" then
					preCard = slot5

					break
				end
			end

			if preCard then
				preCard:UpdateSelected(slot0.selected)
			end
		end

		slot1:UpdateSelected(slot0.selected)
	end, SFX_PANEL)

	slot0.cards[slot1] = slot0.CreateCard(slot1)
end

slot0.OnUpdateCard = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitCard(slot2)
	end

	slot0.cards[slot2].Update(slot3, slot5, slot0.disPlays[slot1 + 1]:IsPurchased(slot0.dorm:GetAllFurniture()))
	slot0.cards[slot2].UpdateSelected(slot3, slot0.selected)

	if slot0:NoSelected() and slot1 == 0 then
		triggerButton(slot3._go)
	end
end

slot0.NoSelected = function (slot0)
	return not slot0.selected or not _.any(slot0.disPlays, function (slot0)
		return slot0.id == slot0.selected.id
	end)
end

slot0.OnCardClick = function (slot0, slot1)
	slot0:UpdateMainPage(slot1.themeVO)
end

slot0.UpdateMainPage = function (slot0, slot1)
	if slot1 == slot0.card then
		return
	end

	slot0.title.text = slot1:getConfig("name")
	slot0.desc.text = slot1:getConfig("desc")
	slot2 = slot1:getConfig("discount")

	setActive(slot0.actualPrice, slot3)

	slot0.goldTxt.text, slot0.actualPriceTxt.text = slot0:CalcThemePrice(slot1)

	GetSpriteFromAtlasAsync("BackYardTheme/theme_" .. slot1.id, "", function (slot0)
		if IsNil(slot0.preview) then
			return
		end

		slot0.preview.sprite = slot0
	end)
	setActive(go(slot0.preview), true)

	slot0.card = slot1
end

slot0.CalcThemePrice = function (slot0, slot1)
	slot3 = 0
	slot4 = 0

	for slot8, slot9 in ipairs(slot2) do
		slot10 = Furniture.New({
			id = slot9
		})
		slot4 = slot4 + slot10:getConfig("dorm_icon_price")
		slot3 = slot3 + slot10:getPrice(PlayerConst.ResDormMoney)
	end

	return slot3, slot4
end

function slot1(slot0, slot1)
	slot2 = nil

	for slot6, slot7 in pairs(slot0) do
		if slot7.themeVO.id == slot1.id then
			slot2 = slot7

			break
		end
	end

	return slot2
end

function slot2(slot0, slot1, slot2)
	return math.abs(slot0:HeadIndexToValue(slot2) - slot0:HeadIndexToValue(slot1))
end

slot0.GetSelectedIndex = function (slot0)
	slot1 = 0

	for slot5, slot6 in ipairs(slot0.disPlays) do
		if slot6.id == slot0.selected.id then
			slot1 = slot5

			break
		end
	end

	return slot1
end

slot0.OnSwitchToNextTheme = function (slot0)
	if slot0:GetSelectedIndex() >= #slot0.disPlays then
		return false
	end

	function slot4(slot0)
		return go(slot0.scrollRect).transform.localPosition.x + slot0.scrollRectWidth / 2 < go(slot0.scrollRect).transform.parent:InverseTransformPoint(slot0._tf.position).x
	end

	if not slot0(slot0.cards, slot0.disPlays[slot1 + 1]) or (slot3 and slot4(slot3)) then
		slot0.scrollRect:ScrollTo(slot0.scrollRect.value + slot1(slot0.scrollRect, 1, 2), true)

		slot3 = slot0(slot0.cards, slot2)
	end

	if slot3 then
		triggerButton(slot3._go)
	end

	return true
end

slot0.OnSwitchToPrevTheme = function (slot0)
	if slot0:GetSelectedIndex() <= 1 then
		return false
	end

	function slot4(slot0)
		return go(slot0.scrollRect).transform.parent:InverseTransformPoint(slot0._tf.position).x < go(slot0.scrollRect).transform.localPosition.x - slot0.scrollRectWidth / 2
	end

	if not slot0(slot0.cards, slot0.disPlays[slot1 - 1]) or (slot3 and slot4(slot3)) then
		slot0.scrollRect:ScrollTo(slot0.scrollRect.value - slot1(slot0.scrollRect, 1, 2), true)

		slot3 = slot0(slot0.cards, slot2)
	end

	if slot3 then
		triggerButton(slot3._go)
	end

	return true
end

slot0.OnInfoPagePrevTheme = function (slot0)
	if slot0:OnSwitchToPrevTheme() then
		triggerButton(slot0.purchaseBtn)
	end
end

slot0.OnInfoPageNextTheme = function (slot0)
	if slot0:OnSwitchToNextTheme() then
		triggerButton(slot0.purchaseBtn)
	end
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	slot0:UnBlurView()
end

slot0.BlurView = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanelPB(slot0.descript, {
		pbList = {
			slot0.descript
		}
	})
	SetParent(slot0.adpter, pg.UIMgr.GetInstance().OverlayMain)
end

slot0.UnBlurView = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.descript, slot0._tf)
	SetParent(slot0.adpter, slot0._tf)
end

slot0.OnDestroy = function (slot0)
	if slot0.infoPage then
		slot0.infoPage.OnExit = nil
		slot0.infoPage.OnEnter = nil
		slot0.infoPage.OnPrevTheme = nil
		slot0.infoPage.OnNextTheme = nil

		slot0.infoPage:Destroy()
	end

	slot0:Hide()
end

return slot0

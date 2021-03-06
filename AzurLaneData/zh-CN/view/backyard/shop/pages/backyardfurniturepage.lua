slot0 = class("BackYardFurniturePage", import(".BackYardShopBasePage"))

table.insert(slot1, 1, {})

function slot2(slot0)
	return slot0[slot0]
end

slot0.getUIName = function (slot0)
	return "BackYardFurniturePage"
end

slot0.OnLoaded = function (slot0)
	slot0.scrollRect = slot0:findTF("frame/bg"):GetComponent("LScrollRect")
	slot0.searchInput = slot0:findTF("sort_bg/fliter_container/search")
	slot0.searchBtn = slot0:findTF("sort_bg/fliter_container/search/btn")
	slot0.filterBtn = slot0:findTF("sort_bg/fliter_container/filter")
	slot0.filterBtnTxt = slot0.filterBtn:Find("Text"):GetComponent(typeof(Text))
	slot0.filterBtnTxt.text = i18n("word_default")
	slot0.orderBtn = slot0:findTF("sort_bg/fliter_container/order")
	slot0.orderBtnTxt = slot0.orderBtn:Find("Text"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	slot0.cards = {}

	slot0.scrollRect.onInitItem = function (slot0)
		slot0:OnInitItem(slot0)
	end

	slot0.scrollRect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end

	onButton(slot0, slot0.searchBtn, function ()
		slot0:OnSearchKeyChange()
	end)

	slot0.orderMode = BackYardDecorationFilterPanel.ORDER_MODE_DASC

	function slot1(slot0)
		slot1 = ""

		if slot0 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			slot1 = i18n("word_asc")
		elseif slot0 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
			slot1 = i18n("word_desc")
		end

		slot0.orderBtnTxt.text = slot1
	end

	onToggle(slot0, slot0.orderBtn, function (slot0)
		slot0.orderMode = (slot0 and BackYardDecorationFilterPanel.ORDER_MODE_ASC) or BackYardDecorationFilterPanel.ORDER_MODE_DASC

		slot0(slot0.orderMode)
		slot0:UpdateFliterData()
		slot0.contextData.filterPanel:Sort()
		slot0:OnFilterDone()
	end, SFX_PANEL)
	slot1(slot0.orderMode)

	slot0.contextData.filterPanel.confirmFunc = function ()
		slot0.filterBtnTxt.text = slot0.contextData.filterPanel.sortTxt

		slot0:OnFilterDone()
	end

	onButton(slot0, slot0.filterBtn, function ()
		slot0.contextData.filterPanel:setFilterData(slot0:GetData())
		slot0.contextData.filterPanel.setFilterData.contextData.filterPanel:ExecuteAction("Show")
	end, SFX_PANEL)
	slot0.UpdateFliterData(slot0)
end

slot0.UpdateFliterData = function (slot0)
	slot0.contextData.filterPanel:updateOrderMode(slot0.orderMode)
end

slot0.OnFilterDone = function (slot0)
	slot0.displays = slot0.contextData.filterPanel:GetFilterData()

	slot0.scrollRect:SetTotalCount(#slot0.displays)
end

slot0.OnDisplayUpdated = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.displays) do
		if slot6.id == slot1.id then
			slot0.displays[slot5] = slot1

			break
		end
	end
end

slot0.OnCardUpdated = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.cards) do
		if slot6.furniture.id == slot1.id then
			slot6:Update(slot1)

			break
		end
	end
end

slot0.OnDormUpdated = function (slot0)
	slot0:UpdateFliterData()
end

slot0.OnSetUp = function (slot0)
	slot0:InitFurnitureList()
end

slot0.OnSearchKeyChange = function (slot0)
	slot0:InitFurnitureList()
end

slot0.InitFurnitureList = function (slot0)
	slot0.contextData.filterPanel:setFilterData(slot0:GetData())
	slot0.contextData.filterPanel:filter()
	slot0:OnFilterDone()
end

slot0.GetData = function (slot0)
	slot1 = {}
	slot2 = slot0.dorm:GetAllFurniture()

	function slot3(slot0)
		return not slot0:isNotForSale() and (not slot0:isForActivity() or slot0[slot0.id]) and not not slot0:inTime()
	end

	function slot4(slot0)
		return slot0:isMatchSearchKey(getInputText(slot0.searchInput))
	end

	function slot5(slot0, slot1)
		return table.contains(slot1, slot0:getConfig("type"))
	end

	for slot10, slot11 in ipairs(pg.furniture_shop_template.all) do
		if not slot2[slot11] then
			slot13 = Furniture.New({
				id = slot11
			})
			slot12 = slot13
		end

		if slot3(slot12) and slot5(slot12, slot0(slot0.pageType)) and slot4(slot12) then
			table.insert(slot1, slot12)
		end
	end

	return slot1
end

slot0.OnInitItem = function (slot0, slot1)
	onButton(slot0, BackYardFurnitureCard.New(slot1)._go, function ()
		if slot0.furniture:canPurchase() then
			slot1.contextData.furnitureMsgBox:ExecuteAction("SetUp", slot0.furniture, slot1.dorm, slot1.player)
		end
	end, SFX_PANEL)

	slot0.cards[slot1] = BackYardFurnitureCard.New(slot1)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitItem(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:Update(slot0.displays[slot1 + 1])
end

slot0.OnDestroy = function (slot0)
	for slot4, slot5 in pairs(slot0.cards) do
		slot5:Clear()
	end
end

return slot0

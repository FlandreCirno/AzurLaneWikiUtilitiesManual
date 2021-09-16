slot0 = class("BackYardDecrationLayer", import("...base.BaseUI"))
slot1 = 1
slot2 = 2
slot3 = 3
slot4 = 4
slot5 = 5
slot6 = 6
slot7 = 7
slot8 = {
	"word_theme",
	"word_furniture",
	"word_decorate",
	"word_wallpaper",
	"word_floorpaper",
	"word_wall",
	"word_collection"
}

function slot9(slot0)
	return i18n(slot0[slot0])
end

slot0.getUIName = function (slot0)
	return "BackYardDecorationUI"
end

slot0.init = function (slot0)
	slot0.adpter = slot0:findTF("adpter")
	slot0.tagTpl = slot0:findTF("adpter/bottom/tags/tag")
	slot0.tagsContainer = slot0:findTF("adpter/bottom/tags")
	slot0.pageConainer = slot0:findTF("adpter/bottom/pages")
	slot0.shopBtn = slot0:findTF("adpter/bottom/shop")
	slot0.saveBtn = slot0:findTF("adpter/bottom/save")
	slot0.clearBtn = slot0:findTF("adpter/bottom/clrear")
	slot0.orderBtn = slot0:findTF("adpter/bottom/fliter_container/order")
	slot0.orderBtnTxt = slot0.orderBtn:Find("Text"):GetComponent(typeof(Text))
	slot0.filterBtn = slot0:findTF("adpter/bottom/fliter_container/filter")
	slot0.filterBtnTxt = slot0.filterBtn:Find("Text"):GetComponent(typeof(Text))
	slot0.filterBtnTxt.text = i18n("word_default")
	slot0.searchInput = slot0:findTF("adpter/bottom/fliter_container/search")
	slot0.showPutListBtn = slot0:findTF("adpter/putlist_btn")
	slot0.themePage = BackYardDecorationThemePage.New(slot0.pageConainer, slot0.event, slot0.contextData)
	slot0.furniturePage = BackYardDecorationFurniturePage.New(slot0.pageConainer, slot0.event, slot0.contextData)
	slot0.putListPage = BackYardDecorationPutlistPage.New(slot0.adpter, slot0.event, slot0.contextData)

	slot0.putListPage.OnShow = function (slot0)
		setActive(slot0.showPutListBtn, not slot0)
	end

	slot0.putListPage.OnShowImmediately = function ()
		setActive(slot0.showPutListBtn, false)
	end

	slot0.contextData.furnitureDescMsgBox = BackYardDecorationDecBox.New(slot0._tf, slot0.event, slot0.contextData)
	slot0.contextData.filterPanel = BackYardDecorationFilterPanel.New(slot0._tf, slot0.event, slot0.contextData)
	slot0.pages = {
		[slot0] = slot0.themePage,
		[slot1] = slot0.furniturePage,
		[slot1] = slot0.furniturePage,
		[slot0.furniturePage] = slot0.furniturePage,
		[slot4] = slot0.furniturePage,
		[slot5] = slot0.furniturePage,
		[slot6] = slot0.furniturePage
	}
end

slot0.didEnter = function (slot0)
	slot0.orderMode = BackYardDecorationFilterPanel.ORDER_MODE_ASC

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

		if slot0.pageType then
			slot0.pages[slot0.pageType]:ExecuteAction("OrderModeUpdated", slot0.orderMode)
		end

		slot1(slot0.orderMode)
	end, SFX_PANEL)
	slot1(slot0.orderMode)
	onButton(slot0, slot0.shopBtn, function ()
		slot0:emit(BackYardDecorationMediator.OPEN_SHOP)
	end, SFX_PANEL)
	onButton(slot0, slot0.saveBtn, function ()
		slot0:emit(BackYardDecorationMediator.SAVE_ALL)
	end, SFX_PANEL)
	onButton(slot0, slot0.clearBtn, function ()
		slot0:emit(BackYardDecorationMediator.ClEAR_ALL, true)
	end, SFX_PANEL)
	onButton(slot0, slot0.filterBtn, function ()
		if not slot0.pageType then
			return
		end

		slot0.pages[slot0.pageType]:ShowFilterPanel(function (slot0)
			slot0.filterBtnTxt.text = slot0
		end)
	end, SFX_PANEL)
	onInputChanged(slot0, slot0.searchInput, function (slot0)
		if not slot0.pageType then
			return
		end

		slot0.pages[slot0.pageType]:ExecuteAction("SearchKeyUpdated", slot0)
	end)
	onButton(slot0, slot0.showPutListBtn, function ()
		slot0.putListPage:ExecuteAction("SetUp", 0, slot0.dorm, slot0.themes, slot0.orderMode)
	end, SFX_PANEL)
	seriesAsync({
		function (slot0)
			if slot0.themes then
				slot0()

				return
			end

			slot0:emit(BackYardDecorationMediator.GET_CUSTOM_THEME, slot0)
		end
	}, function ()
		slot0:InitPages()
		slot0.InitPages:ShowDefaultPage()
	end)
end

slot0.SetDorm = function (slot0, slot1)
	slot0.dorm = slot1
end

slot0.UpdateDorm = function (slot0, slot1)
	slot0.dorm = slot1

	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("DormUpdated", slot0.dorm)
	end

	if slot0.putListPage:GetLoaded() then
		slot0.putListPage:ExecuteAction("DormUpdated", slot0.dorm)
	end
end

slot0.OnApplyThemeBefore = function (slot0)
	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("OnApplyThemeBefore")
	end
end

slot0.OnApplyThemeAfter = function (slot0, slot1)
	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("OnApplyThemeAfter", slot1)
	end
end

slot0.UpdateFurnitrue = function (slot0, slot1)
	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("FurnitureUpdated", slot1)
	end
end

slot0.SetThemes = function (slot0, slot1)
	slot0.themes = slot1
end

slot0.CustomThemeAdded = function (slot0, slot1)
	slot0.themes[slot1.id] = slot1

	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("CustomThemeAdded", slot1)
	end
end

slot0.CustomThemeDeleted = function (slot0, slot1)
	slot0.themes[slot1] = nil

	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("CustomThemeDeleted", slot1)
	end
end

slot0.ThemeUpdated = function (slot0)
	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("ThemeUpdated")
	end
end

slot0.InitPages = function (slot0)
	slot0.btns = {}
	slot1 = 0

	for slot5, slot6 in ipairs(slot0.pages) do
		slot7 = slot0.tagsContainer:GetChild(slot1)

		onToggle(slot0, slot7, function (slot0)
			if slot0 then
				slot0:SwitchToPage(slot0.SwitchToPage)
			end
		end, SFX_PANEL)
		setText(slot7.Find(slot7, "Text"), slot0(slot5))

		slot1 = slot1 + 1
		slot0.btns[slot5] = slot7
	end
end

slot0.ShowDefaultPage = function (slot0)
	triggerToggle(slot0.btns[slot0], true)
end

slot0.SwitchToPage = function (slot0, slot1)
	if slot0.pageType == slot1 then
		return
	end

	if slot0.page and not slot0.page:GetLoaded() then
		return
	end

	slot2 = slot0.pages[slot1]

	if slot0.page and slot0.page ~= slot2 then
		slot0.page:ExecuteAction("Hide")
	end

	slot2:ExecuteAction("SetUp", slot1, slot0.dorm, slot0.themes, slot0.orderMode)

	slot0.page = slot2
	slot0.pageType = slot1

	setActive(slot0.filterBtn, slot0.pageType ~= slot0)
end

slot0.willExit = function (slot0)
	slot0.themePage:Destroy()
	slot0.furniturePage:Destroy()
	slot0.putListPage:Destroy()
	slot0.contextData.furnitureDescMsgBox:Destroy()
	slot0.contextData.filterPanel:Destroy()
end

slot0.onBackPressed = function (slot0)
	if slot0.themePage:OnBackPressed() then
		return
	end

	if slot0.furniturePage:OnBackPressed() then
		return
	end

	if slot0.putListPage:OnBackPressed() then
		return
	end

	if slot0.contextData.furnitureDescMsgBox:GetLoaded() and slot0.contextData.furnitureDescMsgBox:isShowing() then
		slot0.contextData.furnitureDescMsgBox:Hide()

		return
	end

	if slot0.contextData.filterPanel:GetLoaded() and slot0.contextData.filterPanel:isShowing() then
		slot0.contextData.filterPanel:Hide()

		return
	end

	triggerButton(slot0.saveBtn)
end

return slot0

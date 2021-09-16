slot0 = class("NewBackYardShopLayer", import("...base.BaseUI"))
slot1 = 1
slot2 = 2
slot3 = 3
slot4 = 4
slot5 = 5
slot6 = 6
slot7 = {
	"word_theme",
	"word_wallpaper",
	"word_floorpaper",
	"word_furniture",
	"word_decorate",
	"word_wall"
}

function slot8(slot0)
	return i18n(slot0[slot0])
end

function slot9(slot0, slot1, slot2)
	function slot3(slot0, slot1)
		setActive(slot0:Find("btn_di"), slot1)
	end

	onButton(slot0, slot1, function ()
		if not slot0() then
			return
		end

		if slot1.btn then
			slot2(slot1.btn, false)
		end

		slot2(slot3, true)

		slot3.btn = slot3
	end, SFX_PANEL)
	slot3(slot1, false)
end

slot0.getUIName = function (slot0)
	return "NewBackYardShopUI"
end

slot0.SetDorm = function (slot0, slot1)
	slot0.dorm = slot1
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.player = slot1
end

slot0.PlayerUpdated = function (slot0, slot1)
	slot0:SetPlayer(slot1)
	slot0:UpdateRes()

	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("PlayerUpdated", slot1)
	end
end

slot0.DormUpdated = function (slot0, slot1)
	slot0:SetDorm(slot1)

	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("DormUpdated", slot1)
	end
end

slot0.FurnituresUpdated = function (slot0, slot1)
	if slot0.pageType then
		slot0.pages[slot0.pageType]:ExecuteAction("FurnituresUpdated", slot1)
	end
end

slot0.init = function (slot0)
	slot0.pageContainer = slot0:findTF("pages")
	slot0.btnTpl = slot0:getTpl("adpter/list/tpl")
	slot0.btnContainer = slot0:findTF("adpter/list")
	slot0.backBtn = slot0:findTF("adpter/top/fanhui")
	slot0.goldTxt = slot0:findTF("adpter/top/res_gold/Text"):GetComponent(typeof(Text))
	slot0.gemTxt = slot0:findTF("adpter/top/res_gem/Text"):GetComponent(typeof(Text))
	slot0.goldAddBtn = slot0:findTF("adpter/top/res_gold/jiahao")
	slot0.gemAddBtn = slot0:findTF("adpter/top/res_gem/jiahao")

	SetActive(slot0:findTF("adpter/top/top_word1"), false)
	SetActive(slot0:findTF("adpter/top/top_word"), true)

	slot0.help = slot0:findTF("adpter/top/help")
	slot0.themePage = BackYardThemePage.New(slot0.pageContainer, slot0.event, slot0.contextData)
	slot0.furniturePage = BackYardFurniturePage.New(slot0.pageContainer, slot0.event, slot0.contextData)
	slot0.contextData.filterPanel = BackYardShopFilterPanel.New(slot0._tf, slot0.event, slot0.contextData)
	slot0.pages = {
		[slot0] = slot0.themePage,
		[slot1] = slot0.furniturePage,
		[slot1] = slot0.furniturePage,
		[slot0.furniturePage] = slot0.furniturePage,
		[slot4] = slot0.furniturePage,
		[slot5] = slot0.furniturePage
	}
	slot0.contextData.furnitureMsgBox = BackYardFurnitureMsgBoxPage.New(slot0._tf, slot0.event)
	slot0.contextData.themeMsgBox = BackYardThemeMsgBoxPage.New(slot0._tf, slot0.event)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(slot0, slot0.help, function ()
		slot0:emit(slot1.ON_HOME)
	end, SFX_PANEL)
	onButton(slot0, slot0.goldAddBtn, function ()
		slot0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(slot0, slot0.gemAddBtn, function ()
		slot0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
	slot0.InitPageFooter(slot0)
	slot0:UpdateRes()
	triggerButton(slot0.btns[triggerButton])
end

slot0.UpdateRes = function (slot0)
	slot0.goldTxt.text = slot0.player:getResource(PlayerConst.ResDormMoney)
	slot0.gemTxt.text = slot0.player:getTotalGem()
end

slot0.InitPageFooter = function (slot0)
	slot0.btns = {}

	for slot4, slot5 in ipairs(slot0.pages) do
		slot6 = cloneTplTo(slot0.btnTpl, slot0.btnContainer)

		setText(slot6:Find("Text"), slot0(slot4))
		setText(slot6:Find("btn_di/Text"), slot0(slot4))
		slot1(slot0, slot6, function ()
			if slot0.pageType == slot1 then
				return
			end

			if slot0.pageType and not slot0.pages[slot0.pageType]:GetLoaded() then
				return
			end

			if slot0.pageType and slot0.pages[slot0.pageType] ~= slot2 then
				slot0.pages[slot0.pageType]:Hide()
			end

			slot2:ExecuteAction("SetUp", slot2, slot0.dorm, slot0.player)

			slot2.ExecuteAction.pageType = slot2

			return true
		end)

		slot0.btns[slot4] = slot6
	end
end

slot0.willExit = function (slot0)
	if slot0.contextData.onDeattch then
		slot0.contextData.onDeattch()
	end

	slot0.contextData.filterPanel:Destroy()
	slot0.themePage:Destroy()
	slot0.furniturePage:Destroy()
	slot0.contextData.furnitureMsgBox:Destroy()

	slot0.contextData.furnitureMsgBox = nil

	slot0.contextData.themeMsgBox:Destroy()

	slot0.contextData.themeMsgBox = nil
end

return slot0

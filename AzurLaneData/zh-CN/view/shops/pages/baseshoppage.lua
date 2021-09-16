slot0 = class("BaseShopPage", import("...base.BaseSubView"))

slot0.Load = function (slot0)
	if slot0._state ~= slot0.STATES.NONE then
		return
	end

	slot0._state = slot0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	if IsNil(findTF(slot1, slot0:getUIName())) then
		PoolMgr.GetInstance():GetUI(slot0:getUIName(), true, function (slot0)
			slot0:Loaded(slot0)
			slot0:Init()
		end)
	else
		slot0.Loaded(slot0, slot2.gameObject)
		slot0:Init()
	end
end

slot0.SetShop = function (slot0, slot1)
	slot0.shop = slot1
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.player = slot1

	slot0:OnUpdatePlayer()
end

slot0.SetItems = function (slot0, slot1)
	slot0.items = slot1

	slot0:OnUpdateItems()
end

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	slot0:SetShop(slot1)
	slot0:SetPlayer(slot2)
	slot0:SetItems(slot3)
	slot0:OnSetUp()
	slot0:SetPainting()
	slot0:Show()
end

slot0.SetPainting = function (slot0)
	if slot0.contextData.paintingView.name ~= slot0:GetPaintingName() then
		slot0.contextData.paintingView:Init(slot1)

		slot6, slot7 = slot0:GetPaintingEnterVoice()

		slot0.contextData.paintingView:Chat(slot2, slot3, true)
		onButton(slot0, slot0.contextData.paintingView.touch, function ()
			slot2, slot5 = slot0:GetPaintingTouchVoice()

			slot0.contextData.paintingView:Chat(slot0, slot1, false)
		end, SFX_PANEL)
	end
end

slot0.UpdateShop = function (slot0, slot1)
	slot0:SetShop(slot1)
	pg.MsgboxMgr.GetInstance():hide()
	slot0.contextData.singleWindow:ExecuteAction("Close")
	slot0.contextData.multiWindow:ExecuteAction("Close")
	slot0:OnUpdateAll()
end

slot0.UpdateCommodity = function (slot0, slot1, slot2)
	slot0:SetShop(slot1)
	slot0:OnUpdateCommodity(slot3)

	slot8, slot9 = slot0:GetPaintingCommodityUpdateVoice()

	slot0.contextData.paintingView:Chat(slot4, slot5, true)
end

slot0.OnClickCommodity = function (slot0, slot1, slot2)
	function slot3(slot0, slot1)
		if not slot0:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return false
		end

		slot2, slot3 = getPlayerOwn(slot0:getConfig("resource_category"), slot0:getConfig("resource_type"))

		if slot3 < slot0:getConfig("resource_num") * slot1 then
			if not ItemTipPanel.ShowItemTip(slot0:getConfig("resource_category"), slot0:getConfig("resource_type")) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", slot2))
			end

			return false
		end

		return true
	end

	function slot4(slot0, slot1, slot2)
		if slot0:getConfig("commodity_type") == 4 or slot0.shop.type == ShopArgs.ShopActivity then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("pt_reconfirm", slot2 or "??"),
				onYes = function ()
					if slot0(slot1, slot2) then
						slot3(slot1, slot2)
					end
				end
			})
		elseif slot0.getSpecialRule(slot3, slot0) and slot1(slot0, slot1) then
			slot2(slot0, slot1)
		end
	end

	if slot1.getConfig(slot1, "num_limit") == 1 or slot1:getConfig("commodity_type") == 4 then
		slot0.contextData.singleWindow:ExecuteAction("Open", slot1, slot4)
	else
		slot0.contextData.multiWindow:ExecuteAction("Open", slot1, slot4)
	end
end

slot0.getSpecialRule = function (slot0, slot1)
	if slot1:getConfig("commodity_type") == 2 and slot0.shop.type == ShopArgs.ShopFragment and pg.item_data_statistics[slot1:getConfig("commodity_id")] and slot3.type == 7 and slot3.shiptrans_id ~= 0 then
		slot5 = getProxy(BayProxy):getConfigShipCount(slot3.shiptrans_id)

		if getProxy(BagProxy):getItemById(slot2) or slot5 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("special_transform_limit_reach"))

			return false
		end
	end

	return true
end

slot0.CanOpen = function (slot0, slot1, slot2)
	return true
end

slot0.GetPaintingName = function (slot0)
	return "buzhihuo_shop"
end

slot0.GetPaintingEnterVoice = function (slot0)
	return string.split(slot1, "|")[math.random(#string.split(slot1, "|"))], "enter_" .. math.random(#string.split(slot1, "|"))
end

slot0.GetPaintingCommodityUpdateVoice = function (slot0)
	return string.split(slot1, "|")[math.random(#string.split(slot1, "|"))], "buy_" .. math.random(#string.split(slot1, "|"))
end

slot0.GetPaintingTouchVoice = function (slot0)
	return string.split(slot1, "|")[math.random(#string.split(slot1, "|"))], "touch_" .. math.random(#string.split(slot1, "|"))
end

slot0.GetBg = function (slot0, slot1)
	return
end

slot0.OnSetUp = function (slot0)
	return
end

slot0.OnUpdateAll = function (slot0)
	return
end

slot0.OnUpdateCommodity = function (slot0, slot1)
	return
end

slot0.OnUpdatePlayer = function (slot0)
	return
end

slot0.OnUpdateItems = function (slot0)
	return
end

return slot0

slot0 = class("GuildShopPage", import(".MilitaryShopPage"))

slot0.getUIName = function (slot0)
	return "GuildShop"
end

slot0.CanOpen = function (slot0)
	return true
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.refreshBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_shop_refresh_all_tip", slot0.shop:GetResetConsume(), i18n("word_guildgold")),
			onYes = function ()
				if slot0.player:getResource(PlayerConst.ResGuildCoin) < slot0.player then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					slot0:emit(NewShopsMediator.REFRESH_GUILD_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)

	slot0.purchaseWindow = GuildShopPurchasePanel.New(slot0._tf, slot0._event)
end

slot0.OnUpdatePlayer = function (slot0)
	slot0.exploitTF.text = slot0.player:getResource(PlayerConst.ResGuildCoin)
end

slot0.OnSetUp = function (slot0)
	slot0.super.OnSetUp(slot0)
	slot0:UpdateRefreshBtn()
end

slot0.UpdateRefreshBtn = function (slot0)
	setButtonEnabled(slot0.refreshBtn, slot0.shop:CanRefresh())
end

slot0.UpdateCard = function (slot0, slot1, slot2)
	slot3 = GuildGoodsCard.New(slot1)

	slot3:update(slot2)

	slot0.cards[slot2.id] = slot3

	onButton(slot0, slot3.itemTF, function ()
		slot0:OnCardClick(slot0)
	end, SFX_PANEL)
end

slot0.OnCardClick = function (slot0, slot1)
	if slot1.goods:Selectable() then
		slot0.purchaseWindow:ExecuteAction("Show", slot1.goods)
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			showOwned = true,
			hideLine = true,
			yesText = "text_exchange",
			content = i18n("guild_shop_exchange_tip"),
			onYes = function ()
				if not slot0.goods:CanPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				slot1:emit(NewShopsMediator.ON_GUILD_SHOPPING, slot0.goods.id, slot0.goods:GetFirstDropId())
			end
		})
	end
end

slot0.OnTimeOut = function (slot0)
	slot0:emit(NewShopsMediator.REFRESH_GUILD_SHOP, false)
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)
	slot0.purchaseWindow:Destroy()
end

return slot0

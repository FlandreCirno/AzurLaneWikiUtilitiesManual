slot0 = class("StreetShopPage", import(".BaseShopPage"))

slot0.getUIName = function (slot0)
	return "StreetShop"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("scrollView/view"), slot0:findTF("tpl"))
	slot0.timerText = slot0:findTF("timer_bg/Text"):GetComponent(typeof(Text))
	slot0.refreshBtn = slot0:findTF("refresh_btn")

	setText(slot0:findTF("tpl/mask/tag/sellout_tag"), i18n("word_sell_out"))

	slot0.actTip = slot0:findTF("tip/tip_activity"):GetComponent(typeof(Text))

	setActive(slot0.actTip, #_.select(slot1, function (slot0)
		if slot0 then
			slot1 = not slot0:isEnd()
		end

		return slot1
	end) > 0)

	slot0.actTip.text = slot0.GenTip(slot0, slot2)
	slot0.helpBtn = slot0:findTF("tip/help")

	setActive(slot0.helpBtn, #slot2 > 1)

	slot0.activitys = slot2
end

slot0.GenTip = function (slot0, slot1)
	slot2 = ""

	if #slot1 == 1 then
		slot2 = i18n("shop_street_activity_tip", slot1[1]:GetShopTime())
	elseif #slot1 > 1 then
		slot2 = slot0:GenTipForMultiAct(slot1)
	end

	return slot2
end

slot0.GenTipForMultiAct = function (slot0, slot1)
	slot3 = slot1[1].getStartTime(slot2)
	slot4 = slot1[1].stopTime
	slot5 = _.all(slot1, function (slot0)
		return slot0:getStartTime() == slot0
	end)
	slot7 = slot2

	if not _.all(slot1, function (slot0)
		return slot0.stopTime == slot0
	end) then
		table.sort(slot1, function (slot0, slot1)
			return slot0.stopTime < slot1.stopTime
		end)

		slot7 = slot1[1]
	elseif not slot5 and slot6 then
		table.sort(slot1, function (slot0, slot1)
			return slot0:getStartTime() < slot1:getStartTime()
		end)

		slot7 = slot1[1]
	end

	return i18n("shop_street_activity_tip", slot7.GetShopTime(slot7))
end

slot0.GenHelpContent = function (slot0, slot1, slot2)
	for slot7, slot8 in ipairs(slot3) do
		table.insert(slot1, i18n("shop_street_Equipment_skin_box_help", pg.item_data_statistics[pg.shop_template[slot8[1]].effect_args[1]].name, slot2:GetShopTime()))
	end
end

slot0.OnInit = function (slot0)
	slot0.resPanel = PlayerResource.New()

	slot0.resPanel:setParent(slot0._tf, false)
	onButton(slot0, slot0.helpBtn, function ()
		table.sort(slot0.activitys, function (slot0, slot1)
			return slot0:getStartTime() < slot1:getStartTime()
		end)
		_.each(slot0.activitys, function (slot0)
			slot0:GenHelpContent(slot0.GenHelpContent, slot0)
		end)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = table.concat(slot0, "\n\n")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.refreshBtn, function ()
		if not ShoppingStreet.getRiseShopId(ShopArgs.ShoppingStreetUpgrade, slot0.shop.flashCount) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			noText = "text_cancel",
			hideNo = false,
			yesText = "text_confirm",
			content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(pg.shop_template[slot0].resource_type) .. "_icon"), pg.shop_template[slot0].resource_num, slot0.shop.flashCount),
			onYes = function ()
				slot0:emit(NewShopsMediator.REFRESH_STREET_SHOP, slot0)
			end
		})
	end, SFX_PANEL)
end

slot0.OnUpdatePlayer = function (slot0)
	slot0.resPanel:setResources(slot0.player)
end

slot0.OnSetUp = function (slot0)
	slot0:InitCommodities(slot1)
	slot0:RemoveTimer()
	slot0:AddTimer(slot0.shop)
end

slot0.OnUpdateAll = function (slot0)
	slot0:OnSetUp()
end

slot0.OnUpdateCommodity = function (slot0, slot1)
	slot0.cards[slot1.id]:update(slot1)
end

slot0.InitCommodities = function (slot0, slot1)
	function slot2(slot0)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			showOwned = true,
			hideLine = true,
			yesText = "text_exchange",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				id = slot0:getConfig("effect_args")[1],
				type = slot0:getConfig("type")
			},
			onYes = function ()
				slot0:Purchase(slot0)
			end
		})
	end

	slot0.cards = {}

	slot0.uilist.make(slot3, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = GoodsCard.New(slot2)

			onButton(slot1, slot4.itemTF, function ()
				slot0(slot1.goodsVO)
			end, SFX_PANEL)
			slot4.update(slot4, slot0[slot1 + 1])

			slot1.cards[slot0[slot1 + 1].id] = slot4
		end
	end)
	slot0.uilist.align(slot3, #slot1)
end

slot0.Purchase = function (slot0, slot1)
	if not slot1:canPurchase() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return
	end

	if slot1:getConfig("resource_type") == 4 or slot2 == 14 then
		slot3 = slot0.player:getResById(slot2)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("charge_scene_buy_confirm", slot1:getConfig("resource_num") * slot1.discount / 100, Item.New({
				id = slot1:getConfig("effect_args")[1]
			}):getConfig("name")),
			onYes = function ()
				slot0:emit(NewShopsMediator.ON_SHOPPING, slot1.id, 1)
			end
		})
	else
		slot0.emit(slot0, NewShopsMediator.ON_SHOPPING, slot1.id, 1)
	end
end

slot0.RemoveTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.AddTimer = function (slot0)
	slot1 = slot0.shop
	slot0.timer = Timer.New(function ()
		if slot0:isUpdateGoods() then
			slot1:RemoveTimer()
			slot1:emit(NewShopsMediator.REFRESH_STREET_SHOP)
		else
			slot1.timerText.text = pg.TimeMgr.GetInstance():DescCDTime(slot0.nextFlashTime - pg.TimeMgr.GetInstance():GetServerTime())
		end
	end, 1, -1)

	slot0.timer.Start(slot2)
	slot0.timer.func()
end

slot0.OnDestroy = function (slot0)
	slot0:RemoveTimer()
	slot0.resPanel:exit()
end

return slot0

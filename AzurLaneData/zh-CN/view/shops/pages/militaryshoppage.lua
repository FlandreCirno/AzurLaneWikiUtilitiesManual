slot0 = class("MilitaryShopPage", import(".BaseShopPage"))

slot0.getUIName = function (slot0)
	return "MilitaryShop"
end

slot0.GetPaintingCommodityUpdateVoice = function (slot0)
	return
end

slot0.CanOpen = function (slot0, slot1, slot2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(slot2.level, "MilitaryExerciseMediator")
end

slot0.OnLoaded = function (slot0)
	slot0.exploitTF = slot0:findTF("res_exploit/bg/Text"):GetComponent(typeof(Text))
	slot0.uilist = UIItemList.New(slot0:findTF("scrollView/view"), slot0:findTF("tpl"))
	slot0.timerTF = slot0:findTF("timer_bg/Text"):GetComponent(typeof(Text))
	slot0.refreshBtn = slot0:findTF("refresh_btn")

	setText(slot0:findTF("tpl/mask/tag/sellout_tag"), i18n("word_sell_out"))
end

slot0.OnInit = function (slot0)
	slot1 = pg.arena_data_shop[1]

	onButton(slot0, slot0.refreshBtn, function ()
		if slot0.shop.refreshCount - 1 >= #slot1.refresh_price then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("refresh_shopStreet_question", i18n("word_gem_icon"), slot1.refresh_price[slot0.shop.refreshCount] or slot1.refresh_price[#slot1.refresh_price], slot1.refresh_price[slot0.shop.refreshCount] or slot1.refresh_price[#slot1.refresh_price].shop.refreshCount - 1),
			onYes = function ()
				if slot0.player:getTotalGem() < slot0.player then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					slot0:emit(NewShopsMediator.REFRESH_MILITARY_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)
end

slot0.OnUpdatePlayer = function (slot0)
	slot0.exploitTF.text = slot0.player.exploit
end

slot0.OnSetUp = function (slot0)
	slot0:InitCommodities()
	slot0:RemoveTimer()
	slot0:AddTimer()
end

slot0.OnUpdateAll = function (slot0)
	slot0:OnSetUp()
end

slot0.OnUpdateCommodity = function (slot0, slot1)
	slot0.cards[slot1.id]:update(slot1)
end

slot0.InitCommodities = function (slot0)
	slot0.cards = {}

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1:UpdateCard(slot2, slot0[slot1 + 1])
		end
	end)
	slot0.uilist.align(slot2, #slot0.shop:GetCommodities())
end

slot0.UpdateCard = function (slot0, slot1, slot2)
	slot3 = GoodsCard.New(slot1)

	slot3:update(slot2)

	slot0.cards[slot2.id] = slot3

	onButton(slot0, slot3.itemTF, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			showOwned = true,
			hideLine = true,
			yesText = "text_exchange",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				id = slot0.goodsVO.getConfig(slot0, "effect_args")[1],
				type = slot0.goodsVO:getConfig("type")
			},
			onYes = function ()
				if not slot0:canPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				slot1:emit(NewShopsMediator.ON_SHOPPING, slot0.id, 1)
			end
		})
	end, SFX_PANEL)
end

slot0.AddTimer = function (slot0)
	slot1 = slot0.shop.nextTime + 1
	slot0.timer = Timer.New(function ()
		if slot0 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			slot1:RemoveTimer()
			slot1.RemoveTimer:OnTimeOut()
		else
			slot1.timerTF.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
		end
	end, 1, -1)

	slot0.timer.Start(slot2)
	slot0.timer.func()
end

slot0.OnTimeOut = function (slot0)
	slot0:emit(NewShopsMediator.REFRESH_MILITARY_SHOP)
end

slot0.RemoveTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.OnDestroy = function (slot0)
	slot0:RemoveTimer()
end

return slot0

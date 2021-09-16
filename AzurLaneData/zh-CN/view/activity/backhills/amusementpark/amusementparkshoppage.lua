slot0 = class("AmusementParkShopPage", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "AmusementParkShopPage"
end

slot0.init = function (slot0)
	slot0.goodsContainer = slot0._tf:Find("Box/Container/Goods")
	slot0.specialsContainer = slot0._tf:Find("Box/Container/SpecialList")
	slot0.specailsDecoration = slot0._tf:Find("Box/Container/Specials")
	slot0.specailsOtherDecoration = slot0._tf:Find("Box/Container/SpecialsOther")

	setActive(slot0.specailsOtherDecoration, false)

	slot0.chat = slot0._tf:Find("Box/Bubble")
	slot0.chatText = slot0.chat:Find("BubbleText")
	slot0.chatClick = slot0._tf:Find("Box/BubbleClick")
	slot0.chatActive = false
	slot0.pollText = {
		i18n("amusementpark_shop_carousel1"),
		i18n("amusementpark_shop_carousel2"),
		i18n("amusementpark_shop_carousel3"),
		i18n("amusementpark_shop_0")
	}
	slot0.pollIndex = math.random(0, math.max(0, #slot0.pollText - 1))
	slot0.msgbox = slot0._tf:Find("Msgbox")

	setActive(slot0.msgbox, false)

	slot0.contentText = slot0.msgbox:Find("window/msg_panel/content"):GetComponent("RichText")
end

slot0.SetShop = function (slot0, slot1)
	slot0.shop = slot1
end

slot0.SetSpecial = function (slot0, slot1)
	slot0.specialLists = slot1
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._tf:Find("Top/Back"), function ()
		slot0:closeView()
	end, SOUND_BACK)
	onButton(slot0, slot0._tf:Find("Top/Help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.amusementpark_shop_help.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.msgbox:Find("BG"), function ()
		setActive(slot0.msgbox, false)
	end)
	onButton(slot0, slot0.msgbox:Find("window/button_container/Button1"), function ()
		setActive(slot0.msgbox, false)
	end, SFX_CANCEL)
	onButton(slot0, slot0.chatClick, function ()
		slot0:SetActiveBubble(not slot0.chatActive)
	end)
	slot0.contentText:AddSprite(pg.item_data_statistics[id2ItemId(slot0.shop.getResId(slot1))] and slot2.icon, LoadSprite(pg.item_data_statistics[id2ItemId(slot0.shop.getResId(slot1))] and slot2.icon, ""))
	slot0:UpdateView()
	slot0:ShowEnterMsg()
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
end

slot0.ShowEnterMsg = function (slot0)
	if _.all(_.values(slot0.shop.goods), function (slot0)
		return not slot0:canPurchase()
	end) then
		slot0.ShowShipWord(slot0, i18n("amusementpark_shop_end"))

		return
	end

	slot0:ShowShipWord(i18n("amusementpark_shop_enter"))
end

slot0.UpdateView = function (slot0)
	setText(slot0._tf:Find("Box/TicketText"), "X" .. (getProxy(PlayerProxy):getRawData()[id2res(slot0.shop:getResId())] or 0))
	slot0:UpdateGoods()
end

slot0.UpdateGoods = function (slot0)
	table.sort(slot1, function (slot0, slot1)
		return slot0.id < slot1.id
	end)
	UIItemList.StaticAlign(slot0.goodsContainer, slot0.goodsContainer.GetChild(slot4, 0), #_.values(slot0.shop.goods), function (slot0, slot1, slot2)
		if slot0 ~= UIItemList.EventUpdate then
			return
		end

		setActive(slot2:Find("mask"), not slot0[slot1 + 1].canPurchase(slot3))
		updateDrop(slot2, slot7)
		setText(slot2:Find("Price"), slot0[slot1 + 1].getConfig(slot3, "resource_num"))
		onButton(slot1, slot2, function ()
			slot0:OnClickCommodity(slot0, function (slot0, slot1)
				slot0:OnPurchase(slot1, slot1)
			end)
		end, SFX_PANEL)
	end)
	setActive(slot0.specailsDecoration, #slot0.specialLists > 0)
	setActive(slot0.specailsOtherDecoration, #slot0.specialLists <= 0)
	UIItemList.StaticAlign(slot0.specialsContainer, slot0.specialsContainer.GetChild(slot4, 0), 3, function (slot0, slot1, slot2)
		if slot0 ~= UIItemList.EventUpdate then
			return
		end

		setActive(slot2, slot0.specialLists[slot1 + 1])

		if not slot0.specialLists[slot1 + 1] then
			return
		end

		setActive(slot2:Find("mask"), slot3.HasGot)
		updateDropCfg(slot3)
		onButton(slot0, slot2, function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
	end)
end

slot0.CheckRes = function (slot0, slot1, slot2)
	if not slot1:canPurchase() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return false
	end

	slot3, slot4 = getPlayerOwn(slot1:getConfig("resource_category"), slot1:getConfig("resource_type"))

	if slot4 < slot1:getConfig("resource_num") * slot2 then
		slot0:ShowMsgbox({
			useGO = true,
			content = i18n("amusementpark_shop_exchange"),
			onYes = function ()
				slot0:emit(AmusementParkShopMediator.GO_SCENE, SCENE.TASK)
			end
		})

		return false
	end

	return true
end

slot0.Purchase = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ShowMsgbox({
		content = i18n("amusementpark_shop_exchange2", slot1:getConfig("resource_num") * slot2, slot1:getConfig("num") * slot2, slot3),
		onYes = function ()
			if slot0:CheckRes(slot0, ) then
				slot3(slot1, slot2)
			end
		end
	})
end

slot0.OnClickCommodity = function (slot0, slot1, slot2)
	if not slot0:CheckRes(slot1, 1) then
		return
	end

	updateDropCfg(slot3)
	slot0:Purchase(slot1, 1, ({
		id = slot1:getConfig("commodity_id"),
		type = slot1:getConfig("commodity_type")
	})["cfg"].name, slot2)
end

slot0.OnPurchase = function (slot0, slot1, slot2)
	slot0:emit(AmusementParkShopMediator.ON_ACT_SHOPPING, slot0.shop.activityId, 1, slot1.id, slot2)
end

slot0.ShowMsgbox = function (slot0, slot1)
	setActive(slot0.msgbox, true)

	slot0.contentText.text = slot1.content

	setActive(slot2, not slot1.useGO)
	setActive(slot0.msgbox:Find("window/button_container/Button3"), slot1.useGO)
	onButton(slot0, (slot1.useGO and slot3) or slot2, function ()
		setActive(slot0.msgbox, false)
		existCall(slot0.msgbox.onYes)
	end, SFX_CONFIRM)
end

slot0.SetActiveBubble = function (slot0, slot1, slot2)
	if slot0.chatActive == tobool(slot1) and not slot2 then
		return
	end

	LeanTween.cancel(go(slot0.chat))

	slot3 = 0.3
	slot0.chatActive = tobool(slot1)

	if slot1 then
		setActive(slot0.chat, true)
		LeanTween.scale(slot0.chat.gameObject, Vector3.New(1, 1, 1), slot3):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack)
	else
		setActive(slot0.chat, true)
		LeanTween.scale(slot0.chat.gameObject, Vector3.New(0, 0, 0), slot3):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function ()
			setActive(slot0.chat, false)
		end))
	end
end

slot0.ShowShipWord = function (slot0, slot1)
	slot0:SetActiveBubble(true, true)
	setText(slot0.chatText, slot1)
	slot0:AddPollingChat()
end

slot0.AddPollingChat = function (slot0)
	slot0:StopPolling()

	slot0.pollTimer = Timer.New(function ()
		slot0:ShowShipWord(slot0)

		slot0.pollText[slot0.pollIndex + 1].pollIndex = (slot0.pollIndex + 1) % #slot0.pollText
	end, 6)

	slot0.pollTimer.Start(slot1)
end

slot0.StopPolling = function (slot0)
	if not slot0.pollTimer then
		return
	end

	slot0.pollTimer:Stop()

	slot0.pollTimer = nil
end

slot0.StopChat = function (slot0)
	if LeanTween.isTweening(go(slot0.chat)) then
		LeanTween.cancel(go(slot0.chat))
	end

	setActive(slot0.chat, false)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
	slot0:StopPolling()
end

slot0.GetActivityShopTip = function ()
	if not getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD) or slot1:isEnd() then
		return
	end

	for slot6, slot7 in ipairs(pg.activity_shop_template.all) do
		if slot1.id == slot2[slot7].activity then
			slot11 = slot2[slot7].num_limit == 0 or ((table.indexof(slot1.data1_list, slot7) and slot1.data2_list[slot8]) or 0) < slot10.num_limit
			slot12, slot13 = getPlayerOwn(slot10.resource_category, slot10.resource_type)
			slot14 = slot10.resource_num <= slot13

			if slot11 and slot14 then
				return true
			end
		end
	end

	return false
end

return slot0

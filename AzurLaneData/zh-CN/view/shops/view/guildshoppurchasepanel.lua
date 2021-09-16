slot0 = class("GuildShopPurchasePanel", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "GuildShopPurchaseMsgUI"
end

slot0.OnLoaded = function (slot0)
	slot0.list = UIItemList.New(slot0:findTF("got/bottom/scroll/list"), slot0:findTF("got/bottom/scroll/list/tpl"))
	slot0.confirmBtn = slot0:findTF("confirm")
	slot0.exchagneCnt = slot0:findTF("got/top/exchange/Text"):GetComponent(typeof(Text))
	slot0.consumeCnt = slot0:findTF("confirm/consume/Text"):GetComponent(typeof(Text))
	slot0.title = slot0:findTF("got/top/title")

	setText(slot0:findTF("got/top/exchange/label"), i18n("guild_shop_label_2"))
	setText(slot0:findTF("confirm/Text"), i18n("guild_shop_label_3"))
	setText(slot0:findTF("confirm/consume/label"), i18n("guild_shop_label_4"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.confirmBtn, function ()
		if #slot0.selectedList == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_must_select_goods"))

			return
		end

		slot0:emit(NewShopsMediator.ON_GUILD_SHOPPING, slot0.goods.id, slot0.selectedList)
		slot0.emit:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.Show = function (slot0, slot1)
	slot0.super.Show(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)

	slot0.goods = slot1
	slot0.maxCnt = slot1:GetMaxCnt()
	slot0.selectedList = {}

	slot0:InitList()
	slot0:UpdateValue()

	if slot1:getConfig("type") == 4 then
		setText(slot0.title, i18n("guild_shop_label_5"))
	else
		setText(slot0.title, i18n("guild_shop_label_1"))
	end
end

slot0.UpdateValue = function (slot0)
	slot0.exchagneCnt.text = ((slot0.maxCnt - #slot0.selectedList > 0 and "<color=#92FC63FF>" .. slot1 .. "</color>/") or "<color=#FF5C5CFF>" .. slot1 .. "</color>/") .. slot0.maxCnt
	slot0.consumeCnt.text = slot0.goods:GetPrice() * #slot0.selectedList
end

slot0.InitList = function (slot0)
	slot0.displays = slot0.goods.getConfig(slot1, "goods")

	slot0.list:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:UpdateItem(slot1, slot0.displays[slot1 + 1], slot2)
		end
	end)
	slot0.list.align(slot2, #slot0.displays)
end

slot0.UpdateItem = function (slot0, slot1, slot2, slot3)
	updateDrop(slot3:Find("item/bg"), {
		count = 1,
		type = slot1:getConfig("type"),
		id = slot2
	})
	updateDropCfg(slot5)
	slot3:Find("name_bg/Text"):GetComponent("ScrollText").SetText(slot6, slot7)

	slot8 = slot3:Find("cnt/Text"):GetComponent(typeof(Text))

	function slot9()
		for slot4, slot5 in ipairs(slot0.selectedList) do
			if slot5 == slot1 then
				slot0 = slot0 + 1
			end
		end

		slot2.text = slot0
	end

	onButton(slot0, slot3, function ()
		slot0.list:each(function (slot0, slot1)
			slot2 = slot0.displays[slot0 + 1]

			if slot1 ~= slot1 and not table.contains(slot0.selectedList, slot2) then
				setActive(slot1:Find("cnt"), false)
				setActive(slot1:Find("selected"), false)
			end
		end)
		setActive(slot0.list.Find(slot1, "cnt"), true)
		setActive(slot0.list.Find(slot1, "cnt"):Find("selected"), true)
	end, SFX_PANEL)
	onButton(slot0, slot3:Find("cnt/minus"), function ()
		if #slot0.selectedList == 0 then
			return
		end

		for slot3, slot4 in ipairs(slot0.selectedList) do
			if slot4 == slot1 then
				table.remove(slot0.selectedList, slot3)

				break
			end
		end

		slot2()
		slot2:UpdateValue()
	end, SFX_PANEL)
	onButton(slot0, slot3:Find("cnt/add"), function ()
		if #slot0.selectedList == slot0.maxCnt then
			return
		end

		table.insert(slot0.selectedList, )
		slot2()
		slot2:UpdateValue()
	end, SFX_PANEL)
	slot9()
end

slot0.Hide = function (slot0)
	if slot0:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	end

	slot0.list:each(function (slot0, slot1)
		setActive(slot1:Find("cnt"), false)
		setActive(slot1:Find("selected"), false)
	end)
	slot0.super.Hide(slot0)
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()
end

return slot0

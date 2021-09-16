slot0 = class("FragmentShopPage", import(".ShamShopPage"))

slot0.getUIName = function (slot0)
	return "FragmentShop"
end

slot0.GetPaintingCommodityUpdateVoice = function (slot0)
	return
end

slot0.CanOpen = function (slot0, slot1, slot2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(slot2.level, "FragmentShop")
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("scrollView/view"), slot0:findTF("tpl"))
	slot0.dayTxt = slot0:findTF("time/day"):GetComponent(typeof(Text))
	slot0.fragment = slot0:findTF("res_fragment/count"):GetComponent(typeof(Text))
	slot0.resolveBtn = slot0:findTF("res_fragment/resolve")
	slot0.urRes = slot0:findTF("res_ur/count"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)
	onButton(slot0, slot0.resolveBtn, function ()
		if not slot0.resolvePanel then
			slot0.resolvePanel = FragResolvePanel.New(slot0)

			slot0.resolvePanel:Load()
		end

		slot0.resolvePanel.buffer:Reset()
		slot0.resolvePanel.buffer.Reset.resolvePanel.buffer:Trigger("control")
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("res_fragment"), function ()
		slot0:emit(BaseUI.ON_ITEM, id2ItemId(PlayerConst.ResBlueprintFragment))
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("res_ur"), function ()
		slot0:emit(BaseUI.ON_ITEM, pg.gameset.urpt_chapter_max.description[1])
	end, SFX_PANEL)
end

slot0.OnUpdatePlayer = function (slot0)
	slot1 = slot0.player
	slot0.fragment.text = slot0.player:getResource(PlayerConst.ResBlueprintFragment)
end

slot0.OnFragmentSellUpdate = function (slot0)
	if slot0.resolvePanel then
		slot0.resolvePanel.buffer:Reset()
		slot0.resolvePanel.buffer:Trigger("control")
	end
end

slot0.OnUpdateItems = function (slot0)
	if not LOCK_UR_SHIP then
		slot0.urRes.text = slot0.items[pg.gameset.urpt_chapter_max.description[1]] or {
			count = 0
		}.count
	else
		setActive(slot0:findTF("res_ur"), false)
		setAnchoredPosition(slot0:findTF("res_fragment"), {
			x = 938.5
		})
	end
end

slot0.OnUpdateCommodity = function (slot0, slot1)
	slot0.cards[slot1.id].goodsVO = slot1

	ActivityGoodsCard.StaticUpdate(slot0.cards[slot1.id].tr, slot1, slot0.TYPE_FRAGMENT)
end

slot0.AddCard = function (slot0, slot1, slot2)
	ActivityGoodsCard.StaticUpdate(slot2, slot1, slot0.TYPE_FRAGMENT)

	return {
		goodsVO = slot1,
		tr = slot2
	}
end

slot0.OnPurchase = function (slot0, slot1, slot2)
	slot0:emit(NewShopsMediator.ON_FRAGMENT_SHOPPING, slot1.id, slot2)
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)

	if slot0.resolvePanel then
		slot0.resolvePanel:Destroy()

		slot0.resolvePanel = nil
	end
end

return slot0

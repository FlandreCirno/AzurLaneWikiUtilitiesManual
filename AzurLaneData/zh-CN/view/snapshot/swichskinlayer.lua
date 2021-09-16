slot0 = class("SwichSkinLayer", import("..base.BaseUI"))

slot0.setShip = function (slot0, slot1)
	slot0.shipVO = slot1
end

slot0.setShipSkin = function (slot0, slot1)
	slot0.shipVO.skinId = slot1
end

slot0.setSkinList = function (slot0, slot1)
	slot0.skinList = slot1
	slot0.skins = slot0:getGroupSkinList(slot0.shipVO.groupId)
	slot0.owns = slot0:getGroupOwnSkins(slot0.shipVO.groupId)
end

slot0.getUIName = function (slot0)
	return "SwichSkinLayer"
end

slot0.back = function (slot0)
	slot0:emit(slot0.ON_CLOSE)
end

slot0.init = function (slot0)
	return
end

slot0.didEnter = function (slot0)
	slot0:initSelectSkinPanel()

	if slot0.shipVO then
		slot0:openSelectSkinPanel()
	end
end

slot0.initSelectSkinPanel = function (slot0)
	slot0.skinPanel = slot0._tf

	onButton(slot0, slot1, function ()
		slot0:back()
	end)
	onButton(slot0, slot2, function ()
		slot0:back()
	end)

	slot0.skinScroll = slot0.findTF(slot0, "select_skin/style_scroll", slot0.skinPanel)
	slot0.skinContainer = slot0:findTF("view_port", slot0.skinScroll)
	slot0.skinCard = slot0._go:GetComponent(typeof(ItemList)).prefabItem[0]

	setActive(slot0.skinCard, false)

	slot0.skinCardMap = {}
end

slot0.openSelectSkinPanel = function (slot0)
	for slot4 = slot0.skinContainer.childCount, #slot0.skins - 1, 1 do
		cloneTplTo(slot0.skinCard, slot0.skinContainer)
	end

	for slot4 = #slot0.skins, slot0.skinContainer.childCount - 1, 1 do
		setActive(slot0.skinContainer:GetChild(slot4), false)
	end

	slot1 = slot0.skinContainer.childCount

	for slot5, slot6 in ipairs(slot0.skins) do
		if not slot0.skinCardMap[slot0.skinContainer:GetChild(slot5 - 1)] then
			slot0.skinCardMap[slot7] = ShipSkinCard.New(slot7.gameObject)
		end

		slot8:updateData(slot0.shipVO, slot6, slot0.shipVO:proposeSkinOwned(slot6) or table.contains(slot0.skinList, slot6.id) or (slot0.shipVO:getRemouldSkinId() == slot6.id and slot0.shipVO:isRemoulded()) or slot6.skin_type == ShipSkin.SKIN_TYPE_OLD)
		slot8:updateSkin(slot6, slot0.shipVO.proposeSkinOwned(slot6) or table.contains(slot0.skinList, slot6.id) or (slot0.shipVO.getRemouldSkinId() == slot6.id and slot0.shipVO.isRemoulded()) or slot6.skin_type == ShipSkin.SKIN_TYPE_OLD)
		slot8:updateUsing(slot0.shipVO.skinId == slot6.id)
		removeOnButton(slot7)

		slot14 = ((slot6.shop_id > 0 and pg.shop_template[slot6.shop_id]) or nil) and not pg.TimeMgr.GetInstance():inTime((slot6.shop_id > 0 and pg.shop_template[slot6.shop_id]) or nil.time)
		slot15 = slot6.id == slot0.shipVO.skinId
		slot16 = slot6.id == slot0.shipVO:getConfig("skin_id") or (((slot0.shipVO:proposeSkinOwned(slot6) or table.contains(slot0.skinList, slot6.id) or (slot0.shipVO:getRemouldSkinId() == slot6.id and slot0.shipVO:isRemoulded())) and 1) or 0) >= 1 or slot6.skin_type == ShipSkin.SKIN_TYPE_OLD
		slot17 = getProxy(ShipSkinProxy):InForbiddenSkinListAndShow(slot6.id)

		onToggle(slot0, slot8.hideObjToggleTF, function (slot0)
			PlayerPrefs.SetInt("paint_hide_other_obj_" .. slot0.paintingName, (slot0 and 1) or 0)
			slot0:flushSkin()
			slot0.flushSkin:emit(SwichSkinMediator.UPDATE_SKINCONFIG, PlayerPrefs.SetInt.shipVO.skinId)
		end, SFX_PANEL)
		onButton(slot0, slot7, function ()
			if slot0 then
				slot1:back()
			elseif slot2 then
				slot1:emit(SwichSkinMediator.CHANGE_SKIN, slot3, (slot3.id ~= slot1.shipVO:getConfig("skin_id") or 0) and slot3.id)
				slot1:back()
			elseif slot4 then
				if slot5 or slot6 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_skin_out_of_stock"))
				else
					slot0 = Goods.Create({
						shop_id = slot4.id
					}, Goods.TYPE_SKIN)
					slot3 = i18n("text_buy_fashion_tip", slot0:GetPrice(), HXSet.hxLan(slot3.name))
					slot4 = slot0:isDisCount() and slot0:IsItemDiscountType()

					if slot4 then
						slot3 = i18n("discount_coupon_tip", slot2, slot0:GetDiscountItem().name, HXSet.hxLan(slot3.name))
					end

					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = slot3,
						onYes = function ()
							if slot0 then
								slot1:emit(SwichSkinMediator.BUY_ITEM_BY_ACT, slot2.id, 1)
							else
								slot1:emit(SwichSkinMediator.BUY_ITEM, slot2.id, 1)
							end
						end
					})
				end
			end
		end)
		setActive(slot7, true)
	end
end

slot0.isCurrentShipExistSkin = function (slot0, slot1)
	if slot1 then
		if #slot0.skins > 1 then
			return true
		elseif #slot0.skins == 1 then
			return false
		end
	end
end

slot0.getGroupSkinList = function (slot0, slot1)
	return getProxy(ShipSkinProxy):GetAllSkinForShip(slot0.shipVO)
end

slot0.getGroupOwnSkins = function (slot0, slot1)
	slot2 = {}
	slot3 = slot0.skinList

	if getProxy(CollectionProxy):getShipGroup(slot1) then
		for slot9, slot10 in ipairs(slot5) do
			if slot10.skin_type == ShipSkin.SKIN_TYPE_DEFAULT or table.contains(slot3, slot10.id) or (slot10.skin_type == ShipSkin.SKIN_TYPE_REMAKE and slot4.trans) or (slot10.skin_type == ShipSkin.SKIN_TYPE_PROPOSE and slot4.married == 1) then
				slot2[slot10.id] = true
			end
		end
	end

	return slot2
end

slot0.willExit = function (slot0)
	for slot4, slot5 in pairs(slot0.skinCardMap) do
		slot5:clear()
	end
end

return slot0

slot0 = class("AssignedItemView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "StoreHouseItemAssignedView"
end

slot0.OnInit = function (slot0)
	slot0:InitData()
	slot0:InitUI()
	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.InitData = function (slot0)
	slot0.selectedVO = nil
	slot0.count = 1
end

slot0.InitUI = function (slot0)
	slot0.ulist = UIItemList.New(slot0:findTF("got/bottom/scroll/list"), slot0:findTF("got/bottom/scroll/list/tpl"))
	slot0.confirmBtn = slot0:findTF("calc/confirm")
	slot0.rightArr = slot0:findTF("calc/value_bg/add")
	slot0.leftArr = slot0:findTF("calc/value_bg/mius")
	slot0.maxBtn = slot0:findTF("calc/max")
	slot0.valueText = slot0:findTF("calc/value_bg/Text")
	slot0.itemTF = slot0:findTF("item/bottom/item")
	slot0.nameTF = slot0:findTF("item/bottom/name_bg/name")
	slot0.descTF = slot0:findTF("item/bottom/desc_con/desc")

	onButton(slot0, slot0._tf, function ()
		slot0:Destroy()
	end, SFX_PANEL)
	onButton(slot0, slot0.rightArr, function ()
		if not slot0.itemVO then
			return
		end

		slot0.count = math.min(slot0.count + 1, slot0.itemVO.count)

		slot0:updateValue()
	end, SFX_PANEL)
	onButton(slot0, slot0.leftArr, function ()
		if not slot0.itemVO then
			return
		end

		slot0.count = math.max(slot0.count - 1, 1)

		slot0:updateValue()
	end, SFX_PANEL)
	onButton(slot0, slot0.maxBtn, function ()
		if not slot0.itemVO then
			return
		end

		slot0.count = slot0.itemVO.count

		slot0:updateValue()
	end, SFX_PANEL)
	onButton(slot0, slot0.confirmBtn, function ()
		if not slot0.selectedVO or not slot0.itemVO or slot0.count <= 0 then
			return
		end

		slot0:emit(EquipmentMediator.ON_USE_ITEM, slot0.itemVO.id, slot0.count, slot0.selectedVO)
		slot0.emit:Destroy()
	end, SFX_PANEL)
end

slot0.updateValue = function (slot0)
	setText(slot0.valueText, slot0.count)

	slot1 = slot0.itemVO:getConfig("display_icon")

	slot0.ulist:each(function (slot0, slot1)
		setText(slot1:Find("item/bg/icon_bg/count"), slot1.count * slot0[slot0 + 1][3])
	end)
end

slot0.OnDestroy = function (slot0)
	slot0.selectedVO = nil
	slot0.itemVO = nil
	slot0.count = 1

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)

	if slot0.selectedItem then
		triggerToggle(slot0.selectedItem, false)
	end

	slot0.selectedItem = nil
end

slot0.update = function (slot0, slot1)
	slot0.itemVO = slot1
	slot0.selectedItem = nil

	slot0.ulist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2:Find("item/bg"), slot4)

			slot5 = slot2:Find("item/bg/icon_bg/count")

			onToggle(slot1, slot2, function (slot0)
				if slot0 then
					slot0.selectedVO = slot1:getTempCfgTable().usage_arg[slot2 + 1]

					setText(slot2 + 1, slot0.count * slot4[3])

					slot0.selectedItem = slot5
				end
			end, SFX_PANEL)
			setScrollText(slot2.Find(slot2, "name_bg/Text"), HXSet.hxLan(({
				type = slot0[slot1 + 1][1],
				id = slot0[slot1 + 1][2],
				count = slot0[slot1 + 1][3]
			})["cfg"].name))
		end
	end)
	slot0.ulist.align(slot3, #slot1:getConfig("display_icon"))
	slot0:updateValue()
	updateDrop(slot0.itemTF:Find("bg"), {
		type = DROP_TYPE_ITEM,
		id = slot1.id,
		count = slot1.count
	})
	setText(slot0.nameTF, slot1:getConfig("name"))
	setText(slot0.descTF, slot1:getConfig("display"))
end

return slot0

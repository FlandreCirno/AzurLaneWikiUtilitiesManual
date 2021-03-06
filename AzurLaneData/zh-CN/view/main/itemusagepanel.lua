slot0 = class("ItemUsagePanel")
slot0.SINGLE = 1
slot0.BATCH = 2
slot0.INFO = 3
slot0.SEE = 4

slot0.Ctor = function (slot0, slot1, slot2)
	pg.DelegateInfo.New(slot0)

	slot0._go = slot1

	setActive(slot0._go, false)

	slot0._parent = slot2
	slot0.backBtn = findTF(slot0._go, "window/top/btnBack")
	slot0.itemTF = findTF(slot0._go, "window/panel/item")
	slot0.itemIntro = findTF(slot0.itemTF, "display_panel/desc/Text")
	slot0.itemName = findTF(slot0.itemTF, "display_panel/name_container/name")
	slot0.resetBtn = findTF(slot0.itemTF, "reset_btn")
	slot0.useBtn = findTF(slot0._go, "window/panel/actions/use_one_button")

	setActive(slot0.useBtn, false)

	slot0.batchUseBtn = findTF(slot0._go, "window/panel/actions/batch_use_button")

	setActive(slot0.batchUseBtn, false)

	slot0.useOneBtn = findTF(slot0._go, "window/panel/actions/use_button")

	setActive(slot0.useOneBtn, false)

	slot0.confirmBtn = findTF(slot0._go, "window/panel/actions/confirm_button")

	setActive(slot0.confirmBtn, false)

	slot0.seeBtn = findTF(slot0._go, "window/panel/actions/see_button")

	setActive(slot0.seeBtn, false)

	slot0.batchText = slot0.batchUseBtn:Find("text")

	onButton(slot0, slot0.backBtn, function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, findTF(slot0._go, "bg"), function ()
		slot0:Close()
	end, SFX_PANEL)
end

slot0.Open = function (slot0, slot1)
	slot0.settings = slot1 or {}

	slot0:Update(slot1 or )
	slot0:UpdateAction(slot1 or )
	setActive(slot0.resetBtn, true)
	setActive(slot0._go, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._go)
end

slot0.Close = function (slot0)
	slot0.settings = nil

	setActive(slot0._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._go, slot0._parent)
end

slot0.Update = function (slot0, slot1)
	updateDrop(slot0.itemTF, {
		type = DROP_TYPE_WORLD_ITEM,
		id = slot1.id,
		count = slot1.count
	})
	setText(slot0.itemIntro, HXSet.hxLan(slot1:getConfig("display")))
	setText(slot0.itemName, HXSet.hxLan(slot1:getConfig("name")))
	onButton(slot0, slot0.resetBtn, function ()
		slot0.settings.onResetInfo({
			count = 1,
			type = DROP_TYPE_WORLD_ITEM,
			id = slot1.id
		})
	end, SFX_PANEL)
end

slot0.UpdateAction = function (slot0, slot1)
	slot2 = slot0.settings

	setActive(slot0.useBtn, (slot0.settings.mode or slot0.SINGLE) == slot0.SINGLE)
	setActive(slot0.batchUseBtn, (slot0.settings.mode or slot0.SINGLE) == slot0.BATCH)
	setActive(slot0.useOneBtn, (slot0.settings.mode or slot0.SINGLE) == slot0.BATCH)
	setActive(slot0.confirmBtn, (slot0.settings.mode or slot0.SINGLE) == slot0.INFO)
	setActive(slot0.seeBtn, (slot0.settings.mode or slot0.SINGLE) == slot0.SEE)

	if slot3 == slot0.SINGLE then
		onButton(slot0, slot0.useBtn, function ()
			if slot0.count == 0 then
				return
			end

			if slot1.onUse then
				slot1.onUse()
			end

			slot2:Close()
		end, SFX_PANEL)
	else
		if slot3 == slot0.BATCH then
			setText(slot0.batchText, slot4)
			onButton(slot0, slot0.batchUseBtn, function ()
				if slot0.count == 0 then
					return
				end

				if slot1.onUseBatch then
					slot1.onUseBatch(slot2)
				end

				slot3:Close()
			end, SFX_PANEL)
			onButton(slot0, slot0.useOneBtn, function ()
				if slot0.count == 0 then
					return
				end

				if slot1.onUseOne then
					slot1.onUseOne()
				end

				slot2:Close()
			end, SFX_PANEL)
			setActive(slot0.batchUseBtn, math.min(slot1.count, 10) > 1)

			return
		end

		if slot3 == slot0.INFO then
			onButton(slot0, slot0.confirmBtn, function ()
				slot0:Close()
			end, SFX_PANEL)
		elseif slot3 == slot0.SEE then
			onButton(slot0, slot0.seeBtn, function ()
				if slot0.count == 0 then
					return
				end

				if slot1.onUse then
					slot1.onUse()
				end

				slot2:Close()
			end, SFX_PANEL)
		end
	end
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
	slot0:Close()
end

return slot0

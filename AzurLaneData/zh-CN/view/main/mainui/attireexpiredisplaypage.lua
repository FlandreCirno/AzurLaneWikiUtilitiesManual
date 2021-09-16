slot0 = class("AttireExpireDisplayPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "AttireOverDueUI"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("window/sliders/scrollrect/content"), slot0:findTF("window/sliders/scrollrect/content/tpl"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0:findTF("window/confirm_btn"), function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("window/top/btnBack"), function ()
		slot0:Hide()
	end, SFX_CANCEL)
end

slot0.Show = function (slot0, slot1)
	slot0.super.Show(slot0)
	slot0:Display(slot1)
end

slot0.Display = function (slot0, slot1)
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, {
				count = 1,
				id = slot0[slot1 + 1].getConfig(slot3, "id"),
				type = slot0[slot1 + 1]:getDropType()
			})
		end
	end)
	slot0.uilist.align(slot2, #slot1)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

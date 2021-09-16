slot0 = class("SkinExpireDisplayPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "SkinOverDueUI"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("window/list/scrollrect/content"), slot0:findTF("window/list/scrollrect/content/tpl"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0:findTF("window/button_container/confirm_btn"), function ()
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
			setText(slot2:Find("name/Text"), slot0[slot1 + 1].getConfig(slot3, "name"))

			slot4 = slot2:Find("icon_bg/icon")

			LoadSpriteAsync("qicon/" .. slot0[slot1 + 1]:getIcon(), function (slot0)
				if not IsNil(slot0._tf) then
					slot1:GetComponent(typeof(Image)).sprite = slot0
				end
			end)
		end
	end)
	slot0.uilist.align(slot2, #slot1)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

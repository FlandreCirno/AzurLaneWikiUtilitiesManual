slot0 = class("SkinExperienceDiplayPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "ExSkinListUI"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("window/list/content"), slot0:findTF("window/list/content/tpl"))
	slot0.skinTimers = {}
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0:findTF("window/top/btnBack"), function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("window/button_container/confirm_btn"), function ()
		slot0:Hide()
	end, SFX_CANCEL)
end

slot0.Show = function (slot0, slot1)
	slot0.super.Show(slot0)
	slot0:Display(slot1)
end

slot0.Display = function (slot0, slot1)
	slot0:Clear()
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("name/Text"), HXSet.hxLan(slot0[slot1 + 1]:getConfig("name")))

			if slot1.skinTimers[slot0[slot1 + 1].id] then
				slot1.skinTimers[slot3.id]:Stop()
			end

			slot1.skinTimers[slot3.id] = Timer.New(function ()
				setText(slot1:Find("time/Text"), skinTimeStamp(slot0:getRemainTime()))
			end, 1, -1)

			slot1.skinTimers[slot3.id].Start(slot4)
			slot1.skinTimers[slot3.id].func()

			slot4 = slot2:Find("icon_bg/icon")

			LoadSpriteAsync("qicon/" .. slot3:getIcon(), function (slot0)
				if not IsNil(slot0._tf) then
					slot1:GetComponent(typeof(Image)).sprite = slot0
				end
			end)
		end
	end)
	slot0.uilist.align(slot2, #slot1)
end

slot0.Clear = function (slot0)
	for slot4, slot5 in pairs(slot0.skinTimers) do
		slot5:Stop()
	end

	slot0.skinTimers = {}
end

slot0.OnDestroy = function (slot0)
	slot0:Clear()

	slot0.skinTimers = nil
end

return slot0

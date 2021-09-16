slot0 = class("TaskPtAwardWindow", import("..activity.Panels.PtAwardWindow"))

slot0.UpdateList = function (slot0, slot1, slot2, slot3)
	slot0.UIlist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1:UpdateDrop(slot2:Find("award"), slot0[slot1 + 1][1])
			slot1:UpdateDrop(slot2:Find("award1"), slot0[slot1 + 1][2])
			setText(slot2:Find("title/Text"), "PHASE " .. slot1 + 1)
			setText(slot2:Find("target/Text"), slot4)
			setText(slot2:Find("target/title"), HXSet.hxLan(slot1.resTitle))
			setActive(slot2:Find("award/mask"), slot1 + 1 <= slot0[slot1 + 1])
			setActive(slot2:Find("award1/mask"), slot1 + 1 <= slot3)

			if slot2:Find("target/icon") and slot1.resIcon and slot1.resIcon ~= "" then
				setActive(slot2:Find("target/icon"), true)
				LoadImageSpriteAsync(slot1.resIcon, slot2:Find("target/icon/image"), false)
			else
				setActive(slot2:Find("target/icon"), false)
			end
		end
	end)
	slot0.UIlist.align(slot4, #slot1)
end

slot0.UpdateDrop = function (slot0, slot1, slot2)
	if slot2 then
		setActive(slot1, true)
		updateDrop(slot1, slot3, {
			hideName = true
		})
		onButton(slot0.binder, slot1, function ()
			slot0.binder:emit(BaseUI.ON_DROP, slot0.binder)
		end, SFX_PANEL)

		return
	end

	setActive(slot1, false)
end

return slot0

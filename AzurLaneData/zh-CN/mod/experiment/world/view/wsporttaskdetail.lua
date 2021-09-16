slot0 = class("WSPortTaskDetail", import("...BaseEntity"))
slot0.Fields = {
	task = "table",
	onCancel = "function",
	transform = "userdata"
}

slot0.Setup = function (slot0)
	pg.DelegateInfo.New(slot0)
	slot0:Init()
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
	slot0:Clear()
end

slot0.Init = function (slot0)
	onButton(slot0, slot1, function ()
		slot0.onCancel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.transform.Find(slot1, "top/btnBack"), function ()
		slot0.onCancel()
	end, SFX_CANCEL)
end

slot0.UpdateTask = function (slot0, slot1)
	slot0.task = slot1

	setText(slot0.transform.Find(slot2, "window/desc"), slot1.config.description)

	slot6 = UIItemList.New(slot4, slot5)

	slot6:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, slot3)
			setScrollText(slot2:Find("name_mask/name"), slot0[slot1 + 1].cfg.name)
		end
	end)
	slot6.align(slot6, #slot1:GetDisplayDrops())
end

return slot0

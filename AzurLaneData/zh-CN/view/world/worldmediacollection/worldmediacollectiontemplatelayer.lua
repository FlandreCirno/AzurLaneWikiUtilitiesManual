slot0 = class("WorldMediaCollectionTemplateLayer", import("view.base.BaseSubView"))

slot0.getUIName = function (slot0)
	return
end

slot0.Ctor = function (slot0, slot1, ...)
	slot0.super.Ctor(slot0, ...)

	slot0.viewParent = slot1
	slot0.buffer = setmetatable({}, {
		__index = function (slot0, slot1)
			return function (slot0, ...)
				slot0:ActionInvoke(slot0.ActionInvoke, ...)
			end
		end,
		__newindex = function ()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)

	if slot0._top then
		setActive(slot0._top, true)
	end
end

slot0.Hide = function (slot0)
	if slot0._top then
		setActive(slot0._top, false)
	end

	slot0.super.Hide(slot0)
end

slot0.OnSelected = function (slot0)
	slot0:Show()

	if slot0._top then
		slot0.viewParent:Add2TopContainer(slot0._top)
	end
end

slot0.OnReselected = function (slot0)
	return
end

slot0.OnDeselected = function (slot0)
	if slot0._top then
		setParent(slot0._top, slot0._tf)
	end

	slot0:Hide()
end

slot0.OnBackward = function (slot0)
	return
end

slot0.Add2LayerContainer = function (slot0, slot1)
	setParent(slot1, slot0._tf)
end

slot0.Add2TopContainer = function (slot0, slot1)
	setParent(slot1, slot0._top)
end

slot0.SetActive = function (slot0, slot1)
	if slot1 then
		slot0:Show()
	else
		slot0:Hide()
	end
end

slot0.UpdateView = function (slot0)
	return
end

return slot0

slot0 = class("MapBuilder", import("view.base.basesubview"))
slot0.TYPENORMAL = 1
slot0.TYPEESCORT = 2
slot0.TYPESHINANO = 3
slot0.TYPESKIRMISH = 4

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2.event, slot2.contextData)

	slot0.sceneParent = slot2
	slot0.map = slot1:Find("maps")
	slot0.float = slot1:Find("float")
	slot0.tweens = {}
	slot0.mapWidth = 1920
	slot0.mapHeight = 1440
	slot0.buffer = setmetatable({}, {
		__index = function (slot0, slot1)
			return function (slot0, ...)
				if slot0 == "UpdateMapItems" and underscore.any(slot1._funcQueue, function (slot0)
					return slot0.funcName == slot0
				end) then
					return
				end

				slot1.ActionInvoke(slot1, slot0, ...)
			end
		end,
		__newindex = function ()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
end

slot0.DoFunction = function (slot0, slot1)
	slot1()
end

slot0.InvokeParent = function (slot0, slot1, ...)
	if slot0.sceneParent[slot1] then
		return slot2(slot0.sceneParent, ...)
	end
end

slot0.GetType = function (slot0)
	return
end

slot0.OnLoaded = function (slot0)
	slot0._tf:SetParent(slot0.float, false)
end

slot0.Destroy = function (slot0)
	if slot0._state == slot0.STATES.INITED then
		slot0:Hide()
	end

	slot0.super.Destroy(slot0, go)
end

slot0.OnDestroy = function (slot0)
	slot0.tweens = nil
end

slot0.Show = function (slot0)
	setActive(slot0._tf, true)
	slot0:OnShow()
end

slot0.Hide = function (slot0)
	slot0:OnHide()
	setActive(slot0._tf, false)
end

slot0.OnShow = function (slot0)
	return
end

slot0.OnHide = function (slot0)
	for slot4, slot5 in pairs(slot0.tweens) do
		LeanTween.cancel(slot5)
	end

	slot0.tweens = {}
end

slot0.Update = function (slot0, slot1)
	slot0.data = slot1
end

slot0.UpdateButtons = function (slot0)
	return
end

slot0.PostUpdateMap = function (slot0, slot1)
	return
end

slot0.UpdateMapItems = function (slot0)
	return
end

slot0.RecordTween = function (slot0, slot1, slot2)
	slot0.tweens[slot1] = slot2
end

slot0.DeleteTween = function (slot0, slot1)
	if slot0.tweens[slot1] then
		LeanTween.cancel(slot2)

		slot0.tweens[slot1] = nil
	end
end

return slot0

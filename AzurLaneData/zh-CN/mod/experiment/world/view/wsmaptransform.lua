slot0 = class("WSMapTransform", import(".WSMapObject"))
slot0.Fields = {
	transform = "userdata",
	isMoving = "boolean",
	modelOrder = "number"
}

slot0.Dispose = function (slot0)
	slot0:ClearModelOrder()
	slot0:Clear()
end

slot0.SetModelOrder = function (slot0, slot1, slot2)
	if not GetComponent(slot0.transform, typeof(Canvas)) then
		setCanvasOverrideSorting(slot0.transform, true)
	end

	slot3 = 0

	if slot0.modelOrder then
		slot3 = slot3 - slot0.modelOrder
	end

	slot0.modelOrder = slot1 + defaultValue(slot2, 0) * 10

	if slot3 + slot0.modelOrder ~= 0 then
		WorldConst.ArrayEffectOrder(slot0.transform, slot3)
	end
end

slot0.ClearModelOrder = function (slot0)
	slot0:UnloadModel()

	if slot0.modelOrder then
		WorldConst.ArrayEffectOrder(slot0.transform, -slot0.modelOrder)

		slot0.modelOrder = nil
	end
end

slot0.LoadModel = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.super.LoadModel(slot0, slot1, slot2, slot3, slot4, function ()
		if slot0.modelOrder then
			WorldConst.ArrayEffectOrder(slot0.model, slot0.modelOrder)
		end

		return existCall(slot1)
	end)
end

slot0.UnloadModel = function (slot0)
	if slot0.modelOrder and slot0.model then
		WorldConst.ArrayEffectOrder(slot0.model, -slot0.modelOrder)
	end

	slot0.super.UnloadModel(slot0)
end

return slot0

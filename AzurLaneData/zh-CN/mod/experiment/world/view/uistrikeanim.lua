slot0 = class("UIStrikeAnim", import(".UIAnim"))
slot0.Fields = {
	spineAnim = "userdata",
	prefab = "string",
	aniEvent = "userdata",
	char = "userdata",
	transform = "userdata",
	playing = "boolean",
	onTrigger = "function",
	onStart = "function",
	onEnd = "function",
	skelegraph = "userdata",
	painting = "userdata",
	shipVO = "table"
}
slot0.EventLoaded = "UIStrikeAnim.EventLoaded"

slot0.Setup = function (slot0, slot1, slot2)
	slot0.prefab = slot1
	slot0.shipVO = slot2
end

slot0.LoadBack = function (slot0)
	if slot0.transform and slot0.painting and slot0.char then
		slot0:Init()
		slot0:DispatchEvent(slot0.EventLoaded)
	end
end

slot0.Load = function (slot0)
	PoolMgr.GetInstance().GetUI(slot2, slot1, true, function (slot0)
		if slot0 == slot1.prefab then
			slot1.transform = slot0.transform

			slot1:LoadBack()
		else
			slot2:ReturnUI(slot0, slot0)
		end
	end)
	slot0.ReloadShip(slot0, slot0.shipVO)
end

slot0.ReloadShip = function (slot0, slot1)
	slot0.shipVO = slot1
	slot0.aniEvent = nil
	slot0.painting = nil
	slot0.char = nil

	PoolMgr.GetInstance().GetInstance():GetPainting(slot1:getPainting(), true, function (slot0)
		slot0.painting = slot0

		ShipExpressionHelper.SetExpression(slot0.painting, slot1:getPainting())
		slot0:LoadBack()
	end)
	PoolMgr.GetInstance().GetInstance().GetSpineChar(slot3, slot1:getPrefab(), true, function (slot0)
		slot0.char = slot0
		slot0.char.transform.localScale = Vector3.one

		slot0:LoadBack()
	end)
end

slot0.UnloadShipVO = function (slot0)
	retPaintingPrefab(slot0.transform:Find("mask/painting"), slot0.shipVO.getPainting(slot1))
	PoolMgr.GetInstance():ReturnSpineChar(slot0.shipVO.getPrefab(slot1), slot0.char)

	slot0.shipVO = nil
	slot0.painting = nil
	slot0.char = nil
end

slot0.Play = function (slot0, slot1)
	slot0.playing = true

	slot0.onStart = function (slot0)
		slot0.spineAnim:SetAction("attack", 0)

		slot0.skelegraph.freeze = true
	end

	slot0.onTrigger = function (slot0)
		slot0.skelegraph.freeze = false

		slot0.spineAnim:SetActionCallBack(function (slot0)
			if slot0 == "action" then
			elseif slot0 == "finish" then
				slot0.skelegraph.freeze = true
			end
		end)
	end

	slot0.onEnd = slot1

	slot0.Update(slot0)
end

slot0.Stop = function (slot0)
	slot0.playing = false

	slot0:Update()

	if slot0.skelegraph then
		slot0.skelegraph.freeze = false
	end

	slot0:UnloadShipVO()
end

slot0.Init = function (slot0)
	setActive(slot0.transform, false)
	setParent(slot0.painting, slot0.transform:Find("mask/painting").Find(slot2, "fitter"), false)
	setParent(slot0.char, slot3, false)
	setActive(slot3, false)
	setActive(slot1, false)

	slot0.spineAnim = slot0.char:GetComponent("SpineAnimUI")
	slot0.skelegraph = slot0.spineAnim:GetComponent("SkeletonGraphic")
	slot0.aniEvent = slot0.transform:GetComponent("DftAniEvent")

	slot0:Update()
end

return slot0

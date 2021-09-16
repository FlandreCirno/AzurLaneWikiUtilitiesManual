slot0 = class("StaticCellView", import("view.level.cell.LevelCellView"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0)

	slot0.parent = slot1
	slot0.go = nil
	slot0.tf = nil
	slot0.info = nil
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityNone
end

slot0.SetTpl = function (slot0, slot1)
	slot0._tpl = slot1
end

slot0.UpdateGO = function (slot0)
	if slot0._tpl and slot0._currentTpl ~= slot1 then
		slot0:DestroyGO()

		slot0.go = Instantiate(slot1)

		setParent(slot0.go, slot0.parent)

		slot0.tf = slot0.go.transform
		slot0._currentTpl = slot1

		slot0:OverrideCanvas()
	end
end

slot0.PrepareBase = function (slot0, slot1)
	slot0.go = GameObject.New(slot1)

	slot0.go:AddComponent(typeof(RectTransform))
	setParent(slot0.go, slot0.parent)

	slot0.tf = tf(slot0.go)
	slot0.tf.sizeDelta = slot0.parent.sizeDelta

	slot0:OverrideCanvas()
	slot0:ResetCanvasOrder()
end

slot0.SetActive = function (slot0, slot1)
	setActive(slot0.go, slot1)
end

slot0.DestroyGO = function (slot0)
	if slot0.loader then
		slot0.loader:ClearRequests()
	end

	if not IsNil(slot0.go) then
		Destroy(slot0.go)

		slot0.go = nil
		slot0.tf = nil
	end
end

slot0.Clear = function (slot0)
	slot0.parent = nil
	slot0._tpl = nil
	slot0._currentTpl = nil
	slot0.info = nil

	slot0:DestroyGO()
end

return slot0

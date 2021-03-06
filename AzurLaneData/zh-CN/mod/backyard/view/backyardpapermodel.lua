slot0 = class("BackYardPaperModel")
slot1 = require("Mod/BackYard/view/BackYardTool")
slot0.PAPER_TYPE_WALL = 1
slot0.PAPER_TYPE_FLOOR = 2
slot0.PAPER_TYPE_BASEWALL = 3

slot0.getFloorScale = function (slot0)
	if not slot0.sizes then
		slot0.sizes = {
			0.5,
			0.67,
			0.83,
			1
		}
	end

	return slot0.sizes[slot0]
end

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.type = slot2
	slot0._tf = slot1
	slot0.img = slot0._tf:GetComponent(typeof(Image))

	setActive(slot0.img, false)

	slot0.parent = slot0._tf.parent
	slot0.spineModel = nil
end

slot0.update = function (slot0, slot1, slot2)
	slot0:clear()

	slot0.level = slot2

	if slot1 then
		if slot0.type == slot0.PAPER_TYPE_BASEWALL then
			slot0:loadImage("base/wall_")
		else
			slot0.isSpine = slot1:isSpine()

			if slot0.isSpine then
				slot7, slot8 = slot1:getSpineName()

				slot0:loadSpine(slot3, slot4)
			else
				slot0:loadImage(slot1:getConfig("picture"))
			end
		end
	elseif slot0.type == slot0.PAPER_TYPE_WALL then
		slot0:loadImage("base/wall_")
	elseif slot0.type == slot0.PAPER_TYPE_FLOOR then
		slot0:loadImage("base/floor_4")
	elseif slot0.type == slot0.PAPER_TYPE_BASEWALL then
		setActive(slot0._tf, false)
	end
end

slot0.loadSpine = function (slot0, slot1, slot2)
	setActive(slot0.img, false)

	slot3 = nil

	if slot0.type == slot0.PAPER_TYPE_WALL then
		slot1 = slot1 .. slot0.level

		function slot3(slot0)
			rtf(slot0).anchoredPosition3D = Vector3(0, -10, 0)

			tf(slot0):SetSiblingIndex(2)
		end
	elseif slot0.type == slot0.PAPER_TYPE_FLOOR then
		function slot3(slot0)
			slot1 = slot0.getFloorScale(slot1.level)
			rtf(slot0).localScale = Vector3(slot1, slot1, slot1)
			rtf(slot0).anchoredPosition3D = Vector3(0, -280, 0)

			tf(slot0):SetSiblingIndex(3)
		end
	end

	pg.UIMgr.GetInstance().LoadingOn(slot4)
	LoadAndInstantiateAsync("sfurniture", slot1, function (slot0)
		slot0.spineModel = slot0
		rtf(slot0).anchorMin = Vector2(0.5, 1)
		rtf(slot0).anchorMax = Vector2(0.5, 1)
		rtf(slot0).pivot = Vector2(0.5, 1)
		rtf(slot0).localScale = Vector3(1, 1, 1)

		SetParent(slot0, slot0.parent)
		SetParent(slot0)

		if slot0 then
			slot2 = GetOrAddComponent(slot1, typeof(SpineAnimUI))

			slot2:SetAction(slot2, 0)
		end

		pg.UIMgr.GetInstance():LoadingOff()
	end)
end

slot0.loadImage = function (slot0, slot1)
	if slot0.type == slot0.PAPER_TYPE_FLOOR then
		slot0.img.sprite = GetSpriteFromAtlas("furniture/" .. slot1, "")
		rtf(go(slot0.img)).sizeDelta = Vector2(1877, 934)
		slot2 = slot0.getFloorScale(slot0.level)
		slot0._tf.localScale = Vector3(slot2, slot2, slot2)
	elseif slot0.type == slot0.PAPER_TYPE_WALL or slot0.type == slot0.PAPER_TYPE_BASEWALL then
		slot0.img.sprite = GetSpriteFromAtlas("furniture/" .. slot1, "")

		slot0.img:SetNativeSize()
	end

	setActive(slot0._tf, true)
end

slot0.clear = function (slot0)
	if slot0.isSpine and slot0.spineModel then
		Destroy(slot0.spineModel)

		slot0.spineModel = nil
		slot0.isSpine = nil
	else
		setActive(slot0._tf, false)
	end
end

slot0.dispose = function (slot0)
	slot0:clear()
	UIUtil.ClearImageSprite(go(slot0._tf))
end

return slot0

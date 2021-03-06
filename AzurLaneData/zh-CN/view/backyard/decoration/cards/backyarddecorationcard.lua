slot0 = class("BackYardDecorationCard")

slot0.Ctor = function (slot0, slot1)
	slot0._go = slot1
	slot0._tf = tf(slot1)
	slot0._bg = findTF(slot0._tf, "bg")
	slot0.maskTF = findTF(slot0._tf, "bg/mask")
	slot0.iconImg = findTF(slot0._tf, "bg/icon"):GetComponent(typeof(Image))
	slot0.comfortableTF = findTF(slot0._tf, "bg/comfortable/Text")
	slot0.newTF = findTF(slot0._tf, "bg/new_bg")
	slot0.countTxt = findTF(slot0._tf, "bg/count")
end

slot0.Update = function (slot0, slot1, slot2)
	slot0.furniture = slot1
	slot0.iconImg.sprite = LoadSprite("furnitureicon/" .. slot1:getConfig("icon"))

	setText(slot0.comfortableTF, shortenString(slot1:getConfig("name"), 4))

	slot3 = slot1:getConfig("count")
	slot0.showMask = slot1:GetOwnCnt() <= slot2

	SetActive(slot0.maskTF, slot0.showMask)

	if slot3 > 1 then
		setText(slot0.countTxt, slot2 .. "/" .. slot4)
		SetActive(slot0.maskTF, slot2 == slot4)
	else
		setText(slot0.countTxt, "")
	end

	SetActive(slot0.newTF, slot1.isNew)
end

slot0.Flush = function (slot0, slot1, slot2)
	if slot1.id == slot0.furniture.id then
		slot0:Update(slot1, slot2)
	else
		slot0:Update(slot0.furniture, slot2)
	end
end

slot0.HasMask = function (slot0)
	return slot0.showMask
end

return slot0

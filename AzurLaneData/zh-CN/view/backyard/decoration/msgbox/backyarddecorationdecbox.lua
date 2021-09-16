slot0 = class("BackYardDecorationDecBox", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "BackYardDecorationDescUI"
end

slot0.OnLoaded = function (slot0)
	slot0.nameTxt = slot0:findTF("name_bg/Text"):GetComponent(typeof(Text))
	slot0.descTxt = slot0:findTF("Text"):GetComponent(typeof(Text))
	slot0.icon = slot0:findTF("icon_bg/Image"):GetComponent(typeof(Image))
	slot0.width = slot0._tf.rect.width
	slot0.prantLeftBound = slot0._tf.parent.rect.width / 2
end

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	if slot0.furniture ~= slot1 then
		slot0.nameTxt.text = slot1:getConfig("name")
		slot0.descTxt.text = shortenString(slot1:getConfig("describe"), 35)
		slot0.icon.sprite = LoadSprite("furnitureicon/" .. slot1:getConfig("icon"))
	end

	slot0._tf.position = slot2

	if slot3 then
		slot0._tf.localPosition = Vector3(slot0._tf.localPosition.x, slot0._tf.localPosition.y - slot0._tf.rect.height, 0)
	end

	if slot0.prantLeftBound < slot0._tf.localPosition.x + slot0.width then
		slot0._tf.localPosition = Vector3(slot0._tf.localPosition.x - slot0.width, slot0._tf.localPosition.y, slot0._tf.localPosition.z)
	end

	slot0:Show()
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

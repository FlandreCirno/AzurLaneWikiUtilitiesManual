slot0 = class("WSPortGoods", import("...BaseEntity"))
slot0.Fields = {
	transform = "userdata",
	rtMask = "userdata",
	goods = "table",
	txName = "userdata",
	rtResIcon = "userdata",
	rtItem = "userdata",
	txCount = "userdata",
	rtResCount = "userdata"
}
slot0.Listeners = {
	onUpdate = "Update"
}

slot0.Setup = function (slot0, slot1)
	slot0.goods = slot1

	slot0.goods:AddListener(WorldGoods.EventUpdateCount, slot0.onUpdate)
	slot0:Init()
end

slot0.Dispose = function (slot0)
	slot0.goods:RemoveListener(WorldGoods.EventUpdateCount, slot0.onUpdate)
	slot0:Clear()
end

slot0.Init = function (slot0)
	slot0.rtMask = slot0.transform.Find(slot1, "mask")
	slot0.rtItem = slot0.transform.Find(slot1, "item")
	slot0.txCount = slot0.transform.Find(slot1, "item/count_contain/count")
	slot0.txName = slot0.transform.Find(slot1, "item/name_mask/name")
	slot0.rtResIcon = slot0.transform.Find(slot1, "item/consume/contain/icon")
	slot0.rtResCount = slot0.transform.Find(slot1, "item/consume/contain/Text")

	setText(slot0.txName, shortenString(slot0.goods.item.getConfig(slot2, "name"), 6))
	updateDrop(slot0.rtItem, slot0.goods.item)
	LoadImageSpriteAtlasAsync(Item.GetIcon(slot0.goods.moneyItem.type, slot0.goods.moneyItem.id), "", slot0.rtResIcon)
	setText(slot0.rtResCount, slot0.goods.moneyItem.count)
	slot0:Update()
end

slot0.Update = function (slot0, slot1)
	if slot1 == nil or slot1 == WorldGoods.EventUpdateCount then
		setText(slot0.txCount, slot0.goods.count .. "/" .. slot0.goods.config.frequency)
		setActive(slot0.rtMask, slot0.goods.count == 0)
	end
end

return slot0

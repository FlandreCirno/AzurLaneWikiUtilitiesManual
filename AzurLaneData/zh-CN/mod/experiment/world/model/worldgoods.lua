slot0 = class("WorldGoods", import("...BaseEntity"))
slot0.Fields = {
	config = "table",
	item = "table",
	count = "number",
	id = "number",
	moneyItem = "table"
}
slot0.EventUpdateCount = "WorldGoods.EventUpdateCount"

slot0.CreateItem = function (slot0, slot1, slot2)
	return (slot0 == DROP_TYPE_WORLD_ITEM and WorldItem) or Item.New({
		type = slot0,
		id = slot1,
		count = slot2
	})
end

slot0.Setup = function (slot0, slot1)
	slot0.id = slot1.goods_id
	slot0.config = pg.world_goods_data[slot0.id]
	slot0.count = slot1.count
	slot0.item = slot0.CreateItem(slot0.config.item_type, slot0.config.item_id, slot0.config.item_num)
	slot0.moneyItem = slot0.CreateItem(slot0.config.price_type, slot0.config.price_id, slot0.config.price_num)
end

slot0.UpdateCount = function (slot0, slot1)
	if slot0.count ~= slot1 then
		slot0.count = slot1

		slot0:DispatchEvent(slot0.EventUpdateCount)
	end
end

slot0.sortFunc = function (slot0, slot1)
	if slot0.config.priority == slot1.config.priority then
		return slot0.id < slot1.id
	else
		return slot1.config.priority < slot0.config.priority
	end
end

return slot0

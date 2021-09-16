pg = pg or {}
pg.GuildPaintingMgr = singletonClass("GuildPaintingMgr")

pg.GuildPaintingMgr.Enter = function (slot0, slot1)
	slot0._tf = slot1
end

pg.GuildPaintingMgr.Update = function (slot0, slot1, slot2)
	slot0:Show()

	if slot0.name == slot1 then
		return
	end

	slot0:Clear()
	setPaintingPrefabAsync(slot0._tf, slot1, "chuanwu")

	slot0.name = slot1

	if slot2 then
		slot0._tf.localPosition = slot2
	end
end

pg.GuildPaintingMgr.Show = function (slot0)
	setActive(slot0._tf, true)
end

pg.GuildPaintingMgr.Hide = function (slot0)
	setActive(slot0._tf, false)
end

pg.GuildPaintingMgr.Clear = function (slot0)
	if slot0.name then
		retPaintingPrefab(slot0._tf, slot0.name)

		slot0.name = nil
	end
end

pg.GuildPaintingMgr.Exit = function (slot0)
	slot0:Clear()
end

return

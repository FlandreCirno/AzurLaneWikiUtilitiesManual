class("DaofengPTPage", import(".TemplatePage.PtTemplatePage")).OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot7, slot8, slot3 = slot0.ptData:GetResProgress()

	setText(slot0.progress, setColorStr(slot1, "#915167") .. "/" .. slot2)
	LoadImageSpriteAsync(pg.item_data_statistics[id2ItemId(slot4)].icon, slot0:findTF("AD/icon"), false)
end

return class("DaofengPTPage", import(".TemplatePage.PtTemplatePage"))

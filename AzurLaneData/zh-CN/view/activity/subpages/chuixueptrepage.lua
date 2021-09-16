slot0 = class("ChuixuePTRePage", import(".TemplatePage.PtTemplatePage"))

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)

	slot0.scrolltext = slot0:findTF("name", slot0.awardTF)

	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.GO_SHOPS_LAYER_STEEET, {
			warp = NewShopsScene.TYPE_SHOP_STREET
		})
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	slot0:SetAwardName()

	slot1, slot2, slot3 = slot0.ptData:GetResProgress()

	setText(slot0.progress, ((slot3 >= 1 and setColorStr(slot1, "#A2A2A2FF")) or slot1) .. "/" .. slot2)
end

slot0.SetAwardName = function (slot0)
	if pg.item_data_statistics[slot0.ptData:GetAward().id] then
		if slot1.type == 1 then
			changeToScrollText(slot0.scrolltext, pg.item_data_statistics[pg.player_resource[slot1.id].itemid].name)
		else
			changeToScrollText(slot0.scrolltext, pg.item_data_statistics[slot1.id].name)
		end
	else
		setActive(slot0:findTF("name", slot0.awardTF), false)
	end
end

return slot0

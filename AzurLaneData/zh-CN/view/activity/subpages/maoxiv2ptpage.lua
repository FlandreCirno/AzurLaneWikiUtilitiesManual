class("MaoxiV2PtPage", import(".TemplatePage.PtTemplatePage")).OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot9, slot11, slot3 = slot0.ptData:GetLevelProgress()
	slot4, slot5, slot6 = slot0.ptData:GetResProgress()

	setText(slot0.step, slot1 .. "/" .. slot2)
	setText(slot0.progress, ((slot6 >= 1 and setColorStr(slot4, "#80e4f9")) or slot4) .. "/" .. slot5)
	setSlider(slot0.slider, 0, 1, slot6)
end

return class("MaoxiV2PtPage", import(".TemplatePage.PtTemplatePage"))

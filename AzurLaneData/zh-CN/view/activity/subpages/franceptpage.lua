class("FrancePTPage", import(".TemplatePage.PtTemplatePage")).OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot7, slot8, slot3 = slot0.ptData:GetResProgress()

	setText(slot0.progress, setColorStr(slot1, "#E7E1CCFF") .. "/" .. slot2)
end

return class("FrancePTPage", import(".TemplatePage.PtTemplatePage"))

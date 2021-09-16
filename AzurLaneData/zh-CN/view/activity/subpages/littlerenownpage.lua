slot0 = class("LittleRenownPage", import(".TemplatePage.PtTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.heartTpl = slot0:findTF("HeartTpl", slot0.bg)
	slot0.heartContainer = slot0:findTF("HeartContainer", slot0.bg)
	slot0.heartUIItemList = UIItemList.New(slot0.heartContainer, slot0.heartTpl)

	slot0.heartUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setActive(slot0:findTF("Full", slot2), slot0.ptData:GetLevelProgress() >= slot1 + 1)
		end
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot1, slot5 = slot0.ptData:GetLevelProgress()

	slot0.heartUIItemList:align(slot2)
end

return slot0

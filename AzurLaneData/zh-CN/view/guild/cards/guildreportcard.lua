slot0 = class("GuildReportCard")

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.viewComponent = slot2
	slot0._go = slot1
	slot0._tf = tf(slot1)

	pg.DelegateInfo.New(slot0)

	slot0.bg = slot0._tf:GetComponent(typeof(Image))
	slot0.label = slot0._tf:Find("label"):GetComponent(typeof(Image))
	slot0.titleTxt = slot0._tf:Find("title/name"):GetComponent(typeof(Text))
	slot0.descTxt = slot0._tf:Find("desc"):GetComponent(typeof(Text))
	slot0.awardList = UIItemList.New(slot0._tf:Find("awards/content"), slot0._tf:Find("awards/content/item"))
	slot0.getBtn = slot0._tf:Find("get")
	slot0.gotBtn = slot0._tf:Find("got")
end

slot0.Update = function (slot0, slot1)
	slot0.report = slot1
	slot0.bg.sprite = GetSpriteFromAtlas("ui/GuildEventReportUI_atlas", "bg_" .. slot2)
	slot0.label.sprite = GetSpriteFromAtlas("ui/GuildEventReportUI_atlas", "text_" .. slot1:GetType())
	slot3 = slot1:IsSubmited()

	setActive(slot0.getBtn, not slot3)
	setActive(slot0.gotBtn, slot3)

	if not slot3 then
		setGray(slot0.getBtn, slot1:IsLock(), true)
	end

	slot0:UpdateAwards()

	slot0.titleTxt.text = slot1:getConfig("name")
	slot0.descTxt.text = slot1:GetReportDesc()
end

slot0.UpdateAwards = function (slot0)
	slot2, slot3 = slot0.report.GetDrop(slot1)

	slot0.awardList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, slot4)
			onButton(slot1, slot2, function ()
				slot0.viewComponent:emit(BaseUI.ON_DROP, slot0.viewComponent)
			end, SFX_PANEL)
			setActive(slot2.Find(slot2, "icon_bg/bouns"), slot1 + 1 <= slot2)
		end
	end)
	slot0.awardList.align(slot4, #slot2)
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
end

return slot0

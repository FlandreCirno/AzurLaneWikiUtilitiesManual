slot0 = class("SitanliLoginPage", import(".TemplatePage.LoginTemplatePage"))

slot0.OnDataSetting = function (slot0)
	slot0.config = pg.activity_7_day_sign[slot0.activity:getConfig("config_id")]
	slot0.Day = 14
end

slot0.OnFirstFlush = function (slot0)
	setActive(slot0.item, false)
	slot0.itemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventInit then
			updateDrop(slot3, slot5)
			onButton(slot0, slot2, function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)

			return
		end

		if slot0 == UIItemList.EventUpdate then
			setActive(slot0.findTF(slot3, "got", slot2), slot1 < slot0.nday)
		end
	end)
end

return slot0

slot0 = class("WudaoLoginPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.labelDay = slot0:findTF("days")
	slot0.items = slot0:findTF("items")
	slot0.item = slot0:findTF("item")
end

slot0.OnDataSetting = function (slot0)
	slot0.config = pg.activity_7_day_sign[slot0.activity:getConfig("config_id")]
end

slot0.OnFirstFlush = function (slot0)
	setActive(slot0.item, false)

	for slot4 = 1, 8, 1 do
		updateDrop(slot6, slot8)
		onButton(slot0, cloneTplTo(slot0.item, slot0.items:Find("layout")), function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
	end
end

slot0.OnUpdateFlush = function (slot0)
	for slot4 = 1, 8, 1 do
		GetImageSpriteFromAtlasAsync("ui/activityuipage/wudaologinpage_atlas", string.format("number%d", slot4), slot0:findTF("day", slot0.items:Find("layout"):GetChild(slot4 - 1)), true)
		setActive(slot0:findTF("got", slot0.items.Find("layout").GetChild(slot4 - 1)), slot4 <= slot0.activity.data1)
	end
end

slot0.OnDestroy = function (slot0)
	clearImageSprite(slot0.bg)
	removeAllChildren(slot0.items)
end

return slot0

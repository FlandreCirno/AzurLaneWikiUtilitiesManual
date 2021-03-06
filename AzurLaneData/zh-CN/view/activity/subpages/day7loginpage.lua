slot0 = class("Day7LoginPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("bg")
	slot0.labelDay = slot0:findTF("days")
	slot0.items = slot0:findTF("items")
	slot0.item = slot0:findTF("item")
end

slot0.OnDataSetting = function (slot0)
	slot0.config = pg.activity_7_day_sign[slot0.activity:getConfig("config_id")]
end

slot0.OnFirstFlush = function (slot0)
	setActive(slot0.item, false)

	for slot4 = 1, 7, 1 do
		updateDrop(slot6, slot8)
		onButton(slot0, cloneTplTo(slot0.item, slot0.items), function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
	end
end

slot0.OnUpdateFlush = function (slot0)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/day7_login_atlas", string.format("0%d", math.max(slot0.activity.data1, 1)), slot0.labelDay, true)

	for slot4 = 1, 7, 1 do
		GetImageSpriteFromAtlasAsync("ui/activityuipage/day7_login_atlas", string.format("day%d", slot4) .. ((slot4 <= slot0.activity.data1 and "_sel") or ""), slot0:findTF("day", slot0.items:GetChild(slot4 - 1)), true)
		setActive(slot0:findTF("got", slot0.items.GetChild(slot4 - 1)), slot4 <= slot0.activity.data1)
	end
end

slot0.OnDestroy = function (slot0)
	clearImageSprite(slot0.bg)
	removeAllChildren(slot0.items)
end

return slot0

slot0 = class("WorldBossEmptyPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "WorldBossEmptyUI"
end

slot0.Setup = function (slot0, slot1)
	slot0.proxy = slot1
end

slot0.OnLoaded = function (slot0)
	slot0.compass = slot0:findTF("compass")
	slot0.latitude = slot0:findTF("info/latitude", slot0.compass)
	slot0.altitude = slot0:findTF("info/altitude", slot0.compass)
	slot0.longitude = slot0:findTF("info/longitude", slot0.compass)
	slot0.speed = slot0:findTF("info/speed", slot0.compass)
	slot0.rader = slot0:findTF("rader/rader")
	slot0.timeTxt = slot0:findTF("time/Text"):GetComponent(typeof(Text))
	slot0.uilist = UIItemList.New(slot0:findTF("useItem/list"), slot0:findTF("useItem/list/tpl"))
	slot0:findTF("useItem/list/tpl"):GetComponent(typeof(Image)).sprite = LoadSprite("MetaShip/" .. WorldBossConst.GetCurrBossGroup() .. "_useitem")
	slot0.useItem = slot0:findTF("useItem")
	slot0.noItem = slot0:findTF("noitem")
end

slot0.OnInit = function (slot0)
	setText(slot0.latitude, "000")
	setText(slot0.altitude, "000")
	setText(slot0.longitude, "000")
	setText(slot0.speed, "000")
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot0[slot1 + 1]

			onButton(slot1, slot2, function ()
				if slot0 and not slot0:isEnd() then
					slot1:emit(WorldBossMediator.ON_ACTIVE_BOSS, slot0.id, )
				end
			end, SFX_PANEL)
		end
	end)
	slot0.uilist.align(slot3, #((getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) and slot1:getConfig("config_data")) or {}))
	rotateAni(slot0.rader, 1, 3)
end

slot0.CanActiveBoss = function (slot0)
	return slot0.proxy:CanUnlock()
end

slot0.Update = function (slot0)
	setActive(slot0.useItem, slot1)
	setActive(slot0.noItem, not slot0:CanActiveBoss())

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) and not slot2:isEnd() then
		slot0.timeTxt.text = string.format("%d.%d.%d~%d.%d.%d", slot2:getConfig("time")[2][1][1], slot2.getConfig("time")[2][1][2], slot2.getConfig("time")[2][1][3], slot2:getConfig("time")[3][1][1], slot2.getConfig("time")[3][1][2], slot2.getConfig("time")[3][1][3])
	else
		slot0.timeTxt.text = ""
	end

	slot0:Show()
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

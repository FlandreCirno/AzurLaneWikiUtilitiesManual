slot0 = class("Match3Page", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.item = slot0:findTF("item", slot0.bg)
	slot0.items = slot0:findTF("items", slot0.bg)
	slot0.goBtn = slot0:findTF("go", slot0.bg)
	slot0.itemList = UIItemList.New(slot0.items, slot0.item)
end

slot0.OnDataSetting = function (slot0)
	slot0.drop = slot0.activity:getConfig("config_client").drop
	slot0.id = slot0.activity:getConfig("config_client").gameId
	slot0.day = #slot0.drop
end

slot0.OnFirstFlush = function (slot0)
	setActive(slot0.item, false)

	slot2 = getProxy(MiniGameProxy).GetHubByHubId(slot1, slot0.activity:getConfig("config_id"))

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
			setActive(slot0.findTF(slot3, "got", slot2), slot1 < slot1.usedtime)
			setActive(slot0:findTF("mask", slot2), slot1 >= slot1.usedtime + slot1.count)
		end
	end)
	slot0.itemList.align(slot3, slot0.day)
	onButton(slot0, slot0.goBtn, function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, slot0.id)
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.itemList:align(slot0.day)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

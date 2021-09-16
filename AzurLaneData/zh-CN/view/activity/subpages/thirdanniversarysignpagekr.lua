slot0 = class("ThirdAnniversarySignPageKR", import(".TemplatePage.LoginTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.item = slot0:findTF("item", slot0.bg)
	slot0.items = slot0:findTF("mask/items", slot0.bg)
	slot0.itemList = UIItemList.New(slot0.items, slot0.item)
	slot0.initItems = {}
end

slot0.OnFirstFlush = function (slot0)
	setActive(slot0.item, false)
	slot0.itemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			if not table.contains(slot0.initItems, slot1) then
				updateDrop(slot3, slot5)
				onButton(slot0, slot2, function ()
					slot0:emit(BaseUI.ON_DROP, slot0)
				end, SFX_PANEL)
				table.insert(slot0.initItems, slot1)
			end

			setActive(slot0:findTF("got", slot2), slot1 < slot0.nday)
		end
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	eachChild(slot0.items, function (slot0)
		return
	end)
end

return slot0

slot0 = class("NewOrleansLoginPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.showItemTpl = slot0:findTF("ShowItem", slot0.bg)
	slot0.showItemContainer = slot0:findTF("ItemShowList", slot0.bg)
	slot0.itemList = UIItemList.New(slot0.showItemContainer, slot0.showItemTpl)

	setActive(slot0.showItemTpl, false)

	slot0.item = slot0:findTF("item", slot0.bg)
	slot0.items = slot0:findTF("items", slot0.bg)
	slot0.uilist = UIItemList.New(slot0.items, slot0.item)

	setActive(slot0.item, false)

	slot0.stepText = slot0:findTF("step_text", slot0.bg)
end

slot0.OnDataSetting = function (slot0)
	slot0.linkActivity = getProxy(ActivityProxy):getActivityById(slot1)
	slot0.nday = 0
	slot0.taskProxy = getProxy(TaskProxy)
	slot0.taskGroup = slot0.linkActivity:getConfig("config_data")
	slot0.config = pg.activity_7_day_sign[slot0.activity:getConfig("config_id")]
	slot0.Day = #slot0.config.front_drops
	slot0.curDay = 0

	return updateActivityTaskStatus(slot0.linkActivity)
end

slot0.OnFirstFlush = function (slot0)
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot0:findTF("item", slot2), slot8)
			onButton(slot0, slot0.findTF("item", slot2), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
			setText(slot0:findTF("description", slot2), slot0.taskProxy:getTaskById(slot0.taskGroup[slot0.nday][slot1 + 1]) or slot0.taskProxy:getFinishTaskById(slot5):getConfig("desc"))
			setText(slot0:findTF("progressText", slot2), slot9 .. "/" .. slot10)
			setSlider(slot0:findTF("progress", slot2), 0, slot10, slot9)
			setActive(slot0:findTF("go_btn", slot2), slot0.taskProxy.getTaskById(slot0.taskGroup[slot0.nday][slot1 + 1]) or slot0.taskProxy.getFinishTaskById(slot5):getTaskStatus() == 0)
			setActive(slot0:findTF("get_btn", slot2), slot14 == 1)
			setActive(slot0:findTF("got_btn", slot2), slot14 == 2)
			onButton(slot0, slot11, function ()
				slot0:emit(ActivityMediator.ON_TASK_GO, slot0)
			end, SFX_PANEL)
			onButton(slot0, slot12, function ()
				slot0:emit(ActivityMediator.ON_TASK_SUBMIT, slot0)
			end, SFX_PANEL)
		end
	end)
	slot0.itemList.make(slot1, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventInit then
			updateDrop(slot2, slot4)
			onButton(slot0, slot2, function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)

			return
		end

		if slot0 == UIItemList.EventUpdate then
			setActive(slot0.findTF(slot3, "icon_mask", slot2), slot1 < slot0.curDay)
		end
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.nday = slot0.linkActivity.data3

	if checkExist(slot0.linkActivity:getConfig("config_client").story, {
		slot0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(slot1[slot0.nday][1])
	end

	if slot0.stepText then
		setText(slot0.stepText, tostring(slot0.nday))
	end

	slot0.uilist:align(#slot0.taskGroup[slot0.nday])

	slot0.curDay = slot0.activity.data1

	slot0.itemList:align(slot0.Day)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

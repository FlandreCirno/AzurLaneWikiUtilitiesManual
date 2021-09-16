slot0 = class("CommossionItemsPanel")

slot0.Ctor = function (slot0, slot1, slot2)
	slot0._go = slot1
	slot0._parent = slot2
	slot0._viewComponent = slot2._viewComponent
	slot0.timers = {}
	slot0.uilist = UIItemList.New(slot1, slot1:GetChild(0))

	pg.DelegateInfo.New(slot0)
end

slot0.updateEventItems = function (slot0, slot1, slot2)
	slot3 = slot2.maxFleetNums
	slot4 = pairs
	slot5 = slot0.timers or {}

	for slot7, slot8 in slot4(slot5) do
		slot8:Stop()
	end

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			if slot0 < slot1 + 1 then
				setText(slot2:Find("lock/Text"), i18n("commission_no_open") .. "\n" .. i18n("commission_open_tip", slot1:getChapterByCount(slot3).chapter_name))
			else
				slot1:UpdateEventInfo(slot2, slot2[slot3])
			end

			setActive(slot2:Find("unlock"), not slot4)
			setActive(slot2:Find("lock"), slot4)
			slot1:UpdateStyle(slot2, false, eventInfo)
		end
	end)
	slot0.uilist.align(slot4, 4)

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT) and not slot4:isEnd() and slot2:GetEventByActivityId(slot4.id) then
		slot6 = cloneTplTo(slot0.uilist.item, slot0.uilist.container)

		slot6:SetAsFirstSibling()
		slot0:UpdateEventInfo(slot6, slot5)
		setActive(slot6:Find("unlock"), true)
		setActive(slot6:Find("lock"), false)
		slot0:UpdateStyle(slot6, true, eventInfo)
	end
end

slot0.UpdateStyle = function (slot0, slot1, slot2, slot3)
	slot4 = (slot3 and slot3.state) or EventInfo.StateNone
	slot5 = "icon_1"
	slot6 = "icon_4"
	slot7 = "icon_3"

	if slot2 then
		slot7 = "icon_6"
		slot6 = "icon_6"
		slot5 = "icon_5"
	end

	slot8("leisure", slot5)
	slot8("ongoging", slot6)
	slot8("finished", slot7)

	slot9 = "event_ongoing"

	if slot2 then
		slot9 = "event_bg_act"
	end

	slot1:Find("unlock/ongoging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/commissioninfoui_atlas", slot9)
	slot1:Find("unlock/finished"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/commissioninfoui_atlas", slot9)
	slot1:Find("unlock/ongoging/print"):GetComponent(typeof(Image)).color = (slot2 and Color.New(0.996078431372549, 0.7568627450980392, 0.9725490196078431, 1)) or Color.New(0.6039215686274509, 0.7843137254901961, 0.9607843137254902, 1)
	slot1:Find("unlock/finished/print"):GetComponent(typeof(Image)).color = (slot2 and Color.New(0.996078431372549, 0.7568627450980392, 0.9725490196078431, 1)) or Color.New(0.6039215686274509, 0.7843137254901961, 0.9607843137254902, 1)

	setActive(slot1:Find("unlock/act"), slot4 == EventInfo.StateNone and slot2)
end

slot0.UpdateEventInfo = function (slot0, slot1, slot2)
	if ((slot2 and slot2.state) or EventInfo.StateNone) == EventInfo.StateNone then
		setText(slot1:Find("unlock/name_bg/Text"), i18n("commission_idle"))
		onButton(slot0, slot1:Find("unlock/leisure/go_btn"), function ()
			slot0._viewComponent:emit(CommissionInfoMediator.ON_ACTIVE_EVENT)
		end, SFX_PANEL)
		onButton(slot0, slot1, function ()
			triggerButton(slot0:Find("unlock/leisure/go_btn"))
		end, SFX_PANEL)
	elseif slot3 == EventInfo.StateFinish then
		setText(slot1.Find(slot1, "unlock/name_bg/Text"), slot2.template.title)
		onButton(slot0, slot1:Find("unlock/finished/finish_btn"), function ()
			slot0._viewComponent:emit(CommissionInfoMediator.FINISH_EVENT, slot0._viewComponent)
		end, SFX_PANEL)
		onButton(slot0, slot1, function ()
			triggerButton(slot0:Find("unlock/finished/finish_btn"))
		end, SFX_PANEL)
	elseif slot3 == EventInfo.StateActive then
		setText(slot1.Find(slot1, "unlock/name_bg/Text"), slot2.template.title)

		slot4 = slot1:Find("unlock/ongoging/time"):GetComponent(typeof(Text))
		slot5 = slot2.finishTime + 2

		if slot0.timers[slot2.id] then
			slot0.timers[slot2.id]:Stop()

			slot0.timers[slot2.id] = nil
		end

		slot0.timers[slot2.id] = Timer.New(function ()
			if slot0 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
				slot1.timers[slot2.id]:Stop()

				slot1.timers[slot2.id].Stop.timers[slot1.timers[slot2.id].id] = nil

				slot1.timers[slot2.id].Stop.timers._parent:update()
			else
				slot3.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
			end
		end, 1, -1)

		slot0.timers[slot2.id].Start(slot6)
		slot0.timers[slot2.id].func()
	end

	setActive(slot1:Find("unlock/leisure"), slot3 == EventInfo.StateNone)
	setActive(slot1:Find("unlock/ongoging"), slot3 == EventInfo.StateActive)
	setActive(slot1:Find("unlock/finished"), slot3 == EventInfo.StateFinish)
end

slot0.getChapterByCount = function (slot0, slot1)
	for slot6, slot7 in pairs(pg.chapter_template.all) do
		if slot2[slot7].collection_team == slot1 then
			return slot2[slot7]
		end
	end
end

slot0.updateClassItems = function (slot0, slot1, slot2)
	slot3 = pairs
	slot4 = slot0.timers or {}

	for slot6, slot7 in slot3(slot4) do
		slot7:Stop()
	end

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = false
			slot5 = slot2:Find("unlock/name_bg")

			if slot0[slot1 + 1] then
				slot5.sizeDelta = Vector2(267, 45)
				slot8 = slot2:Find("unlock/ongoging/time"):GetComponent(typeof(Text))
				slot9 = slot4:getShipVO()
				slot10 = nil

				setText(slot2:Find("unlock/name_bg/Text"), slot4:getSkillName())

				if pg.TimeMgr.GetInstance():GetServerTime() < slot4:getFinishTime() then
					slot1.timers[slot4.id] = Timer.New(function ()
						if slot0 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
							slot1._parent:update()
							slot1._parent.update.timers[slot1._parent.id]:Stop()
						else
							slot3.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
						end
					end, 1, -1)

					slot1.timers[slot4.id].Start(slot11)
					slot1.timers[slot4.id]:func()

					slot10 = slot2:Find("unlock/ongoging/shipicon")
				else
					slot3 = true

					onButton(slot1, slot2:Find("unlock/finished/finish_btn"), function ()
						slot0._viewComponent:emit(CommissionInfoMediator.FINISH_CLASS, slot1.id, Student.CANCEL_TYPE_AUTO)
					end, SFX_PANEL)
					onButton(slot1, slot2, function ()
						triggerButton(slot0:Find("unlock/finished/finish_btn"))
					end, SFX_PANEL)

					slot10 = slot2.Find(slot2, "unlock/finished/shipicon")
				end

				updateShip(slot10, slot9)
			else
				slot5.sizeDelta = Vector2(400, 45)

				setText(slot2:Find("unlock/name_bg/Text"), i18n("commission_idle"))
				onButton(slot1, slot2:Find("unlock/leisure/go_btn"), function ()
					slot0._viewComponent:emit(CommissionInfoMediator.ON_ACTIVE_CLASS)
				end, SFX_PANEL)
				onButton(slot1, slot2, function ()
					triggerButton(slot0:Find("unlock/leisure/go_btn"))
				end, SFX_PANEL)
			end

			setActive(slot2.Find(slot2, "unlock"), true)
			setActive(slot2:Find("lock"), false)
			setActive(slot2:Find("unlock/leisure"), not slot4)
			setActive(slot2:Find("unlock/ongoging"), slot4 and not slot3)
			setActive(slot2:Find("unlock/finished"), slot4 and slot3)
		end
	end)
	slot0.uilist.align(slot3, slot2)
end

slot0.updateTechItems = function (slot0, slot1, slot2)
	slot3 = pairs
	slot4 = slot0.timers or {}

	for slot6, slot7 in slot3(slot4) do
		slot7:Stop()
	end

	table.sort(slot1, function (slot0, slot1)
		return slot1.state < slot0.state
	end)
	slot0.uilist.make(slot3, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			function slot5()
				slot1 = slot0:Find("unlock/desc/name_bg/Text")

				setText(slot1, slot1:getConfig("name"))

				if slot1:hasCondition() then
					setText(slot0:Find("unlock/desc/task_bg/Text"), getProxy(TaskProxy):getTaskById(slot1:getTaskId()) or getProxy(TaskProxy):getFinishTaskById(slot0):getConfig("desc") .. "(" .. getProxy(TaskProxy).getTaskById(slot1.getTaskId()) or getProxy(TaskProxy).getFinishTaskById(slot0):getProgress() .. "/" .. getProxy(TaskProxy).getTaskById(slot1.getTaskId()) or getProxy(TaskProxy).getFinishTaskById(slot0):getConfig("target_num") .. ")")
				end
			end

			if slot0[slot1 + 1].state == Technology.STATE_IDLE then
				setText(slot2.Find(slot2, "unlock/desc/name_bg/Text"), i18n("commission_idle"))
				onButton(slot1, slot2:Find("unlock/leisure/go_btn"), function ()
					slot0._viewComponent:emit(CommissionInfoMediator.ON_ACTIVE_TECH)
				end, SFX_PANEL)
				onButton(slot1, slot2, function ()
					triggerButton(slot0:Find("unlock/leisure/go_btn"))
				end, SFX_PANEL)
			elseif slot4 == Technology.STATE_FINISHED then
				slot5()
				onButton(slot1, slot2:Find("unlock/finished/finish_btn"), function ()
					slot0._viewComponent:emit(CommissionInfoMediator.ON_TECH_FINISHED, {
						id = slot1.id,
						pool_id = slot1.poolId
					})
				end, SFX_PANEL)
				onButton(slot1, slot2, function ()
					triggerButton(slot0:Find("unlock/finished/finish_btn"))
				end, SFX_PANEL)
			elseif slot4 == Technology.STATE_STARTING then
				slot5()

				slot6 = slot2:Find("unlock/ongoging/time"):GetComponent(typeof(Text))

				if pg.TimeMgr.GetInstance():GetServerTime() < slot3:getFinishTime() then
					slot1.timers[slot3.id] = Timer.New(function ()
						if slot0:getFinishTime() - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
							slot1.text = pg.TimeMgr.GetInstance():DescCDTime(slot0)
						else
							slot2.timers[slot0.id]:Stop()
							slot2._parent:update()
						end
					end, 1, -1)

					slot1.timers[slot3.id].Start(slot9)
					slot1.timers[slot3.id].func()
				else
					slot6.text = "00:00:00"
				end
			end

			setActive(slot2:Find("unlock"), true)
			setActive(slot2:Find("lock"), false)
			setActive(slot2:Find("unlock/leisure"), slot4 == Technology.STATE_IDLE)
			setActive(slot2:Find("unlock/ongoging"), slot4 == Technology.STATE_STARTING)
			setActive(slot2:Find("unlock/finished"), slot4 == Technology.STATE_FINISHED)
			setActive(slot2:Find("unlock/desc/task_bg"), slot4 ~= Technology.STATE_IDLE and slot3:hasCondition())
		end
	end)
	slot0.uilist.align(slot3, slot2)
end

slot0.clear = function (slot0)
	slot1 = pairs
	slot2 = slot0.timers or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:Stop()
	end

	pg.DelegateInfo.Dispose(slot0)
end

return slot0

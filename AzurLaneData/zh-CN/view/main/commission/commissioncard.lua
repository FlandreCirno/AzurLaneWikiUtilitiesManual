slot0 = class("CommissionCard")
slot0.TYPE_EVENT = 1
slot0.TYPE_CLASS = 2
slot0.TYPE_TECHNOLOGY = 3

slot0.Ctor = function (slot0, slot1, slot2)
	slot0._go = slot2[2]
	slot0._type = slot2[1]
	slot0._proxy = slot2[3]
	slot0._viewComponent = slot1
	slot0._tf = tf(slot0._go)
	slot0.goBtn = slot0._tf:Find("frame/go_btn")
	slot0.finishedBtn = slot0._tf:Find("frame/finish_btn")
	slot0.toggle = slot0._tf:Find("frame")
	slot0.tip = slot0._tf:Find("frame/tip")
	slot0.finishedCounterContainer = slot0._tf:Find("frame/counter/finished")
	slot0.ongoingCounterContainer = slot0._tf:Find("frame/counter/ongoing")
	slot0.leisureCounterContainer = slot0._tf:Find("frame/counter/leisure")
	slot0.finishedCounter = slot0._tf:Find("frame/counter/finished/Text"):GetComponent(typeof(Text))
	slot0.ongoingCounter = slot0._tf:Find("frame/counter/ongoing/Text"):GetComponent(typeof(Text))
	slot0.leisureCounter = slot0._tf:Find("frame/counter/leisure/Text"):GetComponent(typeof(Text))
	slot0.itemsPanel = CommossionItemsPanel.New(slot0._tf:Find("list"), slot0)
	slot0.lockTF = slot0._tf:Find("lock")
	slot0.commingTF = slot0._tf:Find("comming")

	if slot0.lockTF then
		setActive(slot0.lockTF, false)
	end

	setActive(slot0.finishedCounterContainer, false)
	setActive(slot0.ongoingCounterContainer, false)
	setActive(slot0.leisureCounterContainer, false)
	pg.DelegateInfo.New(slot0)
end

slot0.updateTips = function (slot0, slot1)
	slot0.tip.localScale = Vector3(1, (slot1 and -1) or 1, 1)
end

slot0.update = function (slot0)
	if slot0._type == slot0.TYPE_EVENT then
		slot0:updateForEvent()
	elseif slot0._type == slot0.TYPE_CLASS then
		slot0:updateForClass()
	elseif slot0._type == slot0.TYPE_TECHNOLOGY then
		slot0:updateForTechnology()
	end
end

slot0.updateForEvent = function (slot0)
	slot1 = nil

	setActive(slot0.lockTF, not (getProxy(PlayerProxy):getData().level >= 12))
	setGray(slot0.toggle, not (getProxy(PlayerProxy).getData().level >= 12), true)
	setActive(slot0.tip, getProxy(PlayerProxy).getData().level >= 12)

	if not (getProxy(PlayerProxy).getData().level >= 12) then
		setActive(slot0.goBtn, false)

		return
	end

	slot5 = 0

	_.each(slot2, function (slot0)
		if slot0:IsActivityType() then
			if slot0.state == EventInfo.StateNone then
				slot0 = slot0 + 1
			elseif slot0.state == EventInfo.StateActive then
				slot1 = slot1 + 1
			elseif slot0.state == EventInfo.StateFinish then
				slot2 = slot2 + 1
			end
		elseif slot0.state == EventInfo.StateNone then
		elseif slot0.state == EventInfo.StateActive then
			slot3 = slot3 + 1

			table.insert(slot4, slot0)
		elseif slot0.state == EventInfo.StateFinish then
			slot5 = slot5 + 1

			table.insert(slot4, slot0)
		end
	end)

	slot0.finishedCounter.text = 0 + 0
	slot0.ongoingCounter.text = 0 + 0
	slot0.leisureCounter.text = slot0._proxy.maxFleetNums - (0 + 0) + 0

	setActive(slot0.finishedCounterContainer, 0 + 0 > 0)
	setActive(slot0.ongoingCounterContainer, slot11 > 0)
	setActive(slot0.leisureCounterContainer, slot12 > 0)
	setActive(slot0.goBtn, slot10 == 0)
	setActive(slot0.finishedBtn, slot10 > 0)
	table.sort(slot9, function (slot0, slot1)
		return slot1.state < slot0.state
	end)
	slot0.itemsPanel.updateEventItems(slot13, {}, slot0._proxy)
	onButton(slot0, slot0.finishedBtn, function ()
		_.each(slot0, function (slot0)
			if slot0.state == EventInfo.StateFinish then
				table.insert(slot0, function (slot0)
					slot0._viewComponent:emit(CommissionInfoMediator.FINISH_EVENT, slot0._viewComponent.emit, slot0)
				end)
			end
		end)

		_.each._viewComponent.contextData.oneStepFinishEventCount = #{}

		seriesAsync(slot0)
	end, SFX_PANEL)
end

slot0.updateForClass = function (slot0)
	_.each(_.values(slot1), function (slot0)
		if slot0:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime() then
			slot0 = slot0 + 1
		end
	end)

	slot0.finishedCounter.text = 0
	slot0.ongoingCounter.text = table.getCount(slot1) - 0
	slot0.leisureCounter.text = slot0._proxy:getSkillClassNum() - table.getCount(slot1)

	setActive(slot0.finishedCounterContainer, 0 > 0)
	setActive(slot0.ongoingCounterContainer, slot4 < slot3)
	setActive(slot0.leisureCounterContainer, slot3 < slot2)
	setActive(slot0.goBtn, slot4 == 0)
	setActive(slot0.finishedBtn, slot4 > 0)
	slot0.itemsPanel.updateClassItems(slot5, slot1, slot2)
	onButton(slot0, slot0.finishedBtn, function ()
		for slot4, slot5 in pairs(slot0) do
			if slot5:getFinishTime() < pg.TimeMgr.GetInstance():GetServerTime() then
				table.insert(slot0, function (slot0)
					slot0._viewComponent:emit(CommissionInfoMediator.FINISH_CLASS, slot1.id, Student.CANCEL_TYPE_AUTO, slot0)
				end)
			end
		end

		seriesAsync(slot0)
	end, SFX_PANEL)
end

slot0.updateForTechnology = function (slot0)
	slot1 = nil

	if LOCK_TECHNOLOGY then
		setActive(slot0._tf:Find("frame"), false)
		setActive(slot0.lockTF, false)
		setActive(slot0.commingTF, true)

		return
	else
		setActive(slot0._tf:Find("frame"), true)
		setActive(slot0.lockTF, false)
		setActive(slot0.commingTF, false)
	end

	setActive(slot0.lockTF, not (getProxy(PlayerProxy):getData().level >= 30))
	setGray(slot0.toggle, not (getProxy(PlayerProxy).getData().level >= 30), true)
	setActive(slot0.tip, getProxy(PlayerProxy).getData().level >= 30)

	if not (getProxy(PlayerProxy).getData().level >= 30) then
		setActive(slot0.goBtn, false)

		return
	end

	if #_.select(slot2, function (slot0)
		return slot0.state == Technology.STATE_STARTING and slot0:canFinish()
	end) > 0 then
		for slot7, slot8 in pairs(slot3) do
			slot0._viewComponent:emit(CommissionInfoMediator.ON_TECH_TIME_OVER, slot8.id, function ()
				slot0:updateForTechnology()
			end)
		end
	else
		slot4 = 1

		_.each(slot2, function (slot0)
			if slot0.state == Technology.STATE_IDLE then
			elseif slot0.state == Technology.STATE_STARTING then
				slot0 = slot0 + 1
			elseif slot0.state == Technology.STATE_FINISHED then
				slot1 = slot1 + 1
			end
		end)
		setActive(slot0.goBtn, 0 == 0)
		setActive(slot0.finishedBtn, slot5 > 0)

		slot0.finishedCounter.text = slot5
		slot0.ongoingCounter.text = 0
		slot0.leisureCounter.text = ((slot5 <= 0 and 0 <= 0) or 0) and 1

		setActive(slot0.finishedCounterContainer, slot5 > 0)
		setActive(slot0.ongoingCounterContainer, 0 > 0)
		setActive(slot0.leisureCounterContainer, (((slot5 <= 0 and 0 <= 0) or 0) and 1) > 0)
		slot0.itemsPanel:updateTechItems(slot2, (pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy).getData(slot7).level, "TechnologyMediator") and 1) or 0)
		onButton(slot0, slot0.finishedBtn, function ()
			_.each(_.select(slot0, function (slot0)
				return slot0.state == Technology.STATE_FINISHED
			end), function (slot0)
				slot0._viewComponent:emit(CommissionInfoMediator.ON_TECH_FINISHED, {
					id = slot0.id,
					pool_id = slot0.poolId
				})
			end)
		end, SFX_PANEL)
	end
end

slot0.dispose = function (slot0)
	slot0.itemsPanel:clear()
	pg.DelegateInfo.Dispose(slot0)
end

return slot0

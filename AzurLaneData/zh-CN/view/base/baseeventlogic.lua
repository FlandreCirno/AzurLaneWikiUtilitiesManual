slot0 = class("BaseEventLogic")
slot1 = require("Framework.notify.event")

slot0.Ctor = function (slot0, slot1)
	slot0.eventStore = {}
	slot0.event = slot1 or slot0.New()
	slot0.tweenIdList = {}
end

slot0.bind = function (slot0, slot1, slot2)
	slot0.event:connect(slot1, slot2)
	table.insert(slot0.eventStore, {
		event = slot1,
		callback = slot2
	})
end

slot0.emit = function (slot0, ...)
	if slot0.event then
		slot0.event:emit(...)
	end
end

slot0.disposeEvent = function (slot0)
	for slot4, slot5 in ipairs(slot0.eventStore) do
		slot0.event:disconnect(slot5.event, slot5.callback)
	end

	slot0.eventStore = {}
end

slot0.managedTween = function (slot0, slot1, slot2, ...)
	slot3 = slot1(...)

	slot3:setOnComplete(System.Action(function ()
		table.removebyvalue(slot0.tweenIdList, slot1.uniqueId)

		if slot1.uniqueId then
			slot2()
		end
	end))

	slot0.tweenIdList[#slot0.tweenIdList + 1] = slot3.uniqueId

	return slot3
end

slot0.cleanManagedTween = function (slot0, slot1)
	slot1 = defaultValue(slot1, false)

	for slot5, slot6 in ipairs(slot0.tweenIdList) do
		if LeanTween.isTweening(slot6) then
			LeanTween.cancel(slot6, slot1)
		end
	end

	slot0.tweenIdList = {}
end

slot0.pauseManagedTween = function (slot0)
	for slot4, slot5 in ipairs(slot0.tweenIdList) do
		if LeanTween.isTweening(slot5) then
			LeanTween.pause(slot5)
		end
	end
end

slot0.resumeManagedTween = function (slot0)
	for slot4, slot5 in ipairs(slot0.tweenIdList) do
		if LeanTween.isTweening(slot5) then
			LeanTween.resume(slot5)
		end
	end
end

slot0.AddLeanTween = function (slot0, slot1)
	slot0.tweenIdList[#slot0.tweenIdList + 1] = slot1().uniqueId
end

return slot0

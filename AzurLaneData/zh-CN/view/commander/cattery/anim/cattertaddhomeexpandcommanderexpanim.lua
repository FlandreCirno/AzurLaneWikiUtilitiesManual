slot0 = class("CattertAddHomeExpAndCommanderExpAnim", import(".CatteryAddHomeExpAnim"))

slot0.Ctor = function (slot0, slot1)
	slot0._tf = slot1
	slot0.expSlider = findTF(slot0._tf, "home/slider"):GetComponent(typeof(Slider))
	slot0.levelTxt = findTF(slot0._tf, "home/level"):GetComponent(typeof(Text))
	slot0.expTxt = findTF(slot0._tf, "home/exp"):GetComponent(typeof(Text))
	slot0.addition = findTF(slot0._tf, "home/addition")
	slot0.additionExpTxt = slot0.addition:Find("Text"):GetComponent(typeof(Text))
	slot0.uilist = UIItemList.New(findTF(slot0._tf, "commanders"), findTF(slot0._tf, "commanders/tpl"))
	slot0.cards = {}

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:UpdateCommander(slot2, slot0.displays[slot1 + 1])
		end
	end)

	slot0.animRiseH = slot0.addition.localPosition.y

	setActive(slot0._tf, false)
end

slot0.RefreshAward = function (slot0)
	return
end

slot0.Action = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.commanderExps = slot1

	parallelAsync({
		function (slot0)
			slot0.super.Action(slot0.super.Action, , , , , slot0)
		end,
		function (slot0)
			slot0:InitCommanders()
			slot0:DoCommandersAnim(slot0)
		end
	}, slot5)
end

slot0.GetAwardOffset = function (slot0)
	return 473
end

slot0.InitCommanders = function (slot0)
	slot0.displays = {}

	for slot6, slot7 in pairs(slot2) do
		table.insert(slot0.displays, slot7)
	end

	table.sort(slot0.displays, function (slot0, slot1)
		return slot1:GetCommanderId() < slot0:GetCommanderId()
	end)
	slot0.uilist.align(slot3, #slot0.displays)
end

slot0.DoCommandersAnim = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0.cards) do
		table.insert(slot2, function (slot0)
			slot0:Action(slot0)
		end)
	end

	parallelAsync(slot2, slot1)
end

slot0.UpdateCommander = function (slot0, slot1, slot2)
	if not slot0.cards[slot1] then
		slot0.cards[slot1] = CatteryAnimCard.New(slot1)
	end

	slot4 = 0

	if _.detect(slot0.commanderExps, function (slot0)
		return slot0.id == slot0.id
	end) then
		slot4 = slot5.value
	end

	slot3.Update(slot3, slot2, slot4)
end

slot0.Clear = function (slot0)
	slot0.super.Clear(slot0)

	for slot4, slot5 in pairs(slot0.cards) do
		slot5:Clear()
	end
end

slot0.Dispose = function (slot0)
	slot0.super.Dispose(slot0)

	for slot4, slot5 in pairs(slot0.cards) do
		slot5:Dispose()
	end

	slot0.cards = nil
end

return slot0

slot0 = class("CatterySettlementCard")
slot1 = 1

slot0.Ctor = function (slot0, slot1)
	slot0.tr = slot1
	slot0.go = slot1.gameObject
	slot0.emptyTF = findTF(slot0.tr, "empty")
	slot0.commanderTF = findTF(slot0.tr, "commander")
	slot0.nameTxt = findTF(slot0.commanderTF, "name"):GetComponent(typeof(Text))
	slot0.char = findTF(slot0.commanderTF, "mask/char")
	slot0.expTxt = findTF(slot0.commanderTF, "exp/Text"):GetComponent(typeof(Text))
	slot0.slider = findTF(slot0.commanderTF, "exp_bar"):GetComponent(typeof(Slider))
	slot0.levelTxt = findTF(slot0.commanderTF, "level"):GetComponent(typeof(Text))
end

slot0.Update = function (slot0, slot1, slot2)
	slot0.cattery = slot1
	slot0.exp = slot2

	if slot1:ExistCommander() then
		slot0:UpdateCommander()
	end

	setActive(slot0.emptyTF, not slot3)
	setActive(slot0.commanderTF, slot3)
end

slot0.UpdateCommander = function (slot0)
	slot3 = slot0.cattery.GetCommander(slot2)
	slot4 = slot0:GetOldCommander(slot3, slot1)
	slot0.oldCommander = slot4
	slot0.commander = slot3

	slot0:LoadCommander(slot3)

	slot0.slider.value = slot4.exp / slot4:getNextLevelExp()
	slot0.levelTxt.text = "LV." .. slot4:getLevel()
	slot0.expTxt.text = slot4.exp .. "/" .. slot4:getNextLevelExp()
	slot0.nameTxt.text = slot4:getName()
end

slot0.InitAnim = function (slot0, slot1)
	slot5 = slot0.commander.exp / slot0.commander:getNextLevelExp()

	if slot0.oldCommander:getLevel() < slot0.commander:getLevel() then
		table.insert(slot1, function (slot0)
			slot0:DoUpgradeAnim(slot0)
		end)
	else
		table.insert(slot1, function (slot0)
			slot0:AddExpAnim(slot0.slider.value, slot0.AddExpAnim, slot0.oldCommander.exp, slot0.commander.exp, slot0, slot0)
		end)
	end
end

slot0.Action = function (slot0, slot1)
	if not slot0.commander then
		slot1()

		return
	end

	slot0:InitAnim(slot2)
	parallelAsync({}, slot1)
end

slot0.DoUpgradeAnim = function (slot0, slot1)
	slot2 = slot0.commander:getLevel()
	slot4 = slot0.oldCommander:getLevel()
	slot6 = slot0.commander.exp / slot0.commander:getNextLevelExp()

	function slot7()
		slot0 = slot0 + 1
		slot1.levelTxt.text = "LV." .. slot1.levelTxt
	end

	slot8 = {}
	slot3 = slot0.oldCommander.getLevel() + 1

	table.insert(slot8, function (slot0)
		slot0:AddExpAnim(slot0.slider.value, 1, slot0.oldCommander.exp, slot0.oldCommander:getNextLevelExp(), , function ()
			slot0()
			slot1()
		end)
	end)

	while slot3 ~= slot2 do
		slot3 = slot3 + 1

		table.insert(slot8, function (slot0)
			slot0:AddExpAnim(0, 1, 0, slot0.oldCommander:getConfigExp(slot0.oldCommander.getConfigExp), , function ()
				slot0()
				slot1()
			end)
		end)
	end

	table.insert(slot8, function (slot0)
		slot0:AddExpAnim(0, slot0.AddExpAnim, 0, slot0.commander.exp, slot0, slot0)
	end)
	seriesAsync(slot8, slot1)
end

slot0.LoadCommander = function (slot0, slot1)
	slot0:ReturnCommander()

	slot0.painting = slot1:getPainting()

	setPaintingPrefab(slot0.char, slot0.painting, "result")
end

slot0.ReturnCommander = function (slot0)
	if slot0.painting then
		retPaintingPrefab(slot0.char, slot0.painting)

		slot0.painting = nil
	end
end

slot0.Clear = function (slot0)
	if LeanTween.isTweening(go(slot0.slider)) then
		LeanTween.cancel(go(slot0.slider))
	end

	if LeanTween.isTweening(go(slot0.expTxt)) then
		LeanTween.cancel(go(slot0.expTxt))
	end
end

slot0.Dispose = function (slot0)
	slot0:Clear()
	slot0:ReturnCommander()
end

slot0.GetOldCommander = function (slot0, slot1, slot2)
	slot3 = Clone(slot1)

	slot3:ReduceExp(slot2)

	return slot3
end

slot0.AddExpAnim = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	parallelAsync({
		function (slot0)
			LeanTween.value(go(slot0.slider), LeanTween.value, , ):setOnUpdate(System.Action_float(function (slot0)
				slot0.slider.value = slot0
			end)).setOnComplete(slot1, System.Action(slot0))
		end,
		function (slot0)
			LeanTween.value(go(slot0.expTxt), LeanTween.value, , ):setOnUpdate(System.Action_float(function (slot0)
				slot0.expTxt.text = "<color=#94d53eFF>" .. math.ceil(slot0) .. "/</color>" .. "<color=" .. slot0:GetColor() .. ">" .. math.ceil(slot0) .. "</color>"
			end)).setOnComplete(slot1, System.Action(slot0))
		end
	}, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.GetColor = function (slot0)
	return "#9f9999"
end

return slot0

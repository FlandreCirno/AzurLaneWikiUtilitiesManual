slot0 = class("CatteryAddHomeExpAnim")
slot1 = 1

slot0.Ctor = function (slot0, slot1)
	slot0._tf = slot1
	slot0.expSlider = findTF(slot0._tf, "slider"):GetComponent(typeof(Slider))
	slot0.levelTxt = findTF(slot0._tf, "level"):GetComponent(typeof(Text))
	slot0.expTxt = findTF(slot0._tf, "exp"):GetComponent(typeof(Text))
	slot0.addition = findTF(slot0._tf, "addition")
	slot0.additionExp = findTF(slot0._tf, "addition/exp")
	slot0.additionExpTxt = slot0.additionExp:Find("Text"):GetComponent(typeof(Text))
	slot0.additionItem = findTF(slot0._tf, "addition/item")
	slot0.additionItemImg = findTF(slot0._tf, "addition/item/icon")
	slot0.animRiseH = slot0.addition.localPosition.y

	setActive(slot0._tf, false)
end

slot0.Action = function (slot0, slot1, slot2, slot3, slot4, slot5)
	setActive(slot0._tf, true)

	slot0.callback = slot5

	setAnchoredPosition(slot0.addition, {
		x = slot0:GetAwardOffset(slot3, slot4)
	})
	slot0:RefreshAward(slot3, slot4)
	slot0:RefreshHome(slot2)
end

slot0.GetAwardOffset = function (slot0, slot1, slot2)
	return ((slot1 or slot2) and -82) or -15
end

slot0.RefreshAward = function (slot0, slot1, slot2)
	if slot1 then
		GetImageSpriteFromAtlasAsync("Props/20010", "", slot0.additionItemImg)
	elseif slot2 then
		GetImageSpriteFromAtlasAsync("Props/dormMoney", "", slot0.additionItemImg)
	end

	setActive(slot0.additionItem, slot1 or slot2)
end

slot0.RefreshHome = function (slot0, slot1)
	slot0.additionExpTxt.text = slot1 .. "<size=40>EXP</size>"

	if getProxy(CommanderProxy):GetCommanderHome().exp - slot1 < 0 then
		slot0:DoUpgradeAnim(slot2, slot1)
	else
		slot0:DoAddExpAnim(slot2, slot1)
	end
end

slot0.DoUpgradeAnim = function (slot0, slot1, slot2)
	slot0.levelTxt.text = "LV." .. slot1:GetLevel() - 1
	slot3 = slot1:GetPrevLevelExp()
	slot0.expTxt.text = "<color=#92FC63FF>" .. slot5 .. "/</color>" .. slot3
	slot0.expSlider.value = (slot3 - math.abs(slot1.exp - slot2)) / slot3
	slot8 = slot1.exp / slot1:GetNextLevelExp()

	slot0:AddExpAnim(slot6, 1, slot3 - math.abs(slot1.exp - slot2), slot3, slot3, function ()
		slot0.levelTxt.text = "LV." .. slot1:GetLevel()

		slot0.levelTxt:AddExpAnim(0, , 0, slot1.exp, )
	end)
	slot0.AdditionAnim(slot0, slot0, function ()
		if slot0.callback then
			slot0.callback()
		end

		slot0.callback = nil
	end)
end

slot0.DoAddExpAnim = function (slot0, slot1, slot2)
	slot0.levelTxt.text = "LV." .. slot1:GetLevel()
	slot3 = slot1:GetNextLevelExp()

	slot0:AddExpAnim(slot6, slot4, slot1.exp - slot2, slot1.exp, slot3)
	slot0:AdditionAnim(slot0, function ()
		if slot0.callback then
			slot0.callback()
		end

		slot0.callback = nil
	end)
end

slot0.Clear = function (slot0)
	if LeanTween.isTweening(go(slot0.expSlider)) then
		LeanTween.cancel(go(slot0.expSlider))
	end

	if LeanTween.isTweening(go(slot0.expTxt)) then
		LeanTween.cancel(go(slot0.expTxt))
	end

	if LeanTween.isTweening(go(slot0.addition)) then
		LeanTween.cancel(go(slot0.addition))
	end
end

slot0.Hide = function (slot0)
	slot0:Clear()
	setActive(slot0._tf, false)
end

slot0.Dispose = function (slot0)
	slot0:Hide()
end

slot0.AddExpAnim = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	parallelAsync({
		function (slot0)
			LeanTween.value(go(slot0.expSlider), LeanTween.value, , ):setOnUpdate(System.Action_float(function (slot0)
				slot0.expSlider.value = slot0
			end)).setOnComplete(slot1, System.Action(slot0))
		end,
		function (slot0)
			LeanTween.value(go(slot0.expTxt), LeanTween.value, , ):setOnUpdate(System.Action_float(function (slot0)
				slot0.expTxt.text = "<color=#92FC63FF>" .. math.ceil(slot0) .. "/</color>" .. math.ceil(slot0)
			end)).setOnComplete(slot1, System.Action(slot0))
		end
	}, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.AdditionAnim = function (slot0, slot1, slot2)
	setActive(slot0.addition, true)
	LeanTween.value(go(slot0.addition), slot0.animRiseH, slot0.animRiseH + 25, slot1):setOnUpdate(System.Action_float(function (slot0)
		slot0.addition.localPosition = Vector3(slot0.addition.localPosition.x, slot0, 0)
	end)).setOnComplete(slot3, System.Action(function ()
		setActive(slot0.addition, false)
		slot1()

		slot1.addition.localPosition = Vector3(slot0.addition.localPosition.x, y, 0)
	end))
end

return slot0

slot0 = class("SummaryPageLoading", import(".SummaryPage"))
slot1 = 0.05

slot0.OnInit = function (slot0)
	slot0.textContainer = findTF(slot0._go, "texts")
	slot0.textTFs = {}

	eachChild(slot0.textContainer, function (slot0)
		setActive(slot0, false)
		table.insert(slot0.textTFs, 1, slot0)
	end)

	slot0.timers = {}

	setActive(slot0._go, false)
end

slot0.Show = function (slot0, slot1)
	slot0.inAniming = true

	setActive(slot0._tf, true)

	slot2 = {}

	for slot6, slot7 in ipairs(slot0.textTFs) do
		table.insert(slot2, function (slot0)
			slot0.timers[] = Timer.New(function ()
				if slot0.timers[slot1] then
					slot0.timers[slot1]:Stop()

					slot0.timers[slot1].Stop.timers[slot0.timers[slot1]] = nil
				end

				setActive(slot2, true)
				slot2:GetComponent(typeof(Typewriter)):setSpeed(0.015)
				0.015()
			end, slot3 * slot1, 1)

			slot0.timers[].Start(slot1)
		end)
	end

	table.insert(slot2, function (slot0)
		slot1 = slot0.textContainer:GetComponent(typeof(CanvasGroup))

		LeanTween.value(go(slot0.textContainer), 1, 0, 0.5):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
		end)).setOnComplete(slot2, System.Action(slot0)):setDelay(0.6)
	end)
	seriesAsync(slot2, function ()
		slot0.inAniming = nil

		nil()
	end)
end

slot0.Hide = function (slot0, slot1)
	slot0:Clear()
	setActive(slot0._tf, false)
	slot1()
end

slot0.inAnim = function (slot0)
	return slot0.inAniming
end

slot0.Clear = function (slot0)
	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Stop()
	end

	slot0.timers = {}
end

return slot0

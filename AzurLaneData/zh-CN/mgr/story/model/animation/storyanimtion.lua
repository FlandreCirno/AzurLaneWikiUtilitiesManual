slot0 = class("StoryAnimtion")

slot0.Ctor = function (slot0, slot1)
	slot0.tweens = {}
	slot0.timers = {}
	slot0.timeScale = 1
end

slot0.SetTimeScale = function (slot0, slot1)
	slot0.timeScale = slot1
end

slot0.TweenMove = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.move(rtf(slot0), , slot2 * slot3.timeScale)

		if slot3.timeScale > 1 then
			slot0:setLoopPingPong(slot4)
		end

		if slot5 then
			slot0:setOnComplete(System.Action(slot5))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.TweenScale = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.DelayCall(slot0, slot4, function ()
		slot0 = LeanTween.scale(rtf(slot0), , slot2 * slot3.timeScale)

		if slot3.timeScale then
			slot0:setOnComplete(System.Action(slot4))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.TweenRotate = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.rotate(rtf(slot0), , slot2 * slot3.timeScale):setLoopPingPong(slot3.timeScale)

		if slot5 then
			slot0:setOnComplete(System.Action(slot5))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.TweenValueForcanvasGroup = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.value(go(slot0), , , slot3 * slot4.timeScale):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
		end))

		if slot4.timeScale then
			slot0.setOnComplete(slot0, System.Action(slot5))
		end

		table.insert(slot4.tweens, slot0.gameObject.transform)
	end)
end

slot0.TweenValue = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.value(go(slot0), , , slot3 * slot4.timeScale):setOnUpdate(System.Action_float(slot4.timeScale))

		if slot6 then
			slot0:setOnComplete(System.Action(function ()
				if slot0 then
					slot0()
				end
			end))
		end

		table.insert(slot4.tweens, slot0)
	end)
end

slot0.TweenValueLoop = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.value(go(slot0), , , slot3 * slot4.timeScale):setOnUpdate(System.Action_float(slot4.timeScale)):setLoopClamp()

		if slot6 then
			slot0:setOnComplete(System.Action(function ()
				if slot0 then
					slot0()
				end
			end))
		end

		table.insert(slot4.tweens, slot0)
	end)
end

slot0.TweenTextAlpha = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.DelayCall(slot0, slot4, function ()
		slot0 = slot0(slot1, slot2, (LeanTween.textAlpha or 1) * LeanTween.textAlpha or 1.timeScale)

		if LeanTween.textAlpha or 1.timeScale then
			slot0:setOnComplete(System.Action(slot4))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.TweenAlpha = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.alpha(LeanTween.alpha, , slot2 * slot3.timeScale):setFrom(slot3.timeScale)

		if slot5 then
			slot0:setOnComplete(System.Action(slot5))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.TweenMovex = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.moveX(LeanTween.moveX, , slot2 * slot3.timeScale):setFrom(slot3.timeScale)

		if slot5 then
			slot0:setLoopPingPong(slot5)
		end

		if slot6 then
			slot0:setOnComplete(System.Action(slot6))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.TweenMovey = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot0.DelayCall(slot0, slot5, function ()
		slot0 = LeanTween.moveY(LeanTween.moveY, , slot2 * slot3.timeScale):setFrom(slot3.timeScale)

		if slot5 then
			slot0:setLoopPingPong(slot5)
		end

		if slot6 then
			slot0:setOnComplete(System.Action(slot6))
		end

		table.insert(slot3.tweens, slot0)
	end)
end

slot0.IsTweening = function (slot0, slot1)
	return LeanTween.isTweening(slot1)
end

slot0.CancelTween = function (slot0, slot1)
	if slot0:IsTweening(slot1) then
		LeanTween.cancel(slot1)
	end
end

slot0.DelayCall = function (slot0, slot1, slot2)
	if not slot1 or slot1 <= 0 then
		slot2()

		return
	end

	slot0.timers[slot2] = StoryTimer.New(function ()
		slot0.timers[slot1]:Stop()

		slot0.timers[slot1].Stop.timers[slot0.timers[slot1]] = nil

		slot0.timers[slot1]()
	end, slot1 * slot0.timeScale, 1)

	slot0.timers[slot2].Start(slot3)
end

slot0.UnscaleDelayCall = function (slot0, slot1, slot2)
	if slot1 <= 0 then
		slot2()

		return
	end

	slot0.timers[slot2] = StoryTimer.New(function ()
		slot0.timers[slot1]:Stop()

		slot0.timers[slot1].Stop.timers[slot0.timers[slot1]] = nil

		slot0.timers[slot1]()
	end, slot1, 1)

	slot0.timers[slot2]:Start()
end

slot0.CreateDelayTimer = function (slot0, slot1, slot2)
	if slot1 == 0 then
		slot2()

		return nil
	end

	slot3 = StoryTimer.New(slot2, slot1 * slot0.timeScale, 1)

	slot3:Start()

	return slot3
end

slot0.PauseAllTween = function (slot0)
	for slot4, slot5 in ipairs(slot0.tweens) do
		if not IsNil(slot5) and slot0:IsTweening(slot5.gameObject) then
			LeanTween.pause(slot5.gameObject)
		end
	end
end

slot0.ResumeAllTween = function (slot0)
	for slot4, slot5 in ipairs(slot0.tweens) do
		if not IsNil(slot5) then
			LeanTween.resume(slot5.gameObject)
		end
	end
end

slot0.PauseAllTimer = function (slot0)
	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Pause()
	end
end

slot0.ResumeAllTimer = function (slot0)
	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Resume()
	end
end

slot0.ResumeAllAnimation = function (slot0)
	slot0:ResumeAllTween()
	slot0:ResumeAllTimer()
end

slot0.PauseAllAnimation = function (slot0)
	slot0:PauseAllTween()
	slot0:PauseAllTimer()
end

slot0.ClearAllTween = function (slot0)
	for slot4, slot5 in ipairs(slot0.tweens) do
		if not IsNil(slot5) and slot0:IsTweening(slot5.gameObject) then
			LeanTween.cancel(slot5.gameObject)
		end
	end

	slot0.tweens = {}
end

slot0.ClearAllTimers = function (slot0)
	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Stop()
	end

	slot0.timers = {}
end

slot0.ClearAnimation = function (slot0)
	slot0:ClearAllTween()
	slot0:ClearAllTimers()
end

return slot0

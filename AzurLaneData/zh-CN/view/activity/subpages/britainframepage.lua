slot0 = class("BritainframePage", import(".TemplatePage.PtTemplatePage"))

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	setActive(slot0.displayBtn, false)
	setActive(slot0.awardTF, false)
	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)

	slot0.step = slot0.findTF(slot0, "AD/switcher/phase2/background/step")
	slot0.progress = slot0:findTF("AD/switcher/phase2/background/progress")
	slot0.switchBtn = slot0:findTF("AD/switcher/switch_btn")
	slot0.bar = slot0:findTF("AD/switcher/phase2/background/barContent/bar")
	slot0.phases = {
		slot0:findTF("AD/switcher/phase1"),
		slot0:findTF("AD/switcher/phase2")
	}
	slot0.inPhase2 = false

	onToggle(slot0, slot0.switchBtn, function (slot0)
		if slot0.isSwitching then
			return
		end

		slot0.inPhase2 = slot0

		slot0:Switch(slot0)
	end, SFX_PANEL)

	if pg.TimeMgr.GetInstance():inTime(slot0.activity.getConfig(slot1, "config_client")) then
		triggerToggle(slot0.switchBtn, true)
	end
end

slot0.Switch = function (slot0, slot1)
	slot0.isSwitching = true
	slot2 = GetOrAddComponent(slot0.phases[1], typeof(CanvasGroup))
	slot3 = slot0.phases[1].localPosition

	slot0.phases[2]:SetAsLastSibling()
	setActive(slot0.phases[1]:Find("background"), false)
	LeanTween.moveLocal(go(slot0.phases[1]), slot4, 0.4)
	LeanTween.value(go(slot0.phases[1]), 0, 1, 0.4):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))
	setActive(slot0.phases[2].Find(slot6, "background"), true)

	slot5 = GetOrAddComponent(slot0.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(slot0.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))
	LeanTween.moveLocal(go(slot0.phases[2]), slot3, 0.4):setOnComplete(System.Action(function ()
		slot0.isSwitching = nil
		slot0.phases[2] = slot0.phases[1]
		slot0.phases[1] = slot0.phases[2]
	end))
	slot0.UpdateAwardGot(slot0)
end

slot0.UpdateAwardGot = function (slot0)
	setActive(slot0:findTF("switcher/phase2/background/got", slot0.bg), not slot0.ptData:CanGetNextAward() and slot0.inPhase2)

	slot3 = slot0.bg:Find("switcher/phase2/background")

	setActive(slot3:Find("progress"), not (not slot0.ptData.CanGetNextAward() and slot0.inPhase2))
	setActive(slot3:Find("step"), not (not slot0.ptData.CanGetNextAward() and slot0.inPhase2))
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	setActive(slot0.battleBtn, isActive(slot0.battleBtn) and pg.TimeMgr.GetInstance():inTime(slot2))
	slot0:UpdateAwardGot()

	slot4, slot5, slot6 = slot0.ptData:GetResProgress()

	setText(slot0.step, (slot6 >= 1 and setColorStr(slot4, "#487CFFFF")) or slot4)
	setText(slot0.progress, "/" .. slot5)
	setFillAmount(slot0.bar, slot4 / slot5)
end

return slot0

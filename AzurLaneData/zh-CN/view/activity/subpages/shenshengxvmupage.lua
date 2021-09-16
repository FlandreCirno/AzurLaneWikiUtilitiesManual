slot0 = class("ShenshengxvmuPage", import(".TemplatePage.PtTemplatePage"))

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	setActive(slot0.displayBtn, false)
	setActive(slot0.awardTF, false)
	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	setActive(slot0.battleBtn, isActive(slot0.battleBtn) and pg.TimeMgr.GetInstance():inTime(slot2))
	setActive(setActive, not slot0.ptData:CanGetNextAward())

	slot5, slot6, slot7 = slot0.ptData:GetResProgress()

	setText(slot0.step, (slot7 >= 1 and setColorStr(slot5, COLOR_GREEN)) or slot5)
	setText(slot0.progress, "/" .. slot6)
end

return slot0

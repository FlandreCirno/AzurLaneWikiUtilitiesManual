slot0 = class("HMSHardyTaskPage", import(".TemplatePage.PassChaptersTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.notGetBtn = slot0:findTF("not_get_btn", slot0.bg)
	slot0.goHuntBtn = slot0:findTF("gohunt_btn", slot0.bg)
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	onButton(slot0, slot0.goHuntBtn, function ()
		slot0:emit(ActivityMediator.SELECT_ACTIVITY, pg.activity_const.HMS_Hunter_PT_ID.act_id)
	end, SFX_PANEL)
	onButton(slot0, slot0.notGetBtn, function ()
		slot0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(slot0, slot0.battleBtn, function ()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(slot0, slot0.buildBtn, function ()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.LIGHT
		})
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	updateDrop(slot0.awardTF, slot2)
	onButton(slot0, slot0.awardTF, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)

	if slot0.step then
		setText(slot0.step, slot0.taskIndex)
	end

	setText(slot0.desc, slot0.taskVO:getConfig("desc"))
	setText(slot0.progress, slot3 .. "/" .. slot4)
	setSlider(slot0.slider, 0, slot0.taskVO:getConfig("target_num"), slot0.taskVO.getProgress(slot3))
	setActive(slot0.notGetBtn, slot0.taskVO:getTaskStatus() == 0)
	setActive(slot0.getBtn, slot5 == 1)
	setActive(slot0.gotBtn, slot5 == 2)
end

return slot0

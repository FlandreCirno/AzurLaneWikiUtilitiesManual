slot0 = class("PassChaptersTemplatePage", import("view.base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.slider = slot0:findTF("slider", slot0.bg):GetComponent(typeof(Slider))
	slot0.step = slot0:findTF("step", slot0.bg):GetComponent(typeof(Text))
	slot0.progress = slot0:findTF("progress", slot0.bg):GetComponent(typeof(Text))
	slot0.desc = slot0:findTF("desc", slot0.bg):GetComponent(typeof(Text))
	slot0.awardTF = slot0:findTF("award", slot0.bg)
	slot0.battleBtn = slot0:findTF("battle_btn", slot0.bg)
	slot0.getBtn = slot0:findTF("get_btn", slot0.bg)
	slot0.gotBtn = slot0:findTF("got_btn", slot0.bg)
	slot0.buildBtn = slot0:findTF("build_btn", slot0.bg)
end

slot0.OnDataSetting = function (slot0)
	slot1 = getProxy(TaskProxy)
	slot0.taskList = slot0.taskList or slot0.activity:getConfig("config_data")

	for slot5, slot6 in ipairs(slot0.taskList) do
		slot0.taskIndex = slot5
		slot0.taskVO = slot1:getTaskVO(slot6)

		if not slot0.taskVO:isReceive() then
			break
		end
	end
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(slot0, slot0.getBtn, function ()
		slot0:emit(ActivityMediator.ON_TASK_SUBMIT, slot0.taskVO)
	end, SFX_PANEL)
	onButton(slot0, slot0.buildBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	updateDrop(slot0.awardTF, slot2)
	onButton(slot0, slot0.awardTF, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)

	if slot0.step then
		setText(slot0.step, slot0.taskIndex .. "/" .. #slot0.taskList)
	end

	setText(slot0.desc, slot0.taskVO:getConfig("desc"))
	setText(slot0.progress, slot3 .. "/" .. slot4)
	setSlider(slot0.slider, 0, slot0.taskVO:getConfig("target_num"), slot0.taskVO.getProgress(slot3))
	setActive(slot0.battleBtn, slot0.taskVO:getTaskStatus() == 0)
	setActive(slot0.getBtn, slot5 == 1)
	setActive(slot0.gotBtn, slot5 == 2)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

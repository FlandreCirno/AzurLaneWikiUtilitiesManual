slot0 = class("JamaicaSkinPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.slider = slot0:findTF("slider", slot0.bg)
	slot0.step = slot0:findTF("step", slot0.bg)
	slot0.progress = slot0:findTF("progress", slot0.bg)
	slot0.awardTF = slot0:findTF("award", slot0.bg)
	slot0.battleBtn = slot0:findTF("battle_btn", slot0.bg)
	slot0.getBtn = slot0:findTF("get_btn", slot0.bg)
	slot0.gotBtn = slot0:findTF("got_btn", slot0.bg)
end

slot0.OnDataSetting = function (slot0)
	slot0.taskIDList = _.flatten(slot1)
	slot0.dropList = {}
	slot0.descs = {}

	for slot5, slot6 in ipairs(slot0.taskIDList) do
		table.insert(slot0.dropList, Clone(slot7))
		table.insert(slot0.descs, pg.task_data_template[slot6].desc)
	end

	return updateActivityTaskStatus(slot0.activity)
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(slot0, slot0.getBtn, function ()
		slot0:emit(ActivityMediator.ON_TASK_SUBMIT, slot0.curTaskVO)
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	slot1, slot0.curTaskVO = getActivityTask(slot0.activity)

	updateDrop(slot0.awardTF, slot4)
	onButton(slot0, slot0.awardTF, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	setText(slot0.progress, ((slot2:getConfig("target_num") <= slot2.getProgress(slot2) and setColorStr(slot5, COLOR_GREEN)) or slot5) .. "/" .. slot6)
	setSlider(slot0.slider, 0, slot6, slot5)
	setText(slot0.step, setText .. "/" .. #slot0.taskIDList)
	setActive(slot0.battleBtn, slot2:getTaskStatus() == 0)
	setActive(slot0.getBtn, slot0.progress == 1)
	setActive(slot0.gotBtn, slot0.progress == 2)

	if slot8 == 2 then
		slot0.finishedIndex = slot7
	else
		slot0.finishedIndex = slot7 - 1
	end
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

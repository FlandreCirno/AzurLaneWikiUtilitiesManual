slot0 = class("JiuJiuExpeditionPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.slider = slot0:findTF("slider", slot0.bg)
	slot0.step = slot0:findTF("step", slot0.bg)
	slot0.progress = slot0:findTF("progress", slot0.bg)
	slot0.awardTF = slot0:findTF("award", slot0.bg)
	slot0.battleBtn = slot0:findTF("battle_btn", slot0.bg)
	slot0.getBtn = slot0:findTF("get_btn", slot0.bg)
	slot0.gotBtn = slot0:findTF("got_btn", slot0.bg)
	slot0.help = slot0:findTF("help", slot0.bg)
	slot0.book = slot0:findTF("book", slot0.bg)
	slot0.startGame = slot0:findTF("startGame", slot0.bg)
	slot0.desc = slot0:findTF("desc", slot0.bg)
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
		if slot0.curTaskVO then
			slot0:emit(ActivityMediator.ON_TASK_GO, slot0.curTaskVO)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.getBtn, function ()
		slot0:emit(ActivityMediator.ON_TASK_SUBMIT, slot0.curTaskVO)
	end, SFX_PANEL)
	onButton(slot0, slot0.help, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.jiujiu_expedition_help.tip
		})
	end, SFX_PANEL)

	if PLATFORM_CODE ~= PLATFORM_JP then
		setActive(slot0.book, false)
	else
		slot1, slot2, slot3, slot4 = JiuJiuExpeditionCollectionMediator.GetCollectionData()

		setActive(findTF(slot0.book, "tip"), slot4 < slot3)
		onButton(slot0, slot0.book, function ()
			slot0:emit(ActivityMediator.OPEN_LAYER, Context.New({
				viewComponent = JiuJiuExpeditionCollectionLayer,
				mediator = JiuJiuExpeditionCollectionMediator
			}))
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.startGame, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.JIUJIU_EXPEDITION)
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	slot1, slot0.curTaskVO = getActivityTask(slot0.activity)

	setText(slot0.desc, slot0.curTaskVO:getConfig("desc"))
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

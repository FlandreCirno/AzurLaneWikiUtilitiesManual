slot0 = class("FrameTemplatePage", import("view.base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.battleBtn = slot0:findTF("battle_btn", slot0.bg)
	slot0.getBtn = slot0:findTF("get_btn", slot0.bg)
	slot0.gotBtn = slot0:findTF("got_btn", slot0.bg)
	slot0.switchBtn = slot0:findTF("AD/switch_btn")
	slot0.phases = {
		slot0:findTF("AD/switcher/phase1"),
		slot0:findTF("AD/switcher/phase2")
	}
	slot0.bar = slot0:findTF("AD/switcher/phase2/Image/barContent/bar")
	slot0.step = slot0:findTF("AD/switcher/phase2/Image/step")
	slot0.progress = slot0:findTF("AD/switcher/phase2/Image/progress")
end

slot0.OnDataSetting = function (slot0)
	if slot0.ptData then
		slot0.ptData:Update(slot0.activity)
	else
		slot0.ptData = ActivityPtData.New(slot0.activity)
	end

	slot0.inPhase2 = false
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.getBtn, function ()
		slot3 = getProxy(PlayerProxy).getData(slot2)

		if slot0.ptData:GetAward().type == DROP_TYPE_RESOURCE and slot1.id == PlayerConst.ResGold and slot3:GoldMax(slot1.count) then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = slot0
				})
			end)
		end

		seriesAsync(slot0, function ()
			slot2, slot5.arg1 = slot0.ptData:GetResProgress()

			slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = slot0.ptData:GetId(),
				arg1 = slot1
			})
		end)
	end, SFX_PANEL)
	onToggle(slot0, slot0.switchBtn, function (slot0)
		if slot0.isSwitching then
			return
		end

		slot0.inPhase2 = slot0

		slot0:Switch(slot0)
	end, SFX_PANEL)
	setActive(slot0.battleBtn, pg.TimeMgr.GetInstance():inTime(slot1))

	if pg.TimeMgr.GetInstance().inTime(slot1) then
		triggerToggle(slot0.switchBtn, true)
	end
end

slot0.OnUpdateFlush = function (slot0)
	setActive(slot0.getBtn, slot1)
	setActive(slot0.gotBtn, not slot0.ptData:CanGetNextAward())

	slot3, slot4, slot5 = slot0.ptData:GetResProgress()

	setText(slot0.step, (slot5 >= 1 and setColorStr(slot3, COLOR_GREEN)) or slot3)
	setText(slot0.progress, "/" .. slot4)
	setFillAmount(slot0.bar, slot3 / slot4)
	slot0:UpdateAwardGot()
end

slot0.Switch = function (slot0, slot1)
	slot0.isSwitching = true
	slot2 = GetOrAddComponent(slot0.phases[1], typeof(CanvasGroup))

	slot0.phases[2]:SetAsLastSibling()
	setActive(slot0.phases[1]:Find("Image"), false)
	LeanTween.moveLocal(go(slot0.phases[1]), slot4, 0.4):setOnComplete(System.Action(function ()
		setActive(slot0.phases[1]:Find("label"), true)
	end))
	LeanTween.value(go(slot0.phases[1]), 0, 1, 0.4).setOnUpdate(slot5, System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))
	setActive(slot0.phases[2].Find(slot6, "Image"), true)

	slot5 = GetOrAddComponent(slot0.phases[2], typeof(CanvasGroup))

	LeanTween.value(go(slot0.phases[2]), 0, 1, 0.4):setOnUpdate(System.Action_float(function (slot0)
		slot0.alpha = slot0
	end))
	setActive(slot0.phases[2].Find(slot7, "label"), false)
	LeanTween.moveLocal(go(slot0.phases[2]), slot3, 0.4):setOnComplete(System.Action(function ()
		slot0.isSwitching = nil
		slot0.phases[2] = slot0.phases[1]
		slot0.phases[1] = slot0.phases[2]
	end))
	slot0.UpdateAwardGot(slot0)
end

slot0.UpdateAwardGot = function (slot0)
	setActive(slot0:findTF("switcher/phase2/got", slot0.bg), not slot0.ptData:CanGetNextAward() and slot0.inPhase2)

	if slot2 then
		setActive(slot0.battleBtn, false)
	end
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

slot0 = class("LanternRiddlesView")

slot0.Ctor = function (slot0, slot1)
	slot0.controller = slot1

	pg.DelegateInfo.New(slot0)
end

slot0.SetUI = function (slot0, slot1)
	slot0._tf = slot1
	slot0.questioneTFs = {}

	for slot5, slot6 in ipairs(pg.activity_event_question.all) do
		slot0.questioneTFs[slot6] = slot0:findTF("labels/label" .. slot5)
	end

	slot0.mainPanel = slot0:findTF("main")
	slot0.day = slot0:findTF("time/Text"):GetComponent(typeof(Text))
	slot0:findTF("frame/time", slot0.mainPanel):GetComponent(typeof(Text)).text = i18n("LanternRiddle_wait_time_tip")

	setActive(slot0.mainPanel, false)
	onButton(slot0, slot0.mainPanel, function ()
		slot0:HideMainPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("back"), function ()
		slot0.controller:ExitGame()
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("back/help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.lanternRiddles_gametip.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("option"), function ()
		slot0.controller:ExitGameAndGoHome()
	end, SFX_PANEL)
end

slot0.UpdateDay = function (slot0, slot1)
	slot0.day.text = math.min(slot1, 7)
end

slot0.InitLanternRiddles = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		slot8 = slot6.isUnlock

		onButton(slot0, slot7, function ()
			if not slot0 then
				return
			end

			slot1:ShowMainPanel(slot2)
		end, SFX_PANEL)
		setActive(slot0.questioneTFs[slot6.id].Find(slot7, "finish"), slot6.isFinish)

		if LeanTween.isTweening(go(slot0.questioneTFs[slot6.id])) then
			LeanTween.cancel(go(slot7))
		end

		slot9 = slot7:Find("image")

		if slot8 and not slot6.isFinish then
			LeanTween.rotateZ(go(slot7), 10, 2):setLoopPingPong(0):setFrom(0)
		end

		setActive(slot9, slot8)
	end
end

slot0.RefreshLanterRiddles = function (slot0, slot1)
	slot0:InitLanternRiddles(slot1)
end

slot0.ShowMainPanel = function (slot0, slot1)
	pg.UIMgr.GetInstance():BlurPanel(slot0.mainPanel)
	setActive(slot0.mainPanel, true)
	setActive(slot0:findTF("frame/label_game", slot0.mainPanel), slot1.type == 2)
	setActive(slot0:findTF("frame/label_his", slot0.mainPanel), slot1.type == 1)
	setText(slot0:findTF("frame/Text", slot0.mainPanel), slot1.text)
	slot0:UpdateMainPanelTime()

	slot2 = slot1.answers
	slot3 = slot0:findTF("frame/answers", slot0.mainPanel)
	slot4 = slot1.isFinish

	for slot8 = 1, 4, 1 do
		slot11 = slot3:GetChild(slot8 - 1)

		setText(slot11:Find("Text"), slot9)
		setActive(slot11:Find("right"), slot4 and slot8 == slot1.rightIndex)
		setActive(slot11:Find("false"), slot2[slot8][2])
		onButton(slot0, slot11, function ()
			if slot0.isFinish then
				return
			end

			if slot1 then
				return
			end

			if pg.TimeMgr.GetInstance():GetServerTime() < slot2.controller:GetLockTime() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_wait_for_reanswer"))

				return
			end

			slot2.controller:SelectAnswer(slot0.id, slot2.controller)
		end, SFX_PANEL)
	end
end

slot0.UpdateMainPanelTime = function (slot0)
	slot0:RemoveTimer()
	setActive(slot0:findTF("frame/time", slot0.mainPanel), pg.TimeMgr.GetInstance():GetServerTime() <= slot0.controller:GetLockTime())

	if pg.TimeMgr.GetInstance().GetServerTime() <= slot0.controller.GetLockTime() then
		slot0:AddTimer()
	end
end

slot0.OnUpdateAnswer = function (slot0, slot1, slot2, slot3)
	slot5 = slot0:findTF("frame/answers", slot0.mainPanel).GetChild(slot4, slot2 - 1)

	setActive(slot5:Find("right"), slot3)
	setActive(slot5:Find("false"), not slot3)

	if not slot3 then
		slot0:UpdateMainPanelTime()
		pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_answer_is_wrong"))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("lanternRiddles_answer_is_right"))
		setActive(slot0.questioneTFs[slot1.id].Find(slot6, "finish"), slot1.isFinish)

		if LeanTween.isTweening(go(slot0.questioneTFs[slot1.id])) then
			LeanTween.cancel(go(slot6))
		end
	end
end

slot0.HideMainPanel = function (slot0)
	slot0:RemoveTimer()
	setActive(slot0.mainPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.mainPanel, slot0._tf)
end

slot0.AddTimer = function (slot0)
	slot1 = slot0.controller:GetLockTime()
	slot2 = slot0:findTF("frame/time/Text", slot0.mainPanel):GetComponent(typeof(Text))
	slot0.timer = Timer.New(function ()
		if slot0 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			slot1:RemoveTimer()
			setActive(slot1:findTF("frame/time", slot1.mainPanel), false)
		else
			slot2.text = pg.TimeMgr.GetInstance():DescCDTime(slot1)
		end
	end, 1, -1)

	slot0.timer.Start(slot3)
	slot0.timer.func()
end

slot0.RemoveTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.Dispose = function (slot0)
	slot0:RemoveTimer()
	slot0:HideMainPanel()
	pg.DelegateInfo.Dispose(slot0)
end

slot0.findTF = function (slot0, slot1, slot2)
	return findTF(slot2 or slot0._tf, slot1)
end

return slot0

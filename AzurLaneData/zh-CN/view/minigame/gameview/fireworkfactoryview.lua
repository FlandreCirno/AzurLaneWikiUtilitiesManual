slot0 = class("FireworkFactoryView", import("..BaseMiniGameView"))
slot1 = Mathf

slot0.getUIName = function (slot0)
	return "FireworkFactoryUI"
end

slot0.MINIGAME_ID = 4
slot2 = 50
slot3 = {
	{
		color = "FFD26FFF",
		name = "na"
	},
	{
		color = "DE89ECFF",
		name = "k"
	},
	{
		color = "8F77DFFF",
		name = "rb"
	},
	{
		color = "70ad9f",
		name = "zn"
	},
	{
		color = "FF7069FF",
		name = "ca"
	},
	{
		color = "7faf6e",
		name = "cu"
	}
}
slot4 = {
	"s",
	"a",
	"b",
	"c"
}

slot0.TransformColor = function (slot0)
	return Color.New(tonumber(string.sub(slot0, 1, 2), 16) / 255, tonumber(string.sub(slot0, 3, 4), 16) / 255, tonumber(string.sub(slot0, 5, 6), 16) / 255)
end

slot0.init = function (slot0)
	slot0.top = slot0:findTF("top")
	slot0.plate = slot0:findTF("plate")
	slot0.storage = slot0:findTF("storage")
	slot0.dispenseView = slot0:findTF("top/dispenseView")

	setActive(slot0.dispenseView, false)

	slot0.resultWindow = slot0:findTF("top/resultwindow")

	setActive(slot0.resultWindow, false)

	slot0.btn_back = slot0.top:Find("noAdaptPanel/back")
	slot0.btn_help = slot0.top:Find("noAdaptPanel/title/help")
	slot0.timesText = slot0.top:Find("times/text")
	slot0.ballPlate = slot0.plate:Find("ball_plate")
	slot0.plateRings = {}

	for slot4 = 1, 3, 1 do
		table.insert(slot0.plateRings, slot0.ballPlate:GetChild(slot4))
	end

	slot0.btn_load = slot0.plate:Find("btn_load")
	slot0.ballSelectPanel = slot0.plate:Find("panel/layout")
	slot0.ballSelects = slot0:Clone2Full(slot0.ballSelectPanel, 3)
	slot0.ballSelectStatus = {
		0,
		0,
		0
	}
	slot0.lastSelectedBall = nil
	slot0.ballStoragePanel = slot0.storage:Find("house/layout")
	slot0.ballStorages = slot0:Clone2Full(slot0.ballStoragePanel, 6)
	slot0.screen_mask = slot0:findTF("mask")
	slot0.btn_next = slot0:findTF("Button")
	slot0.btn_next_text = slot0.btn_next:Find("Image")
	slot0.desc_dispense = slot0.dispenseView:Find("intro/Scroll View/Viewport/text")

	setText(slot0.desc_dispense, i18n("help_firework_produce"))

	slot0.btn_dispenseBG = slot0.dispenseView:Find("bg")
	slot0.btn_hammer = slot0.dispenseView:Find("container/Button")
	slot0.btn_hammer_text = slot0.btn_hammer:Find("text")
	slot0.slider_powder = slot0.dispenseView:Find("container/Slider/Fill Area"):GetComponent("Slider")
	slot0.slider_progress = slot0.dispenseView:Find("progress/Slider"):GetComponent("Slider")
	slot0.slider_progress_bg = slot0.dispenseView:Find("progress/Slider/Background/progressdi")
	slot0.slider_bubble = slot0.dispenseView:Find("container/Slider/Fill Area/Fill/handler/bubble")
	slot0.slider_bubble_text = slot0.slider_bubble:Find("text")
	slot0.progress_width = slot0.dispenseView:Find("progress/Slider/Handle Slide Area").rect.width
	slot0.progress_sub_mark_1 = slot0.dispenseView:Find("progress/Slider/Handle Slide Area/submark1")
	slot0.progress_sub_mark_2 = slot0.dispenseView:Find("progress/Slider/Handle Slide Area/submark2")
	slot0.progress_dis = {}

	for slot4 = 0, slot0.slider_progress_bg.childCount - 1, 1 do
		table.insert(slot0.progress_dis, slot0.slider_progress_bg:GetChild(slot4))
	end

	slot0.result_digits = {}

	pg.PoolMgr.GetInstance():GetPrefab("ui/light01", "", true, function (slot0)
		tf(slot0):SetParent(slot0.dispenseView, false)
		slot0:SetActive(false)

		slot0.effect_light = slot0
	end)

	slot0.result_bg = slot0.resultWindow.Find(slot1, "bg")
	slot0.result_desc = slot0.resultWindow:Find("window/Text")

	setText(slot0.result_desc, i18n("result_firework_produce"))

	slot0.btn_result_confirm = slot0.resultWindow:Find("window/button")
	slot0.result_pingjia = slot0.resultWindow:Find("window/pingjia"):GetComponent("Image")
	slot0.flagStart = false
	slot0.flagDispense = false
	slot0.progressDispense = 0
end

slot0.SetSprite = function (slot0, slot1, slot2)
	slot0:SetImageSprite(slot1:GetComponent("Image"), slot2)
end

slot0.SetImageSprite = function (slot0, slot1, slot2)
	pg.PoolMgr.GetInstance():GetSprite("ui/fireworkfactoryui_atlas", slot2, false, function (slot0)
		slot0.sprite = slot0
	end)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.btn_back, function ()
		if slot0.flagDispense then
			slot0:ExitDispenseView()
		elseif slot0:CheckpowderDispensed() and slot0.flagStart then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tips_firework_exit"),
				onYes = function ()
					slot0:emit(slot1.ON_BACK_PRESSED)
				end
			})
		else
			slot0.emit(slot0, slot1.ON_BACK)
		end
	end)
	onButton(slot0, slot0.btn_dispenseBG, function ()
		slot0:ExitDispenseView()
	end)
	onButton(slot0, slot0.btn_help, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_firework.tip
		})
	end)
	onButton(slot0, slot0.btn_next, function ()
		if not slot0.flagStart then
			slot0.flagStart = true

			slot0:UpdateNextBtn()
		elseif slot0:CheckballLoaded() then
			slot0:EnterDispenseView()
		end
	end)
	onButton(slot0, slot0.btn_hammer, function ()
		if slot0.progressDispense == 0 then
			slot0:ResetHammerAnim()
			slot0:FindNextPowderProgress()
			slot0:UpdateContainer()
		elseif slot0 == 1 then
			slot0.result_digits[1] = slot0.slider_powder.value * 100

			slot0:FindandStopProgress()
			slot0:UpdateContainer()
		elseif slot0 == 2 then
			slot0.result_digits[2] = slot0.slider_powder.value * 100

			slot0:FindandStopProgress()
			slot0:UpdateContainer()
		elseif slot0 == 3 then
			slot0.result_digits[3] = slot0.slider_powder.value * 100

			slot0:FindandStopProgress()
			slot0:UpdateContainer()
		end
	end)
	onButton(slot0, slot0.btn_result_confirm, function ()
		slot0:ShowResult()
	end)
	onButton(slot0, slot0.result_bg, function ()
		slot0:ShowResult()
	end)

	for slot4 = 1, #slot0.ballStorages, 1 do
		slot0.UpdateBall(slot0, slot5, slot4)
		onButton(slot0, slot0.ballStorages[slot4].Find(slot5, "mask"), function ()
			if not slot0.lastSelectedBall or slot0.lastSelectedBall <= 0 then
				return
			end

			slot0.ballSelectStatus[slot0.lastSelectedBall] = slot0.lastSelectedBall

			slot0.ballSelectStatus:UpdateRing(slot0.lastSelectedBall, slot0.ballSelectStatus)
			slot0.ballSelectStatus.UpdateRing:UpdateBall(slot0.ballSelects[slot0.lastSelectedBall]:Find("ball"), slot0.ballSelectStatus.UpdateRing)
			slot0.ballSelectStatus.UpdateRing.UpdateBall:UdpateSelectedBall(slot0.lastSelectedBall + 1)
			slot0.ballSelectStatus.UpdateRing.UpdateBall.UdpateSelectedBall:UpdateNextBtn()
		end)
	end

	for slot4 = 1, #slot0.ballSelects, 1 do
		slot0.UpdateBall(slot0, slot0.ballSelects[slot4].Find(slot5, "ball"), 0)
		slot0:UpdateRing(slot4, 0)
		onButton(slot0, slot0.ballSelects[slot4].Find(slot5, "mask"), function ()
			slot0.ballSelectStatus[slot1] = 0

			slot0.ballSelectStatus:UpdateBall(slot0.ballSelects[slot1]:Find("ball"), 0)
			slot0.ballSelectStatus.UpdateBall:UpdateRing(slot0.ballSelectStatus.UpdateBall, 0)
			slot0.ballSelectStatus.UpdateBall.UpdateRing:UdpateSelectedBall(slot0.ballSelectStatus.UpdateBall.UpdateRing)
			slot0.ballSelectStatus.UpdateBall.UpdateRing.UdpateSelectedBall:UpdateNextBtn()
		end)
	end

	slot0.ResetView(slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.top, {
		groupName = LayerWeightConst.GROUP_FIREWORK_PRODUCE
	})

	slot3 = {
		0
	}

	for slot7, slot8 in ipairs(slot2) do
		slot3[#slot2 - slot7 + 2] = slot8[1]
		slot3[#slot2 + slot7 + 1] = slot8[2]
	end

	slot3[#slot3] = 300

	for slot7 = 1, #slot3 - 1, 1 do
		slot0.progress_dis[slot7].anchorMin = Vector2(slot8, 0)
		slot0.progress_dis[slot7].anchorMax = Vector2(slot3[slot7 + 1] / 300, 1)
		slot0.progress_dis[slot7].sizeDelta = Vector2.zero
	end
end

slot0.UpdateNextBtn = function (slot0)
	if not slot0.flagStart then
		slot1 = "dispense_ready"

		if slot0:GetMGData():GetRuntimeData("elements") and #slot3 > 3 and slot3[4] == SummerFeastScene.GetCurrentDay() then
			slot1 = "dispense_retry"
		end

		slot0:SetSprite(slot0.btn_next_text, slot1)
	else
		slot0:SetSprite(slot0.btn_next_text, "dispense_confirm")
	end

	setActive(slot0.screen_mask, not slot0.flagStart)
	setButtonEnabled(slot0.btn_next, not slot0.flagStart or slot0:CheckballLoaded())
end

slot0.UpdateDispenseBtn = function (slot0)
	slot0:SetImageSprite(slot0.btn_load_img, (slot0:CheckpowderDispensed() and "btn_loadcompleted") or "btn_load")
	slot0:SetSprite(slot0.btn_load_text, (slot1 and "load_completed") or "load_ready")
	setButtonEnabled(slot0.btn_load, not slot1)
end

slot5 = {
	"start",
	"first_time",
	"second_time",
	"third_time",
	"finish_time"
}

slot0.FindandStopProgress = function (slot0)
	slot0:StopHammerAnim()
	setButtonEnabled(slot0.btn_hammer, false)
	setButtonEnabled(slot0.btn_dispenseBG, false)
	setText(slot0.slider_bubble_text, math.ceil(slot0.result_digits[#slot0.result_digits]) .. "%")
	setActive(slot0.slider_bubble, true)
	setActive(slot0.effect_light, true)

	slot0.progressDispense = (#slot0.result_digits >= 3 and 4) or 0
	slot1 = 0

	for slot5 = 1, 3, 1 do
		if slot0.result_digits[slot5] then
			slot1 = slot1 + slot6
		end
	end

	slot2 = 0

	for slot6 = 1, #slot0.result_digits - 1, 1 do
		if slot0.result_digits[slot6] then
			slot2 = slot2 + slot7

			if slot6 == 1 then
				setActive(slot0.progress_sub_mark_1, true)

				slot0.progress_sub_mark_1.anchoredPosition = Vector2((slot0.progress_width * slot2) / 300, 27)
			elseif slot6 == 2 then
				setActive(slot0.progress_sub_mark_2, true)

				slot0.progress_sub_mark_2.anchoredPosition = Vector2((slot0.progress_width * slot2) / 300, 27)
			end
		end
	end

	slot3 = slot0.slider_bubble.transform.position
	slot4 = slot0.slider_progress.transform.position
	slot5 = slot0.slider_progress.value
	slot0.progressAnim = LeanTween.value(slot0.slider_progress.gameObject, 0, 1, 1.5):setEase(LeanTweenType.linear):setOnUpdate(System.Action_float(function (slot0)
		slot0.slider_progress.value = slot1.Lerp(slot1.Lerp, slot3 / 300, slot0)

		if slot0.effect_light then
			slot0.effect_light.transform.position = Vector3.Lerp(slot4, slot5, slot0 * 3) - Vector3(0, 0, 2)

			if slot0 * 3 > 1 then
				setActive(slot0.effect_light, false)
			end
		end
	end)).setOnComplete(slot6, System.Action(function ()
		setButtonEnabled(slot0.btn_hammer, true)
		setButtonEnabled(slot0.btn_dispenseBG, true)

		if setButtonEnabled.progressDispense > 3 then
			slot0:FindNextPowderProgress()
		end
	end))
end

slot0.FindNextPowderProgress = function (slot0)
	slot0.progressDispense = #slot0.result_digits + 1

	if slot0.progressDispense > 3 then
		slot0:StopHammerAnim()
		setButtonEnabled(slot0.btn_hammer, false)
		slot0:ShowResultWindow()
	end
end

slot0.ShowResultWindow = function (slot0)
	if #slot0.result_digits < 3 then
		return
	end

	setActive(slot0.resultWindow, true)

	slot2 = slot0:GetMGData().GetSimpleValue(slot1, "score_reference")
	slot3 = 0

	for slot7 = 1, 3, 1 do
		slot3 = slot3 + slot0.result_digits[slot7]
	end

	slot4 = 4

	for slot8, slot9 in ipairs(slot2) do
		if slot9[1] <= slot3 and slot3 <= slot9[2] then
			slot4 = slot8

			break
		end
	end

	if slot4 <= 0 then
		return
	end

	slot0:SetImageSprite(slot0.result_pingjia, slot0[slot4])
end

slot0.ShowResult = function (slot0)
	if slot0:GetMGHubData().count <= 0 then
		slot0:AfterResult()
	else
		slot0:GetReward()
	end

	setActive(slot0.resultWindow, false)
end

slot0.OnGetAwardDone = function (slot0, slot1)
	slot3 = slot0:GetMGHubData().ultimate == 0 and slot2:getConfig("reward_need") <= slot2.usedtime

	if slot1.cmd == MiniGameOPCommand.CMD_COMPLETE and slot3 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = slot2.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	elseif slot1.cmd == MiniGameOPCommand.CMD_ULTIMATE then
		pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI2", function ()
			slot0:AfterResult()
		end)
	else
		slot0.AfterResult(slot0)
	end
end

slot0.AfterResult = function (slot0)
	slot1 = slot0:GetMGData()

	table.insert(slot3, slot2)
	slot0:StoreDataToServer(Clone(slot0.ballSelectStatus))
	onNextTick(function ()
		slot0:emit(slot1.ON_BACK)
	end)
end

slot0.reset = function (slot0)
	slot0:ExitDispenseView()

	slot0.flagStart = false
	slot0.flagDispense = false
	slot0.progressDispense = 0
	slot0.result_digits = {}

	slot0:ResetView()
	slot0:UpdateNextBtn()
end

slot0.GetReward = function (slot0)
	if #slot0.result_digits < 3 then
		return
	end

	slot2 = slot0:GetMGData().GetSimpleValue(slot1, "score_reference")
	slot3 = 0

	for slot7 = 1, 3, 1 do
		slot3 = slot3 + slot0.result_digits[slot7]
	end

	slot4 = 4

	for slot8, slot9 in ipairs(slot2) do
		if slot9[1] <= slot3 and slot3 <= slot9[2] then
			slot4 = slot8

			break
		end
	end

	if slot4 <= 0 then
		return
	end

	slot0:SendSuccess(slot4)
end

slot0.ResetHammerAnim = function (slot0)
	if slot0.hammerAnim then
		slot0:StopHammerAnim()
	end

	setActive(slot0.slider_bubble, false)

	slot0.hammerAnim = LeanTween.value(slot0.slider_powder.gameObject, 0, 1, (slot0:GetMGData():GetSimpleValue("roundTime") or slot0) / 100 * 2):setEase(LeanTweenType.linear):setLoopPingPong():setOnUpdate(System.Action_float(function (slot0)
		slot0.slider_powder.value = slot0
	end))
end

slot0.StopHammerAnim = function (slot0)
	if not slot0.hammerAnim then
		return
	end

	LeanTween.cancel(slot0.hammerAnim.uniqueId)

	slot0.hammerAnim = nil
end

slot0.UpdateContainer = function (slot0)
	slot0:SetSprite(slot0.btn_hammer_text, slot0[slot0.progressDispense + 1])

	slot1 = 0
	slot2 = true

	for slot6 = 1, 3, 1 do
		slot2 = slot2 and slot0.result_digits[slot6] ~= nil

		if slot7 then
			slot1 = slot1 + slot7
		end
	end

	slot0.slider_progress.value = slot1 / 300
end

slot0.StopProgressAnim = function (slot0)
	if not slot0.progressAnim then
		return
	end

	LeanTween.cancel(slot0.progressAnim.uniqueId)

	slot0.progressAnim = nil
end

slot0.CheckballLoaded = function (slot0)
	return _.all(slot0.ballSelectStatus, function (slot0)
		return slot0 > 0
	end)
end

slot0.CheckpowderDispensed = function (slot0)
	return #slot0.result_digits >= 3
end

slot0.UpdateBall = function (slot0, slot1, slot2)
	setActive(slot1, slot2 > 0)

	if slot2 <= 0 then
		return
	end

	slot1:GetComponent("Image").color = slot0.TransformColor(slot0[slot2].color)

	slot0:SetSprite(slot1:Find("symbol"), slot0[slot2].name)
end

slot0.UpdateRing = function (slot0, slot1, slot2)
	if slot1 <= 0 or slot1 > 3 then
		return
	end

	setActive(slot0.plateRings[slot1], slot2 > 0)

	if slot2 <= 0 then
		return
	end

	slot3:GetComponent("Image").color = slot0.TransformColor(slot0[slot2].color)
end

slot0.ResetView = function (slot0)
	_.each(slot0.plateRings, function (slot0)
		setActive(slot0, false)
	end)
	_.each(slot0.ballSelects, function (slot0)
		setActive(slot0:Find("ball"), false)
		setActive(slot0:Find("selected"), false)
	end)
	setText(slot0.timesText, slot0.GetMGHubData(slot0).count)

	if slot0:GetMGData():GetRuntimeData("elements") and #slot3 > 3 and slot3[4] == SummerFeastScene.GetCurrentDay() then
		for slot7 = 1, 3, 1 do
			slot0.ballSelectStatus[slot7] = slot3[slot7]

			if slot3[slot7] > 0 then
				slot0:UpdateRing(slot7, slot8)
				slot0:UpdateBall(slot0.ballSelects[slot7]:Find("ball"), slot8)
			end
		end
	end

	slot0:UdpateSelectedBall(1)
	slot0:UpdateNextBtn()
	setActive(slot0.slider_bubble, false)
	setActive(slot0.progress_sub_mark_1, false)
	setActive(slot0.progress_sub_mark_2, false)
end

slot0.UdpateSelectedBall = function (slot0, slot1)
	if slot1 <= 0 or slot1 > 3 then
		return
	end

	if slot0.lastSelectedBall then
		if slot0.lastSelectedBall == slot1 then
			return
		end

		setActive(slot0.ballSelects[slot0.lastSelectedBall]:Find("selected"), false)
	end

	setActive(slot0.ballSelects[slot1]:Find("selected"), true)

	slot0.lastSelectedBall = slot1
end

slot0.Clone2Full = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = slot1:GetChild(0)

	for slot9 = 0, slot1.childCount - 1, 1 do
		table.insert(slot3, slot1:GetChild(slot9))
	end

	for slot9 = slot5, slot2 - 1, 1 do
		table.insert(slot3, tf(cloneTplTo(slot4, slot1)))
	end

	return slot3
end

slot0.EnterDispenseView = function (slot0)
	setActive(slot0.dispenseView, true)

	slot0.flagDispense = true
	slot0.progressDispense = (#slot0.result_digits >= 3 and 4) or 0

	slot0:UpdateContainer()

	slot0.slider_powder.value = 0
end

slot0.ExitDispenseView = function (slot0)
	if not slot0.flagDispense then
		return
	end

	slot0:UpdateNextBtn()
	slot0:StopHammerAnim()
	slot0:StopProgressAnim()

	slot0.progressDispense = 0

	setActive(slot0.dispenseView, false)
	setButtonEnabled(slot0.btn_hammer, true)
	setText(slot0.timesText, slot0:GetMGHubData().count)
	setActive(slot0.slider_bubble, false)

	if slot0.effect_light then
		setActive(slot0.effect_light, false)
	end

	slot0.flagDispense = false
end

slot0.willExit = function (slot0)
	slot0:ExitDispenseView()
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.top, slot0._tf)

	if slot0.effect_light then
		pg.PoolMgr.GetInstance():ReturnPrefab("ui/light01", "", slot0.effect_light)
	end

	pg.PoolMgr.GetInstance():DestroyPrefab("ui/light01", "")
	pg.PoolMgr.GetInstance():DestroySprite("ui/fireworkfactoryui_atlas")

	if slot0.OPTimer then
		slot0.OPTimer:Stop()

		slot0.OPTimer = nil
	end
end

return slot0

slot0 = class("RefluxScene", import("..base.BaseUI"))
slot0.TabSign = 1
slot0.TabTask = 2
slot0.TabPt = 3

slot0.getUIName = function (slot0)
	return "RefluxUI"
end

slot0.init = function (slot0)
	slot0.tabs = {
		slot0:findTF("left/left_bar/tabs/sign"),
		slot0:findTF("left/left_bar/tabs/task"),
		slot0:findTF("left/left_bar/tabs/pt")
	}
	slot0.tabPanels = {
		slot0:findTF("panel_sign"),
		slot0:findTF("panel_task"),
		slot0:findTF("panel_pt")
	}
	slot0.panelLetter = slot0:findTF("panel_letter")
	slot0.btnLetter = slot0:findTF("left/left_bar/letter")
	slot0.btnBack = slot0:findTF("left/left_bar/back")
	slot0.txTime = slot0:findTF("time/text")

	for slot4, slot5 in ipairs(slot0.tabs) do
		onToggle(slot0, slot5, function (slot0)
			if slot0 then
				slot0:SetTab(slot0.SetTab)
			end
		end, SFX_PANEL)
	end

	setText(slot0.findTF(slot0, "time/icon"), i18n("reflux_word_1"))
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.btnBack, function ()
		slot0:emit(BaseUI.ON_BACK)
	end, SFX_CANCEL)
	onButton(slot0, slot0.panelLetter:Find("btn_share"), function ()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeReflux)
	end, SFX_PANEL)
	onButton(slot0, slot0.btnLetter, function ()
		slot0:DisplayLetter()
	end, SFX_PANEL)
end

slot0.willExit = function (slot0)
	slot0.contextData.tab = slot0:GetTab()

	LeanTween.cancel(go(slot0.tabPanels[slot0.TabPt]))

	if slot0.ptAchieveTwId then
		LeanTween.cancel(slot0.ptAchieveTwId)

		slot0.ptAchieveTwId = nil
	end
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.panelLetter) then
		slot0:HideLetter()

		return
	end

	triggerButton(slot0.btnBack)
end

slot0.SetActivity = function (slot0, slot1)
	slot0.activity = slot1
	slot0.offlineTime = slot1.data1
	slot0.activateTime = slot1.data2
	slot0.bonusPoint = slot1.data3
	slot0.battlePhase = slot1.data4
	slot0.lastSignTime = slot1.data1_list[1]
	slot0.reduceSignDays = slot1.data1_list[2]
	slot0.activateLevel = slot1.data1_list[3]
	slot0.activateShipCount = slot1.data1_list[4]
	slot0.ptAccount = slot1.data1KeyValueList[1]

	print("offlineTime: " .. tostring(slot0.offlineTime))
	print("activateTime: " .. tostring(slot0.activateTime))
	print("bonusPoint: " .. tostring(slot0.bonusPoint))
	print("battlePhase: " .. tostring(slot0.battlePhase))
	print("lastSignTime: " .. tostring(slot0.lastSignTime))
	print("reduceSignDays: " .. tostring(slot0.reduceSignDays))
	print("activateLevel: " .. tostring(slot0.activateLevel))
	print("activateShipCount: " .. tostring(slot0.activateShipCount))
	print("pt account: ")

	for slot5, slot6 in pairs(slot0.ptAccount) do
		print(slot5 .. " : " .. slot6)
	end

	slot0:UpdateTime()
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.player = slot1
end

slot0.SetTask = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.tasks) do
		if slot6.id == slot1.id then
			slot0.tasks[slot5] = slot1

			break
		end
	end
end

slot0.SetTasks = function (slot0, slot1)
	slot0.tasks = slot1
end

slot0.SortTasks = function (slot0, slot1)
	function slot2(slot0, slot1, slot2)
		return slot3(slot0) < slot3(slot1)
	end

	table.sort(slot1, function (slot0, slot1)
		if slot0:getTaskStatus() == slot1:getTaskStatus() then
			return slot0.id < slot1.id
		else
			return slot0(slot0:getTaskStatus(), slot1:getTaskStatus(), {
				1,
				0,
				2
			})
		end
	end)
end

slot0.TriggerTab = function (slot0, slot1)
	triggerToggle(slot0.tabs[slot1], true)
end

slot0.GetTab = function (slot0)
	return slot0.tab
end

slot0.SetTab = function (slot0, slot1)
	if slot0.tab ~= slot1 then
		slot0.tab = slot1

		slot0:UpdateTab()
	end
end

slot0.UpdateTab = function (slot0)
	if slot0.tab == slot0.TabSign then
		slot0:UpdateSign()
	elseif slot0.tab == slot0.TabTask then
		slot0:UpdateTask()
	elseif slot0.tab == slot0.TabPt then
		slot0:UpdatePt()
	end
end

slot0.DisplayLetter = function (slot0, slot1)
	slot0.onLetterClose = slot1
	slot2 = pg.TimeMgr.GetInstance()
	slot3 = slot2:STimeDescS(slot0.offlineTime, "*t")

	setText(slot0.panelLetter:Find("billboard/year"), slot3.year % 100)
	setText(slot0.panelLetter:Find("billboard/month"), slot3.month)
	setText(slot0.panelLetter:Find("billboard/date"), slot3.day)
	setText(slot0.panelLetter:Find("billboard/days"), slot2:DiffDay(slot0.offlineTime, slot0.activateTime))
	setText(slot0.panelLetter:Find("billboard/count"), slot0.activateShipCount)
	onButton(slot0, slot0.panelLetter:Find("billboard"), function ()
		slot0:HideLetter()
	end, SFX_PANEL)
	setActive(slot0.panelLetter, true)
end

slot0.HideLetter = function (slot0)
	setActive(slot0.panelLetter, false)

	if slot0.onLetterClose then
		slot0.onLetterClose()

		slot0.onLetterClose = nil
	end
end

slot0.UpdateSign = function (slot0)
	setText(slot0.tabPanels[slot0.TabSign].Find(slot1, "reduce/text"), slot0.reduceSignDays)

	for slot6 = 0, slot0.tabPanels[slot0.TabSign].Find(slot1, "days").childCount - 1, 1 do
		slot7 = slot2:GetChild(slot6)
		slot9 = slot7:Find("checked")
		slot10 = slot7:Find("item").GetComponentsInChildren(slot8, typeof(Image))
		slot11 = (slot6 + 1 <= slot0.reduceSignDays and Color.gray) or Color.white

		for slot15 = 0, slot10.Length - 1, 1 do
			slot10[slot15].color = slot11
		end

		setImageColor(slot8, slot11)
		setActive(slot9, slot6 + 1 <= slot0.reduceSignDays)
	end
end

slot0.UpdateTask = function (slot0)
	slot0:SortTasks(slot0.tasks)

	slot2 = UIItemList.New(slot0.tabPanels[slot0.TabTask].Find(slot1, "scrollview/viewport/list"), slot0.tabPanels[slot0.TabTask].Find(slot1, "scrollview/viewport/list/task"))

	slot2:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot0.tasks[slot1 + 1]
			slot4 = slot2:Find("goto")
			slot5 = slot2:Find("finish")
			slot6 = slot2:Find("achieved")
			slot8 = slot2:Find("name")
			slot10 = slot2:Find("drops").Find(slot9, "item")

			for slot14 = 0, slot2:Find("cat").childCount - 1, 1 do
				setActive(slot7:GetChild(slot14), slot14 == slot1 % 3)
			end

			setText(slot8, slot3:getConfig("desc"))

			slot12 = UIItemList.New(slot9, slot10)

			slot12:make(function (slot0, slot1, slot2)
				if slot0 == UIItemList.EventUpdate then
					updateDrop(slot2, {
						type = slot0[slot1 + 1][1],
						id = slot0[slot1 + 1][2],
						count = slot0[slot1 + 1][3]
					})
				end
			end)
			slot12.align(slot12, #slot3:getConfig("award_display"))
			setActive(slot4, slot3:getTaskStatus() == 0)
			setActive(slot5, slot13 == 1)
			setActive(slot6, slot13 == 2)

			slot14 = slot3:getProgress()
			slot15 = slot3:getConfig("target_num")

			if slot13 == 0 then
				setSlider(slot4:Find("progress"), 0, slot15, slot14)
				setText(slot4:Find("progress/text"), slot14 .. "/" .. slot15)
			elseif slot13 == 1 then
				setSlider(slot5:Find("progress"), 0, slot15, slot14)
				setText(slot5:Find("progress/text"), slot14 .. "/" .. slot15)
			end

			onButton(slot0, slot4:Find("button"), function ()
				slot0:emit(RefluxMediator.OnTaskGo, slot0)
			end, SFX_PANEL)
			onButton(slot0, slot5.Find(slot5, "button"), function ()
				slot0:emit(RefluxMediator.OnTaskSubmit, slot1.id)
			end, SFX_PANEL)
		end
	end)
	slot2.align(slot2, #slot0.tasks)
end

slot0.UpdatePt = function (slot0)
	for slot7 = slot0.tabPanels[slot0.TabPt].Find(slot2, "scrollview/viewport/list").childCount, #pg.return_pt_template.all - 1, 1 do
		cloneTplTo(slot3:GetChild(slot7 % 10), slot3)
	end

	slot4 = 0

	for slot8 = 0, slot3.childCount - 1, 1 do
		slot10 = nil

		for slot14, slot15 in ipairs(slot1[slot1.all[slot8 + 1]].level) do
			if slot15[1] <= slot0.activateLevel and slot0.activateLevel <= slot15[2] then
				slot10 = slot9.award_display[slot14]

				break
			end
		end

		slot11 = slot3:GetChild(slot8)
		slot12 = slot11:Find("item")
		slot14 = slot11:Find("progress")

		setText(slot12:Find("text_unlock"), i18n("reflux_word_2"))
		setText(slot12:Find("text_pt"), slot9.pt_require .. "PT")
		updateDrop(slot12:Find("award"), {
			type = slot10[1],
			id = slot10[2],
			count = slot10[3]
		})
		setActive(slot11:Find("checked"), slot8 + 1 <= slot0.battlePhase)

		slot15 = (slot8 + 1 <= slot0.battlePhase and Color.gray) or Color.white

		for slot20 = 0, slot12:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
			slot16[slot20].color = slot15
		end

		setImageColor(slot12, slot15)

		slot14.sizeDelta = Vector2((slot8 == 0 and 86) or 125, 20)

		setSlider(slot14, 0, slot9.pt_require - slot4, slot0.bonusPoint - slot4)
		setActive(slot14:Find("Fill Area"), slot4 < slot0.bonusPoint)
		setText(slot14:Find("text"), slot9.pt_require .. "PT")

		slot4 = slot9.pt_require

		setActive(slot11:Find("achieve"), slot8 == slot0.battlePhase and slot9.pt_require <= slot0.bonusPoint)

		if slot17 then
			if slot0.ptAchieveTwId then
				LeanTween.cancel(slot0.ptAchieveTwId)

				slot0.ptAchieveTwId = nil
			end

			slot0.ptAchieveTwId = LeanTween.moveLocalY(go(slot18), 70, 1.5):setEase(LeanTweenType.easeInOutSine):setFrom(90):setLoopPingPong().uniqueId

			onButton(slot0, slot11, function ()
				slot0:emit(RefluxMediator.OnBattlePhaseForward, slot0.battlePhase + 1)
			end, SFX_PANEL)
		else
			removeOnButton(slot11)
		end
	end

	slot0:ScrollPt(slot0.battlePhase - 1, true)
	setText(slot2:Find("reduce/text"), slot0.bonusPoint)
	onButton(slot0, slot2:Find("bg/help"), function ()
		for slot4 = 1, #Clone(i18n("reflux_help_tip")), 1 do
			if slot0[slot4] and slot0[slot4].info then
				slot0[slot4].info = string.gsub(slot0[slot4].info, "%[task=(%d+)%]", function (slot0)
					return slot0.ptAccount[tonumber(slot0)] or 0
				end)
			end
		end

		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
			type = MSGBOX_TYPE_HELP,
			helps = slot0
		})
	end, SFX_PANEL)
end

slot0.ScrollPt = function (slot0, slot1, slot2, slot3)
	slot5 = slot0.tabPanels[slot0.TabPt].Find(slot4, "scrollview")
	slot6 = slot5:Find("viewport")
	slot7 = slot6:Find("list")
	slot9 = slot7:GetChild(0):GetComponent(typeof(LayoutElement))
	slot12 = math.clamp(math.max(slot1 * (slot9.preferredWidth + slot7:GetComponent(typeof(HorizontalLayoutGroup)).spacing) - slot6.rect.width * 0.5 + slot9.preferredWidth, 0) / ((slot7.childCount * slot9.preferredWidth + (slot7.childCount - 1) * slot7.GetComponent(typeof(HorizontalLayoutGroup)).spacing) - slot6.rect.width), 0, 1)
	slot13 = slot5:GetComponent(typeof(ScrollRect))

	LeanTween.cancel(go(slot0.tabPanels[slot0.TabPt]))

	if slot2 then
		slot13.horizontalNormalizedPosition = slot12
	else
		LeanTween.value(go(slot4), slot13.horizontalNormalizedPosition, slot12, math.abs(slot13.horizontalNormalizedPosition - slot12) * 1):setOnUpdate(System.Action_float(function (slot0)
			slot0.horizontalNormalizedPosition = slot0
		end)).setOnComplete(slot14, System.Action(function ()
			if slot0 then
				slot0()
			end
		end)).setEase(slot14, LeanTweenType.easeInOutSine)
	end
end

slot0.UpdateTime = function (slot0)
	slot1 = pg.TimeMgr.GetInstance()

	setText(slot0.txTime, slot0.activity:getConfig("config_data")[4] - math.clamp(slot1:DiffDay(slot0.activateTime, slot1:GetServerTime()), 0, slot0.activity.getConfig("config_data")[4] - 1))
end

return slot0

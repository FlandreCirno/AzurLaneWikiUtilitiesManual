slot0 = class("TaskCard")
slot1 = 0
slot2 = 1
slot3 = 2
slot4 = 3
slot5 = 4
slot6 = 0.3

slot0.Ctor = function (slot0, slot1, slot2)
	pg.DelegateInfo.New(slot0)

	slot0._go = slot1
	slot0._tf = tf(slot0._go)
	slot0.viewComponent = slot2
	slot0.frame = slot0._tf:Find("frame")
	slot0.descTxt = slot0._tf:Find("frame/desc"):GetComponent(typeof(Text))
	slot0.tagTF = slot0._tf:Find("frame/tag")
	slot0.rewardPanel = slot0._tf:Find("frame/awards")
	slot0._rewardModel = slot0.rewardPanel:GetChild(0)
	slot0.progressBar = slot0._tf:Find("frame/slider"):GetComponent(typeof(Slider))
	slot0.progressNum = slot0._tf:Find("frame/slider/Text"):GetComponent(typeof(Text))
	slot0.GotoBtn = slot0._tf:Find("frame/go_btn")
	slot0.GetBtn = slot0._tf:Find("frame/get_btn")
	slot0.storyIconFrame = slot0._tf:Find("frame/storyIcon")
	slot0.storyIcon = slot0._tf:Find("frame/storyIcon/icon")
	slot0.frame = slot0._tf:Find("frame")
	slot0._modelWidth = slot0.frame.rect.width + 100
	slot0.finishBg = slot0._tf:Find("frame/finish_bg")
	slot0.unfinishBg = slot0._tf:Find("frame/unfinish_bg")
	slot0.tip = slot0._tf:Find("frame/tip")
	slot0.cg = GetOrAddComponent(slot0._tf, "CanvasGroup")
	slot0.height = slot0._tf.rect.height
	slot0.urTag = slot0._tf:Find("frame/urTag")
	slot0.lockBg = slot0._tf:Find("lock_bg")
	slot0.lockTxt = slot0.lockBg:Find("btn/Text"):GetComponent(typeof(Text))
end

slot0.update = function (slot0, slot1)
	slot0.taskVO = slot1

	if slot1.id == 10302 then
		slot0._go.name = slot1.id
	end

	slot0.descTxt.text = HXSet.hxLan(slot1:getConfig("desc"))

	slot0:setSpriteTo("taskTagOb/" .. slot1:GetRealType(), slot0.tagTF)

	slot2 = slot1:getConfig("target_num")

	slot0:updateAwards(slot1:getConfig("award_display"))

	slot3 = slot1:getProgress()

	if slot1:isFinish() then
		slot0.progressNum.text = "COMPLETE"
	elseif slot1:getConfig("sub_type") == 1012 then
		slot0.progressNum.text = math.floor(slot3 / 100) .. "/" .. math.floor(slot2 / 100)
	else
		slot0.progressNum.text = slot3 .. "/" .. slot2
	end

	slot0.progressBar.value = slot3 / slot2

	slot0:updateBtnState(slot1)
	setActive(slot0.urTag, slot1:IsUrTask())
	setActive(slot0.storyIconFrame, slot1:getConfig("story_id") and slot4 ~= "" and not slot5)

	if slot4 and slot4 ~= "" then
		if not slot1:getConfig("story_icon") or slot6 == "" then
			slot6 = "task_icon_default"
		end

		LoadSpriteAsync("shipmodels/" .. slot6, function (slot0)
			if slot0 then
				setImageSprite(slot0.storyIcon, slot0, true)
			end
		end)
		onButton(slot0, slot0.storyIconFrame, function ()
			pg.NewStoryMgr.GetInstance():Play(pg.NewStoryMgr.GetInstance().Play, nil, true)
		end, SFX_PANEL)
	else
		removeOnButton(slot0.storyIconFrame)
	end

	slot0.cg.alpha = 1

	setActive(slot0.frame, true)
	setActive(slot0._go, true)
end

slot0.updateBtnState = function (slot0, slot1)
	slot2 = slot0

	removeOnButton(slot0.GotoBtn)
	removeOnButton(slot0.GetBtn)

	if slot1:isLock() then
		slot2 = slot1
	elseif slot1:isFinish() then
		slot2 = (slot1:isReceive() and slot2) or slot3

		onButton(slot0, slot0.GetBtn, function ()
			function slot0()
				if not slot0.isClick then
					slot0.isClick = true

					slot0:DoSubmitAnim(function ()
						slot0.isClick = nil

						slot0:Submit(slot0)
					end)
				end
			end

			slot1 = nil

			function slot2()
				if slot0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM or slot0:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM or slot0:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
					if slot0:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
						slot0 = DROP_TYPE_RESOURCE
					end

					pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("sub_item_warning"),
						items = {
							{
								type = slot0,
								id = slot0:getConfig("target_id_for_client"),
								count = slot0:getConfig("target_num")
							}
						},
						onYes = function ()
							slot0()
						end
					})
					coroutine.yield()
				end

				slot0, slot1 = slot0:judgeOverflow()

				if slot0 then
					pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
						type = MSGBOX_TYPE_ITEM_BOX,
						content = i18n("award_max_warning"),
						items = slot1,
						onYes = function ()
							slot0()
						end
					})
					coroutine.yield()
				end

				slot2()
			end

			coroutine.wrap(slot2)()
		end, SFX_PANEL)
	else
		slot2 = slot4

		onButton(slot0, slot0.GotoBtn, function ()
			slot0:Skip(slot0)
		end, SFX_PANEL)
	end

	SetActive(slot4, slot2 == slot0.GotoBtn)
	SetActive(slot0.GetBtn, slot2 == SetActive)
	SetActive(slot0.finishBg, slot2 == setActive or slot2 == slot2)
	SetActive(slot0.unfinishBg, slot2 ~= setActive and slot2 ~= BTN_STATE_FETC)
	SetActive(slot0.tip, slot2 == setActive or slot2 == slot2)
	setActive(slot0.lockBg, slot2 == slot1)
	setGray(slot0.frame, slot2 == slot1, true)

	if slot2 == slot1 then
		slot0.lockTxt.text = i18n("task_lock", slot1.getConfig(slot1, "level"))
	end
end

slot0.Submit = function (slot0, slot1)
	if slot1.isWeekTask then
		slot0.viewComponent:onSubmitForWeek(slot1)
	else
		slot0.viewComponent:onSubmit(slot1)
	end
end

slot0.Skip = function (slot0, slot1)
	slot0.viewComponent:onGo(slot1)
end

slot0.updateAwards = function (slot0, slot1)
	for slot7 = slot0.rewardPanel.childCount, #_.slice(slot1, 1, 3) - 1, 1 do
		cloneTplTo(slot0._rewardModel, slot0.rewardPanel)
	end

	for slot7 = 1, slot0.rewardPanel.childCount, 1 do
		setActive(slot0.rewardPanel:GetChild(slot7 - 1), slot7 <= #slot2)

		if slot9 then
			updateDrop(slot8, slot11)
			onButton(slot0, slot8, function ()
				slot0.viewComponent:emit(TaskMediator.ON_DROP, slot0.viewComponent)
			end, SFX_PANEL)
		end
	end
end

slot0.setSpriteTo = function (slot0, slot1, slot2, slot3)
	slot2:GetComponent(typeof(Image)).sprite = slot0.viewComponent._tf:Find(slot1):GetComponent(typeof(Image)).sprite

	if slot3 then
		slot4:SetNativeSize()
	end
end

slot0.DoSubmitAnim = function (slot0, slot1)
	LeanTween.alphaCanvas(slot0.cg, 0, slot0):setFrom(1)
	LeanTween.value(go(slot0.frame), slot0.frame.localPosition.x, slot0.frame.localPosition.x + slot0._modelWidth, slot0):setOnUpdate(System.Action_float(function (slot0)
		slot0.frame.transform.localPosition = Vector3(slot0, slot1.y, slot1.z)
	end)).setOnComplete(slot3, System.Action(function ()
		slot0.frame.transform.localPosition = slot1

		setActive(slot0.frame, false)
		false()
	end))
end

slot0.dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
end

return slot0

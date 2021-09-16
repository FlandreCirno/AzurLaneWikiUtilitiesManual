slot0 = class("TechnologyScene", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "TechnologyUI"
end

slot0.setTechnologys = function (slot0, slot1)
	slot0.technologyVOs = slot1
end

slot0.setRefreshFlag = function (slot0, slot1)
	slot0.flag = slot1
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1

	if slot0._resPanel then
		slot0._resPanel:setResources(slot1)
	end
end

slot0.updateSettingsBtn = function (slot0)
	slot2 = slot0:findTF("RedPoint", slot0.settingsBtn)

	setText(slot3, i18n("tec_settings_btn_word"))

	slot5 = slot0:findTF("Selected", slot4)
	slot6 = slot0:findTF("ActCatchup", slot0.settingsBtn)

	setActive(slot0:findTF("tag", slot0.settingsBtn), getProxy(TechnologyProxy).getTendency(slot7, 2) > 0)

	if slot8 > 0 then
		for slot13 = 1, slot1.childCount, 1 do
			setActive(slot1:GetChild(slot13 - 1), slot8 == slot13)
		end
	end

	slot9 = false

	if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP) and not slot10:isEnd() then
		slot13 = pg.activity_event_blueprint_catchup[slot10:getConfig("config_id")].char_choice

		if slot10.data1 < pg.activity_event_blueprint_catchup[slot10.getConfig("config_id")].obtain_max then
			setImageSprite(slot15, LoadSprite("TecCatchup/QChar" .. slot13, tostring(slot13)))
			setText(slot16, slot11 .. "/" .. slot14)

			slot17 = slot10.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

			if slot0.actCatchupTimer then
				slot0.actCatchupTimer:Stop()

				slot0.actCatchupTimer = nil
			end

			slot18 = slot0:findTF("TimeLeft/Day", slot6)
			slot19 = slot0:findTF("TimeLeft/Hour", slot6)
			slot20 = slot0:findTF("TimeLeft/Min", slot6)
			slot21 = slot0:findTF("TimeLeft/NumText", slot6)

			function slot22()
				slot4, slot1, slot2, slot3 = pg.TimeMgr.GetInstance():parseTimeFrom(pg.TimeMgr.GetInstance().parseTimeFrom)

				if slot0 - 1 >= 1 then
					setActive(slot1, true)
					setActive(slot2, false)
					setActive(slot3, false)
					setText(setText, slot0)
				elseif slot0 <= 0 and slot1 > 0 then
					setActive(slot1, false)
					setActive(slot2, true)
					setActive(slot3, false)
					setText(setText, slot1)
				elseif slot0 <= 0 and slot1 <= 0 and (slot2 > 0 or slot3 > 0) then
					setActive(slot1, false)
					setActive(slot2, false)
					setActive(slot3, true)
					setText(setText, math.max(slot2, 1))
				elseif slot0 <= 0 and slot1 <= 0 and slot2 <= 0 and slot3 <= 0 and slot5.actCatchupTimer then
					slot5.actCatchupTimer:Stop()

					slot5.actCatchupTimer.actCatchupTimer = nil

					setActive(slot6, false)
				end
			end

			slot0.actCatchupTimer = Timer.New(slot22, 1, -1, 1)

			slot0.actCatchupTimer:Start()
			slot0.actCatchupTimer.func()

			slot9 = true
		end
	end

	setActive(slot6, slot9)
	setActive(slot4, true)

	slot12 = slot7:isOnCatchup()

	if slot7:isOpenTargetCatchup() then
		if not slot12 then
			setActive(slot5, false)
			setActive(slot2, true)
		else
			slot16 = slot7:getCurCatchupTecInfo().printNum
			slot19 = (slot7:getCatchupData(slot14):isUr(slot7.getCurCatchupTecInfo().groupID) and pg.technology_catchup_template[slot14].obtain_max_per_ur) or pg.technology_catchup_template[slot14].obtain_max

			if slot19 <= slot16 then
				setActive(slot5, false)
				setActive(slot2, false)
			else
				setActive(slot5, true)
				setActive(slot2, false)
				setImageSprite(slot21, LoadSprite("TecCatchup/QChar" .. slot15, tostring(slot15)))
				setText(slot0:findTF("ProgressText", slot5), slot16 .. "/" .. slot19)
			end
		end
	else
		setActive(slot5, false)
		setActive(slot2, false)
	end
end

slot0.init = function (slot0)
	slot0.srcollView = slot0:findTF("main/srcoll_rect/content")
	slot0.cardTpl = slot0:findTF("card_tpl", slot0.srcollView)
	slot0.srcollViewCG = slot0.srcollView:GetComponent(typeof(CanvasGroup))
	slot0.helpBtn = slot0:findTF("main/help_btn")
	slot0.refreshBtn = slot0:findTF("main/refresh_btn")
	slot0.backBtn = slot0:findTF("blur_panel/adapt/top/back")
	slot0.settingsBtn = slot0:findTF("main/settings_btn")
	slot0.selectetPanel = slot0:findTF("main/selecte_panel")

	setActive(slot0.selectetPanel, false)

	slot0.arrLeftBtn = slot0:findTF("left_arr_btn", slot0.selectetPanel)
	slot0.arrRightBtn = slot0:findTF("right_arr_btn", slot0.selectetPanel)
	slot0.technologyTpl = slot0:findTF("technology_card", slot0.selectetPanel)
	slot0.descTxt = slot0:findTF("desc/bg/Text", slot0.selectetPanel):GetComponent(typeof(Text))
	slot0.timerTxt = slot0:findTF("timer/bg/Text", slot0.selectetPanel):GetComponent(typeof(Text))
	slot0.itemContainer = slot0:findTF("consume_panel/bg/container", slot0.selectetPanel)
	slot0.itemTpl = slot0:findTF("item_tpl", slot0.itemContainer)
	slot0.emptyTF = slot0:findTF("consume_panel/bg/empty", slot0.selectetPanel)
	slot0.taskPanel = slot0:findTF("consume_panel/bg/task_panel", slot0.selectetPanel)
	slot0.taskSlider = slot0.taskPanel:Find("slider"):GetComponent(typeof(Slider))
	slot0.taskDesc = slot0.taskPanel:Find("slider/Text"):GetComponent(typeof(Text))
	slot0.descBG = slot0:findTF("desc/bg", slot0.selectetPanel):GetComponent(typeof(Image))
	slot0.techTimer = {}
	slot0.refreshTimer = {}
	slot0.cardtimer = {}
	slot0._playerResOb = slot0:findTF("blur_panel/adapt/top/playerRes")
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)
end

slot0.didEnter = function (slot0)
	slot0:initTechnologys()
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.technology_help_text.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.refreshBtn, function ()
		if _.any(slot0.technologyVOs, function (slot0)
			return slot0.state ~= Technology.STATE_IDLE
		end) then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot0, {
				content = i18n("technology_canot_refresh")
			})

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("technology_refresh_tip"),
			onYes = function ()
				slot0:emit(TechnologyMediator.ON_REFRESH)
			end
		})
	end, SFX_PANEL)

	slot1 = getProxy(TechnologyProxy).getConfigMaxVersion(slot1)

	onButton(slot0, slot0.settingsBtn, function ()
		slot0:emit(TechnologyMediator.ON_CLICK_SETTINGS_BTN)
	end, SFX_PANEL)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SOUND_BACK)
	onButton(slot0, slot0.selectetPanel, function ()
		slot0:cancelSelected()
	end, SFX_PANEL)
	slot0.updateRefreshBtn(slot0, slot0.flag)
	slot0._resPanel:setResources(slot0.player)
	slot0:updateSettingsBtn()
end

slot0.initTechnologys = function (slot0)
	slot0.technologCards = {}
	slot0.lastButtonListener = slot0.lastButtonListener or {}

	if not slot0.itemList then
		slot0.itemList = UIItemList.New(slot0.srcollView, slot0.cardTpl)

		slot0.itemList:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventUpdate then
				slot2.name = slot1 + 1
				slot0.technologCards[slot0.technologyVOs[slot1 + 1].id] = slot2

				slot0:updateTechnologyTF(slot2, slot0.technologyVOs[slot1 + 1])
				slot0:updateTimer(slot0.technologyVOs[slot1 + 1])

				slot3 = GetOrAddComponent(slot2, typeof(Button)).onClick

				if slot0.lastButtonListener[slot2] then
					slot3:RemoveListener(slot0.lastButtonListener[slot2])
				end

				if slot0.technologyVOs[slot1 + 1]:isStart() then
					Timer.New(function ()
						slot0.srcollView:GetComponent("EnhancelScrollView"):SetHorizontalTargetItemIndex(slot1:GetComponent("EnhanceItem").scrollViewItemIndex)
					end, 0.35, 1).Start(slot4)
				end

				slot0.lastButtonListener[slot2] = function ()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)

					if pg.CriMgr.GetInstance().PlaySoundEffect_V3.technologyVOs[pg.CriMgr.GetInstance() + 1]:getState() == Technology.STATE_FINISHED then
						slot0:emit(TechnologyMediator.ON_FINISHED, {
							id = slot0.technologyVOs[slot1 + 1].id,
							pool_id = slot0.technologyVOs[slot1 + 1].poolId
						})
					else
						slot0:onSelected(slot1 + 1)
					end
				end

				slot3.AddListener(slot3, slot0.lastButtonListener[slot2])
			end
		end)
	end

	slot0.itemList.align(slot1, #slot0.technologyVOs)
end

slot0.updateRefreshBtn = function (slot0, slot1)
	setButtonEnabled(slot0.refreshBtn, slot1 == 0)
end

slot0.onSelected = function (slot0, slot1)
	if not slot1 then
		return
	end

	if not slot0.technologyVOs[slot1] then
		return
	end

	slot0.technologyCount = table.getCount(slot0.technologyVOs)
	slot0.contextData.selectedIndex = slot1
	slot0.srcollViewCG.alpha = 0.3

	setActive(slot3, false)
	setActive(slot0.selectetPanel, true)

	slot4 = {}

	eachChild(slot0.srcollView, function (slot0)
		slot0[tonumber(slot0.name)] = slot0
	end)

	function slot5(slot0, slot1)
		slot2 = {}
		slot3 = slot0
		slot4 = slot0[slot0].localPosition.x

		for slot8, slot9 in ipairs(slot0) do
			slot2[slot8] = slot0[slot8].localPosition.x - slot4
		end

		for slot8, slot9 in ipairs(slot2) do
			if slot9 ~= 0 and (slot2[slot3] == 0 or (slot1 and ((slot9 > 0 and slot2[slot3] > 0 and slot2[slot3] < slot9) or (slot9 < 0 and (slot2[slot3] > 0 or slot2[slot3] < slot9)))) or (not slot1 and ((slot9 < 0 and slot2[slot3] < 0 and slot9 < slot2[slot3]) or (slot9 > 0 and (slot2[slot3] < 0 or slot9 < slot2[slot3]))))) then
				slot3 = slot8
			end
		end

		return slot0[slot3]
	end

	slot0.updateSelectedInfo(slot0, slot2)
	onButton(slot0, slot0.arrLeftBtn, function ()
		if slot0.inAnim then
			return
		end

		slot0:cancelSelected()
		triggerButton(slot0(slot2, true))
	end, SFX_PANEL)
	onButton(slot0, slot0.arrRightBtn, function ()
		if slot0.inAnim then
			return
		end

		slot0:cancelSelected()
		triggerButton(slot0(slot2, false))
	end, SFX_PANEL)
end

slot0.updateSelectedInfo = function (slot0, slot1)
	if not slot0.contextData.selectedIndex then
		return
	end

	slot0:updateTechnologyTF(slot0.technologyTpl, slot1, true)
	slot0:updateExtraInfo(slot1)
end

slot0.updateExtraInfo = function (slot0, slot1)
	slot0.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(slot2)
	slot0.descTxt.text = slot1:getConfig("desc")
	slot0.descBG.sprite = GetSpriteFromAtlas("ui/TechnologyUI_atlas", slot1:getConfig("rarity"))

	for slot8 = slot0.itemContainer.childCount + 1, #slot1:getConfig("consume"), 1 do
		cloneTplTo(slot0.itemTpl, slot0.itemContainer)
	end

	for slot8 = 1, slot0.itemContainer.childCount, 1 do
		setActive(slot0.itemContainer:GetChild(slot8 - 1), slot8 <= #slot3)

		if slot8 <= #slot3 then
			slot0:updateItem(slot9, slot1, slot3[slot8])
		end
	end

	setActive(slot0.emptyTF, not slot3 or #slot3 <= 0)

	if slot1:hasCondition() then
		slot0.taskSlider.value = getProxy(TaskProxy):getTaskById(slot1:getTaskId()) or Task.New({
			id = slot5
		}).progress / getProxy(TaskProxy).getTaskById(slot1.getTaskId()) or Task.New():getConfig("target_num")
		slot0.taskDesc.text = getProxy(TaskProxy).getTaskById(slot1.getTaskId()) or Task.New():getConfig("desc") .. "(" .. getProxy(TaskProxy).getTaskById(slot1.getTaskId()) or Task.New().progress .. "/" .. getProxy(TaskProxy).getTaskById(slot1.getTaskId()) or Task.New():getConfig("target_num") .. ")"
	else
		slot0.taskDesc.text = i18n("technology_task_none_tip")
		slot0.taskSlider.value = 0
	end

	if slot0.techTimer[slot1.id] then
		slot0.techTimer[slot1.id]:Stop()

		slot0.techTimer[slot1.id] = nil
	end

	function slot5()
		slot0.techTimer[slot1.id]:Stop()

		slot0.techTimer[slot1.id].Stop.techTimer[slot0.techTimer[slot1.id].id] = nil
		slot0.techTimer[slot1.id].Stop.techTimer.timerTxt.text = "00:00:00"
	end

	if slot1.isStarting(slot1) then
		slot0.techTimer[slot1.id] = Timer.New(function ()
			if slot0.time - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
				slot1()
			else
				slot2.timerTxt.text = pg.TimeMgr.GetInstance():DescCDTime(slot0.time - slot0)
			end
		end, 1, -1)

		slot0.techTimer[slot1.id].Start(slot6)
		slot0.techTimer[slot1.id].func()
	end

	for slot10 = 1, slot0.itemContainer.childCount, 1 do
		slot11 = slot0.itemContainer:GetChild(slot10 - 1)

		setActive(slot11:Find("check"), slot1:isStart())
		setActive(slot11:Find("icon_bg/count"), not slot1:isStart())
	end
end

slot0.cancelSelected = function (slot0)
	if not slot0.contextData.selectedIndex then
		return
	end

	if not slot0.technologyVOs[slot1] then
		return
	end

	slot0.srcollViewCG.alpha = 1

	setActive(slot3, true)
	removeOnButton(slot0.arrLeftBtn)
	removeOnButton(slot0.arrRightBtn)
	setActive(slot0.selectetPanel, false)

	slot0.inAnim = true

	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end

	slot0.contextData.selectedIndex = nil
	slot0.timer = Timer.New(function ()
		slot0.inAnim = nil
	end, 0.2, 1)

	slot0.timer.Start(slot4)

	if callback then
		callback()
	end

	if slot0.techTimer[slot2.id] then
		slot0.techTimer[slot2.id]:Stop()

		slot0.techTimer[slot2.id] = nil
	end
end

slot0.updateTechnology = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.technologyVOs) do
		if slot6.id == slot1.id then
			slot0.technologyVOs[slot5] = slot1
		end
	end

	slot0:updateTechnologyTF(slot2, slot1)
	slot0:updateTimer(slot1)
end

slot0.updateTimer = function (slot0, slot1)
	slot3 = slot0.technologCards[slot1.id].Find(slot2, "frame/btns/dev_btn/time")
	slot4 = slot0.technologCards[slot1.id].Find(slot2, "frame/btns/dev_btn/limit")

	if slot0.cardtimer[slot1.id] then
		slot0.cardtimer[slot1.id]:Stop()

		slot0.cardtimer[slot1.id] = nil
	end

	if slot1:getState() == Technology.STATE_STARTING then
		setActive(slot3, true)
		setActive(slot4, false)

		slot0.cardtimer[slot1.id] = Timer.New(function ()
			if slot0.time - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
				if slot1.cardtimer[slot0.id] then
					slot1.cardtimer[slot0.id]:Stop()

					slot1.cardtimer[slot0.id] = nil
				end

				if not slot0:canFinish() then
					setActive(setActive, false)
					setActive(setActive, true)
				else
					slot1:emit(TechnologyMediator.ON_TIME_OVER, slot0.id)
				end
			else
				setText(slot2:Find("text"), pg.TimeMgr.GetInstance():DescCDTime(slot0 - slot1))
			end
		end, 1, -1)

		slot0.cardtimer[slot1.id].Start(slot5)
		slot0.cardtimer[slot1.id].func()
	end
end

slot0.updateTechnologyTF = function (slot0, slot1, slot2, slot3)
	slot0:updateInfo(slot1, slot2, slot3)
	setActive(slot0:findTF("frame/btns/finish_btn", slot1), slot2:getState() == Technology.STATE_FINISHED)

	if not slot3 then
		setActive(slot0:findTF("frame/btns/desc_btn", slot1), slot4 == Technology.STATE_IDLE)
		setActive(slot0:findTF("frame/btns/dev_btn", slot1), slot4 == Technology.STATE_STARTING)

		return
	end

	removeOnButton(slot5)
	removeOnButton(slot6)
	removeOnButton(slot7)
	setActive(slot0:findTF("frame/btns/start_btn", slot1), slot4 == Technology.STATE_IDLE)
	setActive(slot7, slot4 == Technology.STATE_STARTING)

	if slot4 == Technology.STATE_IDLE then
		onButton(slot0, slot6, function ()
			if _.any(slot0.technologyVOs, function (slot0)
				return slot0.state ~= Technology.STATE_IDLE
			end) then
				pg.TipsMgr.GetInstance().ShowTips(slot0, i18n("technology_is_actived"))

				return
			end

			if #slot1:getConfig("consume") > 0 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("technology_task_build_tip", getDropInfo(slot0)),
					onYes = function ()
						slot0:emit(TechnologyMediator.ON_START, {
							id = slot1.id,
							pool_id = slot1.poolId
						})
					end
				})
			else
				slot0.emit(slot1, TechnologyMediator.ON_START, {
					id = slot1.id,
					pool_id = slot1.poolId
				})
			end
		end, SFX_PANEL)
		setButtonEnabled(slot6, slot2:hasResToStart())
	elseif slot4 == Technology.STATE_STARTING then
		onButton(slot0, slot7, function ()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("technology_stop_tip"),
				onYes = function ()
					slot0:emit(TechnologyMediator.ON_STOP, {
						id = slot1.id,
						pool_id = slot1.poolId
					})
				end
			})
		end, SFX_PANEL)
	elseif slot4 == Technology.STATE_FINISHED then
		onButton(slot0, slot5, function ()
			slot0:emit(TechnologyMediator.ON_FINISHED, {
				id = slot1.id,
				pool_id = slot1.poolId
			})
		end, SFX_PANEL)
	end
end

slot0.dfs = function (slot0, slot1, slot2)
	if slot1.name ~= "item_tpl" then
		for slot6 = 1, slot1.childCount, 1 do
			slot0:dfs(slot1:GetChild(slot6 - 1), slot2)
		end
	else
		slot2(slot1)
	end
end

slot0.updateInfo = function (slot0, slot1, slot2, slot3)
	setImageSprite(slot0:findTF("frame", slot1), GetSpriteFromAtlas("technologycard", slot2:getConfig("bg") .. ((slot3 and "_l") or "")))
	LoadImageSpriteAtlasAsync("technologyshipicon/" .. slot2:getConfig("bg_icon"), slot2:getConfig("bg_icon"), slot0:findTF("frame/icon_mask/icon", slot1), true)
	setImageSprite(slot0:findTF("frame/label", slot1), GetSpriteFromAtlas("technologycard", slot2:getConfig("label")))
	setImageSprite(slot0:findTF("frame/label/text", slot1), GetSpriteFromAtlas("technologycard", slot2:getConfig("label_color")), true)
	setImageSprite(slot0:findTF("frame/label/version", slot1), GetSpriteFromAtlas("technologycard", "version_" .. slot2:getConfig("blueprint_version")), true)
	setText(slot0:findTF("frame/name_bg/Text", slot1), slot2:getConfig("name"))
	setText(slot0:findTF("frame/sub_name", slot1), slot2:getConfig("sub_name") or "")

	slot4 = slot2:getConfig("drop_client")
	slot6 = 0

	slot0:dfs(slot1:Find("frame/item_container"), function (slot0)
		slot1(slot0 + 1, slot0 + 1 <= #slot1)

		if slot0 <= #slot1 then
			slot2:updateItem(slot0, , slot1[slot0])
		end
	end)

	if not slot3 then
		setActive(slot5.GetChild(slot5, 1), #slot4 > 2)

		slot5:GetChild(0):GetComponent("HorizontalLayoutGroup").padding.right = (#slot4 == 4 and 25) or 0
		slot5:GetChild(1):GetComponent("HorizontalLayoutGroup").padding.left = (#slot4 == 4 and 25) or 0
	end
end

slot0.updateItem = function (slot0, slot1, slot2, slot3)
	slot4 = nil

	updateDrop(slot1, slot4)

	if not IsNil(slot0:findTF("icon_bg/count", slot1)) then
		slot6 = nil

		setColorCount(slot5, (slot3[1] ~= DROP_TYPE_RESOURCE or slot0.player:getResById(slot3[2])) and getProxy(BagProxy):getItemCountById(slot4.id), slot3[3])
	end

	onButton(slot0, slot1, function ()
		if #(slot0:getConfig("display_icon") or {}) > 0 then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot2, {
				type = MSGBOX_TYPE_ITEM_BOX,
				items = _.map(slot0, function (slot0)
					return {
						type = slot0[1],
						id = slot0[2]
					}
				end),
				content = slot0.getConfig(slot2, "display"),
				itemFunc = function (slot0)
					slot0:emit(slot1.ON_DROP, slot0, function ()
						pg.MsgboxMgr.GetInstance():ShowMsgBox(pg.MsgboxMgr.GetInstance().ShowMsgBox)
					end)
				end
			})

			return
		end

		slot1:emit(slot2.ON_DROP, slot0)
	end, SFX_PANEL)
end

slot0.clearTimer = function (slot0, ...)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end

	for slot4, slot5 in pairs(slot0.techTimer) do
		slot5:Stop()
	end

	slot0.techTimer = {}

	for slot4, slot5 in pairs(slot0.cardtimer) do
		slot5:Stop()
	end

	slot0.cardtimer = {}

	if slot0.actCatchupTimer then
		slot0.actCatchupTimer:Stop()

		slot0.actCatchupTimer = nil
	end
end

slot0.willExit = function (slot0)
	slot0:clearTimer()

	slot0.techTimer = nil
	slot0.cardtimer = {}
end

return slot0

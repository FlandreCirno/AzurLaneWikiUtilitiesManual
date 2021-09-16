slot0 = class("ShipBluePrintScene", import("..base.BaseUI"))
slot1 = pg.ship_data_blueprint
slot2 = pg.ship_data_template
slot3 = pg.ship_data_breakout
slot4 = 3
slot5 = -10
slot6 = 2.3

slot0.getUIName = function (slot0)
	return "ShipBluePrintUI"
end

slot0.setVersion = function (slot0, slot1)
	slot0.version = slot1
end

slot0.setShipVOs = function (slot0, slot1)
	slot0.shipVOs = slot1
end

slot0.getShipById = function (slot0, slot1)
	return slot0.shipVOs[slot1]
end

slot0.setTaskVOs = function (slot0, slot1)
	slot0.taskVOs = slot1
end

slot0.getTaskById = function (slot0, slot1)
	return slot0.taskVOs[slot1] or Task.New({
		id = slot1
	})
end

slot0.getItemById = function (slot0, slot1)
	return getProxy(BagProxy):getItemById(slot1) or Item.New({
		count = 0,
		type = DROP_TYPE_ITEM,
		id = slot1
	})
end

slot0.setShipBluePrints = function (slot0, slot1)
	slot0.bluePrintByIds = slot1
end

slot0.updateShipBluePrintVO = function (slot0, slot1)
	slot0.bluePrintByIds[slot1.id] = slot1

	slot0:filterBlueprints()
	setActive(slot0.shipContainer, false)
	slot0.itemList:align(#slot0.filterBlueprintVOs)
	setActive(slot0.shipContainer, true)
	eachChild(slot0.shipContainer, function (slot0)
		if slot0.contextData.shipBluePrintVO.id == slot0.bluePrintItems[slot0].shipBluePrintVO.id then
			triggerToggle(slot0, true)
		end
	end)
end

slot0.init = function (slot0)
	slot0.main = slot0:findTF("main")
	slot0.centerPanel = slot0:findTF("center_panel", slot0.main)
	slot0.blurPanel = slot0:findTF("blur_panel")
	slot0.top = slot0:findTF("adapt", slot0.blurPanel)
	slot0.topPanel = slot0:findTF("top", slot0.top)
	slot0.topBg = slot0:findTF("top_bg", slot0.blurPanel)
	slot0.backBtn = slot0:findTF("top/back", slot0.top)
	slot0.leftPanle = slot0:findTF("left_panel", slot0.top)
	slot0.bottomPanel = slot0:findTF("bottom_panel", slot0.top)
	slot0.rightPanel = slot0:findTF("right_panel", slot0.top)
	slot0.shipContainer = slot0:findTF("ships/bg/content", slot0.bottomPanel)
	slot0.shipTpl = slot0:findTF("ship_tpl", slot0.bottomPanel)
	slot0.versionBtn = slot0:findTF("ships/bg/version/version_btn", slot0.bottomPanel)
	slot0.eyeTF = slot0:findTF("eye", slot0.leftPanle)
	slot0.painting = slot0:findTF("main/center_panel/painting")
	slot0.nameTF = slot0:findTF("name", slot0.centerPanel)
	slot0.shipName = slot0:findTF("name_mask/Text", slot0.nameTF)
	slot0.shipType = slot0:findTF("type", slot0.nameTF)
	slot0.englishName = slot0:findTF("english_name", slot0.nameTF)
	slot0.shipInfoStarTpl = slot0:findTF("star_tpl", slot0.nameTF)

	setActive(slot0.shipInfoStarTpl, false)

	slot0.stars = slot0:findTF("stars", slot0.nameTF)
	slot0.initBtn = slot0:findTF("property_panel/btns/init_toggle", slot0.leftPanle)
	slot0.attrBtn = slot0:findTF("property_panel/btns/attr_toggle", slot0.leftPanle)
	slot0.attrDisableBtn = slot0:findTF("property_panel/btns/attr_toggle/disable", slot0.leftPanle)
	slot0.initPanel = slot0:findTF("property_panel/init_panel", slot0.leftPanle)
	slot0.propertyPanel = PropertyPanel.New(slot0.initPanel, 32)
	slot0.skillRect = slot0:findTF("property_panel/init_panel/skills_rect", slot0.leftPanle)
	slot0.skillPanel = slot0:findTF("property_panel/init_panel/skills_rect/skills", slot0.leftPanle)
	slot0.skillTpl = slot0:findTF("skilltpl", slot0.skillPanel)
	slot0.skillArrLeft = slot0:findTF("property_panel/init_panel/arrow1", slot0.leftPanle)
	slot0.skillArrRight = slot0:findTF("property_panel/init_panel/arrow2", slot0.leftPanle)
	slot0.simulationBtn = slot0:findTF("property_panel/init_panel/property_title2/simulation", slot0.leftPanle)
	slot0.attrPanel = slot0:findTF("property_panel/attr_panel", slot0.leftPanle)
	slot0.modAdditionPanel = slot0:findTF("property_panel/attr_panel", slot0.leftPanle)
	slot0.modAdditionContainer = slot0:findTF("scroll_rect/content", slot0.modAdditionPanel)
	slot0.modAdditionTpl = slot0:findTF("addition_tpl", slot0.modAdditionContainer)
	slot0.preViewBtn = slot0:findTF("pre_view", slot0.attrPanel)
	slot0.stateInfo = slot0:findTF("state_info", slot0.centerPanel)
	slot0.startBtn = slot0:findTF("state_info/start_btn", slot0.centerPanel)
	slot0.lockPanel = slot0:findTF("state_info/lock_panel", slot0.centerPanel)
	slot0.lockBtn = slot0:findTF("lock", slot0.lockPanel)
	slot0.finishedBtn = slot0:findTF("state_info/finished_btn", slot0.centerPanel)
	slot0.progressPanel = slot0:findTF("state_info/progress", slot0.centerPanel)
	slot0.progressContainer = slot0:findTF("content", slot0.progressPanel)
	slot0.progressTpl = slot0:findTF("item", slot0.progressContainer)
	slot0.openCondition = slot0:findTF("state_info/open_condition", slot0.centerPanel)
	slot0.speedupBtn = slot0:findTF("main/speedup_btn")
	slot0.taskListPanel = slot0:findTF("task_list", slot0.rightPanel)
	slot0.taskContainer = slot0:findTF("task_list/scroll/content", slot0.rightPanel)
	slot0.taskTpl = slot0:findTF("task_list/task_tpl", slot0.rightPanel)
	slot0.modPanel = slot0:findTF("mod_panel", slot0.rightPanel)
	slot0.attrContainer = slot0:findTF("desc/atrrs", slot0.modPanel)
	slot0.levelSlider = slot0:findTF("title/slider", slot0.modPanel):GetComponent(typeof(Slider))
	slot0.levelSliderTxt = slot0:findTF("title/slider/Text", slot0.modPanel)
	slot0.preLevelSlider = slot0:findTF("title/pre_slider", slot0.modPanel):GetComponent(typeof(Slider))
	slot0.modLevel = slot0:findTF("title/level_bg/Text", slot0.modPanel):GetComponent(typeof(Text))
	slot0.needLevelTxt = slot0:findTF("title/Text", slot0.modPanel):GetComponent(typeof(Text))
	slot0.calcPanel = slot0.modPanel:Find("desc/calc_panel")
	slot0.calcMinBtn = slot0.calcPanel:Find("min")
	slot0.calcMaxBtn = slot0.calcPanel:Find("max")
	slot0.calcTxt = slot0.calcPanel:Find("count/Text")
	slot0.itemInfo = slot0.calcPanel:Find("item_bg")
	slot0.itemInfoIcon = slot0.itemInfo:Find("icon")
	slot0.itemInfoCount = slot0.itemInfo:Find("kc")
	slot0.modBtn = slot0.calcPanel:Find("confirm_btn")
	slot0.fittingBtn = slot0:findTF("desc/fitting_btn", slot0.modPanel)
	slot0.fittingBtnEffect = slot0.fittingBtn:Find("anim/ShipBlue02")
	slot0.fittingPanel = slot0:findTF("fitting_panel", slot0.rightPanel)

	setActive(slot0.fittingPanel, false)

	slot0.fittingAttrPanel = slot0:findTF("desc/middle", slot0.fittingPanel)
	slot0.phasePic = slot0:findTF("title/phase", slot0.fittingPanel)
	slot0.phaseSlider = slot0:findTF("desc/top/slider", slot0.fittingPanel):GetComponent(typeof(Slider))
	slot0.phaseSliderTxt = slot0:findTF("desc/top/precent", slot0.fittingPanel)
	slot0.prePhaseSlider = slot0:findTF("desc/top/pre_slider", slot0.fittingPanel):GetComponent(typeof(Slider))
	slot0.fittingNeedMask = slot0:findTF("desc/top/mask", slot0.fittingPanel)
	slot0.fittingCalcPanel = slot0:findTF("desc/bottom", slot0.fittingPanel)
	slot0.fittingCalcMinBtn = slot0:findTF("calc/min", slot0.fittingCalcPanel)
	slot0.fittingCalcMaxBtn = slot0:findTF("calc/max", slot0.fittingCalcPanel)
	slot0.fittingCalcTxt = slot0:findTF("calc/count/Text", slot0.fittingCalcPanel)
	slot0.fittingItemInfo = slot0:findTF("item_bg", slot0.fittingCalcPanel)
	slot0.fittingItemInfoIcon = slot0:findTF("icon", slot0.fittingItemInfo)
	slot0.fittingItemInfoCount = slot0:findTF("kc", slot0.fittingItemInfo)
	slot0.fittingConfirmBtn = slot0:findTF("confirm_btn", slot0.fittingCalcPanel)
	slot0.fittingCancelBtn = slot0:findTF("cancel_btn", slot0.fittingCalcPanel)
	slot0.msgPanel = slot0:findTF("msg_panel", slot0.blurPanel)

	setActive(slot0.msgPanel, false)

	slot0.versionPanel = slot0._tf:Find("version_panel")

	setActive(slot0.versionPanel, false)

	slot0.preViewer = slot0:findTF("preview")
	slot0.preViewerFrame = slot0:findTF("preview/frame")

	setActive(slot0.preViewer, false)

	slot0.sea = slot0:findTF("sea", slot0.preViewerFrame)
	slot0.rawImage = slot0.sea:GetComponent("RawImage")

	setActive(slot0.rawImage, false)

	slot0.seaLoading = slot0:findTF("bg/loading", slot0.preViewerFrame)
	slot0.healTF = slot0:findTF("resources/heal")
	slot0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(slot0.healTF, false)

	slot0.stages = slot0:findTF("stageScrollRect/stages", slot0.preViewerFrame)
	slot0.breakView = slot0:findTF("content/Text", slot0.preViewerFrame)
	slot0.previewAttrPanel = slot0:findTF("preview/attrs_panel/attr_panel")
	slot0.previewAttrContainer = slot0:findTF("content", slot0.previewAttrPanel)
	slot0.helpBtn = slot0:findTF("helpBtn", slot0.top)
	slot0.bottomWidth = slot0.bottomPanel.rect.height
	slot0.topWidth = slot0.topPanel.rect.height * 2
	slot0.taskTFs = {}
	slot0.leanTweens = {}
end

slot0.didEnter = function (slot0)
	slot1 = getProxy(TechnologyProxy):getConfigMaxVersion()

	if not slot0.contextData.shipBluePrintVO then
		slot2 = {}

		for slot6 = 1, slot1, 1 do
			slot2[slot6] = 0
		end

		for slot6, slot7 in pairs(slot0.bluePrintByIds) do
			slot2[slot7.version] = slot2[slot7.version] + ((slot7.state == ShipBluePrint.STATE_UNLOCK and 1) or 0)

			if slot7.state == ShipBluePrint.STATE_DEV then
				slot0.contextData.shipBluePrintVO = slot0.contextData.shipBluePrintVO or slot7

				break
			end
		end

		if not slot0.contextData.shipBluePrintVO then
			for slot6 = 1, slot1, 1 do
				slot0.version = slot6

				if slot2[slot6] <= 4 then
					break
				end
			end

			slot0:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, slot0.version)
		end
	end

	slot0:initShips()
	onButton(slot0, slot0.speedupBtn, function ()
		slot0:emit(ShipBluePrintMediator.ON_CLICK_SPEEDUP_BTN)
	end, SFX_PANEL)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(ShipBluePrintMediator.ON_MAIN)
	end, SOUND_BACK)
	onButton(slot0, slot0.startBtn, function ()
		if not slot0.contextData.shipBluePrintVO then
			return
		end

		slot0:emit(ShipBluePrintMediator.ON_START, slot0.contextData.shipBluePrintVO.id)
	end, SFX_PANEL)
	onButton(slot0, slot0.finishedBtn, function ()
		if not slot0.contextData.shipBluePrintVO then
			return
		end

		slot0:emit(ShipBluePrintMediator.ON_FINISHED, slot0.contextData.shipBluePrintVO.id)
	end, SFX_PANEL)
	onButton(slot0, slot0.preViewBtn, function ()
		slot0:openPreView()
	end, SFX_PANEL)
	onButton(slot0, slot0.seaLoading, function ()
		if not slot0.previewer then
			slot0:showBarrage()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.preViewer, function ()
		slot0:closePreview()
	end, SFX_PANEL)
	onButton(slot0, slot0.eyeTF, function ()
		slot0:hideUI()
	end, SFX_PANEL)
	onButton(slot0, slot0.main, function ()
		if slot0.flag then
			slot0:hideUI()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		slot0(pg.MsgboxMgr.GetInstance(), {
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[(isActive(slot0.fittingPanel) and "help_shipblueprintui_luck") or "help_shipblueprintui"].tip
		})
	end, SFX_PANEL)
	pg.UIMgr.GetInstance().OverlayPanelPB(slot2, slot0.blurPanel, {
		pbList = {
			slot0.rightPanel:Find("task_list"),
			slot0.rightPanel:Find("mod_panel"),
			slot0.leftPanle:Find("property_panel"),
			slot0.bottomPanel:Find("ships/bg")
		}
	})
	onButton(slot0, slot0:findTF("window/top/btnBack", slot0.msgPanel), function ()
		pg.UIMgr.GetInstance():UnblurPanel(slot0.msgPanel, slot0.top)
		setActive(slot0.msgPanel, false)
	end, SFX_CANCEL)
	setText(slot0.findTF(slot0, "window/confirm_btn/Text", slot0.msgPanel), i18n("text_confirm"))
	onButton(slot0, slot0:findTF("window/confirm_btn", slot0.msgPanel), function ()
		pg.UIMgr.GetInstance():UnblurPanel(slot0.msgPanel, slot0.top)
		setActive(slot0.msgPanel, false)
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("bg", slot0.msgPanel), function ()
		pg.UIMgr.GetInstance():UnblurPanel(slot0.msgPanel, slot0.top)
		setActive(slot0.msgPanel, false)
	end, SFX_CANCEL)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. slot0.version, slot0.versionBtn)

	if slot1 > 1 then
		onButton(slot0, slot0.versionBtn, function ()
			setActive(slot0.versionPanel, true)
			pg.UIMgr.GetInstance():BlurPanel(slot0.versionPanel)
		end, SFX_PANEL)
		onButton(slot0, slot0.versionPanel:Find("bg"), function ()
			pg.UIMgr.GetInstance():UnblurPanel(slot0.versionPanel, slot0._tf)
			setActive(slot0.versionPanel, false)
		end, SFX_CANCEL)

		for slot6 = 1, slot0.versionPanel.Find(slot2, "window/content").childCount, 1 do
			setActive(slot2:Find("version_" .. slot6), slot6 <= slot1)

			if slot6 <= slot1 then
				onButton(slot0, slot7, function ()
					slot0.version = slot1

					slot0:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, slot0.version)

					slot0.emit.contextData.shipBluePrintVO = nil

					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "version_" .. slot0.version, slot0.versionBtn)
					GetImageSpriteFromAtlasAsync:initShips()
					pg.UIMgr.GetInstance():UnblurPanel(slot0.versionPanel, slot0._tf)
					setActive(slot0.versionPanel, false)
				end, SFX_CANCEL)
			end
		end
	end

	LeanTween.alpha(rtf(slot0.skillArrLeft), 0.25, 1).setEase(slot2, LeanTweenType.easeInOutSine):setLoopPingPong()
	LeanTween.alpha(rtf(slot0.skillArrRight), 0.25, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
end

slot7 = 0.5

slot0.hideUI = function (slot0)
	LeanTween.cancel(slot0.bottomPanel)
	LeanTween.cancel(slot0.topPanel)
	LeanTween.cancel(slot0.topBg)
	slot0:switchUI(slot0, slot0.flag)

	slot0.flag = not slot0.flag

	if slot0.flag then
		LeanTween.moveY(slot0.bottomPanel, -slot0.bottomWidth, slot0)
		LeanTween.moveY(slot0.topPanel, slot0.topWidth, slot0)
		LeanTween.moveY(slot0.topBg, slot0.topWidth, slot0)
	else
		LeanTween.moveY(slot0.bottomPanel, 0, slot0)
		LeanTween.moveY(slot0.topPanel, 0, slot0)
		LeanTween.moveY(slot0.topBg, 0, slot0)
	end

	setActive(slot0.nameTF, not slot0.flag)
	setActive(slot0.stateInfo, not slot0.flag)
	setActive(slot0.helpBtn, not slot0.flag)
end

slot0.switchUI = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = nil
	slot6 = (slot2 or {
		-slot0.leftPanle.rect.width - 400,
		slot0.rightPanel.rect.width + 400,
		0
	}) and (slot3 or {
		0,
		0,
		0
	}) and {
		-slot0.leftPanle.rect.width - 400,
		0,
		-slot0.rightPanel.rect.width / 2
	}

	LeanTween.cancel(slot0.leftPanle)
	LeanTween.cancel(slot0.rightPanel)
	LeanTween.cancel(slot0.centerPanel)

	if slot0.cbTimer then
		slot0.cbTimer:Stop()

		slot0.cbTimer = nil
	end

	slot0.isSwitchAnim = true

	parallelAsync({
		function (slot0)
			LeanTween.moveX(slot0.leftPanle, slot1[1], ):setOnComplete(System.Action(slot0))
		end,
		function (slot0)
			LeanTween.moveX(slot0.rightPanel, slot1[2], ):setOnComplete(System.Action(slot0))
		end,
		function (slot0)
			LeanTween.moveX(slot0.centerPanel, slot1[3], ):setOnComplete(System.Action(slot0))
		end
	}, function ()
		if slot0 then
			slot1.cbTimer = Timer.New(function ()
				slot0.cbTimer = nil
				slot0.isSwitchAnim = false

				return existCall(false)
			end, slot1)

			slot1.cbTimer.Start(slot0)
		else
			slot1.isSwitchAnim = false

			return existCall(slot2)
		end
	end)
end

slot0.createShipItem = function (slot0, slot1)
	return {
		go = slot1,
		tf = tf(slot1),
		iconShip = findTF(()["tf"], "icon"):GetComponent("Image"),
		countTxt = findTF(()["tf"], "count"):GetComponent(typeof(Text)),
		seleted = findTF(()["tf"], "selected"),
		maskLock = findTF(()["tf"], "state/mask_lock"),
		maskDev = findTF(()["tf"], "state/mask_dev"),
		tip = findTF(()["tf"], "tip"),
		iconTF = findTF(()["tf"], "icon"),
		toggle = ()["tf"]:GetComponent("Toggle"),
		lvTF = findTF(()["tf"], "dev_lv"),
		lvTextTF = findTF(()["tf"], "dev_lv/Text"),
		update = function (slot0, slot1, slot2)
			slot0.toggle.enabled = slot1.id > 0
			slot0.shipBluePrintVO = slot1

			if slot0.shipBluePrintVO.id < 0 then
				setActive(slot0.seleted, false)
				setActive(slot0.maskLock, false)
				setActive(slot0.maskDev, false)
				setActive(slot0.tip, false)
				setActive(slot0.lvTF, false)
				setActive(slot0.countTxt, false)
				LoadSpriteAsync("shipdesignicon/empty", function (slot0)
					if slot0.shipBluePrintVO.id < 0 then
						slot0.iconShip.sprite = slot0
					end
				end)
			else
				LoadSpriteAsync("shipdesignicon/" .. slot3, function (slot0)
					if slot0.shipBluePrintVO.id > 0 and string.find(slot0.name, string.find) then
						slot0.iconShip.sprite = slot0
					end
				end)

				if slot2.count > 999 then
					slot0.countTxt.text = "999+"
				else
					slot0.countTxt.text = slot2.count
				end

				setText(slot0.lvTextTF, slot0.shipBluePrintVO.level)
				setActive(slot0.seleted, false)
				setActive(slot0.countTxt, true)
				setActive(slot0.maskLock, slot1.isLock(slot1))
				setActive(slot0.maskDev, slot1:isDeving())
				setActive(slot0.tip, slot1:isFinished())
				setActive(slot0.lvTF, not slot1:isLock() and not slot1:isDeving())
			end
		end,
		updateSelectedStyle = function (slot0, slot1)
			LeanTween.moveY(slot0.iconTF, (not slot1 or 0) and -25, 0.1)
		end
	}
end

slot0.initShips = function (slot0)
	slot0:checkStory()
	slot0:filterBlueprints()

	if not slot0.itemList then
		slot0.bluePrintItems = {}
		slot0.itemList = UIItemList.New(slot0.shipContainer, slot0.shipTpl)

		slot0.itemList:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventInit then
				slot0.bluePrintItems[slot2] = slot0:createShipItem(slot2)

				onToggle(slot0, slot2, function (slot0)
					if slot0 then
						slot0:clearLeanTween()

						slot0.contextData.shipBluePrintVO = slot0.bluePrintItems[slot0.contextData].shipBluePrintVO

						function slot1()
							slot0:setSelectedBluePrint()

							slot0.setSelectedBluePrint.nowShipId = slot0.contextData.shipBluePrintVO.id
						end

						if slot0.inFlag then
							if slot0.nowShipId ~= slot0.contextData.shipBluePrintVO.id then
								slot0.switchUI(slot3, 0.3, false, false, function ()
									slot0()
									slot1:switchUI(slot2, true, false)
								end, 0.1)
							else
								slot1()
							end
						else
							slot1()

							slot0.inFlag = true
							slot0.flag = true

							slot0:hideUI()
						end
					end

					slot0.bluePrintItems[]:updateSelectedStyle(slot0)
				end, SFX_PANEL)
			elseif slot0 == UIItemList.EventUpdate then
				if slot0.filterBlueprintVOs[slot1 + 1].id > 0 then
					slot0.bluePrintItems[slot2]:update(slot3, slot0:getItemById(slot4))
				else
					slot0.bluePrintItems[slot2]:update(slot3, nil)
				end

				triggerToggle(slot2, false)
				slot0.bluePrintItems[slot2]:updateSelectedStyle(false)
			end
		end)
	end

	setActive(slot0.shipContainer, false)
	slot0.itemList.align(slot1, #slot0.filterBlueprintVOs)
	setActive(slot0.shipContainer, true)

	if not slot0.contextData.shipBluePrintVO or underscore.all(slot0.filterBlueprintVOs, function (slot0)
		return slot0.contextData.shipBluePrintVO.id ~= slot0.id
	end) then
		slot0.contextData.shipBluePrintVO = slot0.filterBlueprintVOs[1]
	end

	eachChild(slot0.shipContainer, function (slot0)
		if slot0.contextData.shipBluePrintVO.id == slot0.bluePrintItems[slot0].shipBluePrintVO.id then
			triggerToggle(slot0, true)
		end
	end)
end

slot0.filterBlueprints = function (slot0)
	if slot0.contextData.shipBluePrintVO then
		slot0.version = slot0.contextData.shipBluePrintVO:getConfig("blueprint_version")

		slot0:emit(ShipBluePrintMediator.SET_TECHNOLOGY_VERSION, slot0.version)
	end

	slot0.filterBlueprintVOs = {}
	slot1 = 0

	for slot5, slot6 in pairs(slot0.bluePrintByIds) do
		if slot6.version == slot0.version then
			table.insert(slot0.filterBlueprintVOs, slot6)

			slot1 = slot1 + 1
		end
	end

	for slot5 = slot1, 5, 1 do
		table.insert(slot0.filterBlueprintVOs, {
			id = -1,
			state = -1
		})
	end

	table.sort(slot0.filterBlueprintVOs, function (slot0, slot1)
		if slot0.state == slot1.state then
			return slot0.id < slot1.id
		else
			return slot1.state < slot0.state
		end
	end)
end

slot0.setSelectedBluePrint = function (slot0)
	slot0:updateInfo()
	slot0:updatePainting()
	slot0:updateProperty()
	setActive(slot0.taskListPanel, not slot0.contextData.shipBluePrintVO.isUnlock(slot1))
	setActive(slot0.fittingPanel, slot0.contextData.shipBluePrintVO.isUnlock(slot1) and isActive(slot0.fittingPanel) and slot0.noUpdateMod)
	setActive(slot0.modPanel, slot2 and not isActive(slot0.fittingPanel))
	setActive(slot0.attrDisableBtn, not slot2)

	if slot2 then
		slot0:updateMod()
	else
		slot0:updateTaskList()
		triggerToggle(slot0.initBtn, true)
	end

	if slot1:isDeving() then
		slot0:emit(ShipBluePrintMediator.ON_CHECK_TAKES, slot1.id)
	end
end

slot0.updateMod = function (slot0)
	if slot0.noUpdateMod then
		return
	end

	slot0:updateModPanel()
	slot0:updateModAdditionPanel()
end

slot0.updateModInfo = function (slot0, slot1)
	slot2 = slot0:getShipById(slot1.shipId)
	slot4 = intProperties(slot0.contextData.shipBluePrintVO.getShipProperties(slot3, slot2))
	slot5 = intProperties(slot1:getShipProperties(slot2))
	slot6 = Clone(slot1)
	slot6.level = slot6:getMaxLevel()
	slot7 = intProperties(slot6:getShipProperties(slot2))

	function slot8(slot0, slot1, slot2, slot3)
		slot4 = slot0:findTF("attr_bg/name", slot0)
		slot5 = slot0:findTF("attr_bg/value", slot0)
		slot6 = slot0:findTF("attr_bg/max", slot0)
		slot7 = slot0:findTF("slider", slot0):GetComponent(typeof(Slider))
		slot8 = slot0:findTF("pre_slider", slot0):GetComponent(typeof(Slider))
		slot9 = slot0:findTF("exp", slot0)

		if slot1:isMaxLevel() then
			slot3 = slot2
		end

		setText(slot6, slot3)
		setText(slot4, AttributeType.Type2Name(slot1))
		setText(slot5, slot2)

		slot19, slot11 = slot2:getBluePrintAddition(slot1)
		slot7.value = slot11 / slot2:getExpRetio(slot12)
		slot18, slot20 = slot1:getBluePrintAddition(slot1)

		setText(slot9, math.floor(slot15) .. "/" .. slot2.getExpRetio(slot12))

		slot8.value = (math.floor(slot10) < math.floor(slot14) and 1) or slot15 / slot1:getExpRetio(slot12)
	end

	slot9 = 0

	for slot13, slot14 in pairs(slot5) do
		if table.contains(ShipModAttr.BLUEPRINT_ATTRS, slot13) then
			slot9 = slot9 + 1

			slot8(slot0.attrContainer:Find(slot13), slot13, slot14, slot7[slot13] or 0)
		end
	end

	slot0.modLevel.text = slot0:formatModLvTxt(slot1.level, slot1:getMaxLevel())

	if slot3:getNextLevelExp() == -1 then
		slot0.levelSlider.value = 1
	else
		slot0.levelSlider.value = slot3.exp / slot10
	end

	if slot1:getNextLevelExp() == -1 then
		setText(slot0.levelSliderTxt, "MAX")

		slot0.preLevelSlider.value = 1
	else
		setText(slot0.levelSliderTxt, slot1.exp .. "/" .. slot1:getNextLevelExp())

		slot0.preLevelSlider.value = (slot3.level < slot1.level and 1) or slot1.exp / slot10
	end

	slot15, slot12 = slot1:isShipModMaxLevel(slot2)

	setActive(slot0.needLevelTxt, slot11)
	setActive(slot0.levelSliderTxt, not slot11)

	if slot11 then
		setText(slot0.needLevelTxt, i18n("buleprint_need_level_tip", slot12))

		slot0.levelSlider.value = 1
	end
end

slot0.inModAnim = function (slot0)
	return slot0.inAnim
end

slot0.formatModLvTxt = function (slot0, slot1, slot2)
	return "<size=45>" .. slot1 .. "</size>/<size=27>" .. slot2 .. "</size>"
end

slot8 = 0.2

slot0.doModAnim = function (slot0, slot1, slot2)
	slot0:clearLeanTween()

	slot0.inAnim = true
	slot3 = {}

	if slot1.level ~= slot2:getMaxLevel() then
		function slot5(slot0, slot1, slot2)
			Clone(slot0).level = slot1
			Clone(slot0).exp = slot2

			return Clone(slot0)
		end

		slot0.preLevelSlider.value = 0

		for slot9 = slot1.level, slot2.level, 1 do
			slot10 = (slot9 == slot1.level and slot1.exp / slot1.getNextLevelExp(slot1)) or 0
			slot11 = (slot9 == slot2.level and slot2.level ~= slot4 and slot2.exp / slot2:getNextLevelExp()) or 1

			table.insert(slot3, function (slot0)
				TweenValue(go(slot0.levelSlider), TweenValue, , , nil, function (slot0)
					slot0.levelSlider.value = slot0
				end, function ()
					slot4:doAttrsAinm((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0), (((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0)) == slot3.level and slot3) or slot2(slot2, ((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0)) + 1, 0), )

					slot4.modLevel.text = (slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0):formatModLvTxt((((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0)) == slot3.level and slot3) or slot2(slot2, ((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0)) + 1, 0).level, (((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0)) == slot3.level and slot3) or slot2(slot2, ((slot0 == slot1.level and slot1) or slot2(slot1, slot2, 0)) + 1, 0))
				end)
			end)
		end

		table.insert(slot0.leanTweens, slot0.levelSlider)
	else
		slot4 = slot2.getMaxFateLevel(slot2)

		function slot5(slot0, slot1, slot2)
			Clone(slot0).fateLevel = slot1
			Clone(slot0).exp = slot2

			return Clone(slot0)
		end

		slot0.prePhaseSlider.value = 0

		for slot9 = slot1.fateLevel, slot2.fateLevel, 1 do
			slot10 = (slot9 == slot1.fateLevel and slot1.exp / slot1.getNextFateLevelExp(slot1)) or 0
			slot11 = (slot9 == slot2.fateLevel and slot2.fateLevel ~= slot4 and slot2.exp / slot2:getNextFateLevelExp()) or 1

			table.insert(slot3, function (slot0)
				TweenValue(go(slot0.phaseSlider), TweenValue, , , nil, function (slot0)
					slot0.phaseSlider.value = slot0
				end, function ()
					slot4:updateFittingAttrPanel((((slot0 == slot1.fateLevel and slot1) or slot2(slot1, slot2, 0)) == slot3.fateLevel and slot3) or slot2(slot2, ((slot0 == slot1.fateLevel and slot1) or slot2(slot1, slot2, 0)) + 1, 0))
					GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.min((((slot0 == slot1.fateLevel and slot1) or slot2(slot1, slot2, 0)) == slot3.fateLevel and slot3) or slot2(slot2, ((slot0 == slot1.fateLevel and slot1) or slot2(slot1, slot2, 0)) + 1, 0).fateLevel + 1, (((slot0 == slot1.fateLevel and slot1) or slot2(slot1, slot2, 0)) == slot3.fateLevel and slot3) or slot2(slot2, ((slot0 == slot1.fateLevel and slot1) or slot2(slot1, slot2, 0)) + 1, 0):getMaxFateLevel()), slot4.phasePic, true)
					slot4.phasePic()
				end)
			end)
		end

		table.insert(slot0.leanTweens, slot0.phaseSlider)
	end

	seriesAsync(slot3, function ()
		slot0.noUpdateMod = false

		slot0:updateMod()

		slot0.updateMod.inAnim = false
	end)
end

slot0.doAttrsAinm = function (slot0, slot1, slot2, slot3)
	slot4 = {}
	slot6 = intProperties(slot1:getShipProperties(slot5))
	slot7 = intProperties(slot2:getShipProperties(slot5))

	for slot11, slot12 in ipairs(ShipModAttr.BLUEPRINT_ATTRS) do
		if slot12 ~= AttributeType.AntiAircraft then
			slot13 = slot0.attrContainer:Find(slot12)
			slot14 = slot0:findTF("attr_bg/value", slot13):GetComponent(typeof(Text))
			slot15 = slot0:findTF("slider", slot13):GetComponent(typeof(Slider))
			slot19 = slot6[slot12]
			slot20 = slot7[slot12]
			slot21, slot22 = slot1:getBluePrintAddition(slot12)
			slot23, slot24 = slot2:getBluePrintAddition(slot12)
			slot25 = slot22 / slot1:getExpRetio(slot17)
			slot26 = slot24 / slot1.getExpRetio(slot17)
			slot0:findTF("pre_slider", slot13):GetComponent(typeof(Slider)).value = 0

			table.insert(slot4, function (slot0)
				slot0:doAttrAnim(slot0.doAttrAnim, slot0, , , math.floor(slot5), math.floor(slot6), , , slot0)
			end)
		end
	end

	parallelAsync(slot4, slot3)
end

slot9 = 0.1

slot0.doAttrAnim = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9)
	table.insert(slot0.leanTweens, slot1)

	slot10 = {}

	for slot14 = slot5, slot6, 1 do
		slot15 = (slot14 == slot5 and slot3) or 0
		slot16 = (slot14 == slot6 and slot4) or 1

		table.insert(slot10, function (slot0)
			TweenValue(go(slot0), TweenValue, , , nil, function (slot0)
				slot0.value = slot0
			end, function ()
				slot0.text = slot1 - math.min(slot2 - , slot1 - )

				slot1()
			end)
		end)
	end

	seriesAsync(slot10, function ()
		slot0()
	end)
end

slot0.clearLeanTween = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.leanTweens) do
		if LeanTween.isTweening(go(slot6)) then
			LeanTween.cancel(go(slot6))
		end
	end

	if slot0.inAnim then
		slot0.inAnim = nil

		if not slot1 then
			slot0.noUpdateMod = false
		end
	end

	slot0.leanTweens = {}
end

slot0.updateModPanel = function (slot0)
	slot2 = slot0:getShipById(slot0.contextData.shipBluePrintVO.shipId)
	slot5 = slot0:getItemById(slot0.contextData.shipBluePrintVO.getConfig(slot1, "strengthen_item")).count == 0 and slot1:isPursuing()
	slot6 = 0
	slot7, slot8 = nil

	if slot5 then
		slot7 = math.min(getProxy(TechnologyProxy).calcMaxPursuingCount(slot9, slot1), slot1:getUseageMaxItem())

		function slot8(slot0)
			slot1 = slot0:getItemExp()
			slot3 = Clone(slot0)

			slot3:addExp(slot2)
			slot1:updateModInfo(slot3)
			setText(slot1.calcTxt, slot0)
			setText(slot1.itemInfoIcon:Find("icon_bg/count"), slot0:getPursuingPrice(TechnologyProxy.getPursuingDiscount(slot2.pursuingTimes + slot3 + 1)))
			setActive(slot1.itemInfo:Find("no_cost"), TechnologyProxy.getPursuingDiscount(slot2.pursuingTimes + slot3 + 1) == 0)
			setActive(slot1.itemInfo:Find("discount"), slot4 > 0 and slot4 < 100)

			if slot4 > 0 and slot4 < 100 then
				setText(slot1.itemInfo:Find("discount/Text"), 100 - slot4 .. "%OFF")
			end

			setActive(slot1.modBtn:Find("pursuing_cost"), slot3 > 0)
			setText(slot1.modBtn:Find("pursuing_cost/Text"), slot2:calcPursuingCost(slot0, slot0))
		end

		updateDrop(slot0.itemInfoIcon, slot10)
		onButton(slot0, slot0.itemInfoIcon, function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
		setScrollText(findTF(slot0.itemInfo, "name/Text"), HXSet.hxLan(({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		})["cfg"].name))
		setText(slot0.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy).getRawData(slot15):getResource(PlayerConst.ResGold))
		setText(slot0.itemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(slot0.modBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(slot0, slot0.modBtn, function ()
			if slot0:inModAnim() then
				return
			end

			if slot1 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", slot2:calcPursuingCost(i18n, pg.MsgboxMgr.GetInstance())),
				onYes = function ()
					slot0:emit(ShipBluePrintMediator.ON_PURSUING, slot1.id, )
				end
			})
		end, SFX_PANEL)
	else
		slot7 = math.min(slot4.count, slot1.getUseageMaxItem(slot1))

		function slot8(slot0)
			slot1 = slot0:getItemExp()
			slot3 = Clone(slot0)

			slot3:addExp(slot2)
			slot1:updateModInfo(slot3)
			setText(slot1.calcTxt, slot0)
		end

		updateDrop(slot0.itemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = slot4.id
		})
		onButton(slot0, slot0.itemInfoIcon, function ()
			ItemTipPanel.ShowItemTipbyID(slot0.id, i18n("title_item_ways", HXSet.hxLan(slot0:getConfig("name"))))
		end, SFX_PANEl)
		setScrollText(findTF(slot0.itemInfo, "name/Text"), HXSet.hxLan(slot4.getConfig(slot4, "name")))
		setText(slot0.itemInfoCount, i18n("tec_tip_material_stock") .. ":" .. slot4.count)
		setActive(slot0.itemInfo:Find("no_cost"), false)
		setActive(slot0.itemInfo:Find("discount"), false)
		setActive(slot0.modBtn:Find("pursuing_cost"), false)
		onButton(slot0, slot0.modBtn, function ()
			if slot0:inModAnim() then
				return
			end

			if slot1 == 0 then
				return
			end

			slot0:emit(ShipBluePrintMediator.ON_MOD, slot2.id, slot0)
		end, SFX_PANEL)
	end

	slot8(slot6)
	pressPersistTrigger(slot0.calcMinBtn, 0.5, function (slot0)
		if slot0:inModAnim() or slot1:isMaxLevel() or slot2 == 0 then
			if slot0 then
				slot0()
			end

			return
		end

		0(math.max(slot2 - 1, 0))
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(slot0.calcMaxBtn, 0.5, function (slot0)
		if slot0:inModAnim() or slot1:isMaxLevel() then
			if slot0 then
				slot0()
			end

			return
		end

		slot4 = Clone(slot1)

		slot4:addExp(slot3)

		if slot3.level < slot4:getStrengthenConfig(math.min(slot4.level + 1, slot4:getMaxLevel())).need_lv and slot2 <= slot4.exp then
			if slot0 then
				slot0()
			end

			return
		end

		if slot4.level == slot4:getMaxLevel() and slot2 <= slot4.exp then
			if slot0 then
				slot0()
			end

			return
		end

		slot5(math.max(math.min(slot2 + 1, slot4), 0))
	end, nil, true, true, 0.1, SFX_PANEL)

	function slot9(slot0)
		setActive(slot0.calcPanel, not slot0)
		setActive(slot0.fittingBtn, slot0)
		setActive(slot0.fittingBtnEffect, false)
	end

	slot9(false)

	if slot1:canFateSimulation() then
		onButton(slot0, slot0.fittingBtn, function ()
			if slot0.isSwitchAnim then
				return
			end

			setActive(slot0.fittingBtnEffect, true)

			slot0.cbTimer = Timer.New(function ()
				slot0.cbTimer = nil

				slot0:switchUI(slot0, false, true, function ()
					setActive(slot0.modPanel, false)
					setActive(slot0.fittingPanel, true)
					setActive(slot0.fittingBtnEffect, false)

					if not PlayerPrefs.HasKey("first_fate") then
						triggerButton(slot0.helpBtn)
						PlayerPrefs.SetInt("first_fate", 1)
						PlayerPrefs.Save()
					end

					slot0:switchUI(slot0, true, true)
				end, 0.1)
			end, 0.6)

			slot0.cbTimer.Start(slot1)
		end, SFX_PANEL)
		slot0.updateFittingPanel(slot0)
		pg.NewStoryMgr.GetInstance():Play(slot1:getConfig("luck_story"), function (slot0)
			slot1 = (slot0 and {
				function (slot0)
					slot0:buildStartAni("fateStartWindow", slot0)
				end
			}) or {}

			seriesAsync(slot1, function ()
				slot0(true)
			end)
		end)
	end
end

slot0.updateFittingPanel = function (slot0)
	slot2 = slot0:getShipById(slot0.contextData.shipBluePrintVO.shipId)
	slot5 = slot0:getItemById(slot0.contextData.shipBluePrintVO.getConfig(slot1, "strengthen_item")).count == 0 and slot1:isPursuing()
	slot6 = 0
	slot7, slot8 = nil

	if slot5 then
		slot7 = math.min(getProxy(TechnologyProxy).calcMaxPursuingCount(slot9, slot1), slot1:getFateUseageMaxItem())

		function slot8(slot0)
			slot1 = slot0:getItemExp()
			slot3 = Clone(slot0)

			slot3:addExp(slot2)
			slot1:updateFittingInfo(slot3)
			setText(slot1.fittingCalcTxt, slot0)
			setText(slot1.fittingItemInfoIcon:Find("icon_bg/count"), slot0:getPursuingPrice(TechnologyProxy.getPursuingDiscount(slot2.pursuingTimes + slot3 + 1)))
			setActive(slot1.fittingItemInfo:Find("no_cost"), TechnologyProxy.getPursuingDiscount(slot2.pursuingTimes + slot3 + 1) == 0)
			setActive(slot1.fittingItemInfo:Find("discount"), slot4 > 0 and slot4 < 100)

			if slot4 > 0 and slot4 < 100 then
				setText(slot1.fittingItemInfo:Find("discount/Text"), 100 - slot4 .. "%OFF")
			end

			setActive(slot1.fittingConfirmBtn:Find("pursuing_cost"), slot0 > 0)
			setText(slot1.fittingConfirmBtn:Find("pursuing_cost/Text"), slot2:calcPursuingCost(slot0, slot0))
		end

		updateDrop(slot0.fittingItemInfoIcon, slot10)
		onButton(slot0, slot0.fittingItemInfoIcon, function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
		setScrollText(findTF(slot0.fittingItemInfo, "name/Text"), HXSet.hxLan(({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold
		})["cfg"].name))
		setText(slot0.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. getProxy(PlayerProxy).getRawData(slot15):getResource(PlayerConst.ResGold))
		setText(slot0.fittingItemInfo:Find("no_cost/Text"), i18n("tec_tip_no_consumption"))
		setText(slot0.fittingConfirmBtn:Find("pursuing_cost/word"), i18n("tec_tip_to_consumption"))
		onButton(slot0, slot0.fittingConfirmBtn, function ()
			if slot0:inModAnim() then
				return
			end

			if slot1 == 0 then
				return
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_catchup_by_gold_confirm", slot2:calcPursuingCost(i18n, pg.MsgboxMgr.GetInstance())),
				onYes = function ()
					slot0:emit(ShipBluePrintMediator.ON_PURSUING, slot1.id, )
				end
			})
		end, SFX_PANEL)
	else
		slot7 = math.min(slot4.count, slot1.getFateUseageMaxItem(slot1))

		function slot8(slot0)
			slot1 = slot0:getItemExp()
			slot3 = Clone(slot0)

			slot3:addExp(slot2)
			slot1:updateFittingInfo(slot3)
			setText(slot1.fittingCalcTxt, slot0)
		end

		updateDrop(slot0.fittingItemInfoIcon, {
			type = DROP_TYPE_ITEM,
			id = slot4.id
		})
		onButton(slot0, slot0.fittingItemInfoIcon, function ()
			ItemTipPanel.ShowItemTipbyID(slot0.id, i18n("title_item_ways", HXSet.hxLan(slot0:getConfig("name"))))
		end, SFX_PANEl)
		setScrollText(slot0.fittingItemInfo.Find(slot10, "name/Text"), HXSet.hxLan(slot4:getConfig("name")))
		setText(slot0.fittingItemInfoCount, i18n("tec_tip_material_stock") .. ":" .. slot4.count)
		setActive(slot0.fittingItemInfo:Find("no_cost"), false)
		setActive(slot0.fittingItemInfo:Find("discount"), false)
		setActive(slot0.fittingConfirmBtn:Find("pursuing_cost"), false)
		onButton(slot0, slot0.fittingConfirmBtn, function ()
			if slot0:inModAnim() then
				return
			end

			if slot1 == 0 then
				return
			end

			slot0:emit(ShipBluePrintMediator.ON_MOD, slot2.id, slot0)
		end, SFX_PANEL)
	end

	setText(slot0.fittingAttrPanel.Find(slot10, "attr/name"), AttributeType.Type2Name(AttributeType.Luck))
	setText(slot0.fittingPanel:Find("desc/top/text/Text"), i18n("fate_phase_word"))
	onButton(slot0, slot0.fittingCancelBtn, function ()
		slot0:switchUI(0.3, false, false, function ()
			setActive(slot0.modPanel, true)
			setActive(slot0.fittingPanel, false)
			setActive:switchUI(setActive, true, false)
		end, 0.1)
	end, SFX_PANEL)
	pressPersistTrigger(slot0.fittingCalcMinBtn, 0.5, function (slot0)
		if slot0:inModAnim() or slot1:isMaxFateLevel() or slot2 == 0 then
			if slot0 then
				slot0()
			end

			return
		end

		0(math.max(slot2 - 1, 0))
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(slot0.fittingCalcMaxBtn, 0.5, function (slot0)
		if slot0:inModAnim() or slot1:isMaxFateLevel() then
			if slot0 then
				slot0()
			end

			return
		end

		slot4 = Clone(slot1)

		slot4:addExp(slot3)

		if slot3.level < slot4:getFateStrengthenConfig(math.min(slot4.fateLevel + 1, slot4:getMaxFateLevel())).need_lv and slot2 <= slot4.exp then
			if slot0 then
				slot0()
			end

			return
		end

		if slot4.fateLevel == slot4:getMaxFateLevel() and slot2 <= slot4.exp then
			if slot0 then
				slot0()
			end

			return
		end

		slot5(math.max(math.min(slot2 + 1, slot4), 0))
	end, nil, true, true, 0.1, SFX_PANEL)
	setActive(slot10, false)

	slot11 = {
		0,
		-60,
		0,
		60
	}
	slot12 = {}

	for slot16 = 1, slot1:getMaxFateLevel(), 1 do
		slot17 = slot9:Find("phase_" .. slot16) or cloneTplTo(slot10, slot9, "phase_" .. slot16)
		slot20 = nil

		for slot24, slot25 in ipairs(slot19) do
			if slot25[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				slot20 = slot25[2][2]

				break
			end
		end

		for slot24, slot25 in ipairs({
			"off",
			"on"
		}) do
			setActive(slot17:Find(slot25 .. "/icon"), not slot20)
			setActive(slot17:Find(slot25 .. "/skill"), slot20)
			setActive(slot17:Find(slot25 .. "/icon/line"), slot11[slot16])
			setActive(slot17:Find(slot25 .. "/skill/line"), slot11[slot16])

			if slot11[slot16] then
				slot17:Find(slot25 .. "/icon/line").localEulerAngles = Vector3(0, 0, slot11[slot16])
				slot17:Find(slot25 .. "/skill/line").localEulerAngles = Vector3(0, 0, slot11[slot16])

				GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", slot16 .. "_" .. slot25, slot17:Find(slot25 .. "/icon/icon"), true)
			end
		end

		if slot20 then
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_" .. slot20, "", slot17:Find("off/skill/icon"), true)
			GetImageSpriteFromAtlasAsync("tecfateskillicon/skill_on_" .. slot20, "", slot17:Find("on/skill/icon"), true)

			slot12[slot16] = 55
		else
			slot12[slot16] = 40
		end

		onButton(slot0, slot17, function ()
			slot0:showFittingMsgPanel(slot0)
		end, SFX_PANEL)
	end

	slot13 = Vector2.zero
	slot14 = Vector2.zero
	slot15 = Vector2.zero

	for slot19 = 1, slot1.getMaxFateLevel(slot1), 1 do
		setAnchoredPosition(slot20, slot13)

		slot14.x = math.min(slot14.x, slot13.x)
		slot14.y = math.min(slot14.y, slot13.y)
		slot15.x = math.max(slot15.x, slot13.x)
		slot15.y = math.max(slot15.y, slot13.y)

		if slot11[slot19] then
			slot13 = slot13 + (slot12[slot19] + slot12[slot19 + 1]) * Vector2(math.cos((math.pi * slot11[slot19]) / 180), math.sin((math.pi * slot11[slot19]) / 180))
		end
	end

	setSizeDelta(slot9, slot15 - slot14)
	setAnchoredPosition(slot9, {
		y = -slot15.y
	})
	slot8(slot6)
end

slot0.updateFittingInfo = function (slot0, slot1)
	slot2 = slot0:getShipById(slot1.shipId)

	slot0:updateFittingAttrPanel(slot3, slot1)
	GetImageSpriteFromAtlasAsync("ui/shipblueprintui_atlas", "phase_" .. math.max(slot1.fateLevel, 1), slot0.phasePic, true)

	if slot0.contextData.shipBluePrintVO:getNextFateLevelExp() == -1 then
		slot0.phaseSlider.value = 1
	else
		slot0.phaseSlider.value = slot3.exp / slot4
	end

	if slot1:getNextFateLevelExp() == -1 then
		setText(slot0.phaseSliderTxt, "MAX")

		slot0.prePhaseSlider.value = 1
	else
		setText(slot0.phaseSliderTxt, tostring(slot5) .. "%")

		slot0.prePhaseSlider.value = (slot3.fateLevel < slot1.fateLevel and 1) or slot1.exp / slot4
	end

	slot9, slot6 = slot1:isShipModMaxFateLevel(slot2)

	setActive(slot0.fittingNeedMask, slot5)

	if slot5 then
		setText(slot0:findTF("limit", slot0.fittingNeedMask), i18n("buleprint_need_level_tip", slot6))

		slot0.phaseSlider.value = 1
	end
end

slot0.updateFittingAttrPanel = function (slot0, slot1, slot2)
	setText(slot0:findTF("attr/name/Text", slot0.fittingAttrPanel), " + " .. defaultValue(slot2 or slot1:attrSpecialAddition()[AttributeType.Luck], 0))

	slot0.blinkTarget = slot0.blinkTarget or {
		{},
		{}
	}

	for slot6 = 1, slot1:getMaxFateLevel(), 1 do
		slot8 = slot0:findTF("off", slot7)
		slot9 = slot0:findTF("on", slot0:findTF("phase_panel/phase_" .. slot6, slot0.fittingAttrPanel))

		if slot2 and slot1.fateLevel < slot6 and slot6 <= slot2.fateLevel then
			setActive(slot8, true)
			setActive(slot9, true)

			if not table.contains(slot0.blinkTarget[1], slot8) then
				table.insert(slot0.blinkTarget[1], slot8)
				table.insert(slot0.blinkTarget[2], slot9)
			end
		else
			if table.indexof(slot0.blinkTarget[1], slot8) then
				table.remove(slot0.blinkTarget[1], slot10)
				table.remove(slot0.blinkTarget[2], slot10)
			end

			setActive(slot8, slot1.fateLevel < slot6)
			setActive(slot9, slot6 <= slot1.fateLevel)

			slot8:GetComponent(typeof(CanvasGroup)).alpha = 1
			slot9:GetComponent(typeof(CanvasGroup)).alpha = 1
		end
	end

	if #slot0.blinkTarget[1] == 0 then
		LeanTween.cancel(go(slot0.fittingAttrPanel))
	elseif not LeanTween.isTweening(go(slot0.fittingAttrPanel)) then
		LeanTween.value(go(slot0.fittingAttrPanel), 1, 0, 0.8):setOnUpdate(System.Action_float(function (slot0)
			for slot4, slot5 in ipairs(slot0.blinkTarget[1]) do
				slot5:GetComponent(typeof(CanvasGroup)).alpha = slot0
			end

			for slot4, slot5 in ipairs(slot0.blinkTarget[2]) do
				slot5:GetComponent(typeof(CanvasGroup)).alpha = 1 - slot0
			end
		end)).setEase(slot3, LeanTweenType.easeInOutSine):setLoopPingPong(0)
	end
end

slot0.updateModAdditionPanel = function (slot0)
	for slot7 = slot0.modAdditionContainer.childCount - 1, #slot0.contextData.shipBluePrintVO.specialStrengthens(slot1), 1 do
		slot0:cloneTplTo(slot0.modAdditionTpl, slot0.modAdditionContainer)
	end

	for slot7 = 1, slot0.modAdditionContainer.childCount, 1 do
		setActive(slot0.modAdditionContainer:GetChild(slot7 - 1), slot7 <= #slot2)

		if slot7 <= #slot2 then
			slot0:updateAdvanceTF(slot1, slot9, slot2[slot7])
		end
	end
end

slot0.updateAdvanceTF = function (slot0, slot1, slot2, slot3)
	setActive(slot2:Find("mask"), slot1.level < slot3.level)

	if slot1.level < slot3.level then
		setText(slot2:Find("mask/content/Text"), i18n("blueprint_mod_addition_lock", slot3.level))
	end

	slot5 = slot3.des
	slot6 = slot3.extraDes or {}

	removeAllChildren(slot7)

	slot8 = slot0:findTF("scroll_rect/info", slot0.modAdditionPanel)

	function slot9(slot0, slot1)
		slot7 = Ship.New({
			configId = slot1[2]
		}).getStar(slot4)
		slot8 = slot0:Find("star_tpl")

		removeAllChildren(slot9)
		removeAllChildren(slot10)

		for slot14 = 1, Ship.New({
			configId = pg.ship_data_breakout[slot1[2]].pre_id
		}).getStar(slot5), 1 do
			cloneTplTo(slot8, slot9)
		end

		for slot14 = 1, slot7, 1 do
			cloneTplTo(slot8, slot10)
		end
	end

	for slot13 = 1, #slot5, 1 do
		slot14 = cloneTplTo(slot8, slot7)

		setActive(slot15, false)
		setActive(slot14:Find("attr_tpl"), false)
		setActive(slot16, false)
		setActive(slot14:Find("empty_tpl"), false)

		if slot5[slot13] then
			if slot5[slot13][1] == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
				setActive(slot16, true)
				slot9(slot16, slot5[slot13])
			else
				setActive(slot15, true)
				setText(slot15:Find("Text"), slot5[slot13][3])
			end
		else
			setActive(empty_tpl, true)
		end
	end

	for slot13 = 1, #slot6, 1 do
		slot14 = cloneTplTo(slot8, slot7)
		slot15 = slot14:Find("text_tpl")

		setActive(slot15, true)
		setActive(slot14:Find("attr_tpl"), false)
		setActive(slot14:Find("breakout_tpl"), false)
		setActive(slot14:Find("empty_tpl"), false)
		setText(slot15:Find("Text"), slot6[slot13])
	end
end

slot0.updateInfo = function (slot0)
	slot2 = nil

	if slot0.contextData.shipBluePrintVO:isFetched() then
		slot2 = slot0.shipVOs[slot1.shipId]
	end

	setText(slot0.shipName, slot4)
	setText(slot0.englishName, slot2 or slot1:getShipVO():getConfigTable().english_name)
	removeAllChildren(slot0.stars)

	slot5 = slot2 or slot1.getShipVO():getStar()

	for slot10 = 1, slot2:getMaxStar(), 1 do
		cloneTplTo(slot0.shipInfoStarTpl, slot0.stars, "star_" .. slot10)
	end

	for slot11 = 1, slot6 - slot5, 1 do
		slot12 = slot0.stars:GetChild(slot6 - slot11)

		setActive(slot12:Find("star_tpl"), false)
		setActive(slot12:Find("empty_star_tpl"), true)
	end

	if not GetSpriteFromAtlas("shiptype", slot2:getShipType()) then
		warning("找不到船形, shipConfigId: " .. slot2.configId)
	end

	setImageSprite(slot0.shipType, slot8, true)

	slot9 = slot1:isLock()

	setActive(slot0.finishedBtn, slot1:isFinished())
	setActive(slot0.progressPanel, slot1:isDeving())

	if not slot1.isDeving() then
		setActive(slot0.speedupBtn, false)
	end

	if slot10 then
		slot0:updateTasksProgress()
	end

	slot11 = slot1:isFinishPrevTask(true)

	if slot9 and not slot11 then
		if slot1:isFinishPrevTask() then
			for slot15, slot16 in ipairs(slot1:getOpenTaskList()) do
				slot0:emit(ShipBluePrintMediator.ON_FINISH_TASK, slot16)
			end

			slot11 = true
		else
			slot12 = getProxy(TaskProxy)

			for slot17, slot18 in ipairs(slot13) do
				slot19 = slot12:getTaskVO(slot18)

				setActive((slot0.lockPanel.childCount < slot17 and cloneTplTo(slot0.lockBtn, slot0.lockPanel)) or slot0.lockPanel:GetChild(slot17 - 1), true)
				setText(slot0:findTF("Text", (slot0.lockPanel.childCount < slot17 and cloneTplTo(slot0.lockBtn, slot0.lockPanel)) or slot0.lockPanel.GetChild(slot17 - 1)), ((slot19:getConfig("target_num") <= slot19:getProgress() and setColorStr(slot21, COLOR_GREEN)) or slot21) .. "/" .. slot22)
			end

			for slot17 = #slot13 + 1, slot0.lockPanel.childCount, 1 do
				setActive(slot0.lockPanel:GetChild(slot17 - 1), false)
			end
		end
	end

	setText(slot0:findTF("Text", slot0.openCondition), slot1:getConfig("unlock_word"))
	setActive(slot0.openCondition, slot9)
	setActive(slot0.startBtn, slot9 and slot11)
	setActive(slot0.lockPanel, slot9 and not slot11)
end

slot0.updateTasksProgress = function (slot0)
	for slot7 = slot0.progressContainer.childCount, #slot0.contextData.shipBluePrintVO.getTaskIds(slot1), 1 do
		cloneTplTo(slot0.progressTpl, slot0.progressContainer)
	end

	for slot7 = 1, slot0.progressContainer.childCount, 1 do
		setActive(slot0.progressContainer:GetChild(slot7 - 1), slot7 <= #slot2)

		if slot9 then
			setActive(findTF(slot8, "complete"), slot1:getTaskStateById(slot2[slot7]) == ShipBluePrint.TASK_STATE_FINISHED)
			setActive(findTF(slot8, "lock"), slot10 == ShipBluePrint.TASK_STATE_LOCK or slot10 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(findTF(slot8, "working"), slot10 == ShipBluePrint.TASK_STATE_ACHIEVED or slot10 == ShipBluePrint.TASK_STATE_OPENING or slot10 == ShipBluePrint.TASK_STATE_START)
		end
	end

	if pg.gameset.technology_catchup_itemid.description[slot1:getConfig("blueprint_version")] then
		setActive(slot0.speedupBtn, (slot1:getTaskStateById(slot2[1]) == ShipBluePrint.TASK_STATE_START or slot1:getTaskStateById(slot2[4]) == ShipBluePrint.TASK_STATE_START) and getProxy(BagProxy):getItemCountById(slot8) > 0)
	else
		setActive(slot0.speedupBtn, false)
	end
end

slot0.updatePainting = function (slot0)
	slot2 = slot0.contextData.shipBluePrintVO.getShipVO(slot1)

	if slot0.lastPaintingName and slot0.lastPaintingName ~= slot2:getPainting() then
		retPaintingPrefab(slot0.painting, slot0.lastPaintingName)
	end

	setPaintingPrefab(slot0.painting, slot2:getPainting(), "tuzhi")

	slot0.lastPaintingName = slot2.getPainting()

	slot0:paintBreath()
end

slot0.updateProperty = function (slot0)
	slot0.propertyPanel:initProperty(slot0.contextData.shipBluePrintVO.getShipVO(slot1).configId, PropertyPanel.TypeFlat)

	for slot9 = slot0.skillPanel.childCount, #slot0[slot0.contextData.shipBluePrintVO.getShipVO(slot1).configId].buff_list_display - 1, 1 do
		cloneTplTo(slot0.skillTpl, slot0.skillPanel)
	end

	for slot9 = 1, slot0.skillPanel.childCount, 1 do
		slot11 = slot9 <= #slot4
		slot12 = findTF(slot0.skillPanel:GetChild(slot9 - 1), "icon")

		if slot11 then
			LoadImageSpriteAsync("skillicon/" .. getSkillConfig(slot13).icon, slot12)
			onButton(slot0, slot10, function ()
				slot0:emit(ShipBluePrintMediator.SHOW_SKILL_INFO, slot1.id, {
					id = slot1.id,
					level = pg.skill_data_template[slot1.id].max_level
				}, function ()
					return
				end)
			end, SFX_PANEL)
		end

		setActive(slot10, slot11)
	end

	setActive(slot0.skillArrLeft, #slot4 > 3)
	setActive(slot0.skillArrRight, #slot4 > 3)

	if #slot4 > 3 then
		onScroll(slot0, slot0.skillRect, function (slot0)
			setActive(slot0.skillArrLeft, slot0.x > 0.01)
			setActive(slot0.skillArrRight, slot0.x < 0.99)
		end)
	else
		GetComponent(slot0.skillRect, typeof(ScrollRect)).onValueChanged.RemoveAllListeners(slot6)
	end

	setAnchoredPosition(slot0.skillPanel, {
		x = 0
	})
	setActive(slot0.simulationBtn, slot1:getConfig("simulate_dungeon") ~= 0)
	onButton(slot0, slot0.simulationBtn, function ()
		if slot0 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tech_simulate_closed"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("blueprint_simulation_confirm_" .. slot1.id),
				onYes = function ()
					slot0:emit(ShipBluePrintMediator.SIMULATION_BATTLE, slot0)
				end
			})
		end
	end, SFX_CONFIRM)
end

slot0.updateTaskList = function (slot0)
	for slot7 = slot0.taskContainer.childCount, #slot0.contextData.shipBluePrintVO.getTaskIds(slot1), 1 do
		cloneTplTo(slot0.taskTpl, slot0.taskContainer)
	end

	for slot7 = 1, slot0.taskContainer.childCount, 1 do
		setActive(slot0.taskContainer:GetChild(slot7 - 1), slot7 <= #slot2)

		if slot0.taskTFs[slot7] then
			slot0.taskTFs[slot7]:clear()
		end

		if slot7 <= #slot2 then
			if not slot0.taskTFs[slot7] then
				slot0.taskTFs[slot7] = slot0:createTask(slot8)
			end

			slot10 = slot0:getTaskById(slot9)

			if slot1.duration > 0 then
				slot10.leftTime = slot1:getTaskOpenTimeStamp(slot9) - slot1.duration
			end

			slot10.taskState = slot1:getTaskStateById(slot9)
			slot10.dueTime = slot1:getTaskOpenTimeStamp(slot9)
			slot10.index = slot7

			slot0.taskTFs[slot7]:update(slot10)
		end
	end
end

slot0.createTask = function (slot0, slot1)
	onToggle(slot0, slot1, function (slot0)
		setActive(slot0.desc, slot0)
		setActive(slot0.progreshadow, slot0)

		if slot0 then
			Canvas.ForceUpdateCanvases()

			slot4 = 0

			if Canvas.ForceUpdateCanvases.taskContainer.parent.transform:InverseTransformPoint(slot2.position).y - Canvas.ForceUpdateCanvases.taskContainer.parent.transform.rect.height < slot1.taskContainer.parent.transform.rect.yMin then
				slot4 = slot3.yMin - slot2
			end

			if slot3.yMax < slot1 then
				slot4 = slot3.yMax - slot1
			end

			slot1.taskContainer.localPosition.y = slot1.taskContainer.localPosition.y + slot4
			slot1.taskContainer.localPosition = slot1.taskContainer.localPosition
			slot0.progreshadow.localPosition = Vector3(39, -((148 + slot0.desc.rect.height) - 150))
		end
	end, SFX_PANEL)

	return {
		title = slot0:findTF("title/name", slot1),
		desc = slot0:findTF("desc/Text", slot1),
		timerTF = slot0:findTF("title/timer", slot1),
		timerTFTxt = slot0:findTF("title/timer/Text", slot1),
		timerOpen = slot0:findTF("title/timer/open", slot1),
		timerClose = slot0:findTF("title/timer/close", slot1),
		maskAchieved = slot0:findTF("title/slider/complete", slot1),
		tip = slot0:findTF("title/tip", slot1),
		commitBtn = slot0:findTF("desc/commit_panel/commit_btn", slot1),
		itemInfo = slot0:findTF("desc/item_info", slot1),
		itemContainer = slot0:findTF("items", ()["itemInfo"]),
		itemTpl = slot0:findTF("item_tpl", ()["itemContainer"]),
		numberTF = slot0:findTF("title/number", slot1),
		progressTF = slot0:findTF("title/slider", slot1),
		progessSlider = ()["progressTF"]:GetComponent(typeof(Slider)),
		lockBtn = slot0:findTF("desc/commit_panel/lock_btn", slot1),
		itemCount = ()["itemTpl"]:Find("award/icon_bg/count"),
		progres = slot0:findTF("desc/commit_panel/progress", slot1),
		progreshadow = slot0:findTF("title/shadow", slot1),
		check = findTF(slot1, "title/complete"),
		lock = findTF(slot1, "title/lock"),
		working = findTF(slot1, "title/working"),
		pause = findTF(slot1, "title/pause"),
		pauseLock = findTF(slot1, "title/pause_lock"),
		view = slot0,
		update = function (slot0, slot1)
			slot0:clearTimer()

			slot0.autoCommit = true
			slot0.isExpTask = false

			removeOnButton(slot0.commitBtn)
			slot0:updateItemInfo(slot1)
			slot0:updateView(slot1)
			slot0:updateProgress(slot1)
		end,
		updateItemInfo = function (slot0, slot1)
			slot0.taskVO = slot1

			changeToScrollText(slot0.title, slot1:getConfig("name"))
			setText(slot0.desc, slot1:getConfig("desc") .. "\n\n")

			slot2 = nil
			slot3 = slot1:getConfig("target_num")

			if slot1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
				slot0.autoCommit = false
				slot2 = slot1:getConfig("target_id_for_client")
			elseif slot4 == TASK_SUB_TYPE_PLAYER_RES then
				slot0.autoCommit = false
				slot2 = id2ItemId(slot1:getConfig("target_id_for_client"))
			elseif slot4 == TASK_SUB_TYPE_BATTLE_EXP then
				slot0.isExpTask = true
				slot2 = 59000
			end

			setActive(slot0.itemContainer, not slot0.autoCommit or slot0.isExpTask)

			if slot2 then
				updateDrop(slot0.itemTpl:Find("award"), {
					type = 2,
					id = slot2,
					count = slot3
				})
				setText(slot0.itemCount, (slot3 > 1000 and math.floor(slot3 / 1000) .. "K") or slot3)
			end

			setText(slot0.numberTF, slot1.index)
		end,
		updateView = function (slot0, slot1)
			slot3 = false
			slot4 = false
			slot5 = false

			if slot1.taskState == ShipBluePrint.TASK_STATE_PAUSE and slot1.leftTime then
				slot3 = getProxy(TaskProxy):getTaskVO(slot1.id) and slot6:isFinish()
				slot5 = slot1.leftTime > 0
				slot4 = slot6 and slot6:isReceive()

				if slot1.leftTime > 0 then
					setText(slot0.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(slot1.leftTime))
				end
			end

			setActive(slot0.pause, (ShipBluePrint.TASK_STATE_PAUSE == slot2 and not slot3 and not slot5) or (ShipBluePrint.TASK_STATE_PAUSE == slot2 and not slot5 and slot3 and not slot0.autoCommit))
			setActive(slot0.pauseLock, ShipBluePrint.TASK_STATE_PAUSE == slot2 and not slot3 and slot5)
			setActive(slot0.lockBtn, slot2 ~= ShipBluePrint.TASK_STATE_ACHIEVED and (slot2 ~= ShipBluePrint.TASK_STATE_START or not not slot0.autoCommit))
			setActive(slot0.commitBtn, slot2 == ShipBluePrint.TASK_STATE_ACHIEVED or (slot2 == ShipBluePrint.TASK_STATE_START and not slot0.autoCommit))
			setActive(slot0.progressTF, slot2 == ShipBluePrint.TASK_STATE_ACHIEVED or slot2 == ShipBluePrint.TASK_STATE_START or slot2 == ShipBluePrint.TASK_STATE_FINISHED or (slot2 == ShipBluePrint.TASK_STATE_PAUSE and not slot5))
			setActive(slot0.lock, slot2 == ShipBluePrint.TASK_STATE_LOCK or slot2 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(slot0.working, slot2 == ShipBluePrint.TASK_STATE_OPENING or slot2 == ShipBluePrint.TASK_STATE_START or slot2 == ShipBluePrint.TASK_STATE_ACHIEVED)
			setActive(slot0.maskAchieved, slot2 == ShipBluePrint.TASK_STATE_FINISHED or (slot2 == ShipBluePrint.TASK_STATE_PAUSE and slot4))
			setActive(slot0.timerTF, slot2 == ShipBluePrint.TASK_STATE_WAIT or (slot2 == ShipBluePrint.TASK_STATE_PAUSE and slot1.leftTime and slot1.leftTime > 0))
			setActive(slot0.check, (slot0.autoCommit and slot2 == TASK_STATE_ACHIEVED) or slot2 == ShipBluePrint.TASK_STATE_FINISHED or (slot2 == ShipBluePrint.TASK_STATE_PAUSE and slot4))
			setActive(slot0.tip, slot2 == ShipBluePrint.TASK_STATE_ACHIEVED)
			setActive(slot0.timerOpen, slot2 == ShipBluePrint.TASK_STATE_WAIT)
			setActive(slot0.timerClose, slot2 == ShipBluePrint.TASK_STATE_PAUSE and slot1.leftTime and slot1.leftTime > 0)
		end,
		updateProgress = function (slot0, slot1)
			slot3 = slot1:getProgress() / slot1:getConfig("target_num")

			if slot1.taskState == ShipBluePrint.TASK_STATE_WAIT then
				slot0:addTimer(slot1, slot1.dueTime)

				slot3 = 0
			elseif slot2 == ShipBluePrint.TASK_STATE_OPENING then
				slot3 = 0

				slot0.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, slot1.id)
			elseif slot2 == ShipBluePrint.TASK_STATE_PAUSE then
				if slot1:isReceive() then
					slot3 = 1
				end
			elseif slot2 == ShipBluePrint.TASK_STATE_LOCK then
				slot3 = 0
			elseif slot2 == ShipBluePrint.TASK_STATE_ACHIEVED then
				onButton(slot0.view, slot0.commitBtn, function ()
					slot0.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, slot1.id)
				end, SFX_PANEL)

				slot3 = 1
			elseif slot2 == ShipBluePrint.TASK_STATE_FINISHED then
				slot3 = 1
			elseif slot2 == ShipBluePrint.TASK_STATE_START and not slot0.autoCommit then
				onButton(slot0.view, slot0.commitBtn, function ()
					slot0.view:emit(ShipBluePrintMediator.ON_FINISH_TASK, slot1.id)
				end, SFX_PANEL)

				slot3 = 0
			end

			if slot3 > 0 then
				slot0.itemSliderLT = LeanTween.value(go(slot0.progressTF), 0, math.min(slot3, 1), 0.5 * math.min(slot3, 1)):setOnUpdate(System.Action_float(function (slot0)
					slot0.progessSlider.value = slot0
				end)).uniqueId
			else
				slot0.progessSlider.value = slot3
			end

			setText(slot0.progres, math.ceil(math.min(slot4, 100)) .. "%")
			setText(slot0.progreshadow, math.min(slot4, 100) .. "%")
		end,
		addTimer = function (slot0, slot1, slot2)
			slot0:clearTimer()

			slot0.taskTimer = Timer.New(function ()
				if slot0 - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
					setText(slot1.timerTFTxt, pg.TimeMgr.GetInstance():DescCDTime(slot1))
				else
					slot1:clearTimer()
					setText(slot1.timerTFTxt, "00:00:00")
					slot1.view:emit(ShipBluePrintMediator.ON_TASK_OPEN, slot2.id)
				end
			end, 1, -1)

			slot0.taskTimer.Start(slot3)
			slot0.taskTimer.func()
		end,
		clearTimer = function (slot0)
			if slot0.taskTimer then
				slot0.taskTimer:Stop()

				slot0.taskTimer = nil
			end
		end,
		clear = function (slot0)
			slot0:clearTimer()

			if slot0.itemSliderLT then
				LeanTween.cancel(slot0.itemSliderLT)

				slot0.itemSliderLT = nil
			end
		end
	}
end

slot0.openPreView = function (slot0)
	if slot0.contextData.shipBluePrintVO then
		setActive(slot0.preViewer, true)
		setParent(slot0.blurPanel, slot0._tf)
		pg.UIMgr.GetInstance():BlurPanel(slot0.preViewer)
		slot0:playLoadingAni()

		slot0.viewShipVO = slot1:getShipVO()
		slot0.breakIds = slot0:getStages(slot0.viewShipVO)

		for slot5 = 1, slot0, 1 do
			slot7 = slot1[slot0.breakIds[slot5]]

			onToggle(slot0, slot0:findTF("stage" .. slot5, slot0.stages), function (slot0)
				if slot0 then
					setText(slot0.breakView, slot1[slot0.breakView].breakout_view)
					slot0:switchStage(slot0)
				end
			end, SFX_PANEL)

			if slot5 == 1 then
				triggerToggle(slot8, true)
			end
		end

		slot0.isShowPreview = true

		slot0:updateMaxLevelAttrs(slot1)
	end
end

slot0.MAX_LEVEL_ATTRS = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.ArmorType,
	AttributeType.Dodge
}

slot0.updateMaxLevelAttrs = function (slot0, slot1)
	if not slot1:isFetched() then
		return
	end

	Clone(slot2).level = 120
	slot4 = Clone(slot1)
	slot4.level = slot1:getMaxLevel()
	slot5 = intProperties(slot4:getShipProperties(slot3, false))

	for slot9, slot10 in ipairs(slot0.MAX_LEVEL_ATTRS) do
		slot11 = slot0.previewAttrContainer:Find(slot10)

		if slot10 == AttributeType.ArmorType then
			setText(slot11:Find("bg/value"), slot2:getShipArmorName())
		else
			setText(slot11:Find("bg/value"), slot5[slot10] or 0)
		end

		setText(slot11:Find("bg/name"), AttributeType.Type2Name(slot10))
	end
end

slot0.closePreview = function (slot0, slot1)
	if slot0.previewer then
		slot0.previewer:clear()

		slot0.previewer = nil
	end

	setActive(slot0.preViewer, false)
	setActive(slot0.rawImage, false)

	if not slot1 then
		SetParent(slot0.blurPanel, pg.UIMgr.GetInstance().OverlayMain)
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0.preViewer, slot0._tf)

	slot0.isShowPreview = nil
end

slot0.playLoadingAni = function (slot0)
	setActive(slot0.seaLoading, true)
end

slot0.stopLoadingAni = function (slot0)
	setActive(slot0.seaLoading, false)
end

slot0.showBarrage = function (slot0)
	slot0.previewer = WeaponPreviewer.New(slot0.rawImage)

	slot0.previewer:configUI(slot0.healTF)
	slot0.previewer:setDisplayWeapon(slot0:getWaponIdsById(slot0.breakOutId))
	slot0.previewer:load(40000, slot0.viewShipVO, slot0:getAllWeaponIds(), function ()
		slot0:stopLoadingAni()
	end)
end

slot0.getWaponIdsById = function (slot0, slot1)
	return slot0[slot1].weapon_ids
end

slot0.getAllWeaponIds = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.breakIds) do
		setmetatable(slot1, {
			__add = function (slot0, slot1)
				for slot5, slot6 in ipairs(slot0) do
					if not table.contains(slot1, slot6) then
						table.insert(slot1, slot6)
					end
				end

				return slot1
			end
		})

		slot1 = slot1 + Clone(slot0[slot6].weapon_ids)
	end

	return slot1
end

slot0.getStages = function (slot0, slot1)
	slot2 = {}
	slot3 = math.floor(slot1.configId / 10)

	for slot7 = 1, 4, 1 do
		table.insert(slot2, tonumber(slot3 .. slot7))
	end

	return slot2
end

slot0.switchStage = function (slot0, slot1)
	if slot0.breakOutId == slot1 then
		return
	end

	slot0.breakOutId = slot1

	if slot0.previewer then
		slot0.previewer:setDisplayWeapon(slot0:getWaponIdsById(slot0.breakOutId))
	end
end

slot0.clearTimers = function (slot0)
	slot1 = pairs
	slot2 = slot0.taskTFs or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:clear()
	end
end

slot0.cloneTplTo = function (slot0, slot1, slot2)
	slot3 = tf(Instantiate(slot1))

	SetActive(slot3, true)
	slot3:SetParent(tf(slot2), false)

	return slot3
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.versionPanel) then
		triggerButton(slot0.versionPanel:Find("bg"))

		return
	end

	if slot0.isShowPreview then
		slot0:closePreview(true)

		return
	end

	if slot0.awakenPlay or slot0:inModAnim() then
		return
	end

	slot0:emit(slot0.ON_BACK_PRESSED)
end

slot0.willExit = function (slot0)
	if isActive(slot0.msgPanel) then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.msgPanel, slot0._tf)
		setActive(slot0.msgPanel, false)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.blurPanel, slot0._tf)
	LeanTween.cancel(go(slot0.fittingAttrPanel))

	if slot0.lastPaintingName then
		retPaintingPrefab(slot0.painting, slot0.lastPaintingName)
	end

	slot1 = pairs
	slot2 = slot0.taskTFs or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:clear()
	end

	slot0:closePreview(true)
	slot0:clearLeanTween(true)

	if slot0.previewer then
		slot0.previewer:clear()

		slot0.previewer = nil
	end
end

slot0.paintBreath = function (slot0)
	LeanTween.cancel(go(slot0.painting))
	LeanTween.moveY(rtf(slot0.painting), slot0, LeanTween.moveY):setLoopPingPong():setEase(LeanTweenType.easeInOutCubic):setFrom(0)
end

slot0.buildStartAni = function (slot0, slot1, slot2)
	if slot1 == "researchStartWindow" then
		slot0.progressPanel.localScale = Vector3(0, 1, 1)

		LeanTween.scale(slot0.progressPanel, Vector3(1, 1, 1), 0.2):setDelay(2)
	end

	function slot3()
		slot0.awakenAni:SetActive(true)

		slot0.awakenAni.SetActive.awakenPlay = true
		slot0 = tf(slot0.awakenAni)

		pg.UIMgr.GetInstance():BlurPanel(slot0)
		slot0:SetAsLastSibling()
		slot0:GetComponent("DftAniEvent"):SetEndEvent(function (slot0)
			if not IsNil(slot0.awakenAni) then
				pg.UIMgr.GetInstance():UnblurPanel(pg.UIMgr.GetInstance().UnblurPanel, slot0.blurPanel)
				slot0.awakenAni:SetActive(false)

				slot0.awakenPlay = false

				if false then
					slot2()
				end
			end
		end)
	end

	slot0.awakenAni = slot0.findTF(slot0, slot1 .. "(Clone)") and go(slot4)

	if not slot0.awakenAni then
		PoolMgr.GetInstance():GetUI(slot1, true, function (slot0)
			slot0:SetActive(true)

			slot0.awakenAni = slot0

			slot0()
		end)
	else
		slot3()
	end
end

slot0.showFittingMsgPanel = function (slot0, slot1)
	pg.UIMgr.GetInstance():BlurPanel(slot0.msgPanel)
	setActive(slot0.msgPanel, true)

	slot3 = slot0.contextData.shipBluePrintVO.getMaxFateLevel(slot2)
	slot4 = slot0:findTF("window/content", slot0.msgPanel)
	slot8 = slot0:findTF("skill_panel", slot4)
	slot9 = slot0:findTF("phase", slot4)
	slot10 = {
		"I",
		"II",
		"III",
		"IV",
		"V"
	}

	onButton(slot0, slot5, function ()
		slot0 = slot0 - 1

		slot1()
	end)
	onButton(slot0, slot6, function ()
		slot0 = slot0 + 1

		slot1()
	end)
	setText(slot0.findTF(slot0, "desc", slot0:findTF("attrl_panel", slot4)), i18n("fate_attr_word"))
	function ()
		slot0(slot1, setActive > 1)
		setActive(slot1, setActive > 1 < slot3)
		setText(slot4, "PHASE." .. slot5[slot4])

		slot2 = nil
		slot3 = {}

		for slot7, slot8 in ipairs(slot1) do
			if slot8[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
				slot2 = slot8[2][2]
			elseif slot9 == ShipBluePrint.STRENGTHEN_TYPE_ATTR then
				table.insert(slot3, slot8[2])
			end
		end

		setActive(slot7, #slot3 > 0)
		setActive(slot8, slot2)

		if slot2 then
			GetImageSpriteFromAtlasAsync("skillicon/" .. getSkillConfig(slot2).icon, "", slot9:findTF("skill_icon", slot9.findTF))
			setText(slot9:findTF("skill_name", ), getSkillName(slot2))
			setText(slot9:findTF("skill_lv", slot9), "Lv." .. slot5)
			setText(slot9:findTF("help_panel/skill_intro", slot9), getSkillDescGet(slot2))
		end

		if #slot3 > 0 then
			for slot7, slot8 in ipairs(slot3) do
				setText((slot7 < slot7.childCount and slot7:GetChild(slot7)) or cloneTplTo(slot7:GetChild(slot7 - 1), slot7):Find("name"), AttributeType.Type2Name(slot8[1]))
				setText((slot7 < slot7.childCount and slot7:GetChild()) or cloneTplTo(slot7.GetChild(slot7 - 1), slot7):Find("number"), " + " .. slot8[2])
			end

			for slot7 = #slot3 + 1, slot7.childCount - 1, 1 do
				setActive(slot7:GetChild(slot7), false)
			end
		end
	end()
end

slot0.checkStory = function (slot0)
	slot1 = {
		nil,
		"FANGAN3"
	}
	slot0.storyMgr = slot0.storyMgr or pg.NewStoryMgr.GetInstance()

	if slot1[slot0.version] and not slot0.storyMgr:IsPlayed(slot1[slot0.version]) then
		slot0.storyMgr:Play(slot1[slot0.version])
	end
end

return slot0

slot0 = class("PizzahutPTPage", import(".TemplatePage.PtTemplatePage"))
slot0.FADE_TIME = 0.5
slot0.SHOW_TIME = 1
slot0.FADE_OUT_TIME = 0.5
slot0.Menu_Ani_Open_Time = 0.5
slot0.Menu_Ani_Close_Time = 0.3
slot0.PosList = {
	-256,
	-150,
	-50,
	55,
	160,
	263
}
slot0.Pizza_Save_Tag_Pre = "Pizza_Tag_"

slot0.OnDataSetting = function (slot0)
	slot0.super.OnDataSetting(slot0)

	slot0.specialPhaseList = slot0.activity:getConfig("config_data")
	slot0.selectedList = slot0:getSelectedList()
	slot0.curSelectOrder = 0
	slot0.curSelectIndex = 0
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	slot0:findUI()
	slot0:initMainPanel()
	slot0:addListener()
	slot0:initSD()
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot1, slot2, slot3 = slot0.ptData:GetResProgress()

	setText(slot0.progress, ((slot3 >= 1 and setColorStr(slot1, "#947D80FF")) or slot1) .. "/" .. slot2)
	slot0:updatePizza()
	slot0:updateMainSelectPanel()
	setActive(slot0.openBtn, slot0:isFinished())
	setActive(slot0.shareBtn, slot0:isFinished())
	onButton(slot0, slot0.battleBtn, function ()
		slot0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

slot0.OnDestroy = function (slot0)
	if slot0.spine then
		slot0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("chuixue_6", slot0.spine)

		slot0.spine = nil
	end

	if slot0.shareGo then
		PoolMgr.GetInstance():ReturnUI("PizzahutSharePage", slot0.shareGo)

		slot0.shareGo = nil
	end
end

slot0.findUI = function (slot0)
	slot0.shareBtn = slot0:findTF("share_btn", slot0.bg)
	slot0.empty = slot0:findTF("empty", slot0.bg)
	slot0.pizzaTF = slot0:findTF("Pizza", slot0.bg)
	slot0.openBtn = slot0:findTF("open_btn", slot0.bg)
	slot0.helpBtn = slot0:findTF("help_btn", slot0.bg)
	slot0.specialTF = slot0:findTF("Special")
	slot0.backBG = slot0:findTF("BG", slot0.specialTF)
	slot0.closeBtn = slot0:findTF("CloseBtn", slot0.specialTF)
	slot0.menuTF = slot0:findTF("Menu", slot0.specialTF)
	slot0.mainPanel = slot0:findTF("MainPanel", slot0.menuTF)
	slot0.mainToggleTFList = {}

	for slot4 = 1, 6, 1 do
		slot0.mainToggleTFList[slot4] = slot0.mainPanel:GetChild(slot4 - 1)
	end

	slot0.secondPanel = slot0:findTF("SecondList", slot0.menuTF)
	slot0.selectBtn = slot0:findTF("SelectBtn", slot0.menuTF)
	slot0.mainPanelCG = GetComponent(slot0.mainPanel, "CanvasGroup")
	slot0.secondPanelCG = GetComponent(slot0.secondPanel, "CanvasGroup")
	slot0.selectBtnImg = GetComponent(slot0.selectBtn, "Image")
	slot0.resTF = slot0:findTF("Res")
	slot0.iconTable = {
		["1"] = {
			slot0:findTF("1/1", slot0.resTF),
			slot0:findTF("1/2", slot0.resTF),
			slot0:findTF("1/3", slot0.resTF)
		},
		["21"] = {
			slot0:findTF("2/1/1", slot0.resTF),
			slot0:findTF("2/1/2", slot0.resTF),
			slot0:findTF("2/1/3", slot0.resTF)
		},
		["22"] = {
			slot0:findTF("2/2/1", slot0.resTF),
			slot0:findTF("2/2/2", slot0.resTF),
			slot0:findTF("2/2/3", slot0.resTF)
		},
		["23"] = {
			slot0:findTF("2/3/1", slot0.resTF),
			slot0:findTF("2/3/2", slot0.resTF),
			slot0:findTF("2/3/3", slot0.resTF)
		},
		["311"] = {
			slot0:findTF("3/1/1", slot0.resTF)
		},
		["312"] = {
			slot0:findTF("3/1/2", slot0.resTF)
		},
		["313"] = {
			slot0:findTF("3/1/3", slot0.resTF)
		},
		["321"] = {
			slot0:findTF("3/2/1", slot0.resTF)
		},
		["322"] = {
			slot0:findTF("3/2/2", slot0.resTF)
		},
		["323"] = {
			slot0:findTF("3/2/3", slot0.resTF)
		},
		["331"] = {
			slot0:findTF("3/3/1", slot0.resTF)
		},
		["332"] = {
			slot0:findTF("3/3/2", slot0.resTF)
		},
		["333"] = {
			slot0:findTF("3/3/3", slot0.resTF)
		},
		["4"] = {
			slot0:findTF("4/1", slot0.resTF),
			slot0:findTF("4/2", slot0.resTF),
			slot0:findTF("4/3", slot0.resTF)
		},
		["5"] = {
			slot0:findTF("5/1", slot0.resTF),
			slot0:findTF("5/2", slot0.resTF),
			slot0:findTF("5/3", slot0.resTF)
		},
		["6"] = {
			slot0:findTF("6/1", slot0.resTF),
			slot0:findTF("6/2", slot0.resTF),
			slot0:findTF("6/3", slot0.resTF)
		}
	}
	slot0.pizzaResTF = slot0:findTF("Pizza")
	slot0.mainToggleSelectedTF = {}

	for slot34, slot35 in ipairs(slot0.mainToggleTFList) do
		slot0.mainToggleSelectedTF[slot34] = slot35:GetChild(0)
	end

	slot0.selectedIconResTF = slot0:findTF("SelectedIcon")
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.getBtn, function ()
		slot4, slot1, slot2 = slot0.ptData:GetLevelProgress()

		if table.indexof(slot0.specialPhaseList, slot0, 1) then
			slot0:openMainPanel(slot3)
		else
			slot4 = {}
			slot7 = getProxy(PlayerProxy).getData(slot6)

			if slot0.ptData:GetAward().type == DROP_TYPE_RESOURCE and slot5.id == PlayerConst.ResGold and slot7:GoldMax(slot5.count) then
				table.insert(slot4, function (slot0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
						onYes = slot0
					})
				end)
			end

			seriesAsync(slot4, function ()
				slot2, slot5.arg1 = slot0.ptData:GetResProgress()

				slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = slot0.ptData:GetId(),
					arg1 = slot1
				})
			end)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.openBtn, function ()
		slot0:openMainPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.pizzahut_help.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.shareBtn, function ()
		slot0:share()
	end, SFX_PANEL)
end

slot0.initMainPanel = function (slot0)
	onButton(slot0, slot0.backBG, function ()
		slot0:closeSpecial()

		if slot0.closeSpecial:isFinished() then
			setActive(slot0.openBtn, true)
		end
	end, SFX_CANCEL)

	for slot4, slot5 in ipairs(slot0.mainToggleTFList) do
		onToggle(slot0, slot5, function (slot0)
			slot0.curSelectOrder = slot0

			if slot0 == true then
				setLocalPosition(slot0.secondPanel, {
					x = slot2.PosList[]
				})
				setLocalPosition(slot0.selectBtn, {
					x = slot2.PosList[]
				})

				slot2 = nil

				if slot2.PosList[] == 1 then
					slot2 = slot0.iconTable.1
				elseif slot1 == 2 then
					slot2 = slot0.iconTable[2 .. slot0.selectedList[1]]
				elseif slot1 == 3 then
					slot2 = slot0.iconTable[3 .. slot0.selectedList[1] .. slot0.selectedList[2]]
				elseif slot1 >= 4 and slot1 <= 6 then
					slot2 = slot0.iconTable[tostring(slot1)]
				end

				slot3 = {}

				for slot7 = 1, 3, 1 do
					slot3[slot7] = slot0.secondPanel:GetChild(slot7 - 1)
				end

				if #slot2 == 1 then
					setActive(slot3[2], false)
					setActive(slot3[3], false)
					setImageSprite(slot0:findTF("icon", slot3[1]), slot4, true)
					onToggle(slot0, slot3[1], function (slot0)
						if slot0 == true then
							slot0:openSelectBtn()

							slot0.curSelectIndex = 1
						end
					end, SFX_PANEL)
					triggerToggle(slot3[1], true)
				else
					setActive(slot3[2], true)
					setActive(slot3[3], true)

					for slot7 = 1, 3, 1 do
						setImageSprite(slot0.findTF(slot10, "icon", slot3[slot7]), slot8, true)
						onToggle(slot0, slot3[slot7], function (slot0)
							if slot0 == true then
								slot0:openSelectBtn()

								slot0.curSelectIndex = slot0
							else
								setActive(slot0.selectBtn, false)

								slot0.curSelectIndex = 0
							end
						end, SFX_PANEL)
					end
				end

				for slot7 = 1, 3, 1 do
					triggerToggle(slot3[slot7], false)
				end

				slot0.openSecondPanel(slot4)
				setActive(slot0.selectBtn, false)
			else
				setActive(slot0.secondPanel, false)
				setActive(slot0.selectBtn, false)
			end

			slot0:updateMainSelectPanel()
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.selectBtn, function ()
		if not slot0:isFinished() then
			if slot0.curSelectIndex then
				slot2, slot5.arg1 = slot0.ptData:GetResProgress()

				slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
					cmd = 1,
					activity_id = slot0.ptData:GetId(),
					arg1 = slot1,
					arg2 = slot0.curSelectIndex,
					callback = function ()
						slot0.selectedList[slot0.curSelectOrder] = slot0.curSelectIndex

						slot0.selectedList:closeSpecial()
					end
				})
			end
		else
			slot0.changeIndexSelect(slot0)
			slot0.changeIndexSelect:updatePizza()
			slot0.changeIndexSelect.updatePizza:updateMainSelectPanel()
		end
	end, SFX_PANEL)
end

slot0.openMainPanel = function (slot0, slot1)
	slot0.selectedList = slot0:getSelectedList()

	setActive(slot0.openBtn, false)

	for slot5 = 1, 6, 1 do
		triggerToggle(slot0.mainToggleTFList[slot5], false)

		GetComponent(slot0.mainToggleTFList[slot5], "Toggle").interactable = slot0:isFinished()
	end

	slot0:updateMainSelectPanel()
	setActive(slot0.specialTF, true)
	LeanTween.value(go(slot0.mainPanel), 0, 1, slot0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function (slot0)
		slot0.mainPanelCG.alpha = slot0
	end)).setOnComplete(slot2, System.Action(function ()
		slot0.mainPanelCG.alpha = 1
	end))
	LeanTween.value(go(slot0.mainPanel), -640, 0, slot0.Menu_Ani_Open_Time).setOnUpdate(slot2, System.Action_float(function (slot0)
		setLocalPosition(slot0.mainPanel, {
			x = slot0
		})
	end)).setOnComplete(slot2, System.Action(function ()
		setLocalPosition(slot0.mainPanel, {
			x = 0
		})

		if slot0.mainPanel and slot1 > 0 then
			triggerToggle(slot0.mainToggleTFList[], true)
		end
	end))
end

slot0.closeMainPanel = function (slot0)
	LeanTween.value(go(slot0.mainPanel), 1, 0, slot0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function (slot0)
		slot0.mainPanelCG.alpha = slot0
	end)).setOnComplete(slot1, System.Action(function ()
		slot0.mainPanelCG.alpha = 0

		setActive(slot0.specialTF, false)
	end))
	LeanTween.value(go(slot0.mainPanel), 0, -640, slot0.Menu_Ani_Close_Time).setOnUpdate(slot1, System.Action_float(function (slot0)
		setLocalPosition(slot0.mainPanel, {
			x = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setLocalPosition(slot0.mainPanel, {
			x = -640
		})
		setActive(slot0.specialTF, false)
	end))
end

slot0.openSecondPanel = function (slot0)
	setActive(slot0.secondPanel, true)
	LeanTween.value(go(slot0.secondPanel), 0, 1, slot0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function (slot0)
		slot0.secondPanelCG.alpha = slot0
	end)).setOnComplete(slot1, System.Action(function ()
		slot0.secondPanelCG.alpha = 1
	end))
	LeanTween.value(go(slot0.secondPanel), -530, -60, slot0.Menu_Ani_Open_Time).setOnUpdate(slot1, System.Action_float(function (slot0)
		setLocalPosition(slot0.secondPanel, {
			y = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setLocalPosition(slot0.secondPanel, {
			y = -60
		})
	end))
end

slot0.closeSecondPanel = function (slot0)
	LeanTween.value(go(slot0.secondPanel), 1, 0, slot0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function (slot0)
		slot0.secondPanelCG.alpha = slot0
	end)).setOnComplete(slot1, System.Action(function ()
		slot0.secondPanelCG.alpha = 0

		setActive(slot0.secondPanel, false)
	end))
	LeanTween.value(go(slot0.secondPanel), -60, -530, slot0.Menu_Ani_Close_Time).setOnUpdate(slot1, System.Action_float(function (slot0)
		setLocalPosition(slot0.secondPanel, {
			y = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setLocalPosition(slot0.secondPanel, {
			y = -530
		})
		setActive(slot0.secondPanel, false)
		setActive:closeMainPanel()
	end))
end

slot0.openSelectBtn = function (slot0)
	setActive(slot0.selectBtn, true)
	LeanTween.value(go(slot0.selectBtn), 0, 1, slot0.Menu_Ani_Open_Time):setOnUpdate(System.Action_float(function (slot0)
		setImageAlpha(slot0.selectBtn, slot0)
	end)).setOnComplete(slot1, System.Action(function ()
		setImageAlpha(slot0.selectBtn, 1)
	end))
	LeanTween.value(go(slot0.selectBtn), -145, -210, slot0.Menu_Ani_Open_Time).setOnUpdate(slot1, System.Action_float(function (slot0)
		setLocalPosition(slot0.selectBtn, {
			y = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setLocalPosition(slot0.selectBtn, {
			y = -210
		})
	end))
end

slot0.closeSelectBtn = function (slot0)
	LeanTween.value(go(slot0.selectBtn), 1, 0, slot0.Menu_Ani_Close_Time):setOnUpdate(System.Action_float(function (slot0)
		setImageAlpha(slot0.selectBtn, slot0)
	end)).setOnComplete(slot1, System.Action(function ()
		setImageAlpha(slot0.selectBtn, 0)
		setActive(slot0.selectBtn, false)
	end))
	LeanTween.value(go(slot0.selectBtn), -210, -145, slot0.Menu_Ani_Close_Time).setOnUpdate(slot1, System.Action_float(function (slot0)
		setLocalPosition(slot0.selectBtn, {
			y = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setLocalPosition(slot0.selectBtn, {
			y = -145
		})
		setActive(slot0.selectBtn, false)
	end))
end

slot0.closeSpecial = function (slot0)
	slot0:closeSelectBtn()
	slot0:closeSecondPanel()
end

slot0.updatePizza = function (slot0)
	setActive(slot0.empty, slot0.selectedList[1] == 0)
	setActive(slot0.pizzaTF, slot0.selectedList[1] > 0)
	setActive(slot0:findTF("PizzaPan", slot0.pizzaTF), slot0.selectedList[1] and slot0.selectedList[1] > 0)
	setActive(slot0:findTF("PizzaSauce", slot0.pizzaTF), slot0.selectedList[2] and slot0.selectedList[2] > 0)
	setActive(slot0:findTF("PizzaCheese", slot0.pizzaTF), slot0.selectedList[3] and slot0.selectedList[3] > 0)
	setActive(slot0:findTF("EX1", slot0.pizzaTF), slot0.selectedList[4] and slot0.selectedList[4] > 0)
	setActive(slot0:findTF("EX2", slot0.pizzaTF), slot0.selectedList[5] and slot0.selectedList[5] > 0)
	setActive(slot0:findTF("EX3", slot0.pizzaTF), slot0.selectedList[6] and slot0.selectedList[6] > 0)

	if slot0.selectedList[1] and slot0.selectedList[1] > 0 then
		setImageSprite(slot1, getImageSprite(slot0:findTF(tostring(slot0.selectedList[1]), slot0.pizzaResTF)), true)
	end

	if slot0.selectedList[2] and slot0.selectedList[2] > 0 then
		setImageSprite(slot2, getImageSprite(slot0:findTF(slot7, slot0.pizzaResTF)), true)
	end

	if slot0.selectedList[3] and slot0.selectedList[3] > 0 then
		setImageSprite(slot3, getImageSprite(slot0:findTF(slot7, slot0.pizzaResTF)), true)
	end

	if slot0.selectedList[4] and slot0.selectedList[4] > 0 then
		setImageSprite(slot4, getImageSprite(slot0:findTF(slot7, slot0.pizzaResTF)), true)
	end

	if slot0.selectedList[5] and slot0.selectedList[5] > 0 then
		setImageSprite(slot5, getImageSprite(slot0:findTF(slot7, slot0.pizzaResTF)), true)
	end

	if slot0.selectedList[6] and slot0.selectedList[6] > 0 then
		setImageSprite(slot6, getImageSprite(slot0:findTF(slot7, slot0.pizzaResTF)), true)
	end
end

slot0.updateMainSelectPanel = function (slot0)
	if slot0.selectedList[1] and slot0.selectedList[1] > 0 then
		setImageSprite(slot0.mainToggleSelectedTF[1], slot1, true)
		setActive(slot0.mainToggleSelectedTF[1], true)
	end

	if slot0.selectedList[2] and slot0.selectedList[2] > 0 then
		setImageSprite(slot0.mainToggleSelectedTF[2], slot2, true)
		setActive(slot0.mainToggleSelectedTF[2], true)
	end

	if slot0.selectedList[3] and slot0.selectedList[3] > 0 then
		setImageSprite(slot0.mainToggleSelectedTF[3], slot2, true)
		setActive(slot0.mainToggleSelectedTF[3], true)
	end

	if slot0.selectedList[4] and slot0.selectedList[4] > 0 then
		setImageSprite(slot0.mainToggleSelectedTF[4], slot2, true)
		setActive(slot0.mainToggleSelectedTF[4], true)
	end

	if slot0.selectedList[5] and slot0.selectedList[5] > 0 then
		setImageSprite(slot0.mainToggleSelectedTF[5], slot2, true)
		setActive(slot0.mainToggleSelectedTF[5], true)
	end

	if slot0.selectedList[6] and slot0.selectedList[6] > 0 then
		setImageSprite(slot0.mainToggleSelectedTF[6], slot2, true)
		setActive(slot0.mainToggleSelectedTF[6], true)
	end
end

slot0.isFinished = function (slot0)
	return #slot0.activity.data2_list == 6
end

slot0.changeIndexSelect = function (slot0)
	slot0.selectedList[slot0.curSelectOrder] = slot0.curSelectIndex

	PlayerPrefs.SetInt(slot0.Pizza_Save_Tag_Pre .. slot0.curSelectOrder, slot0.curSelectIndex)
end

slot0.getSelectedList = function (slot0)
	slot0.selectedList = {
		0,
		0,
		0,
		0,
		0,
		0
	}

	for slot4, slot5 in ipairs(slot0.activity.data2_list) do
		slot0.selectedList[slot4] = slot5
	end

	if slot0:isFinished() then
		for slot4 = 1, 6, 1 do
			if PlayerPrefs.GetInt(slot5, 0) > 0 then
				slot0.selectedList[slot4] = slot6
			end
		end
	end

	slot0:saveSelectedList()

	return slot0.selectedList
end

slot0.saveSelectedList = function (slot0)
	for slot4 = 1, 6, 1 do
		PlayerPrefs.SetInt(slot0.Pizza_Save_Tag_Pre .. slot4, slot0.selectedList[slot4])
	end
end

slot0.share = function (slot0)
	PoolMgr.GetInstance():GetUI("PizzahutSharePage", false, function (slot0)
		SetParent(slot0, slot1, false)

		slot0.shareGo = slot0
		slot3 = slot0:findTF("PizzaContainer", slot0)

		setText(slot2, slot6)

		slot7 = getProxy(PlayerProxy):getRawData()
		slot12 = slot0:findTF("deck", slot0)

		setText(slot12:Find("name/value"), (slot7 and slot7.name) or "")
		setText(slot12:Find("server/value"), (getProxy(ServerProxy):getRawData()[(getProxy(UserProxy):getRawData() and slot8.server) or 0] and getProxy(ServerProxy).getRawData()[(getProxy(UserProxy).getRawData() and slot8.server) or 0].name) or "")
		setText(slot12:Find("lv/value"), slot7.level)
		setLocalPosition(tf(slot13), {
			x = 0,
			y = 0
		})
		setLocalScale(tf(slot13), {
			x = 1.4,
			y = 1.4
		})
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePizzahut)

		if slot0.shareGo then
			PoolMgr.GetInstance():ReturnUI("PizzahutSharePage", slot0.shareGo)

			slot0.shareGo = nil
		end
	end)
end

slot0.initSD = function (slot0)
	slot0.sdContainer = slot0:findTF("sdcontainer", slot0.bg)
	slot0.spine = nil
	slot0.spineLRQ = GetSpineRequestPackage.New("chuixue_6", function (slot0)
		SetParent(slot0, slot0.sdContainer)

		slot0.spine = slot0
		slot0.spine.transform.localScale = Vector3.one

		if slot0.spine:GetComponent("SpineAnimUI") then
			slot1:SetAction("stand", 0)
		end

		slot0.spineLRQ = nil
	end).Start(slot1)

	setActive(slot0.sdContainer, true)
end

slot0.showBubble = function (slot0, slot1)
	slot2 = nil

	if not slot1 then
		if isActive(slot0.battleBtn) then
			slot2 = HXSet.hxLan(i18n("sofmapsd_1"))
		elseif isActive(slot0.getBtn) then
			slot2 = HXSet.hxLan(i18n("sofmapsd_2"))
		elseif isActive(slot0.gotBtn) then
			slot2 = i18n("sofmapsd_4")
		end
	else
		slot2 = slot1
	end

	setText(slot0.bubbleText, slot2)

	function slot4()
		LeanTween.value(go(slot0.bubble), 1, 0, slot1.FADE_OUT_TIME):setOnUpdate(System.Action_float(System.Action_float)):setOnComplete(System.Action(function ()
			setActive(slot0.bubble, false)
		end))
	end

	LeanTween.cancel(go(slot0.bubble))
	setActive(slot0.bubble, true)
	LeanTween.value(go(slot0.bubble), 0, 1, slot0.FADE_TIME).setOnUpdate(slot5, System.Action_float(slot3)):setOnComplete(System.Action(function ()
		LeanTween.delayedCall(go(slot0.bubble), slot1.SHOW_TIME, System.Action(slot1.SHOW_TIME))
	end))
end

return slot0

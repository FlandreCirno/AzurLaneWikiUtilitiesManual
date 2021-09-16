slot0 = class("LevelStageTotalRewardPanel", BaseUI)

slot0.getUIName = function (slot0)
	return "LevelStageTotalRewardPanel"
end

slot1 = 0.15

slot0.init = function (slot0)
	slot0.window = slot0._tf:Find("Window")
	slot0.boxView = slot0.window:Find("Layout/Box/ScrollView")
	slot0.emptyTip = slot0.window:Find("Layout/Box/EmptyTip")
	slot0.itemList = slot0.boxView:Find("Viewport/Content/ItemGrid")
	Instantiate(slot0.itemList:GetComponent(typeof(ItemList)).prefabItem[0]).name = "Icon"

	setParent(slot1, slot0.itemList:Find("GridItem/Shell"))

	slot0.spList = slot0.window:Find("Fixed/SpList")

	slot0.CloneIconTpl(slot0.spList:Find("Item/Active/Item"), "Icon")
	setText(slot0.emptyTip, i18n("autofight_rewards_none"))
	setText(slot0.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
	setText(slot0.window:Find("Layout/Box/Title/Text"), i18n("battle_end_subtitle1"))
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:UpdateView()

	slot1 = slot0.contextData.isAutoFight
	slot2 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if slot1 and slot2 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end

	if getProxy(MetaCharacterProxy):getMetaTacticsInfoOnEnd() and #slot3 > 0 then
		slot0.metaExpView = MetaExpView.New(slot0.window:Find("Layout"), slot0.event, slot0.contextData)

		slot0.metaExpView.Reset(slot4)
		slot0.metaExpView.Load(slot4)
		slot0.metaExpView.setData(slot4, slot3)
		slot0.metaExpView:ActionInvoke("Show")
	end
end

slot0.willExit = function (slot0)
	slot0:SkipAnim()

	if slot0.metaExpView then
		slot0.metaExpView:Destroy()
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

slot0.UpdateView = function (slot0)
	onButton(slot0, slot0._tf:Find("BG"), function ()
		if slot0.isRewardAnimating then
			slot0:SkipAnim()

			return
		end

		existCall(slot1.onClose)
		existCall:closeView()
	end)
	setText(slot0.window.Find(slot3, "Fixed/ButtonGO/pic"), i18n("autofight_onceagain"))
	onButton(slot0, slot0.window:Find("Fixed/ButtonGO"), function ()
		if slot0.contextData.spItemID and not (PlayerPrefs.GetInt("autoFight_firstUse_sp", 0) == 1) then
			PlayerPrefs.SetInt("autoFight_firstUse_sp", 1)
			PlayerPrefs.Save()
			slot0.HandleShowMsgBox(slot3, {
				hideNo = true,
				content = i18n("autofight_special_operation_tip"),
				onYes = function ()
					slot0.contextData.spItemID = nil

					slot0.contextData:UpdateSPItem()
				end,
				onNo = function ()
					slot0.contextData.spItemID = nil

					slot0.contextData.UpdateSPItem()
				end
			})

			return
		end

		slot1 = true
		slot2 = slot0.contextData.chapter.duties
		slot3 = slot0.contextData.chapter:getConfig("type") == Chapter.CustomFleet
		slot4 = slot0.contextData.chapter

		if slot3 then
			seriesAsync({
				function (slot0)
					slot1 = slot0:GetParentView()

					slot1:trackChapter(slot1, slot0)
				end,
				function (slot0)
					slot0.CheckOilCost(slot0.CheckOilCost, , slot0)
				end,
				function (slot0)
					slot0:emit(LevelMediator2.ON_ELITE_TRACKING, slot1.id, 1, slot0, , )
					slot0:closeView()
				end
			})

			return
		elseif slot0.contextData.fleets and #slot5 > 0 then
			seriesAsync({
				function (slot0)
					slot1 = slot0:GetParentView()

					slot1:trackChapter(slot1, slot0)
				end,
				function (slot0)
					slot0.CheckOilCost(slot0.CheckOilCost, , slot0)
				end,
				function (slot0)
					slot0:emit(LevelMediator2.ON_TRACKING, slot1.id, slot0, 1, , , )
					slot0:closeView()
				end
			})

			return
		end

		slot0.closeView(slot5)
	end, SFX_CONFIRM)
	setText(slot0.window.Find(slot3, "Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(slot0, slot0.window:Find("Fixed/ButtonExit"), function ()
		existCall(slot0.onClose)
		slot0.onClose:closeView()
	end, SFX_CANCEL)
	slot0.UpdateSPItem(slot0)

	slot0.tweenItems = {}
	slot6 = slot0.contextData.rewards and #slot2 > 0
	slot7 = slot0.contextData.events and #slot0.contextData.events > 0
	slot8 = slot0.contextData.guildTasks and table.getCount(slot0.contextData.guildTasks) > 0
	slot9 = slot0.contextData.guildAutoReceives and table.getCount(slot0.contextData.guildAutoReceives) > 0

	if slot6 or slot7 or slot8 or slot9 then
		setActive(slot0.window, true)
		setActive(slot0.emptyTip, false)
		setActive(slot0.boxView:Find("Viewport/Content/ItemGrid"), slot6)

		if slot6 then
			for slot14, slot15 in ipairs(slot10) do
				updateDrop(slot10[slot14].Find(slot17, "Shell/Icon"), slot16)
				onButton(slot0, slot10[slot14].Find(slot17, "Shell/Icon"), function ()
					slot0:emit(BaseUI.ON_DROP, slot0)
				end, SFX_PANEL)
			end

			slot11 = {}

			for slot15 = 1, #slot2, 1 do
				slot16 = slot10[slot15]

				setActive(slot16, false)
				table.insert(slot11, function (slot0)
					if not slot0.tweenItems then
						slot0()

						return
					end

					setActive(setActive, true)
					Canvas.ForceUpdateCanvases()

					slot0.boxView:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 0

					table.insert(slot0.tweenItems, LeanTween.delayedCall(slot0.tweenItems, System.Action(slot0)).id)
				end)
			end

			slot0.isRewardAnimating = true

			table.insert(slot11, function ()
				slot0:SkipAnim()
			end)
			seriesAsync(slot11)
		end

		setActive(slot0.boxView:Find("Viewport/Content/TextArea"), slot7 or slot8)

		slot10 = ""

		if slot7 then
			for slot14, slot15 in ipairs(slot3) do
				slot10 = slot10 .. i18n("autofight_entrust", (pg.collection_template[slot15] and pg.collection_template[slot15].title) or "") .. "\n"
			end
		end

		if slot8 then
			for slot14, slot15 in pairs(slot4) do
				slot10 = slot10 .. i18n("autofight_task", slot15) .. "\n"
			end
		end

		if slot9 then
			for slot14, slot15 in pairs(slot5) do
				slot10 = slot10 .. i18n("guild_task_autoaccept_1", slot15) .. "\n"
			end
		end

		if #slot10 > 0 then
			setText(slot0.boxView:Find("Viewport/Content/TextArea/Text"), string.sub(slot10, 1, -2) or slot10)
		end
	else
		setActive(slot0.boxView, false)
		setActive(slot0.emptyTip, true)
	end
end

slot0.UpdateSPItem = function (slot0)
	slot2 = getProxy(BagProxy).getItemsByType(slot1, Item.SPECIAL_OPERATION_TICKET)

	if slot0.contextData.chapter:getConfig("special_operation_list") == "" then
		slot3 = {} or slot3
		slot4 = {}
	end

	for slot8, slot9 in pairs(pg.benefit_buff_template) do
		if slot9.benefit_type == Chapter.OPERATION_BUFF_TYPE_DESC and table.contains(slot3, slot8) then
			table.insert(slot4, slot9)
		end
	end

	slot5 = 1

	setActive(slot0.spList, #slot4 ~= 0)

	if #slot4 == 0 then
		return
	end

	UIItemList.StaticAlign(slot0.spList, slot0.spList:GetChild(0), slot5, function (slot0, slot1, slot2)
		if slot0 ~= UIItemList.EventUpdate then
			return
		end

		setText(slot2:Find("Active/Desc"), slot0[slot1 + 1].desc)

		_.detect(slot1, function (slot0)
			return slot0.configId == slot0
		end) or {
			count = 0,
			id = tonumber(slot0[slot1 + 1].benefit_condition),
			type = DROP_TYPE_ITEM
		}.type = DROP_TYPE_ITEM

		setActive(slot2.Find(slot2, "Active"), _.detect(slot1, function (slot0)
			return slot0.configId == slot0
		end) or .count > 0)
		setActive(slot2:Find("Block"), not (_.detect(slot1, function (slot0)
			return slot0.configId == slot0
		end) or .count > 0))

		if not (_.detect(slot1, function (slot0)
			return slot0.configId == slot0
		end) or .count > 0) then
			setText(slot2:Find("Block"):Find("Desc"), i18n("levelScene_select_noitem"))

			return
		end

		setActive(slot2:Find("Active/Item"), true)
		updateDrop(slot2:Find("Active/Item/Icon"), slot5)
		onButton(slot2, slot2, function ()
			slot0.spItemID = (not slot0.contextData.spItemID and slot1) or nil

			if slot0.contextData.spItemID then
				pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_select_sp"))
			end

			slot0:UpdateSPItem()
		end, SFX_PANEL)
		onButton(slot2, slot2.Find(slot2, "Active/Item/Icon"), function ()
			slot0:emit(BaseUI.ON_ITEM, slot0)
		end)
		setActive(slot2.Find(slot2, "Active/Checkbox/Mark"), tobool(slot2.contextData.spItemID))
	end)
end

slot0.CloneIconTpl = function (slot0, slot1)
	slot3 = Instantiate(slot0:GetComponent(typeof(ItemList)).prefabItem[0])

	if slot1 then
		slot3.name = slot1
	end

	setParent(slot3, slot0)

	return slot3
end

slot0.GetParentView = function (slot0)
	return getProxy(ContextProxy):getCurrentContext() and pg.m02:retrieveMediator(slot2.mediator.__cname) and getProxy(ContextProxy).getCurrentContext() and pg.m02.retrieveMediator(slot2.mediator.__cname):getViewComponent()
end

slot0.HandleShowMsgBox = function (slot0, slot1)
	slot1.blurLevelCamera = true

	pg.MsgboxMgr.GetInstance():ShowMsgBox(slot1)
end

slot0.CheckOilCost = function (slot0, slot1, slot2)
	if not getProxy(PlayerProxy).getRawData(slot4):isEnough({
		oil = slot0:getConfig("oil") * TrackingCommand.CalculateSpItemMoreCostRate(slot1)
	}) then
		if not ItemTipPanel.ShowOilBuyTip(slot3) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))
		end

		return
	end

	slot2()
end

slot0.SkipAnim = function (slot0)
	if not slot0.isRewardAnimating then
		return
	end

	for slot4, slot5 in ipairs(slot0.tweenItems) do
		LeanTween.cancel(slot5)
	end

	for slot4 = 1, slot0.itemList.childCount, 1 do
		setActive(slot0.itemList:GetChild(slot4 - 1), true)
	end

	slot0.isRewardAnimating = nil
end

return slot0

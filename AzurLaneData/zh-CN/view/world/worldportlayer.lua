slot0 = class("WorldPortLayer", import("..base.BaseUI"))
slot0.Listeners = {
	onUpdateMoneyCount = "OnUpdateMoneyCount",
	onUpdateTasks = "OnUpdateTasks",
	onUpdateGoods = "OnUpdateGoods"
}
slot0.TitleName = {
	"text_gangkou",
	"text_operation",
	"text_supply"
}
slot0.PageMain = 0
slot0.PageTask = 1
slot0.PageShop = 2
slot0.PageDockyard = 3
slot0.BlurPages = {
	[slot0.PageTask] = true,
	[slot0.PageShop] = true
}
slot0.optionsPath = {
	"blur_panel/adapt/top/title/option"
}

slot0.getUIName = function (slot0)
	return "WorldPortUI"
end

slot0.init = function (slot0)
	for slot4, slot5 in pairs(slot0.Listeners) do
		slot0[slot4] = function (...)
			slot0[slot1](slot2, ...)
		end
	end

	slot0.rtBg = slot0.findTF(slot0, "bg")
	slot0.rtEnterIcon = slot0.rtBg:Find("enter_icon")
	slot0.rtBlurPanel = slot0:findTF("blur_panel")
	slot0.rtTasks = slot0.rtBlurPanel:Find("adapt/tasks")
	slot0.rtShop = slot0.rtBlurPanel:Find("adapt/shop")
	slot0.rtPainting = slot0.rtShop:Find("paint")
	slot0.btnPainting = slot0.rtShop:Find("paint_touch")

	setActive(slot0.btnPainting, false)

	slot0.rtChat = slot0.rtShop:Find("chat")

	setActive(slot0.rtChat, false)

	slot0.rtTop = slot0.rtBlurPanel:Find("adapt/top")
	slot0.btnBack = slot0.rtTop:Find("title/back_button")
	slot0.rtTopTitle = slot0.rtTop:Find("title")
	slot0.rtImageTitle = slot0.rtTopTitle:Find("print/title")
	slot0.rtImageTitleTask = slot0.rtTopTitle:Find("print/title_task")
	slot0.rtImageTitleShop = slot0.rtTopTitle:Find("print/title_shop")
	slot0.rtTopLeft = slot0.rtTop:Find("left_stage")
	slot0.rtTopRight = slot0.rtTop:Find("right_stage")
	slot0.wsWorldInfo = WSWorldInfo.New()
	slot0.wsWorldInfo.transform = slot0.rtTopRight:Find("display_panel/world_info")

	slot0.wsWorldInfo:Setup()
	setText(slot0.rtTopRight:Find("display_panel/title/title"), i18n("world_map_title_tips"))
	setText(slot0.rtTopRight:Find("display_panel/title/title_en"), i18n("world_map_title_tips_en"))

	slot0.rtTopBottom = slot0.rtTop:Find("bottom_stage")
	slot0.rtButtons = slot0:findTF("btn", slot0.rtTopBottom)
	slot0.buttons = {
		slot0.rtButtons:Find("operation"),
		slot0.rtButtons:Find("supply"),
		slot0.rtButtons:Find("dockyard")
	}
	slot0.resPanel = WorldResource.New()

	slot0.resPanel._tf:SetParent(slot0.rtTop:Find("title/resources"), false)

	slot0.rtTaskWindow = slot0:findTF("task_window")
	slot0.wsTasks = {}
	slot0.wsGoods = {}
	slot0.page = -1
	slot0.dirtyFlags = {}
	slot0.cdTF = slot0.rtShop:Find("timer_bg")
	slot0.emptyTF = slot0.rtShop:Find("frame/scrollview/empty")
	slot0.refreshBtn = slot0.rtShop:Find("refresh_btn")

	setActive(slot0.refreshBtn, false)

	slot0.glitchArtMaterial = slot0:findTF("resource/material1"):GetComponent(typeof(Image)).material
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, {
		groupName = slot0:getGroupNameFromData()
	})
	onButton(slot0, slot0.btnBack, function ()
		if slot0.isTweening then
			return
		end

		if slot0.port:IsTempPort() or slot0.page == slot1.PageMain then
			slot0:EaseOutUI(function ()
				slot0:closeView()
			end)
		else
			slot0.SetPage(slot0, slot1.PageMain)
		end
	end, SFX_CANCEL)

	for slot4, slot5 in ipairs(slot0.buttons) do
		onButton(slot0, slot5, function ()
			if slot0 == slot1.PageDockyard then
				slot2:emit(WorldPortMediator.OnOpenBay)
			else
				slot2:SetPage(slot2.SetPage)
			end
		end, SFX_PANEL)
	end

	slot0.UpdatePainting(slot0, slot0:GetPaintingInfo())
	slot0:UpdateTaskTip()
	slot0:UpdateCDTip()

	if slot0.port:IsTempPort() then
		slot0.contextData.page = WorldPortLayer.PageShop
	elseif slot0.contextData.page == WorldPortLayer.PageDockyard then
		slot0.contextData.page = nil
	end

	slot0:SetPage(slot0.contextData.page or WorldPortLayer.PageMain)
	slot0:EaseInUI()
end

slot0.onBackPressed = function (slot0)
	if pg.m02:retrieveMediator(WorldMediator.__cname).viewComponent:CheckMarkOverallClose() then
	else
		triggerButton(slot0.btnBack)
	end
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
	slot0:RecyclePainting(slot0.rtPainting)

	slot0.contextData.isEnter = true

	if slot0.BlurPages[slot0.page] then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.rtBlurPanel, slot0._tf)
	end

	slot0:CancelUITween()
	slot0:DisposeTopUI()
	slot0:DisposeTaskDetail()
	slot0:DisposeTasks()
	slot0:DisposeGoods()
	slot0.port:RemoveListener(WorldMapPort.EventUpdateTaskIds, slot0.onUpdateTasks)
	slot0.port:RemoveListener(WorldMapPort.EventUpdateGoods, slot0.onUpdateGoods)

	slot0.port = nil

	slot0.resPanel:exit()

	slot0.resPanel = nil

	slot0.refreshTimer:Stop()

	slot0.refreshTimer = nil

	slot0.inventory:RemoveListener(WorldInventoryProxy.EventUpdateItem, slot0.onUpdateMoneyCount)

	slot0.inventory = nil

	slot0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, slot0.onUpdateTasks)

	slot0.taskProxy = nil

	slot0.wsWorldInfo:Dispose()

	slot0.wsWorldInfo = nil
end

slot0.GetPaintingInfo = function (slot0)
	if slot0.port:IsTempPort() then
		return "mingshi", false
	else
		return "tbniang", true
	end
end

slot0.UpdatePainting = function (slot0, slot1, slot2)
	slot0.paintingName = slot1

	setPaintingPrefab(slot0.rtPainting, slot1, "chuanwu")

	if slot2 then
		slot0:AddGlitchArtEffectForPating(slot0.rtPainting)
	end
end

slot0.AddGlitchArtEffectForPating = function (slot0, slot1)
	for slot6 = 0, slot1:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
		slot2[slot6].material = slot0.glitchArtMaterial
	end
end

slot0.RecyclePainting = function (slot0, slot1)
	if slot1:Find("fitter").childCount > 0 then
		for slot6 = 0, slot1:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
			slot8 = Color.white

			if slot2[slot6].material ~= slot2[slot6].defaultGraphicMaterial then
				slot7.material = slot7.defaultGraphicMaterial

				slot7.material:SetColor("_Color", slot8)
			end
		end

		setGray(slot1, false, true)

		slot3 = slot1:Find("fitter"):GetChild(0)

		retPaintingPrefab(slot1, slot3.name)

		if slot3:Find("temp_mask") then
			Destroy(slot4)
		end
	end
end

slot0.DisplayTopUI = function (slot0, slot1)
	setActive(slot0.rtImageTitle, slot1 == slot0.PageMain)
	setActive(slot0.rtImageTitleTask, slot1 == slot0.PageTask)
	setActive(slot0.rtImageTitleShop, slot1 == slot0.PageShop)
	setActive(slot0.rtTopRight, slot1 == slot0.PageMain)
	setActive(slot0.rtTopBottom, slot1 == slot0.PageMain)
end

slot0.DisposeTopUI = function (slot0)
	slot0.wsPortLeft:Dispose()
end

slot0.NewPortLeft = function (slot0)
	slot1 = WSPortLeft.New()
	slot1.transform = slot0.rtTopLeft

	slot1:Setup(nowWorld)
	slot1:UpdateMap(nowWorld:GetActiveMap())

	return slot1
end

slot0.EnterPortAnim = function (slot0, slot1)
	if slot0.rtEnterIcon:GetComponent(typeof(DftAniEvent)) then
		slot2:SetTriggerEvent(function (slot0)
			slot0()
		end)
		slot2.SetEndEvent(slot2, function (slot0)
			setActive(slot0.rtEnterIcon, false)
		end)
	end

	setActive(slot0.rtEnterIcon, true)
end

slot0.EaseInUI = function (slot0, slot1)
	slot0.isTweening = true
	slot2 = {}

	slot0:CancelUITween()

	if #slot0.enterIcon > 0 and not slot0.contextData.isEnter then
		table.insert(slot2, function (slot0)
			setActive(slot0.rtTop, false)
			slot0:EnterPortAnim(function ()
				setActive(slot0.rtTop, true)

				return slot0.rtTop()
			end)
		end)
	else
		setActive(slot0.rtEnterIcon, false)
	end

	seriesAsync(slot2, function ()
		setAnchoredPosition(slot0.rtTopLeft, {
			x = -slot0.rtTopLeft.rect.width
		})
		setAnchoredPosition(slot0.rtTopRight, {
			x = slot0.rtTopRight.rect.width
		})
		setAnchoredPosition(slot0.rtTopTitle, {
			y = slot0.rtTopTitle.rect.height
		})
		setAnchoredPosition(slot0.rtTopBottom, {
			y = -slot0.rtTopRight.rect.height
		})
		LeanTween.moveX(slot0.rtTopLeft, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveX(slot0.rtTopRight, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveY(slot0.rtTopTitle, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
		LeanTween.moveY(slot0.rtTopBottom, 0, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function ()
			slot0.isTweening = false

			return existCall(false)
		end))
	end)
end

slot0.EaseOutUI = function (slot0, slot1)
	slot0:CancelUITween()
	LeanTween.moveX(slot0.rtTopLeft, -slot0.rtTopLeft.rect.width, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveX(slot0.rtTopRight, slot0.rtTopRight.rect.width, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveY(slot0.rtTopTitle, slot0.rtTopTitle.rect.height, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine)
	LeanTween.moveY(slot0.rtTopBottom, -slot0.rtTopRight.rect.height, WorldConst.UIEaseDuration):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function ()
		slot0.isTweening = false

		return existCall(false)
	end))
end

slot0.CancelUITween = function (slot0)
	LeanTween.cancel(go(slot0.rtTopTitle))
	LeanTween.cancel(go(slot0.rtTopLeft))
	LeanTween.cancel(go(slot0.rtTopRight))
	LeanTween.cancel(go(slot0.rtTopBottom))
end

slot0.SetPlayer = function (slot0, slot1)
	slot0.player = slot1

	slot0.resPanel:setPlayer(slot1)
end

slot0.SetPort = function (slot0, slot1)
	slot0.port = slot1

	slot0.port:AddListener(WorldMapPort.EventUpdateTaskIds, slot0.onUpdateTasks)
	slot0.port:AddListener(WorldMapPort.EventUpdateGoods, slot0.onUpdateGoods)
	slot0:SetBg(slot0.port.id)

	slot0.refreshTimer = Timer.New(function ()
		if slot0.port:IsValid() then
			slot0:UpdateRefreshTime(slot0.port.expiredTime - pg.TimeMgr.GetInstance():GetServerTime())
		else
			slot0:emit(WorldPortMediator.OnReqPort, nowWorld:GetActiveMap().id)
		end
	end, 1, -1)

	slot0.refreshTimer.Start(slot2)
	slot0.refreshTimer.func()

	slot2 = nowWorld:GetActiveMap():GetFleet()
	slot0.wsPortLeft = slot0:NewPortLeft()

	setActive(slot0.buttons[1], slot0.port:GetRealm() == 0 or slot3 == nowWorld:GetRealm())
	setActive(slot0.buttons[3], slot3 == 0 or slot3 == nowWorld:GetRealm())
	setActive(slot0.resPanel._tf, nowWorld:IsSystemOpen(WorldConst.SystemResource))

	slot0.inventory = nowWorld:GetInventoryProxy()

	slot0.inventory:AddListener(WorldInventoryProxy.EventUpdateItem, slot0.onUpdateMoneyCount)
	slot0:OnUpdateMoneyCount()

	slot0.taskProxy = nowWorld:GetTaskProxy()

	slot0.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, slot0.onUpdateTasks)
end

slot0.SetBg = function (slot0, slot1)
	slot0.portBg = pg.world_port_data[slot1].port_bg

	setImageAlpha(slot0.rtBg, (#slot0.portBg > 0 and 1) or 0)

	if #slot0.portBg > 0 then
		GetImageSpriteFromAtlasAsync("world/port/" .. slot0.portBg, "", slot0.rtBg)
	end

	slot0.enterIcon = pg.world_port_data[slot1].port_entrance_icon

	setActive(slot0.rtEnterIcon, #slot0.enterIcon > 0)

	if #slot0.enterIcon > 0 then
		GetImageSpriteFromAtlasAsync("world/porttitle/" .. slot0.enterIcon, "", slot0.rtEnterIcon, false)
	end

	GetImageSpriteFromAtlasAsync("world/portword/" .. slot0.portBg, "", slot0.rtImageTitle, true)
	GetImageSpriteFromAtlasAsync("world/portword/" .. slot0.portBg .. "_en", "", slot0.rtImageTitle:Find("Image"), true)
end

slot0.OnUpdateTasks = function (slot0)
	slot0:UpdateTaskTip()
	slot0:SetPageDirty(slot0.PageTask)

	if slot0.page == slot0.PageTask then
		slot0:UpdateTasks()
	end
end

slot0.OnUpdateGoods = function (slot0)
	slot0:UpdateCDTip()
	slot0:SetPageDirty(slot0.PageShop)

	if slot0.page == slot0.PageShop then
		slot0:UpdateGoods()
	end
end

slot0.SetPage = function (slot0, slot1)
	if slot0.page ~= slot1 then
		if slot0.BlurPages[slot0.page or 0] ~= slot0.BlurPages[slot1] then
			if slot0.BlurPages[slot1] then
				pg.UIMgr.GetInstance():BlurPanel(slot0.rtBlurPanel, false, {
					blurLevelCamera = true
				})
			else
				pg.UIMgr.GetInstance():UnblurPanel(slot0.rtBlurPanel, slot0._tf)
			end
		end

		if slot1 == slot0.PageShop and slot0.paintingName == "buzhihuo_shop" then
			slot0:showRandomShipWord(pg.navalacademy_shoppingstreet_template[1].words_enter, true, "enter")
		end

		slot0.page = slot1

		slot0:UpdatePage()

		slot0.contextData.page = slot1
	end
end

slot0.SetPageDirty = function (slot0, slot1)
	slot0.dirtyFlags[slot1] = true
end

slot0.IsPageDirty = function (slot0, slot1)
	return slot0.dirtyFlags[slot1] == true or slot0.dirtyFlags[slot1] == nil
end

slot0.UpdatePage = function (slot0)
	slot0:DisplayTopUI(slot1)
	setActive(slot0.rtTasks, slot0.page == slot0.PageTask)
	setActive(slot0.rtShop, slot1 == slot0.PageShop)

	if slot0:IsPageDirty(slot1) then
		if slot1 == slot0.PageTask then
			slot0:UpdateTasks()
		elseif slot1 == slot0.PageShop then
			slot0:UpdateGoods()
		end
	end
end

slot0.UpdateTasks = function (slot0)
	slot0.dirtyFlags[slot0.PageTask] = false

	slot0:DisposeTasks()
	table.sort(slot3, WorldTask.sortFunc)

	slot4 = UIItemList.New(slot0.rtTasks:Find("frame/viewport/content"), slot2)

	slot4:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = WSPortTask.New()
			slot4.transform = slot2

			slot4:Setup(slot3)
			onButton(slot1, slot4.btnInactive, function ()
				slot0:emit(WorldPortMediator.OnAccepetTask, slot0, slot0.port.id)
			end, SFX_PANEL)
			onButton(slot1, slot4.btnOnGoing, function ()
				slot0:showTaskWindow(slot0)
			end, SFX_PANEL)
			onButton(slot1, slot4.btnFinished, function ()
				slot0:emit(WorldPortMediator.OnSubmitTask, slot0)
			end, SFX_PANEL)

			slot4.onDrop = function (slot0)
				slot0:emit(slot1.ON_DROP, slot0)
			end

			table.insert(slot1.wsTasks, slot4)
		end
	end)
	slot4.align(slot4, #_.map(slot0.port.taskIds, function (slot0)
		return WorldTask.New({
			id = slot0
		})
	end))
	setActive(slot0.rtTasks:Find("frame/empty"), #_.map(slot0.port.taskIds, function (slot0)
		return WorldTask.New({
			id = slot0
		})
	end) == 0)
end

slot0.DisposeTasks = function (slot0)
	_.each(slot0.wsTasks, function (slot0)
		slot0:Dispose()
	end)

	slot0.wsTasks = {}
end

slot0.HideTaskDetail = function (slot0)
	setActive(slot0.taskDetail.transform, false)
end

slot0.DisposeTaskDetail = function (slot0)
	if slot0.taskDetail then
		slot0.taskDetail:Dispose()

		slot0.taskDetail = nil
	end
end

slot0.UpdateGoods = function (slot0)
	slot0.dirtyFlags[slot0.PageShop] = false

	slot0:DisposeGoods()

	slot1 = slot0.rtShop:Find("frame/scrollview/view")

	table.sort(slot3, WorldGoods.sortFunc)

	slot4 = UIItemList.New(slot1, slot2)

	slot4:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = WSPortGoods.New()
			slot4.transform = slot2

			slot4:Setup(slot3)
			onButton(slot1, slot4.transform, function ()
				if slot0.count > 0 then
					slot1:BuyGoods(slot1.BuyGoods)
				end
			end, SFX_PANEL)
			table.insert(slot1.wsGoods, slot4)
		end
	end)
	slot4.align(slot4, #underscore.rest(slot0.port.goods, 1))
end

slot0.DisposeGoods = function (slot0)
	_.each(slot0.wsGoods, function (slot0)
		slot0:Dispose()
	end)

	slot0.wsGoods = {}
end

slot0.BuyGoods = function (slot0, slot1)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yesText = "text_buy",
		hideLine = true,
		type = MSGBOX_TYPE_SINGLE_ITEM,
		drop = slot1.item,
		onYes = function ()
			slot0:emit(WorldPortMediator.OnBuyGoods, slot0)
		end
	})
end

slot0.OnUpdateMoneyCount = function (slot0, slot1, slot2, slot3)
	if not slot1 or slot3.id == WorldItem.PortMoneyId then
		setText(slot0.rtShop:Find("quick_count/value"), slot0.inventory:GetItemCount(WorldItem.PortMoneyId))
	end
end

slot0.UpdateRefreshTime = function (slot0, slot1)
	setText(slot0.cdTF:Find("Text"), pg.TimeMgr.GetInstance():DescCDTime(slot1))
end

slot0.UpdateCDTip = function (slot0)
	setActive(slot0.cdTF, #slot0.port.goods > 0 and not slot0.port:IsTempPort())
	setActive(slot0.emptyTF, #slot0.port.goods == 0)
end

slot0.UpdateTaskTip = function (slot0)
	setActive(slot0.rtButtons:Find("operation/new"), nowWorld:GetAtlas().taskPortDic[slot0.port.id])
end

slot0.showTaskWindow = function (slot0, slot1)
	setActive(slot0.rtTaskWindow:Find("main_window/left_panel").Find(slot3, "bg"), slot1:IsSpecialType())

	if #slot1.config.rare_task_icon > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. slot2, "", slot3:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "nobody", slot3:Find("card"), true)
	end

	slot4 = slot0.rtTaskWindow:Find("main_window/right_panel")

	setText(slot4:Find("title/Text"), HXSet.hxLan(slot1.config.name))
	setText(slot4:Find("content/desc"), HXSet.hxLan(slot1.config.rare_task_text))
	setText(slot4:Find("content/slider_progress/Text"), slot1:getProgress() .. "/" .. slot1:getMaxProgress())
	setSlider(slot4:Find("content/slider"), 0, slot1:getMaxProgress(), slot1:getProgress())

	slot5 = slot4:Find("content/item_tpl")

	removeAllChildren(slot6)

	for slot11, slot12 in ipairs(slot7) do
		updateDrop(slot13, slot14)
		onButton(slot0, slot13, function ()
			slot0:emit(slot1.ON_DROP, )
		end, SFX_PANEL)
		setActive(slot13, true)
	end

	setActive(slot5, false)
	setActive(slot4:Find("content/award_bg/arror"), #slot7 > 3)
	onButton(slot0, slot4:Find("btn_close"), function ()
		slot0:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(slot0, slot0.rtTaskWindow:Find("bg"), function ()
		slot0:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(slot0, slot4:Find("btn_go"), function ()
		slot0:hideTaskWindow()
		slot0.hideTaskWindow:emit(WorldPortMediator.OnTaskGoto, slot1.id)
	end, SFX_PANEL)
	setButtonEnabled(slot4.Find(slot4, "btn_go"), slot1:GetFollowingAreaId() or slot1:GetFollowingEntrance())
	setActive(slot0.rtTaskWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.rtTaskWindow, slot0._tf)
end

slot0.hideTaskWindow = function (slot0)
	setActive(slot0.rtTaskWindow, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.rtTaskWindow, slot0._tf)
end

return slot0

slot0 = class("WorldHelpLayer", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "WorldHelpUI"
end

slot0.init = function (slot0)
	slot0.rtTitle = slot0._tf:Find("title")
	slot0.btnBack = slot0.rtTitle:Find("btn_back")

	onButton(slot0, slot0.btnBack, function ()
		slot0:closeView()
	end, SFX_CANCEL)

	slot0.groupList = UIItemList.New(slot0.rtTitle.Find(slot2, "toggles"), slot0.rtTitle:Find("toggles/toggle"))

	slot0.groupList:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("Text"), pg.world_help_data[slot0.titles[slot1]].name)
			onToggle(slot0, slot2, function (slot0)
				if slot0 then
					if slot0.curGroupId ~=  then
						slot0:toggleAnim(slot0, true)
						slot0:setCurGroup(slot0.setCurGroup)
					end
				else
					slot0:toggleAnim(slot0, false)
				end
			end, SFX_PANEL)
		end
	end)

	slot0.rtMain = slot0._tf.Find(slot1, "main")
	slot0.rtScroll = slot0.rtMain:Find("Scroll")

	onButton(slot0, slot0.rtMain:Find("left"), function ()
		if LeanTween.isTweening(go(slot0.rtScroll)) then
			return
		end

		if slot0.curPageIndex > 1 then
			table.insert(slot0, function (slot0)
				slot0:pageAnim(false, slot0)
			end)
			table.insert(slot0, function (slot0)
				slot0:setCurPage(slot0.curPageIndex - 1)
				slot0()
			end)
			table.insert(slot0, function (slot0)
				slot0:pageAnim(true, slot0)
			end)
			seriesAsync(slot0, function ()
				return
			end)
		end
	end)
	onButton(slot0, slot0.rtMain:Find("right"), function ()
		if LeanTween.isTweening(go(slot0.rtScroll)) then
			return
		end

		if slot0.curPageIndex < #slot0.pageList then
			table.insert(slot0, function (slot0)
				slot0:pageAnim(false, slot0)
			end)
			table.insert(slot0, function (slot0)
				slot0:setCurPage(slot0.curPageIndex + 1)
				slot0()
			end)
			table.insert(slot0, function (slot0)
				slot0:pageAnim(true, slot0)
			end)
			seriesAsync(slot0, function ()
				return
			end)
		end
	end)
end

slot0.setCurGroup = function (slot0, slot1)
	slot2 = {}

	if slot0.curGroupId then
		table.insert(slot2, function (slot0)
			slot0:pageAnim(false, slot0)
		end)
	end

	slot0.curGroupId = slot1

	table.insert(slot2, function (slot0)
		slot0.pageList = {}
		slot2 = nowWorld:GetProgress()

		for slot6, slot7 in ipairs(pg.world_help_data[slot0.curGroupId].stage_help) do
			if slot7[1] <= slot2 then
				table.insert(slot0.pageList, {
					id = slot6,
					path = slot7[2]
				})
			end
		end

		if #slot0.pageList > 0 then
			slot0:setCurPage(1)
		end

		slot0()
	end)
	seriesAsync(slot2, function ()
		slot0:pageAnim(true)
	end)
end

slot0.setCurPage = function (slot0, slot1)
	slot0.curPageIndex = slot1

	setText(slot0.rtMain:Find("page/Text"), slot0.curPageIndex .. "/" .. #slot0.pageList)
	setImageAlpha(slot0.rtScroll:Find("Card").Find(slot2, "Image"), 0)
	GetSpriteFromAtlasAsync(slot0.pageList[slot1].path, "", function (slot0)
		if slot0.curPageIndex ==  then
			setImageSprite(slot2:Find("Image"), slot0)
			setImageAlpha(slot2.Find("Image"):Find("Image"), 1)
		end
	end)
end

slot0.getPageIndex = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.pageList) do
		if slot6.id == slot1 then
			return slot5
		end
	end

	return 1
end

slot0.pageAnim = function (slot0, slot1, slot2)
	LeanTween.cancel(go(slot0.rtScroll))

	slot3 = GetOrAddComponent(slot0.rtScroll, "CanvasGroup")
	slot3.alpha = (not slot1 or 0) and 1

	LeanTween.alphaCanvas(slot3, (slot1 and 1) or 0, 0.3):setOnComplete(System.Action(function ()
		return existCall(existCall)
	end))
end

slot0.toggleAnim = function (slot0, slot1, slot2)
	LeanTween.cancel(slot1.gameObject)

	slot3 = GetComponent(slot1, typeof(LayoutElement))

	if slot2 then
		LeanTween.value(slot1.gameObject, slot3.preferredWidth, 238, 0.15):setOnUpdate(System.Action_float(function (slot0)
			slot0.preferredWidth = slot0
		end)).setOnComplete(slot4, System.Action(function ()
			setActive(slot0:Find("selected"), )
		end))
	else
		setActive(slot1.Find(slot1, "selected"), slot2)
		LeanTween.value(slot1.gameObject, slot3.preferredWidth, 176, 0.15):setOnUpdate(System.Action_float(function (slot0)
			slot0.preferredWidth = slot0
		end))
	end
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)

	slot1 = nil
	slot0.titles = {}
	slot2 = nowWorld:GetProgress()

	for slot6, slot7 in ipairs(pg.world_help_data.all) do
		if pg.world_help_data[slot7].stage <= slot2 then
			table.insert(slot0.titles, slot7)

			if slot0.contextData.titleId == slot7 then
				slot1 = #slot0.titles
			end
		end
	end

	slot0.groupList:align(#slot0.titles)
	setActive(slot0.rtScroll, #slot0.titles > 0)

	if #slot0.titles > 0 then
		if slot1 then
			triggerToggle(slot0.groupList.container:GetChild(slot1 - 1), true)
			slot0:setCurPage(slot0:getPageIndex(slot0.contextData.pageId))
		else
			triggerToggle(slot0.groupList.container:GetChild(0), true)
		end
	end
end

slot0.willExit = function (slot0)
	LeanTween.cancel(go(slot0.rtScroll))
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
end

return slot0

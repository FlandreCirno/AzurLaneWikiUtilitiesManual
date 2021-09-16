slot0 = class("PlayerSecondSummaryInfoScene", import("...base.BaseUI"))

slot0.getUIName = function (slot0)
	return "PlayerSecondSummaryUI"
end

slot0.setActivity = function (slot0, slot1)
	slot0.activityVO = slot1
end

slot0.setPlayer = function (slot0, slot1)
	slot0.palyerVO = slot1
end

slot0.setSummaryInfo = function (slot0, slot1)
	slot0.summaryInfoVO = slot1
end

slot0.init = function (slot0)
	slot0.backBtn = slot0:findTF("bg/back_btn")
	slot0.pageContainer = slot0:findTF("bg/main/pages")
	slot0.pageFootContainer = slot0:findTF("bg/main/foots")

	setActive(slot0.pageFootContainer, false)
end

slot0.didEnter = function (slot0)
	if slot0.summaryInfoVO then
		slot0:initSummaryInfo()
	else
		slot0:emit(PlayerSummaryInfoMediator.GET_PLAYER_SUMMARY_INFO)
	end

	onButton(slot0, slot0.backBtn, function ()
		if slot0:inAnim() then
			return
		end

		slot0:closeView()
	end, SFX_CANCEL)
end

slot0.inAnim = function (slot0)
	return slot0.inAniming or (slot0.currPage and slot0.pages[slot0.currPage]:inAnim())
end

slot0.initSummaryInfo = function (slot0)
	slot0.loadingPage = SecondSummaryPage1.New(slot0:findTF("page1", slot0.pageContainer))

	slot0.loadingPage:Init(slot0.summaryInfoVO)

	slot0.pages = {}

	slot1(slot0.pageContainer:Find("page2"), SecondSummaryPage2, slot0.summaryInfoVO)
	slot1(slot0.pageContainer:Find("page3"), SecondSummaryPage3, slot0.summaryInfoVO)
	setActive(slot2, false)

	for slot7 = 1, math.floor((#slot0.activityVO:getConfig("config_data") - 1) / SecondSummaryPage4.PerPageCount) + 1, 1 do
		slot1(cloneTplTo(slot2, slot0.pageContainer, "page4_1_" .. slot7), SecondSummaryPage4, setmetatable({
			pageType = SecondSummaryPage4.PageTypeFurniture,
			samePage = slot7,
			activityVO = slot0.activityVO
		}, {
			__index = slot0.summaryInfoVO
		}))
	end

	for slot7 = 1, math.floor((#slot0.activityVO:getConfig("config_client") - 1) / SecondSummaryPage4.PerPageCount) + 1, 1 do
		slot1(cloneTplTo(slot2, slot0.pageContainer, "page4_2_" .. slot7), SecondSummaryPage4, setmetatable({
			pageType = SecondSummaryPage4.PageTypeIconFrame,
			samePage = slot7,
			activityVO = slot0.activityVO
		}, {
			__index = slot0.summaryInfoVO
		}))
	end

	slot1(slot0.pageContainer:Find("page5"), SecondSummaryPage5, slot0.summaryInfoVO)
	onButton(slot0, slot0:findTF("page5/share", slot0.pageContainer), function ()
		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeSecondSummary)
	end, SFX_CONFIRM)
	seriesAsync({
		function (slot0)
			slot0.inAniming = true

			slot0.loadingPage:Show(slot0)
		end,
		function (slot0)
			slot0.inAniming = false

			slot0.loadingPage:Hide()
			slot0:registerFootEvent()
			slot0:registerDrag()
			slot0()
		end
	}, function ()
		setActive(slot0.pageFootContainer, true)
		setActive:updatePageFoot(1)
	end)
end

slot0.registerFootEvent = function (slot0)
	slot1 = UIItemList.New(slot0.pageFootContainer, slot0.pageFootContainer:Find("dot"))

	slot1:make(function (slot0, slot1, slot2)
		slot3 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			onToggle(slot0, slot2, function (slot0)
				if slot0 then
					slot0.pages[]:Show()

					slot0.currPage = slot0
				else
					slot0.pages[slot0.currPage]:Hide()
				end
			end)
		end
	end)
	slot1.align(slot1, #slot0.pages)
end

slot0.registerDrag = function (slot0)
	slot0:addVerticalDrag(slot0:findTF("bg"), function ()
		slot0:updatePageFoot(slot0.currPage - 1)
	end, function ()
		slot0:updatePageFoot(slot0.currPage + 1)
	end)
end

slot0.updatePageFoot = function (slot0, slot1)
	if slot0:inAnim() or not slot0.pages[slot1] then
		return
	end

	triggerToggle(slot0.pageFootContainer:GetChild(slot1 - 1), true)
end

slot0.addVerticalDrag = function (slot0, slot1, slot2, slot3)
	slot4 = GetOrAddComponent(slot1, "EventTriggerListener")
	slot5 = nil
	slot6 = 0
	slot7 = 50

	slot4:AddBeginDragFunc(function (slot0, slot1)
		slot0 = 0
		slot1 = slot1.position
	end)
	slot4.AddDragFunc(slot4, function (slot0, slot1)
		slot0 = slot1.position.x - slot1.x
	end)
	slot4.AddDragEndFunc(slot4, function (slot0, slot1)
		if slot0 < -slot1 then
			if slot2 then
				slot2()
			end
		elseif slot1 < slot0 and slot3 then
			slot3()
		end
	end)
end

slot0.willExit = function (slot0)
	for slot4, slot5 in pairs(slot0.pages) do
		slot5:Dispose()
	end

	slot0.pages = nil
	slot0.currPage = nil
end

return slot0

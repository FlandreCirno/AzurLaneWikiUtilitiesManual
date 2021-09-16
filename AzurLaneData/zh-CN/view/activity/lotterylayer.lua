slot0 = class("LotteryLayer", import("..base.BaseUI"))
slot1 = pg.activity_random_award_template
slot2 = true

slot0.getUIName = function (slot0)
	if slot0 then
		return "LotteryForCHTUI"
	else
		return "LotteryUI"
	end
end

slot0.setPlayerVO = function (slot0, slot1)
	slot0.playerVO = slot1

	slot0:updateResource()
end

slot0.updateResource = function (slot0)
	slot0.resCount = slot0.playerVO[id2res(slot0.resId)]

	setText(slot0.resource:Find("Text"), slot0.resCount)
end

slot0.setActivity = function (slot0, slot1)
	slot0.activityVO = slot1
	slot0.resId = slot0.activityVO:getConfig("config_client").resId
	slot0.awardInfos = slot1:getAwardInfos()

	slot0:initActivityPools()
end

slot0.initActivityPools = function (slot0)
	slot0.activityPools = {}
	slot1 = slot0.activityVO:getConfig("config_data")
	slot2 = _.select(slot0.all, function (slot0)
		return table.contains(slot0, slot0)
	end)
	slot3 = nil

	for slot7, slot8 in ipairs(slot2) do
		slot3 = slot8
		slot0.activityPools[ActivityItemPool.New({
			id = slot8,
			awards = slot0.awardInfos[slot8],
			prevId = slot3,
			index = slot7
		}).id] = ActivityItemPool.New()
	end

	slot0.activityPool = slot0.activityPools[slot0.activityVO.data1 or slot1[1]]
end

slot0.init = function (slot0)
	slot0.lotteryPoolContainer = slot0:findTF("left_panel/pool_list/content")
	slot0.attrs = slot0:findTF("left_panel/pool_list/arrs")
	slot0.mainItenContainer = slot0:findTF("right_panel/main_item_list/content")
	slot0.mainItenTpl = slot0:findTF("equipmenttpl", slot0.mainItenContainer)
	slot0.resource = slot0:findTF("left_panel/resource")
	slot0.launchOneBtn = slot0:findTF("left_panel/launch_one_btn")
	slot0.launchOneBtnTxt = slot0:findTF("res/Text", slot0.launchOneBtn):GetComponent(typeof(Text))
	slot0.launchTenBtn = slot0:findTF("left_panel/launch_ten_btn")
	slot0.launchTenBtnTxt = slot0:findTF("res/Text", slot0.launchTenBtn):GetComponent(typeof(Text))
	slot0.launchMaxBtn = slot0:findTF("left_panel/launch_max_btn")
	slot0.launchMaxBtnTxt = slot0:findTF("res/Text", slot0.launchMaxBtn):GetComponent(typeof(Text))
	slot0.awardsCounttxt = slot0:findTF("right_panel/count_container/Text"):GetComponent(typeof(Text))
	slot0.bgTF = slot0:findTF("right_panel"):GetComponent(typeof(Image))
	slot0.descBtn = slot0:findTF("right_panel/desc_btn")
	slot0.bonusWindow = slot0:findTF("Msgbox")

	setActive(slot0.bonusWindow, false)

	slot0.topPanel = slot0:findTF("top")
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0:findTF("top/back_btn"), function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SOUND_BACK)

	slot1 = {
		slot0.launchOneBtn,
		slot0.launchTenBtn,
		slot0.launchMaxBtn
	}
	slot2 = {
		1,
		10,
		"max"
	}

	for slot6, slot7 in ipairs(slot1) do
		GetImageSpriteFromAtlasAsync(pg.item_data_statistics[id2ItemId(slot0.resId)].icon, "", slot7:Find("res/icon"), true)
		onButton(slot0, slot7, function ()
			if not slot0.activityPool then
				return
			end

			if slot0.activityPool ~= slot0.showActivityPool then
				pg.TipsMgr.GetInstance():ShowTips(i18n("amercian_notice_5"))

				return
			end

			if slot0.activityPool:getleftItemCount() == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("activity_pool_awards_empty"))

				return
			end

			if not (slot1[] ~= "max" or math.min(slot0, math.max(math.floor(slot0.resCount / slot1.count), 1))) and math.min(slot0, slot1[math.min]).activityPool:enoughResForUsage((slot1[] ~= "max" or math.min(slot0, math.max(math.floor(slot0.resCount / slot1.count), 1))) and math.min(slot0, slot1[math.min])) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end

			function slot2()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("amercian_notice_1", slot0 * slot1.count, pg.MsgboxMgr.GetInstance().ShowMsgBox),
					onYes = function ()
						slot0(slot1, slot2, slot3, slot0.activityPool.id, slot0, slot2[slot0.activityVO.id] == "max")
					end
				})
			end

			if slot0.playerVO.OilMax(slot3, 1) or slot0.playerVO:GoldMax(1) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("amercian_notice_6"),
					onYes = function ()
						slot0()
					end
				})
			else
				slot2()
			end
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.descBtn, function ()
		if not slot0.showActivityPool then
			return
		end

		slot2, slot5 = slot0.showActivityPool:getItems()

		slot0:showBonus(slot0, slot1)
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("window/top/btnBack", slot0.bonusWindow), function ()
		setActive(slot0.bonusWindow, false)
	end)
	onButton(slot0, slot0:findTF("window/button", slot0.bonusWindow), function ()
		setActive(slot0.bonusWindow, false)
	end)
	onButton(slot0, slot0.bonusWindow, function ()
		setActive(slot0.bonusWindow, false)
	end)

	slot0.bgs = {}
	slot0.attrTFs = {}

	for slot6 = 1, table.getCount(slot0.activityPools), 1 do
		if not IsNil(slot0.attrs.Find(slot7, "arr_" .. slot6)) then
			table.insert(slot0.attrTFs, slot7)
		end
	end

	slot0:updateResource()
	slot0:initPoolTFs()
	slot0:updateActivityPoolState()
	triggerToggle(slot0.activityPoolTFs[slot0.activityPool.id], true)
end

slot0.onActivityUpdated = function (slot0, slot1)
	slot0:setActivity(slot1)
	slot0:updateActivityPoolState()
	slot0:switchToPool(slot1.data1)
end

slot0.initPoolTFs = function (slot0)
	slot0.activityPoolTFs = {}

	for slot4, slot5 in pairs(slot0.activityPools) do
		slot0.activityPoolTFs[slot5.id] = slot0.lotteryPoolContainer:GetChild(slot5.index - 1)

		onToggle(slot0, slot0.lotteryPoolContainer.GetChild(slot5.index - 1), function (slot0)
			if slot0 then
				if not slot0.prevId or slot1.activityPools[slot0.prevId]:canOpenNext() then
					slot1:emit(LotteryMediator.ON_SWITCH, slot1.activityVO.id, slot0.id)
				else
					slot1:switchToPool(slot0.id)
				end
			end
		end)
	end
end

slot0.updateActivityPoolState = function (slot0)
	for slot4, slot5 in pairs(slot0.activityPools) do
		setActive(slot0.activityPoolTFs[slot4]:Find("bg/unlock"), not slot5.prevId or slot0.activityPools[slot5.prevId]:canOpenNext())
		setActive(slot0.activityPoolTFs[slot4]:Find("bg/lock"), not (not slot5.prevId or slot0.activityPools[slot5.prevId].canOpenNext()))
		setActive(slot0.activityPoolTFs[slot4]:Find("selected/unlock"), not slot5.prevId or slot0.activityPools[slot5.prevId].canOpenNext())
		setActive(slot0.activityPoolTFs[slot4]:Find("selected/lock"), not (not slot5.prevId or slot0.activityPools[slot5.prevId].canOpenNext()))

		if slot0 then
			setActive(slot6:Find("icon"), slot7)
			setActive(slot6:Find("icon_g"), not slot7)
		end

		setActive(slot6:Find("finish"), slot5:getleftItemCount() == 0)

		if slot0.attrTFs[slot5.index - 1] then
			triggerToggle(slot0.attrTFs[slot5.index - 1], slot7)
		end
	end
end

slot0.switchToPool = function (slot0, slot1)
	slot3 = slot0.activityPoolTFs[slot1]

	slot0:updateMainItems(slot2)
	slot0:updateAwardsFetchedCount(slot0.activityPools[slot1])

	if not slot0.bgs[slot1] then
		slot0.bgs[slot1] = (not slot0 or LoadSprite("lotterybg/cht_" .. slot2.index)) and LoadSprite("lotterybg/kr_re_" .. slot2.index)
	end

	slot0.bgTF.sprite = slot4
	slot5 = slot2:getComsume()
	slot0.launchOneBtnTxt.text = slot5.count
	slot0.launchTenBtnTxt.text = slot5.count * math.min(slot2:getleftItemCount(), 10)
	slot0.launchMaxBtnTxt.text = slot5.count * math.min(slot2:getleftItemCount(), math.max(math.floor(slot0.resCount / slot5.count), 1))
	slot0.showActivityPool = slot0.activityPools[slot2.id]
end

slot0.updateAwardsFetchedCount = function (slot0, slot1)
	if slot0.awardsCounttxt then
		slot0.awardsCounttxt.text = setColorStr(slot1:getItemCount() - slot1:getFetchCount(), (slot1.getFetchCount() < slot1.getItemCount() and COLOR_GREEN) or COLOR_RED) .. "/" .. slot3
	end
end

slot0.updateMainItems = function (slot0, slot1)
	for slot7 = slot0.mainItenContainer.childCount, #slot1:getMainItems(), 1 do
		cloneTplTo(slot0.mainItenTpl, slot0.mainItenContainer)
	end

	for slot7 = 1, slot0.mainItenContainer.childCount, 1 do
		setActive(slot0.mainItenContainer:GetChild(slot7 - 1), slot7 <= #slot2)

		if slot9 then
			updateDrop(slot8, slot10)
			setActive(slot8:Find("mask"), slot2[slot7].surplus <= 0)
			setText(slot8:Find("icon_bg/surplus"), "X" .. slot10.surplus or "")
			onButton(slot0, slot8, function ()
				slot0:emit(slot1.ON_DROP, )
			end, SFX_PANEL)
		end
	end
end

slot0.showBonus = function (slot0, slot1, slot2)
	setActive(slot0.bonusWindow, true)

	slot0.awardMain = slot1
	slot0.awardNormal = slot2
	slot0.trDropTpl = slot0:findTF("Msgbox/window/items/scrollview/item")
	slot0.trDrops = slot0:findTF("Msgbox/window/items/scrollview/list/list_main")
	slot0.dropList = UIItemList.New(slot0.trDrops, slot0.trDropTpl)

	slot0.dropList:make(function (slot0, slot1, slot2)
		slot0:updateDrop(slot0, slot1, slot2, slot0.awardMain)
	end)
	slot0.dropList.align(slot3, #slot0.awardMain)

	slot0.trDropsN = slot0:findTF("Msgbox/window/items/scrollview/list/list_normal")
	slot0.dropListN = UIItemList.New(slot0.trDropsN, slot0.trDropTpl)

	slot0.dropListN:make(function (slot0, slot1, slot2)
		slot0:updateDrop(slot0, slot1, slot2, slot0.awardNormal)
	end)
	slot0.dropListN.align(slot3, #slot0.awardNormal)
end

slot0.updateDrop = function (slot0, slot1, slot2, slot3, slot4)
	if slot1 == UIItemList.EventUpdate then
		updateDrop(slot3, slot5)
		setText(slot3:Find("count"), slot4[slot2 + 1].surplus .. "/" .. slot4[slot2 + 1].total)
		setActive(slot3:Find("mask"), slot4[slot2 + 1].surplus <= 0)
		setScrollText(findTF(slot3, "name_mask/name"), slot5.name or slot5.cfg.name)
	end
end

slot0.willExit = function (slot0)
	slot0.bgs = nil
end

return slot0

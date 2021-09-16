slot0 = class("LevelSignalView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "LevelSignalView"
end

slot0.OnInit = function (slot0)
	slot0:InitUI()

	slot0.barAnims = {}

	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.OnDestroy = function (slot0)
	if slot0.timers then
		_.each(slot0.timers, function (slot0)
			slot0:Stop()
		end)

		slot0.timers = nil
	end

	slot0.onSearch = nil
	slot0.onGo = nil
	slot0.onCancel = nil

	pg.UIMgr.GetInstance().UnblurPanel(slot1, slot0._tf, slot0._parentTF)
end

slot0.setCBFunc = function (slot0, slot1, slot2, slot3)
	slot0.onSearch = slot1
	slot0.onGo = slot2
	slot0.onCancel = slot3
end

slot0.InitUI = function (slot0)
	slot0.btnBack = slot0:findTF("panel/btnBack")
	slot0.intensity = slot0:findTF("panel/intensity/nums")
	slot0.area = slot0:findTF("panel/area")
	slot0.content = slot0:findTF("panel/list/content")
	slot0.item = slot0:findTF("panel/list/item")
	slot0.signals = slot0:findTF("panel/signals/nums")
	slot0.btnHelp = slot0:findTF("panel/help_button")
	slot0.btnStart = slot0:findTF("panel/start_button")
	slot0.empty = slot0:findTF("panel/empty")

	setActive(slot0.item, false)
	setText(slot0.item:Find("Info/t1"), i18n("time_remaining_tip"))
	setText(slot0:findTF("panel/title/Text"), i18n("LevelSignal"))
	setText(slot0.item:Find("Info/go/Text"), i18n("LevelSignal_go"))
	setText(slot0.item:Find("Info/start/Text"), i18n("LevelSignal_search"))
	setText(slot0:findTF("panel/signals/text"), i18n("LevelSignal_times"))
	setText(slot0:findTF("panel/intensity/text"), i18n("LevelSignal_intensity"))
end

slot0.set = function (slot0, slot1, slot2)
	slot0.subRefreshCount = slot1
	slot0.subProgress = slot2

	slot0:flush()
	onButton(slot0, slot0.btnHelp, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_sos")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.btnBack, function ()
		if slot0.onCancel then
			slot0.onCancel()
		end
	end, SFX_CANCEL)
end

slot0.flush = function (slot0)
	setText(slot0.signals, slot0.subRefreshCount)
	setText(slot0.area, i18n("levelScene_search_area", math.min(slot0.subProgress, #_.filter(pg.expedition_data_by_map.all, function (slot0)
		return type(pg.expedition_data_by_map[slot0].drop_by_map_display) == "table" and #slot1 > 0
	end)) + 2))
	setText(slot0.intensity, slot2)

	slot3 = {}

	_.each(getProxy(ChapterProxy):getNormalMaps(), function (slot0)
		for slot4, slot5 in ipairs(slot0:getChapters()) do
			if slot5:getPlayType() == ChapterConst.TypeMainSub and slot5:isValid() then
				slot0[slot5:getConfig("map")] = slot5
			end
		end
	end)

	if slot0.timers then
		_.each(slot0.timers, function (slot0)
			slot0:Stop()
		end)
	end

	setActive(slot0.empty, slot2 <= 0)

	slot0.timers = {}
	slot4 = pg.TimeMgr.GetInstance()

	UIItemList.New(slot0.content, slot0.item).make(slot5, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1.barAnims[slot1 + 3] = slot2
			slot5 = slot2:Find("Info/time")
			slot6 = slot2:Find("Info/t1")
			slot1.timers[slot1 + 1] = Timer.New(slot7, 1, -1)

			slot1.timers[slot1 + 1]:Start()
			slot7()
			setText(slot2:Find("name"), i18n("chapter_no", slot3))
			setActive(slot2:Find("Info/go"), slot4)
			onButton(slot1, slot2:Find("Info/go"), function ()
				if slot0.onGo and slot1 then
					slot0.onGo(slot1)
				end
			end, SFX_PANEL)
			setActive(slot2.Find(slot2, "Info/start"), not slot0[slot1 + 3])
			onButton(slot1, slot2:Find("Info/start"), function ()
				if slot0.subRefreshCount > 0 then
					if slot0.onSearch and not slot1 then
						slot0.onSearch(slot2 or 0)
					end
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_sub_refresh_count_not_enough"))
				end
			end, SFX_CONFIRM)
		end
	end)
	UIItemList.New(slot0.content, slot0.item).align(slot5, slot2)
end

slot0.PlaySubRefreshAnimation = function (slot0, slot1, slot2)
	if IsNil(slot0.barAnims[slot1]) then
		existCall(slot2)

		return
	end

	slot3:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot5, function (slot0)
		slot0:SetEndEvent(nil)
		existCall(existCall)
	end)
	slot3:GetComponent(typeof(Animator)).Play(slot4, "loading", -1, 0)
end

return slot0

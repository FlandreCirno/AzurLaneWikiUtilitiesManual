slot0 = class("LevelRemasterView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "LevelRemasterView"
end

slot0.OnInit = function (slot0)
	slot0:InitUI()
	slot0:Show()
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.OnDestroy = function (slot0)
	slot0.onItem = nil
	slot0.onCancel = nil

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTF)
end

slot0.setCBFunc = function (slot0, slot1, slot2)
	slot0.onItem = slot1
	slot0.onCancel = slot2
end

slot0.InitUI = function (slot0)
	slot0.content = slot0:findTF("list/content")
	slot0.item = slot0.content:Find("item")
	slot0.numsTxt = slot0:findTF("nums/text")
	slot0.helpBtn = slot0:findTF("help")

	setActive(slot0.item, false)

	slot0.getRemasterTF = slot0:findTF("getBtn/state_before")
	slot0.gotRemasterTF = slot0:findTF("getBtn/state_after")
	slot0.exToggle = slot0:findTF("toggles/EX")
	slot0.spToggle = slot0:findTF("toggles/SP")
end

slot0.set = function (slot0, slot1, slot2, slot3)
	slot0.templates = slot1
	slot0.tickets = slot2
	slot0.temp = slot0.temp or slot1

	slot0:flush(slot3)
end

slot0.flush = function (slot0, slot1)
	slot2 = pg.TimeMgr.GetInstance()

	UIItemList.New(slot0.content, slot0.item).make(slot3, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot0.temp[slot1 + 1]

			setActive(slot2:Find("right"), slot1 % 2 == 0)
			setActive(setActive, false)
			setActive(slot2.Find("right"), false)
			setActive(slot1 % 2 == 0, false)
			setText(slot2:Find("bg/index"), (slot1 + 1 < 10 and "0" .. slot1 + 1) or slot1 + 1)

			if not slot3 then
				setActive(slot6, true)
				onButton(slot0, slot6, function ()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			elseif not slot1.inTime(slot7, slot3.time) then
				setActive(slot5, true)
				onButton(slot0, slot5, function ()
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_remaster_do_not_open"))
				end, SFX_PANEL)
			else
				setActive(slot4, true)
				GetImageSpriteFromAtlasAsync("activitybanner/" .. slot3.bg, "", slot4)
				setSlider(slot4.Find(slot4, "progress"), 0, 1, slot8)
				setText(slot4:Find("progress_text"), math.floor(#_.filter(pg.memory_group[slot3.memory_group].memories, function (slot0)
					return pg.NewStoryMgr.GetInstance():IsPlayed(pg.memory_template[slot0].story, true)
				end) / #pg.memory_group[slot3.memory_group].memories * 100) .. "%")
				onButton(slot0, slot4, function ()
					slot0.onItem(slot1)
				end, SFX_PANEL)
			end
		end
	end)
	setText(slot0.numsTxt, slot0.tickets .. "/" .. pg.gameset.reactivity_ticket_max.key_value)
	onButton(slot0, slot0._tf, function ()
		slot0.onCancel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_remaster_help_tip")
		})
	end, SFX_PANEL)

	if getProxy(ChapterProxy).remasterDailyCount > 0 then
		SetActive(slot0.getRemasterTF, false)
		SetActive(slot0.gotRemasterTF, true)
	else
		SetActive(slot0.getRemasterTF, true)
		SetActive(slot0.gotRemasterTF, false)
		onButton(slot0, slot0.getRemasterTF, function ()
			if pg.gameset.reactivity_ticket_max.key_value < slot0.remasterTickets + pg.gameset.reactivity_ticket_daily.key_value then
				pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
					content = i18n("tack_tickets_max_warning", math.max(pg.gameset.reactivity_ticket_max.key_value - slot0.remasterTickets, 0)),
					onYes = function ()
						slot0:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
					end
				})

				return
			end

			slot1:emit(LevelMediator2.ON_CLICK_RECEIVE_REMASTER_TICKETS_BTN)
		end, SFX_PANEL)
	end

	slot5 = {
		slot0.exToggle,
		slot0.spToggle
	}

	for slot9, slot10 in ipairs(slot5) do
		onToggle(slot0, slot10, function (slot0)
			if slot0 then
				slot0.temp = _.filter(slot0.templates, function (slot0)
					return slot0.activity_type == slot0
				end)

				_.filter(slot0.templates, function (slot0)
					return slot0.activity_type == slot0
				end).align(slot1, math.max(math.ceil(#slot0.temp / 2) * 2, 4))
			end
		end, SFX_PANEL)
	end

	triggerToggle(slot5[(slot1 and 2) or 1], true)
end

return slot0

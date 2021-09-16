slot0 = class("ActivityPermanentLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "ActivitySelectUI"
end

slot0.onBackPressed = function (slot0)
	slot0:closeView()
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.rtMsgbox) then
		slot0:hideMsgbox()
	else
		slot0.super.onBackPressed(slot0)
	end
end

slot0.init = function (slot0)
	slot0.bg = slot0._tf:Find("bg_back")

	onButton(slot0, slot0.bg, function ()
		slot0:closeView()
	end, SFX_CANCEL)

	slot0.btnBack = slot0._tf.Find(slot1, "window/inner/top/back")

	onButton(slot0, slot0.btnBack, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	setText(slot0._tf.Find(slot2, "window/inner/top/back/Text"), i18n("activity_permanent_total"))

	slot0.btnHelp = slot0._tf:Find("window/inner/top/help")

	onButton(slot0, slot0.btnHelp, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("activity_permanent_help")
		})
	end, SFX_PANEL)

	slot0.content = slot0._tf.Find(slot1, "window/inner/content/scroll_rect")
	slot0.itemList = UIItemList.New(slot0.content, slot0.content:Find("item"))
	slot1 = getProxy(ActivityPermanentProxy)

	slot0.itemList:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("main/word/Text"), pg.activity_task_permanent[slot0.ids[slot1]].gametip)
			setText(slot2:Find("main/Image/tip/Text"), pg.activity_task_permanent[slot0.ids[slot1]].gametip_extra)
			GetImageSpriteFromAtlasAsync("activitybanner/" .. pg.activity_task_permanent[slot0.ids[slot1]].banner_route, "", slot2:Find("main/Image"))
			onButton(slot0, slot2:Find("main"), function ()
				slot0:showMsgbox(slot0)
			end, SFX_PANEL)

			slot6 = GetOrAddComponent(slot5, typeof(CanvasGroup))

			if slot0.ids[slot1] == slot0.contextData.finishId then
				slot0.childFinish = slot2
				slot6.alpha = 0
			else
				slot6.alpha = 1
			end

			setText(slot5:Find("Image/Text"), i18n("activity_permanent_finished"))
			setActive(slot5, slot1:isActivityFinish(slot3))
		end
	end)

	slot0.rtMsgbox = slot0._tf.Find(slot2, "Msgbox")

	onButton(slot0, slot0.rtMsgbox:Find("bg"), function ()
		slot0:hideMsgbox()
	end, SFX_CANCEL)
	onButton(slot0, slot0.rtMsgbox:Find("window/top/btnBack"), function ()
		slot0:hideMsgbox()
	end, SFX_CANCEL)
	onButton(slot0, slot0.rtMsgbox:Find("window/button_container/custom_button_2"), function ()
		slot0:hideMsgbox()
	end, SFX_CANCEL)
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0.itemList:align(#slot0.ids)

	if slot0.childFinish then
		scrollTo(slot0.content, nil, math.clamp(slot0.childFinish.anchoredPosition.y / (slot0.content.rect.height - slot0.content:GetComponent(typeof(ScrollRect)).viewport.rect.height), 0, 1))
		slot0:doFinishAnim(slot0.childFinish)

		slot0.childFinish = nil
	end

	if PlayerPrefs.GetInt("permanent_select", 0) ~= 1 then
		PlayerPrefs.SetInt("permanent_select", 1)
		triggerButton(slot0.btnHelp)
	end
end

slot0.willExit = function (slot0)
	if isActive(slot0.rtMsgbox) then
		slot0:hideMsgbox()
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)

	if slot0.ltId then
		LeanTween.cancel(slot0.ltId)

		slot0.ltId = nil
	end
end

slot0.setActivitys = function (slot0, slot1)
	slot0.ids = slot1
	slot2 = getProxy(ActivityPermanentProxy)

	table.sort(slot0.ids, function (slot0, slot1)
		if slot0:isActivityFinish(slot0) == slot0:isActivityFinish(slot1) then
			return slot0 < slot1
		else
			return slot3
		end
	end)
end

slot0.doFinishAnim = function (slot0, slot1)
	slot0.ltId = LeanTween.alphaCanvas(GetOrAddComponent(slot2, typeof(CanvasGroup)), 1, 1).uniqueId
end

slot0.showMsgbox = function (slot0, slot1)
	setText(slot0.rtMsgbox:Find("window/msg_panel/content"), i18n("activity_permanent_tips1", pg.activity_task_permanent[slot1].activity_name))
	setText(slot0.rtMsgbox:Find("window/msg_panel/Text"), i18n("activity_permanent_tips4"))
	onButton(slot0, slot0.rtMsgbox:Find("window/button_container/custom_button_1"), function ()
		slot0:hideMsgbox()
		slot0.hideMsgbox:emit(ActivityPermanentMediator.START_SELECT, slot0.hideMsgbox)
	end, SFX_CONFIRM)
	setActive(slot0.rtMsgbox, true)
	pg.UIMgr.GetInstance().BlurPanel(slot2, slot0.rtMsgbox)
end

slot0.hideMsgbox = function (slot0)
	setActive(slot0.rtMsgbox, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.rtMsgbox)
end

return slot0

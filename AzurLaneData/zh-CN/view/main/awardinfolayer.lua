slot0 = class("AwardInfoLayer", import("..base.BaseUI"))
slot0.TITLE = {
	COMMANDER = "commander",
	ITEM = "item",
	SHIP = "ship",
	REVERT = "revert",
	ESCORT = "escort"
}
slot1 = 0.15
slot2 = 340
slot3 = 564

slot0.getUIName = function (slot0)
	return "AwardInfoUI"
end

slot0.setAwards = function (slot0, slot1)
	return
end

slot0.init = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})

	slot0.awards = _.select(slot0.contextData.items or {}, function (slot0)
		return slot0.type ~= DROP_TYPE_ICON_FRAME and slot0.type ~= DROP_TYPE_CHAT_FRAME
	end)
	slot0._itemsWindow = slot0._tf.Find(slot1, "items")
	slot0.spriteMask = slot0._itemsWindow:Find("SpriteMask")
	slot0.title = slot0.contextData.title or slot0.TITLE.ITEM

	for slot4, slot5 in pairs(slot0.TITLE) do
		setActive(slot0._itemsWindow:Find("titles/title_" .. slot5), slot0.title == slot5)
	end

	if slot0.title == slot0.TITLE.COMMANDER then
		eachChild(slot0._itemsWindow:Find("titles/title_commander"), function (slot0)
			setActive(slot0, slot0.name == slot0.contextData.titleExtra)
		end)
	end

	slot1 = {
		items_scroll = slot0._itemsWindow.Find(slot2, "items_scroll/content"),
		ships = slot0._itemsWindow:Find("ships")
	}

	if slot0.title == slot0.TITLE.SHIP then
		slot0.container = slot1.ships
	else
		slot0.container = slot1.items_scroll

		scrollTo(slot0.container, nil, 1)

		slot0.windowLayout = slot0._itemsWindow:Find("items_scroll"):GetComponent(typeof(LayoutElement))
	end

	GetOrAddComponent(slot0.container, "CanvasGroup").alpha = 1

	for slot5, slot6 in pairs(slot1) do
		setActive(slot0._itemsWindow:Find(slot5), slot0.container == slot6)
	end

	setLocalScale(slot0._itemsWindow, Vector3(0.5, 0.5, 0.5))

	slot0.itemTpl = slot0._itemsWindow:Find("item_tpl")
	slot0.shipTpl = slot0._itemsWindow:Find("ship_tpl")
	slot0.extraBouns = slot0._itemsWindow:Find("titles/extra_bouns")

	setActive(slot0.extraBouns, slot0.contextData.extraBonus)

	slot0.continueBtn = slot0:findTF("items/close")
	slot2 = slot0._tf:Find("decorations")

	if slot0.title == slot0.TITLE.SHIP then
		setLocalScale(slot2, Vector3.New(1.25, 1.25, 1))
	else
		setLocalScale(slot2, Vector3.one)
	end

	slot0.blinks = {}
	slot0.tweenItems = {}
	slot0.shipCardTpl = slot0._tf:GetComponent("ItemList").prefabItem[0]

	slot0._tf:SetAsLastSibling()

	slot0.metaRepeatAwardTF = slot0:findTF("MetaShipRepeatAward")
end

slot0.doAnim = function (slot0, slot1)
	LeanTween.scale(rtf(slot0._itemsWindow), Vector3(1, 1, 1), 0.15):setEase(LeanTweenType.linear):setOnComplete(System.Action(function ()
		if slot0.exited then
			return
		end

		slot1()
	end))
end

slot0.playAnim = function (slot0, slot1)
	slot2 = {}

	for slot6 = 1, #slot0.awards, 1 do
		table.insert(slot2, function (slot0)
			setActive(slot0.container:GetChild(slot1 - 1), true)

			if slot0.windowLayout then
				if slot1 > 5 and slot0.windowLayout.preferredHeight ~= slot2 then
					slot0.windowLayout.preferredHeight = slot2

					onNextTick(function ()
						slot0:updateSpriteMaskScale()
					end)
				end

				if slot1 % 5 == 1 then
					scrollTo(slot0.container, nil, 0)
				end
			end

			slot0.tweeningId = LeanTween.delayedCall(slot3, System.Action(slot0)).uniqueId
		end)
	end

	seriesAsync(slot2, function ()
		slot0.tweeningId = nil

		if nil then
			slot1()
		end
	end)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._tf, function ()
		if slot0.tweeningId then
			LeanTween.cancel(slot0.tweeningId)

			LeanTween.cancel.tweeningId = nil
		end

		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL, {
		noShip = not slot0.hasShip
	})
	onButton(slot0, slot0.continueBtn, function ()
		triggerButton(slot0._tf)
	end)
	pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot1, SFX_UI_GETITEM)
	table.insert(slot1, function (slot0)
		slot0:doAnim(slot0)
	end)
	slot0.displayAwards(slot0)

	if slot0.contextData.animation then
		eachChild(slot0.container, function (slot0)
			setActive(slot0, false)
		end)

		GetOrAddComponent(slot0.container, "CanvasGroup").alpha = 0

		table.insert(slot1, function (slot0)
			GetOrAddComponent(slot0.container, "CanvasGroup").alpha = 1

			slot0:playAnim(slot0)
		end)
	end

	if slot0.windowLayout then
		slot0.windowLayout.preferredHeight = (not slot0.contextData.animation and #slot0.awards > 5 and slot1) or slot0.windowLayout

		slot0.updateSpriteMaskScale(slot0)
	end

	seriesAsync(slot1, function ()
		if slot0.exited then
			return
		end

		if slot0.contextData.closeOnCompleted then
			slot0:closeView()
		end

		if slot0.enterCallback then
			slot0.enterCallback()

			slot0.enterCallback.enterCallback = nil
		end
	end)
end

slot0.onUIAnimEnd = function (slot0, slot1)
	slot0.enterCallback = slot1
end

slot0.onBackPressed = function (slot0)
	if LeanTween.isTweening(go(slot0._itemsWindow)) then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(slot0._tf)
end

function slot4(slot0, slot1)
	slot2 = pg.ship_data_statistics[slot1.id]
	slot3 = Ship.New({
		configId = slot1.id
	})
	slot3.virgin = slot1.virgin

	setScrollText(findTF(slot0, "content/info/name_mask/name"), slot3:getName())
	flushShipCard(slot0, slot3)
	setActive(findTF(slot0, "content/front/new"), slot1.virgin)
end

slot0.displayAwards = function (slot0)
	removeAllChildren(slot0.container)

	for slot4 = 1, #slot0.awards, 1 do
		if slot0.title ~= slot0.TITLE.SHIP then
			cloneTplTo(slot0.itemTpl, slot0.container)
		else
			cloneTplTo(slot0.shipCardTpl, cloneTplTo(slot0.shipTpl, slot0.container), "ship_tpl")
		end
	end

	if slot0.title ~= slot0.TITLE.SHIP then
		for slot4 = 1, #slot0.awards, 1 do
			slot5 = slot0.container:GetChild(slot4 - 1):Find("bg")

			if slot0.awards[slot4].type == DROP_TYPE_SHIP then
				slot0.hasShip = true
			end

			updateDrop(slot5, slot6, {
				fromAwardLayer = true
			})
			setActive(findTF(slot5, "icon_bg/bonus"), slot6.riraty)
			setActive(findTF(slot5, "icon_bg/bonus_catchup"), slot6.catchupTag)
			setActive(findTF(slot5, "icon_bg/bonus_event"), slot6.catchupActTag)
			setActive(slot7, false)
			setActive(slot8, true)
			setScrollText(findTF(slot5, "name_mask/name"), slot6.name or getText(slot7))
			onButton(slot0, slot5, function ()
				if slot0.tweeningId then
					return
				end

				slot0:emit(AwardInfoMediator.ON_DROP, slot0)
			end, SFX_PANEL)
		end
	else
		for slot4 = 1, #slot0.awards, 1 do
			slot1(slot0.container.GetChild(slot5, slot4 - 1):Find("ship_tpl"), slot0.awards[slot4])

			if slot0.awards[slot4].reMetaSpecialItemVO then
				slot8 = cloneTplTo(slot0.metaRepeatAwardTF, slot5)

				setLocalPosition(slot8, Vector3.zero)
				setLocalScale(slot8, Vector3.zero)
				updateDrop(slot9, slot7)
				slot0.managedTween(slot0, LeanTween.delayedCall, function ()
					slot0:managedTween(LeanTween.value, nil, go(slot1), 0, 1, 0.3):setOnUpdate(System.Action_float(function (slot0)
						setLocalScale(slot0, {
							x = slot0,
							y = slot0
						})
					end)).setOnComplete(slot0, System.Action(function ()
						setLocalScale(setLocalScale, Vector3.one)
					end))
				end, 0.3, nil)
			end

			if #slot0.awards > 5 then
				if slot4 <= 5 then
					slot5.anchoredPosition = Vector2.New(-50, 0)
				else
					slot5.anchoredPosition = Vector2.New(50, 0)
				end
			end
		end
	end
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)

	if slot0.title ~= slot0.TITLE.SHIP then
		for slot4 = 0, slot0.container.childCount - 1, 1 do
			clearDrop(slot0.container:GetChild(slot4):Find("bg"))
		end
	end

	if slot0.blinks and #slot0.blinks > 0 then
		for slot4, slot5 in pairs(slot0.blinks) do
			if not IsNil(slot5) then
				Destroy(slot5)
			end
		end
	end

	if slot0.contextData.removeFunc then
		slot0.contextData.removeFunc()
	end
end

slot0.updateSpriteMaskScale = function (slot0)
	setLocalScale(slot0.spriteMask, Vector3(slot0.spriteMask.rect.width / WHITE_DOT_SIZE * PIXEL_PER_UNIT, slot0.spriteMask.rect.height / WHITE_DOT_SIZE * PIXEL_PER_UNIT, 1))
end

return slot0

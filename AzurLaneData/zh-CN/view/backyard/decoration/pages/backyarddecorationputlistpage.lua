slot0 = class("BackYardDecorationPutlistPage", import(".BackYardDecorationBasePage"))

slot0.getUIName = function (slot0)
	return "BackYardPutListPage"
end

slot0.OnLoaded = function (slot0)
	slot0._bg = slot0:findTF("bg")
	slot0.scrollRect = slot0:findTF("bg/frame0/frame/scrollrect"):GetComponent("LScrollRect")
	slot0.scrollRectTF = slot0:findTF("bg/frame0/frame/scrollrect")
	slot0.emptyTF = slot0:findTF("bg/frame0/frame/empty")
	slot0.arr = slot0:findTF("bg/frame0/frame/arr")
end

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.arr, function ()
		slot0:Hide()
	end, SFX_PANEL)

	function slot1()
		if slot0.timer then
			slot0.timer:Stop()

			slot0.timer.Stop.timer = nil
		end
	end

	function slot2(slot0)
		slot0.timer = Timer.New(slot0, 0.8, 1)

		slot0.timer:Start()
	end

	function slot3(slot0)
		slot2 = nil

		for slot6, slot7 in pairs(slot1.cards) do
			slot11 = Vector2(slot7._tf.localPosition.x + slot7._tf.rect.width / 2, slot7._tf.localPosition.y + slot7._tf.rect.height / 2)
			slot12 = Vector2(slot7._tf.localPosition.x + slot7._tf.rect.width / 2, slot7._tf.localPosition.y - slot7._tf.rect.height / 2)

			if Vector2(slot7._tf.localPosition.x - slot7._tf.rect.width / 2, slot7._tf.localPosition.y - slot7._tf.rect.height / 2).x < slot1.x and slot1.x < slot12.x and slot12.y < slot1.y and slot1.y < slot11.y then
				slot2 = slot7

				break
			end
		end

		return slot2
	end

	GetOrAddComponent(slot0.scrollRectTF, typeof(EventTriggerListener)).AddPointDownFunc(slot4, function (slot0, slot1)
		slot1.downPosition = slot1.position

		if slot0(slot1) then
			slot2()
			slot2(function ()
				slot0.lock = true

				slot0.contextData.furnitureDescMsgBox:ExecuteAction("SetUp", slot1.furniture, slot1._tf.position, true)
			end)
		end
	end)
	GetOrAddComponent(slot0.scrollRectTF, typeof(EventTriggerListener)).AddPointUpFunc(slot4, function (slot0, slot1)
		slot0()

		if slot1.lock then
			slot1.contextData.furnitureDescMsgBox:ExecuteAction("Hide")
			onNextTick(function ()
				slot0.lock = false
			end)
		else
			slot2 = slot1.position

			if Vector2.Distance(slot2, slot1.downPosition) > 1 then
				return
			end

			if slot2(slot1) then
				slot1:emit(BackYardDecorationMediator.ON_SELECTED_FURNITRUE, slot3.furniture.id)
			end
		end
	end)
end

slot0.change2ScrPos = function (slot0, slot1)
	return LuaHelper.ScreenToLocal(slot0:GetComponent("RectTransform"), slot1, GameObject.Find("UICamera"):GetComponent("Camera"))
end

slot0.OnInitItem = function (slot0, slot1)
	slot0.cards[slot1] = BackYardDecorationPutCard.New(slot1)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitItem(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:Update(slot0.displays[slot1 + 1])
end

slot0.OnDisplayList = function (slot0)
	slot0.displays = {}
	slot2 = getProxy(DormProxy).floor

	for slot6, slot7 in pairs(slot1) do
		if slot7.floor == slot2 then
			table.insert(slot0.displays, slot7)
		end
	end

	table.sort(slot0.displays, function (slot0, slot1)
		return slot0:getConfig("type") < slot1:getConfig("type")
	end)
	setActive(slot0.emptyTF, #slot0.displays == 0)
	slot0.scrollRect.SetTotalCount(slot3, #slot0.displays)
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	LeanTween.value(slot0._bg.gameObject, slot1, 0, 0.4):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0._bg, {
			x = slot0
		})
	end)).setOnComplete(slot2, System.Action(function ()
		if slot0.OnShow then
			slot0.OnShow(true)
		end
	end))

	if slot0.OnShowImmediately then
		slot0.OnShowImmediately()
	end
end

slot0.Hide = function (slot0)
	LeanTween.value(slot0._bg.gameObject, 0, slot1, 0.4):setOnUpdate(System.Action_float(function (slot0)
		setAnchoredPosition(slot0._bg, {
			x = slot0
		})
	end)).setOnComplete(slot2, System.Action(function ()
		slot0.super.Hide(slot1)

		if slot1.OnShow then
			slot1.OnShow(false)
		end
	end))
end

slot0.OnDormUpdated = function (slot0)
	slot0:OnDisplayList()
end

slot0.OnDestroy = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

return slot0

slot0 = class("BackYardDecorationFurniturePage", import(".BackYardDecorationBasePage"))

function slot1(slot0)
	if not slot0.tagsList then
		slot0.tagsList = {
			2,
			3,
			4,
			5,
			6,
			7
		}
	end

	return slot0.tagsList[slot0]
end

slot0.getUIName = function (slot0)
	return "BackYardDecorationFurniturePage"
end

slot0.OnFurnitureUpdated = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.cards) do
		if slot6.furniture:getConfig("id") == slot1:getConfig("id") then
			slot6:Flush(slot1, slot0.dorm:GetPutCntForFurniture(slot1))

			break
		end
	end
end

slot0.OnDisplayList = function (slot0)
	slot0.displays = slot0:GetDisplays()

	slot0:SortDisplays()
end

function slot2(slot0, slot1, slot2, slot3)
	if ((slot3[slot0.id].ownCnt > slot3[slot0.id].putCnt or 0) and 1) == ((slot3[slot1.id].ownCnt > slot3[slot1.id].putCnt or 0) and 1) then
		if slot2 == BackYardDecorationFilterPanel.ORDER_MODE_ASC then
			return slot0.id < slot1.id
		elseif slot2 == BackYardDecorationFilterPanel.ORDER_MODE_DASC then
			return slot1.id < slot0.id
		end
	else
		return slot6 < slot7
	end
end

slot0.SortDisplays = function (slot0)
	if not slot0.contextData.filterPanel:GetLoaded() then
		slot1 = {}

		for slot5, slot6 in ipairs(slot0.displays) do
			slot1[slot6.id] = {
				putCnt = slot0.dorm:GetPutCntForFurniture(slot6),
				ownCnt = slot6:GetOwnCnt()
			}
		end

		table.sort(slot0.displays, function (slot0, slot1)
			return slot0(slot0, slot1, slot1.orderMode, slot0)
		end)
		slot0.SetTotalCount(slot0)

		return
	end

	slot0.contextData.filterPanel:setFilterData(slot0:GetDisplays())
	slot0.contextData.filterPanel:filter()
	slot0:OnFilterDone(slot0.contextData.filterPanel:GetFilterData())
end

slot0.OnOrderModeUpdated = function (slot0)
	slot0:SortDisplays()
end

slot0.change2ScrPos = function (slot0, slot1)
	return LuaHelper.ScreenToLocal(slot0:GetComponent("RectTransform"), slot1, GameObject.Find("UICamera"):GetComponent("Camera"))
end

slot0.OnLoaded = function (slot0)
	slot0.scrollRect = slot0._tf:GetComponent("LScrollRect")

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
			slot11 = Vector2(slot7._tf.localPosition.x + slot7._bg.rect.width / 2, slot7._tf.localPosition.y + slot7._bg.rect.height / 2)
			slot12 = Vector2(slot7._tf.localPosition.x + slot7._bg.rect.width / 2, slot7._tf.localPosition.y - slot7._bg.rect.height / 2)

			if Vector2(slot7._tf.localPosition.x - slot7._bg.rect.width / 2, slot7._tf.localPosition.y - slot7._bg.rect.height / 2).x < slot1.x and slot1.x < slot12.x and slot12.y < slot1.y and slot1.y < slot11.y then
				slot2 = slot7

				break
			end
		end

		return slot2
	end

	GetOrAddComponent(slot0._tf, typeof(EventTriggerListener)).AddPointDownFunc(slot4, function (slot0, slot1)
		slot0.downPosition = slot1.position

		if slot1(slot1) then
			slot2()
			slot2(function ()
				slot0.lock = true

				slot0.contextData.furnitureDescMsgBox:ExecuteAction("SetUp", slot1.furniture, slot1._tf.position)
			end)
		end
	end)
	GetOrAddComponent(slot0._tf, typeof(EventTriggerListener)).AddPointUpFunc(slot4, function (slot0, slot1)
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

			if slot2(slot1) and slot3:HasMask() and slot3.furniture:isPaper() then
				slot1:emit(BackYardDecorationMediator.REMOVE_PAPER, slot3.furniture)
			elseif slot3 and not slot3:HasMask() then
				slot4 = Clone(slot3.furniture)

				slot4:clearPosition()
				slot1:emit(BackYardDecorationMediator.ADD_FURNITURE, slot4)
			end
		end
	end)
end

slot0.OnInitItem = function (slot0, slot1)
	slot0.cards[slot1] = BackYardDecorationCard.New(slot1)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitItem(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:Update(slot0.lastDiaplys[slot1 + 1], slot0.dorm:GetPutCntForFurniture(slot4))
end

slot0.GetDisplays = function (slot0)
	slot1 = {}

	for slot6, slot7 in pairs(slot2) do
		if pg.furniture_data_template[slot7.id] and slot0(slot7:getConfig("tag")) == slot0.pageType then
			table.insert(slot1, slot7)
		end
	end

	return slot1
end

slot0.OnFilterDone = function (slot0, slot1)
	slot0.displays = slot1

	slot0:SetTotalCount()
end

slot0.SetTotalCount = function (slot0)
	slot0.lastDiaplys = {}

	for slot4, slot5 in ipairs(slot0.displays) do
		if slot5:isMatchSearchKey(slot0.searchKey) then
			table.insert(slot0.lastDiaplys, slot5)
		end
	end

	slot0.scrollRect:SetTotalCount(#slot0.lastDiaplys)
end

slot0.OnSearchKeyChanged = function (slot0)
	slot0:SetTotalCount()
end

slot0.OnDestroy = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

return slot0

slot0 = class("CommanderBoxesPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "CommanderBoxesUI"
end

slot0.OnInit = function (slot0)
	slot0.boxCards = {}
	slot0.startBtn = slot0._tf:Find("frame/boxes/start_btn")
	slot0.finishBtn = slot0._tf:Find("frame/boxes/finish_btn")
	slot0.closeBtn = slot0._tf:Find("frame/close_btn")
	slot0.boxesList = UIItemList.New(slot0._tf:Find("frame/boxes/mask/content"), slot0._tf:Find("frame/boxes/mask/content/frame"))
	slot0.scrollRect = slot0._tf:Find("frame/boxes/mask")
	slot0.buildPoolPanel = CommanderBuildPoolPanel.New(slot0._tf:Find("buildpool_panel"), slot0)
	slot0.traningCnt = slot0._tf:Find("frame/boxes/statistics/traning"):GetComponent(typeof(Text))
	slot0.waitCnt = slot0._tf:Find("frame/boxes/statistics/wait"):GetComponent(typeof(Text))
	slot0.itemCnt = slot0._tf:Find("frame/item/Text"):GetComponent(typeof(Text))

	setActive(slot0._tf:Find("frame/item"), not LOCK_CATTERY)

	slot0.mask = slot0._tf:Find("mask")

	setActive(slot0.mask, false)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.startBtn, function ()
		for slot4, slot5 in ipairs(slot0.boxes) do
			if slot5:getState() == CommanderBox.STATE_EMPTY then
				slot0 = slot0 + 1
			end
		end

		if slot0 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("commander_build_solt_deficiency"))

			return
		end

		slot0.buildPoolPanel:Show(slot0.pools, slot0)
	end, SFX_PANEL)
	onButton(slot0, slot0.finishBtn, function ()
		if #slot0.boxes <= 0 then
			return
		end

		scrollTo(slot0.scrollRect, nil, 1)
		scrollTo:emit(CommandRoomMediator.ON_BATCH_GET, slot0.boxes)
	end, SFX_PANEL)
	setActive(slot0._tf.Find(slot2, "frame"), true)
end

slot0.Update = function (slot0, slot1, slot2)
	slot0.boxes = slot1
	slot0.pools = slot2

	table.sort(slot3, function (slot0, slot1)
		if slot0.state == slot1.state then
			return slot0.id < slot1.id
		else
			return slot3 < slot2
		end
	end)
	slot0.boxesList.make(slot4, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot0[slot1 + 1]

			if not slot1.boxCards[slot1] then
				slot1.boxCards[slot1] = CommanderBoxCard.New(slot1, slot2)
			end

			if not (slot1 > 3 and slot3.state == CommanderBox.STATE_EMPTY) then
				slot4:Update(slot3)
			else
				slot4:Clear()
			end

			setActive(slot2, not slot5)
		end
	end)
	slot0.boxesList.align(slot4, #_.map(slot0.boxes, function (slot0)
		slot0.state = slot0:getState()

		return slot0
	end))
	slot0:Show()
	slot0:UpdateItem()
	slot0:updateCntLabel()
end

slot0.updateCntLabel = function (slot0)
	slot1 = 0

	_.each(slot0.boxes, function (slot0)
		slot0.state = slot0:getState()

		if slot0.state == CommanderBox.STATE_WAITING then
			slot0 = slot0 + 1
		elseif slot0.state == CommanderBox.STATE_STARTING then
			slot1 = slot1 + 1
		end
	end)

	slot0.traningCnt.text = slot1 .. "/" .. CommanderProxy.MAX_WORK_COUNT
	slot0.waitCnt.text = slot2 .. "/" .. CommanderProxy.MAX_SLOT - CommanderProxy.MAX_WORK_COUNT
end

slot0.Show = function (slot0)
	slot0.activation = true

	setActive(slot0._go, true)
end

slot0.Hide = function (slot0)
	slot0.buildPoolPanel:Hide()

	slot0.activation = false

	setActive(slot0._go, false)
end

slot0.isShow = function (slot0)
	return slot0.activation
end

slot0.playFinshedAnim = function (slot0, slot1, slot2)
	slot3 = nil

	for slot7, slot8 in pairs(slot0.boxCards) do
		if slot8.boxVO and slot8.boxVO.id == slot1 then
			slot3 = slot8

			break
		end
	end

	if slot3 then
		slot3:playAnim(slot2)
	else
		slot2()
	end
end

slot0.onBackPressed = function (slot0)
	if slot0.buildPoolPanel and slot0.buildPoolPanel.isShow then
		slot0.buildPoolPanel:Hide()

		return
	else
		slot0:Hide()
	end
end

slot0.UpdateItem = function (slot0)
	slot0.itemCnt.text = getProxy(BagProxy):getItemCountById(Item.COMMANDER_QUICKLY_TOOL_ID)
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()

	slot1 = pairs
	slot2 = slot0.boxCards or {}

	for slot4, slot5 in slot1(slot2) do
		slot5:Destroy()
	end

	slot0.boxCards = {}
end

return slot0

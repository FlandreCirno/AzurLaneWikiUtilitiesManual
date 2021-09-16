slot0 = class("RivalInfoLayer", import("..base.BaseUI"))
slot0.TYPE_DISPLAY = 1
slot0.TYPE_BATTLE = 2

slot0.getUIName = function (slot0)
	return "RivalInfoUI"
end

slot0.setRival = function (slot0, slot1)
	slot0.rivalVO = slot1
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():LoadingOn()
	onButton(slot0, findTF(slot0._tf, "bg"), function ()
		slot0:emit(slot1.ON_CLOSE)
	end)

	slot0.shipCardTpl = slot0._tf.GetComponent(slot1, "ItemList").prefabItem[0]
	slot0.startBtn = findTF(slot0._tf, "ships_container/start_btn")

	setActive(slot0.startBtn, false)
	setActive(findTF(slot0._tf, "info/title_miex"), slot0.contextData.type == slot0.TYPE_BATTLE)
	onButton(slot0, slot0.startBtn, function ()
		slot0:emit(RivalInfoMediator.START_BATTLE)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance().BlurPanel(slot1, slot0._tf)
	slot0:initRivalInfo()
end

slot0.initRivalInfo = function (slot0)
	setText(findTF(slot0._tf, "info/name/container/name"), slot0.rivalVO.name)
	setText(findTF(slot0._tf, "info/name/container/lv"), "Lv." .. slot0.rivalVO.level)
	setActive(findTF(slot0._tf, "info/rank"), slot0.rivalVO.rank ~= nil)
	setActive(findTF(slot0._tf, "info/medal"), slot0.rivalVO.rank ~= nil)
	setActive(findTF(slot0._tf, "info/medal/Text"), slot0.rivalVO.rank ~= nil)

	if slot0.rivalVO.rank then
		setText(findTF(slot0._tf, "info/rank/container/value"), slot0.rivalVO.rank)

		slot1 = SeasonInfo.getMilitaryRank(slot0.rivalVO.score, slot0.rivalVO.rank)
		slot2 = findTF(slot0._tf, "info/medal"):GetComponent(typeof(Image))
		slot3 = findTF(slot0._tf, "info/medal/Text"):GetComponent(typeof(Image))

		LoadSpriteAsync("emblem/" .. slot4, function (slot0)
			slot0.sprite = slot0

			slot0:SetNativeSize()
		end)
		LoadSpriteAsync("emblem/n_" .. slot4, function (slot0)
			slot0.sprite = slot0

			slot0:SetNativeSize()
		end)
	end

	function slot1(slot0, slot1)
		flushShipCard(slot0, slot1)
		setScrollText(findTF(slot0, "content/info/name_mask/name"), slot1:getName())
	end

	function slot2(slot0, slot1, slot2, slot3)
		cloneTplTo(slot0.shipCardTpl, slot2).localScale = Vector3(1.1, 1.1, 1)

		setActive(slot0:findTF("content", cloneTplTo(slot0.shipCardTpl, slot2)), slot3 ~= nil)
		setActive(slot0:findTF("empty", slot4), slot3 == nil)

		if slot3 then
			slot1(slot4, slot3)
		end
	end

	slot3 = slot0.findTF(slot0, "ships_container/ships/main", slot0._tf)
	slot4 = #slot0.rivalVO.mainShips

	for slot8 = 1, 3, 1 do
		slot2(slot4, slot8, slot3, slot0.rivalVO.mainShips[slot8])
	end

	slot5 = slot0:findTF("ships_container/ships/vanguard", slot0._tf)
	slot6 = #slot0.rivalVO.vanguardShips

	for slot10 = 1, 3, 1 do
		slot2(slot6, slot10, slot5, slot0.rivalVO.vanguardShips[slot10])
	end

	slot7 = slot0:findTF("ships_container/main_comprehensive", slot0._tf)
	slot8 = slot0:findTF("ships_container/vanguard_comprehensive", slot0._tf)
	slot10 = slot0:findTF("ships_container/vanguard_comprehensive/Text", slot0._tf)

	LeanTween.value(go(slot9), 0, slot11, 0.5):setOnUpdate(System.Action_float(function (slot0)
		setText(slot0, math.floor(slot0))
	end))
	LeanTween.value(go(slot10), 0, slot12, 0.5):setOnUpdate(System.Action_float(function (slot0)
		setText(slot0, math.floor(slot0))
	end)).setOnComplete(slot13, System.Action(function ()
		slot0(slot0.startBtn, slot0.contextData.type == slot0.TYPE_BATTLE)
		pg.UIMgr.GetInstance():LoadingOff()
	end))
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, pg.UIMgr.GetInstance().UIMain)
end

return slot0

slot0 = class("TowerClimbingGameView", import("..BaseMiniGameView"))

slot0.getUIName = function (slot0)
	return "TowerClimbingUI"
end

slot0.GetMGData = function (slot0)
	return getProxy(MiniGameProxy):GetMiniGameData(slot0.contextData.miniGameId):clone()
end

slot0.GetMGHubData = function (slot0)
	return getProxy(MiniGameProxy):GetHubByGameId(slot0.contextData.miniGameId)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0:findTF("overview/back"), function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("overview/collection"), function ()
		slot0:emit(TowerClimbingMediator.ON_COLLECTION)
	end, SFX_PANEL)

	if LOCK_TOWERCLIMBING_AWARD then
		setActive(slot0.findTF(slot0, "overview/collection"), false)
	end
end

slot0.UpdateTip = function (slot0)
	TowerClimbingCollectionLayer.New().SetData(slot2, slot1)
	setActive(slot0.findTF(slot0, "overview/collection/tip"), _.any({
		1,
		2,
		3
	}, function (slot0)
		return slot0:GetAwardState(slot0) == 1
	end))
end

slot0.Start = function (slot0)
	slot0.controller = TowerClimbingController.New()

	slot0.controller.view:SetUI(slot0._go)
	slot0.controller.SetCallBack(slot3, slot1, slot2)
	slot0.controller:SetUp(slot0:PackData())
	slot0:UpdateTip()
end

slot0.OnSendMiniGameOPDone = function (slot0, slot1)
	if slot1.hubid == 9 and slot1.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and slot1.argList[1] == MiniGameDataCreator.TowerClimbingGameID and slot1.argList[2] == 1 then
		slot0:Start()
	elseif (slot1.hubid == 9 and slot1.cmd == MiniGameOPCommand.CMD_COMPLETE) or (slot1.hubid == 9 and slot1.cmd == MiniGameOPCommand.CMD_SPECIAL_GAME and (slot1.argList[2] == 3 or slot1.argList[2] == 4)) then
		slot0.controller:NetUpdateData(slot0:PackData())
		slot0:UpdateTip()
	end
end

slot0.GetTowerClimbingPageAndScore = function (slot0)
	slot1 = slot0[1] or {}

	for slot6 = #slot1 + 1, 3, 1 do
		table.insert(slot1, {
			value = 0,
			value2 = 0,
			key = slot6
		})
	end

	table.sort(slot1, function (slot0, slot1)
		return slot0.key < slot1.key
	end)

	slot3 = slot0.GetAwardScores()
	slot4 = 0
	slot5 = 1

	for slot9, slot10 in ipairs(slot1) do
		if slot10.value2 < slot3[slot10.key][#slot3[slot10.key]] or (slot9 == #slot1 and slot12 <= slot10.value2) then
			slot4 = slot10.value2
			slot5 = slot10.key

			break
		end
	end

	slot6 = {}
	slot7 = slot0[2] or {}

	for slot12 = #slot7 + 1, 3, 1 do
		table.insert(slot7, {
			value = 0,
			key = slot12
		})
	end

	table.sort(slot7, function (slot0, slot1)
		return slot0.key < slot1.key
	end)

	for slot12, slot13 in ipairs(slot7) do
		slot6[slot13.key] = slot13.value
	end

	return slot4, slot5, slot6
end

slot0.GetAwardScores = function ()
	return _.map(pg.mini_game[MiniGameDataCreator.TowerClimbingGameID].simple_config_data, function (slot0)
		return slot0[1]
	end)
end

slot0.PackData = function (slot0)
	slot8, slot10, slot8.mapScores = slot0.GetTowerClimbingPageAndScore(slot3)

	print(slot4, "-", slot5)

	return {
		shipId = 107031,
		npcName = "TowerClimbingManjuu",
		life = 3,
		screenWidth = slot0._tf.rect.width,
		screenHeight = slot0._tf.rect.height,
		higestscore = slot4,
		pageIndex = slot5,
		mapScores = slot6,
		awards = slot0.GetAwardScores()
	}
end

slot0.onBackPressed = function (slot0)
	if slot0.controller:onBackPressed() then
		return
	end

	slot0:emit(slot0.ON_BACK)
end

slot0.willExit = function (slot0)
	slot0.controller:Dispose()
end

return slot0

slot0 = class("AmusementParkScene2", import("..TemplateMV.BackHillTemplate"))
slot0.UIName = "AmusementParkUI2"
slot0.edge2area = {
	default = "map_middle"
}
slot0.Buildings = {
	[13.0] = "jiujiuchonglang",
	[15.0] = "huahuashijie",
	[16.0] = "jiujiupubu",
	[14.0] = "jiujiutiaoshui"
}

slot0.init = function (slot0)
	slot0.top = slot0:findTF("Top")
	slot0._map = slot0:findTF("map")

	for slot4 = 0, slot0._map.childCount - 1, 1 do
		slot0["map_" .. go(slot5).name] = slot0._map:GetChild(slot4)
	end

	slot0._shipTpl = slot0._map:Find("ship")
	slot0.containers = {
		slot0.map_middle
	}
	slot0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AmusementParkGraph2"))
	slot0._upper = slot0:findTF("upper")

	for slot4 = 0, slot0._upper.childCount - 1, 1 do
		slot0["upper_" .. go(slot5).name] = slot0._upper:GetChild(slot4)
	end

	slot0.gameCountTxt = slot0.top:Find("GameCount/text"):GetComponent(typeof(Text))
	slot0.materialTxt = slot0.top:Find("MaterialCount/text"):GetComponent(typeof(Text))

	if PLATFORM_CODE ~= PLATFORM_JP then
		setActive(slot0.upper_jinianchengbao, false)

		GetOrAddComponent(slot0.map_jinianchengbao, typeof(Button)).enabled = false
	end

	slot0:RegisterDataResponse()

	slot0.upgradePanel = BuildingUpgradPanel.New(slot0)

	slot0.upgradePanel:Load()
	slot0.upgradePanel.buffer:Hide()

	slot0.loader = ThirdAnniversaryAutoloader.New()
end

slot0.RegisterDataResponse = function (slot0)
	slot0.Respones = ResponsableTree.CreateShell({})

	slot0.Respones:SetRawData("view", slot0)

	for slot5, slot6 in ipairs(slot1) do
		slot0.Respones:AddRawListener({
			"view",
			slot6
		}, function (slot0, slot1)
			if not slot1 then
				return
			end

			slot0.loader:GetSprite("ui/AmusementParkUI2_atlas", "entrance_" .. slot0 .. slot1, slot0["map_" .. slot0])

			if not slot0["upper_" .. slot0] or IsNil(slot2:Find("Level")) then
				return
			end

			setText(slot2:Find("Level"), "LV." .. slot1)
		end)
	end

	table.insertto(slot2, slot1)

	for slot6, slot7 in ipairs(slot2) do
		slot0.Respones:AddRawListener({
			"view",
			slot7 .. "Tip"
		}, function (slot0, slot1)
			if not slot0["upper_" .. slot0] or IsNil(slot2:Find("Tip")) then
				return
			end

			setActive(slot2:Find("Tip"), slot1)
		end)
	end

	slot0.Respones.hubData = {}

	slot0.Respones.AddRawListener(slot3, {
		"view",
		"hubData"
	}, function (slot0, slot1)
		slot0.gameCountTxt.text = "X" .. slot1.count
	end, {
		strict = true
	})
	slot0.Respones.AddRawListener(slot3, {
		"view",
		"materialCount"
	}, function (slot0, slot1)
		slot0.materialTxt.text = slot1
	end)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.top:Find("Back"), function ()
		slot0:emit(slot1.ON_BACK)
	end)
	onButton(slot0, slot0.top:Find("Home"), function ()
		slot0:emit(slot1.ON_HOME)
	end)
	onButton(slot0, slot0.top:Find("Help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.activity_event_building.tip
		})
	end)
	onButton(slot0, slot0.top:Find("Invitation"), function ()
		if getProxy(ActivityProxy):getActivityById(ActivityConst.JP_CEREMONY_INVITATION_ID) and not slot0:isEnd() then
			slot0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = slot0.id
			})
		end
	end)

	for slot4, slot5 in pairs(slot0.Buildings) do
		slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, slot5, function ()
			slot0.upgradePanel:Set(slot0.activity, slot0.upgradePanel)
		end)
	end

	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "jiujiudalaotuan", function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 30)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "jinianchengbao", function ()
		slot0:emit(AmusementParkMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	slot0.BindItemSkinShop(slot0)
	slot0:BindItemBuildShip()
	slot0:InitStudents(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME) and slot1.id, 3, 4)
	slot0:UpdateView()
end

slot0.UpdateActivity = function (slot0, slot1)
	slot0.activity = slot1

	for slot5, slot6 in pairs(slot0.Buildings) do
		slot0.Respones[slot6] = slot1.data1KeyValueList[2][slot5] or 1
	end

	slot0.Respones.materialCount = slot1.data1KeyValueList[1][next(slot1.data1KeyValueList[1])] or 0

	slot0:UpdateView()

	if slot0.upgradePanel and slot0.upgradePanel:IsShowing() then
		slot0.upgradePanel:Set(slot1)
	end
end

slot0.UpdateView = function (slot0)
	slot1, slot2 = nil
	slot3 = getProxy(ActivityProxy)

	for slot7, slot8 in pairs(slot0.Buildings) do
		slot0.Respones[slot8 .. "Tip"] = slot0:UpdateBuildingTip(slot7)
	end

	slot0.Respones.jiujiudalaotuanTip = getProxy(MiniGameProxy).GetHubByHubId(slot5, slot3:getActivityByType(ActivityConst.ACTIVITY_TYPE_MINIGAME):getConfig("config_id")).count > 0

	slot0:UpdateHubData(slot6)
end

slot0.onBackPressed = function (slot0)
	if slot0.upgradePanel and slot0.upgradePanel:IsShowing() then
		slot0.upgradePanel:Hide()

		return
	end

	slot0.super.onBackPressed(slot0)
end

slot0.UpdateHubData = function (slot0, slot1)
	slot0.Respones.hubData.count = slot1.count
	slot0.Respones.hubData.usedtime = slot1.usedtime
	slot0.Respones.hubData.id = slot1.id

	slot0.Respones:PropertyChange("hubData")
end

slot0.willExit = function (slot0)
	slot0:clearStudents()
	slot0.super.willExit(slot0)
end

return slot0

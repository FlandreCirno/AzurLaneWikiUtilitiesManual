slot0 = class("AmusementParkScene", import("..TemplateMV.BackHillTemplate"))
slot0.UIName = "AmusementParkUI"
slot0.edge2area = {
	default = "map_middle",
	1_1 = "map_top"
}

slot0.init = function (slot0)
	slot0.top = slot0:findTF("Top")
	slot0._map = slot0:findTF("map")

	for slot4 = 0, slot0._map.childCount - 1, 1 do
		slot0["map_" .. go(slot5).name] = slot0._map:GetChild(slot4)
	end

	slot0._shipTpl = slot0._map:Find("ship")
	slot0.containers = {
		slot0.map_middle,
		slot0.map_top
	}
	slot0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.AmusementParkGraph"))
	slot0._upper = slot0:findTF("upper")

	for slot4 = 0, slot0._upper.childCount - 1, 1 do
		slot0["upper_" .. go(slot5).name] = slot0._upper:GetChild(slot4)
	end

	slot0.gameCountTxt = slot0.top:Find("GameCount/text"):GetComponent(typeof(Text))
	slot0.materialTxt = slot0.top:Find("MaterialCount/text"):GetComponent(typeof(Text))

	setActive(slot0.map_huiyichengbao, PLATFORM_CODE == PLATFORM_CH)
	setActive(slot0.upper_huiyichengbao, PLATFORM_CODE == PLATFORM_CH)
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

			slot0.loader:GetSprite("ui/AmusementParkUI_atlas", "entrance_" .. slot0 .. slot1, slot0["map_" .. slot0])

			if not slot0["upper_" .. slot0] or IsNil(slot2:Find("Level")) then
				return
			end

			setText(slot2:Find("Level"), "LV." .. slot1)
		end)
	end

	slot2 = {
		"guoshanche",
		"haidaochuan",
		"xuanzhuanmuma",
		"tiaolouji",
		"dangaobaoweizhan",
		"jiujiuduihuanwu"
	}

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
			helps = pg.gametip.amusementpark_help.tip
		})
	end)
	onButton(slot0, slot0.top:Find("Invitation"), function ()
		if getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CLIENT_DISPLAY) and not slot0:isEnd() then
			slot0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.ACTIVITY, {
				id = slot0.id
			})
		end
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "jiujiuduihuanwu", function ()
		slot0:emit(AmusementParkMediator.GO_SUBLAYER, Context.New({
			mediator = AmusementParkShopMediator,
			viewComponent = AmusementParkShopPage
		}))
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "xuanzhuanmuma", function ()
		slot0.upgradePanel:Set(slot0.activity, 9)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "guoshanche", function ()
		slot0.upgradePanel:Set(slot0.activity, 10)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "tiaolouji", function ()
		slot0.upgradePanel:Set(slot0.activity, 11)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "haidaochuan", function ()
		slot0.upgradePanel:Set(slot0.activity, 12)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "dangaobaoweizhan", function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 23)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "huiyichengbao", function ()
		slot0:emit(AmusementParkMediator.GO_SCENE, SCENE.SUMMARY)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "xianshijianzao", function ()
		slot0:emit(AmusementParkMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "huanzhuangshandian", function ()
		slot0:emit(AmusementParkMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	slot0:InitStudents(getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and slot1.id, 2, 3)
	slot0:UpdateView()
	slot0.loader:LoadPrefab("ui/houshan_caidai", "", function (slot0)
		setParent(slot0, slot0._map)
	end)
end

slot0.UpdateActivity = function (slot0, slot1)
	slot0.activity = slot1
	slot0.Respones.xuanzhuanmuma = slot1.data1KeyValueList[2][9] or 1
	slot0.Respones.guoshanche = slot1.data1KeyValueList[2][10] or 1
	slot0.Respones.tiaolouji = slot1.data1KeyValueList[2][11] or 1
	slot0.Respones.haidaochuan = slot1.data1KeyValueList[2][12] or 1
	slot0.Respones.materialCount = slot1.data1KeyValueList[1][next(slot1.data1KeyValueList[1])] or 0

	slot0:UpdateView()

	if slot0.upgradePanel and slot0.upgradePanel:IsShowing() then
		slot0.upgradePanel:Set(slot1)
	end
end

slot0.UpdateView = function (slot0)
	slot1, slot2 = nil
	slot0.Respones.xuanzhuanmumaTip = slot4(9)
	slot0.Respones.guoshancheTip = slot4(10)
	slot0.Respones.tiaoloujiTip = slot4(11)
	slot0.Respones.haidaochuanTip = slot4(12)
	slot0.Respones.dangaobaoweizhanTip = getProxy(MiniGameProxy).GetHubByHubId(slot6, getProxy(ActivityProxy).getActivityByType(slot3, ActivityConst.ACTIVITY_TYPE_MINIGAME):getConfig("config_id")).count > 0

	slot0:UpdateHubData(slot7)

	slot0.Respones.jiujiuduihuanwuTip = AmusementParkShopPage.GetActivityShopTip()
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

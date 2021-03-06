slot0 = class("MusicFestivalScene2", import("..TemplateMV.BackHillTemplate"))

slot0.getUIName = function (slot0)
	return "MusicFestivalUI2"
end

slot0.edge2area = {
	default = "_middle"
}

slot0.init = function (slot0)
	slot0.top = slot0:findTF("top")
	slot0._map = slot0:findTF("map")

	for slot4 = 0, slot0._map.childCount - 1, 1 do
		slot0["map_" .. go(slot5).name] = slot0._map:GetChild(slot4)
	end

	slot0._stageShip = slot0._map:Find("stageship")
	slot0._shipTpl = slot0._map:Find("ship")
	slot0._upper = slot0:findTF("upper")

	for slot4 = 0, slot0._upper.childCount - 1, 1 do
		slot0["upper_" .. go(slot5).name] = slot0._upper:GetChild(slot4)
	end

	slot0.modelTip = slot0.upper_model:Find("tip")

	setActive(slot0.modelTip, false)

	slot0._middle = slot0._map:Find("middle")
	slot0.containers = {
		slot0._middle
	}
	slot0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.MusicFestivalGraph2"))
	slot0._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = (slot0._tf:GetComponentInParent(typeof(UnityEngine.Canvas)) and slot1.sortingOrder) - 2
	slot3 = GetComponent(slot0._map, "ItemList")

	for slot7 = 1, 3, 1 do
		setParent(tf(Instantiate(slot8)), slot0._map)
	end

	slot0.loader = ThirdAnniversaryAutoloader.New()
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0:findTF("top/return_btn"), function ()
		slot0:emit(slot1.ON_BACK)
	end)
	onButton(slot0, slot0:findTF("top/return_main_btn"), function ()
		slot0:emit(slot1.ON_HOME)
	end)
	onButton(slot0, slot0:findTF("top/help_btn"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_main.tip
		})
	end)
	slot0:InitStudents(getProxy(ActivityProxy).getActivityById(slot1, ActivityConst.MUSIC_FESTIVAL_ID_2) and slot1.id, 3, 4)
	onButton(slot0, slot0.upper_model, function ()
		slot0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = slot1.id
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "jichangwutai", function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 16)
	end)

	slot2 = getProxy(ActivityProxy).getActivityByType(slot2, ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	slot0:InitFacilityCross(slot0._map, slot0._upper, "leijipt", function ()
		slot0:emit(MusicFestivalMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = slot1.id
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "bujishangdian", function ()
		slot0:emit(MusicFestivalMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "huangzhuangshangdian", function ()
		slot0:emit(MusicFestivalMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "xianshijianzao", function ()
		slot0:emit(MusicFestivalMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "jinianzhang", function ()
		slot0:emit(MusicFestivalMediator.GO_SUBLAYER, Context.New({
			mediator = IdolMedalCollectionMediator,
			viewComponent = IdolMedalCollectionView2
		}))
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "tebiezuozhan", function ()
		slot0, slot1 = getProxy(ChapterProxy):getLastMapForActivity()
		slot2 = slot0 and Map.StaticIsMapBindedActivityActive(slot0) and not Map.StaticIsMapRemaster(slot0)

		if not slot2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			slot0:emit(MusicFestivalMediator.GO_SCENE, SCENE.LEVEL, {
				chapterId = slot1,
				mapIdx = slot0
			})
		end
	end)
	slot0.updateStageShip(slot0)
	slot0:UpdateView()
end

slot0.UpdateView = function (slot0)
	slot2 = nil

	setActive(slot6, getProxy(MiniGameProxy).GetHubByHubId(slot4, getProxy(ActivityProxy).getActivityById(slot1, ActivityConst.MUSIC_FESTIVAL_ID_2):getConfig("config_id")).count > 0)
	setActive(slot0.modelTip, slot5:getConfig("reward_need") <= slot5.usedtime and slot5.ultimate == 0)
	setActive(slot8, slot5.getConfig("reward_need") <= slot5.usedtime and slot5.ultimate == 0)
	setActive(slot0.upper_jinianzhang:Find("tip"), IdolMedalCollectionMediator.isHaveActivableMedal())
end

slot0.getStageShip = function (slot0)
	slot1 = getProxy(ActivityProxy)

	if not getProxy(ActivityProxy):getActivityById(ActivityConst.MUSIC_FESTIVAL_ID_2) then
		return
	end

	if slot2:getConfig("config_client") and slot3.stage_on_ship then
		return slot4[math.random(1, slot5)], slot4.action[1]
	end
end

slot0.updateStageShip = function (slot0)
	slot1, slot2 = slot0:getStageShip()

	if not slot1 then
		return
	end

	slot0.loader:GetSpine(slot1, function (slot0)
		slot0.transform.localScale = Vector3(0.63, 0.63, 1)
		slot0.transform.localPosition = Vector3.zero

		slot0.transform:SetParent(slot0._stageShip, false)
		slot0.transform:SetSiblingIndex(1)
		setActive(slot0._stageShip, true)

		slot1 = slot0:GetComponent(typeof(SpineAnimUI))

		slot1:SetAction(slot1, 0)
	end, slot0._stageShip)
end

slot0.InitStudents = function (slot0, slot1, slot2, slot3)
	slot4 = slot0.getStudents(slot1, slot2, slot3)
	slot5 = {}

	for slot9, slot10 in pairs(slot0.graphPath.points) do
		table.insert(slot5, slot10)
	end

	slot6 = #slot5
	slot0.academyStudents = {}

	for slot10, slot11 in pairs(slot4) do
		if not slot0.academyStudents[slot10] then
			cloneTplTo(slot0._shipTpl, slot0._map).gameObject.name = slot10
			slot14 = SummerFeastNavigationAgent.New(cloneTplTo(slot0._shipTpl, slot0._map).gameObject)

			slot14:attach()
			slot14:setPathFinder(slot0.graphPath)
			slot14:setCurrentIndex(slot0.ChooseRandomPos(slot5, slot6 - 1) and slot13.id)
			slot14:SetOnTransEdge(function (slot0, slot1, slot2)
				slot0._tf:SetParent(slot0[slot0.edge2area[slot1 .. "_" .. math.max(slot1, slot2)] or slot0.edge2area.default])
			end)
			slot14.updateStudent(slot14, slot11)

			slot0.academyStudents[slot10] = slot14
		end
	end

	if #slot4 > 0 then
		slot0.sortTimer = Timer.New(function ()
			slot0:sortStudents()
		end, 0.2, -1)

		slot0.sortTimer.Start(slot7)
		slot0.sortTimer.func()
	end
end

slot0.getStudents = function (slot0, slot1, slot2)
	slot3 = {}

	if not getProxy(ActivityProxy):getActivityById(slot0) then
		return slot3
	end

	if slot5:getConfig("config_client") and slot6.stage_off_ship then
		slot7 = 0
		slot8 = #Clone(slot6)

		while slot7 < slot1 * slot2 and slot8 > 0 do
			table.insert(slot3, slot6[math.random(1, slot8)])

			slot6[math.random(1, slot8)] = slot6[slot8]
			slot8 = slot8 - 1
			slot7 = slot7 + math.random(slot1, slot2)
		end
	end

	return slot3
end

slot0.willExit = function (slot0)
	slot0:clearStudents()
	slot0.super.willExit(slot0)
end

return slot0

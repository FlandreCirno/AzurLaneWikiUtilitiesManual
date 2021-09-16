slot0 = class("DOALinkIslandScene", import("..TemplateMV.BackHillTemplate"))

slot0.getUIName = function (slot0)
	return "DOALinkIslandUI"
end

slot0.edge2area = {
	default = "map_middle",
	2_2 = "map_bridge"
}

slot0.init = function (slot0)
	slot0.top = slot0:findTF("top")
	slot0._map = slot0:findTF("map")

	for slot4 = 0, slot0._map.childCount - 1, 1 do
		slot0["map_" .. go(slot5).name] = slot0._map:GetChild(slot4)
	end

	slot0._shipTpl = slot0._map:Find("ship")
	slot0._upper = slot0:findTF("upper")

	for slot4 = 0, slot0._upper.childCount - 1, 1 do
		slot0["upper_" .. go(slot5).name] = slot0._upper:GetChild(slot4)
	end

	slot0.containers = {
		slot0.map_middle
	}
	slot0.graphPath = GraphPath.New(import("GameCfg.BackHillGraphs.DOAIslandGraph"))
	slot0._map:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = (slot0._tf:GetComponentInParent(typeof(UnityEngine.Canvas)) and slot1.sortingOrder) - 3
	slot0.map_tebiezuozhan:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = (slot0._tf.GetComponentInParent(typeof(UnityEngine.Canvas)) and slot1.sortingOrder) - 1
	slot0.map_bridge:GetComponent(typeof(UnityEngine.Canvas)).sortingOrder = (slot0._tf.GetComponentInParent(typeof(UnityEngine.Canvas)) and slot1.sortingOrder) - 1
	slot3 = GetComponent(slot0._map, "ItemList")

	for slot7 = 1, 1, 1 do
		pg.ViewUtils.SetSortingOrder(slot9, slot2 - 2)
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
			helps = pg.gametip.doa_main.tip
		})
	end)
	slot0:InitStudents(getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and slot1.id, 2, 3)
	slot0:InitFacilityCross(slot0._map, slot0._upper, "shatanpaiqiu", function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 17)
	end)

	slot2 = getProxy(ActivityProxy).getActivityByType(slot2, ActivityConst.ACTIVITY_TYPE_PT_BUFF)

	slot0:InitFacilityCross(slot0._map, slot0._upper, "daoyvjianshe", function ()
		slot0(slot1, DOALinkIslandMediator.GO_SCENE, SCENE.ACTIVITY, {
			id = slot0.emit and slot1.id
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "bujishangdian", function ()
		slot0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "huanzhuangshangdian", function ()
		slot0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.SKINSHOP)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "xianshijianzao", function ()
		slot0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.GETBOAT, {
			projectName = "new",
			page = 1
		})
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "jinianzhang", function ()
		slot0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.DOA_MEDAL_COLLECTION_SCENE)
	end)
	slot0.InitFacilityCross(slot0, slot0._map, slot0._upper, "tebiezuozhan", function ()
		slot1, slot2 = getProxy(ChapterProxy).getLastMapForActivity(slot0)

		if not slot1 or not slot0:getMapById(slot1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			slot0:emit(DOALinkIslandMediator.GO_SCENE, SCENE.LEVEL, {
				chapterId = slot2,
				mapIdx = slot1
			})
		end
	end)
	slot0.UpdateView(slot0)
end

slot0.UpdateView = function (slot0)
	slot2 = nil

	setActive(slot6, (getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and getProxy(MiniGameProxy):GetHubByHubId(slot3:getConfig("config_id")) and getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and getProxy(MiniGameProxy).GetHubByHubId(slot3.getConfig("config_id")).count > 0) or (getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and getProxy(MiniGameProxy).GetHubByHubId(slot3.getConfig("config_id")):getConfig("reward_need") <= getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and getProxy(MiniGameProxy).GetHubByHubId(slot3.getConfig("config_id")).usedtime and getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and getProxy(MiniGameProxy).GetHubByHubId(slot3.getConfig("config_id")).ultimate == 0))
	slot0.loader:GetSprite("ui/DOALinkIslandUI_atlas", tostring(getProxy(ActivityProxy).getActivityByType(slot1, ActivityConst.ACTIVITY_TYPE_MINIGAME) and getProxy(MiniGameProxy).GetHubByHubId(slot3.getConfig("config_id")).usedtime or 0), slot0.map_shatanpaiqiu:Find("Digit"), true)
	setActive(slot0.upper_daoyvjianshe:Find("tip"), slot1:getActivityByType(ActivityConst.ACTIVITY_TYPE_PT_BUFF) and slot0.loader.GetSprite:readyToAchieve())
	setActive(slot0.upper_jinianzhang:Find("tip"), DoaMedalCollectionView.isHaveActivableMedal())
end

slot0.willExit = function (slot0)
	slot0:clearStudents()
	slot0.super.willExit(slot0)
end

return slot0

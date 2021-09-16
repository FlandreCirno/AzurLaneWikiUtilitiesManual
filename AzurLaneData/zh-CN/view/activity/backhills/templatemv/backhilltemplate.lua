slot0 = class("BackHillTemplate", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return slot0.UIName
end

slot0.init = function (slot0)
	slot0.loader = AutoLoader.New()
end

slot0.willExit = function (slot0)
	slot0.loader:Clear()
end

slot0.InitFacility = function (slot0, slot1, slot2)
	onButton(slot0, slot1, slot2)
	onButton(slot0, slot1:Find("button"), slot2)
end

slot0.InitFacilityCross = function (slot0, slot1, slot2, slot3, slot4)
	onButton(slot0, slot1:Find(slot3), slot4, SFX_PANEL)
	onButton(slot0, slot2:Find(slot3), slot4, SFX_PANEL)
end

slot0.getStudents = function (slot0, slot1, slot2)
	slot3 = {}

	if not getProxy(ActivityProxy):getActivityById(slot0) then
		return slot3
	end

	if slot5:getConfig("config_client") and slot6.ships then
		slot7 = math.random(slot1, slot2)
		slot8 = #Clone(slot6)

		while slot7 > 0 and slot8 > 0 do
			table.insert(slot3, slot6[math.random(1, slot8)])

			slot6[math.random(1, slot8)] = slot6[slot8]
			slot8 = slot8 - 1
			slot7 = slot7 - 1
		end
	end

	return slot3
end

slot0.InitStudents = function (slot0, slot1, slot2, slot3)
	slot4 = slot0.getStudents(slot1, slot2, slot3)
	slot5 = {}

	for slot9, slot10 in pairs(slot0.graphPath.points) do
		if not slot10.outRandom then
			table.insert(slot5, slot10)
		end
	end

	slot6 = #slot5
	slot0.academyStudents = {}

	for slot10, slot11 in pairs(slot4) do
		if not slot0.academyStudents[slot10] then
			cloneTplTo(slot0._shipTpl, slot0._map).gameObject.name = slot10
			slot14 = SummerFeastNavigationAgent.New(cloneTplTo(slot0._shipTpl, slot0._map).gameObject)

			slot14:attach()
			slot14:setPathFinder(slot0.graphPath)
			slot14:setCurrentIndex(slot0.ChooseRandomPos(slot5, (slot6 - 2) % #slot5 + 1) and slot13.id)
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

slot0.ChooseRandomPos = function (slot0, slot1)
	if not math.random(1, slot1) then
		return nil
	end

	pg.Tool.Swap(slot0, slot2, slot1)

	return slot0[slot1]
end

slot0.sortStudents = function (slot0)
	for slot5, slot6 in pairs(slot1) do
		if slot6.childCount > 1 then
			slot7 = {}

			for slot11 = 1, slot6.childCount, 1 do
				table.insert(slot7, {
					tf = slot6:GetChild(slot11 - 1),
					index = slot11
				})
			end

			table.sort(slot7, function (slot0, slot1)
				if math.abs(slot2) < 1 then
					return slot0.index < slot1.index
				else
					return slot2 > 0
				end
			end)

			for slot11, slot12 in ipairs(slot7) do
				slot12.tf:SetSiblingIndex(slot11 - 1)
			end
		end
	end
end

slot0.clearStudents = function (slot0)
	if slot0.sortTimer then
		slot0.sortTimer:Stop()

		slot0.sortTimer = nil
	end

	if slot0.academyStudents then
		for slot4, slot5 in pairs(slot0.academyStudents) do
			slot5:detach()
			Destroy(slot5._go)
		end

		table.clear(slot0.academyStudents)
	end
end

slot0.AutoFitScreen = function (slot0)
	slot5 = nil

	setLocalScale(slot0._map, {
		x = (1.7777777777777777 > Screen.width / Screen.height or math.clamp((1080 * slot1) / slot0._map.rect.width, 1, 2)) and math.clamp(1920 / slot1 / slot0._map.rect.height, 1, 2),
		y = (1.7777777777777777 > Screen.width / Screen.height or math.clamp((1080 * slot1) / slot0._map.rect.width, 1, 2)) and math.clamp(1920 / slot1 / slot0._map.rect.height, 1, 2),
		z = (1.7777777777777777 > Screen.width / Screen.height or math.clamp((1080 * slot1) / slot0._map.rect.width, 1, 2)) and math.clamp(1920 / slot1 / slot0._map.rect.height, 1, 2)
	})
	setLocalScale(slot0._upper, {
		x = (1.7777777777777777 > Screen.width / Screen.height or math.clamp((1080 * slot1) / slot0._map.rect.width, 1, 2)) and math.clamp(1920 / slot1 / slot0._map.rect.height, 1, 2),
		y = (1.7777777777777777 > Screen.width / Screen.height or math.clamp((1080 * slot1) / slot0._map.rect.width, 1, 2)) and math.clamp(1920 / slot1 / slot0._map.rect.height, 1, 2),
		z = (1.7777777777777777 > Screen.width / Screen.height or math.clamp((1080 * slot1) / slot0._map.rect.width, 1, 2)) and math.clamp(1920 / slot1 / slot0._map.rect.height, 1, 2)
	})
end

slot0.IsMiniActNeedTip = function (slot0)
	if not getProxy(ActivityProxy):getActivityById(slot0) or slot1:isEnd() then
		return
	end

	return (slot1 and getProxy(MiniGameProxy):GetHubByHubId(slot1:getConfig("config_id")) and slot1 and getProxy(MiniGameProxy).GetHubByHubId(slot1.getConfig("config_id")).count > 0) or (slot1 and getProxy(MiniGameProxy).GetHubByHubId(slot1.getConfig("config_id")):getConfig("reward_need") <= slot1 and getProxy(MiniGameProxy).GetHubByHubId(slot1.getConfig("config_id")).usedtime and slot1 and getProxy(MiniGameProxy).GetHubByHubId(slot1.getConfig("config_id")).ultimate == 0)
end

slot0.Clone2Full = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = slot1:GetChild(0)

	for slot9 = 0, slot1.childCount - 1, 1 do
		table.insert(slot3, slot1:GetChild(slot9))
	end

	for slot9 = slot5, slot2 - 1, 1 do
		table.insert(slot3, tf(cloneTplTo(slot4, slot1)))
	end

	return slot3
end

slot0.UpdateActivity = function (slot0, slot1)
	return
end

slot0.BindItemActivityShop = function (slot0)
	slot0:InitFacilityCross(slot0._map, slot0._upper, "bujishangdian", function ()
		slot0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SHOP, {
			warp = NewShopsScene.TYPE_ACTIVITY
		})
	end)
end

slot0.BindItemSkinShop = function (slot0)
	slot0:InitFacilityCross(slot0._map, slot0._upper, "huanzhuangshangdian", function ()
		slot0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.SKINSHOP)
	end)
end

slot0.BindItemBuildShip = function (slot0, slot1)
	slot0:InitFacilityCross(slot0._map, slot0._upper, "xianshijianzao", function ()
		slot0.emit(slot1, BackHillMediatorTemplate.GO_SCENE, SCENE.GETBOAT, slot0.emit or {
			projectName = "new",
			page = 1
		})
	end)
end

slot0.BindItemBattle = function (slot0)
	slot0:InitFacilityCross(slot0._map, slot0._upper, "tebiezuozhan", function ()
		slot1, slot2 = getProxy(ChapterProxy).getLastMapForActivity(slot0)

		if not slot1 or not slot0:getMapById(slot1):isUnlock() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		else
			slot0:emit(BackHillMediatorTemplate.GO_SCENE, SCENE.LEVEL, {
				chapterId = slot2,
				mapIdx = slot1
			})
		end
	end)
end

slot0.UpdateBuildingTip = function (slot0, slot1)
	if not slot0.activity then
		return
	end

	slot2 = slot0.activity.data1KeyValueList[2][slot1] or 1

	if not pg.activity_event_building[slot1] or slot2 >= #slot3.buff then
		return
	end

	return slot3.material[slot2] <= (slot0.activity.data1KeyValueList[1][slot3.material_id] or 0)
end

return slot0

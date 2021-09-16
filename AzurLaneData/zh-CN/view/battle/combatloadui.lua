slot0 = class("CombatLoadUI", import("..base.BaseUI"))
slot0._loadObs = nil
slot0.LOADING_ANIMA_DISTANCE = 1820

slot0.getUIName = function (slot0)
	return "CombatLoadUI"
end

slot0.init = function (slot0)
	slot1 = slot0:findTF("loading")
	slot0._loadingProgress = slot1:Find("loading_bar"):GetComponent(typeof(Slider))
	slot0._loadingProgress.value = 0
	slot0._loadingText = slot1:Find("loading_label/percent"):GetComponent(typeof(Text))
	slot0._loadingAnima = slot1:Find("loading_anima")
	slot0._loadingAnimaPosY = slot0._loadingAnima.anchoredPosition.y
	slot0._finishAnima = slot1:Find("done_anima")

	SetActive(slot0._loadingAnima, true)
	SetActive(slot0._finishAnima, false)
	slot0._finishAnima:GetComponent("DftAniEvent").SetEndEvent(slot2, function (slot0)
		slot0:emit(CombatLoadMediator.FINISH, slot0._loadObs)
	end)
	SetActive(slot0._tf.Find(slot3, "bg"), slot5 ~= 1)
	SetActive(slot0._tf:Find("bg2"), slot5 == 1)
	setImageSprite((PlayerPrefs.GetInt("bgFitMode", 0) == 1 and slot0._tf.Find("bg2")) or slot0._tf.Find(slot3, "bg"), LoadSprite(SetActive))

	slot0._tipsText = slot1:Find("tipsText"):GetComponent(typeof(Text))
end

slot0.didEnter = function (slot0)
	slot0:Preload()
end

slot0.onBackPressed = function (slot0)
	return
end

slot0.Preload = function (slot0)
	PoolMgr.GetInstance():DestroyAllSprite()

	slot0._loadObs = {}
	slot0._toLoad = {}

	ys.Battle.BattleFXPool.GetInstance():Init()
	ys.Battle.BattleResourceManager.GetInstance().Init(slot1)

	slot2 = getProxy(BayProxy)

	if slot0.contextData.system == SYSTEM_DEBUG then
		slot3 = {}

		for slot10, slot11 in ipairs(slot6) do
			slot3[slot11.configId] = slot11
		end

		for slot10, slot11 in pairs(slot3) do
			if type(slot10) == "number" then
				slot1:AddPreloadCV(slot11.skinId)
				slot1:AddPreloadResource(slot1.GetShipResource(slot10, slot11.skinId, true))

				slot12 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(slot10)

				for slot16, slot17 in ipairs(slot11:getActiveEquipments()) do
					if slot16 <= Ship.WEAPON_COUNT then
						slot18, slot19 = nil
						slot20 = 0

						if not slot17 then
							slot18 = slot12.default_equip_list[slot16]
						else
							slot18 = slot17.configId
							slot20 = slot17.skinId
						end

						for slot25, slot26 in ipairs(slot21) do
							slot1:AddPreloadResource(slot1.GetWeaponResource(slot26, slot20))
						end
					elseif slot17 then
						slot1:AddPreloadResource(slot1.GetEquipResource(slot17.configId, slot17.skinId, slot0.contextData.system))
					end
				end

				for slot16, slot17 in ipairs(slot12.depth_charge_list) do
					for slot22, slot23 in ipairs(slot18) do
						slot1:AddPreloadResource(slot1.GetWeaponResource(slot23))
					end
				end

				for slot16, slot17 in ipairs(slot12.fix_equip_list) do
					for slot22, slot23 in ipairs(slot18) do
						slot1:AddPreloadResource(slot1.GetWeaponResource(slot23))
					end
				end

				for slot17, slot18 in pairs(slot13) do
					slot1:AddPreloadResource(slot18)
				end
			end
		end

		for slot11, slot12 in ipairs(slot7) do
			slot1:AddPreloadResource(slot1.GetAircraftResource(slot12, {}))
		end
	else
		slot3 = {}
		slot4 = {}

		if slot0.contextData.system == SYSTEM_SCENARIO then
			for slot12, slot13 in ipairs(slot8) do
				table.insert(slot3, slot13)
			end

			slot12, slot12 = slot6:getFleetBattleBuffs(slot7)

			slot0.addCommanderBuffRes(slot10)
			slot0.addChapterBuffRes(slot9)
			slot0.addChapterAuraRes(slot11)

			slot13 = {}

			for slot17, slot18 in pairs(slot12) do
				for slot22, slot23 in ipairs(slot18) do
					table.insert(slot13, slot23)
				end
			end

			slot0.addChapterAuraRes(slot13)

			slot14, slot15 = slot5.getSubAidFlag(slot6)

			if slot14 == true or slot14 > 0 then
				for slot20, slot21 in ipairs(slot16) do
					table.insert(slot3, slot21)
				end

				slot20, slot20 = slot6:getFleetBattleBuffs(slot15)

				slot0.addCommanderBuffRes(slot18)
				slot0.addChapterBuffRes(slot17)
			end
		elseif slot0.contextData.system == SYSTEM_HP_SHARE_ACT_BOSS or slot0.contextData.system == SYSTEM_ACT_BOSS or slot0.contextData.system == SYSTEM_BOSS_EXPERIMENT then
			if getProxy(FleetProxy).getActivityFleets(slot5)[slot0.contextData.actId][slot0.contextData.mainFleetId] then
				for slot12, slot13 in ipairs(slot8) do
					table.insert(slot3, slot2:getShipById(slot13))
				end

				slot0.addCommanderBuffRes(slot7:buildBattleBuffList())
			end

			if slot6[slot0.contextData.mainFleetId + 10] then
				for slot13, slot14 in ipairs(slot9) do
					table.insert(slot3, slot2:getShipById(slot14))
				end

				slot0.addCommanderBuffRes(slot8:buildBattleBuffList())
			end
		elseif slot0.contextData.system == SYSTEM_GUILD then
			for slot13, slot14 in ipairs(slot9) do
				if slot14 and slot14.ship then
					table.insert(slot3, slot14.ship)
				end
			end

			slot0.addCommanderBuffRes(slot8:BuildBattleBuffList())

			for slot15, slot16 in ipairs(slot11) do
				if slot16 and slot16.ship then
					table.insert(slot3, slot16.ship)
				end
			end

			slot0.addCommanderBuffRes(slot10:BuildBattleBuffList())
		elseif slot0.contextData.system == SYSTEM_CHALLENGE then
			ships = getProxy(ChallengeProxy).getUserChallengeInfo(slot5, slot0.contextData.mode).getRegularFleet(slot6).getShips(slot7, false)

			for slot11, slot12 in ipairs(ships) do
				table.insert(slot3, slot12)
			end

			slot0.addCommanderBuffRes(slot7:buildBattleBuffList())

			ships = slot6:getSubmarineFleet().getShips(slot7, false)

			for slot11, slot12 in ipairs(ships) do
				table.insert(slot3, slot12)
			end

			slot0.addCommanderBuffRes(slot7:buildBattleBuffList())
		elseif slot0.contextData.system == SYSTEM_WORLD_BOSS then
			for slot12, slot13 in ipairs(slot8) do
				table.insert(slot3, slot13)
			end

			if slot6:GetBossById(slot0.contextData.bossId) and slot9:IsSelf() then
				slot10, slot11, slot12 = slot6.GetSupportValue()

				if slot10 then
					slot0.addChapterAuraRes({
						{
							level = 1,
							id = slot12
						}
					})
				end
			end
		elseif slot0.contextData.system == SYSTEM_WORLD then
			for slot11, slot12 in ipairs(nowWorld.GetActiveMap(slot5).GetFleet(slot6).GetShipVOs(slot7, true)) do
				table.insert(slot3, slot12)
			end

			slot11, slot11 = slot6:getFleetBattleBuffs(slot7)

			slot0.addCommanderBuffRes(slot9)
			slot0.addChapterBuffRes(slot8)
			slot0.addChapterAuraRes(slot10)

			slot12 = {}

			for slot16, slot17 in pairs(slot11) do
				for slot21, slot22 in ipairs(slot17) do
					table.insert(slot12, slot22)
				end
			end

			slot0.addChapterAuraRes(slot12)

			if slot5:GetSubAidFlag() == true then
				for slot19, slot20 in ipairs(slot15) do
					table.insert(slot3, slot20)
				end

				slot19, slot19 = slot6:getFleetBattleBuffs(slot14)

				slot0.addCommanderBuffRes(slot17)
				slot0.addChapterBuffRes(slot16)
			end

			slot15 = slot6:GetCell(slot7.row, slot7.column).GetStageEnemy(slot14)

			slot0.addChapterBuffRes(table.mergeArray(slot15:GetBattleLuaBuffs(), slot6:GetBattleLuaBuffs(WorldMap.FactionEnemy, slot15)))
		elseif slot0.contextData.mainFleetId then
			for slot11, slot12 in ipairs(slot7) do
				table.insert(slot3, slot12)
			end
		end

		if slot0.contextData.rivalId then
			for slot11, slot12 in ipairs(slot7) do
				table.insert(slot3, slot12)
			end
		end

		if slot0.contextData.prefabFleet then
			slot6 = slot0.contextData.prefabFleet.vanguard_unitList
			slot7 = slot0.contextData.prefabFleet.submarine_unitList

			if slot0.contextData.prefabFleet.main_unitList then
				for slot11, slot12 in ipairs(slot5) do
					slot13 = {
						configId = slot12.configId,
						equipments = {},
						skinId = slot12.skinId,
						buffs = slot12.skills
					}

					for slot19 = 1, math.max(#slot12.equipment, #ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(slot12.configId).default_equip_list), 1 do
						slot13.equipments[slot19] = slot12.equipment[slot19] or false
					end

					slot13.getActiveEquipments = function (slot0)
						return slot0.equipments
					end

					table.insert(slot3, slot13)
				end
			end

			if slot6 then
				for slot11, slot12 in ipairs(slot6) do
					slot13 = {
						configId = slot12.configId,
						equipments = {},
						skinId = slot12.skinId,
						buffs = slot12.skills
					}

					for slot19 = 1, math.max(#slot12.equipment, #ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(slot12.configId).default_equip_list), 1 do
						slot13.equipments[slot19] = slot12.equipment[slot19] or false
					end

					slot13.getActiveEquipments = function (slot0)
						return slot0.equipments
					end

					table.insert(slot3, slot13)
				end
			end

			if slot7 then
				for slot11, slot12 in ipairs(slot7) do
					slot13 = {
						configId = slot12.configId,
						equipments = {},
						skinId = slot12.skinId,
						buffs = slot12.skills
					}

					for slot19 = 1, math.max(#slot12.equipment, #ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(slot12.configId).default_equip_list), 1 do
						slot13.equipments[slot19] = slot12.equipment[slot19] or false
					end

					slot13.getActiveEquipments = function (slot0)
						return slot0.equipments
					end

					table.insert(slot3, slot13)
				end
			end
		end

		for slot8, slot9 in ipairs(slot3) do
			slot1:AddPreloadCV(slot9.skinId)
			slot1:AddPreloadResource(slot1.GetShipResource(slot9.configId, slot9.skinId, true))

			slot10 = ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(slot9.configId)

			for slot14, slot15 in ipairs(slot9:getActiveEquipments()) do
				if slot14 <= Ship.WEAPON_COUNT then
					slot16, slot17 = nil
					slot18 = 0

					if not slot15 then
						slot16 = slot10.default_equip_list[slot14]
					else
						slot16 = slot15.configId
						slot18 = slot15.skinId
					end

					for slot23, slot24 in ipairs(slot19) do
						slot1:AddPreloadResource(slot1.GetWeaponResource(slot24, slot18))
					end
				elseif slot15 then
					slot1:AddPreloadResource(slot1.GetEquipResource(slot15.configId, slot15.skinId, slot0.contextData.system))
				end
			end

			for slot14, slot15 in ipairs(slot10.depth_charge_list) do
				for slot20, slot21 in ipairs(slot16) do
					slot1:AddPreloadResource(slot1.GetWeaponResource(slot21))
				end
			end

			for slot14, slot15 in ipairs(slot10.fix_equip_list) do
				for slot20, slot21 in ipairs(slot16) do
					slot1:AddPreloadResource(slot1.GetWeaponResource(slot21))
				end
			end

			for slot15, slot16 in pairs(slot11) do
				slot1:AddPreloadResource(slot16)
			end

			if slot9.buffs then
				slot1:AddPreloadResource(ys.Battle.BattleDataFunction.GetBuffListRes(slot9.buffs, slot0.contextData.system, slot9.skinId))
			end
		end
	end

	slot4 = nil

	slot1:AddPreloadResource(slot1.GetMapResource((slot0.contextData.system ~= SYSTEM_WORLD or pg.expedition_data_template[slot0.contextData.stageId].difficulty ~= ys.Battle.BattleConst.Difficulty.WORLD or nowWorld.GetActiveMap(slot5).config.expedition_map_id) and pg.expedition_data_template[slot0.contextData.stageId].map_id))

	slot10, slot9 = slot1.GetStageResource(slot5)

	slot1:AddPreloadResource(slot6)
	slot1:AddPreloadResource(slot1.GetCommonResource())
	slot1:AddPreloadResource(slot1.GetBuffResource())

	for slot11, slot12 in ipairs(slot7) do
		slot1:AddPreloadCV(slot12)
	end

	slot9 = 0

	setActive(slot11, true)

	slot9 = slot1:StartPreload(slot8, slot10)
	slot0._tipsText.text = pg.server_language[math.random(#pg.server_language)].content
end

slot0.addCommanderBuffRes = function (slot0)
	slot1 = ys.Battle.BattleResourceManager.GetInstance()

	for slot5, slot6 in ipairs(slot0) do
		for slot11, slot12 in ipairs(slot7) do
			slot1:AddPreloadResource(slot12)
		end
	end
end

slot0.addChapterBuffRes = function (slot0)
	slot1 = ys.Battle.BattleResourceManager.GetInstance()

	for slot5, slot6 in ipairs(slot0) do
		for slot11, slot12 in ipairs(slot7) do
			slot1:AddPreloadResource(slot12)
		end
	end
end

slot0.addChapterAuraRes = function (slot0)
	slot1 = ys.Battle.BattleResourceManager.GetInstance()

	for slot5, slot6 in ipairs(slot0) do
		for slot11, slot12 in ipairs(slot7) do
			slot1:AddPreloadResource(slot12)
		end
	end
end

slot0.StartLoad = function (slot0, slot1, slot2, slot3)
	slot0._toLoad[slot3] = 1

	LoadAndInstantiateAsync(slot1, slot2, function (slot0)
		slot0:LoadFinish(slot0, slot0.LoadFinish)
	end)
end

slot0.LoadFinish = function (slot0, slot1, slot2)
	slot0._loadObs.map = slot1
	slot0._toLoad.map = nil

	if table.getCount(slot0._toLoad) <= 0 then
		slot0._go:GetComponent("Animator"):Play("start")
	end
end

return slot0

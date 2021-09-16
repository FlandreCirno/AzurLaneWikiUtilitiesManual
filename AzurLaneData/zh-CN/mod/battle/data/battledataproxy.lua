ys = ys or {}
slot1 = ys.Battle.BattleEvent
slot2 = ys.Battle.BattleFormulas
slot3 = ys.Battle.BattleConst
slot4 = ys.Battle.BattleConfig
slot5 = ys.Battle.BattleDataFunction
slot6 = ys.Battle.BattleAttr
slot7 = ys.Battle.BattleVariable
slot8 = singletonClass("BattleDataProxy", ys.MVC.Proxy)
ys.Battle.BattleDataProxy = slot8
slot8.__name = "BattleDataProxy"

slot8.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot8.InitBattle = function (slot0, slot1)
	slot0.Update = slot0.updateInit

	slot0:SetupCalculateDamage((pg.SdkMgr.GetInstance():CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1 and GodenFnger) or slot0.CreateContextCalculateDamage(slot1.battleType == SYSTEM_WORLD or slot2 == SYSTEM_WORLD_BOSS))
	slot0:SetupDamageKamikazeAir()
	slot0:SetupDamageKamikazeShip()
	slot0:SetupDamageCrush()
	slot1.Init()
	slot0:InitData(slot1)
	slot0:DispatchEvent(slot2.Event.New(slot1.battleType == SYSTEM_WORLD or slot2 == SYSTEM_WORLD_BOSS.STAGE_DATA_INIT_FINISH))
	slot0._cameraUtil:Initialize()
	slot0._cameraUtil:SetMapData(slot0:GetTotalBounds())
	slot0:InitUserShipsData(slot0._battleInitData.MainUnitList, slot0._battleInitData.VanguardUnitList, pg.SdkMgr.GetInstance().CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1.FRIENDLY_CODE, slot0._battleInitData.SubUnitList)
	slot0:InitUserAidData()
	slot0:SetSubmarinAidData()
	slot0._cameraUtil:SetFocusFleet(slot0:GetFleetByIFF(pg.SdkMgr.GetInstance().CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1.FRIENDLY_CODE))
	slot0:StatisticsInit(slot0._fleetList[pg.SdkMgr.GetInstance().CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1.FRIENDLY_CODE]:GetUnitList())
	slot0:SetFlagShipID(slot0:GetFleetByIFF(pg.SdkMgr.GetInstance().CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1.FRIENDLY_CODE):GetFlagShip())
	slot0:DispatchEvent(slot2.Event.New(slot1.battleType == SYSTEM_WORLD or slot2 == SYSTEM_WORLD_BOSS.COMMON_DATA_INIT_FINISH, {}))
end

slot8.Start = function (slot0)
	slot0._startTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

slot8.TriggerBattleInitBuffs = function (slot0)
	for slot4, slot5 in pairs(slot0._fleetList) do
		for slot10, slot11 in ipairs(slot6) do
			slot11:TriggerBuff(slot0.BuffEffectType.ON_INIT_GAME)
		end
	end
end

slot8.TirggerBattleStartBuffs = function (slot0)
	for slot4, slot5 in pairs(slot0._fleetList) do
		slot6 = slot5:GetUnitList()
		slot8 = slot5:GetScoutList()[1]
		slot9 = (#slot5.GetScoutList() > 1 and slot7[#slot7]) or nil
		slot10 = (#slot7 == 3 and slot7[2]) or nil
		slot11 = slot5:GetMainList()
		slot12 = slot11[1]
		slot13 = slot11[2]
		slot14 = slot11[3]

		for slot18, slot19 in ipairs(slot6) do
			underscore.each(slot0._battleInitData.ChapterBuffIDs or {}, function (slot0)
				slot1:AddBuff(slot0.Battle.BattleBuffUnit.New(slot0))
			end)
			underscore.each(slot0._battleInitData.GlobalBuffIDs or {}, function (slot0)
				slot1:AddBuff(slot0.Battle.BattleBuffUnit.New(slot0))
			end)

			if slot0._battleInitData.MapAuraSkills then
				for slot23, slot24 in ipairs(slot0._battleInitData.MapAuraSkills) do
					slot19.AddBuff(slot19, slot0.Battle.BattleBuffUnit.New(slot24.id, slot24.level))
				end
			end

			if slot0._battleInitData.MapAidSkills then
				for slot23, slot24 in ipairs(slot0._battleInitData.MapAidSkills) do
					slot19:AddBuff(slot0.Battle.BattleBuffUnit.New(slot24.id, slot24.level))
				end
			end

			slot19:TriggerBuff(slot1.BuffEffectType.ON_START_GAME)

			if slot19 == slot12 then
				slot19:TriggerBuff(slot1.BuffEffectType.ON_FLAG_SHIP)
			elseif slot19 == slot13 then
				slot19:TriggerBuff(slot1.BuffEffectType.ON_UPPER_CONSORT)
			elseif slot19 == slot14 then
				slot19:TriggerBuff(slot1.BuffEffectType.ON_LOWER_CONSORT)
			elseif slot19 == slot8 then
				slot19:TriggerBuff(slot1.BuffEffectType.ON_LEADER)
			elseif slot19 == slot10 then
				slot19:TriggerBuff(slot1.BuffEffectType.ON_CENTER)
			elseif slot19 == slot9 then
				slot19:TriggerBuff(slot1.BuffEffectType.ON_REAR)
			end
		end
	end
end

slot8.InitAllFleetUnitsWeaponCD = function (slot0)
	for slot4, slot5 in pairs(slot0._fleetList) do
		for slot10, slot11 in ipairs(slot6) do
			slot0.InitUnitWeaponCD(slot11)
		end
	end
end

slot8.InitUnitWeaponCD = function (slot0)
	slot0:CheckWeaponInitial()
end

slot8.GetInitData = function (slot0)
	return slot0._battleInitData
end

slot8.GetDungeonData = function (slot0)
	return slot0._dungeonInfo
end

slot8.InitData = function (slot0, slot1)
	slot0.FrameIndex = 1
	slot0._friendlyCode = 1
	slot0._foeCode = -1
	slot0.FRIENDLY_CODE = 1
	slot0.FOE_CODE = -1
	slot0._completelyRepress = false
	slot0._repressReduce = 1
	slot0._repressLevel = 0
	slot0._repressEnemyHpRant = 1
	slot0._friendlyShipList = {}
	slot0._foeShipList = {}
	slot0._friendlyAircraftList = {}
	slot0._foeAircraftList = {}
	slot0._spectreShipList = {}
	slot0._fleetList = {}
	slot0._freeShipList = {}
	slot0._teamList = {}
	slot0._waveSummonList = {}
	slot0._aidUnitList = {}
	slot0._unitList = {}
	slot0._unitCount = 0
	slot0._bulletList = {}
	slot0._bulletCount = 0
	slot0._aircraftList = {}
	slot0._aircraftCount = 0
	slot0._AOEList = {}
	slot0._AOECount = 0
	slot0._wallList = {}
	slot0._wallIndex = 0
	slot0._shelterList = {}
	slot0._shelterIndex = 0
	slot0._environmentList = {}
	slot0._environmentIndex = 0
	slot0._enemySubmarineCount = 0
	slot0._airFighterList = {}
	slot0._currentStageIndex = 1
	slot0._battleInitData = slot1
	slot0._expeditionID = slot1.StageTmpId
	slot0._expeditionTmp = pg.expedition_data_template[slot0._expeditionID]

	slot0:SetDungeonLevel(slot1.WorldLevel or slot0._expeditionTmp.level)

	slot0._dungeonID = slot0._expeditionTmp.dungeon_id
	slot0._dungeonInfo = slot1.GetDungeonTmpDataByID(slot0._dungeonID)
	slot0._mapId = slot1.WorldMapId or slot0._expeditionTmp.map_id
	slot0._exposeSpeed = slot0._expeditionTmp.expose_speed
	slot0._airExpose = slot0._expeditionTmp.aircraft_expose[1]
	slot0._airExposeEX = slot0._expeditionTmp.aircraft_expose[2]
	slot0._shipExpose = slot0._expeditionTmp.ship_expose[1]
	slot0._shipExposeEX = slot0._expeditionTmp.ship_expose[2]
	slot0._commander = slot1.CommanderList or {}
	slot0._subCommander = slot1.SubCommanderList or {}
	slot0._commanderBuff = slot0.initCommanderBuff(slot0._commander)
	slot0._subCommanderBuff = slot0.initCommanderBuff(slot0._subCommander)

	if slot0._battleInitData.RepressInfo then
		slot2 = slot0._battleInitData.RepressInfo

		if slot0._battleInitData.battleType == SYSTEM_SCENARIO then
			if slot2.repressMax <= slot2.repressCount then
				slot0._completelyRepress = true
			end

			slot0._repressReduce = slot2.ChapterRepressReduce(slot2.repressReduce)
			slot0._repressLevel = slot2.repressLevel
			slot0._repressEnemyHpRant = slot2.repressEnemyHpRant
		elseif slot0._battleInitData.battleType == SYSTEM_WORLD or slot0._battleInitData.battleType == SYSTEM_WORLD_BOSS then
			slot0._repressEnemyHpRant = slot2.repressEnemyHpRant
		end
	end

	slot0._chapterWinningStreak = slot0._battleInitData.DefeatCount or 0
	slot0._waveFlags = table.shallowCopy(slot1.StageWaveFlags) or {}

	slot0:InitStageData()

	slot0._cldSystem = slot3.Battle.BattleCldSystem.New(slot0)
	slot0._cameraUtil = slot3.Battle.BattleCameraUtil.GetInstance()

	slot0:initBGM()
end

slot8.initBGM = function (slot0)
	slot0._initBGMList = {}
	slot0._otherBGMList = {}
	slot1 = {}
	slot2 = {}

	slot3(slot0._battleInitData.MainUnitList)
	slot3(slot0._battleInitData.VanguardUnitList)
	slot3(slot0._battleInitData.SubUnitList)

	if slot0._battleInitData.RivalMainUnitList then
		slot3(slot0._battleInitData.RivalMainUnitList)
	end

	if slot0._battleInitData.RivalVanguardUnitList then
		slot3(slot0._battleInitData.RivalVanguardUnitList)
	end

	for slot7, slot8 in pairs(slot1) do
		table.insert(slot0._initBGMList, slot7)
	end

	for slot7, slot8 in pairs(slot2) do
		table.insert(slot0._otherBGMList, slot7)
	end
end

slot8.initCommanderBuff = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0) do
		slot8 = slot6[1].getSkills(slot7)[1]:getLevel()

		for slot12, slot13 in ipairs(slot6[2]) do
			table.insert(slot1, {
				id = slot13,
				level = slot8,
				commander = slot7
			})
		end
	end

	return slot1
end

slot8.InitStageData = function (slot0)
	slot0._currentStageData = slot0._dungeonInfo.stages[slot0._currentStageIndex]
	slot0._countDown = slot0._currentStageData.timeCount
	slot0._totalLeftBound = slot0._currentStageData.totalArea[1]
	slot0._totalRightBound = slot0._currentStageData.totalArea[1] + slot0._currentStageData.totalArea[3]
	slot0._totalUpperBound = slot0._currentStageData.totalArea[2] + slot0._currentStageData.totalArea[4]
	slot0._totalLowerBound = slot0._currentStageData.totalArea[2]
	slot0._leftZoneLeftBound = slot0._currentStageData.playerArea[1]
	slot0._leftZoneRightBound = slot0._currentStageData.playerArea[1] + slot0._currentStageData.playerArea[3]
	slot0._leftZoneUpperBound = slot0._currentStageData.playerArea[2] + slot0._currentStageData.playerArea[4]
	slot0._leftZoneLowerBound = slot0._currentStageData.playerArea[2]
	slot0._rightZoneLeftBound = slot0._leftZoneRightBound
	slot0._rightZoneRightBound = slot0._totalRightBound
	slot0._rightZoneUpperBound = slot0._leftZoneUpperBound
	slot0._rightZoneLowerBound = slot0._leftZoneLowerBound
	slot0._bulletUpperBound = slot0._totalUpperBound + 3
	slot0._bulletLowerBound = slot0._totalLowerBound - 10
	slot0._bulletLeftBound = slot0._totalLeftBound - 10
	slot0._bulletRightBound = slot0._totalRightBound + 10
end

slot8.Clear = function (slot0)
	for slot4, slot5 in pairs(slot0._teamList) do
		slot0:KillNPCTeam(slot5)
	end

	slot0._teamList = nil

	for slot4, slot5 in pairs(slot0._bulletList) do
		slot0:RemoveBulletUnit(slot4)
	end

	slot0._bulletList = nil

	for slot4, slot5 in pairs(slot0._unitList) do
		slot0:KillUnit(slot4)
	end

	slot0._unitList = nil

	for slot4, slot5 in pairs(slot0._aircraftList) do
		slot0:KillAircraft(slot4)
	end

	slot0._aircraftList = nil

	for slot4, slot5 in pairs(slot0._fleetList) do
		slot5:Dispose()

		slot0._fleetList[slot4] = nil
	end

	slot0._fleetList = nil

	for slot4, slot5 in pairs(slot0._aidUnitList) do
		slot5:Dispose()
	end

	slot0._aidUnitList = nil

	for slot4, slot5 in pairs(slot0._environmentList) do
		slot0:RemoveEnvironment(slot5:GetUniqueID())
	end

	slot0._environmentList = nil

	for slot4, slot5 in pairs(slot0._AOEList) do
		slot0:RemoveAreaOfEffect(slot4)
	end

	slot0._AOEList = nil

	slot0._cldSystem:Dispose()

	slot0._cldSystem = nil
	slot0._dungeonInfo = nil
	slot0._flagShipUnit = nil
	slot0._friendlyShipList = nil
	slot0._foeShipList = nil
	slot0._spectreShipList = nil
	slot0._friendlyAircraftList = nil
	slot0._foeAircraftList = nil
	slot0._fleetList = nil
	slot0._freeShipList = nil
	slot0._countDown = nil
	slot0._lastUpdateTime = nil
	slot0._statistics = nil
	slot0._battleInitData = nil
	slot0._currentStageData = nil

	slot0:ClearFormulas()
	slot0.ClearDungeonCfg(slot0._dungeonID)
end

slot8.DeactiveProxy = function (slot0)
	slot0._state = nil

	slot0:Clear()
	slot0.Battle.BattleDataProxy.super.DeactiveProxy(slot0)
end

slot8.InitUserShipsData = function (slot0, slot1, slot2, slot3, slot4)
	for slot8, slot9 in ipairs(slot2) do
		slot10 = slot0:SpawnVanguard(slot9, slot3)
	end

	for slot8, slot9 in ipairs(slot1) do
		slot10 = slot0:SpawnMain(slot9, slot3)
	end

	slot0:GetFleetByIFF(slot3).FleetUnitSpwanFinish(slot5)

	if slot0._battleInitData.battleType == SYSTEM_SUBMARINE_RUN or slot6 == SYSTEM_SUB_ROUTINE then
		for slot10, slot11 in ipairs(slot4) do
			slot0:SpawnManualSub(slot11, slot3)
		end

		slot5:ShiftManualSub()
	else
		slot5:SetSubUnitData(slot4)
	end

	if slot0._battleInitData.battleType == SYSTEM_DUEL then
		for slot10, slot11 in ipairs(slot5:GetCloakList()) do
			slot11:GetCloak():SetRecoverySpeed(0)
		end
	end

	slot0:DispatchEvent(slot0.Event.New(slot1.ADD_FLEET, {
		fleetVO = slot5
	}))
end

slot8.InitUserAidData = function (slot0)
	for slot4, slot5 in ipairs(slot0._battleInitData.AidUnitList) do
		slot5.properties.level = slot5.level
		slot5.properties.formationID = slot0.FORMATION_ID
		slot5.properties.id = slot5.id

		slot1.AttrFixer(slot0._battleInitData.battleType, slot5.properties)

		slot9 = slot2.CreateBattleUnitData(slot0:GenerateUnitID(), slot3.UnitType.PLAYER_UNIT, slot0.FRIENDLY_CODE, slot5.tmpID, slot5.skinId, slot5.equipment, slot7, slot5.baseProperties, slot5.proficiency or {
			1,
			1,
			1
		}, slot5.baseList, slot5.preloasList)
		slot0._aidUnitList[slot9:GetUniqueID()] = slot9
	end
end

slot8.SetSubmarinAidData = function (slot0)
	slot0:GetFleetByIFF(slot0.FRIENDLY_CODE):SetSubAidData(slot0._battleInitData.TotalSubAmmo, slot0._battleInitData.SubFlag)
end

slot8.CelebrateVictory = function (slot0, slot1)
	slot2 = nil
	slot2 = (slot1 ~= slot0:GetFoeCode() or slot0._foeShipList) and slot0._friendlyShipList

	for slot6, slot7 in pairs(slot2) do
		slot7:StateChange(slot0.Battle.UnitState.STATE_VICTORY)
	end
end

slot8.GetVanguardBornCoordinate = function (slot0, slot1)
	if slot1 == slot0.FRIENDLY_CODE then
		return slot0._currentStageData.fleetCorrdinate
	elseif slot1 == slot0.FOE_CODE then
		return slot0._currentStageData.rivalCorrdinate
	end
end

slot8.GetTotalBounds = function (slot0)
	return slot0._totalUpperBound, slot0._totalLowerBound, slot0._totalLeftBound, slot0._totalRightBound
end

slot8.GetTotalRightBound = function (slot0)
	return slot0._totalRightBound
end

slot8.GetTotalLowerBound = function (slot0)
	return slot0._totalLowerBound
end

slot8.GetUnitBoundByIFF = function (slot0, slot1)
	if slot1 == slot0.FRIENDLY_CODE then
		return slot0._leftZoneUpperBound, slot0._leftZoneLowerBound, slot0._leftZoneLeftBound, slot0.MaxRight, slot0.MaxLeft, slot0._leftZoneRightBound
	elseif slot1 == slot0.FOE_CODE then
		return slot0._rightZoneUpperBound, slot0._rightZoneLowerBound, slot0._rightZoneLeftBound, slot0._rightZoneRightBound, slot0._rightZoneLeftBound, slot0.MaxRight
	end
end

slot8.GetFleetBoundByIFF = function (slot0, slot1)
	if slot1 == slot0.FRIENDLY_CODE then
		return slot0._leftZoneUpperBound, slot0._leftZoneLowerBound, slot0._leftZoneLeftBound, slot0._leftZoneRightBound
	elseif slot1 == slot0.FOE_CODE then
		return slot0._rightZoneUpperBound, slot0._rightZoneLowerBound, slot0._rightZoneLeftBound, slot0._rightZoneRightBound
	end
end

slot8.ShiftFleetBound = function (slot0, slot1, slot2)
	slot1:SetBound(slot0:GetFleetBoundByIFF(slot2))

	slot3, slot4, slot5, slot6, slot7, slot8 = slot0:GetUnitBoundByIFF(slot2)

	for slot13, slot14 in ipairs(slot9) do
		slot14:SetBound(slot3, slot4, slot5, slot6, slot7, slot8)
	end
end

slot8.GetFleetByIFF = function (slot0, slot1)
	if slot0._fleetList[slot1] == nil then
		slot2 = slot0.Battle.BattleFleetVO.New(slot1)
		slot0._fleetList[slot1] = slot2

		slot2:SetBound(slot0:GetFleetBoundByIFF(slot1))
		slot2:SetTotalBound(slot0:GetTotalBounds())
		slot2:SetExposeLine(slot0._expeditionTmp.horizon_line[slot1], slot0._expeditionTmp.expose_line[slot1])
		slot2:CalcSubmarineBaseLine(slot0._battleInitData.battleType)
	end

	return slot0._fleetList[slot1]
end

slot8.GetAidUnit = function (slot0)
	return slot0._aidUnitList
end

slot8.GetFleetList = function (slot0)
	return slot0._fleetList
end

slot8.GetEnemySubmarineCount = function (slot0)
	return slot0._enemySubmarineCount
end

slot8.GetCommander = function (slot0)
	return slot0._commander
end

slot8.GetCommanderBuff = function (slot0)
	return slot0._commanderBuff, slot0._subCommanderBuff
end

slot8.GetStageInfo = function (slot0)
	return slot0._currentStageData
end

slot8.GetWinningStreak = function (slot0)
	return slot0._chapterWinningStreak
end

slot8.GetBGMList = function (slot0, slot1)
	if not slot1 then
		return slot0._initBGMList
	else
		return slot0._otherBGMList
	end
end

slot8.GetDungeonLevel = function (slot0)
	return slot0._dungeonLevel
end

slot8.SetDungeonLevel = function (slot0, slot1)
	slot0._dungeonLevel = slot1
end

slot8.IsCompletelyRepress = function (slot0)
	return slot0._completelyRepress
end

slot8.GetRepressReduce = function (slot0)
	return slot0._repressReduce
end

slot8.GetRepressLevel = function (slot0)
	return slot0._repressLevel
end

slot8.updateInit = function (slot0, slot1)
	slot0:TriggerBattleInitBuffs()

	slot0.checkCld = true

	slot0:updateLoop(slot1)

	slot0.Update = slot0.updateLoop
end

slot8.updateLoop = function (slot0, slot1)
	slot0.FrameIndex = slot0.FrameIndex + 1

	slot0:UpdateCountDown(slot1)

	for slot5, slot6 in pairs(slot0._fleetList) do
		slot6:UpdateMotion()
	end

	slot0.checkCld = not slot0.checkCld
	slot2 = {
		[slot0.FRIENDLY_CODE] = slot0._totalLeftBound,
		[slot0.FOE_CODE] = slot0._totalRightBound
	}

	for slot6, slot7 in pairs(slot0._unitList) do
		if slot7:IsSpectre() then
			slot7:Update(slot1)
		else
			if slot0.checkCld then
				slot0._cldSystem:UpdateShipCldTree(slot7)
			end

			if slot7:IsAlive() then
				slot7:Update(slot1)
			end

			slot8 = slot7:GetPosition().x

			if slot7:GetIFF() == slot0.FRIENDLY_CODE then
				slot2[slot9] = math.max(slot2[slot9], slot8)
			elseif slot9 == slot0.FOE_CODE then
				slot2[slot9] = math.min(slot2[slot9], slot8)
			end
		end
	end

	slot5 = slot0._fleetList[slot0.FRIENDLY_CODE].GetFleetVisionLine(slot3)
	slot6 = slot2[slot0.FOE_CODE]

	if slot0._fleetList[slot0.FRIENDLY_CODE].GetFleetExposeLine(slot3) and slot6 < slot4 then
		slot3:CloakFatalExpose()
	elseif slot6 < slot5 then
		slot3:CloakInVision(slot0._exposeSpeed)
	else
		slot3:CloakOutVision()
	end

	if slot0._fleetList[slot0.FOE_CODE] then
		slot9 = slot0._fleetList[slot0.FOE_CODE].GetFleetVisionLine(slot7)
		slot10 = slot2[slot0.FRIENDLY_CODE]

		if slot0._fleetList[slot0.FOE_CODE].GetFleetExposeLine(slot7) and slot8 < slot10 then
			slot7:CloakFatalExpose()
		elseif slot9 < slot10 then
			slot7:CloakInVision(slot0._exposeSpeed)
		else
			slot7:CloakOutVision()
		end
	end

	for slot10, slot11 in pairs(slot0._bulletList) do
		slot12 = slot11:GetSpeed()
		slot13 = slot11:GetPosition()
		slot14 = slot11:GetType()

		if slot11:GetOutBound() == slot1.BulletOutBound.COMMON and ((slot0._bulletRightBound < slot13.x and slot12.x > 0) or (slot13.z < slot0._bulletLowerBound and slot12.z < 0)) then
			slot0:RemoveBulletUnit(slot11:GetUniqueID())
		elseif slot13.x < slot0._bulletLeftBound and slot12.x < 0 and slot14 ~= slot1.BulletType.BOMB then
			if slot15 == slot1.BulletOutBound.RANDOM and slot0._fleetList[slot0.FRIENDLY_CODE]:RandomMainVictim() then
				slot0:HandleDamage(slot11, slot16)
			end

			slot0:RemoveBulletUnit(slot11:GetUniqueID())
		else
			slot11:Update(slot1)

			if slot11.GetCurrentState and slot11:GetCurrentState() == slot2.Battle.BattleShrapnelBulletUnit.STATE_SPLIT and not slot11:GetTemplate().extra_param.fragile then
			elseif (slot15 == slot1.BulletOutBound.COMMON and slot0._bulletUpperBound < slot13.z and slot12.z > 0) or slot11:IsOutRange(slot1) then
				if slot11:GetExist() then
					slot11:OutRange()
				else
					slot0:RemoveBulletUnit(slot11:GetUniqueID())
				end
			elseif slot0.checkCld then
				slot0._cldSystem:UpdateBulletCld(slot11)
			end
		end
	end

	for slot10, slot11 in pairs(slot0._aircraftList) do
		slot11:Update(slot1)

		slot12, slot13 = slot11:GetIFF()

		if slot12 == slot0.FRIENDLY_CODE then
			slot13 = slot0._totalRightBound
		elseif slot12 == slot0.FOE_CODE then
			slot13 = slot0._totalLeftBound
		end

		if math.abs(slot13) < slot11:GetPosition().x * slot12 and slot11:GetSpeed().x * slot12 > 0 then
			slot11:OutBound()
		else
			slot0._cldSystem:UpdateAircraftCld(slot11)
		end

		if not slot11:IsAlive() then
			slot0:KillAircraft(slot11:GetUniqueID())
		end
	end

	for slot10, slot11 in pairs(slot0._AOEList) do
		slot0._cldSystem:UpdateAOECld(slot11)
		slot11:Settle()

		if slot11:GetActiveFlag() == false then
			slot11:SettleFinale()
			slot0:RemoveAreaOfEffect(slot11:GetUniqueID())
		end
	end

	for slot10, slot11 in pairs(slot0._environmentList) do
		slot11:Update()

		if slot11:IsExpire(slot1) then
			slot0:RemoveEnvironment(slot11:GetUniqueID())
		end
	end

	if slot0.checkCld then
		for slot10, slot11 in pairs(slot0._shelterList) do
			if not slot11:IsWallActive() then
				slot0:RemoveShelter(slot11:GetUniqueID())
			else
				slot11:Update(slot1)
			end
		end

		for slot10, slot11 in pairs(slot0._wallList) do
			if slot11:IsActive() then
				slot0._cldSystem:UpdateWallCld(slot11)
			end
		end
	end

	for slot10, slot11 in pairs(slot0._foeShipList) do
		if slot11:GetPosition().x + slot11:GetBoxSize().x < slot0._leftZoneLeftBound then
			slot11:SetDeathReason(slot1.UnitDeathReason.TOUCHDOWN)
			slot11:DeadAction()
			slot0:KillUnit(slot11:GetUniqueID())
			slot0:HandleShipMissDamage(slot11, slot0._fleetList[slot0.FRIENDLY_CODE])
		end
	end
end

slot8.UpdateAutoComponent = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0._fleetList) do
		slot6:UpdateAutoComponent(slot1)
	end

	for slot5, slot6 in pairs(slot0._teamList) do
		if slot6:IsFatalDamage() then
			slot0:KillNPCTeam(slot5)
		else
			slot6:UpdateMotion()
		end
	end

	for slot5, slot6 in pairs(slot0._freeShipList) do
		slot6:UpdateOxygen(slot1)
		slot6:UpdateWeapon(slot1)
		slot6:UpdatePhaseSwitcher()
	end
end

slot8.UpdateEscapeOnly = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0._foeShipList) do
		slot6:Update(slot1)
	end
end

slot8.UpdateCountDown = function (slot0, slot1)
	slot0._lastUpdateTime = slot0._lastUpdateTime or slot1

	if slot0._countDown - (slot1 - slot0._lastUpdateTime) <= 0 then
		slot2 = 0
	end

	if math.floor(slot0._countDown - slot2) == 0 or slot2 == 0 then
		slot0:DispatchEvent(slot0.Event.New(slot1.UPDATE_COUNT_DOWN, {}))
	end

	slot0._countDown = slot2
	slot0._totalTime = slot1 - slot0._startTimeStamp
	slot0._lastUpdateTime = slot1
end

slot8.SpawnMonster = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = slot0:GenerateUnitID()
	slot8 = {}

	for slot12, slot13 in ipairs(slot0.GetMonsterTmpDataFromID(slot1.monsterTemplateID).equipment_list) do
		table.insert(slot8, {
			id = slot13
		})
	end

	slot10 = slot7.random_nub

	for slot14, slot15 in ipairs(slot9) do
		slot17 = Clone(slot15)

		for slot21 = 1, slot10[slot14], 1 do
			table.insert(slot8, {
				id = slot17[math.random(#slot17)]
			})
			table.remove(slot17, math.random(#slot17))
		end
	end

	slot11 = slot0.CreateBattleUnitData(slot6, slot3, slot4, slot1.monsterTemplateID, nil, slot8, slot1.extraInfo, nil, nil, nil, nil, slot1.level)

	slot1.MonsterAttrFixer(slot0._battleInitData.battleType, slot11)

	if math.ceil(slot11:GetMaxHP() * slot0._repressEnemyHpRant) <= 0 then
		slot12 = 1
	end

	slot11:SetCurrentHP(slot12)
	slot11:SetPosition(slot13)
	slot11:SetAI(slot1.pilotAITemplateID or slot7.pilot_ai_template_id)
	slot0:setShipUnitBound(slot11)

	if table.contains(TeamType.SubShipType, slot7.type) then
		slot11:InitOxygen()
		slot0:UpdateHostileSubmarine(true)
	end

	slot0._freeShipList[slot6] = slot11
	slot0._unitList[slot6] = slot11

	if slot11:IsSpectre() then
		slot11:SetBlindInvisible(true)
	else
		slot0._cldSystem:InitShipCld(slot11)
	end

	slot11:SummonSickness(slot3.SUMMONING_SICKNESS_DURATION)
	slot11:SetMoveCast(slot1.moveCast == true)

	if slot11:GetIFF() == slot4.FRIENDLY_CODE then
		slot0._friendlyShipList[slot6] = slot11
	else
		if slot11:IsSpectre() then
			slot0._spectreShipList[slot6] = slot11
		else
			slot0._foeShipList[slot6] = slot11
		end

		slot11:SetWaveIndex(slot2)
	end

	if slot1.reinforce then
		slot11:Reinforce()
	end

	if slot1.reinforceDelay then
		slot11:SetReinforceCastTime(slot1.reinforceDelay)
	end

	if slot1.team then
		slot0:GetNPCTeam(slot1.team):AppendUnit(slot11)
	end

	if slot1.phase then
		slot5.Battle.BattleUnitPhaseSwitcher.New(slot11):SetTemplateData(slot1.phase)
	end

	if slot5 then
		slot5(slot11)
	end

	slot0:DispatchEvent(slot5.Event.New(slot6.ADD_UNIT, {
		type = slot3,
		unit = slot11,
		bossData = slot1.bossData,
		extraInfo = slot1.extraInfo
	}))

	slot18 = slot0._battleInitData.AffixBuffList or {}

	function (slot0)
		for slot4, slot5 in ipairs(slot0) do
			slot6, slot7 = nil

			if type(slot5) == "number" then
				slot7 = slot5
				slot6 = 1
			else
				slot1:AddBuff(slot0.Battle.BattleBuffUnit.New(slot5.ID, slot5.LV or 1, slot1))
			end
		end
	end(slot11.GetTemplate(slot11).buff_list)
	function (slot0)
		for slot4, slot5 in ipairs(slot0) do
			slot6, slot7 = nil

			if type(slot5) == "number" then
				slot7 = slot5
				slot6 = 1
			else
				slot1.AddBuff(slot0.Battle.BattleBuffUnit.New(slot5.ID, slot5.LV or 1, slot1))
			end
		end
	end(slot1.buffList or {})

	if slot1.affix then
		slot15(slot18)
	end

	if slot1.summonWaveIndex then
		slot0._waveSummonList[slot19] = slot0._waveSummonList[slot19] or {}
		slot0._waveSummonList[slot19][slot11] = true
	end

	slot11:CheckWeaponInitial()

	if slot0._battleInitData.CMDArgs and slot11:GetTemplateID() == slot0._battleInitData.CMDArgs then
		slot0:InitSpecificEnemyStatistics(slot11)
	end
end

slot8.UpdateHostileSubmarine = function (slot0, slot1)
	if slot1 then
		slot0._enemySubmarineCount = slot0._enemySubmarineCount + 1
	else
		slot0._enemySubmarineCount = slot0._enemySubmarineCount - 1
	end

	slot0:DispatchEvent(slot0.Event.New(slot1.UPDATE_HOSTILE_SUBMARINE))
end

slot8.EnemyEscape = function (slot0)
	for slot4, slot5 in pairs(slot0._foeShipList) do
		slot5:SetAI(slot0.COUNT_DOWN_ESCAPE_AI_ID)
	end
end

slot8.GetNPCTeam = function (slot0, slot1)
	if not slot0._teamList[slot1] then
		slot0._teamList[slot1] = slot0.Battle.BattleTeamVO.New(slot1)
	end

	return slot0._teamList[slot1]
end

slot8.KillNPCTeam = function (slot0, slot1)
	if slot0._teamList[slot1] then
		slot2:Dispose()

		slot0._teamList[slot1] = nil
	end
end

slot8.SpawnVanguard = function (slot0, slot1, slot2)
	slot4 = slot0:generatePlayerUnit(slot1, slot2, BuildVector3(slot3), slot0._commanderBuff)

	slot0:GetFleetByIFF(slot2).AppendPlayerUnit(slot5, slot4)
	slot0._cldSystem:InitShipCld(slot4)
	slot0:DispatchEvent(slot1.Event.New(slot2.ADD_UNIT, {
		type = slot0.UnitType.PLAYER_UNIT,
		unit = slot4
	}))

	return slot4
end

slot8.SpawnMain = function (slot0, slot1, slot2)
	slot3 = nil
	slot6 = slot0:generatePlayerUnit(slot1, slot2, (not slot0._currentStageData.mainUnitPosition or not slot0._currentStageData.mainUnitPosition[slot2] or Clone(slot0._currentStageData.mainUnitPosition[slot2][#slot0:GetFleetByIFF(slot2).GetMainList(slot4) + 1])) and Clone(slot0.MAIN_UNIT_POS[slot2][#slot0.GetFleetByIFF(slot2).GetMainList(slot4) + 1]), slot0._commanderBuff)

	slot6:SetBornPosition((not slot0._currentStageData.mainUnitPosition or not slot0._currentStageData.mainUnitPosition[slot2] or Clone(slot0._currentStageData.mainUnitPosition[slot2][#slot0.GetFleetByIFF(slot2).GetMainList(slot4) + 1])) and Clone(slot0.MAIN_UNIT_POS[slot2][#slot0.GetFleetByIFF(slot2).GetMainList(slot4) + 1]))
	slot6:SetMainFleetUnit()

	if slot3.x < slot0._totalLeftBound or slot0._totalRightBound < slot7 then
		slot6:SetImmuneCommonBulletCLD()
	end

	slot4:AppendPlayerUnit(slot6)
	slot0._cldSystem:InitShipCld(slot6)
	slot0:DispatchEvent(slot2.Event.New(slot3.ADD_UNIT, {
		type = slot1.UnitType.PLAYER_UNIT,
		unit = slot6
	}))

	return slot6
end

slot8.SpawnSub = function (slot0, slot1, slot2)
	slot3 = nil
	slot7 = slot0:generatePlayerUnit(slot1, slot2, (slot2 ~= slot0.FRIENDLY_CODE or Vector3(slot0.SUB_UNIT_OFFSET_X + (slot1.GetPlayerShipTmpDataFromID(slot1.tmpID).summon_offset or 0) + slot0._totalLeftBound, 0, slot0.SUB_UNIT_POS_Z[#slot0:GetFleetByIFF(slot2).GetSubList(slot4) + 1])) and Vector3(slot0._totalRightBound - (slot0.SUB_UNIT_OFFSET_X + (slot1.GetPlayerShipTmpDataFromID(slot1.tmpID).summon_offset or 0)), 0, slot0.SUB_UNIT_POS_Z[#slot0.GetFleetByIFF(slot2).GetSubList(slot4) + 1]), slot0._subCommanderBuff)

	slot4:AddSubMarine(slot7)
	slot0._cldSystem:InitShipCld(slot7)
	slot0:DispatchEvent((slot2 ~= slot0.FRIENDLY_CODE or Vector3(slot0.SUB_UNIT_OFFSET_X + (slot1.GetPlayerShipTmpDataFromID(slot1.tmpID).summon_offset or 0) + slot0._totalLeftBound, 0, slot0.SUB_UNIT_POS_Z[#slot0.GetFleetByIFF(slot2).GetSubList(slot4) + 1])) and Vector3(slot0._totalRightBound - (slot0.SUB_UNIT_OFFSET_X + (slot1.GetPlayerShipTmpDataFromID(slot1.tmpID).summon_offset or 0)), 0, slot0.SUB_UNIT_POS_Z[#slot0.GetFleetByIFF(slot2).GetSubList(slot4) + 1]).Event.New(slot4.ADD_UNIT, {
		type = slot2.UnitType.PLAYER_UNIT,
		unit = slot7
	}))

	return slot7
end

slot8.SpawnManualSub = function (slot0, slot1, slot2)
	slot4 = slot0:generatePlayerUnit(slot1, slot2, BuildVector3(slot3), slot0._commanderBuff)

	slot0:GetFleetByIFF(slot2).AddManualSubmarine(slot5, slot4)
	slot0._cldSystem:InitShipCld(slot4)
	slot0:DispatchEvent(slot1.Event.New(slot2.ADD_UNIT, {
		type = slot0.UnitType.SUB_UNIT,
		unit = slot4
	}))

	return slot4
end

slot8.ShutdownPlayerUnit = function (slot0, slot1)
	slot4 = slot0:GetFleetByIFF(slot3)

	slot4:RemovePlayerUnit(slot2)

	slot5 = {}

	if slot4:GetFleetAntiAirWeapon():GetRange() == 0 then
		slot5.isShow = false
	end

	slot0:DispatchEvent(slot0.Event.New(slot1.ANTI_AIR_AREA, slot5))
	slot0:DispatchEvent(slot0.Event.New(slot1.SHUT_DOWN_PLAYER, {
		unit = slot2
	}))
end

slot8.KillUnit = function (slot0, slot1)
	if slot0._unitList[slot1] == nil then
		return
	end

	slot3 = slot2:GetUnitType()

	slot0._cldSystem:DeleteShipCld(slot2)
	slot2:Clear()

	slot0._unitList[slot1] = nil

	if slot0._freeShipList[slot1] then
		slot0._freeShipList[slot1] = nil
	end

	slot4 = slot2:GetIFF()
	slot5 = slot2:GetDeathReason()

	if slot2:IsSpectre() then
		slot0._spectreShipList[slot1] = nil
	elseif slot4 == slot0.FOE_CODE then
		slot0._foeShipList[slot1] = nil

		if slot3 == slot1.UnitType.ENEMY_UNIT or slot3 == slot1.UnitType.BOSS_UNIT or slot3 == slot1.UnitType.NPC_UNIT then
			if slot2:GetTeam() then
				slot2:GetTeam():RemoveUnit(slot2)
			end

			if table.contains(TeamType.SubShipType, slot2:GetTemplate().type) then
				slot0:UpdateHostileSubmarine(false)
			end

			if slot2:GetWaveIndex() and slot0._waveSummonList[slot7] then
				slot0._waveSummonList[slot7][slot2] = nil
			end
		end
	elseif slot4 == slot0.FRIENDLY_CODE then
		slot0._friendlyShipList[slot1] = nil
	end

	slot0:DispatchEvent(slot2.Event.New(slot3.REMOVE_UNIT, {
		UID = slot1,
		type = slot3,
		deadReason = slot5,
		unit = slot2
	}))
	slot2:Dispose()
end

slot8.KillAllEnemy = function (slot0)
	for slot4, slot5 in pairs(slot0._unitList) do
		if slot5:GetIFF() == slot0.FOE_CODE and slot5:IsAlive() and not slot5:IsBoss() then
			slot5:DeadAction()
		end
	end
end

slot8.KillSubmarineByIFF = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0._unitList) do
		if slot6:GetIFF() == slot1 and slot6:IsAlive() and table.contains(TeamType.SubShipType, slot6:GetTemplate().type) and not slot6:IsBoss() then
			slot6:DeadAction()
		end
	end
end

slot8.KillAllAircraft = function (slot0)
	for slot4, slot5 in pairs(slot0._aircraftList) do
		slot5:Clear()
		slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_AIR_CRAFT, {
			UID = slot4
		}))

		slot0._aircraftList[slot4] = nil
	end
end

slot8.KillWaveSummonMonster = function (slot0, slot1)
	if slot0._waveSummonList[slot1] then
		for slot6, slot7 in pairs(slot2) do
			slot0:KillUnit(slot6:GetUniqueID())
		end
	end

	slot0._waveSummonList[slot1] = nil
end

slot8.IsThereBoss = function (slot0)
	return slot0:GetActiveBossCount() > 0
end

slot8.GetActiveBossCount = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0:GetUnitList()) do
		if slot6:IsBoss() and slot6:IsAlive() then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot8.setShipUnitBound = function (slot0, slot1)
	slot1:SetBound(slot0:GetUnitBoundByIFF(slot1:GetIFF()))
end

slot8.generatePlayerUnit = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot0:GenerateUnitID()
	slot1.properties.level = slot1.level
	slot1.properties.formationID = slot0.FORMATION_ID
	slot1.properties.id = slot1.id

	slot1.AttrFixer(slot0._battleInitData.battleType, slot1.properties)

	slot7 = slot1.proficiency or {
		1,
		1,
		1
	}
	slot8 = slot2.UnitType.PLAYER_UNIT

	if slot0._battleInitData.battleType == SYSTEM_SUBMARINE_RUN or slot9 == SYSTEM_SUB_ROUTINE then
		slot8 = slot2.UnitType.SUB_UNIT
	elseif slot9 == SYSTEM_AIRFIGHT then
		slot8 = slot2.UnitType.CONST_UNIT
	end

	slot10 = slot3.CreateBattleUnitData(slot5, slot8, slot2, slot1.tmpID, slot1.skinId, slot1.equipment, slot6, slot1.baseProperties, slot7, slot1.baseList, slot1.preloasList)

	slot3.AttachUltimateBonus(slot10)
	print(slot1.initHPRate)
	slot10:InitCurrentHP(slot1.initHPRate or 1)
	slot10:SetRarity(slot1.rarity)
	slot10:SetIntimacy(slot1.intimacy)
	slot10:SetShipName(slot1.name)

	slot0._unitList[slot5] = slot10

	slot0:setShipUnitBound(slot10)

	if slot10:GetIFF() == slot0.FRIENDLY_CODE then
		slot0._friendlyShipList[slot5] = slot10
	elseif slot10:GetIFF() == slot0.FOE_CODE then
		slot0._foeShipList[slot5] = slot10
	end

	if slot9 == SYSTEM_WORLD then
		slot1.SetCurrent(slot10, "healingRate", slot4.WorldMapRewardHealingRate(slot0._battleInitData.EnemyMapRewards, slot0._battleInitData.FleetMapRewards))
	end

	slot10:SetPosition(slot3)
	slot3.InitUnitSkill(slot1, slot10, slot9)
	slot3.InitEquipSkill(slot1.equipment, slot10, slot9)
	slot3.InitCommanderSkill(slot4, slot10, slot9)
	slot10:SetGearScore(slot1.shipGS)

	if slot1.deathMark then
		slot10:SetWorldDeathMark()
	end

	return slot10
end

slot8.GetUnitList = function (slot0)
	return slot0._unitList
end

slot8.GetFriendlyShipList = function (slot0)
	return slot0._friendlyShipList
end

slot8.GetFoeShipList = function (slot0)
	return slot0._foeShipList
end

slot8.GetFoeAircraftList = function (slot0)
	return slot0._foeAircraftList
end

slot8.GetFreeShipList = function (slot0)
	return slot0._freeShipList
end

slot8.GenerateUnitID = function (slot0)
	slot0._unitCount = slot0._unitCount + 1

	return slot0._unitCount
end

slot8.GetCountDown = function (slot0)
	return slot0._countDown
end

slot8.SpawnAirFighter = function (slot0, slot1)
	slot2 = #slot0._airFighterList + 1
	slot3 = slot0.GetFormationTmpDataFromID(slot1.formation).pos_offset
	slot4 = {
		currentNumber = 0,
		templateID = slot1.templateID,
		totalNumber = slot1.totalNumber or 0,
		onceNumber = slot1.onceNumber,
		timeDelay = slot1.interval or 3,
		maxTotalNumber = slot1.maxTotalNumber or 15
	}

	function slot5(slot0)
		if slot0.currentNumber < slot0.totalNumber then
			slot0.currentNumber = slot1 + 1
			slot2 = slot1:CreateAirFighter(slot1.CreateAirFighter)

			slot2:SetFormationOffset(slot3[slot0])
			slot2:SetFormationIndex(slot0)
			slot2:SetDeadCallBack(function ()
				slot0.totalNumber = slot0.totalNumber - 1
				slot0.currentNumber = slot0.currentNumber - 1

				slot0.currentNumber - 1:DispatchEvent(slot2.Event.New(slot3.REMOVE_AIR_FIGHTER_ICON, {
					index = 
				}))
			end)
			slot2.SetLiveCallBack(slot2, function ()
				slot0.currentNumber = slot0.currentNumber - 1
			end)
		end
	end

	slot0._airFighterList[slot2] = slot4

	slot0.DispatchEvent(slot0, slot1.Event.New(slot2.ADD_AIR_FIGHTER_ICON, {
		index = slot2
	}))

	slot4.timer = pg.TimeMgr.GetInstance():AddBattleTimer("striker", -1, slot1.interval, function ()
		if slot0.totalNumber > 0 then
			for slot4 = 1, slot0, 1 do
				slot1(slot4)
			end
		else
			pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0.timer)

			slot0.timer = nil
		end
	end)
end

slot8.ClearAirFighterTimer = function (slot0)
	for slot4, slot5 in ipairs(slot0._airFighterList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot5.timer)

		slot5.timer = nil
	end

	slot0._airFighterList = {}
end

slot8.KillAllAirStrike = function (slot0)
	for slot4, slot5 in pairs(slot0._aircraftList) do
		if slot5.__name == slot0.Battle.BattleAirFighterUnit.__name then
			slot0._cldSystem:DeleteAircraftCld(slot5)

			slot5._aliveState = false
			slot0._aircraftList[slot4] = nil
			slot0._foeAircraftList[slot4] = nil

			slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_AIR_CRAFT, {
				UID = slot4
			}))
		end
	end

	slot1 = true

	for slot5, slot6 in pairs(slot0._foeAircraftList) do
		slot1 = false

		break
	end

	if slot1 then
		slot0:DispatchEvent(slot0.Event.New(slot1.ANTI_AIR_AREA, {
			isShow = false
		}))
	end

	for slot5, slot6 in ipairs(slot0._airFighterList) do
		slot6.totalNumber = 0

		slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_AIR_FIGHTER_ICON, {
			index = slot5
		}))
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot6.timer)

		slot6.timer = nil
	end

	slot0._airFighterList = {}
end

slot8.GetAirFighterInfo = function (slot0, slot1)
	return slot0._airFighterList[slot1]
end

slot8.CreateAircraft = function (slot0, slot1, slot2, slot3, slot4)
	slot6 = slot0.CreateAircraftUnit(slot0:GenerateAircraftID(), slot2, slot1, slot3)

	if slot4 then
		slot6:SetSkinID(slot4)
	end

	slot7 = nil

	if slot1:GetIFF() == slot1.FRIENDLY_CODE then
	else
		slot7 = true
	end

	slot0:doCreateAirUnit(slot5, slot6, slot2.UnitType.AIRCRAFT_UNIT, slot7)

	return slot6
end

slot8.CreateAirFighter = function (slot0, slot1)
	slot0:doCreateAirUnit(slot0:GenerateAircraftID(), slot0.CreateAirFighterUnit(slot2, slot1), slot1.UnitType.AIRFIGHTER_UNIT, true)

	return slot0.CreateAirFighterUnit(slot2, slot1)
end

slot8.doCreateAirUnit = function (slot0, slot1, slot2, slot3, slot4)
	slot0._aircraftList[slot1] = slot2

	slot0._cldSystem:InitAircraftCld(slot2)
	slot2:SetBound(slot0._leftZoneUpperBound, slot0._leftZoneLowerBound)
	slot0:DispatchEvent(slot0.Event.New(slot1.ADD_UNIT, {
		unit = slot2,
		type = slot3
	}))

	if slot4 or false then
		slot0._foeAircraftList[slot1] = slot2

		slot0:DispatchEvent(slot0.Event.New(slot1.ANTI_AIR_AREA, {
			isShow = true
		}))
	end
end

slot8.KillAircraft = function (slot0, slot1)
	if slot0._aircraftList[slot1] == nil then
		return
	end

	slot2:Clear()
	slot0._cldSystem:DeleteAircraftCld(slot2)

	if slot2:IsUndefeated() then
		slot0:HandleAircraftMissDamage(slot2, slot0._fleetList[slot2:GetIFF() * -1])
	end

	slot2._aliveState = false
	slot0._aircraftList[slot1] = nil
	slot0._foeAircraftList[slot1] = nil
	slot3 = true

	for slot7, slot8 in pairs(slot0._foeAircraftList) do
		slot3 = false

		break
	end

	if slot3 then
		slot0:DispatchEvent(slot0.Event.New(slot1.ANTI_AIR_AREA, {
			isShow = false
		}))
	end

	slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_AIR_CRAFT, {
		UID = slot1
	}))
end

slot8.GetAircraftList = function (slot0)
	return slot0._aircraftList
end

slot8.GenerateAircraftID = function (slot0)
	slot0._aircraftCount = slot0._aircraftCount + 1

	return slot0._aircraftCount
end

slot8.CreateBulletUnit = function (slot0, slot1, slot2, slot3, slot4)
	slot6, slot7 = slot0.CreateBattleBulletData(slot5, slot1, slot2, slot3, slot4)

	if slot7 then
		slot0._cldSystem:InitBulletCld(slot6)
	end

	slot8, slot9 = slot3:GetFixBulletRange()

	if slot8 or slot9 then
		slot6:FixRange(slot8, slot9)
	end

	slot0._bulletList[slot5] = slot6

	return slot6
end

slot8.RemoveBulletUnit = function (slot0, slot1)
	if slot0._bulletList[slot1] == nil then
		return
	end

	slot2:DamageUnitListWriteback()

	if slot2:GetIsCld() then
		slot0._cldSystem:DeleteBulletCld(slot2)
	end

	slot0._bulletList[slot1] = nil

	slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_BULLET, {
		UID = slot1
	}))
	slot2:Dispose()
end

slot8.GetBulletList = function (slot0)
	return slot0._bulletList
end

slot8.GenerateBulletID = function (slot0)
	slot0._bulletCount = slot0._bulletCount + 1

	return slot0._bulletCount + 1
end

slot8.CLSBullet = function (slot0, slot1, slot2)
	slot3 = true

	if slot0._battleInitData.battleType == SYSTEM_DUEL then
		slot3 = false
	end

	if slot3 then
		for slot8, slot9 in pairs(slot0._bulletList) do
			if slot9:GetIFF() == slot1 and slot9:GetExist() and not slot9:ImmuneCLS() then
				if slot9:ImmuneBombCLS() and slot2 then
				else
					slot0:RemoveBulletUnit(slot8)
				end
			end
		end
	end
end

slot8.CLSAircraft = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0._aircraftList) do
		if slot6:GetIFF() == slot1 then
			slot6:Clear()
			slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_AIR_CRAFT, {
				UID = slot5
			}))

			slot0._aircraftList[slot5] = nil
		end
	end
end

slot8.CLSMinion = function (slot0)
	for slot4, slot5 in pairs(slot0._unitList) do
		if slot5:GetIFF() == slot0.FOE_CODE and slot5:IsAlive() and not slot5:IsBoss() then
			slot5:SetDeathReason(slot1.UnitDeathReason.CLS)
			slot5:DeadAction()
		end
	end
end

slot8.SpawnColumnArea = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8)
	slot10 = slot0.Battle.BattleAOEData.New(slot9, slot2, slot6, slot8)

	slot10:SetPosition(slot3)
	slot10:SetRange(slot4)
	slot10:SetAreaType(slot1.AreaType.COLUMN)
	slot10:SetLifeTime(slot5)
	slot10:SetFieldType(slot1)
	slot10:SetOpponentAffected(not (slot7 or false))
	slot0:CreateAreaOfEffect(slot10)

	return slot10
end

slot8.SpawnCubeArea = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9)
	slot11 = slot0.Battle.BattleAOEData.New(slot10, slot2, slot7, slot9)

	slot11:SetPosition(slot3)
	slot11:SetWidth(slot4)
	slot11:SetHeight(slot5)
	slot11:SetAreaType(slot1.AreaType.CUBE)
	slot11:SetLifeTime(slot6)
	slot11:SetFieldType(slot1)
	slot11:SetOpponentAffected(not (slot8 or false))
	slot0:CreateAreaOfEffect(slot11)

	return slot11
end

slot8.SpawnLastingColumnArea = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10)
	slot12 = slot0.Battle.BattleLastingAOEData.New(slot11, slot2, slot6, slot7, slot10)

	slot12:SetPosition(slot3)
	slot12:SetRange(slot4)
	slot12:SetAreaType(slot1.AreaType.COLUMN)
	slot12:SetLifeTime(slot5)
	slot12:SetFieldType(slot1)
	slot12:SetOpponentAffected(not (slot8 or false))
	slot0:CreateAreaOfEffect(slot12)

	if slot9 and slot9 ~= "" then
		slot0:DispatchEvent(slot0.Event.New(slot2.ADD_AREA, {
			area = slot12,
			FXID = slot9
		}))
	end

	return slot12
end

slot8.SpawnLastingCubeArea = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11)
	slot13 = slot0.Battle.BattleLastingAOEData.New(slot12, slot2, slot7, slot8, slot11)

	slot13:SetPosition(slot3)
	slot13:SetWidth(slot4)
	slot13:SetHeight(slot5)
	slot13:SetAreaType(slot1.AreaType.CUBE)
	slot13:SetLifeTime(slot6)
	slot13:SetFieldType(slot1)
	slot13:SetOpponentAffected(not (slot9 or false))
	slot0:CreateAreaOfEffect(slot13)

	if slot10 and slot10 ~= "" then
		slot0:DispatchEvent(slot0.Event.New(slot2.ADD_AREA, {
			area = slot13,
			FXID = slot10
		}))
	end

	return slot13
end

slot8.SpawnTriggerColumnArea = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8)
	slot10 = slot0.Battle.BattleTriggerAOEData.New(slot9, slot2, slot8)

	slot10:SetPosition(slot3)
	slot10:SetRange(slot4)
	slot10:SetAreaType(slot1.AreaType.COLUMN)
	slot10:SetLifeTime(slot5)
	slot10:SetFieldType(slot1)
	slot10:SetOpponentAffected(not (slot6 or false))
	slot0:CreateAreaOfEffect(slot10)

	if slot7 and slot7 ~= "" then
		slot0:DispatchEvent(slot0.Event.New(slot2.ADD_AREA, {
			area = slot10,
			FXID = slot7
		}))
	end

	return slot10
end

slot8.SpawnAura = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot10 = slot0.Battle.BattleMobileAOEData.New(slot7, slot8, slot4, slot5, slot6, slot1)

	slot10:SetPosition(slot9)
	slot10:SetRange(slot3)
	slot10:SetAreaType(slot1.AreaType.COLUMN)
	slot10:SetLifeTime(0)
	slot10:SetFieldType(slot2)
	slot10:SetOpponentAffected(true)
	slot0:CreateAreaOfEffect(slot10)

	return slot10
end

slot8.CreateAreaOfEffect = function (slot0, slot1)
	slot0._AOEList[slot1:GetUniqueID()] = slot1

	slot0._cldSystem:InitAOECld(slot1)
	slot1:StartTimer()
end

slot8.RemoveAreaOfEffect = function (slot0, slot1)
	if not slot0._AOEList[slot1] then
		return
	end

	slot2:Dispose()

	slot0._AOEList[slot1] = nil

	slot0._cldSystem:DeleteAOECld(slot2)
	slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_AREA, {
		id = slot1
	}))
end

slot8.GetAOEList = function (slot0)
	return slot0._AOEList
end

slot8.GenerateAreaID = function (slot0)
	slot0._AOECount = slot0._AOECount + 1

	return slot0._AOECount
end

slot8.SpawnWall = function (slot0, slot1, slot2, slot3, slot4)
	slot6 = slot0.Battle.BattleWallData.New(slot5, slot1, slot2, slot3, slot4)
	slot0._wallList[slot0:GenerateWallID()] = slot6

	slot0._cldSystem:InitWallCld(slot6)

	return slot6
end

slot8.RemoveWall = function (slot0, slot1)
	slot0._wallList[slot1] = nil

	slot0._cldSystem:DeleteWallCld(slot0._wallList[slot1])
end

slot8.SpawnShelter = function (slot0, slot1, slot2)
	slot0._shelterList[slot0:GernerateShelterID()] = slot0.Battle.BattleShelterData.New(slot3)

	return slot0.Battle.BattleShelterData.New(slot3)
end

slot8.RemoveShelter = function (slot0, slot1)
	slot0:DispatchEvent(slot0.Event.New(slot1.REMOVE_SHELTER, {
		uid = slot1
	}))
	slot0._shelterList[slot1].Deactive(slot2)

	slot0._shelterList[slot1] = nil
end

slot8.GetWallList = function (slot0)
	return slot0._wallList
end

slot8.GenerateWallID = function (slot0)
	slot0._wallIndex = slot0._wallIndex + 1

	return slot0._wallIndex
end

slot8.GernerateShelterID = function (slot0)
	slot0._shelterIndex = slot0._shelterIndex + 1

	return slot0._shelterIndex
end

slot8.SpawnEnvironment = function (slot0, slot1)
	slot3 = slot0.Battle.BattleEnvironmentUnit.New(slot2, slot1.FOE_CODE)

	slot3:SetTemplate(slot1)

	slot4 = slot3:GetBehaviours()
	slot12 = nil

	slot3:SetAOEData((#slot1.cld_data ~= 1 or slot0.SpawnLastingColumnArea(slot0, slot1.field_type or slot2.BulletField.SURFACE, slot1.IFF or slot1.FOE_CODE, Vector3(slot1.coordinate[1], slot1.coordinate[2], slot1.coordinate[3]), slot1.cld_data[1], 0, function (slot0)
		slot1 = {}

		for slot5, slot6 in ipairs(slot0) do
			if slot6.Active and not slot0._unitList[slot6.UID]:IsSpectre() then
				table.insert(slot1, slot7)
			end
		end

		slot1:UpdateFrequentlyCollide(slot1)
	end, function ()
		return
	end, false, slot1.prefab, function ()
		return
	end)) and slot0:SpawnLastingCubeArea(slot1.field_type or slot2.BulletField.SURFACE, slot1.IFF or slot1.FOE_CODE, Vector3(slot1.coordinate[1], slot1.coordinate[2], slot1.coordinate[3]), slot1.cld_data[1], slot1.cld_data[2], 0, function (slot0)
		slot1 = 

		for slot5, slot6 in ipairs(slot0) do
			if slot6.Active and not slot0._unitList[slot6.UID].IsSpectre() then
				table.insert(slot1, slot7)
			end
		end

		slot1:UpdateFrequentlyCollide()
	end, function ()
		return
	end, false, slot1.prefab, function ()
		return
	end))

	slot0._environmentList[slot2] = slot3

	return slot3
end

slot8.RemoveEnvironment = function (slot0, slot1)
	slot0:RemoveAreaOfEffect(slot0._environmentList[slot1].GetAOEData(slot2):GetUniqueID())
	slot0._environmentList[slot1].Dispose(slot2)

	slot0._environmentList[slot1] = nil
end

slot8.DispatchWarning = function (slot0, slot1, slot2)
	slot0:DispatchEvent(slot0.Event.New(slot1.UPDATE_ENVIRONMENT_WARNING, {
		isActive = slot1
	}))
end

slot8.GetEnvironmentList = function (slot0)
	return slot0._environmentList
end

slot8.GernerateEnvironmentID = function (slot0)
	slot0._environmentIndex = slot0._environmentIndex + 1

	return slot0._environmentIndex
end

slot8.SpawnEffect = function (slot0, slot1, slot2, slot3)
	slot0:DispatchEvent(slot0.Event.New(slot1.ADD_EFFECT, {
		FXID = slot1,
		position = slot2,
		localScale = slot3
	}))
end

slot8.SpawnUIFX = function (slot0, slot1, slot2, slot3, slot4)
	slot0:DispatchEvent(slot0.Event.New(slot1.ADD_UI_FX, {
		FXID = slot1,
		position = slot2,
		localScale = slot3,
		orderDiff = slot4
	}))
end

slot8.SpawnCameraFX = function (slot0, slot1, slot2, slot3, slot4)
	slot0:DispatchEvent(slot0.Event.New(slot1.ADD_CAMERA_FX, {
		FXID = slot1,
		position = slot2,
		localScale = slot3,
		orderDiff = slot4
	}))
end

slot8.GetFriendlyCode = function (slot0)
	return slot0._friendlyCode
end

slot8.GetFoeCode = function (slot0)
	return slot0._foeCode
end

slot8.GetOppoSideCode = function (slot0)
	if slot0 == slot0.FRIENDLY_CODE then
		return slot0.FOE_CODE
	elseif slot0 == slot0.FOE_CODE then
		return slot0.FRIENDLY_CODE
	end
end

slot8.GetStatistics = function (slot0)
	return slot0._statistics
end

slot8.BlockManualCast = function (slot0, slot1)
	slot2 = (slot1 and 1) or -1

	for slot6, slot7 in pairs(slot0._fleetList) do
		slot7:SetWeaponBlock(slot2)
	end
end

slot8.JamManualCast = function (slot0, slot1)
	slot0:DispatchEvent(slot0.Event.New(slot1.JAMMING, {
		jammingFlag = slot1
	}))
end

slot8.SubmarineStrike = function (slot0, slot1)
	slot2 = slot0:GetFleetByIFF(slot1)
	slot3 = slot2:GetSubAidVO()

	if slot2:GetWeaponBlock() or slot3:GetCurrent() < 1 then
		return
	end

	for slot8, slot9 in ipairs(slot4) do
		slot0:InitAidUnitStatistics(slot0:SpawnSub(slot9, slot1))
	end

	slot2:SubWarcry()

	for slot9, slot10 in ipairs(slot5) do
		if slot9 == 1 then
			slot10:TriggerBuff(slot0.BuffEffectType.ON_SUB_LEADER)
		elseif slot9 == 2 then
			slot10:TriggerBuff(slot0.BuffEffectType.ON_UPPER_SUB_CONSORT)
		elseif slot9 == 3 then
			slot10:TriggerBuff(slot0.BuffEffectType.ON_LOWER_SUB_CONSORT)
		end
	end

	slot6 = slot5[1]

	slot3:Cast()
end

slot8.GetWaveFlags = function (slot0)
	return slot0._waveFlags
end

slot8.AddWaveFlag = function (slot0, slot1)
	if not slot1 then
		return
	end

	if table.contains(slot0:GetWaveFlags(), slot1) then
		return
	end

	table.insert(slot2, slot1)
end

slot8.RemoveFlag = function (slot0, slot1)
	if not slot1 then
		return
	end

	if not table.contains(slot0:GetWaveFlags(), slot1) then
		return
	end

	table.removebyvalue(slot2, slot1)
end

return

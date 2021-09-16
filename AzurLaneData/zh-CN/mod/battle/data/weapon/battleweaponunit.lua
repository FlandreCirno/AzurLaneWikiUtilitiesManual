ys = ys or {}
slot2 = ys.Battle.BattleConfig
slot3 = ys.Battle.BattleFormulas
slot4 = ys.Battle.BattleConst.WeaponSuppressType
slot5 = ys.Battle.BattleConst.WeaponSearchType
slot6 = ys.Battle.BattleDataFunction
slot7 = ys.Battle.BattleAttr
slot8 = class("BattleWeaponUnit")
ys.Battle.BattleWeaponUnit = slot8
slot8.__name = "BattleWeaponUnit"
slot8.INTERNAL = "internal"
slot8.EXTERNAL = "external"
slot8.EMITTER_NORMAL = "BattleBulletEmitter"
slot8.EMITTER_SHOTGUN = "BattleShotgunEmitter"
slot8.STATE_DISABLE = "DISABLE"
slot8.STATE_READY = "READY"
slot8.STATE_PRECAST = "PRECAST"
slot8.STATE_PRECAST_FINISH = "STATE_PRECAST_FINISH"
slot8.STATE_ATTACK = "ATTACK"
slot8.STATE_OVER_HEAT = "OVER_HEAT"

slot8.Ctor = function (slot0)
	slot0.EventDispatcher.AttachEventDispatcher(slot0)

	slot0._currentState = slot0.STATE_READY
	slot0._equipmentIndex = -1
	slot0._dataProxy = slot0.Battle.BattleDataProxy.GetInstance()
	slot0._tempEmittersList = {}
	slot0._dumpedEmittersList = {}
	slot0._reloadFacotrList = {}
	slot0._diveEnabled = true
	slot0._comboIDList = {}
	slot0._jammingTime = 0
	slot0._reloadBoostList = {}
	slot0._CLDCount = 0
	slot0._damageSum = 0
	slot0._CTSum = 0
	slot0._ACCSum = 0
end

slot8.HostOnEnemy = function (slot0)
	slot0._hostOnEnemy = true
end

slot8.SetPotentialFactor = function (slot0, slot1)
	slot0._potential = slot1

	if slot0._correctedDMG then
		slot0._correctedDMG = slot0:WeaponDamagePreCorrection()
	end
end

slot8.GetEquipmentLabel = function (slot0)
	return slot0._equipmentLabelList or {}
end

slot8.SetEquipmentLabel = function (slot0, slot1)
	slot0._equipmentLabelList = slot1
end

slot8.SetTemplateData = function (slot0, slot1)
	slot0._potential = slot0._potential or 1
	slot0._tmpData = slot1
	slot0._maxRangeSqr = slot1.range
	slot0._minRangeSqr = slot1.min_range
	slot0._fireFXFlag = slot1.fire_fx_loop_type
	slot0._oxyList = slot1.oxy_type
	slot0._bulletList = slot1.bullet_ID
	slot0._majorEmitterList = {}

	slot0:ShiftBarrage(slot1.barrage_ID)

	slot0._GCD = slot1.recover_time
	slot0._preCastInfo = slot1.precast_param
	slot0._correctedDMG = slot0:WeaponDamagePreCorrection()
	slot0._convertedAtkAttr = slot0:WeaponAtkAttrPreRatio()

	slot0:FlushReloadMax(1)
end

slot8.createMajorEmitter = function (slot0, slot1, slot2, slot3, slot4, slot5)
	function slot6(slot0, slot1, slot2, slot3, slot4)
		slot6 = slot0:Spawn(slot5, slot4, slot2.INTERNAL)

		slot6:SetOffsetPriority(slot3)
		slot6:SetShiftInfo(slot0, slot1)

		if slot0._tmpData.aim_type == slot3.WeaponAimType.AIM and slot4 ~= nil then
			slot6:SetRotateInfo(slot4:GetBeenAimedPosition(), slot0:GetBaseAngle(), slot2)
		else
			slot6:SetRotateInfo(nil, slot0:GetBaseAngle(), slot2)
		end

		slot0:DispatchBulletEvent(slot6)

		return slot6
	end

	slot0._majorEmitterList[#slot0._majorEmitterList + 1] = slot2.Battle[slot3 or slot0.EMITTER_NORMAL].New(slot4 or slot6, slot5 or function ()
		for slot3, slot4 in ipairs(slot0._majorEmitterList) do
			if slot4:GetState() ~= slot4.STATE_STOP then
				return
			end
		end

		slot0:EnterCoolDown()
	end, slot1)

	return slot2.Battle[slot3 or slot0.EMITTER_NORMAL].New(slot4 or slot6, slot5 or function ()
		for slot3, slot4 in ipairs(slot0._majorEmitterList) do
			if slot4.GetState() ~= slot4.STATE_STOP then
				return
			end
		end

		slot0.EnterCoolDown()
	end, slot1)
end

slot8.interruptAllEmitter = function (slot0)
	if slot0._majorEmitterList then
		for slot4, slot5 in ipairs(slot0._majorEmitterList) do
			slot5:Interrupt()
		end
	end

	for slot4, slot5 in ipairs(slot0._tempEmittersList) do
		for slot9, slot10 in ipairs(slot5) do
			slot10:Interrupt()
		end
	end

	for slot4, slot5 in ipairs(slot0._dumpedEmittersList) do
		for slot9, slot10 in ipairs(slot5) do
			slot10:Interrupt()
		end
	end
end

slot8.cacheSectorData = function (slot0)
	slot0._upperEdge = math.deg2Rad * slot0:GetAttackAngle() / 2
	slot0._lowerEdge = -1 * slot0._upperEdge
	slot2 = math.deg2Rad * slot0._tmpData.axis_angle

	if slot0:GetDirection() == slot0.UnitDir.LEFT then
		slot0._normalizeOffset = math.pi - slot2
	elseif slot0:GetDirection() == slot0.UnitDir.RIGHT then
		slot0._normalizeOffset = slot2
	end

	slot0._wholeCircle = math.pi - slot0._normalizeOffset
	slot0._negativeCircle = -math.pi - slot0._normalizeOffset
	slot0._wholeCircleNormalizeOffset = slot0._normalizeOffset - math.pi * 2
	slot0._negativeCircleNormalizeOffset = slot0._normalizeOffset + math.pi * 2
end

slot8.cacheSquareData = function (slot0)
	slot0._frontRange = slot0._tmpData.angle
	slot0._backRange = slot0._tmpData.axis_angle
	slot0._upperRange = slot0._tmpData.min_range
	slot0._lowerRange = slot0._tmpData.range
end

slot8.SetModelID = function (slot0, slot1)
	slot0._modelID = slot1
end

slot8.SetSkinData = function (slot0, slot1)
	slot0._skinID = slot1

	slot0:SetModelID(slot0.GetEquipSkin(slot0._skinID))
end

slot8.SetDerivateSkin = function (slot0, slot1)
	slot0._derivateSkinID = slot1
	slot2, slot0._derivateBullet, slot0._derivateTorpedo, slot0._derivateBoom = slot0.GetEquipSkin(slot0._derivateSkinID)
end

slot8.GetSkinID = function (slot0)
	return slot0._skinID
end

slot8.setBulletSkin = function (slot0, slot1, slot2)
	if slot0._derivateSkinID then
		if slot0.GetBulletTmpDataFromID(slot2).type == slot1.BulletType.BOMB then
			slot1:SetModleID(slot0._derivateBoom)
		elseif slot3 == slot1.BulletType.TORPEDO then
			slot1:SetModleID(slot0._derivateTorpedo)
		else
			slot1:SetModleID(slot0._derivateBullet)
		end
	elseif slot0._modelID then
		slot3 = 0

		if slot0._skinID then
			slot3 = slot0.GetEquipSkinDataFromID(slot0._skinID).mirror
		end

		slot1:SetModleID(slot0._modelID, slot3)
	end
end

slot8.SetSrcEquipmentID = function (slot0, slot1)
	slot0._srcEquipID = slot1
end

slot8.SetEquipmentIndex = function (slot0, slot1)
	slot0._equipmentIndex = slot1
end

slot8.GetEquipmentIndex = function (slot0)
	return slot0._equipmentIndex
end

slot8.SetHostData = function (slot0, slot1)
	slot0._host = slot1
	slot0._hostUnitType = slot0._host:GetUnitType()
	slot0._hostIFF = slot1:GetIFF()

	if slot0._tmpData.search_type == slot0.SECTOR then
		slot0:cacheSectorData()

		slot0.outOfFireRange = slot0.IsOutOfAngle
		slot0.IsOutOfFireArea = slot0.IsOutOfSector
	elseif slot0._tmpData.search_type == slot0.SQUARE then
		slot0:cacheSquareData()

		slot0.outOfFireRange = slot0.IsOutOfSquare
		slot0.IsOutOfFireArea = slot0.IsOutOfSquare
	end

	if slot0:GetDirection() == slot1.UnitDir.RIGHT then
		slot0._baseAngle = 0
	else
		slot0._baseAngle = 180
	end
end

slot8.SetStandHost = function (slot0, slot1)
	slot0._standHost = slot1
end

slot8.OverrideGCD = function (slot0, slot1)
	slot0._GCD = slot1
end

slot8.updateMovementInfo = function (slot0)
	slot0._hostPos = slot0._host:GetPosition()
end

slot8.GetWeaponId = function (slot0)
	return slot0._tmpData.id
end

slot8.GetTemplateData = function (slot0)
	return slot0._tmpData
end

slot8.GetType = function (slot0)
	return slot0._tmpData.type
end

slot8.GetPotential = function (slot0)
	return slot0._potential or 1
end

slot8.GetSrcEquipmentID = function (slot0)
	return slot0._srcEquipID
end

slot8.IsAttacking = function (slot0)
	return slot0._currentState == slot0.STATE_ATTACK or slot0._currentState == slot0.STATE_PRECAST
end

slot8.Update = function (slot0)
	slot0:UpdateReload()

	if not slot0._diveEnabled then
		return
	end

	if slot0._currentState == slot0.STATE_READY then
		slot0:updateMovementInfo()

		if slot0._tmpData.suppress == slot0.SUPPRESSION or slot0:CheckPreCast() then
			if slot0._preCastInfo.time == nil or not slot0._hostOnEnemy then
				slot0._currentState = slot0.STATE_PRECAST_FINISH
			else
				slot0:PreCast()
			end
		end
	end

	if slot0._currentState == slot0.STATE_PRECAST_FINISH then
		slot0:updateMovementInfo()
		slot0:Fire(slot0:Tracking())
	end
end

slot8.CheckReloadTimeStamp = function (slot0)
	return slot0._CDstartTime and slot0:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime()
end

slot8.UpdateReload = function (slot0)
	if slot0._CDstartTime and not slot0._jammingStartTime then
		if slot0:GetReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			slot0:handleCoolDown()
		else
			return
		end
	end
end

slot8.CheckPreCast = function (slot0)
	for slot4, slot5 in pairs(slot0:GetFilteredList()) do
		return true
	end

	return false
end

slot8.ChangeDiveState = function (slot0)
	if slot0._host:GetOxyState() then
		slot1 = slot0._host:GetOxyState():GetWeaponType()

		for slot5, slot6 in ipairs(slot0._oxyList) do
			if table.contains(slot1, slot6) then
				slot0._diveEnabled = true

				return
			end
		end

		slot0._diveEnabled = false
	end
end

slot8.getTrackingHost = function (slot0)
	return slot0._host
end

slot8.Tracking = function (slot0)
	if slot0.GetCurrent(slot0._host, "TargetChoise") == "farthest" then
		return slot0:TrackingFarthest(slot0:GetFilteredList())
	elseif slot1 == "leastHP" then
		return slot0:TrackingLeastHP(slot0:GetFilteredList())
	elseif type(slot1) == "number" and slot1 > 0 then
		return slot0:TrackingModelID(slot0:GetFilteredList(), slot1)
	elseif slot1 == 0 then
		return slot0:TrackingNearest(slot0:GetFilteredList())
	else
		return slot0:TrackingTag(slot0:GetFilteredList(), slot1)
	end
end

slot8.GetFilteredList = function (slot0)
	slot1 = slot0:FilterTarget()

	if slot0._tmpData.search_type == slot0.SECTOR then
		slot1 = slot0:FilterAngle(slot0:FilterRange(slot1))
	elseif slot0._tmpData.search_type == slot0.SQUARE then
		slot1 = slot0:FilterSquare(slot1)
	end

	return slot1
end

slot8.FixWeaponRange = function (slot0, slot1, slot2, slot3, slot4)
	slot0._maxRangeSqr = slot1 or slot0._tmpData.range
	slot0._minRangeSqr = slot3 or slot0._tmpData.min_range
	slot0._fixBulletRange = slot2
	slot0._bulletRangeOffset = slot4
end

slot8.GetFixBulletRange = function (slot0)
	return slot0._fixBulletRange, slot0._bulletRangeOffset
end

slot8.TrackingNearest = function (slot0, slot1)
	slot2 = slot0._maxRangeSqr
	slot3 = nil

	for slot7, slot8 in ipairs(slot1) do
		if slot0:getTrackingHost():GetDistance(slot8) <= slot2 then
			slot2 = slot9
			slot3 = slot8
		end
	end

	return slot3
end

slot8.TrackingFarthest = function (slot0, slot1)
	slot2 = 0
	slot3 = nil

	for slot7, slot8 in ipairs(slot1) do
		if slot2 < slot0:getTrackingHost():GetDistance(slot8) then
			slot2 = slot9
			slot3 = slot8
		end
	end

	return slot3
end

slot8.TrackingLeastHP = function (slot0, slot1)
	slot2 = math.huge
	slot3 = nil

	for slot7, slot8 in ipairs(slot1) do
		if slot8:GetCurrentHP() < slot2 then
			slot3 = slot8
			slot2 = slot9
		end
	end

	return slot3
end

slot8.TrackingModelID = function (slot0, slot1, slot2)
	slot3 = nil

	for slot7, slot8 in ipairs(slot1) do
		if slot8:GetTemplateID() == slot2 then
			slot3 = slot8
		end
	end

	return slot3
end

slot8.TrackingRandom = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot1) do
		table.insert(slot2, slot7)
	end

	slot3 = #slot2

	if #slot2 == 0 then
		return nil
	else
		return slot2[math.random(#slot2)]
	end
end

slot8.TrackingTag = function (slot0, slot1, slot2)
	slot3 = {}

	for slot7, slot8 in ipairs(slot1) do
		if slot8:ContainsLabelTag({
			slot2
		}) then
			table.insert(slot3, slot8)
		end
	end

	if #slot3 == 0 then
		return slot0:TrackingNearest(slot1)
	else
		return slot3[math.random(#slot3)]
	end
end

slot8.FilterTarget = function (slot0)
	slot1 = nil
	slot1 = (slot0._hostIFF ~= slot0._dataProxy:GetFriendlyCode() or slot0._dataProxy:GetFoeShipList()) and slot0._dataProxy:GetFriendlyShipList()
	slot2 = {}
	slot3 = 1
	slot4 = slot0._tmpData.search_condition

	for slot8, slot9 in pairs(slot1) do
		slot10 = slot9:GetCurrentOxyState()

		if slot0.IsCloak(slot9) then
		elseif not table.contains(slot4, slot10) then
		else
			slot12 = true

			if slot10 == slot1.OXY_STATE.FLOAT then
			elseif slot10 == slot1.OXY_STATE.DIVE and not slot9:IsRunMode() and not slot9:GetDiveDetected() and slot9:GetDiveInvisible() then
				slot12 = false
			end

			if slot12 then
				slot2[slot3] = slot9
				slot3 = slot3 + 1
			end
		end
	end

	return slot2
end

slot8.FilterAngle = function (slot0, slot1)
	if slot0:GetAttackAngle() >= 360 then
		return slot1
	end

	for slot5 = #slot1, 1, -1 do
		if slot0:IsOutOfAngle(slot1[slot5]) then
			table.remove(slot1, slot5)
		end
	end

	return slot1
end

slot8.FilterRange = function (slot0, slot1)
	for slot5 = #slot1, 1, -1 do
		if slot0:IsOutOfRange(slot1[slot5]) then
			table.remove(slot1, slot5)
		end
	end

	return slot1
end

slot8.FilterSquare = function (slot0, slot1)
	slot6 = slot0.Battle.BattleTargetChoise.TargetWeightiest(slot0._host, nil, slot5)

	for slot10 = #slot1, 1, -1 do
		if slot0:IsOutOfSquare(slot1[slot10]) then
			table.remove(slot1, slot10)
		end
	end

	for slot10 = #slot1, 1, -1 do
		if not table.contains(slot6, slot1[slot10]) then
			table.remove(slot1, slot10)
		end
	end

	return slot1
end

slot8.GetAttackAngle = function (slot0)
	return slot0._tmpData.angle
end

slot8.IsOutOfAngle = function (slot0, slot1)
	if slot0:GetAttackAngle() >= 360 then
		return false
	end

	if slot0._lowerEdge < ((slot0._wholeCircle < math.atan2(slot1:GetPosition().z - slot0._hostPos.z, slot1.GetPosition().x - slot0._hostPos.x) and slot3 + slot0._wholeCircleNormalizeOffset) or (slot3 < slot0._negativeCircle and slot3 + slot0._negativeCircleNormalizeOffset) or slot3 + slot0._normalizeOffset) and slot3 < slot0._upperEdge then
		return false
	else
		return true
	end
end

slot8.IsOutOfRange = function (slot0, slot1)
	return slot0._maxRangeSqr < slot0:getTrackingHost():GetDistance(slot1) or slot2 < slot0:GetMinimumRange()
end

slot8.IsOutOfSector = function (slot0, slot1)
	return slot0:IsOutOfRange(slot1) or slot0:IsOutOfAngle(slot1)
end

slot8.IsOutOfSquare = function (slot0, slot1)
	slot3 = false
	slot4 = (slot1:GetPosition().x - slot0._hostPos.x) * slot0:GetDirection()

	if slot0._backRange < 0 then
		if slot4 > 0 and slot4 <= slot0._frontRange and math.abs(slot0._backRange) <= slot4 then
			slot3 = true
		end
	elseif (slot4 > 0 and slot4 <= slot0._frontRange) or (slot4 < 0 and math.abs(slot4) < slot0._backRange) then
		slot3 = true
	end

	if not slot3 then
		return true
	else
		return false
	end
end

slot8.LockUnit = function (slot0, slot1)
	slot1:Tag(slot0)
end

slot8.UnlockUnit = function (slot0, slot1)
	slot1:UnTag(slot0)
end

slot8.GetLockRequiredTime = function (slot0)
	return 0
end

slot8.PreCast = function (slot0)
	slot0._currentState = slot0.STATE_PRECAST

	slot0:AddPreCastTimer()

	if slot0._preCastInfo.armor then
		slot0._precastArmor = slot0._preCastInfo.armor
	end

	slot0._host:SetWeaponPreCastBound(true)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.WEAPON_PRE_CAST, slot1))
end

slot8.Fire = function (slot0, slot1)
	if not slot0._host:IsCease() then
		slot0:DispatchGCD()

		slot0._currentState = slot0.STATE_ATTACK

		if slot0._tmpData.action_index == "" then
			slot0:DoAttack(slot1)
		else
			slot0:DispatchFireEvent(slot1, slot0._tmpData.action_index)
		end
	end

	return true
end

slot8.DoAttack = function (slot0, slot1)
	if slot1 == nil or not slot1:IsAlive() or slot0:outOfFireRange(slot1) then
		slot1 = nil
	end

	slot2 = slot0:GetDirection()
	slot3 = slot0:GetAttackAngle()

	slot0:cacheBulletID()
	slot0:TriggerBuffOnSteday()

	for slot7, slot8 in ipairs(slot0._majorEmitterList) do
		slot8:Ready()
	end

	for slot7, slot8 in ipairs(slot0._majorEmitterList) do
		slot8:Fire(slot1, slot2, slot3)
	end

	slot0._host:CloakExpose(slot0._tmpData.expose)
	slot0.Battle.PlayBattleSFX(slot0._tmpData.fire_sfx)
	slot0:TriggerBuffOnFire()
	slot0:CheckAndShake()
end

slot8.TriggerBuffOnSteday = function (slot0)
	slot0._host:TriggerBuff(slot0.BuffEffectType.ON_WEAPON_STEDAY, {
		equipIndex = slot0._equipmentIndex
	})
end

slot8.TriggerBuffOnFire = function (slot0)
	slot0._host:TriggerBuff(slot0.BuffEffectType.ON_FIRE, {
		equipIndex = slot0._equipmentIndex
	})
end

slot8.TriggerBuffOnReady = function (slot0)
	return
end

slot8.UpdateCombo = function (slot0, slot1)
	if slot0._hostUnitType ~= slot0.UnitType.PLAYER_UNIT or not slot0._host:IsAlive() then
		return
	end

	if #slot1 > 0 then
		slot2 = 0

		for slot6, slot7 in ipairs(slot1) do
			if table.contains(slot0._comboIDList, slot7) then
				slot2 = slot2 + 1
			end

			slot0._host:TriggerBuff(slot0.BuffEffectType.ON_COMBO, {
				equipIndex = slot0._equipmentIndex,
				matchUnitCount = slot2
			})

			break
		end

		slot0._comboIDList = slot1
	end
end

slot8.SingleFire = function (slot0, slot1, slot2, slot3, slot4)
	slot0._tempEmittersList[#slot0._tempEmittersList + 1] = {}

	if slot1 and slot1:IsAlive() then
	else
		slot1 = nil
	end

	slot2 = slot2 or slot0.EMITTER_NORMAL

	for slot9, slot10 in ipairs(slot0._barrageList) do
		function slot11(slot0, slot1, slot2, slot3)
			slot6 = slot1:Spawn(slot5, slot3, (slot0 and slot1._tmpData.bullet_ID) or slot1._bulletList.EXTERNAL)

			slot6:SetOffsetPriority(slot3)
			slot6:SetShiftInfo(slot0, slot1)

			if slot3 ~= nil then
				slot6:SetRotateInfo(slot3:GetBeenAimedPosition(), slot1:GetBaseAngle(), slot2)
			else
				slot6:SetRotateInfo(nil, slot1:GetBaseAngle(), slot2)
			end

			slot1:DispatchBulletEvent(slot6)
		end

		slot5[#slot5 + 1] = slot1.Battle[slot2].New(slot11, function ()
			for slot3, slot4 in ipairs(ipairs) do
				if slot4:GetState() ~= slot4.STATE_STOP then
					return
				end
			end

			for slot3, slot4 in ipairs(ipairs) do
				slot4:Destroy()
			end

			slot0 = nil

			for slot4, slot5 in ipairs(slot1._tempEmittersList) do
				if slot5 == slot0 then
					slot0 = slot4
				end
			end

			table.remove(slot1._tempEmittersList, slot0)

			slot0 = nil
			table.remove._fireFXFlag = slot1._tmpData.fire_fx_loop_type

			if slot1._tmpData.fire_fx_loop_type then
				slot2()
			end
		end, slot10)
	end

	for slot9, slot10 in ipairs(slot5) do
		slot10:Ready()
		slot10:Fire(slot1, slot0:GetDirection(), slot0:GetAttackAngle())
	end

	slot0._host:CloakExpose(slot0._tmpData.expose)
	slot0:CheckAndShake()
end

slot8.SetModifyInitialCD = function (slot0)
	slot0._modInitCD = true
end

slot8.GetModifyInitialCD = function (slot0)
	return slot0._modInitCD
end

slot8.InitialCD = function (slot0)
	if slot0._tmpData.initial_over_heat == 1 then
		slot0:AddCDTimer(slot0:GetReloadTime())
	end
end

slot8.EnterCoolDown = function (slot0)
	slot0._fireFXFlag = slot0._tmpData.fire_fx_loop_type

	slot0:AddCDTimer(slot0:GetReloadTime())
end

slot8.UpdatePrecastArmor = function (slot0, slot1)
	if slot0._currentState ~= slot0.STATE_PRECAST or not slot0._precastArmor then
		return
	end

	slot0._precastArmor = slot0._precastArmor + slot1

	if slot0._precastArmor <= 0 then
		slot0:Interrupt()
	end
end

slot8.Interrupt = function (slot0)
	slot0:DispatchEvent(slot2)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.WEAPON_INTERRUPT, slot1))
	slot0:RemovePrecastTimer()
	slot0:EnterCoolDown()
end

slot8.Cease = function (slot0)
	if slot0._currentState == slot0.STATE_ATTACK or slot0._currentState == slot0.STATE_PRECAST or slot0._currentState == slot0.STATE_PRECAST_FINISH then
		slot0:interruptAllEmitter()
		slot0:EnterCoolDown()
	end
end

slot8.AppendReloadBoost = function (slot0)
	return
end

slot8.DispatchGCD = function (slot0)
	if slot0._GCD > 0 then
		slot0._host:EnterGCD(slot0._GCD, slot0._tmpData.queue)
	end
end

slot8.Clear = function (slot0)
	slot0:RemovePrecastTimer()

	if slot0._majorEmitterList then
		for slot4, slot5 in ipairs(slot0._majorEmitterList) do
			slot5:Destroy()
		end
	end

	for slot4, slot5 in ipairs(slot0._tempEmittersList) do
		for slot9, slot10 in ipairs(slot5) do
			slot10:Destroy()
		end
	end

	for slot4, slot5 in ipairs(slot0._dumpedEmittersList) do
		for slot9, slot10 in ipairs(slot5) do
			slot10:Destroy()
		end
	end
end

slot8.Dispose = function (slot0)
	slot0.EventDispatcher.DetachEventDispatcher(slot0)
	slot0:RemovePrecastTimer()

	slot0._dataProxy = nil
end

slot8.AddCDTimer = function (slot0, slot1)
	slot0._currentState = slot0.STATE_OVER_HEAT
	slot0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	slot0._reloadRequire = slot1
end

slot8.handleCoolDown = function (slot0)
	slot0._currentState = slot0.STATE_READY
	slot0._CDstartTime = nil
	slot0._jammingTime = 0
end

slot8.OverHeat = function (slot0)
	slot0._currentState = slot0.STATE_OVER_HEAT
end

slot8.RemovePrecastTimer = function (slot0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._precastTimer)
	slot0._host:SetWeaponPreCastBound(false)

	slot0._precastArmor = nil
	slot0._precastTimer = nil
end

slot8.AddPreCastTimer = function (slot0)
	slot0._precastTimer = pg.TimeMgr.GetInstance().AddBattleTimer(slot2, "weaponPrecastTimer", 0, slot0._preCastInfo.time, function ()
		slot0._currentState = slot0.STATE_PRECAST_FINISH

		slot0:RemovePrecastTimer()
		slot0:DispatchEvent(slot0.Event.New(slot1.Battle.BattleUnitEvent.WEAPON_PRE_CAST_FINISH, slot0))
		slot0:Tracking()
	end, true)
end

slot8.Spawn = function (slot0, slot1, slot2)
	slot3 = nil
	slot4 = slot0._dataProxy:CreateBulletUnit(slot1, slot0._host, slot0, (slot2 ~= nil or Vector3.zero) and slot2:GetPosition())

	slot0:setBulletSkin(slot4, slot1)
	slot0:TriggerBuffWhenSpawn(slot4)

	return slot4
end

slot8.FixAmmo = function (slot0, slot1)
	slot0._fixedAmmo = slot1
end

slot8.GetFixAmmo = function (slot0)
	return slot0._fixedAmmo
end

slot8.ShiftBullet = function (slot0, slot1)
	slot2 = {}

	for slot6 = 1, #slot0._bulletList, 1 do
		slot2[slot6] = slot1
	end

	slot0._bulletList = slot2
end

slot8.RevertBullet = function (slot0)
	slot0._bulletList = slot0._tmpData.bullet_ID
end

slot8.cacheBulletID = function (slot0)
	slot0._emitBulletIDList = slot0._bulletList
end

slot8.ShiftBarrage = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._majorEmitterList) do
		table.insert(slot0._dumpedEmittersList, slot6)
	end

	slot0._majorEmitterList = {}

	if type(slot1) == "number" then
		slot2 = {}

		for slot6 = 1, #slot0._barrageList, 1 do
			slot2[slot6] = slot1
		end

		slot0._barrageList = slot2
	elseif type(slot1) == "table" then
		slot0._barrageList = slot1
	end

	for slot5, slot6 in ipairs(slot0._barrageList) do
		slot0:createMajorEmitter(slot6, slot5)
	end
end

slot8.RevertBarrage = function (slot0)
	slot0:ShiftBarrage(slot0._tmpData.barrage_ID)
end

slot8.GetPrimalAmmoType = function (slot0)
	return slot0.GetBulletTmpDataFromID(slot0._tmpData.bullet_ID[1]).ammo_type
end

slot8.TriggerBuffWhenSpawn = function (slot0, slot1, slot2)
	slot0._host:TriggerBuff(slot2 or slot0.BuffEffectType.ON_BULLET_CREATE, {
		_bullet = slot1,
		equipIndex = slot0._equipmentIndex
	})
end

slot8.DispatchBulletEvent = function (slot0, slot1, slot2)
	slot3 = slot2
	slot4 = slot0._tmpData
	slot5 = nil

	if slot0._fireFXFlag ~= 0 then
		slot5 = slot4.fire_fx

		if slot0._fireFXFlag ~= -1 then
			slot0._fireFXFlag = slot0._fireFXFlag - 1
		end
	end

	if type(slot4.spawn_bound) == "table" then
		slot3 = slot3 or ((not slot0._dataProxy:GetStageInfo().mainUnitPosition or not slot6[slot0._hostIFF] or Clone(slot6[slot0._hostIFF][slot4.spawn_bound[1]])) and Clone(slot0.MAIN_UNIT_POS[slot0._hostIFF][slot4.spawn_bound[1]]))

		slot0:DispatchEvent(slot1.Event.New(slot1.Battle.BattleUnitEvent.CREATE_BULLET, slot6))

		return
	end
end

slot8.DispatchFireEvent = function (slot0, slot1, slot2)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.FIRE, slot3))
end

slot8.CheckAndShake = function (slot0)
	if slot0._tmpData.shakescreen ~= 0 then
		slot0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[slot0._tmpData.shakescreen])
	end
end

slot8.GetBaseAngle = function (slot0)
	return slot0._baseAngle
end

slot8.GetHost = function (slot0)
	return slot0._host
end

slot8.GetStandHost = function (slot0)
	return slot0._standHost
end

slot8.GetPosition = function (slot0)
	return slot0._hostPos
end

slot8.GetDirection = function (slot0)
	return slot0._host:GetDirection()
end

slot8.GetCurrentState = function (slot0)
	return slot0._currentState
end

slot8.GetReloadTime = function (slot0)
	if slot0._reloadMax ~= slot0._cacheReloadMax or slot0._host:GetAttr().loadSpeed ~= slot0._cacheHostReload then
		slot0._cacheReloadMax = slot0._reloadMax
		slot0._cacheHostReload = slot0._host:GetAttr().loadSpeed
		slot0._cacheReloadTime = slot0.ReloadTime(slot0._reloadMax, slot0._host:GetAttr())
	end

	return slot0._cacheReloadTime
end

slot8.GetReloadFinishTimeStamp = function (slot0)
	slot1 = 0

	for slot5, slot6 in ipairs(slot0._reloadBoostList) do
		slot1 = slot1 + slot6
	end

	if slot1 ~= 0 then
		return slot0._reloadRequire + slot0._CDstartTime + slot0._jammingTime + ((slot1 >= 0 or math.max(slot1, (slot0._reloadRequire - (pg.TimeMgr.GetInstance():GetCombatTime() - slot0._jammingTime - slot0._CDstartTime)) * -1)) and math.min(slot1, pg.TimeMgr.GetInstance().GetCombatTime() - slot0._jammingTime - slot0._CDstartTime))
	end
end

slot8.AppendFactor = function (slot0, slot1)
	return
end

slot8.StartJamming = function (slot0)
	slot0._jammingStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

slot8.JammingEliminate = function (slot0)
	if not slot0._jammingStartTime then
		return
	end

	slot0._jammingTime = pg.TimeMgr.GetInstance():GetCombatTime() - slot0._jammingStartTime
	slot0._jammingStartTime = nil
end

slot8.FlushReloadMax = function (slot0, slot1)
	slot0._reloadMax = slot0._tmpData.reload_max * (slot1 or 1)
end

slot8.AppendReloadFactor = function (slot0, slot1, slot2)
	slot0._reloadFacotrList[slot1] = slot2
end

slot8.RemoveReloadFactor = function (slot0, slot1)
	if slot0._reloadFacotrList[slot1] then
		slot0._reloadFacotrList[slot1] = nil
	end
end

slot8.GetReloadFactorList = function (slot0)
	return slot0._reloadFacotrList
end

slot8.FlushReloadRequire = function (slot0)
	if not slot0._CDstartTime then
		return true
	end

	slot0._reloadRequire = pg.TimeMgr.GetInstance():GetCombatTime() - slot0._CDstartTime + slot0.ReloadTime(slot4, slot0._host:GetAttr())
end

slot8.GetMinimumRange = function (slot0)
	return slot0._minRangeSqr
end

slot8.GetCorrectedDMG = function (slot0)
	return slot0._correctedDMG
end

slot8.GetConvertedAtkAttr = function (slot0)
	return slot0._convertedAtkAttr
end

slot8.SetAtkAttrTrasnform = function (slot0, slot1, slot2, slot3)
	slot0._atkAttrTrans = slot1
	slot0._atkAttrTransA = slot2
	slot0._atkAttrTransB = slot3
end

slot8.GetAtkAttrTrasnform = function (slot0, slot1)
	slot2 = nil

	if slot0._atkAttrTrans then
		slot2 = math.min((slot1[slot0._atkAttrTrans] or 0) / slot0._atkAttrTransA, slot0._atkAttrTransB)
	end

	return slot2
end

slot8.IsReady = function (slot0)
	return slot0._currentState == slot0.STATE_READY
end

slot8.GetReloadRate = function (slot0)
	if slot0._currentState == slot0.STATE_READY then
		return 0
	elseif slot0._CDstartTime then
		return (slot0:GetReloadFinishTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()) / slot0._reloadRequire
	else
		return 1
	end
end

slot8.WeaponStatistics = function (slot0, slot1, slot2, slot3)
	slot0._CLDCount = slot0._CLDCount + 1
	slot0._damageSum = slot1 + slot0._damageSum

	if slot2 then
		slot0._CTSum = slot0._CTSum + 1
	end

	if not slot3 then
		slot0._ACCSum = slot0._ACCSum + 1
	end
end

slot8.GetDamageSUM = function (slot0)
	return slot0._damageSum
end

slot8.GetCTRate = function (slot0)
	return slot0._CTSum / slot0._CLDCount
end

slot8.GetACCRate = function (slot0)
	return slot0._ACCSum / slot0._CLDCount
end

return

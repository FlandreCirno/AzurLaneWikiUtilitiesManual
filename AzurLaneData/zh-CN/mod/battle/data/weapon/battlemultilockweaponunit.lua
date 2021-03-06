ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = class("BattleMultiLockWeaponUnit", ys.Battle.BattleWeaponUnit)
ys.Battle.BattleMultiLockWeaponUnit = slot2
slot2.__name = "BattleMultiLockWeaponUnit"

slot2.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot2.DispatchBlink = function (slot0, slot1)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CHARGE_WEAPON_FINISH, slot2))
end

slot2.RemoveAllLock = function (slot0)
	for slot4, slot5 in ipairs(slot0._lockList) do
		slot0:UnlockUnit(slot5)
	end

	slot0._lockList = {}

	if slot0._currentLockUnit ~= nil then
		slot0:UnlockUnit(slot0._currentLockUnit)
	end

	slot0._currentLockUnit = nil
end

slot2.SetTemplateData = function (slot0, slot1)
	slot0.super.SetTemplateData(slot0, slot1)

	slot0._maxLock = slot0._tmpData.charge_param.maxLock
	slot0._lockRequiredTime = slot0._tmpData.charge_param.lockTime
end

slot2.SetHostData = function (slot0, slot1)
	slot0.super.SetHostData(slot0, slot1)

	slot0._calibrationHost = slot0._host
end

slot2.createMajorEmitter = function (slot0, slot1, slot2)
	slot1.super.createMajorEmitter(slot0, slot1, slot2, slot1.EMITTER_NORMAL, function (slot0, slot1, slot2, slot3)
		slot0._lockList[#slot0._lockList] = nil

		if slot0._lockList[#slot0._lockList] == nil then
			return
		end

		slot6 = slot0:Spawn(slot5, slot4)

		slot6:SetOffsetPriority(slot3)
		slot6:SetShiftInfo(slot0, slot1)
		slot6:SetRotateInfo(slot4:GetPosition(), 0, 0)
		slot2.Battle.BattleVariable.AddExempt(slot6:GetSpeedExemptKey(), slot6:GetIFF(), slot2.Battle.BattleConfig.SPEED_FACTOR_FOCUS_CHARACTER)
		slot0:UnlockUnit(slot4)
		slot0:DispatchBulletEvent(slot6)
	end, function ()
		slot0:RemoveAllLock()
	end)
end

slot2.SetPlayerChargeWeaponVO = function (slot0, slot1)
	slot0._playerChargeWeaponVo = slot1
end

slot2.Charge = function (slot0)
	slot0._currentState = slot0.STATE_PRECAST
	slot0._lockList = {}

	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CHARGE_WEAPON_CHARGE, slot1))
end

slot2.CancelCharge = function (slot0)
	if slot0._currentState ~= slot0.STATE_PRECAST then
		return
	end

	slot0:RemoveAllLock()

	slot0._currentState = slot0.STATE_READY

	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CHARGE_WEAPON_CANCEL, slot1))
end

slot2.QuickTag = function (slot0)
	slot0._lockList = {}

	slot0:updateMovementInfo()

	slot1 = slot0:Tracking()

	while #slot0._lockList < slot0._maxLock and slot1 ~= nil do
		slot0._lockList[#slot0._lockList + 1] = slot1
		slot1 = slot0:Tracking()
	end
end

slot2.CancelQuickTag = function (slot0)
	slot0._lockList = {}
end

slot2.Update = function (slot0, slot1)
	if slot0._currentState ~= slot0.STATE_PRECAST then
		return
	end

	slot0:updateMovementInfo()
	slot0:UpdateLockList()

	if #slot0._lockList < slot0._maxLock then
		if slot0._currentLockUnit ~= nil then
			if slot0:IsOutOfAngle(slot0._currentLockUnit) or slot0:IsOutOfRange(slot0._currentLockUnit) or not slot0._currentLockUnit:IsAlive() then
				slot0:UnlockUnit(slot0._currentLockUnit)

				slot0._currentLockUnit = nil
				slot0._lockStartTime = nil
			elseif slot0._lockRequiredTime <= slot1 - slot0._lockStartTime then
				slot0._lockStartTime = nil
				slot0._lockList[#slot0._lockList + 1] = slot0._currentLockUnit
				slot0._currentLockUnit = nil
			end
		else
			if slot0:Tracking() == nil then
				return
			end

			slot0._currentLockUnit = slot2

			slot0:LockUnit(slot2)

			slot0._lockStartTime = slot1
		end
	end
end

slot2.UpdateLockList = function (slot0)
	for slot4, slot5 in ipairs(slot0._lockList) do
		if not slot5:IsAlive() then
			slot0:UnlockUnit(slot5)
			slot0.Battle.BattlePlayerWeaponVO.deleteElementFromArray(slot5, slot0._lockList)
		end
	end
end

slot2.DoAttack = function (slot0, slot1)
	slot0.Battle.PlayBattleSFX(slot0._tmpData.fire_sfx)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CHARGE_WEAPON_FIRE, {
		weapon = slot0
	}))

	slot3 = {}
	slot4 = #slot0._lockList

	while slot4 > 0 do
		slot3[#slot3 + 1] = slot0._lockList[slot4]
		slot4 = slot4 - 1
	end

	slot0._lockList = slot3

	for slot8, slot9 in ipairs(slot0._majorEmitterList) do
		slot9:Ready()
	end

	for slot8, slot9 in ipairs(slot0._majorEmitterList) do
		slot9:Fire(slot1, slot0:GetDirection(), slot0:GetAttackAngle())
		slot9:SetTimeScale(false)
	end

	slot0:EnterCoolDown()
	slot0:TriggerBuffOnFire()
	slot0.Battle.BattleCameraUtil.GetInstance():StartShake(pg.shake_template[slot1.ShakeType.FIRE])
end

slot2.Spawn = function (slot0, slot1, slot2)
	slot3 = nil

	slot0:TriggerBuffWhenSpawn(slot0._dataProxy:CreateBulletUnit(slot1, slot0._host, slot0, (slot2 ~= nil or ((slot0:TrackingRandom(slot0:GetFilteredList()) ~= nil or Vector3.zero) and slot2:GetPosition())) and slot2:GetPosition()))

	return slot0._dataProxy.CreateBulletUnit(slot1, slot0._host, slot0, (slot2 ~= nil or ((slot0.TrackingRandom(slot0.GetFilteredList()) ~= nil or Vector3.zero) and slot2.GetPosition())) and slot2.GetPosition())
end

slot2.TriggerBuffOnFire = function (slot0)
	slot0._host:TriggerBuff(slot0.BuffEffectType.ON_CHARGE_FIRE, {})
end

slot2.InitialCD = function (slot0)
	slot0.super.InitialCD(slot0)
	slot0._playerChargeWeaponVo:Deduct(slot0)
end

slot2.EnterCoolDown = function (slot0)
	slot0.super.EnterCoolDown(slot0)
	slot0._playerChargeWeaponVo:Deduct(slot0)
end

slot2.GetLockRequiredTime = function (slot0)
	return slot0._lockRequiredTime
end

slot2.GetMinAngle = function (slot0)
	return slot0:GetAttackAngle()
end

slot2.GetLockList = function (slot0)
	return slot0._lockList
end

slot2.GetFilteredList = function (slot0)
	return slot0:filterEnemyUnitType(slot0:filterTagCount(slot0.super.GetFilteredList(slot0)))
end

slot2.filterTagCount = function (slot0, slot1)
	slot2 = {}
	slot3 = slot0._maxLock

	for slot7, slot8 in ipairs(slot1) do
		if slot8:GetSingleWeaponTagCount(slot0) < slot3 then
			slot3 = slot9
		elseif slot9 == slot3 then
			slot2[#slot2 + 1] = slot8
		end
	end

	return slot2
end

slot2.filterEnemyUnitType = function (slot0, slot1)
	slot2 = {}
	slot3 = {}
	slot4 = 0

	for slot8, slot9 in ipairs(slot1) do
		if slot9:GetTemplate().battle_unit_type == nil then
			slot3[#slot3 + 1] = slot9
		elseif slot4 < slot10 then
			slot4 = slot10
		elseif slot4 == slot10 then
			slot2[#slot2 + 1] = slot9
		end
	end

	for slot8, slot9 in ipairs(slot3) do
		slot2[#slot2 + 1] = slot9
	end

	return slot2
end

slot2.AddCDTimer = function (slot0, slot1)
	slot0.RemoveCDTimer(slot0)

	slot0._currentState = slot0.STATE_OVER_HEAT
	slot0._cdTimer = pg.TimeMgr.GetInstance():AddBattleTimer("weaponTimer", 0, slot1, function ()
		slot0._currentState = slot0.STATE_READY

		slot0._playerChargeWeaponVo:Plus(slot0._playerChargeWeaponVo.Plus)
		slot0._playerChargeWeaponVo.Plus:RemoveCDTimer()

		slot0._playerChargeWeaponVo.Plus.RemoveCDTimer._CDstartTime = nil
	end, true)
	slot0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	slot0._CDReloadTime = slot1
end

slot2.QuickCoolDown = function (slot0)
	if slot0._currentState == slot0.STATE_OVER_HEAT then
		slot0._currentState = slot0.STATE_READY

		slot0._playerChargeWeaponVo:PlusAndFirst(slot0)
		slot0:RemoveCDTimer()

		slot0._CDstartTime = nil
	end
end

slot2.getTrackingHost = function (slot0)
	return slot0._calibrationHost
end

slot2.SetCalibrationHost = function (slot0, slot1)
	slot0._calibrationHost = slot1
end

slot2.updateMovementInfo = function (slot0)
	slot0._hostPos = slot0._calibrationHost:GetPosition()
end

slot2.GetMinimumRange = function (slot0)
	if slot0._calibrationHost ~= slot0._host then
		return 0
	else
		return slot0.super.GetMinimumRange(slot0)
	end
end

return

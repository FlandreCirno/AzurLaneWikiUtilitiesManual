ys = ys or {}
slot1 = ys.Battle.BattleBulletEvent
slot2 = ys.Battle.BattleFormulas
slot3 = Vector3.up
slot4 = ys.Battle.BattleVariable
slot6 = ys.Battle.BattleTargetChoise
slot8 = 1 / ys.Battle.BattleConfig.viewFPS
slot9 = ys.Battle.BattleConst
ys.Battle.BattleBulletUnit = class("BattleBulletUnit")
ys.Battle.BattleBulletUnit.__name = "BattleBulletUnit"
ys.Battle.BattleBulletUnit.ACC_INTERVAL = ys.Battle.BattleConfig.calcInterval
ys.Battle.BattleBulletUnit.TRACKER_ANGLE = math.cos(math.deg2Rad * 10)
ys.Battle.BattleBulletUnit.MIRROR_RES = "_mirror"

ys.Battle.BattleBulletUnit.doAccelerate = function (slot0, slot1)
	slot2, slot3 = slot0:GetAcceleration(slot1)

	if slot2 == 0 and slot3 == 0 then
		return
	end

	if slot2 < 0 and slot0._speedLength + slot2 < 0 then
		slot0:reverseAcceleration()
	end

	slot0._speed:Set(slot0._speed.x + slot0._speedNormal.x * slot2 + slot0._speedCross.x * slot3, slot0._speed.y + slot0._speedNormal.y * slot2 + slot0._speedCross.y * slot3, slot0._speed.z + slot0._speedNormal.z * slot2 + slot0._speedCross.z * slot3)

	slot0._speedLength = slot0._speed:Magnitude()

	if slot0._speedLength ~= 0 then
		slot0._speedNormal:Copy(slot0._speed):Div(slot0._speedLength)
	end

	slot0._speedCross:Copy(slot0._speedNormal):Cross2(slot0)
end

ys.Battle.BattleBulletUnit.doTrack = function (slot0)
	if slot0:getTrackingTarget() == nil and slot0:TargetHarmNearest()[1] ~= nil and slot0:GetDistance(slot1) <= slot0._trackRange then
		slot0:setTrackingTarget(slot1)
	end

	if slot0:getTrackingTarget() == nil or slot1 == -1 then
		return
	elseif not slot1:IsAlive() then
		slot0:setTrackingTarget(-1)

		return
	elseif slot0._trackRange < slot0:GetDistance(slot1) then
		slot0:setTrackingTarget(-1)

		return
	end

	if not slot1:GetBeenAimedPosition() then
		return
	end

	slot2 - slot0:GetPosition().SetNormalize(slot3)

	slot4 = Vector3.Normalize(slot0._speed)
	slot6 = slot4.z * slot2 - slot0.GetPosition().x - slot4.x * slot2 - slot0.GetPosition().z

	if slot1.TRACKER_ANGLE <= Vector3.Dot(slot4, slot3) then
		return
	end

	slot9 = math.sin(slot0._sinAngularSpeed * slot0:GetSpeedRatio())
	slot10 = slot5
	slot11 = slot6

	if slot5 < math.cos(slot0._cosAngularSpeed * slot0.GetSpeedRatio()) then
		slot10 = slot8
		slot11 = slot9 * ((slot11 >= 0 and 1) or -1)
	end

	slot0._speed:Set(slot0._speed.x * slot10 + slot0._speed.z * slot11, 0, slot0._speed.z * slot10 - slot0._speed.x * slot11)
end

ys.Battle.BattleBulletUnit.doOrbit = function (slot0)
	slot5 = nil
	slot0._speed = (pg.Tool.FilterY(slot0:GetPosition()) - pg.Tool.FilterY(slot0._weapon:GetPosition()).magnitude <= 10 or pg.Tool.FilterY(slot0._weapon:GetPosition()) - pg.Tool.FilterY(slot0:GetPosition()).normalized + slot0._speed.normalized.normalized) and Vector3(-pg.Tool.FilterY(slot0._weapon.GetPosition()) - pg.Tool.FilterY(slot0.GetPosition()).normalized.z, 0, pg.Tool.FilterY(slot0._weapon.GetPosition()) - pg.Tool.FilterY(slot0.GetPosition()).normalized.x) + slot0._speed.normalized.normalized
end

ys.Battle.BattleBulletUnit.RotateY = function (slot0, slot1)
	return Vector3(slot0.x * math.cos(slot1) + slot0.z * math.sin(slot1), slot0.y, slot0.z * math.cos(slot1) - slot0.x * math.sin(slot1))
end

ys.Battle.BattleBulletUnit.doCircle = function (slot0)
	if not slot0._originPos then
		return
	end

	slot3 = slot0._convertedVelocity
	slot0._inverseFlag = (pg.Tool.FilterY(slot0._position - slot0._originPos).Magnitude(slot2) - slot0._centripetalSpeed * slot0:GetSpeedRatio() * (1 + slot0.Battle.BattleAttr.GetCurrent(slot0, "bulletSpeedRatio")) * slot0._inverseFlag < 0 and -slot0._inverseFlag) or slot0._inverseFlag

	if slot4 <= 1e-05 then
		return
	end

	slot0._speed = slot0.RotateY(slot2, slot3 / slot4).Mul((slot0._circleAntiClockwise and 1) or -1, slot5 / slot4):Sub(slot2)
end

ys.Battle.BattleBulletUnit.doNothing = function (slot0)
	if slot0._gravity ~= 0 then
		slot0._verticalSpeed = slot0._verticalSpeed + slot0._gravity * slot0:GetSpeedRatio()
	end
end

ys.Battle.BattleBulletUnit.Ctor = function (slot0, slot1, slot2)
	slot0.EventDispatcher.AttachEventDispatcher(slot0)

	slot0._battleProxy = slot0.Battle.BattleDataProxy.GetInstance()
	slot0._uniqueID = slot1
	slot0._speedExemptKey = "bullet_" .. slot1
	slot0._IFF = slot2
	slot0._collidedList = {}
	slot0._speed = Vector3.zero
	slot0._exist = true
	slot0._timeStamp = 0
	slot0._dmgEnhanceRate = 1
	slot0._frame = 0
	slot0._reachDestFlag = false
	slot0._verticalSpeed = 0
	slot0._damageList = {}
end

ys.Battle.BattleBulletUnit.Update = function (slot0, slot1)
	slot2 = slot0:GetSpeedRatio()

	slot0:updateSpeed(slot1)
	slot0:updateBarrageTransform(slot1)
	slot0._position:Set(slot0._position.x + slot0._speed.x * slot2, slot0._position.y + slot0._speed.y * slot2, slot0._position.z + slot0._speed.z * slot2)

	slot0._position.y = slot0._position.y + slot0._verticalSpeed * slot2

	if slot0._gravity == 0 then
		slot0._reachDestFlag = slot0._sqrRange < Vector3.SqrDistance(slot0._spawnPos, slot0._position)
	else
		if slot0._fieldSwitchHeight ~= 0 and slot0._position.y <= slot0._fieldSwitchHeight then
			slot0._field = slot0.BulletField.SURFACE
		end

		slot0._reachDestFlag = slot0._position.y <= slot1.BombDetonateHeight
	end
end

ys.Battle.BattleBulletUnit.ActiveCldBox = function (slot0)
	slot0._cldComponent:SetActive(true)
end

ys.Battle.BattleBulletUnit.DeactiveCldBox = function (slot0)
	slot0._cldComponent:SetActive(false)
end

ys.Battle.BattleBulletUnit.SetStartTimeStamp = function (slot0, slot1)
	slot0._timeStamp = slot1
end

ys.Battle.BattleBulletUnit.Hit = function (slot0, slot1, slot2)
	slot0._collidedList[slot1] = true

	slot0:DispatchEvent(slot0.Event.New(slot1.HIT, {
		UID = slot1,
		type = slot2
	}))
end

ys.Battle.BattleBulletUnit.Intercepted = function (slot0)
	slot0:DispatchEvent(slot0.Event.New(slot1.INTERCEPTED, {}))
end

ys.Battle.BattleBulletUnit.Reflected = function (slot0)
	slot0._speed.x = -slot0._speed.x
end

ys.Battle.BattleBulletUnit.ResetVelocity = function (slot0, slot1)
	slot2 = slot0._tempData
	slot3 = slot0:GetTemplate().extra_param

	if not slot1 then
		slot1 = slot2.velocity

		if slot3.velocity_offset then
			slot1 = math.random(slot1 - slot3.velocity_offset, slot1 + slot3.velocity_offset)
		elseif slot3.velocity_offsetF then
			slot1 = (slot1 + math.random() * 2 * slot3.velocity_offsetF) - slot3.velocity_offsetF
		end
	end

	slot0._velocity = slot1
	slot0._convertedVelocity = slot0.ConvertBulletSpeed(slot0._velocity)
end

ys.Battle.BattleBulletUnit.SetTemplateData = function (slot0, slot1)
	slot0._tempData = setmetatable({}, {
		__index = slot1
	})

	slot0:SetModleID(slot1.modle_ID, slot0.ORIGNAL_RES)
	slot0:ResetVelocity()

	slot0._pierceCount = slot1.pierce_count

	slot0:FixRange()
	slot0:InitCldComponent()

	slot0._accTable = Clone(slot0._tempData.acceleration)

	table.sort(slot0._accTable, function (slot0, slot1)
		return slot0.t < slot1.t
	end)

	slot0._field = slot1.effect_type
	slot0._gravity = slot0:GetTemplate().extra_param.gravity or 0
	slot0._fieldSwitchHeight = slot2.effectSwitchHeight or 0
	slot0._ignoreShield = slot0._tempData.extra_param.ignoreShield == true

	slot0.SetDiverFilter(slot0)
end

ys.Battle.BattleBulletUnit.GetModleID = function (slot0)
	slot2 = nil

	return (slot0._IFF ~= slot0.FOE_CODE or (slot0._mirrorSkin == slot0:GetTemplate().extra_param.MIRROR_SKIN_RES and slot0._modleID .. slot0.GetTemplate().extra_param.MIRROR_RES) or (slot0._mirrorSkin == slot0.GetTemplate().extra_param.ORIGNAL_RES and slot0.GetTemplate().extra_param.mirror == true and slot0._modleID .. slot0.GetTemplate().extra_param.MIRROR_RES) or slot0._modleID) and slot0._modleID
end

ys.Battle.BattleBulletUnit.ORIGNAL_RES = -1
ys.Battle.BattleBulletUnit.SKIN_RES = 0
ys.Battle.BattleBulletUnit.MIRROR_SKIN_RES = 1

ys.Battle.BattleBulletUnit.SetModleID = function (slot0, slot1, slot2)
	slot0._modleID = slot1
	slot0._mirrorSkin = slot2
end

ys.Battle.BattleBulletUnit.SetShiftInfo = function (slot0, slot1, slot2)
	slot3 = 0
	slot4 = 0

	if slot0:GetTemplate().extra_param.randomLaunchOffsetX then
		slot3 = math.random() * slot5.randomLaunchOffsetX * 2 - slot5.randomLaunchOffsetX
	end

	if slot5.randomLaunchOffsetZ then
		slot4 = math.random() * slot5.randomLaunchOffsetZ * 2 - slot5.randomLaunchOffsetZ
	end

	slot0._offsetX = slot1 + slot3
	slot0._offsetZ = slot2 + slot4
end

ys.Battle.BattleBulletUnit.SetRotateInfo = function (slot0, slot1, slot2, slot3)
	slot0._targetPos = slot1
	slot0._baseAngle = slot2
	slot0._barrageAngle = slot3

	if slot0._barrageAngle % 360 > 0 and slot4 < 180 then
		for slot8, slot9 in ipairs(slot0._accTable) do
			if slot9.flip then
				slot9.v = slot9.v * -1
			end
		end
	end
end

ys.Battle.BattleBulletUnit.SetBarrageTransformTempate = function (slot0, slot1)
	if #slot1 > 0 then
		slot0._barrageTransData = slot1
	end
end

ys.Battle.BattleBulletUnit.SetAttr = function (slot0, slot1)
	slot0.Battle.BattleAttr.SetAttr(slot0, slot1)
end

ys.Battle.BattleBulletUnit.GetAttr = function (slot0)
	return slot0.Battle.BattleAttr.GetAttr(slot0)
end

ys.Battle.BattleBulletUnit.SetStandHostAttr = function (slot0, slot1)
	slot0._standUnit = {}

	slot0.Battle.BattleAttr.SetAttr(slot0._standUnit, slot1)
end

ys.Battle.BattleBulletUnit.GetWeaponHostAttr = function (slot0)
	if slot0._standUnit then
		return slot0.Battle.BattleAttr.GetAttr(slot0._standUnit)
	else
		return slot0:GetAttr()
	end
end

ys.Battle.BattleBulletUnit.GetWeaponAtkAttr = function (slot0)
	slot2 = nil

	return (slot0._weapon:GetAtkAttrTrasnform(slot0:GetWeaponHostAttr()) and slot3) or slot0.Battle.BattleAttr.GetAtkAttrByType(slot1, slot0:GetWeaponTempData().attack_attribute)
end

ys.Battle.BattleBulletUnit.SetDamageEnhance = function (slot0, slot1)
	slot0._dmgEnhanceRate = slot1
end

ys.Battle.BattleBulletUnit.GetDamageEnhance = function (slot0)
	return slot0._dmgEnhanceRate
end

ys.Battle.BattleBulletUnit.GetAttrByName = function (slot0, slot1)
	return slot0.Battle.BattleAttr.GetCurrent(slot0, slot1)
end

ys.Battle.BattleBulletUnit.GetVerticalSpeed = function (slot0)
	return slot0._verticalSpeed
end

ys.Battle.BattleBulletUnit.IsGravitate = function (slot0)
	return slot0._gravity ~= 0
end

ys.Battle.BattleBulletUnit.SetBuffTrigger = function (slot0, slot1)
	slot0._host = slot1
	slot0._buffTriggerFun = {}
end

ys.Battle.BattleBulletUnit.SetBuffFun = function (slot0, slot1, slot2)
	slot0._buffTriggerFun[slot1] or {}[#(slot0._buffTriggerFun[slot1] or ) + 1] = slot2
	slot0._buffTriggerFun[slot1] = slot0._buffTriggerFun[slot1] or 
end

ys.Battle.BattleBulletUnit.BuffTrigger = function (slot0, slot1, slot2)
	if slot0._host and slot3:IsAlive() then
		slot0._host:TriggerBuff(slot1, slot2)

		if slot0._buffTriggerFun[slot1] then
			for slot8, slot9 in ipairs(slot4) do
				slot9(slot0._host, slot2)
			end
		end
	end
end

ys.Battle.BattleBulletUnit.SetIsCld = function (slot0, slot1)
	slot0._needCld = slot1
end

ys.Battle.BattleBulletUnit.GetIsCld = function (slot0)
	return slot0._needCld
end

ys.Battle.BattleBulletUnit.AppendDamageUnit = function (slot0, slot1)
	slot0._damageList[#slot0._damageList + 1] = slot1
end

ys.Battle.BattleBulletUnit.DamageUnitListWriteback = function (slot0)
	slot0._weapon:UpdateCombo(slot0._damageList)
end

ys.Battle.BattleBulletUnit.HasAcceleration = function (slot0)
	return #slot0._accTable ~= 0
end

ys.Battle.BattleBulletUnit.IsTracker = function (slot0)
	return slot0._accTable.tracker
end

ys.Battle.BattleBulletUnit.IsOrbit = function (slot0)
	return slot0._accTable.orbit
end

ys.Battle.BattleBulletUnit.IsCircle = function (slot0)
	return slot0._accTable.circle
end

ys.Battle.BattleBulletUnit.GetAcceleration = function (slot0, slot1)
	slot0._lastAccTime = slot0._lastAccTime or slot0._timeStamp
	slot0._lastAccTime = slot0._lastAccTime + slot0.ACC_INTERVAL * math.modf((slot1 - slot0._lastAccTime) / slot0.ACC_INTERVAL)
	slot3 = slot1 - slot0._timeStamp
	slot4 = #slot0._accTable

	while slot4 > 0 do
		if slot3 + slot0.ACC_INTERVAL < slot0._accTable[slot4].t then
			slot4 = slot4 - 1
		else
			return slot5.u * slot2, slot5.v * slot2
		end
	end

	return 0, 0
end

ys.Battle.BattleBulletUnit.reverseAcceleration = function (slot0)
	for slot4, slot5 in ipairs(slot0._accTable) do
		slot5.u = slot5.u * -1
	end
end

ys.Battle.BattleBulletUnit.GetDistance = function (slot0, slot1)
	if slot0._frame ~= slot0._battleProxy.FrameIndex then
		slot0._distanceBackup = {}
		slot0._frame = slot2
	end

	if slot0._distanceBackup[slot1] == nil then
		slot0._distanceBackup[slot1] = Vector3.Distance(slot0:GetPosition(), slot1:GetPosition())

		slot1:backupDistance(slot0, Vector3.Distance(slot0.GetPosition(), slot1.GetPosition()))
	end

	return slot3
end

ys.Battle.BattleBulletUnit.backupDistance = function (slot0, slot1, slot2)
	if slot0._frame ~= slot0._battleProxy.FrameIndex then
		slot0._distanceBackup = {}
		slot0._frame = slot3
	end

	slot0._distanceBackup[slot1] = slot2
end

ys.Battle.BattleBulletUnit.getTrackingTarget = function (slot0)
	return slot0._tarckingTarget
end

ys.Battle.BattleBulletUnit.setTrackingTarget = function (slot0, slot1)
	slot0._tarckingTarget = slot1
end

ys.Battle.BattleBulletUnit.SetWeapon = function (slot0, slot1)
	slot0._weapon = slot1

	if slot1 then
		slot0._correctedDMG = slot0._weapon:GetCorrectedDMG()
	end
end

ys.Battle.BattleBulletUnit.GetWeapon = function (slot0)
	return slot0._weapon
end

ys.Battle.BattleBulletUnit.GetCorrectedDMG = function (slot0)
	return slot0._correctedDMG
end

ys.Battle.BattleBulletUnit.OverrideCorrectedDMG = function (slot0, slot1)
	slot0._correctedDMG = slot0.WeaponDamagePreCorrection(slot0._weapon, slot1)
end

ys.Battle.BattleBulletUnit.GetWeaponTempData = function (slot0)
	return slot0._weapon:GetTemplateData()
end

ys.Battle.BattleBulletUnit.GetPosition = function (slot0)
	return slot0._position or Vector3.zero
end

ys.Battle.BattleBulletUnit.SetSpawnPosition = function (slot0, slot1)
	slot0._spawnPos = slot1
	slot0._position = slot1:Clone()

	if slot0._gravity ~= 0 then
		if math.atan2(slot0._speed.x, slot0._speed.z) == 0 then
			slot0._verticalSpeed = 0
		else
			slot3 = Vector3(math.cos(slot2) * 60, math.sin(slot2) * 60)
			slot0._verticalSpeed = -0.5 * slot0._gravity * 60 / slot0._convertedVelocity
		end
	end
end

ys.Battle.BattleBulletUnit.GetSpawnPosition = function (slot0)
	return slot0._spawnPos
end

ys.Battle.BattleBulletUnit.GetTemplate = function (slot0)
	return slot0._tempData
end

ys.Battle.BattleBulletUnit.GetType = function (slot0)
	return slot0._tempData.type
end

ys.Battle.BattleBulletUnit.GetOutBound = function (slot0)
	return slot0._tempData.out_bound
end

ys.Battle.BattleBulletUnit.GetUniqueID = function (slot0)
	return slot0._uniqueID
end

ys.Battle.BattleBulletUnit.GetOffset = function (slot0)
	return slot0._offsetX, slot0._offsetZ, slot0._isOffsetPriority
end

ys.Battle.BattleBulletUnit.GetRotateInfo = function (slot0)
	return slot0._targetPos, slot0._baseAngle, slot0._barrageAngle
end

ys.Battle.BattleBulletUnit.IsOutRange = function (slot0)
	return slot0._reachDestFlag
end

ys.Battle.BattleBulletUnit.SetYAngle = function (slot0, slot1)
	slot0._yAngle = slot1
end

ys.Battle.BattleBulletUnit.SetOffsetPriority = function (slot0, slot1)
	slot0._isOffsetPriority = slot1 or false
end

ys.Battle.BattleBulletUnit.GetOffsetPriority = function (slot0)
	return slot0._isOffsetPriority
end

ys.Battle.BattleBulletUnit.GetYAngle = function (slot0)
	return slot0._yAngle
end

ys.Battle.BattleBulletUnit.GetCurrentYAngle = function (slot0)
	slot2 = math.acos(Vector3.Normalize(slot0._speed).x) / math.deg2Rad

	if Vector3.Normalize(slot0._speed).z < 0 then
		slot2 = 360 - slot2
	end

	return slot2
end

ys.Battle.BattleBulletUnit.GetIFF = function (slot0)
	return slot0._IFF
end

ys.Battle.BattleBulletUnit.GetHost = function (slot0)
	return slot0._host
end

ys.Battle.BattleBulletUnit.GetPierceCount = function (slot0)
	return slot0._pierceCount
end

ys.Battle.BattleBulletUnit.AppendAttachBuff = function (slot0, slot1)
	slot2 = Clone(slot0:GetTemplate().attach_buff)
	slot2[#slot2 + 1] = slot1
	slot0._attachBuffList = slot2
end

ys.Battle.BattleBulletUnit.GetAttachBuff = function (slot0)
	return slot0._attachBuffList or slot0:GetTemplate().attach_buff or {}
end

ys.Battle.BattleBulletUnit.GetEffectField = function (slot0)
	return slot0._field
end

ys.Battle.BattleBulletUnit.SetDiverFilter = function (slot0, slot1)
	if slot1 == nil then
		slot0._diveFilter = slot0._tempData.extra_param.diveFilter or {
			2
		}
	else
		slot0._diveFilter = slot1
	end
end

ys.Battle.BattleBulletUnit.GetDiveFilter = function (slot0)
	return slot0._diveFilter
end

ys.Battle.BattleBulletUnit.GetVelocity = function (slot0)
	return slot0._velocity
end

ys.Battle.BattleBulletUnit.GetConvertedVelocity = function (slot0)
	return slot0._convertedVelocity
end

ys.Battle.BattleBulletUnit.GetSpeedExemptKey = function (slot0)
	return slot0._speedExemptKey
end

ys.Battle.BattleBulletUnit.IsCollided = function (slot0, slot1)
	return slot0._collidedList[slot1]
end

ys.Battle.BattleBulletUnit.GetExist = function (slot0)
	return slot0._exist
end

ys.Battle.BattleBulletUnit.SetExist = function (slot0, slot1)
	slot0._exist = slot1
end

ys.Battle.BattleBulletUnit.GetIgnoreShield = function (slot0)
	return slot0._ignoreShield
end

ys.Battle.BattleBulletUnit.Dispose = function (slot0)
	slot0._dataProxy = nil

	slot0.EventDispatcher.DetachEventDispatcher(slot0)
end

ys.Battle.BattleBulletUnit.InitCldComponent = function (slot0)
	slot1 = slot0:GetTemplate().cld_box
	slot3 = slot0:GetTemplate().cld_offset[1]

	if slot0:GetIFF() == slot0.FOE_CODE then
		slot3 = slot3 * -1
	end

	slot0._cldComponent = slot1.Battle.BattleCubeCldComponent.New(slot1[1], slot1[2], slot1[3], slot3, slot2[3])

	slot0._cldComponent:SetCldData({
		type = slot2.CldType.BULLET,
		IFF = slot0:GetIFF(),
		UID = slot0:GetUniqueID()
	})
end

ys.Battle.BattleBulletUnit.ResetCldSurface = function (slot0)
	if slot0:GetDiveFilter() and #slot1 == 0 then
		slot0:GetCldData().Surface = slot0.OXY_STATE.DIVE
	else
		slot0:GetCldData().Surface = slot0.OXY_STATE.FLOAT
	end
end

ys.Battle.BattleBulletUnit.GetBoxSize = function (slot0)
	return slot0._cldComponent:GetCldBoxSize()
end

ys.Battle.BattleBulletUnit.GetCldBox = function (slot0)
	return slot0._cldComponent:GetCldBox(slot0:GetPosition())
end

ys.Battle.BattleBulletUnit.GetCldData = function (slot0)
	return slot0._cldComponent:GetCldData()
end

ys.Battle.BattleBulletUnit.GetSpeed = function (slot0)
	return slot0._speed
end

ys.Battle.BattleBulletUnit.GetSpeedRatio = function (slot0)
	return slot0.GetSpeedRatio(slot0._speedExemptKey, slot0._IFF)
end

ys.Battle.BattleBulletUnit.InitSpeed = function (slot0, slot1)
	if slot0._yAngle == nil then
		slot0._yAngle = (slot1 or slot0._baseAngle) + slot0._barrageAngle
	end

	slot0:calcSpeed()

	if slot0:HasAcceleration() then
		slot0._speedLength = slot0._speed:Magnitude()
		slot0._speedNormal = Vector3(math.cos(slot2), 0, math.sin(math.deg2Rad * slot0._yAngle))
		slot0._speedCross = Vector3.Cross(slot0._speedNormal, slot0)
		slot0.updateSpeed = slot1.doAccelerate
	elseif slot0:IsTracker() then
		slot0._trackRange = slot0._accTable.tracker.range
		slot0._cosAngularSpeed = math.deg2Rad * slot0._accTable.tracker.angular
		slot0._sinAngularSpeed = math.deg2Rad * slot0._accTable.tracker.angular
		slot0._negativeCosAngularSpeed = math.deg2Rad * slot0._accTable.tracker.angular * -1
		slot0._negativeSinAngularSpeed = math.deg2Rad * slot0._accTable.tracker.angular * -1
		slot0.updateSpeed = slot1.doTrack
	elseif slot0:IsCircle() then
		slot0._originPos = slot0._accTable.circle.center or slot0._targetPos
		slot0._circleAntiClockwise = tobool(slot2.antiClockWise)
		slot0._centripetalSpeed = (slot2.centripetalSpeed or 0) * slot2
		slot0._inverseFlag = 1
		slot0.updateSpeed = slot1.doCircle
	else
		slot0.updateSpeed = slot1.doNothing
	end
end

ys.Battle.BattleBulletUnit.calcSpeed = function (slot0)
	slot0._speed = Vector3(slot1.ConvertBulletSpeed(slot0._velocity * (1 + slot0.Battle.BattleAttr.GetCurrent(slot0, "bulletSpeedRatio"))) * math.cos(slot3), 0, slot1.ConvertBulletSpeed(slot0._velocity * (1 + slot0.Battle.BattleAttr.GetCurrent(slot0, "bulletSpeedRatio"))) * math.sin(math.deg2Rad * slot0._yAngle))
end

ys.Battle.BattleBulletUnit.updateBarrageTransform = function (slot0, slot1)
	if not slot0._barrageTransData or #slot0._barrageTransData == 0 then
		return
	end

	if slot0._barrageTransData[1].transStartDelay <= slot1 - slot0._timeStamp then
		if slot3.transAimAngle then
			slot0._yAngle = slot3.transAimAngle
		else
			slot0._yAngle = math.rad2Deg * math.atan2(slot3.transAimPosZ - slot0._position.z, slot3.transAimPosX - slot0._position.x)
		end

		slot0:calcSpeed()
		table.remove(slot0._barrageTransData, 1)

		if slot0._barrageTransData[1] then
			slot4.transStartDelay = slot4.transStartDelay + slot3.transStartDelay
		end
	end
end

ys.Battle.BattleBulletUnit.GetCurrentDistance = function (slot0)
	return Vector3.Distance(slot0._spawnPos, slot0._position)
end

ys.Battle.BattleBulletUnit.SetOutRangeCallback = function (slot0, slot1)
	slot0._outRangeFunc = slot1
end

ys.Battle.BattleBulletUnit.OutRange = function (slot0)
	slot0:DispatchEvent(slot0.Event.New(slot1.OUT_RANGE, {}))
	slot0:_outRangeFunc()
end

ys.Battle.BattleBulletUnit.FixRange = function (slot0, slot1, slot2)
	slot1 = slot1 or slot0._tempData.range
	slot2 = slot2 or 0

	if slot0._tempData.range_offset == 0 then
		slot0._range = slot1
	else
		slot0._range = slot1 + slot3 * (math.random() - 0.5)
	end

	slot0._range = math.max(0, slot0._range + slot2)
	slot0._sqrRange = slot0._range * slot0._range
end

ys.Battle.BattleBulletUnit.ImmuneBombCLS = function (slot0)
	return slot0:GetTemplate().extra_param.ignoreB
end

ys.Battle.BattleBulletUnit.ImmuneCLS = function (slot0)
	return slot0._immuneCLS
end

ys.Battle.BattleBulletUnit.SetImmuneCLS = function (slot0, slot1)
	slot0._immuneCLS = slot1
end

return

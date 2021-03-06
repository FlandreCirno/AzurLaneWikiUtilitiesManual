ys = ys or {}
slot1 = ys.Battle.BattleBulletEvent
slot2 = ys.Battle.BattleConfig
ys.Battle.BattleBombBulletUnit = class("BattleBombBulletUnit", ys.Battle.BattleBulletUnit)
ys.Battle.BattleBombBulletUnit.__name = "BattleBombBulletUnit"

ys.Battle.BattleBombBulletUnit.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._randomOffset = Vector3.zero
end

ys.Battle.BattleBombBulletUnit.InitSpeed = function (slot0)
	if slot0._barrageLowPriority then
		slot0._yAngle = slot0._baseAngle + slot0._barrageAngle
	else
		slot0._yAngle = math.rad2Deg * math.atan2(slot0._explodePos.z - slot0._spawnPos.z, slot0._explodePos.x - slot0._spawnPos.x)
	end

	slot0:calcSpeed()

	slot0.updateSpeed = slot0.doNothing
end

ys.Battle.BattleBombBulletUnit.Update = function (slot0)
	if slot0._exist then
		slot0.super.Update(slot0)
	end
end

ys.Battle.BattleBombBulletUnit.GetPierceCount = function (slot0)
	return 1
end

ys.Battle.BattleBombBulletUnit.IsOutRange = function (slot0, slot1)
	if not slot0._exist then
		return false
	end

	if slot0._explodeTime and slot0._explodeTime <= slot1 then
		return true
	end

	if slot0._reachDestFlag and not slot0._explodeTime then
		return true
	else
		return false
	end
end

ys.Battle.BattleBombBulletUnit.OutRange = function (slot0)
	slot0:DispatchEvent(slot0.Event.New(slot1.EXPLODE, {
		UID = unitUniqueID
	}))
	slot0.DispatchEvent.super.OutRange(slot0)
end

ys.Battle.BattleBombBulletUnit.SetSpawnPosition = function (slot0, slot1)
	slot0.super.SetSpawnPosition(slot0, slot1)

	if slot0._barragePriority then
		slot0._explodePos = slot0._explodePos + Vector3(slot0._offsetX, 0, slot0._offsetZ)
		slot0._explodePos = Quaternion.Euler(0, slot0._barrageAngle, 0) * (slot0._explodePos - pg.Tool.FilterY(slot0._spawnPos)) + pg.Tool.FilterY(slot0._spawnPos)
	end

	if slot0._fixToRange and slot0._range < Vector3.BattleDistance(slot0._explodePos, slot0._spawnPos) then
		slot0._explodePos = Vector3.Normalize(slot3) * slot0._range + slot0._spawnPos
	end

	if slot0._convertedVelocity ~= 0 then
		slot0._verticalSpeed = slot0:GetTemplate().extra_param.launchVrtSpeed or (slot0._explodePos.y - slot0._spawnPos.y) / (Vector3.Distance(slot2, slot0._explodePos) / slot0._convertedVelocity) - 0.5 * slot0._gravity * Vector3.Distance(slot2, slot0._explodePos) / slot0._convertedVelocity
	end
end

ys.Battle.BattleBombBulletUnit.SetExplodePosition = function (slot0, slot1)
	slot0._explodePos = slot1:Clone()

	if not slot0._barragePriority then
		slot0._explodePos = slot0._explodePos + slot0._randomOffset
	end

	slot0._explodePos.y = slot0.BombDetonateHeight
end

ys.Battle.BattleBombBulletUnit.SetTemplateData = function (slot0, slot1)
	slot0.super.SetTemplateData(slot0, slot1)

	slot0._barragePriority = slot0:GetTemplate().extra_param.barragePriority
	slot0._barrageLowPriority = slot0.GetTemplate().extra_param.barrageLowPriority
	slot0._fixToRange = slot0.GetTemplate().extra_param.fixToRange

	if slot0.GetTemplate().extra_param.barragePriority then
		slot0._randomOffset = Vector3.zero
	else
		slot4 = 0

		if slot2.accuracy then
			slot4 = slot0:GetAttrByName(slot3)
		end

		slot5 = slot2.randomOffsetX or 0
		slot6 = slot2.randomOffsetZ or 0
		slot5 = math.max(0, slot5 - slot4)
		slot6 = math.max(0, slot6 - slot4)
		slot7 = slot2.offsetX or 0
		slot8 = slot2.offsetZ or 0

		if slot5 ~= 0 then
			slot5 = slot5 * (math.random() - 0.5) + slot7
		end

		if slot6 ~= 0 then
			slot6 = slot6 * (math.random() - 0.5) + slot8
		end

		slot0._randomOffset = Vector3(slot5 + (slot2.targetOffsetX or 0), 0, slot6 + (slot2.targetOffsetZ or 0))
	end

	if slot2.timeToExplode then
		slot0._explodeTime = pg.TimeMgr.GetInstance():GetCombatTime() + slot2.timeToExplode
	end

	slot0._gravity = slot2.gravity or slot1.Battle.BattleConfig.GRAVITY
end

ys.Battle.BattleBombBulletUnit.GetExplodePostion = function (slot0)
	return slot0._explodePos
end

return

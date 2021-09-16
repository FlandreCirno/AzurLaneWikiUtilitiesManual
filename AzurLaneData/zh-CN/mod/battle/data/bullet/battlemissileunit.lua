ys = ys or {}
slot1 = ys.Battle.BattleConfig
slot2 = ys.Battle.BattleBulletEvent
slot3 = pg.bfConsts
slot4 = ys.Battle.BattleFormulas
slot6 = class("BattleMissileUnit", ys.Battle.BattleBulletUnit)
slot6.__name = "BattleMissileUnit"
ys.Battle.BattleMissileUnit = slot6
slot6.STATE_LAUNCH = "Launch"
slot6.STATE_ATTACK = "Attack"

slot6.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)

	slot0._state = slot0.STATE_LAUNCH
end

slot6.SetTemplateData = function (slot0, slot1)
	slot0.super.SetTemplateData(slot0, slot1)
	slot0:ResetVelocity(0)

	slot0._gravity = slot0:GetTemplate().extra_param.gravity or slot1.Battle.BattleConfig.GRAVITY
end

slot6.GetPierceCount = function (slot0)
	return 1
end

slot6.RegisterOnTheAir = function (slot0, slot1)
	slot0._onTheHighest = slot1
end

slot6.SetExplodePosition = function (slot0, slot1)
	slot0._explodePos = slot1:Clone()
	slot0._explodePos.y = slot0.BombDetonateHeight
end

slot6.GetExplodePostion = function (slot0)
	return slot0._explodePos
end

slot7 = 1 / ys.Battle.BattleConfig.viewFPS

slot6.SetSpawnPosition = function (slot0, slot1)
	slot0.super.SetSpawnPosition(slot0, slot1)

	slot0._verticalSpeed = slot0:GetTemplate().extra_param.launchVrtSpeed
end

slot6.Update = function (slot0, slot1)
	slot0.super.Update(slot0, slot1)

	if slot0._state == slot0.STATE_LAUNCH and slot1 > slot0:GetTemplate().extra_param.launchRiseTime + slot0._timeStamp then
		slot0:CompleteRise()
	end
end

slot6.CompleteRise = function (slot0)
	slot0._state = slot0.STATE_ATTACK
	slot0._gravity = 0

	if slot0._onTheHighest then
		slot0._onTheHighest()
	end

	slot0._targetPos = slot0._explodePos
	slot0._yAngle = math.rad2Deg * math.atan2(slot0._explodePos.z - slot0._spawnPos.z, slot0._explodePos.x - slot0._spawnPos.x)
	slot0._verticalSpeed = -(slot0._position.y / slot0:GetTemplate().extra_param.fallTime) * slot0

	slot0:ResetVelocity(slot1.ConvertBulletDataSpeed(pg.Tool.FilterY(slot0._explodePos - slot0._position):Magnitude() / slot0.GetTemplate().extra_param.fallTime * slot0))
	slot0:calcSpeed()
end

slot6.IsOutRange = function (slot0)
	return slot0._state == slot0.STATE_ATTACK and slot0._position.y <= slot0.BombDetonateHeight
end

slot6.OutRange = function (slot0, slot1)
	slot0:DispatchEvent(slot0.Event.New(slot1.EXPLODE, {
		UID = slot1
	}))
	slot2.super.OutRange(slot0)
end

return

ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleDataFunction
slot3 = class("BattleMissileWeaponUnit", ys.Battle.BattleWeaponUnit)
ys.Battle.BattleMissileWeaponUnit = slot3
slot3.__name = "BattleMissileWeaponUnit"

slot3.CalculateFixedExplodePosition = function (slot0, slot1)
	return Vector3(slot0._host:GetPosition().x + ((slot0._host:GetDirection() == slot0.UnitDir.RIGHT and 1) or -1) * slot1._range, 0, 0)
end

slot3.CalculateRandTargetPosition = function (slot0, slot1, slot2)
	slot3 = slot2:GetCLDZCenterPosition()
	slot6 = 0

	if slot1:GetTemplate().extra_param.accuracy then
		slot6 = slot1:GetAttrByName(slot5)
	end

	slot7 = slot4.randomOffsetX or 0
	slot8 = slot4.randomOffsetZ or 0
	slot7 = math.max(0, slot7 - slot6)
	slot8 = math.max(0, slot8 - slot6)
	slot9 = slot4.offsetX or 0
	slot10 = slot4.offsetZ or 0

	if slot7 ~= 0 then
		slot7 = slot7 * (math.random() - 0.5) + slot9
	end

	if slot8 ~= 0 then
		slot8 = slot8 * (math.random() - 0.5) + slot10
	end

	return Vector3(slot3.x + slot7 + (slot4.targetOffsetX or 0), 0, slot3.z + slot8 + (slot4.targetOffsetZ or 0))
end

slot3.createMajorEmitter = function (slot0, slot1, slot2, slot3, slot4, slot5)
	return slot0.super.createMajorEmitter(slot0, slot1, slot2, slot3, function (slot0, slot1, slot2, slot3, slot4)
		slot6 = slot0:Spawn(slot5, slot4, slot2.INTERNAL)

		slot6:SetOffsetPriority(slot3)
		slot6:SetShiftInfo(slot0, slot1)
		slot6:SetRotateInfo(nil, slot0:GetBaseAngle(), slot2)
		slot6:RegisterOnTheAir(slot0:ChoiceOntheAir(slot6))
		slot0:DispatchBulletEvent(slot6)
	end, nil)
end

slot3.ChoiceOntheAir = function (slot0, slot1)
	return function ()
		slot11, slot13 = (slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0:CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0:CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition):GetOffset()

		(slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition):Add(Vector3(slot6, 0, slot7))
		(slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition):SetExplodePosition((slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition):GetSpawnPosition() + Quaternion.Euler(0, slot5, 0) * pg.Tool.FilterY(((slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition)) - (slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition):GetSpawnPosition()))
		slot3.Battle.BattleMissileFactory.CreateBulletAlert((slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition).GetSpawnPosition() + Quaternion.Euler(0, slot5, 0) * pg.Tool.FilterY(((slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition)) - (slot0._tmpData.aim_type == slot1.WeaponAimType.AIM and slot0 and slot0.CalculateRandTargetPosition(slot0.CalculateRandTargetPosition, slot0)) or slot0.CalculateFixedExplodePosition(slot0.CalculateFixedExplodePosition).GetSpawnPosition()))
	end
end

return

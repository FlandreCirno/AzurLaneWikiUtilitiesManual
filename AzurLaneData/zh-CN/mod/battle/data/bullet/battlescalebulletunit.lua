ys = ys or {}
slot1 = ys.Battle.BattleBulletEvent
slot2 = ys.Battle.BattleFormulas
slot3 = Vector3.up
slot4 = ys.Battle.BattleVariable
slot5 = ys.Battle.BattleConfig
ys.Battle.BattleScaleBulletUnit = class("BattleScaleBulletUnit", ys.Battle.BattleBulletUnit)
ys.Battle.BattleScaleBulletUnit.__name = "BattleScaleBulletUnit"

ys.Battle.BattleScaleBulletUnit.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._scaleX = 0
end

ys.Battle.BattleScaleBulletUnit.Update = function (slot0, slot1)
	if slot0._scaleLimit < slot0._scaleX + slot0._tempData.cld_box[1] then
		slot0:calcSpeed()
	else
		slot0:UpdateCLDBox()
	end

	slot0.super.Update(slot0, slot1)
end

ys.Battle.BattleScaleBulletUnit.SetTemplateData = function (slot0, slot1)
	slot0.super.SetTemplateData(slot0, slot1)

	slot0._scaleSpeed = slot0._tempData.extra_param.scaleSpeed
	slot0._scaleLimit = slot0._tempData.extra_param.cldMax
end

ys.Battle.BattleScaleBulletUnit.InitSpeed = function (slot0, slot1)
	slot0.super.InitSpeed(slot0, slot1)
	slot0:calcScaleSpeed()
end

ys.Battle.BattleScaleBulletUnit.calcScaleSpeed = function (slot0)
	slot0._speed = Vector3(slot0._scaleSpeed * 0.5 * math.cos(slot2), 0, slot0._scaleSpeed * 0.5 * math.sin(math.deg2Rad * slot0._yAngle))
end

ys.Battle.BattleScaleBulletUnit.UpdateCLDBox = function (slot0)
	slot0._scaleX = slot0._scaleX + slot0._scaleSpeed

	slot0._cldComponent:ResetSize(slot0._tempData.cld_box[1] + slot0._scaleX, slot0._tempData.cld_box[2], slot0._tempData.cld_box[3])
end

ys.Battle.BattleScaleBulletUnit.GetRadian = function (slot0)
	return slot0._radCache or slot0:GetYAngle() * math.deg2Rad, slot0._cosCache or math.cos(slot0._radCache or slot0.GetYAngle() * math.deg2Rad), slot0._sinCache or math.sin(slot0._radCache or slot0.GetYAngle() * math.deg2Rad)
end

return

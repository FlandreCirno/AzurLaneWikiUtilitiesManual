ys = ys or {}
slot1 = ys.Battle.BattleConfig
slot2 = class("BattleBuffAddAdditiveSpeed", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffAddAdditiveSpeed = slot2
slot2.__name = "BattleBuffAddAdditiveSpeed"

slot2.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

slot2.SetArgs = function (slot0, slot1, slot2)
	slot0._singularity = slot0._tempData.arg_list.singularity or {
		x = 0,
		z = 0
	}
	slot0._casterGravity = slot0._tempData.arg_list.gravitationalCaster
	slot0._force = slot0._tempData.arg_list.force
	slot0._forceScalteRate = slot0._tempData.arg_list.scale_rate

	if not slot0._casterGravity then
		slot0._staticSingularity = Vector3.New(slot0._singularity.x, 0, slot0._singularity.z)
	else
		slot0._singularityOffset = Vector3.New(slot0._singularity.x * slot2:GetCaster().GetIFF(slot3), 0, slot0._singularity.z)
	end
end

slot2.onUpdate = function (slot0, slot1, slot2)
	slot3 = nil
	slot5 = pg.Tool.FilterY(((slot0._casterGravity and slot2:GetCaster().GetPosition(slot4) + slot0._singularityOffset) or slot0._staticSingularity) - slot1:GetPosition()).normalized
	slot6 = slot0._force

	if pg.Tool.FilterY(((slot0._casterGravity and slot2.GetCaster().GetPosition(slot4) + slot0._singularityOffset) or slot0._staticSingularity) - slot1.GetPosition()).magnitude < 2 then
		slot6 = 1e-08
	elseif slot0._forceScalteRate then
		slot6 = math.min(slot7, 1 / slot7 * slot6)
	end

	slot1:SetAdditiveSpeed(slot5 * slot6)
end

slot2.onRemove = function (slot0, slot1, slot2)
	slot1:RemoveAdditiveSpeed()
end

return

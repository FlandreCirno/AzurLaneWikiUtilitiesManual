ys = ys or {}
slot1 = pg.effect_offset
ys.Battle.BattleBuffBarrier = class("BattleBuffBarrier", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffBarrier.__name = "BattleBuffBarrier"

ys.Battle.BattleBuffBarrier.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffBarrier.SetArgs = function (slot0, slot1, slot2)
	slot0._durability = slot0._tempData.arg_list.durability
	slot0._dir = slot1:GetDirection()
	slot0._unit = slot1
	slot0._dataProxy = slot0.Battle.BattleDataProxy.GetInstance()
	slot0._centerPos = slot1:GetPosition()

	function slot4(slot0)
		slot0._dataProxy:HandleDamage(slot0, slot0._unit)
		slot0:Intercepted()
		slot0._dataProxy:RemoveBulletUnit(slot0:GetUniqueID())
	end

	slot6 = slot0._tempData.arg_list.cld_data.box
	slot7 = Clone(slot0._tempData.arg_list.cld_data.offset)

	if slot1.GetDirection(slot1) == slot0.Battle.BattleConst.UnitDir.LEFT then
		slot7[1] = -slot7[1]
	end

	slot0._wall = slot0._dataProxy:SpawnWall(slot0, slot4, slot6, slot7)
end

ys.Battle.BattleBuffBarrier.onUpdate = function (slot0, slot1, slot2, slot3)
	slot0._centerPos = slot1:GetPosition()
end

ys.Battle.BattleBuffBarrier.onTakeDamage = function (slot0, slot1, slot2, slot3)
	if slot0:damageAttrRequire(slot3.damageAttr) then
		slot0._durability = slot0._durability - slot3.damage

		if slot0._durability > 0 then
			slot3.damage = 0
		else
			slot3.damage = -slot0._durability

			slot2:SetToCancel()
		end
	end
end

ys.Battle.BattleBuffBarrier.onAttach = function (slot0, slot1, slot2, slot3)
	if slot0._unit:IsBoss() then
		slot0._unit:BarrierStateChange(slot0._durability, slot2:GetDuration())
	end
end

ys.Battle.BattleBuffBarrier.onRemove = function (slot0, slot1, slot2, slot3)
	if slot0._unit:IsBoss() then
		slot0._unit:BarrierStateChange(0)
	end
end

ys.Battle.BattleBuffBarrier.GetIFF = function (slot0)
	return slot0._unit:GetIFF()
end

ys.Battle.BattleBuffBarrier.GetPosition = function (slot0)
	return slot0._centerPos
end

ys.Battle.BattleBuffBarrier.IsWallActive = function (slot0)
	return slot0._durability > 0
end

return

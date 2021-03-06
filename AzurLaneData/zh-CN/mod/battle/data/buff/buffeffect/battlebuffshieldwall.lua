ys = ys or {}
slot1 = pg.effect_offset
ys.Battle.BattleBuffShieldWall = class("BattleBuffShieldWall", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffShieldWall.__name = "BattleBuffShieldWall"

ys.Battle.BattleBuffShieldWall.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffShieldWall.SetArgs = function (slot0, slot1, slot2)
	slot0._buffID = slot2:GetID()
	slot0._dir = slot1:GetDirection()
	slot0._count = slot0._tempData.arg_list.count
	slot0._bulletType = slot0._tempData.arg_list.bulletType or slot0.Battle.BattleConst.BulletType.CANNON
	slot0._doWhenHit = slot3.do_when_hit
	slot0._unit = slot1
	slot0._dataProxy = slot0.Battle.BattleDataProxy.GetInstance()
	slot0._centerPos = slot1:GetPosition()
	slot0._startTime = pg.TimeMgr.GetInstance():GetCombatTime()

	function slot4(slot0)
		return slot0:onWallCld(slot0)
	end

	slot5 = slot1.GetTemplate(slot1).scale / 50
	slot7 = slot3.cld_list[1].box
	slot8 = Clone(slot3.cld_list[1].offset)

	if slot1:GetDirection() == slot0.Battle.BattleConst.UnitDir.LEFT then
		slot8[1] = -slot8[1] * slot5
	else
		slot8[1] = slot8[1] * slot5
	end

	slot0._wall = slot0._dataProxy:SpawnWall(slot0, slot4, slot7, slot8)
	slot9 = nil

	if slot1[slot3.effect] then
		slot14 = Vector3(slot1:GetTemplate().fx_container[slot10.container_index][1], slot1.GetTemplate().fx_container[slot10.container_index][2], slot1.GetTemplate().fx_container[slot10.container_index][3])

		slot14:Add(Vector3(slot10.offset[1], slot10.offset[2], slot10.offset[3]))

		slot9 = slot14
	end

	if slot9 then
		slot0._centerPosFun = function (slot0)
			slot2 = slot0:centerPosFun()
			slot2:Add(nil).x = slot2.Add(nil).x * slot2._dir

			return slot2.Add(nil)
		end
	else
		slot0._centerPosFun = slot3.centerPosFun
	end

	slot0._currentTimeCount = 0

	if slot3.effect then
		slot0._effectIndex = "BattleBuffShieldWall" .. slot0._buffID .. slot0._tempData.id
		slot11 = nil
		slot0._unit = slot1
		slot0._evtData = {
			effect = slot3.effect,
			posFun = (not slot9 or function (slot0)
				return slot0:centerPosFun():Add(nil)
			end) and slot3.centerPosFun,
			index = slot0._effectIndex,
			rotationFun = slot3.rotationFun
		}

		slot1.DispatchEvent(slot1, slot0.Event.New(slot0.Battle.BattleUnitEvent.ADD_EFFECT, slot0._evtData))
	end
end

ys.Battle.BattleBuffShieldWall.onStack = function (slot0, slot1, slot2)
	slot0._count = slot0._tempData.arg_list.count

	slot0._unit:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.ADD_EFFECT, slot0._evtData))
end

ys.Battle.BattleBuffShieldWall.onUpdate = function (slot0, slot1, slot2, slot3)
	slot4 = slot1:GetPosition()
	slot5 = slot1:GetTemplate().scale * 0.02

	if slot0._centerPosFun then
		slot0._currentTimeCount = slot3 - slot0._startTime
		slot4 = slot0._centerPosFun(slot0._currentTimeCount):Mul(slot5):Add(slot4)
	end

	slot0._centerPos = slot4
end

ys.Battle.BattleBuffShieldWall.onWallCld = function (slot0, slot1)
	if not slot1:GetIgnoreShield() and slot1:GetType() == slot0._bulletType and slot0._count > 0 then
		if slot0._doWhenHit == "intercept" then
			slot1:Intercepted()
			slot0._dataProxy:RemoveBulletUnit(slot1:GetUniqueID())

			slot0._count = slot0._count - 1
		elseif slot0._doWhenHit == "reflect" and slot0:GetIFF() ~= slot1:GetIFF() then
			slot1:Reflected()

			slot0._count = slot0._count - 1
		end

		if slot0._count <= 0 then
			slot0:Deactive()
		end
	end

	return slot0._count > 0
end

ys.Battle.BattleBuffShieldWall.GetIFF = function (slot0)
	return slot0._unit:GetIFF()
end

ys.Battle.BattleBuffShieldWall.GetPosition = function (slot0)
	return slot0._centerPos
end

ys.Battle.BattleBuffShieldWall.IsWallActive = function (slot0)
	return slot0._count > 0
end

ys.Battle.BattleBuffShieldWall.Deactive = function (slot0)
	if slot0._effectIndex then
		slot0._unit:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.DEACTIVE_EFFECT, {
			index = slot0._effectIndex
		}))
	end

	slot0._unit:TriggerBuff(slot0.Battle.BattleConst.BuffEffectType.ON_SHIELD_BROKEN, {
		shieldBuffID = slot0._buffID
	})
end

ys.Battle.BattleBuffShieldWall.Clear = function (slot0)
	if slot0._effectIndex then
		slot0._unit:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CANCEL_EFFECT, {
			index = slot0._effectIndex
		}))
	end

	slot0._dataProxy:RemoveWall(slot0._wall:GetUniqueID())
end

return

ys = ys or {}
slot2 = ys.Battle.BattleConfig
slot3 = class("BattleEnvironmentBehaviour")
ys.Battle.BattleEnvironmentBehaviour = slot3
slot3.__name = "BattleEnvironmentBehaviour"
slot3.STATE_DELAY = "STATE_DELAY"
slot3.STATE_READY = "STATE_READY"
slot3.STATE_OVERHEAT = "STATE_OVERHEAT"
slot3.STATE_EXPIRE = "STATE_EXPIRE"

slot3.Ctor = function (slot0, slot1, slot2)
	slot0._cldUnitList = {}
end

slot3.SetUnitRef = function (slot0, slot1)
	slot0._unit = slot1
end

slot3.SetTemplate = function (slot0, slot1)
	slot0._tmpData = slot1

	if slot0._tmpData.delay then
		slot0._delayStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		slot0._state = slot0.STATE_DELAY
	else
		slot0._state = slot0.STATE_READY
	end

	if slot0._tmpData.life_time then
		slot0._liftStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	end

	slot0._diveFilter = slot0._tmpData.diveFilter or {}
end

slot3.UpdateCollideUnitList = function (slot0, slot1)
	if #slot0._diveFilter ~= 0 then
		slot2 = #slot1

		while slot2 > 0 do
			slot3 = slot1[slot2]:GetCurrentOxyState()

			for slot7, slot8 in ipairs(slot0._diveFilter) do
				if slot3 == slot8 then
					table.remove(slot1, slot2)

					break
				end
			end

			slot2 = slot2 - 1
		end
	end

	slot0._cldUnitList = slot1
end

slot3.OnUpdate = function (slot0)
	slot0:updateDelay()
	slot0:updateReload()
	slot0:updateLifeTime()

	if slot0._state == slot0.STATE_READY then
		slot0:doBehaviour()
	end
end

slot3.Dispose = function (slot0)
	slot0._cldUnitList = nil
	slot0._tmpData = nil
	slot0._CDstartTime = nil
end

slot3.OnCollide = function (slot0, slot1)
	return
end

slot3.GetCurrentState = function (slot0)
	return slot0._state
end

slot3.updateDelay = function (slot0)
	if slot0._delayStartTime and slot0._tmpData.delay + slot0._delayStartTime <= pg.TimeMgr.GetInstance():GetCombatTime() then
		slot0._delayStartTime = nil

		slot0:handleCoolDown()
	end
end

slot3.updateReload = function (slot0)
	if slot0._CDstartTime then
		if slot0:getReloadFinishTimeStamp() <= pg.TimeMgr.GetInstance():GetCombatTime() then
			slot0:handleCoolDown()
		else
			return
		end
	end
end

slot3.updateLifeTime = function (slot0)
	if slot0._liftStartTime and slot0._liftStartTime + slot0._tmpData.life_time <= pg.TimeMgr.GetInstance():GetCombatTime() then
		slot0._state = slot0.STATE_EXPIRE

		slot0:doExpire()
	end
end

slot3.getReloadFinishTimeStamp = function (slot0)
	return slot0._tmpData.reload_time + slot0._CDstartTime
end

slot3.handleCoolDown = function (slot0)
	slot0._state = slot0.STATE_READY
	slot0._CDstartTime = nil
end

slot3.doBehaviour = function (slot0)
	if slot0._tmpData.reload_time then
		slot0._CDstartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		slot0._state = slot0.STATE_OVERHEAT
	end
end

slot3.doExpire = function (slot0)
	slot0._state = slot0.STATE_EXPIRE
end

slot3.BehaviourClassEnum = {
	[ys.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX] = "BattleEnvironmentBehaviourPlayFX",
	[ys.Battle.BattleConst.EnviroumentBehaviour.DAMAGE] = "BattleEnvironmentBehaviourDamage",
	[ys.Battle.BattleConst.EnviroumentBehaviour.BUFF] = "BattleEnvironmentBehaviourBuff",
	[ys.Battle.BattleConst.EnviroumentBehaviour.MOVEMENT] = "BattleEnvironmentBehaviourMovement",
	[ys.Battle.BattleConst.EnviroumentBehaviour.FORCE] = "BattleEnvironmentBehaviourForce",
	[ys.Battle.BattleConst.EnviroumentBehaviour.SPAWN] = "BattleEnvironmentBehaviourSpawn",
	[ys.Battle.BattleConst.EnviroumentBehaviour.PLAY_SFX] = "BattleEnvironmentBehaviourPlaySFX",
	[ys.Battle.BattleConst.EnviroumentBehaviour.SHAKE_SCREEN] = "BattleEnvironmentBehaviourShakeScreen"
}

slot3.CreateBehaviour = function (slot0)
	return slot0.Battle[slot1.BehaviourClassEnum[slot0.type]].New()
end

return

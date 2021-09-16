ys = ys or {}
slot1 = ys.Battle.BattleUnitEvent
slot2 = ys.Battle.BattleConst
slot3 = ys.Battle.BattleConfig
slot4 = ys.Battle.BattleAttr
ys.Battle.BattleUnitCloakComponent = class("BattleUnitCloakComponent")
ys.Battle.BattleUnitCloakComponent.__name = "BattleUnitCloakComponent"
ys.Battle.BattleUnitCloakComponent.STATE_CLOAK = "STATE_CLOAK"
ys.Battle.BattleUnitCloakComponent.STATE_UNCLOAK = "STATE_UNCLOAK"

ys.Battle.BattleUnitCloakComponent.Ctor = function (slot0, slot1)
	slot0._client = slot1

	slot0:initCloak()
end

ys.Battle.BattleUnitCloakComponent.Update = function (slot0, slot1)
	slot0._lastCloakUpdateStamp = slot0._lastCloakUpdateStamp or slot1

	slot0:updateCloakValue(slot1)
	slot0:UpdateCloakState()

	slot0._lastCloakUpdateStamp = slot1

	slot0.Battle.BattleBuffDOT.UpdateCloakLock(slot0._client)
end

ys.Battle.BattleUnitCloakComponent.UpdateCloakConfig = function (slot0)
	slot0._exposeBase = slot0.GetCurrent(slot0._client, "cloakExposeBase")
	slot0._exposeExtra = slot0.GetCurrent(slot0._client, "cloakExposeExtra")
	slot0._restoreValue = slot0.GetCurrent(slot0._client, "cloakRestore")
	slot0._recovery = slot0.GetCurrent(slot0._client, "cloakRecovery")

	slot0:adjustCloakAttr()
	slot0._client:DispatchEvent(slot1.Event.New(slot2.UPDATE_CLOAK_CONFIG))
end

ys.Battle.BattleUnitCloakComponent.SetRecoverySpeed = function (slot0, slot1)
	slot0._fieldRecoveryOverride = slot1
end

ys.Battle.BattleUnitCloakComponent.AppendExpose = function (slot0, slot1)
	slot0._cloakValue = Mathf.Clamp(slot2, slot0._cloakBottom, slot0._exposeValue)

	slot0:UpdateCloakState()
end

ys.Battle.BattleUnitCloakComponent.AppendStrikeExpose = function (slot0)
	slot0._strikeCount = slot0._strikeCount + 1

	slot0:AppendExpose(math.min(slot0._strikeExposeAdditive * slot0._strikeCount, slot0._strikeExposeAdditiveLimit))
end

ys.Battle.BattleUnitCloakComponent.AppendExposeSpeed = function (slot0, slot1)
	slot0._exposeSpeed = slot1
end

ys.Battle.BattleUnitCloakComponent.ForceToMax = function (slot0)
	slot0._cloakValue = slot0._exposeValue

	slot0:UpdateCloakState()
end

ys.Battle.BattleUnitCloakComponent.AppendExposeDot = function (slot0, slot1, slot2)
	slot0._exposeDotList[slot1] = slot2

	slot0:AppendExpose(slot2)
	slot0:updateCloakBottom()
end

ys.Battle.BattleUnitCloakComponent.RemoveExposeDot = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0._exposeDotList) do
		slot0._exposeDotList[slot5] = nil

		break
	end

	slot0:updateCloakBottom()
end

ys.Battle.BattleUnitCloakComponent.UpdateDotExpose = function (slot0, slot1)
	if slot1 ~= slot0._cloakBottom then
		slot0._cloakBottom = slot1

		slot0._client:DispatchEvent(slot0.Event.New(slot1.UPDATE_CLOAK_LOCK))
	end
end

ys.Battle.BattleUnitCloakComponent.UpdateCloakState = function (slot0)
	slot1 = nil

	if slot0._exposeValue <= slot0._cloakValue then
		slot1 = slot0.STATE_UNCLOAK
	elseif slot0._cloakValue <= slot0._restoreValue then
		slot1 = slot0.STATE_CLOAK
	end

	if slot1 and slot1 ~= slot0._currentState then
		slot0._currentState = slot1

		if slot0._currentState == slot0.STATE_UNCLOAK then
			slot1.Uncloak(slot0._client)
		elseif slot0._currentState == slot0.STATE_CLOAK then
			slot1.Cloak(slot0._client)
		end
	end
end

ys.Battle.BattleUnitCloakComponent.GetCloakValue = function (slot0)
	return slot0._cloakValue
end

ys.Battle.BattleUnitCloakComponent.GetCloakMax = function (slot0)
	return slot0._exposeValue
end

ys.Battle.BattleUnitCloakComponent.GetCloakLockMin = function (slot0)
	return slot0._fireLockValue
end

ys.Battle.BattleUnitCloakComponent.GetCloakRestoreValue = function (slot0)
	return slot0._restoreValue
end

ys.Battle.BattleUnitCloakComponent.GetCloakBottom = function (slot0)
	return slot0._cloakBottom
end

ys.Battle.BattleUnitCloakComponent.GetCurrentState = function (slot0)
	return slot0._currentState
end

ys.Battle.BattleUnitCloakComponent.GetExposeSpeed = function (slot0)
	return slot0._exposeSpeed
end

ys.Battle.BattleUnitCloakComponent.updateCloakValue = function (slot0, slot1)
	slot0:AppendExpose((slot0._exposeSpeed - (slot0._fieldRecoveryOverride or slot0._recovery)) * (slot1 - slot0._lastCloakUpdateStamp))
end

ys.Battle.BattleUnitCloakComponent.initCloak = function (slot0)
	slot0._exposeBase = slot0.GetCurrent(slot0._client, "cloakExposeBase")
	slot0._exposeExtra = slot0.GetCurrent(slot0._client, "cloakExposeExtra")
	slot0._restoreValue = slot0.GetCurrent(slot0._client, "cloakRestore")
	slot0._fireLockValue = slot0.GetCurrent(slot0._client, "cloakFireLock")
	slot0._cloakValue = 0
	slot0._exposeSpeed = 0
	slot0._cloakBottom = 0

	slot0:adjustCloakAttr()

	slot0._recovery = slot0.GetCurrent(slot0._client, "cloakRecovery")
	slot0._strikeExposeAdditive = slot0.GetCurrent(slot0._client, "cloakStrikeAdditive")
	slot0._strikeCount = 0
	slot0._strikeExposeAdditiveLimit = 0.CLOAK_STRIKE_ADDITIVE_LIMIT
	slot0._exposeDotList = {}
	slot0._currentState = slot2.STATE_CLOAK

	slot0.Cloak(slot0._client)
end

ys.Battle.BattleUnitCloakComponent.adjustCloakAttr = function (slot0)
	slot0._exposeBase = math.max(slot0._exposeBase, slot0.CLOAK_EXPOSE_BASE_MIN)
	slot0._restoreValue = math.max(slot0._restoreValue, 0)
	slot0._exposeValue = math.max(slot0._exposeBase + slot0._exposeExtra, slot0.CLOAK_EXPOSE_SKILL_MIN)
	slot0._cloakValue = Mathf.Clamp(slot0._cloakValue, 0, slot0._exposeValue)

	Mathf.Clamp(slot0._cloakValue, 0, slot0._exposeValue).SetCurrent(slot0._client, "cloakExposeBase", slot0._exposeBase)
	Mathf.Clamp(slot0._cloakValue, 0, slot0._exposeValue).SetCurrent.SetCurrent(slot0._client, "cloakRestore", slot0._restoreValue)
	slot0:UpdateCloakState()
end

return

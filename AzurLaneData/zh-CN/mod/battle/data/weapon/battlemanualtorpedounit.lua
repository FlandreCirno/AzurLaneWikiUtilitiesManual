ys = ys or {}
slot1 = ys.Battle.BattleUnitEvent
slot2 = class("BattleManualTorpedoUnit", ys.Battle.BattleTorpedoUnit)
ys.Battle.BattleManualTorpedoUnit = slot2
slot2.__name = "BattleManualTorpedoUnit"

slot2.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot2.createMajorEmitter = function (slot0, slot1, slot2)
	slot0.super.createMajorEmitter(slot0, slot1, slot2, nil, function (slot0, slot1, slot2, slot3)
		slot5 = slot0:Spawn(slot4, nil, slot2.INTERNAL)

		slot5:SetOffsetPriority(slot3)
		slot5:SetShiftInfo(slot0, slot1)
		slot5:SetRotateInfo(nil, slot0._botAutoAimAngle, slot2)
		slot0:DispatchBulletEvent(slot5)

		return slot5
	end, function ()
		return
	end)
end

slot2.Update = function (slot0)
	slot0:UpdateReload()
end

slot2.SetPlayerTorpedoWeaponVO = function (slot0, slot1)
	slot0._playerTorpedoVO = slot1
end

slot2.TriggerBuffOnReady = function (slot0)
	slot0._host:TriggerBuff(slot0.Battle.BattleConst.BuffEffectType.ON_MANUAL_TORPEDO_READY, {})
end

slot2.Fire = function (slot0, slot1)
	if slot1 then
		slot0:updateMovementInfo()

		if slot0.Battle.BattleTargetChoise.TargetHarmRandomByWeight(slot0._host, nil, slot0:GetFilteredList())[1] then
			slot0._botAutoAimAngle = math.rad2Deg * math.atan2(slot2:GetPosition().z - slot0._host:GetPosition().z, slot2.GetPosition().x - slot0._host.GetPosition().x)
		else
			slot0._botAutoAimAngle = slot0:GetBaseAngle()
		end
	else
		slot0._botAutoAimAngle = slot0:GetBaseAngle()
	end

	slot1.super.Fire(slot0)

	return true
end

slot2.DoAttack = function (slot0)
	slot0:DispatchEvent(slot0.Event.New(slot1.TORPEDO_WEAPON_FIRE, {}))
	slot2.super.DoAttack(slot0)
	slot0:DispatchEvent(slot0.Event.New(slot1.MANUAL_WEAPON_FIRE, {}))
end

slot2.InitialCD = function (slot0)
	slot0.super.InitialCD(slot0)
	slot0._playerTorpedoVO:Deduct(slot0)
	slot0._playerTorpedoVO:Charge(slot0)
end

slot2.EnterCoolDown = function (slot0)
	slot0.super.EnterCoolDown(slot0)
	slot0._playerTorpedoVO:Charge(slot0)
end

slot2.OverHeat = function (slot0)
	slot0.super.OverHeat(slot0)
	slot0._playerTorpedoVO:Deduct(slot0)
end

slot2.Cease = function (slot0)
	if slot0._currentState == slot0.STATE_OVER_HEAT then
		slot0:interruptAllEmitter()
	end
end

slot2.handleCoolDown = function (slot0)
	slot0._currentState = slot0.STATE_READY

	slot0._playerTorpedoVO:Plus(slot0)
	slot0:DispatchEvent(slot0.Event.New(slot1.TORPEDO_WEAPON_READY, {}))
	slot0:DispatchEvent(slot0.Event.New(slot1.MANUAL_WEAPON_READY, {}))
	slot0:TriggerBuffOnReady()

	slot0._CDstartTime = nil
	slot0._reloadBoostList = {}
end

slot2.FlushReloadRequire = function (slot0)
	if slot0.super.FlushReloadRequire(slot0) then
		return true
	end

	slot0._playerTorpedoVO:RefreshReloadingBar()
end

slot2.QuickCoolDown = function (slot0)
	if slot0._currentState == slot0.STATE_OVER_HEAT then
		slot0._currentState = slot0.STATE_READY

		slot0._playerTorpedoVO:InstantCoolDown(slot0)
		slot0:DispatchEvent(slot0.Event.New(slot1.MANUAL_WEAPON_INSTANT_READY, {}))

		slot0._CDstartTime = nil
		slot0._reloadBoostList = {}
	end
end

slot2.Prepar = function (slot0)
	slot0._currentState = slot0.STATE_PRECAST

	slot0:DispatchEvent(slot0.Event.New(slot1.TORPEDO_WEAPON_PREPAR, slot1))
end

slot2.Cancel = function (slot0)
	slot0._currentState = slot0.STATE_READY

	slot0:DispatchEvent(slot0.Event.New(slot1.TORPEDO_WEAPON_CANCEL, {}))
end

slot2.ReloadBoost = function (slot0, slot1)
	table.insert(slot0._reloadBoostList, slot1)
end

slot2.AppendReloadBoost = function (slot0, slot1)
	if slot0._currentState == slot0.STATE_OVER_HEAT then
		slot0._playerTorpedoVO:ReloadBoost(slot0, slot1)
	end
end

return

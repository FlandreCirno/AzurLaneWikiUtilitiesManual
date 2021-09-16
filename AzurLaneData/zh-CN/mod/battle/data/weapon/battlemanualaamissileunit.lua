ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleUnitEvent
slot3 = ys.Battle.BattleTargetChoise
slot4 = class("BattleManualAAMissileUnit", ys.Battle.BattleManualTorpedoUnit)
ys.Battle.BattleManualAAMissileUnit = slot4
slot4.__name = "BattleManualAAMissileUnit"

slot4.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot0._strikeMode = nil
	slot0._strikeModeData = nil
end

slot4.createMajorEmitter = function (slot0, slot1, slot2, slot3)
	function slot4(slot0, slot1, slot2, slot3, slot4)
		slot6 = slot0:Spawn(slot5, slot4, slot2.INTERNAL)

		slot6:SetOffsetPriority(slot3)
		slot6:SetShiftInfo(slot0, slot1)

		if slot0._tmpData.aim_type == slot3.WeaponAimType.AIM and slot4 ~= nil then
			slot6:SetRotateInfo(slot4:GetBeenAimedPosition(), slot0:GetBaseAngle(), slot2)
		else
			slot6:SetRotateInfo(nil, slot0:GetBaseAngle(), slot2)
		end

		slot6:setTrackingTarget(slot4)

		slot7 = {}

		for slot11, slot12 in pairs(slot0._strikeModeData) do
			slot7[slot11] = slot12
		end

		slot6:SetTrackingFXData(slot7)
		slot0:DispatchBulletEvent(slot6)

		return slot6
	end

	slot0._majorEmitterList[#slot0._majorEmitterList + 1] = slot2.Battle[slot3 or slot0.EMITTER_NORMAL].New(slot4, function ()
		for slot3, slot4 in ipairs(slot0._majorEmitterList) do
			if slot4:GetState() ~= slot4.STATE_STOP then
				return
			end
		end

		slot0:DispatchEvent(slot1.Event.New(slot2.MANUAL_WEAPON_FIRE, {}))

		slot0.DispatchEvent._strikeModeData = nil
	end, slot1)

	return slot2.Battle[slot3 or slot0.EMITTER_NORMAL].New(slot4, function ()
		for slot3, slot4 in ipairs(slot0._majorEmitterList) do
			if slot4.GetState() ~= slot4.STATE_STOP then
				return
			end
		end

		slot0.DispatchEvent(slot1.Event.New(slot2.MANUAL_WEAPON_FIRE, ))

		slot0.DispatchEvent._strikeModeData = nil
	end, slot1)
end

slot4.IsStrikeMode = function (slot0)
	return slot0._strikeMode
end

slot4.IsAttacking = function (slot0)
	return slot0._currentState == slot0.STATE_ATTACK
end

slot4.Update = function (slot0)
	slot0:UpdateReload()

	if slot0:IsStrikeMode() then
		slot0:MarkTarget()
	end
end

slot4.EnterStrikeMode = function (slot0)
	slot0._strikeMode = true
	slot0._strikeModeData = {
		fxName = slot0._preCastInfo.fx
	}

	slot0:MarkTarget()
end

slot4.MarkTarget = function (slot0)
	slot0:updateMovementInfo()

	if slot0._strikeModeData.aimingTarget == slot0:Tracking() then
		return
	end

	slot3 = slot0.Battle.BattleState.GetInstance():GetSceneMediator()

	if slot0._strikeModeData.aimingTarget and slot0._strikeModeData.aimingFX and slot3:GetCharacter(slot1:GetUniqueID()) then
		slot4:RemoveFX(slot0._strikeModeData.aimingFX)
	end

	table.clear(slot0._strikeModeData)

	if not slot2 then
		return
	end

	slot4 = slot3:GetCharacter(slot2:GetUniqueID())
	slot5 = nil

	if slot0._preCastInfo.fx and #slot0._preCastInfo.fx > 0 then
		slot5 = slot4:AddFX(slot0._preCastInfo.fx)
	end

	slot0._strikeModeData.aimingTarget = slot2
	slot0._strikeModeData.aimingFX = slot5
end

slot4.CancelStrikeMode = function (slot0)
	if slot0._strikeModeData.aimingTarget and slot0._strikeModeData.aimingFX and slot0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(slot0._strikeModeData.aimingTarget:GetUniqueID()) then
		slot2:RemoveFX(slot0._strikeModeData.aimingFX)
	end

	slot0._strikeMode = nil
	slot0._strikeModeData = nil
end

slot4.Tracking = function (slot0)
	return slot0:TargetWeightiest(nil, slot0:GetFilteredList())[1]
end

slot4.Fire = function (slot0)
	slot0._strikeMode = nil

	slot0.Battle.BattleWeaponUnit.Fire(slot0, slot0._strikeModeData.aimingTarget)

	return true
end

slot4.DoAttack = function (slot0, slot1, ...)
	if slot1 == nil or not slot1:IsAlive() or slot0:outOfFireRange(slot1) then
		slot1 = nil

		if slot0._strikeModeData.aimingTarget and slot0._strikeModeData.aimingFX and slot0.Battle.BattleState.GetInstance():GetSceneMediator():GetCharacter(slot0._strikeModeData.aimingTarget:GetUniqueID()) then
			slot3:RemoveFX(slot0._strikeModeData.aimingFX)
		end

		slot0._strikeModeData.aimingTarget = nil
		slot0._strikeModeData.aimingFX = nil
	end

	slot0.Battle.BattleWeaponUnit.DoAttack(slot0, slot1, ...)
end

slot4.Prepar = function (slot0)
	slot0._currentState = slot0.STATE_PRECAST

	slot0:EnterStrikeMode()
end

slot4.Cancel = function (slot0)
	slot0._currentState = slot0.STATE_READY

	slot0:CancelStrikeMode()
end

return

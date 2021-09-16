ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = class("BattleSkillFireSupport", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillFireSupport = slot2
slot2.__name = "BattleSkillFireSupport"

slot2.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1, lv)

	slot0._weaponID = slot0._tempData.arg_list.weapon_id
	slot0._supportTargetFilter = slot0._tempData.arg_list.supportTarget.targetChoice
	slot0._supportTargetArgList = slot0._tempData.arg_list.supportTarget.arg_list
end

slot2.DoDataEffect = function (slot0, slot1, slot2)
	if slot0._weapon == nil then
		slot3 = nil

		for slot7, slot8 in ipairs(slot0._supportTargetFilter) do
			slot3 = slot0.Battle.BattleTargetChoise[slot8](slot1, slot0._supportTargetArgList, slot3)
		end

		slot4 = slot3[1]
		slot0._weapon = slot0.Battle.BattleDataFunction.CreateWeaponUnit(slot0._weaponID, slot1)

		if BATTLE_DEBUG and slot0._weapon:GetType() == slot0.Battle.BattleConst.EquipmentType.SCOUT then
			slot0._weapon:GetATKAircraftList()
		end

		if slot4 then
			slot0._weapon:SetStandHost(slot4)
		end

		slot1:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, slot5))
	end

	slot0._weapon.updateMovementInfo(slot4)
	slot0._weapon:SingleFire(slot2, slot0._emitter, function ()
		slot0._weapon:Clear()
	end)
end

slot2.DoDataEffectWithoutTarget = function (slot0, slot1)
	slot0:DoDataEffect(slot1)
end

slot2.Clear = function (slot0)
	slot0.super.Clear(slot0)

	if slot0._weapon and not slot0._weapon:GetHost():IsAlive() then
		slot0._weapon:Clear()
	end
end

slot2.Interrupt = function (slot0)
	slot0.super.Interrupt(slot0)

	if slot0._weapon then
		slot0._weapon:Cease()
		slot0._weapon:Clear()
	end
end

slot2.GetDamageSum = function (slot0)
	slot1 = 0

	if not slot0._weapon then
		slot1 = 0
	elseif slot0._weapon:GetType() == slot0.Battle.BattleConst.EquipmentType.SCOUT then
		for slot5, slot6 in ipairs(slot0._weapon:GetATKAircraftList()) do
			for slot11, slot12 in ipairs(slot7) do
				slot1 = slot1 + slot12:GetDamageSUM()
			end
		end
	else
		slot1 = slot0._weapon:GetDamageSUM()
	end

	return slot1
end

return

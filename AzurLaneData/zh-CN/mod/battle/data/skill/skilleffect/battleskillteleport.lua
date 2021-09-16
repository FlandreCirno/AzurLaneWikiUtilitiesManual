ys = ys or {}
slot1 = class("BattleSkillTeleport", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillTeleport = slot1
slot1.__name = "BattleSkillTeleport"

slot1.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)
end

slot1.DoDataEffect = function (slot0, slot1, slot2)
	slot1:SetPosition(slot0.calcCorrdinate(slot0._tempData.arg_list, slot1, slot2))
end

slot1.DoDataEffectWithoutTarget = function (slot0, slot1)
	slot1:SetPosition(slot0.calcCorrdinate(slot0._tempData.arg_list, slot1))
end

return

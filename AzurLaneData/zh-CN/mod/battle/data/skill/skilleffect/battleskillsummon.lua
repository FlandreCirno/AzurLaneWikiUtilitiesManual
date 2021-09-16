ys = ys or {}
slot1 = ys.Battle.BattleConst
ys.Battle.BattleSkillSummon = class("BattleSkillSummon", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillSummon.__name = "BattleSkillSummon"

ys.Battle.BattleSkillSummon.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1, lv)

	slot0._spawnData = slot0._tempData.arg_list.spawnData
end

ys.Battle.BattleSkillSummon.DoDataEffectWithoutTarget = function (slot0, slot1, slot2)
	slot0:DoSummon(slot1, slot2)
end

ys.Battle.BattleSkillSummon.DoDataEffect = function (slot0, slot1, slot2, slot3)
	slot0:DoSummon(slot1, slot3)
end

ys.Battle.BattleSkillSummon.DoSummon = function (slot0, slot1, slot2)
	slot0.Battle.BattleDataProxy.GetInstance():SpawnMonster(slot0._spawnData, slot1:GetWaveIndex(), slot1.UnitType.ENEMY_UNIT, slot1:GetIFF())
end

return

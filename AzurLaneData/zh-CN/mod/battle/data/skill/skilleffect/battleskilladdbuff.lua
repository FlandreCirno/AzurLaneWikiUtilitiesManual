ys = ys or {}
ys.Battle.BattleSkillAddBuff = class("BattleSkillAddBuff", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillAddBuff.__name = "BattleSkillAddBuff"

ys.Battle.BattleSkillAddBuff.Ctor = function (slot0, slot1, slot2)
	slot0.Battle.BattleSkillAddBuff.super.Ctor(slot0, slot1, slot2)

	slot0._buffID = slot0._tempData.arg_list.buff_id
end

ys.Battle.BattleSkillAddBuff.DoDataEffect = function (slot0, slot1, slot2)
	if slot2:IsAlive() then
		slot3 = slot0.Battle.BattleBuffUnit.New(slot0._buffID, slot0._level, slot1)

		slot3:SetCommander(slot0._commander)
		slot2:AddBuff(slot3)
	end
end

return

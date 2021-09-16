ys = ys or {}
ys.Battle.BattleSkillChangeDiveState = class("BattleSkillChangeDiveState", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillChangeDiveState.__name = "BattleSkillChangeDiveState"

ys.Battle.BattleSkillChangeDiveState.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._state = slot0._tempData.arg_list.state
end

ys.Battle.BattleSkillChangeDiveState.DoDataEffect = function (slot0, slot1, slot2)
	if slot2:IsAlive() then
		slot2:ChangeOxygenState(slot0._state)
	end
end

return

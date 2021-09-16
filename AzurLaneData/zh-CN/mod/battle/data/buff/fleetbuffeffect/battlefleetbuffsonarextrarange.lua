ys = ys or {}
ys.Battle.BattleFleetBuffSonarExtraRange = class("BattleFleetBuffSonarExtraRange", ys.Battle.BattleFleetBuffEffect)
ys.Battle.BattleFleetBuffSonarExtraRange.__name = "BattleFleetBuffSonarExtraRange"

ys.Battle.BattleFleetBuffSonarExtraRange.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleFleetBuffSonarExtraRange.SetArgs = function (slot0, slot1, slot2)
	slot0._extraRange = slot0._tempData.arg_list.range
end

ys.Battle.BattleFleetBuffSonarExtraRange.onAttach = function (slot0, slot1, slot2)
	slot0:appendRange(slot1)
end

ys.Battle.BattleFleetBuffSonarExtraRange.onStack = function (slot0, slot1, slot2)
	slot0:appendRange(slot1)
end

ys.Battle.BattleFleetBuffSonarExtraRange.appendRange = function (slot0, slot1)
	slot1:GetFleetSonar():AppendExtraSkillRange(slot0._extraRange)
end

return

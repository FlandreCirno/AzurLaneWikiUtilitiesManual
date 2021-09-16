ys = ys or {}
slot1 = class("BattleSkillEditTag", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillEditTag = slot1
slot1.__name = "BattleSkillEditTag"
slot1.TAG_OPERATION_APPEND = 1
slot1.TAG_OPERATION_REMOVE = -1

slot1.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._tag = slot0._tempData.arg_list.tag
	slot0._op = slot0._tempData.arg_list.operation
end

slot1.DoDataEffect = function (slot0, slot1, slot2)
	if slot0._op == slot0.TAG_OPERATION_APPEND then
		slot2:AddLabelTag(slot0._tag)
	elseif slot0._op == slot0.TAG_OPERATION_REMOVE then
		slot2:RemoveLabelTag(slot0._tag)
	end
end

return

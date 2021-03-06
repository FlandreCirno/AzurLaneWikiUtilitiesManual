ys = ys or {}
slot1 = class("BattleBuffAddAttrBloodrage", ys.Battle.BattleBuffAddAttr)
ys.Battle.BattleBuffAddAttrBloodrage = slot1
slot1.__name = "BattleBuffAddAttrBloodrage"

slot1.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

slot1.GetEffectType = function (slot0)
	return slot0.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR
end

slot1.SetArgs = function (slot0, slot1, slot2)
	slot0._group = slot0._tempData.arg_list.group or slot2:GetID()
	slot0._attr = slot0._tempData.arg_list.attr
	slot0._threshold = slot0._tempData.arg_list.threshold
	slot0._value = slot0._tempData.arg_list.value
	slot0._attrBound = slot0._tempData.arg_list.attrBound
	slot0._number = 0
end

slot1.UpdateAttr = function (slot0, slot1)
	if slot0._threshold < slot1:GetHPRate() then
		slot0._number = 0
	else
		slot0._number = (slot0._threshold - slot2) / slot0._value

		if slot0._attrBound then
			slot0._number = math.min(slot0._number, slot0._attrBound)
		end
	end

	slot0.super.UpdateAttr(slot0, slot1)
end

slot1.doOnHPRatioUpdate = function (slot0, slot1, slot2)
	slot0:UpdateAttr(slot1)
end

return

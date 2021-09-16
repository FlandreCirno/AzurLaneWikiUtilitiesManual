ys = ys or {}
slot1 = ys.Battle.BattleFormulas
slot2 = class("BattleSkillPlayCameraFX", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillPlayCameraFX = slot2
slot2.__name = "BattleSkillPlayCameraFX"

slot2.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._FXID = slot0._tempData.arg_list.effect
	slot0._scale = slot0._tempData.arg_list.scale
	slot0._order = slot0._tempData.arg_list.order
end

slot2.DoDataEffect = function (slot0, slot1, slot2)
	slot0.Battle.BattleDataProxy.GetInstance():SpawnCameraFX(slot0._FXID, slot0.calcCorrdinate(slot0._tempData.arg_list, slot1, slot2), slot0._scale, slot0._order)
end

slot2.DoDataEffectWithoutTarget = function (slot0, slot1)
	slot0.Battle.BattleDataProxy.GetInstance():SpawnCameraFX(slot0._FXID, slot0.calcCorrdinate(slot0._tempData.arg_list, slot1), slot0._scale, slot0._order)
end

return

ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleConfig
slot3 = class("BattleEnvironmentBehaviourPlaySFX", ys.Battle.BattleEnvironmentBehaviour)
ys.Battle.BattleEnvironmentBehaviourPlaySFX = slot3
slot3.__name = "BattleEnvironmentBehaviourPlaySFX"

slot3.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot3.SetTemplate = function (slot0, slot1)
	slot0.super.SetTemplate(slot0, slot1)

	slot0._sfx = slot0._tmpData.SFX_ID
end

slot3.doBehaviour = function (slot0)
	slot0.Battle.PlayBattleSFX(slot0._sfx)
	slot0.Battle.PlayBattleSFX.super.doBehaviour(slot0)
end

return

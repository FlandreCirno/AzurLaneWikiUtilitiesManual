ys = ys or {}
ys.Battle.BattleScaleBullet = class("BattleScaleBullet", ys.Battle.BattleBullet)
ys.Battle.BattleScaleBullet.__name = "BattleScaleBullet"

ys.Battle.BattleScaleBullet.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleScaleBullet.Update = function (slot0, slot1)
	slot0.super.Update(slot0, slot1)
	slot0:updateModelScale()
end

ys.Battle.BattleScaleBullet.updateModelScale = function (slot0)
	slot0._tf.localScale.x = slot0._bulletData:GetBoxSize().x * 2
	slot0._tf.localScale = slot0._tf.localScale
end

return

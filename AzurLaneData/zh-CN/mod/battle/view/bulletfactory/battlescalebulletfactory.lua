ys = ys or {}
slot1 = ys.Battle.BattleConst.UnitType
ys.Battle.BattleScaleBulletFactory = singletonClass("BattleScaleBulletFactory", ys.Battle.BattleCannonBulletFactory)
ys.Battle.BattleScaleBulletFactory.__name = "BattleScaleBulletFactory"

ys.Battle.BattleScaleBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleScaleBulletFactory.MakeBullet = function (slot0)
	return slot0.Battle.BattleScaleBullet.New()
end

return

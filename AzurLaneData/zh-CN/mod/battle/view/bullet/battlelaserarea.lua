ys = ys or {}
slot1 = ys.Battle.BattleBulletEvent
slot2 = ys.Battle.BattleResourceManager
slot3 = ys.Battle.BattleConfig
slot4 = class("BattleLaserArea", ys.Battle.BattleBullet)
ys.Battle.BattleLaserArea = slot4
slot4.__name = "BattleLaserArea"

slot4.Update = function (slot0, slot1)
	slot2 = slot0._bulletData:GetSpeed()

	slot0._curSpeed:Set(slot2.x, slot2.y, slot2.z)

	if slot0._bulletData:GetVerticalSpeed() ~= 0 then
		slot0._curSpeed.y = slot0._curSpeed.y + slot3
	end

	slot0:UpdatePosition()
end

return

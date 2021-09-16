ys = ys or {}
slot1 = ys.Battle.BattleBulletEvent
slot2 = ys.Battle.BattleFormulas
slot3 = Vector3.up
slot4 = ys.Battle.BattleVariable
slot5 = ys.Battle.BattleConfig
slot7 = ys.Battle.BattleTargetChoise
slot8 = class("BattleColumnAreaBulletUnit", ys.Battle.BattleAreaBulletUnit)
slot8.__name = "BattleColumnAreaBulletUnit"
ys.Battle.BattleColumnAreaBulletUnit = slot8
slot8.AreaType = ys.Battle.BattleConst.AreaType.COLUMN

slot8.InitCldComponent = function (slot0)
	slot2 = slot0:GetTemplate().cld_offset
	slot0._cldComponent = slot0.Battle.BattleColumnCldComponent.New(slot0:GetTemplate().cld_box[1], slot0.GetTemplate().cld_box[3])

	slot0._cldComponent:SetCldData({
		type = slot1.CldType.AOE,
		UID = slot0:GetUniqueID(),
		IFF = slot0:GetIFF()
	})
end

slot8.GetBoxSize = function (slot0)
	slot1 = slot0._cldComponent:GetCldBoxSize()

	return Vector3(slot1.range, slot1.range, slot1.tickness)
end

return

ys = ys or {}
slot1 = ys.Battle.BattleConst
ys.Battle.BattleWallData = class("BattleWallData")
ys.Battle.BattleWallData.__name = "BattleWallData"
ys.Battle.BattleWallData.CLD_OBJ_TYPE_BULLET = 1
ys.Battle.BattleWallData.CLD_OBJ_TYPE_SHIP = 2

ys.Battle.BattleWallData.Ctor = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0._id = slot1
	slot0._host = slot2
	slot0._cldFun = slot3
	slot0._cldBox = slot4
	slot0._cldOffset = slot5

	slot0:InitCldComponent()
end

ys.Battle.BattleWallData.InitCldComponent = function (slot0)
	slot2 = slot0._cldOffset

	if slot0._cldBox.range then
		slot0._cldComponent = slot0.Battle.BattleColumnCldComponent.New(slot1.range, 5, slot2[1], slot2[3])
	else
		slot0._cldComponent = slot0.Battle.BattleCubeCldComponent.New(slot1[1], slot1[2], slot1[3], slot2[1], slot2[3])
	end

	slot0._cldComponent:SetCldData(slot3)
	slot0._cldComponent:SetActive(true)
	slot0:SetCldObjType()
end

ys.Battle.BattleWallData.IsActive = function (slot0)
	return slot0._host:IsWallActive()
end

ys.Battle.BattleWallData.DeactiveCldBox = function (slot0)
	slot0._cldComponent:SetActive(false)
end

ys.Battle.BattleWallData.GetCldBox = function (slot0)
	return slot0._cldComponent:GetCldBox(slot0:GetPosition())
end

ys.Battle.BattleWallData.GetCldData = function (slot0)
	return slot0._cldComponent:GetCldData()
end

ys.Battle.BattleWallData.GetBoxSize = function (slot0)
	return slot0._cldComponent:GetCldBoxSize()
end

ys.Battle.BattleWallData.GetHost = function (slot0)
	return slot0._host
end

ys.Battle.BattleWallData.GetIFF = function (slot0)
	return slot0:GetHost():GetIFF()
end

ys.Battle.BattleWallData.GetPosition = function (slot0)
	return slot0:GetHost():GetPosition()
end

ys.Battle.BattleWallData.GetUniqueID = function (slot0)
	return slot0._id
end

ys.Battle.BattleWallData.GetCldFunc = function (slot0)
	return slot0._cldFun
end

ys.Battle.BattleWallData.SetCldObjType = function (slot0, slot1)
	slot0._cldObjType = slot1 or slot0.CLD_OBJ_TYPE_BULLET
end

ys.Battle.BattleWallData.GetCldObjType = function (slot0)
	return slot0._cldObjType
end

return

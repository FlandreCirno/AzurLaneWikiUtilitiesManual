ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleConfig
slot3 = class("BattleArcEffect")
ys.Battle.BattleArcEffect = slot3
slot3.__name = "BattleArcEffect"

slot3.Ctor = function (slot0, slot1, slot2, slot3, slot4)
	slot0._go = slot1
	slot0._characterA = slot2
	slot0._unitA = slot2:GetUnitData()
	slot0._unitB = slot3
	slot0._boundBone = slot4
	slot0._material = slot0._go.transform:GetComponent(typeof(Renderer)).material
	slot0._vectorA = Vector4.New(slot0._characterA:GetBonePos(slot0._boundBone).x, 5, slot0._characterA.GetBonePos(slot0._boundBone).z, 1)
	slot0._vectorB = Vector4.New(slot0._unitB:GetPosition().x, 5, slot0._unitB.GetPosition().z, 1)

	slot0._material:SetVector("_PosBegin", slot0._vectorA)
	slot0._material:SetVector("_PosEnd", slot0._vectorB)
end

slot3.Update = function (slot0)
	if slot0._unitA:IsAlive() and slot0._unitB:IsAlive() then
		slot0._vectorA.x = slot0._characterA:GetBonePos(slot0._boundBone).x
		slot0._vectorA.z = slot0._characterA.GetBonePos(slot0._boundBone).z
		slot0._vectorB.x = slot0._unitB:GetPosition().x
		slot0._vectorB.z = slot0._unitB.GetPosition().z

		slot0._material:SetVector("_PosBegin", slot0._vectorA)
		slot0._material:SetVector("_PosEnd", slot0._vectorB)

		slot0._go.transform.position = slot0._vectorA
	else
		slot0._callback()
	end
end

slot3.ConfigCallback = function (slot0, slot1)
	slot0._callback = slot1

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot0._go, Vector3.zero, true, slot0._callback)
end

slot3.Dispose = function (slot0)
	slot0._callback = nil
	slot0._material = nil
	slot0._go = nil
	slot0._unitA = nil
	slot0._unitB = nil
	slot0._vectorA = nil
	slot0._vectorB = nil
end

return

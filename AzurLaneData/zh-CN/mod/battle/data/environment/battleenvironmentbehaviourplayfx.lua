ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleConfig
slot3 = class("BattleEnvironmentBehaviourPlayFX", ys.Battle.BattleEnvironmentBehaviour)
ys.Battle.BattleEnvironmentBehaviourPlayFX = slot3
slot3.__name = "BattleEnvironmentBehaviourPlayFX"

slot3.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot3.SetTemplate = function (slot0, slot1)
	slot0.super.SetTemplate(slot0, slot1)

	slot0._FXID = slot0._tmpData.FX_ID
	slot0._offset = (slot0._tmpData.offset and Vector3(unpack(slot0._tmpData.offset))) or Vector3.zero
end

slot3.doBehaviour = function (slot0)
	slot1 = 1

	if slot0._tmpData.scaleRate then
		slot4 = nil

		if slot0._unit:GetAOEData().GetAreaType(slot2) == slot0.AreaType.CUBE then
			slot4 = slot2:GetWidth()
		elseif slot3 == slot0.AreaType.COLUMN then
			slot4 = slot2:GetRange()
		end

		slot1 = slot0._tmpData.scaleRate * slot4
	elseif slot0._tmpData.scale then
		slot1 = slot0._tmpData.scale
	end

	slot1.Battle.BattleDataProxy.GetInstance().SpawnEffect(slot3, slot0._FXID, slot0._unit:GetAOEData():GetPosition() + slot0._offset, slot1)
	slot2.super.doBehaviour(slot0)
end

return

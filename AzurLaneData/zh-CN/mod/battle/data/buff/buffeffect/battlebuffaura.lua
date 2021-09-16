ys = ys or {}
slot1 = class("BattleBuffAura", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffAura = slot1
slot1.__name = "BattleBuffAura"
slot2 = ys.Battle.BattleConst

slot1.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

slot1.SetArgs = function (slot0, slot1, slot2)
	slot0._buffLevel = slot2:GetLv()
	slot0._auraRange = slot0._tempData.arg_list.cld_data.box.range
	slot0._buffID = slot0._tempData.arg_list.buff_id
	slot0._aura = slot0.Battle.BattleDataProxy.GetInstance().SpawnAura(slot7, slot1, slot1.AOEField.SURFACE, slot0._auraRange, function (slot0)
		slot1 = slot0:getTargetList(slot0.getTargetList, {
			"TargetAllHarm"
		})

		for slot5, slot6 in ipairs(slot0) do
			if slot6.Active then
				for slot10, slot11 in ipairs(slot1) do
					if slot11:GetUniqueID() == slot6.UID then
						slot11:AddBuff(slot2.Battle.BattleBuffUnit.New(slot0._buffID, slot0._buffLevel, slot0._caster))

						break
					end
				end
			end
		end
	end, function (slot0)
		if slot0.Active then
			for slot5, slot6 in ipairs(slot1) do
				if slot6:GetUniqueID() == slot0.UID then
					slot6:RemoveBuff(slot0._buffID)

					break
				end
			end
		end
	end, function (slot0)
		if slot0.Active then
			for slot5, slot6 in ipairs(slot1) do
				if slot6:GetUniqueID() == slot0.UID then
					slot6:RemoveBuff(slot0._buffID)

					break
				end
			end
		end
	end)
end

slot1.Clear = function (slot0)
	slot0._aura:SetActiveFlag(false)

	slot0._aura = nil

	slot0.super.Clear(slot0)
end

return

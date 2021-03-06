ys = ys or {}
slot1 = ys.Battle.BattleConfig
slot2 = ys.Battle.BattleVariable
ys.Battle.BattleSkillUnit = class("BattleSkillUnit")
ys.Battle.BattleSkillUnit.__name = "BattleSkillUnit"

ys.Battle.BattleSkillUnit.Ctor = function (slot0, slot1, slot2)
	slot0._id = slot1
	slot0._level = slot2
	slot0._tempData = slot0.Battle.BattleDataFunction.GetSkillTemplate(slot1, slot2)
	slot0._cd = slot0._tempData.cd
	slot0._effectList = {}
	slot0._lastEffectTarget = {}

	for slot6, slot7 in ipairs(slot0._tempData.effect_list) do
		slot0._effectList[slot6] = slot0.Battle[slot7.type].New(slot7, slot2)
	end

	slot0._dataProxy = slot0.Battle.BattleDataProxy.GetInstance()
end

ys.Battle.BattleSkillUnit.GenerateSpell = function (slot0, slot1, slot2, slot3)
	slot0.Battle.BattleSkillUnit.New(slot0, slot1)._attachData = slot3

	return slot0.Battle.BattleSkillUnit.New(slot0, slot1)
end

ys.Battle.BattleSkillUnit.GetSkillEffectList = function (slot0)
	return slot0._effectList
end

ys.Battle.BattleSkillUnit.Cast = function (slot0, slot1, slot2)
	slot4 = slot0.Battle.BattleState.GetInstance().GetUIMediator(slot3)

	if slot0._tempData.focus_duration then
		slot4:ShowSkillPainting(slot1, slot0._tempData)
	end

	if slot0._tempData.painting == 1 then
		if slot2 then
			slot4:ShowSkillFloat(slot1, slot2:getSkills()[1]:getConfig("name"), slot2:getPainting())
		else
			slot4:ShowSkillFloat(slot1, slot0._tempData.name)
		end
	elseif type(slot0._tempData.painting) == "string" then
		slot4:ShowSkillFloatCover(slot1, slot0._tempData.name, slot0._tempData.painting)
	end

	if type(slot0._tempData.castCV) == "string" then
		slot1:DispatchVoice(slot0._tempData.castCV)
	elseif slot5 == "table" then
		slot6, slot11, slot8 = ShipWordHelper.GetWordAndCV(slot0._tempData.castCV.skinID, slot0._tempData.castCV.key)

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot7)
	end

	slot6 = slot0._attachData

	for slot10, slot11 in ipairs(slot0._effectList) do
		slot0._lastEffectTarget = slot11:GetTarget(slot1, slot0)

		slot11:SetCommander(slot2)
		slot11:Effect(slot1, slot11.GetTarget(slot1, slot0), slot6)
	end

	if slot0._tempData.aniEffect and slot7 ~= "" then
		slot1:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.ADD_EFFECT, {
			effect = slot7.effect,
			time = slot7.time,
			offset = slot7.offset,
			posFun = slot7.posFun
		}))
	end

	slot0._dataProxy:DispatchEvent(slot0.Event.New(slot0.Battle.BattleEvent.CAST_SKILL, {
		skillID = slot0._id,
		caster = slot1
	}))
end

ys.Battle.BattleSkillUnit.SetTarget = function (slot0, slot1)
	slot0._lastEffectTarget = slot1
end

ys.Battle.BattleSkillUnit.Interrupt = function (slot0)
	for slot4, slot5 in ipairs(slot0._effectList) do
		slot5:Interrupt()
	end
end

ys.Battle.BattleSkillUnit.Clear = function (slot0)
	for slot4, slot5 in ipairs(slot0._effectList) do
		slot5:Clear()
	end
end

ys.Battle.BattleSkillUnit.GetDamageSum = function (slot0)
	slot1 = 0

	for slot5, slot6 in ipairs(slot0._effectList) do
		slot1 = slot6:GetDamageSum() + slot1
	end

	return slot1
end

ys.Battle.BattleSkillUnit.IsFireSkill = function (slot0, slot1)
	slot2 = false

	for slot7, slot8 in ipairs(slot0.Battle.BattleDataFunction.GetSkillTemplate(slot0, slot1).effect_list) do
		if slot8.type == slot0.Battle.BattleSkillFire.__name or slot8.type == slot0.Battle.BattleSkillFireSupport.__name then
			slot2 = true

			break
		end
	end

	return slot2
end

return

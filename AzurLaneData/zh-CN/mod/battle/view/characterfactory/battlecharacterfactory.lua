ys = ys or {}
slot1 = ys.Battle.BattleConfig
slot2 = singletonClass("BattleCharacterFactory")
ys.Battle.BattleCharacterFactory = slot2
slot2.__name = "BattleCharacterFactory"
slot2.HP_BAR_NAME = ""
slot2.POPUP_NAME = "popup"
slot2.TAG_NAME = "ChargeAreaContainer/LockTag"
slot2.MOVE_WAVE_FX_POS = Vector3(0, -2.3, -1.5)
slot2.MOVE_WAVE_FX_NAME = "movewave"
slot2.SMOKE_FX_NAME = "smoke"
slot2.BOMB_FX_NAME = "Bomb"
slot2.DANCHUAN_MOVE_WAVE_FX_NAME = "danchuanlanghuazhong2"

slot2.Ctor = function (slot0)
	return
end

slot2.CreateCharacter = function (slot0, slot1)
	slot3 = slot0:MakeCharacter()

	slot3:SetFactory(slot0)
	slot3:SetUnitData(slot2)
	slot0:MakeModel(slot3)

	return slot3
end

slot2.GetSceneMediator = function (slot0)
	return slot0.Battle.BattleState.GetInstance():GetMediatorByName(slot0.Battle.BattleSceneMediator.__name)
end

slot2.GetFXPool = function (slot0)
	return slot0.Battle.BattleFXPool.GetInstance()
end

slot2.GetCharacterPool = function (slot0)
	return slot0.Battle.BattleResourceManager.GetInstance()
end

slot2.GetHPBarPool = function (slot0)
	return slot0.Battle.BattleHPBarManager.GetInstance()
end

slot2.GetDivingFilterColor = function (slot0)
	slot2 = slot0.Battle.BattleDataFunction.GetDivingFilter(slot1)

	return Color.New(slot2.r, slot2.g, slot2.b, slot2.a)
end

slot2.GetFXContainerPool = function (slot0)
	return slot0.Battle.BattleCharacterFXContainersPool.GetInstance()
end

slot2.MakeCharacter = function (slot0)
	return nil
end

slot2.MakeModel = function (slot0, slot1)
	return nil
end

slot2.MakeBloodBar = function (slot0, slot1)
	return nil
end

slot2.SetHPBarWidth = function (slot0, slot1, slot2, slot3)
	slot2.transform.sizeDelta = Vector2(slot5, slot7)
	slot8.sizeDelta = Vector2(slot1:GetUnitData().GetTemplate(slot4).hp_bar[1] + slot3 or 0, slot2.transform.Find(slot6, "blood").transform.rect.height)
end

slot2.MakeUIComponentContainer = function (slot0, slot1)
	slot1:AddUIComponentContainer()
end

slot2.MakeFXContainer = function (slot0, slot1)
	SetActive(slot4, true)
	slot0:GetFXPool():PopCharacterAttachPoint().transform.SetParent(slot4, slot2, false)

	slot0.GetFXPool().PopCharacterAttachPoint().transform.localPosition = Vector3.zero
	slot0.GetFXPool().PopCharacterAttachPoint().transform.localEulerAngles = Vector3(slot1:GetTf().localEulerAngles.x * -1, slot1.GetTf().localEulerAngles.y, slot1.GetTf().localEulerAngles.z)
	slot6 = slot1:GetUnitData():GetTemplate().fx_container
	slot7 = {}

	for slot11, slot12 in ipairs(slot0.Battle.BattleConst.FXContainerIndex) do
		slot7[slot11] = Vector3(slot6[slot11][1], slot6[slot11][2], slot6[slot11][3])
	end

	slot1:AddFXOffsets(slot3, slot7)
end

slot2.MakeShadow = function (slot0)
	return nil
end

slot2.MakeSmokeFX = function (slot0, slot1)
	slot3 = {}

	for slot7, slot8 in ipairs(slot2) do
		slot10 = {}

		for slot14, slot15 in ipairs(slot9) do
			slot16 = {
				unInitialize = true,
				resID = slot15[1],
				pos = Vector3(slot15[2][1], slot15[2][2], slot15[2][3]),
				[slot16] = false
			}
		end

		slot3[slot7] = {
			active = false,
			rate = slot8[1] / 100,
			smokes = slot10
		}
	end

	slot1:AddSmokeFXs(slot3)
end

slot2.MakeEquipSkinAttachment = function (slot0, slot1)
	if slot1:GetUnitData():GetSkinAttachmentInfo() then
		for slot6, slot7 in pairs(slot2) do
			slot1:AddFX(slot7)
		end
	end
end

slot2.MakeWaveFX = function (slot0, slot1)
	slot1:AddWaveFX(slot0.MOVE_WAVE_FX_NAME)
end

slot2.MakePopNumPool = function (slot0, slot1)
	slot1:AddPopNumPool(slot0:GetSceneMediator():GetPopNumPool())
end

slot2.MakeTag = function (slot0, slot1)
	return slot0.Battle.BattleLockTag.New(slot0:GetSceneMediator():InstantiateCharacterComponent(slot0.TAG_NAME), slot1)
end

slot2.MakePopup = function (slot0)
	return slot0:GetSceneMediator():InstantiateCharacterComponent(slot0.POPUP_NAME)
end

slot2.MakeArrowBar = function (slot0, slot1)
	slot1:AddArrowBar(slot0:GetSceneMediator():InstantiateCharacterComponent(slot0.ARROW_BAR_NAME))
	slot1:UpdateArrowBarPostition()
end

slot2.MakeCastClock = function (slot0, slot1)
	slot1:AddCastClock(slot0:GetSceneMediator():InstantiateCharacterComponent("CastClockContainer/castClock"))
end

slot2.MakeBarrierClock = function (slot0, slot1)
	slot1:AddBarrierClock(slot0:GetSceneMediator():InstantiateCharacterComponent("CastClockContainer/shieldClock"))
end

slot2.MakeVigilantBar = function (slot0, slot1)
	slot1:AddVigilantBar(slot0:GetSceneMediator():InstantiateCharacterComponent("AntiSubVigilantContainer/antiSubMeter"))
	slot1:UpdateVigilantBarPosition()
end

slot2.MakeCloakBar = function (slot0, slot1)
	slot1:AddCloakBar(slot0:GetSceneMediator():InstantiateCharacterComponent("CloakContainer/cloakMeter"))
	slot1:UpdateCloakBarPosition()
end

slot2.RemoveCharacter = function (slot0, slot1, slot2)
	if slot1:GetUnitData():GetTemplate().nationality and table.contains(slot0.SWEET_DEATH_NATIONALITY, slot3) then
	elseif slot2 and slot2 ~= slot1.Battle.BattleConst.UnitDeathReason.KILLED then
	else
		slot8, slot10 = slot0:GetFXPool():GetFX(slot0.BOMB_FX_NAME)

		pg.EffectMgr.GetInstance():PlayBattleEffect(slot4, slot5:Add(slot1:GetPosition()), true)
	end

	slot1:Dispose()
	slot0:GetFXPool():PushCharacterAttachPoint(slot1:GetAttachPoint())
end

return

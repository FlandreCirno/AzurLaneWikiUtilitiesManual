ys = ys or {}
slot1 = ys.Battle.BattleUnitEvent
slot2 = class("BattleBossCharacter", ys.Battle.BattleEnemyCharacter)
ys.Battle.BattleBossCharacter = slot2
slot2.__name = "BattleBossCharacter"

slot2.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot2.Dispose = function (slot0)
	if not slot0._chargeTimer.paused then
		slot0._chargeTimer:Stop()
	end

	if slot0._castClock then
		slot0._castClock:Dispose()

		slot0._castClock = nil
	end

	LeanTween.cancel(slot0._HPBar)
	slot0.super.Dispose(slot0)
end

slot2.Update = function (slot0)
	slot0.super.Update(slot0)
	slot0:UpdateCastClockPosition()

	if slot0._armor then
		slot0:UpdateCastClock()
	end

	slot0:UpdateBarrierClockPosition()

	if slot0._barrier then
		slot0:updateBarrierClock()
	end
end

slot2.UpdateVigilantBarPosition = function (slot0)
	slot0._vigilantBar:UpdateVigilantBarPosition(slot0._referenceVector + slot0._hpBarOffset)
end

slot2.RegisterWeaponListener = function (slot0, slot1)
	slot0.super.RegisterWeaponListener(slot0, slot1)
	slot1:RegisterEventListener(slot0, slot1.WEAPON_INTERRUPT, slot0.onWeaponInterrupted)
end

slot2.UnregisterWeaponListener = function (slot0, slot1)
	slot0.super.UnregisterWeaponListener(slot0, slot1)
	slot1:UnregisterEventListener(slot0, slot1.WEAPON_INTERRUPT)
end

slot2.AddHPBar = function (slot0, slot1, slot2)
	slot0._HPBar = slot1
	slot0._HPBarTf = slot1.transform

	slot1:SetActive(true)
	slot0._unitData:RegisterEventListener(slot0, slot0.UPDATE_HP, slot0.OnUpdateHP)

	slot0._HPBarCountText = slot0._HPBarTf.Find(slot3, "HPBarCount"):GetComponent(typeof(Text))
	slot0._activeVernier = slot2

	slot0:SetTemplateInfo()
	slot0:initBarComponent()
	slot0:SetHPBarCountText(slot0._HPBarTotalCount)

	slot0._cacheHP = slot0._unitData:GetMaxHP()

	slot0:UpdateHpBar()
	slot0:initBarrierBar()
end

slot2.SetTemplateInfo = function (slot0)
	slot2 = ""

	if slot0._unitData:GetTemplate() then
		slot2 = slot1.name
	end

	changeToScrollText(slot0._HPBarTf:Find("BossName"), slot2)

	slot0._HPBarTf:Find("BossLv"):GetComponent(typeof(Text)).text = "Lv." .. slot0._unitData:GetLevel()

	setImageSprite(slot0._HPBarTf:Find("BossIcon/typeIcon/icon"), slot4, true)
	setImageSprite(findTF(slot0._HPBarTf, "BossIcon/icon"), slot6)

	slot0._armorBar = slot0._HPBarTf:Find("ArmorBar")
	slot0._armorProgress = slot0._HPBarTf:Find("ArmorBar/armorProgress"):GetComponent(typeof(Image))

	SetActive(slot0._armorBar, false)

	slot0._barrierBar = slot0._HPBarTf:Find("ShieldBar")
	slot0._barrierProgress = slot0._barrierBar:Find("shieldProgress"):GetComponent(typeof(Image))

	SetActive(slot0._barrierBar, false)
end

slot2.SetBossData = function (slot0, slot1)
	slot0._bossBarInfoList = {}
	slot0._HPBarTotalCount = slot1.hpBarNum or 1
	slot0._hideBarNum = slot1.hideBarNum
	slot0._bossIcon = slot0:GetUnitData():GetTemplate().icon
	slot0._bossIndex = slot1.bossCount
end

slot2.GetBossIndex = function (slot0)
	return slot0._bossIndex
end

slot2.initBarComponent = function (slot0)
	slot0._stepHP = slot0:GetUnitData():GetMaxHP() / slot0._HPBarTotalCount
	slot2 = 1
	slot0._resTotalCount = 5
	slot0._bossBarInfoList = {}

	while slot2 <= slot0._resTotalCount do
		slot6 = slot0._HPBarTf:Find(slot4)
		slot7 = slot0._HPBarTf:Find(slot5)
		({
			progressImage = slot6:GetComponent(typeof(Image)),
			deltaImage = slot7:GetComponent(typeof(Image)),
			progressTF = slot6.transform,
			deltaTF = slot7.transform
		})["progressImage"].fillAmount = 1
		()["deltaImage"].fillAmount = 1
		slot0._bossBarInfoList[slot2] = 
		slot2 = slot2 + 1
	end

	slot0._topBarIndex = slot0._HPBarTf.childCount - 1
	slot0._currentFmod = math.fmod(slot0._HPBarTotalCount, slot0._resTotalCount)

	if slot0._currentFmod == 0 then
		slot0._currentFmod = slot0._resTotalCount
	end

	if slot0._HPBarTotalCount < 5 then
		slot3 = slot0._resTotalCount

		while slot0._HPBarTotalCount < slot3 do
			SetActive(slot0._HPBarTf:Find(slot4), false)
			SetActive(slot0._HPBarTf:Find(slot4 .. "_delta"), false)

			slot3 = slot3 - 1
		end
	else
		slot3 = slot0._resTotalCount

		while slot0._currentFmod < slot3 do
			slot0._HPBarTf:Find(slot4).transform:SetSiblingIndex(0)
			slot0._HPBarTf:Find(slot4 .. "_delta").transform:SetSiblingIndex(0)

			slot3 = slot3 - 1
		end
	end

	if slot0._activeVernier then
		slot0._vernier = slot0._HPBarTf:Find("vernier/tag")

		SetActive(slot0._HPBarTf:Find("vernier"), slot0._activeVernier)
	end

	slot0._chargeTimer = Timer.New(function ()
		slot0._currentTween = slot0:generateTween()
	end, 1)
end

slot2.UpdateHpBar = function (slot0)
	if slot0._cacheHP == slot0._unitData:GetCurrentHP() then
		return
	end

	if not slot0._chargeTimer.paused then
		slot0._chargeTimer:Stop()
		slot0._chargeTimer:Stop()
		slot0._chargeTimer:Reset()
	end

	slot7, slot3, slot8 = slot0:GetCurrentFmod()

	slot0:SortBar(slot2, slot4)

	slot0._currentFmod = slot2
	slot0._currentDivision = slot4

	if slot1 < slot0._cacheHP then
		if slot0._currentDivision ~= slot4 then
			LeanTween.cancel(slot0._HPBar)
		end

		slot0._chargeTimer:Start()
	end

	slot0._bossBarInfoList[slot2].progressImage.fillAmount = slot3

	if slot0._activeVernier then
		slot0._vernier.anchorMin = Vector2(currentRate, 0.5)
		slot0._vernier.anchorMax = Vector2(currentRate, 0.5)
	end

	slot0:SetHPBarCountText(slot4)

	slot0._cacheHP = slot1
end

slot2.generateTween = function (slot0)
	duration = duration or 0.7

	return LeanTween.value(go(slot0._HPBar), slot0._bossBarInfoList[slot0._currentFmod].deltaImage.fillAmount, slot0._bossBarInfoList[slot0._currentFmod].progressImage.fillAmount, 0.7):setOnUpdate(System.Action_float(function (slot0)
		slot0.fillAmount = slot0
	end))
end

slot2.GetCurrentFmod = function (slot0)
	slot2, slot3 = math.modf(slot0._unitData:GetCurrentHP() / slot0._stepHP)

	if math.fmod(slot2 + 1, slot0._resTotalCount) == 0 then
		slot4 = 5
	end

	return slot4, slot3, slot2
end

slot2.SortBar = function (slot0, slot1, slot2)
	if slot1 == slot0._currentFmod then
		return
	elseif slot0._currentFmod < slot1 then
		slot0._bossBarInfoList[slot0._currentFmod].progressImage.fillAmount = 1
		slot0._bossBarInfoList[slot0._currentFmod].deltaImage.fillAmount = 1

		while slot3 < slot1 do
			slot0._bossBarInfoList[slot3 + 1].deltaTF:SetSiblingIndex(slot0._topBarIndex)
			slot0._bossBarInfoList[slot3 + 1].progressTF:SetSiblingIndex(slot0._topBarIndex)
			SetActive(slot0._bossBarInfoList[slot3 + 1].progressImage, true)
			SetActive(slot0._bossBarInfoList[slot3 + 1].deltaImage, true)
		end
	elseif slot1 < slot0._currentFmod then
		slot3 = slot0._currentFmod

		while slot1 < slot3 do
			slot0._bossBarInfoList[slot3].progressImage.fillAmount = 1
			slot0._bossBarInfoList[slot3].deltaImage.fillAmount = 1

			slot0._bossBarInfoList[slot3].progressTF:SetSiblingIndex(0)
			slot0._bossBarInfoList[slot3].deltaTF:SetSiblingIndex(0)

			if slot2 < slot0._resTotalCount then
				SetActive(slot4.progressImage, false)
				SetActive(slot4.deltaImage, false)
			end

			slot3 = slot3 - 1
		end
	end
end

slot2.SetHPBarCountText = function (slot0, slot1)
	if slot0._hideBarNum then
		slot0._HPBarCountText.text = "X??"
	else
		slot0._HPBarCountText.text = "X " .. slot1
	end
end

slot2.UpdateHPBarPostition = function (slot0)
	return
end

slot2.onWeaponPreCast = function (slot0, slot1)
	slot0.super.onWeaponPreCast(slot0, slot1)
	slot0:initArmorBar(slot1.Data.armor)

	if slot1.Data.armor and slot3 ~= 0 then
		slot0:initCastClock(slot2.time, slot1.Dispatcher)
	end
end

slot2.onWeaponPrecastFinish = function (slot0, slot1)
	slot0.super.onWeaponPrecastFinish(slot0, slot1)

	slot3 = slot1.Data.armor

	if slot0._castClock:GetCastingWeapon() == slot1.Dispatcher and slot3 and slot3 ~= 0 then
		if slot0._armor <= 0 then
			slot0._castClock:Interrupt(true)
		else
			slot0._castClock:Interrupt(false)
		end

		slot0._armor = nil

		SetActive(slot0._armorBar, false)
	end
end

slot2.onWeaponInterrupted = function (slot0, slot1)
	slot0._unitData:StateChange(slot0.Battle.UnitState.STATE_INTERRUPT)
end

slot2.initArmorBar = function (slot0, slot1)
	if slot1 and slot1 ~= 0 then
		slot0._armor = slot1
		slot0._totalArmor = slot1

		slot0:updateWeaponArmor()
		SetActive(slot0._armorBar, true)
	end
end

slot2.OnUpdateHP = function (slot0, slot1)
	slot2 = slot1.Data.preShieldHP

	if slot0._barrier and slot2 < 0 then
		slot0._barrier = slot0._barrier + slot2

		slot0:updateBarrierBar()
	end

	slot0.super.OnUpdateHP(slot0, slot1)

	slot3 = slot1.Data.dHP

	if slot0._armor and slot3 < 0 then
		slot0._armor = slot0._armor + slot3

		slot0:updateWeaponArmor()
	end
end

slot2.updateWeaponArmor = function (slot0)
	slot0._armorProgress.fillAmount = slot0._armor / slot0._totalArmor
end

slot2.initCastClock = function (slot0, slot1, slot2)
	slot0._castClock:Casting(slot1, slot2)

	slot0._castFinishTime = pg.TimeMgr.GetInstance():GetCombatTime() + slot1
	slot0._castDuration = slot1
end

slot2.UpdateCastClock = function (slot0)
	slot0._castClock:UpdateCastClock()
end

slot2.updateComponentDiveInvisible = function (slot0)
	slot0.super.updateComponentDiveInvisible(slot0)
	SetActive(slot0._HPBarTf, true)
end

slot2.initBarrierBar = function (slot0)
	slot0._unitData:RegisterEventListener(slot0, slot0.BARRIER_STATE_CHANGE, slot0.onBarrierStateChange)
end

slot2.onBarrierStateChange = function (slot0, slot1)
	slot3 = slot1.Data.barrierDuration

	SetActive(slot0._barrierBar, slot1.Data.barrierDurability > 0)

	if slot2 > 0 then
		slot0._totalBarrier = slot2
		slot0._barrier = slot2

		slot0:initBarrierClock(slot3)
		slot0:updateBarrierBar()
		slot0:updateBarrierClock()
	else
		slot0._barrier = nil
		slot0._totalBarrier = nil

		slot0._barrierClock:Interrupt()
	end
end

slot2.updateBarrierBar = function (slot0)
	slot0._barrierProgress.fillAmount = slot0._barrier / slot0._totalBarrier
end

slot2.updateBarrierClock = function (slot0)
	slot0._barrierClock:UpdateBarrierClockProgress()
end

slot2.initBarrierClock = function (slot0, slot1)
	slot0._barrierClock:Shielding(slot1)
end

return
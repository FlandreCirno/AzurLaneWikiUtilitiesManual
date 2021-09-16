ys = ys or {}
ys.Battle.BattleCloakBar = class("BattleCloakBar")
ys.Battle.BattleCloakBar.__name = "BattleCloakBar"
ys.Battle.BattleCloakBar.FORM_RAD = "radian"
ys.Battle.BattleCloakBar.FORM_BAR = "bar"
ys.Battle.BattleCloakBar.MIN = 0.31
ys.Battle.BattleCloakBar.MAX = 0.69
ys.Battle.BattleCloakBar.METER_LENGTH = ys.Battle.BattleCloakBar.MAX - ys.Battle.BattleCloakBar.MIN
ys.Battle.BattleCloakBar.MIN_ANGLE = -31
ys.Battle.BattleCloakBar.MAX_ANGLE = 33
ys.Battle.BattleCloakBar.RESTORE_LEGHTH = ys.Battle.BattleCloakBar.MAX_ANGLE - ys.Battle.BattleCloakBar.MIN_ANGLE
ys.Battle.BattleCloakBar.BAR_MIN = -62
ys.Battle.BattleCloakBar.BAR_MAX = 62
ys.Battle.BattleCloakBar.BAR_STEP = ys.Battle.BattleCloakBar.BAR_MAX - ys.Battle.BattleCloakBar.BAR_MIN

ys.Battle.BattleCloakBar.Ctor = function (slot0, slot1, slot2)
	slot0._cloakBar = slot1
	slot0._cloakBarGO = slot0._cloakBar.gameObject
	slot0._progress = slot0._cloakBar:Find("progress"):GetComponent(typeof(Image))
	slot0._restoreMark = slot0._cloakBar:Find("cloak_restore")
	slot0._lockProgress = slot0._cloakBar:Find("lock"):GetComponent(typeof(Image))
	slot0._exposeFX = slot0._cloakBar:Find("top_effect")
	slot0._markContainer = slot0._cloakBar:Find("mark")
	slot0._exposeMark = slot0._cloakBar:Find("mark/2")
	slot0._visionMark = slot0._cloakBar:Find("mark/1")

	setActive(slot0._cloakBar, true)
	setActive(slot0._exposeFX, false)
	setActive(slot0._exposeMark, false)
	setActive(slot0._visionMark, false)

	if (slot2 or slot0.FORM_RAD) == slot0.FORM_RAD then
		slot0._restoreMark.localRotation = Vector3(0, 0, 0)
		slot0.meterConvert = slot0.__radMeterConvert
		slot0.restoreConvert = slot0.__radRestoreConvert
	else
		slot0.meterConvert = slot0.__barMeterConvert
		slot0.restoreConvert = slot0.__barRestoreConvert
	end
end

ys.Battle.BattleCloakBar.ConfigCloak = function (slot0, slot1)
	slot0._cloakComponent = slot1

	slot0:initCloak()
end

ys.Battle.BattleCloakBar.UpdateCloakProgress = function (slot0)
	slot0._progress.fillAmount = slot0.meterConvert(slot0._cloakComponent:GetCloakValue() / slot0._meterMaxValue)

	if slot0._cloakComponent:GetCurrentState() == slot0.Battle.BattleUnitCloakComponent.STATE_CLOAK then
		setActive(slot0._exposeFX, false)
	elseif slot3 == slot0.Battle.BattleUnitCloakComponent.STATE_UNCLOAK then
		setActive(slot0._exposeFX, true)
	end

	if slot3 == slot0.Battle.BattleUnitCloakComponent.STATE_UNCLOAK then
		setActive(slot0._exposeMark, true)
		setActive(slot0._visionMark, false)
	elseif slot0._cloakComponent:GetExposeSpeed() > 0 then
		setActive(slot0._exposeMark, false)
		setActive(slot0._visionMark, true)
	else
		setActive(slot0._exposeMark, false)
		setActive(slot0._visionMark, false)
	end
end

slot2 = Vector3.New(-1, 1, 1)
slot3 = Vector3.New(-0.5, 0.5, 1)
slot4 = Vector3.New(0.5, 0.5, 1)

ys.Battle.BattleCloakBar.UpdateCloarBarPosition = function (slot0, slot1)
	if slot1.x < 0 then
		slot0._cloakBar.position = slot1 + Vector3.right
		slot0._cloakBar.localScale = Vector3.one
		slot0._markContainer.localScale = slot0
	else
		slot0._cloakBar.position = slot1 + Vector3.left
		slot0._cloakBar.localScale = slot1
		slot0._markContainer.localScale = slot0._markContainer
	end
end

ys.Battle.BattleCloakBar.UpdateCloakConfig = function (slot0)
	slot0:initCloak()
end

ys.Battle.BattleCloakBar.UpdateCloakLock = function (slot0)
	slot0._lockProgress.fillAmount = slot0.meterConvert(slot0._cloakComponent:GetCloakBottom() / slot0._meterMaxValue)
end

ys.Battle.BattleCloakBar.initCloak = function (slot0)
	slot0._meterMaxValue = slot0._cloakComponent:GetCloakMax()

	slot0:updateRestoreMark()
end

ys.Battle.BattleCloakBar.updateRestoreMark = function (slot0)
	slot0.restoreConvert(slot0._cloakComponent:GetCloakRestoreValue() / slot0._meterMaxValue, slot0._restoreMark)
end

ys.Battle.BattleCloakBar.__radMeterConvert = function (slot0)
	return slot0.METER_LENGTH * slot0 + slot0.MIN
end

ys.Battle.BattleCloakBar.__radRestoreConvert = function (slot0, slot1)
	slot1.localRotation = Quaternion.Euler(0, 0, slot0.RESTORE_LEGHTH * slot0 + slot0.MIN_ANGLE)
end

ys.Battle.BattleCloakBar.__barMeterConvert = function (slot0)
	return slot0
end

ys.Battle.BattleCloakBar.__barRestoreConvert = function (slot0, slot1)
	slot1.localPosition = Vector3(slot0.BAR_STEP * slot0 + slot0.BAR_MIN, 0, 0)
end

ys.Battle.BattleCloakBar.Dispose = function (slot0)
	slot0._cloakComponent = nil
	slot0._cloakBar = nil
	slot0._progress = nil
	slot0._restoreMark = nil
	slot0._exposeFX = nil

	Object.Destroy(slot0._cloakBarGO)

	slot0._cloakBarGO = nil
end

return

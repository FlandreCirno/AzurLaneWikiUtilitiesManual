ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = class("BattleCommonWarningView")
ys.Battle.BattleCommonWarningView = slot2
slot2.__name = "BattleCommonWarningView"
slot2.WARNING_TYPE_SUBMARINE = "submarine"
slot2.WARNING_TYPE_ARTILLERY = "artillery"

slot2.Ctor = function (slot0, slot1)
	slot0._submarineCount = 0
	slot0._go = slot1
	slot0._subIcon = slot1.transform:Find("submarineIcon")
	slot0._tips = slot1.transform:Find("warningTips")
	slot0._subWarn = slot1.transform:Find("submarineWarningTips")
	slot0._warningRequestTable = {
		{
			flag = false,
			type = slot0.WARNING_TYPE_ARTILLERY,
			tf = slot0._tips
		},
		{
			flag = false,
			type = slot0.WARNING_TYPE_SUBMARINE,
			tf = slot0._subWarn
		}
	}
end

slot2.UpdateHostileSubmarineCount = function (slot0, slot1)
	if slot1 > 0 and slot0._submarineCount <= 0 then
		slot0:activeSubmarineWarning()
	elseif slot0._submarineCount > 0 and slot1 <= 0 then
		slot0:deactiveSubmarineWarning()
	end

	slot0._submarineCount = slot1
end

slot2.ActiveWarning = function (slot0, slot1)
	slot2 = false
	slot3 = #slot0._warningRequestTable

	for slot7, slot8 in ipairs(slot0._warningRequestTable) do
		if slot1 == slot8.type then
			slot8.flag = true

			if not slot2 then
				SetActive(slot8.tf, true)

				slot3 = slot7
			else
				break
			end
		else
			slot2 = slot2 or slot8.flag

			if slot8.flag and slot3 < slot7 then
				SetActive(slot8.tf, false)
			end
		end
	end
end

slot2.DeactiveWarning = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0._warningRequestTable) do
		if slot1 == slot6.type then
			slot6.flag = false

			SetActive(slot6.tf, false)
		elseif slot6.flag then
			slot0:ActiveWarning(slot6.type)

			break
		end
	end
end

slot2.activeSubmarineWarning = function (slot0)
	SetActive(slot0._subIcon, true)
	slot0:ActiveWarning(slot0.WARNING_TYPE_SUBMARINE)
	LeanTween.cancel(go(slot0._subIcon))
	LeanTween.alpha(rtf(slot0._subIcon), 1, 2):setFrom(0)
end

slot2.deactiveSubmarineWarning = function (slot0)
	LeanTween.cancel(go(slot0._subIcon))
	LeanTween.alpha(rtf(slot0._subIcon), 0, 1):setFrom(1):setOnComplete(System.Action(function ()
		SetActive(slot0._subIcon, false)
		SetActive:DeactiveWarning(slot1.WARNING_TYPE_SUBMARINE)
	end))
end

slot2.Dispose = function (slot0)
	slot0._go = nil
	slot0._icon = nil
	slot0._tips = nil
end

return

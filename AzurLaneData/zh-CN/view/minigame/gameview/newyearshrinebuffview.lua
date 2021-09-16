slot0 = class("NewYearShrineBuffView", import(".ShrineBuffView"))

slot0.getUIName = function (slot0)
	return "NewYearShrineBuff"
end

slot0.initUI = function (slot0)
	slot0.super.initUI(slot0)

	slot0.dft = GetComponent(slot0._tf, "DftAniEvent")

	slot0.dft:SetStartEvent(function ()
		setButtonEnabled(slot0.backBtn, false)
	end)
	slot0.dft.SetEndEvent(slot1, function ()
		setButtonEnabled(slot0.backBtn, true)
	end)
end

return slot0

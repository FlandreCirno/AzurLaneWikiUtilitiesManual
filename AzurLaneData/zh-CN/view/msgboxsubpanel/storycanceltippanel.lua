slot0 = class("StoryCancelTipPanel", import(".MsgboxSubPanel"))

slot0.GetUIName = function (slot0)
	return "Msgbox4StoryCancelTip"
end

slot0.OnInit = function (slot0)
	setText(slot0._tf:Find("Name"), i18n("autofight_story"))
end

slot0.PreRefresh = function (slot0, slot1)
	slot1.title = pg.MsgboxMgr.TITLE_INFORMATION

	slot0.super.PreRefresh(slot0, slot1)
end

slot0.OnRefresh = function (slot0, slot1)
	slot0:SetWindowSize(Vector2(1000, 640))

	slot3 = slot0._tf:Find("TimeText")

	LeanTween.value(go(slot2), slot4, 0, 5):setOnUpdate(System.Action_float(function (slot0)
		setFillAmount(slot0, slot0 - math.floor(slot0))
		setText(setText, math.clamp(math.ceil(slot0), 0, setText))
	end)).setOnComplete(slot5, System.Action(function ()
		existCall(slot0.onYes)
		slot0.onYes:CloseView()
	end))
end

slot0.OnHide = function (slot0)
	return
end

slot0.OnDestory = function (slot0)
	LeanTween.cancel(slot0._tf:Find("CircleProgress"))
end

return slot0

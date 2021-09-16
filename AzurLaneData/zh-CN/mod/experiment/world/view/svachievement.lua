slot0 = class("SVAchievement", import("view.base.BaseSubView"))
slot0.HideView = "SVAchievement.HideView"

slot0.getUIName = function (slot0)
	return "SVAchievement"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot1 = slot0._tf:Find("display")
	slot1.localScale = Vector3.New(slot2, slot2, 0)
	slot0.rtDesc = slot1:Find("desc")
	slot0.rtStar = slot0.rtDesc:Find("star")

	onButton(slot0, slot0._tf, function ()
		if slot0.isClosing then
			return
		end

		slot0:Hide()
	end, SFX_CANCEL)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	setAnchoredPosition(slot0.rtStar, Vector2.New(100, 0))
	setActive(slot0.rtStar:Find("SVAstar"), false)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	slot0.isClosing = true
	slot1 = slot0.rtDesc:InverseTransformPoint(slot0.starWorldPos)

	table.insert(slot2, function (slot0)
		setActive(slot0.rtStar:Find("SVAstar"), true)
		LeanTween.moveLocal(go(slot0.rtStar), Vector3.New(slot1.x, slot1.y, 0), 0.5):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(slot0))
	end)
	table.insert(slot2, function (slot0)
		Timer.New(slot0, 1.1):Start()
	end)
	seriesAsync(slot2, function ()
		slot0.isClosing = false

		pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf, slot0._parentTf)
		setActive(slot0._tf, false)
		setActive:emit(slot1.HideView)
	end)
end

slot0.Setup = function (slot0, slot1, slot2)
	setText(slot0.rtDesc, HXSet.hxLan(slot1.config.target_desc))

	slot0.starWorldPos = slot2
end

return slot0

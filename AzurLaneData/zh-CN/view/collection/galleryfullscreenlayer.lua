slot0 = class("GalleryFullScreenLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "GalleryViewUI"
end

slot0.init = function (slot0)
	slot0:findUI()
	slot0:initData()
	slot0:addListener()
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
	slot0:updatePicImg()
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
end

slot0.onBackPressed = function (slot0)
	if not slot0.isShowing then
		slot0:closeView()
	end
end

slot0.findUI = function (slot0)
	slot0.bg = slot0:findTF("BG")
	slot0.picImg = slot0:findTF("Pic")
end

slot0.initData = function (slot0)
	slot0.picID = slot0.contextData.picID
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.bg, function ()
		if not slot0.isShowing then
			slot0:closeView()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.picImg, function ()
		if not slot0.isShowing then
			slot0:closeView()
		end
	end, SFX_PANEL)
end

slot0.updatePicImg = function (slot0)
	setImageSprite(slot0.picImg, LoadSprite(slot3, slot2))

	slot0.isShowing = true

	LeanTween.value(go(slot0.picImg), 0, 1, 0.3):setOnUpdate(System.Action_float(function (slot0)
		setImageAlpha(slot0.picImg, slot0)
	end)).setOnComplete(slot4, System.Action(function ()
		slot0.isShowing = false

		setImageAlpha(slot0.picImg, 1)
	end))
end

return slot0

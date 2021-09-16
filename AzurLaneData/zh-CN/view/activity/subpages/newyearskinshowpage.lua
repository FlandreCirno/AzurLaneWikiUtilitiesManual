slot0 = class("NewYearSkinShowPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0:findUI()
	slot0:initData()
end

slot0.findUI = function (slot0)
	slot0.paintBackTF = slot0:findTF("Paints/PaintBack")
	slot0.paintFrontTF = slot0:findTF("Paints/PaintFront")
	slot0.skinShopBtn = slot0:findTF("BtnShop")
	slot0.goBtn = slot0:findTF("BtnGO")

	onButton(slot0, slot0.skinShopBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(slot0, slot0.goBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NEWYEAR_BACKHILL)
	end, SFX_PANEL)
end

slot0.initData = function (slot0)
	slot0.paintCount = 20
	slot0.curPaintIndex = 1
	slot0.paintSwitchTime = 1
	slot0.paintStaticTime = 3.5
	slot0.paintStaticCountValue = 0
	slot0.paintPathPrefix = "NewYearSkinShowPage/"
	slot0.paintNamePrefix = "NewYearA"
end

slot0.switchNextPaint = function (slot0)
	slot0.frameTimer:Stop()
	setImageSprite(slot0.paintBackTF, LoadSprite(slot4, slot3))
	LeanTween.value(go(slot0.paintFrontTF), 1, 0, slot0.paintSwitchTime):setOnUpdate(System.Action_float(function (slot0)
		setImageAlpha(slot0.paintFrontTF, slot0)
		setImageAlpha(slot0.paintBackTF, 1 - slot0)
	end)).setOnComplete(slot5, System.Action(function ()
		setImageFromImage(slot0.paintFrontTF, slot0.paintBackTF)
		setImageAlpha(slot0.paintFrontTF, 1)
		setImageAlpha(slot0.paintBackTF, 0)

		setImageAlpha.curPaintIndex = slot0.paintBackTF

		setImageAlpha.frameTimer:Start()
	end))
end

slot0.OnFirstFlush = function (slot0)
	slot0:initPaint()
	slot0:initTimer()
end

slot0.initPaint = function (slot0)
	setImageSprite(slot0.paintFrontTF, LoadSprite(slot0.paintPathPrefix .. slot3, slot0.paintNamePrefix .. slot1))
	setImageSprite(slot0.paintBackTF, LoadSprite(slot0.paintPathPrefix .. slot3, slot0.paintNamePrefix .. slot2))
end

slot0.initTimer = function (slot0)
	slot1 = 0.016666666666666666
	slot0.paintStaticCountValue = 0
	slot0.frameTimer = Timer.New(function ()
		slot0.paintStaticCountValue = slot0.paintStaticCountValue + 

		if slot0.paintStaticTime <= slot0.paintStaticCountValue then
			slot0.paintStaticCountValue = 0

			slot0:switchNextPaint()
		end
	end, slot1, -1, false)

	slot0.frameTimer:Start()
end

slot0.OnDestroy = function (slot0)
	if slot0.frameTimer then
		slot0.frameTimer:Stop()

		slot0.frameTimer = nil
	end
end

return slot0

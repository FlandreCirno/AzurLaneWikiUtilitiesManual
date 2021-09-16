slot0 = class("FourthAnniversaryPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.hideIndex = {}
	slot0.scrollAble = true

	if PLATFORM_CODE == PLATFORM_CH then
		slot0.hideIndex = {}
		slot0.scrollAble = true
	elseif PLATFORM_CODE == PLATFORM_KR then
		slot0.hideIndex = {
			1,
			2,
			3,
			4
		}
		slot0.scrollAble = false
	elseif PLATFORM_CODE ~= PLATFORM_CH then
		slot0.hideIndex = {
			2,
			4
		}
		slot0.scrollAble = true
	end

	slot0:findUI()
	slot0:initData()
end

slot0.findUI = function (slot0)
	slot0.paintBackTF = slot0:findTF("Paints/PaintBack")
	slot0.paintFrontTF = slot0:findTF("Paints/PaintFront")
	slot0.skinShopBtn = slot0:findTF("BtnShop")
	slot0.btnContainer = slot0:findTF("BtnList/Viewport/Content")
	slot0.btnList1 = {}

	for slot5 = 0, slot0.btnContainer.childCount / 3 - 1, 1 do
		slot0.btnList1[slot5 + 1] = slot0.btnContainer:GetChild(slot5)
	end

	slot0.btnList2 = {}

	for slot5 = slot1, 2 * slot1 - 1, 1 do
		slot0.btnList2[#slot0.btnList2 + 1] = slot0.btnContainer:GetChild(slot5)
	end

	slot0.btnList3 = {}

	for slot5 = slot1 * 2, 3 * slot1 - 1, 1 do
		slot0.btnList3[#slot0.btnList3 + 1] = slot0.btnContainer:GetChild(slot5)
	end

	for slot5 = 1, slot1 * 3, 1 do
		if table.contains(slot0.hideIndex, slot5 % 6) or (not slot0.scrollAble and slot5 > 6) then
			setActive(slot0.btnContainer:GetChild(slot5 - 1), false)
		end
	end

	slot0.gridLayoutGroupCom = GetComponent(slot0.btnContainer, "GridLayoutGroup")
end

slot0.initData = function (slot0)
	slot0.paintCount = 9
	slot0.curPaintIndex = 1
	slot0.paintSwitchTime = 1
	slot0.paintStaticTime = 3.5
	slot0.paintStaticCountValue = 0
	slot0.paintPathPrefix = "clutter/"
	slot0.paintNamePrefix = "fourtha"
	slot0.btnCount = slot0.btnContainer.childCount / 3
	slot0.btnSpeed = 50
	slot0.btnSizeX = slot0.gridLayoutGroupCom.cellSize.x
	slot0.btnMarginX = slot0.gridLayoutGroupCom.spacing.x
	slot0.moveLength = (slot0.btnCount - #slot0.hideIndex) * (slot0.btnSizeX + slot0.btnMarginX)
	slot0.startAnchoredPosX = slot0.btnContainer.anchoredPosition.x
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
	onButton(slot0, slot0.skinShopBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end)
	slot0.initPaint(slot0)
	slot0:initBtnList(slot0.btnList1)
	slot0:initBtnList(slot0.btnList2)
	slot0:initBtnList(slot0.btnList3)
	slot0:initTimer()
end

slot0.initPaint = function (slot0)
	setImageSprite(slot0.paintFrontTF, LoadSprite(slot0.paintPathPrefix .. slot3, slot0.paintNamePrefix .. slot1))
	setImageSprite(slot0.paintBackTF, LoadSprite(slot0.paintPathPrefix .. slot3, slot0.paintNamePrefix .. slot2))
end

slot0.initBtnList = function (slot0, slot1)
	onButton(slot0, slot1[1], function ()
		slot0:emit(ActivityMediator.GO_PRAY_POOL)
	end, SFX_PANEL)
	onButton(slot0, slot1[2], function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SUMMARY)
	end, SFX_PANEL)
	onButton(slot0, slot1[3], function ()
		slot0:emit(ActivityMediator.SELECT_ACTIVITY, ActivityConst.ACTIVITY_TYPE_RETURN_AWARD_ID4)
	end, SFX_PANEL)
	onButton(slot0, slot1[4], function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.CHARGE, {
			wrap = ChargeScene.TYPE_DIAMOND
		})
	end, SFX_PANEL)
	onButton(slot0, slot1[5], function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.AMUSEMENT_PARK)
	end, SFX_PANEL)
	onButton(slot0, slot1[6], function ()
		slot0:emit(ActivityMediator.GO_MINI_GAME, 23)
	end, SFX_PANEL)
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

	slot0.frameTimer2 = Timer.New(function ()
		if slot0.scrollAble then
			if slot0.moveLength <= slot0.startAnchoredPosX - (slot0.btnContainer.anchoredPosition.x - slot0.btnSpeed * ) then
				slot0 = slot0.btnContainer.anchoredPosition.x + slot0.moveLength
			end

			slot0.btnContainer.anchoredPosition = Vector3(slot0, 0, 0)
		end
	end, slot1, -1, false)

	slot0.frameTimer2:Start()
end

slot0.OnDestroy = function (slot0)
	if slot0.frameTimer then
		slot0.frameTimer:Stop()

		slot0.frameTimer = nil
	end

	if slot0.frameTimer2 then
		slot0.frameTimer2:Stop()

		slot0.frameTimer2 = nil
	end
end

return slot0

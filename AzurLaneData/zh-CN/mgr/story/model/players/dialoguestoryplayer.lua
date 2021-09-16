slot0 = class("DialogueStoryPlayer", import(".StoryPlayer"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.actorPanel = slot0:findTF("actor", slot0.dialoguePanel)
	slot0.actorLeft = slot0:findTF("actor_left", slot0.actorPanel)
	slot0.initActorLeftPos = slot0.actorLeft.localPosition
	slot0.actorMiddle = slot0:findTF("actor_middle", slot0.actorPanel)
	slot0.initActorMiddlePos = slot0.actorMiddle.localPosition
	slot0.actorRgiht = slot0:findTF("actor_right", slot0.actorPanel)
	slot0.initActorRgihtPos = slot0.actorRgiht.localPosition
	slot0.mainPanel = slot0:findTF("main", slot0.dialoguePanel)
	slot0.contentArr = slot0.mainPanel:Find("next/arrow")
	slot0.conentTxt = slot0:findTF("content", slot0.mainPanel):GetComponent(typeof(Text))
	slot0.typewriter = slot0:findTF("content", slot0.mainPanel):GetComponent(typeof(Typewriter))
	slot0.nameLeft = slot0:findTF("name_left", slot0.mainPanel)
	slot0.nameRight = slot0:findTF("name_right", slot0.mainPanel)
	slot0.nameLeftTxt = slot0:findTF("Text", slot0.nameLeft):GetComponent(typeof(Text))
	slot0.nameRightTxt = slot0:findTF("Text", slot0.nameRight):GetComponent(typeof(Text))
	slot0.subActorMiddle = UIItemList.New(slot0:findTF("actor_middle/sub", slot0.actorPanel), slot0:findTF("actor_middle/sub/tpl", slot0.actorPanel))
	slot0.subActorRgiht = UIItemList.New(slot0:findTF("actor_right/sub", slot0.actorPanel), slot0:findTF("actor_right/sub/tpl", slot0.actorPanel))
	slot0.subActorLeft = UIItemList.New(slot0:findTF("actor_left/sub", slot0.actorPanel), slot0:findTF("actor_left/sub/tpl", slot0.actorPanel))
	slot0.glitchArtMaterial = slot0:findTF("resource/material1"):GetComponent(typeof(Image)).material
	slot0.maskMaterial = slot0:findTF("resource/material2"):GetComponent(typeof(Image)).material
	slot0.glitchArtMaterialForPainting = slot0:findTF("resource/material3"):GetComponent(typeof(Image)).material
	slot0.typewriterSpeed = 0
	slot0.defualtFontSize = slot0.conentTxt.fontSize
end

slot0.OnReset = function (slot0, slot1, slot2)
	slot0:ResetActorTF(slot1, slot2)
	setActive(slot0.nameLeft, false)
	setActive(slot0.nameRight, false)
	setActive(slot0.dialoguePanel, true)

	slot0.conentTxt.text = ""

	slot0:CancelTween(slot0.contentArr)
end

slot0.ResetActorTF = function (slot0, slot1, slot2)
	if slot0:GetSideTF(slot1:GetSide()) then
		slot0:CancelTween(slot4.gameObject)

		slot4.localScale = Vector3(1, 1, 1)
		slot4.eulerAngles = Vector3(0, 0, 0)

		if slot4 == slot0.actorRgiht then
			slot4.localPosition = slot0.initActorRgihtPos
		elseif slot4 == slot0.actorMiddle then
			slot4.localPosition = slot0.initActorMiddlePos
		elseif slot4 == slot0.actorLeft then
			slot4.localPosition = slot0.initActorLeftPos
		end
	end

	if slot1:HideOtherPainting() then
		slot0:RecyclePainting({
			"actorLeft",
			"actorMiddle",
			"actorRgiht"
		})
	else
		if slot2 and slot2:IsDialogueMode() and slot1:IsSameSide(slot2) and slot1:IsDialogueMode() then
			slot0:RecyclePainting(slot4)
		end

		if slot3 == DialogueStep.SIDE_MIDDLE then
			slot0:RecyclePainting({
				"actorLeft",
				"actorRgiht"
			})
		end
	end

	slot0:RecyclesSubPantings(slot0.subActorMiddle)
	slot0:RecyclesSubPantings(slot0.subActorRgiht)
	slot0:RecyclesSubPantings(slot0.subActorLeft)
end

slot0.OnInit = function (slot0, slot1, slot2)
	slot3 = {
		function (slot0)
			slot0:UpdateContent(slot0.UpdateContent, slot0)
		end,
		function (slot0)
			slot0:UpdatePainting(slot0.UpdatePainting, slot0)
		end
	}

	parallelAsync(slot3, slot2)
end

slot0.OnStartUIAnimations = function (slot0, slot1, slot2)
	if not slot1:ShouldShakeDailogue() then
		slot2()

		return
	end

	slot3 = slot1:GetShakeDailogueData()

	slot0:TweenMovex(slot0.dialoguePanel, slot3.x, slot0.dialoguePanel.localPosition.x, slot3.speed, slot3.delay, slot3.number, slot2)
end

slot0.OnEnter = function (slot0, slot1, slot2, slot3)
	parallelAsync({
		function (slot0)
			slot0:FadeInPaiting(slot0.FadeInPaiting, slot0, slot0)
		end,
		function (slot0)
			slot0:StartMovePrevPaitingToSide(slot0.StartMovePrevPaitingToSide, slot0, slot0)
		end,
		function (slot0)
			slot0:FadeOutPrevPaiting(slot0.FadeOutPrevPaiting, slot0, )
		end
	}, slot3)
end

slot0.FadeOutPrevPaiting = function (slot0, slot1, slot2, slot3)
	if not slot1 or not slot1:IsDialogueMode() then
		slot3()

		return
	end

	if slot0:GetSideTF(slot2:GetPrevSide(slot1)) and slot2 and slot2:IsDialogueMode() and slot2:GetPainting() ~= nil and not slot2:IsSameSide(slot1) then
		slot0:fadeTransform(slot4, (slot1:GetPaintingAlpha() and slot1:GetPaintingAlpha()) or 1, slot1:GetPaintingData().alpha, slot1.GetPaintingData().time, false, slot3)
	else
		slot3()
	end
end

slot0.FadeInPaiting = function (slot0, slot1, slot2, slot3)
	if slot2 and slot2:IsDialogueMode() and slot2:GetPainting() ~= nil and not slot1:IsSameSide(slot2) then
		slot5 = slot1:GetPaintingData()

		if not IsNil(slot0:GetSideTF(slot1:GetSide())) and not slot1:GetPaintingAlpha() then
			slot0:fadeTransform(slot4, slot5.alpha, 1, slot5.time, false)
		end
	end

	slot3()
end

slot0.UpdateTypeWriter = function (slot0, slot1, slot2)
	if not slot1:GetTypewriter() then
		slot2()

		return
	end

	slot0.typewriter.endFunc = function ()
		slot0.typewriterSpeed = 0
		slot0.typewriter.endFunc = nil

		removeOnButton(slot0._tf)
		slot0._tf()
	end

	slot0.typewriterSpeed = math.max((slot3.speed or 0.1) * slot0.timeScale, 0.001)
	slot4 = slot3.speedUp or slot0.typewriterSpeed

	slot0.typewriter.setSpeed(slot5, slot0.typewriterSpeed)
	slot0.typewriter:Play()
	onButton(slot0, slot0._tf, function ()
		if slot0.puase or slot0.stop then
			return
		end

		slot0.typewriterSpeed = math.min(slot0.typewriterSpeed, math.min)

		slot0.typewriter:setSpeed(slot0.typewriterSpeed)
	end, SFX_PANEL)
end

slot0.UpdatePainting = function (slot0, slot1, slot2)
	slot4, slot5, slot6, slot7 = slot0:GetSideTF(slot1:GetSide())

	if slot1:GetPainting() then
		if slot1:IsShowNPainting() and PathMgr.FileExists(PathMgr.getAssetBundle("painting/" .. slot3 .. "_n")) then
			slot3 = slot3 .. "_n"
		end

		if slot1:IsShowWJZPainting() and PathMgr.FileExists(PathMgr.getAssetBundle("painting/" .. slot3 .. "_wjz")) then
			slot3 = slot3 .. "_wjz"
		end

		setPaintingPrefab(slot4, slot3, "duihua")

		slot4.localScale = Vector3(slot8, slot9, 1)
		slot10 = findTF(slot4, "fitter"):GetChild(0)
		slot10.name = slot3

		slot0:UpdateActorPostion(slot4, slot1)
		slot0:UpdateExpression(slot10, slot1)
		slot0:StartPatiningActions(slot4, slot1)
		slot0:AddGlitchArtEffectForPating(slot4, slot10, slot1)
		slot0:InitSubPainting(slot7, slot1)
		slot4:SetAsLastSibling()

		if slot1:ShouldGrayPainting() then
			setGray(slot10, true, true)
		end

		if findTF(slot10, "shadow") then
			setActive(slot11, slot1:ShouldFaceBlack())
		end

		if slot1:GetPaintingAlpha() then
			slot0:setPaintingAlpha(slot4, slot12)
		end
	end

	if slot5 then
		setActive(slot5, slot1:GetNameWithColor() and slot8 ~= "")

		slot6.text = slot8
	end

	slot2()
end

slot0.InitSubPainting = function (slot0, slot1, slot2)
	function slot3(slot0, slot1)
		slot2 = slot0.name

		if slot0.showNPainting and PathMgr.FileExists(PathMgr.getAssetBundle("painting/" .. slot2 .. "_n")) then
			slot2 = slot2 .. "_n"
		end

		setPaintingPrefab(slot1, slot2, "duihua")

		slot4 = findTF(slot3, "face")
		slot5 = slot0.expression

		if not slot0.expression and slot0.name and ShipExpressionHelper.DefaultFaceless(slot0.name) then
			slot5 = ShipExpressionHelper.GetDefaultFace(slot0.name)
		end

		if slot5 then
			setActive(slot4, true)
			setImageSprite(slot4, GetSpriteFromAtlas("paintingface/" .. slot0.name, slot0.expression))
		end

		if slot0.pos then
			setAnchoredPosition(slot1, slot0.pos)
		end

		if slot0.dir then
			slot1.transform.localScale = Vector3(slot0.dir, 1, 1)
		end

		if slot0.paintingNoise then
			slot0:AddGlitchArtEffectForPating(slot1, slot3, slot1)
		end
	end

	slot1:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0(slot1[slot1 + 1], slot2)
		end
	end)
	slot1.align(slot1, #slot2.GetSubPaintings(slot2))
end

slot0.UpdateActorPostion = function (slot0, slot1, slot2)
	if slot2:GetPaitingOffst() then
		slot1.localPosition = Vector3(slot1.localPosition.x + (slot3.x or 0), slot4.y + (slot3.y or 0), 0)
	end
end

slot0.UpdateExpression = function (slot0, slot1, slot2)
	if slot2:GetExPression() then
		setActive(slot4, true)
		setImageSprite(findTF(slot1, "face"), GetSpriteFromAtlas("paintingface/" .. slot5, slot3))
	end
end

slot0.StartPatiningActions = function (slot0, slot1, slot2, slot3)
	slot4 = {
		function (slot0)
			slot0:StartPatiningMoveAction(slot0.StartPatiningMoveAction, slot0, slot0)
		end,
		function (slot0)
			slot0:StartPatiningShakeAction(slot0.StartPatiningShakeAction, slot0, slot0)
		end,
		function (slot0)
			slot0:StartPatiningZoomAction(slot0.StartPatiningZoomAction, slot0, slot0)
		end,
		function (slot0)
			slot0:StartPatiningRotateAction(slot0.StartPatiningRotateAction, slot0, slot0)
		end
	}

	parallelAsync(slot4, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.StartPatiningShakeAction = function (slot0, slot1, slot2, slot3)
	if not slot2:GetPaintingAction(DialogueStep.PAINTING_ACTION_SHAKE) then
		slot3()

		return
	end

	function slot5(slot0, slot1)
		slot1:TweenMove(slot0, Vector3(tf(slot0).localPosition.x + (slot0.x or 0), tf(slot0).localPosition.y + (slot0.y or 10), 0), slot0.dur or 1, slot0.number or 1, slot0.delay or 0, slot1)
	end

	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		table.insert(slot6, function (slot0)
			slot0(slot0, slot0)
		end)
	end

	parallelAsync(slot6, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.StartPatiningZoomAction = function (slot0, slot1, slot2, slot3)
	if not slot2:GetPaintingAction(DialogueStep.PAINTING_ACTION_ZOOM) then
		slot3()

		return
	end

	function slot5(slot0, slot1)
		slot2 = slot0.from or {
			0,
			0,
			0
		}

		slot0:TweenScale(slot1, Vector3(slot0.to or {
			1,
			1,
			1
		}[1], slot0.to or [2], slot0.to or [3]), slot0.dur or 0, slot0.delay or 0, slot1)
	end

	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		table.insert(slot6, function (slot0)
			slot0(slot0, slot0)
		end)
	end

	parallelAsync(slot6, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.StartPatiningRotateAction = function (slot0, slot1, slot2, slot3)
	if not slot2:GetPaintingAction(DialogueStep.PAINTING_ACTION_ROTATE) then
		slot3()

		return
	end

	function slot5(slot0, slot1)
		slot0:TweenRotate(slot1, slot0.value, slot0.dur or 1, slot0.number or 1, slot0.delay or 0, slot1)
	end

	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		table.insert(slot6, function (slot0)
			slot0(slot0, slot0)
		end)
	end

	parallelAsync(slot6, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.StartPatiningMoveAction = function (slot0, slot1, slot2, slot3)
	if not slot2:GetPaintingAction(DialogueStep.PAINTING_ACTION_MOVE) then
		slot3()

		return
	end

	function slot5(slot0, slot1)
		slot1:TweenMove(slot0, Vector3(tf(slot0).localPosition.x + (slot0.x or 0), tf(slot0).localPosition.y + (slot0.y or 0), 0), slot0.dur or 1, 1, slot0.delay or 0, slot1)
	end

	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		table.insert(slot6, function (slot0)
			slot0(slot0, slot0)
		end)
	end

	parallelAsync(slot6, function ()
		if slot0 then
			slot0()
		end
	end)
end

slot0.StartMovePrevPaitingToSide = function (slot0, slot1, slot2, slot3)
	if not slot1:GetPaintingMoveToSide() or not slot2 then
		slot3()

		return
	end

	if not slot0:GetSideTF(slot2:GetSide()) then
		slot3()

		return
	end

	slot6 = slot4.time

	if not slot0:GetSideTF(slot4.side) then
		slot3()

		return
	end

	if slot1.side ~= slot2.side then
		if slot5:Find("fitter").childCount > 0 then
			removeAllChildren(slot8:Find("fitter"))
			setParent(slot9, slot8:Find("fitter"))

			slot8.localScale = Vector3(slot2:GetPaintingDir(), math.abs(slot10), 1)
		end
	elseif slot2:GetPainting() then
		setPaintingPrefab(slot8, slot9, "duihua")
	end

	slot0:TweenValue(slot8, slot5.localPosition.x, tf(slot8).localPosition.x, slot6, 0, function (slot0)
		setAnchoredPosition(slot0, {
			x = slot0
		})
	end, slot3)
end

slot0.AddGlitchArtEffectForPating = function (slot0, slot1, slot2, slot3)
	slot5 = slot3:IsNoHeadPainting()

	if slot3:ShouldAddGlitchArtEffect() and slot3:GetExPression() ~= nil and not slot5 then
		cloneTplTo(slot6, slot2:Find("face").parent, "temp_mask").SetAsFirstSibling(slot7)

		for slot12 = 0, slot1:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
			if slot8[slot12].gameObject.name == "temp_mask" then
				slot13.material = slot0.maskMaterial
			elseif slot13.gameObject.name == "face" then
				slot13.material = slot0.glitchArtMaterial
			else
				slot13.material = slot0.glitchArtMaterialForPainting
			end
		end
	elseif slot4 then
		for slot10 = 0, slot1:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
			slot6[slot10].material = slot0.glitchArtMaterial
		end
	end
end

slot0.UpdateContent = function (slot0, slot1, slot2)
	slot0.conentTxt.fontSize = slot1:GetFontSize() or slot0.defualtFontSize
	slot0.conentTxt.text = slot1:GetContent()
	slot4 = 999

	if slot1.GetContent() and slot3 ~= "" then
		slot4 = System.String.New(slot3).Length
	end

	if slot3 and slot3 ~= "" and slot3 ~= "…" and #slot3 > 1 and slot4 > 1 then
		slot0:UpdateTypeWriter(slot1, slot2)
		slot0:TweenMovey(slot0.contentArr, 0, 10, 0.5, 0, -1, nil)
	else
		slot2()
	end
end

slot0.GetSideTF = function (slot0, slot1)
	slot2, slot3, slot4, slot5 = nil

	if DialogueStep.SIDE_LEFT == slot1 then
		slot5 = slot0.subActorLeft
		slot4 = slot0.nameLeftTxt
		slot3 = slot0.nameLeft
		slot2 = slot0.actorLeft
	elseif DialogueStep.SIDE_RIGHT == slot1 then
		slot5 = slot0.subActorRgiht
		slot4 = slot0.nameRightTxt
		slot3 = slot0.nameRight
		slot2 = slot0.actorRgiht
	elseif DialogueStep.SIDE_MIDDLE == slot1 then
		slot5 = slot0.subActorMiddle
		slot4 = slot0.nameLeftTxt
		slot3 = slot0.nameLeft
		slot2 = slot0.actorMiddle
	end

	return slot2, slot3, slot4, slot5
end

slot0.RecyclesSubPantings = function (slot0, slot1)
	slot1:each(function (slot0, slot1)
		slot0:RecyclePainting(slot1)
	end)
end

slot0.RecyclePainting = function (slot0, slot1)
	function slot2(slot0)
		if slot0:Find("fitter").childCount == 0 then
			return
		end

		if slot0:Find("fitter"):GetChild(0) then
			for slot6 = 0, slot0:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
				slot8 = Color.white

				if slot2[slot6].material ~= slot2[slot6].defaultGraphicMaterial then
					slot7.material = slot7.defaultGraphicMaterial

					slot7.material:SetColor("_Color", slot8)
				end
			end

			setGray(slot0, false, true)
			retPaintingPrefab(slot0, slot1.name)

			if slot1:Find("temp_mask") then
				Destroy(slot3)
			end
		end
	end

	if type(slot1) == "table" then
		for slot6, slot7 in ipairs(slot1) do
			slot2(slot0[slot7])
		end
	else
		slot2(slot1)
	end
end

slot0.Resume = function (slot0)
	slot0.super.Resume(slot0)

	if slot0.typewriterSpeed ~= 0 then
		slot0.typewriter:setSpeed(slot0.typewriterSpeed)
	end
end

slot0.Puase = function (slot0)
	slot0.super.Puase(slot0)

	if slot0.typewriterSpeed ~= 0 then
		slot0.typewriter:setSpeed(100000000)
	end
end

slot0.OnEnd = function (slot0)
	slot0:RecyclePainting({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	})

	slot0.conentTxt.text = ""
	slot0.nameLeftTxt.text = ""
	slot0.nameRightTxt.text = ""
end

return slot0

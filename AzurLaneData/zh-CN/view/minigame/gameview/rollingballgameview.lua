slot0 = class("RollingBallGameView", import("..BaseMiniGameView"))
slot1 = "event:/ui/ddldaoshu2"
slot2 = "event:/ui/boat_drag"
slot3 = "event:/ui/break_out_full"
slot4 = "event:/ui/sx-good"
slot5 = "event:/ui/sx-perfect"
slot6 = "event:/ui/sx-jishu"
slot7 = "event:/ui/furnitrue_save"

slot0.getUIName = function (slot0)
	return "RollingBallGameUI"
end

slot0.init = function (slot0)
	slot1 = slot0:GetMGData()
	slot2 = slot0:GetMGHubData()
	slot0.tplScoreTip = findTF(slot0._tf, "tplScoreTip")
	slot0.tplRemoveEffect = findTF(slot0._tf, "sanxiaoxiaoshi")
	slot0.effectUI = findTF(slot0._tf, "effectUI")
	slot0.tplEffect = findTF(slot0._tf, "tplEffect")
	slot0.effectPoolTf = findTF(slot0._tf, "effectPool")
	slot0.effectPool = {}
	slot0.effectDatas = {}
	slot0.effectTargetPosition = findTF(slot0.effectUI, "effectTargetPos").localPosition
	slot0.rollingUI = findTF(slot0._tf, "rollingUI")
	slot0.rollingEffectUI = findTF(slot0._tf, "rollingEffectUI")
	slot0.tplGrid = findTF(slot0._tf, "tplRollingGrid")
	slot0.gridPoolTf = findTF(slot0._tf, "gridPool")
	slot0.gridsPool = {}
	slot0.gridDic = {}
	slot0.fillGridDic = {}
	slot0.startFlag = false
	slot0.dragAlphaGrid = RollingBallGrid.New(slot3)

	setActive(slot0.dragAlphaGrid:getTf(), false)

	slot0.timer = Timer.New(function ()
		slot0:onTimer()
	end, 0.016666666666666666, -1)

	for slot7 = 1, RollingBallConst.horizontal, 1 do
		slot0.gridDic[slot7] = {}
		slot0.fillGridDic[slot7] = {}

		for slot11 = 1, RollingBallConst.vertical, 1 do
			table.insert(slot0.gridDic[slot7], false)
		end
	end

	slot0.goodEffect = slot0.findTF(slot0, "sanxiaoGood")
	slot0.greatEffect = slot0:findTF("sanxiaoGreat")
	slot0.perfectEffect = slot0:findTF("sanxiaoPerfect")
	slot0.caidaiTf = findTF(slot0._tf, "zhuanzhu_caidai")

	setActive(slot0.caidaiTf, false)

	slot0.startUI = findTF(slot0._tf, "startUI")

	onButton(slot0, findTF(slot0.startUI, "btnStart"), function ()
		if not slot0.startFlag then
			setActive(slot0.startUI, false)
			setActive:gameStart()
		end
	end, SFX_CONFIRM)
	onButton(slot0, findTF(slot0.startUI, "btnRule"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_rollingBallGame.tip
		})
	end, SFX_CONFIRM)
	setActive(slot0.startUI, true)

	slot0.scoreUI = findTF(slot0._tf, "scoreUI")
	slot0.labelCurScore = findTF(slot0.scoreUI, "labelCur")
	slot0.labelHigh = findTF(slot0.scoreUI, "labelHigh")
	slot0.scoreNew = findTF(slot0.scoreUI, "new")

	onButton(slot0, findTF(slot0.scoreUI, "btnEnd"), function ()
		setActive(slot0.scoreUI, false)
		setActive(slot0.startUI, true)
	end, SFX_CANCEL)
	setActive(slot0.scoreUI, false)

	slot0.downProgress = findTF(slot0._tf, "downProgress")
	slot0.downTimeSlider = findTF(slot0.downProgress, "Slider").GetComponent(slot4, typeof(Slider))
	slot0.labelGameTime = findTF(slot0._tf, "labelGameTime")
	slot0.labelGameScore = findTF(slot0._tf, "labelGameScore")
	slot0.endLess = findTF(slot0._tf, "endLess")

	setActive(slot0.endLess, true)

	slot0.closeUI = findTF(slot0._tf, "closeUI")

	setActive(slot0.closeUI, false)
	onButton(slot0, findTF(slot0.closeUI, "btnOk"), function ()
		if not slot0.countStart then
			slot0:closeView()
		end
	end, SFX_CONFIRM)
	onButton(slot0, findTF(slot0.closeUI, "btnCancel"), function ()
		setActive(slot0.closeUI, false)
	end, SFX_CANCEL)

	slot0.overLight = findTF(slot0._tf, "overLight")

	setActive(slot0.overLight, false)
	onButton(slot0, findTF(slot0._tf, "btnClose"), function ()
		if not slot0.startFlag then
			slot0:closeView()
		else
			setActive(slot0.closeUI, true)
		end
	end, SFX_CANCEL)
end

slot0.getGameTimes = function (slot0)
	return slot0:GetMGHubData().count
end

slot0.showScoreUI = function (slot0, slot1)
	if slot1 > ((slot0:GetMGData():GetRuntimeData("elements") and #slot2 > 0 and slot2[1]) or 0) then
		setActive(slot0.scoreNew, true)
	else
		setActive(slot0.scoreNew, false)
	end

	setActive(slot0.scoreUI, true)
	setText(slot0.labelCurScore, slot1)
	setText(slot0.labelHigh, (slot1 < slot3 and slot3) or slot1)
	slot0:StoreDataToServer({
		(slot1 < slot3 and slot3) or slot1
	})

	if slot0:getGameTimes() > 0 then
		slot0:SendSuccess(0)
	end
end

slot0.showCountStart = function (slot0, slot1)
	setActive(slot2, true)

	slot0.countIndex = 3
	slot0.countStart = true

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)

	function slot3(slot0)
		slot0.countIndex = slot0.countIndex - 1
		slot3 = GetComponent(slot2, typeof(CanvasGroup))

		seriesAsync({
			function (slot0)
				GetSpriteFromAtlasAsync("ui/rollingBallGame_atlas", "count_" .. slot0, function (slot0)
					setImageSprite(slot0, slot0, true)
				end)
				LeanTween.value(go(slot1), 0, 1, 0.5).setOnUpdate(slot1, System.Action_float(function (slot0)
					slot0.alpha = slot0
				end)).setOnComplete(slot1, System.Action(function ()
					slot0()
				end))
			end,
			function (slot0)
				LeanTween.value(go(slot0), 1, 0, 0.5):setOnUpdate(System.Action_float(function (slot0)
					slot0.alpha = slot0
				end)).setOnComplete(slot1, System.Action(function ()
					slot0()
				end))
			end
		}, slot0)
	end

	slot4 = {}

	for slot8 = 1, 3, 1 do
		table.insert(slot4, slot3)
	end

	seriesAsync(slot4, function ()
		slot0.countStart = false

		setActive(false, false)
		false()
	end)
end

slot0.gameStart = function (slot0)
	slot0.startFlag = true

	seriesAsync({
		function (slot0)
			slot0:showCountStart(slot0)
		end,
		function (slot0)
			slot0.moveDatas = {}
			slot0.selectGrid = nil
			slot0.selectEnterGrid = nil
			slot0.dragOffsetPos = Vector3(0, 0, 0)
			slot0.changeGridsDic = nil
			slot0.downTime = RollingBallConst.downTime
			slot0.comboAmount = 0
			slot0.stopFlag = false
			slot0.onBeginDragTime = nil

			if slot0:getGameTimes() > 0 then
				slot0.gameTime = RollingBallConst.gameTime
			else
				slot0.gameTime = RollingBallConst.finishGameTime
			end

			slot0.gameTimeReal = Time.realtimeSinceStartup
			slot0.gameTimeFlag = true

			setActive(slot0.endLess, false)

			slot0.gameScore = 0

			slot0:firstInitGrid()
			slot0:moveGridsBySelfPos(slot0.gridDic)
			slot0:timerStart()
		end
	}, nil)
end

slot0.gameStop = function (slot0)
	slot0:timerStop()
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)

	for slot4 = #slot0.effectDatas, 1, -1 do
		slot0:returnEffect(slot0.effectDatas[slot4].tf)
		table.remove(slot0.effectDatas, slot4)
	end

	for slot4 = 1, RollingBallConst.horizontal, 1 do
		for slot8 = 1, RollingBallConst.vertical, 1 do
			if slot0.gridDic[slot4][slot8] then
				slot0.gridDic[slot4][slot8]:setEventActive(false)
			end
		end
	end

	slot0:clearUI()
	slot0:showScoreUI(slot0.gameScore, 1000)
end

slot0.timerStart = function (slot0)
	if not slot0.timer.running then
		slot0.timer:Start()
	end
end

slot0.timerStop = function (slot0)
	if slot0.timer.running then
		slot0.timer:Stop()
	end
end

slot0.fallingGridDic = function (slot0)
	function slot1(slot0, slot1)
		for slot5 = slot1 + 1, RollingBallConst.vertical, 1 do
			if slot0.gridDic[slot0][slot5] then
				return slot5
			end
		end

		return 0
	end

	for slot5 = 1, RollingBallConst.horizontal, 1 do
		for slot9 = 1, RollingBallConst.vertical, 1 do
			if not slot0.gridDic[slot5][slot9] and RollingBallConst.vertical - slot9 > 0 and slot1(slot5, slot9) > 0 then
				slot0.gridDic[slot5][slot11] = false
				slot0.gridDic[slot5][slot9] = slot0.gridDic[slot5][slot11]

				slot0.gridDic[slot5][slot9]:setPosData(slot5, slot9)
			end
		end
	end
end

slot0.firstInitGrid = function (slot0)
	for slot4 = 1, RollingBallConst.horizontal, 1 do
		slot0.fillGridDic[slot4] = {}

		for slot8 = 1, RollingBallConst.vertical, 1 do
			if not slot0.gridDic[slot4][slot8] then
				slot9 = {}

				if slot4 > 2 and slot0.gridDic[slot4 - 2][slot8]:getType() == slot0.gridDic[slot4 - 1][slot8]:getType() then
					table.insert(slot9, slot0.gridDic[slot4 - 2][slot8]:getType())
				end

				if slot8 > 2 and slot0.gridDic[slot4][slot8 - 2]:getType() == slot0.gridDic[slot4][slot8 - 1]:getType() then
					table.insert(slot9, slot0.gridDic[slot4][slot8 - 2]:getType())
				end

				slot10 = slot0:createGrid(slot0:getRandomType(slot9), slot4, slot8)
				slot0.gridDic[slot4][slot8] = slot10

				slot0:setFillGridPosition(slot10, slot4, #slot0.fillGridDic[slot4])
				table.insert(slot0.fillGridDic[slot4], slot10)
			end
		end
	end
end

slot0.fillEmptyGrid = function (slot0)
	for slot4 = 1, RollingBallConst.horizontal, 1 do
		slot0.fillGridDic[slot4] = {}

		for slot8 = 1, RollingBallConst.vertical, 1 do
			if not slot0.gridDic[slot4][slot8] then
				slot9 = slot0:createGrid(slot0:getRandomType(), slot4, slot8)
				slot0.gridDic[slot4][slot8] = slot9

				slot0:setFillGridPosition(slot9, slot4, #slot0.fillGridDic[slot4])
				table.insert(slot0.fillGridDic[slot4], slot9)
			end
		end
	end
end

slot0.setFillGridPosition = function (slot0, slot1, slot2, slot3)
	slot1:setPosition((slot2 - 1) * RollingBallConst.grid_width, (RollingBallConst.vertical + slot3) * RollingBallConst.grid_height)
end

slot0.onTimer = function (slot0)
	for slot4 = #slot0.moveDatas, 1, -1 do
		slot8 = slot0.moveDatas[slot4].grid.getPosition(slot6).y
		slot10 = slot0.moveDatas[slot4].endY

		if slot0.moveDatas[slot4].grid.getPosition(slot6).x == slot0.moveDatas[slot4].endX and slot8 == slot10 then
			slot6:setEventActive(true)
			table.remove(slot0.moveDatas, slot4)
		else
			slot11, slot12 = nil

			if math.abs(slot9 - slot7) < RollingBallConst.moveSpeed or slot9 == slot7 then
				slot11 = slot9 - slot7
			elseif slot7 < slot9 then
				slot11 = RollingBallConst.moveSpeed
			elseif slot9 < slot7 then
				slot11 = -RollingBallConst.moveSpeed
			end

			if math.abs(slot10 - slot8) < RollingBallConst.moveSpeed or slot8 == slot10 then
				slot12 = 0
				slot8 = slot10
			elseif slot8 < slot10 then
				slot12 = RollingBallConst.moveSpeed
			elseif slot10 < slot8 then
				slot12 = -RollingBallConst.moveSpeed
			end

			slot6:setPosition(slot7 + slot11, slot8 + slot12)
		end
	end

	for slot4 = #slot0.effectDatas, 1, -1 do
		slot0.effectDatas[slot4].ax = (slot0.effectTargetPosition.x - slot0.effectDatas[slot4].tf.localPosition.x) * 0.002
		slot0.effectDatas[slot4].ay = (slot0.effectTargetPosition.y - slot0.effectDatas[slot4].tf.localPosition.y) * 0.002
		slot0.effectDatas[slot4].vx = slot0.effectDatas[slot4].vx + slot0.effectDatas[slot4].ax
		slot0.effectDatas[slot4].vy = slot0.effectDatas[slot4].vy + slot0.effectDatas[slot4].ay
		slot0.effectDatas[slot4].tf.localPosition.x = slot0.effectDatas[slot4].tf.localPosition.x + slot0.effectDatas[slot4].vx
		slot0.effectDatas[slot4].tf.localPosition.y = slot0.effectDatas[slot4].tf.localPosition.y + slot0.effectDatas[slot4].vy
		slot0.effectDatas[slot4].tf.localPosition = slot0.effectDatas[slot4].tf.localPosition

		if slot0.effectDatas[slot4].tf.localPosition.x < slot0.effectTargetPosition.x then
			slot0:returnEffect(slot5.tf)
			table.remove(slot0.effectDatas, slot4)
		end
	end

	if slot0.onBeginDragTime and slot0.downTime > 0 then
		slot0.downTime = slot0.downTime - (Time.realtimeSinceStartup - slot0.onBeginDragTime) * 1000
		slot0.onBeginDragTime = Time.realtimeSinceStartup

		if slot0.downTime <= 0 then
			slot0.downTime = 0

			if slot0.selectGrid then
				slot0.selectGrid.onEndDrag(slot2)
				slot0:onGridUp(slot2)
				slot0.selectGrid.addUpCallback(slot2, function (slot0, slot1)
					slot0:onGridUp(slot1)
				end)
				slot0.selectGrid.addDragCallback(slot2, function (slot0, slot1)
					slot0:onGridDrag(slot1, slot0, slot1)
				end)
			end
		end
	end

	slot0.downTimeSlider.value = slot0.downTime / RollingBallConst.downTime

	if slot0.gameTimeFlag and slot0.gameTime > 0 and not isActive(slot0.closeUI) then
		slot0.gameTime = slot0.gameTime - (Time.realtimeSinceStartup - slot0.gameTimeReal) * 1000

		if slot0.gameTime > 0 and slot0.gameTime <= 8000 and not isActive(slot0.overLight) then
			setActive(slot0.overLight, true)
		end

		if slot0.gameTime <= 0 then
			slot0.gameTime = 0

			setActive(slot0.overLight, false)

			slot0.stopFlag = true
		end
	end

	slot0.gameTimeReal = Time.realtimeSinceStartup

	if math.floor(slot0.gameTime / 60000) < 10 then
		slot1 = "0" .. slot1 or slot1
	end

	if math.floor(slot0.gameTime % 60000 / 1000) < 10 then
		slot2 = "0" .. slot2 or slot2
	end

	if math.floor(math.floor(slot0.gameTime % 1000) / 10) < 10 then
		setText(slot0.labelGameTime, slot1 .. ":" .. slot2 .. ":" .. ("0" .. slot3 or slot3))
	end

	if #slot0.moveDatas == 0 then
		if slot0.stopFlag then
			slot0:gameStop()

			return
		end

		if slot0.checkSuccesFlag then
			slot0.checkSuccesFlag = false

			slot0:checkSuccessGrid()
		end

		if slot0.isMoveing then
			slot0.isMoveing = false
		end
	elseif not slot0.isMoveing then
		slot0.isMoveing = true
	end
end

slot0.moveGridsByChangeDic = function (slot0)
	slot0.moveDatas = {}

	for slot4 = 1, #slot0.changeGridsDic, 1 do
		for slot9 = 1, #slot0.changeGridsDic[slot4], 1 do
			if slot5[slot9].grid ~= slot0.selectGrid then
				slot0:moveGridToPos(slot10.grid, slot10.posX, slot10.posY)
			end
		end
	end

	if #slot0.moveDatas > 0 then
		slot0:timerStart()
	end
end

slot0.moveGridsBySelfPos = function (slot0, slot1, slot2)
	slot0.moveDatas = {}

	for slot6 = 1, #slot1, 1 do
		for slot10 = 1, #slot1[slot6], 1 do
			if slot1[slot6][slot10] and slot11 ~= slot2 then
				slot0:moveGridToPos(slot11, slot11:getPosData())
			end
		end
	end

	if #slot0.moveDatas > 0 then
		slot0:timerStart()
	end
end

slot0.moveGridToPos = function (slot0, slot1, slot2, slot3)
	slot4 = slot1:getPosition().x
	slot5 = slot1:getPosition().y
	slot7 = (slot3 - 1) * RollingBallConst.grid_height

	if math.floor(slot6) == math.floor(slot2) and math.floor(slot7) == math.floor(slot3) then
		return
	end

	slot1:setEventActive(false)
	table.insert(slot0.moveDatas, {
		grid = slot1,
		endX = slot6,
		endY = slot7
	})
end

slot0.updateMoveGridDic = function (slot0)
	for slot4 = 1, #slot0.changeGridsDic, 1 do
		for slot9 = 1, #slot0.changeGridsDic[slot4], 1 do
			if slot5[slot9].grid then
				slot10.grid:setPosData(slot10.posX, slot10.posY)
			end
		end
	end

	slot0:sortGridDic()
end

slot0.sortGridDic = function (slot0)
	slot1 = {}

	function slot2(slot0, slot1)
		for slot5 = 1, #slot0, 1 do
			slot6, slot7 = slot0[slot5]:getPosData()

			if slot6 == slot0 and slot7 == slot1 then
				return table.remove(slot0, slot5)
			end
		end

		return nil
	end

	for slot6 = 1, #slot0.gridDic, 1 do
		for slot10 = 1, #slot0.gridDic[slot6], 1 do
			slot12 = nil

			if slot0.gridDic[slot6][slot10] ~= slot6 or slot12 ~= slot10 then
				table.insert(slot1, slot0.gridDic[slot6][slot10])

				slot0.gridDic[slot6][slot10] = false
			end
		end
	end

	for slot6 = 1, #slot0.gridDic, 1 do
		for slot10 = 1, #slot0.gridDic[slot6], 1 do
			if slot0.gridDic[slot6][slot10] == false then
				slot0.gridDic[slot6][slot10] = slot2(slot6, slot10)
			end
		end
	end
end

slot0.checkSuccessGrid = function (slot0)
	slot1 = nil

	slot0:updateRemoveFlag()

	slot0.gameTimeFlag = false
	slot2 = {}

	seriesAsync({
		function (slot0)
			for slot4 = 1, RollingBallConst.horizontal, 1 do
				for slot8 = 1, RollingBallConst.vertical, 1 do
					slot0.gridDic[slot4][slot8].setEventActive(slot9, false)

					if slot0.gridDic[slot4][slot8]:getRemoveFlagV() or slot9:getRemoveFlagH() then
						slot11, slot12 = slot9:getPosData()

						if not slot1[slot9:getRemoveId()] then
							slot1[slot10] = {
								amount = 0,
								posList = {}
							}
						end

						slot1[slot10].amount = slot1[slot10].amount + 1

						table.insert(slot1[slot10].posList, {
							x = slot11,
							y = slot12
						})
						slot0:returnGrid(slot9)

						slot0.gridDic[slot4][slot8] = false

						if not slot2 then
							slot2 = true
						end
					end
				end
			end

			slot0()
		end,
		function (slot0)
			if slot0 then
				LeanTween.delayedCall(go(slot1.rollingUI), 0.7, System.Action(function ()
					slot0()
				end))
				LeanTween.delayedCall.updateScore(slot1, )
				LeanTween.delayedCall.updateScore:updateCombo()
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot1)
			else
				slot1.comboAmount = 0

				slot0()
			end
		end,
		function (slot0)
			if not slot0.stopFlag then
				slot0:fallingGridDic()
				slot0:fillEmptyGrid()
				slot0:moveGridsBySelfPos(slot0.gridDic, nil)

				if slot0.moveGridsBySelfPos then
					slot0.checkSuccesFlag = true
				end
			end

			slot0()
		end
	}, function ()
		slot0.gameTimeFlag = true
	end)
end

slot0.updateCombo = function (slot0)
	setActive(slot0.goodEffect, false)
	setActive(slot0.greatEffect, false)
	setActive(slot0.perfectEffect, false)

	if slot0.comboAmount == 2 then
		setActive(slot0.goodEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)
	elseif slot0.comboAmount == 3 then
		setActive(slot0.greatEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)
	elseif slot0.comboAmount >= 4 then
		setActive(slot0.perfectEffect, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(pg.CriMgr.GetInstance().PlaySoundEffect_V3)
	end

	if slot0.comboAmount > 1 then
		if LeanTween.isTweening(go(slot0.caidaiTf)) then
			LeanTween.cancel(go(slot0.caidaiTf))
		end

		LeanTween.delayedCall(go(slot0.caidaiTf), 3, System.Action(function ()
			setActive(slot0.caidaiTf, false)
		end))
		setActive(slot0.caidaiTf, true)
	end
end

slot0.updateScore = function (slot0, slot1)
	for slot5, slot6 in pairs(slot1) do
		slot0.comboAmount = slot0.comboAmount + 1
	end

	slot2 = 10 * slot0.comboAmount
	slot3 = 0

	for slot7, slot8 in pairs(slot1) do
		slot9 = nil
		slot3 = slot3 + slot2 * ((slot8.amount == 3 and 1) or (slot8.amount == 4 and 1.5) or 2) * slot8.amount
		slot10 = slot2 * ((slot8.amount == 3 and 1) or (slot8.amount == 4 and 1.5) or 2)

		for slot14 = 1, #slot8.posList, 1 do
			slot0:addGridScoreTip(slot8.posList[slot14], slot10)
			slot0:addRemoveEffect(slot8.posList[slot14])
		end
	end

	LeanTween.delayedCall(go(slot0.labelGameScore), 0.7, System.Action(function ()
		if LeanTween.isTweening(go(slot0.labelGameScore)) then
			LeanTween.cancel(go(slot0.labelGameScore))
		end

		LeanTween.value(go(slot0.labelGameScore), slot0, slot1, 1.7):setOnUpdate(System.Action_float(function (slot0)
			setText(slot0.labelGameScore, math.floor(slot0))
		end)).setOnComplete(slot2, System.Action(function ()
			setText(slot0.labelGameScore, )
		end))

		slot0.gameScore = slot0.gameScore + 

		pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, pg.CriMgr.GetInstance().PlaySoundEffect_V3)
	end))
end

slot0.updateRemoveFlag = function (slot0)
	for slot4 = 1, RollingBallConst.horizontal, 1 do
		for slot8 = 1, RollingBallConst.vertical, 1 do
			slot0:checkGridRemove(slot0.gridDic[slot4][slot8], slot4, slot8)
		end
	end
end

slot0.checkGridRemove = function (slot0, slot1, slot2, slot3)
	if not slot1:getRemoveFlagH() and slot2 < RollingBallConst.horizontal - 1 then
		slot4 = 0
		slot5 = true
		slot6 = nil
		slot7 = {}

		for slot11 = slot2, RollingBallConst.horizontal, 1 do
			if slot1:getType() == slot0.gridDic[slot11][slot3]:getType() and slot5 then
				slot4 = slot4 + 1

				table.insert(slot7, slot0.gridDic[slot11][slot3])

				if slot0.gridDic[slot11][slot3]:getRemoveId() then
					slot6 = slot0.gridDic[slot11][slot3]:getRemoveId()
				end
			else
				slot5 = nil
			end
		end

		if slot4 and slot4 >= 3 then
			slot6 = slot6 or slot0:getGridRemoveId()

			for slot11 = 1, #slot7, 1 do
				slot7[slot11]:setRemoveFlagH(true, slot6)
			end
		end
	end

	if not slot1:getRemoveFlagV() and slot3 < RollingBallConst.vertical - 1 then
		slot4 = 0
		slot5 = true
		slot6 = nil
		slot7 = {}

		for slot11 = slot3, RollingBallConst.vertical, 1 do
			if slot1:getType() == slot0.gridDic[slot2][slot11]:getType() and slot5 then
				slot4 = slot4 + 1

				table.insert(slot7, slot0.gridDic[slot2][slot11])

				if slot0.gridDic[slot2][slot11]:getRemoveId() then
					slot6 = slot0.gridDic[slot2][slot11]:getRemoveId()
				end
			else
				slot5 = nil
			end
		end

		if slot4 and slot4 >= 3 then
			slot6 = slot6 or slot0:getGridRemoveId()

			for slot11 = 1, #slot7, 1 do
				slot7[slot11]:setRemoveFlagV(true, slot6)
			end
		end
	end
end

slot0.onGridDown = function (slot0, slot1)
	if slot0.isMoveing or slot0.selectGrid or #slot0.moveDatas > 0 then
		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)

	slot0.selectGrid = slot1

	slot0.selectGrid:getTf():SetAsLastSibling()
end

slot0.onGridUp = function (slot0, slot1)
	slot0.selectGrid = nil

	if slot0.changeGridsDic then
		slot0:updateMoveGridDic()

		slot0.changeGridsDic = nil
	end

	slot0:clearDragAlpha()

	slot0.onBeginDragTime = nil

	slot0:moveGridsBySelfPos(slot0.gridDic, nil)

	slot0.checkSuccesFlag = true
	slot0.downTime = RollingBallConst.downTime
end

slot0.checkChangePos = function (slot0, slot1)
	slot2, slot3 = slot1:getPosData()
	slot4, slot5 = slot0.selectGrid:getPosData()

	if slot1 == slot0.selectGrid or (slot4 ~= slot2 and slot5 ~= slot3) then
		slot0:moveGridsBySelfPos(slot0.gridDic, slot0.selectGrid, function ()
			return
		end)

		slot0.selectEnterGrid = nil
		slot0.changeGridsDic = nil
		slot0.changePosX, slot0.changePosY = nil
	else
		if slot0.changePosX == slot2 and slot0.changePosY == slot3 then
			return
		end

		slot0.changePosY = slot3
		slot0.changePosX = slot2

		slot0:updateEnterGrid(slot0.changePosX, slot0.changePosY)
		slot0:moveGridsByChangeDic()
	end
end

slot0.onGridBeginDrag = function (slot0, slot1, slot2, slot3)
	if slot0.isMoveing or not slot0.selectGrid or slot1 ~= slot0.selectGrid then
		return
	end

	slot0.onBeginDragTime = Time.realtimeSinceStartup
	slot0.downTime = RollingBallConst.downTime
	slot10, slot11 = slot0.selectGrid:getPosData()

	slot0:setDragAlpha(slot5, slot6, slot0.selectGrid:getType())

	slot0.changePosX, slot0.changePosY = nil
	slot0.dragOffsetPos.x = slot3.position.x - slot0.selectGrid:getTf().transform.localPosition.x
	slot0.dragOffsetPos.y = slot3.position.y - slot0.selectGrid.getTf().transform.localPosition.y
end

slot0.onGridDrag = function (slot0, slot1, slot2, slot3)
	if not slot0.selectGrid or slot1 ~= slot0.selectGrid then
		return
	end

	if not slot0.uiCam then
		slot0.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")
	end

	slot7 = slot0.rollingUI:InverseTransformPoint(slot4).y - RollingBallConst.grid_height / 2

	if slot0.rollingUI.InverseTransformPoint(slot4).x - RollingBallConst.grid_width / 2 < 0 then
		slot6 = 0
	end

	if slot7 < 0 then
		slot7 = 0
	end

	if slot6 > (RollingBallConst.horizontal - 1) * RollingBallConst.grid_width then
		slot6 = (RollingBallConst.horizontal - 1) * RollingBallConst.grid_width
	end

	if slot7 > (RollingBallConst.vertical - 1) * RollingBallConst.grid_height then
		slot7 = (RollingBallConst.vertical - 1) * RollingBallConst.grid_height
	end

	slot0.selectGrid:changePosition(slot6, slot7)

	if slot0:getGridByPosition(slot0.selectGrid:getPosition()) and slot8 ~= slot0.selectGrid then
		slot9, slot10 = slot8:getPosData()
		slot11, slot12 = slot0.selectGrid:getPosData()

		if math.abs(slot13) + math.abs(slot10 - slot12) == 1 then
			slot0:updateMove(slot9, slot10)
		elseif math.abs(slot14) < math.abs(slot13) then
			if slot13 > 0 then
				slot9 = slot11 + 1
			end

			if slot13 < 0 then
				slot9 = slot11 - 1
			end

			slot0:updateMove(slot9, slot12)
		else
			if slot14 > 0 then
				slot10 = slot12 + 1
			end

			if slot14 < 0 then
				slot10 = slot12 - 1
			end

			slot0:updateMove(slot11, slot10)
		end
	end
end

slot0.updateMove = function (slot0, slot1, slot2)
	if RollingBallConst.horizontal < slot1 or RollingBallConst.vertical < slot2 then
		return
	end

	slot0:changeDragGrid(slot1, slot2)
	slot0:updateMoveGridDic()

	slot0.changeGridsDic = nil

	slot0:moveGridsBySelfPos(slot0.gridDic, slot0.selectGrid)
	slot0:setDragAlpha(slot1, slot2, slot0.selectGrid:getType())
end

slot0.getGridByPosition = function (slot0, slot1)
	slot3 = math.floor((slot1.y + RollingBallConst.grid_height / 2) / RollingBallConst.grid_height) + 1

	if math.floor((slot1.x + RollingBallConst.grid_width / 2) / RollingBallConst.grid_width) + 1 >= 1 and slot2 <= RollingBallConst.horizontal and slot3 >= 1 and slot3 <= RollingBallConst.vertical then
		return slot0.gridDic[slot2][slot3]
	end

	return nil
end

slot0.updateEnterGrid = function (slot0, slot1, slot2)
	slot3, slot4 = slot0.selectGrid:getPosData()
	slot0.changeGridsDic = {}

	for slot8 = 1, #slot0.gridDic, 1 do
		slot0.changeGridsDic[slot8] = {}

		for slot12 = 1, #slot0.gridDic[slot8], 1 do
			if slot8 ~= slot3 and slot12 ~= slot4 then
				table.insert(slot0.changeGridsDic[slot8], {
					grid = slot0.gridDic[slot8][slot12],
					posX = slot8,
					posY = slot12
				})
			elseif slot8 == slot3 and slot12 == slot4 then
				table.insert(slot0.changeGridsDic[slot8], {
					grid = slot0.gridDic[slot8][slot12],
					posX = slot1,
					posY = slot2
				})
			elseif slot8 == slot3 then
				if slot4 < slot12 and slot12 <= slot2 then
					table.insert(slot0.changeGridsDic[slot8], {
						grid = slot0.gridDic[slot8][slot12],
						posX = slot8,
						posY = slot12 - 1
					})
				elseif slot12 < slot4 and slot2 <= slot12 then
					table.insert(slot0.changeGridsDic[slot8], {
						grid = slot0.gridDic[slot8][slot12],
						posX = slot8,
						posY = slot12 + 1
					})
				else
					table.insert(slot0.changeGridsDic[slot8], {
						grid = slot0.gridDic[slot8][slot12],
						posX = slot8,
						posY = slot12
					})
				end
			elseif slot12 == slot4 then
				if slot3 < slot8 and slot8 <= slot1 then
					table.insert(slot0.changeGridsDic[slot8], {
						grid = slot0.gridDic[slot8][slot12],
						posX = slot8 - 1,
						posY = slot12
					})
				elseif slot8 < slot3 and slot1 <= slot8 then
					table.insert(slot0.changeGridsDic[slot8], {
						grid = slot0.gridDic[slot8][slot12],
						posX = slot8 + 1,
						posY = slot12
					})
				else
					table.insert(slot0.changeGridsDic[slot8], {
						grid = slot0.gridDic[slot8][slot12],
						posX = slot8,
						posY = slot12
					})
				end
			end
		end
	end
end

slot0.changeDragGrid = function (slot0, slot1, slot2)
	slot3, slot4 = slot0.selectGrid:getPosData()
	slot0.changeGridsDic = {}

	for slot8 = 1, #slot0.gridDic, 1 do
		slot0.changeGridsDic[slot8] = {}

		for slot12 = 1, #slot0.gridDic[slot8], 1 do
			if slot8 == slot1 and slot12 == slot2 then
				table.insert(slot0.changeGridsDic[slot8], {
					grid = slot0.gridDic[slot8][slot12],
					posX = slot3,
					posY = slot4
				})
			elseif slot8 == slot3 and slot12 == slot4 then
				table.insert(slot0.changeGridsDic[slot8], {
					grid = slot0.gridDic[slot8][slot12],
					posX = slot1,
					posY = slot2
				})
			else
				table.insert(slot0.changeGridsDic[slot8], {
					grid = slot0.gridDic[slot8][slot12],
					posX = slot8,
					posY = slot12
				})
			end
		end
	end
end

slot0.createGrid = function (slot0, slot1, slot2, slot3)
	slot4 = nil
	slot5 = #slot0.gridsPool

	if #slot0.gridsPool > 0 then
		slot4 = table.remove(slot0.gridsPool, 1)
	else
		RollingBallGrid.New(tf(Instantiate(slot0.tplGrid))).addDownCallback(slot4, function (slot0, slot1)
			slot0:onGridDown(slot1)
		end)
		RollingBallGrid.New(tf(Instantiate(slot0.tplGrid))).addUpCallback(slot4, function (slot0, slot1)
			slot0:onGridUp(slot1)
		end)
		RollingBallGrid.New(tf(Instantiate(slot0.tplGrid))).addBeginDragCallback(slot4, function (slot0, slot1)
			slot0:onGridBeginDrag(slot1, slot0, slot1)
		end)
		RollingBallGrid.New(tf(Instantiate(slot0.tplGrid))).addDragCallback(slot4, function (slot0, slot1)
			slot0:onGridDrag(slot1, slot0, slot1)
		end)
		setActive(RollingBallGrid.New(tf(Instantiate(slot0.tplGrid))).getTf(slot4), true)
	end

	slot4:setParent(slot0.rollingUI)
	slot4:setType(slot1)
	slot4:setPosData(slot2, slot3)

	return slot4
end

slot0.setDragAlpha = function (slot0, slot1, slot2, slot3)
	slot0.dragAlphaGrid:setPosition(slot4, (slot2 - 1) * RollingBallConst.grid_height)
	slot0.dragAlphaGrid:setType(slot3)
	setActive(slot0.dragAlphaGrid:getTf(), true)
end

slot0.clearDragAlpha = function (slot0)
	setActive(slot0.dragAlphaGrid:getTf(), false)
end

slot0.returnGrid = function (slot0, slot1)
	slot0:removeGrid(slot1)
	slot1:clearData()
	slot1:setParent(slot0.gridPoolTf)
	slot1:setEventActive(false)
	table.insert(slot0.gridsPool, slot1)
end

slot0.removeGrid = function (slot0, slot1)
	slot2, slot3 = slot1:getPosData()

	if not slot0.gridDic[slot2][slot3] then
		slot0.gridDic[slot2][slot3] = false
	end
end

slot0.getRandomType = function (slot0, slot1)
	if slot1 then
		slot2 = {}

		for slot6 = 1, RollingBallConst.grid_type_amount, 1 do
			if not table.contains(slot1, slot6) then
				table.insert(slot2, slot6)
			end
		end

		return slot2[math.random(1, #slot2)]
	end

	return math.random(1, RollingBallConst.grid_type_amount)
end

slot0.addGridScoreTip = function (slot0, slot1, slot2)
	slot5 = slot0:getScoreTip()
	slot5.localPosition = Vector3(slot6, slot7, 0)

	setText(findTF(slot5, "text"), "+" .. slot2)
	LeanTween.moveLocalY(go(slot5), (slot1.y - 1) * RollingBallConst.grid_height + 30, 0.5):setOnComplete(System.Action(function ()
		slot0:returnScoreTip(slot0)
	end))
end

slot0.addRemoveEffect = function (slot0, slot1)
	slot0:getRemoveEffect().localPosition = Vector3((slot1.x - 1) * RollingBallConst.grid_width + 50, (slot1.y - 1) * RollingBallConst.grid_height + 50, -350)

	LeanTween.delayedCall(go(slot4), 0.7, System.Action(function ()
		slot0:returnRemoveEffect(slot0)
	end))
end

slot0.getRemoveEffect = function (slot0)
	if not slot0.removeEffectPool then
		slot0.removeEffectPool = {}
		slot0.removeEffects = {}
	end

	slot1 = nil

	if #slot0.removeEffectPool > 1 then
		slot1 = table.remove(slot0.removeEffectPool, #slot0.removeEffectPool)
	else
		setParent(slot1, slot0.rollingEffectUI, false)
		table.insert(slot0.removeEffects, tf(Instantiate(slot0.tplRemoveEffect)))
	end

	setActive(slot1, true)

	return slot1
end

slot0.returnRemoveEffect = function (slot0, slot1)
	setActive(slot1, false)
	table.insert(slot0.removeEffectPool, slot1)
end

slot0.getScoreTip = function (slot0)
	if not slot0.scoreTipPool then
		slot0.scoreTipPool = {}
		slot0.scoreTips = {}
	end

	slot1 = nil

	if #slot0.scoreTipPool > 1 then
		slot1 = table.remove(slot0.scoreTipPool, #slot0.scoreTipPool)
	else
		setParent(slot1, slot0.rollingEffectUI, false)
		table.insert(slot0.scoreTips, tf(Instantiate(slot0.tplScoreTip)))
	end

	setActive(slot1, true)

	return slot1
end

slot0.returnScoreTip = function (slot0, slot1)
	setActive(slot1, false)
	table.insert(slot0.scoreTipPool, slot1)
end

slot0.addEffect = function (slot0, slot1)
	slot3 = slot0:getEffect()

	setParent(slot3, slot0.effectUI, false)
	setActive(slot3, true)

	slot3.localPosition = slot0.effectUI:InverseTransformPoint(slot1)

	table.insert(slot0.effectDatas, {
		vy = 2,
		ay = 0,
		vx = 2,
		ax = 0,
		tf = slot3
	})
end

slot0.clearUI = function (slot0)
	slot0.moveDatas = {}
	slot0.startFlag = false
	slot0.stopFlag = false

	setText(slot0.labelGameScore, "0000")
	setText(slot0.labelGameTime, "")
	setActive(slot0.endLess, true)

	slot0.downTimeSlider.value = 1

	setActive(slot0.closeUI, false)
	setActive(slot0.overLight, false)
	slot0:clearDragAlpha()

	for slot4 = #slot0.effectDatas, 1, -1 do
		slot0:returnEffect(slot5)
		table.remove(slot0.effectDatas, slot4)
	end

	for slot4 = 1, RollingBallConst.horizontal, 1 do
		for slot8 = 1, RollingBallConst.vertical, 1 do
			if slot0.gridDic[slot4][slot8] then
				slot0:returnGrid(slot0.gridDic[slot4][slot8])

				slot0.gridDic[slot4][slot8] = false
			end
		end
	end
end

slot0.getEffect = function (slot0)
	if #slot0.effectPool > 0 then
		return table.remove(slot0.effectPool, #slot0.effectPool)
	end

	return tf(Instantiate(slot0.tplEffect))
end

slot0.returnEffect = function (slot0, slot1)
	SetParent(slot1, slot0.effectPoolTf, false)
	table.insert(slot0.effectPool, slot1)
end

slot0.getGridRemoveId = function (slot0)
	if not slot0.removeId then
		slot0.removeId = 0
	end

	slot0.removeId = slot0.removeId + 1

	return tostring(slot0.removeId)
end

slot0.onBackPressed = function (slot0)
	if not slot0.startFlag then
		slot0:emit(slot0.ON_BACK_PRESSED)
	end
end

slot0.willExit = function (slot0)
	if slot0.timer and slot0.timer.running then
		slot0.timer:Stop()
	end

	if LeanTween.isTweening(go(slot0.caidaiTf)) then
		LeanTween.cancel(go(slot0.caidaiTf))
	end

	if LeanTween.isTweening(go(slot0.labelGameScore)) then
		LeanTween.cancel(go(slot0.labelGameScore))
	end

	if LeanTween.isTweening(go(slot0.rollingUI)) then
		LeanTween.cancel(go(slot0.rollingUI))
	end

	if slot0.scoreTips then
		for slot4 = 1, #slot0.scoreTips, 1 do
			if LeanTween.isTweening(go(slot0.scoreTips[slot4])) then
				LeanTween.cancel(go(slot0.scoreTips[slot4]))
			end
		end
	end

	if slot0.removeEffects then
		for slot4 = 1, #slot0.removeEffects, 1 do
			if LeanTween.isTweening(go(slot0.removeEffects[slot4])) then
				LeanTween.cancel(go(slot0.removeEffects[slot4]))
			end
		end
	end

	slot0.timer = nil
end

return slot0

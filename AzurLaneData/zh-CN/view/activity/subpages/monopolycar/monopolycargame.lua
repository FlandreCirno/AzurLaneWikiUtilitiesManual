slot0 = class("MonopolyCarGame")
slot1 = 100
slot2 = 50
slot3 = "redcar"
slot4, slot5 = nil
slot6 = {
	"gaoxiong_5",
	"aidang_5",
	"dafeng_5",
	"yuekegongjue_2",
	"weiershiqinwang_3",
	"xianghe_3",
	"ruihe_3"
}
slot7 = {
	"gaoxiong_5",
	"aidang_5",
	"dafeng_5",
	"yuekegongjue_2",
	"weiershiqinwang_3",
	"xianghe_3",
	"ruihe_3"
}
slot8 = 0.6
slot9 = "B-stand"
slot10 = "F-stand"
slot11 = "B-walk"
slot12 = "F-walk"
slot13 = "typeMoveUp"
slot14 = "typeMoveDown"
slot15 = "typeMoveLeft"
slot16 = "typeMoveRight"

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0._binder = slot1
	slot0._tf = slot2
	slot0._event = slot3

	slot0:initData()
	slot0:initUI()
	slot0:initEvent()
end

slot0.initData = function (slot0)
	slot0.leftCount = 0
	slot0.inAnimatedFlag = false
	slot0.mapCells = {}
	slot2 = slot3[slot0[math.random(1, #slot0)]]
end

slot0.initUI = function (slot0)
	slot0.tplMapCell = findTF(slot0._tf, "tplMapCell")
	slot0.mapContainer = findTF(slot0._tf, "mapContainer")
	slot0.char = findTF(slot0._tf, "mapContainer/char")
	slot0.showChar = findTF(slot0._tf, "showChar")

	setActive(slot0.char, false)

	slot0.btnStart = findTF(slot0._tf, "btnStart")
	slot0.btnHelp = findTF(slot0._tf, "btnHelp")
	slot0.btnRp = findTF(slot0._tf, "btnRp")
	slot0.commonAnim = findTF(slot0.btnRp, "rpAni"):GetComponent(typeof(Animator))
	slot0.labelLeftCountTip = findTF(slot0.btnStart, "labelLeftCountTip")

	setActive(slot0.labelLeftCountTip, false)

	slot0.labelLeftCount = findTF(slot0.btnStart, "labelLeftCount")
	slot0.labelDropShip = findTF(slot0._tf, "labelDropShip")
	slot0.labelLeftRpCount = findTF(slot0._tf, "labelLeftRpCount")
	slot0.rollStep = findTF(slot0._tf, "step")

	setActive(slot0.rollStep, false)

	slot0.mcTouzi = findTF(slot0._tf, "mcTouzi")
	slot0.imgTouzi = findTF(slot0._tf, "imgTouzi")

	setActive(slot0.mcTouzi, false)
	slot0:initMap()
	slot0:initChar()
end

slot0.initEvent = function (slot0)
	onButton(slot0._binder, slot0.btnStart, function ()
		if slot0.inAnimatedFlag then
			return
		end

		if slot0.leftCount and slot0.leftCount <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_count_noenough"))

			return
		end

		slot0:changeAnimeState(true)
		setActive(slot0.btnStart, true)
		setActive._event:emit(MonopolyCarPage.ON_START, slot0.activity.id, function (slot0)
			if slot0 and slot0 > 0 then
				slot0:showRollAnimated(slot0)
			end
		end)
	end, SFX_PANEL)
	onButton(slot0._binder, slot0.btnHelp, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_monopoly_car.tip
		})
	end, SFX_PANEL)
	onButton(slot0._binder, slot0.showChar, function ()
		slot0._event:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
	onButton(slot0._binder, slot0.btnRp, function ()
		if slot0.leftAwardCnt > 0 then
			slot0._event:emit(MonopolyCarPage.ON_AWARD)
		end
	end, SFX_PANEL)
end

slot0.showRollAnimated = function (slot0, slot1)
	findTF(slot0.rollStep, "stepArrow").localEulerAngles = Vector3(0, 0, 0)
	findTF(slot0.rollStep, "progress/bg"):GetComponent(typeof(Image)).fillAmount = 0.1
	findTF(slot0.rollStep, "select/bg"):GetComponent(typeof(Image)).fillAmount = 0.1

	setText(findTF(slot0.rollStep, "labelRoll"), "0")
	seriesAsync({
		function (slot0)
			LeanTween.value(go(slot0._tf), 1, 0, 0.2):setOnUpdate(System.Action_float(function (slot0)
				slot0.btnStart:GetComponent(typeof(CanvasGroup)).alpha = slot0
			end)).setOnComplete(slot1, System.Action(function ()
				setActive(slot0.btnStart, false)

				setActive.btnStart:GetComponent(typeof(CanvasGroup)).alpha = 1

				1()
			end))
		end,
		function (slot0)
			LeanTween.value(go(slot0._tf), 0, 1, 0.2):setOnUpdate(System.Action_float(function (slot0)
				slot0.rollStep:GetComponent(typeof(CanvasGroup)).alpha = slot0

				setActive(slot0.rollStep, true)
			end)).setOnComplete(slot1, System.Action(function ()
				slot0()
			end))
		end,
		function (slot0)
			slot2 = (slot0 / 6 * 0.62) / slot0
			slot3 = -slot0 * 31

			LeanTween.value(go(slot1._tf), 0, 1, 0.7 + slot0 / 5):setEase(LeanTweenType.easeOutCirc):setOnUpdate(System.Action_float(function (slot0)
				findTF(slot0.rollStep, "progress/bg"):GetComponent(typeof(Image)).fillAmount = slot1 * slot0 + 0.13
				findTF(slot0.rollStep, "select/bg"):GetComponent(typeof(Image)).fillAmount = findTF(slot0.rollStep, "select/bg") * math.floor(slot0 / (1 / slot3)) + 0.17

				setText(findTF(slot0.rollStep, "labelRoll"), math.floor(slot0 / (1 / slot3)))

				slot5.localEulerAngles = Vector3(0, 0, slot4 * slot0 - 13)
			end)).setOnComplete(slot4, System.Action(function ()
				slot0()
			end))
		end,
		function (slot0)
			LeanTween.value(go(slot0._tf), 1, 0, 0.3):setOnComplete(System.Action(function ()
				slot0()
			end))
		end,
		function (slot0)
			LeanTween.value(go(slot0._tf), 1, 0, 0.3):setOnUpdate(System.Action_float(function (slot0)
				slot0.rollStep:GetComponent(typeof(CanvasGroup)).alpha = slot0
			end)).setOnComplete(slot1, System.Action(function ()
				setActive(slot0.rollStep, false)

				setActive.rollStep:GetComponent(typeof(CanvasGroup)).alpha = 1

				1()
			end))
		end
	}, function ()
		setActive(slot0.mcTouzi, true)
		setActive(slot0.mcTouzi, false)

		setActive.useCount = slot0.useCount + 1
		setActive.step = slot0.useCount + 1

		if setActive.step > 0 then
			slot0 = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", slot0.step)

			setActive(slot0.imgTouzi, true)

			slot0.imgTouzi:GetComponent(typeof(Image)).sprite = slot0
		end

		slot0:updataUI()
		slot0.updataUI:checkCharActive()
	end)
end

slot0.checkCountStory = function (slot0, slot1)
	slot2 = slot0.useCount
	slot4 = slot0.activity:getDataConfig("story") or {}

	if _.detect(slot4, function (slot0)
		return slot0[1] == slot0
	end) then
		pg.NewStoryMgr.GetInstance().Play(slot6, slot5[2], slot1)
	else
		slot1()
	end
end

slot0.changeAnimeState = function (slot0, slot1)
	if slot1 then
		slot0.btnStart:GetComponent(typeof(Image)).raycastTarget = false
		slot0.inAnimatedFlag = true

		slot0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
	else
		slot0.inAnimatedFlag = false
		slot0.btnStart:GetComponent(typeof(Image)).raycastTarget = true

		setActive(slot0.imgTouzi, false)
		slot0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)
	end

	setActive(slot0.btnStart, not slot1)
end

slot0.initMap = function (slot0)
	slot0.mapCells = {}

	for slot5 = 1, #MonopolyCarConst.map_dic, 1 do
		slot7 = {
			x = -(slot5 - 1) * slot0,
			y = -(slot5 - 1) * slot1
		}

		for slot12 = 1, #slot1[slot5], 1 do
			slot13 = slot12 - 1

			if slot8[slot12] > 0 then
				slot15 = cloneTplTo(slot0.tplMapCell, slot0.mapContainer, tostring(slot14))
				slot15.localPosition = Vector2(slot0 * slot13 + slot7.x, -slot1 * slot13 + slot7.y)
				findTF(slot15, "image"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/activityuipage/monopolycar_atlas", slot17)

				findTF(slot15, "image"):GetComponent(typeof(Image)):SetNativeSize()
				table.insert(slot0.mapCells, {
					col = slot13,
					row = slot6,
					mapId = slot14,
					tf = slot15,
					icon = pg.activity_event_monopoly_map[slot14].icon,
					position = Vector2(slot0 * slot13 + slot7.x, -slot1 * slot13 + slot7.y)
				})
			end
		end
	end

	table.sort(slot0.mapCells, function (slot0, slot1)
		return slot0.mapId < slot1.mapId
	end)
end

slot0.initChar = function (slot0)
	PoolMgr.GetInstance():GetSpineChar(slot0, true, function (slot0)
		slot0.model = slot0
		slot0.model.transform.localScale = Vector3.one
		slot0.model.transform.localPosition = Vector3.zero

		slot0.model.transform:SetParent(slot0.char, false)

		slot0.anim = slot0.model:GetComponent(typeof(SpineAnimUI))

		slot0:checkCharActive()

		if slot0.pos then
			slot0:updataCharDirect(slot0.pos, false)
		end
	end)
	PoolMgr.GetInstance().GetSpineChar(slot1, PoolMgr.GetInstance().GetSpineChar, true, function (slot0)
		slot0.showModel = slot0
		slot0.showModel.transform.localScale = Vector3.one
		slot0.showModel.transform.localPosition = Vector3.zero

		slot0.showModel.transform:SetParent(slot0.showChar, false)

		slot0.showAnim = slot0.showModel:GetComponent(typeof(SpineAnimUI))

		slot0.showAnim:SetAction("stand", 0)
	end)
end

slot0.updataCharDirect = function (slot0, slot1, slot2)
	if slot0.model then
		slot3 = slot0.mapCells[slot1].position
		slot5 = slot0.mapCells[(slot1 + 1 > #slot0.mapCells and 1) or slot1 + 1]
		slot0.char.localScale = Vector3(slot7, slot0.char.localScale.y, slot0.char.localScale.z)

		slot0.anim:SetActionCallBack(nil)
		slot0.anim:SetAction(slot6, 0)
	end
end

slot0.getMoveType = function (slot0, slot1, slot2, slot3)
	slot5 = {}
	slot6 = {}

	for slot10 = 1, #MonopolyCarConst.map_dic, 1 do
		for slot15 = 1, #slot4[slot10], 1 do
			if slot11[slot15] == slot1 then
				slot5 = {
					x = slot15,
					y = slot10
				}
			end

			if slot16 == slot2 then
				slot6 = {
					x = slot15,
					y = slot10
				}
			end
		end
	end

	slot7, slot8 = nil

	if slot5.y < slot6.y then
		slot7 = (slot3 and slot0) or slot1
		slot8 = slot2
	elseif slot6.y < slot5.y then
		slot7 = (slot3 and slot3) or slot4
		slot8 = slot2
	elseif slot5.x < slot6.x then
		slot7 = (slot3 and slot0) or slot1
		slot8 = -slot2
	elseif slot6.x < slot5.x then
		slot7 = (slot3 and slot3) or slot4
		slot8 = -slot2
	end

	return slot7, slot8
end

slot0.checkCharActive = function (slot0)
	if slot0.anim then
		if slot0.effectId and slot0.effectId > 0 then
			slot0:changeAnimeState(true)
			slot0:checkEffect(function ()
				slot0:changeAnimeState(false)
				slot0.changeAnimeState:checkCharActive()
			end)
		elseif slot0.step and slot0.step > 0 then
			slot0.changeAnimeState(slot0, true)
			slot0:checkStep(function ()
				slot0:changeAnimeState(false)
				slot0.changeAnimeState:checkCharActive()
			end)
		end
	end
end

slot0.firstUpdata = function (slot0, slot1)
	slot0:activityDataUpdata(slot1)
	slot0:updataUI()
	slot0:updataChar()
	slot0:checkCharActive()
end

slot0.updataActivity = function (slot0, slot1)
	slot0:activityDataUpdata(slot1)
	slot0:updataUI()
end

slot0.activityDataUpdata = function (slot0, slot1)
	slot0.activity = slot1
	slot0.totalCnt = math.ceil((pg.TimeMgr.GetInstance():GetServerTime() - slot0.activity.data1) / 86400) * slot0.activity:getDataConfig("daily_time") + slot0.activity.data1_list[1]
	slot0.useCount = slot0.activity.data1_list[2]
	slot0.leftCount = slot0.totalCnt - slot0.useCount
	slot0.turnCnt = slot0.activity.data1_list[3] - 1
	slot0.leftDropShipCnt = 8 - slot0.turnCnt
	slot0.advanceTotalCnt = #slot1:getDataConfig("reward")
	slot0.isAdvanceRp = slot0.advanceTotalCnt - slot0.activity.data2_list[2] > 0
	slot0.leftAwardCnt = slot0.activity.data2_list[1] - slot8
	slot0.advanceRpCount = math.max(0, math.min(slot0.advanceTotalCnt - slot0.activity.data2_list[2] > 0, slot0.advanceTotalCnt) - slot8)
	slot0.commonRpCount = math.max(0, slot0.activity.data2_list[1] - slot0.advanceTotalCnt) - math.max(0, slot8 - slot0.advanceTotalCnt)
	slot0.nextredPacketStep = slot1:getDataConfig("reward_time") - slot0.useCount % slot1.getDataConfig("reward_time")
	slot0.pos = slot0.activity.data2
	slot0.step = slot0.activity.data3
	slot0.effectId = slot0.activity.data4
end

slot0.checkStep = function (slot0, slot1)
	if slot0.step > 0 then
		slot0._event:emit(MonopolyCarPage.ON_MOVE, slot0.activity.id, function (slot0, slot1, slot2)
			slot0.step = slot0
			slot0.pos = slot1[#slot1]
			slot0.effectId = slot2

			seriesAsync({
				function (slot0)
					(#slot0 > 3 and stateRun) or stateJump:moveCharWithPaths(slot0, (#slot0 > 3 and stateRun) or stateJump, slot0)
				end,
				function (slot0)
					slot0:checkEffect(slot0)
				end
			}, function ()
				if slot0 then
					slot0()
				end
			end)
		end)
	elseif slot1 then
		slot1()
	end
end

slot0.updataUI = function (slot0)
	setText(slot0.labelLeftRpCount, "" .. slot0.leftAwardCnt)
	slot0.commonAnim:SetInteger("count", slot0.leftAwardCnt)
	setText(slot0.labelDropShip, "" .. slot0.turnCnt + 1)
	setText(slot0.labelLeftCountTip, i18n("monopoly_left_count"))
	setText(slot0.labelLeftCount, slot0.leftCount)
end

slot0.updataChar = function (slot0)
	slot0.char.localPosition = slot0.mapCells[slot0.pos].position

	if not isActive(slot0.char) then
		SetActive(slot0.char, true)
		slot0.char:SetAsLastSibling()
	end

	if slot0.model then
		slot0:updataCharDirect(slot0.pos, false)
	end
end

slot0.checkEffect = function (slot0, slot1)
	if slot0.effectId > 0 then
		slot2 = slot0.mapCells[slot0.pos]
		slot3 = pg.activity_event_monopoly_event[slot0.effectId].story

		seriesAsync({
			function (slot0)
				if slot0 and tonumber(slot0) ~= 0 then
					pg.NewStoryMgr.GetInstance():Play(slot0, slot0, true, true)
				else
					slot0()
				end
			end,
			function (slot0)
				slot0:triggerEfeect(slot0)
			end,
			function (slot0)
				slot0:checkCountStory(slot0)
			end
		}, slot1)

		return
	end

	if slot1 then
		slot1()
	end
end

slot0.triggerEfeect = function (slot0, slot1)
	slot0._event:emit(MonopolyCarPage.ON_TRIGGER, slot0.activity.id, function (slot0, slot1)
		if slot0 and #slot0 >= 0 then
			slot0.effectId = slot1
			slot0.pos = slot0[#slot0]

			seriesAsync({
				function (slot0)
					slot0:moveCharWithPaths(slot0.moveCharWithPaths, nil, slot0)
				end
			}, function ()
				slot0()
			end)
		end
	end)
end

slot0.moveCarWithPaths = function (slot0, slot1, slot2, slot3)
	if not slot1 or #slot1 <= 0 then
		if slot3 then
			slot3()
		end

		return
	end

	slot4 = {}
	slot5 = slot0.char.localPosition
	slot6 = {}
	slot7 = {}

	for slot11 = 1, #slot1, 1 do
		if slot0:checkPathTurn(slot1[slot11]) then
			table.insert(slot6, slot0.mapCells[slot1[slot11]].position)
			table.insert(slot7, slot1[slot11])
		elseif slot11 == #slot1 then
			table.insert(slot6, slot0.mapCells[slot1[slot11]].position)
			table.insert(slot7, slot1[slot11])
		end
	end

	slot0.speedX = 0
	slot0.speedY = 0
	slot0.baseSpeed = 6
	slot0.baseASpeed = 0.1

	if not slot0.timer then
		slot0.timer = Timer.New(function ()
			slot0:toMoveCar()
		end, 0.016666666666666666, -1)

		slot0.timer.Start(slot8)
	end

	for slot11 = 1, #slot6, 1 do
		table.insert(slot4, function (slot0)
			slot0.moveComplete = slot0
			slot0.stopOnEnd = false
			slot0.targetPosition = slot1[]
			slot0.targetPosIndex = slot1[]
			slot0.moveX = slot0.targetPosition.x - slot0.char.localPosition.x
			slot0.moveY = slot0.targetPosition.y - slot0.char.localPosition.y
			slot0.baseSpeedX = slot0.baseSpeed * slot0.moveX / math.abs(slot0.moveX)
			slot0.baseASpeedX = slot0.baseASpeed * slot0.moveX / math.abs(slot0.moveX)
			slot0.baseSpeedY = math.abs(slot0.baseSpeedX) / (math.abs(slot0.moveX) / slot0.moveY)
			slot0.baseASpeedY = math.abs(slot0.baseASpeedX) / (math.abs(slot0.moveX) / slot0.moveY)

			if math.abs(slot0.baseASpeedX) / (math.abs(slot0.moveX) / slot0.moveY) == 1 then
				slot0.speedX = 0
				slot0.speedY = 0
			else
				slot0.speedX = slot0.baseSpeedX
				slot0.speedY = slot0.baseSpeedY
			end
		end)
	end

	table.insert(slot4, function (slot0)
		slot0.moveComplete = nil

		slot0:updataCharDirect(slot1[#slot1], false)
		slot0()
	end)
	table.insert(slot4, function (slot0)
		LeanTween.value(go(slot0._tf), 1, 0, 0.1):setOnComplete(System.Action(function ()
			slot0()
		end))
	end)
	seriesAsync(slot4, slot3)
end

slot0.toMoveCar = function (slot0)
	if not slot0.targetPosition then
		return
	end

	slot2 = math.abs(slot0.targetPosition.y - slot0.char.localPosition.y)

	if math.abs(slot0.targetPosition.x - slot0.char.localPosition.x) <= 6.5 and slot2 <= 6.5 then
		slot0.targetPosition = nil

		if slot0.moveComplete then
			slot0:updataCharDirect(slot0.targetPosIndex, true)
			slot0.moveComplete()
		end
	end

	slot0.speedX = (math.abs(slot0.baseSpeedX) < math.abs(slot0.speedX + slot0.baseASpeedX) and slot0.baseSpeedX) or slot0.speedX + slot0.baseASpeedX
	slot0.speedY = (math.abs(slot0.baseSpeedY) < math.abs(slot0.speedY + slot0.baseASpeedY) and slot0.baseSpeedY) or slot0.speedY + slot0.baseASpeedY
	slot0.char.localPosition = Vector3(slot0.char.localPosition.x + slot0.speedX, slot0.char.localPosition.y + slot0.speedY, 0)
end

slot0.checkPathTurn = function (slot0, slot1)
	if slot0.mapCells[(slot1 + 1 > #slot0.mapCells and 1) or slot1 + 1].col == slot0.mapCells[(slot1 - 1 < 1 and #slot0.mapCells) or slot1 - 1].col or slot0.mapCells[slot2].row == slot0.mapCells[slot3].row then
		return false
	end

	return true
end

slot0.moveCharWithPaths = function (slot0, slot1, slot2, slot3)
	slot0:moveCarWithPaths(slot1, slot2, slot3)

	return

	if not slot1 or #slot1 <= 0 then
		if slot3 then
			slot3()
		end

		return
	end

	slot4 = {}
	slot5 = (slot1[1] - 1 < 1 and #slot0.mapCells) or slot1[1] - 1

	for slot9 = 1, #slot1, 1 do
		slot10 = slot0.mapCells[slot1[slot9]]

		table.insert(slot4, function (slot0)
			slot0:updataCharDirect(slot0.updataCharDirect, true)

			slot1 = slot0[slot3]

			LeanTween.moveLocal(go(slot0.char), slot0.char.tf.localPosition, slot1):setEase(LeanTweenType.linear):setOnComplete(System.Action(function ()
				slot0()
			end))
		end)

		if slot9 == #slot1 then
			table.insert(slot4, function (slot0)
				slot0:updataCharDirect(slot1[slot2], false)
				slot0()
			end)
		end
	end

	seriesAsync(slot4, slot3)
end

slot0.dispose = function (slot0)
	PoolMgr.GetInstance():ReturnSpineChar(slot0, slot0.showModel)
	PoolMgr.GetInstance():ReturnSpineChar(show, slot0.showSkinId)
end

return slot0

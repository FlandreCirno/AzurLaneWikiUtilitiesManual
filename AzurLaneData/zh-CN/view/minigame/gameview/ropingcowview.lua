slot0 = class("IdolMasterView", import("..BaseMiniGameView"))
slot1 = "backyard"
slot2 = "event:/ui/ddldaoshu2"
slot3 = "event:/ui/sou"
slot4 = "event:/ui/xueqiu"
slot5 = 60
slot6 = 100
slot7 = 10
slot8 = {
	{
		20,
		3
	},
	{
		40,
		4
	},
	{
		60,
		5
	},
	{
		10000,
		5
	}
}
slot9 = {
	{
		10700031,
		10700030
	},
	{
		10700041,
		10700040
	},
	{
		10700051,
		10700050
	},
	{
		10700061,
		10700060
	},
	{
		10700071,
		10700070
	}
}
slot10 = {
	{
		10700011,
		10700010
	},
	{
		10700021,
		10700020
	}
}
slot11 = "EVENT_SEND_GIFT"
slot12 = "EVENT_FANS_ACTION"
slot13 = {
	1,
	2,
	3,
	4,
	5,
	6
}
slot14 = {
	1,
	2
}
slot15 = {
	3,
	4,
	5,
	6
}
slot16 = 3
slot17 = "dafuweng_event"
slot18 = "stand2"
slot19 = "normal"
slot20 = "work"
slot21 = "wrong"
slot22 = "end1"
slot23 = "end2"
slot24 = "gift"
slot25 = "normal"
slot26 = "walk"
slot27 = 3
slot28 = "type_fans_fail"
slot29 = "type_fans_success"
slot30 = 4
slot31 = {
	Vector3(160, 160),
	Vector3(160, -30),
	Vector3(160, -210),
	Vector3(160, -400)
}
slot32 = 350

function slot33(slot0, slot1, slot2)
	({
		Ctor = function (slot0)
			slot0._giftTf = slot0
			slot0._event = slot0
			slot0._workerTf = slot2

			PoolMgr.GetInstance():GetSpineChar(slot1, true, function (slot0)
				slot0.transform.localScale = Vector3.one
				slot0.transform.localPosition = Vector3.zero

				slot0.transform:SetParent(slot0._workerTf, false)

				slot0.wokerSpine = {
					model = slot0.model,
					anim = slot0:GetComponent(typeof(SpineAnimUI)),
					name = slot1
				}

				slot0:changeWorkerAction(slot0.changeWorkerAction, 0, nil)
			end)

			slot0.selectedGifts = {}
			slot0.gifts = {}
			slot0.delegateGifts = {}

			for slot5 = 1, #slot4, 1 do
				slot6 = slot5

				table.insert(slot0.gifts, {
					tf = findTF(slot0._giftTf, slot4[slot5]),
					index = slot5
				})
				GetOrAddComponent(slot7, "EventTriggerListener").AddPointDownFunc(slot8, function (slot0, slot1)
					slot0:selectGift(slot1)
				end)
				table.insert(slot0.delegateGifts, slot8)
			end

			slot0:updateSelected()
		end,
		changeWorkerAction = function (slot0, slot1, slot2, slot3)
			slot0.wokerSpine.anim:SetActionCallBack(nil)
			slot0.wokerSpine.anim:SetAction(slot1, 0)
			slot0.wokerSpine.anim:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					if slot0 == 1 then
						slot1.wokerSpine.anim:SetActionCallBack(nil)
						slot1.wokerSpine.anim.SetActionCallBack.wokerSpine.anim:SetAction(slot1.wokerSpine.anim.SetActionCallBack.wokerSpine.anim, 0)
					end

					if slot3 then
						slot3()
					end
				end
			end)

			if slot2 ~= 1 and slot3 then
				slot3()
			end
		end,
		selectGift = function (slot0, slot1)
			if table.contains(slot0, slot1) then
				for slot5 = #slot0.selectedGifts, 1, -1 do
					if table.contains(slot0, slot0.selectedGifts[slot5]) and slot6 ~= slot1 then
						table.remove(slot0.selectedGifts, slot5)
					end
				end
			elseif #slot0.selectedGifts == 2 and not table.contains(slot0.selectedGifts, slot1) then
				slot2 = false

				for slot6 = 1, #slot0.selectedGifts, 1 do
					if table.contains(slot0, slot0.selectedGifts[slot6]) then
						slot2 = true

						break
					end
				end

				if not slot2 then
					table.remove(slot0.selectedGifts, 1)
				end
			end

			slot2 = 0

			for slot6 = 1, #slot0.selectedGifts, 1 do
				if slot0.selectedGifts[slot6] == slot1 then
					slot2 = slot6
				end
			end

			if slot2 == 0 then
				table.insert(slot0.selectedGifts, slot1)
				slot0:moveJiujiu(slot1)
				slot0:changeWorkerAction(slot1, 1)
			else
				table.remove(slot0.selectedGifts, slot2)
			end

			if slot2 <= #slot0.selectedGifts then
				slot0._event:emit(slot0._event.emit, Clone(slot0.selectedGifts), function (slot0)
					if not slot0 then
						slot0:changeWorkerAction(slot0.changeWorkerAction, 1)
					end
				end)

				slot0.selectedGifts = {}

				slot0.moveJiujiu(slot0, -1)
			end

			slot0:updateSelected()
		end,
		start = function (slot0)
			slot0.selectedGifts = {}

			slot0:updateSelected()
		end,
		updateSelected = function (slot0)
			for slot4 = 1, #slot0.gifts, 1 do
				if table.contains(slot0.selectedGifts, slot0.gifts[slot4].index) then
					setActive(findTF(slot0.gifts[slot4].tf, "selected"), true)
				else
					setActive(findTF(slot0.gifts[slot4].tf, "selected"), false)
				end
			end
		end,
		moveJiujiu = function (slot0, slot1)
			if slot1 == -1 then
				slot0._workerTf.anchoredPosition = Vector3.New(-290, 30, 0)
				slot0._workerTf.localScale = Vector3.New(-1, 1, 1)
			else
				slot3 = slot0._workerTf.parent:InverseTransformPoint(slot0.gifts[slot1].tf.position)
				slot3.x = slot3.x + 150
				slot3.y = slot3.y - 50
				slot0._workerTf.anchoredPosition = slot3
				slot0._workerTf.localScale = Vector3.New(1, 1, 1)
			end
		end,
		destroy = function (slot0)
			if slot0.delegateGifts and #slot0.delegateGifts > 0 then
				for slot4 = 1, #slot0.delegateGifts, 1 do
					ClearEventTrigger(slot0.delegateGifts[slot4])
				end

				slot0.delegateGifts = {}
			end

			PoolMgr.GetInstance():ReturnSpineChar(slot0.wokerSpine.name, slot0.wokerSpine.model)
		end
	})["Ctor"](slot3)

	return 
end

function slot34(slot0, slot1, slot2, slot3)
	({
		Ctor = function (slot0)
			slot0._groupTf = slot0
			slot0._groupIndex = slot0
			slot0._groupTf.anchoredPosition = slot2[slot0._groupTf]
			slot0._event = slot3
			slot0.modelData = {}

			SetActive(slot0._groupTf, true)
			slot0:createIdol(slot4[1], slot4[2])

			slot0.fans = {}
			slot0.wantedData = {}
		end,
		createIdol = function (slot0, slot1, slot2)
			PoolMgr.GetInstance():GetSpineChar(Ship.New({
				configId = slot1,
				skin_id = slot2
			}).getPrefab(slot3), true, function (slot0)
				slot0.transform.localScale = Vector3.one
				slot0.transform.localPosition = Vector3.zero

				slot0.transform:SetParent(findTF(slot0._groupTf, "idolPos"), false)

				slot0.modelData = {
					model = slot0.model,
					id = slot1,
					skinId = slot0,
					anim = slot0:GetComponent(typeof(SpineAnimUI))
				}

				slot0:changeCharAction(slot0, 0, nil)
			end)
		end,
		changeCharAction = function (slot0, slot1, slot2, slot3)
			if slot0.modelData.actionName == slot1 then
				return
			end

			slot0.modelData.actionName = slot1

			slot0.modelData.anim:SetActionCallBack(nil)
			slot0.modelData.anim:SetAction(slot1, 0)
			slot0.modelData.anim:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					if slot0 == 1 then
						slot1.modelData.anim:SetActionCallBack(nil)
						slot1.modelData.anim.SetActionCallBack.modelData.anim:SetAction(slot1.modelData.anim.SetActionCallBack.modelData.anim, 0)
					end

					if slot3 then
						slot3()
					end
				end
			end)

			if slot2 ~= 1 and slot3 then
				slot3()
			end
		end,
		createFans = function (slot0, slot1)
			SetActive(slot1, true)
			SetParent(slot1, findTF(slot0._groupTf, "fansPos"))

			if #slot0.fans > 0 then
				slot0.fans[#slot0.fans].tf.anchoredPosition.x = slot0.fans[#slot0.fans].tf.anchoredPosition.x + slot0 + math.random() * 200 + 150
				slot1.anchoredPosition = Vector3.New(slot0.fans[#slot0.fans].tf.anchoredPosition.x, slot0.fans[#slot0.fans].tf.anchoredPosition.y, slot0.fans[#slot0.fans].tf.anchoredPosition.z)
			else
				slot1.anchoredPosition = Vector3.New((#slot0.fans + 1) * slot0 + 200, 0, 0)
			end

			table.insert(slot0.fans, {
				tf = slot1,
				speed = math.random() + 2.5
			})

			slot2 = slot0.fans[#slot0.fans]

			PoolMgr.GetInstance():GetSpineChar("jiu-fan" .. math.random(1, 4), true, function (slot0)
				slot0.transform.localScale = Vector3.one
				slot0.transform.localPosition = Vector3.zero

				slot0.transform:SetParent(findTF(slot0.tf, "spinePos"), false)

				slot0.modelData = {
					model = slot0,
					anim = slot0:GetComponent(typeof(SpineAnimUI)),
					modelName = slot0.GetComponent(typeof(SpineAnimUI))
				}
			end)
		end,
		changeFansAction = function (slot0, slot1, slot2, slot3, slot4)
			if not slot1.modelData or slot1.modelData.actionName == slot2 then
				return
			end

			slot1.modelData.actionName = slot2

			slot1.modelData.anim:SetActionCallBack(nil)
			slot1.modelData.anim:SetAction(slot2, 0)
			slot1.modelData.anim:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					if slot0 == 1 then
						slot1.modelData.anim:SetActionCallBack(nil)
						slot1.modelData.anim.SetActionCallBack.modelData.anim:SetAction(slot1.modelData.anim.SetActionCallBack.modelData.anim, 0)
					end

					if slot3 then
						slot3()
					end
				end
			end)

			if slot3 ~= 1 and slot4 then
				slot4()
			end
		end,
		getWantedGifts = function (slot0)
			if #slot0.fans > 0 and slot0.fans[1].gifts and not slot0.fans[1].leave then
				return slot0.fans[1].gifts
			end

			return nil
		end,
		clearFans = function (slot0)
			for slot4 = 1, #slot0.fans, 1 do
				PoolMgr.GetInstance():ReturnSpineChar(slot0.fans[slot4].modelData.modelName, slot0.fans[slot4].modelData.model)
				Destroy(slot0.fans[slot4].tf)
			end

			slot0.fans = {}
		end,
		start = function (slot0)
			return
		end,
		step = function (slot0, slot1)
			slot0.stepTime = slot1

			for slot5 = #slot0.fans, 1, -1 do
				slot7 = slot0.fans[slot5].tf

				if slot0.fans[slot5].tf.anchoredPosition.x > (slot5 - 1) * slot0 then
					slot8.x = slot8.x - slot6.speed
					slot6.tf.anchoredPosition = slot8

					slot0:changeFansAction(slot6, slot1, 0, nil)
				elseif slot5 == 1 and not slot6.leave then
					if slot6.gifts == nil then
						slot6.gifts = slot0:createWantedGifts()
						slot6.time = slot1 + slot2

						setImageSprite(findTF(slot6.tf, "score/pack"), slot9)
						slot0:changeFansAction(slot6, slot3, 0, nil)
					end
				elseif not slot6.leave then
					slot0:changeFansAction(slot6, slot4, 0, nil)
				end
			end

			if #slot0.fans > 0 then
				if slot0.fans[1].time and slot2.time < slot1 and not slot2.leave then
					slot2.leave = true

					slot0:fanLeave(slot2, , function ()
						table.remove(slot0.fans, 1)
					end)
				else
					slot0.showFansWanted(slot0, slot2)
				end

				slot2.tf:SetSiblingIndex(#slot0.fans - 1)
			end
		end,
		showFansWanted = function (slot0, slot1)
			if slot1.leave then
				return
			end

			if not slot1.time then
				return
			end

			slot4 = slot1.gifts

			setActive(findTF(slot1.tf, "wanted"), true)
			setActive(findTF(slot1.tf, "wanted/bg1"), not (((math.ceil(slot2 - slot0.stepTime) >= 0 or 0) and slot2 - slot0.stepTime) <= 5))
			setActive(findTF(slot1.tf, "wanted/bgTime1"), not (((math.ceil(slot2 - slot0.stepTime) >= 0 or 0) and slot2 - slot0.stepTime) <= 5))
			setActive(findTF(slot1.tf, "wanted/time1"), not (((math.ceil(slot2 - slot0.stepTime) >= 0 or 0) and slot2 - slot0.stepTime) <= 5))
			setActive(findTF(slot1.tf, "wanted/bg2"), ((math.ceil(slot2 - slot0.stepTime) >= 0 or 0) and slot2 - slot0.stepTime) <= 5)
			setActive(findTF(slot1.tf, "wanted/bgTime2"), ((math.ceil(slot2 - slot0.stepTime) >= 0 or 0) and slot2 - slot0.stepTime) <= 5)
			setActive(findTF(slot1.tf, "wanted/time1"), ((math.ceil(slot2 - slot0.stepTime) >= 0 or 0) and slot2 - slot0.stepTime) <= 5)

			if slot3 < 0 then
				slot3 = 0
			end

			setText(findTF(slot1.tf, "wanted/time1"), math.abs(math.ceil(slot3)) .. "S")
			setText(findTF(slot1.tf, "wanted/time2"), math.abs(math.ceil(slot3)) .. "S")

			for slot9 = 1, #slot4, 1 do
				setImageSprite(findTF(slot1.tf, "wanted/item" .. slot9), LoadSprite("ui/minigameui/idolmasterui_atlas", "wantItem" .. slot4[slot9]))
			end
		end,
		checkGifts = function (slot0, slot1)
			if slot0:getWantedGifts() then
				for slot6 = 1, #slot1, 1 do
					if not table.contains(slot2, slot1[slot6]) then
						return false
					end
				end

				slot0.fans[1].leave = true

				slot0:fanLeave(slot0.fans[1], slot0, function ()
					table.remove(slot0.fans, 1)
				end)

				return true
			end

			return false
		end,
		createWantedGifts = function (slot0)
			table.insert(slot2, slot1[math.random(1, #slot1)])

			for slot6 = 1, 2, 1 do
				table.insert(slot2, table.remove(slot1, math.random(1, #slot1)))
			end

			return slot2
		end,
		fanLeave = function (slot0, slot1, slot2, slot3)
			setActive(findTF(slot1.tf, "wanted"), false)

			slot4 = nil

			if slot0 == slot2 then
				slot4 = slot1
			elseif slot2 then
				setText(findTF(slot1.tf, "score"), "+" .. slot4)
				setActive(findTF(slot1.tf, "score"), true)
			end

			slot0:changeFansAction(slot1, slot4, 1, function ()
				PoolMgr.GetInstance():ReturnSpineChar(slot0.modelData.modelName, slot0.modelData.model)
				slot1._event:emit(slot0.modelData.modelName, slot0.modelData.model)
				Destroy(slot0.tf)
				slot4()
			end)
		end,
		reset = function (slot0)
			slot0:clearFans()

			slot0.wantedData = {}
		end,
		destroy = function (slot0)
			if slot0.modelData then
				PoolMgr.GetInstance():ReturnSpineChar(slot0.modelData.id, slot0.modelData.model)
			end
		end
	})["Ctor"](slot4)

	return 
end

function slot35(slot0, slot1, slot2, slot3, slot4)
	({
		Ctor = function (slot0)
			slot0._containerTf = slot0
			slot0._tplGroup = slot0
			slot0._tplIdol = slot2
			slot0._tplFans = slot3
			slot0._event = slot4
			slot0.groups = {}
			slot1 = slot0:getRandomIdols()

			for slot5 = 1, slot5, 1 do
				slot6 = tf(Instantiate(slot0._tplGroup))

				SetParent(slot6, slot0._containerTf)
				table.insert(slot0.groups, slot6(slot1[slot5], slot6, slot5, slot0._event))
			end
		end,
		receiveGift = function (slot0, slot1, slot2)
			slot3 = false

			for slot7 = 1, #slot0.groups, 1 do
				if slot0.groups[slot7]:checkGifts(slot1) then
					slot3 = true

					break
				end
			end

			if slot2 then
				slot2(slot3)
			end
		end,
		getRandomIdols = function (slot0)
			slot2 = Clone(slot0)

			for slot6 = 1, {}, 1 do
				slot7 = false

				if slot6 == slot1 then
					slot7 = true

					for slot11, slot12 in ipairs(slot2) do
						if table.contains(slot1, slot12) then
							slot7 = false
						end
					end
				end

				if slot7 then
					table.insert(slot1, slot2[math.random(1, #slot2)])
				else
					table.insert(slot1, table.remove(slot2, math.random(1, #slot2)))
				end
			end

			return slot1
		end,
		getApearTime = function (slot0)
			if slot0.runTime and slot0.runTime > 0 then
				for slot4 = 1, #slot0, 1 do
					if slot0.runTime < slot0[slot4][1] then
						return slot0[slot4][2]
					end
				end
			end

			return slot0[#slot0][2]
		end,
		start = function (slot0)
			slot0:reset()

			slot0.createFansTime = nil
			slot0.lastTime = slot0

			for slot4 = 1, 3, 1 do
				slot0.groups[math.random(1, #slot0.groups)]:createFans(tf(instantiate(slot0._tplFans)))
			end

			for slot4 = 1, #slot0.groups, 1 do
				slot0.groups[slot4]:start()
			end
		end,
		step = function (slot0, slot1)
			slot0.lastTime = slot0.lastTime - Time.deltaTime
			slot2 = slot0:getApearTime()

			if not slot0.createFansTime then
				slot0.createFansTime = slot1 + slot2 + math.random() * 1
			elseif slot0.createFansTime < slot1 then
				slot0.groups[math.random(1, #slot0.groups)]:createFans(tf(instantiate(slot0._tplFans)))

				slot0.createFansTime = slot1 + slot2 + math.random() * 1
			end

			for slot6 = 1, #slot0.groups, 1 do
				slot0.groups[slot6]:step(slot1)
			end
		end,
		reset = function (slot0)
			for slot4 = 1, #slot0.groups, 1 do
				slot0.groups[slot4]:reset()
			end
		end,
		destroy = function (slot0)
			for slot4 = 1, #slot0.groups, 1 do
				slot0.groups[slot4]:destroy()
			end
		end
	})["Ctor"](slot5)

	return 
end

slot0.getUIName = function (slot0)
	return "IdolMasterGameUI"
end

slot0.getBGM = function (slot0)
	return slot0
end

slot0.didEnter = function (slot0)
	slot0:initEvent()
	slot0:initData()
	slot0:initUI()
	slot0:initGameUI()
	slot0:updateMenuUI()
	slot0:openMenuUI()
end

slot0.initEvent = function (slot0)
	slot0:bind(slot0, function (slot0, slot1, slot2)
		if slot0.idolGroupUI then
			slot0.idolGroupUI:receiveGift(slot1, slot2)
		end
	end)
	slot0.bind(slot0, slot0.bind, function (slot0, slot1, slot2)
		if slot0.gameStartFlag then
			if slot1 == slot1 then
				slot0:loseHeart()
			elseif slot1 == slot2 then
				slot0:addScore(100)
			end
		end
	end)
end

slot0.initData = function (slot0)
	slot0.timer = Timer.New(function ()
		slot0:onTimer()
	end, 1 / (Application.targetFrameRate or 60), -1)
end

slot0.initUI = function (slot0)
	slot0.sceneTf = findTF(slot0._tf, "scene")
	slot0.clickMask = findTF(slot0._tf, "clickMask")
	slot0.countUI = findTF(slot0._tf, "pop/CountUI")
	slot0.countAnimator = GetComponent(findTF(slot0.countUI, "count"), typeof(Animator))
	slot0.countDft = GetComponent(findTF(slot0.countUI, "count"), typeof(DftAniEvent))

	slot0.countDft:SetTriggerEvent(function ()
		return
	end)
	slot0.countDft.SetEndEvent(slot1, function ()
		setActive(slot0.countUI, false)
		setActive:gameStart()
	end)

	slot0.leaveUI = findTF(slot0._tf, "pop/LeaveUI")

	onButton(slot0, findTF(slot0.leaveUI, "ad/btnOk"), function ()
		slot0:resumeGame()
		slot0.resumeGame:onGameOver()
	end, SFX_CANCEL)
	onButton(slot0, findTF(slot0.leaveUI, "ad/btnCancel"), function ()
		slot0:resumeGame()
	end, SFX_CANCEL)

	slot0.pauseUI = findTF(slot0._tf, "pop/pauseUI")

	onButton(slot0, findTF(slot0.pauseUI, "ad/btnOk"), function ()
		setActive(slot0.pauseUI, false)
		setActive:resumeGame()
	end, SFX_CANCEL)

	slot0.settlementUI = findTF(slot0._tf, "pop/SettleMentUI")

	onButton(slot0, findTF(slot0.settlementUI, "ad/btnOver"), function ()
		setActive(slot0.settlementUI, false)
		setActive:openMenuUI()
	end, SFX_CANCEL)

	slot0.menuUI = findTF(slot0._tf, "pop/menuUI")
	slot0.battleScrollRect = GetComponent(findTF(slot0.menuUI, "battList"), typeof(ScrollRect))
	slot0.totalTimes = slot0.getGameTotalTime(slot0)

	scrollTo(slot0.battleScrollRect, 0, 1 - ((slot0:getGameUsedTimes() - 4 >= 0 or 0) and slot0:getGameUsedTimes() - 4) / (slot0.totalTimes - 4))
	onButton(slot0, findTF(slot0.menuUI, "rightPanelBg/arrowUp"), function ()
		if slot0.battleScrollRect.normalizedPosition.y + 1 / (slot0.totalTimes - 4) > 1 then
			slot0 = 1
		end

		scrollTo(slot0.battleScrollRect, 0, slot0)
	end, SFX_CANCEL)
	onButton(slot0, findTF(slot0.menuUI, "rightPanelBg/arrowDown"), function ()
		if slot0.battleScrollRect.normalizedPosition.y - 1 / (slot0.totalTimes - 4) < 0 then
			slot0 = 0
		end

		scrollTo(slot0.battleScrollRect, 0, slot0)
	end, SFX_CANCEL)
	onButton(slot0, findTF(slot0.menuUI, "btnBack"), function ()
		slot0:closeView()
	end, SFX_CANCEL)
	onButton(slot0, findTF(slot0.menuUI, "btnRule"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.cowboy_tips.tip
		})
	end, SFX_CANCEL)
	onButton(slot0, findTF(slot0.menuUI, "btnStart"), function ()
		setActive(slot0.menuUI, false)
		setActive:readyStart()
	end, SFX_CANCEL)

	slot2 = findTF(slot0.menuUI, "tplBattleItem")
	slot0.battleItems = {}

	for slot6 = 1, slot0.totalTimes, 1 do
		slot7 = tf(instantiate(slot2))
		slot7.name = "battleItem_" .. slot6

		setParent(slot7, findTF(slot0.menuUI, "battList/Viewport/Content"))
		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "tx_" .. slot8, function (slot0)
			setImageSprite(findTF(slot0, "state_open/icon"), slot0, true)
			setImageSprite(findTF(slot0, "state_clear/icon"), slot0, true)
			setImageSprite(findTF(slot0, "state_current/icon"), slot0, true)
		end)
		GetSpriteFromAtlasAsync("ui/minigameui/idolmasterui_atlas", "battleDesc" .. slot8, function (slot0)
			setImageSprite(findTF(slot0, "state_open/buttomDesc"), slot0, true)
			setImageSprite(findTF(slot0, "state_clear/buttomDesc"), slot0, true)
			setImageSprite(findTF(slot0, "state_current/buttomDesc"), slot0, true)
			setImageSprite(findTF(slot0, "state_closed/buttomDesc"), slot0, true)
		end)
		setActive(slot7, true)
		table.insert(slot0.battleItems, slot7)
	end

	if not slot0.handle then
		slot0.handle = UpdateBeat:CreateListener(slot0.Update, slot0)
	end

	UpdateBeat:AddListener(slot0.handle)
end

slot0.initGameUI = function (slot0)
	slot0.gameUI = findTF(slot0._tf, "ui/gameUI")
	slot0.textScore = findTF(slot0.gameUI, "top/score")

	onButton(slot0, findTF(slot0.gameUI, "topRight/btnStop"), function ()
		slot0:stopGame()
		setActive(slot0.pauseUI, true)
	end)
	onButton(slot0, findTF(slot0.gameUI, "btnLeave"), function ()
		slot0:stopGame()
		setActive(slot0.leaveUI, true)
	end)

	slot0.gameTimeM = findTF(slot0.gameUI, "topRight/time/m")
	slot0.gameTimeS = findTF(slot0.gameUI, "topRight/time/s")
	slot0.heartTfs = {}

	for slot4 = 1, slot0, 1 do
		table.insert(slot0.heartTfs, findTF(slot0.gameUI, "top/heart" .. slot4 .. "/full"))
	end

	slot0.scoreTf = findTF(slot0.gameUI, "top/score")
	slot0.giftUI = findTF(slot0.gameUI, "top/score")(findTF(slot0._tf, "scene/gift"), findTF(slot0._tf, "scene/jiujiuWorker"), slot0)
	slot0.idolGroupUI = slot2(findTF(slot0._tf, "scene/IdolContainer"), findTF(slot0._tf, "scene/group"), findTF(slot0._tf, "scene/Idol"), findTF(slot0._tf, "scene/fans"), slot0)
end

slot0.Update = function (slot0)
	slot0:AddDebugInput()
end

slot0.AddDebugInput = function (slot0)
	if slot0.gameStop or slot0.settlementFlag then
		return
	end

	if Application.isEditor then
	end
end

slot0.updateMenuUI = function (slot0)
	slot1 = slot0:getGameUsedTimes()
	slot2 = slot0:getGameTimes()

	for slot6 = 1, #slot0.battleItems, 1 do
		setActive(findTF(slot0.battleItems[slot6], "state_open"), false)
		setActive(findTF(slot0.battleItems[slot6], "state_closed"), false)
		setActive(findTF(slot0.battleItems[slot6], "state_clear"), false)
		setActive(findTF(slot0.battleItems[slot6], "state_current"), false)

		if slot6 <= slot1 then
			setActive(findTF(slot0.battleItems[slot6], "state_clear"), true)
		elseif slot6 == slot1 + 1 and slot2 >= 1 then
			setActive(findTF(slot0.battleItems[slot6], "state_current"), true)
		elseif slot1 < slot6 and slot6 <= slot1 + slot2 then
			setActive(findTF(slot0.battleItems[slot6], "state_open"), true)
		else
			setActive(findTF(slot0.battleItems[slot6], "state_closed"), true)
		end
	end

	slot0.totalTimes = slot0:getGameTotalTime()

	if 1 - ((slot0:getGameUsedTimes() - 3 >= 0 or 0) and slot0:getGameUsedTimes() - 3) / (slot0.totalTimes - 4) > 1 then
		slot4 = 1
	end

	scrollTo(slot0.battleScrollRect, 0, slot4)
	setActive(findTF(slot0.menuUI, "btnStart/tip"), slot2 > 0)
	slot0:CheckGet()
end

slot0.CheckGet = function (slot0)
	setActive(findTF(slot0.menuUI, "got"), false)

	if slot0:getUltimate() and slot0:getUltimate() ~= 0 then
		setActive(findTF(slot0.menuUI, "got"), true)
	end

	if slot0:getUltimate() == 0 then
		if slot0:getGameUsedTimes() < slot0:getGameTotalTime() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = slot0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
		setActive(findTF(slot0.menuUI, "got"), true)
	end
end

slot0.openMenuUI = function (slot0)
	setActive(findTF(slot0._tf, "scene_front"), false)
	setActive(findTF(slot0._tf, "scene_background"), false)
	setActive(findTF(slot0._tf, "scene"), false)
	setActive(slot0.gameUI, false)
	setActive(slot0.menuUI, true)
	slot0:updateMenuUI()
end

slot0.clearUI = function (slot0)
	setActive(slot0.sceneTf, false)
	setActive(slot0.settlementUI, false)
	setActive(slot0.countUI, false)
	setActive(slot0.menuUI, false)
	setActive(slot0.gameUI, false)
end

slot0.readyStart = function (slot0)
	setActive(slot0.countUI, true)
	slot0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot0)
end

slot0.gameStart = function (slot0)
	setActive(findTF(slot0._tf, "scene_front"), true)
	setActive(findTF(slot0._tf, "scene_background"), true)
	setActive(findTF(slot0._tf, "scene"), true)
	setActive(slot0.gameUI, true)

	slot0.gameStartFlag = true
	slot0.scoreNum = 0
	slot0.playerPosIndex = 2
	slot0.gameStepTime = 0
	slot0.heart = slot0
	slot0.gameTime = slot0

	slot0.idolGroupUI:start()
	slot0.giftUI:start()
	slot0:updateGameUI()
	slot0:timerStart()
end

slot0.getGameTimes = function (slot0)
	return slot0:GetMGHubData().count
end

slot0.getGameUsedTimes = function (slot0)
	return slot0:GetMGHubData().usedtime
end

slot0.getUltimate = function (slot0)
	return slot0:GetMGHubData().ultimate
end

slot0.getGameTotalTime = function (slot0)
	return slot0:GetMGHubData():getConfig("reward_need")
end

slot0.changeSpeed = function (slot0, slot1)
	return
end

slot0.onTimer = function (slot0)
	slot0:gameStep()
end

slot0.gameStep = function (slot0)
	slot0.gameTime = slot0.gameTime - Time.deltaTime

	if slot0.gameTime < 0 then
		slot0.gameTime = 0
	end

	slot0.gameStepTime = slot0.gameStepTime + Time.deltaTime

	if slot0.idolGroupUI then
		slot0.idolGroupUI:step(slot0.gameStepTime)
	end

	slot0:updateGameUI()

	if slot0.gameTime <= 0 then
		slot0:onGameOver()

		return
	end
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

slot0.updateGameUI = function (slot0)
	setText(slot0.textScore, slot0.scoreNum)

	if math.floor(math.ceil(slot0.gameTime) / 60) < 10 then
		slot1 = "0" .. slot1
	end

	if math.floor(math.ceil(slot0.gameTime) % 60) < 10 then
		slot2 = "0" .. slot2
	end

	for slot6 = 1, #slot0.heartTfs, 1 do
		if slot6 <= slot0.heart then
			setActive(slot0.heartTfs[slot6], true)
		else
			setActive(slot0.heartTfs[slot6], false)
		end
	end

	setText(slot0.scoreTf, slot0.scoreNum)
	setText(slot0.gameTimeM, slot1)
	setText(slot0.gameTimeS, slot2)
end

slot0.loseHeart = function (slot0)
	if slot0.heart <= 0 then
		return
	end

	slot0.heart = slot0.heart - 1

	slot0:updateGameUI()

	if slot0.heart <= 0 then
		slot0.heart = 0

		slot0:onGameOver()
	end
end

slot0.addScore = function (slot0, slot1)
	slot0.scoreNum = slot0.scoreNum + slot1

	if slot0.scoreNum < 0 then
		slot0.scoreNum = 0
	end
end

slot0.onGameOver = function (slot0)
	if slot0.settlementFlag then
		return
	end

	slot0:timerStop()

	slot0.settlementFlag = true

	setActive(slot0.clickMask, true)
	LeanTween.delayedCall(go(slot0._tf), 2, System.Action(function ()
		slot0.settlementFlag = false
		slot0.gameStartFlag = false

		setActive(slot0.clickMask, false)
		setActive:showSettlement()
	end))
end

slot0.showSettlement = function (slot0)
	setActive(slot0.settlementUI, true)
	GetComponent(findTF(slot0.settlementUI, "ad"), typeof(Animator)).Play(slot1, "settlement", -1, 0)
	setActive(findTF(slot0.settlementUI, "ad/new"), ((slot0:GetMGData():GetRuntimeData("elements") and #slot2 > 0 and slot2[1]) or 0) < slot0.scoreNum)

	if slot4 <= slot3 then
		slot0:StoreDataToServer({
			slot3
		})
	end

	setText(slot5, slot4)
	setText(slot6, slot3)

	if slot0:getGameTimes() and slot0:getGameTimes() > 0 then
		slot0.sendSuccessFlag = true

		slot0:SendSuccess(0)
	end
end

slot0.resumeGame = function (slot0)
	slot0.gameStop = false

	setActive(slot0.leaveUI, false)
	slot0:changeSpeed(1)
	slot0:timerStart()
end

slot0.stopGame = function (slot0)
	slot0.gameStop = true

	slot0:timerStop()
	slot0:changeSpeed(0)
end

slot0.onBackPressed = function (slot0)
	if not slot0.gameStartFlag then
		slot0:emit(slot0.ON_BACK_PRESSED)
	else
		if slot0.settlementFlag then
			return
		end

		if isActive(slot0.pauseUI) then
			setActive(slot0.pauseUI, false)
		end

		slot0:stopGame()
		setActive(slot0.leaveUI, true)
	end
end

slot0.willExit = function (slot0)
	if slot0.handle then
		UpdateBeat:RemoveListener(slot0.handle)
	end

	if slot0._tf and LeanTween.isTweening(go(slot0._tf)) then
		LeanTween.cancel(go(slot0._tf))
	end

	if slot0.timer and slot0.timer.running then
		slot0.timer:Stop()
	end

	Time.timeScale = 1
	slot0.timer = nil
end

return slot0

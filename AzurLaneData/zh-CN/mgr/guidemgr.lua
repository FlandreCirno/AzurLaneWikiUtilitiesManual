pg = pg or {}
pg.GuideMgr = singletonClass("GuideMgr")
pg.GuideMgr.ENABLE_GUIDE = true
pg.GuideMgr.MANAGER_STATE = {
	IDLE = 1,
	BUSY = 2,
	LOADING = 0,
	BREAK = 4,
	STOP = 3
}
slot1 = 1
slot2 = 2
slot3 = 3
slot4 = 4
slot5 = 5
slot6 = {
	MODE1 = 1,
	MODE2 = 2
}

pg.GuideMgr.Init = function (slot0, slot1)
	print("initializing guide manager...")

	slot0.managerState = slot0.MANAGER_STATE.LOADING
	slot0.sceneStore = {}

	PoolMgr.GetInstance():GetUI("GuideUI", true, function (slot0)
		slot0._go = slot0
		slot0._tf = slot0._go.transform

		slot0._go:SetActive(false)

		slot0.UIOverlay = tf(GameObject.Find("Overlay/UIOverlay"))

		slot0._go.transform:SetParent(slot0.UIOverlay, false)

		slot0.guiderTF = findTF(slot0._go, "Guider")
		slot0.styleTF1 = findTF(slot0.guiderTF, "mode1")
		slot0.styleTF2 = findTF(slot0.guiderTF, "mode2")
		slot0.initChatBgH = slot0.styleTF2.sizeDelta.y

		SetActive(slot0.guiderTF, false)

		slot0._bg = findTF(slot0._go, "BG")
		slot0.bgAlpha = slot0._bg:GetComponent(typeof(CanvasGroup))
		slot0.bgAlpha.alpha = 0.2
		slot0._closeBtn = slot0._bg:Find("close_btn")
		slot0.uiLongPress = GetOrAddComponent(slot0._closeBtn, typeof(UILongPressTrigger))
		slot0.uiLongPress.longPressThreshold = 10
		slot0.fingerTF = findTF(slot0._go, "finger")

		SetActive(slot0.fingerTF, false)

		slot0._signRes = findTF(slot0._go, "signRes")
		slot0.signPool = {}
		slot0.curSignList = {}
		slot0.fingerSprites = {}

		eachChild(findTF(slot0._go, "resources"), function (slot0)
			table.insert(slot0.fingerSprites, slot0:GetComponent(typeof(Image)).sprite)
		end)

		slot0.sceneFunc = nil
		slot0.inited = true
		slot0.finder = slot0.Finder(slot2)
		slot0.managerState = slot1.MANAGER_STATE.IDLE
		slot0.chars = {
			slot0.styleTF1:Find("char"):GetComponent(typeof(Image)).sprite,
			GetSpriteFromAtlas("ui/guide_atlas", "guide1")
		}
		slot0.material = slot0._tf:Find("resources/material"):GetComponent(typeof(Image)).material

		slot0._tf.Find("resources/material").GetComponent(typeof(Image)).material()
	end)
end

pg.GuideMgr.isRuning = function (slot0)
	return slot0.managerState == slot0.MANAGER_STATE.BUSY
end

pg.GuideMgr.transformPos = function (slot0, slot1)
	return tf(slot0._go):InverseTransformPoint(slot1)
end

pg.GuideMgr.canPlay = function (slot0)
	if pg.MsgboxMgr.GetInstance()._go.activeSelf then
		return false, 1
	end

	if pg.NewStoryMgr.GetInstance():IsRunning() then
		return false, 2
	end

	if slot0.managerState == slot0.MANAGER_STATE.BUSY then
		return false, 3
	end

	return true
end

pg.GuideMgr.onSceneAnimDone = function (slot0, slot1)
	if not slot0.inited then
		return
	end

	if not table.contains(slot0.sceneStore, slot1.view) then
		table.insert(slot0.sceneStore, slot1.view)
	end

	if slot0.sceneFunc then
		slot0.sceneFunc(slot1.view)
	end
end

pg.GuideMgr.onSceneExit = function (slot0, slot1)
	if not slot0.inited then
		return
	end

	if table.contains(slot0.sceneStore, slot1.view) then
		table.removebyvalue(slot0.sceneStore, slot1.view)
	end
end

pg.GuideMgr.checkModuleOpen = function (slot0, slot1)
	return table.contains(slot0.sceneStore, slot1)
end

pg.GuideMgr.isPlayed = function (slot0, slot1)
	return pg.NewStoryMgr.GetInstance():IsPlayed(slot1)
end

pg.GuideMgr.play = function (slot0, slot1, slot2, slot3, slot4)
	if not slot0.ENABLE_GUIDE then
		return
	end

	slot10, slot6 = slot0:canPlay()

	print("play guide >>", slot1, slot5)

	slot0.erroCallback = slot4

	if slot5 then
		slot0.currentGuide = require("GameCfg.guide.newguide.segments." .. slot1)

		slot0:addDelegateInfo()

		slot7 = Clone(slot0.currentGuide.events)

		if slot2 then
			slot0.curEvents = _.select(slot7, function (slot0)
				if not slot0.code then
					return true
				elseif type(slot0.code) == "table" then
					return _.any(slot0, function (slot0)
						return table.contains(slot0.code, slot0)
					end)
				else
					return table.contains(slot0, slot0.code)
				end
			end)
		else
			slot0.curEvents = slot7
		end

		slot0.prepareGuider(slot0, slot3)

		slot8 = {}
		slot9 = ipairs
		slot10 = slot0.curEvents or {}

		for slot12, slot13 in slot9(slot10) do
			table.insert(slot8, function (slot0)
				slot0.doCurrEvent(slot2, slot0.doCurrEvent, function ()
					if slot0.managerState ~= slot1.MANAGER_STATE.IDLE then
						slot0.scenes = {}

						slot2()
					else
						slot0.erroCallback()

						slot0.erroCallback.erroCallback = nil
					end
				end)
			end)
		end

		slot0.managerState = slot0.MANAGER_STATE.BUSY

		seriesAsync(slot8, function ()
			slot0:endGuider(slot0)
		end)
	elseif slot3 then
		slot3()
	end
end

pg.GuideMgr.prepareGuider = function (slot0, slot1)
	pg.m02:sendNotification(GAME.START_GUIDE)
	slot0._go.transform:SetAsLastSibling()
	slot0._go:SetActive(true)
	SetActive(slot0.fingerTF, false)

	slot0.bgAlpha.alpha = 0.2

	slot0.uiLongPress.onLongPressed:AddListener(function ()
		slot0:endGuider(slot0)
	end)
end

pg.GuideMgr.doCurrEvent = function (slot0, slot1, slot2)
	function slot3(slot0)
		if slot0.waitScene and slot0.waitScene ~= "" and not table.contains(slot1.scenes, slot0.waitScene) then
			slot1.sceneFunc = function (slot0)
				if slot0.waitScene == slot0 or table.contains(slot1.sceneStore, slot0.waitScene) then
					slot1.sceneFunc = nil

					nil()
				end
			end

			slot1.sceneFunc()
		else
			slot0()
		end
	end

	function slot4()
		if slot0.hideui then
			slot1:hideUI(slot1.hideUI, )
		elseif slot0.stories then
			slot1:playStories(slot1.playStories, )
		elseif slot0.notifies then
			slot1:sendNotifies(slot1.sendNotifies, )
		elseif slot0.showSign then
			slot1:showSign(slot1.showSign, )
		elseif slot0.doFunc then
			slot0.doFunc()
			slot2()
		elseif slot0.doNothing then
			slot2()
		else
			slot1:findUI(slot1.findUI, )
		end
	end

	if slot1.delay ~= nil then
		slot0.delayTimer = Timer.New(function ()
			slot0(slot1)
		end, slot1.delay, 1)

		slot0.delayTimer.Start(slot5)
	else
		slot3(slot4)
	end
end

pg.GuideMgr.showSign = function (slot0, slot1, slot2)
	slot3 = slot1.showSign

	function slot4()
		slot1 = slot0.duration
		slot2 = slot0.simultaneously
		slot3 = slot0.clickUI
		slot4 = slot0.clickArea
		slot5 = slot0.longPress
		slot7 = {}

		for slot11, slot12 in ipairs(slot6) do
			slot15 = slot12.cachedIndex
			slot1.curSignList[#slot1.curSignList + 1] = {
				signType = slot12.signType,
				sign = slot1:getSign(slot13, slot12)
			}

			if type(slot12.pos) == "string" then
				if slot14 == "useCachePos" then
					slot14 = WorldGuider.GetInstance():GetTempGridPos(slot15)
				end
			elseif type(slot14) == "table" then
				slot14 = Vector3.New(slot14[1], slot14[2], slot14[3])
			end

			if slot14 then
				setLocalPosition(slot16, slot14)
			end

			slot7[#slot7 + 1] = slot17
		end

		function recycle_handler()
			for slot3, slot4 in ipairs(ipairs) do
				slot1:recycleSign(slot1.curSignList[slot4].signType, slot1.curSignList[slot4].sign)

				slot1.curSignList[slot4] = nil
			end

			if not slot2 then
				slot1:finishCurrEvent(slot3, slot4)
			end
		end

		slot9 = slot1.curSignList[slot7[1]].sign

		if slot0 == 2 then
			slot1.updateUIStyle(slot10, slot2, false, nil)

			slot10 = findTF(slot9, "btn")

			if slot3 then
				setActive(slot9, false)
				slot1.finder:Search({
					path = slot3.path,
					delay = slot3.delay,
					pathIndex = slot3.pathIndex,
					conditionData = slot3.conditionData,
					found = function (slot0)
						slot0.cloneTarget = slot0:cloneGO(go(slot0), slot0._tf, slot0)

						setActive(slot0.cloneTarget, false)

						slot0.cloneTarget.sizeDelta.x * (slot0.cloneTarget.pivot.x - 0.5).localPosition = slot0.cloneTarget.localPosition - Vector3(slot0.cloneTarget.sizeDelta.x * (slot0.cloneTarget.pivot.x - 0.5), slot0.cloneTarget.sizeDelta.y * (slot0.cloneTarget.pivot.y - 0.5), 0)

						if slot1.sizeDeltaPlus then
							slot1.sizeDeltaPlus[1].sizeDelta = slot0.cloneTarget.sizeDelta + Vector2(slot1.sizeDeltaPlus[1], slot1.sizeDeltaPlus[2])
						else
							slot3.sizeDelta = slot0.cloneTarget.sizeDelta
						end

						setActive(setActive, true)
					end,
					notFound = function ()
						slot0:endGuider(slot0)
					end
				})
			elseif slot4 then
				slot10.sizeDelta = Vector2.New(slot4[1], slot4[2])
			end

			GetOrAddComponent(slot10, typeof(UILongPressTrigger)).onLongPressed:RemoveAllListeners()
			GetOrAddComponent(slot10, typeof(UILongPressTrigger)).onReleased:RemoveAllListeners()

			if slot5 == 1 then
				slot11.onLongPressed:AddListener(function ()
					recycle_handler()
				end)
			else
				slot11.onReleased.AddListener(slot12, function ()
					recycle_handler()
				end)
			end

			return
		end

		if slot0 == 3 then
			slot9.sizeDelta = Vector2.New(slot4[1], slot4[2])

			slot1.updateUIStyle(slot10, slot2, true, slot3)
		else
			if slot2 then
				slot1:finishCurrEvent(slot2, slot3)
			end

			if slot1 ~= nil then
				slot1.curSignList[slot8].signTimer = Timer.New(function ()
					recycle_handler()
				end, slot1, 1)

				slot1.curSignList[slot8].signTimer:Start()
			end
		end
	end

	slot4()
end

pg.GuideMgr.getSign = function (slot0, slot1, slot2)
	slot3, slot4 = nil
	slot5 = slot2.atlasName
	slot6 = slot2.fileName

	if slot0.signPool[slot1] ~= nil and #slot0.signPool[slot1] > 0 then
		slot3 = table.remove(slot0.signPool[slot1], #slot0.signPool[slot1])
	else
		if slot1 == 1 or slot1 == 6 then
			slot4 = findTF(slot0._signRes, "wTask")
		elseif slot1 == 2 then
			slot4 = findTF(slot0._signRes, "wDanger")
		elseif slot1 == 3 then
			slot4 = findTF(slot0._signRes, "wForbidden")
		elseif slot1 == 4 then
			slot4 = findTF(slot0._signRes, "wClickArea")
		elseif slot1 == 5 then
			slot4 = findTF(slot0._signRes, "wShowArea")
		end

		slot3 = tf(Instantiate(slot4))
	end

	if slot1 == 6 then
		setImageSprite(findTF(slot3, "shadow"), LoadSprite(slot5, slot6), true)
	end

	setActive(slot3, true)
	setParent(slot3, slot0._go.transform)

	slot3.eulerAngles = Vector3(0, 0, 0)
	slot3.localScale = Vector3.one

	return slot3
end

pg.GuideMgr.recycleSign = function (slot0, slot1, slot2)
	if slot0.signPool[slot1] == nil then
		slot0.signPool[slot1] = {}
	end

	if #slot0.signPool[slot1] > 3 or slot1 == 6 then
		Destroy(slot2)
	else
		table.insert(slot3, slot2)
		setParent(slot2, slot0._signRes)
		setActive(slot2, false)
	end
end

pg.GuideMgr.destroyAllSign = function (slot0)
	for slot4, slot5 in ipairs(slot0.curSignList) do
		if slot5.signTimer ~= nil then
			slot5.signTimer:Stop()

			slot5.signTimer = nil
		end

		slot0:recycleSign(slot5.signType, slot5.sign)

		slot0.curSignList[slot4] = nil
	end
end

pg.GuideMgr.sendNotifies = function (slot0, slot1, slot2)
	slot3 = {}

	for slot7, slot8 in ipairs(slot1.notifies) do
		table.insert(slot3, function (slot0)
			pg.m02:sendNotification(slot0.notify, slot0.body)
			slot0()
		end)
	end

	seriesAsync(slot3, function ()
		slot0:finishCurrEvent(slot0, )
	end)
end

pg.GuideMgr.playStories = function (slot0, slot1, slot2)
	slot3 = {}

	for slot7, slot8 in ipairs(slot1.stories) do
		table.insert(slot3, function (slot0)
			pg.NewStoryMgr.GetInstance():Play(slot0, slot0, true)
		end)
	end

	seriesAsync(slot3, function ()
		slot0:finishCurrEvent(slot0, )
		pg.m02:sendNotification(GAME.START_GUIDE)
	end)
end

pg.GuideMgr.hideUI = function (slot0, slot1, slot2)
	slot3 = {}

	for slot7, slot8 in ipairs(slot1.hideui) do
		table.insert(slot3, function (slot0)
			slot0.finder:SearchTimely({
				path = slot1.path,
				delay = slot1.delay,
				pathIndex = slot1.pathIndex,
				found = function (slot0)
					SetActive(slot0, not slot0.ishide)
					SetActive()
				end,
				notFound = function ()
					slot0:endGuider(slot0)
				end
			})
		end)
	end

	parallelAsync(slot3, function ()
		slot0:finishCurrEvent(slot0, )
	end)
end

pg.GuideMgr.findUI = function (slot0, slot1, slot2)
	slot3 = true
	slot4 = {
		function (slot0)
			if not slot0.baseui then
				slot0()

				return
			end

			slot1.finder:Search({
				path = slot0.baseui.path,
				delay = slot0.baseui.delay,
				pathIndex = slot0.baseui.pathIndex,
				conditionData = slot0.baseui.conditionData,
				found = slot0,
				notFound = function ()
					slot0:endGuider(slot0)
				end
			})
		end,
		function (slot0)
			if not slot0.spriteui then
				slot0()

				return
			end

			slot1:CheckSprite(slot0.spriteui, slot0, slot1)
		end,
		function (slot0)
			if not slot0.ui then
				slot0()

				return
			end

			slot1 = false

			slot2.finder:Search({
				path = slot0.ui.path,
				delay = slot0.ui.delay,
				pathIndex = slot0.ui.pathIndex,
				conditionData = slot0.ui.conditionData,
				found = function (slot0)
					Canvas.ForceUpdateCanvases()

					slot0.cloneTarget = slot0:cloneGO(slot0.gameObject, slot0._go.transform, slot1.ui)

					slot0:addUIEventTrigger(slot0, slot0.addUIEventTrigger, slot0)
					slot0:setFinger(slot0, slot1.ui)
					slot0()
				end,
				notFound = function ()
					if slot0.ui.notfoundSkip then
						slot1:finishCurrEvent(slot1.finishCurrEvent, )
					else
						slot1:endGuider(slot2)
					end
				end
			})
		end
	}

	seriesAsync(slot4, function ()
		slot0:updateUIStyle(slot0, , )
	end)
end

pg.GuideMgr.CheckSprite = function (slot0, slot1, slot2, slot3)
	slot4, slot5 = nil
	slot6 = 0
	slot7 = 10

	function slot4()
		slot0 = slot0 + 1

		slot1:RemoveCheckSpriteTimer()

		if IsNil(slot2:GetComponent(typeof(Image)).sprite) or (slot3.defaultName and slot0.sprite.name == slot3.defaultName) then
			if slot4 <= slot0 then
				slot5()

				return
			end

			slot1.srpiteTimer = Timer.New(slot6, 0.5, 1)

			slot1.srpiteTimer:Start()
		else
			slot5()
		end
	end

	slot0.finder.Search(slot8, {
		path = slot1.path,
		delay = slot1.delay,
		pathIndex = slot1.pathIndex,
		conditionData = slot1.conditionData,
		found = function (slot0)
			slot1 = (not slot0.childPath or slot0:Find(slot0.childPath)) and slot0

			slot2()
		end,
		notFound = function ()
			slot0:endGuider(slot0)
		end
	})
end

pg.GuideMgr.RemoveCheckSpriteTimer = function (slot0)
	if slot0.srpiteTimer then
		slot0.srpiteTimer:Stop()

		slot0.srpiteTimer = nil
	end
end

pg.GuideMgr.SetHighLightLine = function (slot0, slot1)
	slot0.highLightLine = cloneTplTo(findTF(slot0._signRes, "wShowArea"), slot0._tf)
	slot0.highLightLine.sizeDelta = Vector2(slot1.sizeDelta.x + 15, slot1.sizeDelta.y + 15)
	slot0.highLightLine.pivot = slot1.pivot
	slot0.highLightLine.localPosition = Vector3(slot0._tf:InverseTransformPoint(slot1.position).x, slot0._tf.InverseTransformPoint(slot1.position).y, 0) + Vector3(slot4, slot5, 0)
end

pg.GuideMgr.updateUIStyle = function (slot0, slot1, slot2, slot3)
	slot0.bgAlpha.alpha = slot1.alpha or 0.2

	SetActive(slot0.guiderTF, slot1.style)

	function slot4(slot0)
		if slot0.style.ui.lineMode then
			slot1:SetHighLightLine(slot0)
		else
			slot1.cloneTarget = slot1:cloneGO(go(slot0), slot1._tf, slot0.style.ui)
		end
	end

	if slot1.style then
		slot0.updateContent(slot0, slot1)

		if slot1.style.ui then
			slot0.finder:Search({
				path = slot1.style.ui.path,
				delay = slot1.style.ui.delay,
				pathIndex = slot1.style.ui.pathIndex,
				found = slot4,
				notFound = function ()
					slot0:endGuider()
				end
			})
		end
	end

	onButton(slot0, slot0._go, function ()
		slot0:finishCurrEvent(slot0, )

		if slot1.style and slot1.style.scene then
			pg.m02:sendNotification(GAME.GO_SCENE, SCENE[slot1.style.scene])
		end
	end, SFX_PANEL)
	setButtonEnabled(slot0._go, slot2)
end

pg.GuideMgr.updateContent = function (slot0, slot1)
	slot3 = slot1.style or {}.dir or 1
	slot5 = slot1.style or .posX or 0
	slot6 = slot1.style or .posY or 0

	SetActive(slot0.styleTF1, (slot1.style or .mode or 1) == slot0.MODE1)
	SetActive(slot0.styleTF2, (slot1.style or .mode or 1) == slot0.MODE2)

	slot7, slot8 = nil

	if slot4 == slot0.MODE1 then
		slot7 = slot0.styleTF1
		slot8 = Vector3(18, -31, 0)
	elseif slot4 == slot0.MODE2 then
		slot7 = slot0.styleTF2
		slot8 = Vector3(-27, 143, 0)
	end

	slot9 = slot7:Find("char"):GetComponent(typeof(Image))
	slot9.sprite = slot0.chars[(slot2.char and slot2.char == "1" and 2) or 1]

	slot9:SetNativeSize()

	slot9.material = slot2.char and slot0.material
	slot9.gameObject.transform.pivot = getSpritePivot(slot0.chars)

	setAnchoredPosition(slot9.gameObject.transform, {
		x = slot8.x,
		y = slot8.y
	})

	slot7.localScale = (slot3 == 1 and Vector3(1, 1, 1)) or Vector3(-1, 1, 1)
	slot7:Find("content").localScale = (slot3 == 1 and Vector3(1, 1, 1)) or Vector3(-1, 1, 1)

	setText(slot12, HXSet.hxLan(slot2.text or ""))

	if CHAT_POP_STR_LEN_MIDDLE < #slot12:GetComponent(typeof(Text)).text then
		slot14.alignment = TextAnchor.MiddleLeft
	else
		slot14.alignment = TextAnchor.MiddleCenter
	end

	slot15 = slot14.preferredHeight + 120

	if slot4 == slot0.MODE2 and slot0.initChatBgH < slot15 then
		slot7.sizeDelta = Vector2.New(slot7.sizeDelta.x, slot15)
	else
		slot7.sizeDelta = Vector2.New(slot7.sizeDelta.x, slot0.initChatBgH)
	end

	if slot4 == slot0.MODE1 then
		slot7:Find("hand").localPosition = Vector3(slot2.hand or {
			w = 0,
			x = -267,
			y = -96
		}.x, slot2.hand or .y, 0)
		slot7:Find("hand").eulerAngles = Vector3(0, 0, slot2.hand or .w)
	end

	setAnchoredPosition(slot0.guiderTF, Vector2(slot5, slot6))
end

pg.GuideMgr.Finder = function (slot0)
	function slot2(slot0, slot1)
		slot2 = -1

		for slot6 = 1, slot0.childCount, 1 do
			if (not slot0:GetChild(slot6 - 1):GetComponent(typeof(LayoutElement)) or not slot8.ignoreLayout) and slot2 + 1 == slot1 then
				break
			end
		end

		return slot2
	end

	function slot3(slot0, slot1)
		if not IsNil(GameObject.Find(slot0)) then
			if slot1 and slot1 == -999 then
				for slot7 = 0, tf(slot2).childCount, 1 do
					if not IsNil(tf(slot2):GetChild(slot7)) and go(slot8).activeInHierarchy then
						return slot8
					end
				end
			elseif slot1 and slot1 ~= -1 then
				if slot0(tf(slot2), slot1) >= 0 and slot3 < tf(slot2).childCount and not IsNil(tf(slot2):GetChild(slot3)) then
					return slot4
				end
			else
				return tf(slot2)
			end
		end
	end

	function slot4(slot0, slot1)
		if slot0(slot0, -1) ~= nil then
			for slot6, slot7 in ipairs(slot1) do
				if slot2:Find(slot7) then
					return slot8
				end
			end
		end
	end

	return {
		Search = function (slot0, slot1)
			slot0:Clear()

			slot2 = 0.5
			slot3 = 20
			slot4 = 0
			slot5 = slot1.delay or 0
			slot0.findUITimer = Timer.New(function ()
				slot0 = slot0 + slot1

				if pg.UIMgr.GetInstance():OnLoading() then
					return
				end

				if slot2 < slot0 then
					if slot3 == 0 then
						print("not found ui >>", slot4.path)
						slot5:Clear()
						slot4.notFound()

						return
					end

					slot0 = nil

					if (slot4.conditionData == nil or slot6(slot4.path, slot4.conditionData)) and slot7(slot4.path, slot4.pathIndex) and go(slot0).activeInHierarchy then
						slot5:Clear()
						slot4.found(slot0)

						return
					end

					slot3 = slot3 - 1
				end
			end, slot2, -1)

			slot0.findUITimer:Start()
			slot0.findUITimer.func()
		end,
		SearchTimely = function (slot0, slot1)
			slot0:Clear()

			if slot0(slot1.path, slot1.pathIndex) then
				slot1.found(slot2)
			else
				slot1.notFound()
			end
		end,
		Clear = function (slot0)
			if slot0.findUITimer then
				slot0.findUITimer:Stop()

				slot0.findUITimer = nil
			end
		end
	}
end

pg.GuideMgr.cloneGO = function (slot0, slot1, slot2, slot3)
	slot4 = tf(Instantiate(slot1))
	slot4.sizeDelta = tf(slot1).sizeDelta

	SetActive(slot4, true)
	slot4:SetParent(slot2, false)

	if slot3.hideChildEvent then
		eachChild(slot4, function (slot0)
			if slot0:GetComponent(typeof(Button)) then
				slot1.enabled = false
			end
		end)
	end

	if slot3.hideAnimtor and slot4.GetComponent(slot4, typeof(Animator)) then
		slot5.enabled = false
	end

	if slot3.childAdjust then
		for slot8, slot9 in ipairs(slot3.childAdjust) do
			if LeanTween.isTweening(slot4:Find(slot9[1]).gameObject) then
				LeanTween.cancel(slot10.gameObject)
			end

			if slot10 and slot9[2] == "scale" then
				slot10.localScale = Vector3(slot9[3][1], slot9[3][2], slot9[3][3])
			elseif slot10 and slot9[2] == "position" then
				slot10.anchoredPosition = Vector3(slot9[3][1], slot9[3][2], slot9[3][3])
			end
		end
	end

	if slot0.targetTimer then
		slot0.targetTimer:Stop()

		slot0.targetTimer = nil
	end

	if not slot3.pos and not slot3.scale and not slot3.eulerAngles then
		slot0.targetTimer = Timer.New(function ()
			if not IsNil(IsNil) and not IsNil(slot1) then
				slot1.position = slot0.transform.position
				slot0.transform.position.localPosition = Vector3(slot1.localPosition.x, slot1.localPosition.y, 0)
				slot1.localScale = Vector3(slot0.transform.localScale.x, slot0.transform.localScale.y, slot0.transform.localScale.z)

				if slot1.image and type(slot2.image) == "table" then
					slot4 = nil
					slot4 = (not (not slot2.image.isChild or tf(slot0):Find(slot2.image.source)) and GameObject.Find(slot2.image.source).image.isRelative or ((not slot2.image.isChild or tf(slot0).Find(slot2.image.source)) and GameObject.Find(slot2.image.source).image.target == "" and slot1) or tf(slot1):Find((not slot2.image.isChild or tf(slot0).Find(slot2.image.source)) and GameObject.Find(slot2.image.source).image.target)) and GameObject.Find((not slot2.image.isChild or tf(slot0).Find(slot2.image.source)) and GameObject.Find(slot2.image.source).image.target)

					if not IsNil(slot2) and not IsNil(slot4) then
						slot6 = slot4:GetComponent(typeof(Image))

						if slot2:GetComponent(typeof(Image)) and slot6 then
							slot8 = slot6.sprite

							if slot5.sprite and slot8 and slot7 ~= slot8 then
								slot6.enabled = slot5.enabled

								setImageSprite(slot4, slot7)
							end
						end
					end
				end
			end
		end, 0.01, -1)

		slot0.targetTimer.Start(slot5)
		slot0.targetTimer.func()
	else
		if slot3.pos then
			slot4.localPosition = Vector3(slot3.pos.x, slot3.pos.y, slot3.pos.z or 0)
		elseif slot3.isLevelPoint then
			slot4.localPosition = LuaHelper.ScreenToLocal(slot2, GameObject.Find("LevelCamera"):GetComponent(typeof(Camera)).WorldToScreenPoint(slot5, slot6), GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)))
		else
			slot4.position = slot1.transform.position
			slot4.localPosition = Vector3(slot4.localPosition.x, slot4.localPosition.y, 0)
		end

		slot4.localScale = Vector3(slot3.scale or 1, , )

		if slot3.eulerAngles then
			slot4.eulerAngles = Vector3(slot3.eulerAngles[1], slot3.eulerAngles[2], slot3.eulerAngles[3])
		else
			slot4.eulerAngles = Vector3(0, 0, 0)
		end
	end

	return slot4
end

pg.GuideMgr.setFinger = function (slot0, slot1, slot2)
	SetActive(slot0.fingerTF, true)

	slot0.fingerTF.localScale = Vector3((slot2.scale and 1 / slot2.scale) or 1, , 1)
	slot6 = (slot2.fingerPos and Vector3(slot2.fingerPos.posX, slot2.fingerPos.posY, 0)) or Vector3(slot1.sizeDelta.x / 2, -(slot1.sizeDelta.y / 2), 0)
	slot7 = Vector3(0, 0, 0)

	if slot2.fingerPos then
		slot7 = Vector3(slot2.fingerPos.rotateX or 0, slot2.fingerPos.rotateY or 0, slot2.fingerPos.rotateZ or 0)
	end

	if slot0.cloneTarget then
		slot0.fingerTF:SetParent(slot0.cloneTarget, false)
	end

	setAnchoredPosition(slot0.fingerTF, slot6)

	slot0.fingerTF.localEulerAngles = slot7
end

pg.GuideMgr.addUIEventTrigger = function (slot0, slot1, slot2, slot3)
	slot4 = slot2.ui
	slot5 = slot1

	if slot0.cloneTarget:GetComponent(typeof(CanvasGroup)) then
		slot7.alpha = 1
	end

	if slot4.eventIndex then
		slot5 = slot1:GetChild(slot4.eventIndex)
		slot6 = slot0.cloneTarget:GetChild(slot4.eventIndex)
	elseif slot4.eventPath then
		if IsNil(GameObject.Find(slot4.eventPath)) then
			slot5 = slot1
		end

		if slot0.cloneTarget:GetComponent(typeof(Image)) == nil then
			GetOrAddComponent(slot0.cloneTarget, typeof(Image)).color = Color(1, 1, 1, 0)
		end
	end

	if ((slot4.triggerType and slot4.triggerType[1]) or slot0) == slot0 then
		onButton(slot0, slot6, function ()
			if not IsNil(IsNil) then
				slot1:finishCurrEvent(slot2, slot3)

				if slot4.onClick then
					slot4.onClick()
				else
					triggerButton(triggerButton)
				end
			end
		end, SFX_PANEL)
		setButtonEnabled(slot6, true)
	elseif slot8 == slot1 then
		onToggle(slot0, slot6, function (slot0)
			if IsNil(slot0) then
				return
			end

			slot1:finishCurrEvent(slot1, )

			if slot4.triggerType[2] ~= nil then
				triggerToggle(slot0, slot4.triggerType[2])
			else
				triggerToggle(slot0, true)
			end
		end, SFX_PANEL)
		setToggleEnabled(slot6, true)
	else
		if slot8 == slot2 then
			slot9 = slot5:GetComponent(typeof(EventTriggerListener))
			slot10 = slot6:GetComponent(typeof(EventTriggerListener))

			slot10:AddPointDownFunc(function (slot0, slot1)
				if not IsNil(slot0) then
					slot1:OnPointerDown(slot1)
				end
			end)
			slot10.AddPointUpFunc(slot10, function (slot0, slot1)
				slot0:finishCurrEvent(slot1, slot0.finishCurrEvent)

				if not IsNil(slot0) then
					slot4:OnPointerUp(slot1)
				end
			end)

			return
		end

		if slot8 == slot3 then
			if slot6.GetComponent(slot6, typeof(EventTriggerListener)) == nil then
				slot9 = go(slot6):AddComponent(typeof(EventTriggerListener))
			end

			slot9:AddPointDownFunc(function (slot0, slot1)
				if not IsNil(slot0) then
					slot1:finishCurrEvent(slot1.finishCurrEvent, slot1)
				end
			end)
		elseif slot8 == slot4 then
			if slot6.GetComponent(slot6, typeof(EventTriggerListener)) == nil then
				slot9 = go(slot6):AddComponent(typeof(EventTriggerListener))
			end

			slot9:AddPointUpFunc(function (slot0, slot1)
				slot0:finishCurrEvent(slot1, slot0.finishCurrEvent)
			end)
		end
	end
end

pg.GuideMgr.finishCurrEvent = function (slot0, slot1, slot2)
	slot0.bgAlpha.alpha = 0.2

	removeOnButton(slot0._go)
	slot0:destroyAllSign()
	SetParent(slot0.fingerTF, tf(slot0._go), false)
	SetActive(slot0.fingerTF, false)
	SetActive(slot0.guiderTF, false)

	slot0.fingerTF.localScale = Vector3(1, 1, 1)

	if slot0.cloneTarget then
		SetActive(slot0.cloneTarget, false)
		Destroy(slot0.cloneTarget)

		slot0.cloneTarget = nil
	end

	if slot0.targetTimer then
		slot0.targetTimer:Stop()

		slot0.targetTimer = nil
	end

	if slot0.findUITimer then
		slot0.findUITimer:Stop()

		slot0.findUITimer = nil
	end

	if slot0.highLightLine then
		Destroy(slot0.highLightLine)

		slot0.highLightLine = nil
	end

	if slot2 then
		slot2()
	end
end

function slot7(slot0)
	slot0:clearDelegateInfo()
	slot0:RemoveCheckSpriteTimer()

	if slot0.delayTimer then
		slot0.delayTimer:Stop()

		slot0.delayTimer = nil
	end

	if slot0.targetTimer then
		slot0.targetTimer:Stop()

		slot0.targetTimer = nil
	end

	slot0:destroyAllSign()
	slot0.finder:Clear()

	if slot0.cloneTarget then
		SetParent(slot0.fingerTF, slot0._go)
		Destroy(slot0.cloneTarget)

		slot0.cloneTarget = nil
	end

	slot0._go:SetActive(false)
	removeOnButton(slot0._go)

	if slot0.curEvents then
		slot0.curEvents = nil
	end

	if slot0.currentGuide then
		slot0.currentGuide = nil
	end

	slot0.uiLongPress.onLongPressed:RemoveAllListeners()
end

pg.GuideMgr.addDelegateInfo = function (slot0)
	pg.DelegateInfo.New(slot0)

	slot0.isAddDelegateInfo = true
end

pg.GuideMgr.clearDelegateInfo = function (slot0)
	if slot0.isAddDelegateInfo then
		pg.DelegateInfo.Dispose(slot0)

		slot0.isAddDelegateInfo = nil
	end
end

pg.GuideMgr.mask = function (slot0)
	SetActive(slot0._go, true)
end

pg.GuideMgr.unMask = function (slot0)
	SetActive(slot0._go, false)
end

pg.GuideMgr.endGuider = function (slot0, slot1)
	slot0(slot0)

	slot0.managerState = slot1.MANAGER_STATE.IDLE

	pg.m02:sendNotification(GAME.END_GUIDE)

	if slot1 then
		slot1()
	end
end

pg.GuideMgr.onDisconnected = function (slot0)
	if slot0._go.activeSelf then
		slot0.prevState = slot0.managerState
		slot0.managerState = slot0.MANAGER_STATE.BREAK

		SetActive(slot0._go, false)

		if slot0.cloneTarget then
			SetActive(slot0.cloneTarget, false)
		end
	end
end

pg.GuideMgr.onReconneceted = function (slot0)
	if slot0.prevState then
		slot0.managerState = slot0.prevState
		slot0.prevState = nil

		SetActive(slot0._go, true)

		if slot0.cloneTarget then
			SetActive(slot0.cloneTarget, true)
		end
	end
end

return

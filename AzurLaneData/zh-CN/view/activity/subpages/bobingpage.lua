slot0 = class("BobingPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		setActive(findTF(slot0._tf, "bobing"), true)
		setActive(findTF(slot0._tf, "lottery"), false)
	else
		setActive(findTF(slot0._tf, "bobing"), false)
		setActive(findTF(slot0._tf, "lottery"), true)
	end

	slot0:bind(ActivityMediator.ON_BOBING_RESULT, function (slot0, slot1, slot2)
		if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
			slot0:displayBBResult(slot1.awards, slot1.numbers, function ()
				slot0.callback()
			end)
		else
			slot0.displayLotteryAni(slot3, slot1.awards, slot1.numbers, function ()
				slot0.callback()
			end)
		end
	end)
end

slot0.OnUpdateFlush = function (slot0)
	if PLATFORM_CODE == PLATFORM_CHT or PLATFORM_CODE == PLATFORM_CH then
		slot0:bobingUpdate()
	else
		slot0:lotteryUpdate()
	end
end

slot0.lotteryUpdate = function (slot0)
	slot1 = slot0.activity
	slot2 = findTF(slot0._tf, "lottery/layer")

	if not slot0.lotteryWrap then
		slot0.lotteryWrap = {
			btnLotteryBtn = findTF(slot2, "lottery_btn"),
			phase = findTF(slot2, "phase"),
			nums = findTF(slot2, "nums")
		}
	end

	if slot1:getConfig("config_id") <= slot1.data1 then
		setActive(findTF(slot3.phase, "bg"), false)
		setActive(findTF(slot3.phase, "Text"), false)
		setActive(findTF(slot3.phase, "finish"), true)
	else
		setActive(findTF(slot3.phase, "bg"), true)
		setActive(findTF(slot3.phase, "Text"), true)
		setText(findTF(slot3.phase, "Text"), setColorStr(slot1.data1, "FFD43F") .. "/" .. slot4)
		setActive(findTF(slot3.phase, "finish"), false)
	end

	if slot1.data2 < 1 then
		LeanTween.alpha(slot3.btnLotteryBtn, 1, 1):setLoopPingPong()
		setActive(findTF(slot3.btnLotteryBtn, "mask"), false)
		onButton(slot0, slot3.btnLotteryBtn, function ()
			if slot0.activity.data2 < 1 then
				slot0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = slot0.activity.id
				})
				slot0.emit._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			end
		end, SFX_PANEL)
	else
		LeanTween.cancel(slot3.btnLotteryBtn.gameObject)
		setActive(findTF(slot3.btnLotteryBtn, "mask"), true)
		setActive(findTF(slot3.btnLotteryBtn, "mask/1"), slot0.getIndexByNumbers(slot0, slot1.data1_list) == 1)
		setActive(findTF(slot3.btnLotteryBtn, "mask/2"), slot5 == 2)
		setActive(findTF(slot3.btnLotteryBtn, "mask/3"), slot5 == 3)
		onButton(slot0, slot3.btnLotteryBtn, function ()
			if slot0.activity.data2 < 1 then
				slot0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = slot0.activity.id
				})
				slot0.emit._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			end
		end, SFX_PANEL)
	end

	slot5 = (slot1.data2 == 0 and "FFD43F") or "d2d4db"

	setText(findTF(slot3.nums, "text"), string.format("<color=#%s>%s</color> / %s", slot5, 1 - slot1.data2, 1))
end

slot0.getIndexByNumbers = function (slot0, slot1)
	slot3 = 3

	if ActivityConst.BBRule(slot1) and slot2 >= 1 and slot2 <= 2 then
		slot3 = 1
	end

	if slot2 and slot2 >= 3 and slot2 <= 4 then
		slot3 = 2
	end

	return slot3
end

slot0.displayLotteryAni = function (slot0, slot1, slot2, slot3)
	slot4 = slot0:getIndexByNumbers(slot2)
	slot6 = slot0:findTF("omikuji_anim", slot5):GetComponent(typeof(DftAniEvent))

	slot6:SetEndEvent(function (slot0)
		setActive(slot0.gameObject, false)

		slot1 = setActive:findTF("omikuji_result", setActive)

		setActive(slot1, true)

		for slot6 = 1, slot1:findTF("title", slot1).childCount, 1 do
			setActive(slot2:GetChild(slot6 - 1), slot6 == slot3)
		end

		setText(slot3, slot5)
		setActive(slot6, false)
		removeAllChildren(slot1:findTF("award_list", slot1))

		if {
			"big",
			"medium",
			"little"
		} then
			for slot11, slot12 in ipairs(slot4) do
				updateDrop(slot13, slot14)
				onButton(slot1, cloneTplTo(slot6, slot7), function ()
					slot0:emit(BaseUI.ON_DROP, slot0)
				end, SFX_PANEL)
			end
		end

		slot1._event.emit(slot8, ActivityMainScene.LOCK_ACT_MAIN, false)
		onButton(slot1, slot1, function ()
			setActive(setActive, false)
			setActive()
		end)
	end)
	setActive(slot6.gameObject, true)
end

slot0.bobingUpdate = function (slot0)
	slot1 = slot0.activity
	slot2 = findTF(slot0._tf, "bobing")

	if not slot0.bobingWrap then
		setActive(({
			bg = slot0:findTF("AD", slot0._tf),
			progress = slot0:findTF("award/nums", slot2),
			get = slot0:findTF("award/get", slot2),
			nums = slot0:findTF("nums/text", slot2),
			bowlDisable = slot0:findTF("bowl_disable", slot2),
			bowlEnable = slot0:findTF("bowl_enable", slot2),
			bowlShine = slot0:findTF("bowl_shine", ()["bowlEnable"]),
			btnRule = slot0:findTF("btnRule", slot2),
			layerRule = slot0:findTF("rule", slot2),
			btnReturn = slot0:findTF("btnReturn", ()["layerRule"]),
			item = slot0:findTF("item", ()["layerRule"]),
			top = slot0:findTF("top", ()["layerRule"]),
			itemRow = slot0:findTF("row", ()["layerRule"]),
			itemColumn = slot0:findTF("column", ()["layerRule"])
		})["layerRule"], false)
		setActive(()["item"], false)
		setActive(()["itemRow"], false)
		setActive(()["itemColumn"], true)

		slot7 = UIItemList.New(()["top"], ()["item"])

		slot7:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventUpdate then
				updateDrop(slot2, slot3)
				onButton(slot1, slot2, function ()
					slot0:emit(BaseUI.ON_DROP, slot0)
				end, SFX_PANEL)
			end
		end)
		slot7.align(slot7, #pg.gameset.bb_front_awards.description[1])

		slot8 = UIItemList.New(()["itemColumn"], ()["itemRow"])

		slot8:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventUpdate then
				slot4 = UIItemList.New(slot2, slot1.item)

				slot4:make(function (slot0, slot1, slot2)
					if slot0 == UIItemList.EventUpdate then
						updateDrop(slot2, slot3)
						onButton(slot1, slot2, function ()
							slot0:emit(BaseUI.ON_DROP, slot0)
						end, SFX_PANEL)
					end
				end)
				slot4.align(slot4, #slot0[slot1 + 1])
			end
		end)
		slot8.align(slot8, #_.slice(slot4, 2, #pg.gameset.bb_front_awards.description - 1))
		onButton(slot0, ()["btnRule"], function ()
			setActive(slot0.layerRule, true)
		end, SFX_PANEL)
		onButton(slot0, ()["btnReturn"], function ()
			setActive(slot0.layerRule, false)
		end, SFX_CANCEL)
		onButton(slot0, ()["bowlEnable"], function ()
			slot0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, true)
			slot0._event.emit:displayBBAnim(function ()
				slot0:emit(ActivityMediator.EVENT_OPERATION, {
					cmd = 1,
					activity_id = slot1.id
				})
			end)
		end, SFX_PANEL)

		slot0.bobingWrap = 
	end

	setActive(slot3.layerRule, false)
	setActive(slot3.get, slot1.getConfig(slot1, "config_id") <= slot1.data1)
	setActive(slot3.bowlDisable, slot1.data2 == 0)
	setActive(slot3.bowlEnable, slot1.data2 > 0)

	if slot1.data2 < 1 then
		LeanTween.alpha(slot3.bowlShine, 1, 1):setLoopPingPong()
	else
		LeanTween.cancel(slot3.bowlShine.gameObject)
	end

	setText(slot3.progress, string.format("<color=#%s>%s</color> %s", "FFD43F", math.min(slot1.data1, slot4) .. "/", slot4))
	setActive(slot3.progress, slot1.data1 < slot4)
	setText(slot3.nums, string.format("<color=#%s>%s</color>", (slot1.data2 == 0 and "FFD43F") or "d2d4db", slot1.data2))
end

slot0.displayBBAnim = function (slot0, slot1)
	slot3 = slot0:findTF("ship", slot2)
	slot4 = slot0:findTF("bowl", slot0:findTF("bobing/bb_anim"))

	if not slot0.animBowl then
		slot0.animBowl = slot4:GetComponent(typeof(SpineAnimUI))

		slot0.animBowl:SetAction("bobing", 0)
		slot0.animBowl:SetActionCallBack(function (slot0)
			if slot0 == "finsih" then
				setActive(slot0, false)
				setActive(setActive, false)
				setActive()
			end
		end)
	end

	function slot5()
		setActive(setActive, true)
		setActive(setActive, true)
		slot2.model:GetComponent(typeof(SpineAnimUI)):SetAction("victory", 0)
	end

	if not slot0.model then
		PoolMgr.GetInstance():GetSpineChar(getProxy(BayProxy).getShipById(slot8, getProxy(PlayerProxy).getRawData(slot6).character).getPrefab(slot9), false, function (slot0)
			slot0.model = slot0
			slot0.model.transform.localScale = Vector3(0.5, 0.5, 1)

			slot0.model.transform:SetParent(slot0.model.transform.SetParent, false)
			slot0.model.transform()
		end)
	else
		slot5()
	end

	setActive(slot2, true)
end

slot0.displayBBResult = function (slot0, slot1, slot2, slot3)
	slot0.animation = findTF(slot0._tf, "bobing")

	setActive(slot0:findTF("bb_anim", slot0.animation), false)

	slot4 = slot0:findTF("bb_result", slot0.animation)
	slot5 = slot0:findTF("numbers", slot4)
	slot7 = slot0:findTF("rank", slot4)
	slot8 = slot0:findTF("bgRank", slot4)

	setActive(slot6, false)
	setActive(slot9, false)
	removeAllChildren(slot0:findTF("award_list", slot4))

	if slot1 then
		for slot14, slot15 in ipairs(slot1) do
			updateDrop(slot16, slot17)
			onButton(slot0, cloneTplTo(slot9, slot10), function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
		end
	end

	slot11 = UIItemList.New(slot5, slot6)

	slot11:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:setSpriteTo("bobing/bb_icon/dice" .. slot1[slot1 + 1], slot2)
			setImageAlpha(slot2, 0)
		end
	end)
	slot11.align(slot11, #slot2)
	setActive(slot7, ActivityConst.BBRule(slot2) < 7)
	setActive(slot8, slot12 < 7)

	if slot12 < 7 then
		slot0:setSpriteTo("bobing/bb_icon/rank" .. slot12, slot7)
		setImageAlpha(slot7, 0)
	end

	slot13 = false
	slot14 = LeanTween.value(go(slot5), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
		slot0:each(function (slot0, slot1)
			setImageAlpha(slot1, slot0)
		end)
	end))

	if slot12 == 7 then
		slot14.setOnComplete(slot14, System.Action(function ()
			slot0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)

			slot1 = true
		end))
	else
		LeanTween.value(go(slot7), 0, 1, 0.2):setDelay(1):setOnUpdate(System.Action_float(function (slot0)
			setImageAlpha(slot0, slot0)

			slot0.localScale = Vector3.Lerp(Vector3(2, 2, 2), Vector3.one, slot0)
		end))
		slot0:setSpriteTo("bobing/bb_icon/rank" .. slot12, slot0.findTF(slot0, "rank_p", slot4) or cloneTplTo(slot7, slot4, "rank_p"))
		slot0:setSpriteTo("bobing/bb_icon/rank" .. slot12, slot7)
		LeanTween.value(go(slot0.findTF(slot0, "rank_p", slot4) or cloneTplTo(slot7, slot4, "rank_p")), 1, 0, 0.3):setDelay(1.5):setOnUpdate(System.Action_float(function (slot0)
			setImageAlpha(slot0, slot0)

			slot0.localScale = Vector3.Lerp(Vector3(2, 2, 2), Vector3.one, slot0)
		end)).setOnComplete(slot16, System.Action(function ()
			slot0._event:emit(ActivityMainScene.LOCK_ACT_MAIN, false)

			slot1 = true
		end))
	end

	setActive(slot4, true)
	onButton(slot0, slot4, function ()
		if slot0 then
			setActive(slot1, false)
			false()
		end
	end)
end

slot0.setSpriteTo = function (slot0, slot1, slot2, slot3)
	slot2:GetComponent(typeof(Image)).sprite = slot0:findTF(slot1):GetComponent(typeof(Image)).sprite

	if slot3 then
		slot4:SetNativeSize()
	end
end

slot0.OnDestroy = function (slot0)
	if slot0.bobingWrap then
		clearImageSprite(slot0.bobingWrap.bg)
		LeanTween.cancel(slot0.bobingWrap.bowlShine.gameObject)
	end
end

return slot0

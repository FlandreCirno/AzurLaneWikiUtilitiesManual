slot0 = class("BeatMonsterMeidator")
slot1 = 1
slot2 = 0.1
slot3 = 1

slot0.Ctor = function (slot0, slot1)
	pg.DelegateInfo.New(slot0)

	slot0.controller = slot1
end

slot0.SetUI = function (slot0, slot1)
	slot0._go = slot1
	slot0._tf = tf(slot1)
	slot0.monsterNian = slot0:findTF("AD/monster")
	slot0.fushun = slot0:findTF("AD/fushun")
	slot0.hpTF = slot0:findTF("AD/hp"):GetComponent(typeof(Slider))
	slot0.attackCntTF = slot0:findTF("AD/attack_count/Text"):GetComponent(typeof(Text))
	slot0.actions = slot0:findTF("AD/actions")
	slot0.actionKeys = {
		slot0.actions:Find("content/1"),
		slot0.actions:Find("content/2"),
		slot0.actions:Find("content/3")
	}
	slot0.curtainTF = slot0:findTF("AD/curtain")
	slot0.startLabel = slot0.curtainTF:Find("start_label")
	slot0.ABtn = slot0:findTF("AD/A_btn")
	slot0.BBtn = slot0:findTF("AD/B_btn")
	slot0.joyStick = slot0:findTF("AD/joyStick")
end

slot0.DoCurtainUp = function (slot0, slot1)
	if getProxy(SettingsProxy):IsShowBeatMonseterNianCurtain() then
		slot2:SetBeatMonseterNianFlag()
		slot0:StartCurtainUp(slot1)
	else
		slot1()
	end
end

slot0.StartCurtainUp = function (slot0, slot1)
	setActive(slot0.curtainTF, true)
	LeanTween.color(slot0.curtainTF, Color.white, slot0):setFromColor(Color.black):setOnComplete(System.Action(function ()
		setActive(slot0.startLabel, true)
		blinkAni(slot0.startLabel, , 2):setOnComplete(System.Action(function ()
			LeanTween.alpha(slot0.curtainTF, 0, ):setFrom(1)
			LeanTween.alpha(slot0.startLabel, 0, ):setFrom(1):setOnComplete(System.Action(System.Action))
		end))
	end))
end

slot0.OnInited = function (slot0)
	slot0.OnTrigger(slot0, slot0.ABtn, slot1, function ()
		slot0.controller:Input(BeatMonsterNianConst.ACTION_NAME_A)
	end)
	slot0.OnTrigger(slot0, slot0.BBtn, slot1, function ()
		slot0.controller:Input(BeatMonsterNianConst.ACTION_NAME_B)
	end)
	slot0.OnJoyStickTrigger(slot0, slot0.joyStick, function ()
		if slot0.attackCnt <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_hit_monster_nocount"))

			return false
		end

		if slot0.hp <= 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("activity_hit_monster_reset_tip"),
				onYes = function ()
					slot0.controller:ReStartGame()
				end
			})

			return false
		end

		return true
	end, function (slot0)
		if slot0 > 0 then
			slot0.controller:Input(BeatMonsterNianConst.ACTION_NAME_R)
		elseif slot0 < 0 then
			slot0.controller:Input(BeatMonsterNianConst.ACTION_NAME_L)
		end
	end)
end

slot0.OnAttackCntUpdate = function (slot0, slot1, slot2)
	slot0.attackCnt = slot1
	slot0.attackCntTF.text = (slot2 and "-") or slot1
end

slot0.OnMonsterHpUpdate = function (slot0, slot1)
	slot0.hp = slot1

	slot0.fuShun:SetInteger("hp", slot1)
	slot0.nian:SetInteger("hp", slot1)
end

slot0.OnUIHpUpdate = function (slot0, slot1, slot2, slot3)
	LeanTween.value(slot0.hpTF.gameObject, slot4, slot5, 0.3):setOnUpdate(System.Action_float(function (slot0)
		slot0.hpTF.value = slot0
	end)).setOnComplete(slot6, System.Action(function ()
		if slot0 then
			slot0()
		end
	end))
end

slot0.OnAddFuShun = function (slot0, slot1)
	slot0.fuShun = slot0.fushun:GetComponent(typeof(Animator))

	slot0.fuShun:SetInteger("hp", slot1)
end

slot0.OnAddMonsterNian = function (slot0, slot1, slot2)
	slot0.hp = slot1
	slot0.nian = slot0.monsterNian:GetComponent(typeof(Animator))
	slot0.hpTF.value = slot1 / slot2

	slot0.nian:SetInteger("hp", slot1)
end

slot0.OnChangeFuShunAction = function (slot0, slot1)
	slot0.fuShun:SetTrigger(slot1)
end

slot0.OnChangeNianAction = function (slot0, slot1)
	slot0.nian:SetTrigger(slot1)
end

slot0.BanJoyStick = function (slot0, slot1)
	setActive(slot0.joyStick:Find("ban"), slot1)

	GetOrAddComponent(slot0.joyStick, typeof(EventTriggerListener)).enabled = not slot1
end

slot0.OnInputChange = function (slot0, slot1)
	if slot1 and slot1 ~= "" then
		for slot6, slot7 in ipairs(slot0.actionKeys) do
			setActive(slot7:Find("A"), (string.sub(slot1, slot6, slot6) or "") == BeatMonsterNianConst.ACTION_NAME_A)
			setActive(slot7:Find("L"), (string.sub(slot1, slot6, slot6) or "") == BeatMonsterNianConst.ACTION_NAME_L)
			setActive(slot7:Find("R"), (string.sub(slot1, slot6, slot6) or "") == BeatMonsterNianConst.ACTION_NAME_R)
			setActive(slot7:Find("B"), (string.sub(slot1, slot6, slot6) or "") == BeatMonsterNianConst.ACTION_NAME_B)
		end
	end

	setActive(slot0.actions, slot2)
	slot0:BanJoyStick(#slot1 == 2)
end

slot0.PlayStory = function (slot0, slot1, slot2)
	pg.NewStoryMgr.GetInstance():Play(slot1, slot2)
end

slot0.DisplayAwards = function (slot0, slot1, slot2)
	pg.m02:sendNotification(ActivityProxy.ACTIVITY_SHOW_AWARDS, {
		awards = slot1,
		callback = slot2
	})
end

slot0.Dispose = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
end

slot0.OnTrigger = function (slot0, slot1, slot2, slot3)
	slot4 = slot1:Find("off")
	slot5 = true
	slot6 = GetOrAddComponent(slot1, typeof(EventTriggerListener))

	slot6:AddPointDownFunc(function (slot0, slot1)
		if slot1() then
			setActive(setActive, false)
		end
	end)
	slot6.AddPointUpFunc(slot6, function (slot0, slot1)
		if slot0 then
			setActive(slot1, true)

			if setActive then
				slot2()
			end
		end
	end)
end

slot0.OnJoyStickTrigger = function (slot0, slot1, slot2, slot3)
	slot4 = slot1:Find("m")
	slot5 = slot1:Find("l")
	slot6 = slot1:Find("r")
	slot7 = GetOrAddComponent(slot1, typeof(EventTriggerListener))
	slot8 = nil
	slot9 = false

	slot7:AddBeginDragFunc(function (slot0, slot1)
		slot0 = slot1()
		slot2 = slot1.position
	end)
	slot7.AddDragFunc(slot7, function (slot0, slot1)
		if not slot0 then
			return
		end

		setActive(slot1.position.x - slot1.x, slot1.position.x - slot1.x == 0)
		setActive(setActive, slot2 < 0)
		setActive(setActive, slot2 > 0)
	end)
	slot7.AddDragEndFunc(slot7, function (slot0, slot1)
		if not slot0 then
			return
		end

		slot2(slot2)
		setActive(setActive, true)
		setActive(setActive, false)
		setActive(false, false)
	end)
end

slot0.findTF = function (slot0, slot1, slot2)
	return findTF(slot2 or slot0._tf, slot1)
end

return slot0

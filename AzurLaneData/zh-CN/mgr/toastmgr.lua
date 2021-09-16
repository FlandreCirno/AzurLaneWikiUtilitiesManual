pg = pg or {}
pg.ToastMgr = singletonClass("ToastMgr")
slot1 = require("Mgr/Pool/PoolPlural")
pg.ToastMgr.TYPE_ATTIRE = "Attire"
pg.ToastMgr.TYPE_TECPOINT = "Tecpoint"
pg.ToastMgr.TYPE_TROPHY = "Trophy"
pg.ToastMgr.TYPE_META = "Meta"
pg.ToastMgr.ToastInfo = {
	[pg.ToastMgr.TYPE_ATTIRE] = {
		Attire = "attire_tpl"
	},
	[pg.ToastMgr.TYPE_TECPOINT] = {
		Buff = "buff_tpl",
		Point = "point_tpl"
	},
	[pg.ToastMgr.TYPE_TROPHY] = {
		Trophy = "trophy_tpl"
	},
	[pg.ToastMgr.TYPE_META] = {
		MetaLevel = "meta_level_tpl",
		MetaExp = "meta_exp_tpl"
	}
}

pg.ToastMgr.Init = function (slot0, slot1)
	PoolMgr.GetInstance():GetUI("ToastUI", true, function (slot0)
		slot0._go = slot0

		slot0._go:SetActive(false)

		slot0._tf = slot0._go.transform
		slot0.container = slot0._tf:Find("container")

		slot0._go.transform:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		slot0.pools = {}

		for slot5, slot6 in pairs(slot1.ToastInfo) do
			for slot10, slot11 in pairs(slot6) do
				slot1[slot10 .. "Tpl"] = slot11
			end
		end

		for slot5, slot6 in pairs(slot1) do
			slot7 = slot0._tf:Find("resources/" .. slot6)

			if slot6 == "meta_exp_tpl" then
				setText(slot8, i18n("meta_toast_fullexp"))
				setText(slot7:Find("ExpAdd/Tip"), i18n("meta_toast_tactics"))
			end

			setActive(slot7, false)

			slot0.pools[slot5] = slot2.New(slot7.gameObject, 5)
		end

		slot0:ResetUIDandHistory()

		if slot0 then
			slot3()
		end
	end)
end

pg.ToastMgr.ResetUIDandHistory = function (slot0)
	slot0.completedJob = 0
	slot0.actionJob = 0
	slot0.buffer = {}
end

pg.ToastMgr.ShowToast = function (slot0, slot1, slot2)
	slot3 = #slot0.buffer

	table.insert(slot0.buffer, {
		state = 0,
		type = slot1,
		info = slot2
	})
	setActive(slot0._tf, true)

	if #slot0.buffer == 1 or slot0.buffer[slot3].state >= 2 then
		slot0:Toast()
	end
end

pg.ToastMgr.Toast = function (slot0)
	if slot0.actionJob >= #slot0.buffer then
		return
	end

	if slot0.buffer[slot0.actionJob] and slot0.buffer[slot0.actionJob].state < 2 then
		return
	elseif slot0.buffer[slot0.actionJob] and slot0.buffer[slot0.actionJob].type ~= slot0.buffer[slot0.actionJob + 1].type and slot0.buffer[slot0.actionJob].state < 3 then
		return
	end

	slot0.actionJob = slot0.actionJob + 1
	slot2 = slot0.actionJob
	slot0.buffer[slot0.actionJob].state = 1

	slot0["Update" .. slot0.buffer[slot0.actionJob].type](slot0, slot0.buffer[slot0.actionJob], function ()
		slot0.state = 2

		2:Toast()
	end, function ()
		slot0.state = 3

		if slot1.buffer[slot2 + 1] and slot1.buffer[slot2 + 1].state < 1 then
			slot1:Toast()
		end

		slot1.completedJob = slot1.completedJob + 1

		if slot1.completedJob >= #slot1.completedJob + 1.buffer then
			slot1:ResetUIDandHistory()
			setActive(slot1._tf, false)

			for slot3, slot4 in pairs(slot1._tf.pools) do
				slot4:ClearItems(false)
			end
		end
	end)
end

pg.ToastMgr.GetAndSet = function (slot0, slot1, slot2)
	slot3 = slot0.pools[slot1 .. "Tpl"]:Dequeue()

	setActive(slot3, true)
	setParent(slot3, slot2)
	slot3.transform:SetAsLastSibling()

	return slot3
end

pg.ToastMgr.UpdateAttire = function (slot0, slot1, slot2, slot3)
	slot4 = slot0:GetAndSet(slot1.type, slot0.container)
	slot5 = slot4:GetComponent(typeof(DftAniEvent))

	slot5:SetTriggerEvent(function (slot0)
		if slot0 then
			slot0()
		end

		slot1:SetTriggerEvent(nil)
	end)
	slot5.SetEndEvent(slot5, function (slot0)
		setActive(slot0, false)
		setActive.pools[slot0.type .. "Tpl"]:Enqueue(slot0)
		slot3:SetEndEvent(nil)

		if slot4 then
			slot4()
		end
	end)
	slot4.GetComponent(slot4, typeof(Animation)):Play("attire")
	setActive(slot4.transform:Find("bg/icon_frame"), slot1.info.getType(slot6) == AttireConst.TYPE_ICON_FRAME)
	setActive(slot4.transform:Find("bg/chat_frame"), slot7 == AttireConst.TYPE_CHAT_FRAME)
	setText(slot4.transform:Find("bg/Text"), slot6:getConfig("name"))
end

pg.ToastMgr.FADE_TIME = 0.4
pg.ToastMgr.FADE_OUT_TIME = 1
pg.ToastMgr.SHOW_TIME = 1.5
pg.ToastMgr.DELAY_TIME = 0.3

pg.ToastMgr.UpdateTecpoint = function (slot0, slot1, slot2, slot3)
	slot7 = slot1.info.attr
	slot8 = slot1.info.value
	GetComponent(slot0:GetAndSet("Point", slot0.container).transform, "CanvasGroup").alpha = 0

	setText(findTF(slot9, "PointText"), "+" .. slot1.info.point)

	slot10 = {}

	if slot1.info.typeList then
		for slot14 = 1, #slot6, 1 do
			slot15 = slot0:GetAndSet("Buff", slot0.container)
			GetComponent(slot15.transform, "CanvasGroup").alpha = 0

			setImageSprite(slot15.transform:Find("TypeImg").transform, slot20)
			setText(slot15.transform:Find("AttrText").transform, AttributeType.Type2Name(pg.attribute_info_by_type[slot7].name))
			setText(slot15.transform:Find("ValueText").transform, "+" .. slot8)

			slot10[slot14] = go(slot15)
		end
	end

	function slot11()
		if slot0 then
			slot0()
		end

		if slot1 then
			slot1()
		end
	end

	slot12 = go(slot9)
	slot13 = GetComponent(slot9, "CanvasGroup")

	function slot15()
		LeanTween.moveX(rtf(slot0), 0, slot1.FADE_OUT_TIME)
		LeanTween.value(LeanTween.value, 1, 0, slot1.FADE_OUT_TIME):setOnUpdate(System.Action_float(System.Action_float)):setOnComplete(System.Action(function ()
			setActive(setActive, false)
			slot1.pools.PointTpl:Enqueue(slot1.pools.PointTpl.Enqueue)

			if not slot1.pools.PointTpl.Enqueue then
				slot3()
			end
		end))
	end

	LeanTween.value(slot12, 0, 1, slot0.FADE_TIME):setOnUpdate(System.Action_float(slot14)):setOnComplete(System.Action(function ()
		LeanTween.delayedCall(LeanTween.delayedCall, slot1.SHOW_TIME, System.Action(slot1.SHOW_TIME))
	end))

	function slot16(slot0, slot1, slot2)
		slot3 = GetComponent(slot0.transform, "CanvasGroup")

		function slot5()
			LeanTween.moveX(rtf(slot0), 0, slot1.FADE_OUT_TIME)
			LeanTween.value(LeanTween.value, 1, 0, slot1.FADE_OUT_TIME):setOnUpdate(System.Action_float(System.Action_float)):setOnComplete(System.Action(function ()
				setActive(setActive, false)
				slot1.pools.BuffTpl:Enqueue(slot1.pools.BuffTpl.Enqueue)

				if slot1.pools.BuffTpl.Enqueue then
					slot3()
				end
			end))
		end

		LeanTween.value(slot0, 0, 1, slot0.FADE_TIME):setOnUpdate(System.Action_float(slot4)):setOnComplete(System.Action(function ()
			LeanTween.delayedCall(LeanTween.delayedCall, slot1.SHOW_TIME + (slot1.FADE_OUT_TIME - slot1.DELAY_TIME) * slot1.SHOW_TIME, System.Action(System.Action))
		end))
	end

	for slot20, slot21 in ipairs(slot10) do
		LeanTween.delayedCall(slot12, slot20 * slot0.DELAY_TIME, System.Action(function ()
			slot0(slot1, slot2, slot2 == #slot3)
		end))
	end
end

pg.ToastMgr.UpdateTrophy = function (slot0, slot1, slot2, slot3)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot1.info.sound or SFX_UI_TIP)

	slot4 = slot0:GetAndSet(slot1.type, slot0.container)

	LoadImageSpriteAsync("medal/s_" .. pg.medal_template[slot1.info.id].icon, slot4.transform:Find("content/icon"), true)
	setText(slot4.transform:Find("content/name"), pg.medal_template[slot1.info.id].name)
	setText(slot4.transform:Find("content/label"), i18n("trophy_achieved"))

	slot6 = slot4.transform:Find("content")
	slot6.anchoredPosition = Vector2(-550, 0)

	LeanTween.moveX(rtf(slot6), 0, 0.5)
	LeanTween.moveX(rtf(slot6), -550, 0.5):setDelay(5):setOnComplete(System.Action(function ()
		setActive(setActive, false)
		slot1.pools[slot2.type .. "Tpl"]:Enqueue(slot1.pools[slot2.type .. "Tpl"].Enqueue)

		if slot3 then
			slot3()
		end
	end))

	if slot2 then
		slot2()
	end
end

pg.ToastMgr.UpdateMeta = function (slot0, slot1, slot2, slot3)
	slot8 = slot0:GetAndSet("MetaLevel", slot0.container)
	slot15, slot16 = MetaCharacterConst.GetMetaCharacterToastPath(slot6)

	setImageSprite(slot9, LoadSprite(slot10, slot11))

	slot15 = slot1.info.addDayExp
	slot16 = pg.gameset.meta_skill_exp_max.key_value <= slot1.info.newDayExp

	setSlider(slot0:GetAndSet("MetaExp", slot0.container).transform:Find("Progress"), 0, slot13, slot14)

	slot17 = slot4.curSkillID
	slot20 = slot4.oldSkillLevel < slot4.newSkillLevel
	slot21 = slot7.transform:Find("ExpFull")
	slot22 = slot7.transform:Find("ExpAdd")

	if slot16 then
		setActive(slot21, true)
		setActive(slot22, false)
	else
		setText(slot23, string.format("+%d", slot15))
		setActive(slot21, false)
		setActive(slot22, slot20)
	end

	if slot20 then
		setImageSprite(slot23, LoadSprite("skillicon/" .. getSkillConfig(slot17).icon))

		slot25 = slot8.transform:Find("LevelUp")
		slot26 = slot8.transform:Find("LevelMax")
		slot28 = pg.skill_data_template[slot17].max_level <= slot19

		if slot28 then
			setActive(slot25, false)
			setActive(slot26, true)
		else
			setText(slot29, string.format("+%d", slot19 - slot18))
			setActive(slot25, true)
			setActive(slot26, false)
		end
	end

	function slot23()
		if slot0 then
			slot0()
		end

		if slot1 then
			slot1()
		end
	end

	GetComponent(slot7, "CanvasGroup").alpha = 0
	GetComponent(slot8, "CanvasGroup").alpha = 0
	slot26 = slot16 or slot20

	if slot26 then
		function slot28()
			LeanTween.moveX(rtf(slot0.transform), 0, slot1.FADE_OUT_TIME)
			LeanTween.value(LeanTween.value, 1, 0, slot1.FADE_OUT_TIME):setOnUpdate(System.Action_float(System.Action_float)):setOnComplete(System.Action(function ()
				slot0.pools.MetaExpTpl:Enqueue(slot0.pools.MetaExpTpl)

				if not slot0.pools.MetaExpTpl then
					slot0.pools.MetaLevelTpl:Enqueue(slot3)
					slot4()
				end
			end))
		end

		LeanTween.value(slot7, 0, 1, slot0.FADE_TIME):setOnUpdate(System.Action_float(slot27)):setOnComplete(System.Action(function ()
			LeanTween.delayedCall(LeanTween.delayedCall, slot1.SHOW_TIME, System.Action(slot1.SHOW_TIME))
		end))
	end

	if slot20 then
		function slot27(slot0)
			slot0.alpha = slot0
		end

		function slot28()
			LeanTween.moveX(rtf(slot0.transform), 0, slot1.FADE_OUT_TIME)
			LeanTween.value(LeanTween.value, 1, 0, slot1.FADE_OUT_TIME):setOnUpdate(System.Action_float(System.Action_float)):setOnComplete(System.Action(function ()
				slot0.pools.MetaLevelTpl:Enqueue(slot0.pools.MetaLevelTpl)
				slot0.pools.MetaLevelTpl()
			end))
		end

		function slot29()
			LeanTween.delayedCall(LeanTween.delayedCall, slot1.SHOW_TIME, System.Action(slot1.SHOW_TIME))
		end

		LeanTween.delayedCall(slot8, slot0.DELAY_TIME, System.Action(function ()
			LeanTween.value(LeanTween.value, 0, 1, slot1.FADE_TIME):setOnUpdate(System.Action_float(System.Action_float)):setOnComplete(System.Action(System.Action_float))
		end))
	end
end

pg.ToastMgr.Dispose = function (slot0)
	setActive(slot0._tf, false)
	slot0:ResetUIDandHistory()

	for slot4, slot5 in pairs(slot0.pools) do
		slot5:Clear(false)
	end
end

return

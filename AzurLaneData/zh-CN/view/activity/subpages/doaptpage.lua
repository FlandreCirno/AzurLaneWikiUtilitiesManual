slot0 = class("DOAPtPage", import(".TemplatePage.PtTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.buffModule = slot0:findTF("buff_module", slot0.bg)
	slot0.buffPanel = slot0:findTF("skill", slot0.buffModule)
	slot0.buffLvs = {}

	eachChild(slot0.buffPanel, function (slot0)
		table.insert(slot0.buffLvs, slot0)
	end)

	slot0.getGreyBtn = slot0.findTF(slot0, "get_grey_btn", slot0.bg)
	slot0.helpBtn = slot0:findTF("help_btn", slot0.bg)
	slot0.levelPanel = slot0:findTF("level", slot0.buffModule)
	slot0.f2aPanel = slot0:findTF("f_to_a", slot0.levelPanel)
	slot0.sPanel = slot0:findTF("s_ss", slot0.levelPanel)
	slot0.sssPanel = slot0:findTF("sss", slot0.levelPanel)
	slot0.lvBarImages = slot0:findTF("lv_bars", slot0.bg)
	slot0.lvTagImages = slot0:findTF("lv_tags", slot0.bg)
	slot0.shieldEffect = slot0:findTF("level/shield_effect", slot0.buffModule)
	slot0.starEffect = slot0:findTF("level/star_effect", slot0.buffModule)
	slot0.mask = slot0:findTF("mask", slot0.bg)
	slot0.trainWindow = slot0:findTF("TrainWindow")
	slot0.trainBtn = slot0:findTF("panel/train_btn", slot0.trainWindow)
	slot0.trainSkills = slot0:findTF("panel/skills", slot0.trainWindow)
	slot0.trainSkillBtns = {}

	eachChild(slot0.trainSkills, function (slot0)
		table.insert(slot0.trainSkillBtns, slot0)
	end)

	slot0.curInfoPanel = slot0.findTF(slot0, "panel/info_bg", slot0.trainWindow)
	slot0.curInfo = slot0:findTF("panel/info_bg/cur", slot0.trainWindow)
	slot0.nextInfo = slot0:findTF("panel/info_bg/next", slot0.trainWindow)
	slot0.msgBox = slot0:findTF("MsgBox")
	slot0.msgContent = slot0:findTF("panel/content", slot0.msgBox)
	slot0.msgBoxMask = slot0:findTF("mengban", slot0.msgBox)
	slot0.cancelBtn = slot0:findTF("panel/cancel_btn", slot0.msgBox)
	slot0.confirmBtn = slot0:findTF("panel/confirm_btn", slot0.msgBox)
	slot0.tipPanel = slot0:findTF("Tip")
	slot0.buffBox = slot0:findTF("BuffBox")
	slot0.buffMask = slot0:findTF("mask", slot0.buffBox)
	slot0.buffIconParent = slot0:findTF("window/panel/icon", slot0.buffBox)
	slot0.buffDescContent = slot0:findTF("window/panel/intro_view/Viewport/Content", slot0.buffBox)
	slot0.buffDescTpl = slot0:findTF("window/panel/intro_view/buff_desc_tpl", slot0.buffBox)
	slot0.singleBuffBox = slot0:findTF("SingleBuffBox")
	slot0.singleBuffMask = slot0:findTF("bg", slot0.singleBuffBox)
	slot0.singleSureBtn = slot0:findTF("window/top/btnBack", slot0.singleBuffBox)
	slot0.singleCloseBtn = slot0:findTF("window/sure_btn", slot0.singleBuffBox)
	slot0.singleIconParent = slot0:findTF("window/panel/icon", slot0.singleBuffBox)
	slot0.singleDescContent = slot0:findTF("window/panel/intro_view/Viewport/Content", slot0.singleBuffBox)
	slot0.singleDescTpl = slot0:findTF("window/panel/intro_view/buff_desc_tpl", slot0.singleBuffBox)
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	setActive(slot0.bg, true)
	removeOnButton(slot0.getBtn)
	onButton(slot0, slot0.getBtn, function ()
		slot3 = getProxy(PlayerProxy).getData(slot2)

		if slot0.ptData:GetAward().type == DROP_TYPE_RESOURCE and slot1.id == PlayerConst.ResGold and slot3:GoldMax(slot1.count) then
			table.insert(slot0, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("gold_max_tip_title") .. i18n("award_max_warning"),
					onYes = slot0
				})
			end)
		end

		seriesAsync(slot0, function ()
			slot0.isShowEffect = true
			slot2, slot7.arg1 = slot0.ptData:CanTrain() and slot0.ptData:isInBuffTime().ptData.GetResProgress(slot2)

			slot0.ptData.CanTrain() and slot0.ptData.isInBuffTime():emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = slot0.ptData.CanTrain() and slot0.ptData.isInBuffTime().ptData:GetId(),
				arg1 = slot3,
				callback = function ()
					if slot0 then
						slot1:showUpEffect()
					else
						slot1:updateLevelPanel()
					end
				end
			})
		end)
	end, SFX_PANEL)
	removeOnButton(slot0.battleBtn)
	onButton(slot0, slot0.battleBtn, function ()
		slot2, slot1 = nil

		if slot0.activity:getConfig("config_client") ~= "" and slot0.activity:getConfig("config_client").linkActID then
			slot1 = getProxy(ActivityProxy):getActivityById(slot0)
		end

		if not slot0 then
			slot0:emit(ActivityMediator.BATTLE_OPERA)
		elseif slot1 and not slot1:isEnd() then
			slot0:emit(ActivityMediator.BATTLE_OPERA)
		else
			slot0:showTip(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("doa_pt_help")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.buffModule, function ()
		slot0:showBuffBox()
	end, SFX_PANEL)

	if slot0.contextData.singleActivity then
		setActive(slot0.bg, false)
		slot0.showSingleBuffBox(slot0)
	end

	slot0.starEffect:GetComponent("DftAniEvent"):SetEndEvent(function ()
		slot0:updateLevelPanel()
		slot0.updateLevelPanel:managedTween(LeanTween.delayedCall, function ()
			slot0:showTrianPanel()
			setActive(slot0.starEffect, false)
			setActive(slot0.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(slot0.mask, slot0.bg)
		end, 0.2, nil)
	end)
	slot0.shieldEffect.GetComponent(slot1, "DftAniEvent"):SetEndEvent(function ()
		slot0:updateLevelPanel()
		slot0.updateLevelPanel:managedTween(LeanTween.delayedCall, function ()
			slot0:showTrianPanel()
			setActive(slot0.starEffect, false)
			setActive(slot0.mask, false)
			pg.UIMgr.GetInstance():UnOverlayPanel(slot0.mask, slot0.bg)
		end, 0.2, nil)
	end)

	slot0.isShowEffect = false
end

slot0.showUpEffect = function (slot0, slot1)
	setSlider(slot0.curPanel, 0, 1, 1)

	if slot0.ptData:GetBuffLevelProgress() == 8 or slot2 == 9 then
		setActive(slot0.starEffect, true)
		slot0.starEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	else
		setActive(slot0.shieldEffect, true)
		slot0.shieldEffect:GetComponent("Animator"):Play("saoguang_anim", -1, 0)
	end

	setActive(slot0.mask, true)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.mask)
end

slot0.updateLevelPanel = function (slot0)
	slot1, slot2 = slot0.ptData:GetBuffLevelProgress()

	setActive(slot0.f2aPanel, false)
	setActive(slot0.sPanel, false)
	setActive(slot0.sssPanel, false)

	slot0.curPanel = nil

	if slot1 == 9 then
		slot0.curPanel = slot0.sssPanel
	elseif slot1 > 6 then
		slot0.curPanel = slot0.sPanel
	else
		slot0.curPanel = slot0.f2aPanel
	end

	setActive(slot0.curPanel, true)
	setImageSprite(slot0:findTF("bar", slot0.curPanel), slot0.lvBarImages:Find(slot1):GetComponent(typeof(Image)).sprite)
	setImageSprite(slot0:findTF("lv_tag", slot0.curPanel), slot0.lvTagImages:Find(slot1):GetComponent(typeof(Image)).sprite, true)
	setSlider(slot0.curPanel, 0, 1, slot2)

	return slot0.curPanel
end

slot0.OnUpdateFlush = function (slot0)
	setActive(slot0.starEffect, false)
	setActive(slot0.shieldEffect, false)

	if slot0.ptData:CanTrain() and slot1 <= slot0.ptData.level and slot0.ptData:isInBuffTime() and not slot0.contextData.singleActivity and not slot0.isShowEffect then
		slot0:showTrianPanel()
	end

	slot10, slot12, slot4 = slot0.ptData:GetLevelProgress()
	slot5, slot6, slot7 = slot0.ptData:GetResProgress()

	setText(slot0.step, slot2 .. "/" .. slot3)
	setText(slot0.progress, ((slot7 >= 1 and setColorStr(slot5, COLOR_GREEN)) or slot5) .. "/" .. slot6)
	setSlider(slot0.slider, 0, 1, slot7)

	if not slot0.isShowEffect then
		slot0:updateLevelPanel()
	end

	slot8 = slot0.ptData:CanGetAward()

	setActive(slot0.battleBtn, slot0.ptData:CanGetMorePt() and not slot8 and slot0.ptData:CanGetNextAward())
	setActive(slot0.getBtn, slot8)
	setActive(slot0.getGreyBtn, not slot8)
	setActive(slot0.gotBtn, not slot0.ptData.CanGetNextAward() and not slot0.ptData:CanTrain())
	setActive(slot0.buffModule, slot0.ptData:isInBuffTime())
	updateDrop(slot0.awardTF, setActive)
	onButton(slot0, slot0.awardTF, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)

	for slot16, slot17 in ipairs(slot0.ptData.GetCurBuffInfos(slot14)) do
		setText(slot0.buffLvs[slot17.group], (slot17.next and "LV." .. slot17.lv) or "MAX")
	end
end

slot0.showTrianPanel = function (slot0)
	setActive(slot0.trainWindow, true)

	slot1 = slot0.ptData:GetCurBuffInfos()
	slot0.selectIndex = nil
	slot0.selectBuffId = nil
	slot0.selectBuffLv = nil
	slot0.selectNewBuffId = nil

	for slot5, slot6 in ipairs(slot0.trainSkillBtns) do
		onButton(slot0, slot6, function ()
			for slot3, slot4 in ipairs(ipairs) do
				if slot1 == slot4.group then
					if slot4.next then
						slot2.selectIndex = slot1
						slot2.selectBuffId = slot4.id
						slot2.selectNewBuffId = slot4.next
						slot2.selectBuffLv = slot4.lv
					else
						slot2.selectIndex = nil
						slot2.selectBuffId = nil
						slot2.selectNewBuffId = nil
						slot2.selectBuffLv = nil
					end
				end
			end

			slot2:flushTrainPanel()
		end, SFX_PANEL)
	end

	onButton(slot0, slot0.trainBtn, function ()
		slot0:showMsgBox()
	end, SFX_PANEL)

	function slot2()
		for slot3, slot4 in ipairs(ipairs) do
			if slot4.next then
				slot1.selectIndex = slot4.group
				slot1.selectBuffId = slot4.id
				slot1.selectNewBuffId = slot4.next
				slot1.selectBuffLv = slot4.lv

				return
			end
		end
	end

	slot2()
	slot0:flushTrainPanel()
end

slot0.hideTrianPanel = function (slot0)
	setActive(slot0.trainWindow, false)
end

slot0.flushTrainPanel = function (slot0)
	if slot0.ptData:GetCurBuffInfos() then
		for slot5, slot6 in ipairs(slot1) do
			setText(slot0:findTF("lv_bg/lv", slot0.trainSkillBtns[slot6.group]), (slot6.next and "LV." .. slot6.lv) or "MAX")
		end
	end

	for slot5, slot6 in ipairs(slot0.trainSkillBtns) do
		if slot5 == slot0.selectIndex then
			setActive(slot0:findTF("selected", slot6), true)
		else
			setActive(slot0:findTF("selected", slot6), false)
		end
	end

	if slot0.selectIndex then
		setActive(slot0.curInfoPanel, true)
		setActive(slot0.trainBtn, true)
		setText(slot0.curInfo, pg.benefit_buff_template[slot0.selectBuffId].desc)
		setText(slot0.nextInfo, pg.benefit_buff_template[slot0.selectNewBuffId].desc)
	else
		setActive(slot0.curInfoPanel, false)
		setActive(slot0.trainBtn, false)
	end
end

slot0.getBuffNameIndex = function (slot0, slot1)
	if slot1 == 35 or slot1 == 36 or slot1 == 37 then
		return 1
	elseif slot1 == 38 or slot1 == 39 or slot1 == 40 then
		return 2
	elseif slot1 == 41 or slot1 == 42 or slot1 == 43 then
		return 3
	elseif slot1 == 44 or slot1 == 45 or slot1 == 46 then
		return 4
	end

	return 1
end

slot0.getTip = function (slot0, slot1)
	if slot1 == 35 or slot1 == 36 or slot1 == 37 then
		return i18n("doa_liliang")
	elseif slot1 == 38 or slot1 == 39 or slot1 == 40 then
		return i18n("doa_jiqiao")
	elseif slot1 == 41 or slot1 == 42 or slot1 == 43 then
		return i18n("doa_tili")
	elseif slot1 == 44 or slot1 == 45 or slot1 == 46 then
		return i18n("doa_meili")
	end

	return ""
end

slot0.showMsgBox = function (slot0)
	if slot0.selectBuffId then
		setActive(slot0.msgBox, true)
		setText(slot0.msgContent, i18n("doa_pt_up", slot0:getTip(pg.benefit_buff_template[slot0.selectBuffId].id)))
		onButton(slot0, slot0.msgBoxMask, function ()
			slot0:hideMsgBox()
		end, SFX_PANEL)
		onButton(slot0, slot0.cancelBtn, function ()
			slot0:hideMsgBox()
		end, SFX_PANEL)
		onButton(slot0, slot0.confirmBtn, function ()
			slot0:hideMsgBox()
			slot0.hideMsgBox:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 3,
				activity_id = slot0.ptData:GetId(),
				arg1 = slot0.ptData:CanTrain(),
				arg2 = slot0.selectNewBuffId,
				oldBuffId = slot0.selectBuffId
			})
			slot0.hideMsgBox.emit:hideTrianPanel()
			slot0.hideMsgBox.emit.hideTrianPanel:showTip(i18n("doa_pt_complete"))
		end, SFX_PANEL)
	end
end

slot0.hideMsgBox = function (slot0)
	setActive(slot0.msgBox, false)
end

slot0.showTip = function (slot0, slot1)
	slot2 = cloneTplTo(slot0.tipPanel, slot0._tf)

	setActive(slot2, true)
	setText(slot0:findTF("Text", slot2), slot1)

	slot2.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(slot2, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(slot2, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	slot3 = GetOrAddComponent(slot2, "CanvasGroup")

	Timer.New(function ()
		if IsNil(IsNil) then
			return
		end

		LeanTween.scale(LeanTween.scale, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function ()
			LeanTween.scale(LeanTween.scale, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function ()
				Destroy(Destroy)
			end))
		end))
	end, 3).Start(slot4)
end

slot0.showBuffBox = function (slot0)
	setActive(slot0.buffBox, true)
	removeAllChildren(slot0.buffIconParent)
	setLocalPosition(slot1, Vector3(0, 0, 0))
	setLocalScale(slot1, Vector3(1.3, 1.3, 1))

	if slot0.ptData:GetCurBuffInfos() then
		for slot6, slot7 in ipairs(slot2) do
			slot8 = nil

			setText((slot6 > slot0.buffDescContent.childCount or slot0.buffDescContent:GetChild(slot6 - 1)) and cloneTplTo(slot0.buffDescTpl, slot0.buffDescContent), pg.benefit_buff_template[slot7.id].name .. pg.benefit_buff_template[slot7.id].desc)
		end
	end

	onButton(slot0, slot0.buffMask, function ()
		setActive(slot0.buffBox, false)
	end, SFX_PANEL)
end

slot0.showSingleBuffBox = function (slot0)
	setActive(slot0.singleBuffBox, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.singleBuffBox)
	removeAllChildren(slot0.singleIconParent)
	setLocalPosition(slot1, Vector3(0, 0, 0))
	setLocalScale(slot1, Vector3(1.3, 1.3, 1))

	if slot0.ptData:GetCurBuffInfos() then
		for slot6, slot7 in ipairs(slot2) do
			slot8 = nil

			setText((slot6 > slot0.singleDescContent.childCount or slot0.singleDescContent:GetChild(slot6 - 1)) and cloneTplTo(slot0.singleDescTpl, slot0.singleDescContent), pg.benefit_buff_template[slot7.id].name .. pg.benefit_buff_template[slot7.id].desc)
		end
	end

	function slot3()
		setActive(slot0.singleBuffBox, false)
		setActive:emit(ActivitySingleScene.EXIT)
		setActive.emit:emit(ActivitySingleScene.ON_CLOSE)
		pg.UIMgr.GetInstance():UnblurPanel(slot0.singleBuffBox, slot0._tf)
	end

	onButton(slot0, slot0.singleBuffMask, function ()
		slot0()
	end, SFX_PANEL)
	onButton(slot0, slot0.singleCloseBtn, function ()
		slot0()
	end, SFX_PANEL)
	onButton(slot0, slot0.singleSureBtn, function ()
		slot0()
	end, SFX_PANEL)
end

slot0.onBackPressed = function (slot0)
	if slot0.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.singleBuffBox, slot0._tf)
	end
end

slot0.willExit = function (slot0)
	if slot0.contextData.singleActivity then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.singleBuffBox, slot0._tf)
	end
end

return slot0

slot0 = class("NavalTacticsLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "NavalTacticsUI"
end

slot0.setShips = function (slot0, slot1)
	slot0.shipVOs = slot1
end

slot0.setSKillClassNum = function (slot0, slot1)
	slot0.skillClassNum = slot1
end

slot0.setStudents = function (slot0, slot1)
	slot0.studentVOs = slot1
end

slot0.setPlayer = function (slot0, slot1)
	slot0.playerVO = slot1
end

slot0.setItemVOs = function (slot0, slot1)
	slot0.itemVOs = slot1 or {}

	table.sort(slot0.itemVOs, function (slot0, slot1)
		if slot0:getConfig("rarity") == slot1:getConfig("rarity") then
			return slot0.id < slot1.id
		else
			return slot3 < slot2
		end
	end)
end

slot0.updateShipVO = function (slot0, slot1)
	slot0.shipVOs[slot1.id] = slot1
end

slot0.init = function (slot0)
	slot0.shipCards = {}
	slot0.backBtn = slot0:findTF("blur_container/adapt/top/btnBack")
	slot0.mainPanel = slot0:findTF("mainPanel")

	setActive(slot0.mainPanel, true)

	slot0.helpBtn = slot0:findTF("paint/help_btn", slot0.mainPanel)
	slot0.UIMgr = pg.UIMgr.GetInstance()
	slot0.studentContain = slot0:findTF("students/contain/content", slot0.mainPanel)
	slot0.skillsPanel = slot0:findTF("blurOther/skillsPanel/frame")
	slot0.skillsMask = slot0:findTF("blurOther/skillsPanel")
	slot0.skillSelBtn = slot0:findTF("confirm_btn", slot0.skillsPanel)
	slot0.skillContent = slot0:findTF("skill_contain/content", slot0.skillsPanel)
	slot0.lessonPanel = slot0:findTF("blurOther/lessonPanel/frame")
	slot0.lessonMask = slot0:findTF("blurOther/lessonPanel")
	slot0.lessonSelBtn = slot0:findTF("confirm_btn", slot0.lessonPanel)
	slot0.lessonCancelBtn = slot0:findTF("cancel_btn", slot0.lessonPanel)
	slot0.lessonContent = slot0:findTF("bg/lessons/content", slot0.lessonPanel)
	slot0.tpl = slot0:getTpl("student", slot0.studentContain)
	slot0.UIMain = GameObject.Find("/OverlayCamera/Overlay/UIMain")
	slot0.nameTxts = {}
	slot0.deleteStuentQueue = {}
	slot0.blurPanelTF = slot0:findTF("blurOther")
end

slot0.didEnter = function (slot0)
	slot0.lessonOverTimer = {}

	onButton(slot0, slot0.backBtn, function ()
		slot0:closeView()
	end, SFX_CANCEL)
	setActive(slot0.findTF(slot0, "stamp", slot0.mainPanel), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(slot0:findTF("stamp", slot0.mainPanel), false)
	end

	onButton(slot0, slot0:findTF("stamp", slot0.mainPanel), function ()
		getProxy(TaskProxy):dealMingshiTouchFlag(3)
	end, SFX_CONFIRM)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tactics_lesson_system_introduce.tip
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.lessonCancelBtn, function ()
		slot0:closeLessonSel()
		slot0.closeLessonSel:unblurView()
	end, SFX_PANEL)
	onButton(slot0, slot0.skillsMask, function ()
		slot0:closeSkllSel()
		slot0.closeSkllSel:unblurView()
	end, SFX_PANEL)
	slot0.initStudents(slot0)
end

slot0.initStudents = function (slot0)
	slot0.studentTFs = {}

	removeAllChildren(slot0.studentContain)

	for slot5 = 1, NavalAcademyProxy.MAX_SKILL_CLASS_NUM, 1 do
		slot0.studentTFs[slot5] = cloneTplTo(slot0.tpl, slot0.studentContain, slot5)

		if slot5 <= NavalAcademyProxy.MAX_SKILL_CLASS_NUM then
			setActive(slot0.studentTFs[slot5], true)

			if slot5 <= slot0.skillClassNum then
				slot0:updateLockStudentPos(slot5, true)
			else
				slot0:updateLockStudentPos(slot5, false)
			end
		else
			setActive(slot0.studentTFs[slot5], false)
		end
	end
end

slot0.NUM2SHOPID = {
	21,
	22
}

slot0.updateLockStudentPos = function (slot0, slot1, slot2)
	setActive(slot4, not slot2)
	setActive(slot0.studentTFs[slot1].Find(slot3, "addPanel"), slot2)
	setActive(slot0.studentTFs[slot1].Find(slot3, "infoPanel"), slot2)

	if slot2 then
		slot0:updateStudentTF(slot1, slot0.studentVOs[slot1])
	else
		onButton(slot0, slot4, function ()
			if not id2ItemId(pg.shop_template[slot1.NUM2SHOPID[slot0.skillClassNum - 1]].resource_type) then
				return
			end

			slot4 = slot2.resource_num
			slot5, slot6 = nil

			if slot2.discount ~= 0 and type(slot2.discount_time) == "table" and (table.getCount(slot2.discount_time) == 0 or pg.TimeMgr.GetInstance():inTime(slot2.discount_time)) then
				slot5 = {
					discount = slot2.discount
				}
				slot7, slot8 = unpack(slot2.discount_time)
				slot11, slot12, slot13 = unpack(slot9)
				slot20.year, slot20.month, slot20.day = unpack(slot10)

				if pg.TimeMgr.GetInstance():Table2ServerTime({
					year = slot14,
					month = slot15,
					day = slot16,
					hour = slot8[2][1],
					min = slot8[2][2],
					sec = slot8[2][3]
				}) - pg.TimeMgr.GetInstance():GetServerTime() >= 86400 then
					slot5.date = i18n("discount_time", math.floor((slot18 - slot17) / 86400)) .. i18n("word_date")
				elseif slot19 >= 3600 then
					slot5.date = i18n("discount_time", math.floor((slot18 - slot17) / 3600)) .. i18n("word_hour")
				else
					slot5.date = i18n("discount_time", math.floor((slot18 - slot17) / 60)) .. i18n("word_minute")
				end

				slot6 = i18n("open_skill_pos_discount", slot4, slot4 * (100 - slot2.discount) / 100)
				slot4 = slot4 * (100 - slot2.discount) / 100
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = slot6 or i18n("open_skill_pos", slot4),
				onYes = function ()
					if slot0.playerVO[id2res(slot1.resource_type)] < slot1.resource_type then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

						return
					end

					slot0:emit(NavalTacticsMediator.ON_SHOPPING, slot3)
				end,
				discount = slot5
			})
		end, SFX_PANEL)
	end
end

slot0.addStudent = function (slot0, slot1, slot2, slot3)
	slot4 = Student.New({
		id = slot2,
		ship_id = slot1,
		state = Student.WAIT
	})

	if slot3 then
		slot4:setSkillIndex(slot3)
	end

	slot0.select = coroutine.wrap(function ()
		if not slot0 then
			slot1:showSkillSel(slot2, slot1.select)
			coroutine.yield()
		end

		if #slot1.itemVOs > 0 then
			slot1:showLessonSel(slot1, slot1.select, function ()
				slot0.select = nil

				slot0:addStudent(slot0, , )
			end)
		else
			slot1.openMsgBox = false

			slot1.pushDeleteStudentQueue(slot1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
		end

		coroutine.yield()

		coroutine.yield.studentVOs[slot4] = slot4

		coroutine.yield.studentVOs:updateStudentTF(slot2.id, coroutine.yield.studentVOs)
	end)

	slot0.select()
end

slot0.startLesson = function (slot0, slot1, slot2)
	slot5 = slot0.shipVOs[slot1.shipId].skills[slot1:getSkillId(slot3)]
	slot6 = pg.skill_data_template[slot1.getSkillId(slot3)].max_level
	slot7 = pg.item_data_statistics[slot1.lessonId].name
	slot8 = slot0.shipVOs[slot1.shipId].getName(slot3)
	slot9 = getSkillName(slot1:getSkillId(slot3))

	function slot10()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tactics_lesson_start_tip", pg.MsgboxMgr.GetInstance().ShowMsgBox, pg.MsgboxMgr.GetInstance(), ),
			onYes = function ()
				if slot0.level == slot1 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

					return
				end

				if slot2 then
					slot2()
				end

				slot3:emit(NavalTacticsMediator.ON_START, {
					shipId = slot4.shipId,
					skillPos = slot4.shipId:getSkillId(slot4.shipId),
					lessonId = slot4.shipId:getSkillId().lessonId,
					roomId = slot4.shipId.getSkillId().lessonId.id
				})
			end
		})
	end

	if slot0.shipVOs[slot1.shipId].isActivityNpc(slot3) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("npc_learn_skill_tip"),
			onYes = slot10
		})
	else
		slot10()
	end
end

slot0.updateStudentVO = function (slot0, slot1)
	slot0.studentVOs[slot1.id] = slot1

	if slot1:getState() == Student.ATTEND then
		slot0:addLeasonOverTimer(slot1)
	end
end

slot0.updateStudentTF = function (slot0, slot1, slot2)
	setActive(slot4, slot2)
	setActive(slot0:findTF("addPanel", slot3), not slot2)

	if slot2 then
		slot0:updateShipInfo(slot4, slot2)
		slot0:updateSkillInfo(slot4, slot2)
		setButtonEnabled(slot6, true)

		if slot2:getState() == Student.ATTEND then
			slot0:addLeasonOverTimer(slot2)
		elseif slot2:getState() == Student.WAIT then
			setActive(slot6, false)
		end

		slot7 = slot0.shipVOs[slot2.shipId].configId

		onButton(slot0, slot6, function ()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("tactics_lesson_cancel"),
				onYes = function ()
					slot0:emit(NavalTacticsMediator.ON_CANCEL, slot1.id, Student.CANCEL_TYPE_MANUAL)
				end
			})
		end, SFX_CANCEL)
	else
		onButton(slot0, findTF(slot5, "add_btn"), function ()
			slot0:goDockYard(slot0, )
		end, SFX_PANEL)
	end
end

slot0.addDeleteStudentQueue = function (slot0, slot1, slot2, slot3, slot4)
	table.insert(slot0.deleteStuentQueue, {
		slot1,
		slot2,
		slot3,
		slot4
	})
	setButtonEnabled(slot0.studentTFs[slot1].Find(slot5, "infoPanel/cancel_btn"), false)

	if slot0.lessonOverTimer[slot1] then
		slot0.lessonOverTimer[slot1]:Stop()

		slot0.lessonOverTimer[slot1] = nil
	end

	if not slot0.metaSkillPanel then
		slot0:pushDeleteStudentQueue()
	end
end

slot0.pushDeleteStudentQueue = function (slot0)
	if not slot0.studentVOs then
		return
	end

	if #slot0.deleteStuentQueue > 0 and not slot0.openMsgBox then
		table.remove(slot0.deleteStuentQueue, 1)
		scrollTo(slot0:findTF("students/contain", slot0.mainPanel), 0, 1 - math.max(slot0.deleteStuentQueue[1][1] - 2, 0) / (NavalAcademyProxy.MAX_SKILL_CLASS_NUM - 2))
		slot0:deleteStudentVO(slot0.deleteStuentQueue[1][1], slot0.deleteStuentQueue[1][2], slot0.deleteStuentQueue[1][3], slot0.deleteStuentQueue[1][4])
	end
end

slot1 = 1

slot0.deleteStudentVO = function (slot0, slot1, slot2, slot3, slot4)
	slot0.openMsgBox = true
	slot7 = slot0.studentVOs[slot1].getSkillId(slot5, slot6)
	slot8 = nil

	for slot13, slot14 in ipairs(slot9) do
		if slot14 == slot7 then
			slot8 = slot13

			break
		end
	end

	slot10 = getSkillConfig(slot7)
	slot13 = slot0.studentTFs[slot1].Find(slot11, "infoPanel/skill_info")
	slot14 = slot0.studentTFs[slot1].Find(slot11, "infoPanel/skill_info/level_contain/level")
	slot16 = slot0.studentTFs[slot1].Find(slot11, "infoPanel/skill_info/exp").GetComponent(slot12, typeof(Slider))

	setButtonEnabled(slot15, false)

	function slot17()
		function slot1()
			slot0.flag = nil
			slot0.studentVOs[nil] = nil

			slot0.studentVOs:updateStudentTF(slot0.studentVOs, nil)

			if slot0.studentVOs.updateStudentTF.lessonOverTimer[slot0.studentVOs] then
				slot0.lessonOverTimer[slot1]:Stop()

				slot0.lessonOverTimer[slot1].Stop.lessonOverTimer[slot0.lessonOverTimer[slot1]] = nil
			end
		end

		if pg.skill_data_template[slot3].max_level <= (slot1.level < slot0.level and i18n("tactics_end_to_learn", slot2:getName(), getSkillName(slot3), ) .. i18n("tactics_skill_level_up", slot1.level, slot0.level)) or i18n("tactics_end_to_learn", slot2:getName(), getSkillName(slot3), ).level then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
				modal = true,
				hideNo = true,
				hideClose = true,
				content = slot0,
				onYes = function ()
					slot0()

					slot1.openMsgBox = false

					false:pushDeleteStudentQueue()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				modal = true,
				hideClose = true,
				content = slot0 .. i18n("tactics_continue_to_learn"),
				onYes = function ()
					slot0()
					slot1:addStudent(slot2.id, slot3, slot4)
				end,
				onNo = function ()
					slot0()

					slot1.openMsgBox = false

					false:pushDeleteStudentQueue()
				end
			})
		end
	end

	function slot18(slot0, slot1, slot2)
		slot0:updateSkillDesc(slot1, {
			id = slot2,
			name = getSkillName(slot2),
			level = slot0,
			icon = getConfigFromLevel1(pg.skill_need_exp, slot0).icon,
			exp = (slot1 and slot1) or getConfigFromLevel1(pg.skill_need_exp, slot0).exp
		}, true, slot2)
	end

	slot19 = slot3.level

	function slot20(slot0)
		slot0.value = slot0
	end

	if slot3.level < slot4.level then
		slot18(slot19, nil, true)
		slot0:leanTweenValue(slot12, slot16.value, 1, slot0, 0, slot20, function ()
			slot0 = slot0 + 1

			slot1(slot1)

			if slot2.level -  > 0 then
				slot3:leanTweenValue(slot4, 0, 1, , 0, , function ()
					if slot0 + 1 == slot1.level then
						getConfigFromLevel1:leanTweenValue(slot3, 0, slot1.exp / getConfigFromLevel1(pg.skill_need_exp, getConfigFromLevel1).exp, , 0, , )
						0(getConfigFromLevel1(pg.skill_need_exp, getConfigFromLevel1), slot1.exp)
					else
						slot7(slot7)
					end

					setText(slot8, setText)
				end, slot0)
			else
				slot0:leanTweenValue(slot4, 0, slot2.exp / getConfigFromLevel1(pg.skill_need_exp, slot0).exp, , 0, , )
				getConfigFromLevel1(pg.skill_need_exp, slot0)(slot0, slot2.exp)
			end
		end)
	else
		slot0:leanTweenValue(slot12, slot16.value, slot4.exp / getConfigFromLevel1(pg.skill_need_exp, slot19).exp, slot0, 0, slot20, slot17)
		slot18(slot19, slot4.exp, true)
	end
end

slot0.leanTweenValue = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8)
	slot9 = LeanTween.value(go(slot1), slot2, slot3, slot4):setOnUpdate(System.Action_float(function (slot0)
		if slot0 then
			slot0(slot0)
		end
	end)).setOnComplete(slot9, System.Action(function ()
		if slot0 then
			slot0()
		end
	end)).setDelay(slot9, slot5 or 0)

	if slot8 and slot8 > 0 then
		slot9:setRepeat(slot8)
	end
end

slot0.goDockYard = function (slot0, slot1, slot2)
	if table.getCount(slot0.itemVOs or {}) <= 0 then
		if not ItemTipPanel.ShowItemTipbyID(16001, i18n("item_lack_title", i18n("ship_book"), i18n("ship_book"))) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
		end

		return
	end

	slot3 = {}

	for slot7, slot8 in pairs(slot0.studentVOs) do
		if slot8:getState() == Student.WAIT then
			slot3[slot7] = slot8
		end
	end

	slot0:emit(NavalTacticsMediator.OPEN_DOCKYARD, slot2, slot3, slot1)
end

slot0.addLeasonOverTimer = function (slot0, slot1)
	setActive(slot0:findTF("infoPanel/cancel_btn", slot2), true)

	function slot3()
		if slot0.flag then
			return
		end

		slot0.flag = true

		slot0.lessonOverTimer[true.id]:Stop()

		slot0.lessonOverTimer[true.id].Stop.lessonOverTimer[slot0.lessonOverTimer[true.id].id] = nil

		slot0.lessonOverTimer[true.id].Stop.lessonOverTimer:emit(NavalTacticsMediator.ON_CANCEL, slot1.id, Student.CANCEL_TYPE_AUTO)
	end

	slot4 = slot1.getFinishTime(slot1)
	slot0.lessonOverTimer[slot1.id] = Timer.New(function ()
		if pg.TimeMgr.GetInstance():GetServerTime() <=  then
			slot1()
		else
			setText(slot2:Find("infoPanel/timer/Text"), pg.TimeMgr.GetInstance():DescCDTime(slot0 - slot0))
		end
	end, 1, -1)

	slot0.lessonOverTimer[slot1.id].Start(slot5)
	slot0.lessonOverTimer[slot1.id].func()
end

slot0.updateSkillDesc = function (slot0, slot1, slot2, slot3, slot4)
	setText(findTF(slot1, "name/Text"), slot2.name)
	setText(findTF(slot1, "level_contain/level"), slot2.level)
	LoadImageSpriteAsync("skillicon/" .. slot2.icon, findTF(slot1, "icon"))

	slot6 = slot0:findTF("next_contain/Text", slot1)
	slot7 = getConfigFromLevel1(pg.skill_need_exp, slot2.level)

	if slot2.level == pg.skill_data_template[slot2.id].max_level then
		setText(slot6, "MAX")
	elseif slot3 then
		slot0:leanTweenValue(slot6, (slot4 and tonumber(string.sub(getText(slot6), 1, string.find(getText(slot6), "/") - 1))) or 0, slot2.exp, slot0, 0, function (slot0)
			setText(slot0, math.floor(slot0) .. "/" .. slot1.exp)
		end)
	else
		setText(slot6, slot2.exp .. "/" .. slot7.exp)
	end
end

slot0.updateSkillInfo = function (slot0, slot1, slot2)
	slot4 = slot2:getSkillId(slot3)

	slot0:updateSkillDesc(slot5, {
		id = slot4,
		icon = getSkillConfig(slot4).icon,
		level = slot0.shipVOs[slot2.shipId].skills[slot4].level,
		name = getSkillName(slot4),
		exp = slot0.shipVOs[slot2.shipId].skills[slot4].exp
	})

	slot8 = pg.skill_data_template[slot4].max_level

	onButton(slot0, slot5, function ()
		if slot0.studentVOs[slot1.id]:getState() == Student.ATTEND then
			slot0:emit(NavalTacticsMediator.ON_SKILL, slot2.id, )

			return
		end

		slot0:showSkillSel(slot0, function ()
			slot0:updateSkillInfo(slot0:findTF("infoPanel", slot0.studentTFs[slot1.id]), slot0.updateSkillInfo)
		end)
	end, SFX_PANEL)
	setSlider(slot10, 0, 1, slot0.shipVOs[slot2.shipId].skills[slot4].exp / getConfigFromLevel1(pg.skill_need_exp, slot0.shipVOs[slot2.shipId].skills[slot4].level).exp)
	setText(findTF(slot1, "timer/Text"), pg.TimeMgr.GetInstance():DescCDTime(slot2:getTime()))
end

slot0.updateShipInfo = function (slot0, slot1, slot2)
	slot3 = slot0:findTF("ShipCardTpl", slot1)

	if not slot0.shipCards[slot0.shipVOs[slot2.shipId].id] then
		slot0.shipCards[slot4.id] = TacticsShipItem.New(slot3, ShipStatus.TAG_HIDE_ALL)
	end

	slot0.shipCards[slot4.id]:update(slot4)
end

slot0.showSkillSel = function (slot0, slot1, slot2)
	slot0:blurView()

	slot0.openMsgBox = true

	setActive(slot0.skillsMask, true)

	slot5 = 0

	for slot9, slot10 in pairs(slot4) do
		slot11 = slot0.skillContent:GetChild(slot9 - 1)
		slot12 = getSkillConfig(slot10)

		if slot3.skills[slot10] then
			slot0:updateSkill(slot9, slot11, {
				isLearn = true,
				id = slot10,
				name = getSkillName(slot10),
				icon = slot12.icon,
				desc = getSkillDesc(slot10, slot3.skills[slot10].level),
				level = slot3.skills[slot10].level,
				exp = slot3.skills[slot10].exp
			})

			slot5 = slot5 + 1
		end
	end

	for slot9 = slot5, 2, 1 do
		slot0:updateSkill(slot9, slot0.skillContent:GetChild(slot9), nil)
	end

	setActive(slot0.skillContent:GetChild(3), slot5 == 4)

	slot6 = slot0:findTF("skill_contain/content", slot0.skillsPanel):GetComponent(typeof(ToggleGroup))

	onButton(slot0, slot0.skillSelBtn, function ()
		if not slot0.selectedSkillIndex then
			return
		end

		if not slot2.skills[slot1[slot0.selectedSkillIndex]] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_should_exist_skill"))

			return
		end

		if slot1.level == pg.skill_data_template[slot0].max_level then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

			return
		end

		slot3:setSkillIndex(slot0.selectedSkillIndex)

		slot0.selectedSkillIndex = nil

		nil:SetAllTogglesOff()
		slot0:closeSkllSel()

		if slot0.selectedSkillIndex then
			slot5()
		end
	end, SFX_PANEL)
end

slot0.updateSkill = function (slot0, slot1, slot2, slot3, slot4)
	setActive(slot5, slot3)
	setActive(slot0:findTF("frame/empty", slot2), not slot3)

	if not slot4 then
		setToggleEnabled(slot2, slot3 and slot3.isLearn)
	end

	setActive(findTF(slot2, "frame/mask"), slot3 and not slot3.isLearn)

	if slot3 then
		setText(findTF(slot5, "name_contain/name"), slot3.name)
		LoadImageSpriteAsync("skillicon/" .. slot3.icon, findTF(slot5, "icon"))
		setText(findTF(slot5, "name_contain/level_contain/label"), (slot3.isLearn and "lv") or "")
		setText(findTF(slot5, "name_contain/level_contain/Text"), (slot3.isLearn and slot3.level .. ((slot3.additionLevel and "<color=#A9F548FF>+" .. slot3.additionLevel .. "</color>") or "")) or "")
		setText(findTF(slot5, "next_contain/label"), (slot3.isLearn and "NEXT:") or "")

		slot8 = nil

		if slot3.isLearn then
			slot9 = getConfigFromLevel1(pg.skill_need_exp, slot3.level)
			slot10 = findTF(slot5, "next_contain/Text")

			if slot3.level == pg.skill_data_template[slot3.id].max_level then
				setText(slot10, "MAX")
			else
				setText(slot10, "<color=#A9F548FF>" .. slot3.exp .. "</color>/" .. slot9.exp)
			end

			setText(findTF(slot5, "descView/Viewport/desc"), Student.getSkillDesc(slot3.id, slot3.level))
		else
			setText(findTF(slot5, "descView/Viewport/desc"), slot3.desc)
		end

		if 26 - math.floor((#findTF(slot5, "descView/Viewport/desc"):GetComponent(typeof(Text)).text - 160) / 40) < 26 then
			slot10 = 26
		end

		if slot10 > 28 then
			slot10 = 28
		end

		slot9.fontSize = slot10

		if not slot4 then
			onToggle(slot0, slot2, function (slot0)
				if not slot0.isLearn then
					return
				end

				if slot0 then
					slot1.selectedSkillIndex = slot2
				end
			end)

			if slot1 == 1 then
				triggerToggle(slot2, true)
			end
		end
	end
end

slot0.closeSkllSel = function (slot0)
	setActive(slot0.skillsMask, false)

	slot0.openMsgBox = false

	slot0:pushDeleteStudentQueue()
end

slot0.showMetaSkillPanel = function (slot0, slot1)
	slot0.metaSkillPanel = NavalTacticsMetaSkillsView.New(slot0.blurPanelTF, slot0.event, slot0.contextData)

	slot0.metaSkillPanel:Reset()
	slot0.metaSkillPanel:Load()
	slot0.metaSkillPanel:setData(slot1, function ()
		slot0:closeMetaSkillPanel()
	end)
	slot0.blurView(slot0)
end

slot0.closeMetaSkillPanel = function (slot0)
	if slot0.metaSkillPanel then
		slot0:unblurView()
		slot0.metaSkillPanel:Destroy()

		slot0.metaSkillPanel = nil

		slot0:pushDeleteStudentQueue()
	end
end

slot0.updateMetaSkillPanel = function (slot0)
	if slot0.metaSkillPanel then
		slot0.metaSkillPanel:reUpdate()
	end
end

slot0.showLessonSel = function (slot0, slot1, slot2, slot3)
	slot0:blurView()

	slot0.openMsgBox = true

	setActive(slot0.lessonMask, true)

	slot5 = slot0.lessonContent:Find("bg")

	if slot0.lessonContent.childCount > #slot0.itemVOs then
		for slot9 = slot4 - 1, #slot0.itemVOs, -1 do
			setActive(slot0.lessonContent:GetChild(slot9), false)
		end
	else
		for slot9 = 1, #slot0.itemVOs - slot4, 1 do
			cloneTplTo(slot5, slot0.lessonContent)
		end
	end

	slot6 = slot0.shipVOs[slot1.shipId].configId
	slot7 = slot1:getSkillId(slot0.shipVOs[slot1.shipId])
	slot8 = slot0.shipVOs[slot1.shipId]
	slot9 = slot0:findTF("skill/skilltpl_1", slot0.lessonMask)

	if slot3 then
		onButton(slot0, slot9, function ()
			slot0:closeLessonSel()

			slot0.closeLessonSel.selectedLessonId = nil
			slot0.closeLessonSel.lessonTime = nil

			if nil then
				slot1()
			end
		end)
	end

	slot10 = getSkillConfig(slot7)

	function slot11(slot0)
		if slot0.skills[] then
			slot3 = slot0.skills[slot1]

			if slot0 then
				slot1:addSkillExp(slot1, slot2:getLessonAddition(slot1, slot4) * pg.item_data_template[slot0].usage_arg[2])

				slot3 = slot1.skills[slot1]
			end

			slot2:updateSkill(k, slot3, {
				isLesson = true,
				isLearn = true,
				id = slot1,
				name = getSkillName(slot1),
				icon = slot4.icon,
				desc = getSkillDesc(slot1, slot3.level),
				level = slot0.skills[slot1].level,
				additionLevel = slot3.level - slot2.level > 0 and slot4,
				exp = slot3.exp
			}, true)
		else
			slot2:updateSkill(k, , {
				isLesson = true,
				isLearn = false,
				id = slot1,
				name = getSkillName(slot1),
				icon = slot4.icon,
				desc = getSkillDesc(slot2.updateSkill, slot0.skills[slot2.updateSkill].level)
			}, true)
		end
	end

	slot11(nil)

	for slot15 = 1, #slot0.itemVOs, 1 do
		slot16 = slot0.lessonContent:GetChild(slot15 - 1)

		updateItem(slot16, slot17)
		SetActive(slot16:Find("addition"), slot0:getLessonAddition(slot7, slot0.itemVOs[slot15].id) > 1)
		setText(slot19, slot18 * 100 .. "%exp")
		setText(findTF(slot16, "icon_bg/count"), slot17.count)
		onToggle(slot0, slot16, function (slot0)
			if slot0 then
				slot0.selectedLessonId = slot1.id

				slot0:updateLessonInfo(slot0, slot1.id)
				slot0(slot1.id)
			end
		end)

		if slot15 == 1 then
			triggerToggle(slot16, true)
		end
	end

	onButton(slot0, slot0.lessonSelBtn, function ()
		if not slot0.itemVOs or table.getCount(slot0.itemVOs) == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end

		if not slot0.selectedLessonId then
			return
		end

		slot1:setLesson(slot0.selectedLessonId)
		slot1:setTime(slot0.lessonTime)
		slot1.setTime:startLesson(slot1.setTime, function ()
			slot0:closeLessonSel()

			if slot0 then
				slot1()
			end

			slot0.selectedLessonId = nil
			slot0.lessonTime = nil
		end)
	end, SFX_PANEL)
end

slot0.getLessonAddition = function (slot0, slot1, slot2)
	return (pg.skill_data_template[slot1].type == pg.item_data_template[slot2].usage_arg[3] and 1 + pg.gameset.same_color_lesson_addition.key_value / 100) or 1
end

slot0.updateLessonInfo = function (slot0, slot1, slot2)
	setText(findTF(slot0.lessonPanel, "skillInfo/contain/name"), pg.item_data_statistics[slot2].name)
	setText(findTF(slot0.lessonPanel, "skillInfo/contain/desc"), pg.item_data_statistics[slot2].display)
	setText(findTF(slot0.lessonPanel, "skillInfo/contain/timer_contain/exp_timer/Text"), slot5)
	setText(findTF(slot0.lessonPanel, "skillInfo/contain/timer_contain/timer/Text"), pg.TimeMgr.GetInstance():DescCDTime(pg.item_data_template[slot2].usage_arg[1]))

	slot0.lessonTime = pg.item_data_template[slot2].usage_arg[1]
end

slot0.closeLessonSel = function (slot0)
	slot0.openMsgBox = false

	slot0:pushDeleteStudentQueue()
	setActive(slot0.lessonMask, false)
	slot0:unblurView()
end

slot0.blurView = function (slot0)
	setActive(slot0.blurPanelTF, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.blurPanelTF)
end

slot0.unblurView = function (slot0)
	setActive(slot0.blurPanelTF, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.blurPanelTF, slot0._tf)
end

slot0.willExit = function (slot0)
	slot0.UIMgr:UnOverlayPanel(slot0.mainPanel, slot0._tf)
	slot0:closeLessonSel()
	slot0:closeSkllSel()
	slot0:closeMetaSkillPanel()
	slot0:unblurView()

	if slot0.lessonOverTimer then
		for slot4, slot5 in pairs(slot0.lessonOverTimer) do
			slot5:Stop()
		end

		slot0.lessonOverTimer = nil
	end

	for slot4, slot5 in pairs(slot0.nameTxts) do
		slot5:destroy()
	end

	slot0.nameTxts = nil
end

return slot0

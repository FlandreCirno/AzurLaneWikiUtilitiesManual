slot0 = class("GuildMissionFormationPage", import(".GuildEventBasePage"))

slot0.getUIName = function (slot0)
	return "GuildMissionFormationPage"
end

slot0.OnRefreshMission = function (slot0, slot1)
	slot0:Flush(slot1)
end

slot0.OnFormationDone = function (slot0)
	slot1 = {}
	slot0.loading = true

	for slot5, slot6 in pairs(slot0.shipGos) do
		table.insert(slot1, function (slot0)
			slot1 = slot0:GetComponent(typeof(SpineAnimUI))

			slot1:SetAction("victory", 0)
			slot1:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					slot0:SetActionCallBack(nil)
					slot0:SetAction("stand", 0)
					slot0.SetAction()
				end
			end)
		end)
	end

	parallelAsync(slot1, function ()
		slot0:Hide()

		slot0.Hide.loading = false
	end)

	slot2 = slot0.canFormationIndex or 1

	for slot6, slot7 in ipairs(slot0.pageFooter) do
		setActive(slot7, slot6 <= slot2)
	end

	setActive(slot0.pageFooterAdd, false)
end

slot0.OnLoaded = function (slot0)
	slot0.closeBtn = slot0:findTF("frame/close")
	slot0.titleTxt = slot0:findTF("frame/title"):GetComponent(typeof(Text))
	slot0.recomBtn = slot0:findTF("frame/recom")
	slot0.clearBtn = slot0:findTF("frame/clear")
	slot0.goBtn = slot0:findTF("frame/bottom/go")
	slot0.inProgressBtn = slot0:findTF("frame/bottom/doingBtn")
	slot0.battleAreaTxt = slot0:findTF("frame/bottom/desc/area/Text"):GetComponent(typeof(Text))
	slot0.battleTypeTxt = slot0:findTF("frame/bottom/desc/type/Text"):GetComponent(typeof(Text))
	slot0.awardList = UIItemList.New(slot0:findTF("frame/bottom/award/list"), slot0:findTF("frame/bottom/award/list/item"))
	slot0.target1Text = slot0:findTF("frame/bottom/desc/target/content/Text"):GetComponent(typeof(Text))
	slot0.target2Text = slot0:findTF("frame/bottom/desc/target/content/Text2"):GetComponent(typeof(Text))
	slot0.target1Text4Effect = slot0:findTF("frame/bottom/desc/target/content1/Text"):GetComponent(typeof(Text))
	slot0.target2Text4Effect = slot0:findTF("frame/bottom/desc/target/content1/Text2"):GetComponent(typeof(Text))
	slot0.scoreAdditionTxt = slot0:findTF("frame/bottom/score_addition/Text"):GetComponent(typeof(Text))
	slot0.effectAdditionTxt = slot0:findTF("frame/bottom/effect_addition/Text"):GetComponent(typeof(Text))
	slot0.effectTxt = slot0:findTF("frame/bottom/effect/Text"):GetComponent(typeof(Text))
	slot0.bg = slot0:findTF("frame/bottom/bg"):GetComponent(typeof(Image))
	slot0.pageFooter = {
		slot0:findTF("frame/single/dot/1"),
		slot0:findTF("frame/single/dot/2"),
		slot0:findTF("frame/single/dot/3"),
		slot0:findTF("frame/single/dot/4")
	}
	slot0.pageFooterAdd = slot0:findTF("frame/single/dot/add")
	slot0.nextBtn = slot0:findTF("frame/single/next")
	slot0.prevBtn = slot0:findTF("frame/single/prev")

	setText(slot0:findTF("frame/bottom/desc/area"), i18n("guild_word_battle_area"))
	setText(slot0:findTF("frame/bottom/desc/type"), i18n("guild_word_battle_type"))
end

slot0.OnInit = function (slot0)
	addSlip(SLIP_TYPE_HRZ, slot0.findTF(slot0, "frame"), slot1, slot2)
	onButton(slot0, slot0.nextBtn, slot2, SFX_PANEL)
	onButton(slot0, slot0.prevBtn, slot1, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0.contextData.missionShips = nil

		slot0.contextData:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.recomBtn, function ()
		if not slot0:CheckFormation() then
			return
		end

		slot0:emit(GuildEventMediator.ON_GET_FORMATION, function ()
			if #getProxy(GuildProxy):GetRecommendShipsForMission(slot0.mission) == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_recomm_ship_failed"))

				return
			end

			slot0.contextData.missionShips = slot0

			slot0:UpdateFleet(slot0.contextData.index)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot0.clearBtn, function ()
		if not slot0:CheckFormation() then
			return
		end

		slot0.contextData.missionShips = {}

		slot0.contextData:UpdateFleet(slot0.contextData.index)
	end, SFX_PANEL)
	onButton(slot0, slot0.goBtn, function ()
		if slot0.mission:IsFinish() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_event_is_finish"))

			return
		end

		if not slot0:CheckFormation() then
			return
		end

		if not slot0.contextData.missionShips or #slot0.contextData.missionShips == 0 then
			return
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_event_start_event_tip"),
			onYes = function ()
				slot0:emit(GuildEventMediator.JOIN_MISSION, slot0.mission.id, slot0.contextData.missionShips)
			end
		})
	end, SFX_PANEL)

	slot0.shipGos = {}
end

slot0.OnShow = function (slot0)
	slot0.loading = nil
	slot0.maxShipCnt = slot0.extraData.shipCnt

	slot0:UpdateLayout()
	slot0:Flush(slot0.extraData.mission)
	slot0:UpdatePageFooter()
	slot0:AddNextFormationTimer()
end

slot0.UpdatePageFooter = function (slot0)
	slot2 = slot0.mission.CanFormation(slot1)
	slot3 = slot0.mission.GetFleetCnt(slot1)

	for slot7, slot8 in ipairs(slot0.pageFooter) do
		setActive(slot8, slot7 <= slot3)
		onToggle(slot0, slot8, function (slot0)
			if slot0 then
				slot0:UpdateFleet(slot0.UpdateFleet)
				slot0:UpdateSwitchBtns()
			end
		end, SFX_PANEL)
	end

	setActive(slot0.pageFooterAdd, slot2)
	onToggle(slot0, slot0.pageFooterAdd, function (slot0)
		if slot0 then
			slot0:UpdateFleet(slot1 + 1)
		end
	end, SFX_PANEL)

	if slot3 < (slot0.contextData.index or 1) then
		triggerToggle(slot0.pageFooterAdd, true)
	else
		triggerToggle(slot0.pageFooter[slot4], true)
	end
end

slot0.UpdateSwitchBtns = function (slot0)
	setActive(slot0.prevBtn, slot0.contextData.index ~= 1)
	setActive(slot0.nextBtn, slot3 < slot0.mission.GetMaxFleet(slot1))
end

slot0.AddNextFormationTimer = function (slot0)
	if slot0.mission:IsMaxFleetCnt() then
		return
	end

	function slot2(slot0)
		slot0.canFormationIndex = slot1:GetCanFormationIndex()

		setActive(slot0.pageFooterAdd, true)

		if slot0 then
			triggerToggle(slot0.pageFooterAdd, false)
		end

		slot1:RecordFormationTip()
		setActive(slot0.pageFooterAdd:Find("tip"), slot1:ShouldShowFormationTip())
		slot0:UpdateSwitchBtns()
	end

	if not slot1.CanFormation(slot1) then
		slot5 = slot1:GetNextFormationTime() - pg.TimeMgr.GetInstance():GetServerTime()
		slot0.timer = Timer.New(function ()
			slot0.timer:Stop()

			slot0.timer.Stop.timer = nil

			nil(true)
		end, slot5, 1)

		slot0.timer:Start()
	else
		slot2()
	end
end

slot0.Flush = function (slot0, slot1)
	slot0.mission = slot1
	slot0.canFormationIndex = slot1:GetCanFormationIndex()

	slot0:InitView()
end

slot0.UpdateLayout = function (slot0)
	slot0.bg.sprite = GetSpriteFromAtlas("ui/GuildFormationUI_atlas", "bg3")
	slot0.shipContainer = slot0:findTF("frame/single")
	slot0.bg.gameObject.transform.sizeDelta = Vector2(slot0.bg.gameObject.transform.sizeDelta.x, 212)

	setActive(slot0.findTF("frame/single"), true)
end

slot0.InitView = function (slot0)
	if slot0.initId ~= slot0.mission.id then
		slot0.awardList:make(function (slot0, slot1, slot2)
			if slot0 == UIItemList.EventUpdate then
				updateDrop(slot2, slot4)
				onButton(slot1, slot2, function ()
					slot0:send(BaseUI.ON_DROP, slot0)
				end, SFX_PANEL)
			end
		end)
		slot0.awardList.align(slot3, #slot1:GetAwards())

		slot0.battleAreaTxt.text = slot1:getConfig("ship_camp_display")
		slot0.battleTypeTxt.text = slot1:getConfig("ship_type_display")
		slot0.titleTxt.text = slot1:GetName()
		slot0.initId = slot1.id
	end
end

slot0.UpdateFleet = function (slot0, slot1)
	slot0:ClearSlots()

	slot2 = slot0.mission
	slot3 = slot0.maxShipCnt
	slot4 = nil

	if slot1 == slot0.canFormationIndex then
		slot4 = slot0.contextData.missionShips or slot2:GetFleetByIndex(slot1)
	else
		slot4 = slot2:GetFleetByIndex(slot1)
	end

	slot5 = {}
	slot4 = slot4 or {}

	for slot9 = 1, slot3, 1 do
		slot10 = slot0.shipContainer:GetChild(slot9 - 1)

		table.insert(slot5, function (slot0)
			slot0:UpdateShipSlot(slot0.UpdateShipSlot, slot0, , slot0)
		end)
	end

	pg.UIMgr.GetInstance(slot6):LoadingOn(false)
	parallelAsync(slot5, function ()
		pg.UIMgr:GetInstance():LoadingOff()
	end)

	if slot2.IsEliteType(slot2) then
		slot0.target2Text.text = string.format("%s : (<color=%s>%d/%d</color>)", slot2:GetSquadronDisplay(), (slot2:GetSquadronTargetCnt() <= slot0:GetTagShipCnt(slot4) and COLOR_GREEN) or COLOR_RED, slot6, slot7)
		slot0.target2Text4Effect.text = string.format("%s : (<color=%s>%d/%d</color>)", slot2.GetSquadronDisplay(), (slot2.GetSquadronTargetCnt() <= slot0.GetTagShipCnt(slot4) and COLOR_GREEN) or COLOR_RED, slot6, slot7)
	else
		slot0.target2Text.text = ""
		slot0.target2Text4Effect.text = ""
	end

	slot0.effectTxt.text = GuildMission.CalcMyEffect(slot4)
	slot0.scoreAdditionTxt.text = i18n("guild_word_score_addition") .. slot8
	slot0.effectAdditionTxt.text = i18n("guild_word_effect_addition") .. slot7
	slot0.target1Text.text = table.concat(slot11, " 、")
	slot0.target1Text4Effect.text = slot0.target1Text.text

	setButtonEnabled(slot0.goBtn, #slot4 > 0)
	setActive(slot0.inProgressBtn, not slot2:CanFormation() or slot1 <= slot2:GetFleetCnt())
	setActive(slot0.goBtn, not (not slot2.CanFormation() or slot1 <= slot2.GetFleetCnt()))

	slot0.contextData.index = slot1

	if slot0.target2Text.text ~= "" and slot0.target1Text.text ~= "" then
		setText(slot0:findTF("frame/bottom/desc/target/content/title"), i18n("guild_wrod_battle_target"))
	else
		setText(slot0:findTF("frame/bottom/desc/target/content/title"), "")
	end
end

slot0.UpdateShipSlot = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot0.mission
	slot7 = slot2:Find("Image")
	slot8 = slot2:Find("effect")
	slot9 = slot2:Find("score")

	if slot3[slot1] then
		if getProxy(BayProxy):getShipById(slot6) then
			PoolMgr.GetInstance():GetSpineChar(slot11, true, function (slot0)
				slot0.name = slot0
				tf(slot0).pivot = Vector2(0.5, 0)
				tf(slot0).sizeDelta = Vector2(200, 300)

				SetParent(slot0, SetParent)

				tf(slot0).localPosition = Vector3(0, 0, 0)
				tf(slot0).localScale = Vector3(0.6, 0.6, 0.6)

				SetAction(slot0, "stand")
				GetOrAddComponent(slot0, "EventTriggerListener").AddPointClickFunc(slot1, function (slot0, slot1)
					slot0:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, slot1.id, slot0.emit, slot0, index)
				end)

				GetOrAddComponent(slot0, "EventTriggerListener").AddPointClickFunc.shipGos[slot6] = slot0

				if slot7 then
					slot7()
				end
			end)
			setActive(slot8, slot0:HasEffectAddition(slot10))
			setActive(slot9, slot0:HasScoreAddition(slot10))
		elseif slot4 then
			slot4()
		end
	else
		onButton(slot0, slot7, function ()
			slot0:emit(GuildEventMediator.ON_SELECT_MISSION_SHIP, slot1.id, , )
		end, SFX_PANEL)
		setActive(slot8, false)
		setActive(slot9, false)

		if slot4 then
			slot4()
		end
	end

	setActive(slot7, not slot6)
end

slot0.CheckFormation = function (slot0)
	slot1 = slot0.mission

	if slot0.contextData.index ~= slot0.canFormationIndex then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_curr_fleet_can_not_edit"))

		return false
	end

	slot2, slot3 = slot0.mission:CanFormation()

	if not slot2 then
		if slot3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_next_edit_fleet_time", slot3))
		end

		return false
	end

	return true
end

slot0.emit = function (slot0, ...)
	if slot0.loading then
		return
	end

	if not slot0:CheckFormation() then
		return
	end

	slot0.super.emit(slot0, ...)
end

slot0.send = function (slot0, ...)
	slot0.super.emit(slot0, ...)
end

slot0.GetBattleTarget = function (slot0, slot1, slot2)
	slot5 = slot0.mission.GetAttrAcc(slot3)
	slot6 = {}

	for slot10, slot11 in pairs(slot4) do
		table.insert(slot6, GuildMissionInfoPage.AttrCnt2Desc(slot10, {
			value = slot11.value + (slot1[slot10] or 0),
			total = slot11.total,
			goal = slot11.goal,
			score = slot11.score
		}))
	end

	for slot10, slot11 in pairs(slot5) do
		table.insert(slot6, GuildMissionInfoPage.AttrAcc2Desc(slot10, {
			value = slot11.value + (slot2[slot10] or 0),
			op = slot11.op,
			goal = slot11.goal,
			score = slot11.score
		}))
	end

	return slot6
end

slot0.GetTagShipCnt = function (slot0, slot1)
	slot3 = slot0.mission.GetSquadron(slot2)
	slot4 = 0
	slot5 = getProxy(BayProxy)

	for slot9, slot10 in ipairs(slot1) do
		if slot5:getShipById(slot10) and slot11:IsTagShip(slot3) then
			slot4 = slot4 + 1
		end
	end

	return slot4
end

slot0.CalcScoreAddition = function (slot0, slot1)
	slot3 = slot0.mission.GetAttrCntAcc(slot2)
	slot4 = slot0.mission.GetAttrAcc(slot2)
	slot5 = pg.attribute_info_by_type
	slot6 = 0
	slot7 = {}
	slot8 = {}
	slot9 = getProxy(BayProxy)

	for slot13, slot14 in ipairs(slot1) do
		slot16 = nil

		if slot9:getShipById(slot14) then
			slot17 = _.detect(slot2:getConfig("ship_camp_effect"), function (slot0)
				return slot0[1] == slot0:getNation()
			end)
			slot16 = slot17
		end

		if slot16 then
			slot6 = slot6 + slot16[2]
		end

		slot17 = (slot15 and slot15:getProperties()) or {}

		for slot21, slot22 in pairs(slot3) do
			if slot22.total <= (slot17[slot5[slot21].name] or 0) then
				slot7[slot21] = (slot7[slot21] or 0) + 1
			end
		end

		for slot21, slot22 in pairs(slot4) do
			slot8[slot21] = (slot8[slot21] or 0) + (slot17[slot5[slot21].name] or 0)
		end
	end

	for slot13, slot14 in pairs(slot3) do
		if slot14.goal <= (slot7[slot13] or 0) + slot14.value then
			slot6 = slot6 + slot14.score
		end
	end

	for slot13, slot14 in pairs(slot4) do
		slot15 = slot14.value + (slot8[slot13] or 0)
		slot16 = nil

		if slot14.op == 1 then
			slot16 = slot14.goal <= slot15

			if slot15 <= slot14.goal then
				slot6 = slot6 + slot14.score
			end
		end
	end

	return slot6, slot7, slot8
end

slot0.CalcEffectAddition = function (slot0, slot1)
	slot2 = slot0.mission
	slot3 = GuildMission.CalcMyEffect(slot1)
	slot4 = getProxy(BayProxy)

	for slot8, slot9 in ipairs(slot1) do
		slot11 = nil

		if slot4:getShipById(slot9) then
			slot12 = _.detect(slot2:getConfig("ship_type_effect"), function (slot0)
				return slot0[1] == slot0:getShipType()
			end)
			slot11 = slot12
		end

		if slot11 then
			slot3 = slot3 + slot11[2]
		end
	end

	slot7 = 1

	if slot2:GetSquadronTargetCnt() <= slot0:GetTagShipCnt(slot1) and slot2:IsEliteType() then
		slot7 = slot2:GetSquadronRatio()
	end

	return slot3 * slot7
end

slot0.HasScoreAddition = function (slot0, slot1)
	slot3 = slot0.mission.GetRecommendShipNation(slot2)
	slot4 = slot0.mission.GetAttrCntAcc(slot2)
	slot5 = slot0.mission.GetAttrAcc(slot2)

	return table.contains(slot3, slot1:getNation()) or function ()
		slot0 = slot0:getProperties()

		for slot5, slot6 in pairs(slot1) do
			if slot6.total <= (slot0[slot1[slot5].name] or 0) then
				return true
			end
		end

		for slot5, slot6 in pairs(pairs) do
			slot7 = slot1[slot5].name

			if slot6.op == 1 then
				return (slot0[slot7] or 0) > 0
			elseif slot6.op == 2 then
				return (slot0[slot7] or 0) == 0
			end
		end

		return false
	end()
end

slot0.HasEffectAddition = function (slot0, slot1)
	return table.contains(slot0.mission.GetRecommendShipTypes(slot2), slot1:getShipType()) or slot1:IsTagShip(slot0.mission.GetSquadron(slot2))
end

slot0.ClearSlots = function (slot0)
	for slot4, slot5 in pairs(slot0.shipGos) do
		tf(slot5).pivot = Vector2(0.5, 0.5)

		GetOrAddComponent(slot5, "EventTriggerListener").RemovePointClickFunc(slot6)
		slot5:GetComponent(typeof(SpineAnimUI)).SetActionCallBack(slot7, nil)
		PoolMgr.GetInstance():ReturnSpineChar(slot5.name, slot5)
	end

	slot0.shipGos = {}
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	slot0:ClearSlots()

	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

return slot0

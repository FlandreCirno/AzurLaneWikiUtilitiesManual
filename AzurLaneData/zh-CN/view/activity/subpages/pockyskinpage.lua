slot0 = class("PockySkinPage", import("view.base.BaseActivityPage"))

slot0.GetCurrentDay = function ()
	return pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t").yday
end

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.leftStage = slot0.bg:Find("left")
	slot0.rightStage = slot0.bg:Find("right")
	slot0.taskDesc = slot0.leftStage:Find("task")
	slot0.signDesc = slot0.leftStage:Find("signin")
	slot0.spine = nil
	slot0.spineLRQ = GetSpineRequestPackage.New("beierfasite_4", function (slot0)
		SetParent(slot0, slot0.leftStage:Find("ship"))

		slot0.spine = slot0
		slot0.spine.transform.localScale = Vector3.one

		slot0:SetAction("stand")

		slot0.spineLRQ = nil
	end).Start(slot1)
	slot0.startDay = PlayerPrefs.GetInt("PockySkinSignDay" .. (getProxy(PlayerProxy):getRawData().id or "-1"), 0)
	slot0.usmLRQ = nil
end

slot0.OnDataSetting = function (slot0)
	slot1 = getProxy(ActivityProxy)
	slot2 = slot0.activity:getConfig("config_client").linkids
	slot3 = false
	slot0.ActSignIn = slot0.activity
	slot0.taskProxy = getProxy(TaskProxy)

	if slot0.ActSignIn then
		slot0.nday = 0
		slot0.taskGroup = slot0.ActSignIn:getConfig("config_data")
		slot3 = slot3 or updateActivityTaskStatus(slot0.ActSignIn)
		slot0.ActPT = slot1:getActivityById(slot2[1])
	end

	if slot0.ActPT then
		if slot0.ptData then
			slot0.ptData:Update(slot0.ActPT)
		else
			slot0.ptData = ActivityPtData.New(slot0.ActPT)
		end
	end

	slot0.ActTaskList = slot1:getActivityById(slot2[2])

	if slot0.ActTaskList then
		slot0.nday2 = 0
		slot0.taskGroup2 = slot0.ActTaskList:getConfig("config_data")
		slot3 = slot3 or updateActivityTaskStatus(slot0.ActTaskList)
		slot0.ActFinal = slot1:getActivityById(slot2[3])
	end

	if slot0.ActFinal then
		slot0.nday3 = 0
		slot0.taskGroup3 = slot0.ActFinal:getConfig("config_data")

		return slot3 or updateActivityTaskStatus(slot0.ActFinal)
	end
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.rightStage:Find("display_btn"), function ()
		slot0:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = slot0.ptData.type,
			dropList = slot0.ptData.dropList,
			targets = slot0.ptData.targets,
			level = slot0.ptData.level,
			count = slot0.ptData.count,
			resId = slot0.ptData.resId
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.rightStage:Find("battle_btn"), function ()
		slot0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(slot0, slot0.rightStage:Find("get_btn"), function ()
		slot2, slot5.arg1 = slot0.ptData:GetResProgress()

		slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = slot0.ptData:GetId(),
			arg1 = slot1
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.bg:Find("help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.pocky_help.tip
		})
	end, SFX_PANEL)
end

slot0.SetAction = function (slot0, slot1)
	if not slot0.spine then
		return
	end

	if slot0.spine:GetComponent("SpineAnimUI") then
		slot2:SetAction(slot1, 0)
	end
end

slot0.OnUpdateFlush = function (slot0)
	slot0:UpdateTaskList()
	slot0:UpdatePTList()

	slot2 = "ui"
	slot3 = (slot0.startDay < slot0.GetCurrentDay() and "juu_factory_rest") or "juu_factory"

	if slot0.usmLRQ and slot0.usmLRQ.name ~= slot3 then
		slot0.usmLRQ:Stop()

		slot0.usmLRQ = nil
	end

	if slot0.usmName ~= slot3 then
		slot0.usmLRQ = LoadPrefabRequestPackage.New(slot2 .. "/" .. slot3, slot3, function (slot0)
			if not IsNil(slot0.usm) then
				Destroy(slot0.usm)
			end

			slot0.usm = slot0

			setParent(slot0, slot0.bg:Find("usm"))
		end).Start(slot4)
		slot0.usmName = slot3
	end
end

slot0.UpdateTaskList = function (slot0)
	slot0.nday = slot0.ActSignIn.data3 or 0
	slot0.nday2 = slot0.ActTaskList.data3 or 0
	slot0.nday3 = slot0.ActFinal.data3 or 0

	if checkExist(slot0.ActSignIn:getConfig("config_client").story, {
		slot0.nday
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(slot1[slot0.nday][1])
	end

	slot2 = slot0.leftStage:Find("go_btn")
	slot3 = slot0.leftStage:Find("get_btn")
	slot4 = slot0.leftStage:Find("sign_btn")
	slot5 = slot0.leftStage:Find("got_btn")
	slot6 = slot0.leftStage:Find("award")
	slot7 = slot0.leftStage:Find("slider")
	slot8 = getProxy(TaskProxy)
	slot15 = slot8:getTaskVO(slot9).getTaskStatus(slot12)
	slot16 = slot8:getTaskVO(slot10).getTaskStatus(slot13)
	slot17 = slot8:getTaskVO(slot11).getTaskStatus(slot14)

	if not slot0.startTaskid then
		slot0.startTaskid = slot9
		slot0.startStatus = slot15
	end

	slot18 = false

	if slot0.startTaskid ~= slot9 then
		slot0.startTaskid = slot9
		slot0.startStatus = slot15
		slot18 = true
	elseif slot0.startStatus ~= slot15 then
		slot0.startStatus = slot15
		slot18 = true
	end

	slot19 = slot0.GetCurrentDay()

	if slot18 and slot0.startDay < slot19 then
		slot0.startDay = slot19

		PlayerPrefs.SetInt("PockySkinSignDay" .. (getProxy(PlayerProxy):getRawData().id or "-1"), slot0.startDay)
	end

	if slot17 == 2 then
		setActive(slot6, false)
		setActive(slot7, false)
		setActive(slot0.taskDesc, false)
		setActive(slot0.signDesc, true)
		setText(slot0.signDesc:Find("title"), i18n("pocky_jiujiu"))
		setText(slot0.signDesc:Find("desc"), i18n("pocky_jiujiu_desc"))
		setActive(slot2, false)
		setActive(slot4, true)
		setActive(slot3, false)
		setActive(slot5, false)
		onButton(slot0, slot4, function ()
			if slot0.startDay < slot0.GetCurrentDay() then
				slot0.startDay = slot0

				PlayerPrefs.SetInt("PockySkinSignDay" .. (getProxy(PlayerProxy):getRawData().id or "-1"), slot0.startDay)
				slot0:OnUpdateFlush()
			end
		end, SFX_PANEL)
		removeOnButton(slot5)

		return
	end

	slot20, slot21, slot22 = nil

	if slot0.ptData.level >= #slot0.ptData.targets and slot0.nday >= #slot0.taskGroup and slot15 == 2 and slot0.nday2 >= #slot0.taskGroup2 and slot16 == 2 then
		setActive(slot4, false)

		slot20 = slot3
		slot21 = slot14
	elseif slot0.nday <= slot0.nday2 and slot15 ~= 2 then
		setActive(slot3, false)

		slot20 = slot4
		slot21 = slot12
	else
		setActive(slot4, false)

		slot20 = slot3
		slot21 = slot13
	end

	setActive(slot6, true)
	updateDrop(slot6, slot24)
	onButton(slot0, slot6, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	setActive(slot7, true)
	setActive(slot0.taskDesc, true)
	setActive(slot0.signDesc, false)
	setText(slot0.taskDesc:Find("title"), slot21:getConfig("name"))
	setText(slot0.taskDesc:Find("desc"), slot21:getConfig("desc"))
	setSlider(slot7, 0, slot21:getConfig("target_num"), slot21:getProgress())
	setActive(slot2, slot21:getTaskStatus() == 0)
	setActive(slot20, slot27 == 1)
	setActive(slot5, slot27 == 2)
	onButton(slot0, slot2, function ()
		slot0:emit(ActivityMediator.ON_TASK_GO, slot0)
	end, SFX_PANEL)
	onButton(slot0, slot20, function ()
		slot0:emit(ActivityMediator.ON_TASK_SUBMIT, slot0)
	end, SFX_PANEL)
end

slot0.UpdatePTList = function (slot0)
	if not slot0.ptData then
		return
	end

	if checkExist(slot0.ActPT:getConfig("config_client").story, {
		slot0.ptData:getTargetLevel()
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(slot2[slot1][1])
	end

	slot12, slot13 = slot0.ptData:GetResProgress()

	setSlider(slot6, 0, 1, math.min(slot3, slot4) / slot0.ptData:GetTotalResRequire())
	setSlider(slot8, 0, 1, slot0.ptData:GetUnlockedMaxResRequire() / slot0.ptData.GetTotalResRequire())
	setActive(slot0.rightStage:Find("battle_btn"), slot0.ptData:CanGetMorePt() and not slot0.ptData:CanGetAward() and slot0.ptData:CanGetNextAward())
	setActive(slot0.rightStage:Find("get_btn"), slot0.ptData.CanGetAward())
	setActive(slot0.rightStage:Find("got_btn"), not slot0.ptData.CanGetNextAward())
end

slot0.OnDestroy = function (slot0)
	if slot0.spineLRQ then
		slot0.spineLRQ:Stop()

		slot0.spineLRQ = nil
	end

	if slot0.spine then
		slot0.spine.transform.localScale = Vector3.one

		pg.PoolMgr.GetInstance():ReturnSpineChar("beierfasite_4", slot0.spine)

		slot0.spine = nil
	end
end

return slot0

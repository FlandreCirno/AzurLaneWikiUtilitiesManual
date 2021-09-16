slot0 = class("AprilFoolDiscoveryRePage", import(".AprilFoolDiscoveryPage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.bulin = slot0.bg:Find("bulin")
	slot0.bulinAnim = slot0.bulin:Find("bulin"):GetComponent("SpineAnimUI")

	setText(slot0.bulin:Find("Text"), i18n("super_bulin_tip"))
	setActive(slot0.bulin, false)

	slot0._funcsLink = {}
end

slot0.AddFunc = function (slot0, slot1)
	table.insert(slot0._funcsLink, slot1)

	if #slot0._funcsLink > 1 then
		return
	end

	slot0:PlayFuncsLink()
end

slot0.PlayFuncsLink = function (slot0)
	slot1 = false
	slot2 = nil

	function slot2(...)
		if slot0 then
			table.remove(slot1._funcsLink, 1)
		end

		slot0 = true

		if slot1._funcsLink[1] then
			slot0(slot2, ...)
		end
	end

	slot2()
end

slot0.OnDataSetting = function (slot0)
	function slot2()
		if slot0.activity.data1 == 1 and slot0.activity.data3 == 1 then
			slot0.activity.data3 = 0

			pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
				cmd = 4,
				actId = slot0.activity.id
			})

			return true
		end
	end

	return slot0.super.OnDataSetting(slot0) or slot2()
end

slot0.OnFirstFlush = function (slot0)
	slot0.puzzleConfig = pg.activity_event_picturepuzzle[slot0.activity.id]
	slot0.keyList = Clone(pg.activity_event_picturepuzzle[slot0.activity.id].pickup_picturepuzzle)

	table.insertto(slot0.keyList, pg.activity_event_picturepuzzle[slot0.activity.id].drop_picturepuzzle)
	table.sort(slot0.keyList)
	onButton(slot0, slot0.btnHelp, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.bulin_help.tip
		})
	end, SFX_PANEL)

	slot2 = slot0.activity.id

	onButton(slot0, slot0.btnBattle, function ()
		if #slot0.activity.data2_list < #slot0.keyList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_not_start"))

			return
		end

		slot0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
			warnMsg = "bulin_tip_other3",
			stageId = slot0.puzzleConfig.chapter
		}, function ()
			slot0 = getProxy(ActivityProxy)

			if slot0:getActivityById(slot0).data1 == 1 then
				return
			end

			slot1.data3 = 1

			slot0:updateActivity(slot1)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot0.bulin, function ()
		if slot0.activity.data1 >= 1 then
			seriesAsync({
				function (slot0)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("super_bulin"),
						onYes = slot0
					})
				end,
				function (slot0)
					slot0:emit(ActivityMediator.ON_SIMULATION_COMBAT, {
						warnMsg = "bulin_tip_other3",
						stageId = slot0:GetLinkStage()
					}, function ()
						slot0 = getProxy(ActivityProxy)

						if slot0:getActivityById(slot0).data1 == 2 then
							return
						end

						slot1.data3 = 1

						slot0:updateActivity(slot1)
					end)
				end
			})
		end
	end)

	slot3 = slot0.activity.getConfig(slot3, "config_client").guideName

	slot0:AddFunc(function (slot0)
		pg.SystemGuideMgr.GetInstance():PlayByGuideId(slot0, nil, slot0)
	end)
end

slot1 = {
	"lock",
	"hint",
	"unlock"
}

slot0.OnUpdateFlush = function (slot0)
	slot1 = slot0.activity.data1 >= 1
	slot2 = #slot0.activity.data2_list == #slot0.keyList

	if ((slot1 and "activity_bg_aprilfool_final") or "activity_bg_aprilfool_discovery") ~= slot0.bgName then
		setImageSprite(slot0.bg, LoadSprite("ui/activityuipage/AprilFoolDiscoveryRePage_atlas", slot3))

		slot0.bg:GetComponent(typeof(Image)).enabled = true
		slot0.bgName = slot3
	end

	slot4 = slot0.activity.data2_list
	slot5 = slot0.activity.data3_list

	for slot9, slot10 in ipairs(slot0.items) do
		onButton(slot0, slot10, function ()
			if slot0 >= 3 then
				return
			end

			if slot0 == 2 then
				slot1.selectIndex = slot2

				slot2:UpdateSelection()

				return
			elseif slot0 == 1 then
				if pg.TimeMgr.GetInstance():GetServerTime() < pg.TimeMgr.GetInstance().activity.data2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("bulin_tip_other2"))

					return
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("bulin_tip_other1"),
					onYes = function ()
						pg.m02:sendNotification(GAME.PUZZLE_PIECE_OP, {
							cmd = 3,
							actId = slot0.activity.id,
							id = pg.m02
						})

						pg.m02.sendNotification.selectIndex = GAME.PUZZLE_PIECE_OP
					end
				})
			end
		end)
		slot0.loader.GetSprite(slot13, "UI/ActivityUIPage/AprilFoolDiscoveryRePage_atlas", slot0[(table.contains(slot4, slot0.keyList[slot9]) and 3) or (table.contains(slot5, slot11) and 2) or 1], slot10:Find("state"))
		setActive(slot10:Find("character"), ((table.contains(slot4, slot0.keyList[slot9]) and 3) or (table.contains(slot5, slot11) and 2) or 1) == 3)
	end

	setActive(slot0.btnBattle, slot2)
	setActive(slot0.btnIncomplete, not slot2)
	slot0:UpdateSelection()
	setActive(slot0.bulin, slot1)

	if slot0.activity.data1 == 1 then
		slot6 = slot0.activity:getConfig("config_client").popStory

		slot0:AddFunc(function (slot0)
			pg.NewStoryMgr.GetInstance():Play(slot0, slot0)
		end)
		slot0.AddFunc(slot0, function (slot0)
			if PlayerPrefs.GetInt("SuperBurinPopUp_" .. getProxy(PlayerProxy):getRawData().id, 0) == 0 then
				LoadContextCommand.LoadLayerOnTopContext(Context.New({
					mediator = SuperBulinPopMediator,
					viewComponent = SuperBulinPopView,
					data = {
						stageId = slot0:GetLinkStage(),
						actId = slot0.activity.id,
						onRemoved = slot0
					}
				}))
				PlayerPrefs.SetInt("SuperBurinPopUp_" .. slot1.id, 1)
			end
		end)
	end
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)
end

slot0.GetLinkStage = function (slot0)
	return slot0.activity:getConfig("config_client").lastChapter
end

return slot0

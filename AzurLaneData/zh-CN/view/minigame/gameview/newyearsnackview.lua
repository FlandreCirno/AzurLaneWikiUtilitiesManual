slot0 = class("NewYearSnackView", import(".SnackView"))

slot0.getUIName = function (slot0)
	return "NewYearSnack"
end

slot0.OnSendMiniGameOPDone = function (slot0)
	slot0:updateCount()
end

slot0.addListener = function (slot0)
	slot0.super.addListener(slot0)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_xinnian2021__meishi.tip
		})
	end, SFX_PANEL)
end

slot0.updateSDModel = function (slot0)
	slot2 = getProxy(PlayerProxy).getData(slot1)
	slot3 = getProxy(BayProxy)

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetSpineChar("Z28", true, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()

		slot0.prefab = slot0
		slot0.model = slot0
		tf(slot0).localScale = Vector3(1, 1, 1)

		slot0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
		setParent(slot0, slot0.spineCharContainer)
	end)
end

slot0.updateSelectedList = function (slot0, slot1)
	slot1 = slot1 or {}

	for slot5 = 1, slot0.Order_Num, 1 do
		slot6 = slot0.selectedContainer:GetChild(slot5 - 1)
		slot9 = slot0:findTF("SnackImg", slot8)
		slot0.selectedTFList[slot5] = slot6

		setActive(slot8, slot10)
		setActive(slot0:findTF("Empty", slot6), not slot1[slot5])

		if slot1[slot5] then
			setImageSprite(slot9, GetSpriteFromAtlas("ui/newyearsnackui_atlas", "snack_" .. slot10, true))
		end
	end
end

slot0.updateSnackList = function (slot0, slot1)
	for slot5 = 1, slot0.Snack_Num, 1 do
		slot6 = slot0.snackContainer:GetChild(slot5 - 1)

		setImageSprite(slot7, GetSpriteFromAtlas("ui/newyearsnackui_atlas", "snack_" .. slot8, true))
		setActive(slot0:findTF("SelectedTag", slot6), false)

		slot0.snackTFList[slot5] = slot6
		slot5 = slot5 + 1
	end
end

slot0.updateSelectedOrderTag = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.selectedSnackTFList) do
		slot7 = slot0:findTF("SelectedTag", slot6)

		if slot1 then
			setActive(slot7, false)
		else
			setImageSprite(slot7, GetSpriteFromAtlas("ui/snackui_atlas", "order_" .. slot8, true))
		end
	end
end

slot0.openResultView = function (slot0)
	slot0.packageData = {
		orderIDList = slot0.orderIDList,
		selectedIDList = slot0.selectedIDList,
		countTime = slot0.countTime,
		score = slot0.score,
		correctNumToEXValue = slot0:GetMGData():getConfig("simple_config_data").correct_value,
		scoreLevel = slot0:GetMGData():getConfig("simple_config_data").score_level,
		onSubmit = function (slot0)
			if slot0:GetMGHubData().count > 0 then
				slot0:SendSuccess(slot0)
			end

			slot0.score = 0
			slot0.countTime = nil
			slot0.leftTime = slot0.orginSelectTime
			slot0.orderIDList = {}
			slot0.selectedIDList = {}
			slot0.snackIDList = {}

			slot0:updateSelectedOrderTag(true)

			slot0.selectedSnackTFList = {}

			slot0.animtor:SetBool("AniSwitch", slot1.Ani_Open_2_Close)
			slot0:setState(slot1.States_Before)
		end,
		onContinue = function ()
			slot0.score = slot0.packageData.score
			slot0.leftTime = slot0.packageData.countTime
			slot0.orderIDList = {}
			slot0.selectedIDList = {}
			slot0.snackIDList = {}
			slot0.selectedSnackTFList = {}

			slot0.animtor:SetBool("AniSwitch", slot1.Ani_Open_2_Close)
			slot0.animtor.SetBool:setState(slot1.States_Memory)
		end
	}
	slot0.snackResultView = NewYearSnackResultView.New(slot0._tf, slot0.event, slot0.packageData)

	slot0.snackResultView.Reset(slot1)
	slot0.snackResultView:Load()
end

return slot0

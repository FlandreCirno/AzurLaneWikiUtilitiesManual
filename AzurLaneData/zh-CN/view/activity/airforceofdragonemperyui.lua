slot0 = class("AirForceOfDragonEmperyUI", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "AirForceOfDragonEmperyUI"
end

slot1 = {
	"J-10",
	"J-15",
	"FC-1",
	"FC-31"
}
slot2 = {
	"fighterplane_J10_tip",
	"fighterplane_J15_tip",
	"fighterplane_FC1_tip",
	"fighterplane_FC31_tip"
}

slot0.init = function (slot0)
	slot0.itemList = {}

	for slot4 = 0, slot0._tf:Find("List").childCount - 1, 1 do
		slot5 = slot0._tf:Find("List"):GetChild(slot4)

		setImageAlpha(slot5:Find("Button"), 0.5)
		table.insert(slot0.itemList, slot5)
	end

	slot0.currentNameImage = slot0._tf:Find("FighterName")
	slot0.currentFighterImage = slot0._tf:Find("FighterImage")
	slot0.currentFighterDesc = slot0._tf:Find("FighterProgress")

	setImageAlpha(slot0.currentNameImage, 0)
	setImageAlpha(slot0.currentFighterImage, 0)

	slot0.BattleTimes = slot0._tf:Find("BattleTimes")

	setParent(tf(Instantiate(slot0._tf:GetComponent(typeof(ItemList)).prefabItem[0])), slot0._tf)

	slot0.loader = AutoLoader.New()
end

slot0.SetActivityData = function (slot0, slot1)
	slot0.activity = slot1
end

slot0.GetFighterData = function (slot0, slot1)
	return slot0.activity:getKVPList(1, slot1) or 0, slot0.activity:getKVPList(2, slot1) == 1
end

slot0.GetActivityProgress = function (slot0)
	slot1 = 0

	for slot6 = 1, slot0.activity:getConfig("config_client")[1], 1 do
		slot1 = slot1 + slot0:GetFighterData(slot6)
	end

	slot3 = pg.TimeMgr.GetInstance()

	return slot1, math.min((slot3:DiffDay(slot0.activity.data1, slot3:GetServerTime()) + 1) * 2, slot2 * 3)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._tf:Find("Back"), function ()
		slot0:closeView()
	end, SOUND_BACK)
	onButton(slot0, slot0._tf:Find("Help"), function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fighterplane_help.tip,
			weight = LayerWeightConst.SECOND_LAYER
		})
	end, SFX_PANEL)
	onButton(slot0, slot0._tf:Find("Battle"), function ()
		function slot2()
			slot0:emit(AirForceOfDragonEmperyMediator.ON_BATTLE, slot0.activity:getConfig("config_client")[2][math.random(slot3, slot4)])
		end

		if slot0:GetFighterData(slot0.contextData.index) >= 3 then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
				content = i18n("fighterplane_complete_tip"),
				onYes = slot2,
				weight = LayerWeightConst.SECOND_LAYER
			})
		else
			slot2()
		end
	end, SFX_FIGHTER_BATTLE)

	for slot4, slot5 in ipairs(slot0.itemList) do
		onButton(slot0, slot5, function ()
			slot0:SwitchIndex(slot0)
		end, SFX_FIGHTER_SWITCH)
	end

	slot0.contextData.index = nil

	slot0:SwitchIndex(slot0.contextData.index or PlayerPrefs.GetInt("AirFightIndex_" .. getProxy(PlayerProxy).getRawData(slot1).id, 1))
	slot0:UpdateView()
end

slot0.willExit = function (slot0)
	PlayerPrefs.SetInt("AirFightIndex_" .. getProxy(PlayerProxy):getRawData().id, slot0.contextData.index)
	PlayerPrefs.Save()
	LeanTween.cancel(go(slot0.currentNameImage))
	LeanTween.cancel(go(slot0.currentFighterImage))
	LeanTween.cancel(go(slot0.currentFighterDesc:Find("Desc/Text")))
	LeanTween.cancel(go(slot0.currentFighterDesc:Find("Progress")))
	slot0.loader:Clear()
end

slot0.UpdateView = function (slot0)
	for slot4, slot5 in ipairs(slot0.itemList) do
		slot12, slot7 = slot0:GetFighterData(slot4)

		UIItemList.StaticAlign(slot0.itemList[slot4].Find(slot8, "Progress"), slot0.itemList[slot4].Find(slot8, "Progress"):GetChild(0), slot6)
	end

	slot0:UpdateFighter(slot0.contextData.index)

	slot1, slot2 = slot0:GetActivityProgress()

	setText(slot0.BattleTimes, slot2 - slot1)
	slot0:CheckActivityUpdate()
end

slot0.SwitchIndex = function (slot0, slot1)
	if slot1 == nil or slot1 == slot0.contextData.index then
		return
	end

	if slot0.contextData.index then
		setActive(slot0.itemList[slot0.contextData.index].Find(slot2, "Selected"), false)
		setImageAlpha(slot0.itemList[slot0.contextData.index].Find(slot2, "Button"), 0.5)
	end

	slot0.contextData.index = slot1

	setActive(slot0.itemList[slot0.contextData.index].Find(slot2, "Selected"), true)
	setImageAlpha(slot0.itemList[slot0.contextData.index].Find(slot2, "Button"), 1)
	slot0:UpdateFighter(slot1)

	function slot3()
		slot1 = slot0.currentFighterImage:GetComponent(typeof(Image))
		slot2 = tf(slot0.currentFighterImage)

		LeanTween.cancel(go(slot0.currentFighterImage))

		slot3 = nil
		slot4 = slot0.currentNameImage:GetComponent(typeof(Image))
		slot5 = tf(slot0.currentNameImage)

		LeanTween.cancel(go(slot0.currentNameImage))
		parallelAsync({
			function (slot0)
				if slot0.color.a < 0.05 then
					slot0()

					return
				end

				LeanTween.alpha(slot1, 0, slot1 * 0.2):setOnComplete(System.Action(slot0))
			end,
			function (slot0)
				if slot0.color.a < 0.05 then
					slot0()

					return
				end

				LeanTween.alpha(slot1, 0, slot1 * 0.2):setOnComplete(System.Action(slot0))
			end,
			function (slot0)
				slot0.loader:GetSpriteDirect("ui/AirForceOfDragonEmperyUI_atlas", slot1[slot2], function (slot0)
					slot0 = slot0

					slot1()
				end, slot0.currentFighterImage)
			end,
			function (slot0)
				slot0.loader:GetSpriteDirect("ui/AirForceOfDragonEmperyUI_atlas", slot1[slot2] .. "_BG", function (slot0)
					slot0 = slot0

					slot1()
				end, slot0.currentNameImage)
			end
		}, function ()
			slot0.enabled = true
			slot0.sprite = true

			LeanTween.alpha(slot2, 1, 0.2)

			slot3.enabled = true
			slot3.sprite = slot4

			LeanTween.alpha(slot5, 1, 0.2)
		end)
	end

	slot3()

	function slot4()
		slot0 = slot0.currentFighterDesc:Find("Desc/Text")

		LeanTween.cancel(slot0)
		slot0:GetComponent("ScrollText"):SetText(i18n(slot1[slot0.GetComponent("ScrollText")]))
		LeanTween.textAlpha(slot0, 1, 0.5):setFrom(0)
	end

	slot4()

	slot5, slot6 = slot0:GetFighterData(slot1)
	slot7 = slot0.currentFighterDesc:Find("Progress")

	UIItemList.StaticAlign(slot7, slot7:GetChild(0), 3, function (slot0, slot1, slot2)
		if not slot0 == UIItemList.EventUpdate then
			return
		end

		setActive(slot2:GetChild(0), slot1 + 1 <= slot0)

		slot2:GetChild(0).localScale = Vector3(0, 1, 1)
	end)
	LeanTween.cancel(go(slot7))
	LeanTween.value(go(slot7), 0, 1, 0.6000000000000001):setOnUpdate(System.Action_float(function (slot0)
		for slot4 = 0, 2, 1 do
			slot0:GetChild(slot4).GetChild(slot5, 0).localScale = Vector3(math.clamp(3 * slot0 - slot4, 0, 1), 1, 1)
		end
	end))
	slot0.loader.GetSprite(slot8, "ui/AirForceOfDragonEmperyUI_atlas", slot0[slot1] .. "_Text", slot0.currentFighterDesc:Find("Name"), true)
end

slot0.UpdateFighter = function (slot0, slot1)
	slot8, slot10 = slot0:GetFighterData(slot1)

	UIItemList.StaticAlign(slot0.itemList[slot1].Find(slot4, "Progress"), slot0.itemList[slot1].Find(slot4, "Progress"):GetChild(0), slot2)
	updateDrop(slot0.currentFighterDesc.Find(slot5, "Item"), slot7)
	setActive(slot0.currentFighterDesc.Find(slot5, "ItemMask"), slot3)
	onButton(slot0, slot0.currentFighterDesc.Find(slot5, "Item"), function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
end

slot0.CheckActivityUpdate = function (slot0)
	for slot5 = 1, slot0.activity:getConfig("config_client")[1], 1 do
		slot6, slot7 = slot0:GetFighterData(slot5)

		if slot6 >= 3 and not slot7 then
			slot0:emit(AirForceOfDragonEmperyMediator.ON_ACTIVITY_OPREATION, {
				cmd = 2,
				activity_id = slot0.activity.id,
				arg1 = slot5
			})

			return
		end
	end
end

return slot0

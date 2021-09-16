slot0 = class("WSMapLeft", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	fleet = "table",
	rtArrow = "userdata",
	delayCallFuncs = "table",
	toggles = "table",
	onAgonyClickEnabled = "boolean",
	rtAmmo = "userdata",
	toggleSelected = "userdata",
	onAgonyClick = "function",
	rtSubBar = "userdata",
	btnCollapse = "userdata",
	world = "table",
	toggleMask = "userdata",
	rtBG = "userdata",
	rtVanguard = "userdata",
	rtSalvageList = "userdata",
	toggleList = "userdata",
	onLongPress = "function",
	rtFleet = "userdata",
	transform = "userdata",
	rtShip = "userdata",
	onClickSalvage = "function",
	rtMain = "userdata",
	rtFleetBar = "userdata"
}
slot0.Listeners = {
	onUpdateShipHpRate = "OnUpdateShipHpRate",
	onUpdateFleetOrder = "OnUpdateFleetOrder",
	onUpdateFleetBar = "OnUpdateFleetBar",
	onUpdateCatSalvage = "OnUpdateCatSalvage",
	onUpdateShipBroken = "OnUpdateShipBroken",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet"
}
slot0.EventSelectFleet = "WSMapLeft.EventSelectFleet"

slot0.Setup = function (slot0)
	pg.DelegateInfo.New(slot0)

	slot0.delayCallFuncs = {}

	slot0:Init()
	slot0:AddWorldListener()
	slot0:UpdateAllCatSalvage()
end

slot0.Dispose = function (slot0)
	function slot1(slot0)
		LeanTween.cancel(go(slot0))
		LeanTween.cancel(go(slot0:Find("text")))
	end

	eachChild(slot0.rtMain, function (slot0)
		slot1 = slot0:Find("HP_POP")

		slot0(slot1:Find("heal"))
		slot0(slot1:Find("normal"))
	end)
	eachChild(slot0.rtVanguard, function (slot0)
		slot1 = slot0:Find("HP_POP")

		slot0(slot1:Find("heal"))
		slot0(slot1:Find("normal"))
	end)
	slot0.RemoveWorldListener(slot0)
	slot0:RemoveFleetListener(slot0.fleet)
	slot0:RemoveMapListener()
	pg.DelegateInfo.Dispose(slot0)
	slot0:Clear()
end

slot0.Init = function (slot0)
	slot0.rtBG = slot0.transform.Find(slot1, "bg")
	slot0.rtFleet = slot0.rtBG:Find("fleet")
	slot0.rtMain = slot0.rtFleet:Find("main")
	slot0.rtVanguard = slot0.rtFleet:Find("vanguard")
	slot0.rtShip = slot0.rtFleet:Find("shiptpl")
	slot0.btnCollapse = slot0.rtBG:Find("collapse")
	slot0.rtArrow = slot0.btnCollapse:Find("arrow")
	slot0.rtFleetBar = slot0.transform.Find(slot1, "other/fleet_bar")
	slot0.toggleMask = slot0.transform.Find(slot1, "mask")
	slot0.toggleList = slot0.toggleMask:Find("list")
	slot0.toggles = {}

	for slot5 = 0, slot0.toggleList.childCount - 1, 1 do
		table.insert(slot0.toggles, slot0.toggleList:GetChild(slot5))
	end

	slot0.rtSubBar = slot1:Find("other/sub_bar")
	slot0.rtAmmo = slot0.rtSubBar:Find("text")
	slot0.rtSalvageList = slot1:Find("other/salvage_list")

	setActive(slot0.rtShip, false)
	setActive(slot0.toggleMask, false)
	setActive(slot0.rtSubBar, false)
	onButton(slot0, slot0.btnCollapse, function ()
		slot0:Collpase()
	end, SFX_PANEL)
	onButton(slot0, slot0.rtFleetBar, function ()
		slot0:ShowToggleMask(function (slot0)
			slot0:DispatchEvent(slot1.EventSelectFleet, slot0)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot0.toggleMask, function ()
		slot0:HideToggleMask()
	end, SFX_PANEL)
end

slot0.AddWorldListener = function (slot0)
	underscore.each(nowWorld:GetNormalFleets(), function (slot0)
		slot0:AddListener(WorldMapFleet.EventUpdateCatSalvage, slot0.onUpdateCatSalvage)
	end)
end

slot0.RemoveWorldListener = function (slot0)
	underscore.each(nowWorld:GetNormalFleets(), function (slot0)
		slot0:RemoveListener(WorldMapFleet.EventUpdateCatSalvage, slot0.onUpdateCatSalvage)
	end)
end

slot0.UpdateMap = function (slot0, slot1)
	slot0:RemoveMapListener()

	slot0.map = slot1

	slot0:AddMapListener()
	slot0:OnUpdateSelectedFleet()
	slot0:OnUpdateSubmarineSupport()
end

slot0.AddMapListener = function (slot0)
	if slot0.map then
		slot0.map:AddListener(WorldMap.EventUpdateFIndex, slot0.onUpdateSelectedFleet)
	end
end

slot0.RemoveMapListener = function (slot0)
	if slot0.map then
		slot0.map:RemoveListener(WorldMap.EventUpdateFIndex, slot0.onUpdateSelectedFleet)
	end
end

slot0.AddFleetListener = function (slot0, slot1)
	if slot1 then
		slot1:AddListener(WorldMapFleet.EventUpdateShipOrder, slot0.onUpdateFleetOrder)
		slot1:AddListener(WorldMapFleet.EventUpdateBuff, slot0.onUpdateFleetBar)
		_.each(slot1:GetShips(true), function (slot0)
			slot0:AddListener(WorldMapShip.EventHpRantChange, slot0.onUpdateShipHpRate)
			slot0:AddListener(WorldMapShip.EventUpdateBroken, slot0.onUpdateShipBroken)
		end)
	end
end

slot0.RemoveFleetListener = function (slot0, slot1)
	if slot1 then
		slot1:RemoveListener(WorldMapFleet.EventUpdateShipOrder, slot0.onUpdateFleetOrder)
		slot1:RemoveListener(WorldMapFleet.EventUpdateBuff, slot0.onUpdateFleetBar)
		_.each(slot1:GetShips(true), function (slot0)
			slot0:RemoveListener(WorldMapShip.EventHpRantChange, slot0.onUpdateShipHpRate)
			slot0:RemoveListener(WorldMapShip.EventUpdateBroken, slot0.onUpdateShipBroken)
		end)
	end
end

slot0.OnUpdateSelectedFleet = function (slot0)
	if slot0.fleet ~= slot0.map:GetFleet() then
		slot0:RemoveFleetListener(slot0.fleet)

		slot0.fleet = slot1

		slot0:AddFleetListener(slot0.fleet)

		slot0.delayCallFuncs = {}

		slot0:UpdateShipList(slot0.rtMain, slot0.fleet:GetTeamShips(TeamType.Main, true))
		slot0:UpdateShipList(slot0.rtVanguard, slot0.fleet:GetTeamShips(TeamType.Vanguard, true))
		setImageSprite(slot0.rtFleetBar:Find("text_selected/x"), getImageSprite(slot0.toggles[slot1.index]:Find("text_selected/x")))
		slot0:OnUpdateFleetBar(nil, slot1)
	end
end

slot0.UpdateAllCatSalvage = function (slot0)
	slot2 = slot0.rtSalvageList:GetChild(0)

	for slot6 = slot0.rtSalvageList.childCount + 1, #nowWorld:GetNormalFleets(), 1 do
		cloneTplTo(slot2, slot0.rtSalvageList, slot2.name)
	end

	for slot6 = #slot1 + 1, slot0.rtSalvageList.childCount, 1 do
		setActive(slot0.rtSalvageList:GetChild(slot6 - 1), false)
	end

	underscore.each(slot1, function (slot0)
		slot0:OnUpdateCatSalvage(nil, slot0)
	end)
end

slot0.OnUpdateCatSalvage = function (slot0, slot1, slot2)
	setActive(slot0.rtSalvageList:GetChild(slot2.index - 1), slot2:IsCatSalvage())

	if slot2.IsCatSalvage() then
		GetImageSpriteFromAtlasAsync("commandericon/" .. slot6, "", slot4:Find("icon"))
		setActive(slot4:Find("rarity"), slot2:GetRarityState() > 0)
		setActive(slot4:Find("doing"), slot2.catSalvageStep < #slot2.catSalvageList)
		setSlider(slot4:Find("doing/Slider"), 0, #slot2.catSalvageList, slot2.catSalvageStep)
		setActive(slot4:Find("finish"), slot2.catSalvageStep == #slot2.catSalvageList)
	end

	onButton(slot0, slot4, function ()
		slot0.onClickSalvage(slot1.id)
	end, SFX_PANEL)
end

slot0.OnUpdateSubmarineSupport = function (slot0)
	setActive(slot0.rtSubBar, nowWorld:IsSubmarineSupporting())

	if nowWorld:GetSubmarineFleet() then
		setText(slot0.rtAmmo, slot1:GetAmmo() .. "/" .. slot1:GetTotalAmmo())
		setGray(slot0.rtSubBar, slot1:GetAmmo() <= 0, true)
	end
end

slot0.OnUpdateFleetOrder = function (slot0)
	slot0.delayCallFuncs = {}

	slot0:UpdateShipList(slot0.rtMain, slot0.fleet:GetTeamShips(TeamType.Main, true))
	slot0:UpdateShipList(slot0.rtVanguard, slot0.fleet:GetTeamShips(TeamType.Vanguard, true))
end

slot0.GetShipObject = function (slot0, slot1)
	slot4 = ({
		[TeamType.Main] = slot0.rtMain,
		[TeamType.Vanguard] = slot0.rtVanguard
	})[WorldConst.FetchShipVO(slot1.id):getTeamType()]

	for slot9, slot10 in ipairs(slot5) do
		if slot1.id == slot10.id then
			return slot4:GetChild(slot9 - 1)
		end
	end
end

slot0.OnUpdateShipHpRate = function (slot0, slot1, slot2)
	slot3 = slot0:GetShipObject(slot2)

	table.insert(slot0.delayCallFuncs[slot2.id], function ()
		slot0:ShipDamageDisplay(slot0, , true)
	end)

	if not slot0.delayCallFuncs[slot2.id].isDoing then
		table.remove(slot0.delayCallFuncs[slot2.id], 1)()
	end
end

slot0.OnUpdateShipBroken = function (slot0, slot1, slot2)
	setActive(slot0:GetShipObject(slot2).Find(slot3, "broken"), slot2:IsBroken())
end

slot0.OnUpdateFleetBar = function (slot0, slot1, slot2)
	setActive(slot0.rtFleetBar:Find("watching_buff"), slot2:GetWatchingBuff())

	if slot2.GetWatchingBuff() then
		if #slot3.config.icon > 0 then
			GetImageSpriteFromAtlasAsync("world/watchingbuff/" .. slot3.config.icon, "", slot0.rtFleetBar:Find("watching_buff"))
		else
			setImageSprite(slot0.rtFleetBar:Find("watching_buff"), nil)
		end
	end
end

slot0.UpdateShipList = function (slot0, slot1, slot2)
	slot3 = UIItemList.New(slot1, slot0.rtShip)

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateShip(slot2, WorldConst.FetchShipVO(slot0[slot1 + 1].id))
			onButton(slot1, slot2:Find("agony"), function ()
				if slot0.onAgonyClickEnabled then
					slot0.onAgonyClick()
				end
			end, SFX_PANEL)

			slot1.delayCallFuncs[slot0[slot1 + 1].id] = {}

			slot1.ShipDamageDisplay(slot4, slot3, slot2)
			pg.DelegateInfo.Add(slot1, slot4)
			GetOrAddComponent(slot2, "UILongPressTrigger").onLongPressed.RemoveAllListeners(slot4)
			GetOrAddComponent(slot2, "UILongPressTrigger").onLongPressed:AddListener(function ()
				slot0.onLongPress(slot1)
			end)
		end
	end)
	slot3.align(slot3, #slot2)
end

slot0.ShipDamageDisplay = function (slot0, slot1, slot2, slot3)
	slot4 = slot2:Find("HP_POP")

	setActive(slot4, true)
	setActive(slot4:Find("heal"), false)
	setActive(slot4:Find("normal"), false)

	slot5 = slot2:Find("blood")

	if slot3 then
		function slot9(slot0, slot1)
			setActive(slot0, true)
			setText(findTF(slot0, "text"), slot1)
			setTextAlpha(findTF(slot0, "text"), 0)

			slot0.delayCallFuncs[slot1.id].isDoing = true

			parallelAsync({
				function (slot0)
					LeanTween.moveY(slot0, 60, 1):setOnComplete(System.Action(slot0))
				end,
				function (slot0)
					LeanTween.textAlpha(findTF(slot0, "text"), 1, 0.3):setOnComplete(System.Action(function ()
						LeanTween.textAlpha(findTF(slot0, "text"), 0, 0.5):setDelay(0.4):setOnComplete(System.Action(LeanTween.textAlpha(findTF(slot0, "text"), 0, 0.5).setDelay(0.4)))
					end))
				end
			}, function ()
				slot0.localPosition = Vector3(0, 0, 0)

				if not slot1.delayCallFuncs[slot2.id] then
					return
				end

				slot1.delayCallFuncs[slot2.id].isDoing = false

				if #slot1.delayCallFuncs[slot2.id] > 0 then
					table.remove(slot1.delayCallFuncs[slot2.id], 1)()
				end
			end)
		end

		function slot10(slot0)
			LeanTween.moveX(slot0, slot1, 0.05):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(4)
			LeanTween.alpha(findTF(slot0, "red"), 0.5, 0.4)
			LeanTween.alpha(findTF(slot0, "red"), 0, 0.4):setDelay(0.4)
		end

		if calcFloor((slot1.hpRant - slot5:GetComponent(typeof(Slider)).value) / 10000 * WorldConst.FetchShipVO(slot1.id):getShipProperties()[AttributeType.Durability]) > 0 then
			slot9(findTF(slot4, "heal"), slot8)
		elseif slot8 < 0 then
			slot10(slot2)
			slot9(findTF(slot4, "normal"), slot8)
		end
	end

	setActive(slot6, not not slot1:IsHpSafe())
	setActive(slot7, slot8)

	slot5:GetComponent(typeof(Slider)).fillRect = (not slot1.IsHpSafe() and slot7) or slot6

	setSlider(slot5, 0, 10000, slot1.hpRant)
	setActive(slot5.GetComponent(typeof(Slider)), slot8)
	setActive(slot2:Find("broken"), slot1:IsBroken())
end

slot0.ShowToggleMask = function (slot0, slot1)
	slot0.toggleList.position.x = slot0.rtFleetBar.position.x
	slot0.toggleList.position = slot0.toggleList.position

	setActive(slot0.toggleMask, true)

	slot3 = slot0.map:GetNormalFleets()

	for slot7, slot8 in ipairs(slot0.toggles) do
		setActive(slot8, slot3[slot7])

		if slot3[slot7] then
			setActive(slot8:Find("selected"), slot7 == slot0.map.findex)
			setActive(slot8:Find("text"), not (slot7 == slot0.map.findex))
			setActive(slot8:Find("text_selected"), slot7 == slot0.map.findex)
			setActive(slot8:Find("watching_buff"), slot9:GetWatchingBuff())

			if slot9.GetWatchingBuff() then
				if #slot11.config.icon > 0 then
					GetImageSpriteFromAtlasAsync("world/watchingbuff/" .. slot11.config.icon, "", slot8:Find("watching_buff"))
				else
					setImageSprite(slot8:Find("watching_buff"), nil)
				end
			end

			onButton(slot0, slot8, function ()
				slot0:HideToggleMask()
				slot0(slot2)
			end, SFX_UI_TAG)
		end
	end
end

slot0.HideToggleMask = function (slot0)
	setActive(slot0.toggleMask, false)
end

slot0.Collpase = function (slot0)
	setActive(slot0.rtFleet, not isActive(slot0.rtFleet))

	slot0.rtArrow.localScale.x = -slot0.rtArrow.localScale.x
	slot0.rtArrow.localScale = slot0.rtArrow.localScale
end

return slot0

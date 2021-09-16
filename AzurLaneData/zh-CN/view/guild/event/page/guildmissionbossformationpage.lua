slot0 = class("GuildMissionBossFormationPage", import(".GuildEventBasePage"))

slot0.getUIName = function (slot0)
	return "GuildBossFormationPage"
end

slot0.OnLoaded = function (slot0)
	slot0.closeBtn = slot0:findTF("frame/close")
	slot0.descTxt = slot0:findTF("frame/bottom/target/scrollrect/Text"):GetComponent(typeof(Text))
	slot0.awardList = UIItemList.New(slot0:findTF("frame/bottom/award/list"), slot0:findTF("frame/bottom/award/list/item"))
	slot0.titleTxt = slot0:findTF("frame/title"):GetComponent(typeof(Text))
	slot0.goBtn = slot0:findTF("frame/bottom/go")
	slot0.consumeTxt = slot0:findTF("oil/Text", slot0.goBtn):GetComponent(typeof(Text))
	slot0.recomBtn = slot0:findTF("frame/recom")
	slot0.clearBtn = slot0:findTF("frame/clear")
	slot0.grids = slot0:findTF("frame/double")
	slot0.subGrids = slot0:findTF("frame/single")
	slot0.nextBtn = slot0:findTF("frame/next")
	slot0.prevBtn = slot0:findTF("frame/prev")
	slot0.commanderPage = GuildCommanderFormationPage.New(slot0:findTF("frame/commanders"), slot0.event, slot0.contextData)

	setText(slot0:findTF("oil/label", slot0.goBtn), i18n("text_consume"))

	slot0.flag = slot0:findTF("frame/double/1/flag")
	slot0.subFlag = slot0:findTF("frame/single/1/flag")
	slot0.shipCards = {}
end

slot0.Show = function (slot0, slot1, slot2, slot3)
	slot0.super.Show(slot0, slot1, slot2, slot3)

	Input.multiTouchEnabled = false
end

slot0.Hide = function (slot0, slot1)
	slot0.super.Hide(slot0, slot1)

	Input.multiTouchEnabled = true
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.nextBtn, function ()
		slot0:UpdateFleet(GuildBossMission.SUB_FLEET_ID)
	end, SFX_PANEL)
	onButton(slot0, slot0.prevBtn, function ()
		slot0:UpdateFleet(GuildBossMission.MAIN_FLEET_ID)
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		if slot0.contextData.editBossFleet then
			slot0:emit(GuildEventMediator.ON_SAVE_FORMATION, function ()
				slot0:Hide()
			end)
		else
			slot0.Hide(slot0)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.goBtn, function ()
		slot0:emit(GuildEventMediator.ON_UPDATE_BOSS_FLEET)
	end, SFX_PANEL)
	onButton(slot0, slot0.recomBtn, function ()
		slot0:emit(GuildEventMediator.ON_RECOMM_BOSS_BATTLE_SHIPS, slot0.fleet.id)
	end, SFX_PANEL)
	onButton(slot0, slot0.clearBtn, function ()
		slot0.contextData.editBossFleet = {}
		slot1 = Clone(slot0.contextData.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID.fleet)

		slot1:RemoveAll()

		slot0.contextData.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID.contextData.editBossFleet[slot0.contextData.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID] = slot1

		slot0.contextData.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID:UpdateFleet(slot0.contextData.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID)
	end, SFX_PANEL)
end

slot0.UpdateMission = function (slot0, slot1, slot2)
	slot0.bossMission = slot1

	if slot2 then
		slot0:UpdateFleet(slot0.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID)
	end
end

slot0.OnBossCommanderFormationChange = function (slot0)
	slot0.fleet = slot0.contextData.editBossFleet[slot0.fleet.id]

	slot0:UpdateCommanders(slot0.fleet)
end

slot0.OnBossCommanderPrefabFormationChange = function (slot0)
	slot0:UpdateCommanders(slot0.fleet)
end

slot0.OnShow = function (slot0)
	slot0.isOpenCommander = slot0:CheckCommanderPanel()
	slot0.guild = slot0.guild

	slot0:UpdateMission(slot0.extraData.mission, true)
	slot0:UpdateDesc()

	slot0.consumeTxt.text = string.format("<color=%s>%d</color>/%d", (pg.guildset.use_oil.key_value <= getProxy(PlayerProxy):getRawData():getResource(2) and COLOR_GREEN) or COLOR_RED, slot3, slot2)
end

slot0.CheckCommanderPanel = function (slot0)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(slot0.player.level, "CommandRoomMediator") and not LOCK_COMMANDER
end

slot0.UpdateDesc = function (slot0)
	slot0.descTxt.text = i18n("guild_boss_fleet_desc")

	slot0.awardList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, slot4)
			onButton(slot1, slot2, function ()
				slot0:emit(BaseUI.ON_DROP, slot0)
			end, SFX_PANEL)
		end
	end)
	slot0.awardList.align(slot3, #slot0.bossMission.GetAwards(slot1))

	slot0.titleTxt.text = slot0.bossMission:GetName()
end

slot0.UpdateFleet = function (slot0, slot1)
	slot3 = nil
	slot0.fleet = (not slot0.contextData.editBossFleet or not slot0.contextData.editBossFleet[slot1] or slot0.contextData.editBossFleet[slot1]) and slot0.bossMission:GetFleetByIndex(slot1)

	slot0:UpdateShips((not slot0.contextData.editBossFleet or not slot0.contextData.editBossFleet[slot1] or slot0.contextData.editBossFleet[slot1]) and slot0.bossMission.GetFleetByIndex(slot1))
	slot0:UpdateCommanders((not slot0.contextData.editBossFleet or not slot0.contextData.editBossFleet[slot1] or slot0.contextData.editBossFleet[slot1]) and slot0.bossMission.GetFleetByIndex(slot1))

	slot0.contextData.bossFormationIndex = slot1

	setActive(slot0.nextBtn, slot1 == GuildBossMission.MAIN_FLEET_ID)
	setActive(slot0.prevBtn, slot1 == GuildBossMission.SUB_FLEET_ID)
end

slot0.UpdateCommanders = function (slot0, slot1)
	if slot0.isOpenCommander then
		slot0.commanderPage:ExecuteAction("Update", slot1, getProxy(CommanderProxy):getPrefabFleet())
	end
end

slot0.UpdateShips = function (slot0, slot1)
	slot0:ClearShips()

	slot3 = {}
	slot4 = {}
	slot5 = {}

	for slot9, slot10 in ipairs(slot2) do
		if slot10 and slot10.ship then
			if slot10.ship:getTeamType() == TeamType.Vanguard then
				table.insert(slot4, slot10)
			elseif slot11 == TeamType.Main then
				table.insert(slot3, slot10)
			elseif slot11 == TeamType.Submarine then
				table.insert(slot5, slot10)
			end
		end
	end

	if slot1:IsMainFleet() then
		slot0:UpdateMainFleetShips(slot3, slot4)
	else
		slot0:UpdateSubFleetShips(slot5)
	end

	setActive(slot0.flag, slot6 and #slot3 > 0)
	setActive(slot0.subFlag, not slot6 and #slot5 > 0)
	setActive(slot0.grids, slot6)
	setActive(slot0.subGrids, not slot6)
end

slot0.UpdateMainFleetShips = function (slot0, slot1, slot2)
	for slot6 = 1, 3, 1 do
		slot0:UpdateShip(slot6, slot0.grids:Find(slot6), TeamType.Main, slot1[slot6])
	end

	for slot6 = 4, 6, 1 do
		slot0:UpdateShip(slot6, slot0.grids:Find(slot6), TeamType.Vanguard, slot2[slot6 - 3])
	end
end

slot0.UpdateSubFleetShips = function (slot0, slot1)
	for slot5 = 1, 3, 1 do
		slot0:UpdateShip(slot5, slot0.subGrids:Find(slot5), TeamType.Submarine, slot1[slot5])
	end
end

slot0.UpdateShip = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot2:Find("Image")

	if slot4 then
		PoolMgr.GetInstance():GetSpineChar(slot4.ship.getPrefab(slot6), true, function (slot0)
			slot0.name = slot0

			SetParent(slot0, slot1.parent)
			GuildBossFormationShipCard.New(slot0).Update(slot1, GuildBossFormationShipCard.New(slot0).Update, )
			SetAction(slot0, "stand")

			slot2 = GetOrAddComponent(slot0, "EventTriggerListener")

			slot2:AddPointClickFunc(function (slot0, slot1)
				if slot0.dragging then
					return
				end

				slot0:emit(GuildEventMediator.ON_SELECT_BOSS_SHIP, slot1, slot0.fleet.id, slot0.emit)
			end)
			slot2.AddBeginDragFunc(slot2, function (slot0, slot1)
				slot0.dragging = true

				slot0.transform:SetAsLastSibling()
				SetAction(slot0, "tuozhuai")
			end)
			slot2.AddDragFunc(slot2, function (slot0, slot1)
				slot2 = slot0.Scr2Lpos(slot1.parent, slot1.position)

				slot2:SetLocalPosition(slot2)

				if slot2.SetLocalPosition:GetNearestCard(slot2) then
					slot3:SwopCardSolt(slot3, slot2)
				end
			end)
			slot2.AddDragEndFunc(slot2, function (slot0, slot1)
				slot0.dragging = false

				slot1:RefreshPosition(slot1:GetSoltIndex(), true)
				SetAction(slot0, "stand")
				slot0:RefreshFleet()
			end)
			table.insert(slot2.shipCards, slot1)
		end)
	else
		onButton(slot0, slot5, function ()
			slot0:emit(GuildEventMediator.ON_SELECT_BOSS_SHIP, slot0, slot0.fleet.id)
		end, SFX_PANEL)
	end

	setActive(slot5, not slot4)
end

slot0.GetNearestCard = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.shipCards) do
		if slot6:GetSoltIndex() ~= slot1:GetSoltIndex() and slot6.teamType == slot1.teamType and Vector2.Distance(slot1:GetLocalPosition(), slot6:GetLocalPosition()) <= 50 then
			return slot6
		end
	end

	return nil
end

slot0.SwopCardSolt = function (slot0, slot1, slot2)
	slot1:RefreshPosition(slot2:GetSoltIndex(), true)
	slot2:RefreshPosition(slot1:GetSoltIndex(), false)
end

slot0.RefreshFleet = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.shipCards) do
		table.insert(slot1, {
			index = slot6:GetSoltIndex(),
			shipId = slot6.shipId
		})
	end

	table.sort(slot1, function (slot0, slot1)
		return slot0.index < slot1.index
	end)

	if not slot0.contextData.editBossFleet then
		slot0.contextData.editBossFleet = {}
	end

	if not slot0.contextData.editBossFleet[slot0.fleet.id] then
		slot0.contextData.editBossFleet[slot0.fleet.id] = Clone(slot0.fleet)
		slot0.fleet = slot0.contextData.editBossFleet[slot0.fleet.id]
	end

	slot0.fleet.ResortShips(slot2, slot1)
end

slot0.ClearShips = function (slot0)
	for slot4, slot5 in ipairs(slot0.shipCards) do
		slot5:Dispose()
	end

	slot0.shipCards = {}
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)
	slot0:ClearShips()
	slot0.commanderPage:Destroy()
end

slot0.Scr2Lpos = function (slot0, slot1)
	return LuaHelper.ScreenToLocal(slot0:GetComponent("RectTransform"), slot1, GameObject.Find("OverlayCamera"):GetComponent("Camera"))
end

return slot0

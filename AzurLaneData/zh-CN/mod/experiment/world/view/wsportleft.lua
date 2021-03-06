slot0 = class("WSPortLeft", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	rtVanguard = "userdata",
	rtFleet = "userdata",
	gid = "number",
	rtShip = "userdata",
	transform = "userdata",
	rtBG = "userdata",
	rtMain = "userdata",
	fleet = "table"
}
slot0.Listeners = {
	onUpdateSelectedFleet = "OnUpdateSelectedFleet",
	onUpdateShip = "OnUpdateShip"
}

slot0.Setup = function (slot0)
	pg.DelegateInfo.New(slot0)
	slot0:Init()
end

slot0.Dispose = function (slot0)
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

	setActive(slot0.rtShip, false)
end

slot0.UpdateMap = function (slot0, slot1)
	if slot0.map ~= slot1 or slot0.gid ~= slot1.gid then
		slot0:RemoveMapListener()

		slot0.map = slot1
		slot0.gid = slot1.gid

		slot0:AddMapListener()
		slot0:OnUpdateSelectedFleet()
	end
end

slot0.AddMapListener = function (slot0)
	if slot0.map then
		slot0.map:AddListener(WorldMap.EventUpdateFIndex, slot0.onUpdateSelectedFleet)
	end
end

slot0.RemoveMapListener = function (slot0)
	if slot0.map then
		slot0.map:RemoveListener(WorldMap.EventUpdateFIndex, slot0.onUpdateSelectedFleet)
		slot0:RemoveFleetListener(slot0.fleet)
	end
end

slot0.AddFleetListener = function (slot0, slot1)
	if slot1 then
		_.each(slot1:GetShips(true), function (slot0)
			slot0:AddListener(WorldMapShip.EventHpRantChange, slot0.onUpdateShip)
		end)
	end
end

slot0.RemoveFleetListener = function (slot0, slot1)
	if slot1 then
		_.each(slot1:GetShips(true), function (slot0)
			slot0:RemoveListener(WorldMapShip.EventHpRantChange, slot0.onUpdateShip)
		end)
	end
end

slot0.OnUpdateSelectedFleet = function (slot0)
	if slot0.fleet ~= slot0.map:GetFleet() then
		slot0:RemoveFleetListener(slot0.fleet)

		slot0.fleet = slot1

		slot0:AddFleetListener(slot0.fleet)
		slot0:UpdateShipList(slot0.rtMain, slot0.fleet:GetTeamShipVOs(TeamType.Main, true))
		slot0:UpdateShipList(slot0.rtVanguard, slot0.fleet:GetTeamShipVOs(TeamType.Vanguard, true))
	end
end

slot0.OnUpdateShip = function (slot0, slot1, slot2)
	if slot0.map:GetFleet(slot2.fleetId).GetFleetType(slot3) == FleetType.Normal then
		slot0:UpdateShipList(slot0.rtMain, slot0.fleet:GetTeamShipVOs(TeamType.Main, true))
		slot0:UpdateShipList(slot0.rtVanguard, slot0.fleet:GetTeamShipVOs(TeamType.Vanguard, true))
	elseif slot4 == FleetType.Submarine then
		slot0:UpdateShipList(slot0.rtSubmarine, slot0.submarineFleet:GetTeamShipVOs(TeamType.Submarine, true))
	end
end

slot0.UpdateShipList = function (slot0, slot1, slot2)
	slot3 = UIItemList.New(slot1, slot0.rtShip)

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateShip(slot2, slot3)

			slot5 = findTF(slot2, "HP_POP")

			setActive(slot5, true)
			setActive(findTF(slot5, "heal"), false)
			setActive(findTF(slot5, "normal"), false)
			setActive(slot7, not not WorldConst.FetchWorldShip(slot0[slot1 + 1].id).IsHpSafe(slot4))
			setActive(slot8, slot9)

			findTF(slot2, "blood"):GetComponent(typeof(Slider)).fillRect = (not WorldConst.FetchWorldShip(slot0[slot1 + 1].id).IsHpSafe(slot4) and slot8) or slot7

			setSlider(slot6, 0, 10000, slot4.hpRant)
			setActive(findTF(slot2, "blood").GetComponent(typeof(Slider)), slot9)
			setActive(slot2:Find("broken"), slot4:IsBroken())
		end
	end)
	slot3.align(slot3, #slot2)
end

return slot0

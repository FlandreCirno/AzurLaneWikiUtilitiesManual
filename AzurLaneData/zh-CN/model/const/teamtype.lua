slot0 = class("TeamType")
slot0.Vanguard = "vanguard"
slot0.Main = "main"
slot0.Submarine = "submarine"
slot0.TeamTypeIndex = {
	[slot0.Vanguard] = 1,
	[slot0.Main] = 2,
	[slot0.Submarine] = 3
}
slot0.VanguardShipType = {
	ShipType.QuZhu,
	ShipType.QingXun,
	ShipType.ZhongXun,
	ShipType.HangXun,
	ShipType.LeiXun,
	ShipType.ChaoXun,
	ShipType.Yunshu
}
slot0.MainShipType = {
	ShipType.ZhanXun,
	ShipType.ZhanLie,
	ShipType.QingHang,
	ShipType.ZhengHang,
	ShipType.HangZhan,
	ShipType.WeiXiu,
	ShipType.ZhongPao
}
slot0.SubShipType = {
	ShipType.QianTing,
	ShipType.QianMu
}
slot0.VanguardMax = 3
slot0.MainMax = 3
slot0.SubmarineMax = 3
slot0.TeamPos = {
	FLAG_SHIP = "FlagShip",
	LEADER = "Leader",
	REAR = "Rear",
	CONSORT = "Consort",
	SUB_LEADER = "SubLeader",
	SUB_CONSORT = "SubConsort"
}

slot0.TeamToTypeList = function (slot0)
	if slot0 == slot0.Vanguard then
		return slot0.VanguardShipType
	elseif slot0 == slot0.Main then
		return slot0.MainShipType
	elseif slot0 == slot0.Submarine then
		return slot0.SubShipType
	end
end

slot0.TypeToTeamType = function (slot0)
	if table.contains(slot0.VanguardShipType, slot0) then
		return slot0.Vanguard
	elseif table.contains(slot0.MainShipType, slot0) then
		return slot0.Main
	elseif table.contains(slot0.SubShipType, slot0) then
		return slot0.Submarine
	end
end

slot0.TeamTypeSortIndex = function (slot0)
	if slot0 == slot0.Main then
		return 1
	elseif slot0 == slot0.Vanguard then
		return 2
	elseif slot0 == slot0.Submarine then
		return 3
	end
end

return slot0

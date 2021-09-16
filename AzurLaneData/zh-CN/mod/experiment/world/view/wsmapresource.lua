slot0 = class("WSMapResource", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	rtDarkFog = "userdata",
	rtSairenFog = "userdata"
}

slot0.Setup = function (slot0, slot1)
	slot0.map = slot1
end

slot0.Dispose = function (slot0)
	slot0:Clear()
end

slot0.Load = function (slot0, slot1)
	slot3 = slot0.map

	table.insert(slot2, function (slot0)
		PoolMgr.GetInstance():GetUI("darkfog", true, function (slot0)
			setParent(slot0, GameObject.Find("__Pool__").transform)

			slot0.rtDarkFog = slot0.transform

			setActive(slot0.rtDarkFog, false)
			setActive()
		end)
	end)
	table.insert(slot2, function (slot0)
		PoolMgr.GetInstance():GetUI("sairenfog", true, function (slot0)
			setParent(slot0, GameObject.Find("__Pool__").transform)

			slot0.rtSairenFog = slot0.transform

			setActive(slot0.rtSairenFog, false)
			setActive()
		end)
	end)
	seriesAsync(slot2, slot1)
end

slot0.Unload = function (slot0)
	if slot0.rtDarkFog then
		PoolMgr.GetInstance():ReturnUI("darkfog", slot0.rtDarkFog.gameObject)

		slot0.rtDarkFog = nil
	end

	if slot0.rtSairenFog then
		PoolMgr.GetInstance():ReturnUI("darkfog", slot0.rtSairenFog.gameObject)

		slot0.rtSairenFog = nil
	end
end

return slot0

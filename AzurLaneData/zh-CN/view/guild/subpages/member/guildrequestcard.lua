slot0 = class("GuildRequestCard")

slot0.Ctor = function (slot0, slot1)
	slot0.tf = tf(slot1)
	slot0.nameTF = slot0.tf:Find("frame/request_info/name"):GetComponent(typeof(Text))
	slot0.levelTF = slot0.tf:Find("frame/request_info/level"):GetComponent(typeof(Text))
	slot0.dateTF = slot0.tf:Find("frame/request_info/date"):GetComponent(typeof(Text))
	slot0.msg = slot0.tf:Find("frame/request_content/Text"):GetComponent(typeof(Text))
	slot0.iconTF = slot0.tf:Find("frame/shipicon/icon"):GetComponent(typeof(Image))
	slot0.starsTF = slot0.tf:Find("frame/shipicon/stars")
	slot0.circle = slot0.tf:Find("frame/shipicon/frame")
	slot0.starTF = slot0.tf:Find("frame/shipicon/stars/star")
	slot0.rejectBtn = slot0.tf:Find("frame/refuse_btn")
	slot0.accpetBtn = slot0.tf:Find("frame/accpet_btn")
end

slot0.Update = function (slot0, slot1)
	slot0:Clear()

	slot0.requestVO = slot1
	slot0.nameTF.text = slot1.player.name
	slot0.levelTF.text = "Lv." .. slot1.player.level
	slot0.dateTF.text = getOfflineTimeStamp(slot1.timestamp)
	slot0.msg.text = slot1.content

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. slot4, AttireFrame.attireFrameRes(slot3, false, AttireConst.TYPE_ICON_FRAME, slot1.player.propose), true, function (slot0)
		if IsNil(slot0.tf) then
			return
		end

		if slot0.circle then
			slot0.name = slot1
			findTF(slot0.transform, "icon").GetComponent(slot1, typeof(Image)).raycastTarget = false

			setParent(slot0, slot0.circle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. slot1, PoolMgr.GetInstance().ReturnPrefab, slot0)
		end
	end)

	if pg.ship_data_statistics[slot1.player.icon] then
		LoadSpriteAsync("qicon/" .. slot6, function (slot0)
			slot0.iconTF.sprite = slot0
		end)

		slot7 = slot0.starsTF.childCount

		for slot11 = slot7, slot5.star - 1, 1 do
			cloneTplTo(slot0.starTF, slot0.starsTF)
		end

		for slot11 = 1, slot7, 1 do
			setActive(slot0.starsTF:GetChild(slot11 - 1), slot11 <= slot5.star)
		end
	end
end

slot0.Clear = function (slot0)
	if slot0.circle.childCount > 0 then
		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. slot2, slot0.circle:GetChild(0).gameObject.name, slot0.circle.GetChild(0).gameObject)
	end
end

slot0.Dispose = function (slot0)
	slot0:Clear()
end

return slot0

slot0 = class("GuildShipEquipmentsPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "GuildShipEquipmentsPage"
end

slot0.OnLoaded = function (slot0)
	slot0.shipNameTxt = slot0:findTF("frame/ship_info/shipname"):GetComponent(typeof(Text))
	slot0.userNameTxt = slot0:findTF("frame/ship_info/username"):GetComponent(typeof(Text))
	slot0.shipTypeIcon = slot0:findTF("frame/ship_info/ship_type"):GetComponent(typeof(Image))
	slot0.shipStarList = UIItemList.New(slot0:findTF("frame/ship_info/stars"), slot0:findTF("frame/ship_info/stars/star_tpl"))
	slot0.shipLvTxt = slot0:findTF("frame/ship_info/lv/Text"):GetComponent(typeof(Text))
	slot0.equipmentList = UIItemList.New(slot0:findTF("frame/equipemtns"), slot0:findTF("frame/equipemtns/equipment_tpl"))
	slot0.playerId = getProxy(PlayerProxy):getRawData().id
	slot0.nextBtn = slot0:findTF("frame/next")
	slot0.prevBtn = slot0:findTF("frame/prev")
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.nextBtn, function ()
		if slot0.onNext then
			slot0.onNext()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.prevBtn, function ()
		if slot0.onPrev then
			slot0.onPrev()
		end
	end, SFX_PANEL)
end

slot0.SetCallBack = function (slot0, slot1, slot2)
	slot0.onPrev = slot1
	slot0.onNext = slot2
end

slot0.Show = function (slot0, slot1, slot2, slot3, slot4)
	slot0.super.Show(slot0)

	slot0.OnHide = slot3

	if slot4 then
		slot4()
	end

	slot0:Flush(slot1, slot2)
	pg.UIMgr:GetInstance():BlurPanel(slot0._tf)
	setActive(slot0.nextBtn, slot0.onNext ~= nil)
	SetActive(slot0.prevBtn, slot0.onPrev ~= nil)
end

slot0.Flush = function (slot0, slot1, slot2)
	slot0.ship = slot1
	slot0.member = slot2

	slot0:UpdateShipInfo()
	slot0:UpdateEquipments()
end

slot0.Refresh = function (slot0, slot1, slot2)
	slot0:Flush(slot1, slot2)
end

slot0.UpdateShipInfo = function (slot0)
	slot0.shipNameTxt.text = HXSet.hxLan(slot0.ship:getName())
	slot0.userNameTxt.text = (slot0.playerId == slot0.member.id and "") or i18n("guild_ship_from") .. slot2.name
	slot0.shipTypeIcon.sprite = GetSpriteFromAtlas("shiptype", shipType2print(pg.ship_data_statistics[slot1.configId].type))
	slot6 = slot1:getStar()

	slot0.shipStarList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setActive(slot2:Find("star_tpl"), slot1 <= slot0)
		end
	end)
	slot0.shipStarList.align(slot7, slot1:getMaxStar())

	slot0.shipLvTxt.text = slot1.level
end

slot0.UpdateEquipments = function (slot0)
	slot2 = slot0.ship.getActiveEquipments(slot1)

	slot0.equipmentList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setActive(slot2:Find("info"), slot3)
			setActive(slot2:Find("empty"), not slot0[slot1 + 1])

			if slot0[slot1 + 1] then
				updateEquipment(slot2:Find("info"), slot3)
				setText(slot2:Find("info/name_bg/Text"), shortenString(HXSet.hxLan(slot3.config.name), 5))
			end
		end
	end)
	slot0.equipmentList.align(slot3, 5)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	pg.UIMgr:GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)

	if slot0.OnHide then
		slot0.OnHide()

		slot0.OnHide = nil
	end
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()
end

return slot0

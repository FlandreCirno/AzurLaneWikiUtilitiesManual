slot0 = class("GuildFirePage", import(".GuildMemberBasePage"))

slot0.getUIName = function (slot0)
	return "GuildFirePage"
end

slot0.OnLoaded = function (slot0)
	slot0.super.OnLoaded(slot0)

	slot0.fireconfirmBtn = slot0:findTF("frame/confirm_btn")
	slot0.firecancelBtn = slot0:findTF("frame/cancel_btn")
	slot0.firenameTF = slot0:findTF("frame/info/name/Text", slot0._tf):GetComponent(typeof(Text))
	slot0.fireiconTF = slot0:findTF("frame/info/shipicon/icon", slot0._tf):GetComponent(typeof(Image))
	slot0.fireduty = slot0:findTF("frame/duty"):GetComponent(typeof(Image))
	slot0.firestarsTF = slot0:findTF("frame/info/shipicon/stars", slot0._tf)
	slot0.firestarTF = slot0:findTF("frame/info/shipicon/stars/star", slot0._tf)
	slot0.firelevelTF = slot0:findTF("frame/info/level/Text", slot0._tf):GetComponent(typeof(Text))
	slot0.circle = slot0:findTF("frame/info/shipicon/frame", slot0._tf)
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.firecancelBtn, function ()
		slot0:Hide()
	end, SFX_CONFIRM)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_CONFIRM)
end

slot0.OnShow = function (slot0)
	slot1 = slot0.guildVO
	slot2 = slot0.playerVO
	slot0.firenameTF.text = slot0.memberVO.name

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. slot4, slot4, true, function (slot0)
		if IsNil(slot0._tf) then
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
	LoadSpriteAsync("qicon/" .. Ship.New({
		configId = slot0.memberVO.icon,
		skin_id = slot0.memberVO.skinId
	}).getPainting(slot6), function (slot0)
		if not IsNil(slot0.fireiconTF) then
			slot0.fireiconTF.sprite = slot0
		end
	end)

	slot0.fireduty.sprite = GetSpriteFromAtlas("dutyicon", "icon_" .. slot0.memberVO.duty)
	slot8 = slot0.firestarsTF.childCount

	for slot12 = slot8, pg.ship_data_statistics[slot0.memberVO.icon].star - 1, 1 do
		cloneTplTo(slot0.firestarTF, slot0.firestarsTF)
	end

	for slot12 = 1, slot8, 1 do
		setActive(slot0.firestarsTF:GetChild(slot12 - 1), slot12 <= slot5.star)
	end

	slot0.firelevelTF.text = "Lv." .. slot3.level

	onButton(slot0, slot0.fireconfirmBtn, function ()
		if slot0.id == slot1.id then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_fire_tip"),
			onYes = function ()
				slot0:emit(GuildMemberMediator.FIRE, slot1.id)
				slot0.emit:Hide()
			end
		})
	end, SFX_CONFIRM)
end

return slot0

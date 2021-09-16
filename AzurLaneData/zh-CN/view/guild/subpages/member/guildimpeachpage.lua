slot0 = class("GuildImpeachPage", import(".GuildMemberBasePage"))

slot0.getUIName = function (slot0)
	return "GuildImpeachPage"
end

slot0.OnLoaded = function (slot0)
	slot0.super.OnLoaded(slot0)

	slot0.impeachconfirmBtn = slot0:findTF("frame/confirm_btn")
	slot0.impeachcancelBtn = slot0:findTF("frame/cancel_btn")
	slot0.impeachnameTF = slot0:findTF("frame/info/name/Text", slot0._tf):GetComponent(typeof(Text))
	slot0.impeachiconTF = slot0:findTF("frame/info/shipicon/icon", slot0._tf):GetComponent(typeof(Image))
	slot0.impeachduty = slot0:findTF("frame/duty"):GetComponent(typeof(Image))
	slot0.impeachstarsTF = slot0:findTF("frame/info/shipicon/stars", slot0._tf)
	slot0.impeachstarTF = slot0:findTF("frame/info/shipicon/stars/star", slot0._tf)
	slot0.impeachlevelTF = slot0:findTF("frame/info/level/Text", slot0._tf):GetComponent(typeof(Text))
	slot0.circle = slot0:findTF("frame/info/shipicon/frame", slot0._tf)
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.impeachcancelBtn, function ()
		slot0:Hide()
	end, SFX_CONFIRM)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_CONFIRM)
end

slot0.OnShow = function (slot0)
	slot1 = slot0.guildVO
	slot2 = slot0.playerVO
	slot0.impeachnameTF.text = slot0.memberVO.name

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. slot4, slot4, true, function (slot0)
		if IsNil(slot0._tf) then
			return
		end

		if slot0.cirCle then
			slot0.name = slot1
			findTF(slot0.transform, "icon").GetComponent(slot1, typeof(Image)).raycastTarget = false

			setParent(slot0, slot0.cirCle, false)
		else
			PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. slot1, PoolMgr.GetInstance().ReturnPrefab, slot0)
		end
	end)
	LoadSpriteAsync("qicon/" .. Ship.New({
		configId = slot0.memberVO.icon,
		skin_id = slot0.memberVO.skinId
	}).getPainting(slot6), function (slot0)
		if not IsNil(slot0.impeachiconTF) then
			slot0.impeachiconTF.sprite = slot0
		end
	end)

	slot0.impeachduty.sprite = GetSpriteFromAtlas("dutyicon", "icon_" .. slot0.memberVO.duty)
	slot8 = slot0.impeachstarTF.childCount

	for slot12 = slot8, pg.ship_data_statistics[slot0.memberVO.icon].star - 1, 1 do
		cloneTplTo(slot0.impeachstarTF, slot0.impeachstarsTF)
	end

	for slot12 = 1, slot8, 1 do
		setActive(slot0.impeachstarsTF:GetChild(slot12 - 1), slot12 <= slot5.star)
	end

	slot0.impeachlevelTF.text = "Lv." .. slot3.level

	onButton(slot0, slot0.impeachconfirmBtn, function ()
		if slot0.id == slot1.id then
			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_impeach_tip"),
			onYes = function ()
				slot0:emit(GuildMemberMediator.IMPEACH, slot1.id)
				slot0.emit:Hide()
			end
		})
	end, SFX_CONFIRM)
end

return slot0

slot0 = class("GuildMemberInfoPage", import(".GuildMemberBasePage"))

slot0.getUIName = function (slot0)
	return "GuildMemberInfoPage"
end

slot1 = {
	{
		value = "shipCount",
		type = 1,
		tag = i18n("friend_resume_ship_count")
	},
	{
		type = 3,
		tag = i18n("friend_resume_collection_rate"),
		value = {
			"collectionCount"
		}
	},
	{
		value = "attackCount",
		type = 1,
		tag = i18n("friend_resume_attack_count")
	},
	{
		type = 2,
		tag = i18n("friend_resume_attack_win_rate"),
		value = {
			"attackCount",
			"winCount"
		}
	},
	{
		value = "pvp_attack_count",
		type = 1,
		tag = i18n("friend_resume_manoeuvre_count")
	},
	{
		type = 2,
		tag = i18n("friend_resume_manoeuvre_win_rate"),
		value = {
			"pvp_attack_count",
			"pvp_win_count"
		}
	},
	{
		value = "collect_attack_count",
		type = 1,
		tag = i18n("friend_event_count")
	}
}

slot0.OnLoaded = function (slot0)
	slot0.super.OnLoaded(slot0)

	slot0.infonameTF = slot0:findTF("frame/info/name/Text"):GetComponent(typeof(Text))
	slot0.infoiconTF = slot0:findTF("frame/info/shipicon/icon"):GetComponent(typeof(Image))
	slot0.infoduty = slot0:findTF("frame/duty"):GetComponent(typeof(Image))
	slot0.infostarsTF = slot0:findTF("frame/info/shipicon/stars")
	slot0.infostarTF = slot0:findTF("frame/info/shipicon/stars/star")
	slot0.infolevelTF = slot0:findTF("frame/info/level/Text"):GetComponent(typeof(Text))
	slot0.circle = slot0:findTF("frame/info/shipicon/frame")
	slot0.resumeInfo = slot0:findTF("frame/content")
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_CONFIRM)
end

slot0.Show = function (slot0, slot1, slot2, slot3, slot4)
	slot0.guildVO = slot1
	slot0.playerVO = slot2
	slot0.memberVO = slot3

	slot0:emit(GuildMemberMediator.OPEN_DESC_INFO, slot3)

	if slot4 then
		slot4()
	end
end

slot0.Flush = function (slot0, slot1)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._tf, true)
	slot0._tf:SetAsLastSibling()
	slot0.onShowCallBack(slot0.buttonPos)

	slot2 = slot0.guildVO
	slot0.infonameTF.text = slot0.memberVO.name

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
		if not IsNil(slot0.infoiconTF) then
			slot0.infoiconTF.sprite = slot0
		end
	end)

	slot0.infoduty.sprite = GetSpriteFromAtlas("dutyicon", "icon_" .. slot0.memberVO.duty)
	slot8 = slot0.infostarsTF.childCount

	for slot12 = slot8, pg.ship_data_statistics[slot0.memberVO.icon].star - 1, 1 do
		cloneTplTo(slot0.infostarTF, slot0.infostarsTF)
	end

	for slot12 = 1, slot8, 1 do
		setActive(slot0.infostarsTF:GetChild(slot12 - 1), slot12 <= slot5.star)
	end

	slot0.infolevelTF.text = "Lv." .. slot3.level

	for slot12, slot13 in ipairs(slot0) do
		slot14 = slot0.resumeInfo:GetChild(slot12 - 1)

		setText(slot14:Find("tag"), slot13.tag)

		slot15 = slot14:Find("tag (1)")

		if slot13.type == 1 then
			setText(slot15, slot1[slot13.value])
		elseif slot13.type == 2 then
			setText(slot15, string.format("%0.2f", math.max(slot1[slot13.value[2]], 0) / math.max(slot1[slot13.value[1]], 1) * 100) .. "%")
		elseif slot13.type == 3 then
			setText(slot15, string.format("%0.2f", (slot1[slot13.value[1]] or 1) / getProxy(CollectionProxy):getCollectionTotal() * 100) .. "%")
		end
	end
end

return slot0

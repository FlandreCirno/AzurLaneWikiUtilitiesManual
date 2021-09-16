slot0 = class("GuildAppiontPage", import(".GuildMemberBasePage"))

slot0.getUIName = function (slot0)
	return "GuildAppiontPage"
end

slot1 = {
	"commander",
	"deputyCommander",
	"picked",
	"normal"
}

slot0.OnLoaded = function (slot0)
	slot0.super.OnLoaded(slot0)

	slot0.dutyContainer = slot0:findTF("frame/duty")
	slot0.print = slot0:findTF("frame/prints/print"):GetComponent(typeof(Image))
	slot0.confirmBtn = slot0:findTF("frame/confirm_btn")
	slot0.nameTF = slot0:findTF("frame/info/name/Text", slot0._tf):GetComponent(typeof(Text))
	slot0.iconTF = slot0:findTF("frame/info/shipicon/icon", slot0._tf):GetComponent(typeof(Image))
	slot0.starsTF = slot0:findTF("frame/info/shipicon/stars", slot0._tf)
	slot0.starTF = slot0:findTF("frame/info/shipicon/stars/star", slot0._tf)
	slot0.levelTF = slot0:findTF("frame/info/level/Text", slot0._tf):GetComponent(typeof(Text))
	slot0.circle = slot0:findTF("frame/info/shipicon/frame", slot0._tf)
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.ShouldShow = function (slot0)
	return slot0.memberVO.id ~= slot0.playerVO.id
end

slot0.OnShow = function (slot0)
	slot5 = slot0.guildVO.getEnableDuty(slot3, slot4, slot0.memberVO.duty)
	slot6 = nil

	for slot10, slot11 in ipairs(slot0) do
		slot13 = slot0.dutyContainer:Find(slot11).Find(slot12, "Text")

		if slot2.duty == slot10 then
			setText(slot13, i18n("guild_duty_tip_1"))
		elseif not table.contains(slot5, slot10) then
			setText(slot13, i18n("guild_duty_tip_2"))
		end

		setActive(slot13, not table.contains(slot5, slot10))
		setToggleEnabled(slot12, table.contains(slot5, slot10))
		onToggle(slot0, slot12, function (slot0)
			if slot0 then
				slot0 = slot1
				slot2.selectedToggle = slot3
			end
		end, SFX_PANEL)
	end

	if slot3.getFaction(slot3) == GuildConst.FACTION_TYPE_BLHX then
		slot0.print.color = Color.New(0.4235294117647059, 0.6313725490196078, 0.9568627450980393)
	elseif slot7 == GuildConst.FACTION_TYPE_CSZZ then
		slot0.print.color = Color.New(0.9568627450980393, 0.44313725490196076, 0.42745098039215684)
	end

	slot0.nameTF.text = slot2.name

	PoolMgr.GetInstance():GetPrefab("IconFrame/" .. slot8, slot8, true, function (slot0)
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
		configId = slot2.icon,
		skin_id = slot2.skinId
	}).getPainting(slot10), function (slot0)
		if not IsNil(slot0.iconTF) then
			slot0.iconTF.sprite = slot0
		end
	end)

	slot11 = slot0.starsTF.childCount

	for slot15 = slot11, pg.ship_data_statistics[slot2.icon].star - 1, 1 do
		cloneTplTo(slot0.starTF, slot0.starsTF)
	end

	for slot15 = 1, slot11, 1 do
		setActive(slot0.starsTF:GetChild(slot15 - 1), slot15 <= slot9.star)
	end

	slot0.levelTF.text = "Lv." .. slot2.level

	onButton(slot0, slot0.confirmBtn, function ()
		function slot0()
			slot0:emit(GuildMemberMediator.SET_DUTY, slot1.id, )
			slot0.emit:Hide()
		end

		if slot3 == GuildConst.DUTY_COMMANDER and slot2 == GuildConst.DUTY_COMMANDER then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
				content = i18n("guild_transfer_president_confirm", slot1.name),
				onYes = slot0
			})
		else
			slot0()
		end
	end, SFX_CONFIRM)
end

return slot0

slot0 = class("GuildTechnologyCard")

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.view = slot2

	pg.DelegateInfo.New(slot0)

	slot0._go = slot1
	slot0._tf = tf(slot1)
	slot0.titleImg = slot0._tf:Find("title"):GetComponent(typeof(Text))
	slot0.iconImag = slot0._tf:Find("icon"):GetComponent(typeof(Image))
	slot0.levelTxt = slot0._tf:Find("level"):GetComponent(typeof(Text))
	slot0.descTxt = slot0._tf:Find("desc"):GetComponent(typeof(Text))
	slot0.upgradeTF = slot0._tf:Find("upgrade")
	slot0.guildRes = slot0.upgradeTF:Find("cion")
	slot0.guildResTxt = slot0.upgradeTF:Find("cion/Text"):GetComponent(typeof(Text))
	slot0.goldRes = slot0.upgradeTF:Find("gold")
	slot0.goldResTxt = slot0.upgradeTF:Find("gold/Text"):GetComponent(typeof(Text))
	slot0.upgradeBtn = slot0.upgradeTF:Find("upgrade_btn")
	slot0.maxTF = slot0._tf:Find("max")
	slot0.breakoutTF = slot0._tf:Find("breakout")
	slot0.breakoutSlider = slot0._tf:Find("progress"):GetComponent(typeof(Slider))
	slot0.breakoutTxt = slot0._tf:Find("progress/Text"):GetComponent(typeof(Text))
	slot0.livnessTF = slot0.upgradeTF:Find("livness")

	setActive(slot0.breakoutSlider.gameObject, false)
	setActive(slot0.upgradeTF, false)
	setActive(slot0.maxTF, false)
	setActive(slot0.breakoutTF, false)
end

slot0.Update = function (slot0, slot1, slot2)
	slot0.titleImg.text = slot1:getConfig("name")
	slot0.iconImag.sprite = GetSpriteFromAtlas("GuildTechnology", slot3)
	slot6 = slot1:GetLevel()
	slot8 = math.max(slot5, slot7)

	if slot1:IsGuildMember() then
		slot0.levelTxt.text = "Lv." .. slot6
	else
		slot0.levelTxt.text = "Lv." .. slot6 .. "/" .. slot8 .. string.format(" [%s+%s]", slot5, math.max(0, slot7 - slot5))
	end

	slot0.descTxt.text = slot1:GetDesc()

	setActive(slot0.maxTF, slot8 <= slot6)
	setActive(slot0.upgradeTF, slot6 < slot8)

	slot9 = slot1:_ReachTargetLiveness_()

	removeOnButton(slot0._tf)

	if slot1:CanUpgrade() then
		slot9 = true
		slot0.guildResTxt.text, slot0.goldResTxt.text = slot1:GetConsume()

		onButton(slot0, slot0._tf, function ()
			if slot1 <= slot0 then
				return
			end

			slot2:DoUprade(slot3)
		end, SFX_PANEL)
	elseif not slot9 then
		setText(slot0.livnessTF, i18n("guild_tech_livness_no_enough_label", slot1.GetTargetLivness(slot1)))
	end

	setActive(slot0.guildRes, slot9)
	setActive(slot0.goldRes, slot9)
	setActive(slot0.upgradeBtn, slot9)
	setActive(slot0.livnessTF, not slot9)
	setActive(slot0.breakoutSlider.gameObject, slot2 and slot2.id == slot3)

	if slot2 and slot2.id == slot3 then
		slot0.breakoutSlider.value = slot2:GetProgress() / slot2:GetTargetProgress()
		slot0.breakoutTxt.text = slot13 .. "/" .. slot2.GetTargetProgress()
	end
end

slot0.DoUprade = function (slot0, slot1)
	function slot2()
		slot8, slot9 = slot0:GetConsume()

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			content = i18n("guild_tech_consume_tip", slot1, slot2, slot0:getConfig("name")),
			onYes = function ()
				slot0.view:emit(GuildTechnologyMediator.ON_UPGRADE, slot1.group.id)
			end
		})
	end

	function slot3(slot0)
		if slot0:IsRiseInPrice() then
			slot1, slot2, slot3 = slot0:CanUpgradeBySelf()
			slot4 = i18n("guild_tech_price_inc_tip")

			if slot3 and not slot2 then
				slot4 = i18n("guild_tech_livness_no_enough", slot0:GetLivenessOffset())
			end

			pg.MsgboxMgr:GetInstance():ShowMsgBox({
				content = slot4,
				onYes = slot0
			})
		else
			slot0()
		end
	end

	seriesAsync({
		function (slot0)
			slot0(slot0)
		end,
		function (slot0)
			slot0()
		end
	})
end

slot0.Destroy = function (slot0)
	pg.DelegateInfo.Dispose(slot0)
end

return slot0

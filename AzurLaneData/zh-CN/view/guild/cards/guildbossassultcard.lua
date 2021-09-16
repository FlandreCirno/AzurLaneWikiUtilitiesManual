slot0 = class("GuildBossAssultCard")

slot0.Ctor = function (slot0, slot1)
	slot0._tr = tf(slot1)
	slot0._go = slot1
	slot0.mask = findTF(slot0._tr, "mask"):GetComponent(typeof(Image))
	slot0.icon = findTF(slot0._tr, "icon/icon"):GetComponent(typeof(Image))
	slot0.shipNameTxt = findTF(slot0._tr, "info/shipname"):GetComponent(typeof(Text))
	slot0.userNameTxt = findTF(slot0._tr, "info/username"):GetComponent(typeof(Text))
	slot0.levelTxt = findTF(slot0._tr, "info/lv/Text"):GetComponent(typeof(Text))
	slot0.startList = UIItemList.New(findTF(slot0._tr, "info/stars"), findTF(slot0._tr, "info/stars/star_tpl"))
	slot0.recommendBtn = findTF(slot0._tr, "info/recom_btn")
	slot0.recommendBtnMark = slot0.recommendBtn:Find("mark")
	slot0.viewEquipmentBtn = findTF(slot0._tr, "info/view_equipment")
	slot0.tag = findTF(slot0._tr, "tag")
end

slot0.Flush = function (slot0, slot1, slot2)
	slot0.shipNameTxt.text = slot2.name
	slot0.ship = slot2
	slot0.member = slot1
	slot0.levelTxt.text = slot2.level
	slot4 = slot2:getStar()

	slot0.startList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setActive(slot2:Find("star_tpl"), slot1 <= slot0)
		end
	end)
	slot0.startList.align(slot5, slot3)

	slot0.userNameTxt.text = i18n("guild_ship_from") .. slot1.name

	LoadSpriteAsync("shipYardIcon/" .. slot2:getPainting(), function (slot0)
		if slot0._tr then
			slot0.icon.sprite = slot0
		end
	end)

	slot6 = false

	if #slot2.rarity2bgPrint(slot2) > 1 then
		if string.sub(slot5, 1, 1) == "1" then
			slot6 = true
		else
			slot5 = string.sub(slot5, 2, 1)
		end
	end

	slot0:LoadMetaEffect(slot6)

	slot0.mask.sprite = GetSpriteFromAtlas("ui/GuildBossAssultUI_atlas", slot5)

	setActive(slot0.recommendBtnMark, slot2.guildRecommand)
	setActive(slot0.tag, slot2.guildRecommand)
	setActive(slot0.recommendBtn, GuildMember.IsAdministrator(getProxy(GuildProxy):getRawData():getSelfDuty()))
end

slot1 = "meta_huoxing"

slot0.LoadMetaEffect = function (slot0, slot1)
	if slot0.loading then
		slot0.destoryMetaEffect = not slot1

		return
	end

	if slot1 and not slot0.metaEffect then
		slot0.loading = true

		PoolMgr.GetInstance():GetUI(slot0, true, function (slot0)
			slot0.loading = nil

			if slot0.destoryMetaEffect then
				slot0:RemoveMetaEffect()

				slot0.destoryMetaEffect = nil
			else
				slot0.metaEffect = slot0

				SetParent(slot0.metaEffect, slot0._tr)
				setActive(slot0, true)
			end
		end)
	elseif not slot1 and slot0.metaEffect then
		slot0.RemoveMetaEffect(slot0)
	elseif slot0.metaEffect then
		setActive(slot0.metaEffect, true)
	end
end

slot0.RemoveMetaEffect = function (slot0)
	if slot0.metaEffect then
		PoolMgr.GetInstance():ReturnUI(slot0, slot0.metaEffect)

		slot0.metaEffect = nil
	end
end

slot0.Dispose = function (slot0)
	slot0:RemoveMetaEffect()

	slot0.destoryMetaEffect = true
end

return slot0

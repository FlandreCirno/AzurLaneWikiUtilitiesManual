slot0 = class("GuildBossRankPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "GuildBossRankPage"
end

function slot1(slot0)
	return {
		numer = slot0.transform:Find("numer"):GetComponent(typeof(Text)),
		name = slot0.transform:Find("name"):GetComponent(typeof(Text)),
		damage = slot0.transform:Find("damage"):GetComponent(typeof(Text)),
		Update = function (slot0, slot1, slot2)
			slot0.numer.text = slot1
			slot0.name.text = slot2.name
			slot0.damage.text = slot2.damage
		end
	}
end

slot0.OnLoaded = function (slot0)
	slot0.scrollrect = slot0:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	slot0.closeBtn = slot0:findTF("frame/close")

	setText(slot0:findTF("frame/titles/num"), i18n("guild_damage_ranking"))
	setText(slot0:findTF("frame/titles/member"), i18n("guild_word_member"))
	setText(slot0:findTF("frame/titles/damage"), i18n("guild_total_damage"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)

	slot0.scrollrect.onInitItem = function (slot0)
		slot0:OnInitItem(slot0)
	end

	slot0.scrollrect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end

	slot0.cards = {}
end

slot0.OnInitItem = function (slot0, slot1)
	slot0.cards[slot1] = slot0(slot1)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	slot0.cards[slot2]:Update(slot1 + 1, slot0.ranks[slot1 + 1])
end

slot0.Show = function (slot0, slot1)
	slot0.super.Show(slot0)

	slot0.ranks = slot1

	slot0.scrollrect:SetTotalCount(#slot1)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0

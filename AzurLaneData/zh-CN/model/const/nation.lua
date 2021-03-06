slot0 = class("Nation")
slot0.CM = 0
slot0.US = 1
slot0.EN = 2
slot0.JP = 3
slot0.DE = 4
slot0.CN = 5
slot0.ITA = 6
slot0.SN = 7
slot0.FF = 8
slot0.MNF = 9
slot0.META = 97
slot0.BURIN = 98
slot0.LINK = 100
slot0.IDOL_LINK = 107

slot0.IsLinkType = function (slot0)
	return slot0.LINK < slot0
end

slot0.IsMeta = function (slot0)
	return slot0 == slot0.META
end

slot0.Nation2Print = function (slot0)
	if not slot0.prints then
		slot0.prints = {
			[0] = "cm",
			"us",
			"en",
			"jp",
			"de",
			"cn",
			"ita",
			"sn",
			"ff",
			"mnf",
			[101.0] = "np",
			[98.0] = "cm",
			[104.0] = "um",
			[97.0] = "meta",
			[107.0] = "um",
			[102.0] = "bili",
			[106.0] = "um",
			[103.0] = "um",
			[105.0] = "um"
		}
	end

	return slot0.prints[slot0]
end

slot0.Nation2Side = function (slot0)
	if not slot0.side then
		slot0.side = {
			[0] = "West",
			"West",
			"West",
			"Jp",
			"West",
			"Cn",
			"West",
			"West",
			"West",
			"West",
			[101.0] = "Jp",
			[98.0] = "West",
			[104.0] = "West",
			[97.0] = "Meta",
			[107.0] = "Imas",
			[102.0] = "Cn",
			[106.0] = "Jp",
			[103.0] = "Jp",
			[105.0] = "Jp"
		}
	end

	return slot0.side[slot0]
end

slot0.Nation2BG = function (slot0)
	if not slot0.bg then
		slot0.bg = {
			[0] = "bg/bg_church",
			"bg/bg_church",
			"bg/bg_church",
			"bg/bg_church_jp",
			"bg/bg_church",
			"bg/bg_church_cn",
			"bg/bg_church",
			"bg/bg_church",
			"bg/bg_church",
			"bg/bg_church",
			[101.0] = "bg/bg_church",
			[98.0] = "bg/bg_church",
			[104.0] = "bg/bg_church",
			[97.0] = "bg/bg_church_meta",
			[107.0] = "bg/bg_church_imas",
			[102.0] = "bg/bg_church",
			[106.0] = "bg/bg_church",
			[103.0] = "bg/bg_church",
			[105.0] = "bg/bg_church"
		}
	end

	return slot0.bg[slot0]
end

slot0.Nation2Name = function (slot0)
	if not slot0.nationName then
		slot0.nationName = {
			[0] = i18n("word_shipNation_other"),
			i18n("word_shipNation_baiYing"),
			i18n("word_shipNation_huangJia"),
			i18n("word_shipNation_chongYing"),
			i18n("word_shipNation_tieXue"),
			i18n("word_shipNation_dongHuang"),
			i18n("word_shipNation_saDing"),
			i18n("word_shipNation_beiLian"),
			i18n("word_shipNation_ziyou"),
			i18n("word_shipNation_weixi"),
			[97] = i18n("word_shipNation_meta"),
			[98] = i18n("word_shipNation_other"),
			[101] = i18n("word_shipNation_np"),
			[102] = i18n("word_shipNation_bili"),
			[103] = i18n("word_shipNation_um"),
			[104] = i18n("word_shipNation_ai"),
			[105] = i18n("word_shipNation_holo"),
			[106] = i18n("word_shipNation_doa"),
			[107] = i18n("word_shipNation_imas")
		}
	end

	return slot0.nationName[slot0]
end

slot0.Nation2facionName = function (slot0)
	if not slot0.facionName then
		slot0.facionName = {
			[0] = i18n("guild_faction_unknown"),
			i18n("guild_faction_blhx"),
			i18n("guild_faction_blhx"),
			i18n("guild_faction_cszz"),
			i18n("guild_faction_cszz"),
			i18n("guild_faction_blhx"),
			i18n("guild_faction_cszz"),
			i18n("guild_faction_blhx"),
			i18n("guild_faction_blhx"),
			i18n("guild_faction_cszz"),
			[97] = i18n("guild_faction_meta"),
			[98] = i18n("guild_faction_unknown"),
			[101] = i18n("guild_faction_unknown"),
			[102] = i18n("guild_faction_unknown"),
			[103] = i18n("guild_faction_unknown"),
			[104] = i18n("guild_faction_unknown"),
			[105] = i18n("guild_faction_unknown"),
			[106] = i18n("guild_faction_unknown"),
			[107] = i18n("guild_faction_unknown")
		}
	end

	return slot0.facionName[slot0]
end

return slot0

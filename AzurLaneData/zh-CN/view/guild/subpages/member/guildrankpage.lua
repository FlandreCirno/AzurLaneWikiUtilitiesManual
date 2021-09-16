slot0 = class("GuildRankPage", import("...base.GuildBasePage"))

slot0.getTargetUI = function (slot0)
	return "GuildRankBluePage", "GuildRankRedPage"
end

slot1 = {
	"commit",
	"task",
	"battle"
}
slot2 = {
	i18n("guild_member_rank_title_donate"),
	i18n("guild_member_rank_title_finish_cnt"),
	i18n("guild_member_rank_title_join_cnt")
}

slot0.PageId2RankLabel = function (slot0)
	return slot0[slot0]
end

slot0.GetRank = function (slot0, slot1)
	return slot0.ranks[slot1]
end

slot0.OnUpdateRankList = function (slot0, slot1, slot2)
	if slot2 and table.getCount(slot2) > 0 then
		slot0.ranks[slot1] = slot2

		if slot0.pageId == slot1 then
			slot0:SwitchPage(slot1)
		end
	end
end

slot0.OnLoaded = function (slot0)
	slot0.tabContainer = slot0:findTF("frame/bg/tab")
	slot0.ranTypeTF = slot0:findTF("frame/bg/week")
	slot0.closeBtn = slot0:findTF("frame/close")
	slot0.rankLabel = slot0:findTF("frame/bg/title/Text"):GetComponent(typeof(Text))
	slot0.scrollrect = slot0:findTF("frame/bg/scrollrect"):GetComponent("LScrollRect")

	slot0.scrollrect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end

	setActive(slot0.ranTypeTF.Find(slot2, "month"), true)
	setActive(slot0.ranTypeTF:Find("total"), true)
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)

	slot0.ranType = 0

	onButton(slot0, slot0.ranTypeTF, function ()
		slot0.ranType = (slot0.ranType + 1) % 3

		(slot0.ranType + 1) % 3()
	end, SFX_PANEL)
	slot0.InitTags(slot0)
	function ()
		if slot0.pageId then
			slot0:SwitchPage(slot0.pageId)
		end

		slot0.enabled = slot0.ranType == 0
		slot0.enabled = slot0.ranType == 2
		slot0.enabled = slot0.ranType == 1
	end()
end

slot0.InitTags = function (slot0)
	for slot4, slot5 in ipairs(slot0) do
		onToggle(slot0, slot0.tabContainer:Find(slot5), function (slot0)
			if slot0 then
				slot0:SwitchPage(slot0.SwitchPage)
			end
		end, SFX_PANEL)
	end
end

slot0.Flush = function (slot0, slot1)
	slot0.ranks = slot1

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:Show()
	slot0._tf:SetAsLastSibling()
	triggerToggle(slot0.tabContainer:Find("commit"), true)
end

slot0.SwitchPage = function (slot0, slot1)
	slot0.pageId = slot1

	slot0.scrollrect:SetTotalCount(0)

	slot2 = slot0:GetRank(slot1)

	if getProxy(GuildProxy):ShouldRefreshRank(slot1) then
		slot0:emit(GuildMemberMediator.GET_RANK, slot1)
	else
		slot0:InitRank(slot2)
	end

	slot0.rankLabel.text = slot0.PageId2RankLabel(slot1)
end

slot0.InitRank = function (slot0, slot1)
	slot0.displays = {}

	for slot5, slot6 in pairs(slot1) do
		table.insert(slot0.displays, slot6)
	end

	table.sort(slot0.displays, function (slot0, slot1)
		return slot1:GetScore(slot0.ranType) < slot0:GetScore(slot0.ranType)
	end)
	slot0.scrollrect.SetTotalCount(slot2, #slot0.displays)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	setText(tf(slot2):Find("number"), slot1 + 1)
	setText(tf(slot2):Find("name"), slot0.displays[slot1 + 1].GetName(slot3))
	setText(tf(slot2):Find("score"), slot0.displays[slot1 + 1]:GetScore(slot0.ranType))
end

slot0.Hide = function (slot0)
	if slot0:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	end

	slot0.super.Hide(slot0)
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()
end

return slot0

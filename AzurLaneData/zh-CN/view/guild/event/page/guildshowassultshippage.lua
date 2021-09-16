slot0 = class("GuildShowAssultShipPage", import(".GuildEventBasePage"))

slot0.getUIName = function (slot0)
	return "GuildShowAssultShipPage"
end

slot0.OnLoaded = function (slot0)
	slot0.scrollrect = slot0:findTF("frame/scrollrect"):GetComponent("LScrollRect")
	slot0.closeBtn = slot0:findTF("frame/close")
	slot0.progress = slot0:findTF("frame/progress"):GetComponent(typeof(Text))
end

slot0.OnAssultShipBeRecommanded = function (slot0, slot1)
	slot0:InitList()
end

slot0.OnRefreshAll = function (slot0)
	slot0:InitData()

	slot1 = {}

	for slot5, slot6 in ipairs(slot0.displays) do
		slot1[slot6.ship.id] = slot6
	end

	for slot5, slot6 in pairs(slot0.cards) do
		if slot1[slot6.ship.id] then
			slot6:Flush(slot7.member, slot7.ship)
		end
	end
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)

	slot0.cards = {}

	slot0.scrollrect.onInitItem = function (slot0)
		slot0:OnInitItem(slot0)
	end

	slot0.scrollrect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end
end

slot0.GetRecommandShipCnt = function (slot0)
	slot1 = 0

	for slot5, slot6 in ipairs(slot0.displays) do
		if slot6.ship.guildRecommand then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot0.OnInitItem = function (slot0, slot1)
	slot2 = GuildBossAssultCard.New(slot1)

	onButton(slot0, slot2.recommendBtn, function ()
		(slot0.ship.guildRecommand and GuildConst.CANCEL_RECOMMAND_SHIP) or GuildConst.RECOMMAND_SHIP:emit(GuildEventMediator.REFRESH_RECOMMAND_SHIPS, function ()
			if slot0 == GuildConst.RECOMMAND_SHIP and slot1:GetRecommandShipCnt() >= 9 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_recommend_limit"))

				return
			end

			if ((slot2.guildRecommand and GuildConst.RECOMMAND_SHIP) or GuildConst.CANCEL_RECOMMAND_SHIP) ~= () then
				slot1:emit(GuildEventMediator.ON_RECOMM_ASSULT_SHIP, slot2.id, slot0)
			elseif slot0 == GuildConst.RECOMMAND_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_assult_ship_recommend_conflict"))
			elseif slot0 == GuildConst.CANCEL_RECOMMAND_SHIP then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_cancel_assult_ship_recommend_conflict"))
			end
		end)
	end, SFX_PANEL)

	function slot3()
		if IsNil(slot0._tf) then
			return
		end

		pg.UIMgr:GetInstance():BlurPanel(slot0._tf)
	end

	function slot4()
		if IsNil(slot0._tf) then
			return
		end

		pg.UIMgr:GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	end

	onButton(slot0, slot2.viewEquipmentBtn, function ()
		slot1:emit(GuildEventLayer.SHOW_SHIP_EQUIPMENTS, slot0.ship, slot0.member, slot1.emit, slot1)
	end, SFX_PANEL)

	slot0.cards[slot1] = slot2
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitItem(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:Flush(slot0.displays[slot1 + 1].member, slot0.displays[slot1 + 1].ship)

	slot0.progress.text = slot6 .. "/" .. slot0.totalPageCnt
end

slot0.OnShow = function (slot0)
	slot0:emit(GuildEventMediator.ON_GET_ALL_ASSULT_FLEET, function ()
		slot0:InitList()
	end)
end

slot0.InitData = function (slot0)
	slot2 = slot0.player
	slot0.displays = {}

	for slot7, slot8 in pairs(slot3) do
		for slot14, slot15 in pairs(slot10) do
			table.insert(slot0.displays, {
				ship = slot15,
				member = slot8
			})
		end
	end

	table.sort(slot0.displays, function (slot0, slot1)
		return ((slot0.ship.guildRecommand and 1) or 0) > ((slot1.ship.guildRecommand and 1) or 0)
	end)
end

slot0.InitList = function (slot0)
	slot0:InitData()

	slot0.totalPageCnt = math.ceil(#slot0.displays / 9)

	slot0.scrollrect:SetTotalCount(#slot0.displays)
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)

	for slot4, slot5 in pairs(slot0.cards) do
		slot5:Dispose()
	end
end

return slot0

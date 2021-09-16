slot0 = class("GuildMemberListPage", import("...base.GuildBasePage"))

slot0.getTargetUI = function (slot0)
	return "GuildMemberListBlueUI", "GuildMemberListRedUI"
end

slot0.OnLoaded = function (slot0)
	slot0.rectView = slot0:findTF("scroll")
	slot0.rectRect = slot0.rectView:GetComponent("LScrollRect")
	slot0.rankBtn = slot0:findTF("rank")
	slot0.blurBg = slot0:findTF("blur_bg", slot0._tf)
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.rankBtn, function ()
		slot0.contextData.rankPage:ExecuteAction("Flush", slot0.ranks)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance().OverlayPanelPB(slot1, slot0._tf, {
		pbList = {
			slot0.blurBg
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})

	slot0.items = {}

	slot0.rectRect.onInitItem = function (slot0)
		slot0:OnInitItem(slot0)
	end

	slot0.rectRect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end
end

slot0.SetUp = function (slot0, slot1, slot2, slot3)
	slot0:Show()
	slot0:Flush(slot1, slot2, slot3)
end

slot0.Flush = function (slot0, slot1, slot2, slot3)
	slot0.ranks = slot3
	slot0.memberVOs = slot2
	slot0.guildVO = slot1

	slot0:SetTotalCount()
end

slot0.SetTotalCount = function (slot0)
	table.sort(slot0.memberVOs, function (slot0, slot1)
		if slot0.duty ~= slot1.duty then
			return slot0.duty < slot1.duty
		else
			return slot1.liveness < slot0.liveness
		end
	end)
	slot0.rectRect.SetTotalCount(slot1, #slot0.memberVOs, 0)
end

slot0.OnInitItem = function (slot0, slot1)
	onButton(slot0, GuildMemberCard.New(slot1).tf, function ()
		if slot0.selected == slot1 then
			return
		end

		if slot0.selected then
			slot0.selected:SetSelected(false)
		end

		slot0.selected = slot1

		slot0.selected:SetSelected(true)

		if slot0.selected.SetSelected.OnClickMember then
			slot0.OnClickMember(slot1.memberVO)
		end
	end, SFX_PANEL)

	slot0.items[slot1] = GuildMemberCard.New(slot1)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	if not slot0.items[slot2] then
		slot0:OnInitItem(slot2)

		slot3 = slot0.items[slot2]
	end

	slot3:Update(slot0.memberVOs[slot1 + 1], slot0.guildVO)

	if not slot0.selected and slot1 == 0 then
		triggerButton(slot3.tf)
	end
end

slot0.TriggerFirstCard = function (slot0)
	for slot4, slot5 in pairs(slot0.items) do
		if slot5.memberVO.id == slot0.memberVOs[1].id then
			triggerButton(slot5.tf)

			break
		end
	end
end

slot0.OnDestroy = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf, slot0._parentTf)

	for slot4, slot5 in pairs(slot0.items) do
		slot5:Dispose()
	end
end

return slot0

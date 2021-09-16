slot0 = class("CommanderHomeLevelInfoPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "CommanderHomeLevelUI"
end

slot0.OnLoaded = function (slot0)
	slot0.close = slot0:findTF("bg/frame/close_btn")
	slot0.scrollrect = slot0:findTF("bg/frame/scrollrect"):GetComponent("LScrollRect")
	slot0.levelTxt = slot0:findTF("bg/frame/level/Text"):GetComponent(typeof(Text))
	slot0.descPanel = slot0:findTF("desc_panel")
	slot0.descLevelTxt = slot0.descPanel:Find("frame/level"):GetComponent(typeof(Text))
	slot0.descTxt = slot0.descPanel:Find("frame/Text"):GetComponent(typeof(Text))
	slot0.expTxt = slot0:findTF("bg/frame/level/exp"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	slot0.cards = {}

	slot0.scrollrect.onInitItem = function (slot0)
		slot0:OnInitItem(slot0)
	end

	slot0.scrollrect.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateItem(slot0, slot1)
	end

	onButton(slot0, slot0.descPanel, function ()
		slot0:CloseDescWindow()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.close, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.OnInitItem = function (slot0, slot1)
	slot0.cards[slot1] = CommanderHomeLevelCard.New(slot1, slot0)
end

slot0.OnUpdateItem = function (slot0, slot1, slot2)
	if not slot0.cards[slot2] then
		slot0:OnInitItem(slot2)

		slot3 = slot0.cards[slot2]
	end

	slot3:Update(slot0.home, slot0.displays[slot1 + 1])
end

slot0.Show = function (slot0, slot1)
	slot0.super.Show(slot0)

	slot0.home = slot1

	slot0:InitMainView()
end

slot0.InitMainView = function (slot0)
	slot0.levelTxt.text = "LV." .. slot0.home.GetLevel(slot1)
	slot0.expTxt.text = "EXP " .. slot0.home.exp .. "/" .. slot0.home.GetNextLevelExp(slot1)
	slot0.displays = {}
	slot3 = slot0.home.bindConfigTable(slot1)

	for slot7, slot8 in ipairs(slot2) do
		table.insert(slot0.displays, {
			level = slot3[slot8].level,
			totalExp = slot1:GetTargetExpForLevel(slot8),
			tail = slot7 == #slot2,
			exp = slot9.home_exp,
			desc = slot3[slot8].desc
		})
	end

	slot0.scrollrect:SetTotalCount(#slot0.displays)
end

slot0.ShowDescWindow = function (slot0, slot1, slot2)
	setActive(slot0.descPanel, true)

	slot0.descTxt.text = slot1
	slot0.descLevelTxt.text = "LV." .. slot2
end

slot0.CloseDescWindow = function (slot0)
	setActive(slot0.descPanel, false)
end

slot0.OnDestroy = function (slot0)
	for slot4, slot5 in pairs(slot0.cards) do
		slot5:Dispose()
	end
end

return slot0

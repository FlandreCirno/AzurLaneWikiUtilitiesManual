slot0 = class("CatteryDescPage", import("...base.BaseSubView"))
slot0.CHANGE_STYLE = "CatteryDescPage:CHANGE_STYLE"
slot0.CHANGE_COMMANDER = "CatteryDescPage:CHANGE_COMMANDER"

slot0.getUIName = function (slot0)
	return "CatteryDescPage"
end

slot0.OnCatteryUpdate = function (slot0, slot1)
	slot0:Flush(slot1)

	if slot0.page and slot0.page:GetLoaded() and slot0.page:isShowing() then
		slot0.page:OnCatteryUpdate(slot1)
	end
end

slot0.OnCatteryStyleUpdate = function (slot0, slot1)
	slot0.cattery = slot1

	slot0:UpdateCatteryStyle()

	if slot0.page and slot0.page:GetLoaded() and slot0.page:isShowing() and isa(slot0.page, CommanderHomeSelCatteryStylePage) then
		slot0.page:OnCatteryStyleUpdate(slot1)
	end
end

slot0.OnLoaded = function (slot0)
	slot0.closeBtn = slot0:findTF("right/close_btn")
	slot0.styleIcon = slot0:findTF("left/bg/mask/icon"):GetComponent(typeof(Image))
	slot0.char = slot0:findTF("left/bg/char")
	slot0.commanderEmpty = slot0:findTF("left/bg/info/empty")
	slot0.styleInfo = slot0.commanderEmpty
	slot0.commanderExp = slot0:findTF("left/bg/info/commander_exp")
	slot0.commanderLevelTxt = slot0.commanderExp:Find("level/Text"):GetComponent(typeof(Text))
	slot0.commanderExpTxt = slot0.commanderExp:Find("value_bg/Text"):GetComponent(typeof(Text))
	slot0.commanderExpImg = slot0.commanderExp:Find("exp/Image")
	slot0.toggleGroup = slot0:findTF("left/tags"):GetComponent(typeof(ToggleGroup))
	slot0.pagesTF = slot0:findTF("right/pages")
	slot0.tags = {
		slot0:findTF("left/tags/commander"),
		slot0:findTF("left/tags/home")
	}
	slot0.pages = {
		CommanderHomeSelCommanderPage.New(slot0.pagesTF, slot0._event),
		CommanderHomeSelCatteryStylePage.New(slot0.pagesTF, slot0._event)
	}
end

slot0.OnInit = function (slot0)
	slot0:bind(slot0.CHANGE_STYLE, function (slot0, slot1)
		slot0:PreviewCatteryStyle(slot1)
	end, SFX_PANEL)
	slot0.bind(slot0, slot0.CHANGE_COMMANDER, function (slot0, slot1)
		slot0:PreviewCatteryCommader(slot1)
	end)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)

	for slot4, slot5 in ipairs(slot0.tags) do
		onToggle(slot0, slot5, function (slot0)
			if slot0 then
				slot0:SwitchPage(slot0.SwitchPage)
			end
		end, SFX_PANEL)
	end
end

slot0.SwitchPage = function (slot0, slot1)
	if slot0.page == slot0.pages[slot1] then
		return
	end

	if slot0.page then
		slot0.page:Hide()
	end

	slot2:ExecuteAction("Update", slot0.home, slot0.cattery)

	slot0.page = slot2

	setActive(slot0.commanderEmpty, slot3)
	setActive(slot0.commanderExp, not isa(slot2, CommanderHomeSelCatteryStylePage))
	slot0:FlushCatteryInfo()
end

slot0.Update = function (slot0, slot1, slot2)
	slot0:Show()

	slot0.home = slot1
	slot0.cattery = slot2
	slot0.page = nil

	triggerToggle(slot0.tags[1], true)
	slot0:Flush(slot2)
end

slot0.Flush = function (slot0, slot1)
	slot0.cattery = slot1

	slot0:FlushCatteryInfo()
	slot0:UpdateCatteryStyle()
end

slot0.FlushCatteryInfo = function (slot0)
	slot1 = false

	if isa(slot0.page, CommanderHomeSelCommanderPage) then
		slot1 = slot0.cattery:ExistCommander()
	end

	slot0:UpdateCommander(slot0.cattery:GetCommander())

	slot2 = slot0.home
end

slot0.UpdateCommander = function (slot0, slot1)
	slot0:ReturnChar()

	if slot1 ~= nil then
		slot0:LoadChar(slot1)

		slot0.commanderLevelTxt.text = "LV." .. slot1:getLevel()
		slot0.commanderExpTxt.text = "<color=#92FC63FF>" .. slot1.exp .. "</color>/" .. slot1:getNextLevelExp()

		setFillAmount(slot0.commanderExpImg, slot1.exp / slot1:getNextLevelExp())
	end

	setActive(slot0.commanderExp, slot2)
	setActive(slot0.commanderEmpty, not slot2)
end

slot0.PreviewCatteryCommader = function (slot0, slot1)
	slot0:UpdateCommander(slot1)
end

slot0.UpdateCatteryStyle = function (slot0)
	slot2 = slot0.cattery._GetStyle_(slot1)

	if slot0.cattery:ExistCommander() then
		slot0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. slot2:GetName(slot1:IsDirty()), "")
	else
		slot0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. slot2:GetName(false), "")
	end
end

slot0.PreviewCatteryStyle = function (slot0, slot1)
	slot0.styleIcon.sprite = GetSpriteFromAtlas("CatteryStyle/" .. slot2, "")
end

slot0.LoadChar = function (slot0, slot1)
	slot0.painting = slot1:getPainting()

	setPaintingPrefab(slot0.char, slot0.painting, "info")
end

slot0.ReturnChar = function (slot0)
	if slot0.painting then
		retPaintingPrefab(slot0.char, slot0.painting)

		slot0.painting = nil
	end
end

slot0.Hide = function (slot0)
	slot0.toggleGroup:SetAllTogglesOff()
	slot0.super.Hide(slot0)

	for slot4, slot5 in pairs(slot0.pages) do
		if slot5:GetLoaded() and slot5:isShowing() then
			slot5:Hide()
		end
	end
end

slot0.OnDestroy = function (slot0)
	slot0:ReturnChar()

	for slot4, slot5 in ipairs(slot0.pages) do
		slot5:Destroy()
	end
end

return slot0

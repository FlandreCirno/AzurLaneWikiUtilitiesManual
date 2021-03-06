slot0 = class("GuildTechnologyPage", import("...base.GuildBasePage"))
slot0.PAGE_DEV = 1
slot0.PAGE_UPGRADE = 2
slot0.PAGE_DEV_ITEM = 3

slot0.getTargetUI = function (slot0)
	return "TechnologyBluePage", "TechnologyRedPage"
end

slot0.OnLoaded = function (slot0)
	slot0.frame = slot0:findTF("frame")
	slot0.toggle = slot0:findTF("frame/toggle")
	slot0.upgradeList = UIItemList.New(slot0:findTF("frame/upgrade/content"), slot0:findTF("frame/upgrade/content/tpl"))
	slot0.breakOutList = UIItemList.New(slot0:findTF("frame/breakout/content"), slot0:findTF("frame/upgrade/content/tpl"))
	slot0.breakoutListPanel = slot0:findTF("frame/breakout")
	slot0.upgradePanel = slot0:findTF("frame/upgrade")
	slot0.inDevelopmentPanel = slot0:findTF("frame/dev")
	slot0.inDevelopmentIcon = slot0:findTF("item/icon", slot0.inDevelopmentPanel):GetComponent(typeof(Image))
	slot0.inDevelopmentName = slot0:findTF("item/name", slot0.inDevelopmentPanel):GetComponent(typeof(Text))
	slot0.inDevelopmentLevel1Txt = slot0:findTF("level1/Text", slot0.inDevelopmentPanel):GetComponent(typeof(Text))
	slot0.inDevelopmentLevel2Txt = slot0:findTF("level2/Text", slot0.inDevelopmentPanel):GetComponent(typeof(Text))
	slot0.inDevelopmentLevel1Desc = slot0:findTF("level1/level/Text", slot0.inDevelopmentPanel):GetComponent(typeof(Text))
	slot0.inDevelopmentLevel2Desc = slot0:findTF("level2/level/Text", slot0.inDevelopmentPanel):GetComponent(typeof(Text))
	slot0.inDevelopmentProgress = slot0:findTF("progress/bar", slot0.inDevelopmentPanel)
	slot0.inDevelopmentProgressTxt = slot0:findTF("progress/Text", slot0.inDevelopmentPanel):GetComponent(typeof(Text))
	slot0.donateBtn = slot0:findTF("skin_btn", slot0.inDevelopmentPanel)
	slot0.cancelBtn = slot0:findTF("cancel_btn", slot0.inDevelopmentPanel)

	setText(slot0:findTF("level1/level/label", slot0.inDevelopmentPanel), i18n("guild_tech_label_max_level"))
	setText(slot0:findTF("level2/level/label", slot0.inDevelopmentPanel), i18n("guild_tech_label_max_level"))
	setText(slot0:findTF("progress/title/Text", slot0.inDevelopmentPanel), i18n("guild_tech_label_dev_progress"))
	setText(slot0:findTF("progress/title/label", slot0.inDevelopmentPanel), i18n("guild_tech_label_condition"))
end

slot0.OnInit = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanelPB(slot0.frame, {
		pbList = {
			slot0.frame
		},
		overlayType = LayerWeightConst.OVERLAY_UI_ADAPT
	})
	setActive(slot0._tf, true)
	onToggle(slot0, slot0.toggle, function (slot0)
		if slot0 then
			slot0:UpdateBreakOutList()
		else
			slot0:UpdateUpgradeList()
		end

		setActive(slot0.toggle:Find("on"), slot0)
		setActive(slot0.toggle:Find("off"), not slot0)
	end, SFX_PANEL)
	onButton(slot0, slot0.donateBtn, function ()
		slot0:emit(GuildTechnologyMediator.ON_OPEN_OFFICE)
	end, SFX_PANEL)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:Switch2BreakOutList()
	end, SFX_PANEL)
end

slot0.SetUp = function (slot0, slot1)
	slot0:Update(slot1)
	triggerToggle(slot0.toggle, false)
end

slot0.Update = function (slot0, slot1)
	slot0.guildVO = slot1
	slot0.technologyVOs = slot0.guildVO:getTechnologys()
	slot0.technologyGroupVOs = slot0.guildVO:getTechnologyGroups()
	slot0.activityGroup = _.detect(slot0.technologyGroupVOs, function (slot0)
		return slot0:GetState() == GuildTechnologyGroup.STATE_START
	end)
	slot0.isAdmin = GuildMember.IsAdministrator(slot1.getSelfDuty(slot1))
end

slot0.Flush = function (slot0)
	if slot0.PAGE_DEV == slot0.page then
		slot0:InitBreakOutList()
	elseif slot0.PAGE_UPGRADE == slot0.page then
		slot0:UpdateUpgradeList()
	elseif slot0.PAGE_DEV_ITEM == slot0.page then
		slot0:InitDevingItem()
	end
end

slot0.UpdateUpgradeList = function (slot0)
	table.sort(slot0.technologyVOs, function (slot0, slot1)
		return slot0.id < slot1.id
	end)
	slot0.upgradeList.make(slot1, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			GuildTechnologyCard.New(slot2:Find("content"), slot0).Update(slot4, slot3, slot0.activityGroup)
			setActive(slot2:Find("back"), false)
		end
	end)
	slot0.upgradeList.align(slot1, #slot0.technologyVOs)
	setActive(slot0.upgradePanel, true)
	setActive(slot0.inDevelopmentPanel, false)
	setActive(slot0.breakoutListPanel, false)

	slot0.page = slot0.PAGE_UPGRADE
end

slot0.UpdateBreakOutList = function (slot0)
	if slot0.activityGroup then
		slot0:InitDevingItem()
	else
		slot0:InitBreakOutList()
	end

	setActive(slot0.upgradePanel, false)
	setActive(slot0.inDevelopmentPanel, slot0.activityGroup)
	setActive(slot0.breakoutListPanel, not slot0.activityGroup)
end

slot0.Switch2BreakOutList = function (slot0)
	setActive(slot0.upgradePanel, false)
	setActive(slot0.inDevelopmentPanel, false)
	setActive(slot0.breakoutListPanel, true)
	slot0:InitBreakOutList(true)
end

slot0.InitBreakOutList = function (slot0, slot1)
	table.sort(slot0.technologyGroupVOs, function (slot0, slot1)
		return slot0.pid < slot1.pid
	end)
	slot0.breakOutList.make(slot2, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			GuildTechnologyGroupCard.New(slot2:Find("content"), slot0):Update(slot0.technologyGroupVOs[slot1 + 1], slot0.activityGroup, slot0.isAdmin)
			setActive(slot4._tf, not (slot1 and slot0.activityGroup and slot0.activityGroup.id == slot3.id))
			setActive(slot2:Find("back"), slot1 and slot0.activityGroup and slot0.activityGroup.id == slot3.id)

			if slot1 and slot0.activityGroup and slot0.activityGroup.id == slot3.id then
				onButton(slot0, slot2:Find("back"), function ()
					slot0:UpdateBreakOutList()
				end, SFX_PANEL)
				slot2.SetAsFirstSibling(slot2)
			end
		end
	end)
	slot0.breakOutList.align(slot2, #slot0.technologyGroupVOs)

	slot0.page = slot0.PAGE_DEV
end

slot0.InitDevingItem = function (slot0)
	slot0.inDevelopmentIcon.sprite = GetSpriteFromAtlas("GuildTechnology", slot2)
	slot0.inDevelopmentName.text = slot0.activityGroup.getConfig(slot1, "name")
	slot5, slot6, slot7, slot8, slot9, slot10 = nil

	if slot0.activityGroup.bindConfigTable(slot1)[slot0.activityGroup.pid].next_tech ~= 0 then
		slot5 = slot1:GetLevel()
		slot6 = slot3[slot4].level
		slot7 = GuildConst.GET_TECHNOLOGY_DESC(slot1:getConfig("effect_args"), slot1:getConfig("num"))
		slot8 = GuildConst.GET_TECHNOLOGY_DESC(slot3[slot4].effect_args, slot3[slot4].num)
		slot9 = slot1:GetProgress()
		slot10 = slot1:GetTargetProgress()
	else
		slot5 = slot1:GetLevel()
		slot6 = "MAX"
		slot7 = GuildConst.GET_TECHNOLOGY_DESC(slot1:getConfig("effect_args"), slot1:getConfig("num"))
		slot8 = ""
		slot9 = 1
		slot10 = 1
	end

	slot0.inDevelopmentLevel1Txt.text = slot7
	slot0.inDevelopmentLevel1Desc.text = "Lv" .. slot5
	slot0.inDevelopmentLevel2Desc.text = "Lv" .. slot6
	slot0.inDevelopmentLevel2Txt.text = slot8

	setFillAmount(slot0.inDevelopmentProgress, slot9 / slot10)

	slot0.inDevelopmentProgressTxt.text = slot9 .. "/" .. slot10
	slot0.page = slot0.PAGE_DEV_ITEM
end

slot0.OnDestroy = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.frame, slot0._tf)
end

return slot0

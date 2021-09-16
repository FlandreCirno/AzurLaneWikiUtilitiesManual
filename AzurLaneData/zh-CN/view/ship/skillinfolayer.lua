slot0 = class("SkillInfoLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "SkillInfoUI"
end

slot0.init = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, false, {
		weight = slot0:getWeightFromData()
	})

	slot0.backBtn = slot0:findTF("panel/top/btnBack")
	slot0.skillInfoName = slot0:findTF("panel/bg/skill_name")
	slot0.skillInfoLv = slot0:findTF("panel/bg/skill_lv")
	slot0.skillInfoIntro = slot0:findTF("panel/bg/help_panel/skill_intro")
	slot0.skillInfoIcon = slot0:findTF("panel/bg/skill_icon")
	slot0.btnTypeNormal = slot0:findTF("panel/bg/btn_type_normal")
	slot0.btnTypeWorld = slot0:findTF("panel/bg/btn_type_world")
	slot0.buttonList = slot0:findTF("panel/buttonList")
	slot0.upgradeBtn = slot0:findTF("panel/buttonList/level_button")
	slot0.metaBtn = slot0:findTF("panel/buttonList/meta_button")

	setText(slot0:findTF("Image", slot0.metaBtn), i18n("meta_skillbtn_tactics"))
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("panel/buttonList/ok_button"), function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(slot0, slot0.upgradeBtn, function ()
		slot0:emit(SkillInfoMediator.WARP_TO_TACTIC)
	end, SFX_UI_CLICK)
	onButton(slot0, slot0.metaBtn, function ()
		slot1, slot2 = nil

		if slot0.contextData.shipId then
			slot1 = getProxy(BayProxy):getShipById(slot0.contextData.shipId):isMetaShip()
		end

		if slot1 then
			slot0:emit(SkillInfoMediator.WARP_TO_META_TACTICS, slot2.configId)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.btnTypeNormal, function ()
		slot0:showInfo(false)
		slot0.showInfo:flushTypeBtn()
	end, SFX_PANEL)
	onButton(slot0, slot0.btnTypeWorld, function ()
		slot0:showInfo(true)
		slot0.showInfo:flushTypeBtn()
	end, SFX_PANEL)

	if tobool(pg.skill_world_display[slot0.contextData.skillId]) then
		slot0.flushTypeBtn(slot0)
	else
		setActive(slot0.btnTypeNormal, false)
		setActive(slot0.btnTypeWorld, false)
	end

	slot0:showBase()
	slot0:showInfo(false)
end

slot0.flushTypeBtn = function (slot0)
	setActive(slot0.btnTypeNormal, slot0.isWorld)
	setActive(slot0.btnTypeWorld, not slot0.isWorld)
end

slot0.showBase = function (slot0)
	setText(slot0.skillInfoName, getSkillName(slot1))
	LoadImageSpriteAsync("skillicon/" .. getSkillConfig(slot1).icon, slot0.skillInfoIcon)
	setActive(slot0.upgradeBtn, not slot0.contextData.fromNewShip and slot0.contextData.skillOnShip and slot0.contextData.skillOnShip.level < #slot3 and slot0.contextData.skillOnShip.id ~= 22262 and slot0.contextData.skillOnShip.id ~= 22261)

	slot6, slot7 = nil

	if slot0.contextData.shipId then
		slot6 = getProxy(BayProxy):getShipById(slot0.contextData.shipId):isMetaShip()
	end

	setActive(slot0.metaBtn, slot6 and MetaCharacterConst.isMetaTaskSkillID(slot1))

	if slot6 then
		setActive(slot0.upgradeBtn, false)
	end
end

slot0.showInfo = function (slot0, slot1)
	slot0.isWorld = slot1
	slot2 = slot0.contextData.skillId

	setText(slot0.skillInfoLv, "Lv." .. ((slot0.contextData.skillOnShip and slot3.level) or 1))

	if slot0.contextData.fromNewShip then
		setText(slot0.skillInfoIntro, getSkillDescGet(slot2, slot1))
	else
		setText(slot0.skillInfoIntro, getSkillDesc(slot2, slot4, slot1))
	end
end

slot0.close = function (slot0)
	slot0:emit(slot0.ON_CLOSE)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)

	if slot0.contextData.onExit then
		slot0.contextData.onExit()
	end
end

return slot0

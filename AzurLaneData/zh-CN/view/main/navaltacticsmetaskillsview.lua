slot0 = class("NavalTacticsMetaSkillsView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "NavalTacticsMetaSkillsPanel"
end

slot0.OnInit = function (slot0)
	slot0:initUITip()
	slot0:initUI()
	slot0:addListener()
	slot0:updateSkillList()
	triggerToggle(slot0.skillToggleList[1], true)
	slot0:Show()
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.setData = function (slot0, slot1, slot2)
	slot0.metaShipID = slot1 or slot0.metaShipID
	slot0.metaShipVO = getProxy(BayProxy):getShipById(slot0.metaShipID)
	slot0.closeCB = slot2 or slot0.closeCB
	slot0.metaProxy = getProxy(MetaCharacterProxy)
	slot0.metaTacticsInfo = slot0.metaProxy:getMetaTacticsInfoByShipID(slot0.metaShipVO.id)
	slot0.selectSkillID = slot0.selectSkillID or nil
end

slot0.initUITip = function (slot0)
	slot1 = slot0:findTF("frame/bg/title_bg/title")

	setText(slot2, i18n("meta_tactics_detail"))
	setText(slot3, i18n("meta_tactics_unlock"))
	setText(slot0:findTF("frame/buttons/switch_btn/Image"), i18n("meta_tactics_switch"))
end

slot0.initUI = function (slot0)
	slot0.bg = slot0:findTF("print")
	slot1 = slot0:findTF("frame")
	slot0.skillTpl = slot0:findTF("skilltpl", slot1)
	slot0.skillContainer = slot0:findTF("skill_contain/content", slot1)
	slot2 = slot0:findTF("buttons", slot1)
	slot0.detailBtn = slot0:findTF("detail_btn", slot2)
	slot0.unlockBtn = slot0:findTF("unlock_btn", slot2)
	slot0.switchBtn = slot0:findTF("switch_btn", slot2)
	slot0.skillUIItemList = UIItemList.New(slot0.skillContainer, slot0.skillTpl)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.bg, function ()
		if slot0.closeCB then
			slot0.closeCB()
		else
			slot0:Destroy()
		end
	end, SFX_CANCEL)
	onButton(slot0, slot0.detailBtn, function ()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenTactics = true,
			autoOpenShipConfigID = slot0.metaShipVO.configId
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.unlockBtn, function ()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideYes = true,
			hideNo = true,
			type = MSGBOX_TYPE_META_SKILL_UNLOCK,
			metaShipVO = slot0.metaShipVO,
			skillID = slot0.selectSkillID
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.switchBtn, function ()
		pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
			shipID = slot0.metaShipVO.id,
			skillID = slot0.selectSkillID
		})
	end, SFX_PANEL)
end

slot0.updateSkillTF = function (slot0, slot1, slot2)
	slot3 = slot0:findTF("frame", slot1)
	slot4 = slot0:findTF("skillInfo", slot3)
	slot5 = slot0:findTF("empty", slot3)
	slot6 = slot0:findTF("mask", slot3)
	slot9 = slot0:findTF("next_contain/label", slot4)
	slot10 = slot0:findTF("next_contain/Text", slot4)
	slot13 = slot0:findTF("Tag/learing", slot3)
	slot14 = slot0:findTF("Tag/unlockable", slot3)
	slot15 = slot0.metaShipVO:getMetaSkillLevelBySkillID(slot2)

	setImageSprite(slot7, LoadSprite("skillicon/" .. getSkillConfig(slot2).icon))
	setText(slot0:findTF("descView/Viewport/desc", slot4), getSkillDesc(slot2, (isUnlocked and slot15) or 1))
	setText(slot0:findTF("name_contain/name", slot4), getSkillName(slot16.id))
	setText(slot0:findTF("name_contain/level_contain/Text", slot4), slot15)

	slot17 = slot2 == slot0.metaTacticsInfo.curSkillID
	slot18 = slot15 > 0
	slot19 = slot0.metaTacticsInfo:getSkillExp(slot2)
	slot21 = pg.skill_data_template[slot2].max_level <= slot15

	if not slot21 then
		if slot18 then
			setText(slot10, setColorStr(slot19, COLOR_GREEN) .. "/" .. MetaCharacterConst.getMetaSkillTacticsConfig(slot2, slot15).need_exp)
			setActive(slot9, true)
			setActive(slot10, true)
		else
			setActive(slot9, false)
			setActive(slot10, false)
		end
	else
		setText(slot10, "Max")
	end

	setActive(slot13, slot17 and not slot21)
	setActive(slot14, not slot18)
	setActive(slot6, not slot18)
	onToggle(slot0, slot1, function (slot0)
		if slot0 then
			slot0.selectSkillID = slot0

			slot0:updateButtons(slot0.selectSkillID)
		end
	end, SFX_PANEL)
end

slot0.updateSkillList = function (slot0)
	slot0.skillUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0.skillToggleList = slot0.skillToggleList or {}
			slot0.skillToggleList[slot1 + 1] = slot2

			slot0:updateSkillTF(slot2, slot1 + 1[])
		end
	end)
	slot0.skillUIItemList.align(slot2, #MetaCharacterConst.getTacticsSkillIDListByShipConfigID(slot0.metaShipVO.configId))
end

slot0.updateButtons = function (slot0, slot1)
	slot3 = (slot1 or slot0.selectSkillID) == slot0.metaTacticsInfo.curSkillID
	slot4 = slot0.metaShipVO:getMetaSkillLevelBySkillID(slot1 or slot0.selectSkillID) > 0
	slot5 = slot0.metaShipVO:isSkillLevelMax(slot1 or slot0.selectSkillID)

	if slot3 or slot5 then
		setActive(slot0.detailBtn, true)
		setActive(slot0.unlockBtn, false)
		setActive(slot0.switchBtn, false)
	elseif not slot4 then
		setActive(slot0.detailBtn, true)
		setActive(slot0.unlockBtn, true)
		setActive(slot0.switchBtn, false)
	elseif slot4 and not slot3 then
		setActive(slot0.detailBtn, true)
		setActive(slot0.unlockBtn, false)
		setActive(slot0.switchBtn, true)
	end
end

slot0.reUpdate = function (slot0, slot1, slot2)
	slot0:setData(slot1, slot2)
	slot0:updateSkillList()
	slot0:updateButtons()
end

return slot0

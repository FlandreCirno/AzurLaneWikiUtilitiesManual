slot0 = class("LevelCMDFormationView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "LevelCommanderView"
end

slot0.OnInit = function (slot0)
	slot0:InitUI()
end

slot0.OnDestroy = function (slot0)
	if slot0:isShowing() then
		slot0:Hide()
	end

	slot0.callback = nil
end

slot0.Show = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	setActive(slot0._go, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTF)
end

slot0.InitUI = function (slot0)
	slot0.descFrameTF = slot0:findTF("frame")
	slot0.descPos1 = slot0:findTF("commander1/frame/info", slot0.descFrameTF)
	slot0.descPos2 = slot0:findTF("commander2/frame/info", slot0.descFrameTF)
	slot0.skillTFPos1 = slot0:findTF("commander1/skill_info", slot0.descFrameTF)
	slot0.skillTFPos2 = slot0:findTF("commander2/skill_info", slot0.descFrameTF)
	slot0.abilitysTF = UIItemList.New(slot0:findTF("atttr_panel/abilitys/mask/content", slot0.descFrameTF), slot0:findTF("atttr_panel/abilitys/mask/content/attr", slot0.descFrameTF))
	slot0.talentsTF = UIItemList.New(slot0:findTF("atttr_panel/talents/mask/content", slot0.descFrameTF), slot0:findTF("atttr_panel/talents/mask/content/attr", slot0.descFrameTF))
	slot0.abilityArr = slot0:findTF("frame/atttr_panel/abilitys/arr")
	slot0.talentsArr = slot0:findTF("frame/atttr_panel/talents/arr")
	slot0.restAllBtn = slot0:findTF("rest_all", slot0.descFrameTF)
	slot0.quickBtn = slot0:findTF("quick_btn", slot0.descFrameTF)
	slot0.recordPanel = slot0:findTF("record_panel")
	slot0.recordCommanders = {
		slot0.recordPanel:Find("current/commanders/commander1/frame/info"),
		slot0.recordPanel:Find("current/commanders/commander2/frame/info")
	}
	slot0.reocrdSkills = {
		slot0.recordPanel:Find("current/commanders/commander1/skill_info"),
		slot0.recordPanel:Find("current/commanders/commander2/skill_info")
	}
	slot0.recordList = UIItemList.New(slot0.recordPanel:Find("record/content"), slot0.recordPanel:Find("record/content/commanders"))

	onButton(slot0, slot0.restAllBtn, function ()
		slot0.callback({
			type = LevelUIConst.COMMANDER_OP_REST_ALL
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.quickBtn, function ()
		slot0:OpenRecordPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.recordPanel:Find("back"), function ()
		slot0:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf:Find("bg"), function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.setCallback = function (slot0, slot1)
	slot0.callback = slot1
end

slot0.update = function (slot0, slot1, slot2)
	slot0:updateFleet(slot1)
	slot0:updatePrefabs(slot2)
end

slot0.updateFleet = function (slot0, slot1)
	slot0.fleet = slot1

	slot0:updateDesc()
	slot0:updateRecordFleet()
end

slot0.updatePrefabs = function (slot0, slot1)
	slot0.prefabFleets = slot1

	slot0:updateRecordPanel()
end

slot0.updateRecordFleet = function (slot0)
	slot1 = slot0.fleet:getCommanders()

	for slot5, slot6 in ipairs(slot0.recordCommanders) do
		slot0:updateCommander(slot6, slot5, slot1[slot5])
		slot0:updateSkillTF(slot1[slot5], slot0.reocrdSkills[slot5])
	end
end

slot0.updateRecordPanel = function (slot0)
	slot1 = slot0.fleet:getCommanders()

	slot0.recordList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:UpdatePrefabFleet(slot0.prefabFleets[slot1 + 1], slot2, slot1)
		end
	end)
	slot0.recordList.align(slot2, #slot0.prefabFleets)
end

slot0.UpdatePrefabFleet = function (slot0, slot1, slot2, slot3)
	onInputEndEdit(slot0, slot4, function ()
		getInputText.callback({
			type = LevelUIConst.COMMANDER_OP_RENAME,
			id = slot2.id,
			str = getInputText(getInputText),
			onFailed = function ()
				setInputText(setInputText, )
			end
		})
	end)
	setInputText(slot4, slot5)
	onButton(slot0, slot2:Find("use_btn"), function ()
		slot0.callback({
			type = LevelUIConst.COMMANDER_OP_USE_PREFAB,
			id = slot1.id
		})
		slot0.callback:CloseRecordPanel()
	end, SFX_PANEL)
	onButton(slot0, slot2:Find("record_btn"), function ()
		slot0.callback({
			type = LevelUIConst.COMMANDER_OP_RECORD_PREFAB,
			id = slot1.id
		})
	end, SFX_PANEL)

	slot7 = {
		slot2:Find("commander1/skill_info"),
		slot2:Find("commander2/skill_info")
	}

	for slot11, slot12 in ipairs(slot6) do
		slot0:updateCommander(slot12, slot11, slot1:getCommanderByPos(slot11))
		slot0:updateSkillTF(slot1.getCommanderByPos(slot11), slot7[slot11])
	end
end

slot0.updateDesc = function (slot0)
	slot1 = slot0.fleet:getCommanders()

	for slot5 = 1, CommanderConst.MAX_FORMATION_POS, 1 do
		slot0:updateCommander(slot0["descPos" .. slot5], slot5, slot6, true)
		slot0:updateSkillTF(slot1[slot5], slot0["skillTFPos" .. slot5])
	end

	slot0:updateAdditions()
end

slot0.updateAdditions = function (slot0)
	slot3, slot4 = slot0.fleet.getCommandersAddition(slot1)

	slot0.abilitysTF:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("name"), AttributeType.Type2Name(slot0[slot1 + 1].attrName))
			setText(slot2:Find("Text"), string.format("%0.3f", slot0[slot1 + 1].value) .. "%")
			GetImageSpriteFromAtlasAsync("attricon", slot0[slot1 + 1].attrName, slot2:Find("icon"), false)
			setImageAlpha(slot2:Find("bg"), slot1 % 2)
		end
	end)
	slot0.abilitysTF.align(slot5, #slot3)
	setActive(slot0.abilityArr, #slot3 > 4)
	slot0.talentsTF:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setScrollText(findTF(slot2, "name_mask/name"), slot0[slot1 + 1].name)
			setText(slot2:Find("Text"), slot3.value .. ((slot0[slot1 + 1].type == CommanderConst.TALENT_ADDITION_RATIO and "%") or ""))
			setImageAlpha(slot2:Find("bg"), slot1 % 2)
		end
	end)
	slot0.talentsTF.align(slot5, #_.values(slot0.fleet.getCommandersTalentDesc(slot1)))
	setActive(slot0.talentsArr, #_.values(slot0.fleet.getCommandersTalentDesc(slot1)) > 4)
end

slot0.updateSkillTF = function (slot0, slot1, slot2)
	setActive(slot2, slot1)

	if slot1 then
		GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. slot1:getSkills()[1].getConfig(slot3, "icon"), "", slot2:Find("icon"))
		setText(slot2:Find("level"), "Lv." .. slot1.getSkills()[1].getLevel(slot3))
		onButton(slot0, slot2, function ()
			slot0.callback({
				type = LevelUIConst.COMMANDER_OP_SHOW_SKILL,
				skill = 
			})
		end, SFX_PANEL)

		return
	end

	removeOnButton(slot2)
end

slot0.updateCommander = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot1:Find("add")
	slot6 = slot1:Find("info")

	if slot3 then
		slot8 = slot1:Find("info/frame")

		GetImageSpriteFromAtlasAsync("CommanderHrz/" .. slot3:getPainting(), "", slot1:Find("info/mask/icon"))

		if slot1:Find("info/name") then
			setText(slot9, slot3:getName())
		end

		setImageSprite(slot8, GetSpriteFromAtlas("weaponframes", "commander_" .. Commander.rarity2Frame(slot3:getRarity())))
	end

	if slot4 then
		onButton(slot0, slot6, function ()
			slot0.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = 
			})
		end, SFX_PANEL)
		onButton(slot0, slot5, function ()
			slot0.callback({
				type = LevelUIConst.COMMANDER_OP_ADD,
				pos = 
			})
		end, SFX_PANEL)
	end

	setActive(slot5, not slot3)
	setActive(slot6, slot3)
end

slot0.OpenRecordPanel = function (slot0)
	setActive(slot0.descFrameTF, false)
	setActive(slot0.recordPanel, true)
end

slot0.CloseRecordPanel = function (slot0)
	setActive(slot0.descFrameTF, true)
	setActive(slot0.recordPanel, false)
end

return slot0

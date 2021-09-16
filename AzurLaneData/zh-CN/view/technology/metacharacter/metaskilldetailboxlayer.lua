slot0 = class("MetaSkillDetailBoxLayer", import("...base.BaseUI"))

slot0.getUIName = function (slot0)
	return "MetaSkillDetailBoxUI"
end

slot0.init = function (slot0)
	slot0:initUITextTips()
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, false)
	slot0:updateShipDetail()
	slot0:updateSkillList()
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

slot0.initUITextTips = function (slot0)
	setText(slot1, i18n("battle_end_subtitle2"))
	setText(slot2, i18n("meta_skill_dailyexp"))
	setText(slot0:findTF("Window/MetaSkillDetailBox/TipText"), i18n("meta_skill_learn"))
end

slot0.initData = function (slot0)
	slot0.metaProxy = getProxy(MetaCharacterProxy)
	slot0.metaShipID = slot0.contextData.metaShipID
end

slot0.findUI = function (slot0)
	slot0.bg = slot0:findTF("BG")
	slot0.window = slot0:findTF("Window")
	slot0.closeBtn = slot0:findTF("top/btnBack", slot0.window)
	slot0.panel = slot0:findTF("MetaSkillDetailBox", slot0.window)
	slot0.skillTpl = slot0:findTF("SkillTpl", slot0.panel)
	slot0.expDetailTF = slot0:findTF("ExpDetail", slot0.panel)
	slot0.shipIcon = slot0:findTF("IconTpl/Icon", slot0.expDetailTF)
	slot0.shipNameText = slot0:findTF("Name", slot0.expDetailTF)
	slot0.expProgressText = slot0:findTF("ExpProgressText", slot0.expDetailTF)
	slot0.skillContainer = slot0:findTF("ScrollView/Content", slot0.panel)
	slot0.skillUIItemList = UIItemList.New(slot0.skillContainer, slot0.skillTpl)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.bg, function ()
		slot0:closeView()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:closeView()
	end, SFX_PANEL)
end

slot0.updateSkillTF = function (slot0, slot1, slot2)
	slot3 = slot0:findTF("frame", slot1)
	slot4 = slot0:findTF("check_mark", slot1)
	slot6 = slot0:findTF("mask", slot3)
	slot7 = slot0:findTF("Slider", slot3)
	slot9 = slot0:findTF("ExpProgressText", slot0:findTF("skillInfo", slot3))
	slot12 = slot0:findTF("Tag/learing", slot3)
	slot13 = slot0:findTF("Tag/unlockable", slot3)

	setImageSprite(slot8, LoadSprite("skillicon/" .. getSkillConfig(slot2).icon))
	setText(slot10, shortenString(getSkillName(getSkillConfig(slot2).id), 8))
	setText(slot11, slot15)

	slot18 = slot2 == slot0.metaProxy:getMetaTacticsInfoByShipID(slot0.metaShipID).curSkillID
	slot19 = slot15 > 0
	slot20 = slot14:isSkillLevelMax(slot2)
	slot21 = slot17:getSkillExp(slot2)
	slot23 = pg.skill_data_template[slot2].max_level <= slot15

	if not slot23 then
		if slot19 then
			setText(slot9, slot21 .. "/" .. slot25)
			setSlider(slot7, 0, MetaCharacterConst.getMetaSkillTacticsConfig(slot2, slot15).need_exp, slot21)
			setActive(slot9, true)
			setActive(slot7, true)
		else
			setActive(slot9, false)
			setActive(slot7, false)
		end
	else
		setText(slot9, slot21 .. "/Max")
		setSlider(slot7, 0, 1, 1)
		setActive(slot9, true)
		setActive(slot7, true)
	end

	setActive(slot4, slot18 and not slot20)
	setActive(slot12, slot18 and not slot20)
	setActive(slot13, not slot19)
	setActive(slot6, not slot19)
	onToggle(slot0, slot1, function (slot0)
		if slot0 then
			if not slot0 then
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					hideYes = true,
					hideNo = true,
					type = MSGBOX_TYPE_META_SKILL_UNLOCK,
					weight = LayerWeightConst.TOP_LAYER,
					metaShipVO = slot1,
					skillID = pg.MsgboxMgr.GetInstance()
				})
			elseif not slot3 and not slot4 then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("meta_switch_skill_box_title", getSkillName(pg.MsgboxMgr.GetInstance())),
					onYes = function ()
						pg.m02:sendNotification(GAME.TACTICS_META_SWITCH_SKILL, {
							shipID = slot0.metaShipID,
							skillID = pg.m02
						})
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			elseif slot4 then
				pg.TipsMgr.GetInstance().ShowTips(slot1, i18n("meta_skill_maxtip2"))
			end
		end
	end, SFX_PANEL)
end

slot0.updateSkillList = function (slot0)
	slot0.skillUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot1:updateSkillTF(slot2, slot0[slot1 + 1])
		end
	end)
	slot0.skillUIItemList.align(slot3, #MetaCharacterConst.getTacticsSkillIDListByShipConfigID(getProxy(BayProxy):getShipById(slot0.metaShipID).configId))
end

slot0.updateShipDetail = function (slot0)
	slot1 = getProxy(BayProxy):getShipById(slot0.metaShipID)

	setImageSprite(slot0.shipIcon, LoadSprite(slot3, slot2))
	setText(slot0.shipNameText, slot1:getName())
	setText(slot0.expProgressText, setColorStr(slot5, "#FFF152FF") .. "/" .. pg.gameset.meta_skill_exp_max.key_value)
end

return slot0

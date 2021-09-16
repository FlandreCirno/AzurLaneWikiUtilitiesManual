slot0 = class("MetaSkillUnlockPanel", import(".MsgboxSubPanel"))

slot0.GetUIName = function (slot0)
	return "MetaSkillUnlockBox"
end

slot0.OnInit = function (slot0)
	slot0:findUI()
	slot0:initData()
	slot0:addListener()
end

slot0.UpdateView = function (slot0, slot1)
	slot0:PreRefresh(slot1)
	slot0:updateContent(slot1)

	rtf(slot0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	slot0:PostRefresh(slot1)
end

slot0.findUI = function (slot0)
	slot0.tipText = slot0:findTF("Tip")
	slot0.materialTpl = slot0:findTF("Material")
	slot0.materialContainer = slot0:findTF("MaterialContainer")
	slot0.uiItemList = UIItemList.New(slot0.materialContainer, slot0.materialTpl)
	slot0.cancelBtn = slot0:findTF("Buttons/CancelBtn")
	slot0.confirmBtn = slot0:findTF("Buttons/ConfirmBtn")

	setText(slot1, i18n("word_cancel"))
	setText(slot0:findTF("Text", slot0.confirmBtn), i18n("word_ok"))
end

slot0.initData = function (slot0)
	slot0.curMetaShipID = nil
	slot0.curUnlockSkillID = nil
	slot0.curUnlockMaterialID = nil
	slot0.curUnlockMaterialNeedCount = nil
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.confirmBtn, function ()
		if not slot0.curUnlockMaterialID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_unlock_skill_select"))

			return
		elseif getProxy(BagProxy):getItemCountById(slot0.curUnlockMaterialID) < slot0.curUnlockMaterialNeedCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			slot1 = 0
			slot2 = 0

			for slot8, slot9 in ipairs(slot4) do
				if slot0.curUnlockMaterialID == slot9[2] then
					slot1 = slot8
					slot2 = slot9[3]

					break
				end
			end

			pg.m02:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL, {
				shipID = slot0.curMetaShipID,
				skillID = slot0.curUnlockSkillID,
				materialIndex = slot1,
				materialInfo = {
					id = slot0.curUnlockMaterialID,
					count = slot2
				}
			})
		end

		pg.MsgboxMgr.GetInstance():hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.cancelBtn, function ()
		pg.MsgboxMgr.GetInstance():hide()
	end, SFX_CANCEL)
end

slot0.updateContent = function (slot0, slot1)
	slot0.curMetaShipID = slot1.metaShipVO.id
	slot0.curUnlockSkillID = slot1.skillID

	setText(slot0.tipText, i18n("meta_unlock_skill_tip", slot5, getSkillName(slot4)))

	slot8 = MetaCharacterConst.getMetaSkillTacticsConfig(slot4, 1).skill_unlock

	slot0.uiItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot4, slot7)
			setActive(slot5, false)
			setText(slot1:findTF("Count/Text", slot2), ((getProxy(BagProxy):getItemCountById(slot0[slot1 + 1][2]) < slot0[slot1 + 1][3] and setColorStr(slot10, COLOR_RED)) or setColorStr(slot10, COLOR_GREEN)) .. "/" .. slot9)

			slot1.curUnlockMaterialID = slot8
			slot1.curUnlockMaterialNeedCount = slot9
		end
	end)
	slot0.uiItemList.align(slot9, #{
		MetaCharacterConst.getMetaSkillTacticsConfig(slot4, 1).skill_unlock[1]
	})
end

return slot0

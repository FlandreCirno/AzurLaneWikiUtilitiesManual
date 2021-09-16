class("MetaCharacterLevelMaxBoxShowCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if not getProxy(MetaCharacterProxy) then
		return
	end

	slot6 = nil

	if slot4:GetChapterAutoFlag(slot5.id) == 1 then
		return
	end

	if slot3:getMetaSkillLevelMaxInfoList() and #slot7 > 0 then
		slot8 = ""

		for slot12, slot13 in ipairs(slot7) do
			slot15 = slot13.metaSkillID
			slot8 = (slot12 < #slot7 and slot8 .. setColorStr(HXSet.hxLan(slot13.metaShipVO.getName(slot14)), COLOR_GREEN) .. "、") or slot8 .. setColorStr(HXSet.hxLan(slot13.metaShipVO.getName(slot14)), COLOR_GREEN)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_skill_maxtip", slot8),
			onYes = function ()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
					autoOpenTactics = true,
					autoOpenShipConfigID = slot0[1].metaShipVO.configId
				})
			end,
			onClose = function ()
				if slot0.closeFunc then
					slot0.closeFunc()
				end
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end

	slot3.clearMetaSkillLevelMaxInfoList(slot3)
end

return class("MetaCharacterLevelMaxBoxShowCommand", pm.SimpleCommand)

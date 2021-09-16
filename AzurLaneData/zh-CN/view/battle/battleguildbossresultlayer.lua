slot0 = class("BattleGuildBossResultLayer", import(".BattleContributionResultLayer"))

slot0.setActId = function (slot0, slot1)
	return
end

slot0.showRewardInfo = function (slot0)
	slot0._stateFlag = slot0.STATE_REWARD

	SetActive(slot0:findTF("jieuan01/tips", slot0._bg), false)
	slot0:displayBG()
end

slot0.setPoint = function (slot0)
	slot0._contributionPoint = 0
	slot1 = pg.guildset.guild_damage_resource.key_value

	for slot5, slot6 in ipairs(slot0.contextData.drops) do
		if slot6.configId == slot1 then
			slot0._contributionPoint = slot6.count
		end
	end

	setActive(slot0:findTF("blur_container/activitybossConfirmPanel/playAgain"), false)
end

slot0.displayShips = function (slot0)
	slot1 = {}

	for slot6, slot7 in ipairs(slot2) do
		slot1[slot7.id] = slot7
	end

	slot3 = slot0.contextData.statistics

	for slot7, slot8 in ipairs(slot2) do
		if slot3[slot8.id] then
			slot3[slot8.id].vo = slot8
		end
	end

	slot4, slot5 = nil
	slot5 = (not slot3.mvpShipID or slot3.mvpShipID == 0 or slot3[slot3.mvpShipID].output) and 0
	slot0._atkFuncs = {}
	slot7, slot8 = nil

	SetActive(slot0._atkToggle, #slot0.contextData.oldMainShips > 6)

	if #slot6 > 6 then
		onToggle(slot0, slot0._atkToggle, function (slot0)
			SetActive(slot0._atkContainer, slot0)
			SetActive(slot0._atkContainerNext, not slot0)

			if slot0 then
				slot0:skipAtkAnima(slot0._atkContainerNext)
			else
				slot0:skipAtkAnima(slot0._atkContainer)
			end
		end, SFX_PANEL)
	end

	slot9 = {}
	slot10 = {}

	for slot14, slot15 in ipairs(slot6) do
		slot16 = slot1[slot15.id] or slot15

		if slot3[slot15.id] then
			slot18 = table.contains(TeamType.SubShipType, slot17)
			slot19, slot20 = nil
			slot21 = 0

			if slot14 > 6 then
				slot20 = slot0._atkContainerNext
				slot21 = 7
			else
				slot20 = slot0._atkContainer
				slot21 = 1
			end

			cloneTplTo(slot0._atkTpl, slot20).localPosition.x = cloneTplTo(slot0._atkTpl, slot20).localPosition.x + (slot14 - slot21) * 74
			cloneTplTo(slot0._atkTpl, slot20).localPosition.y = cloneTplTo(slot0._atkTpl, slot20).localPosition.y + (slot14 - slot21) * -124
			cloneTplTo(slot0._atkTpl, slot20).localPosition = cloneTplTo(slot0._atkTpl, slot20).localPosition
			slot23 = findTF(slot19, "result/stars")
			slot24 = findTF(slot19, "result/stars/star_tpl")
			slot25 = slot15:getStar()
			slot26 = slot15:getMaxStar()

			while slot26 > 0 do
				SetActive(cloneTplTo(slot24, slot23):Find("empty"), slot25 < slot26)
				SetActive(slot27:Find("star"), slot26 <= slot25)

				slot26 = slot26 - 1
			end

			slot0:findTF("result/mask/icon", slot19).GetComponent(slot27, typeof(Image)).sprite = LoadSprite("herohrzicon/" .. slot15:getPainting())

			setImageSprite(slot28, slot30, true)
			slot0:setAtkAnima(slot19, slot20, slot3[slot15.id].output / slot5, slot5, slot4 and slot15.id == slot4.id, slot3[slot15.id].output, slot3[slot15.id].kill_count)

			slot31 = nil
			slot32 = false

			if slot4 and slot15.id == slot4.id then
				slot32 = true
				slot0.mvpShipVO = slot15
				slot33, slot34, slot35 = nil

				if slot0.contextData.score > 1 then
					slot33, slot35, slot34 = ShipWordHelper.GetWordAndCV(slot0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_MVP, nil, nil, slot0.mvpShipVO:getCVIntimacy())
				else
					slot33, slot35, slot34 = ShipWordHelper.GetWordAndCV(slot0.mvpShipVO.skinId, ShipWordHelper.WORD_TYPE_LOSE)
				end

				if slot35 then
					slot0:stopVoice()
					pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot35, function (slot0)
						slot0._currentVoice = slot0
					end)
				end
			end

			if slot15.id == slot3._flagShipID then
				slot0.flagShipVO = slot15
			end

			slot33 = nil
			slot34 = slot0.shipBuff and slot0.shipBuff[slot15.getGroupId(slot15)]

			if slot0.expBuff or slot34 then
				slot33 = (slot0.expBuff and slot0.expBuff:getConfig("name")) or (slot34 and i18n("Word_Ship_Exp_Buff"))
				slot36 = nil
			end

			if not slot18 then
				table.insert(slot0._shipResultCardList, BattleResultShipCard.New(slot37))

				if slot8 then
					slot8:ConfigCallback(function ()
						slot0:Play()
					end)
				else
					slot36.Play(slot36)
				end

				slot8 = slot36
			else
				table.insert(slot0._subShipResultCardList, BattleResultShipCard.New(slot37))

				if not slot7 then
					slot0._subFirstExpCard = slot36
				else
					slot7:ConfigCallback(function ()
						slot0:Play()
					end)
				end

				slot7 = slot36
			end

			slot36:SetShipVO(slot15, slot16, slot32, slot33)
		end
	end

	if slot8 then
		slot8:ConfigCallback(function ()
			slot0._stateFlag = slot1.STATE_DISPLAYED

			if not slot0._subFirstExpCard then
				slot0:skip()
			end
		end)
	end

	if slot7 then
		slot7.ConfigCallback(slot7, function ()
			slot0._stateFlag = slot1.STATE_SUB_DISPLAYED

			slot0:skip()
		end)
	end
end

return slot0

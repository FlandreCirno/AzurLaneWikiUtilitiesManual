slot0 = class("PursuingBluePrintCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot4 = slot1:getBody().id

	if slot1.getBody().count == 0 then
		return
	end

	if not getProxy(TechnologyProxy):getBluePrintById(slot4) then
		return
	end

	if not slot6:isUnlock() then
		return
	end

	if getProxy(PlayerProxy):getRawData():getResource(PlayerConst.ResGold) < slot5:calcPursuingCost(slot6, slot3) then
		return
	end

	if slot6:isMaxLevel() and slot6:isMaxFateLevel() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_max_level_tip"))

		return
	end

	slot11 = Clone(slot6)

	slot11:addExp(slot10)

	if getProxy(BayProxy).getShipById(slot13, slot6.shipId).level < slot11:getStrengthenConfig(math.max(slot11.level, 1)).need_lv then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buleprint_need_level_tip", slot12.need_lv))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(63212, {
		ship_id = slot6.shipId,
		count = slot3
	}, 63213, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(PlayerProxy)
			slot2 = slot1:getData()

			slot2:consume({
				gold = slot0
			})
			slot1:updatePlayer(slot2)
			slot1:addPursuingTimes(slot2)

			slot3 = Clone(Clone)

			slot3:addExp(slot3:getItemExp() * slot2)

			if slot3.level < slot3.level then
				for slot8 = slot3.level + 1, slot3.level, 1 do
					if slot3:getStrengthenConfig(slot8).special == 1 and type(slot9.special_effect) == "table" then
						for slot14, slot15 in ipairs(slot10) do
							if slot15[1] == ShipBluePrint.STRENGTHEN_TYPE_SKILL then
								slot19 = getProxy(BayProxy).getShipById(slot18, slot3.shipId)

								for slot23, slot24 in ipairs(slot17) do
									slot19.skills[slot4] = {
										exp = 0,
										level = 1,
										id = slot24
									}

									pg.TipsMgr.GetInstance():ShowTips(slot15[3])
								end

								slot18:updateShip(slot19)
							elseif slot16 == ShipBluePrint.STRENGTHEN_TYPE_SKIN then
								getProxy(ShipSkinProxy).addSkin(slot17, ShipSkin.New({
									id = slot15[2]
								}))

								slot18 = pg.ship_skin_template[slot15[2]].name

								pg.TipsMgr.GetInstance():ShowTips(slot15[3])
							elseif slot16 == ShipBluePrint.STRENGTHEN_TYPE_BREAKOUT then
								slot5:upgradeStar(getProxy(BayProxy).getShipById(slot17, slot3.shipId))
							end
						end
					end
				end
			elseif slot3.fateLevel < slot3.fateLevel then
				for slot8 = slot3.fateLevel + 1, slot3.fateLevel, 1 do
					if slot3:getFateStrengthenConfig(slot8).special == 1 and type(slot9.special_effect) == "table" then
						for slot14, slot15 in ipairs(slot10) do
							if slot15[1] == ShipBluePrint.STRENGTHEN_TYPE_CHANGE_SKILL then
								slot17 = getProxy(BayProxy)
								slot18 = slot17:getShipById(slot3.shipId)
								Clone(slot18.skills[slot15[2][1]]).id = slot15[2][2]
								slot18.skills[slot15[2][1]] = nil
								slot18.skills[slot15[2][2]] = Clone(slot18.skills[slot15[2][1]])

								pg.TipsMgr.GetInstance():ShowTips(slot15[3])
								slot17:updateShip(slot18)

								if getProxy(NavalAcademyProxy):getStudentByShipId(slot18.id) and slot23.skillId == slot19 then
									slot23.skillId = slot20

									slot22:updateStudent(slot23)
								end
							end
						end
					end
				end
			end

			slot5 = slot6:getShipById(slot3.shipId)
			slot5.strengthList = {}

			table.insert(slot5.strengthList, {
				level = slot3.level + math.max(slot3.fateLevel, 0),
				exp = slot3.exp
			})
			table.insert:updateShip(slot5)
			slot5:sendNotification(GAME.MOD_BLUEPRINT_ANIM_LOCK)
			slot1:updateBluePrint(slot3)
			slot5:sendNotification(GAME.MOD_BLUEPRINT_DONE, {
				oldBluePrint = slot3,
				newBluePrint = slot3
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_mod_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("blueprint_mod_erro") .. slot0.result)
		end
	end)
end

slot0.upgradeStar = function (slot0, slot1)
	slot4 = getProxy(CollectionProxy).getShipGroup(slot3, Clone(slot1).groupId)

	if pg.ship_data_breakout[slot1.configId].breakout_id ~= 0 then
		slot1.configId = slot5.breakout_id

		for slot10, slot11 in ipairs(pg.ship_data_template[slot1.configId].buff_list) do
			if not slot1.skills[slot11] then
				slot1.skills[slot11] = {
					exp = 0,
					level = 1,
					id = slot11
				}
			end
		end

		slot1:updateMaxLevel(slot6.max_level)

		for slot11, slot12 in ipairs(slot7) do
			if not table.contains(slot6.buff_list, slot12) then
				slot1.skills[slot12] = nil
			end
		end

		getProxy(BayProxy):updateShip(slot1)
	end
end

return slot0

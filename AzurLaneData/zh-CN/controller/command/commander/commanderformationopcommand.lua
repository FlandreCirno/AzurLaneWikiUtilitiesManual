class("CommanderFormationOPCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().data.FleetType
	slot5 = getProxy(CommanderProxy)
	slot6 = getProxy(ChapterProxy)
	slot7 = getProxy(FleetProxy)

	if slot1.getBody().data.data.type == LevelUIConst.COMMANDER_OP_RENAME then
		slot0:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME, {
			id = slot8.id,
			name = slot8.str,
			onFailed = slot8.onFailed
		})

		return
	end

	if slot4 == LevelUIConst.FLEET_TYPE_SELECT then
		slot9 = slot8.id
		slot10 = slot3.fleetId
		slot11 = slot3.chapterId

		if slot8.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			slot0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = slot9,
				commanders = slot7:getFleetById(slot10).getCommanders(slot12)
			})
		elseif slot8.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			slot0:sendNotification(GAME.USE_COMMANDER_PREFBA, {
				pid = slot9,
				fleetId = slot10
			})
		elseif slot8.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			slot12 = {
				function (slot0)
					slot0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						pos = 1,
						fleetId = slot0.sendNotification,
						callback = slot0
					})
				end,
				function (slot0)
					slot0:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						pos = 2,
						fleetId = slot0.sendNotification,
						callback = slot0
					})
				end
			}

			seriesAsync(slot12)
		end

		return
	end

	if slot4 == LevelUIConst.FLEET_TYPE_EDIT then
		slot10 = slot5:getPrefabFleetById(slot9)
		slot11 = slot3.index
		slot12 = slot3.chapterId

		if slot8.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			if table.getCount(slot6:getChapterById(slot12).getEliteFleetCommanders(slot13)[slot11]) == 0 then
				return
			end

			slot16 = {}

			for slot20 = 1, 2, 1 do
				if slot5:getCommanderById(slot15[slot20]) then
					slot16[slot20] = slot22
				end
			end

			slot0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = slot9,
				commanders = slot16
			})
			slot6:updateChapter(slot13)
			slot0:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = slot13.id,
				index = slot11
			})
		elseif slot8.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			slot13 = {}

			for slot17 = 1, 2, 1 do
				if slot10:getCommanderByPos(slot17) then
					slot19, slot20 = Commander.canEquipToEliteChapter(slot12, slot11, slot17, slot18.id)

					if not slot19 then
						pg.TipsMgr.GetInstance():ShowTips(slot20)

						return
					end
				end
			end

			if slot10:isSameId(slot6:getChapterById(slot12).getEliteFleetCommanders(slot14)[slot11]) then
				return
			end

			for slot20 = 1, 2, 1 do
				if slot10:getCommanderByPos(slot20) then
					slot0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
						chapterId = slot12,
						index = slot11,
						pos = slot20,
						commanderId = slot21.id
					})
				else
					slot0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
						chapterId = slot12,
						index = slot11,
						pos = slot20
					})
				end
			end

			slot0:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = slot14.id,
				index = slot11
			})
		elseif slot8.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			slot13 = slot6:getChapterById(slot12)

			for slot17 = 1, 2, 1 do
				slot0:sendNotification(GAME.SELECT_ELIT_CHAPTER_COMMANDER, {
					chapterId = slot12,
					index = slot11,
					pos = slot17
				})
			end

			slot0:sendNotification(GAME.COMMANDER_ELIT_FORMATION_OP_DONE, {
				chapterId = slot13.id,
				index = slot11
			})
		end
	elseif slot4 == LevelUIConst.FLEET_TYPE_ACTIVITY then
		slot10 = slot5:getPrefabFleetById(slot9)
		slot11 = slot3.fleetId
		slot12 = slot3.actId

		if slot8.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			slot0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = slot9,
				commanders = slot7:getActivityFleets()[slot12][slot11].getCommanders(slot13)
			})
		elseif slot8.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			slot13 = {}
			slot14 = slot7:getActivityFleets()[slot12]
			slot16 = (pg.activity_template[slot12] and slot15.type) or 0

			function slot17(slot0)
				for slot4, slot5 in pairs(slot0) do
					slot6 = slot1 ~= slot4

					if slot4 == ActivityBossMediatorTemplate.GetPairedFleetIndex(slot1) then
						for slot11, slot12 in pairs(slot7) do
							if slot0 == slot12.id then
								return slot4, slot11
							end
						end
					end
				end

				return nil
			end

			for slot21 = 1, 2, 1 do
				if slot10.getCommanderByPos(slot10, slot21) then
					slot23, slot24 = slot17(slot22.id)

					if slot23 and slot24 then
						table.insert(slot13, function (slot0)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", Fleet.DEFAULT_NAME[(slot0 == 1 and i18n("commander_main_pos")) or i18n("commander_assistant_pos")], (slot0 == 1 and i18n("commander_main_pos")) or i18n("commander_assistant_pos")),
								onYes = function ()
									slot0[slot1].updateCommanderByPos(slot0, , nil)
									slot3:updateActivityFleet(nil, slot3.updateActivityFleet, slot0)
									slot0[slot5].updateCommanderByPos(slot1, slot6, slot7)
									slot1:updateActivityFleet(slot6, slot7, slot0[slot5])
									slot8()
								end,
								onNo = slot0
							})
						end)
					else
						table.insert(slot13, function (slot0)
							slot0[].updateCommanderByPos(slot1, slot0[].updateCommanderByPos, )
							slot4:updateActivityFleet(slot1, slot0[], )
							slot0()
						end)
					end
				else
					table.insert(slot13, function (slot0)
						slot0[].updateCommanderByPos(slot1, slot0[].updateCommanderByPos, nil)
						slot1:updateActivityFleet(slot0[].updateCommanderByPos, slot0[], )
						slot0()
					end)
				end
			end

			seriesAsync(slot13, function ()
				slot0:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
					actId = slot1,
					fleetId = GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE
				})
			end)
		elseif slot8.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			slot13 = slot7.getActivityFleets(slot7)[slot12][slot11]

			for slot17 = 1, 2, 1 do
				slot13:updateCommanderByPos(slot17, nil)
			end

			slot7:updateActivityFleet(slot12, slot11, slot13)
			slot0:sendNotification(GAME.COMMANDER_ACTIVITY_FORMATION_OP_DONE, {
				actId = slot12,
				fleetId = slot11
			})
		end
	elseif slot4 == LevelUIConst.FLEET_TYPE_WORLD then
		slot10 = slot5:getPrefabFleetById(slot9)
		slot15 = Fleet.New({
			ship_list = {},
			commanders = slot3.fleets[slot3.fleetType][slot3.fleetIndex].commanders
		})

		if slot8.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
			slot0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
				id = slot9,
				commanders = slot15:getCommanders()
			})
		elseif slot8.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			slot16 = {}

			function slot17(slot0)
				for slot4, slot5 in pairs(slot0) do
					for slot9, slot10 in pairs(slot5) do
						if slot1 ~= slot10 then
							for slot14, slot15 in ipairs(slot10.commanders) do
								if slot15.id == slot0 then
									return slot4, slot9, slot15.pos
								end
							end
						end
					end
				end

				return nil
			end

			for slot21 = 1, 2, 1 do
				if slot10.getCommanderByPos(slot10, slot21) then
					slot23, slot24, slot25 = slot17(slot22.id)

					if slot23 and slot24 and slot25 then
						table.insert(slot16, function (slot0)
							pg.MsgboxMgr.GetInstance():ShowMsgBox({
								content = i18n("comander_repalce_tip", slot2[((slot0 == 1 and i18n("commander_main_pos")) or i18n("commander_assistant_pos")) + ((Fleet.DEFAULT_NAME == FleetType.Submarine and 10) or 0)], (slot0 == 1 and i18n("commander_main_pos")) or i18n("commander_assistant_pos")),
								onYes = function ()
									slot1 = Fleet.New({
										ship_list = {},
										commanders = slot0[slot1][slot2].commanders
									})

									slot1:updateCommanderByPos(slot1, nil)

									slot0[slot1][slot2].commanders = slot1:outputCommanders()

									slot4:updateCommanderByPos(slot4, nil)

									slot6.commanders = slot4:outputCommanders()

									slot7()
								end,
								onNo = slot0
							})
						end)
					else
						table.insert(slot16, function (slot0)
							slot0:updateCommanderByPos(slot0.updateCommanderByPos, slot0)

							slot0.updateCommanderByPos.commanders = slot0:outputCommanders()

							slot0()
						end)
					end
				else
					table.insert(slot16, function (slot0)
						slot0:updateCommanderByPos(slot0.updateCommanderByPos, nil)

						slot0.commanders = slot0:outputCommanders()

						slot0()
					end)
				end
			end

			seriesAsync(slot16, function ()
				slot0:sendNotification(GAME.COMMANDER_WORLD_FORMATION_OP_DONE, {
					fleet = slot0
				})
			end)
		elseif slot8.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			for slot19 = 1, 2, 1 do
				slot15.updateCommanderByPos(slot15, slot19, nil)
			end

			slot14.commanders = slot15:outputCommanders()

			slot0:sendNotification(GAME.COMMANDER_WORLD_FORMATION_OP_DONE, {
				fleet = slot15
			})
		end
	end
end

return class("CommanderFormationOPCommand", pm.SimpleCommand)

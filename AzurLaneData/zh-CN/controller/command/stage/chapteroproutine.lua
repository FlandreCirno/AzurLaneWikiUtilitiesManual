slot0 = class("ChapterOpRoutine", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	return
end

slot0.initData = function (slot0, slot1, slot2, slot3)
	slot0.op = slot1
	slot0.data = slot2
	slot0.chapter = slot3
	slot0.items = {}
	slot0.fullpath = nil
	slot0.flag = 0
end

slot0.doDropUpdate = function (slot0)
	slot0.items = PlayerConst.addTranDrop(slot0.data.drop_list)
end

slot0.doMapUpdate = function (slot0)
	slot1 = slot0.data
	slot2 = slot0.flag
	slot3 = slot0.extraFlag or 0
	slot4 = slot0.chapter

	if #slot1.map_update > 0 then
		_.each(slot1.map_update, function (slot0)
			if slot0.item_type == ChapterConst.AttachStory and slot0.item_data == ChapterConst.StoryTrigger then
				if slot0.cellAttachments[ChapterCell.Line2Name(slot0.pos.row, slot0.pos.column)] then
					if slot2.flag == ChapterConst.CellFlagTriggerActive and slot0.item_flag == ChapterConst.CellFlagTriggerDisabled and pg.map_event_template[slot2.attachmentId].gametip ~= "" then
						pg.TipsMgr.GetInstance():ShowTips(i18n(slot3))
					end

					slot2.attachment = slot0.item_type
					slot2.attachmentId = slot0.item_id
					slot2.flag = slot0.item_flag
					slot2.data = slot0.item_data
				else
					slot0.cellAttachments[slot1] = ChapterCell.New(slot0)
				end
			elseif slot0.item_type ~= ChapterConst.AttachNone and slot0.item_type ~= ChapterConst.AttachBorn and slot0.item_type ~= ChapterConst.AttachBorn_Sub then
				slot0:mergeChapterCell(ChapterCell.New(slot0))
			end
		end)

		slot2 = bit.bor(slot2, ChapterConst.DirtyAttachment)
		slot3 = bit.bor(slot3, ChapterConst.DirtyAutoAction)
	end

	slot0.flag = slot2
	slot0.extraFlag = slot3
end

slot0.doCellFlagUpdate = function (slot0)
	slot2 = slot0.flag
	slot3 = slot0.chapter

	if #slot0.data.cell_flag_list > 0 then
		_.each(slot1.cell_flag_list, function (slot0)
			if slot0:getChapterCell(slot0.pos.row, slot0.pos.column) then
				slot1:updateFlagList(slot0)
			else
				slot1 = ChapterCell.New(slot0)
			end

			slot1.chapter:updateChapterCell(slot1)
		end)

		slot2 = bit.bor(slot2, ChapterConst.DirtyCellFlag)
	end

	slot0.flag = slot2
end

slot0.doAIUpdate = function (slot0)
	slot1 = slot0.data
	slot2 = slot0.flag
	slot3 = slot0.extraFlag or 0
	slot4 = slot0.chapter

	if #slot1.ai_list > 0 then
		_.each(slot1.ai_list, function (slot0)
			slot0:mergeChampion(ChapterChampionPackage.New(slot0))
		end)

		slot2 = bit.bor(slot2, ChapterConst.DirtyChampion)
		slot3 = bit.bor(slot3, ChapterConst.DirtyAutoAction)
	end

	slot0.flag = slot2
	slot0.extraFlag = slot3
end

slot0.doShipUpdate = function (slot0)
	slot2 = slot0.flag
	slot4 = slot0.chapter.fleet

	if #slot0.data.ship_update > 0 then
		_.each(slot1.ship_update, function (slot0)
			if slot0:getShip(slot0.id) and slot1.hpRant * slot0.hp_rant == 0 and slot1:getShipType() == ShipType.WeiXiu then
				slot1 = bit.bor(slot1, ChapterConst.DirtyStrategy)
			end

			slot0:updateShipHp(slot0.id, slot0.hp_rant)
		end)

		slot2 = bit.bor(slot2, ChapterConst.DirtyFleet)
	end

	slot0.flag = slot2
end

slot0.doBuffUpdate = function (slot0)
	slot0.chapter:UpdateBuffList(slot0.data.buff_list)
end

slot0.doExtraFlagUpdate = function (slot0)
	slot2 = slot0.chapter
	slot3 = getProxy(ChapterProxy)

	if #slot0.data.add_flag_list > 0 or #slot1.del_flag_list > 0 then
		slot3:updateExtraFlag(slot2, slot1.add_flag_list, slot1.del_flag_list)

		slot0.flag = bit.bor(slot0.flag, ChapterConst.DirtyFleet, ChapterConst.DirtyStrategy, ChapterConst.DirtyCellFlag, ChapterConst.DirtyFloatItems)
	end
end

slot0.doRetreat = function (slot0)
	slot2 = slot0.data
	slot3 = slot0.flag
	slot4 = slot0.chapter

	if slot0.op.id then
		if #slot4.fleets > 0 then
			slot4.fleets = _.filter(slot4.fleets, function (slot0)
				return slot0.id ~= slot0.id
			end)

			if slot4.fleets[slot1.id] and slot5.getFleetType(slot5) == FleetType.Normal then
				slot4.findex = 1
			end

			slot3 = bit.bor(slot3, ChapterConst.DirtyFleet, ChapterConst.DirtyAttachment, ChapterConst.DirtyChampion, ChapterConst.DirtyStrategy)
		end
	else
		slot4:retreat(slot1.win)

		slot3 = ChapterConst.DirtyMapItems
	end

	slot0.flag = slot3
end

slot0.doMove = function (slot0)
	slot1 = slot0.op
	slot4 = slot0.chapter.fleet
	slot5 = nil

	if #slot0.data.move_path > 0 then
		slot6 = _.map(_.rest(slot2.move_path, 1), function (slot0)
			return {
				row = slot0.row,
				column = slot0.column
			}
		end)
		slot5 = slot6
		slot4.line = {
			row = slot2.move_path[#slot2.move_path].row,
			column = slot2.move_path[#slot2.move_path].column
		}
	end

	slot0.fullpath = slot5

	slot3:IncreaseRound()

	slot0.flag = 0
end

slot0.doOpenBox = function (slot0)
	slot1 = slot0.items
	slot6 = slot0.chapter.getChapterCell(slot3, slot0.chapter.fleet.line.row, slot0.chapter.fleet.line.column)
	slot6.flag = ChapterConst.CellFlagDisabled

	slot0.chapter.updateChapterCell(slot3, slot6)

	slot2 = bit.bor(slot0.flag, ChapterConst.DirtyAttachment)

	if pg.box_data_template[slot6.attachmentId].type == ChapterConst.BoxStrategy then
		slot4:achievedOneStrategy(slot8)
		table.insert(slot1, Item.New({
			count = 1,
			type = DROP_TYPE_STRATEGY,
			id = slot7.effect_id
		}))

		slot2 = bit.bor(slot2, ChapterConst.DirtyStrategy)
	elseif slot7.type == ChapterConst.BoxSupply then
		slot8, slot9 = slot3:getFleetAmmo(slot4)
		slot4.restAmmo = slot4.restAmmo + math.min(slot8 - slot9, slot7.effect_id)
		slot2 = bit.bor(slot2, ChapterConst.DirtyFleet)

		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", slot7.effect_id))
	end

	slot0.flag = slot2
end

slot0.doPlayStory = function (slot0)
	slot0.chapter.getChapterCell(slot2, slot0.chapter.fleet.line.row, slot0.chapter.fleet.line.column).flag = ChapterConst.CellFlagDisabled

	slot0.chapter.updateChapterCell(slot2, slot5)

	slot0.flag = bit.bor(slot0.flag, ChapterConst.DirtyAttachment)
end

slot0.doAmbush = function (slot0)
	slot3 = slot0.chapter.fleet

	if slot0.op.arg1 == 1 then
		if slot2:getChapterCell(slot3.line.row, slot3.line.column).flag == ChapterConst.CellFlagAmbush then
			slot2:clearChapterCell(slot4.row, slot4.column)
		end

		pg.TipsMgr.GetInstance():ShowTips((slot5.flag == ChapterConst.CellFlagActive and i18n("chapter_tip_aovid_failed")) or i18n("chapter_tip_aovid_succeed"))
	end
end

slot0.doStrategy = function (slot0)
	slot1 = slot0.flag
	slot4 = slot0.chapter.fleet

	if pg.strategy_data_template[slot0.op.arg1].type == ChapterConst.StgTypeForm then
		for slot9, slot10 in ipairs(slot4.stgIds) do
			if pg.strategy_data_template[slot10].type == ChapterConst.StgTypeForm then
				slot4.stgIds[slot9] = slot5.id
			end
		end

		PlayerPrefs.SetInt("team_formation_" .. slot4.id, slot5.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_change", slot5.name))
	elseif slot5.type == ChapterConst.StgTypeConsume then
		slot4:consumeOneStrategy(slot5.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("chapter_tip_use", slot5.name))
	end

	if slot5.id == ChapterConst.StrategyExchange then
		slot3:getFleetById(slot2.arg2).line = slot3:getFleetById(slot2.id).line
		slot3.getFleetById(slot2.id).line = slot3.getFleetById(slot2.arg2).line
		slot1 = bit.bor(slot1, ChapterConst.DirtyFleet)
	end

	slot0.flag = bit.bor(slot1, ChapterConst.DirtyStrategy)
end

slot0.doRepair = function (slot0)
	slot1 = getProxy(ChapterProxy)
	slot1.repairTimes = slot1.repairTimes + 1
	slot2, slot3, slot4 = ChapterConst.GetRepairParams()

	if slot2 < slot1.repairTimes then
		slot5 = getProxy(PlayerProxy)
		slot6 = slot5:getData()

		slot6:consume({
			gem = slot4
		})
		slot5:updatePlayer(slot6)
	end
end

slot0.doSupply = function (slot0)
	slot1 = slot0.flag
	slot4, slot5 = slot0.chapter.getFleetAmmo(slot2, slot3)
	slot7 = slot0.chapter.getChapterCell(slot2, slot0.chapter.fleet.line.row, slot0.chapter.fleet.line.column)
	slot7.attachmentId = slot7.attachmentId - math.min(slot7.attachmentId, slot4 - slot5)
	slot0.chapter.fleet.restAmmo = slot0.chapter.fleet.restAmmo + math.min(slot7.attachmentId, slot4 - slot5)

	slot0.chapter.updateChapterCell(slot2, slot7)

	if slot7.attachmentId > 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply_p1", slot8))
	elseif slot7.attachmentId > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_supply", slot8, slot7.attachmentId))
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("level_ammo_empty", slot8))
	end

	slot0.flag = bit.bor(slot1, ChapterConst.DirtyAttachment, ChapterConst.DirtyFleet)
end

slot0.doSubState = function (slot0)
	slot0.chapter.subAutoAttack = slot0.op.arg1
	slot0.flag = bit.bor(slot0.flag, ChapterConst.DirtyStrategy)
end

slot0.doCollectAI = function (slot0)
	slot2 = slot0.flag
	slot3 = slot0.chapter
	slot0.aiActs = {}

	if slot0.data.submarine_act_list then
		_.each(slot1.submarine_act_list, function (slot0)
			table.insert(slot0.aiActs, SubAIAction.New(slot0))
		end)
	end

	if slot1.escort_act_list then
		_.each(slot1.escort_act_list, function (slot0)
			table.insert(slot0.aiActs, TransportAIAction.New(slot0))
		end)
	end

	_.each(slot1.ai_act_list, function (slot0)
		table.insert(slot0.aiActs, ChapterAIAction.New(slot0))
	end)
	_.each(slot1.fleet_act_list, function (slot0)
		table.insert(slot0.aiActs, FleetAIAction.New(slot0))
	end)
end

slot0.doBarrier = function (slot0)
	slot1 = slot0.flag
	slot6 = _.detect(pg.box_data_template.all, function (slot0)
		return pg.box_data_template[slot0].type == ChapterConst.BoxBarrier
	end)

	if slot0.chapter.getChapterCell(slot3, slot0.op.arg1, slot0.op.arg2).attachment ~= ChapterConst.AttachBox or slot4.attachmentId ~= slot6 then
		slot4.attachment = slot5
		slot4.attachmentId = slot6
		slot4.flag = ChapterConst.CellFlagDisabled
	end

	slot3.modelCount = slot3.modelCount + ((slot4.flag == 1 and -1) or 1)
	slot4.flag = 1 - slot4.flag

	slot3.updateChapterCell(slot3, slot4)

	slot0.flag = bit.bor(slot1, ChapterConst.DirtyAttachment, ChapterConst.DirtyStrategy)
end

slot0.doRequest = function (slot0)
	slot2 = slot0.flag
	slot4 = slot0.chapter.fleet

	if #slot0.data.move_path > 0 then
		slot4.line = {
			row = slot1.move_path[#slot1.move_path].row,
			column = slot1.move_path[#slot1.move_path].column
		}
		slot2 = bit.bor(slot2, ChapterConst.DirtyFleet)
	end

	slot0.flag = slot2
end

slot0.doSkipBattle = function (slot0)
	slot0.flag = bit.bor(slot0.flag, ChapterConst.DirtyStrategy, ChapterConst.DirtyAttachment, ChapterConst.DirtyAchieve, ChapterConst.DirtyFleet, ChapterConst.DirtyChampion)
end

slot0.doTeleportSub = function (slot0)
	slot0.fullpath = {
		_.detect(slot0.chapter.fleets, function (slot0)
			return slot0.id == slot0.id
		end).startPos,
		{
			row = slot0.op.arg1,
			column = slot0.op.arg2
		}
	}
end

slot0.doEnemyRound = function (slot0)
	slot0.chapter.IncreaseRound(slot1)

	if slot0.chapter.getPlayType(slot1) == ChapterConst.TypeDefence then
		slot0.flag = bit.bor(slot0.flag, ChapterConst.DirtyAttachment)
	end
end

slot0.doTeleportByPortal = function (slot0)
	if not (slot0.fullpath and slot0.fullpath[#slot0.fullpath]) then
		return
	end

	slot2 = slot0.chapter
	slot3 = nil

	if slot0.op.type == ChapterConst.OpMove then
		slot3 = slot2:GetCellEventByKey("jump", slot1.row, slot1.column)
	elseif slot0.op.type == ChapterConst.OpSubTeleport then
		slot3 = slot2:GetCellEventByKey("jumpsub", slot1.row, slot1.column)
	end

	if not slot3 then
		return
	end

	slot4 = {
		row = slot3[1],
		column = slot3[2]
	}

	if slot0.op.type == ChapterConst.OpMove and slot2:getFleet(FleetType.Normal, slot4.row, slot4.column) then
		return
	end

	slot0.teleportPaths = slot0.teleportPaths or {}

	table.insert(slot0.teleportPaths, {
		row = slot1.row,
		column = slot1.column
	})
	table.insert(slot0.teleportPaths, slot4)
end

return slot0

slot0 = class("WorldMapOpCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(33103, {
		act = slot1:getBody().op,
		group_id = slot1.getBody().id or 0,
		act_arg_1 = slot2.arg1,
		act_arg_2 = slot2.arg2,
		pos_list = slot2.locations or {}
	}, 33104, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(WorldProxy)
			slot2 = nowWorld:GetActiveMap()
			slot0.drops = PlayerConst.addTranDrop(slot0.drop_list)
			slot0.updateAttachmentCells = slot1:NetBuildMapAttachmentCells(slot0.pos_list)
			slot0.fleetAttachUpdates = slot1:NetBuildFleetAttachUpdate(slot0.pos_list)
			slot0.terrainUpdates = slot1:NetBulidTerrainUpdate(slot0.land_list)
			slot0.fleetUpdates = slot1:NetBuildFleetUpdate(slot0.group_update)
			slot0.shipUpdates = slot1:NetBuildShipUpdate(slot0.ship_update)
			slot0.salvageUpdates = slot1:NetBuildSalvageUpdate(slot0.cmd_collection_list)

			WorldConst.DebugPrintAttachmentCell("Op is " .. slot0.op, slot0.updateAttachmentCells)
			slot1:NetUpdateAchievements(slot0.target_list)

			if slot0.op == WorldConst.OpReqMoveFleet then
				slot1:BuildFleetMove(slot0.move_path, slot0)
			elseif slot0.op == WorldConst.OpReqRetreat then
				slot0.childOps = slot1:BuildAIAction(slot0)
			elseif slot0.op == WorldConst.OpReqEvent then
				slot5 = slot0.effect.effect_paramater

				if slot0.effect.effect_type == WorldMapAttachment.EffectEventTeleport or slot4 == WorldMapAttachment.EffectEventTeleportBack then
					slot1:BuildTransfer(slot0, slot0)
				elseif slot4 == WorldMapAttachment.EffectEventProgress then
					slot0.childOps = slot1:BuildProgressAction(slot5[1])
				elseif slot4 == WorldMapAttachment.EffectEventBlink1 or slot4 == WorldMapAttachment.EffectEventBlink2 then
					slot0.childOps = slot1:BuildBlinkAction(slot0.attachment, slot0.updateAttachmentCells)
				end
			elseif slot0.op == WorldConst.OpReqTransport then
				slot1:BuildTransfer(slot0, slot0)
			elseif slot0.op == WorldConst.OpReqJumpOut then
				slot1:BuildTransfer(slot0, slot0)
			elseif slot0.op == WorldConst.OpReqRound then
				slot0.childOps = slot1:BuildAIAction(slot0)
			elseif slot0.op == WorldConst.OpReqBox then
			end
		else
			if slot0.result == 130 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_stamina_not_enough"))
			elseif slot0.op == WorldConst.OpReqRetreat then
				pg.TipsMgr.GetInstance():ShowTips(i18n("no_way_to_escape"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("world_map_op_error_", slot0.result))
			end

			if slot0.op == WorldConst.OpReqEvent then
				WorldConst.Print(slot0.attachment:DebugPrint())
			end
		end

		slot1:sendNotification(GAME.WORLD_MAP_OP_DONE, {
			result = slot0.result,
			mapOp = slot0
		})
	end)
end

slot0.BuildAIAction = function (slot0, slot1)
	slot2 = {}
	slot3 = getProxy(WorldProxy)

	for slot7, slot8 in ipairs(slot1.ai_act_list) do
		slot9 = {}
		(slot8.type ~= WorldMapAttachment.TypeFleet or slot0:BuildFleetAction(slot8)) and (slot8.type ~= WorldMapAttachment.TypeTrap or slot0:BuildTrapAction(slot8)) and slot0:BuildAttachmentAction(slot8, slot2)[#((slot8.type ~= WorldMapAttachment.TypeFleet or slot0.BuildFleetAction(slot8)) and (slot8.type ~= WorldMapAttachment.TypeTrap or slot0.BuildTrapAction(slot8)) and slot0.BuildAttachmentAction(slot8, slot2))].shipUpdates = slot3:NetBuildShipUpdate(slot8.ship_update)
		(slot8.type ~= WorldMapAttachment.TypeFleet or slot0.BuildFleetAction(slot8)) and (slot8.type ~= WorldMapAttachment.TypeTrap or slot0.BuildTrapAction(slot8)) and slot0.BuildAttachmentAction(slot8, slot2)[#((slot8.type ~= WorldMapAttachment.TypeFleet or slot0.BuildFleetAction(slot8)) and (slot8.type ~= WorldMapAttachment.TypeTrap or slot0.BuildTrapAction(slot8)) and slot0.BuildAttachmentAction(slot8, slot2))].fleetAttachUpdates = slot3:NetBuildFleetAttachUpdate(slot8.pos_list)
		slot2 = table.mergeArray(slot2, (slot8.type ~= WorldMapAttachment.TypeFleet or slot0.BuildFleetAction(slot8)) and (slot8.type ~= WorldMapAttachment.TypeTrap or slot0.BuildTrapAction(slot8)) and slot0.BuildAttachmentAction(slot8, slot2))
	end

	return slot2
end

slot0.BuildTransfer = function (slot0, slot1, slot2)
	slot2.entranceId = slot1.enter_map_id
	slot2.destMapId = slot1.id.random_id
	slot2.destGridId = slot1.id.template_id
	slot2.staminaUpdate = {
		slot1.action_power,
		slot1.action_power_extra
	}
end

slot0.BuildFleetMove = function (slot0, slot1, slot2)
	slot3 = {}

	if #slot1 > 0 then
		slot4 = nowWorld:GetActiveMap()
		slot5 = slot4:GetFleet()
		slot2.updateAttachmentCells = {}
		slot3 = table.mergeArray(slot3, slot0:BuildFleetMoveAction(slot1, slot4, slot5.id, slot5.row, slot5.column, slot2.updateAttachmentCells, true))
	elseif slot2.trap == WorldBuff.TrapVortex then
		slot4 = WBank:Fetch(WorldMapOp)
		slot4.op = WorldConst.OpActionFleetAnim
		slot4.id = slot2.id
		slot4.anim = WorldConst.ActionYun
		slot4.duration = 2

		table.insert(slot3, slot4)
	end

	slot2.path = _.rest(slot1, 1)
	slot2.childOps = slot3
end

slot0.BuildFleetPath = function (slot0, slot1, slot2, slot3, slot4)
	_.each(slot1, function (slot0)
		slot0.duration = slot0.duration * slot0:GetStepDurationRate()
	end)

	slot8 = {}
	slot11 = _.map(slot10, function (slot0)
		return slot0:BuildCarryPath(slot0, slot0.BuildCarryPath, slot0)
	end)

	_.each(slot1, function (slot0)
		slot1 = WBank:Fetch(WorldMapOp)
		slot1.op = WorldConst.OpActionMoveStep
		slot1.id = slot0.id
		slot1.pos = {
			row = slot0.row,
			column = slot0.column
		}
		slot1.updateAttachmentCells = {}
		slot1.hiddenCells = {}
		slot1.hiddenAttachments = {}

		if #slot1 > 0 then
			slot1.updateCarryItems = {}

			for slot5, slot6 in ipairs(slot1) do
				slot8 = WPool:Get(WorldCarryItem)

				slot8:Setup(slot6.id)
				slot8:UpdateOffset(slot2[#slot1.updateCarryItems + 1][#slot3 + 1].row - slot0.row, slot2[#slot1.updateCarryItems + 1][#slot3 + 1].column - slot0.column)
				table.insert(slot1.updateCarryItems, slot8)
			end
		end

		slot2 = slot4.theme

		for slot7 = slot0.row - slot4:GetFOVRange(slot5, slot0.row, slot0.column), slot0.row + slot4.GetFOVRange(slot5, slot0.row, slot0.column), 1 do
			for slot11 = slot0.column - slot3, slot0.column + slot3, 1 do
				slot13 = slot7 .. "_" .. slot11

				if slot4:GetCell(slot7, slot11) and not slot12.discovered and WorldConst.InFOVRange(slot0.row, slot0.column, slot7, slot11, slot3) and not slot6[slot13] then
					slot6[slot13] = true

					table.insert(slot1.hiddenCells, slot12)
					table.insert(slot7, {
						row = slot12.row,
						column = slot12.column
					})
					_.each(slot12.attachments, function (slot0)
						if slot0:ShouldMarkAsLurk() then
							table.insert(slot0.hiddenAttachments, slot0)
						end
					end)

					if slot8[WorldMapCell.GetName(slot12.row, slot12.column)] then
						_.each(slot8[slot14].attachmentList, function (slot0)
							if slot0:ShouldMarkAsLurk() then
								table.insert(slot0.hiddenAttachments, slot0)
							end
						end)

						slot1.updateAttachmentCells[slot14] = slot8[slot14]
						slot8[slot14] = nil
					end
				end
			end
		end

		table.insert(slot3, slot1)
	end)

	slot3.stepOps = {}
	slot3.path = slot1
	slot3.pos = {
		row = slot2.row,
		column = slot2.column
	}
	slot3.locations = {}
end

slot0.BuildFleetAction = function (slot0, slot1)
	slot3 = nowWorld:GetActiveMap().FindFleet(slot2, slot1.ai_pos.row, slot1.ai_pos.column)
	slot4 = getProxy(WorldProxy):NetBuildMapAttachmentCells(slot1.pos_list)
	slot5 = nil

	if #slot1.move_path > 0 then
		slot5 = slot0:BuildFleetMoveAction(slot1.move_path, slot2, slot3.id, slot3.row, slot3.column, slot4)
	else
		slot6 = WBank:Fetch(WorldMapOp)
		slot6.op = WorldConst.OpActionUpdate
		slot6.updateAttachmentCells = slot4
		slot5 = {
			slot6
		}
	end

	return slot5
end

slot0.BuildFleetMoveAction = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot8 = {}
	slot9 = (slot7 and WorldMapCell.TerrainNone) or slot2:GetCell(slot4, slot5):GetTerrain()
	slot10 = slot2:GetCell(slot4, slot5).terrainStrong
	slot11 = {
		row = slot4,
		column = slot5
	}
	slot12 = 0
	slot13 = {}

	for slot17, slot18 in ipairs(slot1) do
		slot20 = slot2:GetCell(slot18.row, slot18.column).GetTerrain(slot19)

		table.insert(slot13, {
			row = slot18.row,
			column = slot18.column,
			terrain = slot9,
			duration = WorldConst.GetTerrainMoveStepDuration(slot9)
		})

		slot21, slot22, slot23 = nil

		if slot9 == WorldMapCell.TerrainWind and slot12 + slot10 > #slot13 then
			slot21 = true
		elseif slot9 ~= slot20 then
			slot22 = true
		elseif slot20 == WorldMapCell.TerrainWind then
			slot23 = true
		end

		if slot17 == #slot1 or slot22 then
			slot12 = 0
			slot24 = WBank:Fetch(WorldMapOp)
			slot24.op = WorldConst.OpActionFleetMove
			slot24.id = slot3
			slot24.arg1 = slot18.row
			slot24.arg2 = slot18.column

			slot0:BuildFleetPath(slot13, slot11, slot24, slot6)

			if slot17 == #slot1 then
				slot24.updateAttachmentCells = slot6
			end

			table.insert(slot8, slot24)

			slot11 = {
				row = slot18.row,
				column = slot18.column
			}
			slot13 = {}
		elseif slot23 then
			slot12 = slot12 + slot10
		end

		if slot21 then
		else
			slot9 = slot20
			slot10 = slot19.terrainStrong
		end
	end

	return slot8
end

slot0.BuildAttachmentAction = function (slot0, slot1)
	slot8 = WBank:Fetch(WorldMapOp)
	slot8.op = WorldConst.OpActionCameraMove
	slot8.attachment = nowWorld:GetActiveMap().GetCell(slot2, slot3, slot4).FindAliveAttachment(slot5, WorldMapAttachment.TypeEnemyAI)

	table.insert(slot7, slot8)

	WBank:Fetch(WorldMapOp).updateAttachmentCells = getProxy(WorldProxy):NetBuildMapAttachmentCells(slot1.pos_list)

	if #slot1.move_path > 0 then
		slot9.op = WorldConst.OpActionAttachmentMove
		slot9.attachment = slot6

		slot0:BuildAttachmentActionPath(slot1.move_path, slot9)
	else
		slot9.op = WorldConst.OpActionUpdate
	end

	table.insert(slot7, slot9)

	return slot7
end

slot0.BuildAttachmentActionPath = function (slot0, slot1, slot2)
	slot3 = nowWorld:GetActiveMap()
	slot2.path = underscore.map(slot1, function (slot0)
		return {
			row = slot0.row,
			column = slot0.column,
			duration = WorldConst.GetTerrainMoveStepDuration(WorldMapCell.TerrainNone)
		}
	end)
	slot2.pos = {
		row = slot2.attachment.row,
		column = slot2.attachment.column
	}
end

slot0.BuildTrapAction = function (slot0, slot1)
	slot8 = WBank:Fetch(WorldMapOp)
	slot8.op = WorldConst.OpActionCameraMove
	slot8.attachment = nowWorld:GetActiveMap().GetCell(slot2, slot3, slot4).FindAliveAttachment(slot5, WorldMapAttachment.TypeTrap)

	table.insert(slot7, slot8)

	slot9 = WBank:Fetch(WorldMapOp)
	slot9.op = WorldConst.OpActionTrapGravityAnim
	slot9.attachment = nowWorld.GetActiveMap().GetCell(slot2, slot3, slot4).FindAliveAttachment(slot5, WorldMapAttachment.TypeTrap)

	table.insert({}, slot9)

	return 
end

slot0.BuildBlinkAction = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = slot1:GetSpEventType()
	slot5 = slot2[WorldMapCell.GetName(slot1.row, slot1.column)]
	slot6 = nil

	for slot10, slot11 in pairs(slot2) do
		if _.any(slot11.attachmentList, function (slot0)
			return slot0.type == slot0.type and slot0.id == slot0.id
		end) then
			slot6 = slot11

			break
		end
	end

	if slot4 == WorldMapAttachment.SpEventHaibao then
		slot7 = WBank:Fetch(WorldMapOp)
		slot7.op = WorldConst.OpActionAttachmentAnim
		slot7.attachment = slot1
		slot7.anim = WorldConst.ActionVanish
		slot7.updateAttachmentCells = {
			[WorldMapCell.GetName(slot5.pos.row, slot5.pos.column)] = slot5,
			[WorldMapCell.GetName(slot6.pos.row, slot6.pos.column)] = slot6
		}
		slot2[WorldMapCell.GetName(slot5.pos.row, slot5.pos.column)] = nil
		slot2[WorldMapCell.GetName(slot6.pos.row, slot6.pos.column)] = nil

		table.insert(slot3, slot7)

		slot8 = WBank:Fetch(WorldMapOp)
		slot8.op = WorldConst.OpActionAttachmentAnim
		slot8.attachment = _.detect(slot6.attachmentList, function (slot0)
			return slot0.type == slot0.type and slot0.id == slot0.id
		end)
		slot8.anim = WorldConst.ActionAppear

		table.insert(slot3, slot8)
	elseif slot4 == WorldMapAttachment.SpEventFufen then
		slot8, slot9 = nowWorld:GetActiveMap().FindAIPath(slot7, {
			row = slot1.row,
			column = slot1.column
		}, {
			row = slot6.pos.row,
			column = slot6.pos.column
		})

		if slot8 < PathFinding.PrioObstacle then
			slot10 = WBank:Fetch(WorldMapOp)
			slot10.op = WorldConst.OpActionAttachmentMove
			slot10.attachment = slot1

			slot0:BuildAttachmentActionPath(slot9, slot10)
			table.insert(slot3, slot10)
		end
	end

	return slot3
end

slot0.BuildProgressAction = function (slot0, slot1)
	slot2 = {}
	slot3 = nowWorld:GetRealm()

	if nowWorld:GetProgress() < slot1 then
		_.each(WorldConst.FindStageTemplates(slot1), function (slot0)
			if slot0 and #slot0.stage_effect[slot0] > 0 then
				_.each(slot0.stage_effect[slot0], function (slot0)
					slot2 = WBank:Fetch(WorldMapOp)
					slot2.op = WorldConst.OpActionEventEffect
					slot2.effect = pg.world_effect_data[slot0]

					table.insert(slot0, slot2)
				end)
			end
		end)
	end

	return slot2
end

return slot0
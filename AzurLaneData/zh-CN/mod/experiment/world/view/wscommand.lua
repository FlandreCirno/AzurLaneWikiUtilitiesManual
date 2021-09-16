slot0 = class("WSCommand")

slot0.Bind = function (slot0)
	slot1 = setmetatable({
		master = slot0
	}, {
		__index = _G
	})

	for slot5, slot6 in pairs(slot0) do
		if rawget(slot0, slot5) == slot6 and type(slot6) == "function" then
			setfenv(slot6, slot1)
		end
	end
end

slot0.Unbind = function ()
	for slot4, slot5 in pairs(slot0) do
		if rawget(slot0, slot4) == slot5 and type(slot5) == "function" then
			setfenv(slot5, slot0)
		end
	end
end

slot0.IsBind = function (slot0)
	return tobool(master)
end

slot0.Ctor = function (slot0, slot1)
	slot0.index = slot1
	slot0.wsOps = {}
end

slot0.Dispose = function (slot0)
	return
end

slot0.Op = function (slot0, slot1, ...)
	if #slot0.wsOps > 0 then
		WorldConst.Print("ignore operation: " .. slot1 .. ", current operation: " .. slot0.wsOps[#slot0.wsOps])

		return
	end

	WorldConst.Print(slot0.index .. " do operation: " .. slot1)
	table.insert(slot0.wsOps, slot1)
	slot0[slot1](slot0, ...)
end

slot0.OpPush = function (slot0, slot1, ...)
	WorldConst.Print(slot0.index .. " push operation: " .. slot1)
	table.insert(slot0.wsOps, slot1)
	slot0[slot1](slot0, ...)
end

slot0.OpDone = function (slot0, slot1, ...)
	slot2 = slot0.wsOps[#slot0.wsOps]

	if slot1 ~= nil and slot2 .. "Done" ~= slot1 then
		return
	end

	WorldConst.Print(slot0.index .. " operation done: " .. slot2)
	table.remove(slot0.wsOps, #slot0.wsOps)

	if slot1 then
		slot0[slot1](slot0, ...)
	end
end

slot0.OpClear = function (slot0)
	slot0.wsOps = {}
end

slot0.OpCall = function (slot0, slot1)
	slot1(function ()
		slot0:OpDone()
	end)
end

slot0.OpFetchMap = function (slot0, slot1, slot2)
	slot0.fetchCallback = slot2

	master:emit(WorldMediator.OnMapReq, slot1)
end

slot0.OpFetchMapDone = function (slot0)
	slot0.fetchCallback = nil

	existCall(slot0.fetchCallback)
end

slot0.OpSwitchMap = function (slot0, slot1, slot2)
	nowWorld:TriggerAutoFight(false)

	if not master:GetInMap() then
		slot0:OpDone()
		slot1:Apply()
		slot0:Op("OpSetInMap", true, slot2)

		return
	end

	slot3 = defaultValue(slot2, function ()
		slot0:Op("OpInteractive")
	end)
	slot2 = slot3

	if slot1.destMapId ~= nowWorld:GetActiveMap().id or slot1.destGridId ~= slot3.gid then
		table.insert(slot4, function (slot0)
			pg.UIMgr.GetInstance():BlurCamera(pg.UIMgr.CameraOverlay, true)
			master.wsTimer:AddInMapTimer(slot0, 1, 1):Start()
		end)
		table.insert(slot4, function (slot0)
			pg.UIMgr.GetInstance():UnblurCamera(pg.UIMgr.CameraOverlay)
			master:StopAnim()
			master:HideMap()
			master:HideMapUI()
			slot0()
		end)
		table.insert(slot4, function (slot0)
			slot0:Apply()
			master:LoadMap(nowWorld:GetActiveMap(), slot0)
		end)
		table.insert(slot4, function (slot0)
			master:DisplayEnv()
			master:DisplayMap()
			master:DisplayMapUI()
			master:UpdateMapUI()
			slot0()
		end)
		table.insert(slot4, function (slot0)
			master.wsTimer:AddInMapTimer(slot0, 0.5, 1):Start()
		end)
		seriesAsync(slot4, function ()
			slot0:OpDone()

			return slot0()
		end)
	else
		slot0.OpDone(slot0)
		slot1:Apply()
		master.wsDragProxy:Focus(master.wsMap:GetFleet().transform.position)

		return slot2()
	end
end

slot0.OpOpenLayer = function (slot0, slot1, slot2)
	slot0:OpDone()
	master:emit(WorldMediator.OnOpenLayer, slot1, slot2)
end

slot0.OpOpenScene = function (slot0, slot1, ...)
	slot0:OpDone()
	master:emit(WorldMediator.OnOpenScene, slot1, ...)
end

slot0.OpChangeScene = function (slot0, slot1, ...)
	slot0:OpDone()
	master:emit(WorldMediator.OnChangeScene, slot1, ...)
end

slot0.OpInteractive = function (slot0, slot1)
	slot0:OpDone()

	if master.contextData.inShop then
		master.contextData.inShop = false

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_shop_init_notice"),
			onYes = function ()
				slot0:Op("OpSetInMap", false, function ()
					slot0:Op("OpOpenLayer", Context.New({
						mediator = WorldShopMediator,
						viewComponent = WorldShopLayer
					}))
				end)
			end,
			onNo = function ()
				slot0:Op("OpInteractive")
			end
		})

		return
	end

	if nowWorld.GetRound(slot2) == WorldConst.RoundElse then
		slot0:Op("OpReqRound")

		return
	end

	master:InteractiveMoveQueue()

	if not master:GetInMap() then
		return
	end

	slot2 = nowWorld:GetActiveMap()

	table.insert(slot3, function (slot0)
		if not nowWorld.isAutoFight and nowWorld:HasAutoFightDrops() then
			table.insert(slot1, function (slot0)
				slot0:Op("OpOpenLayer", Context.New({
					mediator = WorldAutoFightRewardMediator,
					viewComponent = WorldAutoFightRewardLayer,
					onRemoved = slot0
				}))
			end)
			seriesAsync(slot1, function ()
				slot0:Op("OpInteractive")
			end)
		else
			slot0()
		end
	end)
	table.insert(slot3, function (slot0)
		if nowWorld:GetTaskProxy():getAutoSubmitTaskVO() then
			slot0:Op("OpAutoSubmitTask", slot1)
		else
			slot0()
		end
	end)
	table.insert(slot3, function (slot0)
		if master:CheckEventForMsg() then
			slot3 = (pg.collection_template[getProxy(EventProxy).eventForMsg.id or 0] and pg.collection_template[getProxy(EventProxy).eventForMsg.id or 0].title) or ""

			if nowWorld.isAutoFight then
				nowWorld:AddAutoInfo("message", i18n("autofight_entrust", slot3))
				slot0()
			else
				pg.MsgboxMgr.GetInstance().ShowMsgBox(slot5, {
					hideNo = true,
					content = i18n("event_special_update", slot3),
					onYes = function ()
						slot0:Op("OpInteractive")
					end,
					onNo = function ()
						slot0.Op("OpInteractive")
					end
				})
			end

			slot1.eventForMsg = nil
		else
			slot0()
		end
	end)
	table.insert(slot3, function (slot0)
		slot1 = pg.GuildMsgBoxMgr.GetInstance()

		if nowWorld.isAutoFight then
			if slot1:GetShouldShowBattleTip() then
				slot1:SubmitTask(function (slot0, slot1, slot2)
					nowWorld:AddAutoInfo("message", i18n("autofight_task", pg.task_data_template[slot2].desc))

					if slot1 then
						if slot0 then
							nowWorld:AddAutoInfo("message", i18n("guild_task_autoaccept_1", pg.task_data_template[slot2].desc))
						end

						slot0:CancelShouldShowBattleTip()
						slot1()
					else
						slot0:NotificationForWorld(slot1)
					end
				end)
			else
				slot0()
			end
		else
			slot1:NotificationForWorld(slot0)
		end
	end)
	table.insert(slot3, function (slot0)
		slot0.isLoss = false

		if slot0.isLoss then
			if WorldConst.IsRookieMap(slot0.id) then
				slot1:Op("OpStory", WorldConst.GetRookieBattleLoseStory(), true, function ()
					slot0:Op("OpKillWorld")
				end)

				return
			elseif WorldGuider.GetInstance().PlayGuide(slot2, "WorldG161") then
				nowWorld:TriggerAutoFight(false)
				slot1:Op("OpInteractive")

				return
			end
		end

		slot0()
	end)
	table.insert(slot3, function (slot0)
		if #master.achievedList > 0 then
			master:ShowSubView("Achievement", master.achievedList[1])
		else
			slot0()
		end
	end)
	table.insert(slot3, function (slot0)
		if #slot0.phaseDisplayList > 0 then
			master:DisplayPhaseAction(slot0.phaseDisplayList)
		else
			slot0()
		end
	end)
	table.insert(slot3, function (slot0)
		if slot0:CheckFleetSalvage() then
			slot1:Op("OpReqCatSalvage")
		else
			slot0()
		end
	end)
	table.insert(slot3, function (slot0)
		if not nowWorld:GetBossProxy().unlockTip then
			slot0()
		else
			slot1.unlockTip = false

			nowWorld:TriggerAutoFight(false)

			if WorldGuider.GetInstance():PlayGuide("WorldG190") then
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("world_boss_get_item"),
					onYes = function ()
						slot0:Op("OpOpenScene", SCENE.WORLDBOSS)
					end,
					onNo = function ()
						slot0:Op("OpInteractive")
					end
				})
			end
		end
	end)
	table.insert(slot3, function (slot0)
		if slot0:CheckInteractive() then
			slot2 = slot0:GetFleet()

			if slot1.type == WorldMapAttachment.TypeEvent then
				if slot1:RemainOpEffect() then
					slot1:Op("OpEventOp", slot1)
				else
					slot1:Op("OpEvent", slot2, slot1)
				end
			elseif WorldMapAttachment.IsEnemyType(slot1.type) then
				if nowWorld.isAutoFight or slot2 then
					slot4 = pg.expedition_data_template[slot1:GetBattleStageId()]

					if nowWorld:CheckSkipBattle() then
						slot1:Op("OpReqSkipBattle", slot2.id)
					elseif nowWorld.isAutoFight or PlayerPrefs.GetInt("world_skip_precombat", 0) == 1 then
						master:emit(WorldMediator.OnStart, slot3, slot2, slot1)
					else
						slot7 = {}

						if pg.world_expedition_data[slot3] and slot5.battle_type and slot5.battle_type ~= 0 then
							slot7.mediator = WorldBossInformationMediator
							slot7.viewComponent = WorldBossInformationLayer
						else
							slot7.mediator = WorldPreCombatMediator
							slot7.viewComponent = WorldPreCombatLayer
						end

						slot1:Op("OpOpenLayer", Context.New(slot7))
					end
				end
			elseif slot1.type == WorldMapAttachment.TypeBox then
				slot1:Op("OpReqBox", slot2, slot1)
			end
		else
			slot0()
		end
	end)
	seriesAsync(slot3, function ()
		slot0:Op("OpReqDiscover")
	end)
end

slot0.OpReqDiscover = function (slot0)
	if #nowWorld:GetActiveMap().CheckDiscover(slot1) > 0 then
		_.each(slot2, function (slot0)
			slot1 = slot0:GetCell(slot0.row, slot0.column)

			table.insert(slot1, slot1)
			_.each(slot1.attachments, function (slot0)
				if slot0:ShouldMarkAsLurk() then
					table.insert(slot0, slot0)
				end
			end)
		end)
		master.emit(slot5, WorldMediator.OnMapOp, master:NewMapOp({
			op = WorldConst.OpReqDiscover,
			locations = slot2,
			hiddenCells = {},
			hiddenAttachments = {}
		}))

		return
	end

	slot0:OpDone("OpReqDiscoverDone")
end

slot0.OpReqDiscoverDone = function (slot0, slot1)
	slot2 = nowWorld:GetActiveMap()
	slot3 = {}

	if slot1 and #slot1.hiddenAttachments > 0 then
		table.insert(slot3, function (slot0)
			slot0:Op("OpAnim", WorldConst.AnimRadar, slot0)
		end)
	end

	seriesAsync(slot3, function ()
		if slot0 then
			slot0:Apply()
			slot0:Op("OpInteractive")
		elseif slot2:CheckMapPressing() then
			slot1:Op("OpReqPressingMap")
		elseif nowWorld:CheckFleetMovable() then
			slot1:Op("OpReadyToMove")
		elseif not slot2:CheckFleetMovable(slot2:GetFleet()) and slot2:GetFleetTerrain(slot0) == WorldMapCell.TerrainWind then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_wind_move"))
		end
	end)
end

slot0.OpAnim = function (slot0, slot1, slot2)
	master:DoAnim(slot1, function ()
		slot0:OpDone()
		slot0()
	end)
end

slot0.OpReadyToMove = function (slot0)
	slot0:OpDone()

	slot3 = master.wsMap.map.GetFleet(slot2)

	if nowWorld.isAutoFight then
		if #master.moveQueue > 0 then
			master:DoQueueMove(slot3)
		else
			slot0:Op("OpAutoFightSeach")
		end

		return
	end

	if #master.moveQueue > 0 and slot2:CanLongMove(slot3) then
		master:DoQueueMove(slot3)

		return
	end

	master:ClearMoveQueue()
	slot1:UpdateRangeVisible(true)

	if #slot3:GetBuffsByTrap(WorldBuff.TrapDisturbance) > 0 then
		slot4 = slot2:GetMoveRange(slot3)

		if slot4[math.clamp(math.ceil(math.random() * #slot4), 1, #slot4)] then
			slot0:Op("OpReqMoveFleet", slot3, slot4[slot5].row, slot4[slot5].column)

			return
		end
	end

	master.contextData.inPort = false

	if master.contextData.inPort and checkExist(slot2, {
		"GetPort"
	}, {
		"IsOpen",
		{
			nowWorld:GetRealm(),
			nowWorld:GetProgress()
		}
	}) then
		slot0:Op("OpReqEnterPort")

		return
	end

	master:CheckGuideSLG(slot2, slot3)
end

slot0.OpLongMoveFleet = function (slot0, slot1, slot2, slot3)
	slot0:OpDone()

	slot4 = nowWorld:GetActiveMap()

	if nowWorld:CheckFleetMovable() then
		slot5 = {
			row = slot1.row,
			column = slot1.column
		}
		slot6 = {
			row = slot2,
			column = slot3
		}
		slot10, slot8 = slot4:GetLongMoveRange(slot1)

		if not _.any(slot7, function (slot0)
			return slot0.row == slot0.row and slot0.column == slot0.column
		end) then
			pg.TipsMgr.GetInstance().ShowTips(slot10, i18n("destination_not_in_range"))
		else
			slot11 = 0
			slot12 = nil

			function slot12(slot0, slot1)
				if slot0.last[slot1] then
					slot0(slot0.last[slot1][1], slot0.last[slot1][2])
					slot2(table.insert, {
						row = slot0.row,
						column = slot0.column,
						step = slot1 + 1,
						stay = slot1 + 1 == 0
					})
				end
			end

			slot12(slot8[slot6.row][slot6.column], 0)
			master:SetMoveQueue(slot10)
			master:DoQueueMove(slot1)
		end
	end
end

slot0.OpReqMoveFleet = function (slot0, slot1, slot2, slot3)
	slot4 = nowWorld:GetActiveMap()
	slot5 = false

	if nowWorld:CheckFleetMovable() then
		slot6 = {
			row = slot1.row,
			column = slot1.column
		}
		slot8 = nil

		if slot4:IsSign(({
			row = slot2,
			column = slot3
		})["row"], ()["column"]) then
			slot9, slot10 = slot4:FindPath(slot6, slot7)

			if slot9 < PathFinding.PrioObstacle then
				slot8 = slot7
				slot7 = slot10[#slot10 - 1]
			end
		end

		slot10 = _.detect(slot9, function (slot0)
			return slot0.row == slot0.row and slot0.column == slot0.column
		end)
		slot11 = nil

		if #slot1.GetBuffsByTrap(slot1, WorldBuff.TrapVortex) > 0 then
			slot13 = math.random() * 100

			if underscore.all(slot12, function (slot0)
				return slot0 < slot0:GetTrapParams()[1]
			end) then
				slot7.column = slot1.column
				slot7.row = slot1.row
				slot11 = WorldBuff.TrapVortex
			end
		end

		if not slot10 then
			pg.TipsMgr.GetInstance().ShowTips(slot14, i18n((slot11 and "world_fleet_in_vortex") or "destination_not_in_range"))
		else
			slot13, slot14 = slot4:FindPath(slot6, slot7)

			if slot13 < PathFinding.PrioObstacle then
				master:emit(WorldMediator.OnMapOp, master:NewMapOp({
					op = WorldConst.OpReqMoveFleet,
					id = slot1.id,
					arg1 = slot7.row,
					arg2 = slot7.column,
					sign = slot8,
					trap = slot11
				}))

				slot5 = true
			elseif slot13 < PathFinding.PrioForbidden then
				pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach_safety"))
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("destination_can_not_reach"))
			end
		end
	end

	if not slot5 then
		master:ClearMoveQueue()
		slot0:OpDone()
	end
end

slot0.OpReqMoveFleetDone = function (slot0, slot1)
	slot5 = master.wsMap.map.GetFleet(slot4)

	table.insert(slot2, function (slot0)
		slot0:UpdateRangeVisible(false)

		if slot0.UpdateRangeVisible.row ~= slot0.arg1 or slot1.column ~= slot2.arg2 then
			slot0:DisplayTargetArrow(slot2.arg1, slot2.arg2)
		end

		slot3:Op("OpActions", slot2.childOps, slot0)
	end)
	table.insert(slot2, function (slot0)
		master:CheckMoveQueue(slot0.path)
		slot0()
	end)

	if slot1.sign then
		table.insert(slot2, function (slot0)
			master:ClearMoveQueue()

			if slot0.row == slot1.arg1 and slot0.column == slot1.arg2 then
				slot1.sign.row:Op("OpTriggerSign", slot0, slot2:GetCell(slot1.sign.row, slot1.sign.column).GetEventAttachment(slot1), slot0)
			else
				slot0()
			end
		end)
	end

	seriesAsync(slot2, function ()
		slot0:HideTargetArrow()
		slot0:Apply()
		slot2:Op("OpInteractive")
	end)
end

slot0.OpMoveFleet = function (slot0, slot1, slot2)
	slot2 = master:DoTopBlock(slot2)
	slot8 = master.wsMap:MovePath(master.wsMap.GetFleet(slot3, slot4), slot1.path, slot1.pos, WorldConst.DirType2, master.wsMap.map:GetCell(master.wsMap.GetFleet(slot3, slot4).fleet.row, master.wsMap.GetFleet(slot3, slot4).fleet.column).GetTerrain(slot7) == WorldMapCell.TerrainWind)

	function slot9(slot0, slot1)
		slot3 = {}

		if #slot0.stepOps[slot0].hiddenAttachments > 0 then
			table.insert(slot3, function (slot0)
				if slot0 < #slot1.stepOps then
					slot2:UpdatePaused(true)
				end

				master:DoAnim(WorldConst.AnimRadar, function ()
					if slot0 < #slot1.stepOps then
						slot2:UpdatePaused(false)
					end

					slot3()
				end)
			end)
		end

		seriesAsync(slot3, function ()
			slot0:Apply()

			return existCall(slot0)
		end)
	end

	function slot10(slot0)
		master.wsDragProxy:Focus(slot1:GetCell(slot0.path[slot0 + 1].row, slot0.path[slot0 + 1].column).transform.position, slot0.path[slot0 + 1].duration, LeanTweenType.linear)
	end

	slot10(slot1.path)
	slot8.AddListener(slot8, WSMapPath.EventArrivedStep, slot1.pos)
	slot8:AddListener(WSMapPath.EventArrived, nil)

	for slot17, slot18 in ipairs(slot6:GetCarries()) do
		slot3:GetCarryItem(slot18):FollowPath(slot6:BuildCarryPath(slot18, slot1.pos, slot1.path))
	end

	master.wsMapRight:UpdateCompassRotation(slot1.path[1])
end

slot0.OpMoveAttachment = function (slot0, slot1, slot2)
	slot2 = master:DoTopBlock(slot2)
	slot4 = master.wsMap.map

	master.wsMap.FlushMovingAttachment(slot3, slot6)

	slot7 = 0
	slot8 = master.wsMap.MovePath(slot3, slot6, slot1.path, slot1.pos, slot1.attachment.GetDirType(slot5))
	slot10 = nil

	slot8.AddListener(slot8, WSMapPath.EventArrivedStep, slot9)
	slot8:AddListener(WSMapPath.EventArrived, function ()
		slot0:RemoveListener(WSMapPath.EventArrivedStep, slot0)
		slot0.RemoveListener:RemoveListener(WSMapPath.EventArrived, )
		slot3:OpDone()
		slot4()
	end)
end

slot0.OpReqRound = function (slot0)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqRound
	}))
end

slot0.OpReqRoundDone = function (slot0, slot1)
	slot0:Op("OpActions", slot1.childOps, function ()
		slot0:Apply()
		slot0:Op("OpInteractive", true)
	end)
end

slot0.OpActions = function (slot0, slot1, slot2)
	slot0:OpDone()

	slot3 = _.map(slot1 or {}, function (slot0)
		return function (slot0)
			slot0:Op("OpAction", slot0.Op, slot0)
		end
	end)

	seriesAsync(slot3, slot2)
end

slot0.OpAction = function (slot0, slot1, slot2)
	slot0:OpDone()

	slot3 = {}

	if slot1.childOps then
		table.insert(slot3, function (slot0)
			slot0:Op("OpActions", slot1.childOps, slot0)
		end)
	end

	if slot1.op == WorldConst.OpActionUpdate then
		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	elseif slot1.op == WorldConst.OpActionFleetMove then
		table.insert(slot3, function (slot0)
			slot0:Op("OpMoveFleet", slot0.Op, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot1.op == WorldConst.OpActionAttachmentMove then
		table.insert(slot3, function (slot0)
			slot0:Op("OpMoveAttachment", slot0.Op, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot1.op == WorldConst.OpActionAttachmentAnim then
		table.insert(slot3, function (slot0)
			slot0:Op("OpAttachmentAnim", slot0.Op, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot1.op == WorldConst.OpActionFleetAnim then
		table.insert(slot3, function (slot0)
			slot0:Op("OpFleetAnim", slot0.Op, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot1.op == WorldConst.OpActionEventEffect then
		table.insert(slot3, function (slot0)
			slot0:Op("OpTriggerEvent", slot0.Op, slot0)
		end)
	elseif slot1.op == WorldConst.OpActionCameraMove then
		table.insert(slot3, function (slot0)
			slot0:Op("OpMoveCameraTarget", slot1.attachment, 0.1, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot1.op == WorldConst.OpActionTrapGravityAnim then
		table.insert(slot3, function (slot0)
			slot0:Op("OpTrapGravityAnim", slot1.attachment, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	end

	seriesAsync(slot3, slot2)
end

slot0.OpEvent = function (slot0, slot1, slot2)
	slot0:OpDone()

	slot3, slot4 = nil
	slot7 = slot2:GetEventEffect().effect_paramater
	slot8 = {}

	if slot2.GetEventEffect().effect_type == WorldMapAttachment.EffectEventStoryOption then
		slot9 = slot7[1]

		if slot5.autoflag[1] and WorldConst.CheckWorldStorySkip(slot9) then
			table.insert(slot8, function (slot0)
				slot0(slot0)
			end)
		elseif slot10 and nowWorld.isAutoFight then
			table.insert(slot8, function (slot0)
				slot0:Op("OpAutoStory", slot0.Op, {
					slot2
				}, true, slot0)
			end)
		else
			table.insert(slot8, function (slot0)
				slot0:Op("OpStory", slot0.Op, true, slot0)
			end)
		end

		table.insert(slot8, function (slot0, slot1)
			if underscore.detect(slot0[2], function (slot0)
				return slot0[1] == slot0
			end) then
				slot1 = slot2[2]

				slot0()
			else
				slot2.triggered = true

				slot2:Op("OpInteractive")
			end
		end)
	elseif slot6 == WorldMapAttachment.EffectEventConsumeItem then
		if nowWorld.isAutoFight then
		else
			table.insert(slot8, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("sub_item_warning"),
					items = {
						{
							type = DROP_TYPE_WORLD_ITEM,
							id = slot0[1],
							count = slot0[2]
						}
					},
					onYes = slot0,
					onNo = function ()
						slot0.triggered = true

						true:Op("OpInteractive")
					end
				})
			end)
		end

		table.insert(slot8, function (slot0)
			if nowWorld:GetInventoryProxy():GetItemCount(slot0[1]) < slot0[2] then
				nowWorld:TriggerAutoFight(false)

				nowWorld.TriggerAutoFight.triggered = true

				true:Op("OpStory", slot0[3], true, function ()
					slot0:Op("OpInteractive")
				end)
			else
				slot0()
			end
		end)
	elseif slot6 == WorldMapAttachment.EffectEventGuide then
		table.insert(slot8, function (slot0)
			if slot0:IsGuideFinish() then
				slot0()
			else
				nowWorld:TriggerAutoFight(false)
				nowWorld.TriggerAutoFight:Op("OpGuide", slot2[1], slot2[2], function ()
					slot0.markGuider = slot0.data

					if slot0.data:IsBind() then
						slot1:Op("OpInteractive")
					end
				end)
			end
		end)
	elseif slot6 == WorldMapAttachment.EffectEventConsumeCarry then
		slot9 = slot5.effect_paramater[1] or {}

		if _.any(slot9, function (slot0)
			return not slot0:ExistCarry(slot0)
		end) then
			slot2.triggered = true

			nowWorld.TriggerAutoFight(slot10, false)

			if slot5.effect_paramater[2] then
				table.insert(slot8, function (slot0)
					slot0:Op("OpStory", slot0.Op, true, slot0)
				end)
			end

			table.insert(slot8, function (slot0)
				slot0:Op("OpInteractive")
			end)
		end
	elseif slot6 == WorldMapAttachment.EffectEventCatSalvage then
		if slot1.GetDisplayCommander(slot1) and not slot1:IsCatSalvage() then
			if not nowWorld.isAutoFight then
				table.insert(slot8, function (slot0)
					slot0:Op("OpStory", slot1[1], true, function (slot0)
						if slot0 == slot0[2] then
							slot1()
						else
							slot2.triggered = true

							slot3:Op("OpInteractive")
						end
					end)
				end)
			end
		else
			slot2.triggered = true

			if not nowWorld.isAutoFight then
				slot9 = pg.gameset.world_catsearch_failure.description[1]

				table.insert(slot8, function (slot0)
					slot0:Op("OpStory", slot0.Op, true, slot0)
				end)
			end

			table.insert(slot8, function (slot0)
				slot0:Op("OpInteractive")
			end)
		end
	elseif slot6 == WorldMapAttachment.EffectEventMsgbox then
		table.insert(slot8, function (slot0)
			nowWorld:TriggerAutoFight(false)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n(slot0[1]),
				onYes = slot0,
				onNo = (slot0[1] == 0 and slot0) or function ()
					slot0.triggered = true

					true:Op("OpInteractive")
				end,
				hideNo = slot0[1] == 0
			})
		end)
	end

	seriesAsync(slot8, function ()
		slot5:Op("OpReqEvent", master:NewMapOp({
			op = WorldConst.OpReqEvent,
			id = slot0.id,
			arg1 = slot1,
			arg2 = slot2,
			attachment = slot2,
			effect = slot4,
			locations = {
				{
					row = slot3.row,
					column = slot3.column
				}
			}
		}))
	end)
end

slot0.OpReqEvent = function (slot0, slot1)
	master:emit(WorldMediator.OnMapOp, slot1)
end

slot0.OpReqEventDone = function (slot0, slot1)
	slot0:Op("OpTriggerEvent", slot1, function ()
		slot0:Op("OpInteractive", true)
	end)
end

slot0.OpEventOp = function (slot0, slot1)
	slot0:OpDone()
	slot0:Op("OpTriggerEvent", master:NewMapOp({
		op = WorldConst.OpActionEventOp,
		attachment = slot1,
		effect = slot1:GetOpEffect()
	}), function ()
		slot0:Op("OpInteractive")
	end)
end

slot0.OpTriggerEvent = function (slot0, slot1, slot2)
	slot0:OpDone()

	slot3 = {}
	slot6 = slot1.effect.effect_paramater

	if slot1.effect.effect_type == WorldMapAttachment.EffectEventStory then
		slot7 = getProxy(WorldProxy)

		if WorldConst.CheckWorldStorySkip(slot6[1]) then
			table.insert(slot3, function (slot0)
				master:ReContinueMoveQueue()
				slot0()
			end)
		elseif nowWorld.isAutoFight then
			table.insert(slot3, function (slot0)
				slot0:Op("OpAutoStory", slot0.Op, {}, true, slot0)
			end)
		else
			table.insert(slot3, function (slot0)
				slot0:Op("OpStory", slot0.Op, true, slot0)
			end)
		end

		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventTeleport or slot5 == WorldMapAttachment.EffectEventTeleportBack then
		slot7 = slot1.attachment
		slot8 = nowWorld.GetMap(slot8, slot1.destMapId)

		if slot1.effect.effect_paramater[1][#slot1.effect.effect_paramater[1]] == 1 then
			table.insert(slot3, function (slot0)
				master:ShowTransportMarkOverall({
					ids = {
						slot0.entranceId
					}
				}, slot0)
			end)
		end

		if master.GetInMap(slot10) and slot7.config.icon == "chuansong01" then
			table.insert(slot3, function (slot0)
				slot0:Op("OpAttachmentAnim", master:NewMapOp({
					anim = "chuansong_open",
					attachment = slot0.Op
				}), slot0)
			end)
		end

		table.insert(slot3, function (slot0)
			slot0:Op("OpSwitchMap", slot0.Op, slot0)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventShowMapMark then
		if nowWorld.isAutoFight then
		else
			table.insert(slot3, function (slot0)
				slot0:Op("OpShowMarkOverall", {
					ids = slot1
				}, slot0)
			end)
		end

		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventCameraMove then
		table.insert(slot3, function (slot0)
			slot0:Op("OpMoveCamera", slot1[1], slot1[2], function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventShakePlane then
		table.insert(slot3, function (slot0)
			slot0:Op("OpShakePlane", slot1[1], slot1[2], slot1[3], slot1[4], function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventBlink1 or slot5 == WorldMapAttachment.EffectEventBlink2 then
		table.insert(slot3, function (slot0)
			nowWorld:TriggerAutoFight(false)
			slot0:Op("OpActions", slot1.childOps, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventFlash then
		table.insert(slot3, function (slot0)
			slot1:Op("OpFlash", slot0[1], slot0[2], slot0[3], Color.New(slot0[4][1] / 255, slot0[4][2] / 255, slot0[4][3] / 255, slot0[4][4] / 255), function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventShipBuff then
		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventHelp then
		if nowWorld.isAutoFight then
		else
			table.insert(slot3, function (slot0)
				WorldConst.BuildHelpTips(nowWorld:GetProgress()).defaultpage = slot0[1]

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_HELP,
					helps = WorldConst.BuildHelpTips(nowWorld.GetProgress()),
					weight = LayerWeightConst.SECOND_LAYER,
					onClose = slot0
				})
			end)
		end

		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventProgress then
		table.insert(slot3, function (slot0)
			slot0:Op("OpActions", slot1.childOps, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventReturn2World then
		table.insert(slot3, function (slot0)
			nowWorld:TriggerAutoFight(false)
			slot0:Op("OpSetInMap", false, function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventShowPort then
		table.insert(slot3, function (slot0)
			slot0:Apply()
			nowWorld:TriggerAutoFight(false)
			master:OpenPortLayer({
				page = slot1[1]
			})
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventGlobalBuff then
		slot7 = {
			id = slot6[1],
			floor = slot6[2],
			before = nowWorld.GetGlobalBuff(slot8, slot6[1]):GetFloor()
		}

		if nowWorld.isAutoFight then
			nowWorld:AddAutoInfo("buffs", slot7)
		else
			table.insert(slot3, function (slot0)
				master:ShowSubView("GlobalBuff", {
					slot0,
					slot0
				})
			end)
		end

		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventSound then
		table.insert(slot3, function (slot0)
			slot0:Op("OpPlaySound", slot1[1], function ()
				slot0:Apply()
				slot0()
			end)
		end)
	elseif slot5 == WorldMapAttachment.EffectEventHelpLayer then
		table.insert(slot3, function (slot0)
			nowWorld:TriggerAutoFight(false)
			slot0:Apply()
			slot0.Apply:Op("OpOpenLayer", Context.New({
				mediator = WorldHelpMediator,
				viewComponent = WorldHelpLayer,
				data = {
					titleId = slot2[1],
					pageId = slot2[2]
				},
				onRemoved = slot0
			}))
		end)
	elseif slot5 == WorldMapAttachment.EffectEventFleetShipHP then
		table.insert(slot3, function (slot0)
			slot0:Apply()

			if slot0.Apply[1] > 0 then
				slot2:Op("OpShowAllFleetHealth", slot0)
			else
				slot0()
			end
		end)
	elseif slot5 == WorldMapAttachment.EffectEventCatSalvage then
		table.insert(slot3, function (slot0)
			slot0:Apply()
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_catsearch_success"))
			slot0()
		end)
	elseif slot5 == WorldMapAttachment.EffectEventTeleportEvent then
		table.insert(slot3, function (slot0)
			slot0:Apply()
			master.wsDragProxy:Focus(master.wsMap:GetFleet().transform.position, nil, LeanTweenType.easeInOutSine, slot0)
		end)
	else
		table.insert(slot3, function (slot0)
			slot0:Apply()
			slot0()
		end)
	end

	seriesAsync(slot3, slot2)
end

slot0.OpReqRetreat = function (slot0, slot1)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqRetreat,
		id = slot1.id,
		attachment = nowWorld:GetActiveMap().GetCell(slot2, slot1.row, slot1.column).GetAliveAttachment(slot3)
	}))
end

slot0.OpReqRetreatDone = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		slot0:Op("OpActions", slot1.childOps, slot0)
	end)
	seriesAsync(slot2, function ()
		slot0:Apply()
		slot0:Op("OpInteractive")
	end)
end

slot0.OpTransport = function (slot0, slot1, slot2)
	slot0:OpDone()

	slot3 = nowWorld:GetActiveMap()

	if not nowWorld:IsSystemOpen(WorldConst.SystemOutMap) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_systemClose"))
	elseif not slot2:IsMapOpen() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_map_not_open"))
	else
		slot0:Op("OpReqTransport", slot3:GetFleet(), slot1, slot2)
	end
end

slot0.OpReqTransport = function (slot0, slot1, slot2, slot3)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqTransport,
		id = slot1.id,
		arg1 = slot3.id,
		arg2 = slot2.id,
		locations = {
			slot3:CalcTransportPos(nowWorld:GetActiveEntrance(), slot2)
		}
	}))
end

slot0.OpReqTransportDone = function (slot0, slot1)
	seriesAsync({}, function ()
		slot0:Op("OpSwitchMap", slot0)
	end)
end

slot0.OpReqSub = function (slot0, slot1)
	master.subCallback = slot1

	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqSub,
		id = nowWorld:GetSubmarineFleet().id
	}))
end

slot0.OpReqSubDone = function (slot0, slot1)
	nowWorld.staminaMgr:ConsumeStamina(slot2)
	nowWorld:SetReqCDTime(WorldConst.OpReqSub, pg.TimeMgr.GetInstance():GetServerTime())
	master:DoStrikeAnim("SubTorpedoUI", nowWorld:GetSubmarineFleet():GetFlagShipVO(), function ()
		slot0:Apply()

		if master.subCallback then
			master.subCallback = nil

			master.subCallback()
		end
	end)
end

slot0.OpReqJumpOut = function (slot0, slot1)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = pg.world_chapter_template_reset[slot1].tip,
		onYes = function ()
			master:emit(WorldMediator.OnMapOp, master:NewMapOp({
				op = WorldConst.OpReqJumpOut
			}))
		end,
		onNo = function ()
			slot0:OpDone()
		end
	})
end

slot0.OpReqJumpOutDone = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		master:ShowTransportMarkOverall({
			ids = {
				slot0.entranceId
			}
		}, slot0)
	end)
	seriesAsync(slot2, function ()
		slot0:Op("OpSwitchMap", slot0)
	end)
end

slot0.OpReqSwitchFleet = function (slot0, slot1)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqSwitchFleet,
		id = slot1.id
	}))
end

slot0.OpReqSwitchFleetDone = function (slot0, slot1)
	nowWorld:GetActiveMap():UpdateFleetIndex(slot2)
	master.wsMap:UpdateRangeVisible(false)
	slot0:Op("OpInteractive")
end

slot0.OpStory = function (slot0, slot1, slot2, slot3)
	pg.NewStoryMgr.GetInstance():Play(slot1, function (slot0, slot1)
		slot0:OpDone()
		existCall(slot1, slot1)
	end, slot2)
end

slot0.OpAutoStory = function (slot0, slot1, slot2, slot3, slot4)
	pg.NewStoryMgr.GetInstance():AutoPlay(slot1, slot2, function (slot0, slot1)
		slot0:OpDone()
		existCall(slot1, slot1)
	end, slot3)
end

slot0.OpTriggerSign = function (slot0, slot1, slot2, slot3)
	slot0:OpDone()

	if slot2:IsAvatar() then
		slot4 = master.wsMap:GetAttachment(slot2.row, slot2.column, slot2.type)

		if slot2.column ~= master.wsMap:GetFleet().fleet.column then
			slot6 = slot4:GetModelAngles()
			slot6.y = (slot2.column >= slot5.fleet.column or 0) and 180

			slot4:UpdateModelAngles(slot6)

			slot5:GetModelAngles().y = 180 - slot6.y

			slot5:UpdateModelAngles(slot5.GetModelAngles())
		end
	end

	slot4 = {}

	_.each(slot5, function (slot0)
		slot2 = slot0.effect_paramater

		if slot0.effect_type == WorldMapAttachment.EffectEventStoryOptionClient then
			slot3 = slot2[1]

			if slot0.autoflag[1] and WorldConst.CheckWorldStorySkip(slot3) then
				table.insert(slot0, function (slot0)
					slot0(slot0)
				end)
			elseif slot4 and nowWorld.isAutoFight then
				table.insert(slot0, function (slot0)
					slot0:Op("OpAutoStory", slot0.Op, {
						slot2
					}, true, slot0)
				end)
			else
				table.insert(slot0, function (slot0)
					slot0:Op("OpStory", slot0.Op, true, slot0)
				end)
			end

			table.insert(slot0, function (slot0, slot1)
				if _.detect(slot0[2], function (slot0)
					return slot0[1] == slot0
				end) then
					if slot2[2] > 0 then
						slot1.Op(slot3, "OpTriggerEvent", master:NewMapOp({
							attachment = slot2,
							effect = pg.world_effect_data[slot2[2]]
						}), slot0)
					else
						slot0()
					end
				else
					slot1:Op("OpInteractive")
				end
			end)

			return
		end

		table.insert(slot0, function (slot0)
			slot0:Op("OpTriggerEvent", master:NewMapOp({
				attachment = slot1,
				effect = slot0
			}), slot0)
		end)
	end)
	seriesAsync(slot4, slot3)
end

slot0.OpShowMarkOverall = function (slot0, slot1, slot2)
	master:LoadAtlasOverall(function ()
		master:ShowSubView("MarkOverall", {
			slot0,
			function ()
				slot0:OpDone()

				return existCall(slot0)
			end
		})
	end)
end

slot0.OpShowTresureMap = function (slot0, slot1)
	slot0:OpDone()
	master:QueryTransport(function ()
		slot1 = nil

		for slot5, slot6 in ipairs(nowWorld:FindTreasureEntrance(nowWorld.FindTreasureEntrance).config.teasure_chapter) do
			if slot0 == slot6[1] then
				slot1 = slot6[2]

				break
			end
		end

		master.atlasDisplayInfo = {
			entrance = slot0,
			mapId = slot1
		}

		master:EnterTransportWorld()
	end)
end

slot0.OpShowOrderPanel = function (slot0)
	slot0:OpDone()
	master:ShowSubView("OrderPanel", {
		nowWorld:GetActiveEntrance(),
		nowWorld:GetActiveMap(),
		master.wsMapRight.wsCompass:GetAnchorEulerAngles()
	})
end

slot0.OpShowScannerPanel = function (slot0, slot1, slot2)
	slot0:OpDone()
	master:ShowSubView("ScannerPanel", {
		nowWorld:GetActiveMap(),
		master.wsDragProxy
	}, {
		slot1,
		slot2
	})
end

slot0.OpMoveCamera = function (slot0, slot1, slot2, slot3)
	slot3 = master:DoTopBlock(slot3)
	slot4 = {}

	if slot1 > 0 then
		for slot9, slot10 in ipairs(slot5) do
			table.insert(slot4, {
				focusPos = function ()
					return master.wsMap:GetAttachment(slot0.row, slot0.column, slot0.type).transform.position
				end,
				row = slot10.row,
				column = slot10.column
			})
		end
	else
		table.insert(slot4, {
			focusPos = function ()
				return slot0.transform.position
			end,
			row = master.wsMap.GetFleet(slot5).fleet.row,
			column = master.wsMap.GetFleet(slot5).fleet.column
		})
	end

	slot5 = {}

	for slot9, slot10 in ipairs(slot4) do
		table.insert(slot5, function (slot0)
			master.wsMapRight:UpdateCompossView(slot0.row, slot0.column)
			slot0()
		end)
		table.insert(slot5, function (slot0)
			master.wsDragProxy:Focus(slot0.focusPos(), nil, LeanTweenType.easeInOutSine, slot0)
		end)
		table.insert(slot5, function (slot0)
			master.wsTimer:AddInMapTimer(slot0, slot0, 1):Start()
		end)
	end

	seriesAsync(slot5, function ()
		slot0:OpDone()

		return existCall(slot0)
	end)
end

slot0.OpMoveCameraTarget = function (slot0, slot1, slot2, slot3)
	slot3 = master:DoTopBlock(slot3)
	slot1 = slot1 or {
		row = master.wsMap:GetFleet().fleet.row,
		column = master.wsMap.GetFleet().fleet.column
	}

	table.insert(slot4, function (slot0)
		master.wsMapRight:UpdateCompossView(slot0.row, slot0.column)
		slot0()
	end)
	table.insert(slot4, function (slot0)
		master.wsDragProxy:Focus(master.wsMap:GetCell(slot0.row, slot0.column).transform.position, nil, LeanTweenType.easeInOutSine, slot0)
	end)
	table.insert(slot4, function (slot0)
		master.wsTimer:AddInMapTimer(slot0, slot0, 1):Start()
	end)
	seriesAsync(slot4, function ()
		slot0:OpDone()

		return existCall(slot0)
	end)
end

slot0.OpShakePlane = function (slot0, slot1, slot2, slot3, slot4, slot5)
	master.wsDragProxy:ShakePlane(slot1, slot2, slot3, slot4, function ()
		slot0:OpDone()

		if slot0 then
			slot1()
		end
	end)
end

slot0.OpAttachmentAnim = function (slot0, slot1, slot2)
	slot4 = master.wsMap:GetAttachment(slot1.attachment.row, slot1.attachment.column, slot1.attachment.type)

	seriesAsync({
		function (slot0)
			slot0:PlayModelAction(slot1.anim, slot1.duration, slot0)
		end
	}, function ()
		slot0:FlushModelAction()
		slot0:OpDone()
		slot2()
	end)
end

slot0.OpFleetAnim = function (slot0, slot1, slot2)
	slot4 = master.wsMap:GetFleet(slot3)

	seriesAsync({
		function (slot0)
			slot0:PlayModelAction(slot1.anim, slot1.duration, slot0)
		end
	}, function ()
		slot0:FlushModelAction()
		slot0:OpDone()
		slot2()
	end)
end

slot0.OpFlash = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = master.rtTop:Find("flash")

	setActive(slot6, true)
	setImageColor(slot6, slot4)
	setImageAlpha(slot6, 0)
	master.wsTimer:AddInMapTween(LeanTween.alpha(slot6, slot4.a, slot1).uniqueId)
	master.wsTimer:AddInMapTween(LeanTween.alpha(slot6, 0, slot3):setDelay(slot1 + slot2):setOnComplete(System.Action(function ()
		setActive(setActive, false)
		setActive:OpDone()
		false()
	end)).uniqueId)
end

slot0.OpReqBox = function (slot0, slot1, slot2)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqBox,
		id = slot1.id,
		attachment = slot2
	}))
end

slot0.OpReqBoxDone = function (slot0, slot1)
	slot1:Apply()
	slot0:Op("OpInteractive")
end

slot0.OpSetInMap = function (slot0, slot1, slot2)
	table.insert({}, (slot1 and function (slot0)
		master:LoadMap(nowWorld:GetActiveMap(), slot0)
	end) or function (slot0)
		master:LoadAtlas(slot0)
	end)
	seriesAsync(slot3, function ()
		slot0:OpDone()
		master:SetInMap(master, )
	end)
end

slot0.OpSwitchInMap = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		master:DisplayEnv()
		master:DisplayMap()
		master:DisplayMapUI()
		master:UpdateMapUI()

		return slot0()
	end)
	table.insert(slot2, function (slot0)
		master:EaseInMapUI(slot0)
	end)
	seriesAsync(slot2, function ()
		slot0:OpDone()

		if slot0 then
			slot1()
		end
	end)
end

slot0.OpSwitchOutMap = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		master:EaseOutMapUI(slot0)
	end)
	table.insert(slot2, function (slot0)
		master:HideMap()
		master:HideMapUI()

		return slot0()
	end)
	seriesAsync(slot2, function ()
		slot0:OpDone()

		return existCall(slot0)
	end)
end

slot0.OpSwitchInWorld = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		master:DisplayEnv()
		master:DisplayAtlas()
		master:DisplayAtlasUI()

		return slot0()
	end)
	table.insert(slot2, function (slot0)
		master:EaseInAtlasUI(slot0)
	end)
	seriesAsync(slot2, function ()
		slot0:OpDone()

		return existCall(slot0)
	end)
end

slot0.OpSwitchOutWorld = function (slot0, slot1)
	table.insert(slot2, function (slot0)
		master:EaseOutAtlasUI(slot0)
	end)
	table.insert(slot2, function (slot0)
		master:HideAtlas()
		master:HideAtlasUI()

		return slot0()
	end)
	seriesAsync(slot2, function ()
		slot0:OpDone()

		return existCall(slot0)
	end)
end

slot0.OpRedeploy = function (slot0)
	slot0:OpDone()

	if underscore.any(nowWorld:GetActiveMap().GetNormalFleets(slot1), function (slot0)
		return #slot0:GetCarries() > 0
	end) then
		pg.TipsMgr.GetInstance().ShowTips(slot2, i18n("world_instruction_redeploy_3"))

		return
	end

	if slot1:CheckFleetSalvage(true) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_catsearch_fleetcheck"),
			onYes = function ()
				slot0.salvageAutoResult = true

				true:Op("OpInteractive")
			end
		})
	else
		slot8.type, slot8.fleets = nowWorld.BuildFormationIds(slot2)

		slot0:Op("OpOpenScene", SCENE.WORLD_FLEET_SELECT, {
			type = slot2,
			fleets = slot3
		})
	end
end

slot0.OpKillWorld = function (slot0)
	getProxy(ContextProxy):getContextByMediator(WorldMediator).onRemoved = function ()
		pg.m02:sendNotification(GAME.WORLD_KILL)
	end

	master.ExitWorld(slot2, function ()
		slot0:OpDone()
	end, true)
end

slot0.OpReqMaintenance = function (slot0, slot1)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqMaintenance,
		id = slot1
	}))
end

slot0.OpReqMaintenanceDone = function (slot0, slot1)
	slot1:Apply()
	_.each(slot2, function (slot0)
		slot0:ClearDamageLevel()

		for slot4, slot5 in ipairs(slot0:GetShips(true)) do
			slot5:Repair()
		end
	end)
	nowWorld.staminaMgr:ConsumeStamina(slot3)
	nowWorld:SetReqCDTime(WorldConst.OpReqMaintenance, pg.TimeMgr.GetInstance():GetServerTime())
	master.wsMap:UpdateRangeVisible(false)
	slot0:Op("OpShowAllFleetHealth", function ()
		slot0:Op("OpInteractive")
	end)
end

slot0.OpReqVision = function (slot0)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqVision
	}))
end

slot0.OpReqVisionDone = function (slot0, slot1)
	slot1:Apply()
	nowWorld.staminaMgr:ConsumeStamina(slot2)
	nowWorld:SetReqCDTime(WorldConst.OpReqVision, pg.TimeMgr.GetInstance():GetServerTime())
	nowWorld:GetActiveMap():UpdateVisionFlag(true)
	master.wsMap:UpdateRangeVisible(false)
	slot0:Op("OpInteractive")
end

slot0.OpReqPressingMap = function (slot0)
	slot1 = nowWorld:GetActiveMap()

	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqPressingMap,
		id = slot1:GetFleet().id,
		arg1 = slot1.id
	}))
end

slot0.OpReqPressingMapDone = function (slot0, slot1, slot2)
	slot3 = slot2

	if nowWorld:GetMap(slot1.arg1):CheckMapPressingDisplay() then
		table.insert(slot3, 1, function (slot0)
			master:BuildCutInAnim("WorldPressingWindow", slot0)
		end)
	end

	if nowWorld.GetPressingAward(slot5, slot4) and slot5.flag then
		if #pg.world_event_complete[slot5.id].event_reward_slgbuff > 1 then
			slot8 = {
				id = slot7[1],
				floor = slot7[2],
				before = nowWorld:GetGlobalBuff(slot7[1]):GetFloor()
			}

			if nowWorld.isAutoFight then
				nowWorld:AddAutoInfo("buffs", slot8)
			else
				table.insert(slot3, function (slot0)
					master:ShowSubView("GlobalBuff", {
						slot0,
						slot0
					})
				end)
			end

			table.insert(slot3, function (slot0)
				nowWorld:AddGlobalBuff(slot0[1], slot0[2])
				slot0()
			end)
		end
	end

	seriesAsync(slot3, function ()
		slot0:Apply()
		master.wsMap:UpdateRangeVisible(false)
		master.wsMap:Op("OpInteractive")
	end)
end

slot0.OpReqEnterPort = function (slot0)
	if nowWorld:GetActiveMap():GetPort():IsOpen(nowWorld:GetRealm(), nowWorld:GetProgress()) then
		master:emit(WorldMediator.OnMapOp, master:NewMapOp({
			op = WorldConst.OpReqEnterPort
		}))
	else
		pg.TipsMgr.GetInstance():ShowTips("port is not open: " .. slot1.id)
	end
end

slot0.OpReqEnterPortDone = function (slot0, slot1)
	slot1:Apply()
	master:OpenPortLayer()
end

slot0.OpReqCatSalvage = function (slot0, slot1)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqCatSalvage,
		id = slot1 or nowWorld:GetActiveMap():CheckFleetSalvage()
	}))
end

slot0.OpReqCatSalvageDone = function (slot0, slot1, slot2)
	slot3 = slot2

	if nowWorld.isAutoFight then
	else
		table.insert(slot3, 1, function (slot0)
			pg.NewStoryMgr.GetInstance():Play(pg.gameset.world_catsearch_completed.description[(nowWorld:GetFleet(slot0.id):GetRarityState() > 0 and 2) or 1], slot0, true)
		end)
	end

	seriesAsync(slot3, function ()
		slot0:Apply()
		slot0:Op("OpInteractive")
	end)
end

slot0.OpReqSkipBattle = function (slot0, slot1)
	master:emit(WorldMediator.OnMapOp, master:NewMapOp({
		op = WorldConst.OpReqSkipBattle,
		id = slot1
	}))
end

slot0.OpReqSkipBattleDone = function (slot0, slot1)
	slot1:Apply()
	slot0:Op("OpInteractive")
end

slot0.OpPlaySound = function (slot0, slot1, slot2)
	master:PlaySound(slot1, slot2)
end

slot0.OpGuide = function (slot0, slot1, slot2, slot3)
	slot0:OpDone()
	nowWorld:TriggerAutoFight(false)

	slot4 = WorldGuider.GetInstance()

	slot4:PlayGuide(slot4:SpecialCheck(slot1), (slot2 == 1 and true) or false, slot3)
end

slot0.OpTaskGoto = function (slot0, slot1)
	slot0:OpDone()

	if nowWorld:GetTaskProxy():getTaskById(slot1):GetFollowingAreaId() then
		slot0:Op("OpShowMarkOverall", {
			mode = "Task",
			taskId = slot1
		})
	elseif nowWorld:GetActiveEntrance().id ~= slot2:GetFollowingEntrance() then
		master:QueryTransport(function ()
			master:QueryTransport(function ()
				master.atlasDisplayInfo = {
					entrance = nowWorld:GetEntrance(slot0:GetFollowingEntrance()),
					mapTypes = {
						"complete_chapter",
						"base_chapter"
					}
				}

				master:EnterTransportWorld()
			end)
		end)
	else
		slot3 = slot2.config.task_goto
		slot5 = nowWorld.GetActiveMap(slot5)

		if #slot2.config.following_random > 0 and not _.any(slot4, function (slot0)
			return slot0 == slot0.id
		end) then
			pg.TipsMgr.GetInstance().ShowTips(slot6, i18n("world_task_goto0"))

			return
		end

		if not slot3[1] then
			return
		elseif slot3[1] == 1 then
			slot6 = {}

			for slot10, slot11 in ipairs(slot3[2]) do
				table.insert(slot6, function (slot0)
					slot1:Op("OpTriggerEvent", master:NewMapOp({
						op = WorldConst.OpActionTaskGoto,
						effect = pg.world_effect_data[slot0]
					}), slot0)
				end)
			end

			seriesAsync(slot6, function ()
				slot0:Op("OpInteractive")
			end)
		elseif slot3[1] == 2 then
			if nowWorld:GetRealm() == checkExist(checkExist(nowWorld.GetActiveMap(slot6), {
				"GetPort"
			}), {
				"GetRealm"
			}) and checkExist(slot7, {
				"IsOpen",
				{
					slot8,
					slot6:GetProgress()
				}
			}) then
				slot0:Op("OpRedeploy")
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_1"))

				return
			end
		elseif slot3[1] == 3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_task_goto3"))

			return
		else
			return
		end
	end
end

slot0.OpShowAllFleetHealth = function (slot0, slot1)
	slot0:OpDone()

	if master:GetInMap() then
		for slot5, slot6 in ipairs(master.wsMap.wsMapFleets) do
			slot6:DisplayHealth()
		end
	end

	return existCall(slot1)
end

slot0.OpAutoSubmitTask = function (slot0, slot1)
	master:emit(WorldMediator.OnAutoSubmitTask, slot1)
end

slot0.OpAutoSubmitTaskDone = function (slot0, slot1)
	slot0:Op("OpInteractive")
end

slot0.OpTrapGravityAnim = function (slot0, slot1, slot2)
	master:ClearMoveQueue()
	master.wsMap:GetAttachment(slot1.row, slot1.column, slot1.type):TrapAnimDisplay(function ()
		slot0:OpDone()
		existCall(slot0)
	end)
end

slot0.OpAutoFightSeach = function (slot0)
	slot0:OpDone()

	slot1 = nowWorld:GetActiveMap()
	slot4 = nil
	slot5 = 0

	for slot9, slot10 in ipairs(slot3) do
		if slot1:GetCell(slot10.row, slot10.column):GetEventAttachment() and slot11:GetEventAutoPri() and slot5 < slot12 and slot1:CheckEventAutoTrigger(slot11) then
			slot4 = slot10
			slot5 = slot12
		end
	end

	if slot4 then
		slot0:Op("OpLongMoveFleet", slot2, slot4.row, slot4.column)
	elseif slot2:IsCatSalvage() then
		slot0:Op("OpLongMoveFleet", slot2, slot3[1].row, slot3[1].column)
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_suspend"))
		nowWorld:TriggerAutoFight(false)
		slot0:Op("OpInteractive")
	end
end

return slot0

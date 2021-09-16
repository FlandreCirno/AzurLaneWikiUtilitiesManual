slot0 = class("WorldProxy", import(".NetProxy"))

slot0.register = function (slot0)
	WPool = BaseEntityPool.New()
	WBank = BaseEntityBank.New()

	slot0:BuildTestFunc()
	slot0:on(33114, function (slot0)
		slot0.isProtoLock = slot0.is_world_open == 0

		slot0:BuildWorld(World.TypeBase)

		nowWorld.baseShipIds = underscore.rest(slot0.ship_id_list, 1)
		nowWorld.baseCmdIds = underscore.rest(slot0.cmd_id_list, 1)

		nowWorld:UpdateProgress(slot0.progress)
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
		slot0:sendNotification(GAME.WORLD_GET_BOSS)
	end)
	slot0.on(slot0, 33105, function (slot0)
		slot0:UpdateMapAttachmentCells(nowWorld:GetActiveMap().id, slot2)
		slot0:ApplyFleetAttachUpdate(nowWorld.GetActiveMap().id, slot0:NetBuildFleetAttachUpdate(slot0.pos_list))
		WPool:ReturnArray(slot0.NetBuildFleetAttachUpdate(slot0.pos_list))
	end)
	slot0.on(slot0, 33203, function (slot0)
		slot1 = nowWorld:GetTaskProxy()

		for slot5, slot6 in ipairs(slot0.update_list) do
			if slot1:getTaskById(WorldTask.New(slot6).id) then
				slot1:updateTask(slot7)
			else
				slot1:addTask(slot7)
				slot0:sendNotification(GAME.WORLD_TRIGGER_TASK_DONE, {
					task = slot7
				})
			end
		end
	end)
	slot0.on(slot0, 33204, function (slot0)
		slot1 = nowWorld:GetTaskProxy()

		for slot5, slot6 in ipairs(slot0.delete_list) do
			slot1:deleteTask(slot6)
		end
	end)
	slot0.on(slot0, 33601, function (slot0)
		slot0:NetUpdateAchievements(slot0.target_list)
	end)
	slot0.on(slot0, 34507, function (slot0)
		if nowWorld then
			slot2 = WorldBoss.New()

			slot2:Setup(slot0.boss_info, Player.New(slot0.user_info))
			slot2:UpdateBossType(slot0.type)
			slot2:SetJoinTime(pg.TimeMgr.GetInstance():GetServerTime())

			if nowWorld:GetBossProxy().isSetup then
				slot1:ClearRank(slot2.id)
				slot1:UpdateCacheBoss(slot2)
			end

			if not slot1:IsSelfBoss(slot2) and nowWorld:IsSystemOpen(WorldConst.SystemWorldBoss) then
				pg.WorldBossTipMgr.GetInstance():Show(slot2)
			end
		end
	end)
	slot0.on(slot0, 34508, function (slot0)
		if nowWorld:GetBossProxy().isSetup then
			slot0:sendNotification(GAME.WORLD_GET_BOSS_RANK, {
				bossId = slot0.boss_id,
				callback = function ()
					slot0:updateBossHp(slot1.boss_id, slot1.hp)
				end
			})
		end
	end)
end

slot0.remove = function (slot0)
	nowWorld:GetBossProxy():Dispose()
	nowWorld:Dispose()

	nowWorld = nil

	WPool:Dispose()

	WPool = nil

	WBank:Dispose()

	WBank = nil
end

slot0.BuildTestFunc = function (slot0)
	world_skip_battle = PlayerPrefs.GetInt("world_skip_battle") or 0

	function switch_world_skip_battle()
		if getProxy(PlayerProxy):getRawData():CheckIdentityFlag() then
			world_skip_battle = 1 - world_skip_battle

			PlayerPrefs.SetInt("world_skip_battle", world_skip_battle)
			PlayerPrefs.Save()
			pg.TipsMgr.GetInstance():ShowTips((world_skip_battle == 1 and "已开启大世界战斗跳略") or "已关闭大世界战斗跳略")
		end
	end

	if Application.isEditor then
		function display_world_debug_panel()
			if pg.m02:retrieveMediator(WorldMediator.__cname) then
				slot0.viewComponent:ShowSubView("DebugPanel")
			end
		end

		pg.UIMgr.GetInstance().AddWorldTestButton(slot1, "WorldDebug", function ()
			WorldConst.Debug = true
		end)
	end
end

slot0.BuildWorld = function (slot0, slot1)
	nowWorld = World.New(slot1, nowWorld and nowWorld:Dispose(slot1))

	nowWorld:NewAtlas(WorldConst.DefaultAtlas)
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inWorld")
end

slot0.NetFullUpdate = function (slot0, slot1)
	slot0.isProtoLock = slot1.is_world_open == 0

	slot0:NetUpdateWorld(slot1.world, slot1.vision_list, slot1.camp)
	slot0:NetUpdateWorldDefaultFleets(slot1.fleet_list)
	slot0:NetUpdateWorldAchievements(slot1.target_list, slot1.target_fetch_list)
	slot0:NetUpdateWorldCountInfo(slot1.count_info)
	slot0:NetUpdateWorldMapPressing(slot1.clean_chapter)
	slot0:NetUpdateWorldShopGoods(slot1.out_shop_buy_list)
	slot0:NetUpdateWorldPressingAward(slot1.chapter_award)
	slot0:NetUpdateWorldPortTaskMark(slot1.port_list)
end

slot0.NetUpdateWorld = function (slot0, slot1, slot2, slot3)
	nowWorld:SetRealm(slot3)

	nowWorld.expiredTime = slot1.last_change_group_timestamp
	nowWorld.roundIndex = slot1.round
	slot4.submarineSupport = slot1.submarine_state == 1

	slot4.staminaMgr:Setup({
		slot1.action_power,
		slot1.action_power_extra,
		slot1.last_recover_timestamp,
		slot1.action_power_fetch_count
	})
	slot4:GetAtlas():SetCostMapList(_.rest(slot1.chapter_list, 1))
	slot4:GetAtlas():SetSairenEntranceList(_.rest(slot1.sairen_chapter, 1))
	slot4:SetFleets(slot0:NetBuildMapFleetList(slot1.group_list))

	if slot1.map_id > 0 and _.detect(slot1.chapter_list, function (slot0)
		return slot0.random_id == slot0.map_id
	end) then
		slot10 = slot4:GetMap(slot7)

		slot4.GetEntrance(slot4, slot6).UpdateActive(slot9, true)
		slot10:UpdateGridId(slot8)

		slot10.findex = table.indexof(slot4.fleets, slot4:GetFleet(slot1.group_list[1].id))

		slot10:BindFleets(slot4.fleets)
		slot10:UpdateActive(true)
	end

	slot4:SetPortShips(slot0:NetBuildPortShipList(slot1.ship_in_port))
	slot4:GetInventoryProxy().Setup(slot6, slot1.item_list)

	slot7 = slot4:GetTaskProxy()

	slot7:Setup(slot1.task_list)

	slot7.taskFinishCount = slot1.task_finish_count

	_.each(slot1.cd_list, function (slot0)
		slot0.cdTimeList[slot0.id] = slot0.time
	end)
	_.each(slot1.buff_list, function (slot0)
		slot0.globalBuffDic[slot0.id] = WorldBuff.New()

		slot0.globalBuffDic[slot0.id]:Setup({
			id = slot0.id,
			floor = slot0.stack
		})
	end)
end

slot0.NetUpdateWorldDefaultFleets = function (slot0, slot1)
	_.each(slot1, function (slot0)
		slot1 = WorldBaseFleet.New()

		slot1:Setup(slot0)
		table.insert(slot0, slot1)
	end)
	table.sort(slot2, function (slot0, slot1)
		return slot0.id < slot1.id
	end)
	nowWorld.SetDefaultFleets(slot3, {})
end

slot0.NetUpdateWorldAchievements = function (slot0, slot1, slot2)
	nowWorld.achievements = {}

	slot0:NetUpdateAchievements(slot1)

	nowWorld.achieveEntranceStar = {}

	_.each(slot2, function (slot0)
		for slot4, slot5 in ipairs(slot0.star_list) do
			nowWorld:SetAchieveSuccess(slot0.id, slot5)
		end
	end)
end

slot0.NetUpdateWorldCountInfo = function (slot0, slot1)
	nowWorld.stepCount = slot1.step_count
	nowWorld.treasureCount = slot1.treasure_count
	nowWorld.activateCount = slot1.activate_count

	nowWorld:GetCollectionProxy().Setup(slot2, slot1.collection_list)
	nowWorld:UpdateProgress(slot1.task_progress)
end

slot0.NetUpdateActiveMap = function (slot0, slot1, slot2, slot3)
	slot4 = nowWorld:GetActiveEntrance()

	if nowWorld:GetActiveMap():NeedClear() and slot4.becomeSairen and slot4:GetSairenMapId() == slot5.id then
		nowWorld:GetAtlas():RemoveSairenEntrance(slot4)
	end

	if slot4.id ~= nowWorld:GetEntrance(slot1).id then
		slot4:UpdateActive(false)
		slot6:UpdateActive(true)
	end

	if slot5.id ~= nowWorld:GetMap(slot2).id then
		slot5:UpdateActive(false)
		slot5:RemoveFleetsCarries()
		slot5:UnbindFleets()

		slot7.findex = slot5.findex
		slot5.findex = nil

		slot7:UpdateGridId(slot3)
		slot7:BindFleets(nowWorld.fleets)
		slot7:UpdateActive(true)
	end

	nowWorld:OnSwitchMap()
end

slot0.NetUpdateMap = function (slot0, slot1)
	slot3 = slot1.id.template_id

	_.each(slot1.state_flag, function (slot0)
		slot0[slot0] = true
	end)

	slot5 = nowWorld.GetMap(slot5, slot2)

	slot5:UpdateClearFlag(({})[1])
	slot5:UpdateVisionFlag(()[2] or nowWorld:IsMapVisioned(slot2))
	slot0:NetUpdateMapDiscoveredCells(slot5.id, slot4[3], slot1.cell_list)
	slot0:UpdateMapAttachmentCells(slot5.id, slot5.UpdateVisionFlag)
	slot0:ApplyFleetAttachUpdate(slot5.id, slot5)
	WPool:ReturnArray(slot5)
	slot0:ApplyTerrainUpdate(slot5.id, slot0:NetBulidTerrainUpdate(slot1.land_list))
	WPool:ReturnArray(()[2] or nowWorld.IsMapVisioned(slot2))
	slot5:SetValid(true)
end

slot0.NetUpdateMapDiscoveredCells = function (slot0, slot1, slot2, slot3)
	slot4 = nowWorld:GetMap(slot1)

	if slot2 then
		for slot8, slot9 in pairs(slot4.cells) do
			slot9:UpdateDiscovered(true)
		end
	else
		_.each(slot3, function (slot0)
			slot0:GetCell(slot0.pos.row, slot0.pos.column):UpdateDiscovered(true)
		end)
	end
end

slot0.NetUpdateMapPort = function (slot0, slot1, slot2)
	slot4 = nowWorld:GetMap(slot1).GetPort(slot3, slot2.port_id)

	slot4:UpdateTaskIds(_.rest(slot2.task_list, 1))
	slot4:UpdateGoods(_.map(slot2.goods_list, function (slot0)
		slot1 = WPool:Get(WorldGoods)

		slot1:Setup(slot0)

		return slot1
	end))
	slot4.UpdateExpiredTime(slot4, slot2.next_refresh_time)
end

slot0.NetUpdateAchievements = function (slot0, slot1)
	_.each(slot1, function (slot0)
		nowWorld:DispatchEvent(World.EventAchieved, nowWorld:GetAchievement(slot0.id):NetUpdate(slot0.process_list))
	end)
end

slot0.NetBuildMapFleetList = function (slot0, slot1)
	slot2 = {}

	if slot1 and #slot1 > 0 then
		_.each(slot1, function (slot0)
			slot1 = WorldMapFleet.New()

			slot1:Setup(slot0)
			table.insert(slot0, slot1)
		end)
		table.sort(slot2, function (slot0, slot1)
			return slot0.id < slot1.id
		end)

		slot3 = {
			[FleetType.Normal] = 1,
			[FleetType.Submarine] = 1
		}

		_.each(slot2, function (slot0)
			slot1 = slot0:GetFleetType()
			slot0.index = slot0[slot1]
			slot0[slot1] = slot0[slot1] + 1
		end)
	end

	return slot2
end

slot0.NetBuildPortShipList = function (slot0, slot1)
	return _.map(slot1, function (slot0)
		slot1 = WPool:Get(WorldMapShip)

		slot1:Setup(slot0)

		return slot1
	end)
end

slot0.NetResetWorld = function (slot0)
	slot0:sendNotification(GAME.SEND_CMD, {
		cmd = "world",
		arg1 = "reset"
	})
	slot0:sendNotification(GAME.SEND_CMD, {
		cmd = "kick"
	})
end

slot0.NetBuildMapAttachmentCells = function (slot0, slot1)
	slot2 = {}

	_.each(slot1, function (slot0)
		slot0[WorldMapCell.GetName(slot0.pos.row, slot0.pos.column)] = {
			pos = {
				row = slot0.pos.row,
				column = slot0.pos.column
			},
			attachmentList = slot0.item_list
		}
	end)

	for slot6, slot7 in pairs(slot2) do
		_.each(slot7.attachmentList, function (slot0)
			slot1 = WPool:Get(WorldMapAttachment)

			slot1:Setup(setmetatable({
				pos = slot0.pos
			}, {
				__index = slot0
			}))
			table.insert(slot1, slot1)
		end)

		slot7.attachmentList = {}
	end

	return slot2
end

slot0.UpdateMapAttachmentCells = function (slot0, slot1, slot2)
	slot3 = nowWorld:GetMap(slot1)

	for slot7, slot8 in pairs(slot2) do
		for slot14 = #slot3:GetCell(slot8.pos.row, slot8.pos.column).attachments, 1, -1 do
			slot15 = slot10[slot14]

			if not WorldMapAttachment.IsFakeType(slot10[slot14].type) and not _.any(slot8.attachmentList, function (slot0)
				return slot0.type == slot0.type and slot0.id == slot0.id
			end) then
				slot9.RemoveAttachment(slot9, slot14)
			end
		end

		_.each(slot8.attachmentList, function (slot0)
			if slot0.type ~= WorldMapAttachment.TypeFleet then
				if _.detect(slot0.attachments, function (slot0)
					return slot0.type == slot0.type and slot0.id == slot0.id
				end) then
					slot1.UpdateFlag(slot1, slot0.flag)
					slot1:UpdateData(slot0.data, slot0.effects)
					slot1:AddPhaseDisplay(slot1:UpdateBuffList(slot0.buffList))
				else
					slot0:AddAttachment(slot0)
				end
			end
		end)
	end
end

slot0.NetBuildFleetAttachUpdate = function (slot0, slot1)
	_.each(slot1, function (slot0)
		slot1 = {
			row = slot0.pos.row,
			column = slot0.pos.column
		}

		_.each(slot0.item_list, function (slot0)
			if slot0.item_type == WorldMapAttachment.TypeFleet then
				slot1 = WPool:Get(NetFleetAttachUpdate)

				slot1:Setup(setmetatable({
					pos = slot0
				}, {
					__index = slot0
				}))
				table.insert(slot1, slot1)
			end
		end)
	end)

	return {}
end

slot0.ApplyFleetAttachUpdate = function (slot0, slot1, slot2)
	slot3 = nowWorld:GetMap(slot1)

	_.each(slot2, function (slot0)
		slot0:UpdateFleetLocation(slot0.id, slot0.row, slot0.column)
	end)
end

slot0.NetBulidTerrainUpdate = function (slot0, slot1)
	return _.map(slot1, function (slot0)
		slot1 = WPool:Get(NetTerrainUpdate)

		slot1:Setup(slot0)

		return slot1
	end)
end

slot0.ApplyTerrainUpdate = function (slot0, slot1, slot2)
	slot3 = nowWorld:GetMap(slot1)

	_.each(slot2, function (slot0)
		if slot0:FindFleet(slot0:GetCell(slot0.row, slot0.column).row, slot0.GetCell(slot0.row, slot0.column).column) then
			slot0:CheckFleetUpdateFOV(slot2, function ()
				slot0:UpdateTerrain(slot1:GetTerrain(), slot1.terrainDir, slot1.terrainStrong)
			end)
		else
			slot1.UpdateTerrain(slot1, slot0:GetTerrain(), slot0.terrainDir, slot0.terrainStrong)
		end
	end)
end

slot0.NetBuildFleetUpdate = function (slot0, slot1)
	return _.map(slot1, function (slot0)
		slot1 = WPool:Get(NetFleetUpdate)

		slot1:Setup(slot0)

		return slot1
	end)
end

slot0.ApplyFleetUpdate = function (slot0, slot1, slot2)
	slot3 = nowWorld:GetMap(slot1)

	_.each(slot2, function (slot0)
		slot0:CheckFleetUpdateFOV(slot0:GetFleet(slot0.id), function ()
			slot0:UpdateBuffs(slot1.buffs)
		end)
	end)
end

slot0.NetBuildShipUpdate = function (slot0, slot1)
	return _.map(slot1, function (slot0)
		slot1 = WPool:Get(NetShipUpdate)

		slot1:Setup(slot0)

		return slot1
	end)
end

slot0.ApplyShipUpdate = function (slot0, slot1)
	_.each(slot1, function (slot0)
		nowWorld:GetShip(slot0.id):UpdateHpRant(slot0.hpRant)
	end)
end

slot0.NetUpdateWorldSairenChapter = function (slot0, slot1)
	nowWorld:GetAtlas():SetSairenEntranceList(_.rest(slot1, 1))
end

slot0.NetUpdateWorldMapPressing = function (slot0, slot1)
	nowWorld:GetAtlas():SetPressingMarkList(_.rest(slot1, 1))
end

slot0.NetUpdateWorldShopGoods = function (slot0, slot1)
	nowWorld:InitWorldShopGoods()
	nowWorld:UpdateWorldShopGoods(slot1)
end

slot0.NetUpdateWorldPressingAward = function (slot0, slot1)
	slot2 = nowWorld:GetAtlas()

	_.each(slot1, function (slot0)
		nowWorld.pressingAwardDic[slot0.id] = {
			id = slot0.award,
			flag = slot0.flag == 1
		}

		if not slot2.flag then
			slot0:MarkMapTransport(slot1)
		end
	end)
end

slot0.NetUpdateWorldPortTaskMark = function (slot0, slot1)
	nowWorld:GetAtlas():SetPortTaskList(slot1)
end

slot0.NetBuildSalvageUpdate = function (slot0, slot1)
	return _.map(slot1, function (slot0)
		slot1 = WPool:Get(NetSalvageUpdate)

		slot1:Setup(slot0)

		return slot1
	end)
end

slot0.ApplySalvageUpdate = function (slot0, slot1)
	_.each(slot1, function (slot0)
		nowWorld:GetFleet(slot0.id):UpdateCatSalvage(slot0.step, slot0.list, slot0.mapId)
	end)
end

return slot0

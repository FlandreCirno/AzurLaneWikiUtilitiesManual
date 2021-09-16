slot0 = class("GuildMissionBattleView")
slot1 = Vector3(40, -3, 40)
slot2 = 10
slot3 = 1028
slot4 = Vector3(80, -3, 40)

function slot5(slot0)
	slot1 = {}
	slot2 = {}

	for slot6, slot7 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
		slot2[slot6] = Vector3(slot0[slot6][1], slot0[slot6][2], slot0[slot6][3])
	end

	slot1._FXOffset = slot2
	slot1._FXAttachPoint = GameObject()

	slot1.GetFXOffsets = function (slot0, slot1)
		return slot0._FXOffset[slot1 or 1]
	end

	slot1.GetAttachPoint = function (slot0)
		return slot0._FXAttachPoint
	end

	slot1.GetGO = function (slot0)
		return slot0._go
	end

	slot1.SetGo = function (slot0, slot1)
		slot0._go = slot1

		slot0._FXAttachPoint.transform.SetParent(slot2, slot1.transform, false)

		slot0._FXAttachPoint.transform.localPosition = Vector3.zero
		slot0._FXAttachPoint.transform.localEulerAngles = Vector3(330, 0, 0)
	end

	slot1.GetSpecificFXScale = function (slot0)
		return {}
	end

	return slot1
end

slot0.Ctor = function (slot0, slot1)
	slot0.rawImage = slot1

	setActive(slot0.rawImage, false)

	slot0.seaCameraGO = GameObject.Find("BarrageCamera")
	slot0.seaCameraGO.tag = "MainCamera"
	slot0.seaCamera = slot0.seaCameraGO:GetComponent(typeof(Camera))
	slot0.seaCamera.targetTexture = slot0.rawImage.texture
	slot0.seaCamera.enabled = true
	slot0.mainCameraGO = pg.UIMgr.GetInstance():GetMainCamera()
end

slot0.configUI = function (slot0, slot1, slot2)
	slot0.nameTF = slot2
	slot0.healTF = slot1

	setActive(slot0.healTF, false)
	slot0.healTF:GetComponent("DftAniEvent"):SetEndEvent(function ()
		setActive(slot0.healTF, false)
		setText(slot0.healTF:Find("text"), "")
	end)
end

slot0.load = function (slot0, slot1, slot2)
	ys.Battle.BattleVariable.Init()

	slot3 = ys.Battle.BattleResourceManager.GetInstance()

	slot3:Init()
	slot3:AddPreloadResource(slot3.GetMapResource(slot1))
	slot3.StartPreload(slot3, function ()
		pg.UIMgr.GetInstance():LoadingOff()

		pg.UIMgr.GetInstance().LoadingOff.seaView = ys.Battle.BattleMap.New(ys.Battle.BattleMap.New)

		setActive(slot0.rawImage, true)

		GameObject.Find("scenes").transform.position = Vector3(0, -26, 0)

		Vector3(0, -26, 0):Clear()

		if 0 then
			onNextTick(slot3)
		end
	end, nil)
	pg.UIMgr.GetInstance():LoadingOn()
end

slot0.LoadShip = function (slot0, slot1, slot2, slot3, slot4)
	if not slot1 then
		slot4()

		return
	end

	if slot0.shipVO then
		slot4()

		return
	end

	slot0.unitList = {}
	slot0.bulletUnitList = {}
	slot0.shipVO = slot1
	slot0.equipSkinId = 0
	slot0.weaponIds = slot2

	ys.Battle.BattleFXPool.GetInstance():Init()

	slot0._cldSystem = ys.Battle.BattleCldSystem.New(slot0)
	slot5 = ys.Battle.BattleResourceManager.GetInstance()

	slot5:Init()
	slot5:AddPreloadResource(slot5.GetDisplayCommonResource())

	if slot0.equipSkinId > 0 then
		slot5:AddPreloadResource(slot5.GetEquipSkinPreviewRes(slot0.equipSkinId))
	end

	slot5:AddPreloadResource(slot5.GetCharacterPath(pg.enemy_data_statistics[slot0].prefab), false)
	slot5:AddPreloadResource(slot5.GetCharacterPath(pg.enemy_data_statistics[slot1].prefab), false)
	slot5:AddPreloadResource(slot5.GetShipResource(slot1.configId, slot1.skinId), false)

	if slot1:getShipType() ~= ShipType.WeiXiu then
		for slot11, slot12 in ipairs(slot2) do
			if slot12 ~= 0 then
				for slot17, slot18 in ipairs(slot13) do
					slot5:AddPreloadResource(slot5.GetWeaponResource(slot18))
				end
			end
		end
	end

	slot5.StartPreload(slot5, function ()
		function slot0(slot0)
			slot0.seaCharacter = slot0
			slot0.transform.localScale = Vector3(slot0:getConfig("scale") / 50 - 0.4, slot1, slot1)
			slot0.transform.localPosition = slot0:GetCharacterOffset()
			slot0.transform.localEulerAngles = Vector3(30, 0, 0)
			slot0.seaAnimator = slot0.transform:GetComponent("SpineAnim")
			slot0.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			slot0.seaAnimator:SetAction(slot0.characterAction, 0, true)

			slot2 = cloneTplTo(slot0.nameTF, slot0)
			slot2.localPosition = Vector3(0, -0.35, -1)

			setText(slot2:Find("Text"), slot2)

			slot4 = slot3(pg.ship_skin_template[slot1.skinId].fx_container)

			slot4:SetGo(slot0)

			slot5 = ys.Battle.BattleFXPool.GetInstance()

			pg.EffectMgr.GetInstance():PlayBattleEffect(slot5:GetCharacterFX("movewave", slot4), Vector3(0, 0, 0), true)

			slot0.seaFXPool = slot5

			if slot1:getShipType() ~= ShipType.WeiXiu then
				slot0.boneList = {}

				for slot11, slot12 in pairs(pg.ship_skin_template[slot1.skinId].bound_bone) do
					slot13 = {}

					for slot17, slot18 in ipairs(slot12) do
						if type(slot18) == "table" then
							slot13[#slot13 + 1] = Vector3(slot18[1], slot18[2], slot18[3])
						else
							slot13[#slot13 + 1] = Vector3.zero
						end
					end

					slot0.boneList[slot11] = slot13[1]
				end
			end

			LeanTween.value(slot0, -20, 0, 2):setOnUpdate(System.Action_float(function (slot0)
				slot0.transform.position = Vector3(slot0, slot0.transform.position.y, slot0.transform.position.z)
			end))
		end

		seriesAsync({
			function (slot0)
				slot0:InstCharacter(slot1:getPrefab(), function (slot0)
					slot0(slot0)
					slot0()
				end)
			end,
			function (slot0)
				slot0:CreateMonster(slot0)
			end,
			function (slot0)
				slot0:CreateItemBox(slot0)
			end
		}, function ()
			slot0.loaded = true

			pg.TimeMgr.GetInstance():ResumeBattleTimer()

			if pg.TimeMgr.GetInstance():getShipType() ~= ShipType.WeiXiu then
				slot0:onWeaponUpdate()
				slot0.onWeaponUpdate:SeaUpdate()
			end

			if slot2 then
				slot2()
			end
		end)
	end, nil)
end

slot0.StartMoveOtherShips = function (slot0, slot1)
	function slot2(slot0, slot1)
		LeanTween.value(slot0, slot0.transform.localPosition.x, 80, math.random(5, 8)):setOnUpdate(System.Action_float(function (slot0)
			slot0.transform.localPosition = Vector3(slot0, slot1.y, slot1.z)
		end)).setOnComplete(slot5, System.Action(slot1)):setDelay(math.random(0, 5))
	end

	slot3 = {}

	for slot7, slot8 in ipairs(slot0.otherShipGos) do
		table.insert(slot3, function (slot0)
			slot0(slot0, slot0)
		end)
	end

	parallelAsync(slot3, slot1)
end

slot0.PlayOtherShipAnim = function (slot0, slot1, slot2)
	if not slot0.loaded then
		return
	end

	slot0.otherShipGos = {}
	slot3 = ys.Battle.BattleResourceManager.GetInstance()

	slot3:Init()
	slot3:AddPreloadResource(slot3.GetDisplayCommonResource())

	function slot4(slot0, slot1, slot2)
		slot2.transform.localScale = Vector3(pg.ship_data_statistics[slot0.id].scale / 50 - 0.4, slot4, slot4)
		slot2.transform.localPosition = Vector3(-20, 0, slot1)
		slot2.transform.localEulerAngles = Vector3(30, 0, 0)

		slot2.transform:GetComponent("SpineAnim").SetAction(slot5, ys.Battle.BattleConst.ActionName.MOVE, 0, true)

		slot6 = cloneTplTo(slot0.nameTF, slot2)
		slot6.localPosition = Vector3(0, -0.35, -1)

		setText(slot6:Find("Text"), slot0.name)

		slot8 = slot1(pg.ship_skin_template[slot0.skin].fx_container)

		slot8:SetGo(slot2)
		pg.EffectMgr.GetInstance():PlayBattleEffect(slot10, Vector3(0, 0, 0), true)
		table.insert(slot0.otherShipGos, slot2)
	end

	slot5 = {}
	slot6 = {
		math.random(43, 48),
		math.random(49, 53)
	}

	for slot10, slot11 in ipairs(slot1) do
		slot3:AddPreloadResource(slot3.GetShipResource(slot11.id, slot11.skin), false)
		table.insert(slot5, function (slot0)
			slot1:InstCharacter(pg.ship_skin_template[slot0.skin].prefab, function (slot0)
				slot0(slot0, slot2[], slot0)
				slot0()
			end)
		end)
	end

	function slot7()
		for slot3, slot4 in ipairs(slot0.otherShipGos) do
			Destroy(slot4)
		end

		slot0.otherShipGos = nil

		nil()
	end

	slot3.StartPreload(slot3, function ()
		seriesAsync(seriesAsync, function ()
			slot0:StartMoveOtherShips(slot0)
		end)
	end, nil)
end

slot0.PlayAttackAnim = function (slot0)
	slot0.isFinish = nil

	function slot1()
		if not slot0.animTimer then
			return
		end

		slot0.animTimer:Stop()

		slot0.animTimer.Stop.animTimer = nil
	end

	seriesAsync({
		function (slot0)
			slot0()
			slot0.seaEmenyAnimator:SetAction("move", 0, true)

			slot1.seaEmeny.transform.localPosition = slot0.seaEmenyAnimator + Vector3(40, 0, 0)

			setActive(slot1.seaEmeny, true)

			slot1.animTimer = Timer.New(function ()
				slot0.localPosition = Vector3.Lerp(slot0.localPosition, Vector3.Lerp, Time.deltaTime * 3)

				if Vector3.Distance(Vector3.Lerp(slot0.localPosition, Vector3.Lerp, Time.deltaTime * 3), slot0.localPosition) <= 1 then
					slot2()
				end
			end, 0.033, -1)

			slot1.animTimer.Start(slot3)
		end,
		function (slot0)
			slot0()

			if slot0.shipVO:getShipType() ~= ShipType.WeiXiu then
				slot1:SeaFire()
			end

			slot1.animTimer = Timer.New(slot0, 3, 1)

			slot1.animTimer:Start()
		end,
		function (slot0)
			slot0()

			if not slot0.isFinish then
				slot1:HandleBulletHit(nil, slot1.unitList[1])
			end

			slot1.seaAnimator:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					slot0.seaAnimator:SetAction("move", 0, true)
					slot0.seaAnimator:SetActionCallBack(nil)
					slot0.seaAnimator.SetActionCallBack()
				end
			end)
			slot1.seaAnimator.SetActionCallBack.seaAnimator.SetAction(slot1, "victory", 0, true)
		end
	})
end

slot0.PlayItemAnim = function (slot0)
	function slot1()
		if not slot0.animTimer then
			return
		end

		slot0.animTimer:Stop()

		slot0.animTimer.Stop.animTimer = nil
	end

	slot1()
	seriesAsync({
		function (slot0)
			slot0.seaItemBoxAnimator:SetAction("move", 0, true)
			setActive(slot0.seaItemBox, true)

			slot0.seaItemBox.transform.localPosition = slot1
			slot0.animTimer = Timer.New(function ()
				slot0.localPosition = Vector3.Lerp(slot0.localPosition, Vector3.Lerp, Time.deltaTime * 3)

				if Vector3.Distance(Vector3.Lerp(slot0.localPosition, Vector3.Lerp, Time.deltaTime * 3), slot0.localPosition) <= 1 then
					slot2()
				end
			end, 0.033, -1)

			slot0.animTimer.Start(slot2)
		end,
		function (slot0)
			slot0()
			slot0.seaAnimator:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					slot0.seaAnimator:SetAction("move", 0, true)
					slot0.seaAnimator:SetActionCallBack(nil)
					slot0.seaAnimator.SetActionCallBack()
				end
			end)
			slot0.seaAnimator.SetActionCallBack.seaAnimator.SetAction(slot1, "victory", 0, true)
		end
	})
end

slot0.CreateMonster = function (slot0, slot1)
	slot3 = ys.Battle.BattleDataFunction.CreateBattleUnitData(slot2, ys.Battle.BattleConst.UnitType.ENEMY_UNIT, -1, slot0, nil, {}, nil, nil, false, 1, 1, nil, nil, 1)

	slot3:SetPosition(slot1)
	slot3:ActiveCldBox()
	slot0._cldSystem:InitShipCld(slot3)

	slot4 = slot2(slot3:GetTemplate().fx_container)

	ys.Battle.BattleResourceManager.GetInstance():InstCharacter(slot3:GetTemplate().prefab, function (slot0)
		slot0:SetGo(slot0)

		slot0.transform.localScale = Vector3(slot1, slot1, slot1)
		slot0.transform.localPosition = slot0.transform
		slot0.transform.localEulerAngles = Vector3(30, 0, 0)
		slot3 = ys.Battle.BattleFXPool.GetInstance()

		pg.EffectMgr.GetInstance():PlayBattleEffect(slot4, Vector3(0, 0, 0), true)

		slot3.seaEmeny = slot0
		slot3.seaEmenyAnimator = slot0.transform:GetComponent("SpineAnim")

		setActive(slot0, false)
		slot3:GetCharacterFX(slot2, slot0)()
	end)

	slot0.unitList[1] = slot3
end

slot0.CreateItemBox = function (slot0, slot1)
	ys.Battle.BattleResourceManager.GetInstance():InstCharacter(pg.enemy_data_statistics[slot0].prefab, function (slot0)
		slot0.transform.localScale = Vector3(slot1, slot1, slot1)
		slot0.transform.localPosition = slot1
		slot0.transform.localEulerAngles = Vector3(30, 0, 0)
		slot0.transform.seaItemBox = slot0
		slot0.transform.seaItemBoxAnimator = slot0.transform:GetComponent("SpineAnim")

		setActive(slot0, false)
		slot0()
	end)
end

slot0.playShipAnims = function (slot0)
	if slot0.loaded and slot0.seaAnimator then
		slot1 = {
			"attack",
			"victory",
			"dead"
		}

		function slot2(slot0)
			if slot0.seaAnimator then
				slot0.seaAnimator:SetActionCallBack(nil)
			end

			slot0.seaAnimator:SetAction(slot1[slot0], 0, false)
			slot0.seaAnimator:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					slot0.seaAnimator:SetActionCallBack(nil)
					slot0.seaAnimator:SetAction("stand", 0, false)
				end
			end)
		end

		if slot0.palyAnimTimer then
			slot0.palyAnimTimer.Stop(slot3)

			slot0.palyAnimTimer = nil
		end

		slot0.palyAnimTimer = Timer.New(function ()
			slot0(math.random(1, #slot1))
		end, 5, -1)

		slot0.palyAnimTimer.Start(slot3)
		slot0.palyAnimTimer.func()
	end
end

slot0.onWeaponUpdate = function (slot0)
	if slot0.loaded and slot0.weaponIds then
		if slot0.seaAnimator then
			slot0.seaAnimator:SetActionCallBack(nil)
		end

		function slot1()
			slot1 = slot0.weaponList or {}

			for slot3, slot4 in slot0(slot1) do
				slot5 = pairs
				slot6 = slot4.emitterList or {}

				for slot8, slot9 in slot5(slot6) do
					slot9:Destroy()
				end
			end

			slot1 = slot0.bulletList or {}

			for slot3, slot4 in slot0(slot1) do
				Object.Destroy(slot4._go)
			end

			slot1 = slot0.aircraftList or {}

			for slot3, slot4 in slot0(slot1) do
				Object.Destroy(slot4.obj)
			end

			slot0.bulletList = {}
			slot0.aircraftList = {}
		end

		if #slot0.weaponIds == 0 and slot0.playRandomAnims then
			if slot0._fireTimer then
				slot0._fireTimer.Stop(slot2)
			end

			if slot0._delayTimer then
				slot0._delayTimer:Stop()
			end

			if slot0.shipVO:getShipType() ~= ShipType.WeiXiu then
				slot1()
			elseif slot0.buffTimer then
				pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0.buffTimer)

				slot0.buffTimer = nil
			end

			slot0:playShipAnims()
		elseif slot0.shipVO:getShipType() ~= ShipType.WeiXiu then
			slot1()
			slot0:MakeWeapon(slot0.weaponIds)
		elseif slot0.weaponIds[1] then
			slot0:MakeBuff(pg.equip_data_statistics[slot2].skill_id[1])
		end
	end
end

slot0.SeaFire = function (slot0)
	slot1 = 1
	slot2 = nil

	function slot2()
		if slot0.weaponList[slot1] then
			function slot1()
				slot1 = 0

				for slot5, slot6 in ipairs(slot0.emitterList) do
					slot6:Ready()
				end

				for slot5, slot6 in ipairs(slot0.emitterList) do
					slot6:Fire(nil, slot0, slot1)
				end

				slot1 = slot1 + 1
			end

			if slot0.tmpData.action_index ~= "" then
				slot0.characterAction = slot0.tmpData.action_index

				slot0.seaAnimator.SetAction(slot2, slot0.characterAction, 0, false)
				slot0.seaAnimator:SetActionCallBack(function (slot0)
					if slot0 == "action" then
						slot0()
					end
				end)
			else
				slot1()
			end

			if slot0.tmpData.type == ys.Battle.BattleConst.EquipmentType.PREVIEW_ARICRAFT then
				slot0.timer = Timer.New(slot0, 1.5, 1)

				slot0.timer:Start()
			end

			return
		end

		if slot0.characterAction ~= ys.Battle.BattleConst.ActionName.MOVE then
			slot0.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			slot0.seaAnimator:SetAction(slot0.characterAction, 0, true)

			slot1 = 1
		end
	end

	slot2()
end

slot0.MakeBuff = function (slot0, slot1)
	slot4 = getSkillConfig(slot1).effect_list[1].arg_list.time
	slot5 = require("GameCfg.skill.skill_" .. getSkillConfig(slot1).effect_list[1].arg_list.skill_id)

	if slot0.buffTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0.buffTimer)

		slot0.buffTimer = nil
	end

	slot0.buffTimer = pg.TimeMgr.GetInstance():AddBattleTimer("buffTimer", -1, slot4, function ()
		setActive(slot0.healTF, true)
		setText(slot0.healTF:Find("text"), slot1.effect_list[1].arg_list.number)
	end)
end

slot0.MakeWeapon = function (slot0, slot1)
	slot0.weaponList = {}
	slot0.bulletList = {}
	slot0.aircraftList = {}
	slot2 = 0
	slot3 = ys.Battle.BattleConst

	for slot7, slot8 in ipairs(slot1) do
		for slot13, slot14 in ipairs(slot9) do
			if slot14 <= 0 then
				break
			end

			slot2 = slot2 + 1

			if ys.Battle.BattleDataFunction.GetWeaponPropertyDataFromID(slot14).type == slot3.EquipmentType.MAIN_CANNON or slot15.type == slot3.EquipmentType.SUB_CANNON or slot15.type == slot3.EquipmentType.TORPEDO or slot15.type == slot3.EquipmentType.MANUAL_TORPEDO or slot15.type == slot3.EquipmentType.POINT_HIT_AND_LOCK then
				if type(slot15.barrage_ID) == "table" then
					slot0.weaponList[slot2] = {
						tmpData = slot15,
						emitterList = {}
					}

					for slot19, slot20 in ipairs(slot15.barrage_ID) do
						slot0.weaponList[slot2].emitterList[slot19] = slot0:createEmitterCannon(slot20, slot15.bullet_ID[slot19], slot15.spawn_bound)
					end
				end
			elseif slot15.type == slot3.EquipmentType.PREVIEW_ARICRAFT and type(slot15.barrage_ID) == "table" then
				slot0.weaponList[slot2] = {
					tmpData = slot15,
					emitterList = {}
				}

				for slot19, slot20 in ipairs(slot15.barrage_ID) do
					slot0.weaponList[slot2].emitterList[slot19] = slot0:createEmitterAir(slot20, slot15.bullet_ID[slot19], slot15.spawn_bound)
				end
			end
		end
	end
end

slot0.createEmitterCannon = function (slot0, slot1, slot2, slot3)
	function slot4(slot0, slot1, slot2, slot3, slot4)
		slot5 = ys.Battle.BattlePlayerUnit.New(1, ys.Battle.BattleConfig.FRIENDLY_CODE)

		slot5:SetSkinId(slot0.shipVO.skinId)
		slot5:SetTemplate(slot0.shipVO.configId, slot6)

		slot9, slot10 = ys.Battle.BattleDataFunction.CreateBattleBulletData(slot1, slot1, slot5, nil, slot0:GetCharacterOffset() + Vector3(40, 0, 0))

		if slot10 then
			slot0._cldSystem:InitBulletCld(slot9)
		end

		slot9:SetOffsetPriority(slot3)
		slot9:SetShiftInfo(slot0, slot1)
		slot9:SetRotateInfo(nil, 0, slot2)

		if slot0.equipSkinId > 0 then
			slot11 = pg.equip_skin_template[slot0.equipSkinId]
			slot12, slot13, slot14, slot15 = ys.Battle.BattleDataFunction.GetEquipSkin(slot0.equipSkinId)
			slot18 = nil

			if slot9:GetType() == ys.Battle.BattleConst.BulletType.CANNON or slot16 == slot17.BOMB then
				if _.any({
					EquipType.CannonQuZhu,
					EquipType.CannonQingXun,
					EquipType.CannonZhongXun,
					EquipType.CannonZhanlie,
					EquipType.CannonZhongXun2
				}, function (slot0)
					return table.contains(slot0.equip_type, slot0)
				end) then
					slot9.SetModleID(slot9, slot12)
				elseif slot13 and #slot13 > 0 then
					slot9:SetModleID(slot13)
				elseif slot15 and #slot15 > 0 then
					slot9:SetModleID(slot15)
				end
			elseif slot16 == slot17.TORPEDO then
				if table.contains(slot11.equip_type, EquipType.Torpedo) then
					slot9:SetModleID(slot12)
				elseif slot14 and #slot14 > 0 then
					slot9:SetModleID(slot14)
				end
			end
		end

		slot13 = nil

		(slot9:GetType() ~= ys.Battle.BattleConst.BulletType.CANNON or ys.Battle.BattleCannonBullet.New()) and (slot11 ~= slot12.BOMB or ys.Battle.BattleBombBullet.New()) and (slot11 ~= slot12.TORPEDO or ys.Battle.BattleTorpedoBullet.New()) and ys.Battle.BattleBullet.New():SetBulletData(slot9)
		table.insert(slot0.bulletUnitList, slot9)

		function slot14(slot0)
			slot0:SetGO(slot0)
			slot0:AddRotateScript()

			if tf(slot0).parent then
				tf(slot0).parent = nil
			end

			slot0:SetSpawn(slot1.boneList[slot2] or Vector3.zero:GetCharacterOffset() + (slot1.boneList[slot2] or Vector3.zero))

			if slot1.boneList[slot2] or Vector3.zero.bulletList then
				table.insert(slot1.bulletList, slot0)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance().InstBullet(slot15, (slot9.GetType() ~= ys.Battle.BattleConst.BulletType.CANNON or ys.Battle.BattleCannonBullet.New()) and (slot11 ~= slot12.BOMB or ys.Battle.BattleBombBullet.New()) and (slot11 ~= slot12.TORPEDO or ys.Battle.BattleTorpedoBullet.New()) and ys.Battle.BattleBullet.New():GetModleID(), function (slot0)
			slot0(slot0)
		end)
	end

	return ys.Battle.BattleBulletEmitter.New(slot4, function ()
		return
	end, slot1)
end

slot0.createEmitterAir = function (slot0, slot1, slot2, slot3)
	function slot4(slot0, slot1, slot2, slot3, slot4)
		slot5 = {
			id = slot0,
			tmpData = pg.aircraft_template[slot0]
		}
		slot8 = Vector3(math.cos(slot7), 0, math.sin(slot7))

		function slot9(slot0)
			slot1 = slot0:GetCharacterOffset()
			slot0.transform.localPosition = slot1 + Vector3(slot1.position_offset[1] + slot2, slot1.position_offset[2], slot1.position_offset[3] + slot1.position_offset[1] + slot2)
			slot4 = Vector3(0.1, 0.1, 0.1)
			slot0.transform.localScale = slot4
			slot4.obj = slot0
			slot4.tf = slot0.transform
			slot4.pos = slot1 + Vector3(slot1.position_offset[1] + slot2, slot1.position_offset[2], slot1.position_offset[3] + slot1.position_offset[1] + slot2)
			slot0.transform.baseVelocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(slot4.tmpData.speed)
			ys.Battle.BattleFormulas.ConvertAircraftSpeed(slot4.tmpData.speed).speed = slot4.tmpData.speed * slot4.baseVelocity
			slot4.tmpData.speed * slot4.baseVelocity.speedZ = (math.random() - 0.5) * 0.5
			(math.random() - 0.5) * 0.5.targetZ = slot1.z

			if slot0.aircraftList then
				table.insert(slot0.aircraftList, )
			end
		end

		slot10 = pg.aircraft_template[slot0].model_ID

		if slot1.equipSkinId > 0 and table.contains(pg.equip_skin_template[slot1.equipSkinId].equip_type, ({
			EquipType.FighterAircraft,
			EquipType.TorpedoAircraft,
			EquipType.BomberAircraft
		})[slot6.type]) then
			slot13 = ys.Battle.BattleDataFunction.GetEquipSkin(slot1.equipSkinId)
			slot10 = slot13
		end

		ys.Battle.BattleResourceManager.GetInstance():InstAirCharacter(slot10, function (slot0)
			slot0(slot0)
		end)
	end

	return ys.Battle.BattleBulletEmitter.New(slot4, function ()
		return
	end, slot1)
end

slot0.RemoveBullet = function (slot0, slot1, slot2)
	table.remove(slot0.bulletUnitList, slot1)
	Object.Destroy(slot0.bulletList[slot1]._go)
	table.remove(slot0.bulletList, slot1)

	if slot2 and slot3:GetMissFXID() and slot4 ~= "" then
		slot9, slot6 = slot0.seaFXPool:GetFX(slot4)

		pg.EffectMgr.GetInstance():PlayBattleEffect(slot5, slot3:GetPosition() + slot6, true)
	end
end

slot0.SeaUpdate = function (slot0)
	if not slot0.bulletList then
		return
	end

	slot1 = 0
	slot2 = -20
	slot3 = 60
	slot4 = 0
	slot5 = 60
	slot6 = ys.Battle.BattleConfig
	slot7 = ys.Battle.BattleConst

	pg.TimeMgr.GetInstance().AddBattleTimer(slot9, "barrageUpdateTimer", -1, 0.033, function ()
		for slot3 = #slot0.bulletUnitList, 1, -1 do
			slot0._cldSystem:UpdateBulletCld(slot0.bulletUnitList[slot3])
		end

		for slot3 = #slot0.bulletList, 1, -1 do
			slot5 = slot0.bulletList[slot3]._bulletData:GetSpeed()()

			if (slot1 < slot0.bulletList[slot3].GetPosition(slot4).x and slot5.x > 0) or (slot6.z < slot2 and slot5.z < 0) then
				slot0:RemoveBullet(slot3, false)
			elseif slot6.x < slot3 and slot5.x < 0 and slot4:GetType() ~= slot4.BulletType.BOMB then
				slot0:RemoveBullet(slot3, false)
			else
				slot4._bulletData:Update(slot7)
				slot4:Update(slot5)

				if (slot6 < slot6.z and slot5.z > 0) or slot4._bulletData:IsOutRange(slot5) then
					slot0:RemoveBullet(slot3, true)
				end
			end
		end

		for slot3, slot4 in ipairs(slot0.aircraftList) do
			if slot4.pos + slot4.speed.y < slot7.AircraftHeight + 5 then
				slot4.speed.y = math.max(0.4, 1 - slot5.y / slot7.AircraftHeight)
				slot6 = math.min(1, slot5.y / slot7.AircraftHeight)
				slot4.tf.localScale = Vector3(slot6, slot6, slot6)
			end

			slot4.speed.z = slot4.baseVelocity * slot4.speedZ

			if slot4.baseVelocity < slot4.targetZ - slot5.z then
				slot4.speed.z = slot4.baseVelocity * 0.5
			elseif slot6 < -slot4.baseVelocity then
				slot4.speed.z = -slot4.baseVelocity * 0.5
			else
				slot4.targetZ = slot0:GetCharacterOffset().z + slot0.GetCharacterOffset().z * (math.random() - 0.5) * 0.6
			end

			if slot1 < slot5.x or slot5.x < slot3 then
				Object.Destroy(slot4.obj)
				table.remove(slot0.aircraftList, slot3)
			else
				slot4.tf.localPosition = slot5
				slot4.pos = slot5
			end
		end

		slot5 = slot5 + 1
	end)
end

slot0.GetCharacterOffset = function (slot0)
	return Vector3(0, -3, 40)
end

slot0.GetTotalBounds = function (slot0)
	return ({
		-70,
		20,
		90,
		70
	})[2] + ()[4], ()[2], ()[1], ()[1] + ()[3]
end

slot0.HandleShipCrashDecelerate = function (slot0)
	return
end

slot0.HandleShipCrashDecelerate = function (slot0)
	return
end

slot0.HandleShipCrashDamageList = function (slot0)
	return
end

slot0.HandleBulletHit = function (slot0, slot1, slot2)
	for slot6 = #slot0.bulletUnitList, 1, -1 do
		if slot0.bulletUnitList[slot6] == slot1 then
			slot0:RemoveBullet(slot6, true)
		end
	end

	if not slot0.isFinish then
		slot0.isFinish = true

		setActive(slot0.seaEmeny, false)

		slot7, slot9 = ys.Battle.BattleFXPool.GetInstance():GetFX("Bomb")

		pg.EffectMgr.GetInstance():PlayBattleEffect(slot3, slot4:Add(slot2:GetPosition()), true)
	end
end

slot0.HandleWallHitByBullet = function (slot0)
	return
end

slot0.GetUnitList = function (slot0)
	return slot0.unitList
end

slot0.GetAircraftList = function (slot0)
	return {}
end

slot0.GetBulletList = function (slot0)
	return slot0.bulletUnitList
end

slot0.GetAOEList = function (slot0)
	return {}
end

slot0.GetFriendlyCode = function (slot0)
	return 1
end

slot0.GetFoeCode = function (slot0)
	return -1
end

slot0.clear = function (slot0)
	if slot0.animTimer then
		slot0.animTimer:Stop()

		slot0.animTimer = nil
	end

	if slot0._cldSystem then
		slot0._cldSystem:Dispose()
	end

	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end

	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()

	if slot0.seaCharacter then
		Destroy(slot0.seaCharacter)

		slot0.seaCharacter = nil
	end

	if slot0.otherShipGos then
		for slot4, slot5 in ipairs(slot0.otherShipGos) do
			Destroy(slot5)
		end

		slot0.otherShipGos = nil
	end

	if slot0.aircraftList then
		for slot4, slot5 in ipairs(slot0.aircraftList) do
			Destroy(slot5.obj)
		end

		slot0.aircraftList = nil
	end

	if slot0.seaView then
		slot0.seaView:Dispose()

		slot0.seaView = nil
	end

	if slot0.weaponList then
		for slot4, slot5 in ipairs(slot0.weaponList) do
			for slot9, slot10 in ipairs(slot5.emitterList) do
				slot10:Destroy()
			end
		end

		slot0.weaponList = nil
	end

	if slot0.bulletList then
		for slot4, slot5 in ipairs(slot0.bulletList) do
			Destroy(slot5._go)
		end

		slot0.bulletList = nil
	end

	if slot0.seaFXPool then
		slot0.seaFXPool:Clear()

		slot0.seaFXPool = nil
	end

	if slot0.seaEmeny then
		Destroy(slot0.seaEmeny)

		slot0.seaEmeny = nil
	end

	if slot0.seaItemBox then
		Destroy(slot0.seaItemBox)

		slot0.seaItemBox = nil
	end

	if slot0.seaFXContainersPool then
		slot0.seaFXContainersPool:Clear()

		slot0.seaFXContainersPool = nil
	end

	ys.Battle.BattleResourceManager.GetInstance().Clear(slot1)

	slot0.seaCameraGO.tag = "Untagged"
	slot0.seaCameraGO = nil
	slot0.seaCamera = nil

	slot0.mainCameraGO:SetActive(true)

	slot0.mainCameraGO = nil
	slot0.loaded = false

	if slot0.palyAnimTimer then
		slot0.palyAnimTimer:Stop()

		slot0.palyAnimTimer = nil
	end
end

return slot0

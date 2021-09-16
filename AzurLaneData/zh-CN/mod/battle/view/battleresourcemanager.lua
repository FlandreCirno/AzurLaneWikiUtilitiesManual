ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = ys.Battle.BattleConst
slot3 = ys.Battle.BattleConfig
slot4 = require("Mgr/Pool/PoolUtil")
slot5 = singletonClass("BattleResourceManager")
ys.Battle.BattleResourceManager = slot5
slot5.__name = "BattleResourceManager"

slot5.Ctor = function (slot0)
	slot0.rotateScriptMap = setmetatable({}, {
		__mode = "kv"
	})
end

slot5.Init = function (slot0)
	slot0._preloadList = {}
	slot0._resCacheList = {}
	slot0._allPool = {}
	slot0._ob2Pool = {}
	slot0._shaders = {}
	slot1 = GameObject()

	slot1:SetActive(false)

	slot1.name = "PoolRoot"
	slot1.transform.position = Vector3(-10000, -10000, 0)
	slot0._poolRoot = slot1
	slot0._bulletContainer = GameObject("BulletContainer")
	slot0._battleCVList = {}
end

slot5.Clear = function (slot0)
	for slot4, slot5 in pairs(slot0._allPool) do
		slot5:Dispose()
	end

	for slot4, slot5 in pairs(slot0._resCacheList) do
		if string.find(slot4, "Char/") then
			slot0.ClearCharRes(slot4, slot5)
		elseif string.find(slot4, "painting/") then
			slot0.ClearPaintingRes(slot4, slot5)
		else
			slot1.Destroy(slot5)
		end
	end

	slot0._resCacheList = {}
	slot0._ob2Pool = {}
	slot0._allPool = {}
	slot0._shaders = {}

	Object.Destroy(slot0._poolRoot)

	slot0._poolRoot = nil

	Object.Destroy(slot0._bulletContainer)

	slot0._bulletContainer = nil
	slot0.rotateScriptMap = setmetatable({}, {
		__mode = "kv"
	})

	for slot4, slot5 in pairs(slot0._battleCVList) do
		pg.CriMgr.UnloadCVBank(slot5)
	end

	slot0._battleCVList = {}

	slot2.Battle.BattleDataFunction.ClearConvertedBarrage()
end

slot5.GetBulletPath = function (slot0)
	return "Item/" .. slot0
end

slot5.GetCharacterPath = function (slot0)
	return "Char/" .. slot0
end

slot5.GetCharacterGoPath = function (slot0)
	return "chargo/" .. slot0
end

slot5.GetAircraftIconPath = function (slot0)
	return "AircraftIcon/" .. slot0
end

slot5.GetFXPath = function (slot0)
	return "Effect/" .. slot0
end

slot5.GetPaintingPath = function (slot0)
	return "painting/" .. slot0
end

slot5.GetHrzIcon = function (slot0)
	return "herohrzicon/" .. slot0
end

slot5.GetSquareIcon = function (slot0)
	return "squareicon/" .. slot0
end

slot5.GetQIcon = function (slot0)
	return "qicon/" .. slot0
end

slot5.GetCommanderHrzIconPath = function (slot0)
	return "commanderhrz/" .. slot0
end

slot5.GetShipTypeIconPath = function (slot0)
	return "shiptype/" .. slot0
end

slot5.GetMapPath = function (slot0)
	return "Map/" .. slot0
end

slot5.GetUIPath = function (slot0)
	return "UI/" .. slot0
end

slot5.GetResName = function (slot0)
	slot2 = string.find(slot0, "%/")

	while slot2 do
		slot2 = string.find(string.sub(slot1, slot2 + 1), "%/")
	end

	return slot1
end

slot5.ClearCharRes = function (slot0, slot1)
	slot3 = slot1:GetComponent("SkeletonRenderer").skeletonDataAsset

	if not PoolMgr.GetInstance():IsSpineSkelCached(slot0:GetResName()) then
		UIUtil.ClearSharedMaterial(slot1)
	end

	slot1:Destroy()
end

slot5.ClearPaintingRes = function (slot0, slot1)
	PoolMgr.GetInstance():ReturnPainting(slot0:GetResName(), slot1)
end

slot5.DestroyOb = function (slot0, slot1)
	if slot0._ob2Pool[slot1] then
		slot2:Recycle(slot1)
	else
		slot0.Destroy(slot1)
	end
end

slot5.popPool = function (slot0, slot1, slot2)
	slot3 = slot1:GetObject()

	if not slot2 then
		slot3.transform.parent = nil
	end

	slot0._ob2Pool[slot3] = slot1

	return slot3
end

slot5.InstCharacter = function (slot0, slot1, slot2)
	if slot0._allPool[slot0.GetCharacterPath(slot1)] then
		slot2(slot0:popPool(slot4))
	elseif slot0._resCacheList[slot3] ~= nil then
		slot0:InitPool(slot3, slot0._resCacheList[slot3], function ()
			slot0 = slot1._allPool[slot2]

			slot3(slot2:popPool(slot2.popPool))
		end)
	else
		slot0.LoadSpineAsset(slot0, slot1, function (slot0)
			if not slot0._poolRoot then
				slot1.ClearCharRes(slot2, slot0)

				return
			end

			slot1 = SpineAnim.AnimChar(slot3, slot0)

			slot1:SetActive(false)
			slot0:InitPool(slot0.InitPool, slot1, function ()
				slot0 = slot1._allPool[slot2]

				slot3(slot2:popPool(slot2.popPool))
			end)
		end)
	end
end

slot5.LoadSpineAsset = function (slot0, slot1, slot2)
	slot3 = slot0.GetCharacterPath(slot1)

	if not PoolMgr.GetInstance():IsSpineSkelCached(slot1) then
		ResourceMgr.Inst:getAssetAsync(slot3, slot1 .. "_SkeletonData", UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			slot0(slot0)
		end), true, true)
	else
		PoolMgr.GetInstance().GetSpineSkel(slot4, slot1, true, slot2)
	end
end

slot5.InstAirCharacter = function (slot0, slot1, slot2)
	if slot0._allPool[slot0.GetCharacterGoPath(slot1)] then
		slot2(slot0:popPool(slot4))
	elseif slot0._resCacheList[slot3] ~= nil then
		slot0:InitPool(slot3, slot0._resCacheList[slot3], function ()
			slot0 = slot1._allPool[slot2]

			slot3(slot2:popPool(slot2.popPool))
		end)
	else
		ResourceMgr.Inst.getAssetAsync(slot5, slot3, slot1, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			if not slot0._poolRoot then
				slot1.Destroy(slot0)

				return
			else
				slot0:InitPool(slot0, slot0, function ()
					slot0 = slot1._allPool[slot2]

					slot3(slot2:popPool(slot2.popPool))
				end)
			end
		end), true, true)
	end
end

slot5.InstBullet = function (slot0, slot1, slot2)
	if slot0._allPool[slot0.GetBulletPath(slot1)] then
		slot5 = slot0:popPool(slot4, true)

		if string.find(slot1, "_trail") and slot5:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) then
			slot6:Clear()
		end

		slot2(slot5)

		return true
	elseif slot0._resCacheList[slot3] ~= nil then
		slot0:InitPool(slot3, slot0._resCacheList[slot3], function ()
			slot0 = slot1._allPool[slot2]
			slot0 = slot2:popPool(slot2.popPool, true)

			if string.find(true, "_trail") and slot0:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) then
				slot1:Clear()
			end

			slot4(slot0)
		end)

		return true
	else
		ResourceMgr.Inst.getAssetAsync(slot5, slot3, slot1, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			if slot0._poolRoot then
				slot1.Destroy(slot0)

				return
			else
				slot0:InitPool(slot0, slot0, function ()
					slot0 = slot1._allPool[slot2]

					true(slot2:popPool(slot2.popPool, true))
				end)
			end
		end), true, true)

		return false
	end
end

slot5.InstFX = function (slot0, slot1)
	slot3 = nil

	if slot0._allPool[slot0.GetFXPath(slot1)] then
		slot3 = slot0:popPool(slot4)
	elseif slot0._resCacheList[slot2] ~= nil then
		slot0:InitPool(slot2, slot0._resCacheList[slot2])

		slot3 = slot0:popPool(slot0._allPool[slot2])
	else
		ResourceMgr.Inst:getAssetAsync(slot2, slot1, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			if not slot0._poolRoot then
				slot1.Destroy(slot0)

				return
			else
				slot0:InitPool(slot0, slot0)
			end
		end), true, true)
		GameObject(slot1 .. "临时假obj"):SetActive(false)

		slot0._resCacheList[slot2] = GameObject(slot1 .. "临时假obj")
	end

	return slot3
end

slot5.InstSkillPaintingUI = function (slot0)
	slot0._ob2Pool[slot0._allPool["UI/SkillPainting"].GetObject(slot1)] = slot0._allPool["UI/SkillPainting"]

	return slot0._allPool["UI/SkillPainting"].GetObject(slot1)
end

slot5.InstBossWarningUI = function (slot0)
	slot0._ob2Pool[slot0._allPool["UI/MonsterAppearUI"].GetObject(slot1)] = slot0._allPool["UI/MonsterAppearUI"]

	return slot0._allPool["UI/MonsterAppearUI"].GetObject(slot1)
end

slot5.InstPainting = function (slot0, slot1)
	slot3 = nil

	if slot0._allPool[slot0.GetPaintingPath(slot1)] then
		slot0._ob2Pool[slot4:GetObject()] = slot4
	elseif slot0._resCacheList[slot2] ~= nil then
		Object.Instantiate(slot0._resCacheList[slot2]):SetActive(true)
	end

	return slot3
end

slot5.InstMap = function (slot0, slot1)
	slot3 = nil

	if slot0._allPool[slot0.GetMapPath(slot1)] then
		slot0._ob2Pool[slot4:GetObject()] = slot4
	elseif slot0._resCacheList[slot2] ~= nil then
		slot3 = Object.Instantiate(slot0._resCacheList[slot2])
	end

	slot3:SetActive(true)

	return slot3
end

slot5.GetCharacterIcon = function (slot0, slot1)
	return slot0._resCacheList[slot0.GetHrzIcon(slot1)]
end

slot5.GetCharacterSquareIcon = function (slot0, slot1)
	return slot0._resCacheList[slot0.GetSquareIcon(slot1)]
end

slot5.GetCharacterQIcon = function (slot0, slot1)
	return slot0._resCacheList[slot0.GetQIcon(slot1)]
end

slot5.GetAircraftIcon = function (slot0, slot1)
	return slot0._resCacheList[slot0.GetAircraftIconPath(slot1)]
end

slot5.GetShipTypeIcon = function (slot0, slot1)
	return slot0._resCacheList[slot0.GetShipTypeIconPath(slot1)]
end

slot5.GetCommanderHrzIcon = function (slot0, slot1)
	return slot0._resCacheList[slot0.GetCommanderHrzIconPath(slot1)]
end

slot5.GetShader = function (slot0, slot1)
	return slot0._shaders[slot1]
end

slot5.AddPreloadResource = function (slot0, slot1)
	if type(slot1) == "string" then
		slot0._preloadList[slot1] = false
	elseif type(slot1) == "table" then
		for slot5, slot6 in ipairs(slot1) do
			slot0._preloadList[slot6] = false
		end
	end
end

slot5.AddPreloadCV = function (slot0, slot1)
	if ShipWordHelper.RawGetCVKey(slot1) > 0 then
		slot0._battleCVList[slot2] = pg.CriMgr.GetBattleCVBankName(slot2)
	end
end

slot5.StartPreload = function (slot0, slot1, slot2)
	slot3 = 0
	slot4 = 0

	for slot8, slot9 in pairs(slot0._preloadList) do
		slot4 = slot4 + 1
	end

	for slot8, slot9 in pairs(slot0._battleCVList) do
		slot4 = slot4 + 1
	end

	for slot8, slot9 in pairs(slot0.BATTLE_SHADER) do
		slot4 = slot4 + 1
	end

	function slot5()
		if not slot0._poolRoot then
			return
		end

		if slot2 < slot1 + 1 then
			return
		end

		if slot3 then
			slot3(slot1)
		end

		if slot1 == slot2 then
			slot0._preloadList = nil

			slot4()
		end
	end

	for slot9, slot10 in pairs(slot0._battleCVList) do
		pg.CriMgr.LoadBattleCV(slot11, slot9, slot5)
	end

	for slot9, slot10 in pairs(slot0.BATTLE_SHADER) do
		ResourceMgr.Inst:LoadAssetAsync(pg.ShaderMgr.GetInstance().shaders, slot10, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			slot0._shaders[] = slot0

			slot0._shaders()
		end), false, false)
	end

	for slot9, slot10 in pairs(slot0._preloadList) do
		if slot0.GetResName(slot9) == "" or slot0._resCacheList[slot9] ~= nil then
			slot5()
		elseif string.find(slot9, "herohrzicon/") or string.find(slot9, "qicon/") or string.find(slot9, "squareicon/") or string.find(slot9, "commanderhrz/") or string.find(slot9, "AircraftIcon/") then
			ResourceMgr.Inst:getAssetAsync(slot9, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
				if slot0 == nil then
					print("资源预加载失败，检查以下目录：>>" .. slot0 .. "<<")
				else
					if not slot1._poolRoot then
						slot2.Destroy(slot0)

						return
					end

					if slot1._resCacheList then
						slot1._resCacheList[slot0] = slot0
					end
				end

				slot3()
			end), true, true)
		elseif string.find(slot9, "shiptype/") then
			ResourceMgr.Inst:getAssetAsync("shiptype", string.split(slot9, "/")[2], typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
				if slot0 == nil then
					print("资源预加载失败，检查以下目录：>>" .. slot0 .. "<<")
				else
					if not slot1._poolRoot then
						slot2.Destroy(slot0)

						return
					end

					if slot1._resCacheList then
						slot1._resCacheList[slot0] = slot0
					end
				end

				slot3()
			end), true, true)
		elseif string.find(slot9, "painting/") then
			slot12 = false

			PoolMgr.GetInstance():GetPainting(slot11 .. (((PlayerPrefs.GetInt(BATTLE_HIDE_BG, 1) <= 0 or PathMgr.FileExists(PathMgr.getAssetBundle("painting/" .. slot11 .. "_n"))) and PlayerPrefs.GetInt("paint_hide_other_obj_" .. slot11, 0) ~= 0 and "_n") or ""), true, function (slot0)
				if slot0 == nil then
					print("资源预加载失败，检查以下目录：>>" .. slot0 .. "<<")
				else
					if not slot1._poolRoot then
						slot2.ClearPaintingRes(slot0, slot0)

						return
					end

					ShipExpressionHelper.SetExpression(slot0, slot3)
					slot0:SetActive(false)

					if slot0.SetActive._resCacheList then
						slot1._resCacheList[slot0] = slot0
					end
				end

				slot4()
			end)
		elseif string.find(slot9, "Char/") then
			slot0:LoadSpineAsset(slot11, function (slot0)
				if slot0 == nil then
					print("资源预加载失败，检查以下目录：>>" .. slot0 .. "<<")
				else
					slot0 = SpineAnim.AnimChar(SpineAnim.AnimChar, slot0)

					if not slot2._poolRoot then
						slot3.ClearCharRes(slot0, slot0)

						return
					end

					slot0:SetActive(false)

					if slot2._resCacheList then
						slot2._resCacheList[slot0] = slot0
					end
				end

				slot2:InitPool(slot0, slot0, function ()
					slot0()
				end)
			end)
		elseif string.find(slot9, "UI/") then
			LoadAndInstantiateAsync("UI", slot11, function (slot0)
				if slot0 == nil then
					print("资源预加载失败，检查以下目录：>>" .. slot0 .. "<<")
				else
					if not slot1._poolRoot then
						slot2.Destroy(slot0)

						return
					end

					slot0:SetActive(false)

					if slot0.SetActive._resCacheList then
						slot1._resCacheList[slot0] = slot0
					end
				end

				slot1:InitPool(slot0, slot0, function ()
					slot0()
				end)
			end, true, true)
		else
			ResourceMgr.Inst.getAssetAsync(slot12, slot9, slot11, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
				if slot0 == nil then
					print("资源预加载失败，检查以下目录：>>" .. slot0 .. "<<")
				else
					if not slot1._poolRoot then
						slot2.Destroy(slot0)

						return
					end

					if slot1._resCacheList then
						slot1._resCacheList[slot0] = slot0
					end
				end

				slot1:InitPool(slot0, slot0, function ()
					slot0()
				end)
			end), true, true)
		end
	end

	return slot4
end

slot6 = Vector3(0, 10000, 0)

slot5.HideBullet = function (slot0)
	slot0.transform.position = slot0
end

slot5.InitParticleSystemCB = function (slot0)
	pg.EffectMgr.GetInstance():CommonEffectEvent(slot0)
end

slot5.InitPool = function (slot0, slot1, slot2, slot3)
	slot4 = slot0._poolRoot.transform

	if string.find(slot1, "Item/") then
		if slot2:GetComponentInChildren(typeof(UnityEngine.TrailRenderer)) ~= nil or slot2:GetComponentInChildren(typeof(ParticleSystem)) ~= nil then
			if slot3 ~= nil then
				slot0._allPool[slot1] = pg.Pool.New(slot0._bulletContainer.transform, slot2, 15, 20, true, false):InitSizeAsync(slot3)
			else
				slot0._allPool[slot1] = pg.Pool.New(slot0._bulletContainer.transform, slot2, 15, 20, true, false):InitSize()
			end
		else
			pg.Pool.New(slot0._bulletContainer.transform, slot2, 20, 20, true, true):SetRecycleFuncs(slot0.HideBullet)

			if slot3 ~= nil then
				slot0._allPool[slot1] = slot5

				slot5:InitSizeAsync(slot3)
			else
				slot5:InitSize()

				slot0._allPool[slot1] = slot5
			end
		end
	elseif string.find(slot1, "Effect/") then
		if slot2:GetComponent(typeof(UnityEngine.ParticleSystem)) then
			slot5 = 5

			if string.find(slot1, "smoke") and not string.find(slot1, "smokeboom") then
				slot5 = 30
			elseif string.find(slot1, "feijiyingzi") then
				slot5 = 1
			end

			pg.Pool.New(slot4, slot2, slot5, 20, false, false):SetInitFuncs(slot0.InitParticleSystemCB)

			if slot3 ~= nil then
				slot0._allPool[slot1] = slot6

				slot6:InitSizeAsync(slot3)
			else
				slot6:InitSize()

				slot0._allPool[slot1] = slot6
			end
		else
			slot5 = 8

			if string.find(slot1, "AntiAirArea") or string.find(slot1, "AntiSubArea") then
				slot5 = 1
			end

			GetOrAddComponent(slot2, typeof(ParticleSystemEvent))

			slot6 = pg.Pool.New(slot4, slot2, slot5, 20, false, false)

			if slot3 ~= nil then
				slot0._allPool[slot1] = slot6

				slot6:InitSizeAsync(slot3)
			else
				slot6:InitSize()

				slot0._allPool[slot1] = slot6
			end
		end
	elseif string.find(slot1, "Char/") then
		slot5 = 1

		if string.find(slot1, "danchuan") then
			slot5 = 3
		end

		if slot3 ~= nil then
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, slot5, 20, false, false):InitSizeAsync(slot3)
		else
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, slot5, 20, false, false):InitSize()
		end
	elseif string.find(slot1, "chargo/") then
		if slot3 ~= nil then
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, 3, 20, false, false):InitSizeAsync(slot3)
		else
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, 3, 20, false, false):InitSize()
		end
	elseif slot1 == "UI/SkillPainting" then
		if slot3 ~= nil then
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, 1, 20, false, false):InitSizeAsync(slot3)
		else
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, 1, 20, false, false):InitSize()
		end
	elseif slot1 == "UI/MonsterAppearUI" then
		if slot3 ~= nil then
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, 1, 20, false, false):InitSizeAsync(slot3)
		else
			slot0._allPool[slot1] = pg.Pool.New(slot4, slot2, 1, 20, false, false):InitSize()
		end
	elseif slot1 == "UI/CombatHPBar" then
		slot1.Battle.BattleHPBarManager.GetInstance():Init(slot2, slot4)

		if slot3 ~= nil then
			slot3()
		end
	elseif slot1 == "UI/CombatHPPop" then
		slot1.Battle.BattlePopNumManager.GetInstance():Init(slot2, slot4)

		if slot3 ~= nil then
			slot3()
		end
	elseif slot3 ~= nil then
		slot3()
	end
end

slot5.GetRotateScript = function (slot0, slot1, slot2)
	if slot0.rotateScriptMap[slot1] then
		return slot3[slot1]
	end

	slot3[slot1] = GetOrAddComponent(slot1, "BulletRotation")

	return GetOrAddComponent(slot1, "BulletRotation")
end

slot5.GetCommonResource = function ()
	return {
		slot0.GetMapPath("visionLine"),
		slot0.GetMapPath("exposeLine"),
		slot0.GetFXPath(slot1.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		slot0.GetFXPath(slot1.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		slot0.GetFXPath(slot1.Battle.BattleBossCharacterFactory.BOMB_FX_NAME),
		slot0.GetFXPath(slot1.Battle.BattleAircraftCharacterFactory.BOMB_FX_NAME),
		slot0.GetFXPath("AlertArea"),
		slot0.GetFXPath("TorAlert"),
		slot0.GetFXPath("SquareAlert"),
		slot0.GetFXPath("AntiAirArea"),
		slot0.GetFXPath("AntiSubArea"),
		slot0.GetFXPath("shock"),
		slot0.GetFXPath("qianting_chushui"),
		slot0.GetFXPath("qianting_chushui".PLAYER_SUB_BUBBLE_FX),
		slot0.GetFXPath("weaponrange"),
		slot0.GetUIPath("SkillPainting"),
		slot0.GetUIPath("MonsterAppearUI"),
		slot0.GetUIPath("CombatHPBar"),
		slot0.GetUIPath("CombatHPPop")
	}
end

slot5.GetDisplayCommonResource = function ()
	return {
		slot0.GetFXPath(slot1.Battle.BattleCharacterFactory.MOVE_WAVE_FX_NAME),
		slot0.GetFXPath(slot1.Battle.BattleCharacterFactory.BOMB_FX_NAME),
		slot0.GetFXPath(slot1.Battle.BattleCharacterFactory.DANCHUAN_MOVE_WAVE_FX_NAME)
	}
end

slot5.GetMapResource = function (slot0)
	slot1 = {}

	for slot6, slot7 in ipairs(slot0.Battle.BattleMap.LAYERS) do
		for slot12, slot13 in ipairs(slot8) do
			slot1[#slot1 + 1] = slot1.GetMapPath(slot13)
		end
	end

	return slot1
end

slot5.GetBuffResource = function ()
	slot0 = {}

	for slot5, slot6 in ipairs(slot1) do
		slot0[#slot0 + 1] = slot0.GetFXPath(slot6)
	end

	return slot0
end

slot5.GetShipResource = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = slot0:GetPlayerShipTmpDataFromID()

	if slot1 == nil or slot1 == 0 then
		slot1 = slot4.skin_id
	end

	slot5 = slot0.GetPlayerShipSkinDataFromID(slot1)
	slot3[#slot3 + 1] = slot1.GetCharacterPath(slot5.prefab)
	slot3[#slot3 + 1] = slot1.GetHrzIcon(slot5.painting)
	slot3[#slot3 + 1] = slot1.GetQIcon(slot5.painting)
	slot3[#slot3 + 1] = slot1.GetSquareIcon(slot5.painting)

	if slot2 and slot0.GetShipTypeTmp(slot4.type).team_type == TeamType.Main then
		slot3[#slot3 + 1] = slot1.GetPaintingPath(slot5.painting)
	end

	return slot3
end

slot5.GetEnemyResource = function (slot0)
	slot3 = slot0.bossData ~= nil
	slot4 = slot0.buffList or {}
	slot5 = slot0.phase or {}

	for slot10, slot11 in ipairs(slot6.appear_fx) do
		slot1[#slot1 + 1] = slot1.GetFXPath(slot11)
	end

	for slot10, slot11 in ipairs(slot6.smoke) do
		for slot16, slot17 in ipairs(slot12) do
			slot1[#slot1 + 1] = slot1.GetFXPath(slot17[1])
		end
	end

	if type(slot6.bubble_fx) == "table" then
		slot1[#slot1 + 1] = slot1.GetFXPath(slot6.bubble_fx[1])
	end

	function slot7(slot0)
		for slot5, slot6 in pairs(slot0.Battle.BattleDataFunction.GetBuffTemplate(slot0, 1).effect_list) do
			if slot6.arg_list.skill_id then
				if slot0.Battle.BattleDataFunction.GetSkillTemplate(slot7).painting == 1 then
					slot1[#slot1 + 1] = slot2.GetHrzIcon(slot3.icon)
				elseif type(slot9) == "string" then
					slot1[#slot1 + 1] = slot2.GetHrzIcon(slot9)
				end
			end

			if slot6.arg_list.buff_id then
				slot4(slot8)
			end
		end
	end

	for slot11, slot12 in ipairs(slot4) do
		slot7(slot12)
	end

	for slot11, slot12 in ipairs(slot5) do
		if slot12.addBuff then
			for slot16, slot17 in ipairs(slot12.addBuff) do
				slot7(slot17)
			end
		end
	end

	if slot3 then
		slot1[#slot1 + 1] = slot1.GetSquareIcon(slot6.icon)
	end

	return slot1
end

slot5.GetWeaponResource = function (slot0, slot1)
	slot2 = {}

	if slot0 == -1 then
		return slot2
	end

	if slot0:GetWeaponPropertyDataFromID().type == slot1.EquipmentType.MAIN_CANNON or slot3.type == slot1.EquipmentType.SUB_CANNON or slot3.type == slot1.EquipmentType.TORPEDO or slot3.type == slot1.EquipmentType.ANTI_AIR or slot3.type == slot1.EquipmentType.ANTI_SEA or slot3.type == slot1.EquipmentType.POINT_HIT_AND_LOCK or slot3.type == slot1.EquipmentType.BOMBER_PRE_CAST_ALERT or slot3.type == slot1.EquipmentType.DEPTH_CHARGE or slot3.type == slot1.EquipmentType.MANUAL_TORPEDO or slot3.type == slot1.EquipmentType.DISPOSABLE_TORPEDO or slot3.type == slot1.EquipmentType.MANUAL_AAMISSILE or slot3.type == slot1.EquipmentType.BEAM or slot3.type == slot1.EquipmentType.SPACE_LASER or slot3.type == slot1.EquipmentType.MISSILE then
		for slot7, slot8 in ipairs(slot3.bullet_ID) do
			for slot13, slot14 in ipairs(slot9) do
				slot2[#slot2 + 1] = slot14
			end
		end
	elseif slot3.type == slot1.EquipmentType.SCOUT or slot3.type == slot1.EquipmentType.PASSIVE_SCOUT then
		slot2 = slot2.GetAircraftResource(slot0, nil, slot1)
	elseif slot3.type == slot1.EquipmentType.PREVIEW_ARICRAFT then
		for slot7, slot8 in ipairs(slot3.bullet_ID) do
			slot2 = slot2.GetAircraftResource(slot8, nil, slot1)
		end
	end

	slot2[#slot2 + 1] = slot2.GetFXPath(slot3.fire_fx)

	if slot3.precast_param.fx then
		slot2[#slot2 + 1] = slot2.GetFXPath(slot3.precast_param.fx)
	end

	return slot2
end

slot5.GetEquipResource = function (slot0, slot1, slot2)
	slot3 = {}

	if slot1 ~= 0 then
		if slot0.Battle.BattleDataFunction.GetEquipSkinDataFromID(slot1).ship_skin_id ~= 0 then
			slot3[#slot3 + 1] = slot1.GetCharacterPath(slot0.Battle.BattleDataFunction.GetPlayerShipSkinDataFromID(slot5).prefab)
		end

		if slot4.attachment_combat_scene ~= "" then
			slot3[#slot3 + 1] = slot1.GetFXPath(slot6)
		end
	end

	for slot9, slot10 in ipairs(slot5) do
		for slot15, slot16 in ipairs(slot11) do
			slot3[#slot3 + 1] = slot16
		end
	end

	for slot10, slot11 in ipairs(slot6) do
		if slot2 then
			slot11 = slot0.Battle.BattleDataFunction.SkillTranform(slot2, slot11) or slot11
		end

		for slot16, slot17 in ipairs(slot12) do
			slot3[#slot3 + 1] = slot17
		end
	end

	return slot3
end

slot5.GetBulletResource = function (slot0, slot1)
	slot2 = {}
	slot1 = slot1 or 0
	slot3 = slot0:GetBulletTmpDataFromID()
	slot4 = nil

	if slot1 ~= 0 then
		slot4 = slot0.GetEquipSkinDataFromID(slot1).bullet_name

		if slot0.GetEquipSkinDataFromID(slot1).mirror == 1 then
			slot2[#slot2 + 1] = slot1.GetBulletPath(slot4 .. slot2.Battle.BattleBulletUnit.MIRROR_RES)
		end
	else
		slot4 = slot3.modle_ID
	end

	if slot3.type == slot3.BulletType.BEAM or slot3.type == slot3.BulletType.SPACE_LASER or slot3.type == slot3.BulletType.MISSILE or slot3.type == slot3.BulletType.ELECTRIC_ARC then
		slot2[#slot2 + 1] = slot1.GetFXPath(slot3.modle_ID)
	else
		slot2[#slot2 + 1] = slot1.GetBulletPath(slot4)
	end

	if slot3.extra_param.mirror then
		slot2[#slot2 + 1] = slot1.GetBulletPath(slot4 .. slot2.Battle.BattleBulletUnit.MIRROR_RES)
	end

	slot2[#slot2 + 1] = slot1.GetFXPath(slot3.hit_fx)
	slot2[#slot2 + 1] = slot1.GetFXPath(slot3.miss_fx)
	slot2[#slot2 + 1] = slot1.GetFXPath(slot3.alert_fx)

	if slot3.extra_param.shrapnel then
		for slot8, slot9 in ipairs(slot3.extra_param.shrapnel) do
			for slot14, slot15 in ipairs(slot10) do
				slot2[#slot2 + 1] = slot15
			end
		end
	end

	for slot8, slot9 in ipairs(slot3.attach_buff) do
		if slot9.effect_id then
			slot2[#slot2 + 1] = slot1.GetFXPath(slot9.effect_id)
		end

		if slot9.buff_id then
			for slot14, slot15 in ipairs(slot10) do
				slot2[#slot2 + 1] = slot15
			end
		end
	end

	return slot2
end

slot5.GetAircraftResource = function (slot0, slot1, slot2)
	slot3 = {}
	slot2 = slot2 or 0
	slot4 = slot0:GetAircraftTmpDataFromID()
	slot5, slot6, slot7, slot8 = nil

	if slot2 ~= 0 then
		slot5, slot6, slot7, slot8 = slot0.GetEquipSkin(slot2)

		if slot10 ~= "" then
			slot3[#slot3 + 1] = slot1.GetBulletPath(slot6)
		end

		if slot7 ~= "" then
			slot3[#slot3 + 1] = slot1.GetBulletPath(slot7)
		end

		if slot8 ~= "" then
			slot3[#slot3 + 1] = slot1.GetBulletPath(slot8)
		end
	else
		slot5 = slot4.model_ID
	end

	slot3[#slot3 + 1] = slot1.GetCharacterGoPath(slot5)
	slot3[#slot3 + 1] = slot1.GetAircraftIconPath(slot4.model_ID)

	if type(slot1 or slot4.weapon_ID) == "table" then
		for slot13, slot14 in ipairs(slot9) do
			for slot19, slot20 in ipairs(slot15) do
				slot3[#slot3 + 1] = slot20
			end
		end
	else
		for slot14, slot15 in ipairs(slot10) do
			slot3[#slot3 + 1] = slot15
		end
	end

	return slot3
end

slot5.GetCommanderResource = function (slot0)
	slot3 = slot0[1].getSkills(slot2)[1]:getLevel()

	for slot7, slot8 in ipairs(slot0[2]) do
		for slot13, slot14 in ipairs(slot9) do
			slot1[#slot1 + 1] = slot14
		end
	end

	return slot1
end

slot5.GetStageResource = function (slot0)
	slot2 = {}
	slot3 = {}

	for slot7, slot8 in ipairs(slot0.Battle.BattleDataFunction.GetDungeonTmpDataByID(slot0).stages) do
		for slot12, slot13 in ipairs(slot8.waves) do
			if slot13.triggerType == slot0.Battle.BattleConst.WaveTriggerType.NORMAL then
				for slot17, slot18 in ipairs(slot13.spawn) do
					for slot23, slot24 in ipairs(slot19) do
						table.insert(slot2, slot24)
					end
				end

				if slot13.reinforcement then
					for slot17, slot18 in ipairs(slot13.reinforcement) do
						for slot23, slot24 in ipairs(slot19) do
							table.insert(slot2, slot24)
						end
					end
				end
			elseif slot13.triggerType == slot0.Battle.BattleConst.WaveTriggerType.AID then
				slot15 = slot13.triggerParams.main_unitList

				if slot13.triggerParams.vanguard_unitList then
					for slot20, slot21 in ipairs(slot16) do
						table.insert(slot2, slot21)
					end

					for slot20, slot21 in ipairs(slot14) do
						slot3[#slot3 + 1] = slot21.skinId
					end
				end

				if slot15 then
					for slot20, slot21 in ipairs(slot16) do
						table.insert(slot2, slot21)
					end

					for slot20, slot21 in ipairs(slot15) do
						slot3[#slot3 + 1] = slot21.skinId
					end
				end
			elseif slot13.triggerType == slot0.Battle.BattleConst.WaveTriggerType.ENVIRONMENT then
				for slot17, slot18 in ipairs(slot13.spawn) do
					slot1.GetEnvironmentRes(slot2, slot18)
				end
			end

			if slot13.airFighter ~= nil then
				for slot17, slot18 in pairs(slot13.airFighter) do
					for slot23, slot24 in ipairs(slot19) do
						slot2[#slot2 + 1] = slot24
					end
				end
			end
		end
	end

	return slot2, slot3
end

slot5.GetEnvironmentRes = function (slot0, slot1)
	table.insert(slot0, slot1.prefab and slot0.GetFXPath(slot1.prefab))

	for slot7, slot8 in ipairs(slot3) do
		if slot8.type == slot1.Battle.BattleConst.EnviroumentBehaviour.BUFF then
			for slot14, slot15 in ipairs(slot10) do
				slot0[#slot0 + 1] = slot15
			end
		elseif slot9 == slot1.Battle.BattleConst.EnviroumentBehaviour.SPAWN then
			table.insert(slot0, slot8.content and slot8.content.alert and slot8.content.alert.alert_fx and slot0.GetFXPath(slot8.content and slot8.content.alert and slot8.content.alert.alert_fx))

			if slot8.content and slot8.content.child_prefab then
				slot0:GetEnvironmentRes(slot11)
			end
		elseif slot9 == slot1.Battle.BattleConst.EnviroumentBehaviour.PLAY_FX then
			slot0[#slot0 + 1] = slot0.GetFXPath(slot8.FX_ID)
		end
	end
end

slot5.GetMonsterRes = function (slot0)
	slot1 = {}

	for slot6, slot7 in ipairs(slot2) do
		slot1[#slot1 + 1] = slot7
	end

	slot4 = Clone(slot1.Battle.BattleDataFunction.GetMonsterTmpDataFromID(slot0.monsterTemplateID).equipment_list)
	slot5 = slot1.Battle.BattleDataFunction.GetMonsterTmpDataFromID(slot0.monsterTemplateID).buff_list
	slot6 = Clone(slot0.buffList) or {}

	if slot0.phase then
		for slot10, slot11 in ipairs(slot0.phase) do
			if slot11.addWeapon then
				for slot15, slot16 in ipairs(slot11.addWeapon) do
					slot4[#slot4 + 1] = slot16
				end
			end

			if slot11.addRandomWeapon then
				for slot15, slot16 in ipairs(slot11.addRandomWeapon) do
					for slot20, slot21 in ipairs(slot16) do
						slot4[#slot4 + 1] = slot21
					end
				end
			end

			if slot11.addBuff then
				for slot15, slot16 in ipairs(slot11.addBuff) do
					slot6[#slot6 + 1] = slot16
				end
			end
		end
	end

	for slot10, slot11 in ipairs(slot5) do
		for slot16, slot17 in ipairs(slot12) do
			slot1[#slot1 + 1] = slot17
		end
	end

	for slot10, slot11 in ipairs(slot6) do
		for slot16, slot17 in ipairs(slot12) do
			slot1[#slot1 + 1] = slot17
		end

		for slot17, slot18 in pairs(slot1.Battle.BattleDataFunction.GetBuffTemplate(slot11, 1).effect_list) do
			if slot18.arg_list.skill_id and slot1.Battle.BattleDataFunction.NeedSkillPainting(slot19) then
				slot1[#slot1 + 1] = slot0.GetPaintingPath(slot2.GetMonsterTmpDataFromID(slot0.monsterTemplateID).icon)

				break
			end
		end
	end

	for slot10, slot11 in ipairs(slot4) do
		for slot16, slot17 in ipairs(slot12) do
			slot1[#slot1 + 1] = slot17
		end
	end

	return slot1
end

slot5.GetEquipSkinPreviewRes = function (slot0)
	slot1 = {}

	for slot6, slot7 in ipairs(slot0:GetEquipSkinDataFromID().weapon_ids) do
		for slot12, slot13 in ipairs(slot8) do
			slot1[#slot1 + 1] = slot13
		end
	end

	function slot3(slot0)
		if slot0 ~= "" then
			slot0[#slot0 + 1] = slot1.GetBulletPath(slot0)
		end
	end

	slot4, slot5, slot6, slot7 = slot0.GetEquipSkin(slot0)

	if _.any(EquipType.AirProtoEquipTypes, function (slot0)
		return table.contains(slot0.equip_type, slot0)
	end) then
		slot1[#slot1 + 1] = slot1.GetCharacterGoPath(slot4)
	else
		slot1[#slot1 + 1] = slot1.GetBulletPath(slot4)
	end

	slot3(slot5)
	slot3(slot6)
	slot3(slot7)

	return slot1
end

slot5.GetEquipSkinBulletRes = function (slot0)
	slot1 = {}
	slot2, slot3, slot4, slot5 = slot0:GetEquipSkin()

	function slot6(slot0)
		if slot0 ~= "" then
			slot0[#slot0 + 1] = slot1.GetBulletPath(slot0)
		end
	end

	slot8 = false

	for slot12, slot13 in ipairs(slot0.GetEquipSkinDataFromID(slot0).equip_type) do
		if table.contains(EquipType.AircraftSkinType, slot13) then
			slot8 = true
		end
	end

	if slot8 then
		if slot2 ~= "" then
			slot1[#slot1 + 1] = slot1.GetCharacterGoPath(slot2)
		end
	else
		slot6(slot2)

		if slot0:GetEquipSkinDataFromID().mirror == 1 then
			slot1[#slot1 + 1] = slot1.GetBulletPath(slot2 .. slot2.Battle.BattleBulletUnit.MIRROR_RES)
		end
	end

	slot6(slot3)
	slot6(slot4)
	slot6(slot5)

	return slot1
end

slot5.GetAidUnitsRes = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0) do
		slot7 = slot0.GetShipResource(slot6.tmpID, nil, true)

		for slot11, slot12 in ipairs(slot6.equipment) do
			if slot12 ~= 0 then
				if slot11 <= Ship.WEAPON_COUNT then
					for slot17, slot18 in ipairs(slot13) do
						for slot23, slot24 in ipairs(slot19) do
							table.insert(slot7, slot24)
						end
					end
				else
					for slot17, slot18 in ipairs(slot13) do
						table.insert(slot7, slot18)
					end
				end
			end
		end

		for slot11, slot12 in ipairs(slot7) do
			table.insert(slot1, slot12)
		end
	end

	return slot1
end

return

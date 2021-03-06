slot0 = singletonClass("PoolMgr")
pg = pg or {}
pg.PoolMgr = slot0
PoolMgr = slot0
slot1 = require("Mgr/Pool/PoolPlural")
slot2 = require("Mgr/Pool/PoolSingleton")
slot3 = require("Mgr/Pool/PoolObjPack")
slot4 = require("Mgr/Pool/PoolUtil")
slot5 = ResourceMgr.Inst

slot0.Ctor = function (slot0)
	slot0.root = GameObject.New("__Pool__").transform
	slot0.pools_plural = {}
	slot0.pools_single = {}
	slot0.pools_pack = {}
	slot0.callbacks = {}
	slot0.pluralIndex = 0
	slot0.singleIndex = 0
	slot0.paintingCount = 0
	slot0.preloads = {
		shiptype = {
			"battle_hangmu",
			"battle_qingxun",
			"battle_quzhu",
			"battle_weixiu",
			"battle_zhanlie",
			"battle_zhongxun",
			"hangmu",
			"hangxun",
			"hangzhan",
			"leixun",
			"qingxun",
			"quzhu",
			"weixiu",
			"xunyang",
			"zhanlie",
			"zhongxun"
		},
		shipframe = {
			"1",
			"2",
			"3",
			"04",
			"4",
			"05",
			"5",
			"b1",
			"b2",
			"b3",
			"b04",
			"b4",
			"b05",
			"b5",
			"ba",
			"bl",
			"prop",
			"prop04",
			"prop05",
			"bprop",
			"bprop04",
			"bprop05"
		},
		["shipyardicon/unknown"] = {
			""
		},
		skillframe = {
			"skill_red",
			"skill_blue",
			"skill_yellow"
		},
		weaponframes = {
			"bg1",
			"bg2",
			"bg3",
			"bg04",
			"bg4",
			"bg05",
			"bg5",
			"bg8",
			"bg9",
			"frame",
			"frame04",
			"frame05",
			"frame6",
			"frame7",
			"frame8",
			"frame9",
			"frame_npc",
			"frame_prop"
		},
		energy = {
			"express_1",
			"express_2",
			"express_3",
			"express_4"
		},
		shipstatus = {},
		channel = {},
		["painting/mat"] = {}
	}
	slot0.ui_tempCache = {}
	slot0.tempCacheLink = {}
end

slot0.Init = function (slot0, slot1)
	print("initializing pool manager...")

	slot2 = 0
	slot3 = table.getCount(slot0.preloads)

	function slot4()
		if slot0 + 1 == slot1 then
			slot2()
		end
	end

	for slot8, slot9 in pairs(slot0.preloads) do
		if #slot9 > 0 then
			slot10 = 0

			for slot14, slot15 in ipairs(slot9) do
				slot0:GetSprite(slot8, slot15, true, function (slot0)
					if slot0 + 1 == #slot1 then
						slot2()
					end
				end)
			end
		else
			slot0.loadAssetBundleAsync(slot10, slot8, function (slot0)
				slot0()
			end)
		end
	end
end

slot0.GetSpineChar = function (slot0, slot1, slot2, slot3)
	function slot6()
		slot0.pools_plural[slot1].index = slot0.pluralIndex
		slot0.pluralIndex = slot0.pluralIndex + 1
		slot1 = slot0.pools_plural[slot1].Dequeue(slot0)

		slot1:SetActive(true)
		slot1:SetActive()
	end

	if not slot0.pools_plural[slot4 .. slot1] then
		slot0.GetSpineSkel(slot0, slot1, slot2, function (slot0)
			if not slot0.pools_plural[] then
				SpineAnimUI.AnimChar(slot2, slot0).SetActive(slot0, false)
				tf(slot0):SetParent(slot0.root, false)

				slot1 = SpineAnimUI.AnimChar(slot2, slot0).GetComponent(slot0, "SkeletonGraphic")
				slot1.material = slot1.skeletonDataAsset.atlasAssets[0].materials[0]
				slot0.pools_plural[slot1] = slot3.New(SpineAnimUI.AnimChar(slot2, slot0), 1)
			end

			slot4()
		end, true)
	else
		slot6()
	end
end

slot0.ReturnSpineChar = function (slot0, slot1, slot2)
	slot4 = slot3 .. slot1

	if IsNil(slot2) then
		Debugger.LogError("empty go: " .. slot1)
	elseif slot0.pools_plural[slot4] then
		UIUtil.ClearChildren(slot2)
		slot2:SetActive(false)
		slot2.transform:SetParent(slot0.root, false)

		slot2.transform.localPosition = Vector3.New(0, 0, 0)
		slot2.transform.localScale = Vector3.New(0.5, 0.5, 1)
		slot2.transform.localRotation = Quaternion.identity

		slot0.pools_plural[slot4]:Enqueue(slot2)
		slot0:ExcessSpineChar()
	else
		slot0.Destroy(slot2)
	end
end

slot0.ExcessSpineChar = function (slot0)
	slot1 = 0
	slot2 = 6
	slot3 = {}

	for slot7, slot8 in pairs(slot0.pools_plural) do
		if string.find(slot7, "char/") == 1 then
			table.insert(slot3, slot7)
		end
	end

	if slot2 < #slot3 then
		table.sort(slot3, function (slot0, slot1)
			return slot0.pools_plural[slot1].index < slot0.pools_plural[slot0].index
		end)

		for slot7 = slot2 + 1, #slot3, 1 do
			slot0.pools_plural[slot3[slot7]].Clear(slot9)

			slot0.pools_plural[slot3[slot7]] = nil

			if slot0.pools_single[slot3[slot7]] then
				slot10:Clear()

				slot0.pools_single[slot8] = nil
			end
		end
	end
end

slot0.GetSpineSkel = function (slot0, slot1, slot2, slot3)
	slot8, slot9 = HXSet.autoHxShiftPath("char/" .. slot1, slot1)

	slot0:FromSingle(slot4, slot5 .. "_SkeletonData", slot2, slot3)
end

slot0.ClearSpineSkel = function (slot0, slot1)
	slot4, slot5 = HXSet.autoHxShiftPath("char/" .. slot1, slot1)

	if slot0.pools_single[slot2 .. slot3 .. "_SkeletonData"] then
		slot0.pools_single[slot4]:Clear()

		slot0.pools_single[slot4] = nil
	end
end

slot0.IsSpineSkelCached = function (slot0, slot1)
	slot4, slot5 = HXSet.autoHxShiftPath("char/" .. slot1, slot1)

	return slot0.pools_single[slot2 .. slot3 .. "_SkeletonData"] ~= nil
end

slot6 = {
	"ResPanel",
	"WorldResPanel"
}
slot7 = {
	"ResPanel",
	"WorldResPanel",
	"MainUI",
	"DockyardUI",
	"AwardInfoUI",
	"SkillInfoUI",
	"ItemInfoUI",
	"ShipDetailView",
	"LevelFleetSelectView",
	"ToastUI",
	"MsgBox",
	"TipPanel",
	"Loading",
	"WorldUI"
}
slot8 = {
	"WorldAllocateUI"
}

slot0.GetUI = function (slot0, slot1, slot2, slot3)
	slot6 = table.contains(slot1, slot1) or table.contains(slot2, slot1)

	slot0:FromPlural("ui/" .. slot1, slot1, slot2, (table.contains(slot0, slot1) and 3) or 1, function (slot0)
		slot0.SetActive(slot0, false)

		if table.indexof(function ()
			slot0(slot1)
		end, table.indexof) then
			slot4.pools_plural[slot3 .. ].prefab:GetComponent(typeof(UIArchiver)):Clear()
			slot0:GetComponent(typeof(UIArchiver)):Load(slot1)
		else
			slot1()
		end
	end, slot6)
end

slot0.ReturnUI = function (slot0, slot1, slot2)
	slot4 = slot3 .. slot1

	if IsNil(slot2) then
		Debugger.LogError("empty go: " .. slot1)
	elseif slot0.pools_plural[slot4] then
		if table.indexof(slot0, slot1) then
			slot2.transform:SetParent(slot0.root, false)
		end

		if table.indexof(slot1, slot1) or table.indexof(slot0.ui_tempCache, slot1) then
			slot2:SetActive(false)
			slot0.pools_plural[slot4]:Enqueue(slot2)
		elseif table.indexof(slot2, slot1) then
			slot2:SetActive(false)
			slot2:GetComponent(typeof(UIArchiver)):Clear()
			slot0.pools_plural[slot4]:Enqueue(slot2)
		else
			slot0.pools_plural[slot4]:Enqueue(slot2, true)

			if slot0.pools_plural[slot4]:AllReturned() and (not slot0.callbacks[slot4] or #slot0.callbacks[slot4] == 0) then
				slot3:ClearBundleRef(slot3, true, true)
				slot0.pools_plural[slot4]:Clear()

				slot0.pools_plural[slot4] = nil
			end
		end
	else
		slot4.Destroy(slot2)
	end
end

slot0.HasCacheUI = function (slot0, slot1)
	return slot0.pools_plural[slot2 .. slot1] ~= nil
end

slot0.PreloadUI = function (slot0, slot1, slot2)
	slot3 = {}

	if not slot0.pools_plural[slot4 .. slot1] then
		table.insert(slot3, function (slot0)
			slot0:GetUI(slot0.GetUI, true, function (slot0)
				slot0.pools_plural[]:Enqueue(slot0)
				slot0.pools_plural[]()
			end)
		end)
	end

	seriesAsync(slot3, slot2)
end

slot0.AddTempCache = function (slot0, slot1, slot2)
	if slot0.tempCacheLink[slot1] == nil then
		slot0.tempCacheLink[slot1] = {}
	end

	table.insert(slot0.tempCacheLink[slot1], slot2)
	_.each(slot0.tempCacheLink[slot1], function (slot0)
		if not table.contains(slot0.ui_tempCache, slot0) then
			table.insert(slot0.ui_tempCache, slot0)
		end
	end)
end

slot0.DelTempCache = function (slot0, slot1)
	if slot0.tempCacheLink[slot1] ~= nil then
		_.each(slot0.tempCacheLink[slot1], function (slot0)
			if table.contains(slot0.ui_tempCache, slot0) then
				table.removebyvalue(slot0.ui_tempCache, slot0, true)
			end
		end)

		slot0.tempCacheLink[slot1] = nil
	end
end

slot0.GetPainting = function (slot0, slot1, slot2, slot3)
	slot5 = slot4 .. slot1

	slot0:FromPlural("painting/" .. slot1, slot1, slot2, 1, function (slot0)
		slot0:SetActive(true)

		if ShipExpressionHelper.DefaultFaceless(slot0) then
			setActive(tf(slot0):Find("face"), true)
		end

		slot1(slot0)
	end, true)
end

slot0.ReturnPainting = function (slot0, slot1, slot2)
	slot4 = slot3 .. slot1

	if IsNil(slot2) then
		Debugger.LogError("empty go: " .. resName)
	elseif slot0.pools_plural[slot4] then
		if tf(slot2):Find("face") then
			setActive(slot5, false)
		end

		slot2:SetActive(false)
		slot2.transform:SetParent(slot0.root, false)
		slot0.pools_plural[slot4]:Enqueue(slot2)
		slot0:ExcessPainting()
	else
		slot0.Destroy(slot2, true)
	end
end

slot0.ExcessPainting = function (slot0)
	slot1 = 0
	slot2 = 4
	slot3 = {}

	for slot7, slot8 in pairs(slot0.pools_plural) do
		if string.find(slot7, "painting/") == 1 then
			table.insert(slot3, slot7)
		end
	end

	if slot2 < #slot3 then
		table.sort(slot3, function (slot0, slot1)
			return slot0.pools_plural[slot1].index < slot0.pools_plural[slot0].index
		end)

		for slot7 = slot2 + 1, #slot3, 1 do
			slot0.pools_plural[slot3[slot7]].Clear(slot9, true)

			slot0.pools_plural[slot3[slot7]] = nil
		end

		slot0:unloadUnusedAssetBundles()

		slot0.paintingCount = slot0.paintingCount + 1

		if slot0.paintingCount > 10 then
			slot0.paintingCount = 0

			Resources.UnloadUnusedAssets()
		end
	end
end

slot0.GetSprite = function (slot0, slot1, slot2, slot3, slot4)
	slot0:FromObjPack(slot1, tostring(slot2), slot3, typeof(Sprite), function (slot0)
		slot0(slot0)
	end)
end

slot0.DecreasSprite = function (slot0, slot1, slot2)
	slot4 = typeof(Sprite)

	if slot0.pools_pack[slot1] and slot0.pools_pack[slot3].type == slot4 then
		if slot0.pools_pack[slot3]:Remove(slot2) then
			slot0:ClearBundleRef(slot3, true, false)
		end

		if slot0.pools_pack[slot3]:GetAmount() <= 0 then
			slot0.pools_pack[slot3]:Clear()

			slot0.pools_pack[slot3] = nil
		end
	end
end

slot0.DestroySprite = function (slot0, slot1)
	slot3 = typeof(Sprite)

	if slot0.pools_pack[slot1] and slot0.pools_pack[slot2].type == slot3 then
		slot0.pools_pack[slot2]:Clear()

		slot0.pools_pack[slot2] = nil

		for slot8 = 1, slot0.pools_pack[slot2]:GetAmount(), 1 do
			slot0:ClearBundleRef(slot2, true, false)
		end
	end
end

slot0.DestroyAllSprite = function (slot0)
	slot1 = {}
	slot2 = typeof(Sprite)

	for slot6, slot7 in pairs(slot0.pools_pack) do
		if slot7.type == slot2 and not slot0.preloads[slot6] then
			slot1[slot6] = slot7
		end
	end

	for slot6, slot7 in pairs(slot1) do
		slot0.pools_pack[slot6]:Clear()

		slot0.pools_pack[slot6] = nil

		for slot12 = 1, slot0.pools_pack[slot6]:GetAmount(), 1 do
			slot0:ClearBundleRef(slot6, true, false)
		end
	end

	slot0:unloadUnusedAssetBundles()
end

slot0.DisplayPoolPacks = function (slot0)
	slot1 = ""

	for slot5, slot6 in pairs(slot0.pools_pack) do
		for slot10, slot11 in pairs(slot6.items) do
			if #slot1 > 0 then
				slot1 = slot1 .. "\n"
			end

			slot1 = slot1 .. " " .. table.concat(_.map({
				slot5,
				"assetName:",
				slot10,
				"type:",
				slot6.type.FullName
			}, function (slot0)
				return tostring(slot0)
			end), " ")
		end
	end

	warning(slot1)
end

slot0.SpriteMemUsage = function (slot0)
	slot1 = 0
	slot2 = 9.5367431640625e-07
	slot3 = typeof(Sprite)

	for slot7, slot8 in pairs(slot0.pools_pack) do
		if slot8.type == slot3 then
			slot9 = {}

			for slot13, slot14 in pairs(slot8.items) do
				if not slot9[slot14.texture.name] then
					slot17 = 4

					if slot15.format == TextureFormat.RGB24 then
						slot17 = 3
					elseif slot18 == TextureFormat.ARGB4444 or slot18 == TextureFormat.RGBA4444 then
						slot17 = 2
					elseif slot18 == TextureFormat.DXT5 or slot18 == TextureFormat.ETC2_RGBA8 then
						slot17 = 1
					elseif slot18 == TextureFormat.PVRTC_RGB4 or slot18 == TextureFormat.PVRTC_RGBA4 or slot18 == TextureFormat.ETC_RGB4 or slot18 == TextureFormat.ETC2_RGB or slot18 == TextureFormat.DXT1 then
						slot17 = 0.5
					end

					slot1 = slot1 + slot15.width * slot15.height * slot17 * slot2
					slot9[slot16] = true
				end
			end
		end
	end

	return slot1
end

slot9 = 64
slot10 = {
	"chapter/",
	"emoji/",
	"world/"
}

slot0.GetPrefab = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6 = slot1 .. slot2

	slot0:FromPlural(slot1, slot2, slot3, slot5 or slot0, function (slot0)
		if string.find(slot0, "emoji/") == 1 and slot0:GetComponent(typeof(CriManaEffectUI)) then
			slot1:Pause(false)
		end

		slot0:SetActive(true)
		tf(slot0):SetParent(slot1.root, false)
		tf(slot0)(slot0)
	end, true)
end

slot0.ReturnPrefab = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot1 .. slot2

	if IsNil(slot3) then
		Debugger.LogError("empty go: " .. slot2)
	elseif slot0.pools_plural[slot5] then
		if string.find(slot1, "emoji/") == 1 and slot3:GetComponent(typeof(CriManaEffectUI)) then
			slot6:Pause(true)
		end

		slot3:SetActive(false)
		slot3.transform:SetParent(slot0.root, false)
		slot0.pools_plural[slot5]:Enqueue(slot3)

		if slot4 and slot0.pools_plural[slot5].balance <= 0 and (not slot0.callbacks[slot5] or #slot0.callbacks[slot5] == 0) then
			slot0:DestroyPrefab(slot1, slot2)
		end
	else
		slot0.Destroy(slot3)
	end
end

slot0.DestroyPrefab = function (slot0, slot1, slot2)
	if slot0.pools_plural[slot1 .. slot2] then
		slot0.pools_plural[slot3]:Clear()

		slot0.pools_plural[slot3] = nil

		slot0:ClearBundleRef(slot1, true, false)
	end
end

slot0.DestroyAllPrefab = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.pools_plural) do
		if _.any(slot0, function (slot0)
			return string.find(slot0, slot0) == 1
		end) then
			slot6.Clear(slot6)
			slot1:ClearBundleRef(slot5, true, false)
			table.insert(slot1, slot5)
		end
	end

	_.each(slot1, function (slot0)
		slot0.pools_plural[slot0] = nil
	end)
end

slot0.DisplayPluralPools = function (slot0)
	slot1 = ""

	for slot5, slot6 in pairs(slot0.pools_plural) do
		if #slot1 > 0 then
			slot1 = slot1 .. "\n"
		end

		slot1 = slot1 .. " " .. table.concat(_.map({
			slot5,
			"balance",
			slot6.balance,
			"currentItmes",
			#slot6.items
		}, function (slot0)
			return tostring(slot0)
		end), " ")
	end

	warning(slot1)
end

slot0.FromPlural = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	function slot8()
		slot0.pools_plural[slot1].index = slot0.pluralIndex
		slot0.pluralIndex = slot0.pluralIndex + 1

		slot0.pluralIndex + 1(slot0.pools_plural[slot1]:Dequeue())
	end

	if not slot0.pools_plural[slot1 .. slot2] then
		slot0.LoadAsset(slot0, slot1, slot2, slot3, typeof(Object), function (slot0)
			if slot0 == nil then
				Debugger.LogError("can not find asset: " .. slot0 .. " : " .. Debugger.LogError)

				return
			end

			if not slot2.pools_plural[slot3] then
				slot2.pools_plural[slot3] = slot4.New(slot0, slot5)
			end

			slot6()
		end, slot6)
	else
		slot8()
	end
end

slot0.FromSingle = function (slot0, slot1, slot2, slot3, slot4)
	function slot6()
		slot0.pools_single[slot1].index = slot0.singleIndex
		slot0.singleIndex = slot0.singleIndex + 1

		slot0.singleIndex + 1(slot0.pools_single[slot1].prefab)
	end

	if not slot0.pools_single[slot1 .. slot2] then
		slot0.LoadAsset(slot0, slot1, slot2, slot3, typeof(Object), function (slot0)
			if not slot0.pools_single[] then
				slot0.pools_single[] = slot2.New(slot0)
			end

			slot3()
		end, true)
	else
		slot6()
	end
end

slot0.FromObjPack = function (slot0, slot1, slot2, slot3, slot4, slot5)
	if not slot0.pools_pack[slot1] or not slot0.pools_pack[slot6]:Get(slot2) then
		slot0:LoadAsset(slot1, slot2, slot3, slot4, function (slot0)
			if not slot0.pools_pack[] then
				slot0.pools_pack[] = slot2.New(slot2.New)
			end

			if not slot0.pools_pack[]:Get(slot4) then
				slot0.pools_pack[]:Set(slot4, slot0)
			end

			slot5(slot0)
		end, false)
	else
		slot5(slot0.pools_pack[slot6]:Get(slot2))
	end
end

slot0.LoadAsset = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot1, slot2 = HXSet.autoHxShiftPath(slot1, slot2)

	if slot0.callbacks[slot1 .. slot2] then
		if not slot3 then
			errorMsg("Sync Loading after async operation")
		end

		table.insert(slot0.callbacks[slot7], slot5)
	elseif slot3 then
		slot0.callbacks[slot7] = {
			slot5
		}

		slot0:getAssetAsync(slot1, slot2, slot4, UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			if slot0.callbacks[] then
				for slot6 = 1, #slot0.callbacks[], 1 do
					table.remove(slot1)(slot0)
				end

				slot0.callbacks[slot1] = nil
			end
		end), slot6, false)
	else
		slot5(slot0:getAssetSync(slot1, slot2, slot4, slot6, false))
	end
end

slot0.PrintPools = function (slot0)
	slot1 = ""

	for slot5, slot6 in pairs(slot0.pools_plural) do
		slot1 = slot1 .. "\n" .. slot5
	end

	print(slot1)
end

return slot0

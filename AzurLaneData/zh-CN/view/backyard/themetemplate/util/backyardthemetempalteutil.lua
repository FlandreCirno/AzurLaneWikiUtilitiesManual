slot0 = class("BackYardThemeTempalteUtil")
slot1 = false
slot2 = true
slot3 = 1980
slot4 = 1080
slot0.TakeScale = 0.86
slot0.HideGos = {}
slot0.ScaleGos = {}
slot0.loader = {}
slot5 = 7
slot0.caches = {}
slot0.overCnt = 0
slot0.ForceSynGCCnt = 8

function slot6(...)
	if slot0 then
		print(...)
	end
end

function slot7()
	return Application.persistentDataPath .. "/screen_scratch"
end

function slot8(slot0)
	return Application.persistentDataPath .. "/screen_scratch/" .. slot0 .. ".png"
end

function slot9(slot0)
	return slot0 .. ".png"
end

function slot10(slot0)
	if PathMgr.FileExists(slot0) then
		return HashUtil.HashFile(slot0)
	else
		return ""
	end
end

function slot11(slot0, slot1, slot2)
	if not slot0:FileExists() then
		slot2()

		return
	end

	pg.OSSMgr.GetInstance():GetTexture2D(slot2(slot0), slot1(slot0), false, , , function (slot0, slot1)
		if slot0 and slot1 then
			slot0(slot1)
		else
			slot0()
		end
	end)
end

function slot12(slot0, slot1, slot2)
	if not slot0 then
		slot2()

		return
	end

	pg.OSSMgr.GetInstance():GetTexture2D(slot2(slot0), slot1(slot0), true, , , function (slot0, slot1)
		if slot0 and slot1 and slot0 == slot1(slot0) then
			slot3(slot1)
		else
			slot3()
		end
	end)
end

function slot13(slot0, slot1)
	if not slot0 then
		slot1()

		return
	end

	pg.OSSMgr.GetInstance():DeleteObject(slot2(slot0), slot1)
end

function slot14(slot0, slot1)
	if not slot0 then
		slot1()

		return
	end

	pg.OSSMgr.GetInstance():AsynUpdateLoad(slot2(slot0), slot1(slot0), slot1)
end

function slot15()
	table.insert(slot0.HideGos, GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/main"))
	table.insert(slot0.HideGos, GameObject.Find("/UICamera/Canvas/UIMain/BackYardDecorationUI(Clone)"))
	table.insert(slot0.HideGos, GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/back"))
	table.insert(slot0.HideGos, GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/bg000"))

	slot0 = GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/scroll_view")
	GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/bg").transform.localScale = Vector2(slot0.TakeScale, slot0.TakeScale, 1)

	table.insert(slot0.ScaleGos, {
		go = GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/bg").transform,
		scale = GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/bg").transform.localScale.x
	})

	if GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/bg/furContain/drag") then
		table.insert(slot0.HideGos, slot3)
	end

	for slot7, slot8 in ipairs(slot0.HideGos) do
		setActive(slot8, false)
	end

	slot0.normalizedPosition = slot0:GetComponent(typeof(ScrollRect)).normalizedPosition

	scrollTo(slot0, slot0.GetComponent(typeof(ScrollRect)).normalizedPosition.x, 1)
end

function slot16()
	for slot3, slot4 in ipairs(slot0.HideGos) do
		setActive(slot4, true)
	end

	for slot3, slot4 in ipairs(slot0.ScaleGos) do
		slot4.go.localScale = Vector3(slot4.scale, , )
	end

	slot0.ScaleGos = {}
	slot0.HideGos = {}
	slot0 = GameObject.Find("/UICamera/Canvas/UIMain/BackYardUI(Clone)/backyardmainui/scroll_view")

	scrollTo(slot0, slot0.normalizedPosition.x, slot0.normalizedPosition.y)

	slot0.normalizedPosition = nil
end

slot0.FileExists = function (slot0)
	return PathMgr.FileExists(slot0(slot0))
end

function slot17(slot0, slot1, slot2)
	slot3 = UnityEngine.Texture2D.New(452, 324)
	slot7 = slot1 / 2 - slot3.height / 2 + slot3.height
	slot8 = 0
	slot9 = 0

	for slot13 = slot0 / 2 - slot3.width / 2, slot0 / 2 - slot3.width / 2 + slot3.width, 1 do
		slot8 = slot8 + 1
		slot9 = 0

		for slot17 = slot5, slot7, 1 do
			slot3:SetPixel(slot8, slot9 + 1, slot1:GetPixel(slot13, slot17))
		end
	end

	slot3:Apply()

	slot10 = slot2(slot0 .. "_icon")

	onNextTick(function ()
		ScreenShooter.SaveTextureToLocal(ScreenShooter.SaveTextureToLocal, , false)

		if ScreenShooter.SaveTextureToLocal then
			slot2()
		end
	end)
end

slot0.TakePhoto = function (slot0, slot1)
	slot0()
	slot4(slot4)
	slot4()
	seriesAsync({
		function (slot0)
			onNextTick(function ()
				slot0(slot1, slot2, slot3)
			end)
		end,
		function (slot0)
			onNextTick(function ()
				ScreenShooter.SaveTextureToLocal(ScreenShooter.SaveTextureToLocal, , false)
				ScreenShooter.SaveTextureToLocal()
			end)
		end
	}, function ()
		if slot0 then
			slot0()
		end
	end)
end

function slot18(slot0)
	return _.detect(slot0.caches, function (slot0)
		return slot0.name == slot0
	end)
end

function slot19(slot0, slot1, slot2)
	table.insert(slot0.loader, {
		name = slot0,
		md5 = slot1,
		callback = slot2
	})

	if #slot0.loader ~= 1 then
		return
	end

	slot3 = nil

	function slot3()
		if #slot0.loader == 0 then
			return
		end

		function slot1(slot0)
			slot0:callback()
			table.remove(slot1.loader, 1)

			if slot0 then
				slot1.CheckCache()
				table.insert(slot1.caches, {
					name = slot1.caches,
					asset = slot0
				})
			end

			onNextTick(slot3)
		end

		if not slot0.loader[1].md5 or slot2 == "" then
			slot1(nil)
		elseif slot0.FileExists(slot0.name) and slot2 == slot3(slot4(slot1)) then
			slot5(slot0.name, slot2, slot1)
		else
			slot6(slot0.name, slot2, slot1)
		end
	end

	slot3()
end

slot0.GetTexture = function (slot0, slot1, slot2)
	if slot0(slot0) then
		slot2(slot3.asset)

		return
	end

	slot1(slot0, slot1, slot2)
end

slot0.UploadTexture = function (slot0, slot1)
	slot0(slot0, slot1)
end

slot0.DeleteTexture = function (slot0, slot1)
	slot0(slot0, slot1)
end

slot0.GetMd5 = function (slot0)
	return slot0(slot0)(slot0(slot0))
end

slot0.GetIconMd5 = function (slot0)
	return slot0.GetMd5(slot0 .. "_icon")
end

slot0.CheckCache = function ()
	if slot1 <= #slot0.caches then
		table.remove(slot0.caches, 1)

		table.remove.overCnt = slot0.overCnt + 1

		if table.remove.overCnt % slot0.ForceSynGCCnt == 0 then
			gcAll(true)
		else
			gcAll(false)
		end
	end
end

slot0.CheckSaveDirectory = function ()
	if not System.IO.Directory.Exists(slot0()) then
		System.IO.Directory.CreateDirectory(slot0)
	end
end

slot0.Init = function (slot0)
	slot0.CheckSaveDirectory()
end

slot0.ClearCaches = function (slot0)
	if not slot0.caches or #slot0.caches == 0 then
		return
	end

	for slot4, slot5 in ipairs(slot0) do
		for slot9 = #slot0.caches, 1, -1 do
			if slot0.caches[slot9].name == slot5 then
				table.remove(slot0.caches, slot9)
			end
		end
	end

	gcAll(true)
end

slot0.ClearAllCache = function ()
	slot0.caches = {}

	gcAll(true)
end

slot0.ClearAllCacheAsyn = function (slot0)
	slot0.caches = {}

	gcAll(false)
end

slot0.Exit = function (slot0)
	slot0.loader = {}

	slot0.ClearAllCacheAsyn()
end

return slot0

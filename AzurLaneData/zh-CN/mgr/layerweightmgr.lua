pg = pg or {}
pg.LayerWeightMgr = singletonClass("LayerWeightMgr")
pg.LayerWeightMgr.DEBUG = false
pg.LayerWeightMgr.ADAPT_TAG = "(Adapt)"
pg.LayerWeightMgr.RECYCLE_ADAPT_TAG = "recycleAdapt"

pg.LayerWeightMgr.Init = function (slot0, slot1)
	slot0.baseParent = tf(GameObject.Find("UICamera/Canvas"))
	slot0.uiOrigin = tf(instantiate(slot2))
	slot0.uiOrigin.name = "UIOrigin"

	slot0.uiOrigin:SetParent(slot0.baseParent, false)

	slot0.originCanvas = GetOrAddComponent(slot0.uiOrigin, typeof(Canvas))
	slot0.originCanvas.overrideSorting = true
	slot0.originCanvas.sortingOrder = 200
	slot0.originCast = GetOrAddComponent(slot0.uiOrigin, typeof(GraphicRaycaster))
	slot0.lvCameraTf = tf(GameObject.Find("LevelCamera"))
	slot0.lvParent = tf(GameObject.Find("LevelCamera/Canvas"))
	slot0.lvCamera = GetOrAddComponent(slot0.lvCameraTf, typeof(Camera))
	slot0.adaptPool = {}
	slot0.UIMain = rtf(GameObject.Find("UICamera/Canvas/UIMain"))
	slot0.OverlayMain = rtf(GameObject.Find("OverlayCamera/Overlay/UIMain"))
	slot0.OverlayAdapt = rtf(GameObject.Find("OverlayCamera/Overlay/UIAdapt"))
	slot0.storeUIs = {}

	if slot1 ~= nil then
		slot1()
	end
end

pg.LayerWeightMgr.Add2Overlay = function (slot0, slot1, slot2, slot3)
	slot3.type = slot1
	slot3.ui = slot2
	slot3.pbList = slot3.pbList or {}
	slot3.weight = slot3.weight or LayerWeightConst.BASE_LAYER
	slot3.overlayType = slot3.overlayType or LayerWeightConst.OVERLAY_UI_MAIN
	slot4 = nil
	slot3.blurCamList = slot3.blurCamList or ((not slot0.lvCamera.enabled or {
		slot0.UIMgr.CameraLevel
	}) and {
		slot0.UIMgr.CameraUI
	})

	if slot2.gameObject.name == "ResPanel(Clone)" then
		return
	end

	if (slot1 == LayerWeightConst.UI_TYPE_SYSTEM and #slot0.storeUIs > 0) or slot1 == LayerWeightConst.UI_TYPE_SUB then
		slot0:Log("ui：" .. slot2.gameObject.name .. " 加入了ui层级管理, weight:" .. slot3.weight)
		slot0:ClearBlurData(slot5)
		table.insert(slot0.storeUIs, slot3)
		slot0:LayerSortHandler()
	end
end

pg.LayerWeightMgr.DelFromOverlay = function (slot0, slot1, slot2)
	if slot1.gameObject.name == "ResPanel(Clone)" then
		return
	end

	slot0:Log("ui：" .. slot1.gameObject.name .. " 去除了ui层级管理")

	if slot0:DelList(slot1) ~= nil then
		if slot0:GetAdaptObjFromUI(slot3.ui) == nil then
			slot5 = slot4
		end

		GetOrAddComponent(slot5, typeof(CanvasGroup)).interactable = true
		GetOrAddComponent(slot5, typeof(CanvasGroup)).blocksRaycasts = true

		slot0:CheckRecycleAdaptObj(slot4, slot2)
		slot0:ClearBlurData(slot3)
	end

	slot0:LayerSortHandler()
end

pg.LayerWeightMgr.DelList = function (slot0, slot1)
	slot2 = nil

	for slot6 = #slot0.storeUIs, 1, -1 do
		if slot0.storeUIs[slot6].ui == slot1 then
			slot2 = slot0.storeUIs[slot6]

			table.remove(slot0.storeUIs, slot6)

			break
		end
	end

	return slot2
end

pg.LayerWeightMgr.ClearBlurData = function (slot0, slot1)
	if slot1 == nil then
		return
	end

	if slot1.pbList ~= nil then
		slot0.UIMgr.GetInstance():RevertPBMaterial(slot1.pbList)
	end
end

pg.LayerWeightMgr.LayerSortHandler = function (slot0)
	slot0:switchOriginParent()
	slot0:SortStoreUIs()

	slot1 = false
	slot2 = false
	slot3 = {}
	slot4 = nil
	slot5 = false
	slot6 = false
	slot7 = {}
	slot8 = nil
	slot9 = 0
	slot10 = 0

	for slot14 = #slot0.storeUIs, 1, -1 do
		slot16 = slot0.storeUIs[slot14].type
		slot17 = slot0.storeUIs[slot14].ui
		slot18 = slot0.storeUIs[slot14].pbList
		slot19 = slot0.storeUIs[slot14].globalBlur
		slot20 = slot0.storeUIs[slot14].groupName
		slot21 = slot0.storeUIs[slot14].overlayType
		slot22 = slot0.storeUIs[slot14].hideLowerLayer
		slot23 = slot0.storeUIs[slot14].staticBlur
		slot24 = slot0.storeUIs[slot14].blurCamList
		slot25 = slot14 == #slot0.storeUIs

		if slot16 == LayerWeightConst.UI_TYPE_SYSTEM then
			slot1 = true
		end

		if slot25 then
			if slot20 ~= nil then
				slot4 = slot20
			end

			slot5 = slot19
			slot6 = slot23
			slot7 = slot24
			slot8 = slot15
		end

		function slot26()
			slot0:ShowOrHideTF(slot0, true)
			slot0.ShowOrHideTF:SetToOverlayParent(slot0.ShowOrHideTF, , )

			if not slot0.ShowOrHideTF and #slot5 > 0 then
				table.insertto(slot6, slot5)
			end
		end

		if slot16 == LayerWeightConst.UI_TYPE_SUB then
			if slot25 then
				slot26()
			elseif slot4 ~= nil and slot4 == slot20 then
				slot26()
			else
				slot0:SetToOrigin(slot17, slot21, slot10, slot15.interactableAlways)

				if slot1 or slot2 then
					slot0:ShowOrHideTF(slot17, false)
				else
					slot0:ShowOrHideTF(slot17, true)

					if #slot18 > 0 then
						slot0.UIMgr.GetInstance():RevertPBMaterial(slot18)
					end
				end
			end
		end

		if slot22 then
			slot2 = true
		end
	end

	if #slot3 > 0 then
		slot0.UIMgr.GetInstance():PartialBlurTfs(slot3)
	else
		slot0.UIMgr.GetInstance():ShutdownPartialBlur()
	end

	if slot5 then
		for slot14, slot15 in ipairs({
			slot0.UIMgr.CameraUI,
			slot0.UIMgr.CameraLevel
		}) do
			if table.contains(slot7, slot15) then
				slot0.UIMgr.GetInstance():BlurCamera(slot15, slot6)
			else
				slot0.UIMgr.GetInstance():UnblurCamera(slot15)
			end
		end
	else
		for slot14, slot15 in ipairs({
			slot0.UIMgr.CameraUI,
			slot0.UIMgr.CameraLevel
		}) do
			slot0.UIMgr.GetInstance():UnblurCamera(slot15)
		end
	end
end

pg.LayerWeightMgr.SetToOverlayParent = function (slot0, slot1, slot2, slot3)
	slot4 = nil

	if slot2 == LayerWeightConst.OVERLAY_UI_ADAPT then
		if slot0:GetAdaptObjFromUI(slot1) ~= nil then
			SetParent(slot1.parent, slot0.OverlayMain, false)
		else
			slot0:GetAdaptObj().name = slot0:GetAdatpObjName(slot1)

			SetParent(slot1, slot0.GetAdaptObj(), false)
		end
	else
		SetParent(slot1, slot0.OverlayMain, false)
	end

	if slot3 ~= nil then
		slot4:SetSiblingIndex(slot3)
	end

	GetOrAddComponent(slot4, typeof(CanvasGroup)).interactable = true
	GetOrAddComponent(slot4, typeof(CanvasGroup)).blocksRaycasts = true
end

pg.LayerWeightMgr.SetToOrigin = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = nil

	if slot2 == LayerWeightConst.OVERLAY_UI_ADAPT then
		if slot0:GetAdaptObjFromUI(slot1) ~= nil then
			slot5 = slot1.parent
		else
			slot0:GetAdaptObj().name = slot0:GetAdatpObjName(slot1)

			SetParent(slot1, slot0.GetAdaptObj(), false)
		end
	else
		slot5 = slot1
	end

	SetParent(slot5, slot0.uiOrigin, false)

	if slot3 ~= nil then
		slot5:SetSiblingIndex(slot3)
	end

	GetOrAddComponent(slot5, typeof(CanvasGroup)).interactable = (slot4 and true) or false
	GetOrAddComponent(slot5, typeof(CanvasGroup)).blocksRaycasts = (slot4 and true) or false
end

pg.LayerWeightMgr.SortStoreUIs = function (slot0)
	slot0:Log("-----------------------------------------")

	slot1 = {}

	for slot5, slot6 in ipairs(slot0.storeUIs) do
		if not table.contains(slot1, slot6.weight) then
			table.insert(slot1, slot6.weight)
		end
	end

	table.sort(slot1, function (slot0, slot1)
		return slot0 < slot1
	end)

	slot2 = {}

	for slot6, slot7 in ipairs(slot1) do
		for slot11, slot12 in ipairs(slot0.storeUIs) do
			if slot7 == slot12.weight then
				table.insert(slot2, slot12)
				slot0:Log(slot12.ui.gameObject.name .. "   globalBlur:" .. tostring(slot12.globalBlur))
			end
		end
	end

	slot0.storeUIs = slot2

	slot0:Log("-----------------------------------------")
end

pg.LayerWeightMgr.ShowOrHideTF = function (slot0, slot1, slot2)
	GetOrAddComponent(slot1, typeof(CanvasGroup)).alpha = (slot2 and 1) or 0
end

pg.LayerWeightMgr.switchOriginParent = function (slot0)
	if slot0.lvCamera.enabled then
		slot0.uiOrigin:SetParent(slot0.lvParent, false)

		slot0.originCanvas.sortingOrder = 5000
	else
		slot0.uiOrigin:SetParent(slot0.baseParent, false)

		slot0.originCanvas.sortingOrder = 200
	end
end

pg.LayerWeightMgr.GetAdaptObj = function (slot0)
	slot1 = nil

	if #slot0.adaptPool > 0 then
		slot1 = table.remove(slot0.adaptPool, #slot0.adaptPool)
	else
		slot2 = GameObject.New()

		slot2:AddComponent(typeof(NotchAdapt))

		slot1 = slot2:AddComponent(typeof(RectTransform))
	end

	SetParent(slot1, slot0.OverlayMain, false)

	slot1.anchorMin = Vector2.zero
	slot1.anchorMax = Vector2.one
	slot1.pivot = Vector2(0.5, 0.5)
	slot1.offsetMax = Vector2.zero
	slot1.offsetMin = Vector2.zero
	slot1.localPosition = Vector3.zero

	SetActive(slot1, true)
	slot0:ShowOrHideTF(slot1, true)

	return slot1
end

pg.LayerWeightMgr.CheckRecycleAdaptObj = function (slot0, slot1, slot2)
	slot3 = slot0:GetAdaptObjFromUI(slot1)

	if slot2 ~= nil then
		SetParent(slot1, slot2, false)
	end

	if slot3 ~= nil then
		if #slot0.adaptPool < 4 then
			table.insert(slot0.adaptPool, slot3)
			SetParent(slot3, slot0.OverlayAdapt, false)

			slot3.name = slot0.RECYCLE_ADAPT_TAG

			SetActive(slot3, false)
		else
			Destory(slot3)
		end
	end
end

pg.LayerWeightMgr.GetAdaptObjFromUI = function (slot0, slot1)
	if slot1.parent ~= nil and slot1.parent.name == slot0:GetAdatpObjName(slot1) then
		return slot1.parent
	end

	return nil
end

pg.LayerWeightMgr.GetAdatpObjName = function (slot0, slot1)
	return slot1.name .. slot0.ADAPT_TAG
end

pg.LayerWeightMgr.Log = function (slot0, slot1)
	if not slot0.DEBUG then
		return
	end

	print(slot1)
end

return

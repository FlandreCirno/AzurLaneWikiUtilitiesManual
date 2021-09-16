pg = pg or {}
pg.UIMgr = singletonClass("UIMgr")
pg.UIMgr._loadPanel = nil
pg.UIMgr.CameraUI = 1
pg.UIMgr.CameraLevel = 2
pg.UIMgr.CameraOverlay = 3
pg.UIMgr.OptimizedBlur = 1
pg.UIMgr.StaticBlur = 2
pg.UIMgr.PartialBlur = 3

pg.UIMgr.Init = function (slot0, slot1)
	print("initializing ui manager...")

	slot0.mainCamera = GameObject.Find("MainCamera")
	slot0.uiCamera = tf(GameObject.Find("UICamera"))
	slot0.levelCamera = tf(GameObject.Find("LevelCamera"))
	slot0.levelCameraComp = slot0.levelCamera:GetComponent("Camera")
	slot0.overlayCamera = tf(GameObject.Find("OverlayCamera"))
	slot0.overlayCameraComp = slot0.overlayCamera:GetComponent("Camera")
	slot0.UIMain = slot0.uiCamera:Find("Canvas/UIMain")
	slot0.OverlayMain = slot0.overlayCamera:Find("Overlay/UIMain")
	slot0.OverlayToast = slot0.overlayCamera:Find("Overlay/UIOverlay")
	slot0.OverlayEffect = slot0.overlayCamera:Find("Overlay/UIEffect")
	slot0._cameraBlurPartial = slot0.uiCamera:GetComponent("UIPartialBlur")
	slot0._levelCameraPartial = GetOrAddComponent(slot0.levelCamera, "UIPartialBlur")
	slot0._levelCameraPartial.blurShader = slot0._cameraBlurPartial.blurShader
	slot0._levelCameraPartial.blurCam = slot0.levelCameraComp
	slot0._levelCameraPartial.maskCam = slot0.overlayCameraComp
	slot0._levelCameraPartial.enabled = false
	slot0.cameraBlurs = {
		[slot0.CameraUI] = {
			slot0.uiCamera:GetComponent("BlurOptimized"),
			slot0.uiCamera:GetComponent("UIStaticBlur"),
			slot0._cameraBlurPartial
		},
		[slot0.CameraLevel] = {
			slot0.levelCamera:GetComponent("BlurOptimized"),
			slot0.levelCamera:GetComponent("UIStaticBlur"),
			slot0._levelCameraPartial
		},
		[slot0.CameraOverlay] = {
			slot0.overlayCamera:GetComponent("BlurOptimized"),
			slot0.overlayCamera:GetComponent("UIStaticBlur")
		}
	}

	function slot2(slot0)
		if slot0 == nil then
			return
		end

		slot0.downsample = 2
		slot0.blurSize = 4
		slot0.blurIterations = 2
	end

	function slot3(slot0)
		if slot0 == nil then
			return
		end

		slot0.downsample = 2
		slot0.blurSize = 1.5
		slot0.blurIteration = 4
	end

	for slot7, slot8 in ipairs(slot0.cameraBlurs) do
		slot2(slot8[slot0.OptimizedBlur])
		slot3(slot8[slot0.PartialBlur])
	end

	slot0._debugPanel = DebugPanel.New()

	setActive(slot0.uiCamera, false)
	seriesAsync({
		function (slot0)
			ResourceMgr.Inst:loadAssetBundleAsync("ui/commonui_atlas", function (slot0)
				slot0._common_ui_bundle = slot0

				slot0()
			end)
		end,
		function (slot0)
			ResourceMgr.Inst:loadAssetBundleAsync("skinicon", function (slot0)
				slot0._skinicon_bundle = slot0

				slot0()
			end)
		end,
		function (slot0)
			ResourceMgr.Inst:loadAssetBundleAsync("attricon", function (slot0)
				slot0._attricon_bundle = slot0

				slot0()
			end)
		end,
		function (slot0)
			setActive(slot0.uiCamera, true)

			slot0._loadPanel = LoadingPanel.New(slot0)
		end,
		function (slot0)
			PoolMgr.GetInstance():GetUI("ClickEffect", true, function (slot0)
				setParent(slot0, slot0.OverlayEffect)
				SetActive(slot0.OverlayEffect, PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0)
				PlayerPrefs.GetInt(SHOW_TOUCH_EFFECT, 1) > 0()
			end)
		end
	}, slot1)
end

pg.UIMgr.Loading = function (slot0, slot1)
	slot0._loadPanel:appendInfo(slot1)
end

pg.UIMgr.LoadingOn = function (slot0, slot1)
	slot0._loadPanel:on(slot1)
end

pg.UIMgr.displayLoadingBG = function (slot0, slot1)
	slot0._loadPanel:displayBG(slot1)
end

pg.UIMgr.LoadingOff = function (slot0)
	slot0._loadPanel:off()
end

pg.UIMgr.OnLoading = function (slot0)
	return slot0._loadPanel:onLoading()
end

pg.UIMgr.LoadingRetainCount = function (slot0)
	return slot0._loadPanel:getRetainCount()
end

pg.UIMgr.AddDebugButton = function (slot0, slot1, slot2)
	slot0._debugPanel:addCustomBtn(slot1, slot2)
end

pg.UIMgr.AddWorldTestButton = function (slot0, slot1, slot2)
	slot0._debugPanel:addCustomBtn(slot1, function ()
		slot0._debugPanel:hidePanel()
		slot0._debugPanel()
	end)
end

pg.UIMgr._maxbianjie = 50
pg.UIMgr._maxbianjieInv = 0.02
pg.UIMgr._maxbianjieSqr = 2500
pg.UIMgr._followRange = 0
pg.UIMgr._stick = nil
pg.UIMgr._areaImg = nil
pg.UIMgr._stickImg = nil
pg.UIMgr._stickCom = nil
pg.UIMgr._normalColor = Color(255, 255, 255, 1)
pg.UIMgr._darkColor = Color(255, 255, 255, 0.5)
pg.UIMgr._firstPos = Vector3.zero

pg.UIMgr.AttachStickOb = function (slot0, slot1)
	slot0.hrz = 0
	slot0.vtc = 0
	slot0.fingerId = -1
	slot2 = slot1:Find("Area")
	slot0._stick = slot2:Find("Stick")
	slot0._areaImg = slot2:GetComponent(typeof(Image))
	slot0._stickImg = slot0._stick:GetComponent(typeof(Image))
	slot0._stickCom = slot1:GetComponent(typeof(StickController))
	slot0._stickCom.StickBorderRate = 1

	slot0._stickCom:SetStickFunc(function (slot0, slot1)
		slot0:UpdateStick(slot0, slot1)
	end)

	slot0._firstPos = slot2.localPosition
	slot0.vtc = 0

	slot0.SetActive(slot0, true)
end

pg.UIMgr.SetActive = function (slot0, slot1)
	slot0._stickActive = slot1
end

pg.UIMgr.Marching = function (slot0)
	slot1 = ys.Battle.BattleConfig

	LeanTween.value(go(slot0._stick), 0, 0.625, 1.8):setOnUpdate(System.Action_float(function (slot0)
		slot0.hrz = slot1.START_SPEED_CONST_B * (slot0 - slot1.START_SPEED_CONST_A) * (slot0 - slot1.START_SPEED_CONST_A)
	end)).setOnComplete(slot2, System.Action(function ()
		slot0.hrz = 0
	end))
end

pg.UIMgr.UpdateStick = function (slot0, slot1, slot2)
	if not slot0._stickActive then
		return
	end

	if slot2 == -2 then
		slot0:SetOutput(slot1.x, slot1.y, -2)

		return
	elseif slot2 == -1 then
		slot0:SetOutput(0, 0, slot2)

		return
	end

	slot1.z = 0

	if slot0._maxbianjieSqr < slot1.SqrMagnitude(slot3) then
		if slot1 - slot3 / math.sqrt(slot4) * slot0._maxbianjie ~= slot0._firstPos then
			slot6 = slot0._firstPos
		end

		slot0._stick.localPosition = slot5

		slot0:SetOutput(slot3.x, slot3.y, slot2)
	else
		slot0._stick.localPosition = slot1

		slot0:SetOutput(slot3.x * slot0._maxbianjieInv, slot3.y * slot0._maxbianjieInv, slot2)
	end
end

pg.UIMgr.SetOutput = function (slot0, slot1, slot2, slot3)
	slot0.hrz = slot1
	slot0.vtc = slot2

	if ((slot3 >= 0 and 1) or 0) - ((slot0.fingerId >= 0 and 1) or 0) ~= 0 and slot0._areaImg and slot0._stickImg then
		slot0._areaImg.color = (slot4 > 0 and slot0._normalColor) or slot0._darkColor
		slot0._stickImg.color = (slot4 > 0 and slot0._normalColor) or slot0._darkColor
	end

	if slot3 < 0 then
		slot0._stick.localPosition = Vector3.zero
	end

	slot0.fingerId = slot3
end

pg.UIMgr.ClearStick = function (slot0)
	slot0._stick.localPosition = Vector3.zero

	slot0._stickCom:ClearStickFunc()

	slot0._stick = nil
	slot0._areaImg = nil
	slot0._stickImg = nil
	slot0._stickCom = nil
end

slot2 = {}
slot3 = false

pg.UIMgr.OverlayPanel = function (slot0, slot1, slot2)
	slot2 or {}.globalBlur = false

	slot0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, slot1, slot2 or )
end

pg.UIMgr.UnOverlayPanel = function (slot0, slot1, slot2)
	slot0.LayerWeightMgr.GetInstance():DelFromOverlay(slot1, slot2 or slot0.UIMain)
end

pg.UIMgr.BlurPanel = function (slot0, slot1, slot2, slot3)
	slot3 or {}.globalBlur = true
	slot3 or .staticBlur = slot2

	slot0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, slot1, slot3 or )
end

pg.UIMgr.UnblurPanel = function (slot0, slot1, slot2)
	slot0.LayerWeightMgr.GetInstance():DelFromOverlay(slot1, slot2 or slot0.UIMain)
end

pg.UIMgr.OverlayPanelPB = function (slot0, slot1, slot2)
	slot2 or {}.globalBlur = false

	slot0.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, slot1, slot2 or )
end

pg.UIMgr.PartialBlurTfs = function (slot0, slot1)
	slot1 = slot1

	true:UpdatePBEnable(true)
end

pg.UIMgr.ShutdownPartialBlur = function (slot0)
	slot1 = {}

	false:UpdatePBEnable(false)
end

pg.UIMgr.RevertPBMaterial = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		slot6:GetComponent(typeof(Image)).material = Material.New(Shader.Find("UI/Default")) or nil
	end
end

pg.UIMgr.UpdatePBEnable = function (slot0, slot1)
	if slot1 then
		if slot0 ~= nil then
			for slot5, slot6 in ipairs(slot0) do
				slot6:GetComponent(typeof(Image)).material = (slot1 and Material.New(Shader.Find("UI/PartialBlur"))) or nil
			end
		end

		if slot0.levelCameraComp.enabled then
			slot0.cameraBlurs[slot1.CameraLevel][slot1.PartialBlur].enabled = true
			slot0.cameraBlurs[slot1.CameraUI][slot1.PartialBlur].enabled = false
		else
			slot0.cameraBlurs[slot1.CameraLevel][slot1.PartialBlur].enabled = false
			slot0.cameraBlurs[slot1.CameraUI][slot1.PartialBlur].enabled = true
		end
	else
		for slot5, slot6 in ipairs(slot0.cameraBlurs) do
			if slot6[slot1.PartialBlur] then
				slot6[slot1.PartialBlur].enabled = false
			end
		end
	end
end

pg.UIMgr.BlurCamera = function (slot0, slot1, slot2)
	slot3 = slot0.cameraBlurs[slot1][slot0.OptimizedBlur]
	slot4 = slot0.cameraBlurs[slot1][slot0.StaticBlur]

	if slot2 then
		slot3.enabled = true
		slot3.staticBlur = true
		slot4.enabled = false
	else
		slot3.enabled = true
		slot3.staticBlur = false
		slot4.enabled = false
	end
end

pg.UIMgr.UnblurCamera = function (slot0, slot1)
	slot0.cameraBlurs[slot1][slot0.StaticBlur].enabled = false
	slot0.cameraBlurs[slot1][slot0.OptimizedBlur].enabled = false
end

pg.UIMgr.SetMainCamBlurTexture = function (slot0, slot1)
	slot2 = slot0.mainCamera:GetComponent(typeof(Camera))
	slot3 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width,
		Screen.height,
		0
	})
	slot2.targetTexture = slot3

	slot2:Render()

	slot2.targetTexture = nil

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		slot3
	})

	slot1.uvRect = slot2.rect
	slot1.texture = slot0.ShaderMgr.GetInstance():BlurTexture(slot3)

	return slot0.ShaderMgr.GetInstance().BlurTexture(slot3)
end

pg.UIMgr.GetMainCamera = function (slot0)
	return slot0.mainCamera
end

return

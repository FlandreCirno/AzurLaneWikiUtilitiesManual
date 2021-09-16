pg = pg or {}
pg.ShaderMgr = singletonClass("ShaderMgr")

pg.ShaderMgr.Init = function (slot0, slot1)
	print("initializing shader manager...")
	ResourceMgr.Inst:loadAssetBundleAsync("shader", function (slot0)
		slot0.shaders = slot0

		slot0()
	end)
end

pg.ShaderMgr.LoadShader = function (slot0, slot1, slot2, slot3)
	if slot2 then
		ResourceMgr.Inst:LoadAssetAsync(slot0.shaders, slot1, typeof(Shader), UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
			slot0(slot0)
		end), false, false)
	else
		slot3(ResourceMgr.Inst.LoadAssetSync(slot4, slot0.shaders, slot1, typeof(Shader), false, false))
	end
end

pg.ShaderMgr.GetBlurMaterialSync = function (slot0)
	if slot0.blurMaterial ~= nil then
		return slot0.blurMaterial
	else
		slot0:LoadShader("MobileBlur", false, function (slot0)
			slot0.blurMaterial = Material.New(slot0)

			slot0.blurMaterial:SetVector("_Parameter", Vector4.New(1, -1, 0, 0))
		end)

		return slot0.blurMaterial
	end
end

pg.ShaderMgr.BlurTexture = function (slot0, slot1)
	slot3 = ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	})
	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", {
		typeof("System.Int32"),
		typeof("System.Int32"),
		typeof("System.Int32")
	}, {
		Screen.width * 0.25,
		Screen.height * 0.25,
		0
	}).filterMode = ReflectionHelp.RefGetField(typeof("UnityEngine.FilterMode"), "Bilinear")

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.RenderTexture"),
		typeof("UnityEngine.Material"),
		typeof("System.Int32")
	}, {
		slot1,
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "GetTemporary", , ),
		slot0:GetBlurMaterialSync(),
		0
	})

	for slot8 = 0, 1, 1 do
		slot4:SetVector("_Parameter", Vector4.New(1 + slot8, -1 - slot8, 0, 0))
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			slot2,
			slot3,
			slot4,
			1
		})
		ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.Graphics"), "Blit", {
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.RenderTexture"),
			typeof("UnityEngine.Material"),
			typeof("System.Int32")
		}, {
			slot3,
			slot2,
			slot4,
			2
		})
	end

	ReflectionHelp.RefCallStaticMethod(typeof("UnityEngine.RenderTexture"), "ReleaseTemporary", {
		typeof("UnityEngine.RenderTexture")
	}, {
		slot3
	})

	return slot2
end

pg.ShaderMgr.SetSpineUIOutline = function (slot0, slot1, slot2)
	slot0:LoadShader("Unlit-Colored_Alpha_UI_Outline", false, function (slot0)
		slot2 = Material.New(slot0)

		slot2:SetColor("_OutlineColor", slot1)
		slot2:SetFloat("_OutlineWidth", 5.75)
		slot2:SetFloat("_ThresholdEnd", 0.2)

		GetComponent(slot0, "SkeletonGraphic").material = slot2
	end)
end

pg.ShaderMgr.DelSpineUIOutline = function (slot0, slot1)
	GetComponent(slot1, "SkeletonGraphic").material = nil
end

return

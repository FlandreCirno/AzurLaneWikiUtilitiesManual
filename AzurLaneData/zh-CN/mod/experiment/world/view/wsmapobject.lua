slot0 = class("WSMapObject", import("...BaseEntity"))
slot0.Fields = {
	modelType = "number",
	modelAction = "string",
	modelResPath = "string",
	modelParent = "userdata",
	modelAngles = "table",
	modelActionTimer = "table",
	modelScale = "table",
	model = "userdata",
	modelComps = "table",
	modelResAsync = "boolean",
	modelResName = "string"
}

slot0.GetModelAngles = function (slot0)
	return (slot0.modelAngles and slot0.modelAngles:Clone()) or Vector3.zero
end

slot0.UpdateModelAngles = function (slot0, slot1)
	if slot0.modelAngles ~= slot1 then
		slot0.modelAngles = slot1

		slot0:FlushModelAngles()
	end
end

slot0.FlushModelAngles = function (slot0)
	if slot0.model and slot0.modelAngles then
		slot0.model.localEulerAngles = slot0.modelAngles
	end
end

slot0.GetModelScale = function (slot0)
	return (slot0.modelScale and slot0.modelScale:Clone()) or Vector3.one
end

slot0.UpdateModelScale = function (slot0, slot1)
	if slot0.modelScale ~= slot1 then
		slot0.modelScale = slot1

		slot0:FlushModelScale()
	end
end

slot0.GetModelAction = function (slot0)
	return slot0.modelAction
end

slot0.FlushModelScale = function (slot0)
	if slot0.model and slot0.modelScale then
		slot0.model.localScale = slot0.modelScale
	end
end

slot0.UpdateModelAction = function (slot0, slot1)
	if slot0.modelAction ~= slot1 then
		slot0.modelAction = slot1

		slot0:FlushModelAction()
	end
end

slot0.FlushModelAction = function (slot0)
	if slot0.model and slot0.modelAction then
		if slot0.modelType == WorldConst.ModelSpine then
			if slot0.modelComps and slot0.modelComps[1] then
				slot1:SetAction(slot0.modelAction, 0)
			end
		elseif slot0.modelType == WorldConst.ModelPrefab and slot0.modelComps and slot0.modelComps[1] and slot1:HasState(0, Animator.StringToHash(slot0.modelAction)) then
			slot1:Play(slot2)
		end
	end
end

slot0.PlayModelAction = function (slot0, slot1, slot2, slot3)
	slot4 = {}

	if slot0.model then
		if slot0.modelType == WorldConst.ModelSpine then
			if slot0.modelComps and slot0.modelComps[1] and slot5.transform.gameObject.activeInHierarchy then
				table.insert(slot4, function (slot0)
					slot0:SetAction(slot0.SetAction, 0)

					if slot0 then
						slot3:NewActionTimer(slot3, slot0)
					else
						slot0:SetActionCallBack(function (slot0)
							if slot0 == "finish" then
								slot0:SetActionCallBack(nil)
								slot0.SetActionCallBack()
							end
						end)
					end
				end)
			end
		elseif slot0.modelType == WorldConst.ModelPrefab then
			if slot0.modelComps and slot0.modelComps[1] and slot5.transform.gameObject.activeInHierarchy then
				if slot5:HasState(0, Animator.StringToHash(slot1)) then
					table.insert(slot4, function (slot0)
						slot0:Play(slot0.Play)

						if slot0 then
							slot3:NewActionTimer(slot3, slot0)
						else
							slot3.modelComps[2]:SetEndEvent(function ()
								slot0:SetEndEvent(nil)
								slot0()
							end)
						end
					end)
				end
			end
		end
	end

	seriesAsync(slot4, slot3)
end

slot0.LoadModel = function (slot0, slot1, slot2, slot3, slot4, slot5)
	if slot0.modelType ~= slot1 or slot0.modelResPath ~= slot2 or slot0.modelResName ~= slot3 then
		slot0:UnloadModel()

		slot0.model = createNewGameObject("model")
		slot0.modelType = slot1
		slot0.modelResPath = slot2
		slot0.modelResName = slot3
		slot0.modelResAsync = defaultValue(slot4, true)
		slot6 = {}

		if slot0.modelType == WorldConst.ModelSpine then
			slot0.modelAction = slot0.modelAction or WorldConst.ActionIdle

			table.insert(slot6, function (slot0)
				slot0:LoadSpine(slot0)
			end)
		elseif slot0.modelType == WorldConst.ModelPrefab then
			slot0.modelAction = slot0.modelAction or "idle"

			table.insert(slot6, function (slot0)
				slot0:LoadPrefab(slot0)
			end)
		end

		seriesAsync(slot6, function ()
			if slot0.modelScale == nil then
				slot0.modelScale = slot0.model.localScale
			else
				slot0:FlushModelScale()
			end

			if slot0.modelAngles == nil then
				slot0.modelAngles = slot0.model.localEulerAngles
			else
				slot0:FlushModelAngles()
			end

			slot0:FlushModelAction()

			if slot0 then
				slot1()
			end
		end)
	end
end

slot0.UnloadModel = function (slot0)
	slot0:DisposeActionTimer()

	if slot0.model then
		if slot0.model.childCount > 0 then
			if slot0.modelType == WorldConst.ModelSpine then
				slot0:UnloadSpine()
			elseif slot0.modelType == WorldConst.ModelPrefab then
				slot0:UnloadPrefab()
			end
		end

		Destroy(slot0.model)
	end

	slot0.model = nil
	slot0.modelComps = nil
	slot0.modelType = nil
	slot0.modelResPath = nil
	slot0.modelResName = nil
	slot0.modelResAsync = nil
end

slot0.LoadSpine = function (slot0, slot1)
	PoolMgr.GetInstance():GetSpineChar(slot0.modelResPath, slot0.modelResAsync, function (slot0)
		if slot0.modelType ~= WorldConst.ModelSpine or slot0.modelResPath ~=  then
			PoolMgr.GetInstance():ReturnSpineChar(PoolMgr.GetInstance().ReturnSpineChar, slot0)

			return
		end

		slot0.transform.GetComponent(slot1, "SkeletonGraphic").raycastTarget = false
		slot0.transform.anchoredPosition3D = Vector3.zero
		slot0.transform.localScale = Vector3.one

		pg.ViewUtils.SetLayer(slot1, Layer.UI)
		slot0.transform.SetParent(slot1, slot0.model, false)

		slot0.modelComps = {
			slot0.transform:GetComponent("SpineAnimUI")
		}

		slot0()
	end)
end

slot0.LoadPrefab = function (slot0, slot1)
	PoolMgr.GetInstance():GetPrefab(slot0.modelResPath, slot0.modelResName, slot0.modelResAsync, function (slot0)
		if slot0.modelType ~= WorldConst.ModelPrefab or slot0.modelResPath ~=  or slot0.modelResName ~= slot2 then
			PoolMgr.GetInstance():ReturnPrefab(PoolMgr.GetInstance().ReturnPrefab, PoolMgr.GetInstance(), slot0, true)

			return
		end

		for slot5 = 0, slot0:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
			slot1[slot5].raycastTarget = false
		end

		slot0.transform:SetParent(slot0.model, false)

		slot0.modelComps = {}

		if slot0:GetComponentInChildren(typeof(Animator)) then
			slot0.modelComps = {
				slot2,
				slot2:GetComponent("DftAniEvent")
			}
		end

		slot3()
	end)
end

slot0.UnloadSpine = function (slot0)
	slot0.modelComps[1].SetActionCallBack(slot1, nil)
	PoolMgr.GetInstance():ReturnSpineChar(slot0.modelResPath, slot0.model:GetChild(0).gameObject)
end

slot0.UnloadPrefab = function (slot0)
	if slot0.modelComps[2] then
		slot1:SetEndEvent(nil)
	end

	PoolMgr.GetInstance():ReturnPrefab(slot0.modelResPath, slot0.modelResName, slot0.model:GetChild(0).gameObject, true)
end

slot0.NewActionTimer = function (slot0, slot1, slot2)
	slot0:DisposeActionTimer()

	slot0.modelActionTimer = Timer.New(slot2, slot1, 1)

	slot0.modelActionTimer:Start()
end

slot0.DisposeActionTimer = function (slot0)
	if slot0.modelActionTimer then
		slot0.modelActionTimer:Stop()

		slot0.modelActionTimer = nil
	end
end

return slot0

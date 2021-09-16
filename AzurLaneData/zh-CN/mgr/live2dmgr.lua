pg = pg or {}
pg.Live2DMgr = singletonClass("Live2DMgr")
this = pg.Live2DMgr

this.GetLive2DModelAsync = function (slot0, slot1, slot2)
	slot3, slot7 = HXSet.autoHxShift("live2d/", slot1)

	slot0:AddRefCount(slot4)
	LoadAndInstantiateAsync("live2d", slot1, function (slot0)
		slot0(slot0)
	end)
end

this.TryReleaseLive2dRes = function (slot0, slot1)
	slot2, slot6 = HXSet.autoHxShift("live2d/", slot1)

	if slot0:SubRefCount(slot3) then
		slot0:ReleaseLive2dRes(slot1)
	end
end

this.ReleaseLive2dRes = function (slot0, slot1)
	slot2, slot5 = HXSet.autoHxShift("live2d/", slot1)

	ResourceMgr.Inst:ClearBundleRef("live2d/" .. slot3, true, true)
end

this.AddRefCount = function (slot0, slot1)
	slot0.refCounterDic = slot0.refCounterDic or {}

	if not slot0.refCounterDic[slot1] then
		slot0.refCounterDic[slot1] = 1
	else
		slot0.refCounterDic[slot1] = slot0.refCounterDic[slot1] + 1
	end
end

this.SubRefCount = function (slot0, slot1)
	if slot0.refCounterDic and slot0.refCounterDic[slot1] then
		slot0.refCounterDic[slot1] = slot0.refCounterDic[slot1] - 1

		if slot0.refCounterDic[slot1] <= 0 then
			slot0.refCounterDic[slot1] = nil

			return true
		end
	else
		return true
	end

	return false
end

return

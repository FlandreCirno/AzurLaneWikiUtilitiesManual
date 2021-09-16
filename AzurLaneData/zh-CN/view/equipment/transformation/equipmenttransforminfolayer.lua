slot0 = class("EquipmentTransformInfoLayer", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "EquipmentTransformInfoUI"
end

slot0.init = function (slot0)
	slot0.loader = AutoLoader.New()
end

slot0.didEnter = function (slot0)
	updateDrop(slot2, slot3)
	onButton(slot0, slot2, function ()
		slot0:emit(slot1.ON_DROP, )
	end, SFX_PANEL)

	slot4 = nil

	pg.UIMgr.GetInstance().BlurPanel(slot5, slot0._tf)
	slot0.loader:GetPrefab("ui/equipupgradeAni", "", function (slot0)
		setParent(slot0, slot0._tf)
		setActive(slot0, true)

		slot1 = slot0:GetComponent(typeof(DftAniEvent))

		slot1:SetTriggerEvent(function (slot0)
			slot0 = true
		end)
		slot1.SetEndEvent(slot1, function (slot0)
			slot0:closeView()
		end)

		slot0.unloadEffect = function ()
			slot0:SetTriggerEvent(nil)
			slot0.SetTriggerEvent:SetEndEvent(nil)
		end
	end)
	onButton(slot0, slot0._tf, function ()
		if slot0 then
			slot1:closeView()
		end
	end)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)

	if slot0.unloadEffect then
		slot0.unloadEffect()
	end

	slot0.loader:Clear()
end

return slot0

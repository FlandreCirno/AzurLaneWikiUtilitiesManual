slot0 = class("SVRealmPanel", import("view.base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "SVRealmPanel"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot2 = slot0._tf.Find(slot1, "panel")
	slot0.btnBLHX = slot2:Find("blhx")
	slot0.btnCSZZ = slot2:Find("cszz")

	setActive(slot0.btnBLHX, true)
	setActive(slot0.btnCSZZ, true)
	onButton(slot0, slot0.btnBLHX, function ()
		slot0:PlayAnim(slot0.btnBLHX, function ()
			slot0:Hide()
			slot0.Hide.onConfirm(1)
		end)
	end, SFX_PANEL)
	onButton(slot0, slot0.btnCSZZ, function ()
		slot0:PlayAnim(slot0.btnCSZZ, function ()
			slot0:Hide()
			slot0.Hide.onConfirm(2)
		end)
	end)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
end

slot0.Setup = function (slot0, slot1)
	slot0.onConfirm = slot1
end

slot0.PlayAnim = function (slot0, slot1, slot2)
	setActive(slot3, true)
	LeanTween.value(go(slot3), 1, 1.2, 0.2):setOnUpdate(System.Action_float(function (slot0)
		slot0.localScale = Vector3(slot0, slot0, 1)
	end)).setOnComplete(slot4, System.Action(function ()
		setActive(setActive, false)

		setActive.localScale = Vector3(1, 1, 1)

		Vector3(1, 1, 1)()
	end))
	LeanTween.value(go(slot3), 1, 0.7, 0.2)
end

return slot0

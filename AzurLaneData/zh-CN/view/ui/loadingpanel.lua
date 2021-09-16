slot0 = class("LoadingPanel", import("..base.BaseUI"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0)
	seriesAsync({
		function (slot0)
			slot0:preload(slot0)
		end
	}, function ()
		PoolMgr.GetInstance():GetUI("Loading", true, function (slot0)
			slot0.transform:SetParent(GameObject.Find("Overlay/UIOverlay").transform, false)
			slot0:SetActive(false)
			slot0:onUILoaded(slot0)
			GameObject.Find("Overlay/UIOverlay")()
		end)
	end)
end

slot0.preload = function (slot0, slot1)
	slot0.isCri, slot0.bgPath = getLoginConfig()

	if slot0.isCri then
		LoadAndInstantiateAsync("effect", slot0.bgPath, function (slot0)
			slot0.criBgGo = slot0

			if slot0 then
				slot1()
			end
		end)
	else
		LoadSpriteAsync("loadingbg/" .. slot0.bgPath, function (slot0)
			slot0.staticBgSprite = slot0

			if slot0 then
				slot1()
			end
		end)
	end
end

slot0.init = function (slot0)
	slot0.infos = slot0:findTF("infos")
	slot0.infoTpl = slot0:getTpl("infos/info_tpl")
	slot0.indicator = slot0:findTF("load")
	slot0.bg = slot0:findTF("BG")
	slot0.logo = slot0:findTF("logo")

	slot0:displayBG(true)
end

slot0.appendInfo = function (slot0, slot1)
	setText(slot2, slot1)

	slot4 = LeanTween.alphaCanvas(slot3, 0, 0.3)

	slot4:setDelay(1.5)
	slot4:setOnComplete(System.Action(function ()
		destroy(destroy)
	end))
end

slot0.onLoading = function (slot0)
	return slot0._go.activeInHierarchy
end

slot1 = 0

slot0.on = function (slot0, slot1)
	setImageAlpha(slot0._tf, (defaultValue(slot1, true) and 0.01) or 0)

	if slot1 then
		pg.TimeMgr.GetInstance():RemoveTimer(slot0.delayTimer)

		slot0.delayTimer = pg.TimeMgr.GetInstance():AddTimer("loading", 1, 0, function ()
			setImageAlpha(slot0._tf, 0.2)
			setActive(slot0.indicator, true)

			setActive.delayTimer = nil
		end)
	else
		setActive(slot0.indicator, false)
	end

	if slot0 + 1 > 0 then
		setActive(slot0._go, true)
		slot0._go.transform.SetAsLastSibling(slot2)
	end
end

slot0.off = function (slot0)
	if slot0 > 0 and slot0 - 1 == 0 then
		setActive(slot0._go, false)
		setActive(slot0.indicator, false)
		pg.TimeMgr.GetInstance():RemoveTimer(slot0.delayTimer)

		slot0.delayTimer = nil
	end
end

slot0.displayBG = function (slot0, slot1)
	setActive(slot0.bg, slot1)
	setActive(slot0.logo, slot1)

	slot2 = GetComponent(slot0.bg, "Image")

	if slot1 then
		if not slot0.isCri then
			if IsNil(slot2.sprite) then
				slot2.sprite = slot0.staticBgSprite
			end
		elseif slot0.bg.childCount == 0 then
			slot2.enabled = false

			slot0.criBgGo.transform.SetParent(slot3, slot0.bg.transform, false)
			slot0.criBgGo.transform:SetAsFirstSibling()
		end
	else
		if not slot0.isCri then
			slot2.sprite = nil
		else
			removeAllChildren(slot0.bg)
		end

		slot0.criBgGo = nil
		slot0.staticBgSprite = nil
	end
end

slot0.getRetainCount = function (slot0)
	return slot0
end

return slot0

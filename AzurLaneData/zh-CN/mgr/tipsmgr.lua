pg = pg or {}
pg.TipsMgr = singletonClass("TipsMgr")

pg.TipsMgr.Ctor = function (slot0)
	slot0._go = nil
end

pg.TipsMgr.Init = function (slot0, slot1)
	print("initializing tip manager...")

	slot0._count = 0
	slot0._tipTable = {}

	PoolMgr.GetInstance():GetUI("TipPanel", true, function (slot0)
		slot0._go = slot0

		slot0._go:SetActive(false)
		slot0._go.transform:SetParent(GameObject.Find("Overlay/UIOverlay").transform, false)

		slot0._tips = slot0._go.transform:Find("toolTip")
		slot0._picTips = slot0._go.transform:Find("toolPicTip")
		slot0._grid = slot0._go.transform:Find("Grid")

		GameObject.Find("Overlay/UIOverlay")()
	end)
end

pg.TipsMgr.ShowTips = function (slot0, slot1, slot2, slot3)
	slot0.CriMgr.GetInstance():PlaySoundEffect_V3(slot3 or SFX_UI_TIP)
	slot0._go.transform:SetAsLastSibling()
	SetActive(slot0._go, true)

	slot0._count = slot0._count + 1
	slot4 = cloneTplTo(slot0._tips, slot0._grid)

	setText(slot4.transform:Find("Text"), "<color=" .. (slot2 or "white") .. ">" .. slot1 .. "</color>")

	slot4.transform.localScale = Vector3(0, 0.1, 1)

	LeanTween.scale(slot4, Vector3(1.8, 0.1, 1), 0.1):setUseEstimatedTime(true)
	LeanTween.scale(slot4, Vector3(1.1, 1.1, 1), 0.1):setDelay(0.1):setUseEstimatedTime(true)

	function slot6(slot0, slot1)
		slot2 = GetOrAddComponent(slot0, "CanvasGroup")

		Timer.New(function ()
			if IsNil(IsNil) then
				return
			end

			LeanTween.scale(LeanTween.scale, Vector3(0.1, 1.5, 1), 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function ()
				LeanTween.scale(LeanTween.scale, Vector3.zero, 0.1):setUseEstimatedTime(true):setOnComplete(System.Action(function ()
					Destroy(Destroy)

					for slot3, slot4 in pairs(Destroy._tipTable) do
						if slot4 == slot0 then
							table.remove(slot1._tipTable, slot3)
						end
					end

					slot1._count = slot1._count - 1

					if slot1._count == 0 then
						SetActive(slot1._go, false)
					end
				end))
			end))
		end, 3).Start(slot3)
	end

	if slot0._count <= 3 then
		slot0._tipTable[slot0._count] = slot4

		slot6(slot4, slot0._count)
	else
		Destroy(slot0._tipTable[1])
		table.remove(slot0._tipTable, 1)

		slot0._count = 3
		slot0._tipTable[3] = slot4

		slot6(slot4, slot0._count)
	end
end

pg.TipsMgr.ShowPicTips = function (slot0, slot1, slot2, slot3, slot4)
	slot0.CriMgr.GetInstance():PlaySoundEffect_V3(slot4 or SFX_UI_TIP)
	slot0._go.transform:SetAsLastSibling()
	SetActive(slot0._go, true)

	slot0._count = slot0._count + 1

	setText(cloneTplTo(slot0._picTips, slot0._grid).transform:Find("Text"), "<color=" .. (slot3 or "white") .. ">\"" .. slot1 .. "\" x" .. slot2 .. "</color>")

	function slot7(slot0)
		GetOrAddComponent(slot0, "CanvasGroup").alpha = 1
		slot2 = LeanTween.alphaCanvas(slot1, 0, 5):setUseEstimatedTime(true):setOnComplete(System.Action(function ()
			Destroy(Destroy)

			for slot3, slot4 in pairs(Destroy._tipTable) do
				if slot4 == slot0 then
					table.remove(slot1._tipTable, slot3)
				end
			end

			slot1._count = slot1._count - 1

			if slot1._count == 0 then
				SetActive(slot1._go, false)
			end
		end))
	end

	if slot0._count <= 3 then
		slot0._tipTable[slot0._count] = slot5

		slot7(slot5)
	else
		Destroy(slot0._tipTable[1])
		table.remove(slot0._tipTable, 1)

		slot0._count = 3
		slot0._tipTable[3] = slot5

		slot7(slot5)
	end
end

return

pg = pg or {}
pg.TrophyReminderMgr = singletonClass("TrophyReminderMgr")

pg.TrophyReminderMgr.Ctor = function (slot0)
	slot0._go = nil
end

pg.TrophyReminderMgr.Init = function (slot0, slot1)
	print("initializing tip manager...")

	slot0._count = 0
	slot0._tipTable = {}

	PoolMgr.GetInstance():GetUI("TrophyRemindPanel", true, function (slot0)
		slot0._go = slot0

		slot0._go:SetActive(false)
		slot0._go.transform:SetParent(GameObject.Find("Overlay/UIOverlay").transform, false)

		slot0._tips = slot0._go.transform:Find("trophyRemind")
		slot0._grid = slot0._go.transform:Find("Grid_trophy")

		GameObject.Find("Overlay/UIOverlay")()
	end)
end

pg.TrophyReminderMgr.ShowTips = function (slot0, slot1)
	slot0.CriMgr.GetInstance():PlaySoundEffect_V3(sound or SFX_UI_TIP)
	slot0._go.transform:SetAsLastSibling()
	SetActive(slot0._go, true)

	slot0._count = slot0._count + 1
	slot2 = cloneTplTo(slot0._tips, slot0._grid)

	LoadImageSpriteAsync("medal/s_" .. slot0.medal_template[slot1].icon, slot2.transform:Find("content/icon"), true)
	setText(slot2.transform:Find("content/name"), slot0.medal_template[slot1].name)
	setText(slot2.transform:Find("content/label"), i18n("trophy_achieved"))

	slot2.transform:Find("content").localPosition = Vector3(-850, 0, 0)

	function slot5(slot0)
		LeanTween.moveX(rtf(slot0), -275, 0.5)
		LeanTween.moveX(rtf(slot0), -850, 0.5):setDelay(5):setOnComplete(System.Action(function ()
			Destroy(Destroy)

			Destroy._count = Destroy._count - 1

			if slot1._count == 0 then
				SetActive(slot1._go, false)
			end
		end))
	end

	slot5(slot2, slot0._count)
end

return

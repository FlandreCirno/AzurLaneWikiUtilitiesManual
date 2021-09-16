slot0 = class("TowerClimbBgMgr")
slot1 = {
	{
		"1",
		"2",
		"3"
	},
	{
		"4",
		"5",
		"6"
	},
	{
		"7",
		"8",
		"9"
	}
}
slot0.effects = {
	{
		{
			"pata_jiandan",
			{
				0,
				-179.5
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				46
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				61.5
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				-179.5
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				46
			}
		}
	},
	{
		{
			"pata_jiandan",
			{
				0,
				61.5
			}
		}
	},
	{
		{
			"pata_kunan",
			{
				0,
				-834.5
			}
		},
		{
			"pata_shandian01",
			{
				370,
				-47.5
			}
		},
		{
			"pata_shandian02",
			{
				370,
				601.5
			}
		}
	},
	{
		{
			"pata_shandian03",
			{
				-210,
				-764
			}
		},
		{
			"pata_shandian04",
			{
				220,
				-259
			}
		},
		{
			"pata_shandian03",
			{
				-210,
				252
			}
		},
		{
			"pata_shandian04",
			{
				252,
				639
			}
		}
	},
	{
		{
			"pata_shandian03",
			{
				-299,
				-99.50002
			}
		},
		{
			"pata_shandian04",
			{
				324,
				174.5
			}
		},
		{
			"pata_kunan",
			{
				0,
				52.5
			}
		}
	}
}

slot0.Ctor = function (slot0, slot1)
	slot0.tr = slot1
end

slot0.Init = function (slot0, slot1, slot2)
	slot0.bgMaps = slot1[slot1]
	slot0.list = {
		slot0.tr:Find("Image1"),
		slot0.tr:Find("Image2"),
		slot0.tr:Find("Image3")
	}
	slot0.names = {}
	slot3 = {}

	for slot7 = 1, 2, 1 do
		setActive(slot0.list[slot7], false)
		table.insert(slot3, function (slot0)
			slot1 = slot0:GetBg(slot0.GetBg)

			slot0:LoadImage(slot1, function (slot0)
				setActive(slot0.list[slot1], true)

				slot0.list[]:GetComponent(typeof(Image)).sprite = slot0

				slot0.list[]:GetComponent(typeof(Image)):SetNativeSize()
				slot0.list[].GetComponent(typeof(Image))()
			end)

			slot0.names[slot0.list[slot1]] = slot1

			slot0.LoadEffect(slot2, slot1, slot0.list[slot1])
		end)
	end

	seriesAsync(slot3, function ()
		for slot4, slot5 in ipairs(slot0.list) do
			if slot0.list[slot4 - 1] then
				slot0 = slot0 + slot6.rect.height
			end

			setAnchoredPosition(slot5, {
				x = 0,
				z = 0,
				y = slot0
			})
		end

		slot1()
	end)
end

slot0.DoMove = function (slot0, slot1, slot2)
	slot3 = {}
	slot4 = nil

	for slot8, slot9 in ipairs(slot0.list) do
		if slot9 then
			slot4 = slot4 or slot8

			table.insert(slot3, function (slot0)
				LeanTween.value(slot0.gameObject, slot0.anchoredPosition.y, getAnchoredPosition(slot0).y - slot1 * 0.8, 0.2):setOnUpdate(System.Action_float(function (slot0)
					setAnchoredPosition(slot0, {
						y = slot0
					})
				end)).setEase(slot2, LeanTweenType.easeOutQuad):setOnComplete(System.Action(slot0))
			end)
		end
	end

	parallelAsync(slot3, function ()
		slot0:DoCheck(slot0)
		slot0()
	end)
end

slot0.DoCheck = function (slot0, slot1)
	slot3 = slot0.list[slot1 + 2]

	if (getAnchoredPosition(slot2).y + slot0.list[slot1].rect.height + slot0.list[slot1 + 1].rect.height) - slot0.tr.rect.height >= 50 then
		slot6 = slot3:GetComponent(typeof(Image))

		if slot0.names[slot3] ~= slot0:GetBg(slot1 + 2) then
			slot0:LoadImage(slot7, function (slot0)
				setActive(slot0, true)

				setActive.sprite = slot0

				setActive:SetNativeSize()
			end)
			slot0.LoadEffect(slot0, slot7, slot3)

			slot0.names[slot3] = slot7
		end
	end

	if slot2.rect.height <= math.abs(slot4.y) then
		slot2:GetComponent(typeof(Image)).sprite = nil
		slot0.names[slot2] = nil

		slot2:SetAsFirstSibling()

		slot0.list[slot1 + 3] = slot2
		slot0.list[slot1] = false

		setAnchoredPosition(slot2, {
			y = getAnchoredPosition(slot3).y + slot3.rect.height
		})
		slot0:ReturnEffect(slot2)
	end
end

slot0.GetBg = function (slot0, slot1)
	return slot0.bgMaps[slot1] or slot0.bgMaps[#slot0.bgMaps]
end

slot0.LoadImage = function (slot0, slot1, slot2)
	LoadSpriteAtlasAsync("clutter/towerclimbing_bg" .. slot1, nil, function (slot0)
		slot0(slot0)
	end)
end

slot0.LoadEffect = function (slot0, slot1, slot2)
	if slot0.effects[tonumber(slot1)] then
		for slot7, slot8 in ipairs(slot3) do
			slot10 = slot8[2]

			PoolMgr.GetInstance():GetUI(slot8[1], true, function (slot0)
				if not slot0.list then
					PoolMgr.GetInstance():ReturnUI(PoolMgr.GetInstance().ReturnUI, slot0)
				else
					slot0.name = slot1

					SetParent(slot0, )

					slot0.transform.anchoredPosition3D = Vector3(slot0[1], slot3[2], -200)

					setActive(slot0, true)
				end
			end)
		end
	end
end

slot0.ReturnEffect = function (slot0, slot1)
	if slot1.childCount > 0 then
		for slot6 = 1, slot2, 1 do
			PoolMgr.GetInstance():ReturnUI(slot1:GetChild(slot6 - 1).name, slot1.GetChild(slot6 - 1).gameObject)
		end
	end
end

slot0.Clear = function (slot0)
	eachChild(slot0.tr, function (slot0)
		slot0:GetComponent(typeof(Image)).sprite = nil

		slot0:ReturnEffect(slot0)
	end)

	slot0.list = nil
	slot0.names = nil
end

return slot0

slot0 = class("AttachmentLBAntiAirCell", import("view.level.cell.StaticCellView"))

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot0:PrepareBase("antiAir")

		slot2 = pg.land_based_template[slot1.attachmentId]

		slot0:GetLoader():GetPrefab("leveluiview/Tpl_AntiAirGun", "Tpl_AntiAirGun", function (slot0)
			setParent(slot0, slot0.tf)

			tf(slot0).anchoredPosition3D = Vector3(0, 10, 0)
			slot0.antiAirGun = slot0

			slot0:Update()
		end)
		slot0.GetLoader(slot0):GetPrefab("leveluiview/Tpl_AntiAirGunArea", "Tpl_AntiAirGunArea", function (slot0)
			setParent(slot0, slot0.grid.restrictMap)

			slot0.name = "chapter_cell_mark_" .. slot1.row .. "_" .. slot1.column .. "#AntiAirGunArea"
			slot2 = slot0.chapter.theme.GetLinePosition(slot1, slot0.line.row, slot0.line.column)
			tf(slot0).anchoredPosition = Vector2(slot2.x - slot0.grid.restrictMap.anchoredPosition.x, slot2.y - slot0.grid.restrictMap.anchoredPosition.y)
			tf(slot0).sizeDelta = Vector2((slot2.function_args[1] * 2 + 1) * slot0.chapter.theme.cellSize.x + slot2.function_args[1] * 2 * slot0.chapter.theme.cellSpace.x, (slot2.function_args[1] * 2 + 1) * slot0.chapter.theme.cellSize.y + slot2.function_args[1] * 2 * slot0.chapter.theme.cellSpace.y)
		end)
	end

	if slot0.antiAirGun and slot1.flag ~= 1 then
		setActive(tf(slot0.antiAirGun):Find("text"), slot0.chapter.getRoundNum(slot5) < math.ceil(slot1.data / 2))

		tf(slot0.antiAirGun):Find("Slider"):GetComponent(typeof(Slider)).value = math.max(slot5 - slot2 + pg.land_based_template[slot1.attachmentId].function_args[2], 0) / pg.land_based_template[slot1.attachmentId].function_args[2]
	end

	setActive(slot0.tf, slot1.flag ~= 1)
end

return slot0

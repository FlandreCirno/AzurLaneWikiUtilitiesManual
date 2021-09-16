slot0 = class("AttachmentLBDockCell", import("view.level.cell.StaticCellView"))

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot0:PrepareBase("dock")
		slot0:GetLoader():GetPrefab("leveluiview/Tpl_Dockyard", "Tpl_Dockyard", function (slot0)
			setParent(slot0, slot0.tf)

			tf(slot0).anchoredPosition3D = Vector3(0, 10, 0)
			slot0.dock = tf(slot0)

			slot0:Update()
		end)
	end

	if slot0.dock then
		setActive(slot0.dock:Find("text"), slot0.chapter.getRoundNum(slot3) < math.ceil(slot1.data / 2))

		slot0.dock:Find("Slider"):GetComponent(typeof(Slider)).value = math.max(slot3 - slot5 + pg.land_based_template[slot1.attachmentId].function_args[2], 0) / pg.land_based_template[slot1.attachmentId].function_args[2]
	end

	setActive(slot0.tf, slot1.flag == 0)
end

return slot0

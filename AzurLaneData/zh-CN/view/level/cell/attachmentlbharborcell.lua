slot0 = class("AttachmentLBHarborCell", import("view.level.cell.StaticCellView"))

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot0:PrepareBase("box_gangkou")
		slot0:GetLoader():GetPrefab("leveluiview/Tpl_Box", "Tpl_Box", function (slot0)
			setParent(slot0, slot0.tf)

			tf(slot0).anchoredPosition3D = Vector3(0, 30, 0)

			slot0:GetLoader():GetPrefab("boxprefab/gangkou", "gangkou", function (slot0)
				tf(slot0):SetParent(tf(slot0):Find("icon"), false)
			end)

			slot0.box = slot0

			slot0.Update(slot1)
		end)
	end

	if slot0.box then
		setActive(findTF(slot0.box, "effect_found"), slot1.trait == ChapterConst.TraitVirgin)

		if slot1.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end

	setActive(slot0.tf, slot1.flag == 0)
end

return slot0

slot0 = class("AttachmentBoxCell", import("view.level.cell.StaticCellView"))

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot2 = pg.box_data_template[slot1.attachmentId]

		slot0:PrepareBase(slot3)

		slot4, slot5 = nil

		parallelAsync({
			function (slot0)
				slot0:GetLoader():GetPrefab("boxprefab/" .. slot1.icon, slot1.icon, function (slot0)
					slot0 = slot0

					slot1()
				end)
			end,
			function (slot0)
				slot0:GetLoader():GetPrefab("leveluiview/tpl_box", "tpl_box", function (slot0)
					setParent(tf(slot0), slot1.tf)

					tf(slot0).anchoredPosition3D = Vector3(0, 30, 0)

					if slot2.type ~= ChapterConst.BoxTorpedo then
						LeanTween.move(tf(slot0), Vector3(0, 40, 0), 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().attachTw = LeanTween.move(tf(slot0), Vector3(0, 40, 0), 1.5).setEase(LeanTweenType.easeInOutSine).setLoopPingPong().uniqueId
					end

					slot1.box = slot0

					slot3()
				end)
			end
		}, function ()
			setParent(setParent, tf(slot1):Find("icon"))
			slot2:ResetCanvasOrder()
			slot2:Update()
		end)
	end

	if slot0.box and slot1.flag == 0 then
		setActive(findTF(slot0.box, "effect_found"), slot1.trait == ChapterConst.TraitVirgin)

		if slot1.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end

	setActive(slot0.tf, slot1.flag == 0)
end

slot0.RemoveTween = function (slot0)
	if slot0.attachTw then
		LeanTween.cancel(slot0.attachTw)
	end

	slot0.attachTw = nil
end

slot0.Clear = function (slot0)
	slot0:RemoveTween()
	slot0.super.Clear(slot0)
end

return slot0

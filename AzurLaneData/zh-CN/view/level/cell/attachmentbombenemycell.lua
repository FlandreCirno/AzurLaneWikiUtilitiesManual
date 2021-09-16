slot0 = class("AttachmentBombEnemyCell", import("view.level.cell.StaticCellView"))
slot0.StateLive = 1
slot0.StateDead = 2

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Update = function (slot0)
	slot1 = slot0.info

	if IsNil(slot0.go) then
		slot0:PrepareBase("bomb_enemy_" .. slot1.attachmentId)
	end

	slot2 = slot0.state

	if slot1.flag == 0 and slot0.state ~= slot0.StateLive then
		slot0.state = slot0.StateLive
		slot0.dead = nil

		slot0:ClearLoader()

		slot3 = pg.specialunit_template[slot1.attachmentId]

		slot0:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function (slot0)
			setParent(slot0, slot0.tf)

			tf(slot0).anchoredPosition = Vector2(0, 10)

			slot0:GetLoader():GetSprite("enemies/" .. slot1.prefab, "", findTF(slot0, "icon"))
			slot1(findTF(slot0, "titleContain/bg_s"), slot1.enemy_point == 5)
			slot1(findTF(slot0, "titleContain/bg_m"), slot1.enemy_point == 8)
			slot1(findTF(slot0, "titleContain/bg_h"), slot1.enemy_point == 10)

			slot0.enemy = slot0

			slot0:ResetCanvasOrder()
			slot0:Update()
		end)
	elseif slot1.flag == 1 and slot0.state ~= slot0.StateDead then
		slot0.state = slot0.StateDead
		slot0.enemy = nil

		slot0.ClearLoader(slot0)

		slot3 = pg.land_based_template[slot1.attachmentId]

		slot0:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function (slot0)
			setParent(slot0, slot0.tf)

			tf(slot0).anchoredPosition = Vector2(0, 10)

			slot0:GetLoader():GetSprite("enemies/" .. slot1.prefab .. "_d_blue", "", findTF(slot0, "icon"))
			setActive(findTF(slot0, "effect_not_open"), false)
			setActive(findTF(slot0, "effect_open"), false)
			setActive(slot2, findTF(slot0, "huoqiubaozha") == slot3.StateLive)

			slot0.dead = slot0

			slot0:ResetCanvasOrder()
			slot0:Update()
		end)
	end

	if slot1.flag == 0 and slot0.enemy then
		setActive(findTF(slot0.enemy, "effect_found"), slot1.trait == ChapterConst.TraitVirgin)

		if slot1.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot3, SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end
end

return slot0

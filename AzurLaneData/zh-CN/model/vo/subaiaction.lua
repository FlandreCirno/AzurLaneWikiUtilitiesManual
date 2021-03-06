slot0 = class("SubAIAction", import(".BaseVO"))

slot0.Ctor = function (slot0, slot1)
	slot0.line = {
		row = slot1.ai_pos.row,
		column = slot1.ai_pos.column
	}

	if slot1.target_pos and slot1.target_pos.row < 9999 and slot1.target_pos.column < 9999 then
		slot0.target = {
			row = slot1.target_pos.row,
			column = slot1.target_pos.column
		}
	end

	slot0.movePath = _.map(slot1.move_path, function (slot0)
		return {
			row = slot0.row,
			column = slot0.column
		}
	end)
	slot0.cellUpdates = {}

	_.each(slot1.map_update, function (slot0)
		if slot0.item_type ~= ChapterConst.AttachNone and slot0.item_type ~= ChapterConst.AttachBorn and slot0.item_type ~= ChapterConst.AttachBorn_Sub and (slot0.item_type ~= ChapterConst.AttachStory or slot0.item_data ~= ChapterConst.StoryTrigger) then
			table.insert(slot0.cellUpdates, (slot0.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(slot0)) or ChapterCell.New(slot0))
		end
	end)
end

slot0.applyTo = function (slot0, slot1, slot2)
	if slot1:getFleet(FleetType.Submarine, slot0.line.row, slot0.line.column) then
		return slot0:applyToFleet(slot1, slot3, slot2)
	end

	return false, "can not find any submarine at: [" .. slot0.line.row .. ", " .. slot0.line.column .. "]"
end

slot0.applyToFleet = function (slot0, slot1, slot2, slot3)
	slot4 = 0

	if not slot2:isValid() then
		return false, "fleet " .. slot2.id .. " is invalid."
	end

	if slot0.target then
		if slot2.restAmmo <= 0 then
			return false, "lack ammo of fleet."
		end

		if not _.detect(slot0.cellUpdates, function (slot0)
			return slot0.row == slot0.target.row and slot0.column == slot0.target.column
		end) then
			return false, "can not find cell update at: [" .. slot0.target.row .. ", " .. slot0.target.column .. "]"
		end

		if not slot3 then
			if isa(slot5, ChapterChampionPackage) then
				slot1:mergeChampion(slot5)

				slot4 = bit.bor(slot4, ChapterConst.DirtyChampion)
			else
				slot1:mergeChapterCell(slot5)

				slot4 = bit.bor(slot4, ChapterConst.DirtyAttachment)
			end

			slot2.restAmmo = slot2.restAmmo - 1
			slot4 = bit.bor(slot4, ChapterConst.DirtyFleet)
		end
	elseif #slot0.movePath > 0 then
		if _.any(slot0.movePath, function (slot0)
			return not slot0:getChapterCell(slot0.row, slot0.column) or not slot1:IsWalkable()
		end) then
			return false, "invalide move path"
		end

		if not slot3 then
			slot2.line = {
				row = slot0.movePath[#slot0.movePath].row,
				column = slot0.movePath[#slot0.movePath].column
			}
			slot4 = bit.bor(slot4, ChapterConst.DirtyFleet)
		end
	end

	return true, slot4
end

slot0.PlayAIAction = function (slot0, slot1, slot2, slot3)
	if slot1:getFleetIndex(FleetType.Submarine, slot0.line.row, slot0.line.column) then
		if slot0.target then
			slot7 = "-" .. _.detect(slot0.cellUpdates, function (slot0)
				return slot0.row == slot0.target.row and slot0.column == slot0.target.column
			end).data / 100 .. "%"

			slot2.viewComponent.doPlayStrikeAnim(slot8, slot1:getTorpedoShip(slot5), "SubTorpedoUI", function ()
				slot0.viewComponent:strikeEnemy(slot1.target, , )
			end)

			return
		end

		if #slot0.movePath > 0 then
			slot2.viewComponent.grid.moveSub(slot5, slot4, slot0.movePath, nil, slot3)
		else
			slot3()
		end
	end
end

return slot0

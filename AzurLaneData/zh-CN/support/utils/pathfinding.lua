PathFinding = class("PathFinding")
PathFinding.PrioNormal = 1
PathFinding.PrioObstacle = 1000
PathFinding.PrioForbidden = 1000000

PathFinding.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.cells = slot1
	slot0.rows = slot2
	slot0.columns = slot3
end

PathFinding.Find = function (slot0, slot1, slot2)
	slot2 = {
		row = slot2.row,
		column = slot2.column
	}

	if slot0.cells[({
		row = slot1.row,
		column = slot1.column
	})["row"]][()["column"]] < 0 or slot0.cells[slot2.row][slot2.column] < 0 then
		return 0, {}
	else
		return slot0:_Find(slot1, slot2)
	end
end

slot1 = {
	{
		1,
		0
	},
	{
		-1,
		0
	},
	{
		0,
		1
	},
	{
		0,
		-1
	}
}

PathFinding._Find = function (slot0, slot1, slot2)
	slot3 = slot0.PrioForbidden
	slot4 = {}
	slot5 = {
		slot1
	}
	slot6 = {}
	slot7 = {
		[slot1.row] = {
			[slot1.column] = {
				priority = 0,
				path = {}
			}
		}
	}

	while #slot5 > 0 do
		if table.remove(slot5, 1).row == slot2.row and slot8.column == slot2.column then
			slot3 = slot7[slot8.row][slot8.column].priority
			slot4 = slot7[slot8.row][slot8.column].path

			break
		end

		table.insert(slot6, slot8)
		_.each(slot1, function (slot0)
			if not (_.any({
				row = slot0.row + slot0[1],
				column = slot0.column + slot0[2]
			}, function (slot0)
				return slot0.row == slot0.row and slot0.column == slot0.column
			end) or _.any(_.any, function (slot0)
				return slot0.row == slot0.row and slot0.column == slot0.column
			end)) and slot1.row >= 0 and slot1.row < slot3.rows and slot1.column >= 0 and slot1.column < slot3.columns then
				if slot4[slot0.row][slot0.column].priority + slot3.cells[slot1.row][slot1.column] < slot3.cells[slot1.row][slot1.column].PrioObstacle then
					table.insert(Clone(slot3).path, slot1)

					Clone(slot3).priority = slot4
					slot4[slot1.row] = slot4[slot1.row] or {}
					slot4[slot1.row][slot1.column] = slot5
					slot6 = 0

					for slot10 = #slot1, 1, -1 do
						if slot4[slot1[slot10].row][slot1[slot10].column].priority <= slot5.priority then
							slot6 = slot10

							break
						end
					end

					table.insert(slot1, slot6 + 1, slot1)
				else
					slot6 = math.min(slot6, slot4)
				end
			end
		end)
	end

	if slot0.PrioObstacle <= slot3 then
		slot8 = 1000000
		slot9 = slot0.PrioForbidden

		for slot13, slot14 in pairs(slot7) do
			for slot18, slot19 in pairs(slot14) do
				if slot8 > math.abs(slot2.row - slot13) + math.abs(slot2.column - slot18) or (slot20 == slot8 and slot19.priority < slot9) then
					slot8 = slot20
					slot9 = slot19.priority
					slot4 = slot19.path
				end
			end
		end
	end

	return slot3, slot4
end

return PathFinding

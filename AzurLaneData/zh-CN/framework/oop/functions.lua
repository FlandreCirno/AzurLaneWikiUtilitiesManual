function printf(slot0, ...)
	print(string.format(tostring(slot0), ...))
end

function AssureTable(slot0)
	if type(slot0) ~= "table" then
		slot0 = {}
	end

	return slot0
end

function checknumber(slot0, slot1)
	return tonumber(slot0, slot1) or 0
end

math.round = function (slot0)
	return math.floor(checknumber(slot0) + 0.5)
end

function checkint(slot0)
	return math.round(checknumber(slot0))
end

function handler(slot0, slot1)
	return function (...)
		return slot0(slot1, ...)
	end
end

function handlerArg1(slot0, slot1, slot2)
	return function (...)
		return slot0(slot1, slot2, ...)
	end
end

slot0 = print
slot1 = table.concat
slot2 = table.insert
slot3 = string.rep
slot4 = type
slot5 = pairs
slot6 = tostring
slot7 = next

function print_r(slot0)
	slot1 = {
		[slot0] = "."
	}

	function slot2(slot0, slot1, slot2)
		slot3 = {}

		for slot7, slot8 in slot0(slot0) do
			slot9 = slot1(slot7)

			if slot2[slot8] then
				slot3(slot3, "+" .. slot9 .. " {" .. slot2[slot8] .. "}")
			elseif slot4(slot8) == "table" then
				slot2[slot8] = slot2 .. "." .. slot9

				slot3(slot3, "+" .. slot9 .. slot5(slot8, slot1 .. ((slot6(slot0, slot7) and "|") or " ") .. slot7(" ", #slot9), slot10))
			else
				slot3(slot3, "+" .. slot9 .. " [" .. slot1(slot8) .. "]")
			end
		end

		return slot8(slot3, "\n" .. slot1)
	end

	slot7(slot2(slot0, "", ""))
end

return

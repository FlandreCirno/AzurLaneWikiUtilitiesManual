slot0 = {
	p = pg.gameset.air_dominance_p.key_value,
	q = pg.gameset.air_dominance_q.key_value,
	s = pg.gameset.air_dominance_s.key_value,
	t = pg.gameset.air_dominance_t.key_value,
	r = pg.gameset.air_dominance_r.key_value,
	a = pg.gameset.air_dominance_a.key_value,
	x = pg.gameset.air_dominance_x.key_value,
	y = pg.gameset.air_dominance_y.key_value
}

function calcAirDominanceValue(slot0, slot1)
	slot2 = slot0:getAircraftCount()

	return (defaultValue(slot0:getProperties(slot1)[AttributeType.Air], 0) * (defaultValue(slot2[EquipType.FighterAircraft], 0) * slot0.p + defaultValue(slot2[EquipType.TorpedoAircraft], 0) * slot0.q + defaultValue(slot2[EquipType.BomberAircraft], 0) * slot0.s + defaultValue(slot2[EquipType.SeaPlane], 0) * slot0.t) * (0.8 + (slot0.level * slot0.r) / 100)) / 100 + defaultValue(slot0:getEquipmentProperties()[AttributeType.AirDominate], 0)
end

function calcAirDominanceStatus(slot0, slot1, slot2)
	slot1 = slot1 * slot0.a / (slot2 + slot0.a)

	if slot0 == 0 then
		if slot1 <= slot0.x then
			return 0
		elseif slot1 <= slot0.y then
			return 2
		else
			return 1
		end
	elseif slot0 <= slot0.x then
		if slot1 == 0 then
			return 0
		elseif slot1 <= slot0.x then
			return 0
		elseif slot1 <= slot0.y then
			if slot0 <= slot1 * 0.75 then
				return 2
			elseif slot0 <= slot1 * 1.3 then
				return 3
			else
				return 4
			end
		elseif slot0 <= slot1 * 0.5 then
			return 1
		elseif slot0 <= slot1 * 0.75 then
			return 2
		elseif slot0 <= slot1 * 1.3 then
			return 3
		else
			return 4
		end
	elseif slot0 <= slot0.y then
		if slot1 == 0 then
			return 4
		elseif slot1 <= slot0.y then
			if slot0 <= slot1 * 0.75 then
				return 2
			elseif slot0 <= slot1 * 1.3 then
				return 3
			else
				return 4
			end
		elseif slot0 <= slot1 * 0.5 then
			return 1
		elseif slot0 <= slot1 * 0.75 then
			return 2
		elseif slot0 <= slot1 * 1.3 then
			return 3
		else
			return 4
		end
	elseif slot1 == 0 then
		return 5
	elseif slot0 <= slot1 * 0.5 then
		return 1
	elseif slot0 <= slot1 * 0.75 then
		return 2
	elseif slot0 <= slot1 * 1.3 then
		return 3
	elseif slot0 <= slot1 * 2 then
		return 4
	else
		return 5
	end
end

function sortCompare(...)
	for slot3 = 1, select("#", ...), 1 do
		if type(select(slot3, ...)) == "table" then
			if slot4[1] < slot4[2] then
				return true
			elseif slot4[1] == slot4[2] then
			else
				return false
			end
		elseif type(slot4) == "boolean" then
			return slot4
		end
	end

	return false
end

function calcPositionAngle(slot0, slot1)
	return (Vector3.Cross(slot2, slot3).z > 0 and Vector2.Angle(slot2, slot3)) or -Vector2.Angle(slot2, slot3)
end

function dichotomy(slot0, slot1)
	slot2 = 1
	slot3 = #slot1
	slot4 = nil

	while slot2 < slot3 do
		if slot1[bit.rshift(slot2 + slot3, 1)] < slot0 then
			slot2 = slot4 + 1
		else
			slot3 = slot4
		end
	end

	if slot3 < slot2 then
		return
	else
		return slot2
	end
end

function DOAParabolaCalc(slot0, slot1, slot2)
	slot4 = 0
	slot5 = slot0 * math.sqrt(slot1 / 2) * 
	slot6 = nil

	while slot5 - slot4 > 0.01 do
		if slot3 > math.sqrt(slot6) + math.sqrt((slot4 + slot5) / 2 + slot2) then
			slot4 = slot6
		else
			slot5 = slot6
		end
	end

	return slot4
end

return

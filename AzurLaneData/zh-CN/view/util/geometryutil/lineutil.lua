slot1 = import(".SegmentUtil")
slot2 = 1e-06

return {
	TwoPointToCommon = function (slot0, slot1)
		return {
			a = -slot1 - slot0.y,
			b = slot1 - slot0.x,
			c = slot0.x * slot1 - slot0.y - slot0.y * slot1 - slot0.x
		}
	end,
	GetVerticalCrossPoint = function (slot0, slot1, slot2)
		slot3 = slot0(slot0, slot1)
		slot6 = nil

		return Vector2((slot3.b * (slot3.b * slot2.x - slot3.a * slot2.y) - slot3.a * slot3.c) / (slot3.a * slot3.a + slot3.b * slot3.b), (slot1.IsZero(slot3.b) and (slot3.x * (slot3.b * (slot3.b * slot2.x - slot3.a * slot2.y) - slot3.a * slot3.c) / (slot3.a * slot3.a + slot3.b * slot3.b) + slot3.c) / -slot3.b) or slot0.y)
	end
}

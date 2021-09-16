slot0 = {
	[Vector3] = 1,
	[Quaternion] = 2,
	[Vector2] = 3,
	[Color] = 4,
	[Vector4] = 5,
	[Ray] = 6,
	[Bounds] = 7,
	[Touch] = 8,
	[LayerMask] = 9,
	[RaycastHit] = 10,
	[int64] = 11,
	[uint64] = 12
}

function slot1()
	slot1 = getmetatable

	return function (slot0)
		if slot0(slot0) == nil then
			return 0
		end

		return slot1[slot1] or 0
	end
end

function AddValueType(slot0, slot1)
	slot0[slot0] = slot1
end

GetLuaValueType = slot1()

return

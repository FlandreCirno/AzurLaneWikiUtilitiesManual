slot2 = bit.bor(System.Reflection.BindingFlags.Instance, System.Reflection.BindingFlags.Public, System.Reflection.BindingFlags.NonPublic, System.Reflection.BindingFlags.FlattenHierarchy, System.Reflection.BindingFlags.Static)

return {
	RefCallStaticMethod = function (slot0, slot1, slot2, slot3)
		slot4.Destroy(nil)

		return (not slot2 or tolua.gettypemethod(slot0, slot1, slot0, Type.DefaultBinder, slot2, {}):Call(unpack(slot3))) and tolua.gettypemethod(slot0, slot1, slot0):Call()
	end,
	RefCallMethod = function (slot0, slot1, slot2, slot3, slot4)
		slot5.Destroy(nil)

		return (not slot3 or tolua.gettypemethod(slot0, slot1, slot0, Type.DefaultBinder, slot3, {}):Call(slot2, unpack(slot4))) and tolua.gettypemethod(slot0, slot1, slot0):Call(slot2)
	end,
	RefGetField = function (slot0, slot1, slot2)
		slot3 = tolua.getfield(slot0, slot1, slot0)

		slot3:Destroy()

		return slot3:Get(slot2)
	end,
	RefSetField = function (slot0, slot1, slot2, slot3)
		slot4 = tolua.getfield(slot0, slot1, slot0)

		slot4:Set(slot2, slot3)
		slot4:Destroy()
	end,
	RefGetProperty = function (slot0, slot1, slot2)
		slot3 = tolua.getproperty(slot0, slot1, slot0)

		slot3:Destroy()

		return slot3:Get(slot2, null)
	end,
	RefSetProperty = function (slot0, slot1, slot2, slot3)
		slot4 = tolua.getproperty(slot0, slot1, slot0)

		slot4:Set(slot2, slot3, null)
		slot4:Destroy()
	end
}

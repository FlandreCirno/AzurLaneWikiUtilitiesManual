slot0 = class("AsideStep", import(".StoryStep"))
slot0.ASIDE_TYPE_HRZ = 1
slot0.ASIDE_TYPE_VEC = 2

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.sequence = slot1.sequence
	slot0.asideType = slot1.asideType or slot0.ASIDE_TYPE_HRZ
	slot0.signDate = slot1.signDate
end

slot0.GetMode = function (slot0)
	return Story.MODE_ASIDE
end

slot0.GetSequence = function (slot0)
	return slot0.sequence or {}
end

slot0.GetAsideType = function (slot0)
	return slot0.asideType
end

slot0.GetDateSign = function (slot0)
	return slot0.signDate
end

return slot0

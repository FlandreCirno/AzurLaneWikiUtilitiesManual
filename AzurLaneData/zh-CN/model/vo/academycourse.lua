slot0 = class("AcademyCourse", import(".BaseVO"))
slot0.ProficiencyRate = 0.1
slot0.MaxStudyTime = 43200
slot0.MaxStudentSlot = 5
slot0.MinEnergy = 30

slot0.GetProficiencyAchieved = function (slot0, slot1, slot2, slot3)
	if math.floor(slot2 / 60) == 0 then
		return 0, _.map(slot3, function ()
			return 0
		end)
	end

	slot6 = math.min(slot1, slot4 * slot0.proficency_cost_per_min)

	return slot6, _.map(slot5, function (slot0)
		return math.min(slot0, math.floor((slot0 * slot1["proficency_to_exp_rant_" .. #slot2]) / 100))
	end)
end

slot0.Ctor = function (slot0)
	slot0.proficiency = 0
	slot0.students = {}
	slot0.timestamp = 0
end

slot0.bindConfigTable = function (slot0)
	return pg.class_upgrade_group
end

slot0.getConfig = function (slot0, slot1)
	return slot0:bindConfigTable()[slot0:getDay()][slot1]
end

slot0.getDay = function (slot0)
	slot1 = slot0.timestamp

	if not slot0:inClass() then
		slot1 = pg.TimeMgr.GetInstance():GetServerTime()
	end

	slot3 = pg.TimeMgr.GetInstance():GetServerTimestampWeek(slot1)

	if slot2 and slot3 == 7 then
		return 6
	end

	return slot3
end

slot0.getRealDay = function (slot0)
	t = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():GetServerTimestampWeek(t)
end

slot0.getExtraRate = function (slot0)
	return (slot0:getRealDay() == 7 and 2) or 1
end

slot0.existCourse = function (slot0)
	return (slot0:bindConfigTable()[slot0:getDay()] and slot2.id and slot2.id > 0) or table.getCount(slot0.students) > 0
end

slot0.inClass = function (slot0)
	return slot0.timestamp > 0
end

slot0.update = function (slot0, slot1)
	slot0.proficiency = slot1.proficiency
	slot0.students = _.map(slot1.students, function (slot0)
		return slot0
	end)
	slot0.timestamp = slot1.timestamp
end

return slot0

slot0 = class("WorldAchievement", import("...BaseEntity"))
slot0.Fields = {
	triggers = "table",
	id = "number",
	config = "table"
}

slot0.Setup = function (slot0, slot1)
	slot0.id = slot1
	slot0.config = pg.world_target_data[slot0.id]
	slot2 = {}

	for slot6, slot7 in ipairs(slot0.config.condition) do
		slot8 = WorldTrigger.New()

		slot8:Setup(slot7[1])

		slot8.progress = 0
		slot8.maxProgress = slot7[2]
		slot8.desc = slot0.config.condition_text[slot6]

		table.insert(slot2, slot8)
	end

	slot0.triggers = slot2
end

slot0.NetUpdate = function (slot0, slot1)
	slot3 = {}

	_.each(slot1, function (slot0)
		if slot0:GetTrigger(slot0.trigger_id) then
			slot1.progress = slot0.count

			if not slot1:IsAchieved() and slot1:IsAchieved() then
				if #slot0.triggers > 1 then
					table.insert(slot1, slot1:GetDesc())
				end

				if slot0:IsAchieved() then
					slot2 = slot0
				end
			end
		end
	end)

	return slot3, nil
end

slot0.GetTrigger = function (slot0, slot1)
	return _.detect(slot0.triggers, function (slot0)
		return slot0.id == slot0
	end)
end

slot0.GetTriggers = function (slot0)
	return slot0.triggers
end

slot0.IsAchieved = function (slot0)
	return _.all(slot0.triggers, function (slot0)
		return slot0:IsAchieved()
	end)
end

slot0.GetProgress = function (slot0)
	if #slot0.triggers > 1 then
		return _.reduce(slot0.triggers, 0, function (slot0, slot1)
			return slot0 + ((slot1:IsAchieved() and 1) or 0)
		end)
	else
		return slot0.triggers[1].GetProgress(slot1)
	end
end

slot0.GetMaxProgress = function (slot0)
	if #slot0.triggers > 1 then
		return #slot0.triggers
	else
		return slot0.triggers[1]:GetMaxProgress()
	end
end

return slot0

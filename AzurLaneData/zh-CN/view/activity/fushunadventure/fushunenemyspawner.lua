slot0 = class("FuShunEnemySpawner")
slot1 = 1
slot2 = 2

slot0.Ctor = function (slot0, slot1, slot2)
	slot0.parent = slot1
	slot0.index = 0
	slot0.score = 0
	slot0.changeTime = -1
	slot0.mode = slot0
	slot0.OnSpawn = slot2
	slot0.targetTime = 0
	slot0.delta = 0
	slot0.starting = false
end

slot0.Start = function (slot0, slot1, slot2, slot3)
	slot0.delta = 0
	slot0.changeTime = -1

	if slot3 then
		slot0.delta = slot2
	end

	slot0.targetTime = slot2
	slot0.mode = slot1
	slot0.starting = true

	FushunAdventureGame.LOG(" spawner time  :", slot2)
end

slot0.Update = function (slot0)
	if not slot0.starting then
		return
	end

	slot0.delta = slot0.delta + Time.deltaTime

	if slot0.targetTime <= slot0.delta then
		slot0.delta = 0

		slot0:Spawn()

		if slot0.changeTime ~= -1 then
			slot0:Start(slot0.mode, slot0.changeTime, false)
		end
	end
end

slot0.NormalMode = function (slot0)
	slot0:Start(slot0, slot0:CalcTime(slot0.score), true)
end

slot0.CarzyMode = function (slot0)
	slot0:Start(slot0, FushunAdventureGameConst.EX_ENEMY_SPAWN_TIME, true)
end

slot0.Spawn = function (slot0)
	slot1 = slot0.mode
	slot0.index = slot0.index + 1
	slot2 = slot0.index

	pg.fushunLoader:GetPrefab("FushunAdventure/" .. slot0:GetConfigByScore(slot0.score).name, "", function (slot0)
		slot0.transform:SetParent(slot0.parent, false)

		if slot0.OnSpawn then
			slot2.speed = ({
				go = slot0,
				config = slot1
			} ==  and slot1.speed) or slot1.crazy_speed
			slot2.index = slot4

			slot1(slot2)
		end
	end, slot0.GetConfigByScore(slot0.score).name)
end

slot0.GetConfigByScore = function (slot0, slot1)
	slot3 = nil

	for slot7, slot8 in ipairs(slot2) do
		slot10 = slot8[1][2]

		if slot8[1][1] <= slot1 and slot1 <= slot10 then
			slot3 = slot8

			break
		end
	end

	FushunAdventureGame.LOG("rate :", slot3 or slot2[#slot2][2], slot3 or slot2[#slot2][3], slot3 or slot2[#slot2][4], " r :", math.random(1, 100))

	slot8 = 1

	if slot3 or slot2[#slot2][2] < math.random(1, 100) and slot7 <= slot4 + slot5 then
		slot8 = 2
	elseif slot7 > slot4 + slot5 and slot7 <= 100 then
		slot8 = 3
	end

	return FushunAdventureGameConst.ENEMYS[slot8]
end

slot0.UpdateScore = function (slot0, slot1)
	slot0.score = slot1

	if slot0.mode == slot0 then
		return
	end

	if slot0.targetTime ~= slot0:CalcTime(slot1) then
		slot0.changeTime = slot2
	end
end

slot0.CalcTime = function (slot0, slot1)
	slot3 = nil

	for slot7, slot8 in ipairs(slot2) do
		slot10 = slot8[1][2]

		if slot8[1][1] <= slot1 and slot1 <= slot10 then
			slot3 = slot8

			break
		end
	end

	return math.random(slot3 or slot2[#slot2][2][1], slot3 or slot2[#slot2][2][2])
end

slot0.Stop = function (slot0)
	slot0.starting = false
end

slot0.Dispose = function (slot0)
	slot0:Stop()
end

return slot0

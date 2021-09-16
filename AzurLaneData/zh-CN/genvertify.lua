function GetBattleCheck()
	return 0
end

function GetBattleCheckResult(slot0, slot1, slot2)
	return math.floor((slot0 % 2621 * slot1 % 2621) % 2621 + slot2), tostring(math.floor((GetBattleCheck() % 3527 * slot1 % 3527) % (3527 + math.floor((slot0 % 2621 * slot1 % 2621) % 2621 + slot2))))
end

ys.BattleShipLevelVertify = {}

return

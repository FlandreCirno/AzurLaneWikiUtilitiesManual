slot0 = class("VoteGroup", import("..BaseVO"))
slot0.VOTE_STAGE = 1
slot0.STTLEMENT_STAGE = 2
slot0.DISPLAY_STAGE = 3

slot0.Ctor = function (slot0, slot1)
	slot0.id = slot1.id
	slot0.configId = slot0.id
	slot0.list = slot1.list
	slot0.onWeb = slot1.onWeb

	slot0:updateRankMap()
end

slot0.isWeb = function (slot0)
	return slot0.onWeb
end

slot0.bindConfigTable = function (slot0)
	return pg.activity_vote
end

slot0.isResurrectionRace = function (slot0)
	return slot0:getConfig("type") == 4
end

slot0.isFinalsRace = function (slot0)
	return slot0:getConfig("type") == 5
end

slot0.getList = function (slot0)
	return slot0.list
end

slot0.UpdateVoteCnt = function (slot0, slot1, slot2)
	for slot6, slot7 in ipairs(slot0.list) do
		if slot7:isSamaGroup(slot1) then
			slot7:UpdateVoteCnt(slot2)
		end
	end

	slot0:updateRankMap()
end

slot0.updateRankMap = function (slot0)
	slot1 = slot0:GetStage()

	table.sort(slot0.list, function (slot0, slot1)
		if slot0 == slot1.DISPLAY_STAGE then
			return slot1.totalVotes < slot0.totalVotes
		elseif slot2.onWeb then
			return slot1.netVotes < slot0.netVotes
		else
			return slot1.votes < slot0.votes
		end
	end)

	slot0.rankMaps = {}

	for slot5, slot6 in ipairs(slot0.list) do
		slot0.rankMaps[slot6.group] = slot5
	end
end

slot0.GetRank = function (slot0, slot1)
	return slot0.rankMaps[slot1.group] or 0
end

slot0.GetStage = function (slot0)
	slot2 = slot0:getConfig("time_vote_client")
	slot3 = slot0:getConfig("time_show")

	if pg.TimeMgr.GetInstance():inTime(slot0:getConfig("time_vote")) then
		return slot0.VOTE_STAGE
	elseif pg.TimeMgr.GetInstance():inTime(slot2) then
		return slot0.STTLEMENT_STAGE
	elseif pg.TimeMgr.GetInstance():inTime(slot3) then
		return slot0.DISPLAY_STAGE
	end
end

slot0.getTimeDesc = function (slot0)
	return table.concat(slot0:getConfig("time_vote")[1][1], ".") .. ((slot0:getConfig("type") == 1 and i18n("word_maintain")) or "(" .. string.format("%02u:%02u", slot1[1][2][1], slot1[1][2][2]) .. ")") .. " ~ " .. table.concat(slot1[2][1], ".") .. "(" .. string.format("%02u:%02u", slot1[2][2][1], slot1[2][2][2]) .. ")"
end

slot0.GetVotes = function (slot0, slot1)
	if slot0:GetStage() == slot0.DISPLAY_STAGE then
		return slot1:getTotalVotes()
	else
		return (slot0:isWeb() and slot1:getNetVotes()) or slot1:GetGameVotes()
	end
end

slot0.GetDialayGroupForFinals = function (slot0)
	slot1 = {}
	slot2 = {}

	for slot6, slot7 in ipairs(slot0.list) do
		if slot6 <= 3 then
			table.insert(slot1, slot7)
		else
			table.insert(slot2, slot7)
		end
	end

	for slot6 = #slot1, 1, -1 do
		if slot0:GetVotes(slot1[slot6]) == 0 then
			table.insert(slot2, 1, table.remove(slot1, slot6))
		end
	end

	return slot1, slot2
end

return slot0

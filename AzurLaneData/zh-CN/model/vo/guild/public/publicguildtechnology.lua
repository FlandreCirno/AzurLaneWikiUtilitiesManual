class("PublicGuildTechnology", import("..GuildTechnology")).GetConsume = function (slot0)
	return slot0:getConfig("contribution_consume") * slot0:getConfig("contribution_multiple"), slot0:getConfig("gold_consume") * slot0.getConfig("contribution_multiple")
end

return class("PublicGuildTechnology", import("..GuildTechnology"))

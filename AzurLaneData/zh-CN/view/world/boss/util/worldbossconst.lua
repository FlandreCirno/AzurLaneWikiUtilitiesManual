class("WorldBossConst").GetCurrBossGroup = function ()
	return (getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS) and slot0:getConfig("config_client").id) or 970701
end

return class("WorldBossConst")

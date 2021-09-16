slot0 = class("AutoSubCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot4 = slot1:getBody().toggle

	PlayerPrefs.SetInt("autoSubIsAcitve" .. slot0.GetAutoSubMark(slot5), (not slot1.getBody().isActiveSub and 1) or 0)
end

slot0.GetAutoSubMark = function (slot0)
	if slot0 == SYSTEM_WORLD then
		return "_" .. slot0
	else
		return ""
	end
end

return slot0

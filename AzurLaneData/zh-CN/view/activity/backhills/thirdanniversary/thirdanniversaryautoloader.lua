class("ThirdAnniversaryAutoloader", import("view.util.Autoloader")).GetSprite = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot0.super.GetSprite(slot0, slot1, slot2, slot3, slot4)

	if not IsNil(slot3) then
		slot3:GetComponent(typeof(Image)).enabled = true
	end

	return slot5
end

return class("ThirdAnniversaryAutoloader", import("view.util.Autoloader"))

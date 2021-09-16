class("WorldMediaCollectionLoader", require("view.util.AutoLoader")).GetSprite = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = tf(slot3)

	slot0:GetSpriteDirect(slot1, slot2 or "", function (slot0)
		slot1 = slot0:GetComponent(typeof(Image))
		slot1.enabled = true
		slot1.sprite = slot0

		if slot1 then
			slot1:SetNativeSize()
		end
	end, slot5)
end

return class("WorldMediaCollectionLoader", require("view.util.AutoLoader"))

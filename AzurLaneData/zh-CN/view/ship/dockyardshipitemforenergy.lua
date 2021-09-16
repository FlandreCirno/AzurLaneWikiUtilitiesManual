slot0 = class("DockyardShipItemForEnergy", import(".DockyardShipItem"))

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.super.Ctor(slot0, slot1, slot2, slot3)

	slot0.energyTFForBackYard = findTF(slot0.go, "content/energy")
	slot0.energyIconForBackYard = slot0.energyTFForBackYard:Find("icon/img"):GetComponent(typeof(Image))
	slot0.energyTxtForBackYard = slot0.energyTFForBackYard:Find("Text"):GetComponent(typeof(Text))
end

slot0.update = function (slot0, slot1)
	setActive(slot0.energyTFForBackYard, true)
	slot0.super.update(slot0, slot1)
end

slot0.flush = function (slot0)
	slot0.super.flush(slot0)
	setActive(slot0.energyTF, false)
	slot0:FlushEnergy()
end

slot0.FlushEnergy = function (slot0)
	if tobool(slot0.shipVO) then
		setImageSprite(slot0.energyIconForBackYard, slot3, true)

		slot0.energyTxtForBackYard.text = slot1:getEnergy()
	end

	setActive(slot0.energyTFForBackYard, slot2)
end

slot0.clear = function (slot0)
	slot0.super.clear(slot0)
	setActive(slot0.energyTFForBackYard, false)
end

return slot0

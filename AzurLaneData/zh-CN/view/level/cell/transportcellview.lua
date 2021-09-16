class("TransportCellView", import(".OniCellView")).Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.tfHp = slot0.tf:Find("hp")
	slot0.tfHpText = slot0.tf:Find("hp/text")
	slot0.tfFighting = slot0.tf:Find("fighting")
end

return class("TransportCellView", import(".OniCellView"))

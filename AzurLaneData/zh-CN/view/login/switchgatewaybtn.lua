slot0 = class("SwitchGatewayBtn")

slot0.Ctor = function (slot0, slot1)
	slot0._tr = slot1
	slot0._go = slot1.gameObject

	setActive(slot0._go, false)
end

slot0.Flush = function (slot0)
	setActive(slot0._go, getProxy(UserProxy):ShowGatewaySwitcher())

	if getProxy(UserProxy).ShowGatewaySwitcher() then
		slot0:RegistSwicher()
	end
end

slot0.RegistSwicher = function (slot0)
	slot2 = getProxy(UserProxy).getLastLoginUser(slot1)

	onButton(nil, slot0._go, function ()
		pg.m02:sendNotification(GAME.SERVER_INTERCOMMECTION, {
			user = slot0,
			platform = slot1:GetReversePlatform()
		})
	end, SFX_PANEL)

	slot0.isRegist = true
end

slot0.Dispose = function (slot0)
	if slot0.isRegist then
		removeOnButton(slot0._go)

		slot0.isRegist = nil
	end
end

return slot0

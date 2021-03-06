slot0 = class("EquipmentSkinLayer", import("..base.BaseUI"))
slot0.DISPLAY = 1
slot0.REPLACE = 2

slot0.getUIName = function (slot0)
	return "EquipmentSkinInfoUI"
end

slot0.setShip = function (slot0, slot1)
	slot0.shipVO = slot1
end

slot0.init = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)

	slot0.displayPanel = slot0:findTF("display")

	setActive(slot0.displayPanel, false)

	slot0.displayActions = slot0.displayPanel:Find("actions")
	slot0.skinViewOnShipTF = slot0:findTF("replace/equipment_on_ship")
	slot0.skinViewTF = slot0:findTF("replace/equipment")
	slot0.replacePanel = slot0:findTF("replace")

	setActive(slot0.replacePanel, false)
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SOUND_BACK)
	onButton(slot0, slot0._tf:Find("display/top/btnBack"), function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(slot0, slot0:findTF("actions/cancel_button", slot0.replacePanel), function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_PANEL)
	onButton(slot0, slot0:findTF("actions/action_button_2", slot0.replacePanel), function ()
		if not slot0.contextData.oldShipInfo then
			slot0:emit(EquipmentSkinMediator.ON_EQUIP)
		else
			slot0:emit(EquipmentSkinMediator.ON_EQUIP_FORM_SHIP)
		end
	end, SFX_PANEL)

	if (slot0.contextData.mode or slot0.DISPLAY) == slot0.REPLACE and slot0.shipVO then
		slot0.initReplace(slot0)
	elseif slot1 == slot0.DISPLAY then
		slot0:initDisplay()
	end
end

slot0.initDisplay = function (slot0)
	setActive(slot0.displayPanel, true)
	setActive(slot0.replacePanel, false)

	if slot0.shipVO then
		slot0:initDisplay4Ship()
	else
		eachChild(slot0.displayActions, function (slot0)
			setActive(slot0, slot0.gameObject.name == "confirm")

			if slot0.gameObject.name == "confirm" then
				onButton(slot0, slot0, function ()
					slot0:emit(slot1.ON_CLOSE)
				end, SFX_PANEL)
			end
		end)
	end

	slot0.updateSkinView(slot0, slot0.displayPanel, slot0.contextData.skinId)
end

slot0.initDisplay4Ship = function (slot0)
	eachChild(slot0.displayActions, function (slot0)
		setActive(slot0, slot0.gameObject.name ~= "confirm")
		onButton(slot0, slot0, function ()
			if slot0 == "unload" then
				slot1:emit(EquipmentSkinMediator.ON_UNEQUIP)
			elseif slot0 == "replace" then
				slot1:emit(EquipmentSkinMediator.ON_SELECT)
			end
		end, SFX_PANEL)
	end)
end

slot0.initReplace = function (slot0)
	setActive(slot0.displayPanel, false)
	setActive(slot0.replacePanel, true)

	slot3 = slot0.contextData.skinId

	slot0:updateSkinView(slot0.skinViewOnShipTF, slot0.shipVO:getEquipSkin(slot0.contextData.pos) or 0)

	if slot0.contextData.oldShipInfo then
		slot0:updateSkinView(slot0.skinViewTF, slot3, slot0.contextData.oldShipInfo)
	else
		slot0:updateSkinView(slot0.skinViewTF, slot3)
	end
end

slot0.updateSkinView = function (slot0, slot1, slot2, slot3)
	slot4 = slot2 ~= 0
	slot6 = slot0:findTF("info", slot1)

	if slot0:findTF("empty", slot1) then
		setActive(slot5, not slot4)
	end

	setActive(slot6, slot4)

	slot1:GetComponent(typeof(Image)).enabled = slot4

	if slot4 then
		slot0:findTF("info/display_panel/name_container/name", slot1):GetComponent(typeof(Text)).text = pg.equip_skin_template[slot2].name
		slot0:findTF("info/display_panel/desc", slot1):GetComponent(typeof(Text)).text = pg.equip_skin_template[slot2].desc

		setScrollText(slot0.findTF(slot0, "info/display_panel/equip_type/mask/Text", slot1), table.concat(slot10, ","))
		setActive(slot11, true)
		onButton(slot0, slot11, function ()
			slot0:emit(EquipmentSkinMediator.ON_PREVIEW, slot0)
		end, SFX_PANEL)
		updateDrop(slot0.findTF(slot0, "info/equip", slot1), {
			type = DROP_TYPE_EQUIPMENT_SKIN,
			id = slot2
		})

		if slot0:findTF("info/head", slot1) then
			setActive(slot12, slot3)

			if slot3 and getProxy(BayProxy):getShipById(slot3.id) then
				setImageSprite(slot12:Find("Image"), LoadSprite("qicon/" .. slot13:getPainting()))
			end
		end
	end
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0.UIMain)
end

return slot0

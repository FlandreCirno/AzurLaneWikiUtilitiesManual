slot0 = class("EquipmentTransformTreeScene", import("view.base.BaseUI"))
slot1 = require("Mgr/Pool/PoolPlural")
slot2 = "ui/EquipmentTransformTreeUI_atlas"

slot0.getUIName = function (slot0)
	return "EquipmentTransformTreeUI"
end

slot0.optionsPath = {
	"blur_panel/adapt/top/option"
}
slot0.MODE_NORMAL = 1
slot0.MODE_HIDESIDE = 2

slot0.init = function (slot0)
	slot0.leftPanel = slot0._tf:Find("Adapt/Left")
	slot0.rightPanel = slot0._tf:Find("Adapt/Right")
	slot0.nationToggleGroup = slot0.leftPanel:Find("Nations").Find(slot1, "ViewPort/Content")

	setActive(slot0.nationToggleGroup:GetChild(0), false)
	slot0.nationToggleGroup:GetChild(0):Find("selectedCursor").gameObject:SetActive(false)

	slot0.equipmentTypeToggleGroup = slot0.leftPanel:Find("EquipmentTypes").Find(slot2, "ViewPort/Content")

	setActive(slot0.equipmentTypeToggleGroup:GetChild(0), false)
	slot0.equipmentTypeToggleGroup:GetChild(0):Find("selectedframe").gameObject:SetActive(false)

	slot0.TreeCanvas = slot0.rightPanel:Find("ViewPort/Content")

	setActive(slot0.rightPanel:Find("EquipNode"), false)
	setActive(slot0.rightPanel:Find("Link"), false)

	slot0.nodes = {}
	slot0.links = {}
	slot0.plurals = {
		EquipNode = slot0.New(slot0.rightPanel:Find("EquipNode").gameObject, 5),
		Link = slot0.New(slot0.rightPanel:Find("Link").gameObject, 8)
	}
	slot0.pluralRoot = pg.PoolMgr.GetInstance().root
	slot0.top = slot0._tf:Find("blur_panel")
	slot0.loader = AutoLoader.New()
end

slot0.GetEnv = function (slot0)
	slot0.env = slot0.env or {}

	return slot0.env
end

slot0.SetEnv = function (slot0, slot1)
	slot0.env = slot1
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.top)
	onButton(slot0, slot0.top:Find("adapt/top/back"), function ()
		slot0:closeView()
	end, SFX_CANCEL)

	if slot0.contextData.targetEquipId then
		slot1, slot2 = nil
		slot3 = false

		for slot7, slot8 in pairs(slot0.env.nationsTree) do
			for slot12, slot13 in pairs(slot8) do
				for slot17, slot18 in ipairs(slot13.equipments) do
					if slot18[3] == slot0.contextData.targetEquipId then
						slot2 = slot12
						slot1 = slot7
						slot3 = true

						break
					end
				end
			end

			if slot3 then
				break
			end
		end

		if slot3 then
			slot0.contextData.nation = slot1
			slot0.contextData.equipmentTypeIndex = slot2
		end
	end

	slot0:InitPage()

	if slot0.contextData.mode == slot0.MODE_HIDESIDE then
		setActive(slot0.leftPanel, false)

		slot0.rightPanel.sizeDelta.x = 0
		slot0.rightPanel.sizeDelta = slot0.rightPanel.sizeDelta

		setAnchoredPosition(slot0.rightPanel, {
			x = 0
		})
	end
end

slot0.GetSortKeys = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0) do
		table.insert(slot1, slot5)
	end

	table.sort(slot1, function (slot0, slot1)
		return slot0 < slot1
	end)

	return slot1
end

slot0.InitPage = function (slot0)
	slot0.firstInit = true
	slot1.mode = slot0.contextData.mode or slot0.MODE_NORMAL
	slot4 = slot0.GetSortKeys(slot0.env.nationsTree)

	if not slot1.nation or not table.contains(slot4, slot3) then
		slot3 = slot4[1]
	end

	if next(slot2.nationsTree[slot3]) == nil then
		for slot8 = 2, #slot4, 1 do
			if next(slot2.nationsTree[slot4[slot8]]) ~= nil then
				slot3 = slot4[slot8]

				break
			end
		end
	end

	slot1.nation = nil

	slot0:UpdateNations()
	triggerButton(slot0.nationToggles[table.indexof(slot4, slot3) or 1])

	slot0.firstInit = nil
end

slot0.UpdateNations = function (slot0)
	slot0.nationToggles = slot0.Clone2Full(slot0.nationToggleGroup, #slot0.GetSortKeys(slot0.env.nationsTree))

	for slot5 = 1, #slot0.nationToggles, 1 do
		slot0.loader:GetSprite(slot1, "nation" .. slot7 .. "_disable", slot0.nationToggles[slot5]:Find("selectedIcon"))
		setActive(slot0.nationToggles[slot5].Find(slot6, "selectedCursor"), false)
		onButton(slot0, slot0.nationToggles[slot5], function ()
			if slot0.contextData.nation ~= slot1 then
				if next(slot0.env.nationsTree[]) == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))

					return
				end

				slot0.loader:GetSprite(slot2, "nation" .. slot1, slot3:Find("selectedIcon"))

				if slot0.loader.GetSprite.contextData.nation then
					slot0 = table.indexof(slot4, slot0.contextData.nation)

					setActive(slot0.nationToggles[slot0]:Find("selectedCursor"), false)
					slot0.loader:GetSprite(slot0.loader, "nation" .. slot0.contextData.nation .. "_disable", slot0.nationToggles[slot0]:Find("selectedIcon"))
				end

				slot0.contextData.nation = slot1

				slot0.contextData:UpdateEquipmentTypes()

				slot1 = slot5.GetSortKeys(slot0.env.nationsTree[])[1]

				if slot0.firstInit and slot0.contextData.equipmentTypeIndex and table.contains(slot0, slot2) then
					slot1 = slot2
				end

				slot0.contextData.equipmentTypeIndex = nil

				triggerToggle(slot0.equipmentTypeToggles[table.indexof(slot0, slot1) or 1], true)
			end
		end, SFX_UI_TAG)
	end
end

slot0.UpdateEquipmentTypes = function (slot0)
	slot0.equipmentTypeToggles = slot0.Clone2Full(slot0.equipmentTypeToggleGroup, #slot0.GetSortKeys(slot0.env.nationsTree[slot0.contextData.nation]))

	for slot5 = 1, #slot0.equipmentTypeToggles, 1 do
		slot0.equipmentTypeToggles[slot5].GetComponent(slot6, typeof(Toggle)).isOn = false

		slot0.loader:GetSprite(slot1, "equipmentType" .. slot7, slot0.equipmentTypeToggles[slot5].Find(slot6, "itemName"), true)
		setActive(slot0.equipmentTypeToggles[slot5].Find(slot6, "selectedframe"), false)
		onToggle(slot0, slot0.equipmentTypeToggles[slot5], function (slot0)
			if slot0 and slot0.contextData.equipmentTypeIndex ~=  then
				slot0.contextData.equipmentTypeIndex = slot0.contextData

				slot0:ResetCanvas()
			end

			setActive(slot2:Find("selectedframe"), slot0)
		end, SFX_UI_TAG)
	end

	slot0.equipmentTypeToggleGroup.anchoredPosition = Vector2.zero
	slot0.leftPanel.Find(slot2, "EquipmentTypes"):GetComponent(typeof(ScrollRect)).velocity = Vector2.zero
end

slot3 = {
	15,
	-4,
	15,
	6
}

slot0.ResetCanvas = function (slot0)
	slot0.TreeCanvas.sizeDelta = Vector2(unpack(EquipmentProxy.EquipmentTransformTreeTemplate[slot0.contextData.nation][slot0.contextData.equipmentTypeIndex].canvasSize))
	slot0.TreeCanvas.anchoredPosition = Vector2.zero
	slot0.rightPanel:GetComponent(typeof(ScrollRect)).velocity = Vector2.zero

	slot0:ReturnCanvasItems()

	for slot6, slot7 in ipairs(EquipmentProxy.EquipmentTransformTreeTemplate[slot0.contextData.nation][slot0.contextData.equipmentTypeIndex].equipments) do
		slot8 = slot0.plurals.EquipNode:Dequeue()

		setActive(slot8, true)
		setParent(slot8, slot0.TreeCanvas)
		table.insert(slot0.nodes, {
			id = slot7[3],
			cfg = slot7,
			go = slot8
		})

		slot8.name = slot7[3]

		slot0:UpdateItemNode(tf(slot8), slot7)
	end

	for slot6, slot7 in ipairs(slot1.links) do
		for slot11 = 1, #slot7 - 1, 1 do
			slot16 = (math.abs(({
				slot7[slot11 + 1][1] - slot7[slot11][1],
				slot7[slot11][2] - slot7[slot11 + 1][2]
			})[2]) < math.abs(()[1]) and math.abs(slot14[1])) or math.abs(slot14[2])

			if slot15 then
				slot14[2] = 0
			else
				slot14[1] = 0
			end

			slot18 = math.deg2Rad * 90 * ((1 - math.sign(slot14[1]) ~= 1 and slot17) or 2 - math.sign(slot14[2]))

			if #slot7 == 2 then
				slot19 = slot0.plurals.Link:Dequeue()

				table.insert(slot0.links, go(slot19))
				setActive(slot19, true)
				setParent(slot19, slot0.TreeCanvas)
				slot0.loader:GetSprite(slot0, (slot14[2] == 0 and "wirehead") or "wireline", slot19)

				tf(slot19).sizeDelta = Vector2(28, 26)
				tf(slot19).pivot = Vector2(0.5, 0.5)
				tf(slot19).localRotation = Quaternion.Euler(0, 0, slot17 * 90)
				tf(slot19).anchoredPosition = Vector2(slot12[1] + Vector2(math.cos(slot18), math.sin(slot18)) * slot1[(slot17 - 1) % 4 + 1].x, -slot12[2] + Vector2(math.cos(slot18), math.sin(slot18)) * slot1[(slot17 - 1) % 4 + 1].y)

				table.insert(slot0.links, go(slot19))
				setActive(slot19, true)
				setParent(slot19, slot0.TreeCanvas)
				slot0.loader:GetSprite(slot0, "wiretail", slot19)

				tf(slot19).sizeDelta = Vector2(28, 26)
				tf(slot19).pivot = Vector2(0.5, 0.5)
				tf(slot19).localRotation = Quaternion.Euler(0, 0, slot17 * 90)
				tf(slot19).anchoredPosition = Vector2(slot13[1] + Vector2(math.cos(slot18), math.sin(slot18)) * -slot1[(slot17 + 1) % 4 + 1].x, -slot13[2] + Vector2(math.cos(slot18), math.sin(slot18)) * -slot1[(slot17 + 1) % 4 + 1].y)

				table.insert(slot0.links, go(slot19))
				setActive(slot19, true)
				setParent(slot19, slot0.TreeCanvas)
				slot0.loader:GetSprite(slot0, "wireline", slot19)

				tf(slot19).sizeDelta = Vector2(math.max(0, slot16 - slot1[(slot17 - 1) % 4 + 1] - slot1[(slot17 + 1) % 4 + 1] - 28), 16)
				tf(slot19).pivot = Vector2(0, 0.5)
				tf(slot19).localRotation = Quaternion.Euler(0, 0, slot17 * 90)
				tf(slot19).anchoredPosition = Vector2(slot12[1] + Vector2(math.cos(slot18), math.sin(slot18)) * slot1[(slot17 - 1) % 4 + 1].x, -slot12[2] + Vector2(math.cos(slot18), math.sin(slot18)) * slot1[(slot17 - 1) % 4 + 1].y) + Vector2(math.cos(slot18), math.sin(slot18)) * 14

				break
			end

			slot19 = slot0.plurals.Link:Dequeue()

			table.insert(slot0.links, go(slot19))
			setActive(slot19, true)
			setParent(slot19, slot0.TreeCanvas)

			slot20 = 1

			if slot11 == 1 then
				slot0.loader:GetSprite(slot0, (slot14[2] == 0 and "wirehead") or "wireline", slot19)

				tf(slot19).sizeDelta = Vector2(slot0.loader.GetSprite, 26)
				tf(slot19).pivot = Vector2(((slot16 + 14 + slot20) - slot1[(slot17 - 1) % 4 + 1] - slot20) / ((slot16 + 14 + slot20) - slot1[(slot17 - 1) % 4 + 1]), 0.5)
				tf(slot19).localRotation = Quaternion.Euler(0, 0, slot17 * 90)
				tf(slot19).anchoredPosition = Vector2(slot13[1], -slot13[2])
			elseif slot11 + 1 == #slot7 then
				slot0.loader:GetSprite(slot0, "wiretail", slot19)

				tf(slot19).sizeDelta = Vector2((slot16 + 14 + slot20) - slot1[(slot17 + 1) % 4 + 1], 26)
				tf(slot19).pivot = Vector2(slot20 / ((slot16 + 14 + slot20) - slot1[(slot17 + 1) % 4 + 1]), 0.5)
				tf(slot19).localRotation = Quaternion.Euler(0, 0, slot17 * 90)
				tf(slot19).anchoredPosition = Vector2(slot12[1], -slot12[2])
			else
				slot0.loader:GetSprite(slot0, "wireline", slot19)

				tf(slot19).sizeDelta = Vector2(slot16 + slot20 * 2, 16)
				tf(slot19).pivot = Vector2(slot20 / (slot16 + slot20 * 2), 0.5)
				tf(slot19).localRotation = Quaternion.Euler(0, 0, slot17 * 90)
				tf(slot19).anchoredPosition = Vector2(slot12[1], -slot12[2])
			end
		end
	end
end

slot0.UpdateItemNode = function (slot0, slot1, slot2)
	tf(slot1).anchoredPosition = Vector2(slot2[1], -slot2[2])

	updateDrop(tf(slot1).Find(slot1, "Item"), {
		id = slot2[3],
		type = DROP_TYPE_EQUIP
	})
	onButton(slot0, tf(slot1).Find(slot1, "Item"), function ()
		if not EquipmentProxy.GetTransformSources(slot0[3])[1] then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_initial_node"))

			return
		end

		slot1:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTransformMediator,
			viewComponent = EquipmentTransformLayer,
			data = {
				formulaId = slot0
			}
		}))
	end, SFX_PANEL)
	tf(slot1).Find(slot1, "Mask/NameText"):GetComponent("ScrollText"):SetText(pg.equip_data_statistics[slot2[3]].name)
	setActive(tf(slot1).Find(slot1, "cratfable"), slot5)
	onButton(slot0, tf(slot1).Find(slot1, "cratfable"), function ()
		slot0:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = slot1[3]
			}
		}))
	end)
	setActive(slot1.Find(slot1, "Item/new"), slot2[4] and PlayerPrefs.GetInt("ShowTransformTip_" .. slot2[3], 0) == 0)
end

slot0.UpdateItemNodes = function (slot0)
	for slot4, slot5 in ipairs(slot0.nodes) do
		slot0:UpdateItemNode(slot5.go, slot5.cfg)
	end
end

slot0.UpdateItemNodeByID = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.nodes) do
		if slot1 == slot6.id then
			slot0:UpdateItemNode(slot6.go, slot6.cfg)

			break
		end
	end
end

slot0.ReturnCanvasItems = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.nodes) do
		if not slot0.plurals.EquipNode:Enqueue(slot6.go, slot1) then
			setParent(slot6.go, slot0.pluralRoot)
		end
	end

	table.clean(slot0.nodes)

	for slot5, slot6 in ipairs(slot0.links) do
		if not slot0.plurals.Link:Enqueue(slot6, slot1) then
			setParent(slot6, slot0.pluralRoot)
		end
	end

	table.clean(slot0.links)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.top, slot0._tf)
	slot0:ReturnCanvasItems(true)

	for slot4, slot5 in pairs(slot0.plurals) do
		slot5:Clear()
	end

	slot0.loader:Clear()
end

slot0.Clone2Full = function (slot0, slot1)
	slot2 = {}
	slot3 = slot0:GetChild(0)

	for slot8 = 0, slot0.childCount - 1, 1 do
		table.insert(slot2, slot0:GetChild(slot8))
	end

	for slot8 = slot4, slot1 - 1, 1 do
		table.insert(slot2, tf(cloneTplTo(slot3, slot0)))
	end

	for slot8 = 0, slot0.childCount - 1, 1 do
		setActive(slot0:GetChild(slot8), slot8 < slot1)
	end

	for slot8 = slot4, slot1 + 1, -1 do
		table.remove(slot2)
	end

	return slot2
end

return slot0

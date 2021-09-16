slot0 = class("WSMapTop", import("...BaseEntity"))
slot0.Fields = {
	map = "table",
	btnBack = "userdata",
	rtGlobalBuffs = "userdata",
	gid = "number",
	rtResource = "userdata",
	rtTime = "userdata",
	cmdSkills = "table",
	rtFleetBuffs = "userdata",
	rtCmdSkills = "userdata",
	entrance = "table",
	fleet = "table",
	rtPoisonRate = "userdata",
	rtMapName = "userdata",
	cmdSkillFunc = "function",
	fleetBuffItemList = "table",
	world = "table",
	transform = "userdata",
	globalBuffItemList = "table",
	cmdSkillItemList = "table",
	globalBuffs = "table",
	poisonFunc = "function",
	fleetBuffs = "table",
	rtMoveLimit = "userdata"
}
slot0.Listeners = {
	onUpdateFleetBuff = "OnUpdateFleetBuff",
	onUpdateGlobalBuff = "OnUpdateGlobalBuff",
	onUpdateCmdSkill = "OnUpdateCmdSkill",
	onUpdateSelectedFleet = "OnUpdateSelectedFleet"
}

slot0.Setup = function (slot0)
	nowWorld:AddListener(World.EventUpdateGlobalBuff, slot0.onUpdateGlobalBuff)
	pg.DelegateInfo.New(slot0)
	slot0:Init()
end

slot0.Dispose = function (slot0)
	nowWorld:RemoveListener(World.EventUpdateGlobalBuff, slot0.onUpdateGlobalBuff)
	slot0:RemoveFleetListener(slot0.fleet)
	slot0:RemoveMapListener()
	pg.DelegateInfo.Dispose(slot0)
	slot0:Clear()
end

function slot1(slot0, slot1)
	if slot1.config.icon and #slot1.config.icon > 0 then
		GetImageSpriteFromAtlasAsync("world/buff/" .. slot1.config.icon, "", slot0:Find("icon"))
	else
		clearImageSprite(slot0:Find("icon"))
	end

	setText(slot0:Find("floor"), slot1:GetFloor())
	setActive(slot0:Find("floor"), slot1.config.buff_maxfloor > 1)
	setText(slot0:Find("lost"), setActive)
	setActive(slot0:Find("lost"), setActive)
	onButton(self, slot0, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = "",
			yesText = "text_confirm",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				isWorldBuff = true,
				type = DROP_TYPE_STRATEGY,
				id = slot0.id
			}
		})
	end, SFX_PANEL)
end

slot0.Init = function (slot0)
	slot0.btnBack = slot0.transform.Find(slot1, "back_button")
	slot0.rtMapName = slot0.transform.Find(slot1, "title/name")
	slot0.rtTime = slot0.transform.Find(slot1, "title/time")
	slot0.rtResource = slot0.transform.Find(slot1, "resources")
	slot0.rtGlobalBuffs = slot0.transform.Find(slot1, "features/status_field/global_buffs")
	slot0.rtMoveLimit = slot0.transform.Find(slot1, "features/status_field/move_limit")
	slot0.rtPoisonRate = slot0.transform.Find(slot1, "features/status_field/poison_rate")
	slot0.rtFleetBuffs = slot0.transform.Find(slot1, "features/fleet_field/fleet_buffs")
	slot0.rtCmdSkills = slot0.transform.Find(slot1, "features/fleet_field/cmd_skills")

	setText(slot0.rtMapName, "")
	setText(slot0.rtTime, "")

	slot0.globalBuffItemList = UIItemList.New(slot0.rtGlobalBuffs, slot0.rtGlobalBuffs:GetChild(0))

	slot0.globalBuffItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0(slot2, slot1.globalBuffs[slot1 + 1])
		end
	end)

	slot0.fleetBuffItemList = UIItemList.New(slot0.rtFleetBuffs, slot0.rtFleetBuffs.GetChild(slot4, 0))

	slot0.fleetBuffItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0(slot2, slot1.fleetBuffs[slot1 + 1])
		end
	end)

	slot0.cmdSkillItemList = UIItemList.New(slot0.rtCmdSkills, slot0.rtCmdSkills.GetChild(slot4, 0))

	slot0.cmdSkillItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			GetImageSpriteFromAtlasAsync("commanderskillicon/" .. slot0.cmdSkills[slot1 + 1].getConfig(slot3, "icon"), "", slot2:Find("icon"))
			setText(slot2:Find("floor"), "Lv." .. slot0.cmdSkills[slot1 + 1].getConfig(slot3, "lv"))
			setActive(slot2:Find("floor"), true)
			setActive(slot2:Find("lost"), false)
			onButton(slot0, slot2, function ()
				slot0.cmdSkillFunc(slot1)
			end, SFX_PANEL)
		end
	end)
end

slot0.Update = function (slot0, slot1, slot2)
	if slot0.entrance ~= slot1 or slot0.map ~= slot2 or slot0.gid ~= slot2.gid then
		slot0:RemoveMapListener()

		slot0.entrance = slot1
		slot0.map = slot2
		slot0.gid = slot2.gid

		slot0:AddMapListener()
		slot0:OnUpdateMap()
		slot0:OnUpdateSelectedFleet()
		slot0:OnUpdateGlobalBuff()
		slot0:OnUpdatePoison()
		slot0:OnUpdateMoveLimit()
	end
end

slot0.AddMapListener = function (slot0)
	if slot0.map then
		slot0.map:AddListener(WorldMap.EventUpdateFIndex, slot0.onUpdateSelectedFleet)
	end
end

slot0.RemoveMapListener = function (slot0)
	if slot0.map then
		slot0.map:RemoveListener(WorldMap.EventUpdateFIndex, slot0.onUpdateSelectedFleet)
	end
end

slot0.AddFleetListener = function (slot0, slot1)
	if slot1 then
		slot1:AddListener(WorldMapFleet.EventUpdateBuff, slot0.onUpdateFleetBuff)
		slot1:AddListener(WorldMapFleet.EventUpdateDamageLevel, slot0.onUpdateFleetBuff)
		slot1:AddListener(WorldMapFleet.EventUpdateCatSalvage, slot0.onUpdateCmdSkill)
	end
end

slot0.RemoveFleetListener = function (slot0, slot1)
	if slot1 then
		slot1:RemoveListener(WorldMapFleet.EventUpdateBuff, slot0.onUpdateFleetBuff)
		slot1:RemoveListener(WorldMapFleet.EventUpdateDamageLevel, slot0.onUpdateFleetBuff)
		slot1:RemoveListener(WorldMapFleet.EventUpdateCatSalvage, slot0.onUpdateCmdSkill)
	end
end

slot0.OnUpdateMap = function (slot0)
	setText(slot0.rtMapName, slot0.map:GetName(slot0.entrance:GetBaseMap()))
end

slot0.OnUpdateSelectedFleet = function (slot0)
	if slot0.fleet ~= slot0.map:GetFleet() then
		slot0:RemoveFleetListener(slot0.fleet)

		slot0.fleet = slot1

		slot0:AddFleetListener(slot0.fleet)
		slot0:OnUpdateFleetBuff()
		slot0:OnUpdateCmdSkill()
	end
end

slot0.OnUpdateGlobalBuff = function (slot0)
	slot0.globalBuffs = nowWorld:GetWorldMapBuffs()

	slot0.globalBuffItemList:align(#slot0.globalBuffs)
end

slot0.OnUpdateMoveLimit = function (slot0)
	setActive(slot0.rtMoveLimit, not slot0.map:IsUnlockFleetMode())

	if not slot0.map.IsUnlockFleetMode() then
		slot2 = WorldBuff.New()

		slot2:Setup({
			floor = 0,
			id = WorldConst.MoveLimitBuffId
		})
		slot0(slot0.rtMoveLimit, slot2)
	end
end

slot0.OnUpdatePoison = function (slot0)
	slot1, slot2 = slot0.map:GetEventPoisonRate()

	setActive(slot0.rtPoisonRate, slot2 > 0)

	if slot2 > 0 then
		slot3 = calcFloor(slot1 / slot2 * 100)

		table.insert(slot4, 1, 0)
		table.insert(slot4, 999)
		eachChild(slot0.rtPoisonRate:Find("bg/ring"), function (slot0)
			if slot1[slot0:GetSiblingIndex() + 1] <= slot0 and slot0 < slot1[slot1 + 1] then
				setActive(slot0, true)

				slot0:GetComponent(typeof(Image)).fillAmount = slot0 / 100
			else
				setActive(slot0, false)
			end

			setText(slot2.rtPoisonRate:Find("bg/Text"), slot0 .. "%")
		end)
		onButton(slot0, slot0.rtPoisonRate, function ()
			slot0.poisonFunc(slot1)
		end, SFX_PANEL)
	end
end

slot0.OnUpdateFleetBuff = function (slot0)
	slot0.fleetBuffs = slot0.fleet:GetBuffList()

	if slot0.fleet:GetDamageBuff() then
		table.insert(slot0.fleetBuffs, 1, slot1)
	end

	slot0.fleetBuffItemList:align(#slot0.fleetBuffs)
	setActive(slot0.rtFleetBuffs, #slot0.fleetBuffs > 0)
end

slot0.OnUpdateCmdSkill = function (slot0)
	if slot0.fleet:IsCatSalvage() then
		slot0.cmdSkills = {}
	else
		slot0.cmdSkills = _.map(_.values(slot0.fleet:getCommanders()), function (slot0)
			return slot0:getSkills()[1]
		end)
	end

	slot0.cmdSkillItemList.align(slot1, #slot0.cmdSkills)
	setActive(slot0.rtCmdSkills, #slot0.cmdSkills > 0)
end

return slot0

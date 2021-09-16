slot0 = class("NavalTacticsSkillInfoLayer", import(".SkillInfoLayer"))

slot0.showBase = function (slot0)
	slot0.super.showBase(slot0)
	setActive(slot0.metaBtn, false)
	setActive(slot0.upgradeBtn, false)
end

slot0.showInfo = function (slot0, slot1)
	slot0.isWorld = slot1
	slot2 = slot0.contextData.skillId

	setText(slot0.skillInfoLv, "Lv." .. ((slot0.contextData.skillOnShip and slot3.level) or 1))
	setText(slot0.skillInfoIntro, Student.getSkillDesc(slot3.id, (slot0.contextData.skillOnShip and slot3.level) or 1, slot1))
end

return slot0

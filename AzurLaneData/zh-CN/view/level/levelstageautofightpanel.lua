slot0 = class("LevelStageAutoFightPanel", BaseSubView)

slot0.Ctor = function (slot0, ...)
	slot0.super.Ctor(slot0, ...)

	slot0.buffer = setmetatable({}, {
		__index = function (slot0, slot1)
			return function (slot0, ...)
				slot0:ActionInvoke(slot0.ActionInvoke, ...)
			end
		end,
		__newindex = function ()
			errorMsg("Cant write Data in ActionInvoke buffer")
		end
	})
	slot0.isFrozen = nil

	slot0.bind(slot0, LevelUIConst.ON_FROZEN, function ()
		slot0.isFrozen = true
	end)
	slot0.bind(slot0, LevelUIConst.ON_UNFROZEN, function ()
		slot0.isFrozen = nil
	end)
end

slot0.getUIName = function (slot0)
	return "LevelStageAutoFightPanel"
end

slot0.OnInit = function (slot0)
	slot0.btnOn = slot0._tf:Find("On")
	slot0.btnOff = slot0._tf:Find("Off")

	onButton(slot0, slot0.btnOn, function ()
		slot0 = getProxy(ChapterProxy)

		slot0:SetChapterAutoFlag(slot0.contextData.chapterVO.id, false)
		PlayerPrefs.SetInt(slot1, 0)
		PlayerPrefs.Save()
		slot0:UpdateAutoFightMark()
	end, SFX_PANEL)
	onButton(slot0, slot0.btnOff, function ()
		slot0 = getProxy(ChapterProxy)

		slot0:SetChapterAutoFlag(slot0.contextData.chapterVO.id, true)
		PlayerPrefs.SetInt(slot1, 1)
		PlayerPrefs.Save()
		slot0:UpdateAutoFightMark()

		if not slot0.isFrozen then
			slot0:emit(LevelUIConst.TRIGGER_ACTION)
		end
	end, SFX_PANEL)
end

slot0.UpdateAutoFightMark = function (slot0)
	setActive(slot0.btnOn, getProxy(ChapterProxy):GetChapterAutoFlag(slot0.contextData.chapterVO.id) == 1)
	setActive(slot0.btnOff, not (getProxy(ChapterProxy).GetChapterAutoFlag(slot0.contextData.chapterVO.id) == 1))
	slot0:emit(LevelUIConst.STRATEGY_PANEL_AUTOFIGHT_ACTIVE, getProxy(ChapterProxy).GetChapterAutoFlag(slot0.contextData.chapterVO.id) == 1)
end

return slot0

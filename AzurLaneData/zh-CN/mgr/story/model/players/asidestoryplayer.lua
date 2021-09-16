slot0 = class("AsideStoryPlayer", import(".StoryPlayer"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.hrzList = UIItemList.New(slot0:findTF("aside", slot0.asidePanel), slot0:findTF("aside/aside_txt_tpl", slot0.asidePanel))
	slot0.vetList = UIItemList.New(slot0:findTF("aside_2", slot0.asidePanel), slot0:findTF("aside_2/aside_txt_tpl_2", slot0.asidePanel))
	slot0.dataTxt = slot0:findTF("aside_sign_date", slot0.asidePanel)
end

slot0.OnReset = function (slot0, slot1)
	setActive(slot0.asidePanel, true)
	setActive(slot0.curtain, true)
	setActive(slot0.hrzList.container, false)
	setActive(slot0.vetList.container, false)

	slot0.curtainCg.alpha = 1

	setText(slot0.dataTxt, "")
end

slot0.OnInit = function (slot0, slot1, slot2)
	slot3 = {
		function (slot0)
			slot0:PlayAside(slot0.PlayAside, slot0)
		end,
		function (slot0)
			slot0:PlayDateSign(slot0.PlayDateSign, slot0)
		end
	}

	parallelAsync(slot3, slot2)
end

slot0.GetAsideList = function (slot0, slot1)
	slot2 = nil

	if slot1 == AsideStep.ASIDE_TYPE_HRZ then
		slot2 = slot0.hrzList
	elseif slot1 == AsideStep.ASIDE_TYPE_VEC then
		slot2 = slot0.vetList
	end

	return slot2
end

slot0.PlayAside = function (slot0, slot1, slot2)
	slot4 = slot0:GetAsideList(slot1:GetAsideType())
	slot5 = Mathf.Sign(slot4.container.localScale.x)

	setActive(slot4.container, true)
	slot4:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot5 = slot0[slot1 + 1][2]

			setText(slot2, slot4)
			setTextAlpha(slot2, 0)
			table.insert(slot1, function (slot0)
				slot0:TweenTextAlpha(slot0.TweenTextAlpha, 1, slot2.sequenceSpd, , slot0)
			end)

			if HXSet.hxLan(slot0[slot1 + 1][1]) ~= Mathf.Sign(slot2.localScale.x) then
				slot2.localScale = Vector3(slot4 * slot2.localScale.x, slot2.localScale.y, 1)
			end
		end
	end)
	slot4.align(slot4, #slot1:GetSequence())
	parallelAsync({}, slot2)
end

slot0.PlayDateSign = function (slot0, slot1, slot2)
	if not slot1:GetDateSign() then
		slot2()

		return
	end

	setText(slot0.dataTxt, HXSet.hxLan(slot3[1]))
	setTextAlpha(slot0.dataTxt, 0)
	slot0:TweenTextAlpha(slot0.dataTxt, 1, slot1.sequenceSpd or 1, slot3[2], slot2)
	setAnchoredPosition(slot0.dataTxt, Vector3(slot3[3] or {}[1], slot3[3] or [2], 0))
end

slot0.OnEnd = function (slot0)
	return
end

return slot0

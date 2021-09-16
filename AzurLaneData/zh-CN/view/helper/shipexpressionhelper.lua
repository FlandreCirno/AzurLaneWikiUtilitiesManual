slot0 = class("ShipExpressionHelper")
slot1 = pg.ship_skin_expression
slot2 = pg.ship_skin_expression_ex
slot3 = false

function slot4(...)
	if slot0 and Application.isEditor then
		print(...)
	end
end

function slot5(slot0, slot1, slot2, slot3)
	function slot5()
		slot1 = nil

		if slot0[slot1] and slot0 ~= "" then
			for slot5, slot6 in ipairs(slot0) do
				if slot6[1] <= slot2 then
					slot1 = slot6[2]
				end
			end
		end

		return slot1
	end

	function slot6(slot0)
		if slot0.main_ex and slot1 ~= "" then
			slot2 = nil

			for slot6, slot7 in ipairs(slot1) do
				if slot7[1] <= slot1 then
					slot2 = slot7[2]
				end
			end

			if slot2 then
				return string.split(slot2, "|")[slot0]
			end
		end

		return nil
	end

	function slot7()
		if not string.split(string.split, "_")[2] then
			return nil
		end

		if tonumber(slot1) - ShipWordHelper.GetMainSceneWordCnt(slot1) > 0 then
			return slot2(slot3)
		else
			return slot3()
		end
	end

	slot8 = nil

	if slot0[slot0] then
		return (not slot3 or not string.find(slot1, "main") or slot7()) and slot5()
	end
end

slot0.GetExpression = function (slot0, slot1, slot2, slot3)
	slot0("name:", slot0, " - kind:", slot1, " - favor:", slot2)

	if not slot1[slot0] then
		return nil
	end

	slot5 = slot4[slot1]

	if slot2 and slot2(slot0, slot1, slot2, slot3) then
		slot0("get expression form ex:", slot6)

		slot5 = slot6
	end

	if not slot5 or slot5 == "" then
		slot0("get expression form default:", slot4.default)
	end

	slot0("get express :", slot5)

	return slot5
end

slot0.SetExpression = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = tf(slot0):Find("face")

	if not slot0.GetExpression(slot1, slot2, slot3, slot4) or slot6 == "" then
		if slot5 then
			setActive(slot5, false)
		end

		return false
	end

	if slot5 then
		setImageSprite(slot5, slot7)
		setActive(slot5, true)

		if findTF(slot5, "face_sub") then
			setActive(slot8, GetSpriteFromAtlas("paintingface/" .. slot1, slot6 .. "_sub"))

			if GetSpriteFromAtlas("paintingface/" .. slot1, slot6 .. "_sub") then
				setImageSprite(slot8, slot9)
			end
		end
	end

	return true
end

slot0.DefaultFaceless = function (slot0)
	return slot0[slot0] and slot1.default ~= ""
end

slot0.GetDefaultFace = function (slot0)
	return slot0[slot0].default
end

return slot0

slot0 = class("ShopPaintingView")

slot0.Ctor = function (slot0, slot1)
	slot0._painting = slot1
	slot0.touch = slot0._painting:Find("paint_touch")
	slot0.chat = slot0._painting:Find("chat")
	slot0.chatText = slot0.chat:Find("Text")
	slot0.name = nil
	slot0.chatting = false
end

slot0.Init = function (slot0, slot1)
	slot0:UnLoad()

	slot0.name = slot1

	slot0:Load()
end

slot0.Load = function (slot0)
	setPaintingPrefabAsync(slot0._painting, slot0.name, "chuanwu")
end

slot0.Chat = function (slot0, slot1, slot2, slot3)
	if not slot0.chatting or slot3 then
		slot0:StopChat()

		if slot2 then
			slot0:PlayCV(slot2, function (slot0)
				if slot0 then
					slot0._cueInfo = slot0.cueInfo
				end

				if slot1 then
					slot0:ShowShipWord(slot0.ShowShipWord)
				end
			end)
		end
	end
end

slot0.ShowShipWord = function (slot0, slot1)
	slot0.chatting = true

	if LeanTween.isTweening(go(slot0.chat)) then
		LeanTween.cancel(go(slot0.chat))
	end

	slot2 = 0.3
	slot3 = 3

	if slot0._cueInfo and slot3 < long2int(slot0._cueInfo.length) / 1000 then
		slot3 = slot4
	end

	setActive(slot0.chat, true)
	setText(slot0.chatText, slot1)
	LeanTween.scale(slot0.chat.gameObject, Vector3.New(1, 1, 1), slot2):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function ()
		if IsNil(slot0.chat) then
			return
		end

		LeanTween.scale(slot0.chat.gameObject, Vector3.New(0, 0, 1), ):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeInBack):setDelay(LeanTweenType.easeInBack):setOnComplete(System.Action(function ()
			if IsNil(slot0.chat) then
				return
			end

			slot0:StopChat()
		end))
	end))
end

slot0.StopChat = function (slot0)
	slot0.chatting = nil

	if LeanTween.isTweening(go(slot0.chat)) then
		LeanTween.cancel(go(slot0.chat))
	end

	setActive(slot0.chat, false)
	slot0:StopCV()
end

slot0.PlayCV = function (slot0, slot1, slot2)
	slot0:StopCV()
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/cv/shop/" .. slot1, slot2)

	slot0._currentVoice = "event:/cv/shop/" .. slot1
end

slot0.StopCV = function (slot0)
	if slot0._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(slot0._currentVoice)
	end

	slot0._currentVoice = nil
	slot0._cueInfo = nil
end

slot0.UnLoad = function (slot0)
	if slot0.name then
		retPaintingPrefab(slot0._painting, slot1)

		slot0.name = nil
	end
end

slot0.Dispose = function (slot0)
	slot0:UnLoad()
	slot0:StopCV()
end

return slot0

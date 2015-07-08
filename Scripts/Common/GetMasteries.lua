MasteryPageTree = {
 ["4211"] = { ID = 4211, rank = 0}, ["4212"] = { ID = 4212, rank = 0}, ["4213"] = { ID = 4213, rank = 0}, ["4214"] = { ID = 4214, rank = 0},
 ["4221"] = { ID = 4221, rank = 0}, ["4222"] = { ID = 4222, rank = 0}, ["4224"] = { ID = 4224, rank = 0},
 ["4231"] = { ID = 4231, rank = 0}, ["4232"] = { ID = 4232, rank = 0}, ["4233"] = { ID = 4233, rank = 0}, ["4234"] = { ID = 4234, rank = 0},
 ["4241"] = { ID = 4241, rank = 0}, ["4242"] = { ID = 4242, rank = 0}, ["4243"] = { ID = 4243, rank = 0}, ["4244"] = { ID = 4244, rank = 0},
 ["4251"] = { ID = 4251, rank = 0}, ["4252"] = { ID = 4252, rank = 0}, ["4253"] = { ID = 4253, rank = 0},
 ["4262"] = { ID = 4262, rank = 0},

 ["4111"] = { ID = 4111, rank = 0}, ["4112"] = { ID = 4112, rank = 0}, ["4113"] = { ID = 4113, rank = 0}, ["4114"] = { ID = 4114, rank = 0},
 ["4121"] = { ID = 4121, rank = 0}, ["4122"] = { ID = 4122, rank = 0}, ["4123"] = { ID = 4123, rank = 0}, ["4124"] = { ID = 4124, rank = 0},
 ["4131"] = { ID = 4131, rank = 0}, ["4132"] = { ID = 4132, rank = 0}, ["4133"] = { ID = 4133, rank = 0}, ["4134"] = { ID = 4134, rank = 0},
 ["4141"] = { ID = 4141, rank = 0}, ["4142"] = { ID = 4142, rank = 0}, ["4143"] = { ID = 4143, rank = 0}, ["4144"] = { ID = 4144, rank = 0},
 ["4151"] = { ID = 4151, rank = 0}, ["4152"] = { ID = 4152, rank = 0}, ["4154"] = { ID = 4154, rank = 0},
 ["4162"] = { ID = 4162, rank = 0},

 ["4311"] = { ID = 4311, rank = 0}, ["4312"] = { ID = 4312, rank = 0}, ["4313"] = { ID = 4313, rank = 0}, ["4314"] = { ID = 4314, rank = 0},
 ["4322"] = { ID = 4322, rank = 0}, ["4323"] = { ID = 4323, rank = 0}, ["4324"] = { ID = 4324, rank = 0},
 ["4331"] = { ID = 4331, rank = 0}, ["4332"] = { ID = 4332, rank = 0}, ["4333"] = { ID = 4333, rank = 0}, ["4334"] = { ID = 4334, rank = 0},
 ["4341"] = { ID = 4341, rank = 0}, ["4342"] = { ID = 4342, rank = 0}, ["4343"] = { ID = 4343, rank = 0}, ["4344"] = { ID = 4344, rank = 0},
 ["4352"] = { ID = 4352, rank = 0}, ["4353"] = { ID = 4353, rank = 0},
 ["4362"] = { ID = 4362, rank = 0}
 }

 local Riot_API_Keys = {
 "c5e3f39a-853c-43dd-9c34-9761ef6c22ee", "f5ed93b6-2462-453b-b622-5c6024f7b617", "a4a7fb0d-440b-4a08-a096-38d3164d3e25", "f14d78fc-9aaa-4369-a32d-d96e16742a53",
 "1758ac7d-3115-45a0-9970-c55f36acd524", "85c4b2c4-b9c9-469a-8cb1-69c1a4f5f5a0", "70858315-7457-4701-88ec-b8794e09e170", "713aea94-e7a7-483c-9e0b-8a3dc77afdc6",
 "0ef2a626-2426-42a2-86f2-2a3eddda28fc", "137c770f-f002-44c4-91d5-a2f04e64e6ec", "62ee08a4-acad-4760-be90-f5572cc36466", "24e46c98-e2cf-4a99-8990-517bbc5da776",
}

API_KEY_NUMBER = math.random(1,12)



function FillMasterTreeTable()
	if not GotAllMasteries then
		DoDownload("http://prod.api.pvp.net/api/lol/euw/v1.4/summoner/by-name/"..(myHero.name).."?api_key="..Riot_API_Keys[API_KEY_NUMBER], "Masteries")
		if FileExist(SCRIPT_PATH.."/Common/Masteries.txt") and SummonerID == nil then
			FileOpen = io.open(SCRIPT_PATH.."/Common/Masteries.txt", "r")
			FileRead = FileOpen:read("*a")
			SummonerIDStartPos = string.find(FileRead, ':{"id":')
			SummonerIDEndPos = string.find(FileRead, ',"name":"')
			SummonerID = string.sub(FileRead, SummonerIDStartPos+7, SummonerIDEndPos-1)
			FileClose = FileOpen:close()
		end
		if SummonerID ~= nil then
			DoDownload("http://prod.api.pvp.net/api/lol/euw/v1.4/summoner/"..SummonerID.."/masteries?api_key="..Riot_API_Keys[API_KEY_NUMBER], "Masteries2")
		end
		if FileExist(SCRIPT_PATH.."/Common/Masteries2.txt") then
			FileOpen = io.open(SCRIPT_PATH.."/Common/Masteries2.txt", "r")
			FileRead = FileOpen:read("*a")
			MasteryPageStartPos = string.find(FileRead, '"current":true')
			MasteryPageStart = string.sub(FileRead, MasteryPageStartPos)
			MasteryPageEndPos = string.find(MasteryPageStart, '"current":false')
			MasteryPage = string.sub(MasteryPageStart, 0, MasteryPageEndPos)

			while string.find(MasteryPage, 'rank":') ~= nil do
				NextID = string.find(MasteryPage, '{"id":')
				ClearID = string.sub(MasteryPage, NextID+6, NextID+6+3)
				NextRank = string.find(MasteryPage, 'rank":')
				ClearRank = string.sub(MasteryPage, NextRank+6, NextRank+6)
				MasteryPageTree[ClearID].rank = ClearRank
				MasteryPageTree[ClearID].ID = ClearID
				MasteryPage = string.sub(MasteryPage, NextRank+6+1)
			end
			FileClose = FileOpen:close()
			os.remove(SCRIPT_PATH.."/Common/Masteries.txt")
			os.remove(SCRIPT_PATH.."/Common/Masteries2.txt")
			GotAllMasteries = true
		end
	end
end

function DoDownload(APIPath, FileToSave)
	if not FileExist(SCRIPT_PATH.."/Common/"..FileToSave..".txt") then
		if not DownloadStarted then
			if FileToSave == "Masteries" then
				SummonerID = nil
			end
			DownloadFile(APIPath.."&rand="..tostring(math.random(1,10000)), SCRIPT_PATH.."/Common/"..FileToSave..".txt",  function() DownloadStarted = false end)
			DownloadStarted = true
		end
	end
end
getgenv().Settings = {
    ["Join Team"] = "Pirate", -- "Pirate","Marine"}
}


spawn(function()
    while task.wait() do
        if game.Players.LocalPlayer.Team == nil then
            pcall(function()
                if getgenv().Settings['Join Team'] == "Pirate" then
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Transparency = 1
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Size = UDim2.new(10000,1000,10000,1000)
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4,0,-5,0)
                    wait(.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(605,394,0,true,game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton,0)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(605,394,0,false,game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton,0)
                elseif getgenv().Settings['Join Team'] == "Marine" then
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Transparency = 1
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Size = UDim2.new(10000,1000,10000,1000)
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4,0,-5,0)
                    wait(.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(605,394,0,true,game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton,0)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(605,394,0,false,game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton,0)
                else
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Size = UDim2.new(10000,1000,10000,1000)
                    game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4,0,-5,0)
                    wait(.5)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(605,394,0,true,game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton,0)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(605,394,0,false,game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton,0)
                end
            end)
        end
    end
end)





local a = require(game:GetService("ReplicatedStorage").Effect.Container.Misc.Damage)
	local old = a.Run
	a.Run = function(...)
		args = {...}
		args[1]['Value'] = ""
		return old(...)
	end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(
		function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position

				input.Changed:Connect(
					function()
						if input.UserInputState == Enum.UserInputState.End then
							Dragging = false
						end
					end
				)
			end
		end
	)

	topbarobject.InputChanged:Connect(
		function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement or
				input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = input
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)
			if input == DragInput and Dragging then
				Update(input)
			end
		end
	)
end

repeat wait(1.5) until game:IsLoaded()


-------[function]----[service]

function Hop()
	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(4)
				end
			end
		end
	end
	function Teleport() 
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end
	Teleport()
end              


if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

function StopTween(target)
    if not target then
        _G.StopTween = true
        wait()
        topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
        end
        _G.StopTween = false
        _G.Clip = false
    end
end
    


function TelePBoss(p)
	if (p.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 2000 and not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
		if NameQuest == "FishmanQuest" then
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
			_G.StopTween = nil
		elseif Ms == "God's Guard [Lv. 450]"  then
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
			_G.StopTween = nil
		elseif NameQuest == "SkyExp1Quest" then
			TP1(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
			_G.StopTween = nil
		elseif NameQuest == "ShipQuest1" then
			TP1(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
		elseif NameQuest == "ShipQuest2" then
			TP1(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
			_G.StopTween = nil
		elseif NameQuest == "FrostQuest" then
			TP1(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422))
			_G.StopTween = nil
		else
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
			repeat wait(.5)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
				wait()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
			until (p.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1000 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			_G.Stop_Tween = nil
            wait(0.5)
		end
	end
end




function CheckQuest() 
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel == 1 or MyLevel <= 9 then
            Mon = "Bandit [Lv. 5]"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameMon = CFrame.new(1353.44885, 3.40935516, 1376.92029, 0.776053488, -6.97791975e-08, 0.630666852, 6.99138596e-08, 1, 2.4612488e-08, -0.630666852, 2.49917598e-08, 0.776053488)
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
        elseif MyLevel == 10 or MyLevel <= 14 then
            Mon = "Monkey [Lv. 14]"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameMon = CFrame.new(-1402.74609, 98.5633316, 90.6417007, 0.836947978, 0, 0.547282517, -0, 1, -0, -0.547282517, 0, 0.836947978)
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
        elseif MyLevel == 15 or MyLevel <= 29 then
            Mon = "Gorilla [Lv. 20]"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameMon = CFrame.new(-1267.89001, 66.2034225, -531.818115, -0.813996196, -5.25169774e-08, -0.580869019, -5.58769671e-08, 1, -1.21082593e-08, 0.580869019, 2.26011476e-08, -0.813996196)
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838, 0, 0, 1, 0, 1, -0, -1, 0, 0)
        elseif MyLevel == 30 or MyLevel <= 39 then
            Mon = "Pirate [Lv. 35]"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameMon = CFrame.new(-1169.5365, 5.09531212, 3933.84082, -0.971822679, -3.73200315e-09, 0.235713184, -4.16762763e-10, 1, 1.41145424e-08, -0.235713184, 1.3618596e-08, -0.971822679)
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
        elseif MyLevel == 40 or MyLevel <= 59 then
            Mon = "Brute [Lv. 45]"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameMon = CFrame.new(-1165.09985, 15.1531372, 4363.51514, -0.962800264, 1.17564889e-06, 0.270213336, 2.60172015e-07, 1, -3.4237969e-06, -0.270213336, -3.22613073e-06, -0.962800264)
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
        elseif MyLevel == 60 or MyLevel <= 74 then
            Mon = "Desert Bandit [Lv. 60]"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameMon = CFrame.new(932.788818, 6.8503746, 4488.24609, -0.998625934, 3.08948351e-08, 0.0524050146, 2.79967303e-08, 1, -5.60361286e-08, -0.0524050146, -5.44919629e-08, -0.998625934)
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)
        elseif MyLevel == 75 or MyLevel <= 89 then
            Mon = "Desert Officer [Lv. 70]"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameMon = CFrame.new(1617.07886, 1.5542295, 4295.54932, -0.997540116, -2.26287735e-08, -0.070099175, -1.69377223e-08, 1, -8.17798806e-08, 0.070099175, -8.03913949e-08, -0.997540116)
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)
        elseif MyLevel == 90 or MyLevel <= 99 then
            Mon = "Snow Bandit [Lv. 90]"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameMon = CFrame.new(1412.92346, 55.3503647, -1260.62036, -0.246266365, -0.0169920288, -0.969053388, 0.000432241941, 0.999844253, -0.0176417865, 0.969202161, -0.00476344163, -0.246220857)
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
        elseif MyLevel == 100 or MyLevel <= 119 then
            Mon = "Snowman [Lv. 100]"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameMon = CFrame.new(1376.86401, 97.2779999, -1396.93115, -0.986755967, 7.71178321e-08, -0.162211925, 7.71531674e-08, 1, 6.08143536e-09, 0.162211925, -6.51427134e-09, -0.986755967)
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796, -0.342042685, 0, 0.939684391, 0, 1, 0, -0.939684391, 0, -0.342042685)
        elseif MyLevel == 120 or MyLevel <= 149 then
            Mon = "Chief Petty Officer [Lv. 120]"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFramMon = CFrame.new(-4882.8623, 22.6520386, 4255.53516, 0.273695946, -5.40380647e-08, -0.96181643, 4.37720793e-08, 1, -4.37274998e-08, 0.96181643, -3.01326679e-08, 0.273695946)
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 150 or MyLevel <= 174 then
            Mon = "Sky Bandit [Lv. 150]"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameMon = CFrame.new(-4959.51367, 365.39267, -2974.56812, 0.964867651, 7.74418396e-08, 0.262737453, -6.95931988e-08, 1, -3.91783708e-08, -0.262737453, 1.95171506e-08, 0.964867651)
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
        elseif MyLevel == 175 or MyLevel <= 189 then
            Mon = "Dark Master [Lv. 175]"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameMon = CFrame.new(-5079.98096, 376.477356, -2194.17139, 0.465965867, -3.69776352e-08, 0.884802461, 3.40249851e-09, 1, 4.00000886e-08, -0.884802461, -1.56281423e-08, 0.465965867)
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
        elseif MyLevel == 190 or MyLevel <= 209 then
            Mon = "Prisoner [Lv. 190]"
            LevelQuest = 1
            NameQuest = "PrisonerQuest"
            NameMon = "Prisoner"
            CFrameMon = CFrame.new(5433.39307, 88.678093, 514.986877, 0.879988372, 0, -0.474995494, 0, 1, 0, 0.474995494, 0, 0.879988372)
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
        elseif MyLevel == 210 or MyLevel <= 249 then
            Mon = "Dangerous Prisoner [Lv. 210]"
            LevelQuest = 2
            NameQuest = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            CFrameMon = CFrame.new(5433.39307, 88.678093, 514.986877, 0.879988372, 0, -0.474995494, 0, 1, 0, 0.474995494, 0, 0.879988372)
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, -0.0894274712, -5.00292918e-09, -0.995993316, 1.60817859e-09, 1, -5.16744869e-09, 0.995993316, -2.06384709e-09, -0.0894274712)
        elseif MyLevel == 250 or MyLevel <= 274 then
            Mon = "Toga Warrior [Lv. 250]"
            LevelQuest = 1
            NameQuest = "ColosseumQuest"
            NameMon = "Toga Warrior"
            CFrameMon = CFrame.new(-1779.97583, 44.6077499, -2736.35474, 0.984437346, 4.10396339e-08, 0.175734788, -3.62286876e-08, 1, -3.05844168e-08, -0.175734788, 2.3741821e-08, 0.984437346)
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
        elseif MyLevel == 275 or MyLevel <= 299 then
            Mon = "Gladiator [Lv. 275]"
            LevelQuest = 2
            NameQuest = "ColosseumQuest"
            NameMon = "Gladiator"
            CFrameMon = CFrame.new(-1274.75903, 58.1895943, -3188.16309, 0.464524001, 6.21005611e-08, 0.885560572, -4.80449414e-09, 1, -6.76054768e-08, -0.885560572, 2.71497012e-08, 0.464524001)
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534, -0.515037298, 0, -0.857167721, 0, 1, 0, 0.857167721, 0, -0.515037298)
        elseif MyLevel == 300 or MyLevel <= 324 then
            Mon = "Military Soldier [Lv. 300]"
            LevelQuest = 1
            NameQuest = "MagmaQuest"
            NameMon = "Military Soldier"
            CFrameMon = CFrame.new(-5363.01123, 41.5056877, 8548.47266, -0.578253984, -3.29503091e-10, 0.815856814, 9.11209668e-08, 1, 6.498761e-08, -0.815856814, 1.11920997e-07, -0.578253984)
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
        elseif MyLevel == 325 or MyLevel <= 374 then
            Mon = "Military Spy [Lv. 325]"
            LevelQuest = 2
            NameQuest = "MagmaQuest"
            NameMon = "Military Spy"
            CFrameMon = CFrame.new(-5787.99023, 120.864456, 8762.25293, -0.188358366, -1.84706277e-08, 0.982100308, -1.23782129e-07, 1, -4.93306951e-09, -0.982100308, -1.22495649e-07, -0.188358366)
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
        elseif MyLevel == 375 or MyLevel <= 399 then
            Mon = "Fishman Warrior [Lv. 375]"
            LevelQuest = 1
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Warrior"
            CFrameMon = CFrame.new(60946.6094, 48.6735229, 1525.91687, -0.0817126185, 8.90751153e-08, 0.996655822, 2.00889794e-08, 1, -8.77269599e-08, -0.996655822, 1.28533992e-08, -0.0817126185)
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel == 400 or MyLevel <= 449 then
            Mon = "Fishman Commando [Lv. 400]"
            LevelQuest = 2
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Commando"
            CFrameMon = CFrame.new(60946.6094, 48.6735229, 1525.916871)
            CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
            end
        elseif MyLevel == 450 or MyLevel <= 474 then
            Mon = "God's Guard [Lv. 450]"
            LevelQuest = 1
            NameQuest = "SkyExp1Quest"
            NameMon = "God's Guard"
            CFrameMon = CFrame.new(-4716.95703, 853.089722, -1933.925427)
            CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
            end
        elseif MyLevel == 475 or MyLevel <= 524 then
            Mon = "Shanda [Lv. 475]"
            LevelQuest = 2
            NameQuest = "SkyExp1Quest"
            NameMon = "Shanda"
            CFrameMon = CFrame.new(-7904.57373, 5584.37646, -459.62973, 0.65171206, 5.11171692e-08, 0.758466363, -4.76232476e-09, 1, -6.33034247e-08, -0.758466363, 3.76435416e-08, 0.65171206)
            CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
            end
        elseif MyLevel == 525 or MyLevel <= 549 then
            Mon = "Royal Squad [Lv. 525]"
            LevelQuest = 1
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Squad"
            CFrameMon = CFrame.new(-7555.04199, 5606.90479, -1303.24744, -0.896107852, -9.6057462e-10, -0.443836004, -4.24974544e-09, 1, 6.41599973e-09, 0.443836004, 7.63560326e-09, -0.896107852)
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 550 or MyLevel <= 624 then
            Mon = "Royal Soldier [Lv. 550]"
            LevelQuest = 2
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            CFrameMon = CFrame.new(-7837.31152, 5649.65186, -1791.08582, -0.716008604, 0.0104285581, -0.698013008, 5.02521061e-06, 0.99988848, 0.0149335321, 0.69809103, 0.0106890313, -0.715928733)
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 625 or MyLevel <= 649 then
            Mon = "Galley Pirate [Lv. 625]"
            LevelQuest = 1
            NameQuest = "FountainQuest"
            NameMon = "Galley Pirate"
            CFrameMon = CFrame.new(5569.80518, 38.5269432, 3849.01196, 0.896460414, 3.98027495e-08, 0.443124533, -1.34262139e-08, 1, -6.26611296e-08, -0.443124533, 5.02237434e-08, 0.896460414)
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
        elseif MyLevel >= 650 then
            Mon = "Galley Captain [Lv. 650]"
            LevelQuest = 2
            NameQuest = "FountainQuest"
            NameMon = "Galley Captain"
            CFrameMon = CFrame.new(5782.90186, 94.5326462, 4716.78174, 0.361808896, -1.24757526e-06, -0.932252586, 2.16989656e-06, 1, -4.96097414e-07, 0.932252586, -1.84339774e-06, 0.361808896)
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
        end
    elseif World2 then
        if MyLevel == 700 or MyLevel <= 724 then
            Mon = "Raider [Lv. 700]"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameMon = CFrame.new(-737.026123, 10.1748352, 2392.57959, 0.272128761, 0, -0.962260842, -0, 1, -0, 0.962260842, 0, 0.272128761)
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
        elseif MyLevel == 725 or MyLevel <= 774 then
            Mon = "Mercenary [Lv. 725]"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameMon = CFrame.new(-1022.21271, 72.9855194, 1891.39148, -0.990782857, 0, -0.135460541, 0, 1, 0, 0.135460541, 0, -0.990782857)
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188, -0.22495985, 0, -0.974368095, 0, 1, 0, 0.974368095, 0, -0.22495985)
        elseif MyLevel == 775 or MyLevel <= 799 then
            Mon = "Swan Pirate [Lv. 775]"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameMon = CFrame.new(976.467651, 111.174057, 1229.1084, 0.00852567982, -4.73897828e-08, -0.999963999, 1.12251888e-08, 1, -4.7295778e-08, 0.999963999, -1.08215579e-08, 0.00852567982)
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898, 0.139203906, 0, 0.99026376, 0, 1, 0, -0.99026376, 0, 0.139203906)
        elseif MyLevel == 800 or MyLevel <= 874 then
            Mon = "Factory Staff [Lv. 800]"
            NameQuest = "Area2Quest"
            LevelQuest = 2
            NameMon = "Factory Staff"
            CFrameMon = CFrame.new(336.74585, 73.1620483, -224.129272, 0.993632793, 3.40154607e-08, 0.112668738, -3.87658332e-08, 1, 3.99718729e-08, -0.112668738, -4.40850592e-08, 0.993632793)
            CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321, -0.0319722369, 8.96074881e-10, -0.999488771, 1.36326533e-10, 1, 8.92172336e-10, 0.999488771, -1.07732087e-10, -0.0319722369)
        elseif MyLevel == 875 or MyLevel <= 899 then
            Mon = "Marine Lieutenant [Lv. 875]"
            LevelQuest = 1
            NameQuest = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            CFrameMon = CFrame.new(-2842.69922, 72.9919434, -2901.90479, -0.762281299, 0, -0.64724648, 0, 1.00000012, 0, 0.64724648, 0, -0.762281299)
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
        elseif MyLevel == 900 or MyLevel <= 949 then
            Mon = "Marine Captain [Lv. 900]"
            LevelQuest = 2
            NameQuest = "MarineQuest3"
            NameMon = "Marine Captain"
            CFrameMon = CFrame.new(-1814.70313, 72.9919434, -3208.86621, -0.900422215, 7.93464423e-08, -0.435017526, 3.68856199e-08, 1, 1.06050372e-07, 0.435017526, 7.94441988e-08, -0.900422215)
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812, 0.866007268, 0, 0.500031412, 0, 1, 0, -0.500031412, 0, 0.866007268)
        elseif MyLevel == 950 or MyLevel <= 974 then
            Mon = "Zombie [Lv. 950]"
            LevelQuest = 1
            NameQuest = "ZombieQuest"
            NameMon = "Zombie"
            CFrameMon = CFrame.new(-5649.23438, 126.0578, -737.773743, 0.355238914, -8.10359282e-08, 0.934775114, 1.65461245e-08, 1, 8.04023372e-08, -0.934775114, -1.3095117e-08, 0.355238914)
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
        elseif MyLevel == 975 or MyLevel <= 999 then
            Mon = "Vampire [Lv. 975]"
            LevelQuest = 2
            NameQuest = "ZombieQuest"
            NameMon = "Vampire"
            CFrameMon = CFrame.new(-6030.32031, 0.4377408, -1313.5564, -0.856965423, 3.9138893e-08, -0.515373945, -1.12178942e-08, 1, 9.45958547e-08, 0.515373945, 8.68467822e-08, -0.856965423)
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061, -0.29242146, 0, -0.95628953, 0, 1, 0, 0.95628953, 0, -0.29242146)
        elseif MyLevel == 1000 or MyLevel <= 1049 then
            Mon = "Snow Trooper [Lv. 1000]"
            LevelQuest = 1
            NameQuest = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            CFrameMon = CFrame.new(621.003418, 391.361053, -5335.43604, 0.481644779, 0, 0.876366913, 0, 1, 0, -0.876366913, 0, 0.481644779)
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
        elseif MyLevel == 1050 or MyLevel <= 1099 then
            Mon = "Winter Warrior [Lv. 1050]"
            LevelQuest = 2
            NameQuest = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            CFrameMon = CFrame.new(1295.62683, 429.447784, -5087.04492, -0.698032081, -8.28980049e-08, -0.71606636, -1.98835952e-08, 1, -9.63858184e-08, 0.71606636, -5.30424877e-08, -0.698032081)
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928, -0.374604106, 0, 0.92718488, 0, 1, 0, -0.92718488, 0, -0.374604106)
        elseif MyLevel == 1100 or MyLevel <= 1124 then
            Mon = "Lab Subordinate [Lv. 1100]"
            LevelQuest = 1
            NameQuest = "IceSideQuest"
            NameMon = "Lab Subordinate"
            CFrameMon = CFrame.new(-5769.2041, 37.9288292, -4468.38721, -0.569419742, -2.49055017e-08, 0.822046936, -6.96206541e-08, 1, -1.79282633e-08, -0.822046936, -6.74401548e-08, -0.569419742)
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
        elseif MyLevel == 1125 or MyLevel <= 1174 then
            Mon = "Horned Warrior [Lv. 1125]"
            LevelQuest = 2
            NameQuest = "IceSideQuest"
            NameMon = "Horned Warrior"
            CFrameMon = CFrame.new(-6401.27979, 15.9775667, -5948.24316, 0.388303697, 0, -0.921531856, 0, 1, 0, 0.921531856, 0, 0.388303697)
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852, 0.453972578, -0, -0.891015649, 0, 1, -0, 0.891015649, 0, 0.453972578)
        elseif MyLevel == 1175 or MyLevel <= 1199 then
            Mon = "Magma Ninja [Lv. 1175]"
            LevelQuest = 1
            NameQuest = "FireSideQuest"
            NameMon = "Magma Ninja"
            CFrameMon = CFrame.new(-5466.06445, 57.6952019, -5837.42822, -0.988835871, 0, -0.149006829, 0, 1, 0, 0.149006829, 0, -0.988835871)
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
        elseif MyLevel == 1200 or MyLevel <= 1249 then
            Mon = "Lava Pirate [Lv. 1200]"
            LevelQuest = 2
            NameQuest = "FireSideQuest"
            NameMon = "Lava Pirate"
            CFrameMon = CFrame.new(-5169.71729, 34.1234779, -4669.73633, -0.196780294, 0, 0.98044765, 0, 1.00000012, -0, -0.98044765, 0, -0.196780294)
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)
        elseif MyLevel == 1250 or MyLevel <= 1274 then
            Mon = "Ship Deckhand [Lv. 1250]"
            LevelQuest = 1
            NameQuest = "ShipQuest1"
            NameMon = "Ship Deckhand"
            CFrameMon = CFrame.new(1163.80872, 138.288452, 33058.4258, -0.998580813, 5.49076979e-08, -0.0532564968, 5.57436763e-08, 1, -1.42118655e-08, 0.0532564968, -1.71604082e-08, -0.998580813)
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)         
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel == 1275 or MyLevel <= 1299 then
            Mon = "Ship Engineer [Lv. 1275]"
            LevelQuest = 2
            NameQuest = "ShipQuest1"
            NameMon = "Ship Engineer"
            CFrameMon = CFrame.new(921.30249023438, 125.400390625, 32937.34375)
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)   
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end             
        elseif MyLevel == 1300 or MyLevel <= 1324 then
            Mon = "Ship Steward [Lv. 1300]"
            LevelQuest = 1
            NameQuest = "ShipQuest2"
            NameMon = "Ship Steward"
            CFrameMon = CFrame.new(917.96057128906, 136.89932250977, 33343.4140625)
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)         
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel == 1325 or MyLevel <= 1349 then
            Mon = "Ship Officer [Lv. 1325]"
            LevelQuest = 2
            NameQuest = "ShipQuest2"
            NameMon = "Ship Officer"
            CFrameMon = CFrame.new(944.44964599609, 181.40081787109, 33278.9453125)
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
            end
        elseif MyLevel == 1350 or MyLevel <= 1374 then
            Mon = "Arctic Warrior [Lv. 1350]"
            LevelQuest = 1
            NameQuest = "FrostQuest"
            NameMon = "Arctic Warrior"
            CFrameMon = CFrame.new(5878.23486, 81.3886948, -6136.35596, -0.451037169, 2.3908234e-07, 0.892505825, -1.08168464e-07, 1, -3.22542007e-07, -0.892505825, -2.4201924e-07, -0.451037169)
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-6508.5581054688, 5000.034996032715, -132.83953857422))
            end
        elseif MyLevel == 1375 or MyLevel <= 1424 then
            Mon = "Snow Lurker [Lv. 1375]"
            LevelQuest = 2
            NameQuest = "FrostQuest"
            NameMon = "Snow Lurker"
            CFrameMon = CFrame.new(5513.36865, 60.546711, -6809.94971, -0.958693981, -1.65617333e-08, 0.284439981, -4.07668654e-09, 1, 4.44854642e-08, -0.284439981, 4.14883701e-08, -0.958693981)
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984, -0.933587909, 0, -0.358349502, 0, 1, 0, 0.358349502, 0, -0.933587909)
        elseif MyLevel == 1425 or MyLevel <= 1449 then
            Mon = "Sea Soldier [Lv. 1425]"
            LevelQuest = 1
            NameQuest = "ForgottenQuest"
            NameMon = "Sea Soldier"
            CFrameMon = CFrame.new(-3115.78223, 63.8785706, -9808.38574, -0.913427353, 3.11199457e-08, 0.407000452, 7.79564235e-09, 1, -5.89660658e-08, -0.407000452, -5.06883708e-08, -0.913427353)
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
        elseif MyLevel >= 1450 then
            Mon = "Water Fighter [Lv. 1450]"
            LevelQuest = 2
            NameQuest = "ForgottenQuest"
            NameMon = "Water Fighter"
            CFrameMon = CFrame.new(-3212.99683, 263.809296, -10551.8799, 0.742111444, -5.59139615e-08, -0.670276582, 1.69155214e-08, 1, -6.46908234e-08, 0.670276582, 3.66697037e-08, 0.742111444)
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193, 0.990270376, -0, -0.13915664, 0, 1, -0, 0.13915664, 0, 0.990270376)
        end
    elseif World3 then
        if MyLevel == 1500 or MyLevel <= 1524 then
            Mon = "Pirate Millionaire [Lv. 1500]"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameMon = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
        elseif MyLevel == 1525 or MyLevel <= 1574 then
            Mon = "Pistol Billionaire [Lv. 1525]"
            LevelQuest = 2
            NameQuest = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            CFrameMon = CFrame.new(81.164993286133, 43.755737304688, 5724.7021484375)
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627)
        elseif MyLevel == 1575 or MyLevel <= 1599 then
            Mon = "Dragon Crew Warrior [Lv. 1575]"
            LevelQuest = 1
            NameQuest = "AmazonQuest"
            NameMon = "Dragon Crew Warrior"
            CFrameMon = CFrame.new(6241.9951171875, 51.522083282471, -1243.9771728516)
            CFrameQuest = CFrame.new(5832.83594, 51.6806107, -1101.51563, 0.898790359, -0, -0.438378751, 0, 1, -0, 0.438378751, 0, 0.898790359)
        elseif MyLevel == 1600 or MyLevel <= 1624 then 
            Mon = "Dragon Crew Archer [Lv. 1600]"
            NameQuest = "AmazonQuest"
            LevelQuest = 2
            NameMon = "Dragon Crew Archer"
            CFrameMon = CFrame.new(6488.9155273438, 383.38375854492, -110.66246032715)
            CFrameQuest = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
        elseif MyLevel == 1625 or MyLevel <= 1649 then
            Mon = "Female Islander [Lv. 1625]"
            NameQuest = "AmazonQuest2"
            LevelQuest = 1
            NameMon = "Female Islander"
            CFrameMon = CFrame.new(4770.4990234375, 758.95520019531, 1069.8680419922)
            CFrameQuest = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
        elseif MyLevel == 1650 or MyLevel <= 1699 then 
            Mon = "Giant Islander [Lv. 1650]"
            NameQuest = "AmazonQuest2"
            LevelQuest = 2
            NameMon = "Giant Islander"
            CFrameMon = CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789)
            CFrameQuest = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
        elseif MyLevel == 1700 or MyLevel <= 1724 then
            Mon = "Marine Commodore [Lv. 1700]"
            LevelQuest = 1
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            CFrameMon = CFrame.new(2490.0844726563, 190.4232635498, -7160.0502929688)
            CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
        elseif MyLevel == 1725 or MyLevel <= 1774 then
            Mon = "Marine Rear Admiral [Lv. 1725]"
            NameMon = "Marine Rear Admiral"
            NameQuest = "MarineTreeIsland"
            LevelQuest = 2
            CFrameMon = CFrame.new(3951.3903808594, 229.11549377441, -6912.81640625)
            CFrameQuest = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
        elseif MyLevel == 1775 or MyLevel <= 1799 then
            Mon = "Fishman Raider [Lv. 1775]"
            LevelQuest = 1
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            CFrameMon = CFrame.new(-10322.400390625, 390.94473266602, -8580.0908203125)
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
        elseif MyLevel == 1800 or MyLevel <= 1824 then
            Mon = "Fishman Captain [Lv. 1800]"
            LevelQuest = 2
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            CFrameMon = CFrame.new(-11194.541992188, 442.02795410156, -8608.806640625)
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652, -0.882952213, 0, 0.469463557, 0, 1, 0, -0.469463557, 0, -0.882952213)   
        elseif MyLevel == 1825 or MyLevel <= 1849 then
            Mon = "Forest Pirate [Lv. 1825]"
            LevelQuest = 1
            NameQuest = "DeepForestIsland"
            NameMon = "Forest Pirate"
            CFrameMon = CFrame.new(-13225.809570313, 428.19387817383, -7753.1245117188)
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)
        elseif MyLevel == 1850 or MyLevel <= 1899 then
            Mon = "Mythological Pirate [Lv. 1850]"
            LevelQuest = 2
            NameQuest = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            CFrameMon = CFrame.new(-13869.172851563, 564.95251464844, -7084.4135742188)
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137, 0.707134247, -0, -0.707079291, 0, 1, -0, 0.707079291, 0, 0.707134247)   
        elseif MyLevel == 1900 or MyLevel <= 1924 then
            Mon = "Jungle Pirate [Lv. 1900]"
            LevelQuest = 1
            NameQuest = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            CFrameMon = CFrame.new(-11982.221679688, 376.32522583008, -10451.415039063)
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
        elseif MyLevel == 1925 or MyLevel <= 1974 then
            Mon = "Musketeer Pirate [Lv. 1925]"
            LevelQuest = 2
            NameQuest = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            CFrameMon = CFrame.new(-13282.3046875, 496.23684692383, -9565.150390625)
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953, -0.0871315002, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, -0.0871315002)
        elseif MyLevel == 1975 or MyLevel <= 1999 then
            Mon = "Reborn Skeleton [Lv. 1975]"
            LevelQuest = 1
            NameQuest = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            CFrameMon = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
        elseif MyLevel == 2000 or MyLevel <= 2024 then
            Mon = "Living Zombie [Lv. 2000]"
            LevelQuest = 2
            NameQuest = "HauntedQuest1"
            NameMon = "Living Zombie"
            CFrameMon = CFrame.new(-10125.234375, 183.94705200195, 6242.013671875)
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0)
        elseif MyLevel == 2025 or MyLevel <= 2049 then
            Mon = "Demonic Soul [Lv. 2025]"
            LevelQuest = 1
            NameQuest = "HauntedQuest2"
            NameMon = "Demonic Soul"
            CFrameMon = CFrame.new(-9712.03125, 204.69589233398, 6193.322265625)
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0) 
        elseif MyLevel == 2050 or MyLevel <= 2074 then
            Mon = "Posessed Mummy [Lv. 2050]"
            LevelQuest = 2
            NameQuest = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            CFrameMon = CFrame.new(-9545.7763671875, 69.619895935059, 6339.5615234375)    
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 2075 or MyLevel <= 2099 then
            Mon = "Peanut Scout [Lv. 2075]"
            LevelQuest = 1
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            CFrameMon = CFrame.new(-2098.07544, 192.611862, -10248.8867, 0.983392298, -9.57031787e-08, 0.181492642, 8.7276355e-08, 1, 5.44169616e-08, -0.181492642, -3.76732068e-08, 0.983392298)
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 2100 or MyLevel <= 2124 then
            Mon = "Peanut President [Lv. 2100]"
            LevelQuest = 2
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut President"
            CFrameMon = CFrame.new(-1876.95959, 192.610947, -10542.2939, 0.0553516336, -2.83836812e-08, 0.998466909, -6.89634405e-10, 1, 2.84654931e-08, -0.998466909, -2.26418861e-09, 0.0553516336)
            CFrameQuest = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 2125 or MyLevel <= 2149 then
            Mon = "Ice Cream Chef [Lv. 2125]"
            LevelQuest = 1
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            CFrameMon = CFrame.new(-821.614075, 208.39537, -10990.7617, -0.870096624, 3.18909272e-08, 0.492881238, -1.8357893e-08, 1, -9.71107568e-08, -0.492881238, -9.35439957e-08, -0.870096624)
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 2150 or MyLevel <= 2199 then
            Mon = "Ice Cream Commander [Lv. 2150]"
            LevelQuest = 2
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            CFrameMon = CFrame.new(-610.11669921875, 208.26904296875, -11253.686523438)
            CFrameQuest = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438, 0, 0, -1, 0, 1, 0, 1, 0, 0)
        elseif MyLevel == 2200 or MyLevel <= 2224 then
            Mon = "Cookie Crafter [Lv. 2200]"
            LevelQuest = 1
            NameQuest = "CakeQuest1"
            NameMon = "Cookie Crafter"
            CFrameMon = CFrame.new(-2286.684326171875, 146.5656280517578, -12226.8818359375)
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
        elseif MyLevel == 2225 or MyLevel <= 2249 then
            Mon = "Cake Guard [Lv. 2225]"
            LevelQuest = 2
            NameQuest = "CakeQuest1"
            NameMon = "Cake Guard"
            CFrameMon = CFrame.new(-1817.9747314453125, 209.5632781982422, -12288.9228515625)
            CFrameQuest = CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931)
        elseif MyLevel == 2250 or MyLevel <= 2274 then
            Mon = "Baking Staff [Lv. 2250]"
            LevelQuest = 1
            NameQuest = "CakeQuest2"
            NameMon = "Baking Staff"
            CFrameMon = CFrame.new(-1818.347900390625, 93.41275787353516, -12887.66015625)
            CFrameMon = CFrame.new(-1818.347900390625, 93.41275787353516, -12887.66015625)
        elseif MyLevel == 2275 or MyLevel <= 2300 then
            Mon = "Head Baker [Lv. 2275]"
            LevelQuest = 2
            NameQuest = "CakeQuest2"
            NameMon = "Head Baker"
            CFrameMon = CFrame.new(-2288.795166015625, 106.9419174194336, -12811.111328125)
            CFrameQuest = CFrame.new(-1927.91602, 37.7981339, -12842.5391, -0.96804446, 4.22142143e-08, 0.250778586, 4.74911062e-08, 1, 1.49904711e-08, -0.250778586, 2.64211941e-08, -0.96804446)
        elseif MyLevel == 2301 or MyLevel <= 2324 then
            Mon = "Cocoa Warrior [Lv. 2300]"
            LevelQuest = 1
            NameQuest = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            CFrameMon = CFrame.new(-95.5974121, 24.7600784, -12310.1211, -0.610346496, -1.89373264e-08, 0.792134583, -1.02349254e-07, 1, -5.4954274e-08, -0.792134583, -1.14615531e-07, -0.610346496)
            CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        elseif MyLevel == 2325 or MyLevel <= 2349 then
            Mon = "Chocolate Bar Battler [Lv. 2325]"
            LevelQuest = 2
            NameQuest = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            CFrameMon = CFrame.new(585.318848, 77.1880112, -12463.8682, 0.225424603, -1.53788804e-08, -0.974260628, -1.1136343e-09, 1, -1.60428542e-08, 0.974260628, 4.70142414e-09, 0.225424603)
            CFrameQuest = CFrame.new(231.75, 23.9003029, -12200.292, -1, 0, 0, 0, 1, 0, 0, 0, -1)
        elseif MyLevel == 2350 or MyLevel <= 2374 then
            Mon = "Sweet Thief [Lv. 2350]"
            LevelQuest = 1
            NameQuest = "ChocQuest2"
            NameMon = "Sweet Thief"
            CFrameMon = CFrame.new(68.6807404, 77.2475662, -12635.0957, 0.937214851, -1.03819522e-08, 0.348752528, 7.28287475e-09, 1, 1.01972999e-08, -0.348752528, -7.01713976e-09, 0.937214851)
            CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)
        elseif MyLevel == 2375 or MyLevel <= 2400 then
            Mon = "Candy Rebel [Lv. 2375]"
            LevelQuest = 2
            NameQuest = "ChocQuest2"
            NameMon = "Candy Rebel"
            CFrameMon = CFrame.new(84.2680511, 256.678314, -12961.3281, -0.609455585, 0, 0.792820275, 0, 1.00000012, -0, -0.792820275, 0, -0.609455585)
            CFrameQuest = CFrame.new(151.198242, 23.8907146, -12774.6172, 0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, 0.422592998)  
        end
    end
end
function UpdateIslandESP() 
    for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
        pcall(function()
            if IslandESP then 
                if v.Name ~= "Sea" then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end
function UpdateChestEsp() 
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        pcall(function()
            if string.find(v.Name,"Chest") then
                if ChestESP then
                    if string.find(v.Name,"Chest") then
                        if not v:FindFirstChild('NameEsp'..Number) then
                            local bill = Instance.new('BillboardGui',v)
                            bill.Name = 'NameEsp'..Number
                            bill.ExtentsOffset = Vector3.new(0, 1, 0)
                            bill.Size = UDim2.new(1,200,1,30)
                            bill.Adornee = v
                            bill.AlwaysOnTop = true
                            local name = Instance.new('TextLabel',bill)
                            name.Font = "GothamBold"
                            name.FontSize = "Size14"
                            name.TextWrapped = true
                            name.Size = UDim2.new(1,0,1,0)
                            name.TextYAlignment = 'Top'
                            name.BackgroundTransparency = 1
                            name.TextStrokeTransparency = 0.5
                            name.TextColor3 = Color3.fromRGB(0, 255, 250)
                        if v.Name == "Chest1" then
                            name.Text = ("Chest 1" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        end
                        if v.Name == "Chest2" then
                            name.Text = ("Chest 2" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        end
                    if v.Name == "Chest3" then
                        name.Text = ("Chest 3" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp'..Number) then
                v:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
            end
        end)
    end
end
function UpdateBfEsp() 
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        pcall(function()
            if DevilFruitESP then
                if string.find(v.Name, "Fruit") then   
                    if not v.Handle:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v.Handle)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                        name.Text = (v.Name ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    else
                        v.Handle['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                    end
            end
        end)
    end
end
function UpdateFlowerEsp() 
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        pcall(function()
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if FlowerESP then 
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = "GothamBold"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    if v.Name == "Flower1" then 
                        name.Text = ("Blue Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                    if v.Name == "Flower2" then
                        name.Text = ("Red Flower" ..' \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        name.TextColor3 = Color3.fromRGB(255, 0, 0)
                    end
                else
                    v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                end
                else
                    if v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end   
        end)
    end
end
function InfAb()
    if InfAbility then
        if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            local inf = Instance.new("ParticleEmitter")
            inf.Acceleration = Vector3.new(0,0,0)
            inf.Archivable = true
            inf.Drag = 20
            inf.EmissionDirection = Enum.NormalId.Top
            inf.Enabled = true
            inf.Lifetime = NumberRange.new(0.2,0.2)
            inf.LightInfluence = 0
            inf.LockedToPart = true
            inf.Name = "Agility"
            inf.Rate = 500
            local numberKeypoints2 = {
                NumberSequenceKeypoint.new(0, 0);
                NumberSequenceKeypoint.new(1, 4); 
            }
            inf.Size = NumberSequence.new(numberKeypoints2)
            inf.RotSpeed = NumberRange.new(999, 9999)
            inf.Rotation = NumberRange.new(0, 0)
            inf.Speed = NumberRange.new(30, 30)
            inf.SpreadAngle = Vector2.new(360,360)
            inf.Texture = "rbxassetid://7157487174"
            inf.VelocityInheritance = 0
            inf.ZOffset = 2
            inf.Transparency = NumberSequence.new(0)
            inf.Color = ColorSequence.new(Color3.fromRGB(80,245,245),Color3.fromRGB(80,245,245))
            inf.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
        end
    else
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
        end
    end
end

local LocalPlayer = game:GetService'Players'.LocalPlayer
local originalstam = LocalPlayer.Character.Energy.Value
function infinitestam()
    LocalPlayer.Character.Energy.Changed:connect(function()
        if InfiniteEnergy then
            LocalPlayer.Character.Energy.Value = originalstam
        end 
    end)
end
spawn(function()
    pcall(function()
        while wait(.1) do
            if InfiniteEnergy then
                wait(0.1)
                originalstam = LocalPlayer.Character.Energy.Value
                infinitestam()
            end
        end
    end)
end)

function NoDodgeCool()
    if nododgecool then
        for i,v in next, getgc() do
            if game:GetService("Players").LocalPlayer.Character.Dodge then
                if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.Character.Dodge then
                    for i2,v2 in next, getupvalues(v) do
                        if tostring(v2) == "0.1" then
                        repeat wait(.1)
                            setupvalue(v,i2,0)
                        until not nododgecool
                        end
                    end
                end
            end
        end
    end
end

function fly()
    local mouse=game:GetService("Players").LocalPlayer:GetMouse''
    localplayer=game:GetService("Players").LocalPlayer
    game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    local torso = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local speedSET=25
    local keys={a=false,d=false,w=false,s=false}
    local e1
    local e2
    local function start()
        local pos = Instance.new("BodyPosition",torso)
        local gyro = Instance.new("BodyGyro",torso)
        pos.Name="EPIXPOS"
        pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        pos.position = torso.Position
        gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.CFrame = torso.CFrame
        repeat
                wait()
                localplayer.Character.Humanoid.PlatformStand=true
                local new=gyro.CFrame - gyro.CFrame.p + pos.position
                if not keys.w and not keys.s and not keys.a and not keys.d then
                speed=1
                end
                if keys.w then
                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed=speed+speedSET
                end
                if keys.s then
                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
                speed=speed+speedSET
                end
                if keys.d then
                new = new * CFrame.new(speed,0,0)
                speed=speed+speedSET
                end
                if keys.a then
                new = new * CFrame.new(-speed,0,0)
                speed=speed+speedSET
                end
                if speed>speedSET then
                speed=speedSET
                end
                pos.position=new.p
                if keys.w then
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*15),0,0)
                elseif keys.s then
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*15),0,0)
                else
                gyro.CFrame = workspace.CurrentCamera.CoordinateFrame
                end
        until not Fly
        if gyro then 
                gyro:Destroy() 
        end
        if pos then 
                pos:Destroy() 
        end
        flying=false
        localplayer.Character.Humanoid.PlatformStand=false
        speed=0
    end
    e1=mouse.KeyDown:connect(function(key)
        if not torso or not torso.Parent then 
                flying=false e1:disconnect() e2:disconnect() return 
        end
        if key=="w" then
            keys.w=true
        elseif key=="s" then
            keys.s=true
        elseif key=="a" then
            keys.a=true
        elseif key=="d" then
            keys.d=true
        end
    end)
    e2=mouse.KeyUp:connect(function(key)
        if key=="w" then
            keys.w=false
        elseif key=="s" then
            keys.s=false
        elseif key=="a" then
            keys.a=false
        elseif key=="d" then
            keys.d=false
        end
    end)
    start()
end

function Click()
    game:GetService'VirtualUser':CaptureController()
    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
end

function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

function UnEquipWeapon(Weapon)
    if game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
        _G.NotAutoEquip = true
        wait(.5)
        game.Players.LocalPlayer.Character:FindFirstChild(Weapon).Parent = game.Players.LocalPlayer.Backpack
        wait(.1)
        _G.NotAutoEquip = false
    end
end

function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait(.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end
end

function topos(Pos)
	Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if game.Players.LocalPlayer.Character.Humanoid.Sit == true then game.Players.LocalPlayer.Character.Humanoid.Sit = false end
        pcall(function() tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/210, Enum.EasingStyle.Linear),{CFrame = Pos}) end)
        tween:Play()
        if Distance <= 250 then
            tween:Cancel()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Pos
        end
        if _G.StopTween == true then
            tween:Cancel()
            _G.Clip = false
        end
    end




function GetDistance(target)
    return math.floor((target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
end

function SuperTp(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 50 then
        Speed = 50
    elseif Distance < 100 then
        Speed = 100
    elseif Distance < 150 then
        Speed = 150
    elseif Distance < 200 then
        Speed = 200
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Exponential),
        {CFrame = Pos}
    ):Play()
end

function TPExpoNential(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 360 then
        Speed = 360
    elseif Distance > 360 then
        Speed = 200
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Exponential	),
        {CFrame = Pos}
    ):Play()
end

function TP1(Pos)
    Distance = (Pos.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 360 then
        Speed = 1175
    elseif Distance < 1000 then
        Speed = 300
    elseif Distance < 360 then
        Speed = 1175
    elseif Distance >= 1000 then
        Speed = 285
    elseif Distance < 100 then
        Speed = 100000
    end
    game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    ):Play()
end

function TP(Pos)
    Distance = (Pos.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance < 250 then
        Speed = 600
    elseif Distance >= 1000 then
        Speed = 200
    end
    game:GetService("TweenService"):Create(
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = Pos}
    ):Play()
    _G.Clip = true
    wait(Distance/Speed)
    _G.Clip = false
end

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarm or _G.TeleportIsland or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery  or  _G.MaterialFarm or _G.Autoitem or _G.AutoAdvanceDungeon or _G.AutoDoughtBoss or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFarmBossHallow or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoBounty or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.GrabChest or _G.AutoFarmBounty or _G.Holy_Torch or _G.AutoFarm or _G.Clip or FarmBoss or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.AutoFarmCandy == true then
                if not game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000,100000,100000)
                    Noclip.Velocity = Vector3.new(0,0,0)
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            if _G.AutoAdvanceDungeon or _G.AutoFarm or _G.Autoitem or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFarmBossHallow or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.NOCLIP or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoBounty or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.GrabChest or _G.AutoFarmBounty or _G.Holy_Torch or _G.AutoFarm or _G.Clip or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.AutoFarmCandy or _G.LOL  == true then
                for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false    
                    end
                end
            end
        end)
    end)
end)

spawn(function()
    while wait() do
        if _G.AutoDoughtBoss or _G.Auto_DungeonMobAura or _G.AutoFarmChest or _G.AutoFarmBossHallow or _G.AutoFarmSwanGlasses or _G.AutoLongSword or _G.AutoBlackSpikeycoat or _G.AutoElectricClaw or _G.AutoFarmGunMastery or _G.AutoHolyTorch or _G.AutoLawRaid or _G.AutoFarmBoss or _G.AutoTwinHooks or _G.AutoOpenSwanDoor or _G.AutoDragon_Trident or _G.AutoSaber or _G.NOCLIP or _G.AutoFarmFruitMastery or _G.AutoFarmGunMastery or _G.TeleportIsland or _G.Auto_EvoRace or _G.AutoFarmAllMsBypassType or _G.AutoObservationv2 or _G.AutoMusketeerHat or _G.AutoEctoplasm or _G.AutoRengoku or _G.Auto_Rainbow_Haki or _G.AutoObservation or _G.AutoDarkDagger or _G.Safe_Mode or _G.MasteryFruit or _G.AutoBudySword or _G.AutoOderSword or _G.AutoAllBoss or _G.Auto_Bounty or _G.AutoSharkman or _G.Auto_Mastery_Fruit or _G.Auto_Mastery_Gun or _G.Auto_Dungeon or _G.Auto_Cavender or _G.Auto_Pole or _G.Auto_Kill_Ply or _G.Auto_Factory or _G.AutoSecondSea or _G.TeleportPly or _G.AutoBartilo or _G.Auto_DarkBoss or _G.AutoFarm or _G.Clip or _G.AutoElitehunter or _G.AutoThirdSea or _G.Auto_Bone or _G.AutoFarmCandy == true then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken",true)
            end)
        end    
    end
end)

function StopTween(target)
    if not target then
        _G.StopTween = true
        wait()
        topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
        end
        _G.StopTween = false
        _G.Clip = false
    end
end

spawn(function()
    pcall(function()
        while wait() do
            for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do  
                if v:IsA("Tool") then
                    if v:FindFirstChild("RemoteFunctionShoot") then 
                        SelectWeaponGun = v.Name
                    end
                end
            end
        end
    end)
end)

game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

---Lib

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/WANZE0/X3Swiftz/main/GameSenseUIDRIP'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/WANZE0/X3Swiftz/main/GameSenseUiMange.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

function GetTime()
    local timeInfo = os.date("*t")
    if timeInfo.month == 1 then
       monthz = "January"
    elseif timeInfo.month == 2 then
       monthz = "February"
    elseif timeInfo.month == 3 then
       monthz = "March"
    elseif timeInfo.month == 4 then
       monthz = "April"
    elseif timeInfo.month == 5 then
       monthz = "May"
    elseif timeInfo.month == 6 then
       monthz = "June"
    elseif timeInfo.month == 7 then
       monthz = "July"
    elseif timeInfo.month == 8 then
       monthz = 'August'
    elseif timeInfo.month == 9 then
       monthz = "September"
    elseif timeInfo.month == 10 then
       monthz = "October"
    elseif timeInfo.month == 11 then
       monthz = "November"
    elseif timeInfo.month == 12 then
       monthz = "December"
    end
 end
 
 GetTime()
 
 local timeInfo = os.date("*t")
 
 Day = timeInfo.day
 
 Y = timeInfo.year
 
 _G.Title = " G A M E S E N S E | ( "..Day.." "..monthz.." "..Y.." ) "
 


 
 local Window = Library:CreateWindow({
     Title = _G.Title,
     Center = true, 
     AutoShow = true,
 })
 
 
 local Tabs = {
     Main = Window:AddTab('Main'), 
     ['Settings'] = Window:AddTab('Settings'),
 }
 
 local PlayName = game:GetService("Players").LocalPlayer.DisplayName
 
 
 function UpdateTime()
    local GameTime = math.floor(workspace.DistributedGameTime+0.5)
    local Hour = math.floor(GameTime/(60^2))%24
    local Minute = math.floor(GameTime/(60^1))%60
    local Second = math.floor(GameTime/(60^0))%60
    Library:SetWatermark(" Map Blox Fruit Update 17 | Status ( In Update ) | Hr ("..Hour..") : Min ("..Minute..") : Sec ("..Second..") ")
 end
 
 spawn(function()
    while task.wait() do
        pcall(function()
            UpdateTime()
        end)
    end
 end)


local SettingTabbox = Tabs.Main:AddLeftTabbox() 

local Setting1 = SettingTabbox:AddTab('Setting')

local Setting3 = SettingTabbox:AddTab('Visual')

local Setting2 = SettingTabbox:AddTab('Misc')

Setting3:AddButton("Open Devil Shop",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop.Visible = true
end)
Setting3:AddButton("Open Inventory",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")
    wait(1)
    game:GetService("Players").LocalPlayer.PlayerGui.Main.Inventory.Visible = true
end)

Setting3:AddButton("Open Title Name",function()
    local args = {
        [1] = "getTitles"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
end)

Setting3:AddButton("Open Color Haki",function()
    game.Players.localPlayer.PlayerGui.Main.Colors.Visible = true
end)

Setting3:AddToggle('GpEsp', {
    Text = 'Glow Player Esp',
    Default = false,
    Tooltip = 'Glow Play Esp', 
}):OnChanged(function(Value) _G.GlowEspPlayer = Toggles.GpEsp.Value end)

Setting3:AddToggle('RMED', {
    Text = 'Remove Death Effect',
    Default = false,
    Tooltip = 'Auto Equip', 
}):OnChanged(function(Value) _G.Remove_Effect2 = Toggles.RMED.Value end)

Setting3:AddToggle('RMEFF', {
    Text = 'Remove Effect',
    Default = false,
    Tooltip = 'Remove Effect', 
}):OnChanged(function(Value) _G.Remove_Effect1 = Toggles.RMEFF.Value end)


spawn(function()
    game:GetService('RunService').Stepped:Connect(function()
        if _G.Remove_Effect1 == true then
            for i, v in pairs(game.Workspace["_WorldOrigin"]:GetChildren()) do
                if v.Name == "CurvedRing" or v.Name == "SwordSlash" or v.Name == "Sounds" or v.Name == "SlashHit" or v.Name == "DamageCounter" then--or v.Name == "SlashHit"
                    v:Destroy() 
                end
            end
        end
    end)
end)

spawn(function()
    game:GetService('RunService').Stepped:Connect(function()
        if _G.Remove_Effect2 == true then
            for i, v in pairs(game:GetService("ReplicatedStorage").Effect.Container:GetChildren()) do
                if v.Name == "Death" then
                    v:Destroy() 
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.GlowEspPlayer == true then
                for i,v in pairs(game.Players:GetChildren()) do
                    local esp = Instance.new("Highlight")
                    esp.Name = "Esp"
                    esp.FillTransparency = 0.2
                    esp.FillColor = Color3.new(156, 255, 182)
                    esp.OutlineColor = Color3.new(133, 255, 165)
                    esp.OutlineTransparency = 0.2
                    esp.Parent = v.Character
                end
            end
        end
    end)
end)

Setting1:AddToggle('AutoSelect', {
    Text = 'Auto Select Weapon',
    Default = false,
    Tooltip = 'Auto Equip', 
}):OnChanged(function(Value) _G.AutoSelect = Toggles.AutoSelect.Value end)

Setting1:AddDropdown('EquipMethod', {
    Values = {'Melee' ,'Sword' , 'Fruit' },
    Default = 1,
    Multi = false,
    Text = 'Select Weapon',
    Tooltip = 'Equip Method',
}):OnChanged(function(Value) _G.WeaponMethod = Options.EquipMethod.Value end)

Weapon = {}

for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
    if v:IsA("Tool") then
        table.insert(Weapon ,v.Name)
    end
end

for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do  
    if v:IsA("Tool") then
        table.insert(Weapon, v.Name)
    end
end



spawn(function()
    while wait(0.1) do
        if _G.AutoSelect == true and _G.WeaponMethod == 'Melee' then
            pcall(function()
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Electro") or game.Players.LocalPlayer.Character:FindFirstChild("Electro") then
                    _G.SelectWeapon = "Electro"
                    SelectToolWeaponOld = "Electro"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Black Leg") or game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") then
                    _G.SelectWeapon = "Black Leg"
                    SelectToolWeaponOld = "Black Leg"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Fishman Karate") or game.Players.LocalPlayer.Character:FindFirstChild("Fishman Karate") then
                    _G.SelectWeapon = "Fishman Karate"
                    SelectToolWeaponOld = "Fishman Karate"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Claw") or game.Players.LocalPlayer.Character:FindFirstChild("Dragon Claw") then
                    _G.SelectWeapon = "Dragon Claw"
                    SelectToolWeaponOld = "Dragon Claw"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Superhuman") or game.Players.LocalPlayer.Backpack:FindFirstChild("Superhuman") then
                    _G.SelectWeapon = "Superhuman"
                    SelectToolWeaponOld = "Superhuman"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Electric Claw") or game.Players.LocalPlayer.Backpack:FindFirstChild("Electric Claw") then
                    _G.SelectWeapon = "Electric Claw"
                    SelectToolWeaponOld = "Electric Claw"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Dragon Talon") or game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Talon") then
                    _G.SelectWeapon = "Dragon Talon"
                    SelectToolWeaponOld = "Dragon Talon"    
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Sharkman Karate") or game.Players.LocalPlayer.Backpack:FindFirstChild("Sharkman Karate") then
                    _G.SelectWeapon = "Sharkman Karate"
                    SelectToolWeaponOld = "Sharkman Karate"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Death Step") or game.Players.LocalPlayer.Backpack:FindFirstChild("Death Step") then
                    _G.SelectWeapon = "Death Step"
                    SelectToolWeaponOld = "Death Step"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Combat") or game.Players.LocalPlayer.Character:FindFirstChild("Combat") then
                    _G.SelectWeapon = "Combat"
                    SelectToolWeaponOld = "Combat"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Godhuman") or game.Players.LocalPlayer.Character:FindFirstChild("Godhuman") then
                    _G.SelectWeapon = "Godhuman"
                    SelectToolWeaponOld = "Godhuman"
                end
                slect:Refresh_SelectedText(_G.SelectToolWeapon)
                wait(3)
            end)
        end
    end
end)
spawn(function()
    while wait(0.1) do
        if _G.AutoSelect == true and _G.WeaponMethod == 'Sword'  then
            pcall(function()
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Tushita")  then
                    _G.SelectWeapon = "Tushita"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Hallow Scythe")  then
                    _G.SelectWeapon = "Hallow Scythe"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Buddy Sword")then
                    _G.SelectWeapon = "Buddy Sword"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Bisento")  then
                    _G.SelectWeapon = "Bisento"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Pole (1st Form)") then
                    _G.SelectWeapon = "Pole (1st Form)"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Rengoku")  then
                    _G.SelectWeapon = "Rengoku"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Saber")  then
                    _G.SelectWeapon = "Saber"  
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Saddi")  then
                    _G.SelectWeapon = "Saddi"
                elseif game.Players.LocalPlayer.Character:FindFirstChild("Spikey Trident")  then
                    _G.SelectWeapon = "Spikey Trident"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Wando") then
                    _G.SelectWeapon = "Wando"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Yama")then
                    _G.SelectWeapon = "Yama"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Dragon Trident")then
                    _G.SelectWeapon = "Dragon Trident"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Longsword")then
                    _G.SelectWeapon = "Longsword"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Soul Cane")then
                    _G.SelectWeapon = "Soul Cane"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Wardens Sword")then
                    _G.SelectWeapon = "Wardens Sword"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Pipe")then
                    _G.SelectWeapon = "Pipe"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Iron Mace")then
                    _G.SelectWeapon = "Iron Mace "
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Shark Saw")then
                    _G.SelectWeapon = "Shark Saw"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Triple Katana")then
                    _G.SelectWeapon = "Triple Katana"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Dual Katana")then
                    _G.SelectWeapon = "Dual Katana"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Cutlass")then
                    _G.SelectWeapon = "Cutlass"
                elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Dark Dagger")then
                    _G.SelectWeapon = "Dark Dagger"
                end
                slect:Refresh_SelectedText(_G.SelectWeapon)
                wait(3)
            end)
        end
    end
end)

Setting1:AddToggle('Black', {
    Text = 'Black Screen',
    Default = false, 
    Tooltip = 'Black Screen', 
}):OnChanged(function(Value) _G.BackScreen = Toggles.Black.Value end)
Setting1:AddToggle('WhiteS', {
    Text = 'CPU Reduce Screen',
    Default = false,
    Tooltip = 'CPU Reduce', 
}):OnChanged(function(Value) _G.WhiteScreen = Toggles.WhiteS.Value end)
Setting1:AddToggle('DeleteNoti', {
    Text = 'Disable Notify',
    Default = false,
    Tooltip = 'Disable Game Notify',
}):OnChanged(function(Value) _G.Delnoti = Toggles.DeleteNoti.Value end)
Setting1:AddToggle('FastAttackV', {
    Text = 'Fast Attack',
    Default = true, 
    Tooltip = 'Fast Attack SAFE!', 
}):OnChanged(function(Value) _G.FastAttack = Toggles.FastAttackV.Value end)
Setting1:AddDropdown('FastSpeed', {
    Values = {'Normal (Recommend)' ,'Fast' , 'Instant'},
    Default = 3, 
    Multi = false, 
    Text = 'Fast Attack Speed',
    Tooltip = 'Select Speed', 
}):OnChanged(function(Value) _G.FastSpe = Options.FastSpeed.Value end)
Setting1:AddToggle('Bringmonter', {
    Text = 'Bring Mob',
    Default = true,
    Tooltip = 'Bring Mob SAFE!',
}):OnChanged(function(Value) _G.BringMonster = Toggles.Bringmonter.Value end)

Setting1:AddDropdown('BringType', {
    Values = {'Normal' ,'Manual' },
    Default = 1, 
    Multi = false, 
    Text = 'Bring Mob Type',
    Tooltip = 'Bring Type', 
}):OnChanged(function(Value) _G.BringMethod = Options.BringType.Value end)

spawn(function()
    while task.wait() do
        pcall(function()
            if _G.BringMonster == true and _G.BringMethod == 'Manual' then
                CheckQuest()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if _G.AutoFarm == true  and StartMagnet and v.Name == Mon and (Mon == "Factory Staff [Lv. 800]" or Mon == "Monkey [Lv. 14]" or Mon == "Dragon Crew Warrior [Lv. 1575]" or Mon == "Dragon Crew Archer [Lv. 1600]") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 220 then
                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                    elseif _G.AutoFarm == true and _G.SelectMethod == 'Level' and StartMagnet == true and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 275 then
                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false 
                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                    end
                    if _G.AutoEctoplasm and StartEctoplasmMagnet then
                        if string.find(v.Name, "Ship") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - EctoplasmMon.Position).Magnitude <= 250 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.CFrame = EctoplasmMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoRengoku and StartRengokuMagnet then
                        if (v.Name == "Snow Lurker [Lv. 1375]" or v.Name == "Arctic Warrior [Lv. 1350]") and (v.HumanoidRootPart.Position - RengokuMon.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = RengokuMon
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoMusketeerHat and StartMagnetMusketeerhat then
                        if v.Name == "Forest Pirate [Lv. 1825]" and (v.HumanoidRootPart.Position - MusketeerHatMon.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = MusketeerHatMon
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.Auto_EvoRace and StartEvoMagnet then
                        if v.Name == "Zombie [Lv. 950]" and (v.HumanoidRootPart.Position - PosMonEvo.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonEvo
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoBartilo and AutoBartiloBring then
                        if v.Name == "Swan Pirate [Lv. 775]" and (v.HumanoidRootPart.Position - PosMonBarto.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonBarto
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarmFruitMastery and StartMasteryFruitMagnet then
                        if v.Name == "Monkey [Lv. 14]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == "Factory Staff [Lv. 800]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == Mon then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                    if _G.AutoFarmGunMastery and StartMasteryGunMagnet then
                        if v.Name == "Monkey [Lv. 14]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == "Factory Staff [Lv. 800]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == Mon then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Bone'  and StartMagnetBoneMon then
                        if (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]") and (v.HumanoidRootPart.Position - PosMonBone.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonBone
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AMD and StartMagnetMys then
                        if (v.Name == "Sea Soldier [Lv. 1425]" or v.Name == "Water Fighter [Lv. 1450]") and (v.HumanoidRootPart.Position - PosMys.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMys
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.ADS and StartMagDS then
                        if (v.Name == "Dragon Crew Warrior [Lv. 1575]" or v.Name == "Dragon Crew Archer [Lv. 1600]") and (v.HumanoidRootPart.Position - PosDragon.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosDragon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AFMT and MagnetFish then
                        if (v.Name == "Fishman Warrior [Lv. 375]" or v.Name == "Fishman Commando [Lv. 400]") and (v.HumanoidRootPart.Position - PosFishMan.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosFishMan
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.MaterialFarm == true and _G.MaterialSelect == 'Magma Ore' and MagnetMagma == true then
                        if (v.Name == "Military Soldier [Lv. 300]" or v.Name == "Military Spy [Lv. 325]") and (v.HumanoidRootPart.Position - PosMagma.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMagma
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    
                    if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and _G.AutoFarmMethod == 'Top'and StartMagnetAC == true then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosAC.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosAC
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end

                    if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and MagnetDought == true  then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosMonDoughtOpenDoor.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonDoughtOpenDoor
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Island' and StartMagnetMoney then
                        if (v.Name == "Cocoa Warrior [Lv. 2300]" or v.Name == "Chocolate Bar Battler [Lv. 2325]" or v.Name == "Sweet Thief [Lv. 2350]" or v.Name == "Candy Rebel [Lv. 2375]")  and (v.HumanoidRootPart.Position - PosMonMoney.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonMoney
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoCandy and StartMagnetCandy then
                        if (v.HumanoidRootPart.Position - PosMonCandy.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonCandy
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and MagnetDought then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosMonDoughtOpenDoor.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonDoughtOpenDoor
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Skip Farm 1-300' and StartMobMagnetSkip15 == true  then
                        if (v.Name == "Desert Officer [Lv. 70]") and (v.HumanoidRootPart.Position - PosSk15.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosSk15
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Skip Farm 1-300' and StartMobMagnetSkip100 == true then
                        if (v.Name == "God's Guard [Lv. 450]" or v.Name == 'Shanda [Lv. 475]') and (v.HumanoidRootPart.Position - PosSk100.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosSk100
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    end
                end
            end
        end)
    end
end)

spawn(function()
    while task.wait() do
        pcall(function()
            if _G.BringMonster == true and _G.BringMethod == 'Normal' then
                CheckQuest()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if _G.AutoFarm == true  and StartMagnet and v.Name == Mon and (Mon == "Factory Staff [Lv. 800]" or Mon == "Monkey [Lv. 14]" or Mon == "Dragon Crew Warrior [Lv. 1575]" or Mon == "Dragon Crew Archer [Lv. 1600]") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 220 then
                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                    elseif _G.AutoFarm == true and _G.SelectMethod == 'Level' and StartMagnet == true and v.Name == Mon and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 275 then
                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                        v.HumanoidRootPart.CFrame = PosMon
                        v.Humanoid:ChangeState(14)
                        v.HumanoidRootPart.CanCollide = false
                        v.Head.CanCollide = false
                        if v.Humanoid:FindFirstChild("Animator") then
                            v.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                    end
                    if _G.AutoEctoplasm and StartEctoplasmMagnet then
                        if string.find(v.Name, "Ship") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - EctoplasmMon.Position).Magnitude <= 250 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.CFrame = EctoplasmMon
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoRengoku and StartRengokuMagnet then
                        if (v.Name == "Snow Lurker [Lv. 1375]" or v.Name == "Arctic Warrior [Lv. 1350]") and (v.HumanoidRootPart.Position - RengokuMon.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = RengokuMon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoMusketeerHat and StartMagnetMusketeerhat then
                        if v.Name == "Forest Pirate [Lv. 1825]" and (v.HumanoidRootPart.Position - MusketeerHatMon.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = MusketeerHatMon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.Auto_EvoRace and StartEvoMagnet then
                        if v.Name == "Zombie [Lv. 950]" and (v.HumanoidRootPart.Position - PosMonEvo.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonEvo
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoBartilo and AutoBartiloBring then
                        if v.Name == "Swan Pirate [Lv. 775]" and (v.HumanoidRootPart.Position - PosMonBarto.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonBarto
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarmFruitMastery and StartMasteryFruitMagnet then
                        if v.Name == "Monkey [Lv. 14]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == "Factory Staff [Lv. 800]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == Mon then
                            if (v.HumanoidRootPart.Position - PosMonMasteryFruit.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryFruit
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                    if _G.AutoFarmGunMastery and StartMasteryGunMagnet then
                        if v.Name == "Monkey [Lv. 14]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == "Factory Staff [Lv. 800]" then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == Mon then
                            if (v.HumanoidRootPart.Position - PosMonMasteryGun.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                v.Humanoid:ChangeState(14)
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CFrame = PosMonMasteryGun
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Bone'  and StartMagnetBoneMon then
                        if (v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]") and (v.HumanoidRootPart.Position - PosMonBone.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonBone
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AMD and StartMagnetMys then
                        if (v.Name == "Sea Soldier [Lv. 1425]" or v.Name == "Water Fighter [Lv. 1450]") and (v.HumanoidRootPart.Position - PosMys.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMys
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.ADS and StartMagDS then
                        if (v.Name == "Dragon Crew Warrior [Lv. 1575]" or v.Name == "Dragon Crew Archer [Lv. 1600]") and (v.HumanoidRootPart.Position - PosDragon.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosDragon
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AFMT and MagnetFish then
                        if (v.Name == "Fishman Warrior [Lv. 375]" or v.Name == "Fishman Commando [Lv. 400]") and (v.HumanoidRootPart.Position - PosFishMan.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosFishMan
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.MaterialFarm == true and _G.MaterialSelect == 'Magma Ore' and MagnetMagma == true then
                        if (v.Name == "Military Soldier [Lv. 300]" or v.Name == "Military Spy [Lv. 325]") and (v.HumanoidRootPart.Position - PosMagma.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMagma
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    
                    if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and _G.AutoFarmMethod == 'Top'and StartMagnetAC == true then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosAC.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosAC
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end

                    if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and MagnetDought == true  then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosMonDoughtOpenDoor.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonDoughtOpenDoor
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Island' and StartMagnetMoney then
                        if (v.Name == "Cocoa Warrior [Lv. 2300]" or v.Name == "Chocolate Bar Battler [Lv. 2325]" or v.Name == "Sweet Thief [Lv. 2350]" or v.Name == "Candy Rebel [Lv. 2375]")  and (v.HumanoidRootPart.Position - PosMonMoney.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonMoney
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoCandy and StartMagnetCandy then
                        if (v.HumanoidRootPart.Position - PosMonCandy.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonCandy
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and MagnetDought then
                        if (v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]") and (v.HumanoidRootPart.Position - PosMonDoughtOpenDoor.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosMonDoughtOpenDoor
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Skip Farm 1-300' and StartMobMagnetSkip15 == true  then
                        if (v.Name == "Desert Officer [Lv. 70]") and (v.HumanoidRootPart.Position - PosSk15.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosSk15
                            v.Humanoid.WalkSpeed = 0
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    if _G.AutoFarm == true and _G.SelectMethod == 'Skip Farm 1-300' and StartMobMagnetSkip100 == true then
                        if (v.Name == 'Shanda [Lv. 475]') and (v.HumanoidRootPart.Position - PosSk100.Position).Magnitude <= 250 and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.Humanoid:ChangeState(14)
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.CFrame = PosSk100
                            v.Humanoid.WalkSpeed = 0
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                    end
                end
            end
        end)
    end
end)


local plr = game.Players.LocalPlayer

local RigLib = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
spawn(function()
    local old = RigLib.wrapAttackAnimationAsync
    RigLib.wrapAttackAnimationAsync = function(...)
        args = {...}
        local Hits =  RigLib.getBladeHits(args[2], args[3], args[4])
        if Hits then
            args[5](Hits)
        end
        return old(unpack(args))
    end
end)
    
local plr = game.Players.LocalPlayer

local RigLib = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
spawn(function()
    local old = RigLib.wrapAttackAnimationAsync
    RigLib.wrapAttackAnimationAsync = function(...)
        args = {...}
        local Hits =  RigLib.getBladeHits(args[2], args[3], args[4])
        if Hits then
            args[5](Hits)
        end
        return old(unpack(args))
    end
end)
    
local CbFw = debug.getupvalues(require(plr.PlayerScripts.CombatFramework))
local CbFw2 = CbFw[2]

function GetCurrentBlade() 
    local p13 = CbFw2.activeController
    local ret = p13.blades[1]
    if not ret then return end
    while ret.Parent~=game.Players.LocalPlayer.Character do ret=ret.Parent end
    return ret
end
function AttackNoCD() 
    local AC = CbFw2.activeController
    --for i = 1, 1 do 
        local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
            plr.Character,
            {plr.Character.HumanoidRootPart},
            60
        )
        local cac = {}
        local hash = {}
        for k, v in pairs(bladehit) do
            if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
                table.insert(cac, v.Parent.HumanoidRootPart)
                hash[v.Parent] = true
            end
        end
        bladehit = cac
        if #bladehit > 0 then
            local u8 = debug.getupvalue(AC.attack, 5)
            local u9 = debug.getupvalue(AC.attack, 6)
            local u7 = debug.getupvalue(AC.attack, 4)
            local u10 = debug.getupvalue(AC.attack, 7)
            local u12 = (u8 * 798405 + u7 * 727595) % u9
            local u13 = u7 * 798405
            (function()
                u12 = (u12 * u9 + u13) % 1099511627776
                u8 = math.floor(u12 / u9)
                u7 = u12 - u8 * u9
            end)()
            u10 = u10 + 1
            debug.setupvalue(AC.attack, 5, u8)
            debug.setupvalue(AC.attack, 6, u9)
            debug.setupvalue(AC.attack, 4, u7)
            debug.setupvalue(AC.attack, 7, u10)
            if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then 
                --[[pcall(function()
                    for k, v in pairs(AC.animator.anims.basic) do
                        v:Play()
                    end
                end)]]  
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetCurrentBlade()))
                game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 1, "") 
            end
        end
    --end
end

function Attack2()
    local AC = CbFw2.activeController
    local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
        plr.Character,
        {plr.Character.HumanoidRootPart},
        60
    )
    local cac = {}
    local hash = {}
    for k, v in pairs(bladehit) do
        if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
            table.insert(cac, v.Parent.HumanoidRootPart)
            hash[v.Parent] = true
        end
    end
    bladehit = cac
    if #bladehit > 0 then
        CbFw2.activeController:attack()
    end
end
require(game:GetService("ReplicatedStorage").Util.CameraShaker):Stop()
spawn(function()
	game:GetService("RunService").Stepped:Connect(function()
		pcall(function()
            CbFw2.activeController.hitboxMagnitude = 200
            CbFw2.activeController.increment = #CbFw2.activeController.anims.basic - 1
            game:GetService("Players").LocalPlayer.Character.Stun.Value = 0
		end)
	end)
end)
spawn(function()
	game:GetService("RunService").Stepped:Connect(function()
        if _G.FastAttack == true and _G.FastSpe == 'Instant' then
            pcall(function()
                Attack2()
            end)
        end
	end)
end)

spawn(function()
    while task.wait() do 
        pcall(function()
            AttackNoCD()
            task.wait(0.165)
        end)
    end
end)





spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.FastAttack == true and _G.FastSpe == 'Normal (Recommend)' then
            require(game:GetService("ReplicatedStorage").Util.CameraShaker):Stop()
            local CombatFramework = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
            if not game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") then
            CombatFramework.activeController.timeToNextAttack =  0
            CombatFramework.activeController.timeToNextBlock =  3
            end
            CombatFramework.activeController.timeToNextAttack =  0
            CombatFramework.activeController.timeToNextBlock =  0
            CombatFramework.activeController.increment = 2
            CombatFramework.activeController.attacking = false
            CombatFramework.activeController.blocking = false
            CombatFramework.activeController.humanoid.AutoRotate = true
            CombatFramework.activeController.hitboxMagnitude = 350
            game.Players.LocalPlayer.Character.Stun.Value = 0
            require(game.ReplicatedStorage.Util.CameraShaker):Stop()
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius",  math.huge)
        end
    end)
end)
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.FastAttack == true and _G.FastSpe == 'Fast' then
            require(game:GetService("ReplicatedStorage").Util.CameraShaker):Stop()
            local CombatFramework = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
            if not game.Players.LocalPlayer.Character:FindFirstChild("Black Leg") then
            CombatFramework.activeController.timeToNextAttack =  3
            CombatFramework.activeController.timeToNextBlock =  3
            end
            CombatFramework.activeController.timeToNextAttack =  -(math.huge^math.huge)
            CombatFramework.activeController.timeToNextBlock =  0
            CombatFramework.activeController.increment = 3
            CombatFramework.activeController.attacking = false
            CombatFramework.activeController.blocking = false
            CombatFramework.activeController.humanoid.AutoRotate = true
            CombatFramework.activeController.hitboxMagnitude = 350
            game.Players.LocalPlayer.Character.Stun.Value = 0
            require(game.ReplicatedStorage.Util.CameraShaker):Stop()
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius",  math.huge)
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.WhiteScreen == true then
                game:GetService("RunService"):Set3dRenderingEnabled(false)
            elseif _G.WhiteScreen == false then
                game:GetService("RunService"):Set3dRenderingEnabled(true)
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.BackScreen == true then
                game:GetService("Lighting").ColorCorrection.Enabled = true
                game:GetService("Lighting").ColorCorrection.TintColor = Color3.fromRGB(0, 0, 0)
            elseif _G.BackScreen  == false then 
                game:GetService("Lighting").ColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.Delnoti == true then
                game:GetService("Players")["LocalPlayer"].PlayerGui.Notifications.Enabled = false
            elseif _G.Delnoti == false then
                game:GetService("Players")["LocalPlayer"].PlayerGui.Notifications.Enabled = true
            end
        end
    end)
end)
Setting2:AddToggle('spawn', {
    Text = 'Auto SetSpawn Point',
    Default = false, 
    Tooltip = 'Auto SetSpawn Point',
}):OnChanged(function(Value) _G.Setspawn = Toggles.spawn.Value end)



Setting2:AddToggle('InfAb', {
    Text = 'Infinity Ability',
    Default = true, 
    Tooltip = 'Inf Ab', 
}):OnChanged(function(Value) _G.Inf = Toggles.InfAb.Value end)

Setting2:AddDropdown('SelectTeam', {
    Values = {'Pirate' ,'Marines' },
    Default = nil, 
    Multi = false, 
    Text = 'Team Select',
    Tooltip = 'Team Select', 
}):OnChanged(function(Value) _G.TeamSelct = Options.SelectTeam.Value end)


Setting2:AddButton('Join Team', function()
    if _G.TeamSelct == 'Pirate' then --1
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Pirates") 
    elseif _G.SelectBuymelee == 'Marines' then --2
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Marines") 
    end
end)

Setting2:AddButton('Rejoin', function()
     game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

Setting2:AddButton("Server Hop",function()
    Hop()
end)

Setting2:AddButton("Hop To Lower Player",function()
    getgenv().AutoTeleport = true
    getgenv().DontTeleportTheSameNumber = true 
    getgenv().CopytoClipboard = false
    if not game:IsLoaded() then
        print("Game is loading waiting...")
    end
    local maxplayers = math.huge
    local serversmaxplayer;
    local goodserver;
    local gamelink = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" 
    function serversearch()
        for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink)).data) do
            if type(v) == "table" and v.playing ~= nil and maxplayers > v.playing then
                serversmaxplayer = v.maxPlayers
                maxplayers = v.playing
                goodserver = v.id
            end
        end       
    end
    function getservers()
        serversearch()
        for i,v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync(gamelink))) do
            if i == "nextPageCursor" then
                if gamelink:find("&cursor=") then
                    local a = gamelink:find("&cursor=")
                    local b = gamelink:sub(a)
                    gamelink = gamelink:gsub(b, "")
                end
                gamelink = gamelink .. "&cursor=" ..v
                getservers()
            end
        end
    end 
    getservers()
    if AutoTeleport then
        if DontTeleportTheSameNumber then 
            if #game:GetService("Players"):GetPlayers() - 4  == maxplayers then
                return warn("It has same number of players (except you)")
            elseif goodserver == game.JobId then
                return warn("Your current server is the most empty server atm") 
            end
        end
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, goodserver)
    end
end)

spawn(function()
    pcall(function()    
        while wait() do
            if _G.Inf == true then
                if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") or not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Water Body") or not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Heavenly Blood") or not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Energy Core") or not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Heightened Senses") or not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Last Resort") or not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("IndraRage2")  then
                    local Agility = game:GetService("ReplicatedStorage").FX["Agility"]:Clone()
                    local Water_Body = game:GetService("ReplicatedStorage").FX["Water Body"]:Clone()
                    local Heavenly_Blood = game:GetService("ReplicatedStorage").FX["Heavenly Blood"]:Clone()
                    local Energy_Core = game:GetService("ReplicatedStorage").FX["Energy Core"]:Clone()
                    local Heightened_Senses = game:GetService("ReplicatedStorage").FX["Heightened Senses"]:Clone()
                    local Last_Resort = game:GetService("ReplicatedStorage").FX["Last Resort"]:Clone()
                    Agility.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Water_Body.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Heavenly_Blood.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Energy_Core.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Heightened_Senses.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
                    Last_Resort.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart 
                end          
            end  
        end
    end)
end)



spawn(function()
    while wait() do
	   if _G.Inf == false then
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then 
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility"):Destroy()
        end
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Water Body") then 
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Water Body"):Destroy()
        end
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Heavenly Blood") then 
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Heavenly Blood"):Destroy()
        end
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Energy Core") then 
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Energy Core"):Destroy()
        end
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Heightened Senses") then 
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Heightened Senses"):Destroy()
        end
        if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Last Resort") then
            game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Last Resort"):Destroy()
        end
	   end
    end
end)
spawn(function()
	while wait(5) do
	   if _G.Setspawn then
		  pcall(function()
		  local args = {
		  [1] = "SetSpawnPoint"
		  }
		 game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
	   end)
	 end
   end
 end)

 Setting2:AddSlider('FOVCha', {
    Text = 'Field Of View',
    Default = 120,
    Min = 15,
    Max = 120,
    Rounding = 0,
    Compact = false, -- If set to true, then it will hide the label
}):OnChanged(function(Value) _G.Fov = Options.FOVCha.Value end)

spawn(function()
    while task.wait() do
    game:GetService("Workspace").Camera.FieldOfView = _G.Fov
    end
end)

 local AutoFramTabbox = Tabs.Main:AddRightTabbox() 

 local Farm1 = AutoFramTabbox:AddTab('General')

 local Farm2 = AutoFramTabbox:AddTab('Event')

 local Farm3 = AutoFramTabbox:AddTab('Item')

 Farm1:AddToggle('AutoFarm', {
    Text = 'Auto Farm',
    Default = false,
    Tooltip = 'Auto Farm', 
}):OnChanged(function(Value) _G.AutoFarm = Toggles.AutoFarm.Value end)

Farm1:AddDropdown('Method', {
    Values = { 'Level' , 'Bone' ,'Dought Boss' , 'Seabeast' , 'Observation Haki'},
    Default = nil, 
    Multi = false, 
    Text = 'Farm Method',
    Tooltip = 'Select Farm Type', 
}):OnChanged(function(Value) _G.SelectMethod = Options.Method.Value end)
Farm1:AddDropdown('FarmMethod', {
    Values = {'Top' ,'Under' , 'Behide', 'Bypass TP' , 'GrandMaster' },
    Default = 1, 
    Multi = false, 
    Text = 'Auto Farm Method',
    Tooltip = 'Select Farm Method', 
}):OnChanged(function(Value) _G.AutoFarmMethod = Options.FarmMethod.Value end)




spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Seabeast' and _G.AutoFarmMethod == 'Top' and _G.BringMethod == 'Normal' then
            for i,v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") then
                    TP1(v.HumanoidRootPart.CFrame*CFrame.new(0,100,0))
                end
            end
        end
    end
end)

spawn(function()
    pcall(function() 
        while wait() do
            if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'GrandMaster' then
                CheckQuest()
                TelePBoss(CFrameQuest)
            end
        end
    end)
end)

spawn(function()
while wait() do 
if _G.AutoFarm == true and _G.SelectMethod == 'Level' then
for i , v in pairs(game.Players:GetChildren()) do
    if not v.Character:FindFirstChild("glowObject") then
    local glow = Instance.new("Highlight")
    glow.Name = "glowObject";
    glow.FillColor = Color3.new(0, 0, 0)
    glow.FillTransparency = 1
    glow.OutlineColor = Color3.new(255, 221, 0)
    glow.OutlineTransparency = 0.1
    glow.Parent = v.Character
    end
end
end
end
end)


spawn(function()
while wait() do 
    pcall(function()
    if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'GrandMaster' and _G.BringMethod == 'Normal' then
        for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do 
            local Level = game:GetService("Players").LocalPlayer.Data.Level.Value
            v.Head.CFrame = (game.Players.LocalPlayer.Character.Head.CFrame * CFrame.new(0,4,0))
            v.Head.Transparency = 1
            v.Head.QuestBBG.Enabled = false
            v.Head.face.Transparency = 1
            v.Head.Talk.TextLabel.Text = "Lv. "..Level..""
        end 
    end
    end)
end
end)

spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'GrandMaster' and _G.BringMethod == 'Normal' then
        local decalsyeeted = true
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain


settings().Rendering.QualityLevel = "Level01"
t.WaterTransparency = 1
for i, e in pairs(l:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
        e.Enabled = false
    end
end
for i,v in pairs(game:GetService("Workspace").Map.Windmill:GetDescendants()) do
    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
    v.Transparency = 0.95
    elseif v:IsA("MeshPart") then
    v.Transparency = 0.95
    elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
    v.Transparency = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
    v.Enabled = false   
    end
end
end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'GrandMaster' and _G.BringMethod == 'Normal' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    TP1(CFrameQuest)
                    wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                    StartMagnet = false
                    CheckQuest()    
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,5,5))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'GrandMaster' and _G.BringMethod == 'Normal' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    TP1(CFrameQuest)
                    wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                    StartMagnet = false
                    CheckQuest()    
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,-15,5))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Top' and _G.BringMethod == 'Normal' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()    
                 repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,20,5))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Behide' and _G.BringMethod == 'Normal' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()
                    repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(25,0,15))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Under' and _G.BringMethod == 'Normal' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()
                    repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(1,-25,5))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)



spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Bypass TP' and _G.BringMethod == 'Normal' then
            pcall(function()
                CheckQuest()
                TelePBoss(CFrameQuest)
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()    
                    TelePBoss(CFrameQuest) 
                 repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TPExpoNential(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TPExpoNential(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,35,5))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)




















spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Top' and _G.BringMethod == 'Manual' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()
                    TelePBoss(CFrameQuest)
                    repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,35,5))
                                            v.HumanoidRootPart.CanCollide = true
                                            v.Humanoid.WalkSpeed = 10
                                            v.Head.CanCollide = true
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true            
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Behide' and _G.BringMethod == 'Manual' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()
                    TelePBoss(CFrameQuest)
                    repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(25,0,15))
                                            v.HumanoidRootPart.CanCollide = true
                                            v.Humanoid.WalkSpeed = 10
                                            v.Head.CanCollide = true
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoFarm == true and _G.SelectMethod == 'Level' and _G.AutoFarmMethod == 'Under' and _G.BringMethod == 'Manual' then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    StartMagnet = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMagnet = false
                    CheckQuest()
                    repeat wait() TP1(CFrameQuest) until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarm
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(0.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    TP1(CFrameMon)
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        TP1(CFrameMon)
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            TelePBoss(CFrameQuest)
                                            local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                            CbFw.activeController.hitboxMagnitude = 400
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()                                            
                                            PosMon = v.HumanoidRootPart.CFrame
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(1,-25,5))
                                            v.HumanoidRootPart.CanCollide = true
                                            v.Humanoid.WalkSpeed = 10
                                            v.Head.CanCollide = true
                                            v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                            StartMagnet = true
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMagnet = false
                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(15,10,2))
                        else
                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                if PosMon ~= nil then
                                    TP1(PosMon * CFrame.new(2,10,15))
                                else
                                    if OldPos ~= nil then
                                        TP1(OldPos.Position)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarm == true then
                require(game.ReplicatedStorage.Util.CameraShaker):Stop()  
            end
        end
    end)
end)
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.AutoFarm == true or  _G.TeleportIsland == true or _G.AutoFarmIsland == true or _G.Autoitem == true or _G.MaterialFarm == true or _G.Auto_Dungeon == true or _G.AutoFarmFruitMastery  == true then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    if not game:GetService("Workspace"):FindFirstChild("LOL") then
                        local LOL = Instance.new("Part")
                        LOL.Name = "LOL"
                        LOL.Parent = game.Workspace
                        LOL.Anchored = true
                        LOL.Transparency = 1
                        LOL.Size = Vector3.new(20,0.5,20)
                    elseif game:GetService("Workspace"):FindFirstChild("LOL") then
                        game.Workspace["LOL"].CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y - 3.9,game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
                    end
                end
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                    v.CanCollide = false
                end
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarm == false then
                StopTween(_G.AutoFarm)  
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.Autoitem == false then
                StopTween(_G.Autoitem)  
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.MaterialFarm == false then
                StopTween(_G.MaterialFarm)  
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.Auto_Dungeon == false then
                StopTween(_G.Auto_Dungeon)  
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmFruitMastery == false then
                StopTween(_G.AutoFarmFruitMastery)  
            end
        end
    end)
end)



spawn(function()
    pcall(function()
        if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' then
            TP1(CFrame.new(-2017.54053, 177.013931, -12838.248, 0.0832364559, -4.61832883e-08, 0.996529818, -7.41030135e-08, 1, 5.2533661e-08, -0.996529818, -7.82185765e-08, 0.0832364559))           
        end
    end)
end)

spawn(function()
    while wait() do
        pcall(function()
            if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 88 then
                KillMob = (tonumber(string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,41)) - 500)
            elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 87 then
                KillMob = (tonumber(string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),40,41)) - 500)
            elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 86 then
                KillMob = (tonumber(string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),41,41)) - 500)
            end
        end)
    end
end)

spawn(function()
    while wait() do 
        if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and _G.AutoFarmMethod == 'Top' then
            TelePBoss(CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931))
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner",true)
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]"  then
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                TelePBoss(CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931))
                                local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                CbFw.activeController.hitboxMagnitude = 400
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false 
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                StartMagnetAC = true
                                PosAC = v.HumanoidRootPart.CFrame
                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(5,40,7))
                            until not  _G.AutoFarm == true or _G.SelectMethod ~= 'Dought Boss' or not v.Parent or v.Humanoid.Health <= 0
                        end
                    elseif game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cake Prince [Lv. 2300] [Raid Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,5))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoDoughtBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end   
                    end
                end
            end)
        end
    end
end)
spawn(function()--Dought
    while wait() do 
        if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and _G.AutoFarmMethod == 'Behide' then
            TelePBoss(CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931))
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner",true)
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]"  then
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                TelePBoss(CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931))
                                local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                CbFw.activeController.hitboxMagnitude = 400
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false 
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                StartMagnetAC = true
                                PosAC = v.HumanoidRootPart.CFrame
                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(5,40,7))
                            until not  _G.AutoFarm == true or _G.SelectMethod ~= 'Dought Boss' or not v.Parent or v.Humanoid.Health <= 0
                        end
                    elseif game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cake Prince [Lv. 2300] [Raid Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,5))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoDoughtBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end   
                    end
                end
            end)
        end
    end
end)
spawn(function()--Dought
    while wait() do 
        if _G.AutoFarm == true and _G.SelectMethod == 'Dought Boss' and _G.AutoFarmMethod == 'Under' then
            TelePBoss(CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931))
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner",true)
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Cookie Crafter [Lv. 2200]" or v.Name == "Cake Guard [Lv. 2225]" or v.Name == "Baking Staff [Lv. 2250]" or v.Name == "Head Baker [Lv. 2275]"  then
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                TelePBoss(CFrame.new(-2021.32007, 37.7982254, -12028.7295, 0.957576931, -8.80302053e-08, 0.288177818, 6.9301187e-08, 1, 7.51931211e-08, -0.288177818, -5.2032135e-08, 0.957576931))
                                local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                CbFw.activeController.hitboxMagnitude = 400
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false 
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                StartMagnetAC = true
                                PosAC = v.HumanoidRootPart.CFrame
                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(5,40,7))
                            until not  _G.AutoFarm == true or _G.SelectMethod ~= 'Dought Boss' or not v.Parent or v.Humanoid.Health <= 0
                        end
                    elseif game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cake Prince [Lv. 2300] [Raid Boss]" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,5))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoDoughtBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end   
                    end
                end
            end)
        end
    end
end)


spawn(function()
    while wait() do 
        if _G.AutoFarm == true and _G.SelectMethod == 'Bone' and _G.AutoFarmMethod == 'Top' then
            TelePBoss(CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0))
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]"  then
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                CbFw.activeController.hitboxMagnitude = 400
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false 
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                StartMagnetBoneMon = true
                                PosMonBone = v.HumanoidRootPart.CFrame
                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(5,40,7))
                            until not  _G.AutoFarm == true or _G.SelectMethod ~= 'Bone' or not v.Parent or v.Humanoid.Health <= 0
                        end    
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do 
        if _G.AutoFarm == true and _G.SelectMethod == 'Bone' and _G.AutoFarmMethod == 'Under' then
            TelePBoss(CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0))
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]"  then
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                CbFw.activeController.hitboxMagnitude = 400
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false 
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                StartMagnetBoneMon = true
                                PosMonBone = v.HumanoidRootPart.CFrame
                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(1,-25,5))
                            until not  _G.AutoFarm == true or _G.SelectMethod ~= 'Bone' or not v.Parent or v.Humanoid.Health <= 0
                        end    
                    end
                end
            end)
        end
    end
end)
spawn(function()
    while wait() do 
        if _G.AutoFarm == true and _G.SelectMethod == 'Bone' and _G.AutoFarmMethod == 'Behide' then
            TelePBoss(CFrame.new(-9479.2168, 141.215088, 5566.09277, 0, 0, 1, 0, 1, -0, -1, 0, 0))
            pcall(function()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Reborn Skeleton [Lv. 1975]" or v.Name == "Living Zombie [Lv. 2000]" or v.Name == "Demonic Soul [Lv. 2025]" or v.Name == "Posessed Mummy [Lv. 2050]"  then
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                local CbFw = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2]
                                CbFw.activeController.hitboxMagnitude = 400
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                v.HumanoidRootPart.CanCollide = false
                                v.Humanoid.WalkSpeed = 0
                                v.Head.CanCollide = false 
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                StartMagnetBoneMon = true
                                PosMonBone = v.HumanoidRootPart.CFrame
                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(25,0,15))
                            until not  _G.AutoFarm == true or _G.SelectMethod ~= 'Bone' or not v.Parent or v.Humanoid.Health <= 0
                        end    
                    end
                end
            end)
        end
    end
end)

Farm1:AddDropdown('SelectStat', {
    Values = { 'Melee', 'Defense', 'Sword' , 'Blox Fruit' , 'Gun' },
    Default = nil, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected
    Text = 'Stats',
    Tooltip = 'This is a tooltip', -- Information shown when you hover over the textbox
}):OnChanged(function(Value) _G.SelectStat = Options.SelectStat.Value end)


Farm1:AddToggle('asasaas', {
    Text = 'Auto Stat',
    Default = false, -- Default value (true / false)
    Tooltip = 'Auto Stats', -- Information shown when you hover over the toggle
}):OnChanged(function(Value) _G.AutoStat = Toggles.asasaas.Value end)

Farm1:AddSlider('StatSelect', {
    Text = 'Stat Point',

    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 0,

    Compact = false, -- If set to true, then it will hide the label
}):OnChanged(function(Value) _G.PointStats = Options.StatSelect.Value end)



spawn(function()
	while wait() do
		if _G.AutoStat == true and _G.SelectStat == 'Melee' then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Melee",_G.PointStats)
		end
	end
end)
spawn(function()
	while wait() do
		if _G.AutoStat == true and _G.SelectStat == 'Defense' then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Defense",_G.PointStats)
		end
	end
end)
spawn(function()
	while wait() do
		if _G.AutoStat == true and _G.SelectStat == 'Sword' then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Sword",_G.PointStats)
		end
	end
end)
spawn(function()
	while wait() do
		if _G.AutoStat == true and _G.SelectStat == 'Blox Fruit' then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Devil Fruit",_G.PointStats)
		end
	end
end)
spawn(function()
	while wait() do
		if _G.AutoStat == true and _G.SelectStat == 'Gun' then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint","Gun",_G.PointStats)
		end
	end
end)



Farm2:AddDropdown('Selctmelee', {
    Values = { 'Fishman Karate', 'Black Leg', 'Electro' , 'Dragon Breathe', 'Godhuman' , 'Superhuman' , 'Fishman Karate', 'Dark Leg ', 'Electric Claw' , 'Dragon Talon'},
    Default = nil, 
    Multi = false, 
    Text = 'Melee Buy ',
    Tooltip = 'This is a tooltip',
}):OnChanged(function(Value) _G.SelectBuymelee = Options.Selctmelee.Value end)

Farm2:AddButton('Buy Melee', function()
    if _G.SelectBuymelee == 'Fishman Karate' then --1
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
    elseif _G.SelectBuymelee == 'Black Leg' then --2
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
    elseif _G.SelectBuymelee == 'Electro' then  --3
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
    elseif _G.SelectBuymelee == 'Dragon Breathe' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
    elseif _G.SelectBuymelee == 'Godhuman'then --5
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
    elseif _G.SelectBuymelee == 'Superhuman' then --6
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    elseif _G.SelectBuymelee == 'Sharkman Karate Karate' then--8
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    elseif _G.SelectBuymelee == 'Electric Claw' then--9
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
    elseif _G.SelectBuymelee == 'Dragon Talon' then--10
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
    end
end)

Farm2:AddToggle('AutoRandomBone', {
    Text = 'Auto Random Bone',
    Default = false,
    Tooltip = 'RandomBone', 
}):OnChanged(function(Value) _G.Auto_Random_Bone = Toggles.AutoRandomBone.Value end)


FruitList = {
    "Bomb-Bomb",
    "Spike-Spike",
    "Chop-Chop",
    "Spring-Spring",
    "Kilo-Kilo",
    "Spin-Spin",
    "Bird: Falcon",
    "Smoke-Smoke",
    "Flame-Flame",
    "Ice-Ice",
    "Sand-Sand",
    "Dark-Dark",
    "Revive-Revive",
    "Diamond-Diamond",
    "Light-Light",
    "Love-Love",
    "Rubber-Rubber",
    "Barrier-Barrier",
    "Magma-Magma",
    "Door-Door",
    "Quake-Quake",
    "Human-Human: Buddha",
    "String-String",
    "Bird-Bird: Phoenix",
    "Rumble-Rumble",
    "Paw-Paw",
    "Gravity-Gravity",
    "Dough-Dough",
    "Venom-Venom",
    "Shadow-Shadow",
    "Control-Control",
    "Soul-Soul",
    "Dragon-Dragon",
    "Leopard-Leopard",
}

Farm2:AddDropdown('SelectFruitSnipe', {
    Values = FruitList,
    Default = nil, 
    Multi = false, 
    Text = 'Auto Fruit Sniper',
    Tooltip = 'This is a tooltip',
}):OnChanged(function(Value) _G.SelectFruit = Options.SelectFruitSnipe.Value end)

Farm2:AddToggle('AutoBuySnipe', {
    Text = 'Auto  Buy Fruit Select',
    Default = false,
    Tooltip = 'Auto Buy Fruit Select', 
}):OnChanged(function(Value) _G.AutoBuyFruitSniper = Toggles.AutoBuySnipe.Value end)

spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.AutoBuyFruitSniper then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit",_G.SelectFruit)
            end 
        end
    end)
end)

Farm2:AddToggle('AutoRandomFruit', {
    Text = 'Auto Random Fruit',
    Default = false,
    Tooltip = 'RandomBone', 
}):OnChanged(function(Value) _G.AutoRandomFruit = Toggles.AutoRandomFruit.Value end)

spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.AutoRandomFruit then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
            end
        end
    end)
end)

Farm3:AddDropdown('ItemMethod', {
    Values = { 'Hallow Scythe' , 'Buddy Sword' , 'Elite Hunter' , 'Admin Boss' , 'Swan Glasses' , 'Saber' , 'Legendary Sword' , 'Enchancement Colour' ,'Musketeer Hat' , 'Rainbow Haki' , 'Rengoku' , 'Yama' },
    Default = nil, 
    Multi = false, 
    Text = 'Item Select',
    Tooltip = 'Select Item Type', 
}):OnChanged(function(Value) _G.ItemSelect = Options.ItemMethod.Value end)

Farm3:AddToggle('Autoitem', {
    Text = 'Auto Item',
    Default = false,
    Tooltip = 'Auto Select Item', 
}):OnChanged(function(Value) _G.Autoitem = Toggles.Autoitem.Value end)

spawn(function()
    while wait() do
        if _G.Autoitem == true and _G.ItemSelect == 'Buddy Sword' then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Cake Queen [Lv. 2175] [Boss]" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                    sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                until not _G.Autoitem ~= true or _G.ItemSelect ~=  'Buddy Sword' or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    end
                else
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen [Lv. 2175] [Boss]") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen [Lv. 2175] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                    else
                        if _G.AutoBudySwordHop then
                            Hop()
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do
        if _G.Autoitem == true and _G.ItemSelect == 'Elite Hunter' and World3 == true then
            pcall(function()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    repeat  wait()
                        topos(CFrame.new(-5418.892578125, 313.74130249023, -2826.2260742188)) 
                    until not _G.AutoElitehunter or (Vector3.new(-5418.892578125, 313.74130249023, -2826.2260742188)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3
                    if (Vector3.new(-5418.892578125, 313.74130249023, -2826.2260742188)-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    if string.find(QuestTitle,"Diablo") or string.find(QuestTitle,"Deandre") or string.find(QuestTitle,"Urban") then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Diablo [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre [Lv. 1750]") or game:GetService("Workspace").Enemies:FindFirstChild("Urban [Lv. 1750]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Diablo [Lv. 1750]" or v.Name == "Deandre [Lv. 1750]" or v.Name == "Urban [Lv. 1750]" then
                                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                        repeat task.wait()
                                            AutoHaki()
                                            EquipWeapon(_G.SelectWeapon)
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                            game:GetService("VirtualUser"):CaptureController()
                                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                            sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                        until _G.Autoitem ~= true or _G.ItemSelect ~= 'Elite Hunter' or v.Humanoid.Health <= 0 or not v.Parent
                                    end
                                end
                            end
                        else
                            if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo [Lv. 1750]") then
                                TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo [Lv. 1750]").HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                            elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre [Lv. 1750]") then
                                TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre [Lv. 1750]").HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                            elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban [Lv. 1750]") then
                                TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Urban [Lv. 1750]").HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                            else
                                if _G.AutoEliteHunterHop then
                                    Hop()
                                else
                                    TP1(CFrame.new(-5418.892578125, 313.74130249023, -2826.2260742188))
                                end
                            end
                        end                    
                    end
                end
            end)
        end
    end
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.Autoitem == true or _G.ItemSelect == 'Admin Boss' then
                if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form [Lv. 5000] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra [Lv. 5000] [Raid Boss]") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == ("rip_indra True Form [Lv. 5000] [Raid Boss]" or v.Name == "rip_indra [Lv. 5000] [Raid Boss]") and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            repeat task.wait()
                                pcall(function()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670),workspace.CurrentCamera.CFrame)
                                end)
                            until _G.Autoitem ~= true or _G.ItemSelect ~= 'Admin Boss' or v.Humanoid.Health <= 0
                        end
                    end
                else
                    TP1(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.Autoitem == true or _G.ItemSelect == 'Swan Glasses' then
                if game:GetService("Workspace").Enemies:FindFirstChild("Don Swan [Lv. 1000] [Boss]") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Don Swan [Lv. 1000] [Boss]" and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            repeat task.wait()
                                pcall(function()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                end)
                            until _G.Autoitem ~= true or _G.ItemSelect ~= 'Swan Glasses' or v.Humanoid.Health <= 0
                        end
                    end
                else 
                    repeat task.wait()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(2284.912109375, 15.537666320801, 905.48291015625)) 
                    until (CFrame.new(2284.912109375, 15.537666320801, 905.48291015625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 or _G.AutoFarmSwanGlasses == false
                end
            end
        end
    end)
end)

spawn(function()
    while wait() do
        if _G.Autoitem == true or _G.ItemSelect == 'Saber' then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert [Lv. 200] [Boss]") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Saber Expert [Lv. 200] [Boss]" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                PosMonSaber = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.CFrame = PosMonSaber
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                    sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                until not _G.Autoitem ~= true or _G.ItemSelect ~= 'Saber' or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    end
                else
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert [Lv. 200] [Boss]") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert [Lv. 200] [Boss]").HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                    else
                        if _G.AutoSaber_Hop then
                            Hop()
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do
        if _G.Autoitem == true or _G.ItemSelect == 'Legendary Sword' then
            pcall(function()
                local args = {
                    [1] = "LegendarySwordDealer",
                    [2] = "1"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                local args = {
                    [1] = "LegendarySwordDealer",
                    [2] = "2"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                local args = {
                    [1] = "LegendarySwordDealer",
                    [2] = "3"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                if _G.AutoBuyLegendarySword_Hop and _G.AutoBuyLegendarySword and World2 then
                    wait(10)
                    Hop()
                end
            end)
        end 
    end
end)

spawn(function()
    while wait() do
        if _G.Autoitem == true or _G.ItemSelect == 'Enchancement Colour' then
            local args = {
                [1] = "ColorsDealer",
                [2] = "2"
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            if _G.AutoBuyEnchancementColour_Hop and _G.AutoBuyEnchancementColour and not World1 then
                wait(10)
                Hop()
            end
        end 
    end
end)

spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.Autoitem == true or _G.ItemSelect == 'Musketeer Hat' then
                if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits == false then
                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Forest Pirate [Lv. 1825]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Forest Pirate [Lv. 1825]" then
                                    repeat task.wait()
                                        pcall(function()
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()
                                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                            v.HumanoidRootPart.CanCollide = false
                                            game:GetService'VirtualUser':CaptureController()
                                            game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            MusketeerHatMon = v.HumanoidRootPart.CFrame
                                            StartMagnetMusketeerhat = true
                                        end)
                                    until _G.Autoitem ~= true or _G.ItemSelect ~= 'Musketeer Hat' or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    StartMagnetMusketeerhat = false
                                end
                            end
                        else
                            StartMagnetMusketeerhat = false
                            TP1(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
                        end
                    else
                        topos(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                        if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest","CitizenQuest",1)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss == false then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Captain Elephant [Lv. 1875] [Boss]" then
                                    OldCFrameElephant = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        pcall(function()
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()
                                            v.HumanoidRootPart.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                            TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.HumanoidRootPart.CFrame = OldCFrameElephant
                                            game:GetService("VirtualUser"):CaptureController()
                                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                            sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                        end)
                                    until _G.Autoitem ~= true or _G.ItemSelect ~= 'Musketeer Hat' or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                end
                            end
                        else
                            TP1(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))
                        end
                    else
                        TP1(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))
                        if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen")
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 1800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress","Citizen") == 2 then
                    TP1(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.Autoitem == true or _G.ItemSelect == 'Rainbow Haki' then
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    TP1(CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875))
                    if (Vector3.new(-11892.0703125, 930.57672119141, -8760.1591796875) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                        wait(1.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan","Bet")
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Stone [Lv. 1550] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Stone [Lv. 1550] [Boss]" then
                                OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                until _G.Autoitem ~= true or _G.ItemSelect ~= 'Rainbow Haki' or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                            end
                        end
                    else
                        TP1(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Island Empress") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Island Empress [Lv. 1675] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Island Empress [Lv. 1675] [Boss]" then
                                OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                until  _G.Autoitem ~= true or _G.ItemSelect ~= 'Rainbow Haki' or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                            end
                        end
                    else
                        TP1(CFrame.new(5713.98877, 601.922974, 202.751251, -0.101080291, -0, -0.994878292, -0, 1, -0, 0.994878292, 0, -0.101080291))
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Kilo Admiral [Lv. 1750] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Kilo Admiral [Lv. 1750] [Boss]" then
                                OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                until _G.Autoitem ~= true or _G.ItemSelect ~= 'Rainbow Haki' or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                            end
                        end
                    else
                        TP1(CFrame.new(2877.61743, 423.558685, -7207.31006, -0.989591599, -0, -0.143904909, -0, 1.00000012, -0, 0.143904924, 0, -0.989591479))
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant [Lv. 1875] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Captain Elephant [Lv. 1875] [Boss]" then
                                OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                until _G.Autoitem ~= true or _G.ItemSelect ~= 'Rainbow Haki' or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                            end
                        end
                    else
                        TP1(CFrame.new(-13485.0283, 331.709259, -8012.4873, 0.714521289, 7.98849911e-08, 0.69961375, -1.02065748e-07, 1, -9.94383065e-09, -0.69961375, -6.43015241e-08, 0.714521289))
                    end
                elseif string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate [Lv. 1950] [Boss]") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Beautiful Pirate [Lv. 1950] [Boss]" then
                                OldCFrameRainbow = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    v.HumanoidRootPart.CFrame = OldCFrameRainbow
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                until _G.Autoitem ~= true or _G.ItemSelect ~= 'Rainbow Haki' or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                            end
                        end
                    else
                        TP1(CFrame.new(5312.3598632813, 20.141201019287, -10.158538818359))
                    end
                else
                    TP1(CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875))
                    if (Vector3.new(-11892.0703125, 930.57672119141, -8760.1591796875) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 30 then
                        wait(1.5)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("HornedMan","Bet")
                    end
                end
            end
        end
    end)
end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.Autoitem == true or _G.ItemSelect == 'Rengoku' then
                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
                    EquipWeapon("Hidden Key")
                    TP1(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
                elseif game:GetService("Workspace").Enemies:FindFirstChild("Snow Lurker [Lv. 1375]") or game:GetService("Workspace").Enemies:FindFirstChild("Arctic Warrior [Lv. 1350]") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if (v.Name == "Snow Lurker [Lv. 1375]" or v.Name == "Arctic Warrior [Lv. 1350]") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                AutoHaki()
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                RengokuMon = v.HumanoidRootPart.CFrame
                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,45,2))
                                game:GetService'VirtualUser':CaptureController()
                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                StartRengokuMagnet = true
                            until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") or _G.Autoitem ~= true or _G.ItemSelect ~= 'Rengoku'  or not v.Parent or v.Humanoid.Health <= 0
                            StartRengokuMagnet = false
                        end
                    end
                else
                    StartRengokuMagnet = false
                    TP1(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
                end
            end
        end
    end)
end)

spawn(function()
    while wait() do
        if _G.Autoitem == true or _G.ItemSelect == 'Yama' then
            if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress") >= 30 then
                repeat wait(.1)
                    fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
                until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not _G.AutoYama
            end
        end
    end
end)






spawn(function()
    while wait() do
        if _G.Autoitem == true and _G.ItemSelect == 'Hallow Scythe' then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if string.find(v.Name , "Soul Reaper") then
                            repeat task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                AutoHaki()
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                TP1(v.HumanoidRootPart.CFrame*CFrame.new(2,45,2))
                                v.HumanoidRootPart.Transparency = 1
                                sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                            until v.Humanoid.Health <= 0 or _G.AutoFarmBossHallow == false
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                    repeat TP1(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) wait() until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8                        
                    EquipWeapon("Hallow Essence")
                else
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper [Lv. 2100] [Raid Boss]").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                    end
                end
            end)
        end
    end
end)




















spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.Auto_Random_Bone == true then    
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","Buy",1,1)
            end
        end
    end)
end)

Farm3:AddDropdown('MSN', {
    Values = { 'Magma Ore'},
    Default = nil, 
    Multi = false, 
    Text = 'Material Select',
    Tooltip = 'Select Material', 
}):OnChanged(function(Value) _G.MaterialSelect = Options.MSN.Value end)

Farm3:AddToggle('AM', {
    Text = 'Auto Material',
    Default = false,
    Tooltip = 'Auto Select Material', 
}):OnChanged(function(Value) _G.MaterialFarm = Toggles.AM.Value end)

Farm3:AddDropdown('AbilSelect', {
    Values = { 'Geppo' , 'Buso Haki' ,'Soru', 'Ken Hake' , 'Tomeo Ring' , 'Black Cape' , 'SwordMan Hat' , 'Cutlass' , 'Katana' , 'Iron Mace' , 'Dual Katana' , 'Triple Katana' , 'Pipe' , 'Dual Headed Blade' , 'Bisento' , 'Soul Cane' },
    Default = nil, 
    Multi = false, 
    Text = 'Select Item',
    Tooltip = 'Select Item!', 
}):OnChanged(function(Value) _G.AbilSelec = Options.AbilSelect.Value end)

Farm3:AddButton('Buy Item Select', function()
    if _G.AbilSelec == 'Geppo' then --1
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
    elseif _G.AbilSelec == 'Buso Haki' then --2
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
    elseif _G.AbilSelec == 'Soru' then  --3
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
    elseif _G.AbilSelec == 'Ken Hake' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
    elseif _G.AbilSelec == 'Tomeo Ring' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Tomoe Ring")
    elseif _G.AbilSelec == 'Black Cape' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Black Cape")
    elseif _G.AbilSelec == 'SwordMan Hat' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat")
    elseif _G.AbilSelec == 'Cutlass' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
    elseif _G.AbilSelec == 'Katana' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Katana")
    elseif _G.AbilSelec == 'Iron Mace' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
    elseif _G.AbilSelec == 'Dual Katana' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")
    elseif _G.AbilSelec == 'Triple Katana' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
    elseif _G.AbilSelec == 'Pipe' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Pipe")
    elseif _G.AbilSelec == 'Dual Headed Blade' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
    elseif _G.AbilSelec == 'Bisento' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Bisento")
    elseif _G.AbilSelec == 'Soul Cane' then --4
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
    end
end)




spawn(function()
	while wait() do 
		if _G.MaterialFarm == true and _G.MaterialSelect == 'Magma Ore' then
            TP1(CFrame.new(-5363.01123, 41.5056877, 8548.47266, -0.578253984, -3.29503091e-10, 0.815856814, 9.11209668e-08, 1, 6.498761e-08, -0.815856814, 1.11920997e-07, -0.578253984))
			pcall(function()
				if game:GetService("Workspace").Enemies:FindFirstChild("Military Soldier [Lv. 300]") or game:GetService("Workspace").Enemies:FindFirstChild("Military Spy [Lv. 325]") or game:GetService("Workspace").Enemies:FindFirstChild("Magma Admiral [Lv. 350] [Boss]")  then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if v.Name == "Military Soldier [Lv. 300]" or v.Name == "Military Spy [Lv. 325]" or v.Name == "Magma Admiral [Lv. 350] [Boss]" then
							if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
								repeat task.wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									v.HumanoidRootPart.CanCollide = false
									v.Humanoid.WalkSpeed = 0
									v.Head.CanCollide = false 
									MagnetMagma = true
									PosMagma = v.HumanoidRootPart.CFrame
									TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(5,40,7))
								until not _G.MaterialFarm == false and _G.MaterialSelect ~= 'Magma Ore' or not v.Parent or v.Humanoid.Health <= 0
							end
						end
					end
				end
			end)
		end
	end
end)



local TeleportW = Tabs.Main:AddLeftTabbox() 
local Tele1 = TeleportW:AddTab('Island')
local Tele2 = TeleportW:AddTab('World')

if World1 == true then
    Tele1:AddDropdown('IslandSelect', {
        Values = { "WindMill",
        "Marine",
        "Middle Town",
        "Jungle",
        "Pirate Village",
        "Desert",
        "Snow Island",
        "MarineFord",
        "Colosseum",
        "Sky Island 1",
        "Sky Island 2",
        "Sky Island 3",
        "Prison",
        "Magma Village",
        "Under Water Island",
        "Fountain City",
        "Shank Room",
        "Mob Island" },
        Default = nil, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
        Text = 'Select ',
        Tooltip = 'World1', -- Information shown when you hover over the textbox
    }):OnChanged(function(Value) _G.SelectIsland = Options.IslandSelect.Value end)
end
if World2 == true then
    Tele1:AddDropdown('IslandSelect', {
        Values = { "The Cafe",
        "Frist Spot",
        "Dark Area",
        "Flamingo Mansion",
        "Flamingo Room",
        "Green Zone",
        "Factory",
        "Colossuim",
        "Zombie Island",
        "Two Snow Mountain",
        "Punk Hazard",
        "Cursed Ship",
        "Ice Castle",
        "Forgotten Island",
        "Ussop Island",
        "Mini Sky Island" },
        Default = nil, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
        Text = 'Select',
        Tooltip = 'World2', -- Information shown when you hover over the textbox
    }):OnChanged(function(Value) _G.SelectIsland = Options.IslandSelect.Value end)
end
if World3 == true then
    Tele1:AddDropdown('IslandSelect', {
        Values = { "Mansion",
        "Port Town",
        "Great Tree",
        "Castle On The Sea",
        "MiniSky", 
        "Hydra Island",
        "Floating Turtle",
        "Haunted Castle",
        "Ice Cream Island",
        "Peanut Island",
        "Cake Island" },
        Default = nil, -- number index of the value / string
        Multi = false, -- true / false, allows multiple choices to be selected
        Text = 'Select',
        Tooltip = 'World3', -- Information shown when you hover over the textbox
    }):OnChanged(function(Value) _G.SelectIsland = Options.IslandSelect.Value end)
end

Tele1:AddToggle('AVVVC', {
    Text = 'Teleport Island',
    Default = false, 
    Tooltip = 'Teleport To Island ',
}):OnChanged(function(Value) _G.TeleportIsland = Toggles.AVVVC.Value end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.TeleportIsland == true then
                repeat wait()
                    if _G.SelectIsland == "WindMill" then
                        TP1(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
                    elseif _G.SelectIsland == "Marine" then
                        TP1(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
                    elseif _G.SelectIsland == "Middle Town" then
                        TP1(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                    elseif _G.SelectIsland == "Jungle" then
                        TP1(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
                    elseif _G.SelectIsland == "Pirate Village" then
                        TP1(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
                    elseif _G.SelectIsland == "Desert" then
                        TP1(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
                    elseif _G.SelectIsland == "Snow Island" then
                        TP1(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469))
                    elseif _G.SelectIsland == "MarineFord" then
                        TP1(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
                    elseif _G.SelectIsland == "Colosseum" then
                        TP1( CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969))
                    elseif _G.SelectIsland == "Sky Island 1" then
                        TP1(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063))
                    elseif _G.SelectIsland == "Sky Island 2" then  
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
                    elseif _G.SelectIsland == "Sky Island 3" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
                    elseif _G.SelectIsland == "Prison" then
                        TP1( CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
                    elseif _G.SelectIsland == "Magma Village" then
                        TP1(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
                    elseif _G.SelectIsland == "Under Water Island" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                    elseif _G.SelectIsland == "Fountain City" then
                        TP1(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
                    elseif _G.SelectIsland == "Shank Room" then
                        TP1(CFrame.new(-1442.16553, 29.8788261, -28.3547478))
                    elseif _G.SelectIsland == "Mob Island" then
                        TP1(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
                    elseif _G.SelectIsland == "The Cafe" then
                        TP1(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
                    elseif _G.SelectIsland == "Frist Spot" then
                        TP1(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
                    elseif _G.SelectIsland == "Dark Area" then
                        TP1(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375))
                    elseif _G.SelectIsland == "Flamingo Mansion" then
                        TP1(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234))
                    elseif _G.SelectIsland == "Flamingo Room" then
                        TP1(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688))
                    elseif _G.SelectIsland == "Green Zone" then
                        TP1( CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344))
                    elseif _G.SelectIsland == "Factory" then
                        TP1(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617))
                    elseif _G.SelectIsland == "Colossuim" then
                        TP1( CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
                    elseif _G.SelectIsland == "Zombie Island" then
                        TP1(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094))
                    elseif _G.SelectIsland == "Two Snow Mountain" then
                        TP1(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938))
                    elseif _G.SelectIsland == "Punk Hazard" then
                        TP1(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125))
                    elseif _G.SelectIsland == "Cursed Ship" then
                        TP1(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
                    elseif _G.SelectIsland == "Ice Castle" then
                        TP1(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188))
                    elseif _G.SelectIsland == "Forgotten Island" then
                        TP1(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875))
                    elseif _G.SelectIsland == "Ussop Island" then
                        TP1(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
                    elseif _G.SelectIsland == "Mini Sky Island" then
                        TP1(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375))
                    elseif _G.SelectIsland == "Great Tree" then
                        TP1(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625))
                    elseif _G.SelectIsland == "Castle On The Sea" then
                        TP1(CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375))
                    elseif _G.SelectIsland == "MiniSky" then
                        TP1(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125))
                    elseif _G.SelectIsland == "Port Town" then
                        TP1(CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375))
                    elseif _G.SelectIsland == "Hydra Island" then
                        TP1(CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625))
                    elseif _G.SelectIsland == "Floating Turtle" then
                        TP1(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625))
                    elseif _G.SelectIsland == "Mansion" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
                    elseif _G.SelectIsland == "Haunted Castle" then
                        TP1(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562))
                    elseif _G.SelectIsland == "Ice Cream Island" then
                        TP1(CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625))
                    elseif _G.SelectIsland == "Peanut Island" then
                        TP1(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375))
                    elseif _G.SelectIsland == "Cake Island" then
                        TP1(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375))
                    end
                until not _G.TeleportIsland
            end
        end
    end)
end)




Tele2:AddButton("Teleport To Main World",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
end)

Tele2:AddButton("Teleport To Dressrosa Sea",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

Tele2:AddButton("Teleport To Zou Sea",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end)

local Raidw = Tabs.Main:AddRightTabbox() 
local Raid1 = Raidw:AddTab('Raid')
local Raid2 = Raidw:AddTab('Setting')



Raid1:AddDropdown('FIQ', {
    Values = { "Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix"},
    Default = nil, 
    Multi = false, 
    Text = 'Select Chip',
    Tooltip = 'Select Material', 
}):OnChanged(function(Value) _G.SelectChip = Options.FIQ.Value end)


Raid1:AddToggle('ABC', {
    Text = 'Auto Buy Chip',
    Default = false, 
    Tooltip = 'Buy Chip select ',
}):OnChanged(function(Value) _G.AutoBuyChip = Toggles.ABC.Value end)

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoBuyChip then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)
            end
        end
    end)
end)



Raid1:AddToggle('AutoAwake', {
    Text = 'Auto Awake',
    Default = false, 
    Tooltip = 'Awake',
}):OnChanged(function(Value) _G.Auto_Awakener = Toggles.AutoAwake.Value end)

spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.Auto_Awakener == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener","Check")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener","Awaken")
            end
        end
    end)
end)

Raid1:AddToggle('ASR', {
    Text = 'Auto Start Go To Raid',
    Default = false, 
    Tooltip = 'Awake',
}):OnChanged(function(Value) _G.Auto_StartRaid = Toggles.ASR.Value end)

spawn(function()
    while wait(.1) do
        pcall(function()
            if _G.Auto_StartRaid == true then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
                    if not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip") then
                        if World2  == true then
                            fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                        elseif World3 == true then
                            fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)

for i,v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
        pcall(function()
            repeat wait()
                sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                v.Humanoid.WalkSpeed = 0
                v.Humanoid.Health = 0
                v.HumanoidRootPart.CanCollide = false
            until not _G.Auto_Dungeon or not v.Parent or v.Humanoid.Health <= 0
        end)
    end
end

Raid1:AddToggle('AutoDG', {
    Text = 'Auto Dungeon',
    Default = false, 
    Tooltip = 'Auto Farm select Island',
}):OnChanged(function(Value) _G.Auto_Dungeon = Toggles.AutoDG.Value end)
spawn(function()
    pcall(function() 
        while wait() do
            if _G.Auto_Dungeon == true then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == true then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            pcall(function()
                                repeat wait()
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    v.Humanoid.WalkSpeed = 0
                                    v.Humanoid.Health = 0
                                    v.HumanoidRootPart.CanCollide = false
                                until not _G.Auto_Dungeon or not v.Parent or v.Humanoid.Health <= 0
                            end)
                        end
                    end
                end
            end
        end
    end)
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.Auto_Dungeon == true then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == true then
                    if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5") then
                        TP1(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 5").CFrame*CFrame.new(0,65,0))
                    elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4") then
                        TP1(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 4").CFrame*CFrame.new(0,65,0))
                    elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3") then
                        TP1(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 3").CFrame*CFrame.new(0,65,0))
                    elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2") then
                        TP1(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 2").CFrame*CFrame.new(0,65,0))
                    elseif game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") then
                        TP1(game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1").CFrame*CFrame.new(0,65,0))
                    end
                end
            end
        end
    end)
end)

Raid1:AddToggle('KAura', {
    Text = 'Kill Aura',
    Default = false, 
    Tooltip = 'Kill Aura',
}):OnChanged(function(Value) _G.Killaura = Toggles.KAura.Value end)


spawn(function()
    while wait() do
        if _G.Killaura  then
            for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                    pcall(function()
                        repeat wait(.1)
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                            v.Humanoid.Health = 0
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                            v.HumanoidRootPart.Transparency = 0.8
                        until not Killaura or not _G.AutoRaid or not RaidSuperhuman or not v.Parent or v.Humanoid.Health <= 0
                    end)
                end
            end
        end
    end
end)

local WWAZX = Tabs.Main:AddLeftTabbox() 

local WWAZX1 = WWAZX:AddTab('Mastery Farm')

local WWAZX3 = WWAZX:AddTab('Setting')


WWAZX1:AddToggle('AAAFM', {
    Text = 'Auto Fruit Mastery',
    Default = false, 
    Tooltip = 'Auto Farm Fruit Mastery',
}):OnChanged(function(Value) _G.AutoFarmFruitMastery = Toggles.AAAFM.Value end)

WWAZX1:AddToggle('AGMM', {
    Text = 'Auto Gun Mastery',
    Default = false, 
    Tooltip = 'Auto Farm Fruit Gun',
}):OnChanged(function(Value) _G.AutoFarmGunMastery = Toggles.AGMM.Value end)

WWAZX1:AddSlider('Slidu', {
    Text = 'Kill At Health %',

    Default = 25,
    Min = 1,
    Max = 100,
    Rounding = 1,

    Compact = true, -- If set to true, then it will hide the label
}):OnChanged(function(Value) _G.Kill_At = Options.Slidu.Value end)

WWAZX1:AddSlider('WaiKillColl', {
    Text = 'Kill Cooldown',

    Default = 1,
    Min = 1,
    Max = 25,
    Rounding = 0,

    Compact = true, -- If set to true, then it will hide the label
}):OnChanged(function(Value) _G.Wait123 = Options.WaiKillColl.Value end)


UseSkill = true

spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoFarmGunMastery == true then
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    Magnet = false                                      
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMasteryGunMagnet = false
                    CheckQuest()
                    TP1(CFrameQuest)
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                        wait(1.2)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        pcall(function()
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == Mon then
                                    repeat task.wait()
                                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                            HealthMin = v.Humanoid.MaxHealth * _G.Kill_At/100
                                            if v.Humanoid.Health <= HealthMin then                                                
                                                EquipWeapon(SelectWeaponGun)
                                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                                v.Humanoid.WalkSpeed = 0
                                                v.HumanoidRootPart.CanCollide = false
                                                v.HumanoidRootPart.Size = Vector3.new(2,2,1)
                                                v.Head.CanCollide = false                                                
                                                local args = {
                                                    [1] = v.HumanoidRootPart.Position,
                                                    [2] = v.HumanoidRootPart
                                                }
                                                game:GetService("Players").LocalPlayer.Character[SelectWeaponGun].RemoteFunctionShoot:InvokeServer(unpack(args))
                                            else
                                                AutoHaki()
                                                EquipWeapon(_G.SelectWeapon)
                                                v.Humanoid.WalkSpeed = 0
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Head.CanCollide = false               
                                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                TP1(v.HumanoidRootPart.CFrame * CFrame.new(2,30,2))
                                                game:GetService'VirtualUser':CaptureController()
                                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            end
                                            StartMasteryGunMagnet = true 
                                            PosMonMasteryGun = v.HumanoidRootPart.CFrame
                                        else
                                            StartMasteryGunMagnet = false
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    until v.Humanoid.Health <= 0 or _G.AutoFarmGunMastery == false or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    StartMasteryGunMagnet = false
                                end
                            end
                        end)
                    else
                        StartMasteryGunMagnet = false
                        local Mob = game:GetService("ReplicatedStorage"):FindFirstChild(Mon) 
                        if Mob then
                            TP1(Mob.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 1 then
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
                                task.wait()
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = false
                            end
                        end
                    end 
                end
            end
        end
    end)
end)
spawn(function()
    while wait() do
        if _G.AutoFarmFruitMastery == true then
            pcall(function()
                CheckQuest()
                local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                if not string.find(QuestTitle, NameMon) then
                    Magnet = false
                    UseSkill = false
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartMasteryFruitMagnet = false
                    UseSkill = false
                    CheckQuest()
                    repeat wait()
                        TP1(CFrameQuest)
                    until (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoFarmFruitMastery
                    if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 then
                        wait(1.2)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                        wait(0.5)
                    end
                elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    CheckQuest()
                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        HealthMs = v.Humanoid.MaxHealth * _G.Kill_At/100
                                        repeat task.wait()
                                            if v.Humanoid.Health <= HealthMs then
                                                AutoHaki()
                                                EquipWeapon(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value)
                                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                                v.HumanoidRootPart.CanCollide = false
                                                PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                                                v.Humanoid.WalkSpeed = 0
                                                v.Head.CanCollide = false
                                                UseSkill = true
                                            else           
                                                UseSkill = false 
                                                AutoHaki()
                                                EquipWeapon(_G.SelectWeapon)
                                                TPExpoNential(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                                v.HumanoidRootPart.CanCollide = false
                                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                                PosMonMasteryFruit = v.HumanoidRootPart.CFrame
                                                v.Humanoid.WalkSpeed = 0
                                                v.Head.CanCollide = false
                                            end
                                            StartMasteryFruitMagnet = true
                                            game:GetService'VirtualUser':CaptureController()
                                            game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                        until not _G.AutoFarmFruitMastery or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        UseSkill = false
                                        StartMasteryFruitMagnet = false
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        StartMasteryFruitMagnet = false   
                        UseSkill = false 
                        local Mob = game:GetService("ReplicatedStorage"):FindFirstChild(Mon) 
                        if Mob then
                            TP1(Mob.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 1 then
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true
                                task.wait()
                                game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = false
                            end
                        end
                    end
                end
            end)
        end
    end
end)


WWAZX3:AddToggle('SkillZ', {
    Text = 'Skill Z',
    Default = false, 
    Tooltip = 'Auto Use Skill Z',
}):OnChanged(function(Value) _G.SkillZ = Toggles.SkillZ.Value end)

WWAZX3:AddToggle('SkillX', {
    Text = 'Skill X',
    Default = false, 
    Tooltip = 'Auto Use Skill X',
}):OnChanged(function(Value) _G.SkillX = Toggles.SkillX.Value end)

WWAZX3:AddToggle('SkillC', {
    Text = 'Skill C',
    Default = false, 
    Tooltip = 'Auto Use Skill C',
}):OnChanged(function(Value) _G.SkillC = Toggles.SkillC.Value end)

WWAZX3:AddToggle('SkillV', {
    Text = 'Skill V',
    Default = false, 
    Tooltip = 'Auto Use Skill V',
}):OnChanged(function(Value) _G.SkillV = Toggles.SkillV.Value end)

spawn(function()
    while wait() do
        if UseSkill == true then
            pcall(function()
                CheckQuest()
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                        MasBF = game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].Level.Value
                    elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                        MasBF = game:GetService("Players").LocalPlayer.Backpack[game:GetService("Players").LocalPlayer.Data.DevilFruit.Value].Level.Value
                    end
                    if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon-Dragon") then                      
                        if _G.SkillZ == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                        
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                        end
                        if _G.SkillX  == true then      
                            wait(_G.Wait123)    
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))               
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                        end
                        if _G.SkillC == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                          
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                            wait(2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                        end
                    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Venom-Venom") then   
                        if _G.SkillZ == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                        
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                        end
                        if _G.SkillX == true then     
                            wait(_G.Wait123)   
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))               
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                        end
                        if _G.SkillC == true then 
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                          
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                            wait(2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                        end
                    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild("Human-Human: Buddha") then
                        if _G.SkillZ == true and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Size == Vector3.new(2, 2.0199999809265, 1) then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                         
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                        end
                        if _G.SkillX == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                        end
                        if _G.SkillC == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                        end
                        if _G.SkillV == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"V",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"V",false,game)
                        end
                    elseif game:GetService("Players").LocalPlayer.Character:FindFirstChild(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value) then
                        if _G.SkillZ == true then 
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                         
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"Z",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"Z",false,game)
                        end
                        if _G.SkillX == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"X",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"X",false,game)
                        end
                        if _G.SkillC == true then
                            wait(_G.Wait123)
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))                           
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"C",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"C",false,game)
                        end
                        if _G.SkillV == true then
                            
                            local args = {
                                [1] = PosMonMasteryFruit.Position
                            }
                            game:GetService("Players").LocalPlayer.Character[game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,"V",false,game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,"V",false,game)
                        end
                    end
                end
            end)
        end
    end
end)


local Cdoe1 = Tabs.Main:AddRightTabbox() 

local Code1 = Cdoe1:AddTab('Code')


local x2Code = {
    "3BVISITS",
    "UPD16",
    "FUDD10",
    "BIGNEWS",
    "THEGREATACE",
    "SUB2GAMERROBOT_EXP1",
    "StrawHatMaine",
    "Sub2OfficialNoobie",
    "SUB2NOOBMASTER123",
    "Sub2Daigrock",
    "Axiore",
    "TantaiGaming",
    "STRAWHATMAINE"
}

Code1:AddToggle('WWASD', {
    Text = 'Redeem Code At Level',
    Default = false, 
    Tooltip = 'Auto Use Skill V',
}):OnChanged(function(Value) _G.Redeem = Toggles.WWASD.Value end)

Code1:AddSlider('LVLSelect', {
    Text = 'Level Select',

    Default = 1,
    Min = 0,
    Max = 2400,
    Rounding = 0,

    Compact = false, -- If set to true, then it will hide the label
}):OnChanged(function(Value) _G.LVLSelect = Options.LVLSelect.Value end)

spawn(function()
	while wait() do
		if _G.Redeem == true and game:GetService("Players").LocalPlayer.Data.Level.Value >= _G.LVLSelect then
            function UseCode(Text)
                game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(Text)
            end
			UseCode("Sub2Fer999")
        UseCode("Enyu_is_Pro")
        UseCode("Magicbus")
        UseCode("JCWK")
    UseCode("Starcodeheo")
    UseCode("Bluxxy")
    UseCode("THEGREATACE")
    UseCode("SUB2GAMERROBOT_EXP1")
    UseCode("StrawHatMaine")
    UseCode("Sub2OfficialNoobie")
    UseCode("SUB2NOOBMASTER123")
    UseCode("Sub2Daigrock")
    UseCode("Axiore")
    UseCode("TantaiGaming")
    UseCode("STRAWHATMAINE")
		end
	end
end)

Code1:AddButton("Redeem All Codes",function()
    function UseCode(Text)
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(Text)
    end
    UseCode("Sub2Fer999")
    UseCode("Enyu_is_Pro")
    UseCode("Magicbus")
    UseCode("JCWK")
    UseCode("Starcodeheo")
    UseCode("Bluxxy")
    UseCode("THEGREATACE")
    UseCode("SUB2GAMERROBOT_EXP1")
    UseCode("StrawHatMaine")
    UseCode("Sub2OfficialNoobie")
    UseCode("SUB2NOOBMASTER123")
    UseCode("Sub2Daigrock")
    UseCode("Axiore")
    UseCode("TantaiGaming")
    UseCode("STRAWHATMAINE")
end)




















local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)


MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightControl', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu



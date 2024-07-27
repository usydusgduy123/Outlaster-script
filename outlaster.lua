-- bad syntax presented by me!
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Outlaster Script by d3cryptt!", "Ocean")

local IntroTab = Window:NewTab("Intro/Credits")
local IntroSection = IntroTab:NewSection("As of 7/25/24, Wave supports 70% of this scripts functions.")
local IntroSection = IntroTab:NewSection("Firing TouchInterests WILL crash your game.")
local IntroSection = IntroTab:NewSection("The buttons below will crash your game, if using Wave. ")
local IntroSection = IntroTab:NewSection("Beat to the Punch, Buoy Baskets, Eye on the Prize.")
local IntroSection = IntroTab:NewSection("Everything but most challenges should work 100% fine.")

-- Miscellaneous Section
local MiscellaneousTab = Window:NewTab("Miscellaneous")
local MiscellaneousSection = MiscellaneousTab:NewSection("Rejoin or execute the script again if anything breaks!")

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local isNoclip = false

-- Function to check if two players are friends
-- Mock implementation: players are friends if their IDs are both even or both odd
local function isPlayerFriended(player, otherPlayer)
    local success, result = pcall(function()
        return player:IsFriendsWith(otherPlayer.UserId)
    end)
    return success and result
end

-- Function to get a player's display name
local function getDisplayName(player)
    local character = workspace.Characters:FindFirstChild(player.Name)
    if character and character:FindFirstChild("Displaytag") and character.Displaytag:FindFirstChild("Display") then
        return character.Displaytag.Display.Text
    end
    return player.Name
end

-- Function to notify players about teamers
local function notifyTeamers(teamingPlayers)
    for _, group in ipairs(teamingPlayers) do
        local message = table.concat(group, ", ") .. " are teaming!"
        StarterGui:SetCore("SendNotification", {
            Title = "Teaming Alert",
            Text = message,
            Duration = 10
        })
    end
end

-- Function to check for teaming players
local function checkTeamingPlayers()
    local players = Players:GetPlayers()
    local seenPlayers = {}
    local teamingGroups = {}

    for _, player in ipairs(players) do
        if not seenPlayers[player.Name] then
            local teamingGroup = {}
            for _, otherPlayer in ipairs(players) do
                if player ~= otherPlayer and isPlayerFriended(player, otherPlayer) then
                    if not table.find(teamingGroup, getDisplayName(player)) then
                        table.insert(teamingGroup, getDisplayName(player))
                    end
                    if not table.find(teamingGroup, getDisplayName(otherPlayer)) then
                        table.insert(teamingGroup, getDisplayName(otherPlayer))
                    end
                    seenPlayers[player.Name] = true
                    seenPlayers[otherPlayer.Name] = true
                end
            end
            if #teamingGroup > 0 then
                table.insert(teamingGroups, teamingGroup)
            end
        end
    end

    if #teamingGroups > 0 then
        notifyTeamers(teamingGroups)
    end
end

-- Button to check for teamers
MiscellaneousSection:NewButton("Check for Teamers", "Checks for teamers in the server", function()
    checkTeamingPlayers()
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Connections storage
local HumanModCons = {}

-- Function to handle WalkSpeed change
local function WalkSpeedChange(speed)
    humanoid.WalkSpeed = speed
end

-- Function to handle JumpPower change
local function JumpPowerChange(power)
    humanoid.JumpPower = power
end

-- Slider for WalkSpeed
MiscellaneousSection:NewSlider("Walk Speed", "Adjusts your walk speed", 44, 16, function(value)
    local speed = value
    if isnumber(speed) then
        WalkSpeedChange(speed)
        HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            WalkSpeedChange(speed)
        end)
        HumanModCons.wsCA = (HumanModCons.wsCA and HumanModCons.wsCA:Disconnect() and false) or player.CharacterAdded:Connect(function(nChar)
            character, humanoid = nChar, nChar:WaitForChild("Humanoid")
            WalkSpeedChange(speed)
            HumanModCons.wsLoop = (HumanModCons.wsLoop and HumanModCons.wsLoop:Disconnect() and false) or humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                WalkSpeedChange(speed)
            end)
        end)
    end
end)

-- Slider for JumpPower
MiscellaneousSection:NewSlider("Jump Power", "Adjusts your jump power", 79, 50, function(value)
    local power = value
    if isnumber(power) then
        JumpPowerChange(power)
        HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            JumpPowerChange(power)
        end)
        HumanModCons.jpCA = (HumanModCons.jpCA and HumanModCons.jpCA:Disconnect() and false) or player.CharacterAdded:Connect(function(nChar)
            character, humanoid = nChar, nChar:WaitForChild("Humanoid")
            JumpPowerChange(power)
            HumanModCons.jpLoop = (HumanModCons.jpLoop and HumanModCons.jpLoop:Disconnect() and false) or humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                JumpPowerChange(power)
            end)
        end)
    end
end)

-- Cleanup function when the player leaves
Players.PlayerRemoving:Connect(function(removingPlayer)
    if removingPlayer == player then
        if HumanModCons.wsLoop then HumanModCons.wsLoop:Disconnect() end
        if HumanModCons.wsCA then HumanModCons.wsCA:Disconnect() end
        if HumanModCons.jpLoop then HumanModCons.jpLoop:Disconnect() end
        if HumanModCons.jpCA then HumanModCons.jpCA:Disconnect() end
    end
end)

-- Function to check if a value is a number
function isnumber(value)
    return type(value) == "number"
end





-- ESP Script
local function runESPScript()
    local player = game.Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local foldersToCheck = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}

    -- Function to create ESP
    local function createESP(part, distance)
        local esp = Instance.new("BillboardGui")
        esp.Name = "ESP"
        esp.Adornee = part
        esp.AlwaysOnTop = true

        -- Adjust the size of the ESP based on distance
        local scaleFactor = math.clamp(distance / 100, 0.5, 2)
        esp.Size = UDim2.new(0, 20 * scaleFactor, 0, 20 * scaleFactor)

        local frame = Instance.new("Frame", esp)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(1, 0, 0)
        frame.BackgroundTransparency = 0.5

        local textLabel = Instance.new("TextLabel", esp)
        textLabel.Size = UDim2.new(1, 0, 0.3, 0)
        textLabel.Position = UDim2.new(0, 0, -0.3, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = string.format("Distance: %.1f studs", distance)
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextScaled = true

        esp.Parent = part
    end

    -- Function to check for TouchInterest and add ESP
    local function checkAndAddESP()
        for _, folderName in ipairs(foldersToCheck) do
            local folder = workspace:FindFirstChild(folderName)
            if folder then
                for _, part in ipairs(folder:GetDescendants()) do
                    if part:IsA("BasePart") and part:FindFirstChild("TouchInterest") then
                        local distance = (part.Position - player.Character.HumanoidRootPart.Position).magnitude
                        if not part:FindFirstChild("ESP") then
                            createESP(part, distance)
                        else
                            local esp = part:FindFirstChild("ESP")
                            local textLabel = esp:FindFirstChildOfClass("TextLabel")
                            if textLabel then
                                textLabel.Text = string.format("Distance: %.1f studs", distance)
                            end
                        end
                    end
                end
            end
        end
    end

    -- Check and add ESP initially
    checkAndAddESP()

    -- Update ESP every 0.1 seconds
    while true do
        wait(0.1)
        checkAndAddESP()
    end
end

-- Button to run the ESP script in Miscellaneous section
MiscellaneousSection:NewButton("Hint/Idol ESP", "Activates the Hint ESP script", function()
    runESPScript()
end)


MiscellaneousSection:NewButton("Infinite Yield", "gives you admin commands", function()
 loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

local TeamTab = Window:NewTab("Team Challenges")
local TeamSection = TeamTab:NewSection("Some stuff might not work, use infinite yield for help!")




-- Button to toggle TouchInterest firing
TeamSection:NewButton("Flag it Down", "Fires TouchInterest every 0.5 seconds", function()
    -- Ensure to require necessary services and libraries
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Variables for TouchInterest firing
local flags = workspace["Flag It Down"].Map:GetChildren()
local isFiring = false

-- Function to fire TouchInterest
local function fireTouchInterest(part)
    if part:FindFirstChild("TouchInterest") then
        firetouchinterest(part, 0) -- Fire TouchInterest
        firetouchinterest(part, 1) -- Release TouchInterest
    end
end

-- Function to check tool and fire TouchInterest
local function checkToolAndFire()
    while isFiring do
        for _, item in ipairs(flags) do
            if item:IsA("BasePart") and item.Name == "Flag" then
                fireTouchInterest(item)

                -- Check if the player is holding a tool
                local char = workspace.Characters:FindFirstChild(Players.LocalPlayer.Name)
                if char and char:FindFirstChildOfClass("Tool") then
                    repeat
                        task.wait(0.1)
                    until not char:FindFirstChildOfClass("Tool")
                end
            end
        end
        task.wait(0.5)
    end
end
    isFiring = not isFiring
    if isFiring then
        task.spawn(checkToolAndFire)
        StarterGui:SetCore("SendNotification", {
            Title = "auto collect ON",
            Text = "Collecting!",
            Duration = 5
        })
        
    else
        StarterGui:SetCore("SendNotification", {
            Title = "auto collect, OFF",
            Text = "Not Collecting!",
            Duration = 5
        })
    end
end)


-- Function to fire TouchInterest
local function fireTouchInterests()
    local paths = {
        "workspace['Beat to the Punch'].Map.Tribe1.Platforms:GetChildren()[1].Finish.TouchInterest",
        "workspace['Beat to the Punch'].Map.Tribe2.Platforms:GetChildren()[2].Finish.TouchInterest",
        "workspace['Beat to the Punch'].Map.Tribe3.Platforms:GetChildren()[3].Finish.TouchInterest"
    }

    for _, path in ipairs(paths) do
        local touchInterest = loadstring("return " .. path)()
        if touchInterest then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, touchInterest.Parent, 0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, touchInterest.Parent, 1)
        end
    end
end

-- Toggle button to start/stop firing TouchInterest
_G.FiringTouchInterests = false
TeamSection:NewToggle("Beat To The Punch (auto win obby)", "Toggle auto firing TouchInterests", function(state)
    _G.FiringTouchInterests = state
    while _G.FiringTouchInterests do
        fireTouchInterests()
        wait(0.1)
    end
end)


-- Function to delete all parts in the given path
local function deletePartsInPath(path)
    local parts = path:GetChildren()
    for _, part in ipairs(parts) do
        part:Destroy()
    end
end




-- Button to delete parts in workspace["Order Ordeal"].Map.Curtains
TeamSection:NewButton("Order Ordeal (Delete Curtains)", "Deletes all parts in the Curtains folder", function()
    local path = workspace:FindFirstChild("Order Ordeal")
    if path then
        path = path:FindFirstChild("Map")
        if path then
            path = path:FindFirstChild("Curtains")
            if path then
                deletePartsInPath(path)
                print("All parts in the Curtains folder have been deleted.")
            else
                print("Curtains folder not found.")
            end
        else
            print("Map folder not found.")
        end
    else
        print("Order Ordeal folder not found.")
    end
end)

local tribes = {"Tribe2"}
local basketNames = {"Basket1", "Basket2", "Basket3", "Basket4", "Basket5", "Basket6", "Basket7", "Basket8", "Basket9", "Basket10"}

local function fireTouchInterest(part)
    firetouchinterest(Players.LocalPlayer.Character.HumanoidRootPart, part, 0)
    firetouchinterest(Players.LocalPlayer.Character.HumanoidRootPart, part, 1)
end

local function checkAndFireTouchInterests()
    while _G.FiringTouchInterests do
        for _, tribe in ipairs(tribes) do
            for _, basketName in ipairs(basketNames) do
                local path = workspace:FindFirstChild("Buoy Baskets")
                if path then
                    path = path:FindFirstChild("Map")
                    if path then
                        path = path:FindFirstChild(tribe)
                        if path then
                            path = path:FindFirstChild("Baskets")
                            if path then
                                path = path:FindFirstChild(basketName)
                                if path then
                                    path = path:FindFirstChild("Basket")
                                    if path then
                                        local inPart = path:FindFirstChild("In")
                                        if inPart and inPart:FindFirstChild("TouchInterest") then
                                            fireTouchInterest(inPart)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- Button to start/stop firing TouchInterests
_G.FiringTouchInterests = false
TeamSection:NewToggle("Buoy Baskets (auto win)", "Toggle firing TouchInterests in Buoy Baskets", function(state)
    _G.FiringTouchInterests = state
    if state then
        checkAndFireTouchInterests()
    end
end)




-- Solo Section
local SoloTab = Window:NewTab("Solo Challenges")
local SoloSection = SoloTab:NewSection("stuff for solo challenges")

-- Function to check for TouchInterest, fire one at random, and wait until no items are held
local function collectItems()
    local path = workspace:FindFirstChild("Eye on the Prize")
    if path then
        path = path:FindFirstChild("Map")
        if path then
            path = path:FindFirstChild("Collect")
            if path then
                while _G.Collecting do
                    local partsWithTouchInterest = {}
                    for _, part in ipairs(path:GetDescendants()) do
                        if part:IsA("BasePart") and part:FindFirstChild("TouchInterest") then
                            table.insert(partsWithTouchInterest, part)
                        end
                    end

                    if #partsWithTouchInterest > 0 then
                        local randomPart = partsWithTouchInterest[math.random(1, #partsWithTouchInterest)]
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, randomPart, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, randomPart, 1)

                        repeat
                            wait(0.1)
                        until not game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool") and not game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")

                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, randomPart, 0)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, randomPart, 1)
                    end

                    wait(1)
                end
            else
                print("Collect folder not found.")
            end
        else
            print("Map folder not found.")
        end
    else
        print("Eye on the Prize folder not found.")
    end
end

-- Toggle button to start/stop collecting items
_G.Collecting = false
SoloSection:NewToggle("Eye On The Prize (auto collect fruit)", "Toggle collecting items in Eye on the Prize", function(state)
    _G.Collecting = state
    if state then
        collectItems()
    end
end)


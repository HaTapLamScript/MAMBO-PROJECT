-- [MAMBO PROJECT] Anti Lag
if _G.MAMBO_ANTILAG_LOCKED then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "[MAMBO PROJECT]",
            Text = "Nah 😡 (Alr running)",
            Duration = 3
        })
    end)
    return
end
local ALLOWED_IDS = {10449761463, 131048399685555}
local valid = false
for _, id in ipairs(ALLOWED_IDS) do
    if game.PlaceId == id then valid = true; break end
end
if not valid then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "[MAMBO PROJECT]",
            Text = "Wrong game bro😭",
            Duration = 3
        })
    end)
    return
end
if not _G.MAMBO_ANTILAG_LOADED then
    _G.MAMBO_ANTILAG_LOADED = true
    local clk = os.clock
    local mround = math.round
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local StarterGui = game:GetService("StarterGui")
    local Stats = game:GetService("Stats")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    pcall(function() if makefolder then makefolder("MAMBO_PROJECT") end end)
    Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.Brightness = 1.5
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.OutdoorAmbient = Color3.new(0.8, 0.8, 0.8)
    Lighting.Ambient = Color3.new(0.6, 0.6, 0.6)
    for _, name in ipairs({"Atmosphere", "Clouds", "Sky"}) do
        local obj = Lighting:FindFirstChild(name) or Workspace:FindFirstChild(name)
        if obj then pcall(function() obj:Destroy() end) end
    end
    for _, v in ipairs(Workspace:GetChildren()) do
        if v.Name:lower():find("cloud") then pcall(function() v:Destroy() end) end
    end
    local WhitelistParts = {
        Ring = true, Debris2g = true, Projectile = true, TornadoMain = true,
        Spiral = true, MiddleSpin = true, MiddleSpinEmit = true
    }
    local WhitelistModels = {
        Flash = true, Slash_Teleport = true, ShurikenProj = true, TParticles2 = true,
        Proj = true, NadoSmoke = true, SmokeRing = true, Adjusted = true,
        General = true, Up = true, Up2 = true, Go2 = true, Dotted = true,
        Clone_Rig = true, Afterimage_Clone = true, Dragon = true, KingCrab = true,
        Model = true, preload = true,
        Trashcan = true,
        Weboom = true
    }
    local EffectClasses = {
        ParticleEmitter = true, Trail = true, Beam = true,
        Smoke = true, Fire = true, PointLight = true,
        SpotLight = true, SurfaceLight = true
    }
    local CRITICAL_SKILLS = {
        ["Sky Ripping Fist"] = true,
        SkyRippingFist = true,
        ["Fourfold Flashstrike"] = true,
        FourfoldFlashstrike = true
    }
    local criticalMode = false
    local criticalEnd = 0
    local queue = {}
    local qHead = 1
    local qTail = 0
    local QueueSet = {}
    local currentFps = 60
    local lastCleanupTime = 0
    local cleanupInterval = 3
    local function activateCriticalMode()
        criticalMode = true
        criticalEnd = clk() + 6
    end
    local function checkForCriticalSkill(obj)
        if not obj then return end
        if CRITICAL_SKILLS[obj.Name] then
            activateCriticalMode()
            return
        end
        for _, child in ipairs(obj:GetChildren()) do
            if CRITICAL_SKILLS[child.Name] then
                activateCriticalMode()
                return
            end
        end
    end
    Workspace.ChildAdded:Connect(checkForCriticalSkill)
    Workspace.DescendantAdded:Connect(checkForCriticalSkill)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if CRITICAL_SKILLS[obj.Name] then
            activateCriticalMode()
            break
        end
    end
    local function InstantDisable(child)
        if not child then return end
        local cClass = child.ClassName
        if EffectClasses[cClass] then
            pcall(function() child.Enabled = false end)
        elseif (cClass == "Part" or cClass == "MeshPart") and not WhitelistParts[child.Name] and not (child.Name == "Part" and child.Size == Vector3.new(4,4,4)) then
            pcall(function()
                child.Transparency = 1
                child.CastShadow = false
                child.CanCollide = false
            end)
        end
    end
    local function QueueGarbage(child)
        if not child or QueueSet[child] then return end
        QueueSet[child] = true
        InstantDisable(child)
        for _, v in ipairs(child:GetChildren()) do InstantDisable(v) end
        qTail = qTail + 1
        queue[qTail] = child
    end
    RunService.Heartbeat:Connect(function()
        if clk() >= criticalEnd then criticalMode = false end
        if qHead > qTail then qHead = 1; qTail = 0; return end
        if criticalMode then return end
        local startTime = clk()
        local timeLimit = 0.001
        if currentFps >= 50 then timeLimit = 0.003
        elseif currentFps >= 30 then timeLimit = 0.002 end
        local processed = 0
        while qHead <= qTail do
            local child = queue[qHead]
            queue[qHead] = nil
            qHead = qHead + 1
            if child then
                QueueSet[child] = nil
                if child.Parent then
                    local cClass = child.ClassName
                    if cClass == "Part" or cClass == "MeshPart" then
                        if not WhitelistParts[child.Name] and not (child.Name == "Part" and child.Size == Vector3.new(4,4,4)) then
                            pcall(function() child:Destroy() end)
                        end
                    elseif cClass == "Model" then
                        if not WhitelistModels[child.Name] then
                            pcall(function() child:Destroy() end)
                        end
                    elseif EffectClasses[cClass] then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
            processed = processed + 1
            if clk() - startTime >= timeLimit or processed >= 10 then break end
        end
    end)
    local Thing = Workspace:FindFirstChild("Thrown")
    if not Thing then
        Thing = Instance.new("Folder")
        Thing.Name = "Thrown"
        Thing.Parent = Workspace
    end
    for _, child in ipairs(Thing:GetChildren()) do QueueGarbage(child) end
    Thing.ChildAdded:Connect(QueueGarbage)
    task.spawn(function()
        while true do
            task.wait(cleanupInterval)
            if currentFps > 25 and not criticalMode then
                local now = clk()
                if now - lastCleanupTime >= cleanupInterval then
                    lastCleanupTime = now
                    pcall(function()
                        local items = Workspace:GetDescendants()
                        local count = 0
                        for i = 1, #items do
                            local v = items[i]
                            if v and EffectClasses[v.ClassName] then
                                pcall(function() v.Enabled = false; v:Destroy() end)
                            end
                            count = count + 1
                            if count % 200 == 0 then RunService.Heartbeat:Wait() end
                        end
                    end)
                end
            end
        end
    end)
    local oldFpsGui = CoreGui:FindFirstChild("MamboFPSDisplay")
    if oldFpsGui then oldFpsGui:Destroy() end
    local fpsGui = Instance.new("ScreenGui")
    fpsGui.Name = "MamboFPSDisplay"
    fpsGui.ResetOnSpawn = false
    fpsGui.DisplayOrder = 999
    fpsGui.IgnoreGuiInset = true
    fpsGui.Parent = CoreGui
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(0, 280, 0, 30)
    fpsLabel.Position = UDim2.new(0.5, -140, 0, 5)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.TextSize = 14
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.RichText = true
    fpsLabel.Text = "<i>FPS: 0  /  Ping: 0ms</i>"
    fpsLabel.Parent = fpsGui
    local fpsCounter = 0
    local lastFpsUpdate = clk()
    RunService.RenderStepped:Connect(function()
        fpsCounter = fpsCounter + 1
        local now = clk()
        if now - lastFpsUpdate >= 1 then
            currentFps = fpsCounter
            fpsCounter = 0
            lastFpsUpdate = now
            local ping = 0
            pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ping == 0 then pcall(function() ping = Stats.PerformanceStats.Ping:GetValue() end) end
            fpsLabel.Text = "<i>FPS: " .. tostring(currentFps) .. "  /  Ping: " .. tostring(mround(ping)) .. "ms</i>"
        end
    end)
    local logoImg = nil
    pcall(function()
        local folder = "MAMBO_PROJECT"
        local path = folder .. "/MAMBO_logo.png"
        if not isfolder(folder) then makefolder(folder) end
        if not isfile(path) then
            writefile(path, game:HttpGet("https://raw.githubusercontent.com/HaTapLamScript/MAMBO-PROJECT/main/Script/MAMBO_logo.png"))
        end
        if getcustomasset then
            logoImg = getcustomasset(path)
        end
    end)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "[MAMBO PROJECT]",
            Text = "Loading...",
            Duration = 2
        })
    end)
end
if not _G.MAMBO_FFLAGS_APPLIED then
    local CoreGui = game:GetService("CoreGui")
    local StarterGui = game:GetService("StarterGui")
    local logoImg = nil
    pcall(function()
        local folder = "MAMBO_PROJECT"
        local path = folder .. "/MAMBO_logo.png"
        if getcustomasset then logoImg = getcustomasset(path) end
    end)
    local oldDialog = CoreGui:FindFirstChild("MamboFFlagsDialog")
    if oldDialog then oldDialog:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MamboFFlagsDialog"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    local function applyCombatFFlags()
        if not (setfflag and getfflag) then return end
        local function setFlag(name, value)
            pcall(function()
                local cleanName = name:gsub("^DFInt", ""):gsub("^DFFlag", ""):gsub("^FFlag", ""):gsub("^FInt", "")
                if getfflag(cleanName) ~= nil then setfflag(cleanName, value)
                elseif getfflag(name) ~= nil then setfflag(name, value) end
            end)
        end
        local flags = {
            DFIntClientInputLatency = "0",
            DFIntClientInputBuffer = "0",
            DFIntClientInputPrediction = "100",
            DFIntClientPacketMaxDelayMs = "1",
            DFIntMaxWaitTimeBeforeForcePacketProcessMS = "1",
            DFIntClientPacketMinMicroseconds = "0",
            DFIntDataSenderRate = "99999",
            DFIntDataSenderMaxBandwidthBps = "2147483647",
            DFIntS2PhysicsSenderRate = "99999",
            DFIntPhysicsSenderMaxBandwidthBps = "2147483647",
            DFIntClientPhysicsSimulationRate = "1000",
            DFIntClientPhysicsTickRate = "240",
            DFFlagPhysicsSkipNonRealTimeHumanoidForceCalc2 = "True",
            DFIntTaskSchedulerTargetFps = "9999",
            FIntTaskSchedulerAutoThreadLimit = "8",
            DFFlagTextureQualityOverrideEnabled = "True",
            FIntDebugTextureManagerSkipMips = "7",
            DFIntDebugFRMQualityLevelOverride = "1",
            FIntRobloxGuiBlurIntensity = "0",
            FFlagRenderAllocateShadowMapResourcesOnDemand = "True",
            FFlagRenderGpuTextureCompressor = "True",
            DFFlagDisableDPIScale = "True",
            FFlagDebugGraphicsPreferD3D11 = "True"
        }
        task.spawn(function()
            for flag, value in pairs(flags) do setFlag(flag, value) end
            _G.MAMBO_FFLAGS_APPLIED = true
            _G.MAMBO_ANTILAG_LOCKED = true
        end)
    end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 140)
    frame.Position = UDim2.new(0.5, -170, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 150)
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -16, 0, 40)
    header.Position = UDim2.new(0, 8, 0, 8)
    header.BackgroundTransparency = 1
    header.Parent = frame
    if logoImg then
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 36, 0, 36)
        img.Position = UDim2.new(0, 0, 0.5, -18)
        img.BackgroundTransparency = 1
        img.Image = logoImg
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = header
    end
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -48, 1, 0)
    titleLabel.Position = UDim2.new(0, 44, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "[MAMBO PROJECT]"
    titleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    titleLabel.Font = Enum.Font.Code
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    local questionLabel = Instance.new("TextLabel")
    questionLabel.Size = UDim2.new(1, -16, 0, 30)
    questionLabel.Position = UDim2.new(0, 8, 0, 52)
    questionLabel.BackgroundTransparency = 1
    questionLabel.Text = "Apply fflags? (Universal)"
    questionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    questionLabel.Font = Enum.Font.Code
    questionLabel.TextSize = 16
    questionLabel.TextXAlignment = Enum.TextXAlignment.Center
    questionLabel.Parent = frame
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -20, 0, 32)
    btnFrame.Position = UDim2.new(0, 10, 0, 90)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = frame
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.45, 0, 1, 0)
    yesBtn.Position = UDim2.new(0, 0, 0, 0)
    yesBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
    yesBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    yesBtn.Text = "Yes"
    yesBtn.Font = Enum.Font.Code
    yesBtn.TextSize = 16
    yesBtn.BorderSizePixel = 0
    yesBtn.Parent = btnFrame
    local cornerY = Instance.new("UICorner")
    cornerY.CornerRadius = UDim.new(0, 6)
    cornerY.Parent = yesBtn
    local strokeY = Instance.new("UIStroke")
    strokeY.Color = Color3.fromRGB(0, 255, 0)
    strokeY.Thickness = 1.5
    strokeY.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    strokeY.Parent = yesBtn
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.45, 0, 1, 0)
    noBtn.Position = UDim2.new(0.55, 0, 0, 0)
    noBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
    noBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    noBtn.Text = "No"
    noBtn.Font = Enum.Font.Code
    noBtn.TextSize = 16
    noBtn.BorderSizePixel = 0
    noBtn.Parent = btnFrame
    local cornerN = Instance.new("UICorner")
    cornerN.CornerRadius = UDim.new(0, 6)
    cornerN.Parent = noBtn
    local strokeN = Instance.new("UIStroke")
    strokeN.Color = Color3.fromRGB(255, 0, 0)
    strokeN.Thickness = 1.5
    strokeN.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    strokeN.Parent = noBtn
    local answered = false
    local function finish(statusText, soundId)
        if answered then return end
        answered = true
        gui:Destroy()
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "[MAMBO PROJECT]",
                Text = statusText,
                Duration = 2
            })
        end)
        task.spawn(function()
            task.wait(0.5)
            pcall(function()
                local s = Instance.new("Sound")
                s.SoundId = soundId or "rbxassetid://119974879573475"
                s.Volume = 1
                s.Parent = CoreGui
                s:Play()
                task.delay(2, function() s:Destroy() end)
            end)
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "[MAMBO PROJECT]",
                    Text = "Done! :D",
                    Duration = 3
                })
            end)
        end)
    end
    yesBtn.MouseButton1Click:Connect(function()
        if answered then return end
        finish("Applying FFlags...")
        task.spawn(applyCombatFFlags)
    end)
    noBtn.MouseButton1Click:Connect(function()
        if answered then return end
        finish("Skipped FFlags.")
    end)
end 

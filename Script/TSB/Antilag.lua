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
    local mfloor = math.floor
    local mmax = math.max
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local StarterGui = game:GetService("StarterGui")
    local Stats = game:GetService("Stats")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local Debris = game:GetService("Debris")
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
    local V4Size = Vector3.new(4, 4, 4)

    local overloadFactor = 1.0
    local lastMode = 0
    local modeChangeCooldown = 0

    local function updateOverloadMode()
        local now = clk()
        if now - modeChangeCooldown < 1.5 then return end
        local newMode
        if currentFps >= 45 then
            newMode = 0
        elseif currentFps >= 25 then
            newMode = 1
        else
            newMode = 2
        end
        if newMode ~= lastMode then
            lastMode = newMode
            modeChangeCooldown = now
            if newMode == 0 then
                overloadFactor = 1.0
            elseif newMode == 1 then
                overloadFactor = 0.75
            else
                overloadFactor = 0.40
            end
        end
    end

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
        local kids = obj:GetChildren()
        for i = 1, #kids do
            if CRITICAL_SKILLS[kids[i].Name] then
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
        elseif (cClass == "Part" or cClass == "MeshPart") and not WhitelistParts[child.Name] and not (child.Name == "Part" and child.Size == V4Size) then
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
        local kids = child:GetChildren()
        for i = 1, #kids do InstantDisable(kids[i]) end
        qTail = qTail + 1
        queue[qTail] = child
    end
    RunService.Heartbeat:Connect(function()
        if clk() >= criticalEnd then criticalMode = false end
        updateOverloadMode()
        if qHead > qTail then qHead = 1; qTail = 0; return end
        if criticalMode then return end

        local startTime = clk()

        local baseLimit = 0.003375
        local baseCap = 20

        if currentFps >= 55 then
            baseLimit = 0.003375
            baseCap = 20
        elseif currentFps >= 40 then
            baseLimit = 0.00253125
            baseCap = 16
        elseif currentFps >= 25 then
            baseLimit = 0.0016875
            baseCap = 12
        else
            baseLimit = 0.00084375
            baseCap = 7
        end

        local timeLimit = baseLimit * overloadFactor
        local processedCap = mmax(3, mfloor(baseCap * overloadFactor))

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
                        if not WhitelistParts[child.Name] and not (child.Name == "Part" and child.Size == V4Size) then
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
            if clk() - startTime >= timeLimit or processed >= processedCap then break end
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
            task.wait(10)
            if currentFps > 40 and not criticalMode then
                pcall(function()
                    local items = Workspace:GetDescendants()
                    local count = 0
                    for i = 1, #items do
                        local v = items[i]
                        if v and EffectClasses[v.ClassName] then
                            pcall(function() v.Enabled = false; v:Destroy() end)
                        end
                        count = count + 1
                        if count % 300 == 0 then RunService.Heartbeat:Wait() end
                    end
                end)
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
    local perfStats = Stats.PerformanceStats
    local serverStats = Stats.Network.ServerStatsItem
    RunService.RenderStepped:Connect(function()
        fpsCounter = fpsCounter + 1
        local now = clk()
        if now - lastFpsUpdate >= 1 then
            currentFps = fpsCounter
            fpsCounter = 0
            lastFpsUpdate = now
            local ping = 0
            pcall(function() ping = serverStats["Data Ping"]:GetValue() end)
            if ping == 0 then pcall(function() ping = perfStats.Ping:GetValue() end) end
            fpsLabel.Text = "<i>FPS: " .. tostring(currentFps) .. "  /  Ping: " .. tostring(mround(ping)) .. "ms</i>"
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
    local RunService = game:GetService("RunService")
    local oldDialog = CoreGui:FindFirstChild("MamboFFlagsDialog")
    if oldDialog then oldDialog:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MamboFFlagsDialog"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local flagtables = {
        ["DFIntTaskSchedulerTargetFps"] = "9999",
        ["FIntTaskSchedulerAutoThreadLimit"] = "6",
        ["FIntTaskSchedulerAsyncTasksMinimumThreadCount"] = "2",
        ["FIntTaskSchedulerMaxNumOfJobs"] = "86",
        ["FIntTaskSchedulerThreadMin"] = "1",
        ["DFFlagBrowserTrackerIdTelemetryEnabled"] = "False",
        ["DFFlagPreloadAsyncSupportTexturePack"] = "True",
        ["DFFlagTextureQualityOverrideEnabled"] = "True",
        ["DFFlagVideoCaptureServiceEnabled"] = "False",
        ["DFFlagSampleAndRefreshRakPing"] = "True",
        ["DFFlagRakNetUseSlidingWindow4"] = "True",
        ["DFFlagCoreScriptTelemetry2"] = "False",
        ["DFFlagEnableSoundPreloading"] = "True",
        ["DFFlagOptimizePartsInPart"] = "True",
        ["DFFlagDisableDPIScale"] = "True",
        ["DFFlagDebugPerfMode"] = "True",
        ["DFIntRaknetBandwidthInfluxHundredthsPercentageV2"] = "10000",
        ["DFIntRakNetClockDriftAdjustmentPerPingMillisecond"] = "100",
        ["DFIntRaknetBandwidthPingSendEveryXSeconds"] = "1",
        ["DFIntRakNetNakResendDelayRttPercent"] = "50",
        ["DFIntRakNetNakResendDelayMsMax"] = "100",
        ["DFIntRakNetNakResendDelayMs"] = "10",
        ["DFIntRakNetResendRttMultiple"] = "1",
        ["DFIntRakNetSelectTimeoutMs"] = "1",
        ["DFIntRakNetLoopMs"] = "1",
        ["DFIntRakNetMinAckGrowthPercent"] = "0",
        ["DFIntRakNetMtuValue1InBytes"] = "1280",
        ["DFIntRakNetMtuValue2InBytes"] = "1240",
        ["DFIntRakNetMtuValue3InBytes"] = "1200",
        ["DFIntConnectionMTUSize"] = "1260",
        ["DFIntMaxReceiveToDeserializeLatencyMilliseconds"] = "15",
        ["DFIntNetworkInDeserializeLimitGameplayMsClient"] = "6",
        ["DFIntNetworkInProcessLimitGameplayMsClient"] = "6",
        ["DFIntClientPacketHealthyAllocationPercent"] = "20",
        ["DFIntClientPacketMaxFrameMicroseconds"] = "200",
        ["DFIntClientPacketExcessMicroseconds"] = "1000",
        ["DFIntClientPacketMinMicroseconds"] = "1",
        ["DFIntClientPacketMaxDelayMs"] = "11",
        ["DFIntMaxWaitTimeBeforeForcePacketProcessMS"] = "1.5",
        ["DFIntMaxProcessPacketsStepsPerCyclic"] = "5000",
        ["DFIntMaxProcessPacketsStepsAccumulated"] = "0",
        ["DFIntMaxProcessPacketsJobScaling"] = "10000",
        ["DFIntLargePacketQueueSizeCutoffMB"] = "1000",
        ["DFIntDataSenderRate"] = "1000",
        ["DFIntDataSenderMaxBandwidthBps"] = "2147483647",
        ["DFIntDataSenderMaxJoinBandwidthBps"] = "2147483647",
        ["DFIntS2PhysicsSenderRate"] = "1000",
        ["DFIntS2NumPhysicsPacketsPerStep"] = "100",
        ["DFIntPhysicsSenderMaxBandwidthBps"] = "2147483647",
        ["DFIntPhysicsSenderMaxBandwidthBpsScaling"] = "1000",
        ["FIntPGSAngularDampingPermilPersecond"] = "0",
        ["DFFlagPhysicsSkipNonRealTimeHumanoidForceCalc2"] = "True",
        ["DFIntSignalRHubConnectionHeartbeatTimerRateMs"] = "1000",
        ["DFIntSignalRHubConnectionBaseRetryTimeMs"] = "100",
        ["DFIntSignalRCoreKeepAlivePingPeriodMs"] = "250",
        ["DFIntSignalRCoreServerTimeoutMs"] = "11100",
        ["DFIntSignalRCoreTimerMs"] = "750",
        ["DFIntSignalRCoreRpcQueueSize"] = "256",
        ["DFIntAnimationLodFacsVisibilityDenominator"] = "0",
        ["DFIntAnimationLodFacsDistanceMin"] = "0",
        ["DFIntAnimationLodFacsDistanceMax"] = "0",
        ["DFIntDebugFRMQualityLevelOverride"] = "1",
        ["DFIntDebugDynamicRenderKiloPixels"] = "1100",
        ["DFIntDebugRestrictGCDistance"] = "1",
        ["DFIntWaitOnUpdateNetworkLoopEndedMS"] = "100",
        ["DFIntWaitOnRecvFromLoopEndedMS"] = "100",
        ["FIntRenderMaxShadowAtlasUsageBeforeDownscale"] = "80",
        ["FIntRenderShadowMapDepthCacheMemLimit"] = "192",
        ["FIntUITextureMaxRenderTextureSize"] = "1024",
        ["FIntRakNetResendBufferArrayLength"] = "128",
        ["FIntTerrainOTAMaxTextureSize"] = "1024",
        ["FIntOcclusionWorkerThreadCount"] = "5",
        ["FIntDefaultMeshCacheSizeMB"] = "256",
        ["FIntRobloxGuiBlurIntensity"] = "0",
        ["FIntTerrainArraySliceSize"] = "0",
        ["FIntDebugForceMSAASamples"] = "1",
        ["FIntRenderShadowmapBias"] = "0",
        ["FIntFRMMaxGrassDistance"] = "0",
        ["FIntFRMMinGrassDistance"] = "0",
        ["FIntGrassMovementReducedMotionFactor"] = "0",
        ["FIntDebugTextureManagerSkipMips"] = "7",
        ["FIntPerformanceTelemetryQueueProcessLimit"] = "0",
        ["FIntTelemetryProfilerFrequency"] = "0",
        ["FIntRenderLocalLightFadeInMs"] = "0",
        ["FIntReportDeviceInfoRollout"] = "0",
        ["FFlagRenderAllocateShadowMapResourcesOnDemand"] = "True",
        ["FFlagSpecifyNetworkReplicatorScopeForItems"] = "True",
        ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
        ["FFlagHandleAltEnterFullscreenManually"] = "False",
        ["FFlagGameBasicSettingsFramerateCap5"] = "False",
        ["FFlagSpecifyNetworkReplicatorScope"] = "True",
        ["FFlagSendRenderFidelityTelemetry2"] = "False",
        ["FFlagRenderGpuTextureCompressor"] = "True",
        ["FFlagBaseThreadPoolUseRuntime2"] = "True",
        ["FFlagCacheTextBoundsInGuiText"] = "True",
        ["FFlagEnableTelemetryService1"] = "False",
        ["FFlagDebugGraphicsPreferD3D11"] = "True",
        ["FFlagPerfDataOnTelemetryV2"] = "False",
        ["FFlagOpenTelemetryEnabled2"] = "False",
        ["FFlagRbxStorageUseMemCache"] = "True",
        ["FFlagDebugForceGenerateHSR"] = "True",
        ["FFlagRenderInitShadowmaps"] = "True",
        ["FFlagFastGPULightCulling3"] = "True",
        ["FFlagDebugSkyGray"] = "True",
        ["FFlagDebugRenderingSetDeterministic"] = "True",
        ["FLogNetwork"] = "7"
    }

    local function formatFlag(z)
        z = z:gsub("^DFInt", "")
        z = z:gsub("^DFFlag", "")
        z = z:gsub("^FFlag", "")
        z = z:gsub("^FInt", "")
        z = z:gsub("FString", "")
        z = z:gsub("FLog", "")
        return z
    end

    local function applyCombatFFlags()
        if not (setfflag and getfflag) then return end
        task.spawn(function()
            for k, v in pairs(flagtables) do
                for i = 1, 3 do RunService.RenderStepped:Wait() end
                pcall(function()
                    local formatted = formatFlag(k)
                    if getfflag(formatted) then
                        setfflag(formatted, v)
                    elseif getfflag(k) then
                        setfflag(k, v)
                    end
                end)
            end
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
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -48, 1, 0)
    titleLabel.Position = UDim2.new(0, 8, 0, 0)
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

--> Hi. This is opensourced. <--
if getgenv().GraphicsLevel then
    local removedTextures = {}
    local removedParticles = {}
    local disabledScripts = {}

    function setGraphicsQuality(level)
        if level == "potato" then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        elseif level == "low" then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level04
        elseif level == "mid" then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level06
        elseif level == "normal" then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end

    function applyGraphicsSettings(level)
        if level == "normal" then
            for _, texture in pairs(removedTextures) do
                texture.obj.Parent = texture.originalParent
            end
            removedTextures = {}

            for _, particle in pairs(removedParticles) do
                particle.obj.Parent = particle.originalParent
            end
            removedParticles = {}

            for _, script in pairs(disabledScripts) do
                script.Disabled = false
            end
            disabledScripts = {}
            return
        end

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") and level ~= "normal" then
                table.insert(removedTextures, {obj = obj, originalParent = obj.Parent})
                obj.Parent = nil
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then
                if level == "potato" then
                    table.insert(removedParticles, {obj = obj, originalParent = obj.Parent})
                    obj.Parent = nil
                end
            elseif obj:IsA("Script") or obj:IsA("LocalScript") then
                if (level == "low" or level == "potato") and not obj.Disabled then
                    table.insert(disabledScripts, obj)
                    obj.Disabled = true
                end
            end
        end
    end

    setGraphicsQuality(getgenv().GraphicsLevel)
    applyGraphicsSettings(getgenv().GraphicsLevel)
else
    print("No graphics level set.")
end
--// Example
-- Set the graphics level
--// getgenv().GraphicsLevel = "potato"  -- Options: "potato", "low", "mid", "normal"

--// Load and execute the external graphics and cleanup script
--// loadstring(game:HttpGet("https://raw.githubusercontent.com/John142-dot/graphicschanger/refs/heads/main/main.lua"))()

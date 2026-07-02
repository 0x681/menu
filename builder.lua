local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

Library.AccentColor = Color3.fromRGB(220, 50, 50)
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
if Library.UpdateColorsUsingRegistry then
    Library:UpdateColorsUsingRegistry()
end

local State   = getgenv().State
local players = game:GetService("Players")

local whitelist     = {}
local priority_list = {}

local function notify(msg)
    pcall(function() Library:Notify(msg, 3) end)
end

local Window = Library:CreateWindow({
    Title = "xenon  |  frontlines",
    Position = UDim2.fromOffset(175, 50),
    Size = UDim2.fromOffset(570, 620),
})

local Tabs = {
    ESP     = Window:AddTab("ESP"),
    Aim     = Window:AddTab("Aim"),
    Chams   = Window:AddTab("Chams"),
    Visuals = Window:AddTab("Visuals"),
    Exploits = Window:AddTab("Exploits"),
    Players = Window:AddTab("Players"),
    Config  = Window:AddTab("Config"),
}

do
    local LeftGB = Tabs.ESP:AddLeftGroupbox("Players")
    LeftGB:AddToggle("e_box",        { Text = "Box ESP",        Default = false }):OnChanged(function(v) State.flags.esp_box = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_name",       { Text = "Name",           Default = false }):OnChanged(function(v) State.flags.esp_name = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_dist",       { Text = "Distance",       Default = false }):OnChanged(function(v) State.flags.esp_distance = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_hp",         { Text = "Health Bar",     Default = false }):OnChanged(function(v) State.flags.esp_healthbar = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_item",       { Text = "Held Item",      Default = false }):OnChanged(function(v) State.flags.esp_held_item = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_team",       { Text = "Team Colors",    Default = false }):OnChanged(function(v) State.flags.esp_team_color = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_hidefriend", { Text = "Hide Teammates", Default = false }):OnChanged(function(v) State.flags.esp_hide_friendly = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("e_dead",       { Text = "Dead Check",     Default = false }):OnChanged(function(v) State.flags.esp_dead_check = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("e_deadrad",    { Text = "Dead Radius",    Default = 3,    Min = 1,   Max = 20,   Rounding = 0 }):OnChanged(function(v) State.flags.esp_dead_radius = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("e_maxdist",    { Text = "Max Distance",   Default = 2000, Min = 100, Max = 5000, Rounding = 0 }):OnChanged(function(v) State.flags.esp_max_distance = v; pcall(getgenv().Xenon_AimSync) end)

    local RightGB = Tabs.ESP:AddRightGroupbox("Colors")
    local ec_enemy = RightGB:AddToggle("ec_ecol_on",  { Text = "Enemy Color",    Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    ec_enemy:AddColorPicker("ec_enemy", { Default = State.colors.esp_enemy }):OnChanged(function(c) State.colors.esp_enemy = c end)

    local ec_friend = RightGB:AddToggle("ec_fcol_on", { Text = "Friendly Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    ec_friend:AddColorPicker("ec_friend", { Default = State.colors.esp_friendly }):OnChanged(function(c) State.colors.esp_friendly = c end)

    local ec_dist = RightGB:AddToggle("ec_dcol_on",   { Text = "Distance Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    ec_dist:AddColorPicker("ec_dist", { Default = State.colors.esp_distance }):OnChanged(function(c) State.colors.esp_distance = c end)

    local ec_dead = RightGB:AddToggle("ec_deadcol_on",{ Text = "Dead Color",     Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    ec_dead:AddColorPicker("ec_dead", { Default = State.colors.esp_dead }):OnChanged(function(c) State.colors.esp_dead = c end)

    local ec_hp = RightGB:AddToggle("ec_hpcol_on",    { Text = "Health Color",   Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    ec_hp:AddColorPicker("ec_hp", { Default = State.colors.esp_healthbar }):OnChanged(function(c) State.colors.esp_healthbar = c end)
end

do
    local LeftGB = Tabs.Aim:AddLeftGroupbox("Silent Aim")
    LeftGB:AddToggle("sa_on",     { Text = "Enabled",       Default = false }):OnChanged(function(v) State.flags.silent_aim_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("sa_fov",    { Text = "FOV",           Default = 180, Min = 1, Max = 360, Rounding = 0 }):OnChanged(function(v) State.flags.silent_aim_fov = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("sa_chance", { Text = "Hit Chance",    Default = 100, Min = 1, Max = 100, Rounding = 0 }):OnChanged(function(v) State.flags.silent_aim_hit_chance = v; pcall(getgenv().Xenon_AimSync) end)
    local fov_ring = LeftGB:AddToggle("sa_ring", { Text = "Show FOV Ring", Default = false }):OnChanged(function(v) State.flags.silent_aim_show_fov = v; pcall(getgenv().Xenon_AimSync) end)
    fov_ring:AddColorPicker("sa_ringcol", { Default = State.colors.fov_circle }):OnChanged(function(c) State.colors.fov_circle = c end)
    LeftGB:AddDropdown("sa_hitbox", { Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" }, Default = "Head", Text = "Hitbox" }):OnChanged(function(v) State.flags.silent_aim_hitbox = v; pcall(getgenv().Xenon_AimSync) end)

    local RightGB = Tabs.Aim:AddRightGroupbox("Combat")
    RightGB:AddToggle("ka_on",    { Text = "Kill Aura",   Default = false }):OnChanged(function(v) State.flags.kill_aura_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddSlider("ka_range", { Text = "Aura Range",  Default = 12, Min = 5, Max = 60, Rounding = 0 }):OnChanged(function(v) State.flags.kill_aura_range = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("as_on",    { Text = "Auto Shoot",  Default = false }):OnChanged(function(v) State.flags.auto_shoot_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("ar_on",    { Text = "Auto Reload", Default = false }):OnChanged(function(v) State.flags.auto_reload_enabled = v; pcall(getgenv().Xenon_AimSync) end)
end

do
    local LeftGB = Tabs.Chams:AddLeftGroupbox("Player Chams")
    LeftGB:AddToggle("pc_on",  { Text = "Enabled",  Default = false }):OnChanged(function(v) State.flags.chams = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddDropdown("pc_mat", { Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, Default = "Neon", Text = "Material" }):OnChanged(function(v) State.flags.chams_material = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("pc_rb",  { Text = "Rainbow",  Default = false }):OnChanged(function(v) State.flags.chams_rainbow = v; pcall(getgenv().Xenon_AimSync) end)
    local pc_ecol = LeftGB:AddToggle("pc_ecol_on", { Text = "Enemy Color",    Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    pc_ecol:AddColorPicker("pc_ecol", { Default = State.colors.chams_enemy }):OnChanged(function(c) State.colors.chams_enemy = c end)
    local pc_fcol = LeftGB:AddToggle("pc_fcol_on", { Text = "Friendly Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    pc_fcol:AddColorPicker("pc_fcol", { Default = State.colors.chams_friendly }):OnChanged(function(c) State.colors.chams_friendly = c end)

    local RightGB = Tabs.Chams:AddRightGroupbox("Viewmodel & Gun")
    RightGB:AddLabel("Viewmodel Chams")
    RightGB:AddToggle("vc_on",  { Text = "Enabled",  Default = false }):OnChanged(function(v) State.flags.viewmodel_chams = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddDropdown("vc_mat", { Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, Default = "Neon", Text = "Material" }):OnChanged(function(v) State.flags.viewmodel_chams_material = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("vc_rb",  { Text = "Rainbow",  Default = false }):OnChanged(function(v) State.flags.viewmodel_chams_rainbow = v; pcall(getgenv().Xenon_AimSync) end)
    local vc_col = RightGB:AddToggle("vc_col_on", { Text = "Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    vc_col:AddColorPicker("vc_col", { Default = State.colors.viewmodel_chams }):OnChanged(function(c) State.colors.viewmodel_chams = c end)

    RightGB:AddLabel("Gun Chams")
    RightGB:AddToggle("gc_on",  { Text = "Enabled",  Default = false }):OnChanged(function(v) State.flags.gun_material_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddDropdown("gc_mat", { Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, Default = "Neon", Text = "Material" }):OnChanged(function(v) State.flags.gun_material = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("gc_rb",  { Text = "Rainbow",  Default = false }):OnChanged(function(v) State.flags.gun_color_rainbow = v; pcall(getgenv().Xenon_AimSync) end)
    local gc_col = RightGB:AddToggle("gc_col_on", { Text = "Color Override", Default = false }):OnChanged(function(v) State.flags.gun_color_override = v; pcall(getgenv().Xenon_AimSync) end)
    gc_col:AddColorPicker("gc_col", { Default = State.colors.gun_color }):OnChanged(function(c) State.colors.gun_color = c end)
    local gc_out = RightGB:AddToggle("gc_out_on", { Text = "Outline", Default = false }):OnChanged(function(v) State.flags.gun_outline_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    gc_out:AddColorPicker("gc_out_col", { Default = State.colors.gun_outline_color }):OnChanged(function(c) State.colors.gun_outline_color = c end)
end

do
    local LeftGB = Tabs.Visuals:AddLeftGroupbox("World Chams")
    LeftGB:AddToggle("wc_on",   { Text = "Enabled",       Default = false }):OnChanged(function(v) State.flags.world_chams = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddDropdown("wc_mode", { Values = { "Fade", "Solid" }, Default = "Fade", Text = "Mode" }):OnChanged(function(v) State.flags.world_chams_mode = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("wc_range", { Text = "Range",        Default = 200, Min = 20, Max = 800, Rounding = 0 }):OnChanged(function(v) State.flags.world_chams_range = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("wc_tr",    { Text = "Transparency", Default = 60,  Min = 0,  Max = 95,  Rounding = 0 }):OnChanged(function(v) State.flags.world_chams_transparency = v / 100; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddDropdown("wc_mat", { Values = { "Glass", "Neon", "ForceField", "SmoothPlastic" }, Default = "Glass", Text = "Material" }):OnChanged(function(v) State.flags.world_chams_material = v; pcall(getgenv().Xenon_AimSync) end)
    local wc_col = LeftGB:AddToggle("wc_col_on", { Text = "Color Override", Default = false }):OnChanged(function(v) State.flags.world_chams_color_override = v; pcall(getgenv().Xenon_AimSync) end)
    wc_col:AddColorPicker("wc_col", { Default = State.colors.world_chams_color }):OnChanged(function(c) State.colors.world_chams_color = c end)

    local RightGB = Tabs.Visuals:AddRightGroupbox("Lighting")
    RightGB:AddToggle("w_nofog",  { Text = "No Fog",            Default = false }):OnChanged(function(v) State.flags.no_fog = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("w_bright", { Text = "Bright Lighting",   Default = false }):OnChanged(function(v) State.flags.bright_lighting = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("w_noatm",  { Text = "No Atmosphere",     Default = false }):OnChanged(function(v) State.flags.no_atmosphere = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("w_nodof",  { Text = "No Depth of Field", Default = false }):OnChanged(function(v) State.flags.no_depth_of_field = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("w_noblur", { Text = "No Damage Blur",    Default = false }):OnChanged(function(v) State.flags.no_damage_blur = v; pcall(getgenv().Xenon_AimSync) end)
    local nv = RightGB:AddToggle("w_nv", { Text = "Night Vision",  Default = false }):OnChanged(function(v) State.flags.night_vision = v; pcall(getgenv().Xenon_AimSync) end)
    nv:AddColorPicker("w_nvcol", { Default = State.colors.night_vision_tint }):OnChanged(function(c) State.colors.night_vision_tint = c end)
    local tv = RightGB:AddToggle("w_tv", { Text = "Thermal Vision", Default = false }):OnChanged(function(v) State.flags.thermal_vision = v; pcall(getgenv().Xenon_AimSync) end)
    tv:AddColorPicker("w_tvcol", { Default = State.colors.thermal_tint }):OnChanged(function(c) State.colors.thermal_tint = c end)
end

do
    local LeftGB = Tabs.Visuals:AddLeftGroupbox("Tracers")
    LeftGB:AddToggle("tr_on",  { Text = "Enabled",  Default = false }):OnChanged(function(v) State.flags.custom_tracers_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddDropdown("tr_mat", { Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, Default = "Neon", Text = "Material" }):OnChanged(function(v) State.flags.tracer_material = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("tr_rb",  { Text = "Rainbow",  Default = false }):OnChanged(function(v) State.flags.tracer_rainbow = v; pcall(getgenv().Xenon_AimSync) end)
    local tr_col = LeftGB:AddToggle("tr_col_on", { Text = "Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    tr_col:AddColorPicker("tr_col", { Default = State.colors.tracer_color }):OnChanged(function(c) State.colors.tracer_color = c end)

    local RightGB = Tabs.Visuals:AddRightGroupbox("Grenade Helper")
    RightGB:AddToggle("gh_on",     { Text = "Enabled",    Default = true  }):OnChanged(function(v) State.flags.grenade_helper_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddDropdown("gh_cmode", { Values = { "Solid", "Rainbow" }, Default = "Solid", Text = "Color Mode" }):OnChanged(function(v) State.flags.grenade_color_mode = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddDropdown("gh_line", { Values = { "Solid", "Dashed" }, Default = "Solid", Text = "Line Style" }):OnChanged(function(v) State.flags.grenade_line_style = v; pcall(getgenv().Xenon_AimSync) end)
    local gh_trail = RightGB:AddToggle("gh_tcol_on", { Text = "Trail Color",  Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    gh_trail:AddColorPicker("gh_tcol", { Default = State.colors.grenade_trail }):OnChanged(function(c) State.colors.grenade_trail = c end)
    local gh_impact = RightGB:AddToggle("gh_icol_on", { Text = "Impact Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    gh_impact:AddColorPicker("gh_icol", { Default = State.colors.grenade_impact }):OnChanged(function(c) State.colors.grenade_impact = c end)
end

do
    local LeftGB = Tabs.Exploits:AddLeftGroupbox("Weapon")
    LeftGB:AddToggle("wx_spread",  { Text = "No Spread",      Default = false }):OnChanged(function(v) State.flags.weapon_no_spread = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("wx_recoil",  { Text = "No Recoil",      Default = false }):OnChanged(function(v) State.flags.weapon_no_recoil = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("wx_sway",    { Text = "No Sway",        Default = false }):OnChanged(function(v) State.flags.weapon_no_sway = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("wx_ads",     { Text = "Instant ADS",    Default = false }):OnChanged(function(v) State.flags.weapon_instant_ads = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("wx_rf",      { Text = "Rapid Fire",     Default = false }):OnChanged(function(v) State.flags.weapon_rapid_fire = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("wx_rfmult",  { Text = "Fire Rate Mult", Default = 2, Min = 1, Max = 10, Rounding = 1 }):OnChanged(function(v) State.flags.weapon_rapid_fire_mult = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("wx_range",   { Text = "Extended Range", Default = false }):OnChanged(function(v) State.flags.weapon_extended_range = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddToggle("wx_melee",   { Text = "Extended Melee", Default = false }):OnChanged(function(v) State.flags.weapon_extended_melee_range = v; pcall(getgenv().Xenon_AimSync) end)
    LeftGB:AddSlider("wx_melmult", { Text = "Melee Mult",     Default = 3, Min = 1, Max = 10, Rounding = 1 }):OnChanged(function(v) State.flags.weapon_extended_melee_mult = v; pcall(getgenv().Xenon_AimSync) end)

    local RightGB = Tabs.Exploits:AddRightGroupbox("Hit Feedback")
    RightGB:AddToggle("hf_hit",   { Text = "Hit Sound",    Default = false }):OnChanged(function(v) State.flags.hit_sound_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddSlider("hf_hvol",  { Text = "Hit Volume",   Default = 1, Min = 0, Max = 2, Rounding = 2 }):OnChanged(function(v) State.flags.hit_sound_volume = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddToggle("hf_death", { Text = "Death Sound",  Default = false }):OnChanged(function(v) State.flags.death_sound_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    RightGB:AddSlider("hf_dvol",  { Text = "Death Volume", Default = 1, Min = 0, Max = 2, Rounding = 2 }):OnChanged(function(v) State.flags.death_sound_volume = v; pcall(getgenv().Xenon_AimSync) end)
    local hf_fx = RightGB:AddToggle("hf_fx", { Text = "Hit Effect", Default = false }):OnChanged(function(v) State.flags.hit_effect_enabled = v; pcall(getgenv().Xenon_AimSync) end)
    hf_fx:AddColorPicker("hf_fxcol", { Default = State.colors.hit_effect }):OnChanged(function(c) State.colors.hit_effect = c end)
end

do
    local LeftGB = Tabs.Players:AddLeftGroupbox("Playerlist")
    LeftGB:AddLabel("Select a player from the game")

    local RightGB = Tabs.Players:AddRightGroupbox("Actions")
    RightGB:AddInput("pl_name", { Text = "Player Name", Default = "" })

    RightGB:AddButton({
        Text = "Whitelist Toggle",
        Func = function()
            local pl_name = Library.Flags.pl_name
            if not pl_name or pl_name == "" then notify("Enter player name") return end
            whitelist[pl_name] = not whitelist[pl_name]
            notify((whitelist[pl_name] and "Whitelisted: " or "Unwhitelisted: ") .. pl_name)
        end,
    })

    RightGB:AddButton({
        Text = "Priority Toggle",
        Func = function()
            local pl_name = Library.Flags.pl_name
            if not pl_name or pl_name == "" then notify("Enter player name") return end
            priority_list[pl_name] = not priority_list[pl_name]
            notify((priority_list[pl_name] and "Priority set: " or "Priority removed: ") .. pl_name)
        end,
    })

    RightGB:AddButton({
        Text = "Teleport To",
        Func = function()
            local pl_name = Library.Flags.pl_name
            if not pl_name or pl_name == "" then notify("Enter player name") return end
            local self_char = players.LocalPlayer.Character
            local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
            if not root then notify("No character") return end
            for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
                if inst.Name == "soldier_model" and inst:GetAttribute("Xenon_owner_name") == pl_name then
                    local hrp = inst:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        root.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                        notify("Teleported to " .. pl_name)
                        return
                    end
                end
            end
            notify("Could not find " .. pl_name)
        end,
    })

    RightGB:AddButton({
        Text = "Kill",
        Func = function()
            local pl_name = Library.Flags.pl_name
            if not pl_name or pl_name == "" then notify("Enter player name") return end
            local self_char = players.LocalPlayer.Character
            local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
            if not root then notify("No character") return end
            for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
                if inst.Name == "soldier_model" and inst:GetAttribute("Xenon_owner_name") == pl_name then
                    local hrp = inst:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        root.CFrame = hrp.CFrame * CFrame.new(0, 1, 2)
                        local prev = State.flags.auto_shoot_enabled
                        State.flags.auto_shoot_enabled = true
                        pcall(getgenv().Xenon_AimSync)
                        task.delay(1.5, function()
                            State.flags.auto_shoot_enabled = prev
                            pcall(getgenv().Xenon_AimSync)
                        end)
                        notify("Killing " .. pl_name)
                        return
                    end
                end
            end
            notify("Could not find " .. pl_name)
        end,
    })

    getgenv().Xenon_whitelist = whitelist
    getgenv().Xenon_priority  = priority_list
end

do
    local LeftGB = Tabs.Config:AddLeftGroupbox("Configurations")
    LeftGB:AddInput("cfg_name", { Text = "Config Name", Default = "" })

    local cfg_dir = "xenon/configs"
    pcall(function() if not isfolder(cfg_dir) then makefolder(cfg_dir) end end)

    LeftGB:AddButton({
        Text = "Create",
        Func = function()
            local cfg_name = Library.Flags.cfg_name
            if not cfg_name or cfg_name == "" then notify("Enter a config name") return end
            pcall(function() if not isfolder(cfg_dir) then makefolder(cfg_dir) end end)
            Library:AttemptSave()
            notify("Created: " .. cfg_name)
        end,
    })

    LeftGB:AddButton({
        Text = "Save",
        Func = function()
            local cfg_name = Library.Flags.cfg_name
            if not cfg_name or cfg_name == "" then notify("Enter config name to save") return end
            Library:AttemptSave()
            notify("Saved: " .. cfg_name)
        end,
    })

    LeftGB:AddButton({
        Text = "Load",
        Func = function()
            local cfg_name = Library.Flags.cfg_name
            if not cfg_name or cfg_name == "" then notify("Enter config name to load") return end
            pcall(function() Library:LoadConfig(cfg_name) end)
            notify("Loaded: " .. cfg_name)
        end,
    })

    LeftGB:AddButton({
        Text = "Delete",
        Func = function()
            local cfg_name = Library.Flags.cfg_name
            if not cfg_name or cfg_name == "" then notify("Enter config name to delete") return end
            pcall(delfile, cfg_dir .. "/" .. cfg_name .. ".cfg")
            notify("Deleted: " .. cfg_name)
        end,
    })

    local RightGB = Tabs.Config:AddRightGroupbox("Interface")
    local cp = RightGB:AddToggle("ui_accent", { Text = "Accent Color", Default = false }):OnChanged(function(v) pcall(getgenv().Xenon_AimSync) end)
    cp:AddColorPicker("accent_picker", { Default = Color3.fromRGB(220, 50, 50) }):OnChanged(function(c)
        Library.AccentColor = c
        Library.AccentColorDark = Library:GetDarkerColor(c)
        if Library.UpdateColorsUsingRegistry then
            Library:UpdateColorsUsingRegistry()
        end
    end)

    RightGB:AddButton({
        Text = "Unload",
        Func = function()
            notify("Unloading xenon...")
            task.delay(0.5, function()
                pcall(getgenv().run_all_cleanup)
                pcall(getgenv().Xenon_AimStop)
            end)
        end,
    })
end

task.defer(function()
    State.flags.grenade_helper_enabled = true
    pcall(getgenv().Xenon_AimSync)
end)

Library:Init()
